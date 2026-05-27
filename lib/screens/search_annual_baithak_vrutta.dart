import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../helpers/static_data.dart' as Statics;
import '../providers/bals.dart';
import '../utils/globals.dart';
import '../utils/stable_geounit_class.dart';
import '../widgets/app_drawer.dart';
import '../widgets/legend.dart';
import './edit_annual_baithak_graam_vikas_vrutta.dart';
import './edit_annual_baithak_mukhya_maarg_vrutta.dart';
import './edit_annual_baithak_shaakhaa_vrutta.dart';
import 'nirikshan_baithak_vrutta.dart';

class SearchAnnualBaithakVrutta extends StatefulWidget {
  static const routeName = '/search-annual-baithak-vrutta';

  @override
  _SearchAnnualBaithakVruttaState createState() => _SearchAnnualBaithakVruttaState();
}

class _SearchAnnualBaithakVruttaState extends State<SearchAnnualBaithakVrutta> {
  bool _isSearching = false;
  bool _isExpanded = false;

  List<StaticMasterBAL>? _baithakTypes;

  String? _baithakTypeValue = '';
  String? _baithakTypeYear = '';
  int? _baithakType;
  String _selectedNagarAndBaithak = '';

  List<dynamic>? _lstShaakhaaVrutta;
  List<Widget>? _shaakhaaVruttaHeaderRow;
  List<dynamic>? _lstShaakhaaViheen;
  List<Widget>? _shaakhaaViheenHeaderRow;
  List<dynamic>? _lstMukhyaMaarg;
  List<Widget>? _mukhyaMaargHeaderRow;
  List<dynamic>? _lstGraamVikas;
  List<Widget>? _graamVikasHeaderRow;
  AnnualBaithakNagarVruttaBAL? _nagarVrutta;
  List<String> geoUnitNamesList = [];
  List<String> exportList = [];
  List<List<String>> donloadexportList = [];
  int? selectedViewOnly = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
    //populateDropdown();
  }

  Future<void> initData() async {
    final dm = await MyAppGlobals.getLevelLDB();

    final controller = context.read<GeoHierarchyController>();

    await controller.initialize(dm);

    setState(() {});
    await populateDropdown();
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
    print("_baithakTypes :-- ${_baithakTypes}");
    setState(() {
      _isSearching = false;
    });
  }

  Future<dynamic> _getShaakhaaVrutta(String? geoUnitID, String? type, int? baithakTypeID) async {
    bool isConnected = await Statics.isInternetConnected();

    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
        "ShaharID": null,
        "NagarID": geoUnitID,
        "AnnualBaithakTypeID": baithakTypeID,
        "GeoUnitID": geoUnitID,
        "LocId": geoUnitID,
        "type": type,
      });
      dynamic retVal = await Statics.getAnnualBaithakShaakhaaVruttaForApp(strInput);
      return retVal;
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return null;
    }
  }

  Future<dynamic> _getShaakhaaViheen(String? nagarID, int? baithakTypeID) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
        "ShaharID": null,
        "NagarID": int.tryParse(nagarID ?? ""),
        "AnnualBaithakTypeID": baithakTypeID,
        "GeoUnitID": null,
      });
      dynamic retVal = await Statics.getAnnualBaithakShaakhaaViheenForApp(strInput);
      return retVal;
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return null;
    }
  }

  Future<dynamic> _getMukhyaMaarg(String? nagarID, int? baithakTypeID) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
        "ShaharID": null,
        "NagarID": int.tryParse(nagarID ?? ""),
        "AnnualBaithakTypeID": baithakTypeID,
        "GeoUnitID": null,
      });
      dynamic retVal = await Statics.getAnnualBaithakMukhyaMaargForApp(strInput);
      return retVal;
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return null;
    }
  }

  Future<dynamic> _getGraamVikas(String? nagarID, int? baithakTypeID) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
        "ShaharID": null,
        "NagarID": int.tryParse(nagarID ?? ""),
        "AnnualBaithakTypeID": baithakTypeID,
        "GeoUnitID": null,
      });
      dynamic retVal = await Statics.getAnnualBaithakGraamVikasForApp(strInput);
      return retVal;
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return null;
    }
  }

  Future<dynamic> _getNagarVrutta(String? nagarID, int baithakTypeID) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
        "NagarID": int.tryParse(nagarID ?? ""),
        "AnnualBaithakTypeID": baithakTypeID,
      });
      dynamic retVal = await Statics.getAnnualBaithakNagarVruttaForApp(strInput);
      return retVal;
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return null;
    }
  }

  Widget _shaakhaaVruttaFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (_lstShaakhaaVrutta == null || _lstShaakhaaVrutta!.length == 0)
      return SizedBox();
    else {
      AnnualBaithakShaakhaaVruttaBAL shaakhaaVrutta = AnnualBaithakShaakhaaVruttaBAL.fromMap(_lstShaakhaaVrutta![index]);
      geoUnitNamesList.add(shaakhaaVrutta.geoUnitName!);
      return Statics.createWidgetFromString(context, shaakhaaVrutta.geoUnitName!, 100, 52, Alignment.center, isTotalRow: isTotalRow);
    }
  }

  Widget _shaakhaaVruttaOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    AnnualBaithakShaakhaaVruttaBAL shaakhaaVrutta = AnnualBaithakShaakhaaVruttaBAL.fromMap(_lstShaakhaaVrutta![index]);

    String avg = (shaakhaaVrutta.shishuAverage == null ? '0' : shaakhaaVrutta.shishuAverage.toString()) +
        '/' +
        (shaakhaaVrutta.baalAverage == null ? '0' : shaakhaaVrutta.baalAverage.toString()) +
        '/' +
        (shaakhaaVrutta.tarunVidyaarthiAverage == null ? '0' : shaakhaaVrutta.tarunVidyaarthiAverage.toString()) +
        '/' +
        (shaakhaaVrutta.tarunVyavasaayeeAverage == null ? '0' : shaakhaaVrutta.tarunVyavasaayeeAverage.toString()) +
        '/' +
        (shaakhaaVrutta.proudhVyavasaayeeAverage == null ? '0' : shaakhaaVrutta.proudhVyavasaayeeAverage.toString());
    String praathamikCounts = (shaakhaaVrutta.praathamikCount == null ? '0' : shaakhaaVrutta.praathamikCount.toString()) +
        '/' +
        (shaakhaaVrutta.praathamikSakriyaCount == null ? '0' : shaakhaaVrutta.praathamikSakriyaCount.toString());

    var widgetArray = <Widget>[
      Statics.createWidgetFromString(context, shaakhaaVrutta.frequencyCode! + ', ' + shaakhaaVrutta.vayogatCode!, 110, 52, Alignment.centerRight, isTotalRow: isTotalRow),
      Statics.createWidgetFromString(
          context,
          (shaakhaaVrutta.isSadhyaSuruAahe == 0
              ? Statics.getLabel('ConfirmationNo')
              : shaakhaaVrutta.isSadhyaSuruAahe == 1
                  ? Statics.getLabel('ConfirmationYes')
                  : ""),
          110,
          52,
          Alignment.center,
          isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (shaakhaaVrutta.conductingDayCount == null ? '' : shaakhaaVrutta.conductingDayCount.toString()), 100, 52, Alignment.centerRight, isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (shaakhaaVrutta.conductingSewaDayCount == null ? '' : shaakhaaVrutta.conductingSewaDayCount.toString()), 100, 52, Alignment.center,
          isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, avg, 130, 52, Alignment.centerRight, isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (shaakhaaVrutta.vaarshikotsavMonth == null ? '' : shaakhaaVrutta.vaarshikotsavMonth.toString()), 100, 52, Alignment.centerRight, isTotalRow: isTotalRow),
      Statics.createWidgetFromIcon(context, (shaakhaaVrutta.isSewaVastiDefined == false ? null : Icons.check), 60, 52, Alignment.centerRight, isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (shaakhaaVrutta.sewaVastiSamparkCount == null ? '' : shaakhaaVrutta.sewaVastiSamparkCount.toString()), 120, 52, Alignment.centerRight,
          isTotalRow: isTotalRow),
      Statics.createWidgetFromIcon(
          context, (shaakhaaVrutta.isSewaKaaryakartaaDefined == null || shaakhaaVrutta.isSewaKaaryakartaaDefined == false ? null : Icons.check), 100, 52, Alignment.centerRight,
          isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (shaakhaaVrutta.sewaUpakramCount == null ? '' : shaakhaaVrutta.sewaUpakramCount.toString()), 100, 52, Alignment.centerRight, isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (shaakhaaVrutta.anyaUpakramCount == null ? '' : shaakhaaVrutta.anyaUpakramCount.toString()), 100, 52, Alignment.centerRight, isTotalRow: isTotalRow),
      Statics.createWidgetFromIcon(context, (shaakhaaVrutta.isShaakhaaToli == null || shaakhaaVrutta.isShaakhaaToli == false ? null : Icons.check), 100, 52, Alignment.centerRight,
          isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (shaakhaaVrutta.shaakhaaToliBaithakCount == null ? '' : shaakhaaVrutta.shaakhaaToliBaithakCount.toString()), 60, 52, Alignment.centerRight,
          isTotalRow: isTotalRow),
      Statics.createWidgetFromIcon(context, (shaakhaaVrutta.isShaakhaaPaalak == null || shaakhaaVrutta.isShaakhaaPaalak == false ? null : Icons.check), 60, 52, Alignment.centerRight,
          isTotalRow: isTotalRow),
    ];
    widgetArray.add(Container(
      width: 70,
      child: IconButton(
          icon: Icon(Icons.edit),
          iconSize: 20,
          color: Colors.purple,
          onPressed: () {
            _onEditShaakhaaVrutta(
              shaakhaaVrutta.annualBaithakShaakhaaVruttaID,
              shaakhaaVrutta.geoUnitID,
              shaakhaaVrutta.geoUnitName!,
              shaakhaaVrutta.annualBaithakTypeID,
              shaakhaaVrutta.annualBaithakTypeCode,
              shaakhaaVrutta.viewOnly,
            );
            print(
                " shaakhaaVrutta.annualBaithakShaakhaaVruttaID ==> ${shaakhaaVrutta.annualBaithakShaakhaaVruttaID},\n shaakhaaVrutta.geoUnitID ==> ${shaakhaaVrutta.geoUnitID},\n shaakhaaVrutta.geoUnitName! ==> ${shaakhaaVrutta.geoUnitName!},\n shaakhaaVrutta.annualBaithakTypeID ==> ${shaakhaaVrutta.annualBaithakTypeID},\n shaakhaaVrutta.annualBaithakTypeCode ==> ${shaakhaaVrutta.annualBaithakTypeCode}");
          }),
    ));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgetArray.map((widget) => Expanded(child: widget)).toList(),
    );
  }

  Future<void> exportListToCsv() async {
    print("exportListToCsvexportListToCsvexportListToCsvexportListToCsv");
    String vaarshikotsavMonthLabel, sewaVastiSamparkCountLabel, sewaUpakramCountLabel, anyaUpakramCountLabel;
    if (_baithakType == Statics.abPratinidhiSabhaa) {
      vaarshikotsavMonthLabel = Statics.getLabel('vaarshikotsavMonth');
      sewaVastiSamparkCountLabel = Statics.getLabel('sewaVastiSamparkCount');
      sewaUpakramCountLabel = Statics.getLabel('sewaUpakramCount');
      anyaUpakramCountLabel = Statics.getLabel('anyaUpakramCount');
    } else if (_baithakType == Statics.praantikBaithak1) {
      vaarshikotsavMonthLabel = Statics.getLabel('vaarshikotsavMonthFebMar');
      sewaVastiSamparkCountLabel = Statics.getLabel('sewaVastiSamparkCountFebMar');
      sewaUpakramCountLabel = Statics.getLabel('sewaUpakramCountFebMar');
      anyaUpakramCountLabel = Statics.getLabel('anyaUpakramCountFebMar');
    } else {
      vaarshikotsavMonthLabel = Statics.getLabel('vaarshikotsavMonthMarJun');
      sewaVastiSamparkCountLabel = Statics.getLabel('sewaVastiSamparkCount');
      sewaUpakramCountLabel = Statics.getLabel('sewaUpakramCountMarJun');
      anyaUpakramCountLabel = Statics.getLabel('anyaUpakramCountMarJun');
    }
    List<String> header = [
      Statics.getLabel('Shaakhaa/Saaptaahik/Maasik/Mandali'),
      Statics.getLabel('FrequencyCode') + '/' + Statics.getLabel('VayogatCode'),
      Statics.getLabel('conductingDayCount'),
      Statics.getLabel('conductingSewaDayCount'),
      Statics.getLabel('averageSankhyaa'),
      vaarshikotsavMonthLabel,
      Statics.getLabel('isSewaVastiDefined'),
      sewaVastiSamparkCountLabel,
      Statics.getLabel('isSewaKaaryakartaaDefined'),
      sewaUpakramCountLabel,
      anyaUpakramCountLabel,
      Statics.getLabel('HasToli'),
      Statics.getLabel('ToliBaithakMeet'),
      Statics.getLabel('HasPaalak'),
      Statics.getLabel('Currentlyrunning'),
      Statics.getLabel("Praant"),
      Statics.getLabel("mahaanagar"),
      Statics.getLabel("vibhaag"),
      Statics.getLabel("Bhaag"),
      Statics.getLabel("Nagar"),
      Statics.getLabel("Mandal"),
      Statics.getLabel("Graam"),
      Statics.getLabel("Vasti"),
    ];

    List<List<String>> csvData = [header] + donloadexportList;
    print("CSVDATA :-- $csvData");

    Statics.convertToCsv(csvData, "AnnualBaithakVrutta" + "_" + DateFormat('ddmmyyyyHHmmss').format(DateTime.now()), context);

    donloadexportList = [];
  }

  Widget _mukhyaMaargFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (_lstMukhyaMaarg == null || _lstMukhyaMaarg!.length == 0)
      return SizedBox();
    else {
      AnnualBaithakMukhyaMaargBAL mukhyaMaarg = AnnualBaithakMukhyaMaargBAL.fromMap(_lstMukhyaMaarg![index]);
      return Statics.createWidgetFromString(context, mukhyaMaarg.geoUnitName!, 100, 52, Alignment.center, isTotalRow: isTotalRow);
    }
  }

  Widget _mukhyaMaargOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    AnnualBaithakMukhyaMaargBAL mukhyaMaarg = AnnualBaithakMukhyaMaargBAL.fromMap(_lstMukhyaMaarg![index]);
    var widgetArray = <Widget>[
      Statics.createWidgetFromString(context, (mukhyaMaarg.mukhyaMaargName == null ? '' : mukhyaMaarg.mukhyaMaargName!), 100, 52, Alignment.center, isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (mukhyaMaarg.shaakhaaCount == null ? '' : mukhyaMaarg.shaakhaaCount.toString()), 60, 52, Alignment.center, isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (mukhyaMaarg.saaptaahikCount == null ? '' : mukhyaMaarg.saaptaahikCount.toString()), 60, 52, Alignment.center, isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (mukhyaMaarg.maasikCount == null ? '' : mukhyaMaarg.maasikCount.toString()), 60, 52, Alignment.center, isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, mukhyaMaarg.graamPramukhName!, 100, 52, Alignment.center, isTotalRow: isTotalRow),
    ];
    widgetArray.add(Container(
        width: 70,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              iconSize: 20,
              color: Colors.purple,
              onPressed: () => _onEditMukhyaMaarg(
                mukhyaMaarg.annualBaithakMukhyaMaargVruttaID,
                mukhyaMaarg.geoUnitID,
                mukhyaMaarg.geoUnitName,
                mukhyaMaarg.annualBaithakTypeID,
                mukhyaMaarg.annualBaithakTypeCode,
              ),
            ),
          ],
        )));

    return Row(children: widgetArray);
  }

  Widget _graamVikasFirstColumn(BuildContext context, int index) {
    bool isTotalRow = false;
    if (_lstGraamVikas == null || _lstGraamVikas!.length == 0)
      return SizedBox();
    else {
      AnnualBaithakGraamVikasBAL graamVikas = AnnualBaithakGraamVikasBAL.fromMap(_lstGraamVikas![index]);
      return Statics.createWidgetFromString(context, graamVikas.geoUnitName!, 150, 52, Alignment.center, isTotalRow: isTotalRow);
    }
  }

  Widget _graamVikasOtherColumns(BuildContext context, int index) {
    bool isTotalRow = false;
    AnnualBaithakGraamVikasBAL graamVikas = AnnualBaithakGraamVikasBAL.fromMap(_lstGraamVikas![index]);
    var widgetArray = <Widget>[
      Statics.createWidgetFromIcon(context, (graamVikas.isUdayGraam == null || graamVikas.isUdayGraam == false ? null : Icons.check), 60, 52, Alignment.center, isTotalRow: isTotalRow),
      Statics.createWidgetFromIcon(context, (graamVikas.isPrabhaatGraam == null || graamVikas.isPrabhaatGraam == false ? null : Icons.check), 80, 52, Alignment.center, isTotalRow: isTotalRow),
    ];
    widgetArray.add(Container(
        width: 70,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              iconSize: 20,
              color: Colors.purple,
              onPressed: () => _onEditGraamVikas(
                graamVikas.annualBaithakGraamVikasVruttaID,
                graamVikas.geoUnitID,
                graamVikas.geoUnitName,
                graamVikas.annualBaithakTypeID,
                graamVikas.annualBaithakTypeCode,
              ),
            ),
          ],
        )));

    return Row(
      children: widgetArray,
    );
  }

  void _onEditShaakhaaVrutta(int? abShaakhaaVruttaID, int? geoUnitID, String? geoUnitName, int? abTypeID, String? abTypeCode, int? viewOnly) async {
    print("acacasc ascasca ssc asc asc ascasca cas casc $viewOnly");
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditAnnualBaithakShaakhaaVrutta(
                  annualBaithakShaakhaaVruttaID: abShaakhaaVruttaID,
                  geoUnitID: geoUnitID,
                  geoUnitName: geoUnitName,
                  annualBaithakTypeID: abTypeID,
                  annualBaithakTypeCode: abTypeCode,
                  onSaveDetails: _search,
                  viewType: (viewOnly == 0 ? "EditVrutta" : "ViewOnly"),
                )));
    print(
        "annualBaithakShaakhaaVruttaID ==> ${abShaakhaaVruttaID},\n geoUnitID ==> ${geoUnitID},\n geoUnitName! ==> ${geoUnitName!},\n annualBaithakTypeID ==> ${abTypeID},\n annualBaithakTypeCode ==> ${abTypeCode}\n selectedViewOnly ==> ${selectedViewOnly}");
  }

  void _onEditMukhyaMaarg(int? abMukhyaMaargVruttaID, int? geoUnitID, String? geoUnitName, int? abTypeID, String? abTypeCode) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditAnnualBaithakMukhyaMaargVrutta(
                  annualBaithakMukhyaMaargVruttaID: abMukhyaMaargVruttaID,
                  geoUnitID: geoUnitID,
                  geoUnitName: geoUnitName,
                  annualBaithakTypeID: abTypeID,
                  annualBaithakTypeCode: abTypeCode,
                  onSaveDetails: _search,
                  viewType: (selectedViewOnly == 0 ? "EditVrutta" : "ViewOnly"),
                )));
  }

  void _onEditGraamVikas(int? abGraamVikasVruttaID, int? geoUnitID, String? geoUnitName, int? abTypeID, String? abTypeCode) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditAnnualBaithakGraamVikasVrutta(
                  annualBaithakGraamVikasVruttaID: abGraamVikasVruttaID,
                  geoUnitID: geoUnitID,
                  geoUnitName: geoUnitName,
                  annualBaithakTypeID: abTypeID,
                  annualBaithakTypeCode: abTypeCode,
                  onSaveDetails: _search,
                  viewType: (selectedViewOnly == 0 ? "EditVrutta" : "ViewOnly"),
                )));
  }

  Future<void> _search() async {
    final ctrl = context.read<GeoHierarchyController>();
    print("searching");
    setState(() {
      _isSearching = true;
      _isExpanded = false;
    });
    _baithakType = _baithakTypeValue == null || _baithakTypeValue == "" ? null : int.parse(_baithakTypeValue!);

    if (ctrl.deepestSelectedGeoUnitId != null) {
      List<Widget>? shaakhaaVruttaHeaderRow = [];
      List<Widget>? shaakhaaViheenHeaderRow = [];
      List<Widget>? mukhyaMaargHeaderRow = [];
      List<Widget>? graamVikasHeaderRow = [];

      dynamic nagarVrutta;
      if (_baithakType != null) {
        String vaarshikotsavMonthLabel, sewaVastiSamparkCountLabel, sewaUpakramCountLabel, anyaUpakramCountLabel;
        if (_baithakType == Statics.abPratinidhiSabhaa) {
          vaarshikotsavMonthLabel = Statics.getLabel('vaarshikotsavMonth');
          sewaVastiSamparkCountLabel = Statics.getLabel('sewaVastiSamparkCount');
          sewaUpakramCountLabel = Statics.getLabel('sewaUpakramCount');
          anyaUpakramCountLabel = Statics.getLabel('anyaUpakramCount');
        } else if (_baithakType == Statics.praantikBaithak1) {
          vaarshikotsavMonthLabel = Statics.getLabel('vaarshikotsavMonthFebMar');
          sewaVastiSamparkCountLabel = Statics.getLabel('sewaVastiSamparkCountFebMar');
          sewaUpakramCountLabel = Statics.getLabel('sewaUpakramCountFebMar');
          anyaUpakramCountLabel = Statics.getLabel('anyaUpakramCountFebMar');
        } else {
          vaarshikotsavMonthLabel = Statics.getLabel('vaarshikotsavMonthMarJun');
          sewaVastiSamparkCountLabel = Statics.getLabel('sewaVastiSamparkCount');
          sewaUpakramCountLabel = Statics.getLabel('sewaUpakramCountMarJun');
          anyaUpakramCountLabel = Statics.getLabel('anyaUpakramCountMarJun');
        }
        nagarVrutta = await _getNagarVrutta(ctrl.deepestSelectedGeoUnitId, _baithakType!);

        ///
        _lstShaakhaaVrutta = await _getShaakhaaVrutta(ctrl.deepestSelectedGeoUnitId, ctrl.deepestSelectedLevelName, _baithakType);

        ///

        print("_lstShaakhaaVrutta!.length  ===> ${_lstShaakhaaVrutta!.length}");
        if (_lstShaakhaaVrutta != null && _lstShaakhaaVrutta!.length > 0) {
          log("_lstShaakhaaVrutta === > $_lstShaakhaaVrutta");
          double rowHeight = 115;
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Shaakhaa/Saaptaahik/Maasik/Mandali'), 100, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow
              .add(Statics.createWidgetFromString(context, Statics.getLabel('FrequencyCode') + '/' + Statics.getLabel('VayogatCode'), 110, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Currentlyrunning'), 110, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('conductingDayCount'), 110, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('conductingSewaDayCount'), 110, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('averageSankhyaa'), 130, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, vaarshikotsavMonthLabel, 100, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('isSewaVastiDefined'), 60, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, sewaVastiSamparkCountLabel, 120, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('isSewaKaaryakartaaDefined'), 100, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, sewaUpakramCountLabel, 100, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, anyaUpakramCountLabel, 100, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('HasToli'), 100, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('ToliBaithakMeet'), 60, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('HasPaalak'), 60, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Edit'), 70, rowHeight, Alignment.center, isTotalRow: false));
        } else {
          shaakhaaVruttaHeaderRow = null;
        }

        ///
        _lstShaakhaaViheen = await _getShaakhaaViheen(ctrl.deepestSelectedGeoUnitId, _baithakType);

        ///
        if (_lstShaakhaaViheen != null && _lstShaakhaaViheen!.length > 0) {
          double rowHeight = 100;
          shaakhaaViheenHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('vastiGraamName'), 100, rowHeight, Alignment.center, isTotalRow: false));
          if (_baithakType == Statics.abPratinidhiSabhaa)
            shaakhaaViheenHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('isShaakhaaInPast'), 100, rowHeight, Alignment.center, isTotalRow: false));
          shaakhaaViheenHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('praathamikShikshaarthiSakriya'), 100, rowHeight, Alignment.center, isTotalRow: false));
          shaakhaaViheenHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Edit'), 70, rowHeight, Alignment.center, isTotalRow: false));
        } else {
          shaakhaaViheenHeaderRow = null;
        }

        ///
        _lstMukhyaMaarg = await _getMukhyaMaarg(ctrl.deepestSelectedGeoUnitId, _baithakType);

        ///
        if (_lstMukhyaMaarg != null && _lstMukhyaMaarg!.length > 0) {
          mukhyaMaargHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Graam'), 100, 56, Alignment.center, isTotalRow: false));
          mukhyaMaargHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('mukhyaMaargName'), 100, 56, Alignment.center, isTotalRow: false));
          mukhyaMaargHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('shaakhaaCount'), 60, 56, Alignment.center, isTotalRow: false));
          mukhyaMaargHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('saaptaahikCount'), 60, 56, Alignment.center, isTotalRow: false));
          mukhyaMaargHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('mandaliCount'), 60, 56, Alignment.center, isTotalRow: false));
          mukhyaMaargHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('graamPramukhName'), 100, 56, Alignment.center, isTotalRow: false));
          mukhyaMaargHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Edit'), 70, 56, Alignment.center, isTotalRow: false));
        } else {
          mukhyaMaargHeaderRow = null;
        }

        ///
        _lstGraamVikas = await _getGraamVikas(ctrl.deepestSelectedGeoUnitId, _baithakType);

        ///
        if (_lstGraamVikas != null && _lstGraamVikas!.length > 0) {
          graamVikasHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Graam'), 150, 56, Alignment.center, isTotalRow: false));
          graamVikasHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('isUdayGraam'), 60, 56, Alignment.center, isTotalRow: false));
          graamVikasHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('isPrabhaatGraam'), 80, 56, Alignment.center, isTotalRow: false));
          graamVikasHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Edit'), 70, 56, Alignment.center, isTotalRow: false));
        } else {
          graamVikasHeaderRow = null;
        }
      }
      donloadexportList = [];

      setState(() {
        if (_baithakType == null) {
          _shaakhaaVruttaHeaderRow = null;
          _shaakhaaViheenHeaderRow = null;
          _mukhyaMaargHeaderRow = null;
          _graamVikasHeaderRow = null;
          _nagarVrutta = null;
          _selectedNagarAndBaithak = '';
        } else {
          _shaakhaaVruttaHeaderRow = shaakhaaVruttaHeaderRow;
          _shaakhaaViheenHeaderRow = shaakhaaViheenHeaderRow;
          _mukhyaMaargHeaderRow = mukhyaMaargHeaderRow;
          _graamVikasHeaderRow = graamVikasHeaderRow;
          _nagarVrutta = AnnualBaithakNagarVruttaBAL.fromMap(nagarVrutta);

          final trail = ctrl.hierarchyNameTrail;
          _selectedNagarAndBaithak = _baithakTypes!.firstWhere((element) => element.staticID == _baithakType).codeForDisplay! +
              ' | ' +
              (trail.vibhaagName ?? "--") +
              ' | ' +
              (trail.bhaagName ?? "--") +
              ' | ' +
              (trail.nagarName ?? "--") +
              ' | ' +
              (trail.upnagarName ?? "--") +
              ' | ';
        }
        _isSearching = false;
      });

      for (var e in _lstShaakhaaVrutta!) {
        var data = AnnualBaithakShaakhaaVruttaBAL.fromMap(e);
        var exportList = [
          "${data.geoUnitName!}",
          "${data.frequencyCode! + ', ' + data.vayogatCode!}",
          "${data.conductingDayCount?.toString() ?? ''}",
          "${data.conductingSewaDayCount?.toString() ?? ''}",
          "${(data.shishuAverage == null ? '0' : data.shishuAverage.toString()) + '/' + (data.baalAverage == null ? '0' : data.baalAverage.toString()) + '/' + (data.tarunVidyaarthiAverage == null ? '0' : data.tarunVidyaarthiAverage.toString()) + '/' + (data.tarunVyavasaayeeAverage == null ? '0' : data.tarunVyavasaayeeAverage.toString()) + '/' + (data.proudhVyavasaayeeAverage == null ? '0' : data.proudhVyavasaayeeAverage.toString())}",
          "${data.vaarshikotsavMonth?.toString() ?? ''}",
          "${(data.isSewaVastiDefined == false ? Statics.getLabel('ConfirmationNo') : data.isSewaVastiDefined == true ? Statics.getLabel('ConfirmationYes') : "")}",
          "${data.sewaVastiSamparkCount == null ? "" : data.sewaVastiSamparkCount}",
          "${(data.isSewaKaaryakartaaDefined == false ? Statics.getLabel('ConfirmationNo') : data.isSewaKaaryakartaaDefined == true ? Statics.getLabel('ConfirmationYes') : "")}",
          "${data.sewaUpakramCount == null ? "" : data.sewaUpakramCount}",
          "${data.anyaUpakramCount == null ? "" : data.anyaUpakramCount}",
          "${(data.isShaakhaaToli == false ? Statics.getLabel('ConfirmationNo') : data.isShaakhaaToli == true ? Statics.getLabel('ConfirmationYes') : "")}",
          "${(data.shaakhaaToliBaithakCount == 0 ? Statics.getLabel('ConfirmationNo') : data.shaakhaaToliBaithakCount == 1 ? Statics.getLabel('ConfirmationYes') : "")}",
          "${(data.isShaakhaaPaalak == false ? Statics.getLabel('ConfirmationNo') : data.isShaakhaaPaalak == true ? Statics.getLabel('ConfirmationYes') : "")}",
          "${(data.isSadhyaSuruAahe == 0 ? Statics.getLabel('ConfirmationNo') : data.isSadhyaSuruAahe == 1 ? Statics.getLabel('ConfirmationYes') : "")}",
          "${data.prantName}",
          "${data.mahaanagarName}",
          "${data.vibhaagName}",
          "${data.bhaagName}",
          "${data.nagarName}",
          "${data.mandalName}",
          "${data.graamName}",
          "${data.vastiName}",
        ];
        donloadexportList.add(exportList);
      }
    } else {
      setState(() {
        _isSearching = false;
      });
      Statics.showMessageDialog(context, Statics.getLabel('selectedBhougolikkaryastithi'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: donloadexportList != []
          ? FloatingActionButton(
              mini: true,
              tooltip: Statics.getLabel("ExportToExcel"),
              onPressed: () async {
                exportListToCsv();
              },
              child: Icon(Icons.download_sharp),
              backgroundColor: Colors.green,
            )
          : Container(),
      appBar: AppBar(
        title: Text(
          Statics.getLabel('annualBaithakVruttaTitle'),
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => NirikshanAnnualBaithakVrutta()));
              },
              icon: Icon(Icons.search))
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(20),
        width: Statics.getDeviceSize(context).width,
        child: Column(
          children: <Widget>[
            Text(
              Statics.getLabel('searchAnnualBaithakVruttaBanner'),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            nagarUpnagarDropdown(),
            Text(_selectedNagarAndBaithak!, style: TextStyle(fontSize: 18)),
            Legend(legendString: "shaakhaaVrutta", fontsize: 18),
            (_isSearching)
                ? CircularProgressIndicator()
                : Container(
                    height: Statics.getDeviceSize(context).height * (_shaakhaaVruttaHeaderRow != null ? 0.40 : 0.07),
                    width: Statics.getDeviceSize(context).width,
                    child: _shaakhaaVruttaHeaderRow != null && _lstShaakhaaVrutta != null && _lstShaakhaaVrutta!.length > 0
                        ? HorizontalDataTable(
                            leftHandSideColumnWidth: 100,
                            rightHandSideColumnWidth: 1500,
                            isFixedHeader: true,
                            headerWidgets: _shaakhaaVruttaHeaderRow,
                            leftSideItemBuilder: _shaakhaaVruttaFirstColumn,
                            rightSideItemBuilder: _shaakhaaVruttaOtherColumns,
                            itemCount: _lstShaakhaaVrutta?.length ?? 0,
                            rowSeparatorWidget: const Divider(
                              color: Colors.black54,
                              height: 1.0,
                              thickness: 1.0,
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
              height: 30,
            ),
            if (_baithakType == Statics.abPratinidhiSabhaa && _lstMukhyaMaarg != null && _lstMukhyaMaarg!.length > 0)
              Column(
                children: <Widget>[
                  Legend(legendString: "mukhyaMaargVrutta", fontsize: 18),
                  Container(
                    height: Statics.getDeviceSize(context).height * (_mukhyaMaargHeaderRow != null ? 0.40 : 0.07),
                    width: Statics.getDeviceSize(context).width,
                    child: _mukhyaMaargHeaderRow != null && _lstMukhyaMaarg != null && _lstMukhyaMaarg!.length > 0
                        ? HorizontalDataTable(
                            leftHandSideColumnWidth: 100,
                            rightHandSideColumnWidth: 450,
                            isFixedHeader: true,
                            headerWidgets: _mukhyaMaargHeaderRow,
                            leftSideItemBuilder: _mukhyaMaargFirstColumn,
                            rightSideItemBuilder: _mukhyaMaargOtherColumns,
                            itemCount: (_lstMukhyaMaarg == null ? 0 : _lstMukhyaMaarg!.length),
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
                    height: 30,
                  ),
                ],
              ),
            if (_baithakType == Statics.abPratinidhiSabhaa && _lstGraamVikas != null && _lstGraamVikas!.length > 0)
              Column(
                children: <Widget>[
                  Legend(legendString: "graamVikasVrutta", fontsize: 18),
                  Container(
                    height: Statics.getDeviceSize(context).height * (_graamVikasHeaderRow != null ? 0.40 : 0.07),
                    width: Statics.getDeviceSize(context).width,
                    child: _graamVikasHeaderRow != null && _lstGraamVikas != null && _lstGraamVikas!.length > 0
                        ? HorizontalDataTable(
                            leftHandSideColumnWidth: 150,
                            rightHandSideColumnWidth: 210,
                            isFixedHeader: true,
                            headerWidgets: _graamVikasHeaderRow,
                            leftSideItemBuilder: _graamVikasFirstColumn,
                            rightSideItemBuilder: _graamVikasOtherColumns,
                            itemCount: (_lstGraamVikas == null ? 0 : _lstGraamVikas!.length),
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
                    height: 30,
                  ),
                ],
              ),
          ],
        ),
      )),
    );
  }

  Widget nagarUpnagarDropdown() {
    return Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
      return Column(
        children: [
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _isExpanded = isExpanded;
              });
            },
            children: [
              ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text(Statics.getLabel('Filters')),
                  );
                },
                body: Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    spacing: 10,
                    children: [
                      GeoDropdownWidget(
                        level: GeoLevel.Mahaanagar,
                        title: 'Mahaanagar',
                        controller: ctrl,
                      ),

                      // if (ctrl.hasItems(GeoLevel.vibhaag))
                      GeoDropdownWidget(
                        level: GeoLevel.Vibhaag,
                        title: 'Vibhaag',
                        controller: ctrl,
                      ),

                      if (ctrl.hasItems(GeoLevel.Bhaag))
                        GeoDropdownWidget(
                          level: GeoLevel.Bhaag,
                          title: 'Bhaag',
                          controller: ctrl,
                        ),

                      if (ctrl.hasItems(GeoLevel.Nagar))
                        GeoDropdownWidget(
                          level: GeoLevel.Nagar,
                          title: 'Nagar',
                          controller: ctrl,
                        ),

                      /// CONDITIONAL

                      if (ctrl.hasItems(GeoLevel.upnagarUpkhanda))
                        GeoDropdownWidget(
                          level: GeoLevel.upnagarUpkhanda,
                          title: 'upnagarUpkhanda',
                          controller: ctrl,
                        ),
                      SizedBox(height: 12),
                      if (_baithakTypes != null)
                        // DropdownSearch<String>(
                        //   popupProps: PopupProps.bottomSheet(
                        //     showSearchBox: true,
                        //     fit: FlexFit.tight,
                        //     itemBuilder: (context, item, isSelected) {
                        //       return Container(
                        //         margin: EdgeInsets.symmetric(horizontal: 8),
                        //         decoration: !isSelected
                        //             ? null
                        //             : BoxDecoration(
                        //           border: Border.all(color: Theme.of(context).primaryColor),
                        //           borderRadius: BorderRadius.circular(5),
                        //           color: Colors.grey[300],
                        //         ),
                        //         child: ListTile(
                        //           title: Text(
                        //             item,
                        //             style: TextStyle(fontSize: 14), ),
                        //           contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8), visualDensity: VisualDensity(vertical: -4),),
                        //       );
                        //     },
                        //     searchFieldProps: TextFieldProps(
                        //       decoration: InputDecoration(
                        //         border: OutlineInputBorder(),
                        //         contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        //       ),
                        //     ),
                        //     constraints: BoxConstraints.tightFor(
                        //       width: double.infinity,   ),
                        //     containerBuilder: (context, popupWidget) {
                        //       return Stack(
                        //         children: [
                        //           popupWidget,
                        //           Positioned(
                        //             right: 10,
                        //             top: 10,
                        //             child: IconButton(
                        //               icon: Icon(Icons.close),
                        //               onPressed: () {
                        //                 Navigator.of(context).pop();
                        //               },
                        //             ),
                        //           ),
                        //         ],
                        //       );
                        //     },
                        //   ),
                        //   items: _baithakTypes!.map((bg) => bg.codeForDisplay!).toList(),
                        //   dropdownDecoratorProps: DropDownDecoratorProps(
                        //     dropdownSearchDecoration: InputDecoration(
                        //       labelText: Statics.getLabel('selectbaithakTypeLabel'),
                        //     ),
                        //   ),
                        //   selectedItem: _baithakTypeValue == "" ? null : _baithakTypes?.firstWhere((element) => element.staticID.toString() == _baithakTypeValue).codeForDisplay,
                        //   onChanged: (value) {
                        //     print(value);
                        //     setState(() {
                        //       selectedViewOnly = _baithakTypes?.firstWhere((element) => element.codeForDisplay == value).ViewOnly;
                        //       _baithakTypeValue = _baithakTypes?.firstWhere((element) => element.codeForDisplay == value).staticID.toString();
                        //     });
                        //     print(selectedViewOnly);
                        //   },
                        // ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(labelText: Statics.getLabel('SankalpCompletionYear')),
                          isExpanded: true,
                          value: _baithakTypeYear == "" ? null : _baithakTypeYear,
                          items: _baithakTypes
                              ?.map((bg) => bg.monthYear.toString().split(',').last)
                              .toSet()
                              .map((year) => DropdownMenuItem(
                                    value: year,
                                    child: Text(year),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            print("Year ---==>  $value");
                            setState(() {
                              _baithakTypeYear = value;
                              _baithakTypeValue = null;
                            });
                          },
                        ),
                      if (_baithakTypes != null)
                        DropdownButtonFormField(
                          decoration: InputDecoration(labelText: Statics.getLabel('baithakType')),
                          isExpanded: true,
                          value: _baithakTypeValue == "" ? null : _baithakTypeValue,
                          items: _baithakTypes!
                              .where((bg) => bg.monthYear.toString().split(',').last == _baithakTypeYear)
                              .map((bg) => DropdownMenuItem(
                                    value: bg.staticID.toString(),
                                    child: Text(bg.codeForDisplay!),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _baithakTypeValue = value;
                              print("value --> $value");
                              print("_baithakTypes -->  ${_baithakTypes!.map((e) => e.ViewOnly)}");
                              try {
                                final matchedItem = _baithakTypes!.firstWhere(
                                  (e) => e.staticID.toString() == value.toString(),
                                );
                                selectedViewOnly = matchedItem.ViewOnly;
                                print("selectedViewOnly --> $selectedViewOnly");
                              } catch (e) {
                                print("No match found for staticID: $value");
                                selectedViewOnly = null;
                              }
                            });
                          },
                        ),
                    ],
                  ),
                ),
                isExpanded: _isExpanded,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                Wrap(
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                      onPressed: () {
                        print("_baithakTypeValue ==> $_baithakTypeValue");
                        if (_baithakTypeValue != '') {
                          _search();
                        } else {
                          Statics.showMessageDialog(context, Statics.getLabel('baithakTypeNotSelected'));
                        }
                      },
                      child: Text(
                        Statics.getLabel('Search'),
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                        onPressed: () {
                          setState(() {
                            _baithakType = null;
                            _baithakTypeYear = _baithakTypeValue = _selectedNagarAndBaithak = '';
                            _isSearching = false;
                            exportList.clear();
                            donloadexportList.clear();
                            _lstShaakhaaVrutta = null;
                            _lstMukhyaMaarg = null;
                            _lstGraamVikas = null;
                          });
                          populateDropdown();
                          ctrl.loadHierarchyForUser();
                        },
                        child: Text(Statics.getLabel('clear'))),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
