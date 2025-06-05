import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../helpers/static_data.dart' as Statics;
import '../widgets/app_drawer.dart';
import '../widgets/legend.dart';
import '../widgets/single_column_row.dart';

import './edit_annual_baithak_shaakhaa_vrutta.dart';
import './edit_annual_baithak_shaakhaa_viheen_vrutta.dart';
import './edit_annual_baithak_mukhya_maarg_vrutta.dart';
import './edit_annual_baithak_graam_vikas_vrutta.dart';
import './edit_annual_baithak_nagar_vrutta.dart';
import '../providers/bals.dart';
import 'nirikshan_baithak_vrutta.dart';

class SearchAnnualBaithakVrutta extends StatefulWidget {
  static const routeName = '/search-annual-baithak-vrutta';

  @override
  _SearchAnnualBaithakVruttaState createState() => _SearchAnnualBaithakVruttaState();
}

class _SearchAnnualBaithakVruttaState extends State<SearchAnnualBaithakVrutta> {

  bool _isSearching = false;
  bool _isExpanded = false;
  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedBhaag;
  List<GeoUnitMasterBAL>? _linkedShahar;
  List<GeoUnitMasterBAL>? _linkedNagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<StaticMasterBAL>? _baithakTypes;
  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedBhaagValue = '';
  String? _linkedShaharValue = '';
  String? _linkedNagarValue = '';
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";
  String? _baithakTypeValue = '';
  String? _baithakTypeYear = '';
  int? _baithakType;
  String _selectedNagarAndBaithak = '';
  String? mahanagarId = '';
  String? vibhagId = '';
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
    populateDropdown();
  }
  void populateDropdown() async {
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    populatelinkedMahaanagarDropdown();
    populatelinkedVibhaagDropdown('');
    if (!mounted) return;
      _baithakTypes = data;
      _baithakTypes = _baithakTypes!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
      print("_baithakTypes :-- ${_baithakTypes}");
    setState(() {});
  }
  Future<List<GeoUnitMasterBAL>>  populatelinkedMahaanagarDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }
  Future<List<GeoUnitMasterBAL>>  populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedShaharValue = _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
    return data;
  }
  Future<List<GeoUnitMasterBAL>>  populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }
  Future<List<GeoUnitMasterBAL>>  populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedShaharValue = _linkedShahar = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _linkedShahar = (shDD.length > 0 ? shDD : null);
    });
    return shDD;

  }
  Future<List<GeoUnitMasterBAL>>  populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkedNagarValue = null;
    _linkedNagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;

    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;

    }

  }
  Future<List<GeoUnitMasterBAL>>  populatelinkedMandalDropdown(String nagarIDStr) async {
    _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }
  Future<List<GeoUnitMasterBAL>>  populatelinkedGraamDropdown(String mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }
  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
    return vsDD;
  }
  Future<dynamic> _getShaakhaaVrutta(int? mahanagarId,int? vibhagId,int? bhagId,int? shaharID, int? nagarID, int? baithakTypeID, int? geoID) async {
    bool isConnected = await Statics.isInternetConnected();
    String type = "";
    String locId = "";
    if(_linkedMahaanagarValue != null &&_linkedVibhaagValue == null &&_linkedBhaagValue == null && _linkedNagarValue == null){
      type = "Mahaanagar";
      locId = mahanagarId.toString();
    }else if(_linkedVibhaagValue != null &&_linkedBhaagValue == null && _linkedNagarValue == null){
    type = "Vibhaag";
    locId = vibhagId.toString();
    }else if(_linkedBhaagValue != null && _linkedNagarValue == null){
       type = "Bhaag";
       locId = bhagId.toString();

    }else if(_linkedBhaagValue != null && _linkedNagarValue != null){
      type = "Nagar";
      locId = nagarID.toString();
    }

    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
        "ShaharID": shaharID,
        "NagarID": nagarID,
        "AnnualBaithakTypeID": baithakTypeID,
        "GeoUnitID": geoID,
        "LocId": locId == '' ? null :locId ,
        "type":type,
      });
      dynamic retVal = await Statics.getAnnualBaithakShaakhaaVruttaForApp(strInput);
      return retVal;
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return null;
    }
  }
  Future<dynamic> _getShaakhaaViheen(int? shaharID, int? nagarID, int? baithakTypeID) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
        "ShaharID": shaharID,
        "NagarID": nagarID,
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
  Future<dynamic> _getMukhyaMaarg(int? shaharID, int? nagarID, int? baithakTypeID) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
        "ShaharID": shaharID,
        "NagarID": nagarID,
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
  Future<dynamic> _getGraamVikas(int? shaharID, int? nagarID, int? baithakTypeID) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
        "ShaharID": shaharID,
        "NagarID": nagarID,
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
  Future<dynamic> _getNagarVrutta(int? nagarID, int baithakTypeID) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
        "NagarID": nagarID,
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

    String avg =
        (shaakhaaVrutta.shishuAverage == null ? '0' : shaakhaaVrutta.shishuAverage.toString()) +
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
      Statics.createWidgetFromString(context, shaakhaaVrutta.frequencyCode! + ', ' + shaakhaaVrutta.vayogatCode!, 110, 52, Alignment.centerRight,isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (shaakhaaVrutta.isSadhyaSuruAahe == 0 ? Statics.getLabel('ConfirmationNo') : shaakhaaVrutta.isSadhyaSuruAahe == 1 ? Statics.getLabel('ConfirmationYes'):""), 110, 52, Alignment.center,isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (shaakhaaVrutta.conductingDayCount == null ? '' : shaakhaaVrutta.conductingDayCount.toString()), 100, 52, Alignment.centerRight,isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (shaakhaaVrutta.conductingSewaDayCount == null ? '' : shaakhaaVrutta.conductingSewaDayCount.toString()), 100, 52, Alignment.center,isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, avg, 130, 52, Alignment.centerRight, isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (shaakhaaVrutta.vaarshikotsavMonth == null ? '' : shaakhaaVrutta.vaarshikotsavMonth.toString()), 100, 52, Alignment.centerRight,isTotalRow: isTotalRow),
      Statics.createWidgetFromIcon(context, (shaakhaaVrutta.isSewaVastiDefined == false ? null : Icons.check), 60, 52, Alignment.centerRight,isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (shaakhaaVrutta.sewaVastiSamparkCount == null ? '' : shaakhaaVrutta.sewaVastiSamparkCount.toString()),120, 52, Alignment.centerRight,isTotalRow: isTotalRow),
      Statics.createWidgetFromIcon(context,(shaakhaaVrutta.isSewaKaaryakartaaDefined == null || shaakhaaVrutta.isSewaKaaryakartaaDefined == false ? null : Icons.check),100,52,Alignment.centerRight,isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (shaakhaaVrutta.sewaUpakramCount == null ? '' : shaakhaaVrutta.sewaUpakramCount.toString()), 100, 52, Alignment.centerRight,isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (shaakhaaVrutta.anyaUpakramCount == null ? '' : shaakhaaVrutta.anyaUpakramCount.toString()), 100, 52, Alignment.centerRight,isTotalRow: isTotalRow),
      Statics.createWidgetFromIcon(context, (shaakhaaVrutta.isShaakhaaToli == null || shaakhaaVrutta.isShaakhaaToli == false ? null : Icons.check),100, 52, Alignment.centerRight,isTotalRow: isTotalRow),
      Statics.createWidgetFromString(context, (shaakhaaVrutta.shaakhaaToliBaithakCount == null ? '' : shaakhaaVrutta.shaakhaaToliBaithakCount.toString()), 60, 52, Alignment.centerRight,isTotalRow: isTotalRow),
      Statics.createWidgetFromIcon(context,(shaakhaaVrutta.isShaakhaaPaalak == null || shaakhaaVrutta.isShaakhaaPaalak == false ? null : Icons.check), 60, 52, Alignment.centerRight,isTotalRow: isTotalRow),
    ];
    widgetArray.add(Container(
      width: 70,
      child:
            IconButton(
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
                );
                print(
                  " shaakhaaVrutta.annualBaithakShaakhaaVruttaID ==> ${shaakhaaVrutta.annualBaithakShaakhaaVruttaID},\n shaakhaaVrutta.geoUnitID ==> ${shaakhaaVrutta.geoUnitID},\n shaakhaaVrutta.geoUnitName! ==> ${shaakhaaVrutta.geoUnitName!},\n shaakhaaVrutta.annualBaithakTypeID ==> ${shaakhaaVrutta.annualBaithakTypeID},\n shaakhaaVrutta.annualBaithakTypeCode ==> ${shaakhaaVrutta.annualBaithakTypeCode}");
              }

            ),
    ));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgetArray.map((widget) => Expanded(child: widget)).toList(),
    );

  }
  Future<void> exportListToCsv() async {

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

    Statics.convertToCsv(csvData, "AnnualBaithakVrutta" + "_" +
        DateFormat('ddmmyyyyHHmmss').format(DateTime.now()), context);

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
      Statics.createWidgetFromString(
          context, (mukhyaMaarg.mukhyaMaargName == null ? '' : mukhyaMaarg.mukhyaMaargName!), 100, 52, Alignment.center,
          isTotalRow: isTotalRow),
      Statics.createWidgetFromString(
          context, (mukhyaMaarg.shaakhaaCount == null ? '' : mukhyaMaarg.shaakhaaCount.toString()), 60, 52, Alignment.center,
          isTotalRow: isTotalRow),
      Statics.createWidgetFromString(
          context, (mukhyaMaarg.saaptaahikCount == null ? '' : mukhyaMaarg.saaptaahikCount.toString()), 60, 52, Alignment.center,
          isTotalRow: isTotalRow),
      Statics.createWidgetFromString(
          context, (mukhyaMaarg.maasikCount == null ? '' : mukhyaMaarg.maasikCount.toString()), 60, 52, Alignment.center,
          isTotalRow: isTotalRow),
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
      Statics.createWidgetFromIcon(
          context, (graamVikas.isUdayGraam == null || graamVikas.isUdayGraam == false ? null : Icons.check), 60, 52, Alignment.center,
          isTotalRow: isTotalRow),
      Statics.createWidgetFromIcon(
          context, (graamVikas.isPrabhaatGraam == null || graamVikas.isPrabhaatGraam == false ? null : Icons.check), 80, 52, Alignment.center,
          isTotalRow: isTotalRow),
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
  void _onEditShaakhaaVrutta(int? abShaakhaaVruttaID, int? geoUnitID, String? geoUnitName, int? abTypeID, String? abTypeCode) async {
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
                  viewType: (selectedViewOnly == 0 ? "EditVrutta" : "ViewOnly"),
                )));
    print("annualBaithakShaakhaaVruttaID ==> ${abShaakhaaVruttaID},\n geoUnitID ==> ${geoUnitID},\n geoUnitName! ==> ${geoUnitName!},\n annualBaithakTypeID ==> ${abTypeID},\n annualBaithakTypeCode ==> ${abTypeCode}\n selectedViewOnly ==> ${selectedViewOnly}");

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
    print("searching");
    setState(() {
      _isSearching = true;
      _isExpanded = false;
    });
    int? mahaanagarVal = _linkedMahaanagarValue == null || _linkedMahaanagarValue == "" ? null : int.parse(_linkedMahaanagarValue!);
    int? vibhaagVal = _linkedVibhaagValue == null || _linkedVibhaagValue == "" ? null : int.parse(_linkedVibhaagValue!);
    int? bhaagVal = _linkedBhaagValue == null || _linkedBhaagValue == "" ? null : int.parse(_linkedBhaagValue!);
    int? shaharVal = _linkedShaharValue == null || _linkedShaharValue == "" ? null : int.parse(_linkedShaharValue!);
    int? nagarVal = _linkedNagarValue == null || _linkedNagarValue == "" ? null : int.parse(_linkedNagarValue!);
    _baithakType = _baithakTypeValue == null || _baithakTypeValue == "" ? null : int.parse(_baithakTypeValue!);
    int? geoID = (nagarVal != null ? nagarVal : (bhaagVal != null ? bhaagVal : (vibhaagVal != null ? vibhaagVal : (mahaanagarVal != null ? mahaanagarVal : null))));

    if(geoID.toString() != "null"){

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
        nagarVrutta = await _getNagarVrutta(nagarVal, _baithakType!);
        if(geoID != null){
          _lstShaakhaaVrutta = await _getShaakhaaVrutta(mahaanagarVal,vibhaagVal,bhaagVal,shaharVal, nagarVal, _baithakType,geoID);
        }else{
          Statics.showMessageDialog(context, Statics.getLabel('selectedBhougolikkaryastithi'));
        }
        print("_lstShaakhaaVrutta!.length  ===> ${_lstShaakhaaVrutta!.length}");
        if (_lstShaakhaaVrutta != null && _lstShaakhaaVrutta!.length > 0) {
          print("_lstShaakhaaVrutta === > $_lstShaakhaaVrutta");
          double rowHeight = 115;
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Shaakhaa/Saaptaahik/Maasik/Mandali'), 100, rowHeight, Alignment.centerLeft,isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('FrequencyCode') + '/' + Statics.getLabel('VayogatCode'), 110, rowHeight, Alignment.centerLeft,isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Currentlyrunning'), 110, rowHeight, Alignment.centerLeft,isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('conductingDayCount'), 110, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('conductingSewaDayCount'), 110, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('averageSankhyaa'), 130, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, vaarshikotsavMonthLabel, 100, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('isSewaVastiDefined'), 60, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, sewaVastiSamparkCountLabel, 120, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('isSewaKaaryakartaaDefined'), 100, rowHeight, Alignment.centerLeft,isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, sewaUpakramCountLabel, 100, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, anyaUpakramCountLabel, 100, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('HasToli'), 100, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('ToliBaithakMeet'), 60, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('HasPaalak'), 60, rowHeight, Alignment.centerLeft, isTotalRow: false));
          shaakhaaVruttaHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Edit'), 70, rowHeight, Alignment.center, isTotalRow: false));
        } else {
          shaakhaaVruttaHeaderRow = null;
        }

        _lstShaakhaaViheen = await _getShaakhaaViheen(shaharVal, nagarVal, _baithakType);
        if (_lstShaakhaaViheen != null && _lstShaakhaaViheen!.length > 0) {
          double rowHeight = 100;
          shaakhaaViheenHeaderRow.add(
              Statics.createWidgetFromString(context, Statics.getLabel('vastiGraamName'), 100, rowHeight, Alignment.center, isTotalRow: false));
          if (_baithakType == Statics.abPratinidhiSabhaa)
            shaakhaaViheenHeaderRow.add(
                Statics.createWidgetFromString(context, Statics.getLabel('isShaakhaaInPast'), 100, rowHeight, Alignment.center, isTotalRow: false));
         shaakhaaViheenHeaderRow.add(Statics.createWidgetFromString(
              context, Statics.getLabel('praathamikShikshaarthiSakriya'), 100, rowHeight, Alignment.center,
              isTotalRow: false));
        shaakhaaViheenHeaderRow
              .add(Statics.createWidgetFromString(context, Statics.getLabel('Edit'), 70, rowHeight, Alignment.center, isTotalRow: false));
        } else {
          shaakhaaViheenHeaderRow = null;
        }

        _lstMukhyaMaarg = await _getMukhyaMaarg(shaharVal, nagarVal, _baithakType);
        if (_lstMukhyaMaarg != null && _lstMukhyaMaarg!.length > 0) {
          mukhyaMaargHeaderRow
              .add(Statics.createWidgetFromString(context, Statics.getLabel('Graam'), 100, 56, Alignment.center, isTotalRow: false));
          mukhyaMaargHeaderRow
              .add(Statics.createWidgetFromString(context, Statics.getLabel('mukhyaMaargName'), 100, 56, Alignment.center, isTotalRow: false));
          mukhyaMaargHeaderRow
              .add(Statics.createWidgetFromString(context, Statics.getLabel('shaakhaaCount'), 60, 56, Alignment.center, isTotalRow: false));
          mukhyaMaargHeaderRow
              .add(Statics.createWidgetFromString(context, Statics.getLabel('saaptaahikCount'), 60, 56, Alignment.center, isTotalRow: false));
          mukhyaMaargHeaderRow
              .add(Statics.createWidgetFromString(context, Statics.getLabel('mandaliCount'), 60, 56, Alignment.center, isTotalRow: false));
          mukhyaMaargHeaderRow
              .add(Statics.createWidgetFromString(context, Statics.getLabel('graamPramukhName'), 100, 56, Alignment.center, isTotalRow: false));
          mukhyaMaargHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Edit'), 70, 56, Alignment.center, isTotalRow: false));
        } else {
          mukhyaMaargHeaderRow = null;
        }

        _lstGraamVikas = await _getGraamVikas(shaharVal, nagarVal, _baithakType);
        if (_lstGraamVikas != null && _lstGraamVikas!.length > 0) {
          graamVikasHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Graam'), 150, 56, Alignment.center, isTotalRow: false));
          graamVikasHeaderRow
              .add(Statics.createWidgetFromString(context, Statics.getLabel('isUdayGraam'), 60, 56, Alignment.center, isTotalRow: false));
          graamVikasHeaderRow
              .add(Statics.createWidgetFromString(context, Statics.getLabel('isPrabhaatGraam'), 80, 56, Alignment.center, isTotalRow: false));
          graamVikasHeaderRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Edit'), 70, 56, Alignment.center, isTotalRow: false));
        } else {
          graamVikasHeaderRow = null;
        }
      }
      donloadexportList = [];




      setState(() {

        if (
        _baithakType == null) {
          _shaakhaaVruttaHeaderRow = null;
          _shaakhaaViheenHeaderRow = null;
          _mukhyaMaargHeaderRow = null;
          _graamVikasHeaderRow = null;
          _nagarVrutta = null;
          _selectedNagarAndBaithak = '';
        } else {


          print("nagarval ==> $nagarVal");
          _shaakhaaVruttaHeaderRow = shaakhaaVruttaHeaderRow;
          _shaakhaaViheenHeaderRow = shaakhaaViheenHeaderRow;
          _mukhyaMaargHeaderRow = mukhyaMaargHeaderRow;
          _graamVikasHeaderRow = graamVikasHeaderRow;
          _nagarVrutta = AnnualBaithakNagarVruttaBAL.fromMap(nagarVrutta);
          _selectedNagarAndBaithak = _baithakTypes!.firstWhere((element) => element.staticID == _baithakType).codeForDisplay! +
              ' | ' +
              (bhaagVal == null ? ' - ' : _linkedBhaag!.firstWhere((element) => element.geoUnitID == bhaagVal).name!) +
              ' | ' +
              (nagarVal  == null ? ' - ' :_linkedNagar!.firstWhere((element) => element.geoUnitID == nagarVal).name!) +
              ' | ' +
              (vibhaagVal == null ? ' - ' : _linkedVibhaag!.firstWhere((element) => element.geoUnitID == vibhaagVal).name!) +
              ' | ' +
              (mahaanagarVal == null ? ' - ' : _linkedMahaanagar!.firstWhere((element) => element.geoUnitID == mahaanagarVal).name!) +
              ' | ' ;
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
          "${(data.baalAverage == null ? '0' : data.baalAverage.toString()) +'/' +(data.tarunVidyaarthiAverage == null ? '0' : data.tarunVidyaarthiAverage.toString()) +'/' +(data.tarunVyavasaayeeAverage == null ? '0' : data.tarunVyavasaayeeAverage.toString()) +'/' +(data.proudhVyavasaayeeAverage == null ? '0' : data.proudhVyavasaayeeAverage.toString())}",
          "${data.vaarshikotsavMonth?.toString() ?? ''}",
          "${(data.isSewaVastiDefined == false ? Statics.getLabel('ConfirmationNo') : data.isSewaVastiDefined == true ? Statics.getLabel('ConfirmationYes'):"")}",
          "${data.sewaVastiSamparkCount  == null? "" : data.sewaVastiSamparkCount }",
          "${(data.isSewaKaaryakartaaDefined == false ? Statics.getLabel('ConfirmationNo') : data.isSewaKaaryakartaaDefined == true ? Statics.getLabel('ConfirmationYes'):"")}",
          "${data.sewaUpakramCount == null? "" : data.sewaUpakramCount  }",
          "${data.anyaUpakramCount == null? "" : data.anyaUpakramCount }",
          "${(data.isShaakhaaToli == false ? Statics.getLabel('ConfirmationNo') : data.isShaakhaaToli == true ? Statics.getLabel('ConfirmationYes'):"")}",
          "${(data.shaakhaaToliBaithakCount == 0 ? Statics.getLabel('ConfirmationNo') : data.shaakhaaToliBaithakCount == 1 ? Statics.getLabel('ConfirmationYes'):"")}",
          "${(data.isShaakhaaPaalak == false ? Statics.getLabel('ConfirmationNo') : data.isShaakhaaPaalak == true ? Statics.getLabel('ConfirmationYes'):"")}",
          "${(data.isSadhyaSuruAahe == 0 ? Statics.getLabel('ConfirmationNo') : data.isSadhyaSuruAahe == 1 ? Statics.getLabel('ConfirmationYes'):"")}",
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
    }else{
      setState(() {
        _isSearching = false;
      });
      Statics.showMessageDialog(context, Statics.getLabel('selectedBhougolikkaryastithi'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:   donloadexportList != []? FloatingActionButton(
        mini: true,
        tooltip: Statics.getLabel("ExportToExcel"),
        onPressed: () async {
              exportListToCsv();
              },
        child: Icon(Icons.download_sharp),
        backgroundColor: Colors.green,
      ):Container(),
      appBar: AppBar(
        title: Text(
          Statics.getLabel('annualBaithakVruttaTitle'),
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => NirikshanAnnualBaithakVrutta()));
          }, icon: Icon(Icons.search))
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
                      children: [
                        if(_linkedMahaanagar != null)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                            isExpanded: true,
                            value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                            items: _linkedMahaanagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                _linkedMahaanagarValue = value;
                                _linkedVibhaagValue = null;
                                _linkedBhaagValue = null;
                                _linkedShaharValue = null;
                                _linkedNagarValue = null;
                                populatelinkedVibhaagDropdown(value!);
                                mahanagarId = value;
                              });
                            },
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        if(_linkedVibhaag != null)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                            isExpanded: true,
                            value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                            items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                _linkedVibhaagValue = value;
                                populatelinkedBhaagDropdown(value!);
                                vibhagId = value;
                              _linkedBhaagValue  = _linkedNagarValue  = null;
                               _linkedBhaag  = _linkedNagar = null;
                              });
                            },
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        if(_linkedBhaag != null)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                            isExpanded: true,
                            value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
                            items: _linkedBhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            onChanged: (value) {
                              setState(() {
                                _linkedBhaagValue = value;
                                populatelinkedShaharDropdown(value!);
                                populatelinkedNagarDropdown(value, null);
                              });
                            },
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        if (_linkedShahar != null && _linkedShahar!.length > 0)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                            isExpanded: true,
                            value: _linkedShaharValue == "" ? null : _linkedShaharValue,
                            items: _linkedShahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            onChanged: (value) {
                              setState(() {
                                _linkedShaharValue = value;
                                populatelinkedNagarDropdown(null, value);
                              });
                            },
                          ),
                        if (_linkedShahar != null && _linkedShahar!.length > 0)
                          SizedBox(
                            height: 10,
                          ),
                        if (_linkedNagar != null && _linkedNagar!.length > 0)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                            isExpanded: true,
                            value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                            items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            onChanged: (value) {
                              setState(() {
                                _linkedNagarValue = value;
                              });
                            },
                          ),
                        if (_linkedNagar != null && _linkedNagar!.length > 0)
                          SizedBox(
                            height: 10,
                          ),
                        if(_baithakTypes != null)
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

                        SizedBox(height: 10),

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
                                  final matchedItem = _baithakTypes!.firstWhere((e) => e.staticID.toString() == value.toString(),);
                                  selectedViewOnly = matchedItem.ViewOnly;
                                  print("selectedViewOnly --> $selectedViewOnly");
                                } catch (e) {
                                  print("No match found for staticID: $value");
                                  selectedViewOnly = null;
                                }
                              });
                            },
                          ),
                        SizedBox(  height: 10,
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
                        textColor: Theme.of(context).primaryTextTheme.button!.color,
                        onPressed: () {
                          print("_baithakTypeValue ==> $_baithakTypeValue");
                          if (_baithakTypeValue != '' ) {
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
                             _linkedMahaanagarValue = _linkedVibhaagValue =  _linkedBhaagValue  = _linkedNagarValue  = null;
                             _linkedMahaanagar =  _linkedVibhaag = _linkedBhaag  = _linkedNagar = null;
                             _baithakType = null;
                              _baithakTypeValue = _selectedNagarAndBaithak = '';
                              _isSearching = false;
                             exportList.clear();
                             donloadexportList.clear();
                            });
                            populatelinkedMahaanagarDropdown();
                            populatelinkedVibhaagDropdown('');
                          },
                          child: Text(Statics.getLabel('clear'))),
                    ],
                  ),
                ],
              ),
            ),
            Text(_selectedNagarAndBaithak!, style: TextStyle(fontSize: 18)),
            Legend(legendString: "shaakhaaVrutta", fontsize: 18),
            (_isSearching)
                ? CircularProgressIndicator()
                : Container(
                    height: Statics.getDeviceSize(context).height * (_shaakhaaVruttaHeaderRow != null ? 0.40 : 0.07),
                    width: Statics.getDeviceSize(context).width,
                    child: _shaakhaaVruttaHeaderRow != null && _lstShaakhaaVrutta != null && _lstShaakhaaVrutta!.length > 0
                        ?
                    HorizontalDataTable(
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
}
