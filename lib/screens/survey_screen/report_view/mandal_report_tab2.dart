import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/taluka_mandal_model.dart';
import '../../../providers/bals.dart';
import '../../../widgets/single_column_row.dart';
import '../../../widgets/two_column_row.dart';

class MandalSurveyReportViewScreen2 extends StatefulWidget {
  static const String routeName = '/mandal-survey-report-tab2';

  const MandalSurveyReportViewScreen2({super.key});

  @override
  State<MandalSurveyReportViewScreen2> createState() =>
      _MandalSurveyReportViewScreen2State();
}

class _MandalSurveyReportViewScreen2State
    extends State<MandalSurveyReportViewScreen2> {
  @override
  void initState() {
    super.initState();
    populateDropdown();
  }

  bool _isExpanded = true;
  bool isVastiSearch = false;
  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedBhaag;
  List<GeoUnitMasterBAL>? _linkedNagar;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<StaticMasterBAL>? _baithakTypes;
  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedBhaagValue = '';
  String? _linkedNagarValue = '';
  String? _linkedvastiValue = '';
  String? mahanagarId = '';
  String? vibhagId = '';
  String? selctedLevel = 'praant';
  String? selctedLevelName = '';
  String? selctedDropDownLevelName = 'प्रांत';
  String? selctedLevelId = '0';
  List<GeoUnitMasterBAL>? _linkedmandal;
  String? _linkedmandalValue = '';
  String? _linkedgraamValue = '';
  List<GeoUnitMasterBAL>? _linkedgraam;

  void populateDropdown() async {
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    // populatelinkedMahaanagarDropdown();
    populatelinkedVibhaagDropdown('');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!
        .where((element) => element.showAnnualBaithakkey!.contains('1'))
        .toList();
    // print("_baithakTypes :-- $_baithakTypes");
    setState(() {});
  }

  // Future<List<GeoUnitMasterBAL>>  populatelinkedMahaanagarDropdown() async {
  //   var data = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
  //   setState(() {
  //     _linkedMahaanagar = data;
  //   });
  //   return data;
  // }
  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(
      String vibhaagIDStr) async {
    _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParentForMandal(
        Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(
      String mahaanagarIDStr) async {
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParentForMandal(
        Statics.levels['VibhaagLevelID'].toString(),
        mahaanagarIDStr,
        (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'),
        '');
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(
      String? bhaagIDStr, String? shaharIDStr) async {
    _linkedNagarValue = null;
    _linkedNagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParentForMandal(
          Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParentForMandal(
          Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(
      String nagarIDStr) async {
    _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParentForMandal(
        Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
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
        msg: "वस्ती उपलब्ध नाहीयेत",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
      return;
    }

    final List<String> namesList =
        vastiStepStartedNames.split('::').map((e) => e.trim()).toList();

    if (namesList.isEmpty || namesList.first.isEmpty) {
      Fluttertoast.showToast(
        msg: "वस्ती उपलब्ध नाहीयेत",
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
                children: const [
                  Icon(Icons.list_alt, color: Colors.purpleAccent),
                  SizedBox(width: 10),
                  Text(
                    'वस्ती यादी',
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
                  label: const Text('बंद करा'),
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
  List<TalukamandalvividhSampradhaySatsangKendra>?
      talukamandalvividhSampradhaySatsangKendra;
  List<TalukamandalReligion>? talukaMandalReligion;
  List<TalukamandalListSwayamsevakCountByVyavasaayeeCategory>?
      vyavasaayeeCategory;
  List<Talukamandalsajjanshakkati> sajjanList = [];
  List<Talukamandaldurjanshakkati> durjanshakati = [];
  List<TalukamandalSewaPrakalpa> sewaPrakalpa = [];

  void getMyDetailsColumnsAndRows() async {
    talukaMandalSampurnaModel =
        await Statics.vastisarvekshanAllReportDataForMandal(context,
            Statics.userDetails["userID"], selctedLevelId, selctedLevel);
    setState(() {
      data = talukaMandalSampurnaModel!.talukamandalsarvekshanReportwithname;
      talukaaSamajikKaryakram =
          talukaMandalSampurnaModel!.talukamandalSamajikkaryakram;
      talukamandalSana = talukaMandalSampurnaModel!.talukamandalmahatvacesana;
      talukamandalUpasanaSthal =
          talukaMandalSampurnaModel!.talukamandalupaasana;
      talukaMandalReligion = talukaMandalSampurnaModel!.talukamandalReligion;
      vyavasaayeeCategory = talukaMandalSampurnaModel!
          .talukamandalListSwayamsevakCountByVyavasaayeeCategory;
      sajjanList = talukaMandalSampurnaModel!.talukamandalsajjanshakkati!;
      durjanshakati = talukaMandalSampurnaModel!.talukamandaldurjanshakkati!;
      sewaPrakalpa = talukaMandalSampurnaModel!.talukamandalSewaPrakalpa!;
      talukamandalvividhSampradhaySatsangKendra =
          talukaMandalSampurnaModel!.talukamandalvividhSampradhaySatsangKendra!;
    });
  }

  Widget buildTalukaMandalTable(List<Talukamandaldurjanshakkati> dataList) {
    dataList = talukaMandalSampurnaModel!.talukamandaldurjanshakkati ?? [];

    // 1. Get unique subtypes
    final List<String> uniqueSubtypes = dataList
        .map((e) => e.subtype ?? '')
        .toSet()
        .where((s) => s.isNotEmpty)
        .toList();

    // 2. Get unique maintypes
    final List<String> uniqueMaintypes = dataList
        .map((e) => e.maintype ?? '')
        .toSet()
        .where((m) => m.isNotEmpty)
        .toList();

    // 3. Build rows with sankhya values
    List<DataRow> rows = uniqueMaintypes.map((maintype) {
      List<DataCell> cells = [
        DataCell(Text(maintype)), // First column: maintype
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
          const DataColumn(
              label: Text('प्रमुख प्रकार')), // First column: maintype
          ...uniqueSubtypes.map((subtype) => DataColumn(label: Text(subtype))),
        ],
        rows: rows,
      ),
    );
  }

  Widget buildSewaPrakalpaDataTable(List<TalukamandalSewaPrakalpa> dataList) {
    dataList = talukaMandalSampurnaModel!.talukamandalSewaPrakalpa ?? [];

    // 1. Unique subtypes for header columns
    final List<String> uniqueSubtypes = dataList
        .map((e) => e.subtype ?? '')
        .toSet()
        .where((s) => s.isNotEmpty)
        .toList();

    // 2. Unique maintypes for row headers
    final List<String> uniqueMaintypes = dataList
        .map((e) => e.maintype ?? '')
        .toSet()
        .where((m) => m.isNotEmpty)
        .toList();

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
        headingRowColor:
            MaterialStateProperty.all(Colors.purpleAccent.shade200),
        headingTextStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        columns: [
          const DataColumn(label: Text('प्रमुख प्रकार')),
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
              Container(
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
                          title: Text("मंडल निवडा",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
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
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            if (_linkedVibhaag != null)
                              DropdownButtonFormField(
                                decoration: InputDecoration(labelText: "विभाग"),
                                isExpanded: true,
                                value: _linkedVibhaagValue == ""
                                    ? null
                                    : _linkedVibhaagValue,
                                items: _linkedVibhaag!
                                    .map((bg) => DropdownMenuItem(
                                        value: bg.geoUnitID.toString(),
                                        child: Text(bg.name!)))
                                    .toList(),
                                onChanged: (value) {
                                  final selectedItem = _linkedVibhaag!
                                      .firstWhere((bg) =>
                                          bg.geoUnitID.toString() == value);
                                  print(value);
                                  setState(() {
                                    _linkedVibhaagValue = value;
                                    populatelinkedBhaagDropdown(value!);
                                    vibhagId = value;
                                    _linkedBhaagValue =
                                        _linkedNagarValue = null;
                                    _linkedBhaag =
                                        _linkedNagar = _linkedmandal = null;
                                    selctedLevelId = value;
                                    selctedLevelName = selectedItem.name ?? "";
                                    selctedLevel = 'vibhag';
                                    selctedDropDownLevelName = 'विभाग';
                                    _linkedmandalValue = null;
                                  });
                                  print("Selected Id: $value");
                                  print(
                                      "Selected Level Name: ${selectedItem.name}");
                                },
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            if (_linkedBhaag != null)
                              DropdownButtonFormField(
                                decoration:
                                    InputDecoration(labelText: "भाग/जिल्हा"),
                                isExpanded: true,
                                value: _linkedBhaagValue == ""
                                    ? null
                                    : _linkedBhaagValue,
                                items: _linkedBhaag!
                                    .map((bg) => DropdownMenuItem(
                                        value: bg.geoUnitID.toString(),
                                        child: Text(bg.name!)))
                                    .toList(),
                                onChanged: (value) {
                                  final selectedItem = _linkedBhaag!.firstWhere(
                                      (bg) => bg.geoUnitID.toString() == value);
                                  setState(() {
                                    _linkedBhaagValue = value;
                                    populatelinkedNagarDropdown(value, null);
                                    selctedLevelId = value;
                                    selctedLevelName = selectedItem.name ?? "";
                                    selctedLevel = 'bhag';
                                    selctedDropDownLevelName = 'भाग';
                                    _linkedmandalValue = null;
                                  });
                                  print("Selected Id: $value");
                                  print(
                                      "Selected Level Name: ${selectedItem.name}");
                                },
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            if (_linkedNagar != null &&
                                _linkedNagar!.length > 0)
                              DropdownButtonFormField(
                                decoration:
                                    InputDecoration(labelText: "तालुका "),
                                isExpanded: true,
                                value: _linkedNagarValue == ""
                                    ? null
                                    : _linkedNagarValue,
                                items: _linkedNagar!
                                    .map((bg) => DropdownMenuItem(
                                        value: bg.geoUnitID.toString(),
                                        child: Text(bg.name!)))
                                    .toList(),
                                onChanged: (value) {
                                  final selectedItem = _linkedNagar!.firstWhere(
                                      (bg) => bg.geoUnitID.toString() == value);
                                  setState(() {
                                    _linkedNagarValue = value;
                                    populatelinkedMandalDropdown(value!);
                                    selctedLevelId = value;
                                    selctedLevelName = selectedItem.name ?? "";
                                    selctedLevel = 'nagar';
                                    selctedDropDownLevelName = 'तालुका';
                                    _linkedmandalValue = null;
                                  });
                                  print("Selected Id: $value");
                                  print(
                                      "Selected Level Name: ${selectedItem.name}");
                                },
                              ),
                            if (_linkedvasti != null &&
                                _linkedvasti!.length > 0)
                              SizedBox(
                                height: 10,
                              ),
                            if (_linkedmandal != null &&
                                _linkedmandal!.length > 0)
                              DropdownButtonFormField(
                                decoration: InputDecoration(labelText: "मंडल"),
                                isExpanded: true,
                                value: _linkedmandalValue == ""
                                    ? null
                                    : _linkedmandalValue,
                                items: _linkedmandal!
                                    .map((bg) => DropdownMenuItem(
                                        value: bg.geoUnitID.toString(),
                                        child: Text(bg.name!)))
                                    .toList(),
                                onChanged: (value) {
                                  final selectedItem = _linkedmandal!
                                      .firstWhere((bg) =>
                                          bg.geoUnitID.toString() == value);
                                  setState(() {
                                    _linkedmandalValue = value;
                                    selctedLevelId = value;
                                    selctedLevelName = selectedItem.name ?? "";
                                    selctedLevel = 'Mandal';
                                    selctedDropDownLevelName = 'मंडल ';
                                  });
                                  print("Selected Id: $value");
                                  print(
                                      "Selected Level Name: ${selectedItem.name}");
                                },
                              ),
                            if (_linkedmandal != null &&
                                _linkedmandal!.length > 0)
                              SizedBox(
                                height: 10,
                              ),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.purpleAccent)),
                                onPressed: () {
                                  // if(selctedLevel == "Vasti" || selctedLevel == "Graam" ){
                                  setState(() {
                                    isVastiSearch = true;
                                    _isExpanded = false;
                                  });
                                  print(
                                      "selctedLevel $selctedLevel -- selctedLevelId $selctedLevelId -- selctedLevelName $selctedLevelName");
                                  getMyDetailsColumnsAndRows();
                                  // }else{
                                  //   Statics.showToast(Statics.getLabel('vastiGramValidation'));
                                  // }
                                },
                                child: Text("निवडा",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        ),
                      ),
                      isExpanded: _isExpanded,
                    ),
                  ],
                ),
              ),
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
                          style: TextStyle(
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        if (selctedLevelName != "")
                          Text(
                            "-> $selctedLevelName",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
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
                            'सारांश ($selctedDropDownLevelName)',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    if (isVastiSearch == true) Divider(),
                    if (isVastiSearch == true)
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor:
                                MaterialStateProperty.all(Colors.teal.shade100),
                            headingTextStyle: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            columns: const [
                              DataColumn(label: Text('सर्वेक्षण स्थिती')),
                              DataColumn(label: Text('तालुका')),
                              DataColumn(label: Text('मंडल')),
                              DataColumn(label: Text('गाव')),
                              DataColumn(label: Text('')),
                            ],
                            rows: [
                              DataRow(
                                color: MaterialStateProperty.all(
                                    Colors.green.shade50),
                                cells: [
                                  DataCell(
                                      Text('प्राथमिक सर्वेक्षण\nपूर्ण झाले')),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarStep1CompleteCount ?? ""}")),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalStep1CompleteCount ?? ""}")),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vastiStep1CompleteCount ?? ""}")),
                                  DataCell(IconButton(
                                    icon: Icon(Icons.remove_red_eye,
                                        color: Colors.teal),
                                    onPressed: () => showPopupList(
                                        context,
                                        talukaMandalSampurnaModel!
                                            .talukamandalsarvekshanReportwithselectedlevel!
                                            .vastiStep1CompleteNames!
                                            .toString()),
                                  )),
                                ],
                              ),
                              // DataRow(
                              //   color: MaterialStateProperty.all(Colors.green.shade50),
                              //   cells: [
                              //     DataCell(Text('अन्य सर्वेक्षण\nपूर्ण झाले')),
                              //     DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarStep2CompleteCount ?? ""}")),
                              //     DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalStep1CompleteCount ?? ""}")),
                              //     DataCell(Text("${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vastiStep2CompleteCount ?? ""}")),
                              //     DataCell(IconButton(
                              //       icon: Icon(Icons.remove_red_eye, color: Colors.teal),
                              //       onPressed: () => showPopupList(context,
                              //           talukaMandalSampurnaModel!.talukamandalsarvekshanReportwithselectedlevel!.vastiStep2CompleteNames!.toString()),
                              //     )),
                              //   ],
                              // ),
                              DataRow(
                                color: MaterialStateProperty.all(
                                    Colors.green.shade50),
                                cells: [
                                  DataCell(
                                      Text('विस्तृत सर्वेक्षण\nपूर्ण झाले')),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarStep3CompleteCount ?? ""}")),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalStep3CompleteCount ?? ""}")),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vastiStep3CompleteCount ?? ""}")),
                                  DataCell(IconButton(
                                    icon: Icon(Icons.remove_red_eye,
                                        color: Colors.teal),
                                    onPressed: () => showPopupList(
                                        context,
                                        talukaMandalSampurnaModel!
                                            .talukamandalsarvekshanReportwithselectedlevel!
                                            .vastiStep3CompleteNames!
                                            .toString()),
                                  )),
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(
                                    Colors.orange.shade50),
                                cells: [
                                  DataCell(Text('सर्वेक्षण सुरु झाले')),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarStepStartedCount ?? ""}")),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalStepStartedCount ?? ""}")),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vastiStepStartedCount ?? ""}")),
                                  DataCell(IconButton(
                                    icon: Icon(Icons.remove_red_eye,
                                        color: Colors.teal),
                                    onPressed: () => showPopupList(
                                        context,
                                        talukaMandalSampurnaModel!
                                            .talukamandalsarvekshanReportwithselectedlevel!
                                            .vastiStepStartedNames!
                                            .toString()),
                                  )),
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(
                                    Colors.orange.shade50),
                                cells: [
                                  DataCell(Text('सर्वेक्षण पूर्ण झाले')),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarAllStepsCompleteCount ?? ""}")),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalAllStepsCompleteCount ?? ""}")),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vastiAllStepsCompleteCount ?? ""}")),
                                  DataCell(IconButton(
                                    icon: Icon(Icons.remove_red_eye,
                                        color: Colors.teal),
                                    onPressed: () => showPopupList(
                                        context,
                                        talukaMandalSampurnaModel!
                                            .talukamandalsarvekshanReportwithselectedlevel!
                                            .vastiAllStepsCompleteNames!
                                            .toString()),
                                  )),
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(
                                    Colors.orange.shade50),
                                cells: [
                                  DataCell(Text('सर्वेक्षण सुरु\nझाले नाही')),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarStepsNotstartedCount ?? ""}")),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalStepsNotstartedCount ?? ""}")),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vastiStepsNotstartedCount ?? ""}")),
                                  DataCell(IconButton(
                                    icon: Icon(Icons.remove_red_eye,
                                        color: Colors.teal),
                                    onPressed: () => showPopupList(
                                        context,
                                        talukaMandalSampurnaModel!
                                            .talukamandalsarvekshanReportwithselectedlevel!
                                            .vastiStepsNotstartedNames!
                                            .toString()),
                                  )),
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(
                                    Colors.grey.shade200),
                                cells: [
                                  DataCell(Text('एकुण')),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.nagarcount ?? ""}")),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.mandalcount ?? ""}")),
                                  DataCell(Text(
                                      "${talukaMandalSampurnaModel?.talukamandalsarvekshanReportwithselectedlevel?.vasticount ?? ""}")),
                                  DataCell(Text("-")),
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
                        if (talukaMandalSampurnaModel != null)
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
                                itemCount: talukaMandalSampurnaModel
                                        ?.talukamandalsarvekshanReportwithname
                                        ?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  final data = talukaMandalSampurnaModel!
                                          .talukamandalsarvekshanReportwithname![
                                      index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Center(
                                          child: Text(
                                            data.name ?? 'तालुका /मंडल नाव',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: DataTable(
                                            headingRowColor:
                                                MaterialStateProperty.all(Colors
                                                    .purpleAccent.shade100),
                                            headingTextStyle: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            columns: const [
                                              DataColumn(
                                                  label:
                                                      Text('सर्वेक्षण स्थिती')),
                                              DataColumn(label: Text('तालुका')),
                                              DataColumn(label: Text('मंडल')),
                                              DataColumn(label: Text('गाव')),
                                            ],
                                            rows: [
                                              DataRow(
                                                color:
                                                    MaterialStateProperty.all(
                                                        Colors
                                                            .lightBlue.shade50),
                                                cells: [
                                                  DataCell(Text(
                                                      'प्राथमिक सर्वेक्षण\nपूर्ण झाले')),
                                                  DataCell(Text(
                                                      "${data.nagarStep1CompleteCount ?? ""}")),
                                                  DataCell(Text(
                                                      "${data.mandalStep1CompleteCount ?? ""}")),
                                                  DataCell(Text(
                                                      "${data.vastiStep1CompleteCount ?? ""}")),
                                                ],
                                              ),
                                              DataRow(
                                                color:
                                                    MaterialStateProperty.all(
                                                        Colors
                                                            .lightBlue.shade50),
                                                cells: [
                                                  DataCell(Text(
                                                      'विस्तृत सर्वेक्षण\nपूर्ण झाले')),
                                                  DataCell(Text(
                                                      "${data.nagarStep3CompleteCount ?? ""}")),
                                                  DataCell(Text(
                                                      "${data.mandalStep3CompleteCount ?? ""}")),
                                                  DataCell(Text(
                                                      "${data.vastiStep3CompleteCount ?? ""}")),
                                                ],
                                              ),
                                              DataRow(
                                                color:
                                                    MaterialStateProperty.all(
                                                        Colors.red.shade50),
                                                cells: [
                                                  DataCell(Text(
                                                      'सर्वेक्षण सुरु झाले')),
                                                  DataCell(Text(
                                                      "${data.nagarStepStartedCount ?? ""}")),
                                                  DataCell(Text(
                                                      "${data.mandalStepStartedCount ?? ""}")),
                                                  DataCell(Text(
                                                      "${data.vastiStepStartedCount ?? ""}")),
                                                ],
                                              ),
                                              DataRow(
                                                color:
                                                    MaterialStateProperty.all(
                                                        Colors.red.shade50),
                                                cells: [
                                                  DataCell(Text(
                                                      'सर्वेक्षण पूर्ण झाले')),
                                                  DataCell(Text(
                                                      "${data.nagarAllStepsCompleteCount ?? ""}")),
                                                  DataCell(Text(
                                                      "${data.mandalAllStepsCompleteCount ?? ""}")),
                                                  DataCell(Text(
                                                      "${data.vastiAllStepsCompleteCount ?? ""}")),
                                                ],
                                              ),
                                              DataRow(
                                                color:
                                                    MaterialStateProperty.all(
                                                        Colors.red.shade50),
                                                cells: [
                                                  DataCell(Text(
                                                      'सर्वेक्षण सुरु\nझाले नाही')),
                                                  DataCell(Text(
                                                      "${data.nagarStepsNotstartedCount ?? ""}")),
                                                  DataCell(Text(
                                                      "${data.mandalStepsNotstartedCount ?? ""}")),
                                                  DataCell(Text(
                                                      "${data.vastiStepsNotstartedCount ?? ""}")),
                                                ],
                                              ),
                                              DataRow(
                                                color:
                                                    MaterialStateProperty.all(
                                                        Colors.yellow.shade50),
                                                cells: [
                                                  DataCell(Text('एकुण')),
                                                  DataCell(Text(
                                                      "${data.nagarcount ?? ""}")),
                                                  DataCell(Text(
                                                      "${data.mandalcount ?? ""}")),
                                                  DataCell(Text(
                                                      "${data.vasticount ?? ""}")),
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
                        SingleColumnRow(
                            txtString: Statics.getLabel('MandalCount'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal?.mandalCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('GraamCount'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal?.graamcount
                                .toString(),
                            fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'sewaPrakalpa',
                      children: [
                        if (talukaMandalSampurnaModel != null &&
                            sewaPrakalpa != null)
                          buildSewaPrakalpaDataTable(sewaPrakalpa),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'karyamahiti',
                      children: [
                        if (talukaMandalSampurnaModel != null &&
                            talukaMandalSampurnaModel
                                    ?.talukamandalvividhKshetaCheKam !=
                                null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: const [
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          'कार्य संख्या',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          'किती मंडलात',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          'किती गावात',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          'चालवणाऱ्या संस्थांची संख्या',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: [
                                  DataRow(
                                    cells: [
                                      DataCell(Center(
                                          child: Text(talukaMandalSampurnaModel!
                                              .talukamandalvividhKshetaCheKam!
                                              .karyasankhya
                                              .toString()))),
                                      DataCell(Center(
                                          child: Text(talukaMandalSampurnaModel!
                                              .talukamandalvividhKshetaCheKam!
                                              .mandalCount
                                              .toString()))),
                                      DataCell(Center(
                                          child: Text(talukaMandalSampurnaModel!
                                              .talukamandalvividhKshetaCheKam!
                                              .gramCount
                                              .toString()))),
                                      DataCell(Center(
                                          child: Text(talukaMandalSampurnaModel!
                                              .talukamandalvividhKshetaCheKam!
                                              .sankhya
                                              .toString()))),
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
                              if (talukaMandalSampurnaModel != null &&
                                  talukamandalvividhSampradhaySatsangKendra !=
                                      null)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: const [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'संप्रदाय',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'ग्राम संख्या',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'किती मंडलात',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows:
                                          talukamandalvividhSampradhaySatsangKendra!
                                              .map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(item.value ?? ''))),
                                            DataCell(Center(
                                                child: Text(item.gramCount
                                                    .toString()))),
                                            DataCell(Center(
                                                child: Text(item.mandalCount
                                                    .toString()))),
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
                        if (talukaMandalSampurnaModel != null &&
                            talukaMandalSampurnaModel?.talukamandalMumbaikar !=
                                null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: const [
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          'मुंबईकर मंडल असलेली गावे',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          'गावांची संख्या',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          'किती मंडलात',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: [
                                  DataRow(
                                    cells: [
                                      DataCell(Center(
                                          child: Text(talukaMandalSampurnaModel!
                                              .talukamandalHinduvirayadi!
                                              .sankhya
                                              .toString()))),
                                      DataCell(Center(
                                          child: Text(talukaMandalSampurnaModel!
                                              .talukamandalHinduvirayadi!
                                              .gramCount
                                              .toString()))),
                                      DataCell(Center(
                                          child: Text(talukaMandalSampurnaModel!
                                              .talukamandalHinduvirayadi!
                                              .mandalCount
                                              .toString()))),
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
                        SingleColumnRow(
                            txtString:
                                Statics.getLabel('TotalKaaryakartaaCount'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal?.totalKaaryakartaaCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('PratidnyitCount'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal?.pratidnyitCount
                                .toString(),
                            fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'SwayamsevakCountByAge',
                      children: [
                        SingleColumnRow(
                            txtString: Statics.getLabel('Shishu'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal?.shishuCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('Baal'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal?.baalCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('TarunVidyaarthi'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal?.tarunVidyaarthiCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('TarunVyavasaayee'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal?.tarunVyavasaayeeCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('ProudhVyavasaayee'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal?.proudhaVyavasaayeeCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('UnkownAge'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal?.unknownAgeCount
                                .toString(),
                            fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'ShikshitSwayamsevakCount',
                      children: [
                        SingleColumnRow(
                            txtString: Statics.getLabel('PrarambhikShikshit'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal?.prarambhikShikshitCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('PraathamikShikshit'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal?.praathamikShikshitCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('PrathamVarshShikshit'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal
                                ?.prathamVarshaShikshitCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('DwitiyaVarshShikshit'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal
                                ?.dwitiyaVarshaShikshitCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('TrutiyaVarshShikshit'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal
                                ?.trutiyaVarshaShikshitCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('NoShikshan'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal?.noShikshanCount
                                .toString(),
                            fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'KaaryakartaaCountByLevel',
                      children: [
                        TwoColumnRow(
                          txtString: Statics.getLabel('Shaakhaa'),
                          value: talukaMandalSampurnaModel?.loksankhyaformandal
                              ?.dailyShaakhaaKaaryakartaaCount
                              .toString(),
                          txtString2: Statics.getLabel('SaaptaahikLabelShort'),
                          value2: talukaMandalSampurnaModel?.loksankhyaformandal
                              ?.saaptaahikMilanKaaryakartaaCount
                              .toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('MilanMandali'),
                          value: talukaMandalSampurnaModel?.loksankhyaformandal
                              ?.maasikMilanKaaryakartaaCount
                              .toString(),
                          txtString2:
                              Statics.getLabel('VastiKaaryakartaaCount'),
                          value2: talukaMandalSampurnaModel
                              ?.loksankhyaformandal?.vastiKaaryakartaaCount
                              .toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('GraamKaaryakartaaCount'),
                          value: talukaMandalSampurnaModel
                              ?.loksankhyaformandal?.graamKaaryakartaaCount
                              .toString(),
                          txtString2:
                              Statics.getLabel('MandalKaaryakartaaCount'),
                          value2: talukaMandalSampurnaModel
                              ?.loksankhyaformandal?.mandalKaaryakartaaCount
                              .toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('NagarKaaryakartaaCount'),
                          value: talukaMandalSampurnaModel
                              ?.loksankhyaformandal?.nagarKaaryakartaaCount
                              .toString(),
                          txtString2:
                              Statics.getLabel('ShaharKaaryakartaaCount'),
                          value2: talukaMandalSampurnaModel
                              ?.loksankhyaformandal?.shaharKaaryakartaaCount
                              .toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('BhaagKaaryakartaaCount'),
                          value: talukaMandalSampurnaModel
                              ?.loksankhyaformandal?.bhaagKaaryakartaaCount
                              .toString(),
                          txtString2:
                              Statics.getLabel('VibhaagKaaryakartaaCount'),
                          value2: talukaMandalSampurnaModel
                              ?.loksankhyaformandal?.vibhaagKaaryakartaaCount
                              .toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString:
                              Statics.getLabel('MahaanagarKaaryakartaaCount'),
                          value: talukaMandalSampurnaModel
                              ?.loksankhyaformandal?.mahaanagarKaaryakartaaCount
                              .toString(),
                          txtString2:
                              Statics.getLabel('PraantKaaryakartaaCount'),
                          value2: talukaMandalSampurnaModel
                              ?.loksankhyaformandal?.praantKaaryakartaaCount
                              .toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString:
                              Statics.getLabel('KshetraKaaryakartaaCount'),
                          value: talukaMandalSampurnaModel
                              ?.loksankhyaformandal?.kshetraKaaryakartaaCount
                              .toString(),
                          txtString2: Statics.getLabel(
                              'AkhilBhaaratiyaKaaryakartaaCount'),
                          value2: talukaMandalSampurnaModel?.loksankhyaformandal
                              ?.akhilBhaaratiyaKaaryakartaaCount
                              .toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString:
                              Statics.getLabel('PravaaseeKaaryakartaaCount'),
                          value: talukaMandalSampurnaModel
                              ?.loksankhyaformandal?.pravaaseeKaaryakartaaCount
                              .toString(),
                          txtString2:
                              Statics.getLabel('TotalKaaryakartaaCount'),
                          value2: talukaMandalSampurnaModel
                              ?.loksankhyaformandal?.totalKaaryakartaaCount
                              .toString(),
                          fontsize: 15,
                        ),
                      ],
                    ),
//--------------------------------------------------------------------------------------------------------------------------
                    commonExpansionTile(
                      title: 'GatividhiAayaamSansthaaKaaryakartaaCount',
                      children: [
                        SingleColumnRow(
                            txtString:
                                Statics.getLabel('GatividhiKaaryakartaaCount'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal
                                ?.gatividhiKaaryakartaaCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString:
                                Statics.getLabel('AayaamKaaryakartaaCount'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal?.aayaamKaaryakartaaCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel(
                                'SanghaPreritSansthaaKaaryakartaaCount'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal
                                ?.sanghaPreritSansthaaKaaryakartaaCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel(
                                'SocialOrganizationKaaryakartaaCount'),
                            value: talukaMandalSampurnaModel
                                ?.loksankhyaformandal
                                ?.socialOrganizationKaaryakartaaCount
                                .toString(),
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
                              if (talukaMandalSampurnaModel != null &&
                                  talukaMandalSampurnaModel
                                          ?.talukamandalListKaaryakartaaCountByGatividhi !=
                                      null)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: const [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'गतिविधी',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'संख्या',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukaMandalSampurnaModel!
                                          .talukamandalListKaaryakartaaCountByGatividhi!
                                          .map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(
                                                    item.gatividhiName ?? ''))),
                                            DataCell(Center(
                                                child: Text(item
                                                    .kaaryakartaaCount
                                                    .toString()))),
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
                              if (talukaMandalSampurnaModel != null &&
                                  talukaMandalSampurnaModel
                                          ?.talukamandalListKaaryakartaaCountByAayaam !=
                                      null)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: const [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'आयाम',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'संख्या',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukaMandalSampurnaModel!
                                          .talukamandalListKaaryakartaaCountByAayaam!
                                          .map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(
                                                    item.aayaamName ?? ''))),
                                            DataCell(Center(
                                                child: Text(item
                                                    .kaaryakartaaCount
                                                    .toString()))),
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
                              if (talukaMandalSampurnaModel != null &&
                                  talukaMandalSampurnaModel
                                          ?.talukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation !=
                                      null)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: const [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'संघ प्रेरित संघटना / संस्था',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'संख्या',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukaMandalSampurnaModel!
                                          .talukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!
                                          .map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(
                                                    item.areaOfOperation ??
                                                        ''))),
                                            DataCell(Center(
                                                child: Text(item
                                                    .kaaryakartaaCount
                                                    .toString()))),
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
                              if (talukaMandalSampurnaModel != null &&
                                  talukaMandalSampurnaModel
                                          ?.talukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation !=
                                      null)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: const [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'अन्य सामाजिक संस्था',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'संख्या',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukaMandalSampurnaModel!
                                          .talukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!
                                          .map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(
                                                    item.areaOfOperation ??
                                                        ''))),
                                            DataCell(Center(
                                                child: Text(item
                                                    .kaaryakartaaCount
                                                    .toString()))),
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
                              if (talukaMandalSampurnaModel != null &&
                                  talukaMandalSampurnaModel
                                          ?.talukamandalListSwayamsevakCountByStudentCategory !=
                                      null)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: const [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'विद्यार्थी श्रेणी',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'संख्या',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukaMandalSampurnaModel!
                                          .talukamandalListSwayamsevakCountByStudentCategory!
                                          .map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(
                                                    item.studentCategoryName ??
                                                        ''))),
                                            DataCell(Center(
                                                child: Text(item
                                                    .countByStudentCategory
                                                    .toString()))),
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
                              if (talukaMandalSampurnaModel != null &&
                                  talukaMandalSampurnaModel
                                          ?.talukamandalListSwayamsevakCountByVyavasaayeeCategory !=
                                      null)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: const [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'व्यवसायी श्रेणी',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'संख्या',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukaMandalSampurnaModel!
                                          .talukamandalListSwayamsevakCountByVyavasaayeeCategory!
                                          .map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(
                                                    item.vyavasaayeeCategoryName ??
                                                        ''))),
                                            DataCell(Center(
                                                child: Text(item
                                                    .countByVyavasaayeeCategory
                                                    .toString()))),
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
                              if (talukaMandalSampurnaModel != null &&
                                  talukaMandalReligion != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: const [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'रिलीजन',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'गावांची संख्या',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'किती मंडलात',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukaMandalReligion!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(item.value ?? ''))),
                                            DataCell(Center(
                                                child: Text(item.gramCount
                                                    .toString()))),
                                            DataCell(Center(
                                                child: Text(item.mandalCount
                                                    .toString()))),
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
                              if (talukaMandalSampurnaModel != null &&
                                  talukamandalUpasanaSthal != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: const [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'उपासना स्थळ',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'संख्या',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'गावांची संख्या',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'किती मंडलात',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows:
                                          talukamandalUpasanaSthal!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(item.value ?? ''))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.sankhya.toString()))),
                                            DataCell(Center(
                                                child: Text(item.gramCount
                                                    .toString()))),
                                            DataCell(Center(
                                                child: Text(item.mandalCount
                                                    .toString()))),
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
                              final prabhavishetraList = {
                                ...data.map((e) => e.prabhavishetra).toSet()
                              }.toList();
                              final samparkList = {
                                ...data.map((e) => e.samparkashiti).toSet()
                              }.toList();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Center(
                                    child: Text(
                                      "सज्जन शक्ती (${sajjanType})",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Table(
                                    border: TableBorder.all(),
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    children: [
                                      // Header Row
                                      TableRow(
                                        decoration: BoxDecoration(
                                          color: Colors.purpleAccent
                                              .shade200, // Header background
                                        ),
                                        children: [
                                          const TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                'सज्जन शक्ती संपर्क स्थिती',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          ...prabhavishetraList
                                              .map((header) => Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Text(
                                                      header!,
                                                      style: TextStyle(
                                                          color: Colors.white),
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
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Text(sampark!),
                                              ),
                                            ),
                                            ...prabhavishetraList
                                                .map((prabhav) {
                                              final match = data.firstWhere(
                                                (item) =>
                                                    item.samparkashiti ==
                                                        sampark &&
                                                    item.prabhavishetra ==
                                                        prabhav,
                                                orElse: () =>
                                                    Talukamandalsajjanshakkati(),
                                              );
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Text(
                                                    '${match.vasticnt ?? ''}'),
                                              );
                                            }),
                                          ],
                                        );
                                      }).toList(),
                                      // Total Row
                                      TableRow(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade200),
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              'एकूण',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          ...prabhavishetraList.map((prabhav) {
                                            final total = data
                                                .where((item) =>
                                                    item.prabhavishetra ==
                                                    prabhav)
                                                .fold<int>(
                                                    0,
                                                    (sum, item) =>
                                                        sum +
                                                        (item.vasticnt ?? 0));

                                            return Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                '$total',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                              if (talukaMandalSampurnaModel != null &&
                                  talukamandalSana != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: const [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'प्रकार',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'संख्या',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'गावांची संख्या',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'किती मंडलात',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: talukamandalSana!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(item.value ?? ''))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.sankhya.toString()))),
                                            DataCell(Center(
                                                child: Text(item.gramCount
                                                    .toString()))),
                                            DataCell(Center(
                                                child: Text(item.mandalCount
                                                    .toString()))),
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
                              if (talukaMandalSampurnaModel != null &&
                                  talukaaSamajikKaryakram != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: const [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'प्रकार',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'संख्या',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'गावांची संख्या',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'किती मंडलात',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows:
                                          talukaaSamajikKaryakram!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(item.value ?? ''))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.sankhya.toString()))),
                                            DataCell(Center(
                                                child: Text(item.gramCount
                                                    .toString()))),
                                            DataCell(Center(
                                                child: Text(item.mandalCount
                                                    .toString()))),
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
                        if (talukaMandalSampurnaModel != null &&
                            durjanshakati != null)
                          buildTalukaMandalTable(durjanshakati),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'HinduVeer',
                      children: [
                        SingleChildScrollView(
                            child: Column(
                          children: [
                            if (talukaMandalSampurnaModel != null &&
                                talukaMandalSampurnaModel
                                        ?.talukamandalHinduvirayadi !=
                                    null)
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor:
                                        MaterialStateProperty.resolveWith(
                                      (states) => Colors.purpleAccent[200],
                                    ),
                                    headingTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    columns: const [
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              'हिंदु वीर संख्या',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              'गावांची संख्या',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              'किती मंडलात',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: [
                                      DataRow(
                                        cells: [
                                          DataCell(Center(
                                              child: Text(
                                                  talukaMandalSampurnaModel!
                                                      .talukamandalHinduvirayadi!
                                                      .sankhya
                                                      .toString()))),
                                          DataCell(Center(
                                              child: Text(
                                                  talukaMandalSampurnaModel!
                                                      .talukamandalHinduvirayadi!
                                                      .gramCount
                                                      .toString()))),
                                          DataCell(Center(
                                              child: Text(
                                                  talukaMandalSampurnaModel!
                                                      .talukamandalHinduvirayadi!
                                                      .mandalCount
                                                      .toString()))),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
