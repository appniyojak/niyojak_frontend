import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;

import '../../helpers/static_data.dart' as Statics;
import '../../models/response_model/notification_list_model.dart';
import '../../models/response_model/upkhanda_upnagar_report_data_model.dart';
import '../../providers/bals.dart';
import '../../providers/login.dart';
import '../../screens/change_password.dart';
import '../../utils/cust_painters.dart';
import '../../widgets/app_drawer.dart';
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
import '../shatabdi_vrutta_sankalan/gruh_sampark_abhiyaan/gruh_abhiyaan_main_tab_screen.dart';
import '../shatabdi_vrutta_sankalan/hindu_sanmelan/hindu_sanmelan_main_tab.dart';
import '../shatabdi_vrutta_sankalan/pramukh_jansanvad/pramukh_jan_main_tab.dart';
import '../shatabdi_vrutta_sankalan/sadbhav_baithak/sadbhav_baithak_main_tab.dart';
import '../shatabdi_vrutta_sankalan/vijayadashami/vijaya_dashami_report.dart';
import '../shatabdi_vrutta_sankalan/vijayadashami/vijayadashami_form_view.dart';
import '../shatabdi_vrutta_sankalan/yuva-sangam_sanmelan/yuva_sangam_main_tab.dart';
import '../survey_screen/mandal_reports_tabs.dart';
import '../survey_screen/survey_form/mandal_survey_form_view.dart';
import '../survey_screen/survey_form/vasti_survey_form_view.dart';
import '../survey_screen/vasti_reports_tabs.dart';
import '../swayamsevak_module/swayamsevak_search.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ─── Scroll ────────────────────────────────────────────────────────────────
  final ScrollController _scrollController = ScrollController();

  // ─── GeoUnit ───────────────────────────────────────────────────────────────
  dynamic geoUnitID;
  dynamic geoUnitName;

  // ─── Loading flags ─────────────────────────────────────────────────────────
  bool _isLoading = false;
  bool _isSearching = false;
  bool _isMySearching = false;
  bool _isTgSearching = false;

  // ─── Panel expansion ───────────────────────────────────────────────────────
  bool _isSwExpanded = false;
  bool _isGeounitExpanded = false;
  bool _isNagarTableExpanded = false;

  // ─── Menu ──────────────────────────────────────────────────────────────────
  List<MenuChoices> choices = [];

  // ─── Target level ──────────────────────────────────────────────────────────
  int _tgLevelID = 13;
  String _selctedLevelName = "praant";
  String _selctedGeoUnitId = "0";

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
  AbhiyanSwayamsevakdata? initialData;

  // ─── Dropdown data – set 1 (Target GeoUnit panel) ─────────────────────────
  List<GeoUnitMasterBAL>? _linkedMahaanagar, _linkedVibhaag, _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar, _linkednagar, _linkedmandal, _linkedgraam, _linkedvasti;
  String? _linkedMahaanagarValue = "", _linkedVibhaagValue = "", _linkedbhaagValue = "";
  String? _linkedshaharValue = "", _linkednagarValue = "", _linkedmandalValue = "";
  String? _linkedgraamValue = "", _linkedvastiValue = "";

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
  GanveshData? _ganveshData;
  Vehicle? _vehicle;
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
    _initScreen();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getReleaseNotes());
  }

  void _initScreen() {
    _getInitialData();
    _populateChoices();
    _populateDropdownSet1();
    _populateDropdownSet2();
    _getGeoUnitID();
    _fetchMyDashboardData();
    _getUpkhandUpnagarReport("0", "praant");
    _fetchNotificationData();
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
  Future<void> _fetchTargetDashboardData(dynamic tgGeoUnitID, int levelID) async {
    _tgLevelID = levelID;
    setState(() => _isTgSearching = true);
    final data = await Statics.getDashboardDataByGeoUnit(Statics.userDetails["userID"], tgGeoUnitID);
    if (data['Status'] != "Success") {
      _clearTargetData();
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
      tgPraarambhikShikshitCount = sd["PraarambhikShikshitCount"].toString();
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
      _isTgSearching = false;
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DROPDOWN HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  void _populateDropdownSet1() {
    _populateMahaanagar1();
    _populateVibhaag1();
  }

  void _populateDropdownSet2() {
    _populateMahaanagar2();
    _populateVibhaag2();
  }

  void _populateMahaanagar1() async {
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), "", "", "");
    setState(() => _linkedMahaanagar = data);
  }

  void _populateVibhaag1() async {
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), "", "", "");
    setState(() => _linkedVibhaag = data);
  }

  void _populateMahaanagar2() async {
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), "", "", "");
    setState(() => _linkedMahaanagar2 = data);
  }

  void _populateVibhaag2() async {
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), "", "", "");
    setState(() => _linkedVibhaag2 = data);
  }

  void _populateBhaag(String vibhaagID) async {
    _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagID, "Vibhaag", "");
    setState(() => _linkedbhaag = data);
  }

  void _populateShahar(String bhaagID) async {
    _linkedshaharValue = _linkedvastiValue = _linkedshahar = _linkedvasti = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagID, 'Bhaag', '');
    setState(() => _linkedshahar = data.isNotEmpty ? data : null);
  }

  void _populateNagar({String? bhaagID, String? shaharID}) async {
    _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    final parentID = shaharID ?? bhaagID!;
    final parentType = shaharID != null ? 'Shahar' : 'Bhaag';
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), parentID, parentType, '');
    setState(() => _linkednagar = data.isNotEmpty ? data : null);
  }

  void _populateMandal(String nagarID) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarID, 'Nagar', '');
    setState(() => _linkedmandal = data.isNotEmpty ? data : null);
  }

  void _populateGraam(String mandalID) async {
    _linkedgraamValue = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalID, 'Mandal', '');
    setState(() => _linkedgraam = data.isNotEmpty ? data : null);
  }

  void _populateVasti(String nagarID) async {
    _linkedvastiValue = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarID, 'Nagar', '');
    setState(() => _linkedvasti = data.isNotEmpty ? data : null);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCESS CONTROL HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  bool _shouldShowForLevel(String levelName) => !_deniedLevels.contains(levelName);

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
        final data = await Statics.refreshDashboardData(Statics.userDetails["userID"], geoUnitID);
        if (data == "Successfull") {
          await Statics.getNotificationDataList(Statics.userDetails["userID"]);
          Statics.populateDashboardDetailsMap();
          Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
        }
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

  // ═══════════════════════════════════════════════════════════════════════════
  // ──────────────────────  REUSABLE TABLE WIDGETS  ──────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════

  /// Standard "no data" placeholder.
  Widget _buildNoData() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(Statics.getLabel('NoDataFound'), style: const TextStyle(fontWeight: FontWeight.normal)),
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
  Widget _buildYesterdayPraantTable(List data) {
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
    return DefaultTabController(
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
              Tab(text: Statics.getLabel('menu')),
              Tab(text: Statics.getLabel('mainScreenTab2')),
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
            _buildMenuTab(),
            _buildDashboardTab(),
          ],
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

              // ── Yesterday Praant ───────────────────────────────────────────
              Legend(legendString: "YesterdayPraantData", fontsize: 18),
              _isMySearching ? const CircularProgressIndicator() : _buildYesterdayPraantTable(Statics.lstYesterdayPraantData),
              const SizedBox(height: 15),

              // ── Bhaugolik rachana (expansion) ─────────────────────────────
              _bhaugolikRachanaPanel(),
              const SizedBox(height: 15),

              // ── My Geo Unit details (expansion) ───────────────────────────
              _myGeoUnitPanel(),
              const SizedBox(height: 10),

              // ── Target Geo Unit details (expansion) ───────────────────────
              _targetGeoUnitPanel(),
              const SizedBox(height: 10),
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
    final isHighLevel = int.parse(Statics.userDetails['LevelID']) > 6;
    return Column(children: [
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
      Legend(legendString: "SwayamsevakCount", fontsize: 18),
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
      _swayamsewakInfoWidget(infolist: _mothertonguelist, heading: 'Mother Tongue'),
      const SizedBox(height: 15),
      _swayamsewakInterests(interestlist: _interestlist),
      const SizedBox(height: 15),
      _swayamsewakInfoWidget(infolist: _ghoshwadlist, heading: 'Ghoshwad'),
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
    ]);
  }

  Widget _targetGeoUnitPanel() {
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
                  setState(() {
                    _linkedMahaanagarValue = _linkedVibhaagValue = _linkedbhaagValue = null;
                    _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
                    _linkedMahaanagar = _linkedVibhaag = _linkedbhaag = null;
                    _linkedshahar = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
                  });
                  _clearTargetData();
                  _populateDropdownSet1();
                }),
              ),

              // Mahaanagar
              if (_linkedMahaanagar != null)
                _dropdown(
                    label: Statics.getLabel('Mahaanagar'),
                    value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                    items: _linkedMahaanagar!,
                    onChanged: (v) {
                      setState(() {
                        _linkedMahaanagarValue = v;
                        _populateVibhaag1();
                        _fetchTargetDashboardData(v, 8);
                      });
                    }),
              // Vibhaag
              if (_linkedVibhaag != null)
                _dropdown(
                    label: Statics.getLabel('Vibhaag'),
                    value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                    items: _linkedVibhaag!,
                    onChanged: (v) {
                      setState(() {
                        _linkedVibhaagValue = v;
                        _populateBhaag(v!);
                        _fetchTargetDashboardData(v, 8);
                      });
                    }),
              // Bhaag
              if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty)
                _dropdown(
                    label: Statics.getLabel('Bhaag'),
                    value: _linkedbhaagValue == "" ? null : _linkedbhaagValue,
                    items: _linkedbhaag!,
                    onChanged: (v) {
                      setState(() {
                        _linkedbhaagValue = v;
                        _populateShahar(v!);
                        _populateNagar(bhaagID: v);
                        _fetchTargetDashboardData(v, 7);
                      });
                    }),
              // Shahar
              if (_linkedshahar != null && _linkedshahar!.isNotEmpty)
                _dropdown(
                    label: Statics.getLabel('Shahar'),
                    value: _linkedshaharValue == "" ? null : _linkedshaharValue,
                    items: _linkedshahar!,
                    onChanged: (v) {
                      setState(() {
                        _linkedshaharValue = v;
                        _populateNagar(shaharID: v);
                        _fetchTargetDashboardData(v, 5);
                      });
                    }),
              // Nagar
              if (_linkednagar != null && _linkednagar!.isNotEmpty)
                _dropdown(
                    label: Statics.getLabel('Nagar'),
                    value: _linkednagarValue == "" ? null : _linkednagarValue,
                    items: _linkednagar!,
                    onChanged: (v) {
                      setState(() {
                        _linkednagarValue = v;
                        _populateMandal(v!);
                        _populateVasti(v);
                        _fetchTargetDashboardData(v, 6);
                      });
                    }),
              // Mandal
              if (_linkedmandal != null && _linkedmandal!.isNotEmpty)
                _dropdown(
                    label: Statics.getLabel('Mandal'),
                    value: _linkedmandalValue == "" ? null : _linkedmandalValue,
                    items: _linkedmandal!,
                    onChanged: (v) {
                      setState(() {
                        _linkedmandalValue = v;
                        _populateGraam(v!);
                        _fetchTargetDashboardData(v, 4);
                      });
                    }),
              // Graam
              if (_linkedgraam != null && _linkedgraam!.isNotEmpty)
                _dropdown(
                    label: Statics.getLabel('Graam'),
                    value: _linkedgraamValue == "" ? null : _linkedgraamValue,
                    items: _linkedgraam!,
                    onChanged: (v) {
                      setState(() {
                        _linkedgraamValue = v;
                        _fetchTargetDashboardData(v, 3);
                      });
                    }),
              // Vasti
              if (_linkedvasti != null && _linkedvasti!.isNotEmpty)
                _dropdown(
                    label: Statics.getLabel('Vasti'),
                    value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                    items: _linkedvasti!,
                    onChanged: (v) {
                      setState(() {
                        _linkedvastiValue = v;
                        _fetchTargetDashboardData(v, 2);
                      });
                    }),

              const SizedBox(height: 40),
              if (_isTgSearching) const CircularProgressIndicator() else _buildTargetGeoUnitContent(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildTargetGeoUnitContent() {
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
      Legend(legendString: "SwayamsevakCount", fontsize: 18),
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
      ),
      const SizedBox(height: 15),
      _swayamsewakByBloodGroup(bloodgroup: _bloodgroup),
      const SizedBox(height: 15),
      _swayamsewakExperties(expertieslist: _expertieslist),
      const SizedBox(height: 15),
      _swayamsewakInterests(interestlist: _interestlist),
      const SizedBox(height: 15),
      _swayamsewakInfoWidget(infolist: _mothertonguelist, heading: 'Mother Tongue'),
      const SizedBox(height: 15),
      _swayamsewakInfoWidget(infolist: _sangayulist, heading: 'Sangayu'),
      const SizedBox(height: 15),
      _swayamsewakInfoWidget(infolist: _ghoshwadlist, heading: 'Ghoshwad'),
      const SizedBox(height: 15),
      _ganveshData == null ? SizedBox() : _swayamsewakUniform(ganvesh: _ganveshData!),
      const SizedBox(height: 15),
      _vehicle == null ? SizedBox() : _swayamsewakVehicle(vehicle: _vehicle!),
      const SizedBox(height: 15),
      _shikshanSection(
        prarambhik: _nullToZero(tgPraarambhikShikshitCount),
        praathamik: _nullToZero(tgPraathamikShikshitCount),
        prathamVarsha: _nullToZero(tgPrathamVarshaShikshitCount),
        dwitiya: _nullToZero(tgDwitiyaVarshaShikshitCount),
        trutiya: _nullToZero(tgTrutiyaVarshaShikshitCount),
        noShikshan: tgNoShikshanCount,
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
  }) {
    double normalwidth = MediaQuery.sizeOf(context).width * 0.75;
    double maxwidth = MediaQuery.sizeOf(context).width * 0.35;
    return Column(
      children: [
        Legend(legendString: heading, fontsize: 18),
        Wrap(
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

  Widget _swayamsewakVehicle({required Vehicle vehicle}) {
    return Column(
      children: [
        Legend(legendString: "VehicleInformation", fontsize: 18),
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

  Widget _swayamsewakExperties({required List<GetCount> expertieslist}) {
    return Column(
      children: [
        Legend(legendString: "Experties", fontsize: 18),
        ListView.builder(
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

  Widget _swayamsewakInterests({required List<GetCount> interestlist}) {
    return Column(
      children: [
        Legend(legendString: "Interests", fontsize: 18),
        ListView.builder(
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

  Widget _swayamsewakUniform({required GanveshData ganvesh}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Legend(legendString: "GanveshDetails", fontsize: 18),
        Single1ColumnRow(
          txtString: Statics.getLabel('HasBelt'),
          value: ganvesh.Hasbelt.toString(),
          fontsize: 15,
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('HasCap'),
          value: ganvesh.Hascap.toString(),
          fontsize: 15,
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('HasDanda'),
          value: ganvesh.Hasdanda.toString(),
          fontsize: 15,
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('HasPant'),
          value: ganvesh.Haspant.toString(),
          fontsize: 15,
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('HasShirt'),
          value: ganvesh.Hasshirt.toString(),
          fontsize: 15,
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('HasShoes'),
          value: ganvesh.Hasshoes.toString(),
          fontsize: 15,
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('HasSocks'),
          value: ganvesh.Hassock.toString(),
          fontsize: 15,
        ),
        Single1ColumnRow(
          txtString: Statics.getLabel('IsGanaveshComplete'),
          value: ganvesh.isganveshcomplted.toString(),
          fontsize: 15,
        ),
      ],
    );
  }

  Widget _swayamsewakByBloodGroup({required List<GetCount> bloodgroup}) {
    double normalwidth = MediaQuery.sizeOf(context).width * 0.75;
    double maxwidth = MediaQuery.sizeOf(context).width * 0.35;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Legend(legendString: "SwayamsevakCountByBloodGroup", fontsize: 18),
        Wrap(
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
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Legend(legendString: "SwayamsevakCountByAge", fontsize: 18),
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
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Legend(legendString: "ShikshitSwayamsevakCount", fontsize: 18),
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
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Legend(legendString: "KaaryakartaaCountByLevel", fontsize: 18),
      TwoColumnRow(txtString: Statics.getLabel('Shaakhaa'), value: shaakhaa, txtString2: Statics.getLabel('SaaptaahikLabelShort'), value2: saptahik, fontsize: 15),
      TwoColumnRow(txtString: Statics.getLabel('MilanMandali'), value: milan, txtString2: Statics.getLabel('VastiKaaryakartaaCount'), value2: vasti, fontsize: 15),
      TwoColumnRow(txtString: Statics.getLabel('GraamKaaryakartaaCount'), value: graam, txtString2: Statics.getLabel('MandalKaaryakartaaCount'), value2: mandal, fontsize: 15),
      TwoColumnRow(txtString: Statics.getLabel('NagarKaaryakartaaCount'), value: nagar, txtString2: Statics.getLabel('ShaharKaaryakartaaCount'), value2: shahar, fontsize: 15),
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
        _cardRow([
          _cardTile(Statics.getLabel('vijayaDashamiUtsav') + '\n' + Statics.getLabel('Vrutta'), () => Navigator.of(context).pushNamed(VijayadashamiFormView.routeName)),
          _cardTile(Statics.getLabel('vijayaDashamiUtsav') + ' ' + Statics.getLabel('Reportonly'), () => Navigator.of(context).pushNamed(VijayadashamiFormReport.routeName)),
        ]),
        _cardRow([
          _cardTile(Statics.getLabel("gruhSamparkAbhiyan"), () => Navigator.of(context).pushNamed(GruhAbhiyaanMainTabScreen.routeName)),
          _cardTile(Statics.getLabel("hinduSammelan"), () => Navigator.of(context).pushNamed(HinduSanmelanMainTab.routeName)),
        ]),
        _cardRow([
          _cardTile(Statics.getLabel("sadbhavBaithak"), () => Navigator.of(context).pushNamed(SadbhavBaithakMainTab.routeName)),
          _cardTile(Statics.getLabel("pramukhJansanvaad"), () => Navigator.of(context).pushNamed(PramukhJansanvadMainTab.routeName)),
        ]),
        _cardRow([
          _cardTile(Statics.getLabel("yuvaSangam"), () => Navigator.of(context).pushNamed(YuvaSangamMainTab.routeName)),
          // _cardTile(Statics.getLabel("yuvaSangam"), () => Fluttertoast.showToast(msg: Statics.getLabel("workInProgress"), gravity: ToastGravity.BOTTOM)),
          _cardTile(Statics.getLabel("shakhaVistaar"), () => Fluttertoast.showToast(msg: Statics.getLabel("workInProgress"), gravity: ToastGravity.BOTTOM)),
        ]),
      ],
    );
  }

  Widget surveyCard() {
    return _card(
      title: Statics.getLabel("Survey"),
      children: [
        _cardRow([
          _cardTile(Statics.getLabel('vastiSurvey'), () => Navigator.of(context).pushNamed(VastiSurveyFormScreen.routeName)),
          _cardTile(Statics.getLabel('mandalSurvey'), () => Navigator.of(context).pushNamed(MandalSurveyFormScreen.routeName)),
        ]),
        _cardRow([
          _cardTile(Statics.getLabel('vastiSurveyReport'), () => Navigator.of(context).pushNamed(VastiSurveyReportScreen.routeName)),
          _cardTile(Statics.getLabel('mandalSurveyReport'), () => Navigator.of(context).pushNamed(MandalSurveyReportScreen.routeName)),
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
          if (_shouldShowForLevel(level)) _cardTile(Statics.getLabel('searchJoinRSSScreenLabel'), () => Navigator.of(context).pushNamed(SearchJoinRss.routeName)),
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
  Widget _cardTile(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        ]),
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
