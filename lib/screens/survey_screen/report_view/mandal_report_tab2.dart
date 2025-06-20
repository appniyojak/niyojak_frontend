import 'package:flutter/material.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/nagar_vasti_model.dart';
import '../../../providers/bals.dart';

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
    // TODO: implement initState
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
  String? selctedLevelId = '';
  String? selctedLevelNameNew = '';
  String? selctedLevelIdNew = '';
  String? _linkedgraamValue = '';
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedmandal;
  String? _linkedmandalValue = '';

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
      populateDropdown();
    });
  }

  NagarVastiSampurnaModel? data;
  List<NagarVastisarvekshanReportwithname>?
      nagarVastisarvekshanReportwithnamedata;

  late List<Sajjanshakkati> sajjanList = [];
  late List<Vasahatsamparkashiti> vasahatSamparkStithiData = [];
  late List<Jagran> jagran = [];
  late List<Gatividhi> gatividhi = [];
  late List<PurviShakhaHoti> purviShakhaHoti = [];
  late List<PurviSptahikMilanHote> purviSptahikMilanHote = [];
  void getMyDetailsColumnsAndRows() async {
    data = await Statics.vastisarvekshanAllReportData(
        context, Statics.userDetails["userID"], selctedLevelId, selctedLevel);
    setState(() {
      nagarVastisarvekshanReportwithnamedata =
          data!.nagarVastisarvekshanReportwithname;
      sajjanList = data!.sajjanshakkati ?? [];
      vasahatSamparkStithiData = data!.vasahatsamparkashiti ?? [];
      gatividhi = data!.gatividhi ?? [];
      jagran = data!.jagran ?? [];
      purviShakhaHoti = data!.purviShakhaHoti ?? [];
      purviSptahikMilanHote = data!.purviSptahikMilanHote ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(children: [
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
                                      "${Statics.getLabel('OtherSocialOrganization')}"),
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
                                final selectedItem = _linkedVibhaag!.firstWhere(
                                    (bg) => bg.geoUnitID.toString() == value);
                                print(value);
                                setState(() {
                                  _linkedVibhaagValue = value;
                                  populatelinkedBhaagDropdown(value!);
                                  vibhagId = value;
                                  _linkedBhaagValue = _linkedNagarValue = null;
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
                          if (_linkedNagar != null && _linkedNagar!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                  labelText: "${Statics.getLabel('taalukaa')}"),
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
                          if (_linkedNagar != null && _linkedNagar!.length > 0)
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
                                final selectedItem = _linkedmandal!.firstWhere(
                                    (bg) => bg.geoUnitID.toString() == value);
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
                          if (selctedLevel == "Mandal")
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.purpleAccent)),
                                onPressed: () {
                                  if (selctedLevel == "Mandal") {
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
            if (selctedLevel == "Mandal" &&
                selctedLevelName != "" &&
                isVastiSearch == true)
              SizedBox(
                height: 20,
              ),
            if (selctedLevel == "Mandal" &&
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
                        "मंडल ->  ",
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
//===================================================================================================================================================
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                children: [
                  commonExpansionTile(
                    title: 'VastisurveuAbhiyanStithi',
                    children: [
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
                            itemCount: data?.nagarVastisarvekshanReportwithname
                                    ?.length ??
                                0,
                            itemBuilder: (context, index) {
                              final data =
                                  nagarVastisarvekshanReportwithnamedata![
                                      index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Center(
                                      child: Text(
                                        data.name ??
                                            "${Statics.getLabel('nagarVastiName')}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataTable(
                                    headingRowColor: MaterialStateProperty.all(
                                        Colors.purpleAccent.shade100),
                                    headingTextStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    columns: [
                                      DataColumn(
                                          label: Text(
                                              "${Statics.getLabel('sarvekshanSthiti')}")),
                                      DataColumn(
                                          label: Text(
                                              "${Statics.getLabel('NagarShahari')}")),
                                      DataColumn(
                                          label: Text(
                                              "${Statics.getLabel('Vasti')}")),
                                    ],
                                    rows: [
                                      DataRow(
                                        color: MaterialStateProperty.all(
                                            Colors.lightBlue.shade50),
                                        cells: [
                                          DataCell(Text(
                                              "${Statics.getLabel('prathamikSurveyComplete')}")),
                                          DataCell(Text(
                                              "${data.nagarStep1CompleteCount ?? ""}")),
                                          DataCell(Text(
                                              "${data.vastiStep1CompleteCount ?? ""}")),
                                        ],
                                      ),
                                      DataRow(
                                        color: MaterialStateProperty.all(
                                            Colors.lightBlue.shade50),
                                        cells: [
                                          DataCell(Text(
                                              "${Statics.getLabel('otherSuerveyComplete')}")),
                                          DataCell(Text(
                                              "${data.nagarStep2CompleteCount ?? ""}")),
                                          DataCell(Text(
                                              "${data.vastiStep2CompleteCount ?? ""}")),
                                        ],
                                      ),
                                      DataRow(
                                        color: MaterialStateProperty.all(
                                            Colors.lightBlue.shade50),
                                        cells: [
                                          DataCell(Text(
                                              "${Statics.getLabel('vistrutSurveyComplete')}")),
                                          DataCell(Text(
                                              "${data.nagarStep3CompleteCount ?? ""}")),
                                          DataCell(Text(
                                              "${data.vastiStep3CompleteCount ?? ""}")),
                                        ],
                                      ),
                                      DataRow(
                                        color: MaterialStateProperty.all(
                                            Colors.red.shade50),
                                        cells: [
                                          DataCell(Text(
                                              "${Statics.getLabel('surveyStart')}")),
                                          DataCell(Text(
                                              "${data.nagarStepStartedCount ?? ""}")),
                                          DataCell(Text(
                                              "${data.vastiStepStartedCount ?? ""}")),
                                        ],
                                      ),
                                      DataRow(
                                        color: MaterialStateProperty.all(
                                            Colors.red.shade50),
                                        cells: [
                                          DataCell(Text(
                                              "${Statics.getLabel('surveyComplete')}")),
                                          DataCell(Text(
                                              "${data.nagarAllStepsCompleteCount ?? ""}")),
                                          DataCell(Text(
                                              "${data.vastiAllStepsCompleteCount ?? ""}")),
                                        ],
                                      ),
                                      DataRow(
                                        color: MaterialStateProperty.all(
                                            Colors.red.shade50),
                                        cells: [
                                          DataCell(Text(
                                              "${Statics.getLabel('surveyNotStarted')}")),
                                          DataCell(Text(
                                              "${data.nagarStepsNotstartedCount ?? ""}")),
                                          DataCell(Text(
                                              "${data.vastiStepsNotstartedCount ?? ""}")),
                                        ],
                                      ),
                                      DataRow(
                                        color: MaterialStateProperty.all(
                                            Colors.yellow.shade50),
                                        cells: [
                                          DataCell(Text(
                                              "${Statics.getLabel('Total')}")),
                                          DataCell(
                                              Text("${data.nagarcount ?? ""}")),
                                          DataCell(
                                              Text("${data.vasticount ?? ""}")),
                                        ],
                                      ),
                                    ],
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
                ],
              ),
            )
          ]),
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
