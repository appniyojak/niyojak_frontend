import 'package:flutter/material.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/vasti_survey_report_model.dart';
import '../../../providers/bals.dart';
import '../../../widgets/single_column_row.dart';
import '../../../widgets/two_column_row.dart';

class MandalSurveyReportViewScreen3 extends StatefulWidget {
  static const String routeName = '/mandal-survey-report-tab3';

  const MandalSurveyReportViewScreen3({super.key});

  @override
  State<MandalSurveyReportViewScreen3> createState() =>
      _MandalSurveyReportViewScreen3State();
}

class _MandalSurveyReportViewScreen3State
    extends State<MandalSurveyReportViewScreen3> {
  @override
  void initState() {
    super.initState();
    populateDropdown();
    getGeoUnitID();
    // getMyDetailsColumnsAndRows();
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
  String? selctedLevelId = '';
  String? selctedLevelNameNew = '';
  String? selctedLevelIdNew = '';
  String? _linkedgraamValue = '';
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedmandal;
  String? _linkedmandalValue = '';

  //=====================================  NEW  ADD ========================================================================================
  final rowTitles = [
    "${Statics.getLabel('Shaakhaa')}",
    "${Statics.getLabel('SaaptaahikMilan')}",
    "${Statics.getLabel('MaasikMilan')}",
    "${Statics.getLabel('isNewSankalpitShakha')}",
    "${Statics.getLabel('isNewSankalpitSaptahikMilan')}",
    "${Statics.getLabel('isNewSankalpitMaasikMilan')}",
    "${Statics.getLabel('purviShakhaHoti')}",
    "${Statics.getLabel('isBeforeSaaptahikMilan')}",
  ];
  String getCellValueByRowIndex(SanghaKaryaStithiData e, int index) {
    switch (index) {
      case 0:
        return (e.shaakhaaCount ?? 0).toString();
      case 1:
        return (e.saaptaahikCount ?? 0).toString();
      case 2:
        return (e.maasikMilanCount ?? 0).toString();
      case 3:
        return (e.sankalpitShaakhaaCount ?? 0).toString();
      case 4:
        return (e.sankalpitSaaptaahikCount ?? 0).toString();
      case 5:
        return (e.sankalpitMaasikMilanCount ?? 0).toString();
      case 6:
        return e.purviShaakhaa?.isNotEmpty == true ? e.purviShaakhaa! : '-';
      case 7:
        return e.purviSaptahik?.isNotEmpty == true ? e.purviSaptahik! : '-';
      default:
        return '';
    }
  }

  var geoUnitID;
  var geoUnitName;

  void populateDropdown() async {
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    populatelinkedMahaanagarDropdown();
    populatelinkedVibhaagDropdown('');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!
        .where((element) => element.showAnnualBaithakkey!.contains('1'))
        .toList();
    // print("_baithakTypes :-- $_baithakTypes");
    setState(() {});
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParentForMandal(
        Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

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

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(
      String mandalIDStr) async {
    _linkedgraamValue = null;
    print("mandalIDStr mandalIDStr ==> $mandalIDStr");
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    // log("_linkedgraam_linkedgraam --> $_linkedgraam");
    return gmDD;
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
      selctedLevelId = '';
      selctedLevelName = "";
      _linkedBhaag = null;
      _linkedNagar = null;
      _linkedvasti = null;
      isVastiSearch = false;
      selctedLevelName = '';
      _isExpanded = false;
      vastiSurveyReportModel = null;
      populateDropdown();
    });
  }

  void getGeoUnitID() async {
    setState(() {
      geoUnitID = Statics.userDetails["DaayitvaGeoUnitID"];
      geoUnitName = Statics.userDetails["DaayitvaGeoUnitName"] +
          "-" +
          Statics.userDetails["LevelName"];
    });
  }

  Widget buildTransposedTable(List<SanghaKaryaStithiData> dataList) {
    final columns = <DataColumn>[
      DataColumn(
        label: Text(
          "${Statics.getLabel('sanghaKaryaStithi')}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      ...dataList.map((e) => DataColumn(
            label: Text(
              e.vayogatCode.toString(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )),
      DataColumn(
        label: Text(
          "${Statics.getLabel('Total')}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ];

    // Helper to get total of each row
    int rowSum(List<int> list) => list.fold(0, (a, b) => a + b);

    // Prepare data rows
    final rows = <DataRow>[
      DataRow(cells: [
        DataCell(Text("${Statics.getLabel('shaakhaaYukta')}")),
        ...dataList
            .map((e) => DataCell(Text((e.shaakhaaCount ?? 0).toString()))),
        DataCell(Text(rowSum(dataList.map((e) => e.shaakhaaCount ?? 0).toList())
            .toString())),
      ]),
      DataRow(cells: [
        DataCell(Text("${Statics.getLabel('saaptahikMilanyukta')}")),
        ...dataList
            .map((e) => DataCell(Text((e.saaptaahikCount ?? 0).toString()))),
        DataCell(Text(
            rowSum(dataList.map((e) => e.saaptaahikCount ?? 0).toList())
                .toString())),
      ]),
      DataRow(cells: [
        DataCell(Text("${Statics.getLabel('MaasikYuktaLabel')}")),
        ...dataList
            .map((e) => DataCell(Text((e.maasikMilanCount ?? 0).toString()))),
        DataCell(Text(
            rowSum(dataList.map((e) => e.maasikMilanCount ?? 0).toList())
                .toString())),
      ]),
      DataRow(cells: [
        DataCell(Text("${Statics.getLabel('isNewSankalpitShakha')}")),
        ...dataList.map(
            (e) => DataCell(Text((e.sankalpitShaakhaaCount ?? 0).toString()))),
        DataCell(Text(
            rowSum(dataList.map((e) => e.sankalpitShaakhaaCount ?? 0).toList())
                .toString())),
      ]),
      DataRow(cells: [
        DataCell(Text("${Statics.getLabel('isNewSankalpitSaptahikMilan')}")),
        ...dataList.map((e) =>
            DataCell(Text((e.sankalpitSaaptaahikCount ?? 0).toString()))),
        DataCell(Text(rowSum(
                dataList.map((e) => e.sankalpitSaaptaahikCount ?? 0).toList())
            .toString())),
      ]),
      DataRow(cells: [
        DataCell(Text("${Statics.getLabel('isNewSankalpitMaasikMilan')}")),
        ...dataList.map((e) =>
            DataCell(Text((e.sankalpitMaasikMilanCount ?? 0).toString()))),
        DataCell(Text(rowSum(
                dataList.map((e) => e.sankalpitMaasikMilanCount ?? 0).toList())
            .toString())),
      ]),
      DataRow(cells: [
        DataCell(Text("${Statics.getLabel('Total')}")),
        ...dataList.map((e) {
          final total = (e.shaakhaaCount ?? 0) +
              (e.saaptaahikCount ?? 0) +
              (e.maasikMilanCount ?? 0) +
              (e.sankalpitShaakhaaCount ?? 0) +
              (e.sankalpitSaaptaahikCount ?? 0) +
              (e.sankalpitMaasikMilanCount ?? 0);
          return DataCell(Text(total.toString()));
        }),
        // Row total
        DataCell(Text(rowSum(dataList.map((e) {
          return (e.shaakhaaCount ?? 0) +
              (e.saaptaahikCount ?? 0) +
              (e.maasikMilanCount ?? 0) +
              (e.sankalpitShaakhaaCount ?? 0) +
              (e.sankalpitSaaptaahikCount ?? 0) +
              (e.sankalpitMaasikMilanCount ?? 0);
        }).toList())
            .toString())),
      ]),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor:
            MaterialStateProperty.all(Colors.purpleAccent.shade100),
        columns: columns,
        rows: rows,
      ),
    );
  }

  VastiSurveyReportModel? vastiSurveyReportModel;
  Vastisarvekshan? data;
  void getMyDetailsColumnsAndRows() async {
    vastiSurveyReportModel = await Statics.vastisarvekshanReportData(
        context, Statics.userDetails["userID"], selctedLevelId);
    setState(() {
      data = vastiSurveyReportModel!.vastisarvekshan;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sanghaData = data?.sanghaKaryaStithiData ?? [];
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
                          title: Text("${Statics.getLabel('selectStar')}",
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
                                decoration: InputDecoration(
                                    labelText:
                                        "${Statics.getLabel('Vibhaag')}"),
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
                                    _linkedBhaag = _linkedNagar = null;
                                    selctedLevelId = value;
                                    selctedLevelName = selectedItem.name ?? "";
                                    selctedLevel = 'Vibhaag';
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
                                decoration: InputDecoration(
                                    labelText: "${Statics.getLabel('Bhaag')}"),
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
                                    selctedLevel = 'Bhaag';
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
                                decoration: InputDecoration(
                                    labelText:
                                        "${Statics.getLabel('taalukaa')}"),
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
                                    selctedLevel = 'Nagar';
                                  });
                                  print("Selected Id: $value");
                                  print(
                                      "Selected Level Name: ${selectedItem.name}");
                                },
                              ),
                            if (_linkedNagar != null &&
                                _linkedNagar!.length > 0)
                              SizedBox(
                                height: 10,
                              ),
                            if (_linkedmandal != null &&
                                _linkedmandal!.length > 0)
                              DropdownButtonFormField(
                                decoration: InputDecoration(
                                    labelText: "${Statics.getLabel('Mandal')}"),
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
                                    populatelinkedGraamDropdown(value!);
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
                            if (_linkedgraam != null &&
                                _linkedgraam!.length > 0)
                              DropdownButtonFormField(
                                decoration: InputDecoration(
                                    labelText: "${Statics.getLabel('gaav')}"),
                                isExpanded: true,
                                value: _linkedgraamValue == ""
                                    ? null
                                    : _linkedgraamValue,
                                items: _linkedgraam!
                                    .map((bg) => DropdownMenuItem(
                                        value: bg.geoUnitID.toString(),
                                        child: Text(bg.name!)))
                                    .toList(),
                                onChanged: (value) {
                                  final selectedItem = _linkedgraam!.firstWhere(
                                      (bg) => bg.geoUnitID.toString() == value);
                                  setState(() {
                                    _linkedgraamValue = value;
                                    selctedLevelId = value;
                                    selctedLevelName = selectedItem.name ?? "";
                                    selctedLevel = 'Graam';
                                  });
                                  print("Selected Id: $value");
                                  print(
                                      "Selected Level Name: ${selectedItem.name}");
                                },
                              ),
                            if (_linkedgraam != null &&
                                _linkedgraam!.length > 0)
                              SizedBox(
                                height: 10,
                              ),
                            if (selctedLevel == "Graam")
                              Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.purpleAccent)),
                                  onPressed: () {
                                    if (selctedLevel == "Graam") {
                                      setState(() {
                                        isVastiSearch = true;
                                        _isExpanded = false;
                                      });
                                      print(
                                          "selctedLevel $selctedLevel -- selctedLevelId $selctedLevelId -- selctedLevelName $selctedLevelName");
                                      getMyDetailsColumnsAndRows();
                                    } else {
                                      Statics.showToast(
                                          Statics.getLabel('mandalValidation'));
                                    }
                                  },
                                  child: Text("${Statics.getLabel('Filters')}",
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
              SizedBox(
                height: 10,
              ),
              if (selctedLevel == "Graam" &&
                  selctedLevelName != "" &&
                  isVastiSearch == true)
                SizedBox(
                  height: 20,
                ),
              if (selctedLevel == "Graam" &&
                  selctedLevelName != "" &&
                  isVastiSearch == true)
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
                          "${Statics.getLabel('gaav')} ->  ",
                          style: TextStyle(
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text(
                          " $selctedLevelName",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ],
                    )),
              if (isVastiSearch == true)
                SizedBox(
                  height: 20,
                ),
              if (isVastiSearch == true)
                SizedBox(
                  height: 20,
                ),
//=============================================================================================================================================================
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    commonExpansionTile(
                      title: 'SewaPrakalpa',
                      children: [
                        if (data != null && data!.vastisarSewaPrakalpa != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
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
                                columnSpacing: 20,
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('SelectFrequency')}")),
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('chalavnariSanstha')}")),
                                ],
                                rows: data!.vastisarSewaPrakalpa!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(
                                          item.selectedDropdownValueName ??
                                              '')),
                                      DataCell(Text(
                                          item.selectedDropdownValueName1 ??
                                              '')),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'mandalSarvekshanSankalan',
                      children: [
                        SingleColumnRow(
                            txtString: Statics.getLabel('purviShakhaHoti'),
                            value: data?.purviShakhaHotiCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('purviSaptahikMilan'),
                            value: data?.purviSptahikMilanHoteCount.toString(),
                            fontsize: 15),
                        if (data != null && data?.sanghaKaryaStithiData != null)
                          buildTransposedTable(data!.sanghaKaryaStithiData!),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'anyaVividhKshetra',
                      children: [
                        if (data != null &&
                            data!.vastisarvividhKshetaCheKam != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
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
                                columnSpacing: 20,
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('kaarya')}")),
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('chalavnariSansthaSanghatana')}")),
                                ],
                                rows: data!.vastisarvividhKshetaCheKam!
                                    .map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.kaam ?? '')),
                                      DataCell(Text(
                                          item.chalavnariSansthaSanghatamn ??
                                              '')),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'satsangKendra',
                      children: [
                        if (data != null &&
                            data!.vastisarvividhSampradhaySatsangKendra != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
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
                                columnSpacing: 20,
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('sanstha')}")),
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('gaavPramukh')}")),
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('doorBhash')}")),
                                ],
                                rows: data!
                                    .vastisarvividhSampradhaySatsangKendra!
                                    .map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(
                                          item.selectedDropdownValueName ??
                                              '')),
                                      DataCell(
                                          Text(item.gaavPramukhName ?? '')),
                                      DataCell(Text(item.samparkSootra ?? '')),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'mumbaikarMandal',
                      children: [
                        if (data != null &&
                            data!.vastisargavatilMumbaikar != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
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
                                columnSpacing: 20,
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('sthaan')}")),
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('pramukhaacheNaav')}")),
                                ],
                                rows:
                                    data!.vastisargavatilMumbaikar!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.sthaan ?? '')),
                                      DataCell(
                                          Text(item.pramukhachrNaav ?? '')),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'GraamInfo',
                      children: [
                        SingleColumnRow(
                            txtString:
                                "${Statics.getLabel('SarpanchacheNaav')}",
                            value: data?.vastiPramukhName,
                            fontsize: 15),
                        SingleColumnRow(
                            txtString:
                                "${Statics.getLabel('gavSadyasyaSamitiCount')}",
                            value: data?.vastiSamitiSadhyasyaCount.toString(),
                            fontsize: 15),
                        // SingleColumnRow(txtString: "गावातील सेवा वस्त्यां (किती ?)", value: data?.vastiSewaVastiCount.toString(), fontsize: 15),
                        SingleColumnRow(
                            txtString:
                                "${Statics.getLabel('gaavachiLoksankhya')}",
                            value: data?.vastichiLoksankhyaCount,
                            fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'SwayamsevakCount',
                      children: [
                        SingleColumnRow(
                            txtString:
                                Statics.getLabel('TotalKaaryakartaaCount'),
                            value: data?.totalSwayamsevakCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('PratidnyitCount'),
                            value: data?.pratidnyitCount.toString(),
                            fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'SwayamsevakCountByAge',
                      children: [
                        SingleColumnRow(
                            txtString: Statics.getLabel('Shishu'),
                            value: data?.shishuCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('Baal'),
                            value: data?.baalCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('TarunVidyaarthi'),
                            value: data?.tarunVidyaarthiCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('TarunVyavasaayee'),
                            value: data?.tarunVyavasaayeeCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('ProudhVyavasaayee'),
                            value: data?.proudhaVyavasaayeeCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('UnkownAge'),
                            value: data?.unknownAgeCount.toString(),
                            fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'ShikshitSwayamsevakCount',
                      children: [
                        SingleColumnRow(
                            txtString: Statics.getLabel('PrarambhikShikshit'),
                            value: data?.prarambhikShikshitCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('PraathamikShikshit'),
                            value: data?.praathamikShikshitCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('PrathamVarshShikshit'),
                            value: data?.prathamVarshaShikshitCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('DwitiyaVarshShikshit'),
                            value: data?.dwitiyaVarshaShikshitCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('TrutiyaVarshShikshit'),
                            value: data?.trutiyaVarshaShikshitCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('NoShikshan'),
                            value: data?.noShikshanCount.toString(),
                            fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'KaaryakartaaCountByLevel',
                      children: [
                        TwoColumnRow(
                          txtString: Statics.getLabel('Shaakhaa'),
                          value:
                              data?.dailyShaakhaaKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('SaaptaahikLabelShort'),
                          value2:
                              data?.saaptaahikMilanKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('MilanMandali'),
                          value: data?.maasikMilanKaaryakartaaCount.toString(),
                          txtString2:
                              Statics.getLabel('VastiKaaryakartaaCount'),
                          value2: data?.vastiKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('GraamKaaryakartaaCount'),
                          value: data?.graamKaaryakartaaCount.toString(),
                          txtString2:
                              Statics.getLabel('MandalKaaryakartaaCount'),
                          value2: data?.mandalKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('NagarKaaryakartaaCount'),
                          value: data?.nagarKaaryakartaaCount.toString(),
                          txtString2:
                              Statics.getLabel('ShaharKaaryakartaaCount'),
                          value2: data?.shaharKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('BhaagKaaryakartaaCount'),
                          value: data?.bhaagKaaryakartaaCount.toString(),
                          txtString2:
                              Statics.getLabel('VibhaagKaaryakartaaCount'),
                          value2: data?.vibhaagKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString:
                              Statics.getLabel('MahaanagarKaaryakartaaCount'),
                          value: data?.mahaanagarKaaryakartaaCount.toString(),
                          txtString2:
                              Statics.getLabel('PraantKaaryakartaaCount'),
                          value2: data?.praantKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString:
                              Statics.getLabel('KshetraKaaryakartaaCount'),
                          value: data?.kshetraKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel(
                              'AkhilBhaaratiyaKaaryakartaaCount'),
                          value2:
                              data?.akhilBhaaratiyaKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString:
                              Statics.getLabel('PravaaseeKaaryakartaaCount'),
                          value: data?.pravaaseeKaaryakartaaCount.toString(),
                          txtString2:
                              Statics.getLabel('TotalKaaryakartaaCount'),
                          value2: data?.totalKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'GatividhiAayaamSansthaaKaaryakartaaCount',
                      children: [
                        SingleColumnRow(
                            txtString:
                                Statics.getLabel('GatividhiKaaryakartaaCount'),
                            value: data?.gatividhiKaaryakartaaCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString:
                                Statics.getLabel('AayaamKaaryakartaaCount'),
                            value: data?.aayaamKaaryakartaaCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel(
                                'SanghaPreritSansthaaKaaryakartaaCount'),
                            value: data?.sanghaPreritSansthaaKaaryakartaaCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel(
                                'SocialOrganizationKaaryakartaaCount'),
                            value: data?.socialOrganizationKaaryakartaaCount
                                .toString(),
                            fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'Gatividhi',
                      children: [
                        if (data != null &&
                            data!.listKaaryakartaaCountByGatividhi != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
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
                                columns: [
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('Gatividhi')}")),
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('KaaryakartaaCount')}")),
                                ],
                                rows: data!.listKaaryakartaaCountByGatividhi!
                                    .map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.gatividhiName ?? '')),
                                      DataCell(Center(
                                          child: Text(item.kaaryakartaaCount
                                                  .toString() ??
                                              "0"))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'Aayaam',
                      children: [
                        if (data != null &&
                            data!.listKaaryakartaaCountByAayaam != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
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
                                columns: [
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('Aayaam')}")),
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('KaaryakartaaCount')}")),
                                ],
                                rows: data!.listKaaryakartaaCountByAayaam!
                                    .map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.aayaamName ?? '')),
                                      DataCell(Center(
                                          child: Text(item.kaaryakartaaCount
                                                  .toString() ??
                                              "0"))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'Sangha-PreritSansthaa',
                      children: [
                        if (data != null &&
                            data!.listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation !=
                                null)
                          Container(
                            // margin: const EdgeInsets.all(16),
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
                                columns: [
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('sanghaPreritSanghatana')}")),
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('KaaryakartaaCount')}")),
                                ],
                                rows: data!
                                    .listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!
                                    .map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                          Text(item.areaOfOperation ?? '')),
                                      DataCell(Center(
                                          child: Text(item.kaaryakartaaCount
                                                  .toString() ??
                                              "0"))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'OtherSocialOrganization',
                      children: [],
                    ),
                    commonExpansionTile(
                      title: 'StudentCategory',
                      children: [
                        if (data != null &&
                            data!.listSwayamsevakCountByStudentCategory != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
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
                                columns: [
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('StudentCategory')}")),
                                  DataColumn(
                                      label:
                                          Text("${Statics.getLabel('count')}")),
                                ],
                                rows: data!
                                    .listSwayamsevakCountByStudentCategory!
                                    .map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                          Text(item.studentCategoryName ?? '')),
                                      DataCell(Center(
                                          child: Text(item
                                                  .countByStudentCategory
                                                  .toString() ??
                                              "0"))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'VyavasaayeeCategory',
                      children: [],
                    ),
                    commonExpansionTile(
                      title: 'religion',
                      children: [
                        Container(
                          // height: 500,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (data != null &&
                                  data!.vastiKontyaReligion != null)
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
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('religion')}",
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
                                                "${Statics.getLabel('vastiCount')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: data!.vastiKontyaReligion!
                                          .map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(
                                                    item.selectedDropdownValueName ??
                                                        ''))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.andaje.toString()))),
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
                    // commonExpansionTile(
                    //   title: 'sanghaKaryaStithi',
                    //   children: [
                    //     if (data != null && data!.sanghaKaryaStithiData != null)
                    //       Row(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           DataTable(
                    //             headingRowColor: MaterialStateProperty.all(
                    //                 Colors.purpleAccent[200]),
                    //             headingTextStyle: TextStyle(
                    //                 color: Colors.white,
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 15),
                    //             columns: [
                    //               DataColumn(
                    //                   label: Text(
                    //                       "${Statics.getLabel('sanghaKaryaStithi')}")),
                    //             ],
                    //             rows: List<DataRow>.generate(
                    //               rowTitles.length,
                    //               (index) => DataRow(
                    //                 cells: [DataCell(Text(rowTitles[index]))],
                    //               ),
                    //             ),
                    //           ),
                    //           Expanded(
                    //             child: SingleChildScrollView(
                    //               scrollDirection: Axis.horizontal,
                    //               child: DataTable(
                    //                 headingRowColor: MaterialStateProperty.all(
                    //                     Colors.purpleAccent[200]),
                    //                 headingTextStyle: TextStyle(
                    //                     color: Colors.white,
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 15),
                    //                 columns: sanghaData
                    //                     .map((e) => DataColumn(
                    //                         label: Text(e.vayogatCode ?? '')))
                    //                     .toList(),
                    //                 rows: List<DataRow>.generate(
                    //                   rowTitles.length,
                    //                   (index) => DataRow(
                    //                     cells: sanghaData.map((e) {
                    //                       final value =
                    //                           getCellValueByRowIndex(e, index);
                    //                       return DataCell(Text(value));
                    //                     }).toList(),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       )
                    //   ],
                    // ),
                    commonExpansionTile(
                      title: 'UpsanaSthal',
                      children: [
                        if (data != null && data!.vastiUpasanaSthalInfo != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection:
                                  Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                width: 300,
                                child: DataTable(
                                  headingRowColor:
                                      MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('UpasanaSthal')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('SelectFrequency')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('count')}")),
                                  ],
                                  rows:
                                      data!.vastiUpasanaSthalInfo!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(
                                            item.selectedDropdownValueName ??
                                                '')),
                                        DataCell(Text(
                                            item.selectedDropdownValueName1 ??
                                                '')),
                                        DataCell(Text(item.sankhya ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'SajjanShakti',
                      children: [
                        if (data != null && data!.vastiSajjanShaktiData != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection:
                                  Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor:
                                      MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('Name')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('Address')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('doorBhash')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('shreni')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('sanstha')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('samparkSthiti')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('prbhaavkshetra')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('samparkSootraNaav')}")),
                                  ],
                                  rows:
                                      data!.vastiSajjanShaktiData!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.name ?? '')),
                                        DataCell(Text(item.address ?? '')),
                                        DataCell(Text(item.doorabhaash ?? '')),
                                        DataCell(Text(
                                            item.selectedDropdownValueName ??
                                                '')),
                                        DataCell(
                                            Text(item.sanstheCheNaav ?? '')),
                                        DataCell(Text(
                                            item.selectedDropdownValueName1 ??
                                                '')),
                                        DataCell(Text(
                                            item.selectedDropdownValueName2 ??
                                                '')),
                                        DataCell(
                                            Text(item.samparkasutranava ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'anyaPrabhaviLok',
                      children: [
                        if (data != null && data!.vastiAnyaPrabhaviLok != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection:
                                  Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor:
                                      MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('Name')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('Address')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('doorBhash')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('shreni')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('upshreni')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('upshreni2')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('samparkSthiti')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('prbhaavkshetra')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('samparkSootraNaav')}")),
                                  ],
                                  rows: data!.vastiAnyaPrabhaviLok!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.name ?? '')),
                                        DataCell(Text(item.address ?? '')),
                                        DataCell(Text(item.doorabhaash ?? '')),
                                        DataCell(Text(
                                            item.selectedDropdownValueName ??
                                                '')),
                                        DataCell(Text(
                                            "${item.selectedDropdownValueName1} ${item.otherupshrenee != "" ? "- ${item.otherupshrenee}" : ""}")),
                                        DataCell(Text(
                                            "${item.selectedDropdownValueName2} ${item.otherupshrenee2 != "" ? "- ${item.otherupshrenee2}" : ""}")),
                                        DataCell(Text(
                                            item.selectedDropdownValueName3 ??
                                                '')),
                                        DataCell(Text(
                                            item.selectedDropdownValueName4 ??
                                                '')),
                                        DataCell(
                                            Text(item.samparkasutranav ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'GavatsajareHonareSan',
                      children: [
                        if (data != null && data!.vastitSajareHonareSan != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection:
                                  Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor:
                                      MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('SelectFrequency')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('aayojakSansthachiNave')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('aayojakNaav')}")),
                                  ],
                                  rows:
                                      data!.vastitSajareHonareSan!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(
                                            "${item.selectedDropdownValueName} ${item.otherSajareSan != "" ? "- ${item.otherSajareSan}" : ""}")),
                                        DataCell(Text(
                                            item.ayojakasansthacinave ?? '')),
                                        DataCell(
                                            Text(item.ayojakancinave ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'GavatHonareKaryakram',
                      children: [
                        if (data != null && data!.vastiSamajikKaryakram != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection:
                                  Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor:
                                      MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('SelectFrequency')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('aayojakSansthachiNave')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('aayojakNaav')}")),
                                  ],
                                  rows:
                                      data!.vastiSamajikKaryakram!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(
                                            "${item.selectedDropdownValueName} ${item.otherKaryakram != "" ? "- ${item.otherKaryakram}" : ""}")),
                                        DataCell(Text(
                                            item.ayojakasansthacinave ?? '')),
                                        DataCell(
                                            Text(item.ayojakancinave ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'DurjanShakti',
                      children: [
                        if (data != null && data!.vastiDurjanShaktiData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection:
                                  Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor:
                                      MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('Name')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('SelectFrequency')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('shiksha')}")),
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('crime')}")),
                                  ],
                                  rows:
                                      data!.vastiDurjanShaktiData!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Center(
                                            child: Text(item.name ?? ''))),
                                        DataCell(Text(
                                            item.selectedDropdownValueName ??
                                                '')),
                                        DataCell(Text(
                                            item.selectedDropdownValueName1 ??
                                                '')),
                                        DataCell(Text(
                                            item.selectedDropdownValueName2 ??
                                                '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'HinduVeerYaadi',
                      children: [
                        if (data != null &&
                            data!.vastiHinduVeerListData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection:
                                  Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                width: 250,
                                child: DataTable(
                                  headingRowColor:
                                      MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(
                                      label: Expanded(
                                        // ensures center works properly
                                        child: Center(
                                          child: Text(
                                            "${Statics.getLabel('Name')}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows:
                                      data!.vastiHinduVeerListData!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Center(
                                            child: Text(item.name ?? ''))),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
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
