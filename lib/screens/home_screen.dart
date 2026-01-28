import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanLoginDataResponse.dart';
import 'package:niyojak_prod/screens/ContactUsScreen.dart';
import 'package:niyojak_prod/widgets/legend.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;

import '../helpers/static_data.dart' as Statics;
import '../models/response_model/notification_list_model.dart';
import '../models/response_model/upkhanda_upnagar_report_data_model.dart';
import '../providers/bals.dart';
import '../providers/login.dart';
import '../screens/change_password.dart';
import '../utils/cust_painters.dart';
import '../widgets/app_drawer.dart';
import '../widgets/single_column_row.dart';
import '../widgets/two_column_row.dart';
import './annual_baithak_ekatrit_vrutta.dart';
import './profile_settings.dart';
import './search_annual_baithak_vrutta.dart';
import 'AbhiyanScreen.dart';
import 'levels_update_module/levels_manage_tabs.dart';
import 'notification_list_page.dart';
import 'search_event.dart';
import 'search_join_rss.dart';
import 'search_rjb_nidhi_sankalan.dart';
import 'search_soochi_screen.dart';
import 'shatabdi_vrutta_sankalan/gruh_sampark_abhiyaan/gruh_abhiyaan_main_tab_screen.dart';
import 'shatabdi_vrutta_sankalan/hindu_sanmelan/hindu_sanmelan_form.dart';
import 'shatabdi_vrutta_sankalan/vijayadashami/vijaya_dashami_report.dart';
import 'shatabdi_vrutta_sankalan/vijayadashami/vijayadashami_form_view.dart';
import 'survey_screen/mandal_reports_tabs.dart';
import 'survey_screen/survey_form/mandal_survey_form_view.dart';
import 'survey_screen/survey_form/vasti_survey_form_view.dart';
import 'survey_screen/vasti_reports_tabs.dart';
import 'swayamsevak_search.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController = ScrollController();
  var geoUnitID;
  var geoUnitName;
  PopupMenu? menu;
  GlobalKey btnKey = GlobalKey();

  List<MenuChoices> choices = [];

  bool _isLoading = false;
  bool _isSwExpanded = false;
  bool _isGeounitExpanded = false;
  bool _isNagarTableExpanded = false;
  bool _isSearching = false, _isMySearching = false, _isTgSearching = false;

  List<Widget>? _mySadyasthitiHeaderRow, _tgSadyasthitiHeaderRow;
  String masikMilanCount = '';
  String sanghaMandaliCount = '';
  String totalsankalpitshakhaCount = '';
  String totalsankalpitSaaptaahikCount = '';
  String totalsankalpitMaasikMilanCount = '';
  String ekunSankalpitShakha = '';
  String ekunSankalpitSaptahikMilan = '';
  int _tgLevelID = 13;

  List<Widget>? _myGatividhiKaaryakartaaHeaderRow;
  List<Widget>? _myAayaamKaaryakartaaHeaderRow;
  List<Widget>? _myPreritKaaryakartaaHeaderRow;
  List<Widget>? _mySocialOrgKaaryakartaaHeaderRow;
  List<Widget>? _myStudentCategoryHeaderRow;
  List<Widget>? _myVyavasaayeeCategoryHeaderRow;
  List<Widget>? _myBhaugolikHeaderRow;

  // List<Widget> _myLastMonthBhaugolikHeaderRow;
  List<Widget>? _yesterdayPraantHeaderRow;
  List<Widget>? _mySankalpDataHeaderRow;
  List<Widget>? _myYesterdaySummaryHeaderRow;
  List<Widget>? _myYesterdayDetailHeaderRow;

  List<GeoUnitMasterBAL>? _linkedMahaanagar; //6-12-24
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;

  List<GeoUnitMasterBAL>? _linkedMahaanagar2; //6-12-24
  List<GeoUnitMasterBAL>? _linkedVibhaag2;
  List<GeoUnitMasterBAL>? _linkedbhaag2;
  List<GeoUnitMasterBAL>? _linkedshahar2;
  List<GeoUnitMasterBAL>? _linkednagar2;
  List<GeoUnitMasterBAL>? _linkedmandal2;
  List<GeoUnitMasterBAL>? _linkedgraam2;
  List<GeoUnitMasterBAL>? _linkedvasti2;

  String? _linkedMahaanagarValue = "";
  String? _linkedVibhaagValue = "";
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";

  String _selctedLevelName = "praant";
  String _selctedGeoUnitId = "0";

  String? _linkedMahaanagarValue2 = "";
  String? _linkedVibhaagValue2 = "";
  String? _linkedbhaagValue2 = "";
  String? _linkedshaharValue2 = "";
  String? _linkednagarValue2 = "";
  String? _linkedmandalValue2 = "";
  String? _linkedgraamValue2 = "";
  String? _linkedvastiValue2 = "";

  String? tgMaasikEQ0 = '', myMaasikEQ0 = '';
  String? tgMaasikEQ1 = '', myMaasikEQ1 = '';
  String? tgSaaptaahik1To3 = '', mySaaptaahik1To3 = '';
  String? tgSaaptaahikEQ0 = '', mySaaptaahikEQ0 = '';
  String? tgSaaptaahikGTE4 = '', mySaaptaahikGTE4 = '';
  String? tgShaakhaa1To24 = '', myShaakhaa1To24 = '';
  String? tgShaakhaaEQ0 = '', myShaakhaaEQ0 = '';
  String? tgShaakhaaGTE25 = '', myShaakhaaGTE25 = '';
  String? tgShaakhaaEQ30 = '', myShaakhaaEQ30 = '';

  String? tgTotalKaaryakartaaCount = '', myTotalKaaryakartaaCount = '';
  String? tgPratidnyitCount = '', myPratidnyitCount = '';
  String? tgMasikMilanCount = '', myMasikMilanCount = '';
  String? tgSanghaMandaliCount = '', mySanghaMandaliCount = '';
  String? tgsankalpitshakhaCount = '', mysankalpitshakhaCount = '';
  String? tgShishuCount = '', myShishuCount = '';
  String? tgBaalCount = '', myBaalCount = '';
  String? tgTarunVidyaarthiCount = '', myTarunVidyaarthiCount = '';
  String? tgTarunVyavasaayeeCount = '', myTarunVyavasaayeeCount = '';
  String? tgProudhaVyavasaayeeCount = '', myProudhaVyavasaayeeCount = '';
  String? tgUnknownAgeCount = '', myUnknownAgeCount = '';
  String? tgPraarambhikShikshitCount = '', myPraarambhikShikshitCount = '';
  String? tgPraathamikShikshitCount = '', myPraathamikShikshitCount = '';
  String? tgPrathamVarshaShikshitCount = '', myPrathamVarshaShikshitCount = '';
  String? tgDwitiyaVarshaShikshitCount = '', myDwitiyaVarshaShikshitCount = '';
  String? tgTrutiyaVarshaShikshitCount = '', myTrutiyaVarshaShikshitCount = '';
  String? tgNoShikshanCount = '', myNoShikshanCount = '';
  String? tgShaakhaaKaaryakartaaCount = '', myShaakhaaKaaryakartaaCount = '';
  String? tgVastiKaaryakartaaCount = '', myVastiKaaryakartaaCount = '';
  String? tgGraamKaaryakartaaCount = '', myGraamKaaryakartaaCount = '';
  String? tgMandalKaaryakartaaCount = '', myMandalKaaryakartaaCount = '';
  String? tgNagarKaaryakartaaCount = '', myNagarKaaryakartaaCount = '';
  String? tgShaharKaaryakartaaCount = '', myShaharKaaryakartaaCount = '';
  String? tgBhaagKaaryakartaaCount = '', myBhaagKaaryakartaaCount = '';
  String? tgVibhaagKaaryakartaaCount = '', myVibhaagKaaryakartaaCount = '';
  String? tgMahaanagarKaaryakartaaCount = '', myMahaanagarKaaryakartaaCount = '';
  String? tgPraantKaaryakartaaCount = '', myPraantKaaryakartaaCount = '';
  String? tgKshetraKaaryakartaaCount = '', myKshetraKaaryakartaaCount = '';
  String? tgPravaaseeKaaryakartaaCount = '', myPravaaseeKaaryakartaaCount = '';
  String? tgGatividhiKaaryakartaaCount = '', myGatividhiKaaryakartaaCount = '';
  String? tgAayaamKaaryakartaaCount = '', myAayaamKaaryakartaaCount = '';
  String? tgSanghaPreritSansthaaKaaryakartaaCount = '', mySanghaPreritSansthaaKaaryakartaaCount = '';
  String? tgSocialOrganizationKaaryakartaaCount = '', mySocialOrganizationKaaryakartaaCount = '';
  String? tgDailyShaakhaaKaaryakartaaCount = '', myDailyShaakhaaKaaryakartaaCount = '';
  String? tgSaaptaahikMilanKaaryakartaaCount = '', mySaaptaahikMilanKaaryakartaaCount = '';
  String? tgMaasikMilanKaaryakartaaCount = '', myMaasikMilanKaaryakartaaCount = '';
  String? tgAkhilBhaaratiyaKaaryakartaaCount = '', myAkhilBhaaratiyaKaaryakartaaCount = '';
  String? tgTotalSwayamsevakCount = '', myTotalSwayamsevakCount = '';
  String? userDaayitvaNameforshow;
  String? notificationCount;

  List<Widget>? _tgGatividhiKaaryakartaaHeaderRow;
  List<Widget>? _tgAayaamKaaryakartaaHeaderRow;
  List<Widget>? _tgPreritKaaryakartaaHeaderRow;
  List<Widget>? _tgSocialOrgKaaryakartaaHeaderRow;
  List<Widget>? _tgStudentCategoryHeaderRow;
  List<Widget>? _tgVyavasaayeeCategoryHeaderRow;
  List<Widget>? _tgBhaugolikHeaderRow;

  // List<Widget> _tgLastMonthBhaugolikHeaderRow;
  List<Widget>? _tgSankalpDataHeaderRow;
  List<Widget>? _tgYesterdaySummaryHeaderRow;
  List<Widget>? _tgYesterdayDetailHeaderRow;

  AbhiyanSwayamsevakdata? initialData;
  NotificationListModel? notificationListdata;
  List<UpkhandaDataList> upkhandaDataList = [];

  UpnagarUpkhandaReportModel? bhougolikReportForExcel;

  @override
  void initState() {
    super.initState();
    getInitialData();
    populateChoice();
    populatelinkedMahanagarDropdown();
    populatelinkedVibhaagDropdown();
    populatelinkedMahanagarDropdown2();
    populatelinkedVibhaagDropdown2();
    getGeoUnitID();
    getMyDetailsColumnsAndRows();
    getUpkhandUpnagarReportFun("0", "praant");

    // Load notification data
    fetchNotificationData();
  }

  Future<void> fetchNotificationData() async {
    try {
      notificationListdata = await Statics.getNotificationDataList(Statics.userDetails["userID"]) as NotificationListModel?;
      setState(() {});
    } catch (e) {
      print('Error fetching notification data: $e');
    }
  }

  void populatelinkedMahanagarDropdown() async {
    _linkedVibhaagValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), "", "", "");
    setState(() {
      _linkedMahaanagar = data;
    });
  }

  void populatelinkedVibhaagDropdown() async {
    _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), "", "", "");
    setState(() {
      _linkedVibhaag = data;
    });
  }

  void populatelinkedMahanagarDropdown2() async {
    _linkedVibhaagValue2 = _linkedbhaagValue2 = _linkedshaharValue2 = _linkednagarValue2 = _linkedmandalValue2 = _linkedgraamValue2 = _linkedvastiValue2 = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), "", "", "");
    setState(() {
      _linkedMahaanagar2 = data;
    });
  }

  void populatelinkedVibhaagDropdown2() async {
    _linkedbhaagValue2 = _linkedshaharValue2 = _linkednagarValue2 = _linkedmandalValue2 = _linkedgraamValue2 = _linkedvastiValue2 = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), "", "", "");
    setState(() {
      _linkedVibhaag2 = data;
    });
  }

  void populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, "Vibhaag", "");
    setState(() {
      _linkedbhaag = data;
    });
  }

  void populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedshaharValue = _linkedvastiValue = _linkedshahar = _linkedvasti = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _linkedshahar = (shDD.length > 0 ? shDD : null);
    });
  }

  void populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    }
  }

  void populatelinkedMandalDropdown(String nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
  }

  void populatelinkedGraamDropdown(String mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
  }

  void populatelinkedVastiDropdown(String nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
  }

  Widget _createWidget(String label, double width, double? height, Alignment? alignment, {bool isTotalRow = false}) {
    return Container(
      child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: height,
      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
      alignment: alignment,
      color: (isTotalRow ? Theme.of(context).colorScheme.secondary.withOpacity(0.1) : Colors.white),
    );
  }

  Widget _createWidget2({required String label, BoxConstraints? constraints, double? width, double? height, Alignment? alignment, bool isTotalRow = false}) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: height,
      constraints: constraints,
      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
      alignment: alignment,
      color: (isTotalRow ? Theme.of(context).colorScheme.secondary.withOpacity(0.1) : Colors.white),
    );
  }

  Widget _createAdditionWidget(String text1, String text2, double width, double height, Alignment alignment, {bool isTotalRow = false}) {
    // Convert the text values to integers
    int value1 = int.tryParse(text1) ?? 0;
    int value2 = int.tryParse(text2) ?? 0;

    // Calculate the sum
    int sum = value1 + value2;

    // Return a widget displaying the result
    return Container(
      child: Text(sum.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: height,
      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
      alignment: alignment,
      color: (isTotalRow ? Theme.of(context).colorScheme.secondary.withOpacity(0.1) : Colors.white),
    );
  }

  Widget _mySadyasthitiFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstdashboardSadyaSthitiData.length > 0 && Statics.lstdashboardSadyaSthitiData.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.lstdashboardSadyaSthitiData[index].vayogatCode!, 100, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _mySadyasthitiOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstdashboardSadyaSthitiData.length > 0 && Statics.lstdashboardSadyaSthitiData.length == index + 1) isTotalRow = true;
    return Row(
      children: <Widget>[
        _createWidget(Statics.lstdashboardSadyaSthitiData[index].shaakhaaCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstdashboardSadyaSthitiData[index].sankalpitShaakhaaCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createAdditionWidget(
            Statics.lstdashboardSadyaSthitiData[index].shaakhaaCount.toString(), Statics.lstdashboardSadyaSthitiData[index].sankalpitShaakhaaCount.toString(), 130, 52, Alignment.center,
            isTotalRow: isTotalRow),
        _createWidget(Statics.lstdashboardSadyaSthitiData[index].saaptaahikCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstdashboardSadyaSthitiData[index].sankalpitSaaptaahikCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createAdditionWidget(
            Statics.lstdashboardSadyaSthitiData[index].saaptaahikCount.toString(), Statics.lstdashboardSadyaSthitiData[index].sankalpitSaaptaahikCount.toString(), 130, 52, Alignment.center,
            isTotalRow: isTotalRow),
        _createWidget(Statics.lstdashboardSadyaSthitiData[index].maasikMilanCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstdashboardSadyaSthitiData[index].sankalpitMaasikMilanCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createAdditionWidget(
            Statics.lstdashboardSadyaSthitiData[index].maasikMilanCount.toString(), Statics.lstdashboardSadyaSthitiData[index].sankalpitMaasikMilanCount.toString(), 130, 52, Alignment.center,
            isTotalRow: isTotalRow),
        _createWidget(Statics.lstdashboardSadyaSthitiData[index].sanghaMandaliCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstdashboardSadyaSthitiData[index].sankalpitSanghaMandaliCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createAdditionWidget(
            Statics.lstdashboardSadyaSthitiData[index].sanghaMandaliCount.toString(), Statics.lstdashboardSadyaSthitiData[index].sankalpitSanghaMandaliCount.toString(), 130, 52, Alignment.center,
            isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _tgSadyasthitiFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstdashboardSadyaSthitiData.length > 0 && Statics.tgLstdashboardSadyaSthitiData.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.tgLstdashboardSadyaSthitiData[index].vayogatCode!, 100, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _tgSadyasthitiOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstdashboardSadyaSthitiData.length > 0 && Statics.tgLstdashboardSadyaSthitiData.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.tgLstdashboardSadyaSthitiData[index].shaakhaaCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstdashboardSadyaSthitiData[index].sankalpitShaakhaaCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createAdditionWidget(
            Statics.tgLstdashboardSadyaSthitiData[index].shaakhaaCount.toString(), Statics.tgLstdashboardSadyaSthitiData[index].sankalpitShaakhaaCount.toString(), 130, 52, Alignment.center,
            isTotalRow: isTotalRow),

        _createWidget(Statics.tgLstdashboardSadyaSthitiData[index].saaptaahikCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstdashboardSadyaSthitiData[index].sankalpitSaaptaahikCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createAdditionWidget(
            Statics.tgLstdashboardSadyaSthitiData[index].saaptaahikCount.toString(), Statics.tgLstdashboardSadyaSthitiData[index].sankalpitSaaptaahikCount.toString(), 130, 52, Alignment.center,
            isTotalRow: isTotalRow),

        _createWidget(Statics.tgLstdashboardSadyaSthitiData[index].maasikMilanCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstdashboardSadyaSthitiData[index].sankalpitMaasikMilanCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow), // navin mami
        _createAdditionWidget(
            Statics.tgLstdashboardSadyaSthitiData[index].maasikMilanCount.toString(), Statics.tgLstdashboardSadyaSthitiData[index].sankalpitMaasikMilanCount.toString(), 130, 52, Alignment.center,
            isTotalRow: isTotalRow),

        _createWidget(Statics.tgLstdashboardSadyaSthitiData[index].sanghaMandaliCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstdashboardSadyaSthitiData[index].sankalpitSanghaMandaliCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createAdditionWidget(
            Statics.tgLstdashboardSadyaSthitiData[index].sanghaMandaliCount.toString(), Statics.tgLstdashboardSadyaSthitiData[index].sankalpitSanghaMandaliCount.toString(), 130, 52, Alignment.center,
            isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _yesterdayPraantFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstYesterdayPraantData.length > 0 && Statics.lstYesterdayPraantData.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.lstYesterdayPraantData[index].vayogatCode!, 100, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _yesterdayPraantOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstYesterdayPraantData.length > 0 && Statics.lstYesterdayPraantData.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.lstYesterdayPraantData[index].shaakhaaCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstYesterdayPraantData[index].saaptaahikCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  ///
  List<String> deniedLevels = ["Shakha", "Saptahik Milan", "शाखा", "साप्ताहिक मिलन"];

  bool shouldShowListTile(String userLevel, String userDayitva) {
    // print("userLevel --> $userLevel  === userDayitva --> $userDayitva");
    // print(allowedLevels.contains(userLevel) && allowedDayitva.contains(userDayitva));
    ///
    return !deniedLevels.contains(userLevel);

    ///
    // return allowedLevels.contains(userLevel); // && allowedDayitva.contains(userDayitva);
  }

  ///
  List<String> allowedLevelsforGeounitCHange = ["Praant", "प्रांत", "Mahaanagar", "महानगर", "Vibhaag", "विभाग", "Bhaag", "भाग", "भाग/जिल्हा", "भाग/जिला", "Nagar", "Nagar/Taalukaa", "नगर/तालुका"];

  List<String> allowedDayitvaforGeounitCHange = [
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
    "अभियान प्रमुख"
  ];

  bool shouldShowListTileforGeounitCHange(String userLevel, String userDayitva) {
    // print("userLevel --> $userLevel  === userDayitva --> $userDayitva");
    // print(allowedLevels.contains(userLevel) && allowedDayitva.contains(userDayitva));
    return allowedLevelsforGeounitCHange.contains(userLevel) && allowedDayitvaforGeounitCHange.contains(userDayitva);
  }

  ///

  // Widget _myLastMonthBhagolikVistaarFirstColumn(BuildContext context, int index) {
  //   bool isTotalRow = false;
  //   return
  //     Statics.lstLastMonthBhaugolikVistaar == null || Statics.lstLastMonthBhaugolikVistaar[index] == null
  //     ? null
  //     : Statics.createWidgetFromString(context, Statics.getLabel(Statics.lstLastMonthBhaugolikVistaar[index].levelName), 100, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  // }

  // Widget _myLastMonthBhagolikVistaarOtherColumns(BuildContext context, int index) {
  //   bool isTotalRow = false;
  //   return Row(
  //     children: <Widget>[
  //       Statics.createWidgetFromString(context, Statics.lstLastMonthBhaugolikVistaar[index].totalCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
  //       Statics.createWidgetFromString(context, Statics.lstLastMonthBhaugolikVistaar[index].shaakhaaYuktaCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
  //       Statics.createWidgetFromString(context, Statics.lstLastMonthBhaugolikVistaar[index].saaptaahikYuktaCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
  //       Statics.createWidgetFromString(context, Statics.lstLastMonthBhaugolikVistaar[index].mandaliYuktaCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
  //     ],
  //   );
  // }

  // Widget _tgLastMonthBhagolikVistaarFirstColumn(BuildContext context, int index) {
  //   bool isTotalRow = false;
  //   return
  //     Statics.tgLstLastMonthBhaugolikVistaar == null || Statics.tgLstLastMonthBhaugolikVistaar[index] == null
  //     ? null
  //     : Statics.createWidgetFromString(context, Statics.getLabel(Statics.tgLstLastMonthBhaugolikVistaar[index].levelName), 100, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  // }

  // Widget _tgLastMonthBhagolikVistaarOtherColumns(BuildContext context, int index) {
  //   bool isTotalRow = false;
  //   return Row(
  //     children: <Widget>[
  //       Statics.createWidgetFromString(context, Statics.tgLstLastMonthBhaugolikVistaar[index].totalCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
  //       Statics.createWidgetFromString(context, Statics.tgLstLastMonthBhaugolikVistaar[index].shaakhaaYuktaCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
  //       Statics.createWidgetFromString(context, Statics.tgLstLastMonthBhaugolikVistaar[index].saaptaahikYuktaCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
  //       Statics.createWidgetFromString(context, Statics.tgLstLastMonthBhaugolikVistaar[index].mandaliYuktaCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
  //     ],
  //   );
  // }

  Widget _myBhagolikVistaarFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    return _createWidget(Statics.getLabel(Statics.lstBhaugolikVistaar[index].levelName!), 100, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _myBhagolikVistaarOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    return Row(
      children: <Widget>[
        _createWidget(Statics.lstBhaugolikVistaar[index].totalCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstBhaugolikVistaar[index].shaakhaaYuktaCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstBhaugolikVistaar[index].saaptaahikYuktaCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstBhaugolikVistaar[index].mandaliYuktaCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _tgBhagolikVistaarFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    return _createWidget(Statics.getLabel(Statics.tgLstBhaugolikVistaar[index].levelName!), 100, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _tgBhagolikVistaarOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    return Row(
      children: <Widget>[
        _createWidget(Statics.tgLstBhaugolikVistaar[index].totalCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstBhaugolikVistaar[index].shaakhaaYuktaCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstBhaugolikVistaar[index].saaptaahikYuktaCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstBhaugolikVistaar[index].mandaliYuktaCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _mySankalpDataFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstSankalpByAadhaarData.length > 0 && Statics.lstSankalpByAadhaarData.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.lstSankalpByAadhaarData[index].vayogatCode!, 100, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _mySankalpDataOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    String sankalpAadhaar = Statics.lstSankalpByAadhaarData[index].sankalpAadhaar == '' ? '' : Statics.getLabel(Statics.lstSankalpByAadhaarData[index].sankalpAadhaar!);
    if (Statics.lstSankalpByAadhaarData.length > 0 && Statics.lstSankalpByAadhaarData.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(sankalpAadhaar, 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstSankalpByAadhaarData[index].sankalpitShaakhaaCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstSankalpByAadhaarData[index].sankalpitSaaptaahikCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstSankalpByAadhaarData[index].sankalpitMasikMilankCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstSankalpByAadhaarData[index].sankalpitSanghaMandalikCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _tgSankalpDataFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstSankalpByAadhaarData.length > 0 && Statics.tgLstSankalpByAadhaarData.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.tgLstSankalpByAadhaarData[index].vayogatCode!, 100, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _tgSankalpDataOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    String sankalpAadhaar = Statics.tgLstSankalpByAadhaarData[index].sankalpAadhaar == '' ? '' : Statics.getLabel(Statics.tgLstSankalpByAadhaarData[index].sankalpAadhaar!);
    if (Statics.tgLstSankalpByAadhaarData.length > 0 && Statics.tgLstSankalpByAadhaarData.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(sankalpAadhaar, 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstSankalpByAadhaarData[index].sankalpitShaakhaaCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstSankalpByAadhaarData[index].sankalpitSaaptaahikCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstSankalpByAadhaarData[index].sankalpitMasikMilankCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstSankalpByAadhaarData[index].sankalpitSanghaMandalikCount.toString(), 130, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _myStudentCategoryFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstStudentCategory.length > 0 && Statics.lstStudentCategory.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.lstStudentCategory[index].studentCategoryName!, 150, index == 0 ? 72 : 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _myStudentCategoryOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstStudentCategory.length > 0 && Statics.lstStudentCategory.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.lstStudentCategory[index].countByStudentCategory.toString(), 150, index == 0 ? 72 : 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _tgStudentCategoryFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstStudentCategory.length > 0 && Statics.tgLstStudentCategory.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.tgLstStudentCategory[index].studentCategoryName!, 150, index == 0 ? 72 : 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _tgStudentCategoryOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstStudentCategory.length > 0 && Statics.tgLstStudentCategory.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.tgLstStudentCategory[index].countByStudentCategory.toString(), 150, index == 0 ? 72 : 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _myVyavasaayeeCategoryFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstVyavasaayeeCategory.length > 0 && Statics.lstVyavasaayeeCategory.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.lstVyavasaayeeCategory[index].vyavasaayeeCategoryName!, 150, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _myVyavasaayeeCategoryOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstVyavasaayeeCategory.length > 0 && Statics.lstVyavasaayeeCategory.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.lstVyavasaayeeCategory[index].countByVyavasaayeeCategory.toString(), 150, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _tgVyavasaayeeCategoryFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstVyavasaayeeCategory.length > 0 && Statics.tgLstVyavasaayeeCategory.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.tgLstVyavasaayeeCategory[index].vyavasaayeeCategoryName!, 150, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _tgVyavasaayeeCategoryOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstVyavasaayeeCategory.length > 0 && Statics.tgLstVyavasaayeeCategory.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.tgLstVyavasaayeeCategory[index].countByVyavasaayeeCategory.toString(), 150, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _myGatividhiKaaryakartaaFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstGatividhiKaaryakartaa.length > 0 && Statics.lstGatividhiKaaryakartaa.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.lstGatividhiKaaryakartaa[index].gatividhiName!, 150, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _myGatividhiKaaryakartaaOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstGatividhiKaaryakartaa.length > 0 && Statics.lstGatividhiKaaryakartaa.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.lstGatividhiKaaryakartaa[index].kaaryakartaaCount.toString(), 150, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _tgGatividhiKaaryakartaaFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstGatividhiKaaryakartaa.length > 0 && Statics.tgLstGatividhiKaaryakartaa.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.tgLstGatividhiKaaryakartaa[index].gatividhiName!, 150, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _tgGatividhiKaaryakartaaOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstGatividhiKaaryakartaa.length > 0 && Statics.tgLstGatividhiKaaryakartaa.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.tgLstGatividhiKaaryakartaa[index].kaaryakartaaCount.toString(), 150, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _myAayaamKaaryakartaaFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstAayaamKaaryakartaa.length > 0 && Statics.lstAayaamKaaryakartaa.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.lstAayaamKaaryakartaa[index].aayaamName!, 150, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _myAayaamKaaryakartaaOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstAayaamKaaryakartaa.length > 0 && Statics.lstAayaamKaaryakartaa.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.lstAayaamKaaryakartaa[index].kaaryakartaaCount.toString(), 150, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _tgAayaamKaaryakartaaFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstAayaamKaaryakartaa.length > 0 && Statics.tgLstAayaamKaaryakartaa.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.tgLstAayaamKaaryakartaa[index].aayaamName!, 150, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _tgAayaamKaaryakartaaOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstAayaamKaaryakartaa.length > 0 && Statics.tgLstAayaamKaaryakartaa.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.tgLstAayaamKaaryakartaa[index].kaaryakartaaCount.toString(), 150, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _myPreritKaaryakartaaFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstPreritKaaryakartaa.length > 0 && Statics.lstPreritKaaryakartaa.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.lstPreritKaaryakartaa[index].preritAOOName!, 150, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _myPreritKaaryakartaaOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstPreritKaaryakartaa.length > 0 && Statics.lstPreritKaaryakartaa.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.lstPreritKaaryakartaa[index].kaaryakartaaCount.toString(), 150, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _tgPreritKaaryakartaaFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstPreritKaaryakartaa.length > 0 && Statics.tgLstPreritKaaryakartaa.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.tgLstPreritKaaryakartaa[index].preritAOOName!, 150, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _tgPreritKaaryakartaaOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstPreritKaaryakartaa.length > 0 && Statics.tgLstPreritKaaryakartaa.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.tgLstPreritKaaryakartaa[index].kaaryakartaaCount.toString(), 150, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _mySocialOrgKaaryakartaaFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstSocialOrgKaaryakartaa.length > 0 && Statics.lstSocialOrgKaaryakartaa.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.lstSocialOrgKaaryakartaa[index].mainAOOName!, 150, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _mySocialOrgKaaryakartaaOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstSocialOrgKaaryakartaa.length > 0 && Statics.lstSocialOrgKaaryakartaa.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.lstSocialOrgKaaryakartaa[index].kaaryakartaaCount.toString(), 150, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _tgSocialOrgKaaryakartaaFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstSocialOrgKaaryakartaa.length > 0 && Statics.tgLstSocialOrgKaaryakartaa.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.tgLstSocialOrgKaaryakartaa[index].mainAOOName!, 150, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _tgSocialOrgKaaryakartaaOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstSocialOrgKaaryakartaa.length > 0 && Statics.tgLstSocialOrgKaaryakartaa.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.tgLstSocialOrgKaaryakartaa[index].kaaryakartaaCount.toString(), 150, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _myYesterdaySummaryFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstYesterdayVruttaSummary.length > 0 && Statics.lstYesterdayVruttaSummary.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.lstYesterdayVruttaSummary[index].geoUnitName!, 100, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _myYesterdaySummaryOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstYesterdayVruttaSummary.length > 0 && Statics.lstYesterdayVruttaSummary.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.lstYesterdayVruttaSummary[index].vayogatCode.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstYesterdayVruttaSummary[index].shaakhaaCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstYesterdayVruttaSummary[index].saaptaahikCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstYesterdayVruttaSummary[index].milanMandaliCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _tgYesterdaySummaryFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstYesterdayVruttaSummary.length > 0 && Statics.tgLstYesterdayVruttaSummary.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.tgLstYesterdayVruttaSummary[index].geoUnitName!, 100, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _tgYesterdaySummaryOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstYesterdayVruttaSummary.length > 0 && Statics.tgLstYesterdayVruttaSummary.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.tgLstYesterdayVruttaSummary[index].vayogatCode.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstYesterdayVruttaSummary[index].shaakhaaCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstYesterdayVruttaSummary[index].saaptaahikCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstYesterdayVruttaSummary[index].milanMandaliCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _myYesterdayDetailFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstYesterdayVruttaDetail.length > 0 && Statics.lstYesterdayVruttaDetail.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.lstYesterdayVruttaDetail[index].geoUnitName!, 100, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _myYesterdayDetailOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.lstYesterdayVruttaDetail.length > 0 && Statics.lstYesterdayVruttaDetail.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.lstYesterdayVruttaDetail[index].frequencyCode.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstYesterdayVruttaDetail[index].vayogatCode.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstYesterdayVruttaDetail[index].baalVidyaarthiCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstYesterdayVruttaDetail[index].tarunVidyaarthiCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstYesterdayVruttaDetail[index].tarunVyavasaayeeCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstYesterdayVruttaDetail[index].proudhaVyavasaayeeCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstYesterdayVruttaDetail[index].shishuCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.lstYesterdayVruttaDetail[index].abhyaagatCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  Widget _tgYesterdayDetailFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstYesterdayVruttaDetail.length > 0 && Statics.tgLstYesterdayVruttaDetail.length == index + 1) isTotalRow = true;
    return _createWidget(Statics.tgLstYesterdayVruttaDetail[index].geoUnitName!, 100, 52, Alignment.centerLeft, isTotalRow: isTotalRow);
  }

  Widget _tgYesterdayDetailOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    if (Statics.tgLstYesterdayVruttaDetail.length > 0 && Statics.tgLstYesterdayVruttaDetail.length == index + 1) isTotalRow = true;

    return Row(
      children: <Widget>[
        _createWidget(Statics.tgLstYesterdayVruttaDetail[index].frequencyCode.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstYesterdayVruttaDetail[index].vayogatCode.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstYesterdayVruttaDetail[index].baalVidyaarthiCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstYesterdayVruttaDetail[index].tarunVidyaarthiCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstYesterdayVruttaDetail[index].tarunVyavasaayeeCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstYesterdayVruttaDetail[index].proudhaVyavasaayeeCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstYesterdayVruttaDetail[index].shishuCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
        _createWidget(Statics.tgLstYesterdayVruttaDetail[index].abhyaagatCount.toString(), 100, 52, Alignment.center, isTotalRow: isTotalRow),
      ],
    );
  }

  getUpkhandUpnagarReportFun(String? targetGeoUnitID, String levelName) async {
    setState(() {
      _isLoading = true;
    });
    var data = await Statics.upkhandUpnagarReportData(userID: Statics.userDetails["userID"], targetGeoUnitID: targetGeoUnitID, type: levelName);
    setState(() {
      _isLoading = false;
    });
    if (data != null) {
      setState(() {
        upkhandaDataList = data.dataList ?? [];
      });
    }
  }

  void getMyDetailsColumnsAndRows() async {
    List<Widget> mySadyasthitiHeaderRow = [];
    List<Widget> myGatividhiHeaderRow = [];
    List<Widget> myAayaamHeaderRow = [];
    List<Widget> myPreritHeaderRow = [];
    List<Widget> mySocialOrgHeaderRow = [];
    List<Widget> myStudentCategoryHeaderRow = [];
    List<Widget> myVyavasaayeeHeaderRow = [];
    List<Widget> myYesterdaySummaryHeaderRow = [];
    List<Widget> myYesterdayDetailHeaderRow = [];
    List<Widget> yesterdayPraantHeaderRow = [];
    List<Widget> myBhaugolikHeaderRow = [];
    // List<Widget> myLastMonthBhaugolikHeaderRow = [];
    List<Widget> mySankalpDataHeaderRow = [];

    int totMaasikMilanCount = 0, totSanghaMandaliCount = 0, totsankalpitshakha = 0, totsankalpitSaaptaahik = 0;

    dynamic stateSadyasthitiHeaderRow,
        stateMaasikCount,
        stateMandaliCount,
        statetotalsankalpitshakha,
        statesankalpitSaaptaahik,
        stateGatividhiHeaderRow,
        stateBhaugolikHeaderRow,
        /*stateLastMonthBhaugolikHeaderRow,*/
        stateYesterdayPraantHeaderRow,
        stateSankalpDataHeaderRow,
        statePreritHeaderRow,
        stateSocialOrgHeaderRow,
        stateStudentCategoryHeaderRow,
        stateAayaamHeaderRow,
        stateVyavasaayeeHeaderRow,
        stateYesterdaySummaryHeaderRow,
        stateYesterdayDetailHeaderRow;

    setState(() {
      _isMySearching = true;
    });
    var data = await Statics.refreshDashboardData(Statics.userDetails["userID"], geoUnitID);
    if (data['Status'] == "Success") {
      setState(() {
        myTotalKaaryakartaaCount = data["HomeScreenData"]["TotalKaaryakartaaCount"].toString();
        myPratidnyitCount = data["HomeScreenData"]["PratidnyitCount"].toString();
        myShishuCount = data["HomeScreenData"]["ShishuCount"].toString();
        myBaalCount = data["HomeScreenData"]["BaalCount"].toString();
        myTarunVidyaarthiCount = data["HomeScreenData"]["TarunVidyaarthiCount"].toString();
        myTarunVyavasaayeeCount = data["HomeScreenData"]["TarunVyavasaayeeCount"].toString();
        myProudhaVyavasaayeeCount = data["HomeScreenData"]["ProudhaVyavasaayeeCount"].toString();
        myUnknownAgeCount = data["HomeScreenData"]["UnknownAgeCount"].toString();
        myPraarambhikShikshitCount = data["HomeScreenData"]["PrarambhikShikshitCount"].toString();
        myPraathamikShikshitCount = data["HomeScreenData"]["PraathamikShikshitCount"].toString();
        myPrathamVarshaShikshitCount = data["HomeScreenData"]["PrathamVarshaShikshitCount"].toString();
        myDwitiyaVarshaShikshitCount = data["HomeScreenData"]["DwitiyaVarshaShikshitCount"].toString();
        myTrutiyaVarshaShikshitCount = data["HomeScreenData"]["TrutiyaVarshaShikshitCount"].toString();
        myNoShikshanCount = data["HomeScreenData"]["NoShikshanCount"].toString();
        myDailyShaakhaaKaaryakartaaCount = data["HomeScreenData"]["DailyShaakhaaKaaryakartaaCount"].toString();
        mySaaptaahikMilanKaaryakartaaCount = data["HomeScreenData"]["SaaptaahikMilanKaaryakartaaCount"].toString();
        myMaasikMilanKaaryakartaaCount = data["HomeScreenData"]["MaasikMilanKaaryakartaaCount"].toString();
        myVastiKaaryakartaaCount = data["HomeScreenData"]["VastiKaaryakartaaCount"].toString();
        myGraamKaaryakartaaCount = data["HomeScreenData"]["GraamKaaryakartaaCount"].toString();
        myMandalKaaryakartaaCount = data["HomeScreenData"]["MandalKaaryakartaaCount"].toString();
        myNagarKaaryakartaaCount = data["HomeScreenData"]["NagarKaaryakartaaCount"].toString();
        myShaharKaaryakartaaCount = data["HomeScreenData"]["ShaharKaaryakartaaCount"].toString();
        myBhaagKaaryakartaaCount = data["HomeScreenData"]["BhaagKaaryakartaaCount"].toString();
        myVibhaagKaaryakartaaCount = data["HomeScreenData"]["VibhaagKaaryakartaaCount"].toString();
        myMahaanagarKaaryakartaaCount = data["HomeScreenData"]["MahaanagarKaaryakartaaCount"].toString();
        myPraantKaaryakartaaCount = data["HomeScreenData"]["PraantKaaryakartaaCount"].toString();
        notificationCount = data["HomeScreenData"]["Notificationcount"].toString();
        myKshetraKaaryakartaaCount = data["HomeScreenData"]["KshetraKaaryakartaaCount"].toString();
        myAkhilBhaaratiyaKaaryakartaaCount = data["HomeScreenData"]["AkhilBhaaratiyaKaaryakartaaCount"].toString();
        myPravaaseeKaaryakartaaCount = data["HomeScreenData"]["PravaaseeKaaryakartaaCount"].toString();
        myTotalKaaryakartaaCount = data["HomeScreenData"]["TotalKaaryakartaaCount"].toString();
        myGatividhiKaaryakartaaCount = data["HomeScreenData"]["GatividhiKaaryakartaaCount"].toString();
        myAayaamKaaryakartaaCount = data["HomeScreenData"]["AayaamKaaryakartaaCount"].toString();
        mySanghaPreritSansthaaKaaryakartaaCount = data["HomeScreenData"]["SanghaPreritSansthaaKaaryakartaaCount"].toString();
        mySocialOrganizationKaaryakartaaCount = data["HomeScreenData"]["SocialOrganizationKaaryakartaaCount"].toString();
        myTotalSwayamsevakCount = data["HomeScreenData"]["TotalSwayamsevakCount"].toString();

        myMaasikEQ0 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["MaasikEQ0"].toString();
        myMaasikEQ1 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["MaasikEQ1"].toString();
        mySaaptaahikEQ0 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["SaaptaahikEQ0"].toString();
        mySaaptaahik1To3 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["Saaptaahik1To3"].toString();
        mySaaptaahikGTE4 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["SaaptaahikGTE4"].toString();
        myShaakhaaEQ0 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["ShaakhaaEQ0"].toString();
        myShaakhaa1To24 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["Shaakhaa1To24"].toString();
        myShaakhaaGTE25 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["ShaakhaaGTE25"].toString();
        myShaakhaaEQ30 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["ShaakhaaEQ30"].toString();

        //Statics.populateDashboardDetailsMap();
      });

      if (Statics.lstdashboardSadyaSthitiData.length > 0) {
        mySadyasthitiHeaderRow = [];
        mySadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('Vayogat'), 100, 70, Alignment.center, isTotalRow: false));

        mySadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('RegisterShaakhaa'), 130, 70, Alignment.centerLeft, isTotalRow: false));
        mySadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('SankalpitShaakhaa'), 130, 70, Alignment.centerLeft, isTotalRow: false));
        mySadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('TotalSankalpitShaakhaa'), 130, 70, Alignment.centerLeft, isTotalRow: false));

        mySadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('RegisteredSaaptaahikMilan'), 130, 70, Alignment.centerLeft, isTotalRow: false));
        mySadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('SankalpitSaaptaahikMilan'), 130, 70, Alignment.centerLeft, isTotalRow: false));
        mySadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('TotalSankalpitSaaptaahikMilan'), 130, 70, Alignment.centerLeft, isTotalRow: false));

        mySadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('RegisteredMasikMilan'), 130, 70, Alignment.centerLeft, isTotalRow: false));
        mySadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('SankalpitMasikMilan'), 130, 70, Alignment.centerLeft, isTotalRow: false));
        mySadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('TotalSankalpitMasikMilan'), 130, 70, Alignment.centerLeft, isTotalRow: false));

        mySadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('RegisteredSanghaMandali'), 130, 70, Alignment.centerLeft, isTotalRow: false));
        mySadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('SankalpitSanghMandali'), 130, 70, Alignment.centerLeft, isTotalRow: false));
        mySadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('TotalSankalpitSanghMandali'), 130, 70, Alignment.centerLeft, isTotalRow: false));

        for (var data in Statics.lstdashboardSadyaSthitiData) {
          if (data.vayogatID == -1) {
            totMaasikMilanCount = data.maasikMilanCount!;
            totSanghaMandaliCount = data.sanghaMandaliCount!;
            totsankalpitshakha = data.sankalpitShaakhaaCount!;
            totsankalpitSaaptaahik = data.sankalpitSaaptaahikCount!;
          }
        }
        stateSadyasthitiHeaderRow = mySadyasthitiHeaderRow;
        stateMaasikCount = totMaasikMilanCount.toString();
        stateMandaliCount = totSanghaMandaliCount.toString();
        statetotalsankalpitshakha = totsankalpitshakha.toString();
        statesankalpitSaaptaahik = totsankalpitSaaptaahik.toString();
      } else {
        stateSadyasthitiHeaderRow = null;
        stateMaasikCount = '0';
        stateMandaliCount = '0';
        statetotalsankalpitshakha = '0';
        statesankalpitSaaptaahik = '0';
      }

      if (Statics.lstGatividhiKaaryakartaa.length > 0) {
        myGatividhiHeaderRow = [];
        myGatividhiHeaderRow.add(_createWidget(Statics.getLabel('Gatividhi'), 150, 56, Alignment.centerLeft, isTotalRow: false));
        myGatividhiHeaderRow.add(_createWidget(Statics.getLabel('KaaryakartaaCount'), 150, 56, Alignment.center, isTotalRow: false));
        stateGatividhiHeaderRow = myGatividhiHeaderRow;
      } else {
        stateGatividhiHeaderRow = null;
      }

      if (Statics.lstAayaamKaaryakartaa.length > 0) {
        myAayaamHeaderRow = [];
        myAayaamHeaderRow.add(_createWidget(Statics.getLabel('Aayaam'), 150, 56, Alignment.centerLeft, isTotalRow: false));
        myAayaamHeaderRow.add(_createWidget(Statics.getLabel('KaaryakartaaCount'), 150, 56, Alignment.center, isTotalRow: false));
        stateAayaamHeaderRow = myAayaamHeaderRow;
      } else {
        stateAayaamHeaderRow = null;
      }

      if (Statics.lstPreritKaaryakartaa.length > 0) {
        myPreritHeaderRow = [];
        myPreritHeaderRow.add(_createWidget(Statics.getLabel('AreaOfOperations'), 150, 56, Alignment.centerLeft, isTotalRow: false));
        myPreritHeaderRow.add(_createWidget(Statics.getLabel('KaaryakartaaCount'), 150, 56, Alignment.center, isTotalRow: false));
        statePreritHeaderRow = myPreritHeaderRow;
      } else {
        statePreritHeaderRow = null;
      }

      if (Statics.lstSocialOrgKaaryakartaa.length > 0) {
        mySocialOrgHeaderRow = [];
        mySocialOrgHeaderRow.add(_createWidget(Statics.getLabel('AreaOfOperations'), 150, 56, Alignment.centerLeft, isTotalRow: false));
        mySocialOrgHeaderRow.add(_createWidget(Statics.getLabel('KaaryakartaaCount'), 150, 56, Alignment.center, isTotalRow: false));

        stateSocialOrgHeaderRow = mySocialOrgHeaderRow;
      } else {
        stateSocialOrgHeaderRow = null;
      }

      if (Statics.lstStudentCategory.length > 0) {
        myStudentCategoryHeaderRow = [];
        myStudentCategoryHeaderRow.add(_createWidget(Statics.getLabel('StudentCategory'), 150, 56, Alignment.centerLeft, isTotalRow: false));
        myStudentCategoryHeaderRow.add(_createWidget(Statics.getLabel('SwayamsevakCount'), 150, 56, Alignment.center, isTotalRow: false));
        stateStudentCategoryHeaderRow = myStudentCategoryHeaderRow;
      } else {
        stateStudentCategoryHeaderRow = null;
      }
      if (Statics.lstVyavasaayeeCategory.length > 0) {
        myVyavasaayeeHeaderRow = [];
        myVyavasaayeeHeaderRow.add(_createWidget(Statics.getLabel('VyavasaayeeCategory'), 150, 56, Alignment.centerLeft, isTotalRow: false));
        myVyavasaayeeHeaderRow.add(_createWidget(Statics.getLabel('SwayamsevakCount'), 150, 56, Alignment.center, isTotalRow: false));
        stateVyavasaayeeHeaderRow = myVyavasaayeeHeaderRow;
      } else {
        stateVyavasaayeeHeaderRow = null;
      }
      if (Statics.lstYesterdayVruttaSummary.length > 0) {
        myYesterdaySummaryHeaderRow = [];
        String fcHeader = '';
        if (_tgLevelID > 7)
          fcHeader = Statics.getLabel('Bhaag');
        else if (_tgLevelID == 7)
          fcHeader = Statics.getLabel('Nagar');
        else if (_tgLevelID == 6)
          fcHeader = Statics.getLabel('Mandal/Vasti');
        else if (_tgLevelID == 5)
          fcHeader = Statics.getLabel('Nagar/Vasti');
        else if (_tgLevelID == 4)
          fcHeader = Statics.getLabel('Graam');
        else
          fcHeader = Statics.getLabel('Shaakhaa');
        myYesterdaySummaryHeaderRow.add(_createWidget(fcHeader, 100, 56, Alignment.centerLeft, isTotalRow: false));
        myYesterdaySummaryHeaderRow.add(_createWidget(Statics.getLabel('Vayogat'), 100, 56, Alignment.center, isTotalRow: false));
        myYesterdaySummaryHeaderRow.add(_createWidget(Statics.getLabel('Shaakhaa'), 100, 56, Alignment.center, isTotalRow: false));
        myYesterdaySummaryHeaderRow.add(_createWidget(Statics.getLabel('SaaptaahikMilan'), 100, 56, Alignment.center, isTotalRow: false));
        myYesterdaySummaryHeaderRow.add(_createWidget(Statics.getLabel('MilanMandali'), 100, 56, Alignment.center, isTotalRow: false));
        stateYesterdaySummaryHeaderRow = myYesterdaySummaryHeaderRow;
      } else {
        stateYesterdaySummaryHeaderRow = null;
      }
      if (Statics.lstYesterdayVruttaDetail.length > 0) {
        myYesterdayDetailHeaderRow = [];
        myYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('GeoUnitName'), 100, 56, Alignment.center, isTotalRow: false));
        myYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('FrequencyCode'), 100, 56, Alignment.center, isTotalRow: false));
        myYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('VayogatCode'), 100, 56, Alignment.center, isTotalRow: false));
        myYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('BaalCount'), 100, 56, Alignment.center, isTotalRow: false));
        myYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('TarunVidyaarthiCount'), 100, 56, Alignment.center, isTotalRow: false));
        myYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('TarunVyavasaayeeCount'), 100, 56, Alignment.center, isTotalRow: false));
        myYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('ProudhaCount'), 100, 56, Alignment.center, isTotalRow: false));
        myYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('ShishuCount'), 100, 56, Alignment.center, isTotalRow: false));
        myYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('AbhyaagatCount'), 100, 56, Alignment.center, isTotalRow: false));

        stateYesterdayDetailHeaderRow = myYesterdayDetailHeaderRow;
      } else {
        stateYesterdayDetailHeaderRow = null;
      }

      if (Statics.lstBhaugolikVistaar.length > 0) {
        myBhaugolikHeaderRow = [];
        myBhaugolikHeaderRow.add(_createWidget(Statics.getLabel('LevelName'), 100, 56, Alignment.centerLeft, isTotalRow: false));
        myBhaugolikHeaderRow.add(_createWidget(Statics.getLabel('Total'), 100, 56, Alignment.center, isTotalRow: false));
        myBhaugolikHeaderRow.add(_createWidget(Statics.getLabel('ShaakhaaYuktaLabel'), 100, 56, Alignment.center, isTotalRow: false));
        myBhaugolikHeaderRow.add(_createWidget(Statics.getLabel('SaaptaahikSLabel'), 100, 56, Alignment.center, isTotalRow: false));
        myBhaugolikHeaderRow.add(_createWidget(Statics.getLabel('MaasikYuktaLabel'), 100, 56, Alignment.center, isTotalRow: false));

        stateBhaugolikHeaderRow = myBhaugolikHeaderRow;
      } else {
        stateBhaugolikHeaderRow = null;
      }

      // if (Statics.lstLastMonthBhaugolikVistaar.length > 0) {
      //   myLastMonthBhaugolikHeaderRow = [];
      //   myLastMonthBhaugolikHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('LevelName'), 100, 56, Alignment.centerLeft, isTotalRow: false));
      //   myLastMonthBhaugolikHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Total'), 100, 56, Alignment.center, isTotalRow: false));
      //   myLastMonthBhaugolikHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('ShaakhaaYuktaLabel'), 100, 56, Alignment.center, isTotalRow: false));
      //   myLastMonthBhaugolikHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('SaaptaahikSLabel'), 100, 56, Alignment.center, isTotalRow: false));
      //   myLastMonthBhaugolikHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('MaasikYuktaLabel'), 100, 56, Alignment.center, isTotalRow: false));

      //   stateLastMonthBhaugolikHeaderRow = myLastMonthBhaugolikHeaderRow;
      // } else {
      //   stateLastMonthBhaugolikHeaderRow = null;
      // }

      if (Statics.lstYesterdayPraantData.length > 0) {
        yesterdayPraantHeaderRow = [];
        yesterdayPraantHeaderRow.add(_createWidget(Statics.getLabel('Vayogat'), 100, 56, Alignment.center, isTotalRow: false));
        yesterdayPraantHeaderRow.add(_createWidget(Statics.getLabel('Shaakhaa'), 100, 56, Alignment.center, isTotalRow: false));
        yesterdayPraantHeaderRow.add(_createWidget(Statics.getLabel('SaaptaahikMilan'), 100, 56, Alignment.center, isTotalRow: false));

        stateYesterdayPraantHeaderRow = yesterdayPraantHeaderRow;
      } else {
        stateYesterdayPraantHeaderRow = null;
      }

      if (Statics.lstSankalpByAadhaarData.length > 0) {
        mySankalpDataHeaderRow = [];
        mySankalpDataHeaderRow.add(_createWidget(Statics.getLabel('Vayogat'), 100, 70, Alignment.center));
        mySankalpDataHeaderRow.add(_createWidget(Statics.getLabel('SankalpAadhaar'), 130, 70, Alignment.center));
        mySankalpDataHeaderRow.add(_createWidget(Statics.getLabel('SankalpitShaakhaa'), 130, 70, Alignment.center));
        mySankalpDataHeaderRow.add(_createWidget(Statics.getLabel('SankalpitSaaptaahikMilan'), 130, 70, Alignment.center));
        mySankalpDataHeaderRow.add(_createWidget(Statics.getLabel('SankalpitMasikMilan'), 130, 70, Alignment.center));
        mySankalpDataHeaderRow.add(_createWidget(Statics.getLabel('SankalpitSanghMandali'), 130, 70, Alignment.center));
        stateSankalpDataHeaderRow = mySankalpDataHeaderRow;
      } else {
        stateSankalpDataHeaderRow = null;
      }

      setState(() {
        masikMilanCount = stateMaasikCount;
        sanghaMandaliCount = stateMandaliCount;
        totalsankalpitshakhaCount = statetotalsankalpitshakha;
        totalsankalpitSaaptaahikCount = statesankalpitSaaptaahik;
        _mySadyasthitiHeaderRow = stateSadyasthitiHeaderRow;
        _myGatividhiKaaryakartaaHeaderRow = stateGatividhiHeaderRow;
        _myAayaamKaaryakartaaHeaderRow = stateAayaamHeaderRow;
        _myPreritKaaryakartaaHeaderRow = statePreritHeaderRow;
        _mySocialOrgKaaryakartaaHeaderRow = stateSocialOrgHeaderRow;
        _myStudentCategoryHeaderRow = stateStudentCategoryHeaderRow;
        _myVyavasaayeeCategoryHeaderRow = stateVyavasaayeeHeaderRow;
        _myBhaugolikHeaderRow = stateBhaugolikHeaderRow;
        // _myLastMonthBhaugolikHeaderRow = stateLastMonthBhaugolikHeaderRow;
        _yesterdayPraantHeaderRow = stateYesterdayPraantHeaderRow;
        _mySankalpDataHeaderRow = stateSankalpDataHeaderRow;
        _myYesterdaySummaryHeaderRow = stateYesterdaySummaryHeaderRow;
        _myYesterdayDetailHeaderRow = stateYesterdayDetailHeaderRow;

        _isMySearching = false;
      });
    }
  }

  void getTargetDetailsColumnsAndRows(tgGeoUnitID, tgLevelID) async {
    _tgLevelID = tgLevelID;
    List<Widget> tgSadyasthitiHeaderRow = [];
    List<Widget> tgGatividhiHeaderRow = [];
    List<Widget> tgAayaamHeaderRow = [];
    List<Widget> tgPreritHeaderRow = [];
    List<Widget> tgSocialOrgHeaderRow = [];
    List<Widget> tgStudentCategoryHeaderRow = [];
    List<Widget> tgVyavasaayeeHeaderRow = [];
    List<Widget> tgBhaugolikHeaderRow = [];
    // List<Widget> tgLastMonthBhaugolikHeaderRow = [];
    List<Widget> tgSankalpDataHeaderRow = [];
    List<Widget> tgYesterdaySummaryHeaderRow = [];
    List<Widget> tgYesterdayDetailHeaderRow = [];
    // int totMaasikMilanCount = 0, totSanghaMandaliCount = 0,totalsankalpitshakhaCount =0;
    int totMaasikMilanCount = 0, totSanghaMandaliCount = 0, totsankalpitshakha = 0, totsankalpitSaaptaahik = 0, totsankalpitMasikMilan = 0;

    // dynamic stateSadyasthitiHeaderRow,
    //     stateMaasikCount,
    //     stateMandaliCount,
    //     statesankalpitshakhaCount,
    //     stateGatividhiHeaderRow,
    //     stateBhaugolikHeaderRow,
    //     /*stateLastMonthBhaugolikHeaderRow,*/
    //     statePreritHeaderRow,
    //     stateSocialOrgHeaderRow,
    //     stateStudentCategoryHeaderRow,
    //     stateAayaamHeaderRow,
    //     stateVyavasaayeeHeaderRow,
    //     stateSankalpDataHeaderRow,
    //     stateYesterdaySummaryHeaderRow,
    //     stateYesterdayDetailHeaderRow;
    dynamic stateSadyasthitiHeaderRow,
        stateMaasikCount,
        stateMandaliCount,
        statesankalpitshakhaCount,
        statetotalsankalpitshakha,
        statesankalpitSaaptaahik,
        statesankalpitMassik,
        stateGatividhiHeaderRow,
        stateBhaugolikHeaderRow,
        /*stateLastMonthBhaugolikHeaderRow,*/
        stateYesterdayPraantHeaderRow,
        stateSankalpDataHeaderRow,
        statePreritHeaderRow,
        stateSocialOrgHeaderRow,
        stateStudentCategoryHeaderRow,
        stateAayaamHeaderRow,
        stateVyavasaayeeHeaderRow,
        stateYesterdaySummaryHeaderRow,
        stateYesterdayDetailHeaderRow;

    setState(() {
      _isTgSearching = true;
    });

    var data = await Statics.getDashboardDataByGeoUnit(Statics.userDetails["userID"], tgGeoUnitID);
    if (data['Status'] == "Success") {
      setState(() {
        tgShaakhaaKaaryakartaaCount = data["HomeScreenData"]['ShaakhaaKaaryakartaaCount'].toString();
        tgTotalKaaryakartaaCount = data["HomeScreenData"]["TotalKaaryakartaaCount"].toString();
        tgPratidnyitCount = data["HomeScreenData"]["PratidnyitCount"].toString();
        tgShishuCount = data["HomeScreenData"]["ShishuCount"].toString();
        tgBaalCount = data["HomeScreenData"]["BaalCount"].toString();
        tgTarunVidyaarthiCount = data["HomeScreenData"]["TarunVidyaarthiCount"].toString();
        tgTarunVyavasaayeeCount = data["HomeScreenData"]["TarunVyavasaayeeCount"].toString();
        tgProudhaVyavasaayeeCount = data["HomeScreenData"]["ProudhaVyavasaayeeCount"].toString();
        tgUnknownAgeCount = data["HomeScreenData"]["UnknownAgeCount"].toString();
        tgPraarambhikShikshitCount = data["HomeScreenData"]["PraarambhikShikshitCount"].toString();
        tgPraathamikShikshitCount = data["HomeScreenData"]["PraathamikShikshitCount"].toString();
        tgPrathamVarshaShikshitCount = data["HomeScreenData"]["PrathamVarshaShikshitCount"].toString();
        tgDwitiyaVarshaShikshitCount = data["HomeScreenData"]["DwitiyaVarshaShikshitCount"].toString();
        tgTrutiyaVarshaShikshitCount = data["HomeScreenData"]["TrutiyaVarshaShikshitCount"].toString();
        tgNoShikshanCount = data["HomeScreenData"]["NoShikshanCount"].toString();
        tgDailyShaakhaaKaaryakartaaCount = data["HomeScreenData"]["DailyShaakhaaKaaryakartaaCount"].toString();
        tgSaaptaahikMilanKaaryakartaaCount = data["HomeScreenData"]["SaaptaahikMilanKaaryakartaaCount"].toString();
        tgMaasikMilanKaaryakartaaCount = data["HomeScreenData"]["MaasikMilanKaaryakartaaCount"].toString();
        tgVastiKaaryakartaaCount = data["HomeScreenData"]["VastiKaaryakartaaCount"].toString();
        tgGraamKaaryakartaaCount = data["HomeScreenData"]["GraamKaaryakartaaCount"].toString();
        tgMandalKaaryakartaaCount = data["HomeScreenData"]["MandalKaaryakartaaCount"].toString();
        tgNagarKaaryakartaaCount = data["HomeScreenData"]["NagarKaaryakartaaCount"].toString();
        tgShaharKaaryakartaaCount = data["HomeScreenData"]["ShaharKaaryakartaaCount"].toString();
        tgBhaagKaaryakartaaCount = data["HomeScreenData"]["BhaagKaaryakartaaCount"].toString();
        tgVibhaagKaaryakartaaCount = data["HomeScreenData"]["VibhaagKaaryakartaaCount"].toString();
        tgMahaanagarKaaryakartaaCount = data["HomeScreenData"]["MahaanagarKaaryakartaaCount"].toString();
        tgPraantKaaryakartaaCount = data["HomeScreenData"]["PraantKaaryakartaaCount"].toString();
        notificationCount = data["HomeScreenData"]["Notificationcount"].toString();
        tgKshetraKaaryakartaaCount = data["HomeScreenData"]["KshetraKaaryakartaaCount"].toString();
        tgAkhilBhaaratiyaKaaryakartaaCount = data["HomeScreenData"]["AkhilBhaaratiyaKaaryakartaaCount"].toString();
        tgPravaaseeKaaryakartaaCount = data["HomeScreenData"]["PravaaseeKaaryakartaaCount"].toString();
        tgTotalKaaryakartaaCount = data["HomeScreenData"]["TotalKaaryakartaaCount"].toString();
        tgGatividhiKaaryakartaaCount = data["HomeScreenData"]["GatividhiKaaryakartaaCount"].toString();
        tgAayaamKaaryakartaaCount = data["HomeScreenData"]["AayaamKaaryakartaaCount"].toString();
        tgSanghaPreritSansthaaKaaryakartaaCount = data["HomeScreenData"]["SanghaPreritSansthaaKaaryakartaaCount"].toString();
        tgSocialOrganizationKaaryakartaaCount = data["HomeScreenData"]["SocialOrganizationKaaryakartaaCount"].toString();
        tgTotalSwayamsevakCount = data["HomeScreenData"]["TotalSwayamsevakCount"].toString();

        tgMaasikEQ0 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["MaasikEQ0"].toString();
        tgMaasikEQ1 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["MaasikEQ1"].toString();
        tgSaaptaahikEQ0 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["SaaptaahikEQ0"].toString();
        tgSaaptaahik1To3 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["Saaptaahik1To3"].toString();
        tgSaaptaahikGTE4 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["SaaptaahikGTE4"].toString();
        tgShaakhaaEQ0 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["ShaakhaaEQ0"].toString();
        tgShaakhaa1To24 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["Shaakhaa1To24"].toString();
        tgShaakhaaGTE25 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["ShaakhaaGTE25"].toString();
        tgShaakhaaEQ30 = data["HomeScreenData"]["ShaakhaaVruttaSummaryData"]["ShaakhaaEQ30"].toString();
      });

      if (Statics.tgLstdashboardSadyaSthitiData.length > 0) {
        tgSadyasthitiHeaderRow = [];
        // tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('Vayogat'), 100, 56, Alignment.centerLeft, isTotalRow: false));
        // tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('Shaakhaa'), 60, 56, Alignment.centerLeft, isTotalRow: false));
        // tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('SankalpitShaakhaa'), 100, 56, Alignment.centerLeft, isTotalRow: false));
        // tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('SaaptaahikMilan'), 100, 56, Alignment.centerLeft, isTotalRow: false));
        // tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('SankalpitSaaptaahikMilan'), 100, 56, Alignment.centerLeft, isTotalRow: false));
        tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('Vayogat'), 130, 56, Alignment.centerLeft, isTotalRow: false));

        tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('RegisterShaakhaa'), 130, 56, Alignment.centerLeft, isTotalRow: false));
        tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('SankalpitShaakhaa'), 130, 56, Alignment.centerLeft, isTotalRow: false));
        tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('TotalSankalpitShaakhaa'), 130, 56, Alignment.centerLeft, isTotalRow: false));

        tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('RegisteredSaaptaahikMilan'), 130, 56, Alignment.centerLeft, isTotalRow: false));
        tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('SankalpitSaaptaahikMilan'), 130, 56, Alignment.centerLeft, isTotalRow: false));
        tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('TotalSankalpitSaaptaahikMilan'), 130, 56, Alignment.centerLeft, isTotalRow: false));

        tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('RegisteredMasikMilan'), 130, 56, Alignment.centerLeft, isTotalRow: false));
        tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('SankalpitMasikMilan'), 130, 56, Alignment.centerLeft, isTotalRow: false));
        tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('TotalSankalpitMasikMilan'), 130, 56, Alignment.centerLeft, isTotalRow: false));

        tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('RegisteredSanghaMandali'), 130, 56, Alignment.centerLeft, isTotalRow: false));
        tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('SankalpitSanghMandali'), 130, 56, Alignment.centerLeft, isTotalRow: false));
        tgSadyasthitiHeaderRow.add(_createWidget(Statics.getLabel('TotalSankalpitSanghMandali'), 130, 56, Alignment.centerLeft, isTotalRow: false));

        //   for (var data in Statics.tgLstdashboardSadyaSthitiData) {
        //     if (data.vayogatID == -1) {
        //       totMaasikMilanCount = data.maasikMilanCount!;
        //       totSanghaMandaliCount = data.sanghaMandaliCount!;
        //     }
        //   }
        //
        //   stateSadyasthitiHeaderRow = tgSadyasthitiHeaderRow;
        //   stateMaasikCount = totMaasikMilanCount.toString();
        //   stateMandaliCount = totSanghaMandaliCount.toString();
        //   statesankalpitshakhaCount = totalsankalpitshakhaCount.toString();
        //
        // } else {
        //   stateSadyasthitiHeaderRow = null;
        //   stateMaasikCount = '0';
        //   stateMandaliCount = '0';
        //   statesankalpitshakhaCount = '0';
        // }
        for (var data in Statics.tgLstdashboardSadyaSthitiData) {
          print("data.vayogatID ---> ${data.vayogatID}");
          if (data.vayogatID == -1) {
            totMaasikMilanCount = data.maasikMilanCount!;
            totSanghaMandaliCount = data.sanghaMandaliCount!;
            totsankalpitshakha = data.sankalpitShaakhaaCount!;
            totsankalpitSaaptaahik = data.sankalpitSaaptaahikCount!;
            totsankalpitMasikMilan = data.sankalpitMaasikMilanCount!;
            print("totsankalpitSaaptaahik ---> $totsankalpitSaaptaahik");
            print("totsankalpitshakha ---> $totsankalpitshakha");
            print("totsankalpitMasikMilan ---> $totsankalpitMasikMilan");
          }
        }
        stateSadyasthitiHeaderRow = tgSadyasthitiHeaderRow;
        stateMaasikCount = totMaasikMilanCount.toString();
        stateMandaliCount = totSanghaMandaliCount.toString();
        statetotalsankalpitshakha = totsankalpitshakha.toString();
        statesankalpitSaaptaahik = totsankalpitSaaptaahik.toString();
        statesankalpitMassik = totsankalpitMasikMilan.toString();
      } else {
        stateSadyasthitiHeaderRow = null;
        stateMaasikCount = '0';
        stateMandaliCount = '0';
        statetotalsankalpitshakha = '0';
        statesankalpitSaaptaahik = '0';
        statesankalpitMassik = '0';
      }

      if (Statics.tgLstGatividhiKaaryakartaa.length > 0) {
        tgGatividhiHeaderRow = [];
        tgGatividhiHeaderRow.add(_createWidget(Statics.getLabel('Gatividhi'), 150, 56, Alignment.centerLeft, isTotalRow: false));
        tgGatividhiHeaderRow.add(_createWidget(Statics.getLabel('KaaryakartaaCount'), 150, 56, Alignment.center, isTotalRow: false));

        stateGatividhiHeaderRow = tgGatividhiHeaderRow;
      } else {
        stateGatividhiHeaderRow = null;
      }

      if (Statics.tgLstAayaamKaaryakartaa.length > 0) {
        tgAayaamHeaderRow = [];
        tgAayaamHeaderRow.add(_createWidget(Statics.getLabel('Aayaam'), 150, 56, Alignment.centerLeft, isTotalRow: false));
        tgAayaamHeaderRow.add(_createWidget(Statics.getLabel('KaaryakartaaCount'), 150, 56, Alignment.center, isTotalRow: false));

        stateAayaamHeaderRow = tgAayaamHeaderRow;
      } else {
        stateAayaamHeaderRow = null;
      }

      if (Statics.tgLstPreritKaaryakartaa.length > 0) {
        tgPreritHeaderRow = [];
        tgPreritHeaderRow.add(_createWidget(Statics.getLabel('AreaOfOperations'), 150, 56, Alignment.centerLeft, isTotalRow: false));
        tgPreritHeaderRow.add(_createWidget(Statics.getLabel('KaaryakartaaCount'), 150, 56, Alignment.center, isTotalRow: false));

        statePreritHeaderRow = tgPreritHeaderRow;
      } else {
        statePreritHeaderRow = null;
      }

      if (Statics.tgLstSocialOrgKaaryakartaa.length > 0) {
        tgSocialOrgHeaderRow = [];
        tgSocialOrgHeaderRow.add(_createWidget(Statics.getLabel('AreaOfOperations'), 150, 56, Alignment.centerLeft, isTotalRow: false));
        tgSocialOrgHeaderRow.add(_createWidget(Statics.getLabel('KaaryakartaaCount'), 150, 56, Alignment.center, isTotalRow: false));

        stateSocialOrgHeaderRow = tgSocialOrgHeaderRow;
      } else {
        stateSocialOrgHeaderRow = null;
      }

      if (Statics.tgLstStudentCategory.length > 0) {
        tgStudentCategoryHeaderRow = [];
        tgStudentCategoryHeaderRow.add(_createWidget(Statics.getLabel('StudentCategory'), 150, 56, Alignment.centerLeft, isTotalRow: false));
        tgStudentCategoryHeaderRow.add(_createWidget(Statics.getLabel('SwayamsevakCount'), 150, 56, Alignment.center, isTotalRow: false));

        stateStudentCategoryHeaderRow = tgStudentCategoryHeaderRow;
      } else {
        stateStudentCategoryHeaderRow = null;
      }

      if (Statics.tgLstVyavasaayeeCategory.length > 0) {
        tgVyavasaayeeHeaderRow = [];
        tgVyavasaayeeHeaderRow.add(_createWidget(Statics.getLabel('VyavasaayeeCategory'), 150, 56, Alignment.centerLeft, isTotalRow: false));
        tgVyavasaayeeHeaderRow.add(_createWidget(Statics.getLabel('SwayamsevakCount'), 150, 56, Alignment.center, isTotalRow: false));

        stateVyavasaayeeHeaderRow = tgVyavasaayeeHeaderRow;
      } else {
        stateVyavasaayeeHeaderRow = null;
      }

      if (Statics.tgLstYesterdayVruttaSummary.length > 0) {
        tgYesterdaySummaryHeaderRow = [];
        String fcHeader = '';
        if (_tgLevelID > 7)
          fcHeader = Statics.getLabel('Bhaag');
        else if (_tgLevelID == 7)
          fcHeader = Statics.getLabel('Nagar');
        else if (_tgLevelID == 6)
          fcHeader = Statics.getLabel('Mandal/Vasti');
        else if (_tgLevelID == 5)
          fcHeader = Statics.getLabel('Nagar/Vasti');
        else if (_tgLevelID == 4)
          fcHeader = Statics.getLabel('Graam');
        else
          fcHeader = Statics.getLabel('Shaakhaa');
        tgYesterdaySummaryHeaderRow.add(_createWidget(fcHeader, 100, 56, Alignment.centerLeft, isTotalRow: false));
        tgYesterdaySummaryHeaderRow.add(_createWidget(Statics.getLabel('Vayogat'), 100, 56, Alignment.center, isTotalRow: false));
        tgYesterdaySummaryHeaderRow.add(_createWidget(Statics.getLabel('Shaakhaa'), 100, 56, Alignment.center, isTotalRow: false));
        tgYesterdaySummaryHeaderRow.add(_createWidget(Statics.getLabel('SaaptaahikMilan'), 100, 56, Alignment.center, isTotalRow: false));
        tgYesterdaySummaryHeaderRow.add(_createWidget(Statics.getLabel('MilanMandali'), 100, 56, Alignment.center, isTotalRow: false));

        stateYesterdaySummaryHeaderRow = tgYesterdaySummaryHeaderRow;
      } else {
        stateYesterdaySummaryHeaderRow = null;
      }

      if (Statics.tgLstYesterdayVruttaDetail.length > 0) {
        tgYesterdayDetailHeaderRow = [];
        tgYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('GeoUnitName'), 100, 56, Alignment.center, isTotalRow: false));
        tgYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('FrequencyCode'), 100, 56, Alignment.center, isTotalRow: false));
        tgYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('VayogatCode'), 100, 56, Alignment.center, isTotalRow: false));
        tgYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('BaalCount'), 100, 56, Alignment.center, isTotalRow: false));
        tgYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('TarunVidyaarthiCount'), 100, 56, Alignment.center, isTotalRow: false));
        tgYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('TarunVyavasaayeeCount'), 100, 56, Alignment.center, isTotalRow: false));
        tgYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('ProudhaCount'), 100, 56, Alignment.center, isTotalRow: false));
        tgYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('ShishuCount'), 100, 56, Alignment.center, isTotalRow: false));
        tgYesterdayDetailHeaderRow.add(_createWidget(Statics.getLabel('AbhyaagatCount'), 100, 56, Alignment.center, isTotalRow: false));

        stateYesterdayDetailHeaderRow = tgYesterdayDetailHeaderRow;
      } else {
        stateYesterdayDetailHeaderRow = null;
      }

      if (Statics.tgLstBhaugolikVistaar.length > 0) {
        tgBhaugolikHeaderRow = [];
        tgBhaugolikHeaderRow.add(_createWidget(Statics.getLabel('LevelName'), 100, 56, Alignment.centerLeft, isTotalRow: false));
        tgBhaugolikHeaderRow.add(_createWidget(Statics.getLabel('Total'), 100, 56, Alignment.center, isTotalRow: false));
        tgBhaugolikHeaderRow.add(_createWidget(Statics.getLabel('ShaakhaaYuktaLabel'), 100, 56, Alignment.center, isTotalRow: false));
        tgBhaugolikHeaderRow.add(_createWidget(Statics.getLabel('SaaptaahikSLabel'), 100, 56, Alignment.center, isTotalRow: false));
        tgBhaugolikHeaderRow.add(_createWidget(Statics.getLabel('MaasikYuktaLabel'), 100, 56, Alignment.center, isTotalRow: false));
        //myBhaugolikHeaderRow.add(_createWidget(Statics.getLabel('GatividhiSLabel'), 100, 56, Alignment.center, isTotalRow: false));

        stateBhaugolikHeaderRow = tgBhaugolikHeaderRow;
      } else {
        stateBhaugolikHeaderRow = null;
      }

      // if (Statics.tgLstLastMonthBhaugolikVistaar.length > 0) {
      //   tgLastMonthBhaugolikHeaderRow = [];
      //   tgLastMonthBhaugolikHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('LevelName'), 100, 56, Alignment.centerLeft, isTotalRow: false));
      //   tgLastMonthBhaugolikHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Total'), 100, 56, Alignment.center, isTotalRow: false));
      //   tgLastMonthBhaugolikHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('ShaakhaaYuktaLabel'), 100, 56, Alignment.center, isTotalRow: false));
      //   tgLastMonthBhaugolikHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('SaaptaahikSLabel'), 100, 56, Alignment.center, isTotalRow: false));
      //   tgLastMonthBhaugolikHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('MaasikYuktaLabel'), 100, 56, Alignment.center, isTotalRow: false));
      //   //tgLastMonthBhaugolikHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('GatividhiSLabel'), 100, 56, Alignment.center, isTotalRow: false));

      //   stateLastMonthBhaugolikHeaderRow = tgLastMonthBhaugolikHeaderRow;
      // } else {
      //   stateLastMonthBhaugolikHeaderRow = null;
      // }

      if (Statics.tgLstSankalpByAadhaarData.length > 0) {
        tgSankalpDataHeaderRow = [];
        // tgSankalpDataHeaderRow.add(_createWidget(Statics.getLabel('Vayogat'), 100, 56, Alignment.centerLeft, isTotalRow: false));
        // tgSankalpDataHeaderRow.add(_createWidget(Statics.getLabel('SankalpAadhaar'), 100, 56, Alignment.centerLeft, isTotalRow: false));
        // tgSankalpDataHeaderRow.add(_createWidget(Statics.getLabel('SankalpitShaakhaa'), 100, 56, Alignment.centerLeft, isTotalRow: false));
        // tgSankalpDataHeaderRow.add(_createWidget(Statics.getLabel('SankalpitSaaptaahikMilan'), 100, 56, Alignment.centerLeft, isTotalRow: false));
        tgSankalpDataHeaderRow.add(_createWidget(Statics.getLabel('Vayogat'), 100, 60, Alignment.center, isTotalRow: false));
        tgSankalpDataHeaderRow.add(_createWidget(Statics.getLabel('SankalpAadhaar'), 130, 60, Alignment.center, isTotalRow: false));
        tgSankalpDataHeaderRow.add(_createWidget(Statics.getLabel('SankalpitShaakhaa'), 130, 60, Alignment.center, isTotalRow: false));
        tgSankalpDataHeaderRow.add(_createWidget(Statics.getLabel('SankalpitSaaptaahikMilan'), 130, 60, Alignment.center, isTotalRow: false));
        tgSankalpDataHeaderRow.add(_createWidget(Statics.getLabel('SankalpitMasikMilan'), 130, 60, Alignment.center, isTotalRow: false));
        tgSankalpDataHeaderRow.add(_createWidget(Statics.getLabel('SankalpitSanghMandali'), 130, 60, Alignment.center, isTotalRow: false));

        stateSankalpDataHeaderRow = tgSankalpDataHeaderRow;
      } else {
        stateSankalpDataHeaderRow = null;
      }

      setState(() {
        _tgSadyasthitiHeaderRow = stateSadyasthitiHeaderRow;
        tgMasikMilanCount = stateMaasikCount;
        tgSanghaMandaliCount = stateMandaliCount;
        tgsankalpitshakhaCount = statesankalpitshakhaCount;
        _tgGatividhiKaaryakartaaHeaderRow = stateGatividhiHeaderRow;
        _tgAayaamKaaryakartaaHeaderRow = stateAayaamHeaderRow;
        _tgPreritKaaryakartaaHeaderRow = statePreritHeaderRow;
        _tgSocialOrgKaaryakartaaHeaderRow = stateSocialOrgHeaderRow;
        _tgStudentCategoryHeaderRow = stateStudentCategoryHeaderRow;
        _tgVyavasaayeeCategoryHeaderRow = stateVyavasaayeeHeaderRow;
        _tgBhaugolikHeaderRow = stateBhaugolikHeaderRow;
        // _tgLastMonthBhaugolikHeaderRow = stateLastMonthBhaugolikHeaderRow;
        _tgSankalpDataHeaderRow = stateSankalpDataHeaderRow;
        _tgYesterdaySummaryHeaderRow = stateYesterdaySummaryHeaderRow;
        _tgYesterdayDetailHeaderRow = stateYesterdayDetailHeaderRow;
        _isTgSearching = false;
      });
    } else {
      setState(() {
        _tgSadyasthitiHeaderRow = null;
        tgMasikMilanCount = '0';
        tgSanghaMandaliCount = '0';
        _tgGatividhiKaaryakartaaHeaderRow = null;
        _tgAayaamKaaryakartaaHeaderRow = null;
        _tgPreritKaaryakartaaHeaderRow = null;
        _tgSocialOrgKaaryakartaaHeaderRow = null;
        _tgStudentCategoryHeaderRow = null;
        _tgVyavasaayeeCategoryHeaderRow = null;
        _tgBhaugolikHeaderRow = null;
        // _tgLastMonthBhaugolikHeaderRow = null;
        _tgSankalpDataHeaderRow = null;
        _tgYesterdaySummaryHeaderRow = null;
        _tgYesterdayDetailHeaderRow = null;

        tgShishuCount = "";
        tgBaalCount = "";
        tgTarunVidyaarthiCount = "";
        tgTarunVyavasaayeeCount = "";
        tgProudhaVyavasaayeeCount = "";
        tgUnknownAgeCount = "";
        tgTrutiyaVarshaShikshitCount = "";
        tgDwitiyaVarshaShikshitCount = "";
        tgPrathamVarshaShikshitCount = "";
        tgPraarambhikShikshitCount = "";
        tgPraathamikShikshitCount = "";
        tgNoShikshanCount = "";
        tgShaakhaaKaaryakartaaCount = "";
        tgVastiKaaryakartaaCount = "";
        tgGraamKaaryakartaaCount = "";
        tgMandalKaaryakartaaCount = "";
        tgNagarKaaryakartaaCount = "";
        tgShaharKaaryakartaaCount = "";
        tgBhaagKaaryakartaaCount = "";
        tgVibhaagKaaryakartaaCount = "";
        tgMahaanagarKaaryakartaaCount = "";
        tgPraantKaaryakartaaCount = "";
        tgKshetraKaaryakartaaCount = "";
        tgPravaaseeKaaryakartaaCount = "";
        tgGatividhiKaaryakartaaCount = "";
        tgAayaamKaaryakartaaCount = "";
        tgSanghaPreritSansthaaKaaryakartaaCount = "";
        tgTotalKaaryakartaaCount = "";
        tgSocialOrganizationKaaryakartaaCount = "";
        tgPratidnyitCount = "";
        tgDailyShaakhaaKaaryakartaaCount = "";
        tgSaaptaahikMilanKaaryakartaaCount = "";
        tgMaasikMilanKaaryakartaaCount = "";
        tgAkhilBhaaratiyaKaaryakartaaCount = "";
        tgTotalSwayamsevakCount = "";

        tgMaasikEQ0 = tgMaasikEQ1 = tgSaaptaahikEQ0 = tgSaaptaahik1To3 = tgSaaptaahikGTE4 = "";
        tgShaakhaaEQ0 = tgShaakhaa1To24 = tgShaakhaaGTE25 = tgShaakhaaEQ30 = "";
        _isTgSearching = false;
      });
    }
  }

  void populateChoice() {
    print("Statics.userDetails[LevelID] ==> ${Statics.userDetails["LevelID"]} ");
    print("Statics.userDetails[DaayitvaName] ==> ${Statics.userDetails["DaayitvaName"]} ");
    setState(() {
      choices = [
        // new MenuChoices("Resfresh", Icons.refresh, Statics.getLabel('RefreshData')),
        new MenuChoices("ResfreshDashboard", Icons.refresh, Statics.getLabel('DashboardData')),
        new MenuChoices("ChangeLanguage", Icons.settings, Statics.getLabel('ChangeLanguage')),
        new MenuChoices("ChangePassword", Icons.track_changes, Statics.getLabel('ChangePassword')),

//         if (int.parse(Statics.userDetails["LevelID"]) >= 6 &&
//             (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
//                 Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
//                 Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
//                 Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||Statics.userDetails["DaayitvaName"] == "सह कार्यवाह" ||
//                 Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' ||Statics.userDetails['DaayitvaName'] == 'कार्यालय प्रमुख' ||
//                 Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
//                 Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||Statics.userDetails['DaayitvaName'] == 'सह प्रचारक'||
//                 Statics.userDetails["DaayitvaName"] == "Sewa Pramukh" ||Statics.userDetails["DaayitvaName"] == "सेवा प्रमुख"||
//                 Statics.userDetails["DaayitvaName"] == "Sewa Saha-Pramukh" ||Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||
//                 Statics.userDetails["DaayitvaName"] == "Vyavasthaa Pramukh" ||Statics.userDetails["DaayitvaName"] == "व्यवस्था प्रमुख" ||Statics.userDetails["DaayitvaName"] == "व्यवस्था प्रमुख" ||
//                 Statics.userDetails["DaayitvaName"] == "Vyavasthaa Saha-Pramukh" ||Statics.userDetails["DaayitvaName"] == "व्यवस्था प्रमुख" ||Statics.userDetails["DaayitvaName"] == "व्यवस्था प्रमुख" ||
//                 Statics.userDetails["DaayitvaName"] == "Sewa Vibhaag - Toli Sadasya" ||Statics.userDetails["DaayitvaName"] == "सेवा विभाग टोली सदस्य" ))
//           // if (Statics.userDetails["MobileNumber"] == "7738167968")
//           new MenuChoices("AnnualBaithakVrutta", Icons.storage, Statics.getLabel('AnnualBaithakVrutta')),
//         if (int.parse(Statics.userDetails["LevelID"]) >= 6)
//           // if (Statics.userDetails["MobileNumber"] == "7738167968")
//           new MenuChoices("AnnualBaithakEkatritVrutta", Icons.report, Statics.getLabel('annualBaithakEkatritVrutta')),
        new MenuChoices("ContactUs", Icons.support_agent_rounded, Statics.getLabel('contactUs')),
        new MenuChoices("LogOut", Icons.logout, Statics.getLabel('logOutLabel')),
      ];
    });
  }

  void getGeoUnitID() async {
    setState(() {
      geoUnitID = Statics.userDetails["DaayitvaGeoUnitID"];
      geoUnitName = Statics.userDetails["DaayitvaGeoUnitName"] + "-" + Statics.userDetails["LevelName"];
    });
  }

  void onMenuSelected(MenuChoices choice) async {
    if (choice.menuType == "ChangePassword") {
      Navigator.of(context).pushNamed(ChangePassword.routeName);
    } else if (choice.menuType == "ChangeLanguage") {
      Navigator.of(context).pushNamed(ProfileSettings.routeName);
    } else if (choice.menuType == "AnnualBaithakVrutta") {
      Navigator.of(context).pushNamed(SearchAnnualBaithakVrutta.routeName);
    } else if (choice.menuType == "AnnualBaithakEkatritVrutta") {
      Navigator.of(context).pushNamed(AnnualBaithakEkatritVrutta.routeName);
    } else if (choice.menuType == "ContactUs") {
      Navigator.of(context).pushNamed(ContactUs.routeName);
    } else if (choice.menuType == "LogOut") {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        await LogIn().logOut();
        BackgroundFetch.stop().then((int status) {
          print('[BackgroundFetch] stop success: $status');
        });
        // Navigator.of(context).pushReplacementNamed('/');
        Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
      }
    }
    // else if (choice.menuType == "Resfresh") {
    //   setState(() {
    //     _isSearching = true;
    //   });
    //   var data = await Statics.refreshData();
    //   if (data == "Successfull") {
    //     setState(() {
    //       _isSearching = false;
    //     });
    //     Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    //   }
    // }
    else if (choice.menuType == "ResfreshDashboard") {
      setState(() {
        _isSearching = true;
      });
      var data = await Statics.refreshDashboardData(Statics.userDetails["userID"], geoUnitID);

      if (data == "Successfull") {
        Statics.getNotificationDataList(Statics.userDetails["userID"]);
        setState(() {
          Statics.populateDashboardDetailsMap();
          _isSearching = false;
        });
        Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
      }
    }
  }

  getInitialData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = pref.getString("AbhiyanSwayamsevakData");
    var loginDate = pref.getString("loginDate");
    print("loginDate ==== > $loginDate");
    print("data ==== >  $data");
    userDaayitvaNameforshow = pref.getString("DaayitvaNameforshow") ?? '';
    await checkLoginDate(DateTime.tryParse(loginDate.toString()) ?? null);
    if (data != null) {
      initialData = AbhiyanSwayamsevakdata.fromJson(jsonDecode(data));
    }
    setState(() {});
  }

  void getExcelReportDataFun(UpkhandaDataList data) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(Statics.getLabel('AskConfirmation')),
        content: Text("${Statics.getLabel("selectedLevel")} -> ${data.goUnitName}"),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, textStyle: TextStyle(color: Colors.white)),
            child: Text(Statics.getLabel("downloadBtn"), style: TextStyle(color: Colors.white)),
            onPressed: () async {
              Navigator.of(ctx).pop();
              // final _path = await getDirectoryPathFun();
              // final file = File(_path);

              // final exists = await file.exists();
              //
              // if (exists) {
              //   final _result = await showDialog(
              //     context: context,
              //     builder: (ctx) => AlertDialog(
              //       title: Text(Statics.getLabel('AskConfirmation')),
              //       content: Text("निवडलेल्या स्तरसाठी एक्सेल रिपोर्ट आधीच अस्तित्वात आहे, तुम्हाला नवीन डाउनलोड करायचा आहे का?"),
              //       actions: <Widget>[
              //         ElevatedButton(
              //           style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, textStyle: TextStyle(color: Colors.white)),
              //           child: Text("डाउनलोड करा", style: TextStyle(color: Colors.white)),
              //           onPressed: () async {
              //             Navigator.of(ctx).pop(true);
              //           },
              //         ),
              //         TextButton(
              //           child: Text("जुनी फाईल उघडा"),
              //           onPressed: () async {
              //             Navigator.of(ctx).pop(false);
              //           },
              //         )
              //       ],
              //     ),
              //   );
              //
              //   if (!_result) {
              //     await OpenFilex.open(file.path);
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(content: Text('Opened existing file: $_path')),
              //     );
              //     return;
              //   }
              // }
              setState(() {
                bhougolikReportForExcel = null;
                // _isLoading = true;
              });
              bhougolikReportForExcel = await Statics.upkhandUpnagarReportForExcelData(userID: Statics.userDetails["userID"], targetGeoUnitID: data.geoUnitId, context: context);
              // log("vijayadashamiReport >>>>>>>>>>>>>>>>> ${jsonDecode(jsonEncode(vijayadashamiReport))}");
              setState(() {
                // _isLoading = false;
                bhougolikReportForExcel;
              });
              final _list = bhougolikReportForExcel?.datanameList;
              if (_list != null && _list.isNotEmpty) {
                await buildExcelFromData3(rows: bhougolikReportForExcel!.toJson()["dataname"]);
              } else {
                Fluttertoast.showToast(
                  msg: Statics.getLabel("errorOccurred"),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              }
            },
          ),
          TextButton(
            child: Text(Statics.getLabel('clear')),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> buildExcelFromData3({required List<Map<String, dynamic>> rows}) async {
    if (rows.isEmpty) {
      throw ArgumentError('No data rows provided.');
    }

    // Workbook + sheet
    final xls.Workbook wb = xls.Workbook();
    final xls.Worksheet _sheet = wb.worksheets[0];
    _sheet.name = Statics.getLabel('bhougolikExcelReport');

    // Styles (kept same as your original)
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

    // Keys/order from the first row (keeps insertion order)
    final keys = rows.first.keys.toList();
    int _colForSheet = 1; // XlsIO is 1-based

    // Header row (single row header like before)
    _sheet.getRangeByIndex(1, _colForSheet).setText('Sr No');
    _sheet.getRangeByIndex(1, _colForSheet, 2, _colForSheet).cellStyle = headerStyle;
    _colForSheet++;

    for (final key in keys) {
      _sheet.getRangeByIndex(1, _colForSheet).setText(Statics.getLabel(key));
      _sheet.getRangeByIndex(1, _colForSheet).cellStyle = headerStyle;
      _colForSheet++;
    }

    int rowIndex = 2;
    int srNo = 1;

    for (final item in rows) {
      // Expand values that contain '-->' into lists, others into single-item lists
      final Map<int, int> countsByCol = {}; // key: column index (1-based), value: count
      final Map<String, List<String>> expanded = {};
      int maxLines = 1;

      for (final key in keys) {
        final val = item[key];
        if (val is String && val.contains('-->')) {
          final parts = val.split('-->').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
          expanded[key] = parts.isNotEmpty ? parts : ['--'];
          if (parts.length > maxLines) maxLines = parts.length;
        } else {
          expanded[key] = [val?.toString().trim().isEmpty == true ? '--' : (val?.toString() ?? '--')];
        }
      }

      // Write expanded lines for this object
      final int startRow = rowIndex;
      for (int i = 0; i < maxLines; i++) {
        int writeCol = 1;

        // Sr No (only on the first sub-row)
        if (i == 0) {
          _sheet.getRangeByIndex(rowIndex, writeCol).setNumber(srNo.toDouble());
          _sheet.getRangeByIndex(rowIndex, writeCol).cellStyle = _cellStyle;
        } else {
          // ensure blank cell exists for alignment (will be merged later)
          _sheet.getRangeByIndex(rowIndex, writeCol).setText('');
          _sheet.getRangeByIndex(rowIndex, writeCol).cellStyle = _cellStyle;
        }
        writeCol++;

        // Fill each key column for this sub-row
        for (final key in keys) {
          final values = expanded[key]!;
          final text = (i < values.length) ? values[i] : '--';

          final col = writeCol; // capture current column
          _sheet.getRangeByIndex(rowIndex, writeCol).setText(text);
          _sheet.getRangeByIndex(rowIndex, writeCol).cellStyle = _cellStyle;
          if (col >= 4) {
            final t = text.trim();
            if (t.isNotEmpty && t != '--') {
              countsByCol[col] = (countsByCol[col] ?? 0) + 1;
            }
          }
          writeCol++;
        }

        rowIndex++;
      }

      final int endRow = rowIndex - 1;

      // Merge Sr No vertically for this object
      _sheet.getRangeByIndex(startRow, 1, endRow, 1).merge();
      _sheet.getRangeByIndex(startRow, 1).cellStyle = _cellStyle;

      // Helper to merge a named key if present
      void tryMergeKey(String keyName) {
        final int keyPos = keys.indexOf(keyName);
        if (keyPos >= 0) {
          // +2 because column 1 = Sr No, columns start at 2 for first key
          final int colForKey = keyPos + 2;
          _sheet.getRangeByIndex(startRow, colForKey, endRow, colForKey).merge();
          _sheet.getRangeByIndex(startRow, colForKey).cellStyle = _cellStyle;
        }
      }

      // Merge bhagname, vibhagname and nagarname vertically if they exist
      tryMergeKey('GoUnitName');
      tryMergeKey('NagarNames');

      srNo++;

      _sheet.getRangeByIndex(rowIndex, 1, rowIndex, 3).merge();
      final _totalLabelRangeForSheet1 = _sheet.getRangeByIndex(rowIndex, 1);
      _totalLabelRangeForSheet1.setText('Total');
      _sheet.getRangeByIndex(rowIndex, 1, rowIndex, 3).cellStyle = boldCellStyle..backColor = '#D6E3BC';

      // Add a separated Total row
      for (int col = 4; col <= (keys.length + 1); col++) {
        final count = countsByCol[col] ?? 0;
        _sheet.getRangeByIndex(rowIndex, col).setNumber(count.toDouble());
        _sheet.getRangeByIndex(rowIndex, col).cellStyle = blankRowStyle;
      }

      rowIndex++; // leave one blank row after each object
    }

    // Auto-fit columns
    for (int c = 1; c <= keys.length + 1; c++) {
      _sheet.autoFitColumn(c);
    }

    // Save + open (same as your existing approach)
    try {
      final _path = await _getDirectoryPathFun();
      final file = File(_path);

      final bytes = wb.saveAsStream();
      wb.dispose();

      await file.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);

      final result = await OpenFilex.open(file.path);

      // Check result type
      if (result.type != ResultType.done) {
        // Handle known failure types
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

  Future<String?> checkLoginDate(DateTime? oldDate) async {
    try {
      Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

      // var response = await http.post(Uri.parse(Statics.urlCheckLoginDate,headers: jHeaders, body: json.encode({"SoochiID": soochiID})),
      //     headers: jHeaders);
      print("Statics.userDetails[userID] = ${Statics.userDetails["userID"]}");
      var response = await http.post(Uri.parse(Statics.urlCheckLoginDate), headers: jHeaders, body: json.encode({"swayamsevakid": Statics.userDetails["userID"]}));
      print(response.request!.url);
      print(response.body);
      var body = json.decode(response.body);
      DateTime? newDate = DateTime.tryParse(body['ForceLogout']) ?? null;
      print("oldDate--->  $oldDate");
      print("newDate---->  $newDate");
      if (newDate != null) {
        print(oldDate);
        print(newDate);
        if (oldDate!.isBefore(newDate)) {
          print("object");
          print("Logout True");
          await LogIn().logOut();
          Navigator.of(context).pushReplacementNamed('/');
        }
      }
      return body['ForceLogout'];
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () {
              var user = Statics.userDetails["userID"];
              print(user);
            },
            child: Text(
              Statics.getLabel('homeScreenTitle'),
              style: TextStyle(fontSize: 20),
            ),
          ),
          bottom: TabBar(
            unselectedLabelStyle: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
            labelStyle: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
            onTap: (value) {
              log("Printing the value >>>>>>> $value");
              if (value == 1) {
                getInitialData();
                populateChoice();
                populatelinkedMahanagarDropdown();
                populatelinkedVibhaagDropdown();
                populatelinkedMahanagarDropdown2();
                populatelinkedVibhaagDropdown2();
                getGeoUnitID();
                getMyDetailsColumnsAndRows();
                getUpkhandUpnagarReportFun("0", "praant");
              }
            },
            tabs: [
              Tab(text: Statics.getLabel('menu')),
              Tab(text: Statics.getLabel('mainScreenTab2')),
            ],
          ),
          actions: <Widget>[
            // if (Statics.lstAppVersion.length > 0 && '-' + Statics.lstAppVersion[0].buildNumber! != Statics.patchSuffix)
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationListPage(
                          userId: Statics.userDetails['userID'],
                        ),
                      ),
                    ).then((value) => fetchNotificationData());
                    setState(() {});
                  },
                ),
                if (notificationListdata?.notificationcount != "null" && notificationListdata?.notificationcount != '0' && notificationListdata?.notificationcount != '')
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${notificationListdata?.notificationcount}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            PopupMenuButton<MenuChoices>(
              onSelected: onMenuSelected,
              icon: Icon(Icons.settings),
              itemBuilder: (BuildContext context) {
                return choices.map((MenuChoices choice) {
                  return PopupMenuItem<MenuChoices>(
                    value: choice,
                    child: ListTile(leading: Icon(choice.icon), title: Text(choice.menuText!)),
                  );
                }).toList();
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: TabBarView(
          children: [
            ModalProgressHUD(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: Statics.getDeviceSize(context).width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  Statics.userDetails['FullName'] + ', ' + Statics.userDetails['MobileNumber'],
                                  style: TextStyle(fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                )),
                              ],
                            ),
                            Wrap(
                              spacing: 5,
                              children: [
                                Text(
                                  Statics.userDetails['DaayitvaGeoUnitName'],
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  Statics.userDetails['LevelName'],
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  '$userDaayitvaNameforshow',
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30),

                        /// 1st CARD
                        shatabdiVrutaCard(),
                        SizedBox(height: 27),

                        /// 2nd CARD
                        surveyCard(),
                        SizedBox(height: 27),

                        /// 3rd CARD
                        moreCard(),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                inAsyncCall: _isSearching),
            ModalProgressHUD(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: Statics.getDeviceSize(context).width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  Statics.userDetails['FullName'] + ', ' + Statics.userDetails['MobileNumber'],
                                  style: TextStyle(fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                )),
                              ],
                            ),
                            Wrap(
                              spacing: 5,
                              children: [
                                Text(
                                  Statics.userDetails['DaayitvaGeoUnitName'],
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  Statics.userDetails['LevelName'],
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  '$userDaayitvaNameforshow',
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        ///
                        Legend(legendString: "YesterdayPraantData", fontsize: 18),
                        Container(
                          height: Statics.getDeviceSize(context).height * (_yesterdayPraantHeaderRow != null ? 0.45 : 0.07),
                          width: Statics.getDeviceSize(context).width,
                          child: _isMySearching == true
                              ? Column(
                                  children: [CircularProgressIndicator()],
                                )
                              : _yesterdayPraantHeaderRow != null
                                  ? HorizontalDataTable(
                                      leftHandSideColumnWidth: 100,
                                      rightHandSideColumnWidth: 200,
                                      isFixedHeader: true,
                                      headerWidgets: _yesterdayPraantHeaderRow,
                                      leftSideItemBuilder: _yesterdayPraantFirstColumn,
                                      rightSideItemBuilder: _yesterdayPraantOtherColumns,
                                      itemCount: (Statics.lstYesterdayPraantData.length),
                                      rowSeparatorWidget: const Divider(
                                        color: Colors.black54,
                                        height: 1.0,
                                        thickness: 0.0,
                                      ),
                                      leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                      rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                    )
                                  : Column(
                                      children: [
                                        Text(
                                          Statics.getLabel('NoDataFound'),
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                        ),
                        SizedBox(height: 15),
                        ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _isNagarTableExpanded = isExpanded;
                            });
                          },
                          children: [
                            ExpansionPanel(
                              isExpanded: _isNagarTableExpanded,
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(Statics.getLabel('prantachiBhaugolikRachanaa')),
                                );
                              },
                              body: Container(
                                margin: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // ElevatedButton.icon(
                                        //   style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                                        //   onPressed: getExcelReportDataFun,
                                        //   // onPressed: () {},
                                        //   icon: Icon(Icons.download, color: Colors.white),
                                        //   label: Text("${Statics.getLabel('downloadReport')}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        // ),
                                        SizedBox(
                                          height: 21,
                                          width: 80,
                                          child: MaterialButton(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                            color: Theme.of(context).primaryColor,
                                            textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                                            onPressed: () {
                                              setState(() {
                                                _linkedMahaanagarValue2 = _linkedVibhaagValue2 =
                                                    _linkedbhaagValue2 = _linkedshaharValue2 = _linkednagarValue2 = _linkedmandalValue2 = _linkedgraamValue2 = _linkedvastiValue2 = null;
                                                _linkedMahaanagar2 = _linkedVibhaag2 = _linkedbhaag2 = _linkedshahar2 = _linkednagar2 = _linkedmandal2 = _linkedgraam2 = _linkedvasti2 = null;
                                                _selctedLevelName = Statics.getLabel("praant");
                                              });

                                              populatelinkedMahanagarDropdown2();
                                              populatelinkedVibhaagDropdown2();
                                              getUpkhandUpnagarReportFun("0", "praant");
                                            },
                                            child: Text(Statics.getLabel("clear"), style: TextStyle(fontSize: 12)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_linkedMahaanagar2 != null)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                                        isExpanded: true,
                                        value: _linkedMahaanagarValue2 == "" ? null : _linkedMahaanagarValue2,
                                        items: _linkedMahaanagar2?.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedMahaanagarValue2 = value!;
                                            _selctedGeoUnitId = value;
                                            _linkedVibhaagValue2 = null;
                                            _selctedLevelName = Statics.getLabel("Mahaanagar");
                                            populatelinkedVibhaagDropdown2();
                                            getUpkhandUpnagarReportFun(value, "mahanagar");
                                          });
                                        },
                                      ),
                                    if (_linkedVibhaag2 != null)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                                        isExpanded: true,
                                        value: _linkedVibhaagValue2 == "" ? null : _linkedVibhaagValue2,
                                        items: _linkedVibhaag2?.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedVibhaagValue2 = value!;
                                            _selctedGeoUnitId = value;
                                            _selctedLevelName = Statics.getLabel("Vibhaag");
                                            getUpkhandUpnagarReportFun(value, "vibhaag");
                                          });
                                        },
                                      ),
                                    SizedBox(height: 18),

                                    ///
                                    _isLoading ? CircularProgressIndicator() : buildUpnagarCountDataTable(upkhandaDataList),

                                    ///
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                        ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _isSwExpanded = isExpanded;
                            });
                          },
                          children: [
                            ExpansionPanel(
                              isExpanded: _isSwExpanded,
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(Statics.getLabel('MyGeoUnitDetails')),
                                );
                              },
                              body: Container(
                                margin: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Legend(legendString: "yesterdayNews", fontsize: 18),
                                    if (int.parse(Statics.userDetails['LevelID']) > 6)
                                      Container(
                                        height: Statics.getDeviceSize(context).height * (_myYesterdaySummaryHeaderRow != null ? 0.40 : 0.07),
                                        width: Statics.getDeviceSize(context).width,
                                        child: _myYesterdaySummaryHeaderRow != null
                                            ? HorizontalDataTable(
                                                leftHandSideColumnWidth: 100,
                                                rightHandSideColumnWidth: 400,
                                                isFixedHeader: true,
                                                headerWidgets: _myYesterdaySummaryHeaderRow,
                                                leftSideItemBuilder: _myYesterdaySummaryFirstColumn,
                                                rightSideItemBuilder: _myYesterdaySummaryOtherColumns,
                                                itemCount: (Statics.lstYesterdayVruttaSummary == null ? 0 : Statics.lstYesterdayVruttaSummary.length),
                                                rowSeparatorWidget: const Divider(
                                                  color: Colors.black54,
                                                  height: 1.0,
                                                  thickness: 0.0,
                                                ),
                                                leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                              )
                                            : Column(
                                                children: [
                                                  Text(
                                                    Statics.getLabel('NoDataFound'),
                                                    style: TextStyle(fontWeight: FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    if (int.parse(Statics.userDetails['LevelID']) <= 6)
                                      Container(
                                        height: Statics.getDeviceSize(context).height * (_myYesterdayDetailHeaderRow != null ? 0.40 : 0.07),
                                        width: Statics.getDeviceSize(context).width,
                                        child: _myYesterdayDetailHeaderRow != null
                                            ? HorizontalDataTable(
                                                leftHandSideColumnWidth: 100,
                                                rightHandSideColumnWidth: 800,
                                                isFixedHeader: true,
                                                headerWidgets: _myYesterdayDetailHeaderRow,
                                                leftSideItemBuilder: _myYesterdayDetailFirstColumn,
                                                rightSideItemBuilder: _myYesterdayDetailOtherColumns,
                                                itemCount: (Statics.lstYesterdayVruttaDetail == null ? 0 : Statics.lstYesterdayVruttaDetail.length),
                                                rowSeparatorWidget: const Divider(
                                                  color: Colors.black54,
                                                  height: 1.0,
                                                  thickness: 0.0,
                                                ),
                                                leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                              )
                                            : Column(
                                                children: [
                                                  Text(
                                                    Statics.getLabel('NoDataFound'),
                                                    style: TextStyle(fontWeight: FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Legend(legendString: "ShaakhaaVruttaSummaryLabel", fontsize: 18),
                                    SingleColumnRow(txtString: Statics.getLabel('Shaakhaa') + ':-', value: '', fontsize: 18),
                                    SingleColumnRow(txtString: Statics.getLabel('ShaakhaaEQ0'), value: myShaakhaaEQ0, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('Shaakhaa1To24'), value: myShaakhaa1To24, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('ShaakhaaGTE25'), value: myShaakhaaGTE25, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('ShaakhaaEQ30'), value: myShaakhaaEQ30, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('SaaptaahikMilan') + ':-', value: '', fontsize: 18),
                                    SingleColumnRow(txtString: Statics.getLabel('SaaptaahikEQ0'), value: mySaaptaahikEQ0, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('Saaptaahik1To3'), value: mySaaptaahik1To3, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('SaaptaahikGTE4'), value: mySaaptaahikGTE4, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('MaasikMilan') + '/' + Statics.getLabel('SanghaMandali') + ':-', value: '', fontsize: 18),
                                    SingleColumnRow(txtString: Statics.getLabel('MaasikEQ0'), value: myMaasikEQ0, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('MaasikEQ1'), value: myMaasikEQ1, fontsize: 15),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    Legend(legendString: "SankalpTable", fontsize: 18),
                                    Container(
                                      constraints: BoxConstraints(maxHeight: Statics.getDeviceSize(context).height * 0.4, minHeight: Statics.getDeviceSize(context).height * 0.07),
                                      // height: Statics.getDeviceSize(context).height * (_mySadyasthitiHeaderRow != null ? 0.40 : 0.07),
                                      width: Statics.getDeviceSize(context).width,
                                      child: _mySadyasthitiHeaderRow != null
                                          ? HorizontalDataTable(
                                              leftHandSideColumnWidth: 100,
                                              rightHandSideColumnWidth: 1560,
                                              isFixedHeader: true,
                                              headerWidgets: _mySadyasthitiHeaderRow,
                                              leftSideItemBuilder: _mySadyasthitiFirstColumn,
                                              rightSideItemBuilder: _mySadyasthitiOtherColumns,
                                              itemCount: (Statics.lstdashboardSadyaSthitiData == null ? 0 : Statics.lstdashboardSadyaSthitiData.length),
                                              rowSeparatorWidget: const Divider(
                                                color: Colors.black54,
                                                height: 1.0,
                                                thickness: 0.0,
                                              ),
                                              leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                              rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                            )
                                          : Column(
                                              children: [
                                                Text(
                                                  Statics.getLabel('NoDataFound'),
                                                  style: TextStyle(fontWeight: FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    // SingleColumnRow(txtString: Statics.getLabel('MaasikMilan'), value: masikMilanCount, fontsize: 15),
                                    // SingleColumnRow(txtString: Statics.getLabel('SanghaMandali'), value: sanghaMandaliCount, fontsize: 15),
                                    // SingleColumnRow(txtString: Statics.getLabel('EkunSankalpitShakha'), value:totalsankalpitshakhaCount, fontsize: 15),
                                    // SingleColumnRow(txtString: Statics.getLabel('EkunSankalpitSaptahikMilan'), value: totalsankalpitSaaptaahikCount, fontsize: 15),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    Legend(legendString: "NewSankalpTable", fontsize: 18),
                                    Container(
                                      height: Statics.getDeviceSize(context).height * (_mySankalpDataHeaderRow != null ? 0.40 : 0.07),
                                      width: Statics.getDeviceSize(context).width,
                                      child: _mySankalpDataHeaderRow != null
                                          ? HorizontalDataTable(
                                              leftHandSideColumnWidth: 100,
                                              rightHandSideColumnWidth: 130 * 5,
                                              isFixedHeader: true,
                                              headerWidgets: _mySankalpDataHeaderRow,
                                              leftSideItemBuilder: _mySankalpDataFirstColumn,
                                              rightSideItemBuilder: _mySankalpDataOtherColumns,
                                              itemCount: (Statics.lstSankalpByAadhaarData == null ? 0 : Statics.lstSankalpByAadhaarData.length),
                                              rowSeparatorWidget: const Divider(
                                                color: Colors.black54,
                                                height: 1.0,
                                                thickness: 0.0,
                                              ),
                                              leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                              rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                            )
                                          : Column(
                                              children: [
                                                Text(
                                                  Statics.getLabel('NoDataFound'),
                                                  style: TextStyle(fontWeight: FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    Legend(legendString: "BhaugolikVistaar", fontsize: 18),
                                    Container(
                                      height: Statics.getDeviceSize(context).height * (_myBhaugolikHeaderRow != null ? 0.40 : 0.07),
                                      width: Statics.getDeviceSize(context).width,
                                      child: _myBhaugolikHeaderRow != null
                                          ? HorizontalDataTable(
                                              leftHandSideColumnWidth: 100,
                                              rightHandSideColumnWidth: 400,
                                              isFixedHeader: true,
                                              headerWidgets: _myBhaugolikHeaderRow,
                                              leftSideItemBuilder: _myBhagolikVistaarFirstColumn,
                                              rightSideItemBuilder: _myBhagolikVistaarOtherColumns,
                                              itemCount: (Statics.lstBhaugolikVistaar == null ? 0 : Statics.lstBhaugolikVistaar.length),
                                              rowSeparatorWidget: const Divider(
                                                color: Colors.black54,
                                                height: 1.0,
                                                thickness: 0.0,
                                              ),
                                              leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                              rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                            )
                                          : Column(
                                              children: [
                                                Text(
                                                  Statics.getLabel('NoDataFound'),
                                                  style: TextStyle(fontWeight: FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    // Legend(legendString: "LastMonthBhaugolikVistaar", fontsize: 18),
                                    // Container(
                                    //   height: Statics.getDeviceSize(context).height *
                                    //       (_myLastMonthBhaugolikHeaderRow != null ? 0.40 : 0.07),
                                    //   width: Statics.getDeviceSize(context).width,
                                    //   child: _myLastMonthBhaugolikHeaderRow != null
                                    //     ? HorizontalDataTable(
                                    //       leftHandSideColumnWidth: 100,
                                    //       rightHandSideColumnWidth: 400,
                                    //       isFixedHeader: true,
                                    //       headerWidgets: _myLastMonthBhaugolikHeaderRow,
                                    //       leftSideItemBuilder: _myLastMonthBhagolikVistaarFirstColumn,
                                    //       rightSideItemBuilder: _myLastMonthBhagolikVistaarOtherColumns,
                                    //       itemCount: (Statics.lstLastMonthBhaugolikVistaar == null ? 0 : Statics.lstLastMonthBhaugolikVistaar.length),
                                    //       rowSeparatorWidget: const Divider(
                                    //         color: Colors.black54,
                                    //         height: 1.0,
                                    //         thickness: 0.0,
                                    //       ),
                                    //       leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                    //       rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                    //     )
                                    //     : Column(
                                    //         children:[
                                    //           Text(Statics.getLabel('NoDataFound'),
                                    //             style: TextStyle(fontWeight: FontWeight.normal),),
                                    //         ],
                                    //     ),
                                    // ),

                                    Legend(legendString: "SwayamsevakCount", fontsize: 18),
                                    SingleColumnRow(txtString: Statics.getLabel('TotalKaaryakartaaCount'), value: myTotalSwayamsevakCount, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('PratidnyitCount'), value: myPratidnyitCount, fontsize: 15),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    Legend(legendString: "SwayamsevakCountByAge", fontsize: 18),
                                    SingleColumnRow(txtString: Statics.getLabel('Shishu'), value: myShishuCount, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('Baal'), value: myBaalCount, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('TarunVidyaarthi'), value: myTarunVidyaarthiCount, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('TarunVyavasaayee'), value: myTarunVyavasaayeeCount, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('ProudhVyavasaayee'), value: myProudhaVyavasaayeeCount, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('UnkownAge'), value: myUnknownAgeCount, fontsize: 15),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    Legend(legendString: "ShikshitSwayamsevakCount", fontsize: 18),
                                    SingleColumnRow(txtString: Statics.getLabel('PrarambhikShikshit'), value: myPraarambhikShikshitCount, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('PraathamikShikshit'), value: myPraathamikShikshitCount, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('PrathamVarshShikshit'), value: myPrathamVarshaShikshitCount, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('DwitiyaVarshShikshit'), value: myDwitiyaVarshaShikshitCount, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('TrutiyaVarshShikshit'), value: myTrutiyaVarshaShikshitCount, fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('NoShikshan'), value: myNoShikshanCount, fontsize: 15),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    Legend(legendString: "KaaryakartaaCountByLevel", fontsize: 18),
                                    TwoColumnRow(
                                      txtString: Statics.getLabel('Shaakhaa'),
                                      value: myDailyShaakhaaKaaryakartaaCount,
                                      txtString2: Statics.getLabel('SaaptaahikLabelShort'),
                                      value2: mySaaptaahikMilanKaaryakartaaCount,
                                      fontsize: 15,
                                    ),
                                    TwoColumnRow(
                                      txtString: Statics.getLabel('MilanMandali'),
                                      value: myMaasikMilanKaaryakartaaCount,
                                      txtString2: Statics.getLabel('VastiKaaryakartaaCount'),
                                      value2: myVastiKaaryakartaaCount,
                                      fontsize: 15,
                                    ),
                                    TwoColumnRow(
                                      txtString: Statics.getLabel('GraamKaaryakartaaCount'),
                                      value: myGraamKaaryakartaaCount,
                                      txtString2: Statics.getLabel('MandalKaaryakartaaCount'),
                                      value2: myMandalKaaryakartaaCount,
                                      fontsize: 15,
                                    ),
                                    TwoColumnRow(
                                      txtString: Statics.getLabel('NagarKaaryakartaaCount'),
                                      value: myNagarKaaryakartaaCount,
                                      txtString2: Statics.getLabel('ShaharKaaryakartaaCount'),
                                      value2: myShaharKaaryakartaaCount,
                                      fontsize: 15,
                                    ),
                                    TwoColumnRow(
                                      txtString: Statics.getLabel('BhaagKaaryakartaaCount'),
                                      value: myBhaagKaaryakartaaCount,
                                      txtString2: Statics.getLabel('VibhaagKaaryakartaaCount'),
                                      value2: myVibhaagKaaryakartaaCount,
                                      fontsize: 15,
                                    ),
                                    TwoColumnRow(
                                      txtString: Statics.getLabel('MahaanagarKaaryakartaaCount'),
                                      value: myMahaanagarKaaryakartaaCount,
                                      txtString2: Statics.getLabel('PraantKaaryakartaaCount'),
                                      value2: myPraantKaaryakartaaCount,
                                      fontsize: 15,
                                    ),
                                    TwoColumnRow(
                                      txtString: Statics.getLabel('KshetraKaaryakartaaCount'),
                                      value: myKshetraKaaryakartaaCount,
                                      txtString2: Statics.getLabel('AkhilBhaaratiyaKaaryakartaaCount'),
                                      value2: myAkhilBhaaratiyaKaaryakartaaCount,
                                      fontsize: 15,
                                    ),
                                    TwoColumnRow(
                                      txtString: Statics.getLabel('PravaaseeKaaryakartaaCount'),
                                      value: myPravaaseeKaaryakartaaCount,
                                      txtString2: Statics.getLabel('TotalKaaryakartaaCount'),
                                      value2: myTotalKaaryakartaaCount,
                                      fontsize: 15,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    Legend(legendString: "GatividhiAayaamSansthaaKaaryakartaaCount", fontsize: 18),
                                    SingleColumnRow(txtString: Statics.getLabel('GatividhiKaaryakartaaCount'), value: Statics.dashboardData['GatividhiKaaryakartaaCount'], fontsize: 15),
                                    SingleColumnRow(txtString: Statics.getLabel('AayaamKaaryakartaaCount'), value: Statics.dashboardData['AayaamKaaryakartaaCount'], fontsize: 15),
                                    SingleColumnRow(
                                        txtString: Statics.getLabel('SanghaPreritSansthaaKaaryakartaaCount'), value: Statics.dashboardData['SanghaPreritSansthaaKaaryakartaaCount'], fontsize: 15),
                                    SingleColumnRow(
                                        txtString: Statics.getLabel('SocialOrganizationKaaryakartaaCount'), value: Statics.dashboardData['SocialOrganizationKaaryakartaaCount'], fontsize: 15),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    Legend(legendString: "Gatividhi", fontsize: 18),
                                    Container(
                                      height: Statics.getDeviceSize(context).height * (_myGatividhiKaaryakartaaHeaderRow != null ? 0.40 : 0.07),
                                      width: Statics.getDeviceSize(context).width,
                                      child: _myGatividhiKaaryakartaaHeaderRow != null
                                          ? HorizontalDataTable(
                                              leftHandSideColumnWidth: 150,
                                              rightHandSideColumnWidth: 150,
                                              isFixedHeader: true,
                                              headerWidgets: _myGatividhiKaaryakartaaHeaderRow,
                                              leftSideItemBuilder: _myGatividhiKaaryakartaaFirstColumn,
                                              rightSideItemBuilder: _myGatividhiKaaryakartaaOtherColumns,
                                              itemCount: (Statics.lstGatividhiKaaryakartaa == null ? 0 : Statics.lstGatividhiKaaryakartaa.length),
                                              rowSeparatorWidget: const Divider(
                                                color: Colors.black54,
                                                height: 1.0,
                                                thickness: 0.0,
                                              ),
                                              leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                              rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                            )
                                          : Column(
                                              children: [
                                                Text(
                                                  Statics.getLabel('NoDataFound'),
                                                  style: TextStyle(fontWeight: FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    Legend(legendString: "Aayaam", fontsize: 18),
                                    Container(
                                      height: Statics.getDeviceSize(context).height * (_myAayaamKaaryakartaaHeaderRow != null ? 0.40 : 0.07),
                                      width: Statics.getDeviceSize(context).width,
                                      child: _myAayaamKaaryakartaaHeaderRow != null
                                          ? HorizontalDataTable(
                                              leftHandSideColumnWidth: 150,
                                              rightHandSideColumnWidth: 150,
                                              isFixedHeader: true,
                                              headerWidgets: _myAayaamKaaryakartaaHeaderRow,
                                              leftSideItemBuilder: _myAayaamKaaryakartaaFirstColumn,
                                              rightSideItemBuilder: _myAayaamKaaryakartaaOtherColumns,
                                              itemCount: (Statics.lstAayaamKaaryakartaa == null ? 0 : Statics.lstAayaamKaaryakartaa.length),
                                              rowSeparatorWidget: const Divider(
                                                color: Colors.black54,
                                                height: 1.0,
                                                thickness: 0.0,
                                              ),
                                              leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                              rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                            )
                                          : Column(
                                              children: [
                                                Text(
                                                  Statics.getLabel('NoDataFound'),
                                                  style: TextStyle(fontWeight: FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    Legend(legendString: "Sangha-PreritSansthaa", fontsize: 18),
                                    Container(
                                      height: Statics.getDeviceSize(context).height * (_myPreritKaaryakartaaHeaderRow != null ? 0.40 : 0.07),
                                      width: Statics.getDeviceSize(context).width,
                                      child: _myPreritKaaryakartaaHeaderRow != null
                                          ? HorizontalDataTable(
                                              leftHandSideColumnWidth: 150,
                                              rightHandSideColumnWidth: 150,
                                              isFixedHeader: true,
                                              headerWidgets: _myPreritKaaryakartaaHeaderRow,
                                              leftSideItemBuilder: _myPreritKaaryakartaaFirstColumn,
                                              rightSideItemBuilder: _myPreritKaaryakartaaOtherColumns,
                                              itemCount: (Statics.lstPreritKaaryakartaa == null ? 0 : Statics.lstPreritKaaryakartaa.length),
                                              rowSeparatorWidget: const Divider(
                                                color: Colors.black54,
                                                height: 1.0,
                                                thickness: 0.0,
                                              ),
                                              leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                              rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                            )
                                          : Column(
                                              children: [
                                                Text(
                                                  Statics.getLabel('NoDataFound'),
                                                  style: TextStyle(fontWeight: FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    Legend(legendString: "OtherSocialOrganization", fontsize: 18),
                                    Container(
                                      height: Statics.getDeviceSize(context).height * (_mySocialOrgKaaryakartaaHeaderRow != null ? 0.40 : 0.07),
                                      width: Statics.getDeviceSize(context).width,
                                      child: _mySocialOrgKaaryakartaaHeaderRow != null
                                          ? HorizontalDataTable(
                                              leftHandSideColumnWidth: 150,
                                              rightHandSideColumnWidth: 150,
                                              isFixedHeader: true,
                                              headerWidgets: _mySocialOrgKaaryakartaaHeaderRow,
                                              leftSideItemBuilder: _mySocialOrgKaaryakartaaFirstColumn,
                                              rightSideItemBuilder: _mySocialOrgKaaryakartaaOtherColumns,
                                              itemCount: (Statics.lstSocialOrgKaaryakartaa == null ? 0 : Statics.lstSocialOrgKaaryakartaa.length),
                                              rowSeparatorWidget: const Divider(
                                                color: Colors.black54,
                                                height: 1.0,
                                                thickness: 0.0,
                                              ),
                                              leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                              rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                            )
                                          : Column(
                                              children: [
                                                Text(
                                                  Statics.getLabel('NoDataFound'),
                                                  style: TextStyle(fontWeight: FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    Legend(legendString: "StudentCategory", fontsize: 18),
                                    Container(
                                      height: Statics.getDeviceSize(context).height * (_myStudentCategoryHeaderRow != null ? 0.40 : 0.07),
                                      width: Statics.getDeviceSize(context).width,
                                      child: _myStudentCategoryHeaderRow != null
                                          ? HorizontalDataTable(
                                              leftHandSideColumnWidth: 150,
                                              rightHandSideColumnWidth: 150,
                                              isFixedHeader: true,
                                              headerWidgets: _myStudentCategoryHeaderRow,
                                              leftSideItemBuilder: _myStudentCategoryFirstColumn,
                                              rightSideItemBuilder: _myStudentCategoryOtherColumns,
                                              itemCount: (Statics.lstStudentCategory == null ? 0 : Statics.lstStudentCategory.length),
                                              rowSeparatorWidget: const Divider(
                                                color: Colors.black54,
                                                height: 1.0,
                                                thickness: 0.0,
                                              ),
                                              leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                              rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                            )
                                          : Column(
                                              children: [
                                                Text(
                                                  Statics.getLabel('NoDataFound'),
                                                  style: TextStyle(fontWeight: FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    Legend(legendString: "VyavasaayeeCategory", fontsize: 18),
                                    Container(
                                      height: Statics.getDeviceSize(context).height * (_myVyavasaayeeCategoryHeaderRow != null ? 0.40 : 0.07),
                                      width: Statics.getDeviceSize(context).width,
                                      child: _myVyavasaayeeCategoryHeaderRow != null
                                          ? HorizontalDataTable(
                                              leftHandSideColumnWidth: 150,
                                              rightHandSideColumnWidth: 150,
                                              isFixedHeader: true,
                                              headerWidgets: _myVyavasaayeeCategoryHeaderRow,
                                              leftSideItemBuilder: _myVyavasaayeeCategoryFirstColumn,
                                              rightSideItemBuilder: _myVyavasaayeeCategoryOtherColumns,
                                              itemCount: (Statics.lstVyavasaayeeCategory == null ? 0 : Statics.lstVyavasaayeeCategory.length),
                                              rowSeparatorWidget: const Divider(
                                                color: Colors.black54,
                                                height: 1.0,
                                                thickness: 0.0,
                                              ),
                                              leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                              rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                            )
                                          : Column(
                                              children: [
                                                Text(
                                                  Statics.getLabel('NoDataFound'),
                                                  style: TextStyle(fontWeight: FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _isGeounitExpanded = isExpanded;
                            });
                          },
                          children: [
                            ExpansionPanel(
                              isExpanded: _isGeounitExpanded,
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(Statics.getLabel('TargetGeoUnitDetails')),
                                );
                              },
                              body: Container(
                                margin: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 80,
                                          child: MaterialButton(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                            color: Theme.of(context).primaryColor,
                                            textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                                            onPressed: () {
                                              setState(() {
                                                _linkedMahaanagarValue = _linkedVibhaagValue =
                                                    _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
                                                _linkedMahaanagar = _linkedVibhaag = _linkedbhaag = _linkedshahar = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;

                                                tgShishuCount = "";
                                                tgBaalCount = "";
                                                tgTarunVidyaarthiCount = "";
                                                tgTarunVyavasaayeeCount = "";
                                                tgProudhaVyavasaayeeCount = "";
                                                tgUnknownAgeCount = "";
                                                tgTrutiyaVarshaShikshitCount = "";
                                                tgDwitiyaVarshaShikshitCount = "";
                                                tgPrathamVarshaShikshitCount = "";
                                                tgPraarambhikShikshitCount = "";
                                                tgPraathamikShikshitCount = "";
                                                tgNoShikshanCount = "";
                                                tgShaakhaaKaaryakartaaCount = "";
                                                tgVastiKaaryakartaaCount = "";
                                                tgGraamKaaryakartaaCount = "";
                                                tgMandalKaaryakartaaCount = "";
                                                tgNagarKaaryakartaaCount = "";
                                                tgShaharKaaryakartaaCount = "";
                                                tgBhaagKaaryakartaaCount = "";
                                                tgVibhaagKaaryakartaaCount = "";
                                                tgMahaanagarKaaryakartaaCount = "";
                                                tgPraantKaaryakartaaCount = "";
                                                notificationCount = "";
                                                tgKshetraKaaryakartaaCount = "";
                                                tgPravaaseeKaaryakartaaCount = "";
                                                tgGatividhiKaaryakartaaCount = "";
                                                tgAayaamKaaryakartaaCount = "";
                                                tgSanghaPreritSansthaaKaaryakartaaCount = "";
                                                tgTotalKaaryakartaaCount = "";
                                                tgSocialOrganizationKaaryakartaaCount = "";
                                                tgPratidnyitCount = "";
                                                _tgSadyasthitiHeaderRow = null;
                                                _tgSankalpDataHeaderRow = null;
                                                _tgBhaugolikHeaderRow = null;
                                                // _tgLastMonthBhaugolikHeaderRow = null;
                                                _tgGatividhiKaaryakartaaHeaderRow = null;
                                                _tgAayaamKaaryakartaaHeaderRow = null;
                                                _tgPreritKaaryakartaaHeaderRow = null;
                                                _tgSocialOrgKaaryakartaaHeaderRow = null;
                                                _tgStudentCategoryHeaderRow = null;
                                                _tgVyavasaayeeCategoryHeaderRow = null;
                                                _tgYesterdayDetailHeaderRow = null;
                                                _tgYesterdaySummaryHeaderRow = null;

                                                tgMasikMilanCount = '0';
                                                tgSanghaMandaliCount = '0';
                                                tgDailyShaakhaaKaaryakartaaCount = "";
                                                tgSaaptaahikMilanKaaryakartaaCount = "";
                                                tgMaasikMilanKaaryakartaaCount = "";
                                                tgAkhilBhaaratiyaKaaryakartaaCount = "";
                                                tgTotalSwayamsevakCount = "";

                                                tgMaasikEQ0 = tgMaasikEQ1 = tgSaaptaahikEQ0 = "";
                                                tgSaaptaahik1To3 = tgSaaptaahikGTE4 = "";
                                                tgShaakhaaEQ0 = tgShaakhaa1To24 = tgShaakhaaGTE25 = tgShaakhaaEQ30 = "";
                                              });

                                              populatelinkedMahanagarDropdown();
                                              populatelinkedVibhaagDropdown();
                                            },
                                            child: Text(Statics.getLabel("clear"), style: TextStyle(fontSize: 12)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_linkedMahaanagar != null)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                                        isExpanded: true,
                                        value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                                        items: _linkedMahaanagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedMahaanagarValue = value!;
                                            populatelinkedVibhaagDropdown();
                                            getTargetDetailsColumnsAndRows(value, 8);
                                          });
                                        },
                                      ),
                                    if (_linkedVibhaag != null)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                                        isExpanded: true,
                                        value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                                        items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedVibhaagValue = value!;
                                            populatelinkedBhaagDropdown(value);
                                            getTargetDetailsColumnsAndRows(value, 8);
                                          });
                                        },
                                      ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                                        isExpanded: true,
                                        value: _linkedbhaagValue == "" ? null : _linkedbhaagValue,
                                        items: _linkedbhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedbhaagValue = value;
                                            populatelinkedShaharDropdown(value!);
                                            populatelinkedNagarDropdown(value, null);
                                            getTargetDetailsColumnsAndRows(value, 7);
                                          });
                                        },
                                      ),
                                    if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    if (_linkedshahar != null && _linkedshahar!.length > 0)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                                        isExpanded: true,
                                        value: _linkedshaharValue == "" ? null : _linkedshaharValue,
                                        items: _linkedshahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedshaharValue = value;
                                            populatelinkedNagarDropdown(null, value);
                                            getTargetDetailsColumnsAndRows(value, 5);
                                          });
                                        },
                                      ),
                                    if (_linkedshahar != null && _linkedshahar!.length > 0)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    if (_linkednagar != null && _linkednagar!.length > 0)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                                        isExpanded: true,
                                        value: _linkednagarValue == "" ? null : _linkednagarValue,
                                        items: _linkednagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkednagarValue = value;
                                            populatelinkedMandalDropdown(value!);
                                            populatelinkedVastiDropdown(value);
                                            getTargetDetailsColumnsAndRows(value, 6);
                                          });
                                        },
                                      ),
                                    if (_linkednagar != null && _linkednagar!.length > 0)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    if (_linkedmandal != null && _linkedmandal!.length > 0)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Mandal')),
                                        isExpanded: true,
                                        value: _linkedmandalValue == "" ? null : _linkedmandalValue,
                                        items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedmandalValue = value;
                                            populatelinkedGraamDropdown(value!);
                                            getTargetDetailsColumnsAndRows(value, 4);
                                          });
                                        },
                                      ),
                                    if (_linkedmandal != null && _linkedmandal!.length > 0)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    if (_linkedgraam != null && _linkedgraam!.length > 0)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Graam')),
                                        isExpanded: true,
                                        value: _linkedgraamValue == "" ? null : _linkedgraamValue,
                                        items: _linkedgraam!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedgraamValue = value;
                                            getTargetDetailsColumnsAndRows(value, 3);
                                          });
                                        },
                                      ),
                                    if (_linkedvasti != null && _linkedvasti!.length > 0)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Vasti')),
                                        isExpanded: true,
                                        value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                                        items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedvastiValue = value;
                                            getTargetDetailsColumnsAndRows(value, 2);
                                          });
                                        },
                                      ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    if (_isTgSearching)
                                      CircularProgressIndicator()
                                    else
                                      Column(
                                        children: [
                                          Legend(legendString: "yesterdayNews", fontsize: 18),
                                          Container(
                                            height: Statics.getDeviceSize(context).height * (_tgYesterdaySummaryHeaderRow != null ? 0.40 : 0.07),
                                            width: Statics.getDeviceSize(context).width,
                                            child: _tgYesterdaySummaryHeaderRow != null
                                                ? HorizontalDataTable(
                                                    leftHandSideColumnWidth: 100,
                                                    rightHandSideColumnWidth: 400,
                                                    isFixedHeader: true,
                                                    headerWidgets: _tgYesterdaySummaryHeaderRow,
                                                    leftSideItemBuilder: _tgYesterdaySummaryFirstColumn,
                                                    rightSideItemBuilder: _tgYesterdaySummaryOtherColumns,
                                                    itemCount: (Statics.tgLstYesterdayVruttaSummary == null ? 0 : Statics.tgLstYesterdayVruttaSummary.length),
                                                    rowSeparatorWidget: const Divider(
                                                      color: Colors.black54,
                                                      height: 1.0,
                                                      thickness: 0.0,
                                                    ),
                                                    leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                    rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                  )
                                                : Column(
                                                    children: [
                                                      Text(
                                                        Statics.getLabel('NoDataFound'),
                                                        style: TextStyle(fontWeight: FontWeight.normal),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          if (_tgLevelID <= 6)
                                            Container(
                                              height: Statics.getDeviceSize(context).height * (_tgYesterdayDetailHeaderRow != null ? 0.40 : 0.07),
                                              width: Statics.getDeviceSize(context).width,
                                              child: _tgYesterdayDetailHeaderRow != null
                                                  ? HorizontalDataTable(
                                                      leftHandSideColumnWidth: 100,
                                                      rightHandSideColumnWidth: 800,
                                                      isFixedHeader: true,
                                                      headerWidgets: _tgYesterdayDetailHeaderRow,
                                                      leftSideItemBuilder: _tgYesterdayDetailFirstColumn,
                                                      rightSideItemBuilder: _tgYesterdayDetailOtherColumns,
                                                      itemCount: (Statics.tgLstYesterdayVruttaDetail == null ? 0 : Statics.tgLstYesterdayVruttaDetail.length),
                                                      rowSeparatorWidget: const Divider(
                                                        color: Colors.black54,
                                                        height: 1.0,
                                                        thickness: 0.0,
                                                      ),
                                                      leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                      rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                    )
                                                  : Column(
                                                      children: [
                                                        Text(
                                                          Statics.getLabel('NoDataFound'),
                                                          style: TextStyle(fontWeight: FontWeight.normal),
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                          SizedBox(
                                            height: 15,
                                          ),

                                          Legend(legendString: "ShaakhaaVruttaSummaryLabel", fontsize: 18),
                                          SingleColumnRow(txtString: Statics.getLabel('Shaakhaa') + ':-', value: '', fontsize: 18),
                                          SingleColumnRow(txtString: Statics.getLabel('ShaakhaaEQ0'), value: tgShaakhaaEQ0 == "null" ? "0" : tgShaakhaaEQ0, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('Shaakhaa1To24'), value: tgShaakhaa1To24 == "null" ? "0" : tgShaakhaa1To24, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('ShaakhaaGTE25'), value: tgShaakhaaGTE25 == "null" ? "0" : tgShaakhaaGTE25, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('ShaakhaaEQ30'), value: tgShaakhaaEQ30 == "null" ? "0" : tgShaakhaaEQ30, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('SaaptaahikMilan') + ':-', value: '', fontsize: 18),
                                          SingleColumnRow(txtString: Statics.getLabel('SaaptaahikEQ0'), value: tgSaaptaahikEQ0 == "null" ? "0" : tgSaaptaahikEQ0, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('Saaptaahik1To3'), value: tgSaaptaahik1To3 == "null" ? "0" : tgSaaptaahik1To3, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('SaaptaahikGTE4'), value: tgSaaptaahikGTE4 == "null" ? "0" : tgSaaptaahikGTE4, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('MaasikMilan') + '/' + Statics.getLabel('SanghaMandali') + ':-', value: '', fontsize: 18),
                                          SingleColumnRow(txtString: Statics.getLabel('MaasikEQ0'), value: tgMaasikEQ0 == "null" ? "0" : tgMaasikEQ0, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('MaasikEQ1'), value: tgMaasikEQ1 == "null" ? "0" : tgMaasikEQ1, fontsize: 15),
                                          SizedBox(
                                            height: 15,
                                          ),

                                          Legend(legendString: "SankalpTable", fontsize: 18),
                                          Container(
                                            constraints: BoxConstraints(maxHeight: Statics.getDeviceSize(context).height * 0.4, minHeight: Statics.getDeviceSize(context).height * 0.07),
                                            //height: Statics.getDeviceSize(context).height * (_tgSadyasthitiHeaderRow != null ? 0.40 : 0.07),
                                            width: Statics.getDeviceSize(context).width,
                                            child: _tgSadyasthitiHeaderRow != null
                                                ? HorizontalDataTable(
                                                    leftHandSideColumnWidth: 100,
                                                    rightHandSideColumnWidth: 130 * 12,
                                                    isFixedHeader: true,
                                                    headerWidgets: _tgSadyasthitiHeaderRow,
                                                    leftSideItemBuilder: _tgSadyasthitiFirstColumn,
                                                    rightSideItemBuilder: _tgSadyasthitiOtherColumns,
                                                    itemCount: (Statics.tgLstdashboardSadyaSthitiData == null ? 0 : Statics.tgLstdashboardSadyaSthitiData.length),
                                                    rowSeparatorWidget: const Divider(
                                                      color: Colors.black54,
                                                      height: 1.0,
                                                      thickness: 0.0,
                                                    ),
                                                    leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                    rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                  )
                                                : Column(
                                                    children: [
                                                      Text(
                                                        Statics.getLabel('NoDataFound'),
                                                        style: TextStyle(fontWeight: FontWeight.normal),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          // SingleColumnRow(txtString: Statics.getLabel('MaasikMilan'), value: tgMasikMilanCount, fontsize: 15),
                                          // SingleColumnRow(txtString: Statics.getLabel('SanghaMandali'), value: tgSanghaMandaliCount, fontsize: 15),
                                          // SingleColumnRow(txtString: Statics.getLabel('EkunSankalpitShakha'), value:totalsankalpitshakhaCount, fontsize: 15),
                                          // SingleColumnRow(txtString: Statics.getLabel('EkunSankalpitSaptahikMilan'), value: totalsankalpitSaaptaahikCount, fontsize: 15),
                                          // SizedBox(height: 15,),

                                          Legend(legendString: "NewSankalpTable", fontsize: 18),
                                          Container(
                                            height: Statics.getDeviceSize(context).height * (_tgSankalpDataHeaderRow != null ? 0.40 : 0.07),
                                            width: Statics.getDeviceSize(context).width,
                                            child: _tgSankalpDataHeaderRow != null
                                                ? HorizontalDataTable(
                                                    leftHandSideColumnWidth: 100,
                                                    rightHandSideColumnWidth: 130 * 5,
                                                    isFixedHeader: true,
                                                    headerWidgets: _tgSankalpDataHeaderRow,
                                                    leftSideItemBuilder: _tgSankalpDataFirstColumn,
                                                    rightSideItemBuilder: _tgSankalpDataOtherColumns,
                                                    itemCount: (Statics.tgLstSankalpByAadhaarData == null ? 0 : Statics.tgLstSankalpByAadhaarData.length),
                                                    rowSeparatorWidget: const Divider(
                                                      color: Colors.black54,
                                                      height: 1.0,
                                                      thickness: 0.0,
                                                    ),
                                                    leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                    rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                  )
                                                : Column(
                                                    children: [
                                                      Text(
                                                        Statics.getLabel('NoDataFound'),
                                                        style: TextStyle(fontWeight: FontWeight.normal),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),

                                          Legend(legendString: "BhaugolikVistaar", fontsize: 18),
                                          Container(
                                            height: Statics.getDeviceSize(context).height * (_tgBhaugolikHeaderRow != null ? 0.40 : 0.07),
                                            width: Statics.getDeviceSize(context).width,
                                            child: _tgBhaugolikHeaderRow != null
                                                ? HorizontalDataTable(
                                                    leftHandSideColumnWidth: 100,
                                                    rightHandSideColumnWidth: 400,
                                                    isFixedHeader: true,
                                                    headerWidgets: _tgBhaugolikHeaderRow,
                                                    leftSideItemBuilder: _tgBhagolikVistaarFirstColumn,
                                                    rightSideItemBuilder: _tgBhagolikVistaarOtherColumns,
                                                    itemCount: (Statics.tgLstBhaugolikVistaar == null ? 0 : Statics.tgLstBhaugolikVistaar.length),
                                                    rowSeparatorWidget: const Divider(
                                                      color: Colors.black54,
                                                      height: 1.0,
                                                      thickness: 0.0,
                                                    ),
                                                    leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                    rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                  )
                                                : Column(
                                                    children: [
                                                      Text(
                                                        Statics.getLabel('NoDataFound'),
                                                        style: TextStyle(fontWeight: FontWeight.normal),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),

                                          // Legend(legendString: "LastMonthBhaugolikVistaar", fontsize: 18),
                                          // Container(
                                          //   height: Statics.getDeviceSize(context).height *
                                          //       (_tgLastMonthBhaugolikHeaderRow != null ? 0.40 : 0.07),
                                          //   width: Statics.getDeviceSize(context).width,
                                          //   child: _tgLastMonthBhaugolikHeaderRow != null
                                          //     ? HorizontalDataTable(
                                          //         leftHandSideColumnWidth: 100,
                                          //         rightHandSideColumnWidth: 400,
                                          //         isFixedHeader: true,
                                          //         headerWidgets: _tgLastMonthBhaugolikHeaderRow,
                                          //         leftSideItemBuilder: _tgLastMonthBhagolikVistaarFirstColumn,
                                          //         rightSideItemBuilder: _tgLastMonthBhagolikVistaarOtherColumns,
                                          //         itemCount: (Statics.tgLstLastMonthBhaugolikVistaar == null ? 0 : Statics.tgLstLastMonthBhaugolikVistaar.length),
                                          //         rowSeparatorWidget: const Divider(
                                          //           color: Colors.black54,
                                          //           height: 1.0,
                                          //           thickness: 0.0,
                                          //         ),
                                          //         leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                          //         rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                          //     )
                                          //     : Column(
                                          //         children:[
                                          //           Text(Statics.getLabel('NoDataFound'),
                                          //             style: TextStyle(fontWeight: FontWeight.normal),),
                                          //         ],
                                          //     ),
                                          // ),

                                          Legend(legendString: "SwayamsevakCount", fontsize: 18),
                                          SingleColumnRow(txtString: Statics.getLabel('TotalKaaryakartaaCount'), value: tgTotalSwayamsevakCount, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('PratidnyitCount'), value: tgPratidnyitCount, fontsize: 15),
                                          SizedBox(
                                            height: 15,
                                          ),

                                          Legend(legendString: "SwayamsevakCountByAge", fontsize: 18),
                                          SingleColumnRow(txtString: Statics.getLabel('Shishu'), value: tgShishuCount, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('Baal'), value: tgBaalCount, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('TarunVidyaarthi'), value: tgTarunVidyaarthiCount, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('TarunVyavasaayee'), value: tgTarunVyavasaayeeCount, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('ProudhVyavasaayee'), value: tgProudhaVyavasaayeeCount, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('UnkownAge'), value: tgUnknownAgeCount, fontsize: 15),
                                          SizedBox(
                                            height: 15,
                                          ),

                                          Legend(legendString: "ShikshitSwayamsevakCount", fontsize: 18),
                                          SingleColumnRow(
                                              txtString: Statics.getLabel('PrarambhikShikshit'), value: tgPraarambhikShikshitCount == 'null' ? "0" : tgPraarambhikShikshitCount, fontsize: 15),
                                          SingleColumnRow(
                                              txtString: Statics.getLabel('PraathamikShikshit'), value: tgPraathamikShikshitCount == 'null' ? "0" : tgPraathamikShikshitCount, fontsize: 15),
                                          SingleColumnRow(
                                              txtString: Statics.getLabel('PrathamVarshShikshit'), value: tgPrathamVarshaShikshitCount == 'null' ? "0" : tgPrathamVarshaShikshitCount, fontsize: 15),
                                          SingleColumnRow(
                                              txtString: Statics.getLabel('DwitiyaVarshShikshit'), value: tgDwitiyaVarshaShikshitCount == 'null' ? "0" : tgDwitiyaVarshaShikshitCount, fontsize: 15),
                                          SingleColumnRow(
                                              txtString: Statics.getLabel('TrutiyaVarshShikshit'), value: tgTrutiyaVarshaShikshitCount == 'null' ? "0" : tgTrutiyaVarshaShikshitCount, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('NoShikshan'), value: tgNoShikshanCount, fontsize: 15),
                                          SizedBox(
                                            height: 15,
                                          ),

                                          Legend(legendString: "KaaryakartaaCountByLevel", fontsize: 18),
                                          TwoColumnRow(
                                            txtString: Statics.getLabel('Shaakhaa'),
                                            value: tgDailyShaakhaaKaaryakartaaCount,
                                            txtString2: Statics.getLabel('SaaptaahikLabelShort'),
                                            value2: tgSaaptaahikMilanKaaryakartaaCount,
                                            fontsize: 15,
                                          ),
                                          TwoColumnRow(
                                            txtString: Statics.getLabel('MilanMandali'),
                                            value: tgMaasikMilanKaaryakartaaCount,
                                            txtString2: Statics.getLabel('VastiKaaryakartaaCount'),
                                            value2: tgVastiKaaryakartaaCount,
                                            fontsize: 15,
                                          ),
                                          TwoColumnRow(
                                            txtString: Statics.getLabel('GraamKaaryakartaaCount'),
                                            value: tgGraamKaaryakartaaCount,
                                            txtString2: Statics.getLabel('MandalKaaryakartaaCount'),
                                            value2: tgMandalKaaryakartaaCount,
                                            fontsize: 15,
                                          ),
                                          TwoColumnRow(
                                            txtString: Statics.getLabel('NagarKaaryakartaaCount'),
                                            value: tgNagarKaaryakartaaCount,
                                            txtString2: Statics.getLabel('ShaharKaaryakartaaCount'),
                                            value2: tgShaharKaaryakartaaCount,
                                            fontsize: 15,
                                          ),
                                          TwoColumnRow(
                                            txtString: Statics.getLabel('BhaagKaaryakartaaCount'),
                                            value: tgBhaagKaaryakartaaCount,
                                            txtString2: Statics.getLabel('VibhaagKaaryakartaaCount'),
                                            value2: tgVibhaagKaaryakartaaCount,
                                            fontsize: 15,
                                          ),
                                          TwoColumnRow(
                                            txtString: Statics.getLabel('MahaanagarKaaryakartaaCount'),
                                            value: tgMahaanagarKaaryakartaaCount,
                                            txtString2: Statics.getLabel('PraantKaaryakartaaCount'),
                                            value2: tgPraantKaaryakartaaCount,
                                            fontsize: 15,
                                          ),
                                          TwoColumnRow(
                                            txtString: Statics.getLabel('KshetraKaaryakartaaCount'),
                                            value: tgKshetraKaaryakartaaCount,
                                            txtString2: Statics.getLabel('AkhilBhaaratiyaKaaryakartaaCount'),
                                            value2: tgAkhilBhaaratiyaKaaryakartaaCount,
                                            fontsize: 15,
                                          ),
                                          TwoColumnRow(
                                            txtString: Statics.getLabel('PravaaseeKaaryakartaaCount'),
                                            value: tgPravaaseeKaaryakartaaCount,
                                            txtString2: Statics.getLabel('TotalKaaryakartaaCount'),
                                            value2: tgTotalKaaryakartaaCount,
                                            fontsize: 15,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),

                                          Legend(legendString: "GatividhiAayaamSansthaaKaaryakartaaCount", fontsize: 18),
                                          SingleColumnRow(txtString: Statics.getLabel('GatividhiKaaryakartaaCount'), value: tgGatividhiKaaryakartaaCount, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('AayaamKaaryakartaaCount'), value: tgAayaamKaaryakartaaCount, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('SanghaPreritSansthaaKaaryakartaaCount'), value: tgSanghaPreritSansthaaKaaryakartaaCount, fontsize: 15),
                                          SingleColumnRow(txtString: Statics.getLabel('SocialOrganizationKaaryakartaaCount'), value: tgSocialOrganizationKaaryakartaaCount, fontsize: 15),
                                          SizedBox(
                                            height: 15,
                                          ),

                                          Legend(legendString: "Gatividhi", fontsize: 18),
                                          Container(
                                            height: Statics.getDeviceSize(context).height * (_tgGatividhiKaaryakartaaHeaderRow != null ? 0.40 : 0.07),
                                            width: Statics.getDeviceSize(context).width,
                                            child: _tgGatividhiKaaryakartaaHeaderRow != null
                                                ? HorizontalDataTable(
                                                    leftHandSideColumnWidth: 150,
                                                    rightHandSideColumnWidth: 150,
                                                    isFixedHeader: true,
                                                    headerWidgets: _tgGatividhiKaaryakartaaHeaderRow,
                                                    leftSideItemBuilder: _tgGatividhiKaaryakartaaFirstColumn,
                                                    rightSideItemBuilder: _tgGatividhiKaaryakartaaOtherColumns,
                                                    itemCount: (Statics.tgLstGatividhiKaaryakartaa == null ? 0 : Statics.tgLstGatividhiKaaryakartaa.length),
                                                    rowSeparatorWidget: const Divider(
                                                      color: Colors.black54,
                                                      height: 1.0,
                                                      thickness: 0.0,
                                                    ),
                                                    leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                    rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                  )
                                                : Column(
                                                    children: [
                                                      Text(
                                                        Statics.getLabel('NoDataFound'),
                                                        style: TextStyle(fontWeight: FontWeight.normal),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),

                                          Legend(legendString: "Aayaam", fontsize: 18),
                                          Container(
                                            height: Statics.getDeviceSize(context).height * (_tgAayaamKaaryakartaaHeaderRow != null ? 0.40 : 0.07),
                                            width: Statics.getDeviceSize(context).width,
                                            child: _tgAayaamKaaryakartaaHeaderRow != null
                                                ? HorizontalDataTable(
                                                    leftHandSideColumnWidth: 150,
                                                    rightHandSideColumnWidth: 150,
                                                    isFixedHeader: true,
                                                    headerWidgets: _tgAayaamKaaryakartaaHeaderRow,
                                                    leftSideItemBuilder: _tgAayaamKaaryakartaaFirstColumn,
                                                    rightSideItemBuilder: _tgAayaamKaaryakartaaOtherColumns,
                                                    itemCount: (Statics.tgLstAayaamKaaryakartaa == null ? 0 : Statics.tgLstAayaamKaaryakartaa.length),
                                                    rowSeparatorWidget: const Divider(
                                                      color: Colors.black54,
                                                      height: 1.0,
                                                      thickness: 0.0,
                                                    ),
                                                    leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                    rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                  )
                                                : Column(
                                                    children: [
                                                      Text(
                                                        Statics.getLabel('NoDataFound'),
                                                        style: TextStyle(fontWeight: FontWeight.normal),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),

                                          Legend(legendString: "Sangha-PreritSansthaa", fontsize: 18),
                                          Container(
                                            height: Statics.getDeviceSize(context).height * (_tgPreritKaaryakartaaHeaderRow != null ? 0.40 : 0.07),
                                            width: Statics.getDeviceSize(context).width,
                                            child: _tgPreritKaaryakartaaHeaderRow != null
                                                ? HorizontalDataTable(
                                                    leftHandSideColumnWidth: 150,
                                                    rightHandSideColumnWidth: 150,
                                                    isFixedHeader: true,
                                                    headerWidgets: _tgPreritKaaryakartaaHeaderRow,
                                                    leftSideItemBuilder: _tgPreritKaaryakartaaFirstColumn,
                                                    rightSideItemBuilder: _tgPreritKaaryakartaaOtherColumns,
                                                    itemCount: (Statics.tgLstPreritKaaryakartaa == null ? 0 : Statics.tgLstPreritKaaryakartaa.length),
                                                    rowSeparatorWidget: const Divider(
                                                      color: Colors.black54,
                                                      height: 1.0,
                                                      thickness: 0.0,
                                                    ),
                                                    leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                    rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                  )
                                                : Column(
                                                    children: [
                                                      Text(
                                                        Statics.getLabel('NoDataFound'),
                                                        style: TextStyle(fontWeight: FontWeight.normal),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),

                                          Legend(legendString: "OtherSocialOrganization", fontsize: 18),
                                          Container(
                                            height: Statics.getDeviceSize(context).height * (_tgSocialOrgKaaryakartaaHeaderRow != null ? 0.40 : 0.07),
                                            width: Statics.getDeviceSize(context).width,
                                            child: _tgSocialOrgKaaryakartaaHeaderRow != null
                                                ? HorizontalDataTable(
                                                    leftHandSideColumnWidth: 150,
                                                    rightHandSideColumnWidth: 150,
                                                    isFixedHeader: true,
                                                    headerWidgets: _tgSocialOrgKaaryakartaaHeaderRow,
                                                    leftSideItemBuilder: _tgSocialOrgKaaryakartaaFirstColumn,
                                                    rightSideItemBuilder: _tgSocialOrgKaaryakartaaOtherColumns,
                                                    itemCount: (Statics.tgLstSocialOrgKaaryakartaa == null ? 0 : Statics.tgLstSocialOrgKaaryakartaa.length),
                                                    rowSeparatorWidget: const Divider(
                                                      color: Colors.black54,
                                                      height: 1.0,
                                                      thickness: 0.0,
                                                    ),
                                                    leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                    rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                  )
                                                : Column(
                                                    children: [
                                                      Text(
                                                        Statics.getLabel('NoDataFound'),
                                                        style: TextStyle(fontWeight: FontWeight.normal),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),

                                          Legend(legendString: "StudentCategory", fontsize: 18),
                                          Container(
                                            height: Statics.getDeviceSize(context).height * (_tgStudentCategoryHeaderRow != null ? 0.40 : 0.07),
                                            width: Statics.getDeviceSize(context).width,
                                            child: _tgStudentCategoryHeaderRow != null
                                                ? HorizontalDataTable(
                                                    leftHandSideColumnWidth: 150,
                                                    rightHandSideColumnWidth: 150,
                                                    isFixedHeader: true,
                                                    headerWidgets: _tgStudentCategoryHeaderRow,
                                                    leftSideItemBuilder: _tgStudentCategoryFirstColumn,
                                                    rightSideItemBuilder: _tgStudentCategoryOtherColumns,
                                                    itemCount: (Statics.tgLstStudentCategory == null ? 0 : Statics.tgLstStudentCategory.length),
                                                    rowSeparatorWidget: const Divider(
                                                      color: Colors.black54,
                                                      height: 1.0,
                                                      thickness: 0.0,
                                                    ),
                                                    leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                    rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                  )
                                                : Column(
                                                    children: [
                                                      Text(
                                                        Statics.getLabel('NoDataFound'),
                                                        style: TextStyle(fontWeight: FontWeight.normal),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),

                                          Legend(legendString: "VyavasaayeeCategory", fontsize: 18),
                                          Container(
                                            height: Statics.getDeviceSize(context).height * (_tgVyavasaayeeCategoryHeaderRow != null ? 0.40 : 0.07),
                                            width: Statics.getDeviceSize(context).width,
                                            child: _tgVyavasaayeeCategoryHeaderRow != null
                                                ? HorizontalDataTable(
                                                    leftHandSideColumnWidth: 150,
                                                    rightHandSideColumnWidth: 150,
                                                    isFixedHeader: true,
                                                    headerWidgets: _tgVyavasaayeeCategoryHeaderRow,
                                                    leftSideItemBuilder: _tgVyavasaayeeCategoryFirstColumn,
                                                    rightSideItemBuilder: _tgVyavasaayeeCategoryOtherColumns,
                                                    itemCount: (Statics.tgLstVyavasaayeeCategory == null ? 0 : Statics.tgLstVyavasaayeeCategory.length),
                                                    rowSeparatorWidget: const Divider(
                                                      color: Colors.black54,
                                                      height: 1.0,
                                                      thickness: 0.0,
                                                    ),
                                                    leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                    rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                                  )
                                                : Column(
                                                    children: [
                                                      Text(
                                                        Statics.getLabel('NoDataFound'),
                                                        style: TextStyle(fontWeight: FontWeight.normal),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                inAsyncCall: _isSearching),
          ],
        ),
      ),
    );
  }

  Widget buildUpnagarCountDataTable(List<UpkhandaDataList> data) {
    final List<String> headers = [
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
        child: Center(
          child: Text(
            Statics.getLabel('NoDataFound'),
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DataTable(
          headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
          columnSpacing: 0,
          horizontalMargin: 16,
          border: TableBorder.all(color: Colors.black26),
          columns: [
            DataColumn(
              label: Center(
                child: SizedBox(
                  width: 50,
                  child: Text(
                    Statics.getLabel("hoomeScreenUpnagarTable0"),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
          rows: data.map((level) {
                return DataRow(color: MaterialStatePropertyAll(Colors.white), cells: [
                  DataCell(Text(level.goUnitName.toString())),
                ]);
              }).toList() +
              [
                DataRow(color: MaterialStatePropertyAll(Colors.yellow.shade100), cells: [
                  DataCell(Text(
                    Statics.getLabel("Total"),
                    style: TextStyle(fontWeight: FontWeight.w700),
                  )),
                ])
              ],
        ),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            interactive: true,
            thickness: 5,
            radius: Radius.circular(10),
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 14,
                horizontalMargin: 12,
                headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                border: TableBorder(verticalInside: BorderSide(width: 0.7, color: Colors.grey.shade200)),
                columns: headers
                    .map((header) => DataColumn(
                          label: Container(
                            constraints: BoxConstraints(minWidth: 40, maxWidth: 100),
                            // constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.2),
                            child: Text(header, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ))
                    .toList(),
                rows: data.map((level) {
                      return DataRow(color: MaterialStatePropertyAll(Colors.white), cells: [
                        DataCell(Center(child: Text(level.nagarCount.toString()))),
                        DataCell(Center(child: Text(level.vastiCount.toString()))),
                        DataCell(Center(child: Text(level.gramCount.toString()))),
                        DataCell(Center(child: Text(level.upNagarCount.toString()))),
                        DataCell(Center(child: Text(level.mapUpNagarCount.toString()))),
                        DataCell(Center(child: Text(level.upKhandCount.toString()))),
                        DataCell(Center(child: Text(level.mapUpKhandCount.toString()))),
                        DataCell(Center(child: Icon(Icons.download, color: Colors.purple, size: 16)), onTap: () => getExcelReportDataFun(level)),
                      ]);
                    }).toList() +
                    [
                      DataRow(color: MaterialStatePropertyAll(Colors.yellow.shade100), cells: [
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.nagarCount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.vastiCount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.gramCount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.upNagarCount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.mapUpNagarCount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.upKhandCount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.mapUpKhandCount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(SizedBox()),
                      ])
                    ],
              ),
            ),
          ),
        ),
        // DataTable(
        //   headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
        //   columnSpacing: 0,
        //   horizontalMargin: 6,
        //   border: TableBorder.all(color: Colors.black26),
        //   columns: [
        //     DataColumn(
        //       label: Center(
        //         child: SizedBox(
        //           width: 30,
        //           child: Text(
        //             "",
        //             // Statics.getLabel("downloadReport"),
        //             softWrap: true,
        //             maxLines: 2,
        //             overflow: TextOverflow.ellipsis,
        //             style: TextStyle(fontWeight: FontWeight.bold),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        //   rows: data.map((level) {
        //     return DataRow(color: MaterialStatePropertyAll(Colors.white), cells: [
        //       DataCell(Center(child: Icon(Icons.download, color: Colors.purple, size: 16)), onTap: getExcelReportDataFun),
        //     ]);
        //   }).toList(),
        // ),
      ],
    );
  }

  shatabdiVrutaCard() {
    return Row(
      children: [
        // SizedBox(height: 50, child: VerticalDivider(color: Colors.purple)),
        // SizedBox(width: 6),
        // SizedBox(height: 50, child: VerticalDivider(color: Colors.purple)),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 19),
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(context).pushNamed(VijayadashamiFormView.routeName),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    "${Statics.getLabel('vijayaDashamiUtsav')} \n${Statics.getLabel('Vrutta')}",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ]),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(context).pushNamed(VijayadashamiFormReport.routeName),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    "${Statics.getLabel('vijayaDashamiUtsav')} ${Statics.getLabel('Reportonly')}",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(context).pushNamed(GruhAbhiyaanMainTabScreen.routeName),
                            // onTap: () {
                            //   Fluttertoast.showToast(
                            //     msg: Statics.getLabel("workInProgress"),
                            //     toastLength: Toast.LENGTH_SHORT,
                            //     gravity: ToastGravity.BOTTOM,
                            //   );
                            // },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    Statics.getLabel("gruhSamparkAbhiyan"),
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ]),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(context).pushNamed(HinduSanmelanForm.routeName),
                            // onTap: () async {
                            //   Fluttertoast.showToast(
                            //     msg: Statics.getLabel("workInProgress"),
                            //     toastLength: Toast.LENGTH_SHORT,
                            //     gravity: ToastGravity.BOTTOM,
                            //   );
                            // },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    Statics.getLabel("hinduSammelan"),
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Fluttertoast.showToast(
                                msg: Statics.getLabel("workInProgress"),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    Statics.getLabel("sadbhavBaithak"),
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ]),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Fluttertoast.showToast(
                                msg: Statics.getLabel("workInProgress"),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    Statics.getLabel("pramukhJansanvaad"),
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Fluttertoast.showToast(
                                msg: Statics.getLabel("workInProgress"),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    Statics.getLabel("yuvaSangam"),
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ]),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Fluttertoast.showToast(
                                msg: Statics.getLabel("workInProgress"),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    Statics.getLabel("shakhaVistaar"),
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                top: -13,
                child: ClipPath(
                  clipBehavior: Clip.antiAlias,
                  clipper: LabelClipper(),
                  child: Container(
                    padding: EdgeInsets.only(right: 24, top: 3, bottom: 2, left: 8),
                    decoration: BoxDecoration(color: Colors.purple.shade300, borderRadius: BorderRadius.circular(12)),
                    child: Text(Statics.getLabel("shatabdiVarshaVruttaTitle"), style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  surveyCard() {
    return Row(
      children: [
        // SizedBox(height: 50, child: VerticalDivider(color: Colors.purple)),
        // SizedBox(width: 6),
        // SizedBox(height: 50, child: VerticalDivider(color: Colors.purple)),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 19),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(context).pushNamed(VastiSurveyFormScreen.routeName),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    "${Statics.getLabel('vastiSurvey')}",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ]),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(context).pushNamed(MandalSurveyFormScreen.routeName),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    "${Statics.getLabel('mandalSurvey')}",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(context).pushNamed(VastiSurveyReportScreen.routeName),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    "${Statics.getLabel('vastiSurveyReport')}",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ]),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(context).pushNamed(MandalSurveyReportScreen.routeName),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    "${Statics.getLabel('mandalSurveyReport')}",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -13,
                child: ClipPath(
                  clipBehavior: Clip.antiAlias,
                  clipper: LabelClipper(),
                  child: Container(
                    padding: EdgeInsets.only(right: 16, top: 3, bottom: 2, left: 8),
                    decoration: BoxDecoration(color: Colors.purple.shade300, borderRadius: BorderRadius.circular(12)),
                    child: Text("${Statics.getLabel("Survey")}", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  moreCard() {
    return Row(
      children: [
        // SizedBox(height: 50, child: VerticalDivider(color: Colors.purple)),
        // SizedBox(width: 6),
        // SizedBox(height: 50, child: VerticalDivider(color: Colors.purple)),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 19),
                    Row(
                      children: [
                        if (shouldShowListTile(Statics.userDetails['LevelName'], Statics.userDetails["DaayitvaName"]) == true)
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.of(context).pushNamed(SearchJoinRss.routeName),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                child: Row(children: [
                                  Expanded(
                                    child: Text(
                                      "${Statics.getLabel('searchJoinRSSScreenLabel')}",
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded, size: 16),
                                ]),
                              ),
                            ),
                          ),
                        SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(context).pushNamed(SwayamSevakSearch.routeName),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    "${Statics.getLabel('searchSwayamsevakScreenBanner')}",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(context).pushNamed(AbhiyanScreen.routeName),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    "${Statics.getLabel('Abhiyaan')}",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ]),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(context).pushNamed(SearchSoochiScreen.routeName),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    "${Statics.getLabel('searchSoochiScreenLabel')}",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        if (shouldShowListTileforGeounitCHange(Statics.userDetails['LevelName'], Statics.userDetails["DaayitvaName"]) == true)
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.of(context).pushNamed(TabScreen.routeName),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                child: Row(children: [
                                  Expanded(
                                    child: Text(
                                      "${Statics.getLabel('masterdataupdate2')}",
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded, size: 16),
                                ]),
                              ),
                            ),
                          ),
                        SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(context).pushNamed(SearchEvent.routeName),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    "${Statics.getLabel('searchEventsScreenLabel')}",
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    if (
                        // (Statics.userDetails["LevelName"] == "Praant" ||
                        //         Statics.userDetails["LevelName"] == "Mahaanagar" ||
                        //         Statics.userDetails["LevelName"] == "Vibhaag" ||
                        //         Statics.userDetails["LevelName"] == "Bhaag" ||
                        //         Statics.userDetails["LevelName"] == "Shahar" ||
                        //         Statics.userDetails['LevelName'] == 'Nagar/Taalukaa'  || Statics.userDetails['LevelName'] == 'Nagar' |||
                        //         Statics.userDetails["LevelName"] == "Graam" ||
                        //         Statics.userDetails["LevelName"] == "Vasti")
                        (Statics.userDetails["LevelName"] == "Praant" ||
                                    Statics.userDetails["LevelName"] == "प्रांत" ||
                                    Statics.userDetails["LevelName"] == "Mahaanagar" ||
                                    Statics.userDetails["LevelName"] == "महानगर" ||
                                    Statics.userDetails["LevelName"] == "Vibhaag" ||
                                    Statics.userDetails["LevelName"] == "विभाग" ||
                                    Statics.userDetails["LevelName"] == "Bhaag" ||
                                    Statics.userDetails["LevelName"] == "भाग/जिला" ||
                                    Statics.userDetails["LevelName"] == "भाग/जिल्हा" ||
                                    Statics.userDetails["LevelName"] == "Shahar" ||
                                    Statics.userDetails["LevelName"] == "शहर" ||
                                    Statics.userDetails['LevelName'] == 'Nagar/Taalukaa' ||
                                    Statics.userDetails['LevelName'] == 'Nagar' ||
                                    Statics.userDetails["LevelName"] == "नगर/तालुका" ||
                                    Statics.userDetails["LevelName"] == "Graam" ||
                                    Statics.userDetails["LevelName"] == "ग्राम" ||
                                    Statics.userDetails["LevelName"] == "Vasti" ||
                                    Statics.userDetails["LevelName"] == "वस्ती") &&
                                // (Statics.userDetails["DaayitvaName"] == "Kaaryaalay Pramukh" ||
                                //     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
                                //     Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
                                //     Statics.userDetails["DaayitvaName"] == "Prachaarak" ||
                                //     Statics.userDetails["DaayitvaName"] == "Saha-Prachaarak" ||
                                //     Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "App Sanyojak" ||
                            //     Statics.userDetails["DaayitvaName"] == "Pramukh")
                            (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
                                Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
                                Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
                                Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "Kaaryaalay Pramukh" ||
                                Statics.userDetails["DaayitvaName"] == "कार्यालय प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
                                Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
                                Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
                                Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
                                Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
                                Statics.userDetails["DaayitvaName"] == "सह कार्यवाह" ||
                                Statics.userDetails["DaayitvaName"] == "Prachaarak" ||
                                Statics.userDetails["DaayitvaName"] == "प्रचारक" ||
                                Statics.userDetails["DaayitvaName"] == "Saha-Prachaarak" ||
                                Statics.userDetails["DaayitvaName"] == "सह प्रचारक" ||
                                Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" ||
                                Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh" ||
                                Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh" ||
                                Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh" ||
                                Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" ||
                                Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" ||
                                Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" ||
                                Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" ||
                                Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" ||
                                Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" ||
                                Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
                                Statics.userDetails["DaayitvaName"] == "App Sanyojak" ||
                                Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
                                Statics.userDetails["DaayitvaName"] == "Pramukh" ||
                                Statics.userDetails["DaayitvaName"] == "प्रमुख"))
                      InkWell(
                        onTap: () => Navigator.of(context).pushNamed(SearchRamJanmaBhoomiNidhiSankalan.routeName),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          child: Row(children: [
                            Expanded(
                              child: Text(
                                "${Statics.getLabel('searchRamJanmabhoomiNidhiSankalanVrutta')}",
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, size: 16),
                          ]),
                        ),
                      ),
                  ],
                ),
              ),
              Positioned(
                top: -13,
                child: ClipPath(
                  clipBehavior: Clip.antiAlias,
                  clipper: LabelClipper(),
                  child: Container(
                    padding: EdgeInsets.only(right: 16, top: 4, bottom: 2, left: 8),
                    decoration: BoxDecoration(color: Colors.purple.shade300, borderRadius: BorderRadius.circular(12)),
                    child: Text(Statics.getLabel("mainScreenOther"), style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
