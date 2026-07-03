import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanLoginDataResponse.dart';
import 'package:niyojak_prod/screens/ContactUsScreen.dart';
import 'package:niyojak_prod/widgets/legend.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;

import '../../helpers/static_data.dart' as Statics;
import '../../models/response_model/home_screen_names_resp_model.dart';
import '../../models/response_model/notification_list_model.dart';
import '../../models/response_model/shaakhaa_vrutta_report_home_resp_model.dart';
import '../../models/response_model/upkhanda_upnagar_report_data_model.dart';
import '../../providers/bals.dart';
import '../../providers/login.dart';
import '../../screens/change_password.dart';
import '../../utils/cust_painters.dart';
import '../../utils/globals.dart';
import '../../utils/stable_geounit_class.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/horizontal_graph_bar_widget.dart';
import '../../widgets/reusable_tab_cards.dart';
import '../../widgets/scrollable_data_table.dart';
import '../../widgets/single_column_row.dart';
import '../../widgets/two_column_row.dart';
import '../AbhiyanScreen.dart';
import '../levels_update_module/levels_manage_tabs.dart';
import '../notification_list_page.dart';
import '../profile_settings.dart';
import '../search_event.dart';
import '../search_join_rss.dart';
import '../search_rjb_nidhi_sankalan.dart';
import '../search_soochi_screen.dart';
import '../shaakhaa_milan_module/shaakha_main_tab_screen.dart';
import '../shatabdi_vrutta_sankalan/gruh_sampark_abhiyaan/gruh_abhiyaan_main_tab_screen.dart';
import '../shatabdi_vrutta_sankalan/hindu_sanmelan/hindu_sanmelan_main_tab.dart';
import '../shatabdi_vrutta_sankalan/pramukh_jansanvad/pramukh_jan_main_tab.dart';
import '../shatabdi_vrutta_sankalan/sadbhav_baithak/sadbhav_baithak_main_tab.dart';
import '../shatabdi_vrutta_sankalan/shaakhaa_saptah_vistar/shakha_saptah_main_tab.dart';
import '../shatabdi_vrutta_sankalan/vijayadashami/vijaya_dashami_report.dart';
import '../shatabdi_vrutta_sankalan/vijayadashami/vijayadashami_form_view.dart';
import '../shatabdi_vrutta_sankalan/yuva-sangam_sanmelan/yuva_sangam_main_tab.dart';
import '../survey_screen/mandal_reports_tabs.dart';
import '../survey_screen/survey_form/mandal_survey_form_view.dart';
import '../survey_screen/survey_form/vasti_survey_form_view.dart';
import '../survey_screen/vasti_reports_tabs.dart';
import '../swayamsevak_module/swayamsevak_search.dart';
import 'data_details_screen.dart';

enum OtherLevelSelection { daily, weekly, monthly, yearly }

enum ShaakhaaLevelSelection { daily, weekly, monthly, tmonthly }

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? currentBackPressTime;

  // ─── Scroll ────────────────────────────────────────────────────────────────
  final ScrollController _scrollController = ScrollController();

  // ─── GeoUnit ───────────────────────────────────────────────────────────────
  dynamic geoUnitID;
  dynamic geoUnitName;

  // ─── Loading flags ─────────────────────────────────────────────────────────
  bool _isLoading = false;
  bool _isSearching = false;
  bool _isMySearching = false;
  bool _isReportSearching = false;
  bool _isTgSearching = false;

  // ─── Panel expansion ───────────────────────────────────────────────────────
  // bool isDailySelected = false;
  bool _isSwExpanded = false;
  bool _isGeounitExpanded = false;
  bool _isNagarTableExpanded = false;

  // ─── Menu ──────────────────────────────────────────────────────────────────
  List<MenuChoices> choices = [];

  // ─── Target level ──────────────────────────────────────────────────────────
  int _tgLevelID = 13;
  String _selctedLevelName = "praant";

  //String _selctedGeoUnitId = "0";

  // ─── My – Shaakhaa Vrutta Summary ─────────────────────────────────────────
  String? myMaasikEQ0 = '', myMaasikEQ1 = '';
  String? mySaaptaahik1To3 = '', mySaaptaahikEQ0 = '', mySaaptaahikGTE4 = '';
  String? myShaakhaa1To24 = '', myShaakhaaEQ0 = '', myShaakhaaGTE25 = '', myShaakhaaEQ30 = '';

  // ─── Tg – Shaakhaa Vrutta Summary ─────────────────────────────────────────
  String? tgMaasikEQ0 = '', tgMaasikEQ1 = '';
  String? tgSaaptaahik1To3 = '', tgSaaptaahikEQ0 = '', tgSaaptaahikGTE4 = '';
  String? tgShaakhaa1To24 = '', tgShaakhaaEQ0 = '', tgShaakhaaGTE25 = '', tgShaakhaaEQ30 = '';

  // ─── My – counts ───────────────────────────────────────────────────────────
  String? myTotalKaaryakartaaCount = '', myPratidnyitCount = '', myTotalSwayamsevakCount = '';
  String? myShishuCount = '', myBaalCount = '', myTarunVidyaarthiCount = '';
  String? myTarunVyavasaayeeCount = '', myProudhaVyavasaayeeCount = '', myUnknownAgeCount = '';
  String? myPraarambhikShikshitCount = '', myPraathamikShikshitCount = '';
  String? myPrathamVarshaShikshitCount = '', myDwitiyaVarshaShikshitCount = '', myTrutiyaVarshaShikshitCount = '';
  String? myNoShikshanCount = '';
  String? myDailyShaakhaaKaaryakartaaCount = '', mySaaptaahikMilanKaaryakartaaCount = '', myMaasikMilanKaaryakartaaCount = '';
  String? myVastiKaaryakartaaCount = '', myGraamKaaryakartaaCount = '', myMandalKaaryakartaaCount = '';
  String? myNagarKaaryakartaaCount = '', myShaharKaaryakartaaCount = '', myBhaagKaaryakartaaCount = '';
  String? myVibhaagKaaryakartaaCount = '', myMahaanagarKaaryakartaaCount = '', myPraantKaaryakartaaCount = '';
  String? myKshetraKaaryakartaaCount = '', myAkhilBhaaratiyaKaaryakartaaCount = '', myPravaaseeKaaryakartaaCount = '';
  String? myGatividhiKaaryakartaaCount = '', myAayaamKaaryakartaaCount = '';
  String? mySanghaPreritSansthaaKaaryakartaaCount = '', mySocialOrganizationKaaryakartaaCount = '';

//------ Blood Group - count-------------------------------------------------//
  String? opos = '', oneg = '', apos = '', aneg = '', bpos = '', bneg = '', abpos = '', abneg = '', nivadlenahi = '';

  // ─── Tg – counts ───────────────────────────────────────────────────────────
  String? tgTotalKaaryakartaaCount = '', tgPratidnyitCount = '', tgTotalSwayamsevakCount = '';
  String? tgShaakhaaKaaryakartaaCount = '';
  String? tgShishuCount = '', tgBaalCount = '', tgTarunVidyaarthiCount = '';
  String? tgTarunVyavasaayeeCount = '', tgProudhaVyavasaayeeCount = '', tgUnknownAgeCount = '';
  String? tgPraarambhikShikshitCount = '', tgPraathamikShikshitCount = '';
  String? tgPrathamVarshaShikshitCount = '', tgDwitiyaVarshaShikshitCount = '', tgTrutiyaVarshaShikshitCount = '';
  String? tgNoShikshanCount = '';
  String? tgDailyShaakhaaKaaryakartaaCount = '', tgSaaptaahikMilanKaaryakartaaCount = '', tgMaasikMilanKaaryakartaaCount = '';
  String? tgVastiKaaryakartaaCount = '', tgGraamKaaryakartaaCount = '', tgMandalKaaryakartaaCount = '';
  String? tgNagarKaaryakartaaCount = '', tgShaharKaaryakartaaCount = '', tgBhaagKaaryakartaaCount = '';
  String? tgVibhaagKaaryakartaaCount = '', tgMahaanagarKaaryakartaaCount = '', tgPraantKaaryakartaaCount = '';
  String? tgKshetraKaaryakartaaCount = '', tgAkhilBhaaratiyaKaaryakartaaCount = '', tgPravaaseeKaaryakartaaCount = '';
  String? tgGatividhiKaaryakartaaCount = '', tgAayaamKaaryakartaaCount = '';
  String? tgSanghaPreritSansthaaKaaryakartaaCount = '', tgSocialOrganizationKaaryakartaaCount = '';
  String? tgMasikMilanCount = '', tgSanghaMandaliCount = '';

  // ─── Misc ──────────────────────────────────────────────────────────────────
  String? userDaayitvaNameforshow;
  String? notificationCount;
  NotificationListModel? notificationListdata;
  List<UpkhandaDataList> upkhandaDataList = [];
  UpnagarUpkhandaReportModel? bhougolikReportForExcel;
  int activeTabIndex = 0; // Tracks which tab is selected
  dynamic currentTabData; // Holds the currently active model (e.g., Shaobj, TotalAndNewModel)
  List<String> tabs = [];
  String? shaakhaausertype;
  String? prevofPrevMonthName;
  String? prevMonthName;
  String? thisMonthName;
  String? prevYearName;
  String? thisYearName;
  String? laststarttoendname;
  String? thisstartoendname;
  Shaakhadata? shaakhaLevelData;
  Otherdata? otherLevelData;
  AbhiyanSwayamsevakdata? initialData;

  // ─── Dropdown data – set 2 (Bhaugolik rachana panel) ──────────────────────
  List<GeoUnitMasterBAL>? _linkedMahaanagar2, _linkedVibhaag2;
  String? _linkedMahaanagarValue2 = "", _linkedVibhaagValue2 = "";

  //-------Ganvesh data-------------//

  late List<GetCount> _bloodgroup = [];
  late List<GetCount> _expertieslist = [];
  late List<GetCount> _mothertonguelist = [];
  late List<GetCount> _interestlist = [];
  late List<GetCount> _sangayulist = [];
  late List<GetCount> _ghoshwadlist = [];

  late List<GetCount> _tgbloodgroup = [];
  late List<GetCount> _tgexpertieslist = [];
  late List<GetCount> _tgmothertonguelist = [];
  late List<GetCount> _tginterestlist = [];
  late List<GetCount> _tgsangayulist = [];
  late List<GetCount> _tgghoshwadlist = [];
  GanveshData? _ganveshData;
  Vehicle? _vehicle;
  GanveshData? _tgganveshData;
  Vehicle? _tgvehicle;

  // ─── Access-control lists ─────────────────────────────────────────────────
  final List<String> _deniedLevels = ["Shakha", "Saptahik Milan", "शाखा", "साप्ताहिक मिलन"];

  final List<String> _allowedLevelsForGeoUnitChange = [
    "Praant",
    "प्रांत",
    "Mahaanagar",
    "महानगर",
    "Vibhaag",
    "विभाग",
    "Bhaag",
    "भाग",
    "भाग/जिल्हा",
    "भाग/जिला",
    "Nagar",
    "Nagar/Taalukaa",
    "नगर/तालुका",
  ];

  final List<String> _allowedDayitvaForGeoUnitChange = [
    "Kaaryavaah",
    "कार्यवाह",
    "Saha-Kaaryavaah",
    "सह कार्यवाह",
    "Prachaarak",
    "प्रचारक",
    "Vyavasthaa Pramukh",
    "व्यवस्था प्रमुख",
    "karyalay sachiv",
    "कार्यालय सचिव",
    "App Sanyojak",
    "एप संयोजक",
    "Saha-Prachaarak",
    "सह प्रचारक",
    "Vyavasaayee Saha-Pramukh",
    "व्यवसायी सह प्रमुख",
    "Kaaryaalay Pramukh",
    "कार्यालय प्रमुख",
    "Saha-kaaryaalay Pramukh",
    "सह कार्यालय प्रमुख",
    "Abhiyaan Karyakarta",
    "अभियान कार्यकर्ता",
    "Abhiyaan Pramukh",
    "अभियान प्रमुख",
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => callAllData());
  }

  callAllData() async {
    initData();
    await _initScreen();
    _getReleaseNotes();
  }

  Future<void> initData() async {
    final dm = await MyAppGlobals.getLevelLDB();

    final controller = context.read<GeoHierarchyController>();

    await controller.initialize(dm);

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
      isuservasti = dm.isvasti;
      isusermandal = dm.ismandal;
    });
  }

  _initScreen() async {
    _getInitialData();
    _populateChoices();
    _populateDropdownSet2();
    _getGeoUnitID();
    await Future.wait([
      _fetchMyDashboardData(),
      if ((userLevelId ?? 0) > 8) _getUpkhandUpnagarReport("0", "praant"),
      _fetchNotificationData(),
      _getShaakhaaVruttaReport(),
    ]);
    setState(() {});
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DATA FETCH
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _fetchNotificationData() async {
    try {
      notificationListdata = await Statics.getNotificationDataList(Statics.userDetails["userID"]);
      setState(() {});
    } catch (e) {
      print('Error fetching notification data: $e');
    }
  }

  Future<void> _getInitialData() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString("AbhiyanSwayamsevakData");
    userDaayitvaNameforshow = pref.getString("DaayitvaNameforshow") ?? '';
    await _checkLoginDate();
    if (data != null) initialData = AbhiyanSwayamsevakdata.fromJson(jsonDecode(data));
    setState(() {});
  }

  Future<void> _getShaakhaaVruttaReport() async {
    shaakhaLevelData = otherLevelData = shaakhaausertype = prevofPrevMonthName = prevMonthName = thisMonthName = null;
    tabs = [];
    setState(() => _isReportSearching = _isMySearching = true);
    final data = await Statics.yestardayShaakhaaVruttaHomeReportData(
      userID: int.tryParse(Statics.userDetails["userID"] ?? "0") ?? 0,
      targetGeoUnitID: null,
    );
    setState(() {
      _isReportSearching = _isMySearching = false;
    });
    if (data != null) {
      shaakhaLevelData = data.shaakhadata;
      otherLevelData = data.otherdata;
      shaakhaausertype = data.usertype;
      prevofPrevMonthName = data.prevofPrevMonthName;
      prevMonthName = data.prevMonthName;
      thisMonthName = data.thisMonthName;
      prevYearName = data.prevYearName;
      thisYearName = data.thisYearName;
      thisstartoendname = data.thisstartoendname;
      laststarttoendname = data.laststarttoendname;
      tabs = getTabTitles(data);
    }
    setState(() {});
    onTabTapped(0);
    setState(() {});
  }

  /// Call this function inside your TabBar's onTap or custom Tab onTap
  void onTabTapped(int index) {
    setState(() {
      activeTabIndex = index;
      // This auto-resolves the exact model type you need to show
      currentTabData = getDataForTab(index);
    });
  }

  /// 1. Returns whether to use Shaakhadata or Otherdata view
  bool get isShaakhaDataView => userLevelId == 1;

  /// 2. Returns the dynamic list of tab titles based on your conditions
  List<String> getTabTitles(ShaakhaaVruttaReportHomeRespModel response) {
    if (!isShaakhaDataView) {
      // Condition: userLevelId != 1 -> Use Otherdata (4 Tabs)
      return [Statics.getLabel('daily'), Statics.getLabel('weekly'), Statics.getLabel('monthly'), Statics.getLabel('yearly')];
    } else {
      // Condition: userLevelId == 1 -> Use Shaakhadata (Depends on usertype)
      switch (response.usertype?.toLowerCase()) {
        case 'daily':
          return [Statics.getLabel('daily'), Statics.getLabel('weekly')];
        case 'week':
          return [Statics.getLabel('weekly'), Statics.getLabel('monthly')];
        case 'month':
          return [Statics.getLabel('monthly'), Statics.getLabel('quarterly')];
        default:
          return [];
      }
    }
  }

  String getThisSelectedLabel() {
    switch (shaakhaausertype?.toLowerCase()) {
      case 'daily':
        return activeTabIndex == 0 ? Statics.getLabel('today') : Statics.getLabel('thisWeek');

      case 'week':
        return activeTabIndex == 0 ? Statics.getLabel('thisWeek') : Statics.getLabel('thisMonth');

      case 'month':
        return activeTabIndex == 0 ? Statics.getLabel('thisMonth') : Statics.getLabel('thisTMonth');

      default:
        return '';
    }
  }

  String getLastSelectedLabel() {
    switch (shaakhaausertype?.toLowerCase()) {
      case 'daily':
        return activeTabIndex == 0 ? Statics.getLabel('yesterdays') : Statics.getLabel('lastWeek');

      case 'week':
        return activeTabIndex == 0 ? Statics.getLabel('lastWeek') : Statics.getLabel('lastMonth');

      case 'month':
        return activeTabIndex == 0 ? Statics.getLabel('lastMonth') : Statics.getLabel('lastTMonth');

      default:
        return '';
    }
  }

  /// 3. Returns the exact data object based on the selected tab index
  dynamic getDataForTab(int index) {
    if (!isShaakhaDataView) {
      // --- OTHER DATA CASES ---
      final other = otherLevelData;
      switch (index) {
        case 0:
          return other?.shaobj; // Daily object
        case 1:
          return other?.weekobj; // Weekly object
        case 2:
          return other?.monthobj; // Monthly object
        case 3:
          return other?.yearobj; // Yearly object
        default:
          return null;
      }
    } else {
      // --- SHAAKHA DATA CASES ---
      final shaakha = shaakhaLevelData;
      final usertype = shaakhaausertype?.toLowerCase();

      if (usertype == 'daily') {
        if (index == 0) return shaakha?.daily;
        if (index == 1) return shaakha?.weekly;
      } else if (usertype == 'week') {
        if (index == 0) return shaakha?.weekly;
        if (index == 1) return shaakha?.monthly;
      } else if (usertype == 'month') {
        if (index == 0) return shaakha?.monthly;
        if (index == 1) return shaakha?.tmonthly;
      }
      return null;
    }
  }

  Future<void> _getUpkhandUpnagarReport(String? targetGeoUnitID, String levelName) async {
    setState(() => _isLoading = true);
    final data = await Statics.upkhandUpnagarReportData(
      userID: Statics.userDetails["userID"],
      targetGeoUnitID: targetGeoUnitID,
      type: levelName,
    );
    setState(() {
      _isLoading = false;
      if (data != null) upkhandaDataList = data.dataList ?? [];
    });
  }

  // ── My dashboard data ──────────────────────────────────────────────────────
  Future<void> _fetchMyDashboardData() async {
    setState(() => _isMySearching = true);
    final data = await Statics.refreshDashboardData(Statics.userDetails["userID"], geoUnitID);
    if (data['Status'] != "Success") {
      setState(() => _isMySearching = false);
      return;
    }
    final sd = data["HomeScreenData"];
    final vd = sd["ShaakhaaVruttaSummaryData"];

    if (sd["BloodGroup"] != null) {
      _bloodgroup.clear();
      sd["BloodGroup"].forEach((v) => _bloodgroup.add(GetCount.fromJson(v)));
    }
    if (sd["AreaOfExpertise"] != null) {
      _expertieslist.clear();
      sd["AreaOfExpertise"].forEach((v) => _expertieslist.add(GetCount.fromJson(v)));
    }
    if (sd["AreaOfInterest"] != null) {
      _interestlist.clear();
      sd["AreaOfInterest"].forEach((v) => _interestlist.add(GetCount.fromJson(v)));
    }
    if (sd["MotherTongue"] != null) {
      _mothertonguelist.clear();
      sd["MotherTongue"].forEach((v) => _mothertonguelist.add(GetCount.fromJson(v)));
    }
    if (sd["sangaayu"] != null) {
      _sangayulist.clear();
      sd["sangaayu"].forEach((v) => _sangayulist.add(GetCount.fromJson(v)));
    }
    if (sd["goshwad"] != null) {
      _ghoshwadlist.clear();
      sd["goshwad"].forEach((v) => _ghoshwadlist.add(GetCount.fromJson(v)));
    }
    if (sd["GanaveshData"] != null) {
      _ganveshData = GanveshData.fromJson(sd["GanaveshData"]);
    }
    if (sd['VehicleData'] != null) {
      _vehicle = Vehicle.fromJson(sd['VehicleData']);
    }
    if (mounted)
      setState(() {
        myTotalKaaryakartaaCount = sd["TotalKaaryakartaaCount"].toString();
        myTotalSwayamsevakCount = sd["TotalSwayamsevakCount"].toString();

        myPratidnyitCount = sd["PratidnyitCount"].toString();
        myShishuCount = sd["ShishuCount"].toString();
        myBaalCount = sd["BaalCount"].toString();
        myTarunVidyaarthiCount = sd["TarunVidyaarthiCount"].toString();
        myTarunVyavasaayeeCount = sd["TarunVyavasaayeeCount"].toString();
        myProudhaVyavasaayeeCount = sd["ProudhaVyavasaayeeCount"].toString();
        myUnknownAgeCount = sd["UnknownAgeCount"].toString();
        myPraarambhikShikshitCount = sd["PrarambhikShikshitCount"].toString();
        myPraathamikShikshitCount = sd["PraathamikShikshitCount"].toString();
        myPrathamVarshaShikshitCount = sd["PrathamVarshaShikshitCount"].toString();
        myDwitiyaVarshaShikshitCount = sd["DwitiyaVarshaShikshitCount"].toString();
        myTrutiyaVarshaShikshitCount = sd["TrutiyaVarshaShikshitCount"].toString();
        myNoShikshanCount = sd["NoShikshanCount"].toString();
        myDailyShaakhaaKaaryakartaaCount = sd["DailyShaakhaaKaaryakartaaCount"].toString();
        mySaaptaahikMilanKaaryakartaaCount = sd["SaaptaahikMilanKaaryakartaaCount"].toString();
        myMaasikMilanKaaryakartaaCount = sd["MaasikMilanKaaryakartaaCount"].toString();
        myVastiKaaryakartaaCount = sd["VastiKaaryakartaaCount"].toString();
        myGraamKaaryakartaaCount = sd["GraamKaaryakartaaCount"].toString();
        myMandalKaaryakartaaCount = sd["MandalKaaryakartaaCount"].toString();
        myNagarKaaryakartaaCount = sd["NagarKaaryakartaaCount"].toString();
        myShaharKaaryakartaaCount = sd["ShaharKaaryakartaaCount"].toString();
        myBhaagKaaryakartaaCount = sd["BhaagKaaryakartaaCount"].toString();
        myVibhaagKaaryakartaaCount = sd["VibhaagKaaryakartaaCount"].toString();
        myMahaanagarKaaryakartaaCount = sd["MahaanagarKaaryakartaaCount"].toString();
        myPraantKaaryakartaaCount = sd["PraantKaaryakartaaCount"].toString();
        myKshetraKaaryakartaaCount = sd["KshetraKaaryakartaaCount"].toString();
        myAkhilBhaaratiyaKaaryakartaaCount = sd["AkhilBhaaratiyaKaaryakartaaCount"].toString();
        myPravaaseeKaaryakartaaCount = sd["PravaaseeKaaryakartaaCount"].toString();
        myGatividhiKaaryakartaaCount = sd["GatividhiKaaryakartaaCount"].toString();
        myAayaamKaaryakartaaCount = sd["AayaamKaaryakartaaCount"].toString();
        mySanghaPreritSansthaaKaaryakartaaCount = sd["SanghaPreritSansthaaKaaryakartaaCount"].toString();
        mySocialOrganizationKaaryakartaaCount = sd["SocialOrganizationKaaryakartaaCount"].toString();
        notificationCount = sd["Notificationcount"].toString();

        // Vrutta summary
        myMaasikEQ0 = vd["MaasikEQ0"].toString();
        myMaasikEQ1 = vd["MaasikEQ1"].toString();
        mySaaptaahikEQ0 = vd["SaaptaahikEQ0"].toString();
        mySaaptaahik1To3 = vd["Saaptaahik1To3"].toString();
        mySaaptaahikGTE4 = vd["SaaptaahikGTE4"].toString();
        myShaakhaaEQ0 = vd["ShaakhaaEQ0"].toString();
        myShaakhaa1To24 = vd["Shaakhaa1To24"].toString();
        myShaakhaaGTE25 = vd["ShaakhaaGTE25"].toString();
        myShaakhaaEQ30 = vd["ShaakhaaEQ30"].toString();

        _isMySearching = false;
      });
  }

  // ── Target dashboard data ──────────────────────────────────────────────────
  Future<void> _fetchTargetDashboardData() async {
    final _controller = context.read<GeoHierarchyController>();
    _tgLevelID = _controller.deepestSelectedLevelId ?? 0;
    setState(() => _isTgSearching = true);
    final data = await Statics.getDashboardDataByGeoUnit(Statics.userDetails["userID"], _controller.deepestSelectedGeoUnitId ?? "0");
    if (data['Status'] != "Success") {
      _clearTargetData();
      return;
    }
    final sd = data["HomeScreenData"];
    final vd = sd["ShaakhaaVruttaSummaryData"];
    if (sd["BloodGroup"] != null) {
      _tgbloodgroup.clear();
      sd["BloodGroup"].forEach((v) => _tgbloodgroup.add(GetCount.fromJson(v)));
    }
    if (sd["AreaOfExpertise"] != null) {
      _tgexpertieslist.clear();
      sd["AreaOfExpertise"].forEach((v) => _tgexpertieslist.add(GetCount.fromJson(v)));
    }
    if (sd["AreaOfInterest"] != null) {
      _tginterestlist.clear();
      sd["AreaOfInterest"].forEach((v) => _tginterestlist.add(GetCount.fromJson(v)));
    }
    if (sd["MotherTongue"] != null) {
      _tgmothertonguelist.clear();
      sd["MotherTongue"].forEach((v) => _tgmothertonguelist.add(GetCount.fromJson(v)));
    }
    if (sd["sangaayu"] != null) {
      _tgsangayulist.clear();
      sd["sangaayu"].forEach((v) => _tgsangayulist.add(GetCount.fromJson(v)));
    }
    if (sd["goshwad"] != null) {
      _tgghoshwadlist.clear();
      sd["goshwad"].forEach((v) => _tgghoshwadlist.add(GetCount.fromJson(v)));
    }
    if (sd["GanaveshData"] != null) {
      _tgganveshData = GanveshData.fromJson(sd["GanaveshData"]);
    }
    if (sd['VehicleData'] != null) {
      _tgvehicle = Vehicle.fromJson(sd['VehicleData']);
    }
    setState(() {
      tgTotalKaaryakartaaCount = sd["TotalKaaryakartaaCount"].toString();
      tgTotalSwayamsevakCount = sd["TotalSwayamsevakCount"].toString();
      tgPratidnyitCount = sd["PratidnyitCount"].toString();
      tgShaakhaaKaaryakartaaCount = sd["ShaakhaaKaaryakartaaCount"].toString();
      tgShishuCount = sd["ShishuCount"].toString();
      tgBaalCount = sd["BaalCount"].toString();
      tgTarunVidyaarthiCount = sd["TarunVidyaarthiCount"].toString();
      tgTarunVyavasaayeeCount = sd["TarunVyavasaayeeCount"].toString();
      tgProudhaVyavasaayeeCount = sd["ProudhaVyavasaayeeCount"].toString();
      tgUnknownAgeCount = sd["UnknownAgeCount"].toString();
      tgPraarambhikShikshitCount = sd["PrarambhikShikshitCount"].toString();
      tgPraathamikShikshitCount = sd["PraathamikShikshitCount"].toString();
      tgPrathamVarshaShikshitCount = sd["PrathamVarshaShikshitCount"].toString();
      tgDwitiyaVarshaShikshitCount = sd["DwitiyaVarshaShikshitCount"].toString();
      tgTrutiyaVarshaShikshitCount = sd["TrutiyaVarshaShikshitCount"].toString();
      tgNoShikshanCount = sd["NoShikshanCount"].toString();
      tgDailyShaakhaaKaaryakartaaCount = sd["DailyShaakhaaKaaryakartaaCount"].toString();
      tgSaaptaahikMilanKaaryakartaaCount = sd["SaaptaahikMilanKaaryakartaaCount"].toString();
      tgMaasikMilanKaaryakartaaCount = sd["MaasikMilanKaaryakartaaCount"].toString();
      tgVastiKaaryakartaaCount = sd["VastiKaaryakartaaCount"].toString();
      tgGraamKaaryakartaaCount = sd["GraamKaaryakartaaCount"].toString();
      tgMandalKaaryakartaaCount = sd["MandalKaaryakartaaCount"].toString();
      tgNagarKaaryakartaaCount = sd["NagarKaaryakartaaCount"].toString();
      tgShaharKaaryakartaaCount = sd["ShaharKaaryakartaaCount"].toString();
      tgBhaagKaaryakartaaCount = sd["BhaagKaaryakartaaCount"].toString();
      tgVibhaagKaaryakartaaCount = sd["VibhaagKaaryakartaaCount"].toString();
      tgMahaanagarKaaryakartaaCount = sd["MahaanagarKaaryakartaaCount"].toString();
      tgPraantKaaryakartaaCount = sd["PraantKaaryakartaaCount"].toString();
      tgKshetraKaaryakartaaCount = sd["KshetraKaaryakartaaCount"].toString();
      tgAkhilBhaaratiyaKaaryakartaaCount = sd["AkhilBhaaratiyaKaaryakartaaCount"].toString();
      tgPravaaseeKaaryakartaaCount = sd["PravaaseeKaaryakartaaCount"].toString();
      tgGatividhiKaaryakartaaCount = sd["GatividhiKaaryakartaaCount"].toString();
      tgAayaamKaaryakartaaCount = sd["AayaamKaaryakartaaCount"].toString();
      tgSanghaPreritSansthaaKaaryakartaaCount = sd["SanghaPreritSansthaaKaaryakartaaCount"].toString();
      tgSocialOrganizationKaaryakartaaCount = sd["SocialOrganizationKaaryakartaaCount"].toString();
      notificationCount = sd["Notificationcount"].toString();

      // Vrutta summary
      tgMaasikEQ0 = vd["MaasikEQ0"].toString();
      tgMaasikEQ1 = vd["MaasikEQ1"].toString();
      tgSaaptaahikEQ0 = vd["SaaptaahikEQ0"].toString();
      tgSaaptaahik1To3 = vd["Saaptaahik1To3"].toString();
      tgSaaptaahikGTE4 = vd["SaaptaahikGTE4"].toString();
      tgShaakhaaEQ0 = vd["ShaakhaaEQ0"].toString();
      tgShaakhaa1To24 = vd["Shaakhaa1To24"].toString();
      tgShaakhaaGTE25 = vd["ShaakhaaGTE25"].toString();
      tgShaakhaaEQ30 = vd["ShaakhaaEQ30"].toString();
      _isTgSearching = false;
    });
  }

  void _clearTargetData() {
    setState(() {
      tgTotalKaaryakartaaCount = tgPratidnyitCount = tgShaakhaaKaaryakartaaCount = '';
      tgShishuCount = tgBaalCount = tgTarunVidyaarthiCount = '';
      tgTarunVyavasaayeeCount = tgProudhaVyavasaayeeCount = tgUnknownAgeCount = '';
      tgPraarambhikShikshitCount = tgPraathamikShikshitCount = '';
      tgPrathamVarshaShikshitCount = tgDwitiyaVarshaShikshitCount = tgTrutiyaVarshaShikshitCount = '';
      tgNoShikshanCount = tgDailyShaakhaaKaaryakartaaCount = '';
      tgSaaptaahikMilanKaaryakartaaCount = tgMaasikMilanKaaryakartaaCount = '';
      tgVastiKaaryakartaaCount = tgGraamKaaryakartaaCount = tgMandalKaaryakartaaCount = '';
      tgNagarKaaryakartaaCount = tgShaharKaaryakartaaCount = tgBhaagKaaryakartaaCount = '';
      tgVibhaagKaaryakartaaCount = tgMahaanagarKaaryakartaaCount = tgPraantKaaryakartaaCount = '';
      tgKshetraKaaryakartaaCount = tgAkhilBhaaratiyaKaaryakartaaCount = tgPravaaseeKaaryakartaaCount = '';
      tgGatividhiKaaryakartaaCount = tgAayaamKaaryakartaaCount = '';
      tgSanghaPreritSansthaaKaaryakartaaCount = tgSocialOrganizationKaaryakartaaCount = '';
      tgTotalSwayamsevakCount = tgMasikMilanCount = tgSanghaMandaliCount = '';
      tgMaasikEQ0 = tgMaasikEQ1 = tgSaaptaahikEQ0 = tgSaaptaahik1To3 = tgSaaptaahikGTE4 = '';
      tgShaakhaaEQ0 = tgShaakhaa1To24 = tgShaakhaaGTE25 = tgShaakhaaEQ30 = '';
      _tgbloodgroup = _tgexpertieslist = _tginterestlist = _tgmothertonguelist = _tgsangayulist = _tgghoshwadlist = [];
      _tgganveshData = null;
      _tgvehicle = null;
      _isTgSearching = false;
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DROPDOWN HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  void _populateDropdownSet2() {
    _populateMahaanagar2();
    _populateVibhaag2();
  }

  void _populateMahaanagar2() async {
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), "", "", "");
    setState(() => _linkedMahaanagar2 = data);
  }

  void _populateVibhaag2() async {
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), "", "", "");
    setState(() => _linkedVibhaag2 = data);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCESS CONTROL HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  bool _shouldShowForLevel(String levelName) => !_deniedLevels.contains(levelName);

  bool get _joinRss => Statics.levelId >= 6 && Statics.levelId != 13;

  bool get _fromAboveMandal => Statics.levelId >= 4;

  bool get _fromMandalGram => Statics.levelId != 2;

  bool get _fromVasti => userLevelId != 3 && userLevelId != 4;

  bool get _fromShaakha => userLevelId == 1;

  bool get _fromAboveNagar => ((userLevelId ?? 0) >= 6 && (userLevelId ?? 0) < 13);

  bool _shouldShowGeoUnitChange(String levelName, String daayitvaName) => _allowedLevelsForGeoUnitChange.contains(levelName);

  // ═══════════════════════════════════════════════════════════════════════════
  // MENU
  // ═══════════════════════════════════════════════════════════════════════════

  void _populateChoices() {
    setState(() {
      choices = [
        MenuChoices("ResfreshDashboard", Icons.refresh, Statics.getLabel('DashboardData')),
        MenuChoices("ChangeLanguage", Icons.settings, Statics.getLabel('ChangeLanguage')),
        MenuChoices("ChangePassword", Icons.track_changes, Statics.getLabel('ChangePassword')),
        MenuChoices("ContactUs", Icons.support_agent_rounded, Statics.getLabel('contactUs')),
        MenuChoices("LogOut", Icons.logout, Statics.getLabel('logOutLabel')),
      ];
    });
  }

  void _onMenuSelected(MenuChoices choice) async {
    switch (choice.menuType) {
      case "ChangePassword":
        Navigator.of(context).pushNamed(ChangePassword.routeName);
        break;
      case "ChangeLanguage":
        Navigator.of(context).pushNamed(ProfileSettings.routeName);
        break;
      case "ContactUs":
        Navigator.of(context).pushNamed(ContactUs.routeName);
        break;
      case "LogOut":
        final connected = await Statics.isInternetConnected();
        if (!connected) {
          Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
        } else {
          await LogIn().logOut();
          BackgroundFetch.stop().then((s) => print('[BackgroundFetch] stop: $s'));
          Navigator.of(context).pushNamedAndRemoveUntil("/", (r) => false);
        }
        break;
      case "ResfreshDashboard":
        setState(() => _isSearching = true);
        await _initScreen();
        /*final data = await Statics.refreshDashboardData(Statics.userDetails["userID"], geoUnitID);
        if (data == "Successfull") {
          await Statics.getNotificationDataList(Statics.userDetails["userID"]);
          Statics.populateDashboardDetailsMap();
          Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
        }*/
        setState(() => _isSearching = false);
        break;
    }
  }

  void _getGeoUnitID() {
    setState(() {
      geoUnitID = Statics.userDetails["DaayitvaGeoUnitID"];
      geoUnitName = '${Statics.userDetails["DaayitvaGeoUnitName"]}-${Statics.userDetails["LevelName"]}';
    });
  }

  Future<String?> _checkLoginDate() async {
    try {
      final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};
      final response = await http.post(
        Uri.parse(Statics.urlCheckLoginDate),
        headers: headers,
        body: json.encode({"swayamsevakid": Statics.userDetails["userID"]}),
      );
      final body = json.decode(response.body);
      if (body['isForceLogout'] == 1) {
        await LogIn().logOut();
        Navigator.of(context).pushReplacementNamed('/');
      }
      return body['ForceLogout'];
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _getReleaseNotes() async {
    final pref = await SharedPreferences.getInstance();
    try {
      final isRead = pref.getBool("isRead") ?? false;
      if (isRead) return;
      final noteData = await Statics.getVersionReleaseNotes();
      if (noteData == null) return;
      setState(() {});
      final langText = (Statics.currentLang() == 1
              ? noteData.hinditext
              : Statics.currentLang() == 2
                  ? noteData.englishtext
                  : noteData.marathitext)
          .toString()
          .split("-->");

      showDialog(
        context: context,
        useSafeArea: true,
        builder: (ct) => PopScope(
          canPop: false,
          child: Dialog(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            insetPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.purple, Colors.purpleAccent]),
                  ),
                  child: Text(
                    "Release Notes - ${Statics.packageInfo['versionNumber']}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: langText
                          .asMap()
                          .entries
                          .map((e) => Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(flex: 1, child: Text("${e.key + 1}. ", style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14))),
                                    Expanded(flex: 7, child: Text(e.value, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey.shade700))),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      minimumSize: const Size.fromHeight(45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      await pref.setBool("isRead", true);
                      await pref.setString("appVer", Statics.packageInfo['versionNumber']);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    label: Text(Statics.getLabel('bandKara'), style: const TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      print('Error fetching release notes: $e');
    }
  }

  showNamesList({String? geoUnitID, required String type}) async {
    setState(() {
      // isLoading = true;
      // errorMessage = null;
    });
    try {
      final req = {
        "AppUserID": int.tryParse(Statics.userDetails['userID'] ?? "0") ?? 0,
        "TargetGeoUnitID": int.tryParse((geoUnitID ?? userGeoUnitId ?? 0).toString()),
        "type": type,
      };

      final response = await Statics.refreshHomeScreenNamesData(req, context: context);

      if (response == null) {
        Statics.showToast(Statics.getLabel("NoDataFound"));
        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DataDetailsScreen(infoName: type, groupedData: _getGroupedDataModels(response)),
        ),
      );
      return;
    } catch (e) {
      print(e);
      return null;
    } finally {}
  }

  List<DataDetailsGroup> _getGroupedDataModels(List<DataDetails> response) {
    List<DataDetailsGroup> groupedList = [];

    for (var item in response) {
      // Check if this groupType already exists in our list
      int existingGroupIndex = groupedList.indexWhere((group) => group.groupType == item.type);

      if (existingGroupIndex == -1) {
        // If it doesn't exist, create a new group and add it to the list
        groupedList.add(DataDetailsGroup(groupType: item.type.toString(), items: [item]));
      } else {
        // If it does exist, add the item to the existing group's list
        groupedList[existingGroupIndex].items.add(item);
      }
    }

    return groupedList;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ──────────────────────  REUSABLE TABLE WIDGETS  ──────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════

  /// Standard "no data" placeholder.
  Widget _buildNoData({String? label}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(Statics.getLabel(label ?? 'NoDataFound'), style: const TextStyle(fontWeight: FontWeight.normal)),
      );

  /// Background colour for a total/summary row.
  MaterialStateProperty<Color?> _totalRowColor() => MaterialStatePropertyAll(Theme.of(context).colorScheme.secondary.withOpacity(0.2));

  /// Shorthand for a plain text DataCell.
  // DataCell _cell(String text) => DataCell(Center(child: Text(text, textAlign: TextAlign.center, softWrap: true)));

  // ── 1. Sadyasthiti / Sankalp (main big table) ────────────────────────────
  /// Shows Shaakhaa, Saaptaahik, Maasik, SanghaMandali counts vs sankalpit.
  Widget _buildSadyasthitiTable(List<DashboardSadyaSthitiDataBAL> data) {
    if (data.isEmpty) return _buildNoData();
    return ScrollableDataTable(
      leftFixedHeaders: [Statics.getLabel('Vayogat')],
      leftFixedRows: data.map((item) {
        final isTotal = item.vayogatID == -1;
        return DataRow(
          color: isTotal ? _totalRowColor() : null,
          cells: [
            customDataRowCell(item.vayogatCode ?? ''),
          ],
        );
      }).toList(),
      headers: [
        Statics.getLabel('RegisterShaakhaa'),
        Statics.getLabel('SankalpitShaakhaa'),
        Statics.getLabel('TotalSankalpitShaakhaa'),
        Statics.getLabel('RegisteredSaaptaahikMilan'),
        Statics.getLabel('SankalpitSaaptaahikMilan'),
        Statics.getLabel('TotalSankalpitSaaptaahikMilan'),
        Statics.getLabel('RegisteredMasikMilan'),
        Statics.getLabel('SankalpitMasikMilan'),
        Statics.getLabel('TotalSankalpitMasikMilan'),
        Statics.getLabel('RegisteredSanghaMandali'),
        Statics.getLabel('SankalpitSanghMandali'),
        Statics.getLabel('TotalSankalpitSanghMandali'),
      ],
      rows: data.map((item) {
        final isTotal = item.vayogatID == -1;
        return DataRow(
          color: isTotal ? _totalRowColor() : null,
          cells: [
            customDataRowCell('${item.shaakhaaCount}'),
            customDataRowCell('${item.sankalpitShaakhaaCount}'),
            customDataRowCell('${(item.shaakhaaCount ?? 0) + (item.sankalpitShaakhaaCount ?? 0)}'),
            customDataRowCell('${item.saaptaahikCount}'),
            customDataRowCell('${item.sankalpitSaaptaahikCount}'),
            customDataRowCell('${(item.saaptaahikCount ?? 0) + (item.sankalpitSaaptaahikCount ?? 0)}'),
            customDataRowCell('${item.maasikMilanCount}'),
            customDataRowCell('${item.sankalpitMaasikMilanCount}'),
            customDataRowCell('${(item.maasikMilanCount ?? 0) + (item.sankalpitMaasikMilanCount ?? 0)}'),
            customDataRowCell('${item.sanghaMandaliCount}'),
            customDataRowCell('${item.sankalpitSanghaMandaliCount}'),
            customDataRowCell('${(item.sanghaMandaliCount ?? 0) + (item.sankalpitSanghaMandaliCount ?? 0)}'),
          ],
        );
      }).toList(),
    );
  }

  // ── 2. Sankalp-by-Aadhaar table ───────────────────────────────────────────
  Widget _buildSankalpByAadhaarTable(List data) {
    if (data.isEmpty) return _buildNoData();
    return ScrollableDataTable(
      leftFixedHeaders: [
        Statics.getLabel('Vayogat'),
      ],
      leftFixedRows: data.asMap().entries.map((e) {
        final item = e.value;
        final isTotal = e.key == data.length - 1;
        final aadhaarLabel = item.sankalpAadhaar == '' ? '' : Statics.getLabel(item.sankalpAadhaar);
        return DataRow(
          color: isTotal ? _totalRowColor() : null,
          cells: [
            customDataRowCell(item.vayogatCode ?? ''),
          ],
        );
      }).toList(),
      headers: [
        Statics.getLabel('SankalpAadhaar'),
        Statics.getLabel('SankalpitShaakhaa'),
        Statics.getLabel('SankalpitSaaptaahikMilan'),
        Statics.getLabel('SankalpitMasikMilan'),
        Statics.getLabel('SankalpitSanghMandali'),
      ],
      rows: data.asMap().entries.map((e) {
        final item = e.value;
        final isTotal = e.key == data.length - 1;
        final aadhaarLabel = item.sankalpAadhaar == '' ? '' : Statics.getLabel(item.sankalpAadhaar);
        return DataRow(
          color: isTotal ? _totalRowColor() : null,
          cells: [
            customDataRowCell(aadhaarLabel),
            customDataRowCell('${item.sankalpitShaakhaaCount}'),
            customDataRowCell('${item.sankalpitSaaptaahikCount}'),
            customDataRowCell('${item.sankalpitMasikMilankCount}'),
            customDataRowCell('${item.sankalpitSanghaMandalikCount}'),
          ],
        );
      }).toList(),
    );
  }

  // ── 3. Bhaugolik Vistaar table ────────────────────────────────────────────
  Widget _buildBhaugolikTable(List data) {
    if (data.isEmpty) return _buildNoData();
    return ScrollableDataTable(
      leftFixedHeaders: [
        Statics.getLabel('LevelName'),
      ],
      leftFixedRows: data.asMap().entries.map((e) {
        final item = e.value;
        final isTotal = e.key == data.length - 1;
        return DataRow(
          color: isTotal ? _totalRowColor() : null,
          cells: [
            customDataRowCell(Statics.getLabel(item.levelName ?? '')),
          ],
        );
      }).toList(),
      headers: [
        Statics.getLabel('Total'),
        Statics.getLabel('ShaakhaaYuktaLabel'),
        Statics.getLabel('SaaptaahikSLabel'),
        Statics.getLabel('MaasikYuktaLabel'),
      ],
      rows: data.asMap().entries.map((e) {
        final item = e.value;
        final isTotal = e.key == data.length - 1;
        return DataRow(color: isTotal ? _totalRowColor() : null, cells: [
          customDataRowCell('${item.totalCount}'),
          customDataRowCell('${item.shaakhaaYuktaCount}'),
          customDataRowCell('${item.saaptaahikYuktaCount}'),
          customDataRowCell('${item.mandaliYuktaCount}'),
        ]);
      }).toList(),
    );
  }

  // ── 4. Generic two-column name/count table ────────────────────────────────
  /// Used for Gatividhi, Aayaam, Prerit, SocialOrg, StudentCategory, VyavasaayeeCategory.
  Widget _buildNameCountTable({
    required List data,
    required String nameHeader,
    required String countHeader,
    required String Function(dynamic) nameOf,
    required String Function(dynamic) countOf,
  }) {
    if (data.isEmpty) return _buildNoData();
    return ScrollableDataTable(
      headers: [nameHeader, countHeader],
      rows: data.asMap().entries.map((e) {
        final isTotal = e.key == data.length - 1;
        return DataRow(
          color: isTotal ? _totalRowColor() : null,
          cells: [customDataRowCell(nameOf(e.value)), customDataRowCell(countOf(e.value))],
        );
      }).toList(),
    );
  }

  // ── 5. Yesterday praant table ─────────────────────────────────────────────
  Widget _buildYesterdayPraantTable() {
    return Column(
      spacing: 12,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(28),
          ),
          // 1. Wrap the Row in a SingleChildScrollView
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // 2. Enable horizontal scrolling
            physics: const BouncingScrollPhysics(), // Gives it a nice native bounce effect
            child: Row(
              // Removed mainAxisAlignment: spaceEvenly since the scrollable width is infinite
              children: List.generate(tabs.length, (index) {
                final isSelected = activeTabIndex == index;

                return GestureDetector(
                  onTap: () => onTabTapped(index),
                  child: Container(
                    // The margin here handles the spacing between tabs nicely
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: isSelected ? 15.0 : 0.0,
                          sigmaY: isSelected ? 15.0 : 0.0,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isSelected ? Colors.white.withOpacity(0.4) : Colors.transparent,
                              width: 1.0,
                            ),
                            gradient: isSelected
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.4),
                                      Colors.purple.withOpacity(0.1),
                                      Colors.deepPurple.withOpacity(0.37),
                                      Colors.deepPurple.withOpacity(0.7),
                                    ],
                                    stops: const [0.0, 0.3, 0.6, 1.0],
                                  )
                                : null,
                            color: isSelected ? null : Colors.white.withOpacity(0.05),
                          ),
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.grey.shade700,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        buildDataBody(),
      ],
    );
    /*
    final data = Statics.lstYesterdayPraantData;
    if (data.isEmpty) return _buildNoData();
    return ScrollableDataTable(
      headers: [
        Statics.getLabel('Vayogat'),
        Statics.getLabel('Shaakhaa'),
        Statics.getLabel('SaaptaahikMilan'),
      ],
      rows: data.asMap().entries.map((e) {
        final item = e.value;
        final isTotal = e.key == data.length - 1;
        return DataRow(
          color: isTotal ? _totalRowColor() : null,
          cells: [
            customDataRowCell(item.vayogatCode ?? ''),
            customDataRowCell('${item.shaakhaaCount}'),
            customDataRowCell('${item.saaptaahikCount}'),
          ],
        );
      }).toList(),
    );*/
  }

  Widget buildDataBody() {
    if (currentTabData == null) return _buildNoData();
    // If userLevelId == 1, data will be TotalAndNewModel
    if (currentTabData is TotalAndNewModel) {
      final data = currentTabData as TotalAndNewModel;
      return Column(
        spacing: 8,
        children: [
          _attendanceCard(title: "${Statics.getLabel('Total')} ${Statics.getLabel('upastithi')}", thisLabel: getThisSelectedLabel(), previousLabel: getLastSelectedLabel(), data: [
            AttendanceData(label: Statics.getLabel('upastithi'), today: (data.todayCount ?? 0).toDouble(), yesterday: (data.yesterdayCount ?? 0).toDouble()),
          ]),
          _attendanceCard(title: "${Statics.getLabel('Total')} ${Statics.getLabel('newAdmission')}", thisLabel: getThisSelectedLabel(), previousLabel: getLastSelectedLabel(), data: [
            AttendanceData(label: Statics.getLabel('admission'), today: (data.todayNewCount ?? 0).toDouble(), yesterday: (data.yesterdayNewCount ?? 0).toDouble()),
          ]),
        ],
      );
    }

    // If userLevelId != 1, data will be specific to the tab type
    if (currentTabData is Shaobj) {
      final data = currentTabData as Shaobj;
      return ReusableBarTabCard(
        inRow: true,
        isHighlighted: true,
        totalshakhaa: data.shaakhaaCount,
        todayShakhaa: data.todayShaakhaaCount,
        yesterdayShakhaa: data.yesterdayShaakhaaCount,
        mainLabel: Statics.getLabel("shakhaaTulna"),
      );
    }

    if (currentTabData is Weekobj) {
      final data = currentTabData as Weekobj;
      return Column(
        spacing: 8,
        children: [
          ReusableBarTabCard(
            inRow: true,
            isHighlighted: true,
            totalshakhaa: data.shaakhaaCount,
            todayShakhaa: data.thisWeekShaakhaaCount,
            yesterdayShakhaa: data.lastWeekShaakhaaCount,
            mainLabel: Statics.getLabel("shakhaaTulna"),
            currentLabel: Statics.getLabel("currentWeekShakhaa"),
            lastLabel: Statics.getLabel("previousWeekShakhaa"),
            currentTotalLabel: Statics.getLabel("thisWeekTotalShakhaa"),
          ),
          ReusableBarTabCard(
            inRow: true,
            isHighlighted: true,
            totalshakhaa: data.shaapthahikCount,
            todayShakhaa: data.thisWeekShaapthahikCount,
            yesterdayShakhaa: data.lastWeekShaapthahikCount,
            mainLabel: Statics.getLabel('weeklyShakhaaTulna'),
            currentLabel: Statics.getLabel("currentWeekMilan"),
            lastLabel: Statics.getLabel('previousWeekMilan'),
            totalLabel: Statics.getLabel("totalMilanSampann"),
          )
        ],
      );
    }

    if (currentTabData is Monthobj) {
      final data = currentTabData as Monthobj;
      return Column(
        spacing: 8,
        children: [
          ReusableBarTabCard(
            inRow: true,
            isHighlighted: true,
            totalshakhaa: data.shaakhaaCount,
            todayShakhaa: data.thisMonthShaakhaaCount,
            yesterdayShakhaa: data.lastMonthShaakhaaCount,
            mainLabel: Statics.getLabel("shakhaaTulna"),
            currentLabel: "$thisMonthName ${Statics.getLabel('fromMonthShaakha')} ${Statics.getLabel("onBasisOfNityaVrutta")}",
            lastLabel: "$prevMonthName ${Statics.getLabel('fromMonthShaakha')} ${Statics.getLabel("onBasisOfNityaVrutta")}",
            currentTotalLabel: Statics.getLabel("todayShaakhaaMonthCount"),
            note: Statics.getLabel("lessThan15Tip"),
            rows: [
              BarRow(
                label: "$prevofPrevMonthName ${Statics.getLabel('fromMonthShaakha')} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                maxValue: (data.shaapthahikCount ?? 0).toDouble(),
                mainSegment: BarSegment(
                  label: Statics.getLabel("moreThan15"),
                  value: (data.prevofprevmonthshakha ?? 0).toDouble(),
                  color: const Color(0xFF5000CA),
                ),
                otherSegments: [
                  BarSegment(
                    label: Statics.getLabel("lessThan15"),
                    value: (data.prevofprevmonthshakhaplusone ?? 0).toDouble(),
                    color: const Color(0xFFAE7BF6),
                  )
                ],
              ),
              BarRow(
                label: "$prevMonthName ${Statics.getLabel('fromMonthShaakha')} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                maxValue: (data.shaapthahikCount ?? 0).toDouble(),
                mainSegment: BarSegment(
                  label: Statics.getLabel("moreThan15"),
                  value: (data.prevmonthshakha ?? 0).toDouble(),
                  color: const Color(0xFFA10000),
                ),
                otherSegments: [
                  BarSegment(
                    label: Statics.getLabel("lessThan15"),
                    value: (data.prevmonthshakhaplusone ?? 0).toDouble(),
                    color: const Color(0xFFF17878),
                  )
                ],
              ),
            ],
          ),
          ReusableBarTabCard(
            inRow: true,
            isHighlighted: true,
            totalshakhaa: data.shaapthahikCount,
            todayShakhaa: data.thisMonthShaapthahikCount,
            yesterdayShakhaa: data.lastMonthShaapthahikCount,
            mainLabel: Statics.getLabel('weeklyShakhaaTulna'),
            currentLabel: "$thisMonthName ${Statics.getLabel("fromMonthSaptahik")} ${Statics.getLabel("onBasisOfNityaVrutta")}",
            lastLabel: "$prevMonthName ${Statics.getLabel('fromMonthSaptahik')} ${Statics.getLabel("onBasisOfNityaVrutta")}",
            totalLabel: Statics.getLabel("totalMilanSampann"),
            currentTotalLabel: Statics.getLabel("thisMonthTotalShaapthahikCount"),
            note: Statics.getLabel("lessThan3Tip"),
            rows: [
              BarRow(
                label: "$prevofPrevMonthName ${Statics.getLabel('fromMonthSaptahik')} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                maxValue: (data.shaapthahikCount ?? 0).toDouble(),
                mainSegment: BarSegment(
                  label: Statics.getLabel("moreThan3"),
                  value: (data.prevofprevmonthmilan ?? 0).toDouble(),
                  color: const Color(0xFF5000CA),
                ),
                otherSegments: [
                  BarSegment(
                    label: Statics.getLabel("lessThan3"),
                    value: (data.prevofprevmonthmilanplusone ?? 0).toDouble(),
                    color: const Color(0xFFAE7BF6),
                  )
                ],
              ),
              BarRow(
                label: "$prevMonthName ${Statics.getLabel('fromMonthSaptahik')} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                maxValue: (data.shaapthahikCount ?? 0).toDouble(),
                mainSegment: BarSegment(
                  label: Statics.getLabel("moreThan3"),
                  value: (data.prevmonthmilan ?? 0).toDouble(),
                  color: const Color(0xFFA10000),
                ),
                otherSegments: [
                  BarSegment(
                    label: Statics.getLabel("lessThan3"),
                    value: (data.prevmonthmilanplusone ?? 0).toDouble(),
                    color: const Color(0xFFF17878),
                  )
                ],
              ),
            ],
          ),
          ReusableBarTabCard(
            inRow: true,
            isHighlighted: true,
            totalshakhaa: data.mandaliCount,
            todayShakhaa: data.thisMonthMandaliCount,
            yesterdayShakhaa: data.lastMonthMandaliCount,
            mainLabel: Statics.getLabel('shaakhaamandaliCount'),
            currentLabel: "$thisMonthName ${Statics.getLabel("fromMonthSangha")} ${Statics.getLabel("onBasisOfNityaVrutta")}",
            lastLabel: "$prevMonthName ${Statics.getLabel('fromMonthSangha')} ${Statics.getLabel("onBasisOfNityaVrutta")}",
            totalLabel: Statics.getLabel("totalshaakhaamandaliCount"),
            currentTotalLabel: Statics.getLabel("thisMonthTotalMandaliCount"),
            rows: [
              BarRow(
                label: "$prevofPrevMonthName ${Statics.getLabel('fromMonthSangha')} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                maxValue: (data.shaapthahikCount ?? 0).toDouble(),
                mainSegment: BarSegment(
                  label: "$prevofPrevMonthName ${Statics.getLabel('fromMonthSangha')} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                  value: (data.prevofprevmonthsanga ?? 0).toDouble(),
                  color: const Color(0xFFB08BE8),
                ),
              ),
              BarRow(
                label: "$prevMonthName ${Statics.getLabel('fromMonthSangha')} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                maxValue: (data.shaapthahikCount ?? 0).toDouble(),
                mainSegment: BarSegment(
                  label: "$prevMonthName ${Statics.getLabel('fromMonthSangha')} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                  value: (data.prevmonthsanga ?? 0).toDouble(),
                  color: const Color(0xFFE67171),
                ),
              ),
            ],
          ),
          ReusableBarTabCard(
            inRow: true,
            isHighlighted: true,
            totalshakhaa: data.masikCount,
            todayShakhaa: data.thisMonthMasikCount,
            yesterdayShakhaa: data.lastMonthMasikCount,
            mainLabel: Statics.getLabel('masikCount'),
            currentLabel: "$thisMonthName ${Statics.getLabel("fromMonthMasik")} ${Statics.getLabel("onBasisOfNityaVrutta")}",
            lastLabel: "$prevMonthName ${Statics.getLabel('fromMonthMasik')} ${Statics.getLabel("onBasisOfNityaVrutta")}",
            totalLabel: Statics.getLabel("totalmasikCount"),
            currentTotalLabel: Statics.getLabel("thisMonthTotalMasikCount"),
            rows: [
              BarRow(
                label: "$prevofPrevMonthName ${Statics.getLabel('fromMonthMasik')} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                maxValue: (data.shaapthahikCount ?? 0).toDouble(),
                mainSegment: BarSegment(
                  label: "$prevofPrevMonthName ${Statics.getLabel('fromMonthMasik')} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                  value: (data.prevofprevmonthmaansik ?? 0).toDouble(),
                  color: const Color(0xFFB08BE8),
                ),
              ),
              BarRow(
                label: "$prevMonthName ${Statics.getLabel('fromMonthMasik')} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                maxValue: (data.shaapthahikCount ?? 0).toDouble(),
                mainSegment: BarSegment(
                  label: "$prevMonthName ${Statics.getLabel('fromMonthMasik')} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                  value: (data.prevmonthmaansik ?? 0).toDouble(),
                  color: const Color(0xFFE67171),
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (currentTabData is Yearobj) {
      final data = currentTabData as Yearobj;

      return Column(
        spacing: 8,
        children: [
          ReusableBarTabCard(
            inRow: true,
            isHighlighted: true,
            totalshakhaa: data.shaakhaaCount,
            todayShakhaa: data.thisYearShaakhaaCount,
            yesterdayShakhaa: data.lastYearShaakhaaCount,
            mainLabel: Statics.getLabel("shakhaaTulna"),
            currentLabel: "$thisstartoendname ${Statics.getLabel("thisYearCount")} ${Statics.getLabel("onBasisOfNityaVrutta")}",
            lastLabel: "$laststarttoendname ${Statics.getLabel("prevYearCount")} ${Statics.getLabel("onBasisOfNityaVrutta")}",
            currentTotalLabel: Statics.getLabel("thisYearTotalCount"),
            note: Statics.getLabel("lessThan15Tip"),
            rows: [
              BarRow(
                label: "$prevYearName ${Statics.getLabel("YearsShaakhaaCount")} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                maxValue: (data.shaapthahikCount ?? 0).toDouble(),
                mainSegment: BarSegment(
                  label: Statics.getLabel("moreThan15"),
                  value: (data.prevofprevyearshakha ?? 0).toDouble(),
                  color: const Color(0xFF5000CA),
                ),
                otherSegments: [
                  BarSegment(
                    label: Statics.getLabel("lessThan15"),
                    value: (data.prevofprevyearshakhaplusone ?? 0).toDouble(),
                    color: const Color(0xFFAE7BF6),
                  )
                ],
              ),
              BarRow(
                label: "$thisYearName ${Statics.getLabel("YearsShaakhaaCount")} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                maxValue: (data.shaapthahikCount ?? 0).toDouble(),
                mainSegment: BarSegment(
                  label: Statics.getLabel("moreThan15"),
                  value: (data.prevyearshakha ?? 0).toDouble(),
                  color: const Color(0xFFA10000),
                ),
                otherSegments: [
                  BarSegment(
                    label: Statics.getLabel("lessThan15"),
                    value: (data.prevyearshakhaplusone ?? 0).toDouble(),
                    color: const Color(0xFFF17878),
                  )
                ],
              ),
            ],
          ),
          ReusableBarTabCard(
            inRow: true,
            isHighlighted: true,
            totalshakhaa: data.shaapthahikCount,
            todayShakhaa: data.thisYearShaapthahikCount,
            yesterdayShakhaa: data.lastYearShaapthahikCount,
            mainLabel: Statics.getLabel('weeklyShakhaaTulna'),
            currentLabel: "$thisstartoendname ${Statics.getLabel("thisYearShaapthahikCount")} ${Statics.getLabel("onBasisOfNityaVrutta")}",
            lastLabel: "$laststarttoendname ${Statics.getLabel('lastYearShaapthahikCount')} ${Statics.getLabel("onBasisOfNityaVrutta")}",
            totalLabel: Statics.getLabel("totalYearshaapthahikCount"),
            currentTotalLabel: Statics.getLabel("thisYearTotalShaapthahikCount"),
            note: Statics.getLabel("lessThan3Tip"),
            rows: [
              BarRow(
                label: "$prevYearName ${Statics.getLabel("YearsSaptikCount")} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                maxValue: (data.shaapthahikCount ?? 0).toDouble(),
                mainSegment: BarSegment(
                  label: Statics.getLabel("moreThan3"),
                  value: (data.prevofprevyearmilan ?? 0).toDouble(),
                  color: const Color(0xFF5000CA),
                ),
                otherSegments: [
                  BarSegment(
                    label: Statics.getLabel("lessThan3"),
                    value: (data.prevofprevyearmilanplusone ?? 0).toDouble(),
                    color: const Color(0xFFAE7BF6),
                  )
                ],
              ),
              BarRow(
                label: "$thisYearName ${Statics.getLabel('YearsSaptikCount')} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                maxValue: (data.shaapthahikCount ?? 0).toDouble(),
                mainSegment: BarSegment(
                  label: Statics.getLabel("moreThan3"),
                  value: (data.prevyearmilan ?? 0).toDouble(),
                  color: const Color(0xFFA10000),
                ),
                otherSegments: [
                  BarSegment(
                    label: Statics.getLabel("lessThan3"),
                    value: (data.prevyearmilanplusone ?? 0).toDouble(),
                    color: const Color(0xFFF17878),
                  )
                ],
              ),
            ],
          ),
          ReusableBarTabCard(
            inRow: true,
            isHighlighted: true,
            totalshakhaa: data.mandaliCount,
            todayShakhaa: data.thisYearMandaliCount,
            yesterdayShakhaa: data.lastYearMandaliCount,
            mainLabel: Statics.getLabel('shaakhaamandaliCount'),
            currentLabel: "$thisstartoendname ${Statics.getLabel("thisYearMandaliCount")} ${Statics.getLabel("onBasisOfNityaVrutta")}",
            lastLabel: "$laststarttoendname ${Statics.getLabel('lastYearMandaliCount')} ${Statics.getLabel("onBasisOfNityaVrutta")}",
            totalLabel: Statics.getLabel("totalYearshaakhaamandaliCount"),
            currentTotalLabel: Statics.getLabel("thisYearTotalMandaliCount"),
            rows: [
              BarRow(
                label: "$prevYearName ${Statics.getLabel("YearsSanghaCount")} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                maxValue: (data.shaapthahikCount ?? 0).toDouble(),
                mainSegment: BarSegment(
                  label: "$prevYearName ${Statics.getLabel("YearsSanghaCount")} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                  value: (data.prevofprevyearsanga ?? 0).toDouble(),
                  color: const Color(0xFFB08BE8),
                ),
              ),
              BarRow(
                label: "$thisYearName ${Statics.getLabel('YearsSanghaCount')} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                maxValue: (data.shaapthahikCount ?? 0).toDouble(),
                mainSegment: BarSegment(
                  label: "$thisYearName ${Statics.getLabel('YearsSanghaCount')} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                  value: (data.prevyearsanga ?? 0).toDouble(),
                  color: const Color(0xFFE67171),
                ),
              ),
            ],
          ),
          ReusableBarTabCard(
            inRow: true,
            isHighlighted: true,
            totalshakhaa: data.masikCount,
            todayShakhaa: data.thisYearMasikCount,
            yesterdayShakhaa: data.lastYearMasikCount,
            mainLabel: Statics.getLabel('masikCount'),
            currentLabel: "$thisstartoendname ${Statics.getLabel("thisYearMasikCount")} ${Statics.getLabel("onBasisOfNityaVrutta")}",
            lastLabel: "$laststarttoendname ${Statics.getLabel('lastYearMasikCount')} ${Statics.getLabel("onBasisOfNityaVrutta")}",
            totalLabel: Statics.getLabel("totalYearmasikCount"),
            currentTotalLabel: Statics.getLabel("thisYearTotalMasikCount"),
            rows: [
              BarRow(
                label: "$prevYearName ${Statics.getLabel("YearsMasikCount")} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                maxValue: (data.shaapthahikCount ?? 0).toDouble(),
                mainSegment: BarSegment(
                  label: "$prevYearName ${Statics.getLabel("YearsMasikCount")} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                  value: (data.prevofprevyearmaansik ?? 0).toDouble(),
                  color: const Color(0xFFB08BE8),
                ),
              ),
              BarRow(
                label: "$thisYearName ${Statics.getLabel('YearsMasikCount')} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                maxValue: (data.shaapthahikCount ?? 0).toDouble(),
                mainSegment: BarSegment(
                  label: "$thisYearName ${Statics.getLabel('YearsMasikCount')} ${Statics.getLabel("onBasisOfMasikVrutta")}",
                  value: (data.prevyearmaansik ?? 0).toDouble(),
                  color: const Color(0xFFE67171),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return _buildNoData();
  }

  Widget _attendanceCard({
    required String title,
    required String previousLabel,
    required String thisLabel,
    required List<AttendanceData> data,
    Color? color,
  }) {
    // Chart height scales with number of categories
    final double chartHeight = data.length * 120.0 + 60.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card header ──────────────────────────
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.groups_outlined, color: Color(0xFF1565C0), size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Horizontal bar chart ─────────────────
          SizedBox(
            height: chartHeight,
            width: MediaQuery.sizeOf(context).width,
            child: HorizontalBarChart(
              data: data,
              showEditIcon: false,

              // 1. Customize the Text dynamically
              tooltipTextBuilder: (selectedData, isYesterday) {
                String timeLabel = Statics.getLabel(isYesterday ? previousLabel : thisLabel, returnKey: true);

                double val = isYesterday ? selectedData.yesterday : selectedData.today;
                return '${selectedData.label} \n\t $timeLabel -> $val';
              },
            ),
          ),

          const SizedBox(height: 16),

          // ── Legend ───────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LegendDot(color: color ?? Color(0xFFE68449), label: Statics.getLabel(previousLabel, returnKey: true), bold: false),
              SizedBox(width: 24),
              LegendDot(color: color ?? Color(0xFF1565C0), label: Statics.getLabel(thisLabel, returnKey: true), bold: true),
            ],
          ),
        ],
      ),
    );
  }

  // ── 6. Yesterday vrutt summary table ─────────────────────────────────────
  Widget _buildYesterdaySummaryTable(List data) {
    if (data.isEmpty) return _buildNoData();
    final fcHeader = _summaryFirstColumnHeader();
    return ScrollableDataTable(
      leftFixedHeaders: [
        fcHeader,
      ],
      leftFixedRows: data.asMap().entries.map((e) {
        final item = e.value;
        final isTotal = e.key == data.length - 1;
        return DataRow(
          color: isTotal ? _totalRowColor() : null,
          cells: [
            customDataRowCell(item.geoUnitName ?? ''),
          ],
        );
      }).toList(),
      headers: [
        Statics.getLabel('Vayogat'),
        Statics.getLabel('Shaakhaa'),
        Statics.getLabel('SaaptaahikMilan'),
        Statics.getLabel('MilanMandali'),
      ],
      rows: data.asMap().entries.map((e) {
        final item = e.value;
        final isTotal = e.key == data.length - 1;
        return DataRow(
          color: isTotal ? _totalRowColor() : null,
          cells: [
            customDataRowCell('${item.vayogatCode}'),
            customDataRowCell('${item.shaakhaaCount}'),
            customDataRowCell('${item.saaptaahikCount}'),
            customDataRowCell('${item.milanMandaliCount}'),
          ],
        );
      }).toList(),
    );
  }

  // ── 7. Yesterday vrutt detail table ──────────────────────────────────────
  Widget _buildYesterdayDetailTable(List data) {
    if (data.isEmpty) return _buildNoData();
    return ScrollableDataTable(
      leftFixedHeaders: [
        Statics.getLabel('GeoUnitName'),
      ],
      leftFixedRows: data.asMap().entries.map((e) {
        final item = e.value;
        final isTotal = e.key == data.length - 1;
        return DataRow(
          color: isTotal ? _totalRowColor() : null,
          cells: [
            customDataRowCell(item.geoUnitName ?? ''),
          ],
        );
      }).toList(),
      headers: [
        Statics.getLabel('FrequencyCode'),
        Statics.getLabel('VayogatCode'),
        Statics.getLabel('BaalCount'),
        Statics.getLabel('TarunVidyaarthiCount'),
        Statics.getLabel('TarunVyavasaayeeCount'),
        Statics.getLabel('ProudhaCount'),
        Statics.getLabel('ShishuCount'),
        Statics.getLabel('AbhyaagatCount'),
      ],
      rows: data.asMap().entries.map((e) {
        final item = e.value;
        final isTotal = e.key == data.length - 1;
        return DataRow(
          color: isTotal ? _totalRowColor() : null,
          cells: [
            customDataRowCell('${item.frequencyCode}'),
            customDataRowCell('${item.vayogatCode}'),
            customDataRowCell('${item.baalVidyaarthiCount}'),
            customDataRowCell('${item.tarunVidyaarthiCount}'),
            customDataRowCell('${item.tarunVyavasaayeeCount}'),
            customDataRowCell('${item.proudhaVyavasaayeeCount}'),
            customDataRowCell('${item.shishuCount}'),
            customDataRowCell('${item.abhyaagatCount}'),
          ],
        );
      }).toList(),
    );
  }

  String _summaryFirstColumnHeader() {
    if (_tgLevelID > 7) return Statics.getLabel('Bhaag');
    if (_tgLevelID == 7) return Statics.getLabel('Nagar');
    if (_tgLevelID == 6) return Statics.getLabel('Mandal/Vasti');
    if (_tgLevelID == 5) return Statics.getLabel('Nagar/Vasti');
    if (_tgLevelID == 4) return Statics.getLabel('Graam');
    return Statics.getLabel('Shaakhaa');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EXCEL EXPORT (unchanged logic, same as before)
  // ═══════════════════════════════════════════════════════════════════════════

  void _showExcelDownloadDialog(UpkhandaDataList data) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(Statics.getLabel('AskConfirmation')),
        content: Text("${Statics.getLabel("selectedLevel")} -> ${data.goUnitName}"),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: Text(Statics.getLabel("downloadBtn"), style: const TextStyle(color: Colors.white)),
            onPressed: () async {
              Navigator.of(ctx).pop();
              setState(() => bhougolikReportForExcel = null);
              bhougolikReportForExcel = await Statics.upkhandUpnagarReportForExcelData(
                userID: Statics.userDetails["userID"],
                targetGeoUnitID: data.geoUnitId,
                context: context,
              );
              setState(() {});
              final list = bhougolikReportForExcel?.datanameList;
              if (list != null && list.isNotEmpty) {
                await buildExcelFromData3(geoHierarchyData: bhougolikReportForExcel!.toJson()["GeoHierarchyData"]);
              } else {
                Fluttertoast.showToast(msg: Statics.getLabel("errorOccurred"), gravity: ToastGravity.BOTTOM);
              }
            },
          ),
          TextButton(
            child: Text(Statics.getLabel('clear')),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> buildExcelFromData3({required List<Map<String, dynamic>> geoHierarchyData}) async {
    if (geoHierarchyData.isEmpty) {
      throw ArgumentError('No data rows provided.');
    }

    /// Workbook + sheet
    final xls.Workbook wb = xls.Workbook();
    final xls.Worksheet _sheet = wb.worksheets[0];
    // Assuming Statics is available in your file
    _sheet.name = Statics.getLabel('bhougolikExcelReport');

    /// Styles
    final headerStyle = wb.styles.add('Header')
      ..bold = true
      ..hAlign = xls.HAlignType.center
      ..vAlign = xls.VAlignType.center
      ..borders.all.lineStyle = xls.LineStyle.thin
      ..backColor = '#E8E8E8';

    final _cellStyle = wb.styles.add('Cell')
      ..borders.all.lineStyle = xls.LineStyle.thin
      ..hAlign = xls.HAlignType.center
      ..vAlign = xls.VAlignType.center;

    final boldCellStyle = wb.styles.add('BoldCell')
      ..bold = true
      ..hAlign = xls.HAlignType.center
      ..vAlign = xls.VAlignType.center
      ..borders.all.lineStyle = xls.LineStyle.medium;

    final blankRowStyle = wb.styles.add('BlankRow')
      ..bold = true
      ..borders.all.lineStyle = xls.LineStyle.medium
      ..hAlign = xls.HAlignType.center
      ..vAlign = xls.VAlignType.center
      ..backColor = '#D6E3BC';

    /// Define columns explicitly to ensure consistent order
    final List<String> headers = [
      'NagarName',
      'UpnagarName',
      'MappedVastis',
      'UpkhandName',
      'MandalName',
      'GraamNames',
    ];

    int _colForSheet = 1;

    /// Header row
    _sheet.getRangeByIndex(1, _colForSheet).setText('Sr No');
    _sheet.getRangeByIndex(1, _colForSheet, 2, _colForSheet).cellStyle = headerStyle;
    _colForSheet++;

    for (final header in headers) {
      _sheet.getRangeByIndex(1, _colForSheet).setText(Statics.getLabel(header));
      _sheet.getRangeByIndex(1, _colForSheet).cellStyle = headerStyle;
      _colForSheet++;
    }

    int rowIndex = 2;
    int srNo = 1;

    for (int dataIndex = 0; dataIndex < geoHierarchyData.length; dataIndex++) {
      final data = geoHierarchyData[dataIndex];
      final String nagarName = data['NagarName']?.toString() ?? '--';

      // 1. FLATTEN THE DEEP HIERARCHY FOR THIS SPECIFIC NAGAR
      List<Map<String, String>> nagarRows = [];

      // Sets to count unique occurrences of parent nodes
      Set<String> uniqueUpkhands = {};
      Set<String> uniqueMandals = {};
      int countGrams = 0;

      Set<String> uniqueUpnagars = {};
      int countMappedVastis = 0;

      bool hasUpkhands = data['Upkhands'] is List && (data['Upkhands'] as List).isNotEmpty;
      bool hasUpnagars = data['Upnagars'] is List && (data['Upnagars'] as List).isNotEmpty;

      // Edge case: Nagar with no sub-data
      if (!hasUpkhands && !hasUpnagars) {
        nagarRows.add({
          'NagarName': nagarName,
          'UpnagarName': '--',
          'MappedVastis': '--',
          'UpkhandName': '--',
          'MandalName': '--',
          'GraamNames': '--',
        });
      }

      // Traverse Rural Hierarchy (Upkhands -> Mandals -> Grams)
      if (hasUpkhands) {
        final List<dynamic> upkhandsList = data['Upkhands'];

        for (dynamic u in upkhandsList) {
          String upkhandName = u is Map ? (u['UpkhandName']?.toString() ?? '--') : u.toString();
          if (upkhandName != '--' && upkhandName.isNotEmpty) {
            uniqueUpkhands.add(upkhandName);
          }

          final List<dynamic> mandals = (u['MappedMandals'] as List?)?.cast<dynamic>() ?? [];

          if (mandals.isEmpty) {
            nagarRows.add({
              'NagarName': nagarName,
              'UpnagarName': '--',
              'MappedVastis': '--',
              'UpkhandName': upkhandName,
              'MandalName': '--',
              'GraamNames': '--',
            });
          } else {
            for (dynamic m in mandals) {
              String mandalName = m is Map ? (m['MandalName']?.toString() ?? '--') : m.toString();
              if (mandalName != '--' && mandalName.isNotEmpty) {
                uniqueMandals.add(mandalName);
              }

              List<dynamic> grams = (m is Map && m['GraamNames'] is List) ? m['GraamNames'] : [];

              if (grams.isEmpty) {
                nagarRows.add({
                  'NagarName': nagarName,
                  'UpnagarName': '--',
                  'MappedVastis': '--',
                  'UpkhandName': upkhandName,
                  'MandalName': mandalName,
                  'GraamNames': '--',
                });
              } else {
                countGrams += grams.length;
                for (dynamic g in grams) {
                  nagarRows.add({
                    'NagarName': nagarName,
                    'UpnagarName': '--',
                    'MappedVastis': '--',
                    'UpkhandName': upkhandName,
                    'MandalName': mandalName,
                    'GraamNames': g != null && g.toString().trim().isNotEmpty ? g.toString() : "--",
                  });
                }
              }
            }
          }
        }
      }

      // Traverse Urban Hierarchy (Upnagars -> Vastis)
      if (hasUpnagars) {
        final List<dynamic> upnagarsList = data['Upnagars'];

        for (dynamic u in upnagarsList) {
          String upnagarName = u is Map ? (u['UpnagarName']?.toString() ?? '--') : u.toString();
          if (upnagarName != '--' && upnagarName.isNotEmpty) {
            uniqueUpnagars.add(upnagarName);
          }

          List<dynamic> vastis = (u is Map && u['MappedVastis'] is List) ? u['MappedVastis'] : [];

          if (vastis.isEmpty) {
            nagarRows.add({
              'NagarName': nagarName,
              'UpnagarName': upnagarName,
              'MappedVastis': '--',
              'UpkhandName': '--',
              'MandalName': '--',
              'GraamNames': '--',
            });
          } else {
            countMappedVastis += vastis.length;
            for (dynamic v in vastis) {
              String vastiName = v is Map ? (v['VastiName']?.toString() ?? '--') : v.toString();
              nagarRows.add({
                'NagarName': nagarName,
                'UpnagarName': upnagarName,
                'MappedVastis': vastiName != null && vastiName.trim().isNotEmpty ? vastiName : "--",
                'UpkhandName': '--',
                'MandalName': '--',
                'GraamNames': '--',
              });
            }
          }
        }
      }

      // 2. WRITE EXTRACTED ROWS TO EXCEL
      final int startRow = rowIndex;

      for (int i = 0; i < nagarRows.length; i++) {
        int writeCol = 1;
        // Only print Sr No on the first row of this block
        _sheet.getRangeByIndex(rowIndex, writeCol).setText(i == 0 ? srNo.toString() : '');
        _sheet.getRangeByIndex(rowIndex, writeCol).cellStyle = _cellStyle;
        writeCol++;

        for (final key in headers) {
          _sheet.getRangeByIndex(rowIndex, writeCol).setText(nagarRows[i][key] ?? '--');
          _sheet.getRangeByIndex(rowIndex, writeCol).cellStyle = _cellStyle;
          writeCol++;
        }
        rowIndex++;
      }

      final int endRow = rowIndex - 1;

      // 3. PERFORM VISUAL MERGES
      if (endRow > startRow) {
        _sheet.getRangeByIndex(startRow, 1, endRow, 1).merge(); // Sr No

        final int nagarCol = headers.indexOf('NagarName') + 2;
        _sheet.getRangeByIndex(startRow, nagarCol, endRow, nagarCol).merge(); // NagarName

        // Helper function to merge contiguous identical values vertically
        void tryMergeSubGroups(String keyName) {
          final int keyPos = headers.indexOf(keyName);
          if (keyPos < 0) return;
          final int col = keyPos + 2;

          int currentStart = startRow;
          String currentVal = nagarRows[0][keyName] ?? '--';

          for (int r = 1; r < nagarRows.length; r++) {
            final text = nagarRows[r][keyName] ?? '--';
            if (text != currentVal) {
              // Only merge if there's more than 1 row with the same value
              if (r - 1 > currentStart - startRow) {
                _sheet.getRangeByIndex(currentStart, col, startRow + r - 1, col).merge();
              }
              currentStart = startRow + r;
              currentVal = text;
            }
          }
          // Merge the final grouping
          if (endRow > currentStart) {
            _sheet.getRangeByIndex(currentStart, col, endRow, col).merge();
          }
        }

        tryMergeSubGroups('UpkhandName');
        tryMergeSubGroups('MandalName');
        tryMergeSubGroups('UpnagarName');

        // We only merge leaf nodes (Graams/Vastis) if they are entirely empty '--'
        bool allGramsEmpty = nagarRows.every((r) => r['GraamNames'] == '--');
        if (allGramsEmpty) {
          final int col = headers.indexOf('GraamNames') + 2;
          _sheet.getRangeByIndex(startRow, col, endRow, col).merge();
        }

        bool allVastisEmpty = nagarRows.every((r) => r['MappedVastis'] == '--');
        if (allVastisEmpty) {
          final int col = headers.indexOf('MappedVastis') + 2;
          _sheet.getRangeByIndex(startRow, col, endRow, col).merge();
        }
      }

      // 4. WRITE THE TOTAL ROW
      Map<String, int> finalCounts = {
        'UpnagarName': uniqueUpnagars.length,
        'MappedVastis': countMappedVastis,
        'UpkhandName': uniqueUpkhands.length,
        'MandalName': uniqueMandals.length,
        'GraamNames': countGrams,
      };

      _sheet.getRangeByIndex(rowIndex, 1, rowIndex, 2).merge(); // Sr No & NagarName combined
      _sheet.getRangeByIndex(rowIndex, 1).setText('Total');
      _sheet.getRangeByIndex(rowIndex, 1, rowIndex, 2).cellStyle = boldCellStyle..backColor = '#D6E3BC';

      for (int i = 0; i < headers.length; i++) {
        final key = headers[i];
        final col = i + 2;

        if (finalCounts.containsKey(key)) {
          // Output counts. Treat 0 as '--' or keep it as 0 based on preference (Setting to Number handles Excel formatting)
          _sheet.getRangeByIndex(rowIndex, col).setNumber(finalCounts[key]!.toDouble());
        } else {
          _sheet.getRangeByIndex(rowIndex, col).setText('');
        }
        _sheet.getRangeByIndex(rowIndex, col).cellStyle = blankRowStyle;
      }

      rowIndex++; // leave one blank row space after total
      srNo++;
    }

    // Auto-fit columns
    for (int c = 1; c <= headers.length + 1; c++) {
      _sheet.autoFitColumn(c);
    }

    /// Save + open
    try {
      final _path = await _getDirectoryPathFun(); // Function assumed available in scope
      final file = File(_path);

      final bytes = wb.saveAsStream();
      wb.dispose();

      await file.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);

      final result = await OpenFilex.open(file.path);

      // Check result type
      if (result.type != ResultType.done) {
        String message;
        switch (result.type) {
          case ResultType.noAppToOpen:
            message = Statics.getLabel("noExcelAppFoundError");
            break;
          case ResultType.error:
            message = Statics.getLabel("errorOccurred");
            break;
          case ResultType.permissionDenied:
            message = Statics.getLabel("noPermissionGiven");
            break;
          default:
            message = Statics.getLabel("unableToOpenFile");
        }

        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excel file saved and opened: $_path')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export file: $e')),
      );
    }

    wb.dispose();
  }

  Future<String> _getDirectoryPathFun() async {
    Directory? dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download');

      if (!await dir.exists()) {
        dir = await getExternalStorageDirectory();
      }
    } else {
      dir = await getApplicationDocumentsDirectory();
    }
    final ts = DateTime.now().toIso8601String().replaceAll(':', '-').split(".").first;
    final path = '${dir!.path}/${_selctedLevelName ?? "prant"}_${Statics.getLabel("bhougolikExcelReport")}_$ts.xlsx';
    log(path);
    return path;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        DateTime now = DateTime.now();
        if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(
            msg: 'Press again to exit',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color.fromARGB(255, 92, 92, 92),
            textColor: const Color.fromARGB(255, 255, 255, 255),
          );

          return;
        }
        exit(1);
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(Statics.getLabel('homeScreenTitle'), style: const TextStyle(fontSize: 20)),
            bottom: TabBar(
              unselectedLabelStyle: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
              labelStyle: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
              onTap: (value) {
                if (value == 1) {
                  _initScreen();
                }
              },
              tabs: [
                Tab(text: Statics.getLabel('mainScreenTab2')),
                Tab(text: Statics.getLabel('menu')),
              ],
            ),
            actions: [
              // Notification bell with badge
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotificationListPage(userId: Statics.userDetails['userID']),
                        ),
                      ).then((_) => _fetchNotificationData());
                      setState(() {});
                    },
                  ),
                  if (notificationListdata?.notificationcount != "null" && notificationListdata?.notificationcount != '0' && notificationListdata?.notificationcount != '')
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text('${notificationListdata?.notificationcount}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      ),
                    ),
                ],
              ),
              PopupMenuButton<MenuChoices>(
                onSelected: _onMenuSelected,
                icon: const Icon(Icons.settings),
                itemBuilder: (ctx) => choices.map((c) => PopupMenuItem(value: c, child: ListTile(leading: Icon(c.icon), title: Text(c.menuText!)))).toList(),
              ),
            ],
          ),
          drawer: AppDrawer(),
          body: TabBarView(
            children: [
              _buildDashboardTab(),
              _buildMenuTab(),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 1 – MENU
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildMenuTab() {
    return ModalProgressHUD(
      inAsyncCall: _isSearching,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: Statics.getDeviceSize(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _userHeader(),
              const SizedBox(height: 30),
              shatabdiVrutaCard(),
              const SizedBox(height: 27),
              surveyCard(),
              const SizedBox(height: 27),
              moreCard(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 2 – DASHBOARD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildDashboardTab() {
    return ModalProgressHUD(
      inAsyncCall: _isSearching,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: Statics.getDeviceSize(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _userHeader(),
              const SizedBox(height: 20),

              if (userLevelId == 1) ...[
                const SizedBox(height: 24),
                _cardTile(
                  Statics.getLabel('searchShaakhaaScreenLabel'),
                  () => Navigator.of(context).pushNamed(ShaakhaMainTabScreen.routeName),
                  makeHighlight: true,
                ),
                const SizedBox(height: 18),
              ],

              // ── Yesterday Praant ───────────────────────────────────────────
              Legend(legendString: "MyGeoVruttaData", fontsize: 18),
              _isReportSearching ? const CircularProgressIndicator() : _buildYesterdayPraantTable(),
              const SizedBox(height: 15),

              // ── My Geo Unit details (expansion) ───────────────────────────
              _myGeoUnitPanel(),
              const SizedBox(height: 10),

              if (userLevelId != 1) ...[
                // ── Target Geo Unit details (expansion) ───────────────────────
                _targetGeoUnitPanel(),
                const SizedBox(height: 15),

                if ((userLevelId ?? 0) > 8) ...[
                  // ── Bhaugolik rachana (expansion) ─────────────────────────────
                  _bhaugolikRachanaPanel(),
                  const SizedBox(height: 15),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ─── Shared user header ───────────────────────────────────────────────────
  Widget _userHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(
            child: Text(
              '${Statics.userDetails['FullName']}, ${Statics.userDetails['MobileNumber']}',
              style: const TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ]),
        Wrap(spacing: 5, children: [
          Text(Statics.userDetails['DaayitvaGeoUnitName'], style: const TextStyle(fontSize: 12)),
          Text(Statics.userDetails['LevelName'], style: const TextStyle(fontSize: 12)),
          Text('$userDaayitvaNameforshow', style: const TextStyle(fontSize: 12)),
        ]),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EXPANSION PANELS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _bhaugolikRachanaPanel() {
    return ExpansionPanelList(
      expansionCallback: (_, isExpanded) => setState(() => _isNagarTableExpanded = isExpanded),
      children: [
        ExpansionPanel(
          isExpanded: _isNagarTableExpanded,
          headerBuilder: (_, __) => ListTile(title: Text(Statics.getLabel('prantachiBhaugolikRachanaa'))),
          body: Container(
            margin: const EdgeInsets.all(20),
            child: Column(children: [
              // Clear + dropdowns
              Align(
                alignment: Alignment.centerRight,
                child: _clearButton(() {
                  setState(() {
                    _linkedMahaanagarValue2 = _linkedVibhaagValue2 = null;
                    _linkedMahaanagar2 = _linkedVibhaag2 = null;
                    _selctedLevelName = Statics.getLabel("praant");
                  });
                  _populateDropdownSet2();
                  _getUpkhandUpnagarReport("0", "praant");
                }),
              ),
              if (_linkedMahaanagar2 != null)
                _dropdown(
                  label: Statics.getLabel('Mahaanagar'),
                  value: _linkedMahaanagarValue2 == "" ? null : _linkedMahaanagarValue2,
                  items: _linkedMahaanagar2!,
                  onChanged: (v) {
                    setState(() {
                      _linkedMahaanagarValue2 = v;
                      _selctedLevelName = Statics.getLabel("Mahaanagar");
                      _populateVibhaag2();
                      _getUpkhandUpnagarReport(v, "mahanagar");
                    });
                  },
                ),
              if (_linkedVibhaag2 != null)
                _dropdown(
                  label: Statics.getLabel('Vibhaag'),
                  value: _linkedVibhaagValue2 == "" ? null : _linkedVibhaagValue2,
                  items: _linkedVibhaag2!,
                  onChanged: (v) {
                    setState(() {
                      _linkedVibhaagValue2 = v;
                      _selctedLevelName = Statics.getLabel("Vibhaag");
                      _getUpkhandUpnagarReport(v, "vibhaag");
                    });
                  },
                ),
              const SizedBox(height: 18),
              _isLoading ? const CircularProgressIndicator() : _buildUpnagarCountDataTable(upkhandaDataList),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _myGeoUnitPanel() {
    return ExpansionPanelList(
      expansionCallback: (_, isExpanded) => setState(() => _isSwExpanded = isExpanded),
      children: [
        ExpansionPanel(
          isExpanded: _isSwExpanded,
          headerBuilder: (_, __) => ListTile(title: Text(Statics.getLabel('MyGeoUnitDetails'))),
          body: Container(
            margin: const EdgeInsets.all(20),
            child: _isMySearching ? const Center(child: CircularProgressIndicator()) : _buildMyGeoUnitContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildMyGeoUnitContent() {
    final isHighLevel = (int.tryParse(Statics.userDetails['LevelID'] ?? "0") ?? 0) > 6;
    return Column(children: [
      if (userLevelId != 1) ...[
        Legend(legendString: "yesterdayNews", fontsize: 18),
        if (isHighLevel) _buildYesterdaySummaryTable(Statics.lstYesterdayVruttaSummary) else _buildYesterdayDetailTable(Statics.lstYesterdayVruttaDetail),
        const SizedBox(height: 15),
        _vruttaSummarySection(
          shaakhaaEQ0: myShaakhaaEQ0,
          shaakhaa1To24: myShaakhaa1To24,
          shaakhaaGTE25: myShaakhaaGTE25,
          shaakhaaEQ30: myShaakhaaEQ30,
          saaptaahikEQ0: mySaaptaahikEQ0,
          saaptaahik1To3: mySaaptaahik1To3,
          saaptaahikGTE4: mySaaptaahikGTE4,
          maasikEQ0: myMaasikEQ0,
          maasikEQ1: myMaasikEQ1,
        ),
        const SizedBox(height: 15),
        Legend(legendString: "SankalpTable", fontsize: 18),
        _buildSadyasthitiTable(Statics.lstdashboardSadyaSthitiData),
        const SizedBox(height: 15),
        Legend(legendString: "NewSankalpTable", fontsize: 18),
        _buildSankalpByAadhaarTable(Statics.lstSankalpByAadhaarData),
        const SizedBox(height: 15),
        Legend(legendString: "BhaugolikVistaar", fontsize: 18),
        _buildBhaugolikTable(Statics.lstBhaugolikVistaar),
        const SizedBox(height: 15),
      ],
      Legend(legendString: "SwayamsevakCount", fontsize: 18, onPressed: () => showNamesList(type: "SwayamsevakCount")),
      SingleColumnRow(txtString: Statics.getLabel('TotalKaaryakartaaCount'), value: myTotalSwayamsevakCount, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('PratidnyitCount'), value: myPratidnyitCount, fontsize: 15),
      const SizedBox(height: 15),
      _swayamsevakCountByAge(
        shishu: myShishuCount,
        baal: myBaalCount,
        tarunV: myTarunVidyaarthiCount,
        tarunVy: myTarunVyavasaayeeCount,
        proudha: myProudhaVyavasaayeeCount,
        unknown: myUnknownAgeCount,
      ),
      const SizedBox(height: 15),
      _swayamsewakByBloodGroup(bloodgroup: _bloodgroup),
      const SizedBox(height: 15),
      _swayamsewakExperties(expertieslist: _expertieslist),
      const SizedBox(height: 15),
      _swayamsewakInfoWidget(infolist: _mothertonguelist, heading: 'MotherTongue'),
      const SizedBox(height: 15),
      _swayamsewakInterests(interestlist: _interestlist),
      const SizedBox(height: 15),
      _swayamsewakInfoWidget(infolist: _ghoshwadlist, heading: 'Ghoshwadak'),
      const SizedBox(height: 15),
      _swayamsewakInfoWidget(infolist: _sangayulist, heading: 'Sangayu'),
      const SizedBox(height: 15),
      _ganveshData == null ? SizedBox() : _swayamsewakUniform(ganvesh: _ganveshData!),
      const SizedBox(height: 15),
      _vehicle == null ? SizedBox() : _swayamsewakVehicle(vehicle: _vehicle!),
      const SizedBox(height: 15),
      _shikshanSection(
        prarambhik: myPraarambhikShikshitCount,
        praathamik: myPraathamikShikshitCount,
        prathamVarsha: myPrathamVarshaShikshitCount,
        dwitiya: myDwitiyaVarshaShikshitCount,
        trutiya: myTrutiyaVarshaShikshitCount,
        noShikshan: myNoShikshanCount,
      ),
      _kaaryakartaaByLevelSection(
        shaakhaa: myDailyShaakhaaKaaryakartaaCount,
        saptahik: mySaaptaahikMilanKaaryakartaaCount,
        milan: myMaasikMilanKaaryakartaaCount,
        vasti: myVastiKaaryakartaaCount,
        graam: myGraamKaaryakartaaCount,
        mandal: myMandalKaaryakartaaCount,
        nagar: myNagarKaaryakartaaCount,
        shahar: myShaharKaaryakartaaCount,
        bhaag: myBhaagKaaryakartaaCount,
        vibhaag: myVibhaagKaaryakartaaCount,
        mahaanagar: myMahaanagarKaaryakartaaCount,
        praant: myPraantKaaryakartaaCount,
        kshetra: myKshetraKaaryakartaaCount,
        akhilBhaarat: myAkhilBhaaratiyaKaaryakartaaCount,
        pravaasee: myPravaaseeKaaryakartaaCount,
        total: myTotalKaaryakartaaCount,
      ),
      Legend(legendString: "GatividhiAayaamSansthaaKaaryakartaaCount", fontsize: 18),
      SingleColumnRow(txtString: Statics.getLabel('GatividhiKaaryakartaaCount'), value: myGatividhiKaaryakartaaCount, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('AayaamKaaryakartaaCount'), value: myAayaamKaaryakartaaCount, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('SanghaPreritSansthaaKaaryakartaaCount'), value: mySanghaPreritSansthaaKaaryakartaaCount, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('SocialOrganizationKaaryakartaaCount'), value: mySocialOrganizationKaaryakartaaCount, fontsize: 15),
      const SizedBox(height: 15),
      Legend(legendString: "Gatividhi", fontsize: 18),
      _buildNameCountTable(
          data: Statics.lstGatividhiKaaryakartaa,
          nameHeader: Statics.getLabel('Gatividhi'),
          countHeader: Statics.getLabel('KaaryakartaaCount'),
          nameOf: (i) => i.gatividhiName ?? '',
          countOf: (i) => '${i.kaaryakartaaCount}'),
      const SizedBox(height: 15),
      Legend(legendString: "Aayaam", fontsize: 18),
      _buildNameCountTable(
          data: Statics.lstAayaamKaaryakartaa,
          nameHeader: Statics.getLabel('Aayaam'),
          countHeader: Statics.getLabel('KaaryakartaaCount'),
          nameOf: (i) => i.aayaamName ?? '',
          countOf: (i) => '${i.kaaryakartaaCount}'),
      const SizedBox(height: 15),
      Legend(legendString: "Sangha-PreritSansthaa", fontsize: 18),
      _buildNameCountTable(
          data: Statics.lstPreritKaaryakartaa,
          nameHeader: Statics.getLabel('AreaOfOperations'),
          countHeader: Statics.getLabel('KaaryakartaaCount'),
          nameOf: (i) => i.preritAOOName ?? '',
          countOf: (i) => '${i.kaaryakartaaCount}'),
      const SizedBox(height: 15),
      Legend(legendString: "OtherSocialOrganization", fontsize: 18),
      _buildNameCountTable(
          data: Statics.lstSocialOrgKaaryakartaa,
          nameHeader: Statics.getLabel('AreaOfOperations'),
          countHeader: Statics.getLabel('KaaryakartaaCount'),
          nameOf: (i) => i.mainAOOName ?? '',
          countOf: (i) => '${i.kaaryakartaaCount}'),
      const SizedBox(height: 15),
      Legend(legendString: "StudentCategory", fontsize: 18),
      _buildNameCountTable(
          data: Statics.lstStudentCategory,
          nameHeader: Statics.getLabel('StudentCategory'),
          countHeader: Statics.getLabel('SwayamsevakCount'),
          nameOf: (i) => i.studentCategoryName ?? '',
          countOf: (i) => '${i.countByStudentCategory}'),
      const SizedBox(height: 15),
      Legend(legendString: "VyavasaayeeCategory", fontsize: 18),
      _buildNameCountTable(
          data: Statics.lstVyavasaayeeCategory,
          nameHeader: Statics.getLabel('VyavasaayeeCategory'),
          countHeader: Statics.getLabel('SwayamsevakCount'),
          nameOf: (i) => i.vyavasaayeeCategoryName ?? '',
          countOf: (i) => '${i.countByVyavasaayeeCategory}'),
      const SizedBox(height: 15),
      if (userLevelId == 1)
        _vruttaSummarySection(
          shaakhaaEQ0: myShaakhaaEQ0,
          shaakhaa1To24: myShaakhaa1To24,
          shaakhaaGTE25: myShaakhaaGTE25,
          shaakhaaEQ30: myShaakhaaEQ30,
          saaptaahikEQ0: mySaaptaahikEQ0,
          saaptaahik1To3: mySaaptaahik1To3,
          saaptaahikGTE4: mySaaptaahikGTE4,
          maasikEQ0: myMaasikEQ0,
          maasikEQ1: myMaasikEQ1,
        ),
    ]);
  }

  Widget _targetGeoUnitPanel() {
    return Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
      return ExpansionPanelList(
        expansionCallback: (_, isExpanded) => setState(() => _isGeounitExpanded = isExpanded),
        children: [
          ExpansionPanel(
            isExpanded: _isGeounitExpanded,
            headerBuilder: (_, __) => ListTile(title: Text(Statics.getLabel('TargetGeoUnitDetails'))),
            body: Container(
              margin: const EdgeInsets.all(20),
              child: Column(children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: _clearButton(() {
                    ctrl.loadHierarchyForUser();
                    _fetchTargetDashboardData();
                  }),
                ),

                // if (ctrl.hasItems(GeoLevel.vibhaag))
                GeoDropdownWidget(
                  level: GeoLevel.Vibhaag,
                  title: 'Vibhaag',
                  controller: ctrl,
                  onChanged: (p0) => _fetchTargetDashboardData(),
                ),

                if (ctrl.hasItems(GeoLevel.Bhaag))
                  GeoDropdownWidget(
                    level: GeoLevel.Bhaag,
                    title: 'Bhaag',
                    controller: ctrl,
                    onChanged: (p0) => _fetchTargetDashboardData(),
                  ),

                if (ctrl.hasItems(GeoLevel.Nagar))
                  GeoDropdownWidget(
                    level: GeoLevel.Nagar,
                    title: 'Nagar',
                    controller: ctrl,
                    onChanged: (p0) => _fetchTargetDashboardData(),
                  ),

                /// CONDITIONAL
                if (ctrl.hasItems(GeoLevel.upnagarUpkhanda))
                  GeoDropdownWidget(
                    level: GeoLevel.upnagarUpkhanda,
                    title: 'upnagarUpkhanda',
                    controller: ctrl,
                    onChanged: (p0) => _fetchTargetDashboardData(),
                  ),

                if (ctrl.hasItems(GeoLevel.Mandal))
                  GeoDropdownWidget(
                    level: GeoLevel.Mandal,
                    title: 'Mandal',
                    controller: ctrl,
                    onChanged: (p0) => _fetchTargetDashboardData(),
                  ),

                if (ctrl.hasItems(GeoLevel.Graam))
                  GeoDropdownWidget(
                    level: GeoLevel.Graam,
                    title: 'Graam',
                    controller: ctrl,
                    onChanged: (p0) => _fetchTargetDashboardData(),
                  ),

                if (ctrl.hasItems(GeoLevel.Vasti))
                  GeoDropdownWidget(
                    level: GeoLevel.Vasti,
                    title: 'Vasti',
                    controller: ctrl,
                    onChanged: (p0) => _fetchTargetDashboardData(),
                  ),

                const SizedBox(height: 40),
                if (_isTgSearching) const CircularProgressIndicator() else _buildTargetGeoUnitContent(ctrl),
              ]),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTargetGeoUnitContent(GeoHierarchyController controller) {
    return Column(children: [
      Legend(legendString: "yesterdayNews", fontsize: 18),
      _buildYesterdaySummaryTable(Statics.tgLstYesterdayVruttaSummary),
      if (_tgLevelID <= 6) _buildYesterdayDetailTable(Statics.tgLstYesterdayVruttaDetail),
      const SizedBox(height: 15),
      _vruttaSummarySection(
        shaakhaaEQ0: _nullToZero(tgShaakhaaEQ0),
        shaakhaa1To24: _nullToZero(tgShaakhaa1To24),
        shaakhaaGTE25: _nullToZero(tgShaakhaaGTE25),
        shaakhaaEQ30: _nullToZero(tgShaakhaaEQ30),
        saaptaahikEQ0: _nullToZero(tgSaaptaahikEQ0),
        saaptaahik1To3: _nullToZero(tgSaaptaahik1To3),
        saaptaahikGTE4: _nullToZero(tgSaaptaahikGTE4),
        maasikEQ0: _nullToZero(tgMaasikEQ0),
        maasikEQ1: _nullToZero(tgMaasikEQ1),
      ),
      const SizedBox(height: 15),
      Legend(legendString: "SankalpTable", fontsize: 18),
      _buildSadyasthitiTable(Statics.tgLstdashboardSadyaSthitiData),
      const SizedBox(height: 15),
      Legend(legendString: "NewSankalpTable", fontsize: 18),
      _buildSankalpByAadhaarTable(Statics.tgLstSankalpByAadhaarData),
      const SizedBox(height: 15),
      Legend(legendString: "BhaugolikVistaar", fontsize: 18),
      _buildBhaugolikTable(Statics.tgLstBhaugolikVistaar),
      const SizedBox(height: 15),
      Legend(legendString: "SwayamsevakCount", fontsize: 18, onPressed: () => showNamesList(geoUnitID: controller.deepestSelectedGeoUnitId, type: "SwayamsevakCount")),
      SingleColumnRow(txtString: Statics.getLabel('TotalKaaryakartaaCount'), value: tgTotalSwayamsevakCount, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('PratidnyitCount'), value: tgPratidnyitCount, fontsize: 15),
      const SizedBox(height: 15),
      _swayamsevakCountByAge(
        shishu: tgShishuCount,
        baal: tgBaalCount,
        tarunV: tgTarunVidyaarthiCount,
        tarunVy: tgTarunVyavasaayeeCount,
        proudha: tgProudhaVyavasaayeeCount,
        unknown: tgUnknownAgeCount,
        controller: controller,
      ),
      const SizedBox(height: 15),
      _swayamsewakByBloodGroup(bloodgroup: _tgbloodgroup, controller: controller),
      const SizedBox(height: 15),
      _swayamsewakExperties(expertieslist: _tgexpertieslist, controller: controller),
      const SizedBox(height: 15),
      _swayamsewakInterests(interestlist: _tginterestlist, controller: controller),
      const SizedBox(height: 15),
      _swayamsewakInfoWidget(infolist: _tgmothertonguelist, heading: 'MotherTongue', controller: controller),
      const SizedBox(height: 15),
      _swayamsewakInfoWidget(infolist: _tgsangayulist, heading: 'Sangayu', controller: controller),
      const SizedBox(height: 15),
      _swayamsewakInfoWidget(infolist: _tgghoshwadlist, heading: 'Ghoshwadak', controller: controller),
      const SizedBox(height: 15),
      _tgganveshData == null ? SizedBox() : _swayamsewakUniform(ganvesh: _tgganveshData!, controller: controller),
      const SizedBox(height: 15),
      _tgvehicle == null ? SizedBox() : _swayamsewakVehicle(vehicle: _tgvehicle!, controller: controller),
      const SizedBox(height: 15),
      _shikshanSection(
        prarambhik: _nullToZero(tgPraarambhikShikshitCount),
        praathamik: _nullToZero(tgPraathamikShikshitCount),
        prathamVarsha: _nullToZero(tgPrathamVarshaShikshitCount),
        dwitiya: _nullToZero(tgDwitiyaVarshaShikshitCount),
        trutiya: _nullToZero(tgTrutiyaVarshaShikshitCount),
        noShikshan: tgNoShikshanCount,
        controller: controller,
      ),
      _kaaryakartaaByLevelSection(
        shaakhaa: tgDailyShaakhaaKaaryakartaaCount,
        saptahik: tgSaaptaahikMilanKaaryakartaaCount,
        milan: tgMaasikMilanKaaryakartaaCount,
        vasti: tgVastiKaaryakartaaCount,
        graam: tgGraamKaaryakartaaCount,
        mandal: tgMandalKaaryakartaaCount,
        nagar: tgNagarKaaryakartaaCount,
        shahar: tgShaharKaaryakartaaCount,
        bhaag: tgBhaagKaaryakartaaCount,
        vibhaag: tgVibhaagKaaryakartaaCount,
        mahaanagar: tgMahaanagarKaaryakartaaCount,
        praant: tgPraantKaaryakartaaCount,
        kshetra: tgKshetraKaaryakartaaCount,
        akhilBhaarat: tgAkhilBhaaratiyaKaaryakartaaCount,
        pravaasee: tgPravaaseeKaaryakartaaCount,
        total: tgTotalKaaryakartaaCount,
        controller: controller,
      ),
      Legend(legendString: "GatividhiAayaamSansthaaKaaryakartaaCount", fontsize: 18),
      SingleColumnRow(txtString: Statics.getLabel('GatividhiKaaryakartaaCount'), value: tgGatividhiKaaryakartaaCount, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('AayaamKaaryakartaaCount'), value: tgAayaamKaaryakartaaCount, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('SanghaPreritSansthaaKaaryakartaaCount'), value: tgSanghaPreritSansthaaKaaryakartaaCount, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('SocialOrganizationKaaryakartaaCount'), value: tgSocialOrganizationKaaryakartaaCount, fontsize: 15),
      const SizedBox(height: 15),
      Legend(legendString: "Gatividhi", fontsize: 18),
      _buildNameCountTable(
          data: Statics.tgLstGatividhiKaaryakartaa,
          nameHeader: Statics.getLabel('Gatividhi'),
          countHeader: Statics.getLabel('KaaryakartaaCount'),
          nameOf: (i) => i.gatividhiName ?? '',
          countOf: (i) => '${i.kaaryakartaaCount}'),
      const SizedBox(height: 15),
      Legend(legendString: "Aayaam", fontsize: 18),
      _buildNameCountTable(
          data: Statics.tgLstAayaamKaaryakartaa,
          nameHeader: Statics.getLabel('Aayaam'),
          countHeader: Statics.getLabel('KaaryakartaaCount'),
          nameOf: (i) => i.aayaamName ?? '',
          countOf: (i) => '${i.kaaryakartaaCount}'),
      const SizedBox(height: 15),
      Legend(legendString: "Sangha-PreritSansthaa", fontsize: 18),
      _buildNameCountTable(
          data: Statics.tgLstPreritKaaryakartaa,
          nameHeader: Statics.getLabel('AreaOfOperations'),
          countHeader: Statics.getLabel('KaaryakartaaCount'),
          nameOf: (i) => i.preritAOOName ?? '',
          countOf: (i) => '${i.kaaryakartaaCount}'),
      const SizedBox(height: 15),
      Legend(legendString: "OtherSocialOrganization", fontsize: 18),
      _buildNameCountTable(
          data: Statics.tgLstSocialOrgKaaryakartaa,
          nameHeader: Statics.getLabel('AreaOfOperations'),
          countHeader: Statics.getLabel('KaaryakartaaCount'),
          nameOf: (i) => i.mainAOOName ?? '',
          countOf: (i) => '${i.kaaryakartaaCount}'),
      const SizedBox(height: 15),
      Legend(legendString: "StudentCategory", fontsize: 18),
      _buildNameCountTable(
          data: Statics.tgLstStudentCategory,
          nameHeader: Statics.getLabel('StudentCategory'),
          countHeader: Statics.getLabel('SwayamsevakCount'),
          nameOf: (i) => i.studentCategoryName ?? '',
          countOf: (i) => '${i.countByStudentCategory}'),
      const SizedBox(height: 15),
      Legend(legendString: "VyavasaayeeCategory", fontsize: 18),
      _buildNameCountTable(
          data: Statics.tgLstVyavasaayeeCategory,
          nameHeader: Statics.getLabel('VyavasaayeeCategory'),
          countHeader: Statics.getLabel('SwayamsevakCount'),
          nameOf: (i) => i.vyavasaayeeCategoryName ?? '',
          countOf: (i) => '${i.countByVyavasaayeeCategory}'),
      const SizedBox(height: 15),
    ]);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REUSABLE SECTION WIDGETS (repeated blocks extracted to named methods)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Shaakhaa / Saptahik / Maasik vrutta summary rows.
  Widget _vruttaSummarySection({
    required String? shaakhaaEQ0,
    required String? shaakhaa1To24,
    required String? shaakhaaGTE25,
    required String? shaakhaaEQ30,
    required String? saaptaahikEQ0,
    required String? saaptaahik1To3,
    required String? saaptaahikGTE4,
    required String? maasikEQ0,
    required String? maasikEQ1,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Legend(legendString: "ShaakhaaVruttaSummaryLabel", fontsize: 18),
      SingleColumnRow(txtString: '${Statics.getLabel('Shaakhaa')}:-', value: '', fontsize: 18),
      SingleColumnRow(txtString: Statics.getLabel('ShaakhaaEQ0'), value: shaakhaaEQ0, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('Shaakhaa1To24'), value: shaakhaa1To24, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('ShaakhaaGTE25'), value: shaakhaaGTE25, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('ShaakhaaEQ30'), value: shaakhaaEQ30, fontsize: 15),
      SingleColumnRow(txtString: '${Statics.getLabel('SaaptaahikMilan')}:-', value: '', fontsize: 18),
      SingleColumnRow(txtString: Statics.getLabel('SaaptaahikEQ0'), value: saaptaahikEQ0, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('Saaptaahik1To3'), value: saaptaahik1To3, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('SaaptaahikGTE4'), value: saaptaahikGTE4, fontsize: 15),
      SingleColumnRow(txtString: '${Statics.getLabel('MaasikMilan')}/${Statics.getLabel('SanghaMandali')}:-', value: '', fontsize: 18),
      SingleColumnRow(txtString: Statics.getLabel('MaasikEQ0'), value: maasikEQ0, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('MaasikEQ1'), value: maasikEQ1, fontsize: 15),
    ]);
  }

  Widget _swayamsewakInfoWidget({
    required List<GetCount> infolist,
    required String heading,
    GeoHierarchyController? controller,
  }) {
    double normalwidth = MediaQuery.sizeOf(context).width * 0.75;
    double maxwidth = MediaQuery.sizeOf(context).width * 0.35;
    return Column(
      children: [
        Legend(legendString: heading, fontsize: 18, onPressed: () => showNamesList(geoUnitID: controller?.deepestSelectedGeoUnitId, type: heading)),
        infolist.isEmpty
            ? Center(child: Text(Statics.getLabel('NoDataFound')))
            : Wrap(
                spacing: 15,
                children: infolist.asMap().entries.map((entry) {
                  int index = entry.key;
                  GetCount e = entry.value;
                  bool islast = index == infolist.length - 1;
                  return Container(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: islast ? normalwidth : maxwidth),
                      child: Single1ColumnRow(
                        txtString: e.codeForDisplay,
                        value: e.cnt.toString(),
                        valFlex: 3,
                      ),
                    ),
                  );
                }).toList()),
      ],
    );
  }

  Widget _swayamsewakVehicle({required Vehicle vehicle, GeoHierarchyController? controller}) {
    return Column(
      children: [
        Legend(
          legendString: "VehicleInformation",
          fontsize: 18,
          onPressed: () => showNamesList(geoUnitID: controller?.deepestSelectedGeoUnitId, type: "VehicleInformation"),
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('VehicleType2W'),
          value: vehicle.Has2wehicle.toString(),
          fontsize: 15,
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('VehicleType3W'),
          value: vehicle.Has3wvehicle.toString(),
          fontsize: 15,
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('VehicleType4W'),
          value: vehicle.Has4wvehicle.toString(),
          fontsize: 15,
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('HasVehicleDriver'),
          value: vehicle.Hasdriver.toString(),
          fontsize: 15,
        ),
      ],
    );
  }

  Widget _swayamsewakExperties({required List<GetCount> expertieslist, GeoHierarchyController? controller}) {
    return Column(
      children: [
        Legend(legendString: "Experties", fontsize: 18, onPressed: () => showNamesList(geoUnitID: controller?.deepestSelectedGeoUnitId, type: "Experties")),
        expertieslist.isEmpty
            ? Center(child: Text(Statics.getLabel('NoDataFound')))
            : ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: expertieslist.length,
                itemBuilder: (context, index) {
                  var experties = expertieslist[index];
                  return Single1ColumnRow(
                    txtString: experties.codeForDisplay,
                    value: experties.cnt.toString(),
                    fontsize: 15,
                  );
                },
              )
      ],
    );
  }

  Widget _swayamsewakInterests({required List<GetCount> interestlist, GeoHierarchyController? controller}) {
    return Column(
      children: [
        Legend(legendString: "Interests", fontsize: 18, onPressed: () => showNamesList(geoUnitID: controller?.deepestSelectedGeoUnitId, type: "Interests")),
        interestlist.isEmpty
            ? Center(child: Text(Statics.getLabel('NoDataFound')))
            : ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: interestlist.length,
                itemBuilder: (context, index) {
                  var interest = interestlist[index];
                  return Single1ColumnRow(
                    txtString: interest.codeForDisplay,
                    value: interest.cnt.toString(),
                    fontsize: 15,
                  );
                },
              )
      ],
    );
  }

  Widget _swayamsewakUniform({required GanveshData ganvesh, GeoHierarchyController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Legend(legendString: "GanveshDetails", fontsize: 18, onPressed: () => showNamesList(geoUnitID: controller?.deepestSelectedGeoUnitId, type: "GanveshDetails")),
        Single1ColumnRow(
          txtString: Statics.getLabel('NoBelt'),
          value: ganvesh.Hasbelt.toString(),
          fontsize: 15,
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('NoCap'),
          value: ganvesh.Hascap.toString(),
          fontsize: 15,
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('NoDanda'),
          value: ganvesh.Hasdanda.toString(),
          fontsize: 15,
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('NoPant'),
          value: ganvesh.Haspant.toString(),
          fontsize: 15,
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('NoShirt'),
          value: ganvesh.Hasshirt.toString(),
          fontsize: 15,
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('NoShoes'),
          value: ganvesh.Hasshoes.toString(),
          fontsize: 15,
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('NoSocks'),
          value: ganvesh.Hassock.toString(),
          fontsize: 15,
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('IsGanaveshComplete'),
          value: ganvesh.isganveshcomplted.toString(),
          fontsize: 15,
        ),
        // Single1ColumnRow(
        //   txtString: Statics.getLabel('SanghaPraveshYearNotFilled'),
        //   value: ganvesh.isyearnotfilled.toString(),
        //   fontsize: 15,
        // ),
      ],
    );
  }

  Widget _swayamsewakByBloodGroup({required List<GetCount> bloodgroup, GeoHierarchyController? controller}) {
    double normalwidth = MediaQuery.sizeOf(context).width * 0.75;
    double maxwidth = MediaQuery.sizeOf(context).width * 0.35;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Legend(legendString: "SwayamsevakCountByBloodGroup", fontsize: 18, onPressed: () => showNamesList(geoUnitID: controller?.deepestSelectedGeoUnitId, type: "SwayamsevakCountByBloodGroup")),
        bloodgroup.isEmpty
            ? Center(child: Text(Statics.getLabel('NoDataFound')))
            : Wrap(
                spacing: 15,
                children: bloodgroup.asMap().entries.map((entry) {
                  int index = entry.key;
                  GetCount e = entry.value;
                  bool islast = index == bloodgroup.length - 1;
                  return Container(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: islast ? normalwidth : maxwidth),
                      child: Single1ColumnRow(
                        txtString: e.codeForDisplay,
                        value: e.cnt.toString(),
                        valFlex: 3,
                      ),
                    ),
                  );
                }).toList())
      ],
    );
  }

  Widget _swayamsevakCountByAge({
    required String? shishu,
    required String? baal,
    required String? tarunV,
    required String? tarunVy,
    required String? proudha,
    required String? unknown,
    GeoHierarchyController? controller,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Legend(legendString: "SwayamsevakCountByAge", fontsize: 18, onPressed: () => showNamesList(geoUnitID: controller?.deepestSelectedGeoUnitId, type: "SwayamsevakCountByAge")),
      SingleColumnRow(txtString: Statics.getLabel('Shishu'), value: shishu, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('Baal'), value: baal, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('TarunVidyaarthi'), value: tarunV, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('TarunVyavasaayee'), value: tarunVy, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('ProudhVyavasaayee'), value: proudha, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('UnkownAge'), value: unknown, fontsize: 15),
      const SizedBox(height: 15),
    ]);
  }

  Widget _shikshanSection({
    required String? prarambhik,
    required String? praathamik,
    required String? prathamVarsha,
    required String? dwitiya,
    required String? trutiya,
    required String? noShikshan,
    GeoHierarchyController? controller,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Legend(legendString: "ShikshitSwayamsevakCount", fontsize: 18, onPressed: () => showNamesList(geoUnitID: controller?.deepestSelectedGeoUnitId, type: "ShikshitSwayamsevakCount")),
      SingleColumnRow(txtString: Statics.getLabel('PrarambhikShikshit'), value: prarambhik, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('PraathamikShikshit'), value: praathamik, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('PrathamVarshShikshit'), value: prathamVarsha, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('DwitiyaVarshShikshit'), value: dwitiya, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('TrutiyaVarshShikshit'), value: trutiya, fontsize: 15),
      SingleColumnRow(txtString: Statics.getLabel('NoShikshan'), value: noShikshan, fontsize: 15),
      const SizedBox(height: 15),
    ]);
  }

  Widget _kaaryakartaaByLevelSection({
    required String? shaakhaa,
    required String? saptahik,
    required String? milan,
    required String? vasti,
    required String? graam,
    required String? mandal,
    required String? nagar,
    required String? shahar,
    required String? bhaag,
    required String? vibhaag,
    required String? mahaanagar,
    required String? praant,
    required String? kshetra,
    required String? akhilBhaarat,
    required String? pravaasee,
    required String? total,
    GeoHierarchyController? controller,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Legend(
        legendString: "KaaryakartaaCountByLevel",
        fontsize: 18,
        onPressed: () => showNamesList(geoUnitID: controller?.deepestSelectedGeoUnitId, type: "KaaryakartaaCountByLevel"),
      ),
      TwoColumnRow(txtString: Statics.getLabel('Shaakhaa'), value: shaakhaa, txtString2: Statics.getLabel('SaaptaahikLabelShort'), value2: saptahik, fontsize: 15),
      TwoColumnRow(txtString: Statics.getLabel('MilanMandali'), value: milan, txtString2: Statics.getLabel('VastiKaaryakartaaCount'), value2: vasti, fontsize: 15),
      TwoColumnRow(txtString: Statics.getLabel('GraamKaaryakartaaCount'), value: graam, txtString2: Statics.getLabel('MandalKaaryakartaaCount'), value2: mandal, fontsize: 15),
      TwoColumnRow(txtString: Statics.getLabel('NagarKaaryakartaaCount'), value: nagar, txtString2: Statics.getLabel('upnagarUpkhanda'), value2: shahar, fontsize: 15),
      TwoColumnRow(txtString: Statics.getLabel('BhaagKaaryakartaaCount'), value: bhaag, txtString2: Statics.getLabel('VibhaagKaaryakartaaCount'), value2: vibhaag, fontsize: 15),
      TwoColumnRow(txtString: Statics.getLabel('MahaanagarKaaryakartaaCount'), value: mahaanagar, txtString2: Statics.getLabel('PraantKaaryakartaaCount'), value2: praant, fontsize: 15),
      TwoColumnRow(txtString: Statics.getLabel('KshetraKaaryakartaaCount'), value: kshetra, txtString2: Statics.getLabel('AkhilBhaaratiyaKaaryakartaaCount'), value2: akhilBhaarat, fontsize: 15),
      TwoColumnRow(txtString: Statics.getLabel('PravaaseeKaaryakartaaCount'), value: pravaasee, txtString2: Statics.getLabel('TotalKaaryakartaaCount'), value2: total, fontsize: 15),
      const SizedBox(height: 15),
    ]);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SMALL UI HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Compact clear button used in expansion panels.
  Widget _clearButton(VoidCallback onPressed) {
    return SizedBox(
      height: 21,
      width: 80,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Theme.of(context).primaryColor,
        textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
        onPressed: onPressed,
        child: Text(Statics.getLabel("clear"), style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  /// Generic geo-unit dropdown.
  Widget _dropdown({
    required String label,
    required String? value,
    required List<GeoUnitMasterBAL> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      isExpanded: true,
      value: value,
      items: items.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
      onChanged: onChanged,
    );
  }

  /// Replace "null" string with "0".
  String _nullToZero(String? v) => (v == null || v == 'null') ? '0' : v;

  // ═══════════════════════════════════════════════════════════════════════════
  // UPNAGAR COUNT DATA TABLE (unchanged, already using DataTable)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildUpnagarCountDataTable(List<UpkhandaDataList> data) {
    final headers = [
      Statics.getLabel('hoomeScreenUpnagarTable1'),
      Statics.getLabel('hoomeScreenUpnagarTable2'),
      Statics.getLabel('hoomeScreenUpnagarTable3'),
      Statics.getLabel('hoomeScreenUpnagarTable4'),
      Statics.getLabel('hoomeScreenUpnagarTable5'),
      Statics.getLabel('hoomeScreenUpnagarTable6'),
      Statics.getLabel('hoomeScreenUpnagarTable7'),
      "",
    ];

    if (data.isEmpty) {
      return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: 150,
        child: Center(child: Text(Statics.getLabel('NoDataFound'), style: const TextStyle(fontWeight: FontWeight.normal))),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Frozen first column
        DataTable(
          headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
          columnSpacing: 0,
          horizontalMargin: 16,
          border: TableBorder.all(color: Colors.black26),
          columns: [
            DataColumn(
              label: SizedBox(
                width: 50,
                child: Text(Statics.getLabel("hoomeScreenUpnagarTable0"), softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          rows: [
            ...data.map((l) => DataRow(color: const MaterialStatePropertyAll(Colors.white), cells: [DataCell(Text(l.goUnitName.toString()))])),
            DataRow(color: MaterialStatePropertyAll(Colors.yellow.shade100), cells: [DataCell(Text(Statics.getLabel("Total"), style: const TextStyle(fontWeight: FontWeight.w700)))]),
          ],
        ),
        // Scrollable remaining columns
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            interactive: true,
            thickness: 5,
            radius: const Radius.circular(10),
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 14,
                horizontalMargin: 12,
                headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                border: TableBorder(verticalInside: BorderSide(width: 0.7, color: Colors.grey.shade200)),
                columns: headers
                    .map((h) => DataColumn(
                          label: Container(
                            constraints: const BoxConstraints(minWidth: 40, maxWidth: 100),
                            child: Text(h, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ))
                    .toList(),
                rows: [
                  ...data.map((l) => DataRow(
                        color: const MaterialStatePropertyAll(Colors.white),
                        cells: [
                          DataCell(Center(child: Text(l.nagarCount.toString()))),
                          DataCell(Center(child: Text(l.vastiCount.toString()))),
                          DataCell(Center(child: Text(l.gramCount.toString()))),
                          DataCell(Center(child: Text(l.upNagarCount.toString()))),
                          DataCell(Center(child: Text(l.mapUpNagarCount.toString()))),
                          DataCell(Center(child: Text(l.upKhandCount.toString()))),
                          DataCell(Center(child: Text(l.mapUpKhandCount.toString()))),
                          DataCell(Center(child: Icon(Icons.download, color: Colors.purple, size: 16)), onTap: () => _showExcelDownloadDialog(l)),
                        ],
                      )),
                  DataRow(
                    color: MaterialStatePropertyAll(Colors.yellow.shade100),
                    cells: [
                      DataCell(Center(child: Text(data.fold(0, (s, i) => s + (i.nagarCount ?? 0)).toString(), style: const TextStyle(fontWeight: FontWeight.w700)))),
                      DataCell(Center(child: Text(data.fold(0, (s, i) => s + (i.vastiCount ?? 0)).toString(), style: const TextStyle(fontWeight: FontWeight.w700)))),
                      DataCell(Center(child: Text(data.fold(0, (s, i) => s + (i.gramCount ?? 0)).toString(), style: const TextStyle(fontWeight: FontWeight.w700)))),
                      DataCell(Center(child: Text(data.fold(0, (s, i) => s + (i.upNagarCount ?? 0)).toString(), style: const TextStyle(fontWeight: FontWeight.w700)))),
                      DataCell(Center(child: Text(data.fold(0, (s, i) => s + (i.mapUpNagarCount ?? 0)).toString(), style: const TextStyle(fontWeight: FontWeight.w700)))),
                      DataCell(Center(child: Text(data.fold(0, (s, i) => s + (i.upKhandCount ?? 0)).toString(), style: const TextStyle(fontWeight: FontWeight.w700)))),
                      DataCell(Center(child: Text(data.fold(0, (s, i) => s + (i.mapUpKhandCount ?? 0)).toString(), style: const TextStyle(fontWeight: FontWeight.w700)))),
                      const DataCell(SizedBox()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MENU TAB CARDS  (unchanged — already clean)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget shatabdiVrutaCard() {
    return _card(
      title: Statics.getLabel("shatabdiVarshaVruttaTitle"),
      children: [
        if (_fromAboveMandal)
          _cardRow([
            _cardTile(Statics.getLabel('vijayaDashamiUtsav') + '  ' + Statics.getLabel('Vrutta'), () => Navigator.of(context).pushNamed(VijayadashamiFormView.routeName)),
            if (_fromAboveNagar) _cardTile(Statics.getLabel('vijayaDashamiUtsav') + '  ' + Statics.getLabel('Reportonly'), () => Navigator.of(context).pushNamed(VijayadashamiFormReport.routeName)),
          ]),
        _cardRow([
          _cardTile(Statics.getLabel("gruhSamparkAbhiyan"), () => Navigator.of(context).pushNamed(GruhAbhiyaanMainTabScreen.routeName)),
          _cardTile(Statics.getLabel("hinduSammelan"), () => Navigator.of(context).pushNamed(HinduSanmelanMainTab.routeName)),
        ]),
        if (_fromAboveMandal)
          _cardRow([
            _cardTile(Statics.getLabel("sadbhavBaithak"), () => Navigator.of(context).pushNamed(SadbhavBaithakMainTab.routeName)),
            _cardTile(Statics.getLabel("pramukhJansanvaad"), () => Navigator.of(context).pushNamed(PramukhJansanvadMainTab.routeName)),
          ]),
        _cardRow([
          if (_fromAboveMandal) _cardTile(Statics.getLabel("yuvaSangam"), () => Navigator.of(context).pushNamed(YuvaSangamMainTab.routeName)),
          // _cardTile(Statics.getLabel("yuvaSangam"), () => Fluttertoast.showToast(msg: Statics.getLabel("workInProgress"), gravity: ToastGravity.BOTTOM)),
          // _cardTile(Statics.getLabel("shakhaVistaar"), () => Statics.showToast(Statics.getLabel("workInProgress"), toastLength: Toast.LENGTH_LONG)),
          _cardTile(Statics.getLabel("shakhaVistaar"), () => Navigator.of(context).pushNamed(ShakhaSaptahMainTab.routeName)),
        ]),
      ],
    );
  }

  Widget surveyCard() {
    if ((isuservasti == 0 && isusermandal == 0) || _fromShaakha) return SizedBox();
    return _card(
      title: Statics.getLabel("Survey"), // + "$isuservasti ?????????? $isusermandal",
      children: [
        _cardRow([
          if (_fromVasti && isuservasti == 1) _cardTile(Statics.getLabel('vastiSurvey'), () => Navigator.of(context).pushNamed(VastiSurveyFormScreen.routeName)),
          if (_fromMandalGram && isusermandal == 1) _cardTile(Statics.getLabel('mandalSurvey'), () => Navigator.of(context).pushNamed(MandalSurveyFormScreen.routeName)),
        ]),
        if (_fromAboveNagar)
          _cardRow([
            if (isuservasti == 1) _cardTile(Statics.getLabel('vastiSurveyReport'), () => Navigator.of(context).pushNamed(VastiSurveyReportScreen.routeName)),
            if (isusermandal == 1) _cardTile(Statics.getLabel('mandalSurveyReport'), () => Navigator.of(context).pushNamed(MandalSurveyReportScreen.routeName)),
          ]),
      ],
    );
  }

  Widget moreCard() {
    final level = Statics.userDetails['LevelName'];
    final daayitva = Statics.userDetails["DaayitvaName"];
    return _card(
      title: Statics.getLabel("mainScreenOther"),
      children: [
        _cardRow([
          if (_joinRss) _cardTile(Statics.getLabel('searchJoinRSSScreenLabel'), () => Navigator.of(context).pushNamed(SearchJoinRss.routeName)),
          _cardTile(Statics.getLabel('searchSwayamsevakScreenBanner'), () => Navigator.of(context).pushNamed(SwayamSevakSearch.routeName)),
        ]),
        _cardRow([
          _cardTile(Statics.getLabel('Abhiyaan'), () => Navigator.of(context).pushNamed(AbhiyanScreen.routeName)),
          _cardTile(Statics.getLabel('searchSoochiScreenLabel'), () => Navigator.of(context).pushNamed(SearchSoochiScreen.routeName)),
        ]),
        _cardRow([
          if (_shouldShowGeoUnitChange(level, daayitva)) _cardTile(Statics.getLabel('masterdataupdate2'), () => Navigator.of(context).pushNamed(TabScreen.routeName)),
          _cardTile(Statics.getLabel('searchEventsScreenLabel'), () => Navigator.of(context).pushNamed(SearchEvent.routeName)),
        ]),
        if (_showRjbNidhiTile(level, daayitva))
          _cardTile(Statics.getLabel('searchRamJanmabhoomiNidhiSankalanVrutta'), () => Navigator.of(context).pushNamed(SearchRamJanmaBhoomiNidhiSankalan.routeName)),
      ],
    );
  }

  // ─── Card primitives ──────────────────────────────────────────────────────

  /// Container card with a floating label, used by all three menu cards.
  Widget _card({required String title, required List<Widget> children}) {
    return Row(children: [
      Expanded(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(12)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [const SizedBox(height: 19), ...children],
              ),
            ),
            Positioned(
              top: -13,
              child: ClipPath(
                clipBehavior: Clip.antiAlias,
                clipper: LabelClipper(),
                child: Container(
                  padding: const EdgeInsets.only(right: 24, top: 3, bottom: 2, left: 8),
                  decoration: BoxDecoration(color: Colors.purple.shade300, borderRadius: BorderRadius.circular(12)),
                  child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  /// A row of up to two card tiles with spacing.
  Widget _cardRow(List<Widget> tiles) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: tiles.map((t) => Expanded(child: t)).toList().fold<List<Widget>>([], (list, w) => list.isEmpty ? [w] : [...list, const SizedBox(width: 8), w])),
    );
  }

  /// A single tappable card tile inside a card row.
  Widget _cardTile(String label, VoidCallback onTap, {bool makeHighlight = false}) {
    return InkWell(
      onTap: onTap,
      // It's good practice to match the InkWell radius to the container radius
      // so the touch ripple doesn't bleed outside the rounded corners.
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: makeHighlight ? Colors.purple.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          // Adds a subtle border to make the highlighted card pop
          border: makeHighlight ? Border.all(color: Colors.blue.shade200, width: 1) : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  // Makes the font slightly bolder when highlighted
                  fontWeight: makeHighlight ? FontWeight.w700 : FontWeight.w500,
                  color: makeHighlight ? Colors.blue.shade900 : Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: makeHighlight ? Colors.blue.shade900 : Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  /// Whether to show the Ram Janmabhoomi Nidhi tile (long condition extracted).
  bool _showRjbNidhiTile(String level, String daayitva) {
    const levels = [
      "Praant",
      "प्रांत",
      "Mahaanagar",
      "महानगर",
      "Vibhaag",
      "विभाग",
      "Bhaag",
      "भाग/जिला",
      "भाग/जिल्हा",
      "Shahar",
      "शहर",
      "Nagar/Taalukaa",
      "Nagar",
      "नगर/तालुका",
      "Graam",
      "ग्राम",
      "Vasti",
      "वस्ती"
    ];
    const daayitvas = [
      "Join RSS Sanyojak",
      "जॉयन आर.एस.एस. संयोजक",
      "Join RSS Pramukh",
      "जॉयन आर.एस.एस. प्रमुख",
      "Kaaryaalay Pramukh",
      "कार्यालय प्रमुख",
      "Kaaryavaah",
      "कार्यवाह",
      "karyalay sachiv",
      "कार्यालय सचिव",
      "Saha-Kaaryavaah",
      "सह कार्यवाह",
      "Prachaarak",
      "प्रचारक",
      "Saha-Prachaarak",
      "सह प्रचारक",
      "Baal Vidyaarthi Pramukh",
      "बाल विद्यार्थी प्रमुख",
      "Mahaavidyaalayeen Vidyaarthi Pramukh",
      "महाविद्यालयीन प्रमुख",
      "Vyavasaayee Pramukh",
      "व्यवसायी प्रमुख",
      "Vyavasaayee Saha-Pramukh",
      "व्यवसायी सह प्रमुख",
      "Tarun Vyavsayee Pramukh",
      "तरुण व्यवसायी प्रमुख",
      "Praudh Vyavsayee Pramukh",
      "प्रौढ व्यवसायी प्रमुख",
      "Tarun Vyavsayee Sah Pramukh",
      "तरुण व्यवसायी सह प्रमुख",
      "Praudh Vyavsayee Sah Pramukh",
      "प्रौढ व्यवसायी सह प्रमुख",
      "Bal Vidyarthi Sah Pramukh",
      "बाल विद्यार्थी सह प्रमुख",
      "Mahavidyaleen Vidyarthi Sah Pramukh",
      "महाविद्यालयीन विद्यार्थी सह प्रमुख",
      "App Sanyojak",
      "एप संयोजक",
      "Pramukh",
      "प्रमुख",
    ];
    return levels.contains(level); // && daayitvas.contains(daayitva);
  }
}

class GetCount {
  String? codeForDisplay;
  int? cnt;

  GetCount({this.codeForDisplay, this.cnt});

  factory GetCount.fromJson(Map<String, dynamic> json) {
    return GetCount(
      codeForDisplay: json['CodeForDisplay'],
      cnt: json['cnt'],
      //cnt: int.tryParse(json['cnt'].toString()) ?? 0,
    );
  }
}

class GanveshData {
  int? Hasbelt;
  int? Hascap;
  int? Hasdanda;
  int? Haspant;
  int? Hasshirt;
  int? Hasshoes;
  int? Hassock;
  int? isganveshcomplted;

  GanveshData({this.Hasbelt, this.Hascap, this.Hasdanda, this.Haspant, this.Hasshirt, this.Hasshoes, this.Hassock, this.isganveshcomplted});

  factory GanveshData.fromJson(Map<String, dynamic> json) {
    return GanveshData(
      Hasbelt: json['HasBelt'],
      Hascap: json['HasCap'],
      Hasdanda: json['HasDanda'],
      Haspant: json['HasPant'],
      Hasshirt: json['HasShirt'],
      Hasshoes: json['HasShoes'],
      Hassock: json['HasSocks'],
      isganveshcomplted: json['IsGanaveshComplete'],
      //cnt: int.tryParse(json['cnt'].toString()) ?? 0,
    );
  }
}

class Vehicle {
  int? Has2wehicle;
  int? Has3wvehicle;
  int? Has4wvehicle;
  int? Hasdriver;

  Vehicle({this.Has2wehicle, this.Has3wvehicle, this.Has4wvehicle, this.Hasdriver});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      Has2wehicle: json['Has2WVehicle'],
      Has3wvehicle: json['Has3WVehicle'],
      Has4wvehicle: json['Has4WVehicle'],
      Hasdriver: json['HasVehicleDriver'],

      //cnt: int.tryParse(json['cnt'].toString()) ?? 0,
    );
  }
}
