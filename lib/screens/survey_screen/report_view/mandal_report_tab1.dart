import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../models/response_model/taluka_mandal_model.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';
import '../../../widgets/single_column_row.dart';
import '../../../widgets/two_column_row.dart';

class MandalSurveyReportViewScreen1 extends StatefulWidget {
  static const String routeName = '/mandal-survey-report-tab1';

  const MandalSurveyReportViewScreen1({super.key});

  @override
  State<MandalSurveyReportViewScreen1> createState() => _MandalSurveyReportViewScreen1State();
}

class _MandalSurveyReportViewScreen1State extends State<MandalSurveyReportViewScreen1> {
  @override
  void initState() {
    super.initState();
    populateDropdown();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
    });
    await populateAllDropdowns(userLevelId!, dm);
  }

  bool _isExpanded = true;
  bool isVastiSearch = false;
  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedBhaag;
  List<GeoUnitMasterBAL>? _linkedNagar;
  List<GeoUnitMasterBAL>? _linkedupnagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<StaticMasterBAL>? _baithakTypes;
  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedBhaagValue = '';
  String? _linkedNagarValue = '';
  String? _linkedupnagarValue = '';
  String? _linkedvastiValue = '';
  String? mahanagarId = '';
  String? vibhagId = '';
  String? selctedLevel = 'praant';
  String? selctedLevelName = '';
  String? selctedDropDownLevelName = 'प्रांत';
  String? selctedLevelId = '0';
  String? _linkedmandalValue = '';
  String? _linkedgraamValue = '';
  List<GeoUnitMasterBAL>? _linkedgraam;

  String? _linkedBhaagName = '';
  String? _linkedshaharName = '';
  String? _linkednagarName = '';
  String? _linkedupnagarName = '';
  String? _linkedmandalName = '';
  String? _linkedgraamName = '';
  String? _linkedvastiName = '';

  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  String _selctedLevelNames = '';
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId;

  Future<void> populateAllDropdowns(int level, DropDownModel dm) async {
    setState(() {
      _selectedGeoUnitId = _linkedMahaanagarValue = _linkedBhaagValue = _linkedNagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    final selection = prepareSelection(dm);

    // Step 1: Mahaanagar
    if (selection.mahaanagar!.isNotEmpty) await populatelinkedMahaanagarDropdown();
    _linkedMahaanagarValue = (level == 9 ? (dm.geoUnitID ?? 0).toString() : selection.mahaanagar) ?? _linkedMahaanagarValue;
    if (level == 9) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.mahaanagar).toString();
      _selctedLevel = 'Mahaanagar';
    }

    // Step 2: Vibhaag
    await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
    _linkedVibhaagValue = (level == 8 ? (dm.geoUnitID ?? 0).toString() : selection.vibhaag) ?? _linkedVibhaagValue;
    if (level == 8) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.vibhaag).toString();
      _selctedLevel = 'Vibhaag';
    }

    // Step 3: Bhaag
    await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
    _linkedBhaagValue = (level == 7 ? (dm.geoUnitID ?? 0).toString() : selection.bhaag) ?? _linkedBhaagValue;
    if (level == 7) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.bhaag).toString();
      _selctedLevel = 'Bhaag';
    }

    // Step 4: Nagar
    await populatelinkedNagarDropdown(_linkedBhaagValue, null);
    _linkedNagarValue = (level == 6 ? (dm.geoUnitID ?? 0).toString() : selection.nagar) ?? _linkedNagarValue;
    if (level == 6) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.nagar).toString();
      _selctedLevel = 'Nagar';
    }

    // Step 5: Upnagar (conditional)
    await populatelinkedUpnagarDropdown(_linkedNagarValue);
    if (selection.upnagar != null && selection.upnagar!.isNotEmpty) {
      _linkedupnagarValue = (level == 13 ? (dm.geoUnitID ?? 0).toString() : selection.upnagar) ?? _linkedupnagarValue;
      if (level == 13) {
        _selectedGeoUnitId = (dm.geoUnitID ?? selection.upnagar).toString();
        _selctedLevel = 'Upnagar';
      }
    }

    // Step 6: Mandal
    await populatelinkedMandalDropdown(
      selection.upnagar != null,
      selection.upnagar != null ? _linkedNagarValue : _linkedupnagarValue,
    );
    _linkedmandalValue = (level == 4 ? (dm.geoUnitID ?? 0).toString() : selection.mandal) ?? _linkedmandalValue;
    if (level == 4) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.mandal).toString();
      _selctedLevel = 'Mandal';
    }
    // // Step 7: Graam
    // await populatelinkedGraamDropdown(_linkedmandalValue);
    // _selectedGeoUnitId = _linkedgraamValue = (level == 3 ? (dm.geoUnitID ?? "").toString() : selection.graam) ?? '';
    //
    // // Step 8: Vasti
    // await populatelinkedVastiDropdown(_linkedNagarValue);
    // _selectedGeoUnitId = _linkedvastiValue = (level == 2 ? (dm.geoUnitID ?? "").toString() : selection.vasti) ?? '';

    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty) _linkedbhaagName = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkednagar != null && _linkednagar!.isNotEmpty) _linkednagarName = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;

    setState(() {});
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    if (fromClear || userLevelId == null || ddm == null) {
      setState(() {
        _linkedMahaanagarValue = _linkedBhaagValue = _linkedNagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
        _linkedMahaanagar = _linkedVibhaag = _linkedBhaag = _linkedNagar = _linkedupnagar = _linkedmandal = null;
        _selctedLevelName = _selectedGeoUnitId = null;
        _selctedLevel = "praant";
      });
      await populatelinkedMahaanagarDropdown();
      await populatelinkedVibhaagDropdown('');
      return;
    }
    setState(() {
      _linkedMahaanagarValue = _linkedBhaagValue = _linkedNagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
      _linkedMahaanagar = _linkedVibhaag = _linkedBhaag = _linkedNagar = _linkedupnagar = _linkedmandal = null;
    });
    await populateAllDropdowns(userLevelId!, ddm!);
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    // populatelinkedMahaanagarDropdown();
    // populatelinkedVibhaagDropdown('');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
    // print("_baithakTypes :-- $_baithakTypes");
    setState(() {});
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '', isAbhiyaan: false);
    setState(() => _linkedMahaanagar = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkedNagarValue = null;
    _linkedNagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedUpnagarDropdown(String? nagarIDStr) async {
    _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = null;
    _linkedupnagarName = _linkedmandalName = _linkedgraamName = null;
    _linkedupnagar = _linkedmandal = _linkedgraam = null;
    var mnDD;

    mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');

    setState(() {
      _linkedupnagar = (mnDD.length > 0 ? mnDD : null);
      //_linkedupnagarValue = (userparentUpanagarid ?? userGeoUnitId).toString();
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(bool haveParentUp, String? nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandalName = _linkedgraamName = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD;
    if (haveParentUp) {
      mnDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, "Upnagar", '');
    } else {
      mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, "Nagar", '');
    }
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  void resetData() async {
    setState(() {
      _linkedMahaanagarValue = null;
      _linkedVibhaagValue = null;
      _linkedBhaagValue = null;
      _linkedNagarValue = null;
      mahanagarId = '';
      selctedLevelName = "";
      selctedLevel = 'praant';
      _linkedvastiValue = '';
      selctedLevelId = '0';
      selctedLevelName = "";
      _linkedBhaag = null;
      _linkedNagar = null;
      _linkedvasti = null;
      _linkedmandal = null;
      isVastiSearch = false;
      selctedLevelName = '';
      selctedDropDownLevelName = 'प्रांत';
      _isExpanded = false;
      _linkedmandalValue = null;
      talukaMandalSampurnaModel = null;
      populateDropdown();
    });
  }

  void showPopupList(BuildContext context, String vastiStepStartedNames) {
    if (vastiStepStartedNames.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "${Statics.getLabel('vastiNotAvailable')}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
      return;
    }

    final List<String> namesList = vastiStepStartedNames.split('::').map((e) => e.trim()).toList();

    if (namesList.isEmpty || namesList.first.isEmpty) {
      Fluttertoast.showToast(
        msg: "${Statics.getLabel('vastiNotAvailable')}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: double.maxFinite,
          height: 500,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.list_alt, color: Colors.purpleAccent),
                  SizedBox(width: 10),
                  Text(
                    "${Statics.getLabel('vastiYaadi')}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purpleAccent,
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1, height: 20),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 6,
                  radius: Radius.circular(10),
                  child: ListView.builder(
                    itemCount: namesList.length,
                    itemBuilder: (_, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1})  ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              namesList[index],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: Text("${Statics.getLabel('bandKara')}"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TalukaMandalSampurnaModel? talukaMandalSampurnaModel;
  List<TalukamandalsarvekshanReportwithname>? data;
  List<TalukamandalSamajikkaryakram>? talukaaSamajikKaryakram;
  List<Talukamandalmahatvacesana>? talukamandalSana;
  List<Talukamandalupaasana>? talukamandalUpasanaSthal;
  List<TalukamandalvividhSampradhaySatsangKendra>? talukamandalvividhSampradhaySatsangKendra;
  List<TalukamandalReligion>? talukaMandalReligion;
  List<TalukamandalListSwayamsevakCountByVyavasaayeeCategory>? vyavasaayeeCategory;
  List<Talukamandalsajjanshakkati> sajjanList = [];
  List<Talukamandaldurjanshakkati> durjanshakati = [];
  List<TalukamandalSewaPrakalpa> sewaPrakalpa = [];

  // void getMyDetailsColumnsAndRows() async {
  //   talukaMandalSampurnaModel =
  //       await Statics.vastisarvekshanAllReportDataForMandal(context,
  //           Statics.userDetails["userID"], selctedLevelId, selctedLevel);
  //   log("talukaMandalSampurnaModel ${jsonEncode(talukaMandalSampurnaModel)}");
  //   setState(() {
  //     data =
  //         talukaMandalSampurnaModel!.talukamandalsarvekshanReportwithname ?? [];
  //     talukaaSamajikKaryakram =
  //         talukaMandalSampurnaModel!.talukamandalSamajikkaryakram ?? [];
  //     talukamandalSana =
  //         talukaMandalSampurnaModel!.talukamandalmahatvacesana ?? [];
  //     talukamandalUpasanaSthal =
  //         talukaMandalSampurnaModel!.talukamandalupaasana ?? [];
  //     talukaMandalReligion =
  //         talukaMandalSampurnaModel!.talukamandalReligion ?? [];
  //     vyavasaayeeCategory = talukaMandalSampurnaModel!
  //             .talukamandalListSwayamsevakCountByVyavasaayeeCategory ??
  //         [];
  //     sajjanList = talukaMandalSampurnaModel!.talukamandalsajjanshakkati ?? [];
  //     durjanshakati = talukaMandalSampurnaModel!.talukamandaldurjanshakkati!;
  //     sewaPrakalpa = talukaMandalSampurnaModel!.talukamandalSewaPrakalpa ?? [];
  //     talukamandalvividhSampradhaySatsangKendra = talukaMandalSampurnaModel!
  //             .talukamandalvividhSampradhaySatsangKendra ??
  //         [];
  //   });
  // }

  void getMyDetailsColumnsAndRows() async {
    talukaMandalSampurnaModel = await Statics.vastisarvekshanAllReportDataForMandal(context, Statics.userDetails["userID"], selctedLevelId, selctedLevel);
    log("talukaMandalSampurnaModel ${jsonEncode(talukaMandalSampurnaModel)}");

    if (talukaMandalSampurnaModel == null || (talukaMandalSampurnaModel!.talukamandalsarvekshanReportwithname == null || talukaMandalSampurnaModel!.talukamandalsarvekshanReportwithname!.isEmpty)) {
      Statics.showToast("${Statics.getLabel('NoDataFound')}");
      return;
    }

    setState(() {
      data = talukaMandalSampurnaModel!.talukamandalsarvekshanReportwithname ?? [];
      talukaaSamajikKaryakram = talukaMandalSampurnaModel!.talukamandalSamajikkaryakram ?? [];
      talukamandalSana = talukaMandalSampurnaModel!.talukamandalmahatvacesana ?? [];
      talukamandalUpasanaSthal = talukaMandalSampurnaModel!.talukamandalupaasana ?? [];
      talukaMandalReligion = talukaMandalSampurnaModel!.talukamandalReligion ?? [];
      vyavasaayeeCategory = talukaMandalSampurnaModel!.talukamandalListSwayamsevakCountByVyavasaayeeCategory ?? [];
      sajjanList = talukaMandalSampurnaModel!.talukamandalsajjanshakkati ?? [];
      durjanshakati = talukaMandalSampurnaModel!.talukamandaldurjanshakkati ?? [];
      sewaPrakalpa = talukaMandalSampurnaModel!.talukamandalSewaPrakalpa ?? [];
      talukamandalvividhSampradhaySatsangKendra = talukaMandalSampurnaModel!.talukamandalvividhSampradhaySatsangKendra ?? [];
    });
  }

  Widget buildTalukaMandalTable(List<Talukamandaldurjanshakkati> dataList) {
    dataList = talukaMandalSampurnaModel!.talukamandaldurjanshakkati ?? [];

    final List<String> uniqueSubtypes = dataList.map((e) => e.subtype ?? '').toSet().where((s) => s.isNotEmpty).toList();

    final List<String> uniqueMaintypes = dataList.map((e) => e.maintype ?? '').toSet().where((m) => m.isNotEmpty).toList();

    List<DataRow> rows = uniqueMaintypes.map((maintype) {
      List<DataCell> cells = [
        DataCell(Text(maintype)),
        ...uniqueSubtypes.map((subtype) {
          final match = dataList.firstWhere(
            (e) => e.maintype == maintype && e.subtype == subtype,
            orElse: () => Talukamandaldurjanshakkati(sankhya: null),
          );
          return DataCell(Text(match.sankhya?.toString() ?? '-'));
        }).toList(),
      ];
      return DataRow(cells: cells);
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.purpleAccent),
        headingTextStyle: TextStyle(color: Colors.white),
        columns: [
          DataColumn(label: Text("${Statics.getLabel('mukhyaPrakar')}")),
          ...uniqueSubtypes.map((subtype) => DataColumn(label: Text(subtype))),
        ],
        rows: rows,
      ),
    );
  }

  Widget buildSewaPrakalpaDataTable(List<TalukamandalSewaPrakalpa> dataList) {
    dataList = talukaMandalSampurnaModel!.talukamandalSewaPrakalpa ?? [];

    // 1. Unique subtypes for header columns
    final List<String> uniqueSubtypes = dataList.map((e) => e.subtype ?? '').toSet().where((s) => s.isNotEmpty).toList();

    // 2. Unique maintypes for row headers
    final List<String> uniqueMaintypes = dataList.map((e) => e.maintype ?? '').toSet().where((m) => m.isNotEmpty).toList();

    // 3. Construct DataTable rows
    List<DataRow> rows = uniqueMaintypes.map((maintype) {
      List<DataCell> cells = [
        DataCell(Text(maintype)), // First cell: maintype
        ...uniqueSubtypes.map((subtype) {
          final match = dataList.firstWhere(
            (e) => e.maintype == maintype && e.subtype == subtype,
            orElse: () => TalukamandalSewaPrakalpa(sankhya: null),
          );
          return DataCell(Text(match.sankhya?.toString() ?? '-'));
        }).toList(),
      ];
      return DataRow(cells: cells);
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.purpleAccent.shade200),
        headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        columns: [
          DataColumn(label: Text("${Statics.getLabel('mukhyaPrakar')}")),
          ...uniqueSubtypes.map((subtype) => DataColumn(label: Text(subtype))),
        ],
        rows: rows,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Sajjan Shakti
    final Map<String, List<Talukamandalsajjanshakkati>> groupedData = {};
    for (var item in sajjanList) {
      final key = item.sajjanshakkati;
      groupedData.putIfAbsent(key!, () => []).add(item);
    }
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              vastiMandalDropdown(),
              if (isVastiSearch == true)
                SizedBox(
                  height: 20,
                ),
              if (isVastiSearch == true)
                Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purpleAccent, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "$selctedDropDownLevelName ",
                          style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        if (selctedLevelName != "")
                          Text(
                            "-> $selctedLevelName",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                      ],
                    )),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  children: [
                    if (isVastiSearch == true)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: Text(
                            '${Statics.getLabel('sharaansh')} ($selctedDropDownLevelName)',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    if (isVastiSearch == true) Divider(),
                    // if (isVastiSearch == true)
                    //   Container(
                    //     child: SingleChildScrollView(
                    //       scrollDirection: Axis.horizontal,
                    //       child: DataTable(
                    //         headingRowColor:
                    //             MaterialStateProperty.all(Colors.teal.shade100),
                    //         headingTextStyle: const TextStyle(
                    //             fontSize: 15,
                    //             color: Colors.black,
                    //             fontWeight: FontWeight.bold),
                    //         columns: [
                    //           DataColumn(
                    //               label: Text(
                    //                   "${Statics.getLabel('sarvekshanSthiti')}")),
                    //           DataColumn(
                    //               label:
                    //                   Text("${Statics.getLabel('taalukaa')}")),
                    //           DataColumn(
                    //               label: Text("${Statics.getLabel('Mandal')}")),
                    //           DataColumn(
                    //               label: Text("${Statics.getLabel('gaav')}")),
                    //           DataColumn(label: Text('')),
                    //         ],
                    //         rows: [
                    //           DataRow(
                    //             color: MaterialStateProperty.all(
                    //                 Colors.green.shade50),
                    //             cells: [
                    //               DataCell(Text(
                    //                   "${Statics.getLabel('prathamikSurveyComplete')}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarStep1CompleteCount ?? ""}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalStep1CompleteCount ?? ""}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vastiStep1CompleteCount ?? ""}")),
                    //               DataCell(IconButton(
                    //                 icon: Icon(Icons.remove_red_eye,
                    //                     color: Colors.teal),
                    //                 onPressed: () => showPopupList(
                    //                     context,
                    //                     talukaMandalSampurnaModel!
                    //                         .talukamandalsarvekshanReportwithselectedlevel!
                    //                         .vastiStep1CompleteNames!
                    //                         .toString()),
                    //               )),
                    //             ],
                    //           ),
                    //           // DataRow(
                    //           //   color: MaterialStateProperty.all(Colors.green.shade50),
                    //           //   cells: [
                    //           //     DataCell(Text("${Statics.getLabel('otherSuerveyComplete')}")),
                    //           //     DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarStep2CompleteCount ?? ""}")),
                    //           //     DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalStep1CompleteCount ?? ""}")),
                    //           //     DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vastiStep2CompleteCount ?? ""}")),
                    //           //     DataCell(IconButton(
                    //           //       icon: Icon(Icons.remove_red_eye, color: Colors.teal),
                    //           //       onPressed: () => showPopupList(context,
                    //           //           talukaMandalSampurnaModel!.talukamandalsarvekshanReportwithselectedlevel!.vastiStep2CompleteNames!.toString()),
                    //           //     )),
                    //           //   ],
                    //           // ),
                    //           DataRow(
                    //             color: MaterialStateProperty.all(
                    //                 Colors.green.shade50),
                    //             cells: [
                    //               DataCell(Text(
                    //                   "${Statics.getLabel('vistrutSurveyComplete')}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarStep3CompleteCount ?? ""}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalStep3CompleteCount ?? ""}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vastiStep3CompleteCount ?? ""}")),
                    //               DataCell(IconButton(
                    //                 icon: Icon(Icons.remove_red_eye,
                    //                     color: Colors.teal),
                    //                 onPressed: () => showPopupList(
                    //                     context,
                    //                     talukaMandalSampurnaModel!
                    //                         .talukamandalsarvekshanReportwithselectedlevel!
                    //                         .vastiStep3CompleteNames!
                    //                         .toString()),
                    //               )),
                    //             ],
                    //           ),
                    //           DataRow(
                    //             color: MaterialStateProperty.all(
                    //                 Colors.orange.shade50),
                    //             cells: [
                    //               DataCell(Text(
                    //                   "${Statics.getLabel('surveyStart')}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarStepStartedCount ?? ""}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalStepStartedCount ?? ""}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vastiStepStartedCount ?? ""}")),
                    //               DataCell(IconButton(
                    //                 icon: Icon(Icons.remove_red_eye,
                    //                     color: Colors.teal),
                    //                 onPressed: () => showPopupList(
                    //                     context,
                    //                     talukaMandalSampurnaModel!
                    //                         .talukamandalsarvekshanReportwithselectedlevel!
                    //                         .vastiStepStartedNames!
                    //                         .toString()),
                    //               )),
                    //             ],
                    //           ),
                    //           DataRow(
                    //             color: MaterialStateProperty.all(
                    //                 Colors.orange.shade50),
                    //             cells: [
                    //               DataCell(Text(
                    //                   "${Statics.getLabel('surveyComplete')}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarAllStepsCompleteCount ?? ""}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalAllStepsCompleteCount ?? ""}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vastiAllStepsCompleteCount ?? ""}")),
                    //               DataCell(IconButton(
                    //                 icon: Icon(Icons.remove_red_eye,
                    //                     color: Colors.teal),
                    //                 onPressed: () => showPopupList(
                    //                     context,
                    //                     talukaMandalSampurnaModel!
                    //                         .talukamandalsarvekshanReportwithselectedlevel!
                    //                         .vastiAllStepsCompleteNames!
                    //                         .toString()),
                    //               )),
                    //             ],
                    //           ),
                    //           DataRow(
                    //             color: MaterialStateProperty.all(
                    //                 Colors.orange.shade50),
                    //             cells: [
                    //               DataCell(Text(
                    //                   "${Statics.getLabel('surveyNotStarted')}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarStepsNotstartedCount ?? ""}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalStepsNotstartedCount ?? ""}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vastiStepsNotstartedCount ?? ""}")),
                    //               DataCell(IconButton(
                    //                 icon: Icon(Icons.remove_red_eye,
                    //                     color: Colors.teal),
                    //                 onPressed: () => showPopupList(
                    //                     context,
                    //                     talukaMandalSampurnaModel!
                    //                         .talukamandalsarvekshanReportwithselectedlevel!
                    //                         .vastiStepsNotstartedNames!
                    //                         .toString()),
                    //               )),
                    //             ],
                    //           ),
                    //           DataRow(
                    //             color: MaterialStateProperty.all(
                    //                 Colors.grey.shade200),
                    //             cells: [
                    //               DataCell(
                    //                   Text("${Statics.getLabel('Total')}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarcount ?? ""}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalcount ?? ""}")),
                    //               DataCell(Text(
                    //                   "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vasticount ?? ""}")),
                    //               DataCell(Text("-")),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    if (isVastiSearch == true)
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(Colors.blueAccent),
                            headingTextStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            columns: [
                              DataColumn(label: Text("${Statics.getLabel('sarvekshanSthiti')}")),
                              DataColumn(label: Text("${Statics.getLabel('taalukaa')}")),
                              DataColumn(label: Text("${Statics.getLabel('Mandal')}")),
                              DataColumn(label: Text("${Statics.getLabel('gaav')}")),
                              DataColumn(label: Text('')),
                            ],
                            rows: [
                              DataRow(
                                color: MaterialStateProperty.all(Colors.orange.shade50),
                                cells: [
                                  DataCell(Text("${Statics.getLabel('surveyStart')}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarStepStartedCount ?? ""}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalStepStartedCount ?? ""}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vastiStepStartedCount ?? ""}")),
                                  DataCell(IconButton(
                                    icon: Icon(Icons.remove_red_eye, color: Colors.teal),
                                    onPressed: () => showPopupList(context, talukaMandalSampurnaModel!.talukamandalsarvekshanReportwithselectedlevel!.vastiStepStartedNames!.toString()),
                                  )),
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(Colors.orange.shade50),
                                cells: [
                                  DataCell(Text("${Statics.getLabel('surveyComplete')}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarAllStepsCompleteCount ?? ""}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalAllStepsCompleteCount ?? ""}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vastiAllStepsCompleteCount ?? ""}")),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(Icons.remove_red_eye, color: Colors.teal),
                                      onPressed: () => showPopupList(context, talukaMandalSampurnaModel!.talukamandalsarvekshanReportwithselectedlevel!.vastiAllStepsCompleteNames!.toString()),
                                    ),
                                  ),
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(Colors.orange.shade50),
                                cells: [
                                  DataCell(Text("${Statics.getLabel('surveyNotStarted')}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarStepsNotstartedCount ?? ""}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalStepsNotstartedCount ?? ""}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vastiStepsNotstartedCount ?? ""}")),
                                  DataCell(IconButton(
                                    icon: Icon(Icons.remove_red_eye, color: Colors.teal),
                                    onPressed: () => showPopupList(context, talukaMandalSampurnaModel!.talukamandalsarvekshanReportwithselectedlevel!.vastiStepsNotstartedNames!.toString()),
                                  )),
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(Colors.grey.shade200),
                                cells: [
                                  DataCell(Text("${Statics.getLabel('Total')}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarcount ?? ""}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalcount ?? ""}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vasticount ?? ""}")),
                                  DataCell(Text("-")),
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(Colors.white),
                                cells: [
                                  DataCell(Text("")),
                                  DataCell(Text("")),
                                  DataCell(Text("")),
                                  DataCell(Text("")),
                                  DataCell(Text("")),
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(Colors.teal.shade100),
                                cells: [
                                  DataCell(
                                    Container(
                                      alignment: Alignment.center,
                                      width: double.infinity, // makes it span available width
                                      child: Text("${Statics.getLabel('surveyStart')} ${Statics.getLabel('Status')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      alignment: Alignment.center,
                                      width: double.infinity, // makes it span available width
                                      child: Text("${Statics.getLabel('taalukaa')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      alignment: Alignment.center,
                                      width: double.infinity, // makes it span available width
                                      child: Text("${Statics.getLabel('Mandal')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      alignment: Alignment.center,
                                      width: double.infinity, // makes it span available width
                                      child: Text("${Statics.getLabel('gaav')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
                                    ),
                                  ),
                                  DataCell.empty,
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(Colors.green.shade50),
                                cells: [
                                  DataCell(Text("${Statics.getLabel('prathamikSurveyComplete')}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarStep1CompleteCount ?? ""}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalStep1CompleteCount ?? ""}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vastiStep1CompleteCount ?? ""}")),
                                  DataCell(IconButton(
                                    icon: Icon(Icons.remove_red_eye, color: Colors.teal),
                                    onPressed: () => showPopupList(context, talukaMandalSampurnaModel!.talukamandalsarvekshanReportwithselectedlevel!.vastiStep1CompleteNames!.toString()),
                                  )),
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(Colors.green.shade50),
                                cells: [
                                  DataCell(Text("${Statics.getLabel('vistrutSurveyComplete')}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarStep3CompleteCount ?? ""}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalStep3CompleteCount ?? ""}")),
                                  DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vastiStep3CompleteCount ?? ""}")),
                                  DataCell(IconButton(
                                    icon: Icon(Icons.remove_red_eye, color: Colors.teal),
                                    onPressed: () => showPopupList(context, talukaMandalSampurnaModel!.talukamandalsarvekshanReportwithselectedlevel!.vastiStep3CompleteNames!.toString()),
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    commonExpansionTile(
                      title: 'MandalsurveuAbhiyanStithi',
                      children: [
                        if (talukaMandalSampurnaModel != null && talukaMandalSampurnaModel!.talukamandalsarvekshanReportwithname != null)
                          Container(
                            height: 500,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithname?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final data = talukaMandalSampurnaModel!.talukamandalsarvekshanReportwithname![index];
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: Center(
                                          child: Text(
                                            data.name ?? "${Statics.getLabel('talukaMandalNaav')}",
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          // width: MediaQuery.of(context)
                                          //         .size
                                          //         .width *
                                          //     0.9,
                                          child: DataTable(
                                            headingRowColor: MaterialStateProperty.all(Colors.purpleAccent.shade100),
                                            headingTextStyle: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                                            columns: [
                                              DataColumn(label: Text("${Statics.getLabel('sarvekshanSthiti')}")),
                                              DataColumn(label: Text("${Statics.getLabel('taalukaa')}")),
                                              DataColumn(label: Text("${Statics.getLabel('Mandal')}")),
                                              DataColumn(label: Text("${Statics.getLabel('gaav')}")),
                                            ],
                                            rows: [
                                              DataRow(
                                                color: MaterialStateProperty.all(Colors.red.shade50),
                                                cells: [
                                                  DataCell(Text("${Statics.getLabel('surveyStart')}")),
                                                  DataCell(Text("${data.nagarStepStartedCount ?? ""}")),
                                                  DataCell(Text("${data.mandalStepStartedCount ?? ""}")),
                                                  DataCell(Text("${data.vastiStepStartedCount ?? ""}")),
                                                ],
                                              ),
                                              DataRow(
                                                color: MaterialStateProperty.all(Colors.red.shade50),
                                                cells: [
                                                  DataCell(Text("${Statics.getLabel('surveyComplete')}")),
                                                  DataCell(Text("${data.nagarAllStepsCompleteCount ?? ""}")),
                                                  DataCell(Text("${data.mandalAllStepsCompleteCount ?? ""}")),
                                                  DataCell(Text("${data.vastiAllStepsCompleteCount ?? ""}")),
                                                ],
                                              ),
                                              DataRow(
                                                color: MaterialStateProperty.all(Colors.red.shade50),
                                                cells: [
                                                  DataCell(Text("${Statics.getLabel('surveyNotStarted')}")),
                                                  DataCell(Text("${data.nagarStepsNotstartedCount ?? ""}")),
                                                  DataCell(Text("${data.mandalStepsNotstartedCount ?? ""}")),
                                                  DataCell(Text("${data.vastiStepsNotstartedCount ?? ""}")),
                                                ],
                                              ),
                                              DataRow(
                                                color: MaterialStateProperty.all(Colors.yellow.shade50),
                                                cells: [
                                                  DataCell(Text("${Statics.getLabel('Total')}")),
                                                  DataCell(Text("${data.nagarcount ?? ""}")),
                                                  DataCell(Text("${data.mandalcount ?? ""}")),
                                                  DataCell(Text("${data.vasticount ?? ""}")),
                                                ],
                                              ),
                                              DataRow(color: MaterialStateProperty.all(Colors.white), cells: [
                                                DataCell.empty,
                                                DataCell.empty,
                                                DataCell.empty,
                                                DataCell.empty,
                                              ]),
                                              DataRow(
                                                color: MaterialStateProperty.all(Colors.lightBlue.shade50),
                                                cells: [
                                                  DataCell(Text("${Statics.getLabel('prathamikSurveyComplete')}")),
                                                  DataCell(Text("${data.nagarStep1CompleteCount ?? ""}")),
                                                  DataCell(Text("${data.mandalStep1CompleteCount ?? ""}")),
                                                  DataCell(Text("${data.vastiStep1CompleteCount ?? ""}")),
                                                ],
                                              ),
                                              DataRow(
                                                color: MaterialStateProperty.all(Colors.lightBlue.shade50),
                                                cells: [
                                                  DataCell(Text("${Statics.getLabel('vistrutSurveyComplete')}")),
                                                  DataCell(Text("${data.nagarStep3CompleteCount ?? ""}")),
                                                  DataCell(Text("${data.mandalStep3CompleteCount ?? ""}")),
                                                  DataCell(Text("${data.vastiStep3CompleteCount ?? ""}")),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(thickness: 2),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'SarvekshanSankalan',
                      children: [
                        SingleColumnRow(txtString: Statics.getLabel('MandalCount'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.mandalCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('GraamCount'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.graamcount.toString(), fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'sewaPrakalpa',
                      children: [
                        if (talukaMandalSampurnaModel != null && sewaPrakalpa != null) buildSewaPrakalpaDataTable(sewaPrakalpa),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'karyamahiti',
                      children: [
                        if (talukaMandalSampurnaModel != null && talukaMandalSampurnaModel?.talukamandalvividhKshetaCheKam != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('karyaSankhya')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('kitiMandalat')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('kitiGaavat')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('chalavnareCount')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: [
                                  DataRow(
                                    cells: [
                                      DataCell(Center(child: Text(talukaMandalSampurnaModel!.talukamandalvividhKshetaCheKam!.karyasankhya.toString()))),
                                      DataCell(Center(child: Text(talukaMandalSampurnaModel!.talukamandalvividhKshetaCheKam!.mandalCount.toString()))),
                                      DataCell(Center(child: Text(talukaMandalSampurnaModel!.talukamandalvividhKshetaCheKam!.gramCount.toString()))),
                                      DataCell(Center(child: Text(talukaMandalSampurnaModel!.talukamandalvividhKshetaCheKam!.sankhya.toString()))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'satsangKendra',
                      children: [
                        Container(
                          // height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (talukaMandalSampurnaModel != null && talukamandalvividhSampradhaySatsangKendra != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('saampradaay')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('TotalGraamCount')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('kitiMandalat')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukamandalvividhSampradhaySatsangKendra!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(child: Text(item.value ?? ''))),
                                            DataCell(Center(child: Text(item.gramCount.toString()))),
                                            DataCell(Center(child: Text(item.mandalCount.toString()))),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'mumbaikarGaav',
                      children: [
                        if (talukaMandalSampurnaModel != null && talukaMandalSampurnaModel?.talukamandalMumbaikar != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('mumbaikarGaav')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('GraamCount')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('kitiMandalat')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: [
                                  DataRow(
                                    cells: [
                                      DataCell(Center(child: Text(talukaMandalSampurnaModel!.talukamandalMumbaikar!.sankhya.toString()))),
                                      DataCell(Center(child: Text(talukaMandalSampurnaModel!.talukamandalMumbaikar!.gramCount.toString()))),
                                      DataCell(Center(child: Text(talukaMandalSampurnaModel!.talukamandalMumbaikar!.mandalCount.toString()))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'SwayamsevakCount',
                      children: [
                        SingleColumnRow(txtString: Statics.getLabel('TotalKaaryakartaaCount'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.totalKaaryakartaaCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('PratidnyitCount'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.pratidnyitCount.toString(), fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'SwayamsevakCountByAge',
                      children: [
                        SingleColumnRow(txtString: Statics.getLabel('Shishu'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.shishuCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('Baal'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.baalCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('TarunVidyaarthi'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.tarunVidyaarthiCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('TarunVyavasaayee'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.tarunVyavasaayeeCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('ProudhVyavasaayee'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.proudhaVyavasaayeeCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('UnkownAge'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.unknownAgeCount.toString(), fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'ShikshitSwayamsevakCount',
                      children: [
                        SingleColumnRow(txtString: Statics.getLabel('PrarambhikShikshit'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.prarambhikShikshitCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('PraathamikShikshit'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.praathamikShikshitCount.toString(), fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('PrathamVarshShikshit'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.prathamVarshaShikshitCount.toString(), fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('DwitiyaVarshShikshit'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.dwitiyaVarshaShikshitCount.toString(), fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('TrutiyaVarshShikshit'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.trutiyaVarshaShikshitCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('NoShikshan'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.noShikshanCount.toString(), fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'KaaryakartaaCountByLevel',
                      children: [
                        TwoColumnRow(
                          txtString: Statics.getLabel('Shaakhaa'),
                          value: talukaMandalSampurnaModel?.loksankhyaformandal?.dailyShaakhaaKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('SaaptaahikLabelShort'),
                          value2: talukaMandalSampurnaModel?.loksankhyaformandal?.saaptaahikMilanKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('MilanMandali'),
                          value: talukaMandalSampurnaModel?.loksankhyaformandal?.maasikMilanKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('VastiKaaryakartaaCount'),
                          value2: talukaMandalSampurnaModel?.loksankhyaformandal?.vastiKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('GraamKaaryakartaaCount'),
                          value: talukaMandalSampurnaModel?.loksankhyaformandal?.graamKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('MandalKaaryakartaaCount'),
                          value2: talukaMandalSampurnaModel?.loksankhyaformandal?.mandalKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('NagarKaaryakartaaCount'),
                          value: talukaMandalSampurnaModel?.loksankhyaformandal?.nagarKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('ShaharKaaryakartaaCount'),
                          value2: talukaMandalSampurnaModel?.loksankhyaformandal?.shaharKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('BhaagKaaryakartaaCount'),
                          value: talukaMandalSampurnaModel?.loksankhyaformandal?.bhaagKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('VibhaagKaaryakartaaCount'),
                          value2: talukaMandalSampurnaModel?.loksankhyaformandal?.vibhaagKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('MahaanagarKaaryakartaaCount'),
                          value: talukaMandalSampurnaModel?.loksankhyaformandal?.mahaanagarKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('PraantKaaryakartaaCount'),
                          value2: talukaMandalSampurnaModel?.loksankhyaformandal?.praantKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('KshetraKaaryakartaaCount'),
                          value: talukaMandalSampurnaModel?.loksankhyaformandal?.kshetraKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('AkhilBhaaratiyaKaaryakartaaCount'),
                          value2: talukaMandalSampurnaModel?.loksankhyaformandal?.akhilBhaaratiyaKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('PravaaseeKaaryakartaaCount'),
                          value: talukaMandalSampurnaModel?.loksankhyaformandal?.pravaaseeKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('TotalKaaryakartaaCount'),
                          value2: talukaMandalSampurnaModel?.loksankhyaformandal?.totalKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'GatividhiAayaamSansthaaKaaryakartaaCount',
                      children: [
                        SingleColumnRow(
                            txtString: Statics.getLabel('GatividhiKaaryakartaaCount'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.gatividhiKaaryakartaaCount.toString(), fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('AayaamKaaryakartaaCount'), value: talukaMandalSampurnaModel?.loksankhyaformandal?.aayaamKaaryakartaaCount.toString(), fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('SanghaPreritSansthaaKaaryakartaaCount'),
                            value: talukaMandalSampurnaModel?.loksankhyaformandal?.sanghaPreritSansthaaKaaryakartaaCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('SocialOrganizationKaaryakartaaCount'),
                            value: talukaMandalSampurnaModel?.loksankhyaformandal?.socialOrganizationKaaryakartaaCount.toString(),
                            fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'Gatividhi',
                      children: [
                        Container(
                          // height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (talukaMandalSampurnaModel != null && talukaMandalSampurnaModel?.talukamandalListKaaryakartaaCountByGatividhi != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'गतिविधी',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('count')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukaMandalSampurnaModel!.talukamandalListKaaryakartaaCountByGatividhi!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(child: Text(item.gatividhiName ?? ''))),
                                            DataCell(Center(child: Text(item.kaaryakartaaCount.toString()))),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'Aayaam',
                      children: [
                        Container(
                          // height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (talukaMandalSampurnaModel != null && talukaMandalSampurnaModel?.talukamandalListKaaryakartaaCountByAayaam != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('Aayaam')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('count')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukaMandalSampurnaModel!.talukamandalListKaaryakartaaCountByAayaam!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(child: Text(item.aayaamName ?? ''))),
                                            DataCell(Center(child: Text(item.kaaryakartaaCount.toString()))),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'Sangha-PreritSansthaa',
                      children: [
                        Container(
                          // height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (talukaMandalSampurnaModel != null && talukaMandalSampurnaModel?.talukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('sanghaPreritSanghatana')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('count')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukaMandalSampurnaModel!.talukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(child: Text(item.areaOfOperation ?? ''))),
                                            DataCell(Center(child: Text(item.kaaryakartaaCount.toString()))),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'OtherSocialOrganization',
                      children: [
                        Container(
                          // height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (talukaMandalSampurnaModel != null && talukaMandalSampurnaModel?.talukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('OtherSocialOrganization')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('count')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukaMandalSampurnaModel!.talukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(child: Text(item.areaOfOperation ?? ''))),
                                            DataCell(Center(child: Text(item.kaaryakartaaCount.toString()))),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'StudentCategory',
                      children: [
                        Container(
                          // height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (talukaMandalSampurnaModel != null && talukaMandalSampurnaModel?.talukamandalListSwayamsevakCountByStudentCategory != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('StudentCategory')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('count')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukaMandalSampurnaModel!.talukamandalListSwayamsevakCountByStudentCategory!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(child: Text(item.studentCategoryName ?? ''))),
                                            DataCell(Center(child: Text(item.countByStudentCategory.toString()))),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'VyavasaayeeCategory',
                      children: [
                        Container(
                          // height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (talukaMandalSampurnaModel != null && talukaMandalSampurnaModel?.talukamandalListSwayamsevakCountByVyavasaayeeCategory != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('VyavasaayeeCategory')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('count')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukaMandalSampurnaModel!.talukamandalListSwayamsevakCountByVyavasaayeeCategory!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(child: Text(item.vyavasaayeeCategoryName ?? ''))),
                                            DataCell(Center(child: Text(item.countByVyavasaayeeCategory.toString()))),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ),
                      ],
                    ),
//=====================================================================================================================

                    commonExpansionTile(
                      title: 'religion',
                      children: [
                        Container(
                          // height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (talukaMandalSampurnaModel != null && talukaMandalReligion != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('religion')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('GraamCount')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('kitiMandalat')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukaMandalReligion!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(child: Text(item.value ?? ''))),
                                            DataCell(Center(child: Text(item.gramCount.toString()))),
                                            DataCell(Center(child: Text(item.mandalCount.toString()))),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'UpsanaSthal',
                      children: [
                        Container(
                          // height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (talukaMandalSampurnaModel != null && talukamandalUpasanaSthal != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('UpasanaSthal')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('count')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('GraamCount')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('kitiMandalat')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukamandalUpasanaSthal!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(child: Text(item.value ?? ''))),
                                            DataCell(Center(child: Text(item.sankhya.toString()))),
                                            DataCell(Center(child: Text(item.gramCount.toString()))),
                                            DataCell(Center(child: Text(item.mandalCount.toString()))),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'SajjanShakti',
                      children: [
                        Container(
                          height: 400,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView(
                            children: groupedData.entries.map((entry) {
                              final sajjanType = entry.key;
                              final data = entry.value;

                              // Unique prabhavishetra & samparkashiti
                              final prabhavishetraList = {...data.map((e) => e.prabhavishetra).toSet()}.toList();
                              final samparkList = {...data.map((e) => e.samparkashiti).toSet()}.toList();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Center(
                                    child: Text(
                                      "${Statics.getLabel('SajjanShakti')} (${sajjanType})",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Table(
                                    border: TableBorder.all(),
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    children: [
                                      // Header Row
                                      TableRow(
                                        decoration: BoxDecoration(
                                          color: Colors.purpleAccent.shade200, // Header background
                                        ),
                                        children: [
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                '${Statics.getLabel('SajjanShakti')} ${Statics.getLabel('samparkSthiti')}',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          ...prabhavishetraList.map((header) => Padding(
                                                padding: const EdgeInsets.all(8),
                                                child: Text(
                                                  header!,
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              )),
                                        ],
                                      ),
                                      // Data Rows
                                      ...samparkList.map((sampark) {
                                        return TableRow(
                                          children: [
                                            SizedBox(
                                              width: 140,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8),
                                                child: Text(sampark!),
                                              ),
                                            ),
                                            ...prabhavishetraList.map((prabhav) {
                                              final match = data.firstWhere(
                                                (item) => item.samparkashiti == sampark && item.prabhavishetra == prabhav,
                                                orElse: () => Talukamandalsajjanshakkati(),
                                              );
                                              return Padding(
                                                padding: const EdgeInsets.all(8),
                                                child: Text('${match.vasticnt ?? ''}'),
                                              );
                                            }),
                                          ],
                                        );
                                      }).toList(),
                                      // Total Row
                                      TableRow(
                                        decoration: BoxDecoration(color: Colors.grey.shade200),
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              "${Statics.getLabel('Total')}",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          ...prabhavishetraList.map((prabhav) {
                                            final total = data.where((item) => item.prabhavishetra == prabhav).fold<int>(0, (sum, item) => sum + (item.vasticnt ?? 0));

                                            return Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                '$total',
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'GavatsajareHonareSan',
                      children: [
                        Container(
                          // height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (talukaMandalSampurnaModel != null && talukamandalSana != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('SelectFrequency')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('count')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('GraamCount')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('kitiMandalat')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukamandalSana!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(child: Text(item.value ?? ''))),
                                            DataCell(Center(child: Text(item.sankhya.toString()))),
                                            DataCell(Center(child: Text(item.gramCount.toString()))),
                                            DataCell(Center(child: Text(item.mandalCount.toString()))),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'GavatHonareKaryakram',
                      children: [
                        Container(
                          // height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (talukaMandalSampurnaModel != null && talukaaSamajikKaryakram != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('SelectFrequency')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('count')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('GraamCount')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('kitiMandalat')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukaaSamajikKaryakram!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(child: Text(item.value ?? ''))),
                                            DataCell(Center(child: Text(item.sankhya.toString()))),
                                            DataCell(Center(child: Text(item.gramCount.toString()))),
                                            DataCell(Center(child: Text(item.mandalCount.toString()))),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'DurjanShakti',
                      children: [
                        if (talukaMandalSampurnaModel != null && durjanshakati != null) buildTalukaMandalTable(durjanshakati),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'HinduVeer',
                      children: [
                        SingleChildScrollView(
                            child: Column(
                          children: [
                            if (talukaMandalSampurnaModel != null && talukaMandalSampurnaModel?.talukamandalHinduvirayadi != null)
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor: MaterialStateProperty.resolveWith(
                                      (states) => Colors.purpleAccent[200],
                                    ),
                                    headingTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    columns: [
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              "${Statics.getLabel('hinduVeerCount')}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              "${Statics.getLabel('GraamCount')}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              "${Statics.getLabel('kitiMandalat')}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: [
                                      DataRow(
                                        cells: [
                                          DataCell(Center(child: Text(talukaMandalSampurnaModel!.talukamandalHinduvirayadi!.sankhya.toString()))),
                                          DataCell(Center(child: Text(talukaMandalSampurnaModel!.talukamandalHinduvirayadi!.gramCount.toString()))),
                                          DataCell(Center(child: Text(talukaMandalSampurnaModel!.talukamandalHinduvirayadi!.mandalCount.toString()))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        )),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget vastiMandalDropdown() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        dividerColor: Colors.black,
        expandIconColor: Colors.purpleAccent,
        elevation: 0,
        children: [
          ExpansionPanel(
            backgroundColor: Colors.transparent,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text("${Statics.getLabel('selectStar')}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                trailing: IconButton(
                    onPressed: () {
                      resetData();
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.purpleAccent,
                    )),
              );
            },
            body: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  if (_linkedMahaanagar != null)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 9 || userLevelId == 13),
                      label: Statics.getLabel('Mahaanagar'),
                      value: _linkedMahaanagarValue,
                      items: _linkedMahaanagar!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                      onChanged: (value) async {
                        final item = _linkedMahaanagar!.firstWhere((g) => g.geoUnitID.toString() == value);
                        setState(() {
                          _linkedMahaanagarValue = value;
                          _linkedVibhaagValue = null;
                          _selctedLevel = 'Mahanagar';
                          selctedLevelId = value;
                          _selctedLevelName = item.name ?? "";
                          _selectedGeoUnitId = value;
                        });
                        populatelinkedVibhaagDropdown(value!);
                        populatelinkedBhaagDropdown("");
                      },
                    ),
                  if (_linkedVibhaag != null)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 8 || userLevelId == 13),
                      label: Statics.getLabel('Vibhaag'),
                      value: _linkedVibhaagValue,
                      items: _linkedVibhaag!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                      onChanged: (value) {
                        final item = _linkedVibhaag!.firstWhere((g) => g.geoUnitID.toString() == value);
                        setState(() {
                          _linkedVibhaagValue = value;
                          _selctedLevel = 'Vibhaag';
                          selctedLevelId = value;
                          _selctedLevelName = item.name ?? "";
                          _selectedGeoUnitId = value;
                        });
                        populatelinkedBhaagDropdown(value!);
                      },
                    ),
                  if (_linkedBhaag != null && _linkedBhaag!.isNotEmpty)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 7 || userLevelId == 13),
                      label: Statics.getLabel('Bhaag'),
                      value: _linkedBhaagValue,
                      items: _linkedBhaag!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                      onChanged: (value) {
                        final item = _linkedBhaag!.firstWhere((g) => g.geoUnitID.toString() == value);
                        setState(() {
                          _linkedBhaagValue = value;
                          _selctedLevel = 'Bhaag';
                          selctedLevelId = value;
                          _selctedLevelName = item.name ?? "";
                          _linkedBhaagName = item.name ?? "";
                          _selectedGeoUnitId = value;
                          populatelinkedNagarDropdown(value, null);
                        });
                      },
                    ),
                  // if (_linkedshahar != null && _linkedshahar!.isNotEmpty)
                  //   buildDropdownField(
                  //     isDisabled: MyAppGlobals.isDropdownDisabled('Nagar'),
                  //     label: Statics.getLabel('Shahar'),
                  //     value: _linkedshaharValue,
                  //     items: _linkedshahar!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                  //     onChanged: (value) {
                  //       final item = _linkedshahar!.firstWhere((g) => g.geoUnitID.toString() == value);
                  //       setState(() {
                  //         _linkedshaharValue = value;
                  //         _selectedGeoUnitId = value;
                  //         _selctedLevel = 'Shahar';
                  //         _selctedLevelName = item.name ?? "";
                  //         _linkedshaharName = item.name ?? "";
                  //         populatelinkedNagarDropdown(null, value);
                  //       });
                  //     },
                  //   ),
                  if (_linkedNagar != null && _linkedNagar!.isNotEmpty)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
                      label: Statics.getLabel('Nagar'),
                      value: _linkedNagarValue,
                      items: _linkedNagar!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                      onChanged: (value) {
                        final item = _linkedNagar!.firstWhere((g) => g.geoUnitID.toString() == value);
                        setState(() {
                          _linkedNagarValue = value;
                          _selectedGeoUnitId = value;
                          _selctedLevel = 'Nagar';
                          selctedLevelId = value;
                          _selctedLevelName = item.name ?? "";
                          _linkednagarName = item.name ?? "";
                          populatelinkedMandalDropdown(false, value);
                        });
                      },
                    ),
                  if (_linkedupnagar != null && _linkedupnagar!.isNotEmpty)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
                      label: Statics.getLabel('upnagarUpkhanda'),
                      value: _linkedupnagarValue,
                      items: _linkedupnagar!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: MyAppGlobals.isDropdownDisabled('upnagarUpkhanda')
                          ? (value) {
                              if (value == null) return;
                            }
                          : (value) {
                              final selectedItem = _linkedupnagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _linkedupnagarValue = value;
                                _selectedGeoUnitId = value;
                                _selctedLevel = 'upnagarUpkhanda';
                                selctedLevelId = value;
                                _selctedLevelName = selectedItem.name ?? "";
                                _linkedshaharName = selectedItem.name ?? "";
                                populatelinkedMandalDropdown(true, value);

                                // populatelinkedNagarDropdown(null, value);
                              });
                            },
                    ),
                  if (_linkedmandal != null && _linkedmandal!.isNotEmpty)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 4),
                      label: Statics.getLabel('Mandal'),
                      value: _linkedmandalValue,
                      items: _linkedmandal!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                      onChanged: (value) {
                        final item = _linkedmandal!.firstWhere((g) => g.geoUnitID.toString() == value);
                        setState(() {
                          _linkedmandalValue = value;
                          _selectedGeoUnitId = value.toString();
                          _selctedLevel = 'Mandal';
                          selctedLevelId = value;
                          _selctedLevelName = item.name ?? "";
                          _linkedmandalName = item.name ?? "";
                          // populatelinkedGraamDropdown(value);
                        });
                      },
                    ),

                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                      onPressed: () {
                        // if(selctedLevel == "Vasti" || selctedLevel == "Graam" ){
                        setState(() {
                          isVastiSearch = true;
                          _isExpanded = false;
                        });
                        print("selctedLevel $selctedLevel -- selctedLevelId $selctedLevelId -- selctedLevelName $selctedLevelName");
                        getMyDetailsColumnsAndRows();
                        // }else{
                        //   Statics.showToast(Statics.getLabel('vastiGramValidation'));
                        // }
                      },
                      child: Text("${Statics.getLabel('Filters')}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }

  Widget commonExpansionTile({
    required String title,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent, // removes the expansion line
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
          title: Text(
            Statics.getLabel(title),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          initiallyExpanded: initiallyExpanded,
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
