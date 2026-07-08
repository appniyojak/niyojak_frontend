import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart' show openAppSettings;

import '../helpers/static_data.dart' as Statics;
import '../screens/shaakhaa_milan_module/shaakha_main_tab_screen.dart';

/// -----------------------------------------------------------------------
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('[PushNotification] Background message: ${message.messageId}');
}

/// Central service responsible for:
/// - Requesting notification permissions (Android 13+/iOS)
/// - Creating notification channels
/// - Displaying foreground notifications (with optional image)
/// - Routing the user to the correct screen when a notification is tapped,
///   based on the `action` key inside [RemoteMessage.data].
class PushNotificationService with WidgetsBindingObserver {
  PushNotificationService._internal();

  static final PushNotificationService instance = PushNotificationService._internal();

  /// Provide this from your app so the service can navigate without a
  /// BuildContext (e.g. `MaterialApp(navigatorKey: PushNotificationService.instance.navigatorKey)`).
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'important_notifications',
    'Niyojak',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
    showBadge: true,
  );

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  int _notificationId = 0;
  bool _initialized = false;

  /// True when _pendingRouteData came from a cold (terminated) launch —
  /// meaning startup data (Statics.userDetails etc.) may not be loaded yet.
  bool _isColdStartRoute = false;

  /// Route we couldn't dispatch yet because the Navigator wasn't attached
  /// (typically: app launched cold via a notification tap).
  Map<String, dynamic>? _pendingRouteData;
  int _pendingRouteRetries = 0;
  static const int _maxPendingRouteRetries = 15;

  /// True once we've shown/queued a "notifications are off" prompt this
  /// session, so we don't nag the user on every screen rebuild.
  bool _permissionPromptShown = false;

  /// Simple bounded dedupe guard against FCM redelivering the same message.
  final Set<String> _seenMessageIds = <String>{};
  static const int _maxSeenMessageIds = 100;

  /// Exposed so the app (e.g. a settings screen) can react to permission
  /// changes reactively without polling the service directly.
  final ValueNotifier<AuthorizationStatus?> permissionStatus = ValueNotifier(null);

  /// Call once, after `Firebase.initializeApp()` has already run in `main()`.
  Future<void> init() async {
    if (_initialized) return;

    WidgetsBinding.instance.addObserver(this);

    await _setupLocalNotifications();
    await _requestPermissions();
    // _listenTokenRefresh();
    _registerMessageHandlers();
    await _handleTerminatedLaunchMessage();

    _initialized = true;
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    permissionStatus.dispose();
    _initialized = false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Covers the "app was backgrounded, user granted permission in system
    // settings, then resumed the app" and "navigator became attached after
    // we tried to route" scenarios.
    if (state == AppLifecycleState.resumed) {
      _retryPendingRoute();
      _refreshPermissionStatus();
    }
  }

  // ---------------------------------------------------------------------
  // Setup
  // ---------------------------------------------------------------------

  Future<void> _setupLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false, // handled via FirebaseMessaging.requestPermission
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _localNotifications.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: _onDidReceiveBackgroundNotificationResponseStatic,
    );

    await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(_channel);

    // Foreground presentation is controlled per-platform inside
    // _showForegroundNotification to avoid duplicate banners on iOS.
  }

  Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    permissionStatus.value = settings.authorizationStatus;
    debugPrint('[PushNotification] Authorization status: ${settings.authorizationStatus}');

    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        break;
      case AuthorizationStatus.provisional:
        // iOS "quiet" delivery: notifications land in Notification Center
        // silently, no banner/sound/badge until the user upgrades access.
        // Nothing to prompt for here — this is a valid, user-chosen state.
        break;
      case AuthorizationStatus.denied:
      case AuthorizationStatus.notDetermined:
        _promptEnableNotifications();
        break;
    }

    // Android 13+ (API 33) needs a *separate* runtime permission request —
    // FirebaseMessaging.requestPermission() alone does not trigger the
    // Android system dialog.
    if (Platform.isAndroid) {
      final granted = await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

      if (granted == false) {
        _promptEnableNotifications();
      }
    }
  }

  Future<void> _refreshPermissionStatus() async {
    final settings = await _messaging.getNotificationSettings();
    permissionStatus.value = settings.authorizationStatus;
  }

  /// Shows an in-app rationale dialog with a direct link to system settings.
  /// We deliberately do NOT re-trigger the native OS permission dialog here
  /// — both platforms only show that once per install; after a denial, the
  /// only way back is the Settings app, so that's what we drive the user to.
  void _promptEnableNotifications() {
    if (_permissionPromptShown) return;

    final context = navigatorKey.currentContext;
    if (context == null) {
      // Navigator not attached yet (e.g. called during cold-start init
      // before MaterialApp built) — retry after the first frame.
      WidgetsBinding.instance.addPostFrameCallback((_) => _promptEnableNotifications());
      return;
    }

    _permissionPromptShown = true;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(Statics.getLabel("notificationDialogTitle")),
        content: Text(Statics.getLabel("notificationDialogSubtitle")),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(Statics.getLabel("notNow")),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              openAppSettings();
            },
            child: Text(Statics.getLabel("openSettings")),
          ),
        ],
      ),
    );
  }

  /// Current device token — send this to your backend right after login
  /// (and again whenever it rotates, see [_listenTokenRefresh]).
  Future<String?> getToken() => _messaging.getToken();

  void _listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((token) {
      debugPrint('[PushNotification] Token refreshed: $token');
      // TODO: send the new token to your backend, replacing the old one.
      // await api.updateFcmToken(token);
    });
  }

  void _registerMessageHandlers() {
    // App in foreground.
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);

    // App in background, user taps the notification.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _routeFromData(message.data);
    });
  }

  /// App was fully terminated and opened via a notification tap.
  Future<void> _handleTerminatedLaunchMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      // Do NOT route now — app was launched cold, SplashScreenCheck hasn't
      // finished its data loading yet (login state, Statics.userDetails,
      // etc.). Stash it; SplashScreenCheck.switchScreens() will call
      // dispatchAfterStartup() once startup is actually done.
      _pendingRouteData = initialMessage.data;
      _isColdStartRoute = true;
      debugPrint('[PushNotification] Cold start via notification, deferring route: ${initialMessage.data}');
    }
  }

  // ---------------------------------------------------------------------
  // Foreground display
  // ---------------------------------------------------------------------

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    // FCM can redeliver the same message (e.g. flaky connectivity retries).
    final messageId = message.messageId;
    if (messageId != null) {
      if (_seenMessageIds.contains(messageId)) {
        debugPrint('[PushNotification] Duplicate message ignored: $messageId');
        return;
      }
      _seenMessageIds.add(messageId);
      if (_seenMessageIds.length > _maxSeenMessageIds) {
        _seenMessageIds.remove(_seenMessageIds.first);
      }
    }

    debugPrint('[PushNotification] Foreground message: ${message.toMap()}');
    debugPrint('[PushNotification] Foreground message data: ${message.data}');
    debugPrint('[PushNotification] Foreground message notification: ${message.notification?.toMap()}');

    if (Platform.isIOS) {
      // Let iOS show its native banner; skip the local-notification duplicate.
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      return;
    }

    final imageUrl = message.data['image'];
    final bigPicture = (imageUrl != null && imageUrl.toString().isNotEmpty) ? await _downloadAsAndroidBitmap(imageUrl.toString()) : null;

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      largeIcon: bigPicture,
      styleInformation: bigPicture != null ? BigPictureStyleInformation(bigPicture, largeIcon: bigPicture) : null,
    );

    await _localNotifications.show(
      _notificationId++,
      notification.title,
      notification.body,
      NotificationDetails(android: androidDetails),
      payload: jsonEncode(message.data),
    );
  }

  Future<ByteArrayAndroidBitmap?> _downloadAsAndroidBitmap(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;
      return ByteArrayAndroidBitmap(response.bodyBytes);
    } catch (e) {
      debugPrint('[PushNotification] Failed to download image: $e');
      return null;
    }
  }

  // ---------------------------------------------------------------------
  // Tap handling -> payload parsing
  // ---------------------------------------------------------------------

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;

    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      _routeFromData(data);
    } catch (e) {
      debugPrint('[PushNotification] Failed to parse payload: $e');
    }
  }

  /// Must be a top-level or static function (isolate entry point requirement).
  @pragma('vm:entry-point')
  static void _onDidReceiveBackgroundNotificationResponseStatic(NotificationResponse response) {
    debugPrint('[PushNotification] Background tap payload: ${response.payload}');
    // Avoid navigation here directly; the app is likely not attached to a
    // Navigator yet. Persist the payload (e.g. SharedPreferences) if you
    // need to act on it once the app resumes, or rely on getInitialMessage().
  }

  // ---------------------------------------------------------------------
  // ⭐ MAIN ROUTING HINT ⭐
  // ---------------------------------------------------------------------
  //
  // This is the single place that decides "where does the user go" based
  // on the `action` key sent from your backend. Add one case per screen.
  //
  // Data payload you're currently receiving looks like:
  //   { "action": "ShakhaaVrutta", "action_id": "0", ... }
  //
  // Keep this method dumb (no business logic) — it should only decide the
  // route + arguments, then hand off to Navigator. Fetch/validate data
  // inside the destination screen itself.
  // ---------------------------------------------------------------------
  void _routeFromData(Map<String, dynamic> data) {
    final action = data['action']?.toString();
    if (action == null || action.isEmpty) {
      debugPrint('[PushNotification] No action key in payload, ignoring.');
      return;
    }

    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      // Common on cold start: FCM delivers the launch message before
      // MaterialApp/Navigator has mounted. Queue it and retry on the next
      // frame instead of dropping it — this is the "app was killed, user
      // tapped the notification" scenario and it must not be lost.
      _pendingRouteData = data;
      _pendingRouteRetries = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) => _retryPendingRoute());
      return;
    }

    _dispatchRoute(navigator, action, data);
  }

  void _retryPendingRoute() {
    final data = _pendingRouteData;
    if (data == null) return;

    final navigator = navigatorKey.currentState;
    if (navigator != null) {
      _pendingRouteData = null;
      _pendingRouteRetries = 0;
      _dispatchRoute(navigator, data['action']?.toString() ?? '', data);
      return;
    }

    _pendingRouteRetries++;
    if (_pendingRouteRetries >= _maxPendingRouteRetries) {
      // Give up after ~15 frames (or app-resume events) rather than
      // retrying forever if the app never builds a Navigator.
      debugPrint('[PushNotification] Giving up on pending route after $_pendingRouteRetries attempts.');
      _pendingRouteData = null;
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _retryPendingRoute());
  }

  void _dispatchRoute(NavigatorState navigator, String action, Map<String, dynamic> data) {
    switch (action) {
      case 'ShakhaaVrutta':
        navigator.pushNamed(ShaakhaMainTabScreen.routeName); //, arguments: data);
        debugPrint('[PushNotification] Route -> ShakhaaVrutta with data: $data');
        break;

      case 'subscription':
        // navigator.pushNamed('/subscription', arguments: data);
        debugPrint('[PushNotification] Route -> Subscription with data: $data');
        break;

      // Add further cases here as new `action` values are introduced,

      default:
        debugPrint('[PushNotification] Unhandled action "$action".');
    }
  }

  /// Called by SplashScreenCheck once it has finished loading startup data
  /// and decided the normal [landingPage]. Navigates to landingPage, then —
  /// only if a cold-start notification is pending — pushes the notification's
  /// target route on top, now that the app actually has data to show.
  void dispatchAfterStartup(BuildContext context, Widget landingPage) {
    final data = _pendingRouteData;
    final isCold = _isColdStartRoute;
    _pendingRouteData = null;
    _isColdStartRoute = false;

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => landingPage));

    if (isCold && data != null) {
      final action = data['action']?.toString() ?? '';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final navigator = navigatorKey.currentState;
        if (navigator != null) {
          _dispatchRoute(navigator, action, data);
        }
      });
    }
  }
}

/*
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PushNotificationService {
  static final PushNotificationService _notificationService = PushNotificationService._internal();

  factory PushNotificationService() {
    return _notificationService;
  }

  PushNotificationService._internal();

  late FirebaseMessaging _messaging;
  int id = 0;

  // PushNotification _notificationInfo;
  bool _initialized = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    setupFlutterNotifications();
    if (!_initialized) {
      registerNotification();
      // registerLocalNotification(message);
      _initialized = true;
    }
  }

  late AndroidNotificationChannel channel;

  Future<void> setupFlutterNotifications() async {
    channel = const AndroidNotificationChannel(
        'important_notifications', // id
        'Niyojak', // title
        // groupId: 'Niyojak Chats',
        description: 'This channel is used for important notifications.', // description
        importance: Importance.high,
        playSound: true,
        showBadge: true);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // await flutterLocalNotificationsPlugin.cancelAll();
  }

  ///
  ///
  ///
  Future<void> registerLocalNotification(RemoteMessage message) async {
    AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        defaultPresentBanner: true,
        defaultPresentBadge: true,
        defaultPresentAlert: true
      // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
          selectNotification(notificationResponse.payload);
        });
  }

  ///
  ///
  ///
  Future<void> showNotification(RemoteMessage message, String channelId) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      'Niyojak',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
    );

    if (message.data.isNotEmpty) {
      if (message.data['image'].toString() != '' && message.data['image'] != null) {
        try {
          var image = await http.get(Uri.parse(message.data['image'].toString()));
          androidPlatformChannelSpecifics = AndroidNotificationDetails(
            channelId,
            'Niyojak',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker',
            playSound: true,
            largeIcon: ByteArrayAndroidBitmap.fromBase64String(base64Encode(image.bodyBytes)),
            // styleInformation: BigPictureStyleInformation(ByteArrayAndroidBitmap.fromBase64String(base64Encode(image.bodyBytes)),
            //     largeIcon: ByteArrayAndroidBitmap.fromBase64String(base64Encode(image.bodyBytes)))
          );
        } catch (e) {
          androidPlatformChannelSpecifics = AndroidNotificationDetails(
            channelId,
            'Niyojak',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker',
            playSound: true,
          );
        }
      }
    }

    DarwinNotificationDetails iosPlatformChannelSpecifics = DarwinNotificationDetails(presentAlert: false, presentBadge: false, presentSound: false);
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosPlatformChannelSpecifics);
    if (message.notification != null) {
      await flutterLocalNotificationsPlugin.show(
          id++, message.notification!.title.toString(), message.notification!.body.toString(), platformChannelSpecifics,
          payload: jsonEncode(message.data));
    }
  }

  ///
  ///
  ///
  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        if (message.notification != null) {
          log("message _Data: " + message.data.toString());
          debugPrint('Message body: ${message.notification?.body}, data: ${message.data}');
          debugPrint(">>>>${message.notification!.title}>>>>${message.notification!.body}");
        }

        if (Platform.isAndroid) {
          await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
        } else {
          await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
            alert: false,
            badge: false,
            sound: false,
          );
        }
        registerLocalNotification(message);
        showNotification(message, 'important_notifications');
      });

      tapNotificationAppBackground();
      tapNotificationAppKilled();
    } else {
      debugPrint('User declined');
    }
  }

  @override
  void dispose() {
    _initialized = false;
  }


  ///
  ///
  /// tap notification when app foreground
  Future selectNotification(String? payload) async {
    debugPrint('LocalNotification Payload : ${payload.toString()}');
    if (payload != null) {
      var data = jsonDecode(payload);
      if(data['action'] == 'subscription') {
        // Get.to(() =>SubscriptionPage(routeName: Get.currentRoute));
      }
    }
  }

  ///
  ///
  ///
  void tapNotificationAppKilled() {
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        // Get.offAll(() => BottomNavBarScreen());
      }
    });
  }

  void tapNotificationAppBackground() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.notification != null) {
        // Get.offAll(() => BottomNavBarScreen());
      }
    });
  }
}
*/
