import 'dart:developer';

import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

import './screens/annual_baithak_ekatrit_vrutta.dart';
import './screens/change_password.dart';
import './screens/edit_daayitva.dart';
import './screens/edit_event.dart';
import './screens/edit_join_rss.dart';
import './screens/edit_sewa_vasti.dart';
import './screens/edit_soochi.dart';
import './screens/event_calender.dart';
import './screens/event_members.dart';
import './screens/event_vrutta.dart';
import './screens/help_screen.dart';
import './screens/login_screen.dart';
import './screens/maps_display.dart';
import './screens/profile_settings.dart';
import './screens/search_annual_baithak_vrutta.dart';
import './screens/search_event.dart';
import './screens/search_join_rss.dart';
import './screens/search_rjb_nidhi_sankalan.dart';
import './screens/search_soochi_screen.dart';
import './screens/search_swayamsevak_transfer.dart';
import './screens/sewa_vasti_list.dart';
import './screens/soochi_members.dart';
import './screens/soochi_sharing.dart';
import './screens/splash_screen.dart';
import './screens/swayamsevak_module/edit_module/edit_swayamsevak_daayitva.dart';
import './screens/swayamsevak_module/edit_module/edit_swayamsevak_other_info.dart';
import './screens/swayamsevak_module/edit_module/edit_swayamsevak_screen.dart';
import './screens/swayamsevak_module/edit_module/edit_swayamsevak_soochi.dart';
import './screens/swayamsevak_module/edit_module/edit_swayamsevak_transfer.dart';
import './screens/swayamsevak_module/swayamsevak_search.dart';
import 'firebase_options.dart';
import 'helpers/static_data.dart' as Statics;
import 'providers/sadbhav_provider.dart';
import 'screens/forget_password.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/shaakhaa_milan_module/edit_shaakhaa.dart';
import 'screens/shaakhaa_milan_module/edit_shaakhaa_vrutta.dart';
import 'screens/shaakhaa_milan_module/search_shaakhaa.dart';
import 'screens/shaakhaa_milan_module/shaakha_main_tab_screen.dart';
import 'screens/shaakhaa_milan_module/shaakhaa_pat.dart';
import 'screens/shaakhaa_milan_module/shaakhaa_ranking_screen.dart';
import 'screens/shaakhaa_milan_module/shaakhaa_sewa_vasti_link.dart';
import 'screens/shaakhaa_milan_module/shaakhaa_toli.dart';
import 'screens/shaakhaa_milan_module/shaakhaa_vrutta.dart';
import 'screens/shatabdi_vrutta_sankalan/gruh_sampark_abhiyaan/add_abhiyaan_karyakarta_screen.dart';
import 'screens/shatabdi_vrutta_sankalan/gruh_sampark_abhiyaan/add_abhiyaan_pramukh.dart';
import 'screens/shatabdi_vrutta_sankalan/gruh_sampark_abhiyaan/gruh_abhiyaan_main_tab_screen.dart';
import 'screens/shatabdi_vrutta_sankalan/hindu_sanmelan/hindu_sanmelan_main_tab.dart';
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
import 'screens/shatabdi_vrutta_sankalan/shaakhaa_saptah_vistar/add_new_shaakhaa_vistaar_screen.dart';
import 'screens/shatabdi_vrutta_sankalan/shaakhaa_saptah_vistar/shakha_saptah_main_tab.dart';
import 'screens/shatabdi_vrutta_sankalan/shaakhaa_saptah_vistar/shakhaa_saptah_form_screen.dart';
import 'screens/shatabdi_vrutta_sankalan/vijayadashami/vijayadashami_form_view.dart';
import 'screens/shatabdi_vrutta_sankalan/yuva-sangam_sanmelan/add_new_karyakram_screen.dart';
import 'screens/shatabdi_vrutta_sankalan/yuva-sangam_sanmelan/yuva_sangam_form_screen.dart';
import 'screens/shatabdi_vrutta_sankalan/yuva-sangam_sanmelan/yuva_sangam_main_tab.dart';
import 'screens/survey_screen/vasti_sarvekshan_screen.dart';
import 'screens/swayamsevak_module/edit_module/edit_swayamsevak_basic_info.dart';
import 'screens/swayamsevak_module/swayamsevak_daayitva_edit.dart';
import 'utils/notification_service.dart';
import 'utils/stable_geounit_class.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(name: "niyojak-cdd79", options: DefaultFirebaseOptions.currentPlatform);

  // Register as early as possible, before any other async setup — FCM can
  // deliver a background message while the rest of init() is still running.
  // `firebaseMessagingBackgroundHandler` lives in notification_service.dart
  // so there is a single source of truth for background handling.
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Owns: permission requests, local-notification channel setup, foreground
  // display, FCM token issuance/refresh + persistence, and tap-to-route
  // handling for all three app states (active/background/killed).
  await PushNotificationService.instance.init();

  runApp(NiyojakApp());
}

class NiyojakApp extends StatefulWidget {
  const NiyojakApp({super.key});

  @override
  State<NiyojakApp> createState() => NiyojakAppState();
}

class NiyojakAppState extends State<NiyojakApp> {
  @override
  void initState() {
    super.initState();

    // Orientation is app-wide and doesn't depend on build state — set it
    // once here instead of on every build().
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    );

    _configureBackgroundFetch();
  }

  @override
  void dispose() {
    PushNotificationService.instance.dispose();
    super.dispose();
  }

  /// NOTE: This is unrelated to push notifications — it's a periodic
  /// background-fetch hook. The registered task currently does nothing but
  /// log and immediately finish. If nothing in the app relies on this
  /// anymore (push handling is now fully owned by PushNotificationService),
  /// consider removing the background_fetch dependency entirely.
  void _configureBackgroundFetch() {
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
        log('[BackgroundFetch] Event: $taskId at ${DateTime.now()}');
        BackgroundFetch.finish(taskId);
      },
    ).then((status) {
      debugPrint('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      debugPrint('[BackgroundFetch] configure ERROR: $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SadbhavProvider()),
        ChangeNotifierProvider(create: (context) => GeoHierarchyController(hierarchy: [...baseHierarchy, shakhaaNode])),
      ],
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            MaterialApp(
              // Critical: without this, PushNotificationService can never
              // resolve a NavigatorState, and every notification-tap route
              // (active/background/killed) silently no-ops.
              navigatorKey: PushNotificationService.instance.navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Niyojak',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  foregroundColor: Colors.white,
                ),
                scaffoldBackgroundColor: Colors.white,
                tabBarTheme: TabBarThemeData(
                  labelColor: Colors.white, // Color for selected tab text
                  unselectedLabelColor: Colors.white70, // Color for unselected tab text
                ),
                appBarTheme: AppBarTheme(color: Colors.purple, titleTextStyle: TextStyle(color: Colors.white), iconTheme: IconThemeData(color: Colors.white)),
                primaryColor: Colors.purple,
                primarySwatch: Colors.purple,
                fontFamily: 'Lato',
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              builder: (c, child) =>
                  SafeArea(
                    top: false,
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: child,
                    ),
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
                ShaakhaMainTabScreen.routeName: (ctx) => ShaakhaMainTabScreen(),
                ShaakhaaRankingScreen.routeName: (ctx) => ShaakhaaRankingScreen(),
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
                // HinduSanmelanForm.routeName: (ctx) => HinduSanmelanForm(),
                // HinduSanmelanReport.routeName: (ctx) => HinduSanmelanReport(),
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
                AddNewKaryakramScreen.routeName: (ctx) => AddNewKaryakramScreen(),
                YuvaSangamMainTab.routeName: (ctx) => YuvaSangamMainTab(),
                YuvaSangamFormScreen.routeName: (ctx) => YuvaSangamFormScreen(),
                ShakhaSaptahMainTab.routeName: (ctx) => ShakhaSaptahMainTab(),
                ShakhaaSaptahFormScreen.routeName: (ctx) => ShakhaaSaptahFormScreen(),
                AddNewShaakhaaVistaarScreen.routeName: (ctx) => AddNewShaakhaaVistaarScreen(),
                SearchSankalpScreen.routeName: (ctx) => ChangeNotifierProvider<SankalpScreenProvider>(create: (context) => SankalpScreenProvider(), child: SearchSankalpScreen()),
              },
            ),
            if (Statics.isDevelopment)
              Positioned(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.04,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(borderRadius: const BorderRadius.horizontal(left: Radius.circular(5)), color: Colors.red.withValues(alpha: 0.7)),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Text("Dev - 1.0.33 ", style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
