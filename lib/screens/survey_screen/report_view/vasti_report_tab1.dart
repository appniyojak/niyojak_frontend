import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/nagar_vasti_model.dart';
import '../../../providers/bals.dart';
import '../../../widgets/single_column_row.dart';
import '../../../widgets/two_column_row.dart';

class VastiSurveyReportTab1 extends StatefulWidget {
  static const String routeName = '/vasti-survey-report-tab1';

  const VastiSurveyReportTab1({super.key});

  @override
  State<VastiSurveyReportTab1> createState() => _VastiSurveyReportTab1State();
}

class _VastiSurveyReportTab1State extends State<VastiSurveyReportTab1> {
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

  void populateDropdown() async {
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    populatelinkedMahaanagarDropdown();
    populatelinkedVibhaagDropdown('');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!
        .where((element) => element.showAnnualBaithakkey!.contains('1'))
        .toList();
    print("_baithakTypes :-- $_baithakTypes");
    setState(() {});
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParentForVasti(
        Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(
      String vibhaagIDStr) async {
    _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParentForVasti(
        Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(
      String mahaanagarIDStr) async {
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParentForVasti(
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
      var ngDD = await Statics.getGeoUnitsByLevelAndParentForVasti(
          Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParentForVasti(
          Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }

  void resetData() async {
    setState(() {
      _linkedMahaanagarValue = null;
      // _linkedMahaanagar = null;
      _linkedVibhaagValue = null;
      // _linkedVibhaag = null;
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
      isVastiSearch = false;
      selctedLevelName = '';
      selctedDropDownLevelName = 'प्रांत';
      _isExpanded = false;
      populateDropdown();
    });
  }

  NagarVastiSampurnaModel? data;
  List<NagarVastisarvekshanReportwithname>?
      nagarVastisarvekshanReportwithnamedata;

  late List<Sajjanshakkati> sajjanList = [];
  late List<VastiAnyaPrabhaviLokam> anyaPrabhaviLok = [];
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
      anyaPrabhaviLok = data!.anyaPrabhaviLok ?? [];
      vasahatSamparkStithiData = data!.vasahatsamparkashiti ?? [];
      gatividhi = data!.gatividhi ?? [];
      jagran = data!.jagran ?? [];
      purviShakhaHoti = data!.purviShakhaHoti ?? [];
      purviSptahikMilanHote = data!.purviSptahikMilanHote ?? [];
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

    final List<String> namesList =
        vastiStepStartedNames.split('::').map((e) => e.trim()).toList();

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
          padding: EdgeInsets.all(20),
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
                    Statics.getLabel('vastiYaadi'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purpleAccent,
                    ),
                  ),
                ],
              ),
              Divider(thickness: 1, height: 20),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 6,
                  radius: Radius.circular(10),
                  child: ListView.builder(
                    itemCount: namesList.length,
                    itemBuilder: (_, index) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
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
                              style: TextStyle(
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
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
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

  Widget buildTransposedTable(List<SanghaKaryaStithiData> dataList) {
    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    // Row titles
    final rowTitles = [
      "${Statics.getLabel('shaakhaaYukta')}",
      "${Statics.getLabel('saaptahikMilanyukta')}",
      "${Statics.getLabel('MaasikYuktaLabel')}",
      "${Statics.getLabel('isNewSankalpitShakha')}",
      "${Statics.getLabel('isNewSankalpitSaptahikMilan')}",
      "${Statics.getLabel('isNewSankalpitMaasikMilan')}",
      'एकूण',
    ];

    // Helper to get totals
    int rowSum(List<int> list) => list.fold(0, (a, b) => a + b);

    // Precalculate total per column (for last row)
    List<int> columnTotals = List.generate(dataList.length, (i) {
      final e = dataList[i];
      return (e.shaakhaaCount ?? 0) +
          (e.saaptaahikCount ?? 0) +
          (e.maasikMilanCount ?? 0) +
          (e.sankalpitShaakhaaCount ?? 0) +
          (e.sankalpitSaaptaahikCount ?? 0) +
          (e.sankalpitMaasikMilanCount ?? 0);
    });

    final totalOfTotals = rowSum(columnTotals);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fixed first column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 48,
              width: 160,
              color: Colors.purpleAccent.shade100,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "${Statics.getLabel('sanghaKaryaStithi')}",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ...rowTitles.map((title) {
              return Container(
                width: 160,
                height: 48,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.grey.shade300, width: 1))),
                child: Text(title),
              );
            }).toList(),
          ],
        ),

        // Scrollable data columns
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: horizontalScrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    ...dataList.map((e) {
                      return Container(
                        width: 100,
                        height: 48,
                        alignment: Alignment.center,
                        color: Colors.purpleAccent.shade100,
                        child: Text(
                          e.vayogatCode.toString(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    Container(
                      width: 100,
                      height: 48,
                      alignment: Alignment.center,
                      color: Colors.purpleAccent.shade100,
                      child: Text(
                        "${Statics.getLabel('Total')}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                // Data rows
                ...List.generate(rowTitles.length, (rowIndex) {
                  return Row(
                    children: [
                      ...dataList.map((e) {
                        int value = 0;
                        switch (rowIndex) {
                          case 0:
                            value = e.shaakhaaCount ?? 0;
                            break;
                          case 1:
                            value = e.saaptaahikCount ?? 0;
                            break;
                          case 2:
                            value = e.maasikMilanCount ?? 0;
                            break;
                          case 3:
                            value = e.sankalpitShaakhaaCount ?? 0;
                            break;
                          case 4:
                            value = e.sankalpitSaaptaahikCount ?? 0;
                            break;
                          case 5:
                            value = e.sankalpitMaasikMilanCount ?? 0;
                            break;
                          case 6:
                            value = (e.shaakhaaCount ?? 0) +
                                (e.saaptaahikCount ?? 0) +
                                (e.maasikMilanCount ?? 0) +
                                (e.sankalpitShaakhaaCount ?? 0) +
                                (e.sankalpitSaaptaahikCount ?? 0) +
                                (e.sankalpitMaasikMilanCount ?? 0);
                            break;
                        }
                        return Container(
                          width: 100,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey.shade300, width: 1)),
                          ),
                          child: Text(value.toString()),
                        );
                      }).toList(),

                      // Total column per row
                      Container(
                        width: 100,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.shade300, width: 1)),
                        ),
                        child: Text(() {
                          if (rowIndex == 6) return totalOfTotals.toString();
                          final values = dataList.map((e) {
                            switch (rowIndex) {
                              case 0:
                                return e.shaakhaaCount ?? 0;
                              case 1:
                                return e.saaptaahikCount ?? 0;
                              case 2:
                                return e.maasikMilanCount ?? 0;
                              case 3:
                                return e.sankalpitShaakhaaCount ?? 0;
                              case 4:
                                return e.sankalpitSaaptaahikCount ?? 0;
                              case 5:
                                return e.sankalpitMaasikMilanCount ?? 0;
                            }
                            return 0;
                          }).toList();
                          return rowSum(values).toString();
                        }()),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Sajjan Shakti
    final Map<String, List<Sajjanshakkati>> groupedData = {};
    for (var item in sajjanList) {
      final key = item.sajjanshakkati;
      groupedData.putIfAbsent(key!, () => []).add(item);
    }

    /// Sajjan Shakti
    final Map<String, List<VastiAnyaPrabhaviLokam>> groupedAnyaPrabhaviData =
        {};
    for (var item1 in anyaPrabhaviLok) {
      final key = item1.sajjanshakkati;
      groupedAnyaPrabhaviData.putIfAbsent(key!, () => []).add(item1);
    }

    /// Vasahat Sampark Stithi
    final maintypes = vasahatSamparkStithiData
        .map((e) => e.maintype as String)
        .toSet()
        .toList();
    final subtypes = vasahatSamparkStithiData
        .map((e) => e.subtype as String)
        .toSet()
        .toList();

    final Map<String, Map<String, int>> vastiMap = {};
    for (var entry in vasahatSamparkStithiData) {
      final mt = entry.maintype;
      final st = entry.subtype;
      final count = entry.vastiCount;
      vastiMap.putIfAbsent(mt!, () => {})[st!] = count!;
    }

    /// Jagran Shreni
    final maintypesJagran =
        jagran.map((e) => e.maintype as String).toSet().toList();
    final subtypesJagran =
        jagran.map((e) => e.subtype as String).toSet().toList();

    final Map<String, Map<String, int>> vastiMapJagran = {};
    for (var entry in jagran) {
      final mt = entry.maintype;
      final st = entry.subtype;
      final count = entry.vastiCount;
      vastiMapJagran.putIfAbsent(mt!, () => {})[st!] = count!;
    }

    /// Gatividhi
    final maintypesGatividhi =
        gatividhi.map((e) => e.maintype as String).toSet().toList();
    final subtypesGatividhi =
        gatividhi.map((e) => e.subtype as String).toSet().toList();

    final Map<String, Map<String, int>> vastiMapgatividhi = {};
    for (var entry in gatividhi) {
      final mt = entry.maintype;
      final st = entry.subtype;
      final count = entry.vastiCount;
      vastiMapgatividhi.putIfAbsent(mt!, () => {})[st!] = count!;
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
                          title: Text(
                              "${Statics.getLabel('selectedBhougolikkaryastithi')}",
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
                            if (_linkedMahaanagar != null)
                              DropdownButtonFormField(
                                decoration: InputDecoration(
                                    labelText:
                                        "${Statics.getLabel('mahaanagar')}"),
                                isExpanded: true,
                                value: _linkedMahaanagarValue == ""
                                    ? null
                                    : _linkedMahaanagarValue,
                                items: _linkedMahaanagar!
                                    .map((bg) => DropdownMenuItem(
                                          value: bg.geoUnitID.toString(),
                                          child: Text(bg.name!),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  final selectedItem = _linkedMahaanagar!
                                      .firstWhere((bg) =>
                                          bg.geoUnitID.toString() == value);
                                  setState(() {
                                    _linkedMahaanagarValue = value;
                                    _linkedVibhaagValue = null;
                                    _linkedBhaagValue = null;
                                    _linkedNagarValue = null;
                                    populatelinkedVibhaagDropdown(value!);
                                    mahanagarId = value;
                                    selctedLevelId = value;
                                    selctedLevelName = selectedItem.name ?? "";
                                    selctedLevel = 'mahanagar';
                                    selctedDropDownLevelName = 'महानगर';
                                  });
                                  print("Selected Id: $value");
                                  print(
                                      "Selected Level Name: ${selectedItem.name}");
                                },
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            if (_linkedVibhaag != null)
                              DropdownButtonFormField(
                                decoration: InputDecoration(
                                    labelText:
                                        "${Statics.getLabel('vibhaag')}"),
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
                                    selctedLevel = 'vibhag';
                                    selctedDropDownLevelName = 'विभाग';
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
                                    labelText:
                                        "${Statics.getLabel('BhaagKaaryakartaaCount')}"),
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
                                    labelText: "${Statics.getLabel('Nagar')}"),
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
                                    // populatelinkedVastiDropdown(value!);
                                    selctedLevelId = value;
                                    selctedLevelName = selectedItem.name ?? "";
                                    selctedLevel = 'nagar';
                                    selctedDropDownLevelName = 'नगर';
                                  });
                                  print("Selected Id: $value");
                                  print(
                                      "Selected Level Name: ${selectedItem.name}");
                                },
                              ),
                            // if (_linkedNagar != null && _linkedNagar!.length > 0)
                            //   SizedBox(height: 10,),
                            // if (_linkedvasti != null && _linkedvasti!.length > 0)
                            //   DropdownButtonFormField(
                            //     decoration: InputDecoration(labelText: "${Statics.getLabel('Vasti')}"),
                            //     isExpanded: true,
                            //     value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                            //     items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            //     onChanged: (value) {
                            //       final selectedItem = _linkedvasti!.firstWhere(
                            //               (bg) => bg.geoUnitID.toString() == value);
                            //       setState(() {
                            //         _linkedvastiValue = value;
                            //         selctedLevelId = value;
                            //         selctedLevelName = selectedItem.name ?? "";
                            //         selctedLevel = 'Vasti';
                            //       });
                            //       print("Selected Id: $value");
                            //       print("Selected Level Name: ${selectedItem.name}");
                            //     },
                            //   ),
                            if (_linkedvasti != null &&
                                _linkedvasti!.length > 0)
                              SizedBox(
                                height: 10,
                              ),
                            // if(selctedLevel == "Vasti")
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
                                child: Text("${Statics.getLabel('Search')}",
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
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: Text(
                            '${Statics.getLabel('sharaansh')} ($selctedDropDownLevelName)',
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
                            headingTextStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            columns: [
                              DataColumn(
                                  label: Text(
                                      "${Statics.getLabel('sarvekshanSthiti')}")),
                              DataColumn(
                                  label:
                                      Text(Statics.getLabel('NagarShahari'))),
                              DataColumn(
                                  label: Text("${Statics.getLabel('Vasti')}")),
                              DataColumn(label: Text('')),
                            ],
                            rows: [
                              DataRow(
                                color: MaterialStateProperty.all(
                                    Colors.orange.shade50),
                                cells: [
                                  DataCell(Text(
                                      "${Statics.getLabel('surveyStart')}")),
                                  DataCell(Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        "${data?.nagarVastisarvekshanReportwithselectedlevel?.nagarStepStartedCount ?? ""}"),
                                  )),
                                  DataCell(Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        "${data?.nagarVastisarvekshanReportwithselectedlevel?.vastiStepStartedCount ?? ""}"),
                                  )),
                                  DataCell(IconButton(
                                    icon: Icon(Icons.remove_red_eye,
                                        color: Colors.teal),
                                    onPressed: () => showPopupList(
                                        context,
                                        data!
                                            .nagarVastisarvekshanReportwithselectedlevel!
                                            .vastiStepStartedNames!
                                            .toString()),
                                  )),
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(
                                    Colors.orange.shade50),
                                cells: [
                                  DataCell(Text(
                                      "${Statics.getLabel('surveyComplete')}")),
                                  DataCell(Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        "${data?.nagarVastisarvekshanReportwithselectedlevel?.nagarAllStepsCompleteCount ?? ""}"),
                                  )),
                                  DataCell(Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        "${data?.nagarVastisarvekshanReportwithselectedlevel?.vastiAllStepsCompleteCount ?? ""}"),
                                  )),
                                  DataCell(IconButton(
                                    icon: Icon(Icons.remove_red_eye,
                                        color: Colors.teal),
                                    onPressed: () => showPopupList(
                                        context,
                                        data!
                                            .nagarVastisarvekshanReportwithselectedlevel!
                                            .vastiAllStepsCompleteNames!
                                            .toString()),
                                  )),
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(
                                    Colors.orange.shade50),
                                cells: [
                                  DataCell(Text(
                                      "${Statics.getLabel('surveyNotStarted')}")),
                                  DataCell(Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        "${data?.nagarVastisarvekshanReportwithselectedlevel?.nagarStepsNotstartedCount ?? ""}"),
                                  )),
                                  DataCell(Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        "${data?.nagarVastisarvekshanReportwithselectedlevel?.vastiStepsNotstartedCount ?? ""}"),
                                  )),
                                  DataCell(IconButton(
                                    icon: Icon(Icons.remove_red_eye,
                                        color: Colors.teal),
                                    onPressed: () => showPopupList(
                                        context,
                                        data!
                                            .nagarVastisarvekshanReportwithselectedlevel!
                                            .vastiStepsNotstartedNames!
                                            .toString()),
                                  )),
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(
                                    Colors.grey.shade200),
                                cells: [
                                  DataCell(
                                      Text("${Statics.getLabel('Total')}")),
                                  DataCell(Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        "${data?.nagarVastisarvekshanReportwithselectedlevel?.nagarcount ?? ""}"),
                                  )),
                                  DataCell(Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        "${data?.nagarVastisarvekshanReportwithselectedlevel?.vasticount ?? ""}"),
                                  )),
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
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(
                                    Colors.green.shade50),
                                cells: [
                                  DataCell(Text(
                                      "${Statics.getLabel('prathamikSurveyComplete')}")),
                                  DataCell(Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        "${data?.nagarVastisarvekshanReportwithselectedlevel?.nagarStep1CompleteCount ?? ""}"),
                                  )),
                                  DataCell(Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        "${data?.nagarVastisarvekshanReportwithselectedlevel?.vastiStep1CompleteCount ?? ""}"),
                                  )),
                                  DataCell(IconButton(
                                    icon: Icon(Icons.remove_red_eye,
                                        color: Colors.teal),
                                    onPressed: () => showPopupList(
                                        context,
                                        data!
                                            .nagarVastisarvekshanReportwithselectedlevel!
                                            .vastiStep1CompleteNames!
                                            .toString()),
                                  )),
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(
                                    Colors.green.shade50),
                                cells: [
                                  DataCell(
                                    Text(
                                        "${Statics.getLabel('otherSuerveyComplete')}"),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          "${data?.nagarVastisarvekshanReportwithselectedlevel?.nagarStep2CompleteCount ?? ""}"),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          "${data?.nagarVastisarvekshanReportwithselectedlevel?.vastiStep2CompleteCount ?? ""}"),
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(Icons.remove_red_eye,
                                          color: Colors.teal),
                                      onPressed: () => showPopupList(
                                          context,
                                          data!
                                              .nagarVastisarvekshanReportwithselectedlevel!
                                              .vastiStep2CompleteNames!
                                              .toString()),
                                    ),
                                  ),
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(
                                    Colors.green.shade50),
                                cells: [
                                  DataCell(
                                    Text(
                                        "${Statics.getLabel('vistrutSurveyComplete')}"),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          "${data?.nagarVastisarvekshanReportwithselectedlevel?.nagarStep3CompleteCount ?? ""}"),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          "${data?.nagarVastisarvekshanReportwithselectedlevel?.vastiStep3CompleteCount ?? ""}"),
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(Icons.remove_red_eye,
                                          color: Colors.teal),
                                      onPressed: () => showPopupList(
                                          context,
                                          data!
                                              .nagarVastisarvekshanReportwithselectedlevel!
                                              .vastiStep3CompleteNames!
                                              .toString()),
                                    ),
                                  ),
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(
                                    Colors.red.shade50),
                                cells: [
                                  DataCell(
                                    Text(
                                        "${Statics.getLabel('remainingVasti')}"),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "${(data?.nagarVastisarvekshanReportwithselectedlevel?.nagarcount ?? 0) - (data?.nagarVastisarvekshanReportwithselectedlevel?.nagar_step_total ?? 0)}",
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "${(data?.nagarVastisarvekshanReportwithselectedlevel?.vasticount ?? 0) - (data?.nagarVastisarvekshanReportwithselectedlevel?.vasti_step_total ?? 0)}",
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text("-"),
                                  ),
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
                              itemCount: data
                                      ?.nagarVastisarvekshanReportwithname
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
                                          EdgeInsets.symmetric(vertical: 8),
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
                                      headingRowColor:
                                          MaterialStateProperty.all(
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
                                            label: Text(Statics.getLabel(
                                                'NagarShahari'))),
                                        DataColumn(
                                            label: Text(
                                                "${Statics.getLabel('Vasti')}")),
                                      ],
                                      rows: [
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
                                            DataCell(Text(
                                                "${data.nagarcount ?? ""}")),
                                            DataCell(Text(
                                                "${data.vasticount ?? ""}")),
                                          ],
                                        ),
                                        DataRow(
                                          color: MaterialStateProperty.all(
                                              Colors.white),
                                          cells: [
                                            DataCell(Text("")),
                                            DataCell(Text("")),
                                            DataCell(Text("")),
                                          ],
                                        ),
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
                    commonExpansionTile(
                      title: 'vastiSarvekshanSankalan',
                      children: [
                        SingleColumnRow(
                            txtString: Statics.getLabel('vastiPramukhaAhe'),
                            value: data?.vastiloksankhya?.vastiPramukhCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('VastiSamitiAhe'),
                            value: data?.vastiloksankhya?.vastiSamitiAheCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('purviShakhaHoti'),
                            value: data?.vastiloksankhya?.purviShakhaHotiCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('purviSaptahikMilan'),
                            value: data
                                ?.vastiloksankhya?.purviSptahikMilanHoteCount
                                .toString(),
                            fontsize: 15),
                        if (data != null && data?.sanghaKaryaStithiData != null)
                          buildTransposedTable(data!.sanghaKaryaStithiData!),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'vastichiLoksankhya',
                      children: [
                        SingleColumnRow(
                            txtString: Statics.getLabel('lessThan8000'),
                            value:
                                data?.vastiloksankhya?.lessThan8000.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('8000to12000'),
                            value: data?.vastiloksankhya?.between8000And12000
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('12000more'),
                            value:
                                data?.vastiloksankhya?.moreThan12000.toString(),
                            fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'SwayamsevakCount',
                      children: [
                        SingleColumnRow(
                            txtString:
                                Statics.getLabel('TotalKaaryakartaaCount'),
                            value: data?.vastiloksankhya?.totalSwayamsevakCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('PratidnyitCount'),
                            value: data?.vastiloksankhya?.pratidnyitCount
                                .toString(),
                            fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'SwayamsevakCountByAge',
                      children: [
                        SingleColumnRow(
                            txtString: Statics.getLabel('Shishu'),
                            value:
                                data?.vastiloksankhya?.shishuCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('Baal'),
                            value: data?.vastiloksankhya?.baalCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('TarunVidyaarthi'),
                            value: data?.vastiloksankhya?.tarunVidyaarthiCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('TarunVyavasaayee'),
                            value: data?.vastiloksankhya?.tarunVyavasaayeeCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('ProudhVyavasaayee'),
                            value: data
                                ?.vastiloksankhya?.proudhaVyavasaayeeCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('UnkownAge'),
                            value: data?.vastiloksankhya?.unknownAgeCount
                                .toString(),
                            fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'ShikshitSwayamsevakCount',
                      children: [
                        SingleColumnRow(
                            txtString: Statics.getLabel('PrarambhikShikshit'),
                            value: data
                                ?.vastiloksankhya?.prarambhikShikshitCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('PraathamikShikshit'),
                            value: data
                                ?.vastiloksankhya?.praathamikShikshitCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('PrathamVarshShikshit'),
                            value: data
                                ?.vastiloksankhya?.prathamVarshaShikshitCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('DwitiyaVarshShikshit'),
                            value: data
                                ?.vastiloksankhya?.dwitiyaVarshaShikshitCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('TrutiyaVarshShikshit'),
                            value: data
                                ?.vastiloksankhya?.trutiyaVarshaShikshitCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('NoShikshan'),
                            value: data?.vastiloksankhya?.noShikshanCount
                                .toString(),
                            fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'KaaryakartaaCountByLevel',
                      children: [
                        TwoColumnRow(
                          txtString: Statics.getLabel('Shaakhaa'),
                          value: data
                              ?.vastiloksankhya?.dailyShaakhaaKaaryakartaaCount
                              .toString(),
                          txtString2: Statics.getLabel('SaaptaahikLabelShort'),
                          value2: data?.vastiloksankhya
                              ?.saaptaahikMilanKaaryakartaaCount
                              .toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('MilanMandali'),
                          value: data
                              ?.vastiloksankhya?.maasikMilanKaaryakartaaCount
                              .toString(),
                          txtString2:
                              Statics.getLabel('VastiKaaryakartaaCount'),
                          value2: data?.vastiloksankhya?.vastiKaaryakartaaCount
                              .toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('GraamKaaryakartaaCount'),
                          value: data?.vastiloksankhya?.graamKaaryakartaaCount
                              .toString(),
                          txtString2:
                              Statics.getLabel('MandalKaaryakartaaCount'),
                          value2: data?.vastiloksankhya?.mandalKaaryakartaaCount
                              .toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('NagarKaaryakartaaCount'),
                          value: data?.vastiloksankhya?.nagarKaaryakartaaCount
                              .toString(),
                          txtString2:
                              Statics.getLabel('ShaharKaaryakartaaCount'),
                          value2: data?.vastiloksankhya?.shaharKaaryakartaaCount
                              .toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('BhaagKaaryakartaaCount'),
                          value: data?.vastiloksankhya?.bhaagKaaryakartaaCount
                              .toString(),
                          txtString2:
                              Statics.getLabel('VibhaagKaaryakartaaCount'),
                          value2: data
                              ?.vastiloksankhya?.vibhaagKaaryakartaaCount
                              .toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString:
                              Statics.getLabel('MahaanagarKaaryakartaaCount'),
                          value: data
                              ?.vastiloksankhya?.mahaanagarKaaryakartaaCount
                              .toString(),
                          txtString2:
                              Statics.getLabel('PraantKaaryakartaaCount'),
                          value2: data?.vastiloksankhya?.praantKaaryakartaaCount
                              .toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString:
                              Statics.getLabel('KshetraKaaryakartaaCount'),
                          value: data?.vastiloksankhya?.kshetraKaaryakartaaCount
                              .toString(),
                          txtString2: Statics.getLabel(
                              'AkhilBhaaratiyaKaaryakartaaCount'),
                          value2: data?.vastiloksankhya
                              ?.akhilBhaaratiyaKaaryakartaaCount
                              .toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString:
                              Statics.getLabel('PravaaseeKaaryakartaaCount'),
                          value: data
                              ?.vastiloksankhya?.pravaaseeKaaryakartaaCount
                              .toString(),
                          txtString2:
                              Statics.getLabel('TotalKaaryakartaaCount'),
                          value2: data?.vastiloksankhya?.totalKaaryakartaaCount
                              .toString(),
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
                            value: data
                                ?.vastiloksankhya?.gatividhiKaaryakartaaCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString:
                                Statics.getLabel('AayaamKaaryakartaaCount'),
                            value: data
                                ?.vastiloksankhya?.aayaamKaaryakartaaCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel(
                                'SanghaPreritSansthaaKaaryakartaaCount'),
                            value: data?.vastiloksankhya
                                ?.sanghaPreritSansthaaKaaryakartaaCount
                                .toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel(
                                'SocialOrganizationKaaryakartaaCount'),
                            value: data?.vastiloksankhya
                                ?.socialOrganizationKaaryakartaaCount
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
                            // margin:EdgeInsets.all(16),
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
                                headingTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('Gatividhi')}")),
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('KaaryakartaaCountByLevel')}")),
                                ],
                                rows: data!.listKaaryakartaaCountByGatividhi!
                                    .map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.gatividhiName ?? '')),
                                      DataCell(Center(
                                          child: Text(item.kaaryakartaaCount
                                              .toString()))),
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
                            // margin:EdgeInsets.all(16),
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
                                headingTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('Aayaam')}")),
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('KaaryakartaaCountByLevel')}")),
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
                            // margin:EdgeInsets.all(16),
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
                                headingTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('sanghaPreritSanghatana')}")),
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('KaaryakartaaCountByLevel')}")),
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
                      children: [
                        if (data != null &&
                            data!.socialOrganizationKaaryakartaaCountByAreaOfOperation !=
                                null)
                          Container(
                            // margin:EdgeInsets.all(16),
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
                                headingTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('OtherSocialOrganization')}")),
                                  DataColumn(
                                      label:
                                          Text("${Statics.getLabel('count')}")),
                                ],
                                rows: data!
                                    .socialOrganizationKaaryakartaaCountByAreaOfOperation!
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
                      title: 'StudentCategory',
                      children: [
                        if (data != null &&
                            data!.listSwayamsevakCountByStudentCategory != null)
                          Container(
                            // margin:EdgeInsets.all(16),
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
                                headingTextStyle: TextStyle(
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
                              if (data != null &&
                                  data!.listSwayamsevakCountByVyavasaayeeCategory !=
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
                                    child: SizedBox(
                                      width: 320,
                                      child: DataTable(
                                        headingRowColor:
                                            MaterialStateProperty.resolveWith(
                                          (states) => Colors.purpleAccent[200],
                                        ),
                                        headingTextStyle: TextStyle(
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
                                                  "${Statics.getLabel('count')}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows: data!
                                            .listSwayamsevakCountByVyavasaayeeCategory!
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
                                ),
                            ],
                          )),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'vasahatPrakar',
                      children: [
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (data != null && data!.vasahatprakar != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal, // horizontal scroll
                                    child: SizedBox(
                                      width: 320,
                                      child: DataTable(
                                        headingRowColor:
                                            MaterialStateProperty.resolveWith(
                                          (states) => Colors.purpleAccent[200],
                                        ),
                                        headingTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        columns: [
                                          DataColumn(
                                            label: Expanded(
                                              child: Center(
                                                child: Text(
                                                  "${Statics.getLabel('vasahatPrakar')}",
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
                                                  "${Statics.getLabel('count')}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows: data!.vasahatprakar!.map((item) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Center(
                                                  child:
                                                      Text(item.value ?? ''))),
                                              DataCell(Center(
                                                  child: Text(
                                                      item.count.toString()))),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'vasahatSamparkStithi',
                      children: [
                        Container(
                          // height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              child: Table(
                                border: TableBorder.all(color: Colors.grey),
                                defaultColumnWidth: IntrinsicColumnWidth(),
                                children: [
                                  // Header Row
                                  TableRow(
                                    decoration: BoxDecoration(
                                        color: Colors.purpleAccent.shade200),
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              "${Statics.getLabel('prakaarSthiti')}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      ...subtypes.map((subtype) => TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(subtype,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                          )),
                                    ],
                                  ),
                                  // Data Rows
                                  ...maintypes.map((mt) {
                                    return TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(mt),
                                          ),
                                        ),
                                        ...subtypes.map((st) {
                                          final value = vastiMap[mt]?[st] ?? 0;
                                          return TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(value.toString()),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'pramukhaBhashhaStithi',
                      children: [
                        Container(
                          height: 500,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (data != null && data!.bhaasacount != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
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
                                        headingTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        columns: [
                                          DataColumn(
                                            label: Expanded(
                                              child: Center(
                                                child: Text(
                                                  "${Statics.getLabel('onlyBhasha')}",
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
                                        rows: data!.bhaasacount!.map((item) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Center(
                                                  child:
                                                      Text(item.value ?? ''))),
                                              DataCell(Center(
                                                  child: Text(
                                                      item.count.toString()))),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'praantStithi',
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
                              if (data != null && data!.prantshiti != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal, // horizontal scroll
                                    child: SizedBox(
                                      width: 350,
                                      child: DataTable(
                                        headingRowColor:
                                            MaterialStateProperty.resolveWith(
                                          (states) => Colors.purpleAccent[200],
                                        ),
                                        headingTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        columns: [
                                          DataColumn(
                                            label: Expanded(
                                              child: Center(
                                                child: Text(
                                                  "${Statics.getLabel('praantStithi')}",
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
                                        rows: data!.prantshiti!.map((item) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Center(
                                                  child:
                                                      Text(item.value ?? ''))),
                                              DataCell(Center(
                                                  child: Text(
                                                      item.count.toString()))),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ),
                      ],
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
                              if (data != null && data!.religion != null)
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
                                      headingTextStyle: TextStyle(
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
                                      rows: data!.religion!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(item.value ?? ''))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.count.toString()))),
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
                          height: 500,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                if (data != null && data!.upasanaSthal != null)
                                  ..._buildGroupedTables(
                                      data!.upasanaSthal!, context)
                              ],
                            ),
                          ),
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
                            children: [
                              ...groupedData.entries.map((entry) {
                                final sajjanType = entry.key;
                                final data = entry.value;

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
                                        "${Statics.getLabel('SajjanShakti')} (${sajjanType})",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Table(
                                      border: TableBorder.all(),
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color: Colors.purpleAccent.shade200,
                                          ),
                                          children: [
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  '${Statics.getLabel('SajjanShakti')} ${Statics.getLabel('samparkSthiti')}',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            ...prabhavishetraList
                                                .map((header) => Padding(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Text(
                                                        header ?? '',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )),
                                          ],
                                        ),
                                        ...samparkList.map((sampark) {
                                          return TableRow(
                                            children: [
                                              SizedBox(
                                                width: 140,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(sampark ?? ''),
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
                                                      Sajjanshakkati(),
                                                );
                                                return Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(
                                                      '${match.vasticnt ?? ''}'),
                                                );
                                              }),
                                            ],
                                          );
                                        }).toList(),
                                        TableRow(
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade200),
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                "${Statics.getLabel('Total')}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            ...prabhavishetraList
                                                .map((prabhav) {
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
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  '$total',
                                                  style: TextStyle(
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

                              // 👇 Grand Total Table Added Below
                              Builder(
                                builder: (context) {
                                  final allData = groupedData.values
                                      .expand((list) => list)
                                      .toList();
                                  final allPrabhavishetra = allData
                                      .map((e) => e.prabhavishetra)
                                      .toSet()
                                      .toList();
                                  final allSampark = allData
                                      .map((e) => e.samparkashiti)
                                      .toSet()
                                      .toList();

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 30),
                                      Center(
                                        child: Text(
                                          "${Statics.getLabel('SajjanShakti')} ${Statics.getLabel('completeAll')}",
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
                                          TableRow(
                                            decoration: BoxDecoration(
                                              color: Colors.deepPurple.shade200,
                                            ),
                                            children: [
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(
                                                    "${Statics.getLabel('samparkSthiti')}",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              ...allPrabhavishetra.map(
                                                (header) => Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(
                                                    header ?? '',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          ...allSampark.map((sampark) {
                                            return TableRow(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(sampark ?? ''),
                                                ),
                                                ...allPrabhavishetra
                                                    .map((prabhav) {
                                                  final total = allData
                                                      .where((e) =>
                                                          e.samparkashiti ==
                                                              sampark &&
                                                          e.prabhavishetra ==
                                                              prabhav)
                                                      .fold<int>(
                                                          0,
                                                          (sum, e) =>
                                                              sum +
                                                              (e.vasticnt ??
                                                                  0));
                                                  return Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text('$total'),
                                                  );
                                                }),
                                              ],
                                            );
                                          }).toList(),
                                          TableRow(
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade300),
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  "${Statics.getLabel('Total')}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              ...allPrabhavishetra
                                                  .map((prabhav) {
                                                final total = allData
                                                    .where((e) =>
                                                        e.prabhavishetra ==
                                                        prabhav)
                                                    .fold<int>(
                                                        0,
                                                        (sum, e) =>
                                                            sum +
                                                            (e.vasticnt ?? 0));
                                                return Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(
                                                    '$total',
                                                    style: TextStyle(
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
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'anyaPrabhaviLok',
                      children: [
                        Container(
                          height: 400,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView(
                            children: [
                              ...groupedAnyaPrabhaviData.entries
                                  .where((entry) => entry.key.trim().isNotEmpty)
                                  .map((entry) {
                                final anyaPrabhaviType = entry.key;
                                final data = entry.value;
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
                                        "${Statics.getLabel('anyaPrabhaviLok')} (${anyaPrabhaviType})",
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
                                            color: Colors.purpleAccent.shade200,
                                          ),
                                          children: [
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  '${Statics.getLabel('anyaPrabhaviLok')} "${Statics.getLabel('samparkSthiti')}"',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            ...prabhavishetraList
                                                .map((header) => Padding(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Text(
                                                        header ?? '',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )),
                                          ],
                                        ),
                                        // Data Rows
                                        ...samparkList.map((sampark) {
                                          return TableRow(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(sampark ?? ''),
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
                                                      VastiAnyaPrabhaviLokam(),
                                                );
                                                return Padding(
                                                  padding: EdgeInsets.all(8),
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
                                            Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                "${Statics.getLabel('Total')}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            ...prabhavishetraList
                                                .map((prabhav) {
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
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  '$total',
                                                  style: TextStyle(
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

                              // ✅ Grand Total Table
                              Builder(
                                builder: (context) {
                                  final allData = groupedAnyaPrabhaviData.values
                                      .expand((list) => list)
                                      .toList();
                                  final allPrabhavishetra = allData
                                      .map((e) => e.prabhavishetra)
                                      .toSet()
                                      .toList();
                                  final allSampark = allData
                                      .map((e) => e.samparkashiti)
                                      .toSet()
                                      .toList();

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 30),
                                      Center(
                                        child: Text(
                                          "${Statics.getLabel('anyaPrabhaviLok')} ${Statics.getLabel('completeAll')}",
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
                                              color: Colors.deepPurple.shade200,
                                            ),
                                            children: [
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(
                                                    "${Statics.getLabel('samparkSthiti')}",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              ...allPrabhavishetra
                                                  .map((header) => Padding(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: Text(
                                                          header ?? '',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )),
                                            ],
                                          ),
                                          // Data Rows
                                          ...allSampark.map((sampark) {
                                            return TableRow(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(sampark ?? ''),
                                                ),
                                                ...allPrabhavishetra
                                                    .map((prabhav) {
                                                  final total = allData
                                                      .where((e) =>
                                                          e.samparkashiti ==
                                                              sampark &&
                                                          e.prabhavishetra ==
                                                              prabhav)
                                                      .fold<int>(
                                                          0,
                                                          (sum, e) =>
                                                              sum +
                                                              (e.vasticnt ??
                                                                  0));
                                                  return Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text('$total'),
                                                  );
                                                }),
                                              ],
                                            );
                                          }).toList(),
                                          // Final Row - Total of all columns
                                          TableRow(
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade300),
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  "${Statics.getLabel('Total')}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              ...allPrabhavishetra
                                                  .map((prabhav) {
                                                final total = allData
                                                    .where((e) =>
                                                        e.prabhavishetra ==
                                                        prabhav)
                                                    .fold<int>(
                                                        0,
                                                        (sum, e) =>
                                                            sum +
                                                            (e.vasticnt ?? 0));
                                                return Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(
                                                    '$total',
                                                    style: TextStyle(
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
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'sajareHonareSan',
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
                              if (data != null && data!.mahatvacesana != null)
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
                                      headingTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('vastitiHonareSanUtsav')}",
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
                                      rows: data!.mahatvacesana!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(item.value ?? ''))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.count.toString()))),
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
                      title: 'sajareHonareKaryakram',
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
                              if (data != null &&
                                  data!.samajikkaryakram != null)
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
                                      headingTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('vastitiHonareSamajikKaryaKram')}",
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
                                      rows: data!.samajikkaryakram!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(item.value ?? ''))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.count.toString()))),
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
                      title: 'gatividhiUpakraam',
                      children: [
                        Container(
                          // height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              child: Table(
                                border: TableBorder.all(color: Colors.grey),
                                defaultColumnWidth: IntrinsicColumnWidth(),
                                children: [
                                  // Header Row
                                  TableRow(
                                    decoration: BoxDecoration(
                                        color: Colors.purpleAccent.shade200),
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              "${Statics.getLabel('prakaarSthiti')}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      ...subtypesGatividhi
                                          .map((subtype) => TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(subtype,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white)),
                                                ),
                                              )),
                                    ],
                                  ),
                                  // Data Rows
                                  ...maintypesGatividhi.map((mt) {
                                    return TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(mt),
                                          ),
                                        ),
                                        ...subtypesGatividhi.map((st) {
                                          final value =
                                              vastiMapgatividhi[mt]?[st] ?? 0;
                                          return TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(value.toString()),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'JagranShreniUpkram',
                      children: [
                        Container(
                          // height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              child: Table(
                                border: TableBorder.all(color: Colors.grey),
                                defaultColumnWidth: IntrinsicColumnWidth(),
                                children: [
                                  // Header Row
                                  TableRow(
                                    decoration: BoxDecoration(
                                        color: Colors.purpleAccent.shade200),
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              "${Statics.getLabel('prakaarSthiti')}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      ...subtypesJagran
                                          .map((subtype) => TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(subtype,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white)),
                                                ),
                                              )),
                                    ],
                                  ),
                                  // Data Rows
                                  ...maintypesJagran.map((mt) {
                                    return TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(mt),
                                          ),
                                        ),
                                        ...subtypesJagran.map((st) {
                                          final value =
                                              vastiMapJagran[mt]?[st] ?? 0;
                                          return TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(value.toString()),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'BalopasanaKendra',
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
                              if (data != null &&
                                  data!.balopasanakendra != null)
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
                                      headingTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('BalopasanaKendra')}",
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
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('kendrsSankhya')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: data!.balopasanakendra!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(item.value ?? ''))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.count.toString()))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.sankhya.toString()))),
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
                      title: 'MotheVyasaayiKendra',
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
                              if (data != null &&
                                  data!.mothevyavasayikakendra != null)
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
                                      headingTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('MotheVyasaayiKendra')}",
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
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('kendrsSankhya')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: data!.mothevyavasayikakendra!
                                          .map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(item.value ?? ''))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.count.toString()))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.sankhya.toString()))),
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
                      title: 'MotheRugnalay',
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
                              if (data != null && data!.motherugnalaya != null)
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
                                      headingTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('MotheRugnalay')}",
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
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('hospitalCount')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: data!.motherugnalaya!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(item.value ?? ''))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.count.toString()))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.sankhya.toString()))),
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
                      title: 'shaikshanikSanstha',
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
                              if (data != null &&
                                  data!.schooltapasilaforschool != null)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Center(
                                    child: Text(
                                      "${Statics.getLabel('school')}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              if (data != null &&
                                  data!.schooltapasilaforschool != null)
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
                                      headingTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('school')}",
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
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('schoolCount')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: data!.schooltapasilaforschool!
                                          .map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(
                                                    item.value.toString()))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.count.toString()))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.sankhya.toString()))),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              if (data != null &&
                                  data!.schooltapasilaforclg != null)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Center(
                                    child: Text(
                                      "${Statics.getLabel('College')}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              if (data != null &&
                                  data!.schooltapasilaforclg != null)
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
                                      headingTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('College')}",
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
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('CollegeCount')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: data!.schooltapasilaforclg!
                                          .map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(
                                                    item.value.toString()))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.count.toString()))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.sankhya.toString()))),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              if (data != null &&
                                  data!.schooltapasilaformedium != null)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Center(
                                    child: Text(
                                      "${Statics.getLabel('vishisthaSansthan')}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              if (data != null &&
                                  data!.schooltapasilaformedium != null)
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
                                      headingTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
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
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                'संस्थान संख्या',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: data!.schooltapasilaformedium!
                                          .map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(
                                                    item.count.toString()))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.sankhya.toString()))),
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
                      title: 'MaidaanUdyan',
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
                              if (data != null && data!.maidan != null)
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
                                      headingTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
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
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('maidanUdyanCount')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: data!.maidan!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(
                                                child: Text(
                                                    item.count.toString()))),
                                            DataCell(Center(
                                                child: Text(
                                                    item.sankhya.toString()))),
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
                      title: 'DharmikNetrutwa',
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              if (data != null && data!.dhaarmiknetrtav != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis
                                        .horizontal, // for horizontal scrolling of table
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      child: DataTable(
                                        headingRowColor:
                                            MaterialStateProperty.resolveWith(
                                          (states) => Colors.purpleAccent[200],
                                        ),
                                        headingTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        columns: [
                                          DataColumn(
                                            label: Center(
                                              child: Text(
                                                "${Statics.getLabel('SelectFrequency')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Center(
                                              child: Text(
                                                "${Statics.getLabel('vastiCount')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Center(
                                              child: Text(
                                                "${Statics.getLabel('count')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows:
                                            data!.dhaarmiknetrtav!.map((item) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Center(
                                                  child: Text(
                                                      item.value.toString()))),
                                              DataCell(Center(
                                                  child: Text(
                                                      item.count.toString()))),
                                              DataCell(Center(
                                                  child: Text(item.sankhya
                                                      .toString()))),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                    commonExpansionTile(
                      title: 'VastiSamajikGarja',
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              if (data != null &&
                                  data!.vastitilasamajika != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis
                                        .horizontal, // for horizontal scrolling of table
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      child: DataTable(
                                        headingRowColor:
                                            MaterialStateProperty.resolveWith(
                                          (states) => Colors.purpleAccent[200],
                                        ),
                                        headingTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        columns: [
                                          DataColumn(
                                            label: Center(
                                              child: Text(
                                                "${Statics.getLabel('vastitilSamajikQueGaraja')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Center(
                                              child: Text(
                                                "${Statics.getLabel('vastiCount')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows: data!.vastitilasamajika!
                                            .map((item) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Center(
                                                  child: Text(
                                                      item.value.toString()))),
                                              DataCell(Center(
                                                  child: Text(
                                                      item.count.toString()))),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                    commonExpansionTile(
                      title: 'karyakramKarnyacheThikaan',
                      children: [
                        SingleChildScrollView(
                            child: Column(
                          children: [
                            if (data != null &&
                                data!.jahirakaryakramasambandhi != null)
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
                                    headingTextStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    columns: [
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              "${Statics.getLabel('karyakramKarnyacheThikaan')}",
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
                                              "${Statics.getLabel('vastiCount')}",
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
                                              "${Statics.getLabel('thikaanCount')}",
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
                                              "${Statics.getLabel('nivaasAvailable')}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: data!.jahirakaryakramasambandhi!
                                        .map((item) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Center(
                                              child:
                                                  Text(item.value.toString()))),
                                          DataCell(Center(
                                              child:
                                                  Text(item.count.toString()))),
                                          DataCell(Center(
                                              child: Text(
                                                  item.sankhya.toString()))),
                                          DataCell(Center(
                                              child: Text(item
                                                  .nivasasathiupalabdha
                                                  .toString()))),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                          ],
                        )),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'DurjanShakti',
                      children: [
                        SingleChildScrollView(
                            child: Column(
                          children: [
                            if (data != null && data!.durjanshakti != null)
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
                                    headingTextStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    columns: [
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              "${Statics.getLabel('DurjanShakti')}",
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
                                              "${Statics.getLabel('vastiCount')}",
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
                                              "${Statics.getLabel('durjanShakatiCount')}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: data!.durjanshakti!.map((item) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Center(
                                              child:
                                                  Text(item.value.toString()))),
                                          DataCell(Center(
                                              child:
                                                  Text(item.count.toString()))),
                                          DataCell(Center(
                                              child: Text(
                                                  item.sankhya.toString()))),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                          ],
                        )),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'HinduVeer',
                      children: [
                        SingleChildScrollView(
                            child: Column(
                          children: [
                            if (data != null && data!.hinduvirayadi != null)
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
                                    headingTextStyle: TextStyle(
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
                                              "${Statics.getLabel('vastiCount')}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: data!.hinduvirayadi!.map((item) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Center(
                                              child: Text(
                                                  item.sankhya.toString()))),
                                          DataCell(Center(
                                              child:
                                                  Text(item.count.toString()))),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                          ],
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // commonExpansionTile(
                    //   title: 'StharInfo',
                    //   children: [
                    Card(
                        elevation: 1,
                        margin: EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              SingleColumnRow(
                                  txtString:
                                      "${Statics.getLabel('fireBrigateCenterCount')}",
                                  value: data?.vastiloksankhya?.fireBrigade
                                      .toString(),
                                  fontsize: 15),
                              SingleColumnRow(
                                  txtString:
                                      "${Statics.getLabel('policeStationCount')}",
                                  value: data?.vastiloksankhya?.policeThane
                                      .toString(),
                                  fontsize: 15),
                            ],
                          ),
                        ))

                    //   ],
                    // ),
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
      margin: EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent, // removes the expansion line
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16.0),
          title: Text(
            Statics.getLabel(title),
            style: TextStyle(
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
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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

  List<Widget> _buildGroupedTables(
      List<UpasanaSthal> list, BuildContext context) {
    // Group by 'prakar'
    Map<String, List<UpasanaSthal>> grouped = {};
    for (var item in list) {
      String key = item.prakar.toString();
      grouped.putIfAbsent(key, () => []).add(item);
    }

    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;
    double tableHeight = isTablet ? 400 : 300;
    double fontSize = isTablet ? 18 : 14;
    double headingFontSize = isTablet ? 20 : 16;
    EdgeInsets containerPadding =
        EdgeInsets.symmetric(horizontal: isTablet ? 16 : 8);

    return grouped.entries.map((entry) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: containerPadding,
            child: Text(
              'प्रकार: ${entry.key}',
              style: TextStyle(
                fontSize: headingFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin: containerPadding,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: tableHeight,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.purpleAccent[200],
                  ),
                  headingTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                  dataTextStyle: TextStyle(
                    fontSize: fontSize,
                  ),
                  columns: [
                    DataColumn(
                        label: Center(
                            child:
                                Text("${Statics.getLabel('UpasanaSthal')}"))),
                    DataColumn(
                        label: Center(
                            child: Text(
                                "${Statics.getLabel('SelectFrequency')}"))),
                    DataColumn(
                        label: Center(
                            child: Text("${Statics.getLabel('count')}"))),
                    DataColumn(label: Center(child: Text('किती वस्तीत'))),
                  ],
                  rows: entry.value.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(Center(child: Text(item.upaasanasthal ?? ''))),
                        DataCell(Center(child: Text(item.prakar.toString()))),
                        DataCell(Center(child: Text(item.tot.toString()))),
                        DataCell(Center(child: Text(item.vasticnt.toString()))),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}
