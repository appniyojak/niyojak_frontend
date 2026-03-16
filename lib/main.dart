import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:niyojak_prod/providers/sankalp_screen_provider.dart';
import 'package:niyojak_prod/screens/AbhiyaanSwayamsevak.dart';
import 'package:niyojak_prod/screens/AbhiyanAddSwayamsevak.dart';
import 'package:niyojak_prod/screens/AbhiyanEditSwayamsevak.dart';
import 'package:niyojak_prod/screens/AbhiyanScreen.dart';
import 'package:niyojak_prod/screens/AbhiyanViewSwayamsevak.dart';
import 'package:niyojak_prod/screens/AddEditVisheshVyaktiScreen.dart';
import 'package:niyojak_prod/screens/AddGruhaSamparkScreen.dart';
import 'package:niyojak_prod/screens/ContactUsScreen.dart';
import 'package:niyojak_prod/screens/VisheshVyaktShodhScreen.dart';
import 'package:niyojak_prod/screens/create_notification.dart';
import 'package:niyojak_prod/screens/edit_swayamsevak_daayitva.dart';
import 'package:niyojak_prod/screens/edit_swayamsevak_other_info.dart';
import 'package:niyojak_prod/screens/edit_swayamsevak_soochi.dart';
import 'package:niyojak_prod/screens/edit_vishesh_vyakti_shod.dart';
import 'package:niyojak_prod/screens/levels_update_module/levels_manage_tabs.dart';
import 'package:niyojak_prod/screens/levels_update_module/update_master_data.dart';
import 'package:niyojak_prod/screens/nirikshan_baithak_vrutta.dart';
import 'package:niyojak_prod/screens/sankalit_data_name.dart';
import 'package:niyojak_prod/screens/search_sankalp_screen.dart';
import 'package:niyojak_prod/screens/shatabdi_vrutta_sankalan/vijayadashami/add_mukhya_atithi_form.dart';
import 'package:niyojak_prod/screens/shatabdi_vrutta_sankalan/vijayadashami/add_vishesh_vyakti.dart';
import 'package:niyojak_prod/screens/shatabdi_vrutta_sankalan/vijayadashami/vijaya_dashami_report.dart';
import 'package:niyojak_prod/screens/survey_screen/mandal_reports_tabs.dart';
import 'package:niyojak_prod/screens/survey_screen/report_view/vasti_report_tab1.dart';
import 'package:niyojak_prod/screens/survey_screen/report_view/vasti_report_tab2.dart';
import 'package:niyojak_prod/screens/survey_screen/survey_form/mandal_survey_form_view.dart';
import 'package:niyojak_prod/screens/survey_screen/survey_form/vasti_survey_form_view.dart';
import 'package:niyojak_prod/screens/survey_screen/vasti_reports_tabs.dart';
import 'package:niyojak_prod/screens/view_vishesh_vyakti_shodh.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './screens/annual_baithak_ekatrit_vrutta.dart';
import './screens/change_password.dart';
import './screens/edit_daayitva.dart';
import './screens/edit_event.dart';
import './screens/edit_join_rss.dart';
import './screens/edit_sewa_vasti.dart';
import './screens/edit_shaakhaa.dart';
import './screens/edit_shaakhaa_vrutta.dart';
import './screens/edit_soochi.dart';
import './screens/edit_swayamsevak_basic_info.dart';
import './screens/edit_swayamsevak_screen.dart';
import './screens/edit_swayamsevak_transfer.dart';
import './screens/event_calender.dart';
import './screens/event_members.dart';
import './screens/event_vrutta.dart';
import './screens/help_screen.dart';
import './screens/home_screen.dart';
import './screens/login_screen.dart';
import './screens/maps_display.dart';
import './screens/profile_settings.dart';
import './screens/search_annual_baithak_vrutta.dart';
import './screens/search_event.dart';
import './screens/search_join_rss.dart';
import './screens/search_rjb_nidhi_sankalan.dart';
import './screens/search_shaakhaa.dart';
import './screens/search_soochi_screen.dart';
import './screens/search_swayamsevak_transfer.dart';
import './screens/sewa_vasti_list.dart';
import './screens/shaakhaa_sewa_vasti_link.dart';
import './screens/shaakhaa_toli.dart';
import './screens/shaakhaa_vrutta.dart';
import './screens/soochi_members.dart';
import './screens/soochi_sharing.dart';
import './screens/splash_screen.dart';
import './screens/swayamsevak_daayitva_edit.dart';
import './screens/swayamsevak_search.dart';
import './widgets/shaakhaa_pat.dart';
import 'firebase_options.dart';
import 'helpers/static_data.dart' as Statics;
import 'providers/sadbhav_provider.dart';
import 'screens/forget_password.dart';
import 'screens/shatabdi_vrutta_sankalan/gruh_sampark_abhiyaan/add_abhiyaan_karyakarta_screen.dart';
import 'screens/shatabdi_vrutta_sankalan/gruh_sampark_abhiyaan/add_abhiyaan_pramukh.dart';
import 'screens/shatabdi_vrutta_sankalan/gruh_sampark_abhiyaan/gruh_abhiyaan_main_tab_screen.dart';
import 'screens/shatabdi_vrutta_sankalan/hindu_sanmelan/hindu_sanmelan_form.dart';
import 'screens/shatabdi_vrutta_sankalan/hindu_sanmelan/hindu_sanmelan_main_tab.dart';
import 'screens/shatabdi_vrutta_sankalan/hindu_sanmelan/hindu_sanmelan_report.dart';
import 'screens/shatabdi_vrutta_sankalan/hindu_sanmelan/search_sajjan_anya_screen.dart';
import 'screens/shatabdi_vrutta_sankalan/pramukh_jansanvad/add_sajjan_anya_pramukh_jan_screen.dart';
import 'screens/shatabdi_vrutta_sankalan/pramukh_jansanvad/all_sanvaad_screen.dart';
import 'screens/shatabdi_vrutta_sankalan/pramukh_jansanvad/karyakram_creation_screen.dart';
import 'screens/shatabdi_vrutta_sankalan/pramukh_jansanvad/pramukh_jan_main_tab.dart';
import 'screens/shatabdi_vrutta_sankalan/sadbhav_baithak/add_present_mahanubhav_screen.dart';
import 'screens/shatabdi_vrutta_sankalan/sadbhav_baithak/sadbhav_baithak_main_tab.dart';
import 'screens/shatabdi_vrutta_sankalan/sadbhav_baithak/sadbhav_center_creation_screen.dart';
import 'screens/shatabdi_vrutta_sankalan/sadbhav_baithak/sadbhav_centers_list_screen.dart';
import 'screens/shatabdi_vrutta_sankalan/sadbhav_baithak/sadbhav_search_vrutta.dart';
import 'screens/shatabdi_vrutta_sankalan/vijayadashami/vijayadashami_form_view.dart';
import 'screens/survey_screen/vasti_sarvekshan_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(name: "niyojak-cdd79", options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(NiyojakApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(name: "niyojak-cdd79", options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message: ${message.messageId}');
}

class NiyojakApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NiyojakAppState();
}

class NiyojakAppState extends State<NiyojakApp> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    setupFirebaseMessaging();
  }

  Future<void> initPlatformState() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      print("Firebase initialized successfully");
    } catch (e) {
      print("Error initializing Firebase: $e");
    }

    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE,
      ),
      (String taskId) async {
        print("Background Event: $taskId at ${DateTime.now()}");
        BackgroundFetch.finish(taskId);
      },
    ).then((int status) {
      print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
    });
  }

  Future<void> setupFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else {
      print("User declined or has not granted permission");
    }

    try {
      String? token;

      if (Platform.isAndroid) {
        token = await messaging.getToken();
      } else if (Platform.isIOS) {
        token = await messaging.getAPNSToken();
      }

      if (token != null) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("deviceToken", token);
        print("Device Token (${Platform.operatingSystem}): $token");
      } else {
        print("Failed to retrieve device token");
      }
    } catch (e) {
      print("Error retrieving device token: $e");
    }

    // Initialize FlutterLocalNotificationsPlugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.notification?.title}');
      if (message.notification != null) {
        _showNotification(message.notification!);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('Notification clicked! ${message}');
      // if (activity == "join") {
      //   var joinResponse = await http.post(
      //     Uri.parse(getJoinRSSGridForAppbyid),
      //     headers: jHeaders,
      //     body: json.encode({
      //       "AppUserID": Statics.userDetails["userID"],
      //       "JoinRSSID": swjoinRssID,
      //     }),
      //   );
      //
      //   if (joinResponse.statusCode == 200) {
      //     print('Join Response: ${joinResponse.body}');
      //     var joinData = jsonDecode(joinResponse.body);
      //     JoinRssDetailByIDModel model = JoinRssDetailByIDModel.fromJson(joinData);
      //
      //     Navigator.of(context).pushNamed(
      //       EditJoinRss.routeName,
      //       arguments: Statics.ScreenArguments(model.listJoinRSS!.first.joinRSSID!, ""),
      //     );
      //   } else {
      //     print('Join request failed with status: ${joinResponse.statusCode}');
      //   }
      // }
    });
  }

  Future<void> _showNotification(RemoteNotification notification) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'channel_name', channelDescription: 'channel_description', importance: Importance.high, priority: Priority.high, showWhen: false);
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SadbhavProvider()),
      ],
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Niyojak',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  foregroundColor: Colors.white,
                ),
                scaffoldBackgroundColor: Colors.white,
                tabBarTheme: TabBarTheme(
                  labelColor: Colors.white, // Color for selected tab text
                  unselectedLabelColor: Colors.white70, // Color for unselected tab text
                ),
                appBarTheme: AppBarTheme(color: Colors.purple, titleTextStyle: TextStyle(color: Colors.white), iconTheme: IconThemeData(color: Colors.white)),
                primaryColor: Colors.purple,
                primarySwatch: Colors.purple,
                fontFamily: 'Lato',
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: SplashScreenCheck(),
              routes: {
                LogInScreen.routeName: (ctx) => LogInScreen(),
                HomeScreen.routeName: (ctx) => HomeScreen(),
                HelpScreen.routeName: (ctx) => HelpScreen(),
                ContactUs.routeName: (ctx) => ContactUs(),
                //SearchSwayamsevakScreen.routeName: (ctx) => SearchSwayamsevakScreen(),
                AbhiyanScreen.routeName: (ctx) => AbhiyanScreen(),
                ForgotPassword.routeName: (ctx) => ForgotPassword(),
                AbhiyaanSwayamsevak.routeName: (ctx) => AbhiyaanSwayamsevak(),
                VisheshVyaktiShodhScreen.routeName: (ctx) => VisheshVyaktiShodhScreen(),
                AddEditVisheshVyaktiScreen.routeName: (ctx) => AddEditVisheshVyaktiScreen(),
                EditVisheshVyaktiScreen.routeName: (ctx) => EditVisheshVyaktiScreen(),
                ViewVisheshVyaktiScreen.routeName: (ctx) => ViewVisheshVyaktiScreen(),
                AbhiyanAddSwayamsevakScreen.routeName: (ctx) => AbhiyanAddSwayamsevakScreen(),
                AbhiyanEditSwayamsevakScreen.routeName: (ctx) => AbhiyanEditSwayamsevakScreen(),
                AbhiyanViewSwayamsevakScreen.routeName: (ctx) => AbhiyanViewSwayamsevakScreen(),
                AddGruhaSamparkScreen.routeName: (ctx) => AddGruhaSamparkScreen(),
                SankalitDataNamesView.routeName: (ctx) => SankalitDataNamesView(),
                SearchShaakhaaScreen.routeName: (ctx) => SearchShaakhaaScreen(),
                EditSwayamsevakScreen.routeName: (ctx) => EditSwayamsevakScreen(),
                EditShaakhaaScreen.routeName: (ctx) => EditShaakhaaScreen(),
                EditSoochiScreen.routeName: (ctx) => EditSoochiScreen(),
                SearchEvent.routeName: (ctx) => SearchEvent(),
                SearchSoochiScreen.routeName: (ctx) => SearchSoochiScreen(),
                ChangePassword.routeName: (ctx) => ChangePassword(),
                ProfileSettings.routeName: (ctx) => ProfileSettings(),
                SwayamSevakSearch.routeName: (ctx) => SwayamSevakSearch(),
                SearchJoinRss.routeName: (ctx) => SearchJoinRss(),
                EditJoinRss.routeName: (ctx) => EditJoinRss(),
                SoochiMembers.routeName: (ctx) => SoochiMembers(),
                SoochiSharing.routeName: (ctx) => SoochiSharing(),
                ShaakhaaPat.routeName: (ctx) => ShaakhaaPat(),
                EditEvent.routeName: (ctx) => EditEvent(),
                EventCalender.routeName: (ctx) => EventCalender(),
                EventMembers.routeName: (ctx) => EventMembers(),
                EventVrutta.routeName: (ctx) => EventVrutta(),
                ShaakhaaVrutta.routeName: (ctx) => ShaakhaaVrutta(),
                EditShaakhaaVrutta.routeName: (ctx) => EditShaakhaaVrutta(),
                MapDisplay.routeName: (ctx) => MapDisplay(),
                SwayamSevakDaayitvaEdit.routeName: (ctx) => SwayamSevakDaayitvaEdit(),
                EditDaayitva.routeName: (ctx) => EditDaayitva(),
                ShaakhaaSevaVastiLink.routeName: (ctx) => ShaakhaaSevaVastiLink(),
                SearchSewaVasti.routeName: (ctx) => SearchSewaVasti(),
                EditSewaVasti.routeName: (ctx) => EditSewaVasti(),
                SearchSwayamsevakTransfer.routeName: (ctx) => SearchSwayamsevakTransfer(),
                EditSwayamsevakTransferScreen.routeName: (ctx) => EditSwayamsevakTransferScreen(),
                SearchRamJanmaBhoomiNidhiSankalan.routeName: (ctx) => SearchRamJanmaBhoomiNidhiSankalan(),
                ShaakhaaToli.routeName: (ctx) => ShaakhaaToli(),
                EditSwayamsevakBasicInfo.routeName: (ctx) => EditSwayamsevakBasicInfo(),
                EditSwayamsevakDaayitva.routeName: (ctx) => EditSwayamsevakDaayitva(),
                EditSwayamsevakOtherInfo.routeName: (ctx) => EditSwayamsevakOtherInfo(),
                SearchAnnualBaithakVrutta.routeName: (ctx) => SearchAnnualBaithakVrutta(),
                NirikshanAnnualBaithakVrutta.routeName: (ctx) => NirikshanAnnualBaithakVrutta(),
                AnnualBaithakEkatritVrutta.routeName: (ctx) => AnnualBaithakEkatritVrutta(),
                EditSwayamsevakSoochiInfo.routeName: (ctx) => EditSwayamsevakSoochiInfo(),
                CreateNotificationView.routeName: (ctx) => CreateNotificationView(),
                UpdateMasterDataScreen.routeName: (ctx) => UpdateMasterDataScreen(),
                TabScreen.routeName: (ctx) => TabScreen(),
                VastiSurveyFormScreen.routeName: (ctx) => VastiSurveyFormScreen(),
                AddMukhyaAtithi.routeName: (ctx) => AddMukhyaAtithi(),
                AddVishisthaAtithi.routeName: (ctx) => AddVishisthaAtithi(),
                VastiSurveyReportTab1.routeName: (ctx) => VastiSurveyReportTab1(),
                VastiSurveyReportTab2.routeName: (ctx) => VastiSurveyReportTab2(),
                MandalSurveyFormScreen.routeName: (ctx) => MandalSurveyFormScreen(),
                MandalSurveyReportScreen.routeName: (ctx) => MandalSurveyReportScreen(),
                VastiSurveyReportScreen.routeName: (ctx) => VastiSurveyReportScreen(),
                VijayadashamiFormView.routeName: (ctx) => VijayadashamiFormView(),
                VijayadashamiFormReport.routeName: (ctx) => VijayadashamiFormReport(),
                GruhAbhiyaanMainTabScreen.routeName: (ctx) => GruhAbhiyaanMainTabScreen(),
                AddAbhiyaanKaryakartaScreen.routeName: (ctx) => AddAbhiyaanKaryakartaScreen(),
                AddAbhiyaanPramukhScreen.routeName: (ctx) => AddAbhiyaanPramukhScreen(),
                HinduSanmelanMainTab.routeName: (ctx) => HinduSanmelanMainTab(),
                HinduSanmelanForm.routeName: (ctx) => HinduSanmelanForm(),
                HinduSanmelanReport.routeName: (ctx) => HinduSanmelanReport(),
                SearchSajjanAnyaScreen.routeName: (ctx) => SearchSajjanAnyaScreen(),
                VastiSarvekshanScreen.routeName: (ctx) => VastiSarvekshanScreen(),
                SadbhavBaithakMainTab.routeName: (ctx) => SadbhavBaithakMainTab(),
                SadbhavCenterListScreen.routeName: (ctx) => SadbhavCenterListScreen(),
                SadbhavCenterCreationScreen.routeName: (ctx) => SadbhavCenterCreationScreen(),
                AllBaithakTableScreen.routeName: (ctx) => AllBaithakTableScreen(),
                AddPresentMahanubhavScreen.routeName: (ctx) => AddPresentMahanubhavScreen(),
                PramukhJansanvadMainTab.routeName: (ctx) => PramukhJansanvadMainTab(),
                AllSanvaadScreen.routeName: (ctx) => AllSanvaadScreen(),
                KaryakramCreationScreen.routeName: (ctx) => KaryakramCreationScreen(),
                AddSajjanAnyaPrakukhJanScreen.routeName: (ctx) => AddSajjanAnyaPrakukhJanScreen(),
                SearchSankalpScreen.routeName: (ctx) => ChangeNotifierProvider<SankalpScreenProvider>(create: (context) => SankalpScreenProvider(), child: SearchSankalpScreen()),
                // SearchSankalpScreen.routeName: (ctx) => ChangeNotifierProvider<SankalpScreenProvider>(create: (context) => SankalpScreenProvider(), child: SearchSankalpScreen()),
              },
            ),
            if (Statics.isDevelopment)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.04,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(borderRadius: const BorderRadius.horizontal(left: Radius.circular(5)), color: Colors.red.withValues(alpha: 0.7)),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Text("D ", style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
