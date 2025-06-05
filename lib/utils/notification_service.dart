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

  ///*
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

  ///*
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

  ///*
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


  ///*
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

  ///*
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
