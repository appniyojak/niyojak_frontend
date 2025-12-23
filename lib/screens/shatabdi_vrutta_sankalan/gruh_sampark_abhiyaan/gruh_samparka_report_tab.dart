import 'dart:convert';
import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' as txt;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/AbhiyaanLoginDataResponse.dart';
import '../../../models/response_model/gruh_abhiyaan_report_model.dart';
import '../../../providers/bals.dart';

class GruhSamparkaReportTab extends StatefulWidget {
  final AbhiyanSwayamsevakdata? initialData;

  const GruhSamparkaReportTab({super.key, this.initialData});

  @override
  State<GruhSamparkaReportTab> createState() => _GruhSamparkaReportTabState();
}

class _GruhSamparkaReportTabState extends State<GruhSamparkaReportTab> with AutomaticKeepAliveClientMixin {
  // This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  bool _isSearching = false;

  List<Table1List> levelWiseList = [];
  List<Table1List> dateWiseList = [];
  List<Table3List> summaryList = [];
  List<Table4List> levelWiseCountsList = [];
  List<Table5List> sajjanAnyaCountsList = [];

  final horizontalController = ScrollController();
  final horizontalController2 = ScrollController();

  List<LevelMasterBAL>? _level;
  List<GeoUnitMasterBAL>? _geoUnits;
  String? _levelValue = "";
  String? _geoUnitsValue = "";

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;

  bool? _linkedMahaanagarDisable = false;
  bool? _linkedVibhaagDisable = false;
  bool? _linkedbhaagDisable = false;
  bool? _linkedshaharDisable = false;
  bool? _linkednagarDisable = false;
  bool? _linkedmandalDisable = false;
  bool? _linkedgraamDisable = false;
  bool? _linkedvastiDisable = false;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";

  // String? _linkedMahaanagarName = '';
  // String? _linkedVibhaagName = '';
  String? _linkedbhaagName = "";
  String? _linkedshaharName = "";
  String? _linkednagarName = "";
  String? _linkedmandalName = "";
  String? _linkedgraamName = "";
  String? _linkedvastiName = "";

  String? type;
  List<MenuChoices> choices = [];
  String? selectedDayitvValue = "";

  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  String _selctedLevelNames = '';
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId;

  bool _isExpanded = true;
  bool _searched = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    populateDropdown();
  }

  @override
  void didUpdateWidget(covariant GruhSamparkaReportTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialData != oldWidget.initialData && widget.initialData != null) {
      populateDropdown();
    }
  }

  Future<void> _getSwList() async {
    try {
      levelWiseList = [];
      dateWiseList = [];
      // summaryList = [];
      levelWiseCountsList = [];
      // sajjanAnyaCountsList = [];
      print("calling");
      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        var inputData = {
          "AppUserID": Statics.abhiyaanUserDetails["isEmpty"] ? Statics.userDetails["userID"] : Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"],
          "GeoUnitID": _selectedGeoUnitId ?? 0, //(_linkedvastiValue != null && _linkedvastiValue!.isNotEmpty) ? _linkedvastiValue : _linkedgraamValue,
        };
        print(jsonEncode(inputData));
        final _report = await Statics.getReportforGruhAbhiyaan(inputData, context: context);
        setState(() {});
        if (_report != null) {
          setState(() {
            levelWiseList = _report.table1List ?? [];
            dateWiseList = _report.table2List ?? [];
            summaryList = _report.table3List ?? [];
            levelWiseCountsList = _report.table4List ?? [];
            sajjanAnyaCountsList = _report.table5List ?? [];
          });
        }
      }
    } catch (e) {
      print("exception >>>>>>>>>>> $e");
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////

  Future<void> populateDropdown({bool isClear = false}) async {
    setState(() {
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
    if (isClear) return;
    if (widget.initialData != null && !Statics.abhiyaanUserDetails["isEmpty"]) {
      // if (widget.initialData!.parentMahaanagarID != null) {
      //   setState(() {
      //     _isExpanded = true;
      //     _linkedMahaanagarDisable = true;
      //     _linkedMahaanagarValue = widget.initialData!.parentMahaanagarID.toString();
      //     _selectedGeoUnitId = widget.initialData!.parentMahaanagarID.toString();
      //   });
      // }
      // await populatelinkedVibhaagDropdown('');
      //
      // if (widget.initialData!.parentVibhaagID != null) {
      //   await populatelinkedBhaagDropdown(widget.initialData!.parentVibhaagID.toString());
      //   setState(() {
      //     _isExpanded = true;
      //     _linkedVibhaagDisable = true;
      //     _linkedVibhaagValue = widget.initialData!.parentVibhaagID.toString();
      //     _selectedGeoUnitId = widget.initialData!.parentVibhaagID.toString();
      //   });
      // }
      // if (widget.initialData!.parentBhaagID != null) {
      //   await populatelinkedNagarDropdown(widget.initialData!.parentBhaagID.toString(), null);
      //
      //   final selectedItem = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == widget.initialData!.parentBhaagID.toString());
      //
      //   setState(() {
      //     _isExpanded = true;
      //     _linkedbhaagDisable = true;
      //     _linkedbhaagValue = widget.initialData!.parentBhaagID.toString();
      //     _selectedGeoUnitId = widget.initialData!.parentBhaagID.toString();
      //     _linkedbhaagName = selectedItem.name ?? "";
      //   });
      // }
      // if (widget.initialData!.parentNagarID != null) {
      //   await populatelinkedMandalDropdown(widget.initialData!.parentNagarID.toString());
      //   await populatelinkedVastiDropdown(widget.initialData!.parentNagarID.toString());
      //
      //   final selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == widget.initialData!.parentNagarID.toString());
      //
      //   setState(() {
      //     _isExpanded = true;
      //     _linkednagarDisable = true;
      //     _linkednagarValue = widget.initialData!.parentNagarID.toString();
      //     _selectedGeoUnitId = widget.initialData!.parentNagarID.toString();
      //     _linkednagarName = selectedItem.name ?? "";
      //   });
      // }
      // setState(() {
      //   if (widget.initialData!.parentMandalID != null) {
      //     _isExpanded = true;
      //     _linkedmandalDisable = true;
      //     _linkedmandalValue = widget.initialData!.parentMandalID.toString();
      //     _selectedGeoUnitId = widget.initialData!.parentMandalID.toString();
      //
      //     final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == widget.initialData!.parentMandalID.toString());
      //
      //     _linkedmandalName = selectedItem.name ?? "";
      //     populatelinkedGraamDropdown(_linkedmandalValue);
      //   }
      //   if (widget.initialData!.levelName == "Vasti" && widget.initialData!.geoUnitID != null) {
      //     _isExpanded = true;
      //     _linkedvastiDisable = true;
      //     _linkedvastiValue = widget.initialData!.geoUnitID.toString();
      //     _selectedGeoUnitId = widget.initialData!.geoUnitID.toString();
      //
      //     final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == widget.initialData!.geoUnitID.toString());
      //
      //     _linkedvastiName = selectedItem.name ?? "";
      //   } else if (widget.initialData!.levelName == "Graam" && widget.initialData!.geoUnitID != null) {
      //     _isExpanded = true;
      //     _linkedgraamDisable = true;
      //     _linkedgraamValue = widget.initialData!.geoUnitID.toString();
      //     _selectedGeoUnitId = widget.initialData!.geoUnitID.toString();
      //
      //     final selectedItem = _linkedgraam!.firstWhere((bg) => bg.geoUnitID.toString() == widget.initialData!.geoUnitID.toString());
      //
      //     _linkedgraamName = selectedItem.name ?? "";
      //   } else if (widget.initialData!.levelName == "Mandal" && widget.initialData!.geoUnitID != null) {
      //     _isExpanded = true;
      //     _linkedmandalDisable = true;
      //     _linkedmandalValue = widget.initialData!.geoUnitID.toString();
      //     _selectedGeoUnitId = widget.initialData!.geoUnitID.toString();
      //     populatelinkedGraamDropdown(_linkedmandalValue);
      //
      //     final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == widget.initialData!.geoUnitID.toString());
      //
      //     _linkedmandalName = selectedItem.name ?? "";
      //   } else if (widget.initialData!.levelName == "Nagar" && widget.initialData!.geoUnitID != null) {
      //     _isExpanded = true;
      //     _linkednagarDisable = true;
      //     _linkednagarValue = widget.initialData!.geoUnitID.toString();
      //     _selectedGeoUnitId = widget.initialData!.geoUnitID.toString();
      //     populatelinkedMandalDropdown(_linkednagarValue);
      //     populatelinkedVastiDropdown(_linkednagarValue);
      //
      //     final selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == widget.initialData!.geoUnitID.toString());
      //
      //     _linkednagarName = selectedItem.name ?? "";
      //   } else if (widget.initialData!.levelName == "Bhaag" && widget.initialData!.geoUnitID != null) {
      //     _isExpanded = true;
      //     _linkedbhaagDisable = true;
      //     _linkedbhaagValue = widget.initialData!.geoUnitID.toString();
      //     _selectedGeoUnitId = widget.initialData!.geoUnitID.toString();
      //     populatelinkedNagarDropdown(_linkedbhaagValue, null);
      //
      //     final selectedItem = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == widget.initialData!.geoUnitID.toString());
      //
      //     _linkedbhaagName = selectedItem.name ?? "";
      //   } else {
      //     _isExpanded = true;
      //     // _linkedgraamDisable = true;
      //     _linkedbhaagValue = null;
      //     _linkedshaharValue = null;
      //     _linkednagarValue = null;
      //     _linkedmandalValue = null;
      //     _linkedgraamValue = null;
      //     _linkedvastiValue = null;
      //   }
      // });
    } else {
      _isExpanded = true;
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    List<GeoUnitMasterBAL> data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '', isAbhiyaan: true);
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    print("populatelinkedVibhaagDropdown $mahaanagarIDStr");
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '', isAbhiyaan: true);
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '', isAbhiyaan: true);
    setState(() {
      _linkedbhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '', isAbhiyaan: true);
    setState(() {
      _linkedshahar = (shDD.length > 0 ? shDD : null);
    });
    return shDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
// print("populatelinkedNagarDropdown ${bhaagIDStr} == ${shaharIDStr}  ");
    _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    print("print LevelID > ${Statics.userDetails["LevelID"]}");
    print("shaharIDStr shaharIDStr $shaharIDStr");
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr!, 'Shahar', '', isAbhiyaan: true);
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '', isAbhiyaan: true);
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(String? nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandalName = _linkedgraamName = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, 'Nagar', '', isAbhiyaan: true);
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String? mandalIDStr) async {
    _linkedgraamValue = null;
    _linkedgraamName = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '', isAbhiyaan: true);
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String? nagarIDStr) async {
    _linkedvastiValue = null;
    _linkedvastiName = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', '', isAbhiyaan: true);
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
    return vsDD;
  }

  //////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    // You must call super.build(context) when using AutomaticKeepAliveClientMixin
    super.build(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "${Statics.getLabel('Abhiyaan')} ${Statics.getLabel('Reportonly')}",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 15),
            _buildExpansionPanel(),
            SizedBox(height: MediaQuery
                .of(context)
                .size
                .height * 0.03),
            if (_searched) ...[
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.03),
              nagarMandalCountsTable(),
              SizedBox(height: 21),
              vastiGramNamesTable(),
              SizedBox(height: 21),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  Statics.getLabel("levelWiseAbhiyaan"),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              // dateWiseDataInChart(),
              // SizedBox(height: 12),
              levelWiseTable(),
              SizedBox(height: 21),
              dateWiseTable(),
              SizedBox(height: 21),
              specialVyaktiTable(),
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.1),
            ],
          ],
        ),
      ),
    );
  }

  Widget levelWiseTable() {
    // final level = [Statics.getLabel("Graam"), Statics.getLabel("Vasti")];
    final headers = [
      // Statics.getLabel('gruhSamarkitGhar'),
      Statics.getLabel('gruhVitaritKarpatra'),
      Statics.getLabel('gruhPustakVikti'),
      Statics.getLabel('gruhSpecialContact'),
      Statics.getLabel('gruhSahabhaagiKaaryakartaaMaleCount'),
      Statics.getLabel('gruhSahabhaagiKaaryakartaaFemaleCount'),
      // Statics.getLabel('gruhSahabhaagiKaaryakartaaTotalCount'),
      if (levelWiseList.any((e) => e.ekunswayamsevak != null)) Statics.getLabel('gruhAbhiyaanSwayamsevakCount'),
      Statics.getLabel('gruhSwayamsevakKaryakartaCount'),
      // Statics.getLabel('gruhAttendance'),
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 8.0, top: 12),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade800)),
        padding: EdgeInsets.all(4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date column as DataTable
            DataTable(
              headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
              columnSpacing: 0,
              horizontalMargin: 16,
              border: TableBorder.all(color: Colors.black26),
              columns: [
                DataColumn(
                  label: Center(
                    child: Text(
                      "${Statics.getLabel("LevelName")}",
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
              // dataRowMinHeight: 40,
              // dataRowMaxHeight: 120,
              rows: [
                // rows from data
                ...levelWiseList.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(Statics.getLabel(item.levelName ?? "", returnKey: true))),
                  ]);
                }),
                // total row for date-column table (shows label)
                DataRow(
                  color: MaterialStatePropertyAll(Colors.yellow.shade100),
                  cells: [
                    DataCell(Text(
                      'Total',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    )),
                  ],
                ),
              ],
            ),

            // Horizontal area for other numeric columns
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                controller: horizontalController,
                child: SingleChildScrollView(
                  controller: horizontalController,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 0,
                    horizontalMargin: 0,
                    headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                    border: TableBorder(
                      verticalInside: BorderSide(width: 0.7, color: Colors.grey.shade300),
                    ),
                    columns: headers
                        .map((header) =>
                        DataColumn(
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            constraints: const BoxConstraints(minWidth: 30, maxWidth: 130),
                            child: Text(
                              header,
                              softWrap: true,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))
                        .toList(),
                    rows: [
                      // per-item rows
                      ...levelWiseList.map((item) {
                        return DataRow(cells: [
                          // DataCell(Center(child: Text((item.samparkitghar ?? 0).toString()))),
                          DataCell(Center(child: Text((item.vitaritkarpatra ?? 0).toString()))),
                          DataCell(Center(child: Text((item.pustakvikrisankhya ?? 0).toString()))),
                          DataCell(Center(child: Text((item.totalAtithiCount ?? 0).toString()))),
                          DataCell(Center(child: Text((item.malecount ?? 0).toString()))),
                          DataCell(Center(child: Text((item.femalecount ?? 0).toString()))),
                          // DataCell(Center(child: Text((item.ekunsamparkhetukaryakarta ?? 0).toString()))),
                          if (levelWiseList.any((e) => e.ekunswayamsevak != null)) DataCell(Center(child: Text((item.ekunswayamsevak ?? 0).toString()))),
                          DataCell(Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 0.4),
                            decoration: BoxDecoration(color: Colors.green.shade100),
                            child: Center(
                                child: Text(
                                  ((item.malecount ?? 0) + (item.femalecount ?? 0) + (item.ekunswayamsevak ?? 0)).toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          )),
                          // DataCell(Center(child: Text((item.attcount ?? 0).toString()))),
                        ]);
                      }),

                      // totals row
                      DataRow(color: MaterialStatePropertyAll(Colors.yellow.shade100), cells: [
                        // DataCell(Center(child: Text(levelWiseList.fold(0, (sum, item) => sum + (item.samparkitghar ?? 0)).toString()))),
                        DataCell(Center(child: Text(levelWiseList.fold(0, (sum, item) => sum + (item.vitaritkarpatra ?? 0)).toString()))),
                        DataCell(Center(child: Text(levelWiseList.fold(0, (sum, item) => sum + (item.pustakvikrisankhya ?? 0)).toString()))),
                        DataCell(Center(child: Text(levelWiseList.fold(0, (sum, item) => sum + (item.totalAtithiCount ?? 0)).toString()))),
                        DataCell(Center(child: Text(levelWiseList.fold(0, (sum, item) => sum + (item.malecount ?? 0)).toString()))),
                        DataCell(Center(child: Text(levelWiseList.fold(0, (sum, item) => sum + (item.femalecount ?? 0)).toString()))),
                        // DataCell(Center(child: Text(levelWiseList.fold(0, (sum, item) => sum + (item.ekunsamparkhetukaryakarta ?? 0)).toString()))),
                        if (levelWiseList.any((e) => e.ekunswayamsevak != null)) DataCell(Center(child: Text(levelWiseList.fold(0, (sum, item) => sum + (item.ekunswayamsevak ?? 0)).toString()))),
                        DataCell(Container(
                          width: double.infinity,
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.green.shade100)), color: Colors.green.shade100),
                          child: Center(
                              child: Text(
                                (levelWiseList.fold(0, (sum, item) => sum + (item.malecount ?? 0)) +
                                    levelWiseList.fold(0, (sum, item) => sum + (item.femalecount ?? 0)) +
                                    levelWiseList.fold(0, (sum, item) => sum + (item.ekunswayamsevak ?? 0)))
                                    .toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        )),
                        // DataCell(Center(child: Text(levelWiseList.fold(0, (sum, item) => sum + (item.attcount ?? 0)).toString()))),
                      ])
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget levelWiseDataInChart() {
    // parse json

    final List<dynamic> table = levelWiseList.map((e) => e.toJson()).toList() as List<dynamic>;

    // ensure we have exactly two levels (Graam and वस्ती). If not, this still maps based on available items.
    final List<Map<String, dynamic>> rows = table.map((e) => Map<String, dynamic>.from(e as Map)).toList();

    // keys we want to plot in order
    final List<String> keys = [
      'vitaritkarpatra',
      'pustakvikrisankhya',
    ];

    // Extract counts per level per key
    // values[i][j] => i = group index (0..2), j = series index (0..rows.length-1)
    final List<List<double>> values = List.generate(keys.length, (i) {
      return List.generate(rows.length, (j) {
        final raw = rows[j][keys[i]];
        if (raw == null) return 0.0;
        if (raw is num) return raw.toDouble();
        return double.tryParse(raw.toString()) ?? 0.0;
      });
    });

    // compute min/max across all values
    double minVal = double.infinity;
    double maxVal = double.negativeInfinity;
    for (final group in values) {
      for (final v in group) {
        if (v.isFinite) {
          if (v < minVal) minVal = v;
          if (v > maxVal) maxVal = v;
        }
      }
    }
    if (minVal == double.infinity) minVal = 0;
    if (maxVal == double.negativeInfinity) maxVal = 0;

    // define gap (tick interval)
    const double gap = 50;

    // compute nice minY and maxY
    // ensure minY is floored to nearest gap, maxY is ceiled to nearest gap
    double minY = (minVal / gap).floor() * gap;
    log("$minY>>>>>>>>>>>>>>>>>>>>>>> minY");
    double maxY = (maxVal / gap).ceil() * gap;
    log("$maxY>>>>>>>>>>>>>>>>>>>>>>> maxY");
    // if minY == maxY (all values equal), expand a little
    if (minY == maxY) {
      minY = (minY - gap).clamp(0, double.infinity);
      maxY = maxY + gap;
    }
    // Ensure minY non-negative
    if (minY < 0) minY = 0;

    // colors for the two bars (series)
    final List<Color> seriesColors = [const Color(0xFF6C3DF4), const Color(0xFF39B54A)];

    final dataMax = values.expand((e) => e).reduce((a, b) => a > b ? a : b);

    // final level = [Statics.getLabel("Graam"), Statics.getLabel("Vasti")];
    final headers = [
      Statics.getLabel('gruhSamarkitGhar'),
      Statics.getLabel('gruhVitaritKarpatra'),
      Statics.getLabel('gruhPustakVikti'),
      Statics.getLabel('gruhSpecialContact'),
      Statics.getLabel('gruhAttendance'),
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 8.0, top: 12),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade800)),
        padding: EdgeInsets.all(4),
        child: Column(
          children: [
            const SizedBox(height: 6),
            SizedBox(
              height: 400,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: dataMax == 0 ? 10 : dataMax * 1.15,
                  minY: minY,
                  groupsSpace: 24,
                  barTouchData: BarTouchData(enabled: true, touchTooltipData: BarTouchTooltipData(getTooltipColor: (group) => Colors.white)),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        reservedSize: 42,
                        // interval: gap,
                        getTitlesWidget: (value, meta) {
                          // show integer ticks
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.black54, fontSize: 12),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double val, TitleMeta meta) {
                          final int index = val.toInt();
                          if (index < 0 || index >= keys.length) return const SizedBox.shrink();
                          // friendly label for bottom
                          final labelMap = {
                            'vitaritkarpatra': Statics.getLabel('gruhVitaritKarpatra'),
                            'pustakvikrisankhya': Statics.getLabel('gruhPustakVikti'),
                            // 'samparkitghar': Statics.getLabel('gruhSamarkitGhar'),
                          };
                          final label = labelMap[keys[index]] ?? keys[index];
                          return Title(
                            title: label,
                            color: Colors.black,
                            child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    // horizontalInterval: gap,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.12), strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(keys.length, (groupIndex) {
                    final groupValues = values[groupIndex];
                    // build bars for each series (rows)
                    final rods = List.generate(rows.length, (seriesIndex) {
                      final v = groupValues[seriesIndex];
                      return BarChartRodData(
                        toY: v,
                        width: 27,
                        // rodStackItems: [
                        //   BarChartRodStackItem(
                        //     0,
                        //     v,
                        //     Colors.transparent,
                        //     label: v.toString(), // text shown above the bar
                        //     labelStyle: const TextStyle(
                        //       fontSize: 12,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.deepOrange,
                        //     ),
                        //   ),
                        // ],
                        borderRadius: BorderRadius.circular(3),
                        gradient: LinearGradient(colors: [seriesColors[seriesIndex % seriesColors.length].withOpacity(0.95), seriesColors[seriesIndex % seriesColors.length]]),
                      );
                    });

                    // position bars inside group: use rods with showingTooltips? fl_chart will display them stacked by x position if you place them as BarChartGroupData with multiple rods
                    return BarChartGroupData(
                      x: groupIndex,
                      barRods: rods,
                      // spacing between bars inside group
                      barsSpace: 6,
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(rows.length, (i) {
                final name = rows[i]['LevelName']?.toString() ?? 'Series ${i + 1}';
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Container(width: 14, height: 14, decoration: BoxDecoration(color: seriesColors[i % seriesColors.length], borderRadius: BorderRadius.circular(4))),
                      const SizedBox(width: 6),
                      Text(name, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget dateWiseDataInChart() {
    if (dateWiseList.isEmpty) {
      return SizedBox(
        height: 120,
        width: double.infinity,
        child: Center(
          child: Text(
            Statics.getLabel("dateWiseDataNotAvailable"),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    // parse json

    final List<Map<String, dynamic>> table = dateWiseList.map((e) => Map<String, dynamic>.from(e.toJson())).toList();

    table.sort((a, b) => DateFormat('dd/MM/yyyy HH:mm:ss').parse(b['AbhiyaanDate']).compareTo(DateFormat('dd/MM/yyyy HH:mm:ss').parse(a['AbhiyaanDate'])));

// take latest 4
    final List<Map<String, dynamic>> rows = table.take(4).toList();

    // keys we want to plot in order
    final List<String> keys = [
      'vitaritkarpatra',
      'pustakvikrisankhya',
    ];

    // Extract counts per level per key
    // values[i][j] => i = group index (0..2), j = series index (0..rows.length-1)
    final List<List<double>> values = List.generate(rows.length, (dateIndex) {
      return List.generate(keys.length, (seriesIndex) {
        final raw = rows[dateIndex][keys[seriesIndex]];
        if (raw == null) return 0.0;
        if (raw is num) return raw.toDouble();
        return double.tryParse(raw.toString()) ?? 0.0;
      });
    });

    // compute min/max across all values
    double minVal = double.infinity;
    double maxVal = double.negativeInfinity;
    for (final group in values) {
      for (final v in group) {
        if (v.isFinite) {
          if (v < minVal) minVal = v;
          if (v > maxVal) maxVal = v;
        }
      }
    }
    if (minVal == double.infinity) minVal = 0;
    if (maxVal == double.negativeInfinity) maxVal = 0;

    // define gap (tick interval)
    const double gap = 50;

    // compute nice minY and maxY
    // ensure minY is floored to nearest gap, maxY is ceiled to nearest gap
    double minY = (minVal / gap).floor() * gap;
    print("$minY>>>>>>>>>>>>>>>>>>>>>>> minY");
    double maxY = (maxVal / gap).ceil() * gap;
    log("$maxY>>>>>>>>>>>>>>>>>>>>>>> maxY");
    // if minY == maxY (all values equal), expand a little
    if (minY == maxY) {
      minY = (minY - gap).clamp(0, double.infinity);
      maxY = maxY + gap;
    }
    // Ensure minY non-negative
    if (minY < 0) minY = 0;

    // colors for the two bars (series)
    final List<Color> seriesColors = [const Color(0xFF6C3DF4), const Color(0xFF39B54A)];

    final dataMax = values.expand((e) => e).reduce((a, b) => a > b ? a : b);

    // final level = [Statics.getLabel("Graam"), Statics.getLabel("Vasti")];
    final headers = [
      Statics.getLabel('gruhSamarkitGhar'),
      Statics.getLabel('gruhVitaritKarpatra'),
      Statics.getLabel('gruhPustakVikti'),
      Statics.getLabel('gruhSpecialContact'),
      Statics.getLabel('gruhAttendance'),
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 8.0, top: 12),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade800)),
        padding: EdgeInsets.all(4),
        child: Column(
          children: [
            const SizedBox(height: 6),
            SizedBox(
              height: 400,
              child: LineChart(
                LineChartData(
                  // For horizontal margin
                  minX: -0.2,
                  maxX: (rows.length - 1) + 0.2,
                  // For horizontal margin
                  maxY: dataMax == 0 ? 10 : dataMax * 1.15,
                  minY: minY,
                  // groupsSpace: 24,
                  // lineTouchData: const LineTouchData(enabled: false),
                  lineTouchData: LineTouchData(enabled: true, touchTooltipData: LineTouchTooltipData(getTooltipColor: (group) => Colors.white)),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        // interval: gap,
                        getTitlesWidget: (value, meta) {
                          // show integer ticks
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.black54, fontSize: 12),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1, // Ensure every date label is shown
                        getTitlesWidget: (double value, TitleMeta meta) {
                          // Prevent duplicate labels: only show for integer indices
                          if (value % 1 != 0) {
                            return const SizedBox.shrink();
                          }

                          final index = value.toInt();
                          if (index < 0 || index >= rows.length) return const SizedBox.shrink();

                          final label = rows[index]['AbhiyaanDate']
                              .toString()
                              .split(" ")
                              .first;

                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              label,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    // horizontalInterval: gap,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.12), strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: List.generate(keys.length, (seriesIndex) {
                    // Generate points (FlSpots)
                    final List<FlSpot> spots = List.generate(rows.length, (dateIndex) {
                      return FlSpot(dateIndex.toDouble(), values[dateIndex][seriesIndex]);
                    });

                    return LineChartBarData(
                      spots: spots,
                      isCurved: false,
                      color: seriesColors[seriesIndex],
                      barWidth: 3,
                      isStrokeCapRound: true,
                      // Dots at data points
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          // Dynamic Collision logic
                          final double currentVal = spot.y;
                          // Find the value of the other series at the same X point
                          final String otherKey = keys[seriesIndex == 0 ? 1 : 0];
                          final double otherVal = (rows[index][otherKey] ?? 0).toDouble();

                          double verticalOffset = -6; // Default distance above dot
                          final double diff = (currentVal - otherVal).abs();

                          // If gap < 8, shift the higher value further up and the lower value slightly down
                          if (diff < 8) {
                            if (currentVal >= otherVal) {
                              verticalOffset = -18; // Push higher value up
                            } else {
                              verticalOffset = 4; // Push lower value below the dot
                            }
                          }
                          return LabelWithCirclePainter(
                            label: spot.y.toInt().toString(),
                            labelStyle: TextStyle(
                              color: seriesColors[seriesIndex],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: seriesColors[seriesIndex],
                            offsetY: verticalOffset,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: seriesColors[seriesIndex].withOpacity(0.15),
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendItem(seriesColors[0], Statics.getLabel('gruhVitaritKarpatra')),
                const SizedBox(width: 16),
                _legendItem(seriesColors[1], Statics.getLabel('gruhPustakVikti')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget specialVyaktiTable() {
    // final level = [
    //   // Statics.getLabel('gruhSamarkitGhar'),
    //   Statics.getLabel('gruhVitaritKarpatra'),
    //   Statics.getLabel('gruhPustakVikti'),
    //   Statics.getLabel('gruhSpecialContact'),
    //   "सहभागी कार्यकर्ते संख्या", //Statics.getLabel('gruhAttendance'),
    //   // "सहभागी टोळी संख्या", //Statics.getLabel('gruhAttendance'),
    //   // Statics.getLabel('gruhAttendance'),
    // ];

    if (sajjanAnyaCountsList.isEmpty)
      return SizedBox(
        height: 120,
        width: double.infinity,
        child: Center(
          child: Text(
            Statics.getLabel("specialContactDataNotAvailable"),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   Statics.getLabel("SajjanShakti"),
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          // SizedBox(height: 8),
          ExpansionTile(
            tilePadding: EdgeInsets.only(right: 16, left: 16),
            childrenPadding: EdgeInsets.zero,
            collapsedBackgroundColor: Colors.purple.shade100,
            backgroundColor: Colors.purple.shade100,
            initiallyExpanded: true,
            shape: RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.circular(12)),
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              Statics.getLabel("SajjanShakti"),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent.shade700,
              ),
            ),
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 8.0, top: 12),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade800)),
                  padding: EdgeInsets.all(4),
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                    columnSpacing: 24,
                    horizontalMargin: 16,
                    border: TableBorder.all(color: Colors.black26),
                    columns: [
                      DataColumn(
                        label: Center(
                          child: Text(
                            "${Statics.getLabel("shreni")}",
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text(
                            "${Statics.getLabel("Total")}",
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                    // dataRowMinHeight: 40,
                    // dataRowMaxHeight: 120,
                    rows: [
                      // rows from data
                      ...sajjanAnyaCountsList.where((e) => e.typename == "sajjanshakti").map((item) {
                        return DataRow(cells: [
                          DataCell(Text(item.shreneename ?? "")),
                          DataCell(Text(item.cnt.toString())),
                        ]);
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),

          //
          SizedBox(height: 16),
          // Text(
          //   Statics.getLabel("anyaPrabhaviLok"),
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          // SizedBox(height: 8),
          ExpansionTile(
            tilePadding: EdgeInsets.only(right: 16, left: 16),
            childrenPadding: EdgeInsets.zero,
            collapsedBackgroundColor: Colors.purple.shade100,
            backgroundColor: Colors.purple.shade100,
            initiallyExpanded: true,
            shape: RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.circular(12)),
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              Statics.getLabel("anyaPrabhaviLok"),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent.shade700,
              ),
            ),
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 8.0, top: 12),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade800)),
                  padding: EdgeInsets.all(4),
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                    columnSpacing: 24,
                    horizontalMargin: 16,
                    border: TableBorder.all(color: Colors.black26),
                    columns: [
                      DataColumn(
                        label: Center(
                          child: Text(
                            "${Statics.getLabel("shreni")}",
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text(
                            "${Statics.getLabel("Total")}",
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                    // dataRowMinHeight: 40,
                    // dataRowMaxHeight: 120,
                    rows: [
                      // rows from data
                      ...sajjanAnyaCountsList.where((e) => e.typename == "Anyaprabhavilokam").map((item) {
                        return DataRow(cells: [
                          DataCell(Text(item.shreneename ?? "")),
                          DataCell(Text(item.cnt.toString())),
                        ]);
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dateWiseTable() {
    final level = [
      // Statics.getLabel('gruhSamarkitGhar'),
      Statics.getLabel('gruhVitaritKarpatra'),
      Statics.getLabel('gruhPustakVikti'),
      Statics.getLabel('gruhSpecialContact'),
      if (dateWiseList.any((e) => e.malecount != null)) Statics.getLabel('gruhSahabhaagiKaaryakartaaMaleCount'),
      if (dateWiseList.any((e) => e.femalecount != null)) Statics.getLabel('gruhSahabhaagiKaaryakartaaFemaleCount'),
      if (dateWiseList.any((e) => e.ekunswayamsevak != null)) Statics.getLabel('gruhAbhiyaanSwayamsevakCount'),
      if (dateWiseList.any((e) => e.ekunsamparkhetukaryakarta != null)) Statics.getLabel('gruhSahabhaagiKaaryakartaaTotalCount'),
      if (dateWiseList.any((e) => e.ekuntotal != null)) Statics.getLabel('gruhSwayamsevakKaryakartaCount2'),
    ];

    if (dateWiseList.isEmpty)
      return SizedBox(
        height: 120,
        width: double.infinity,
        child: Center(
          child: Text(
            Statics.getLabel("dateWiseDataNotAvailable"),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Statics.getLabel("dayWiseAbhiyaan"),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 8.0, top: 12),
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade800)),
              padding: EdgeInsets.all(4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date column as DataTable
                  DataTable(
                    headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                    columnSpacing: 0,
                    horizontalMargin: 0,
                    border: TableBorder.all(color: Colors.black26),
                    columns: [
                      DataColumn(
                        label: Container(
                          alignment: Alignment.center,
                          // width: MediaQuery.sizeOf(context).width * 0.4,
                          constraints: BoxConstraints(maxWidth: MediaQuery
                              .sizeOf(context)
                              .width * 0.38),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "${Statics.getLabel("LevelName")}",
                            softWrap: true,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                    // dataRowMinHeight: 40,
                    // dataRowMaxHeight: 120,
                    rows: [
                      // rows from data
                      ...level
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return DataRow(cells: [
                          DataCell(Container(
                            // width: MediaQuery.sizeOf(context).width * 0.4,
                              constraints: BoxConstraints(maxWidth: MediaQuery
                                  .sizeOf(context)
                                  .width * 0.38),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(color: (index == (level.length - 1)) ? Colors.green.shade100 : null),
                              child: Text(
                                item,
                                style: TextStyle(fontWeight: (index == (level.length - 1)) ? FontWeight.bold : FontWeight.w500),
                              ))),
                        ]);
                      }),
                    ],
                  ),

                  // Horizontal area for other numeric columns
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: horizontalController2,
                      child: SingleChildScrollView(
                        controller: horizontalController2,
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 0,
                          horizontalMargin: 0,
                          headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                          border: TableBorder(verticalInside: BorderSide(width: 0.7, color: Colors.grey.shade200)),
                          columns: [
                            DataColumn(
                              label: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(color: Colors.yellow.shade100, border: Border.all(color: Colors.black26)),
                                // constraints: const BoxConstraints(minWidth: 30, maxWidth: 70),
                                child: Text(
                                  Statics.getLabel("Total"),
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ] +
                              dateWiseList
                                  .map((header) =>
                                  DataColumn(
                                    label: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      constraints: const BoxConstraints(minWidth: 30, maxWidth: 200),
                                      child: Text(
                                        header.abhiyaanDate
                                            .toString()
                                            .split(" ")
                                            .first,
                                        softWrap: true,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ))
                                  .toList(),
                          rows: [
                            // DataRow(cells: [
                            //   DataCell(Container(
                            //       decoration: BoxDecoration(
                            //         color: Colors.yellow.shade50,
                            //         border: Border.all(color: Colors.black26, width: 0.7),
                            //       ),
                            //       alignment: Alignment.center,
                            //       child: Text(dateWiseList.fold(0, (sum, item) => sum + (item.samparkitghar ?? 0)).toString()))),
                            //   ...dateWiseList.map((item) => DataCell(Center(child: Text((item.samparkitghar ?? 0).toString())))).toList(),
                            // ]),
                            DataRow(cells: [
                              DataCell(Container(
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.shade50,
                                    border: Border.all(color: Colors.black26, width: 0.7),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(dateWiseList.fold(0, (sum, item) => sum + (item.vitaritkarpatra ?? 0)).toString()))),
                              ...dateWiseList.map((item) => DataCell(Center(child: Text((item.vitaritkarpatra ?? 0).toString())))).toList(),
                            ]),
                            DataRow(cells: [
                              DataCell(Container(
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.shade50,
                                    border: Border.all(color: Colors.black26, width: 0.7),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(dateWiseList.fold(0, (sum, item) => sum + (item.pustakvikrisankhya ?? 0)).toString()))),
                              ...dateWiseList.map((item) => DataCell(Center(child: Text((item.pustakvikrisankhya ?? 0).toString())))).toList(),
                            ]),
                            DataRow(cells: [
                              DataCell(Container(
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.shade50,
                                    border: Border.all(color: Colors.black26, width: 0.7),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(dateWiseList.fold(0, (sum, item) => sum + (item.totalAtithiCount ?? 0)).toString()))),
                              ...dateWiseList.map((item) => DataCell(Center(child: Text((item.totalAtithiCount ?? 0).toString())))).toList(),
                            ]),
                            // DataRow(cells: [
                            //   DataCell(Container(
                            //       decoration: BoxDecoration(
                            //         color: Colors.yellow.shade50,
                            //         border: Border.all(color: Colors.black26, width: 0.7),
                            //       ),
                            //       alignment: Alignment.center,
                            //       child: Text(dateWiseList.fold(0, (sum, item) => sum + (item.samparkhetusahbhagisankhya ?? 0)).toString()))),
                            //   ...dateWiseList.map((item) => DataCell(Center(child: Text((item.samparkhetusahbhagisankhya ?? 0).toString())))).toList(),
                            // ]),
                            if (dateWiseList.any((e) => e.malecount != null))
                              DataRow(cells: [
                                DataCell(Container(
                                    decoration: BoxDecoration(
                                      color: Colors.yellow.shade50,
                                      border: Border.all(color: Colors.black26, width: 0.7),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(dateWiseList.fold(0, (sum, item) => sum + (item.malecount ?? 0)).toString()))),
                                if (dateWiseList.any((e) => e.malecount != null)) ...dateWiseList.map((item) => DataCell(Center(child: Text((item.malecount ?? 0).toString())))).toList(),
                              ]),
                            if (dateWiseList.any((e) => e.femalecount != null))
                              DataRow(cells: [
                                DataCell(Container(
                                    decoration: BoxDecoration(
                                      color: Colors.yellow.shade50,
                                      border: Border.all(color: Colors.black26, width: 0.7),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(dateWiseList.fold(0, (sum, item) => sum + (item.femalecount ?? 0)).toString()))),
                                if (dateWiseList.any((e) => e.femalecount != null)) ...dateWiseList.map((item) => DataCell(Center(child: Text((item.femalecount ?? 0).toString())))).toList(),
                              ]),
                            if (dateWiseList.any((e) => e.ekunswayamsevak != null))
                              DataRow(cells: [
                                DataCell(Container(
                                    decoration: BoxDecoration(
                                      color: Colors.yellow.shade50,
                                      border: Border.all(color: Colors.black26, width: 0.7),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(dateWiseList.fold(0, (sum, item) => sum + (item.ekunswayamsevak ?? 0)).toString()))),
                                if (dateWiseList.any((e) => e.ekunswayamsevak != null)) ...dateWiseList.map((item) => DataCell(Center(child: Text((item.ekunswayamsevak ?? 0).toString())))).toList(),
                              ]),
                            if (dateWiseList.any((e) => e.ekunsamparkhetukaryakarta != null))
                              DataRow(cells: [
                                DataCell(Container(
                                    decoration: BoxDecoration(
                                      color: Colors.yellow.shade50,
                                      border: Border.all(color: Colors.black26, width: 0.7),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(dateWiseList.fold(0, (sum, item) => sum + (item.ekunsamparkhetukaryakarta ?? 0)).toString()))),
                                if (dateWiseList.any((e) => e.ekunsamparkhetukaryakarta != null))
                                  ...dateWiseList.map((item) => DataCell(Center(child: Text((item.ekunsamparkhetukaryakarta ?? 0).toString())))).toList(),
                              ]),
                            if (dateWiseList.any((e) => e.ekuntotal != null))
                              DataRow(cells: [
                                DataCell(Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      border: Border.all(color: Colors.black26, width: 0.7),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      dateWiseList.fold(0, (sum, item) => sum + (item.ekuntotal ?? 0)).toString(),
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ))),
                                if (dateWiseList.any((e) => e.ekuntotal != null))
                                  ...dateWiseList
                                      .map((item) =>
                                      DataCell(Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade100,
                                            border: Border.all(color: Colors.black26, width: 0.7),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            (item.ekuntotal ?? 0).toString(),
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ))))
                                      .toList(),
                              ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showPopupList(String vastiStepStartedNames, {String type = "graam"}) {
    if (vastiStepStartedNames
        .trim()
        .isEmpty) {
      Statics.showToast(Statics.getLabel(type == "graam"
          ? 'graamNotAvailable'
          : type == "vasti"
          ? 'vastiNotAvailable'
          : type == "nagar"
          ? 'nagarNotAvailable'
          : type == "taluka"
          ? 'taalukaNotAvailable'
          : 'mandalNotAvailable'));
      return;
    }

    final List<String> namesList = vastiStepStartedNames.split('::').map((e) => e.trim()).toList();

    if (namesList.isEmpty || namesList.first.isEmpty) {
      Statics.showToast(Statics.getLabel(type == "graam"
          ? 'graamNotAvailable'
          : type == "vasti"
          ? 'vastiNotAvailable'
          : type == "nagar"
          ? 'nagarNotAvailable'
          : type == "taluka"
          ? 'taalukaNotAvailable'
          : 'mandalNotAvailable'));
      return;
    }

    showDialog(
      context: context,
      builder: (_) =>
          Dialog(
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
                        Statics.getLabel(type == "graam"
                            ? 'graamYaadi'
                            : type == "vasti"
                            ? 'vastiYaadi'
                            : type == "nagar"
                            ? 'nagarYaadi'
                            : type == "taluka"
                            ? 'taalukaYaadi'
                            : 'mandalYaadi'),
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
                        itemBuilder: (_, index) =>
                            Padding(
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

  Widget vastiGramNamesTable() {
    final _vastiData = summaryList.firstWhere((e) => e.typeName == "Vasti");
    final _gramData = summaryList.firstWhere((e) => e.typeName == "Gram");

    final vastiTitleList = [
      {"AbhiyaanStartedCountVasti": _vastiData.startedcount},
      {"AbhiyaanStartedCountNagar": _vastiData.startednagarcount},
      // {"totalNagar": _vastiData.nagarcount},
      {"totalVasti": _vastiData.vasticount},
    ];

    final graamTitleList = [
      {"AbhiyaanStartedCountGraam": _gramData.startedcount},
      {"AbhiyaanStartedCountMandal": _gramData.startedmandalcount},
      // {"totalTaluka": _gramData.nagarcount},
      {"totalMandal": _gramData.mandalcount},
      {"totalGraam": _gramData.gramcount},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Statics.getLabel("abhiyaanStatus"),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  child: DataTable(
                    columnSpacing: 0,
                    horizontalMargin: 16,
                    headingRowColor: MaterialStateProperty.all(Colors.orangeAccent.shade200),
                    headingTextStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    dataRowMinHeight: 60,
                    dataRowMaxHeight: 70,
                    columns: [
                      DataColumn(
                        label: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            Statics.getLabel('Vasti'),
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                      DataColumn(
                          label: IconButton(
                            icon: Icon(Icons.remove_red_eye, color: Colors.teal),
                            onPressed: () => showPopupList(_vastiData.vastiname.toString(), type: "vasti"),
                          )),
                    ],
                    rows: vastiTitleList
                        .asMap()
                        .entries
                        .map((e) =>
                        DataRow(color: MaterialStateProperty.all(Colors.orange.shade50), cells: [
                          DataCell(Container(margin: EdgeInsets.symmetric(horizontal: 8), alignment: Alignment.center, child: Text(Statics.getLabel(e.value.keys.first.toString())))),
                          DataCell(Align(alignment: Alignment.center, child: Text(e.value.values.first.toString(), style: TextStyle(fontWeight: FontWeight.w600)))),
                        ]))
                        .toList(),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  child: DataTable(
                    columnSpacing: 0,
                    horizontalMargin: 16,
                    headingRowColor: MaterialStateProperty.all(Colors.teal.shade100),
                    headingTextStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    dataRowMinHeight: 60,
                    dataRowMaxHeight: 70,
                    columns: [
                      DataColumn(
                        label: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            Statics.getLabel('Graam'),
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                      DataColumn(
                          label: IconButton(
                            icon: Icon(Icons.remove_red_eye, color: Colors.teal),
                            onPressed: () => showPopupList(_gramData.gramname.toString(), type: "graam"),
                          )),
                    ],
                    rows: graamTitleList
                        .asMap()
                        .entries
                        .map((e) =>
                        DataRow(color: MaterialStateProperty.all(Colors.green.shade50), cells: [
                          DataCell(Container(margin: EdgeInsets.symmetric(horizontal: 8), alignment: Alignment.center, child: Text(Statics.getLabel(e.value.keys.first.toString())))),
                          DataCell(Align(alignment: Alignment.center, child: Text(e.value.values.first.toString(), style: TextStyle(fontWeight: FontWeight.w600)))),
                        ]))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // return SingleChildScrollView(
    //   scrollDirection: Axis.horizontal,
    //   child: Container(
    //     margin: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
    //     child: DataTable(
    //       columnSpacing: 0,
    //       horizontalMargin: 16,
    //       headingRowColor: MaterialStateProperty.all(Colors.orangeAccent.shade200),
    //       headingTextStyle: TextStyle(
    //         fontSize: 15,
    //         color: Colors.white,
    //         fontWeight: FontWeight.bold,
    //       ),
    //       columns: [
    //         DataColumn(label: Text('')),
    //         DataColumn(
    //             label: Container(
    //                 alignment: Alignment.center,
    //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //                 child: Text("${Statics.getLabel('LevelName')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)))),
    //         DataColumn(
    //             label: Container(
    //                 alignment: Alignment.center,
    //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //                 child: Text("${Statics.getLabel('AbhiyaanStartedCount')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)))),
    //         DataColumn(
    //             label: Container(
    //                 alignment: Alignment.center,
    //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //                 child: Text(Statics.getLabel('nagarCount'), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)))),
    //         DataColumn(
    //             label: Container(
    //                 alignment: Alignment.center,
    //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //                 child: Text("${Statics.getLabel('vastiCount')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)))),
    //         DataColumn(label: Text('')),
    //       ],
    //       rows: [
    //         DataRow(
    //           color: MaterialStateProperty.all(Colors.orange.shade50),
    //           cells: [
    //             DataCell(IconButton(
    //               icon: Icon(Icons.remove_red_eye, color: Colors.teal),
    //               onPressed: () => showPopupList(_vastiData.vastiname.toString()),
    //             )),
    //             DataCell(Align(alignment: Alignment.center, child: Text("${Statics.getLabel('Vasti')}"))),
    //             DataCell(Align(
    //               alignment: Alignment.center,
    //               child: Text("${_vastiData.startedcount ?? "0"}"),
    //             )),
    //             DataCell(Align(
    //               alignment: Alignment.center,
    //               child: Text("${_vastiData.nagarcount ?? "0"}"),
    //             )),
    //             DataCell(Align(
    //               alignment: Alignment.center,
    //               child: Text("${_vastiData.vasticount ?? "0"}"),
    //             )),
    //             DataCell.empty,
    //           ],
    //         ),
    //         DataRow(
    //           color: MaterialStateProperty.all(Colors.white),
    //           cells: [
    //             DataCell(Text("")),
    //             DataCell(Text("")),
    //             DataCell(Text("")),
    //             DataCell(Text("")),
    //             DataCell(Text("")),
    //             DataCell(Text("")),
    //           ],
    //         ),
    //         DataRow(
    //           color: MaterialStateProperty.all(Colors.teal.shade100),
    //           cells: [
    //             DataCell.empty,
    //             DataCell(
    //               Container(
    //                 alignment: Alignment.center,
    //                 width: double.infinity, // makes it span available width
    //                 child: Text("${Statics.getLabel('LevelName')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
    //               ),
    //             ),
    //             DataCell(
    //               Container(
    //                 alignment: Alignment.center,
    //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //                 child: Text("${Statics.getLabel('AbhiyaanStartedCount')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
    //               ),
    //             ),
    //             DataCell(
    //               Container(
    //                 alignment: Alignment.center,
    //                 width: double.infinity, // makes it span available width
    //                 child: Text("${Statics.getLabel('jilhaCount')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
    //               ),
    //             ),
    //             DataCell(
    //               Container(
    //                 alignment: Alignment.center,
    //                 width: double.infinity, // makes it span available width
    //                 child: Text("${Statics.getLabel('mandalCount')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
    //               ),
    //             ),
    //             DataCell(
    //               Container(
    //                 alignment: Alignment.center,
    //                 width: double.infinity, // makes it span available width
    //                 child: Text("${Statics.getLabel('GraamCount')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
    //               ),
    //             ),
    //           ],
    //         ),
    //         DataRow(
    //           color: MaterialStateProperty.all(Colors.green.shade50),
    //           cells: [
    //             DataCell(IconButton(
    //               icon: Icon(Icons.remove_red_eye, color: Colors.teal),
    //               onPressed: () => showPopupList(_gramData.gramname.toString(), isGram: true),
    //             )),
    //             DataCell(Align(alignment: Alignment.center, child: Text("${Statics.getLabel('Graam')}"))),
    //             DataCell(Align(
    //               alignment: Alignment.center,
    //               child: Text("${_gramData.startedcount ?? "0"}"),
    //             )),
    //             DataCell(Align(
    //               alignment: Alignment.center,
    //               child: Text("${_gramData.nagarcount ?? "0"}"),
    //             )),
    //             DataCell(Align(
    //               alignment: Alignment.center,
    //               child: Text("${_gramData.mandalcount ?? "0"}"),
    //             )),
    //             DataCell(Align(
    //               alignment: Alignment.center,
    //               child: Text("${_gramData.gramcount ?? "0"}"),
    //             )),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget nagarMandalCountsTable() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Statics.getLabel("abhiyaanStatusNagar"),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              child: DataTable(
                columnSpacing: 0,
                horizontalMargin: 16,
                headingRowColor: MaterialStateProperty.all(Colors.purple.shade300),
                headingTextStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                columns: [
                  DataColumn(
                      label: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text("${Statics.getLabel('LevelName')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)))),
                  DataColumn(
                      label: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(Statics.getLabel('Total'), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)))),
                  DataColumn(
                      label: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text("${Statics.getLabel('started')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)))),
                  DataColumn(label: Text('')),
                ],
                rows: levelWiseCountsList
                    .map((e) =>
                    DataRow(
                      color: MaterialStateProperty.all(Colors.purple.shade50),
                      cells: [
                        // DataCell(Align(alignment: Alignment.center, child: Text("${Statics.getLabel('Vasti')}"))),
                        DataCell(Align(
                          alignment: Alignment.center,
                          child: Text(Statics.getLabel(e.type == "nagar"
                              ? "NagarShahari"
                              : e.type == "taluka"
                              ? "taalukaa"
                              : e.type.toString())),
                        )),
                        DataCell(Align(
                          alignment: Alignment.center,
                          child: Text("${e.totalcount ?? "0"}"),
                        )),
                        DataCell(Align(
                          alignment: Alignment.center,
                          child: Text("${e.startedcount ?? "0"}"),
                        )),
                        DataCell(IconButton(
                          icon: Icon(Icons.remove_red_eye, color: Colors.teal),
                          onPressed: () => showPopupList(e.namelist.toString(), type: e.type.toString()),
                        )),
                      ],
                    ))
                    .toList(),
              ),
            ),
          ],
        ));
  }

  Widget _buildExpansionPanel() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.9,
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 0.7, color: Colors.grey.shade700),
      ),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            backgroundColor: Colors.transparent,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  "${Statics.getLabel('vastiGramNivda')}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              );
            },
            body: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  if (_linkedMahaanagar != null)
                    _buildDropdownField(
                      label: Statics.getLabel('Mahaanagar'),
                      value: _linkedMahaanagarValue,
                      items: _linkedMahaanagar!
                          .map((bg) =>
                          DropdownMenuItem(
                            value: bg.geoUnitID.toString(),
                            child: Text(bg.name!),
                          ))
                          .toList(),
                      onChanged: (value) async {
                        final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedMahaanagarValue = value;
                          _linkedVibhaagValue = null;
                          _selctedLevel = 'Mahanagar';
                          _selctedLevelName = selectedItem.name ?? "";
                          _selectedGeoUnitId = value;
                          // _linkedMahaanagarName = selectedItem.name ?? "";
                          // _resetLinkedValues();
                        });
                        populatelinkedVibhaagDropdown(value!);
                        populatelinkedBhaagDropdown("");
                      },
                      isDisabled: false,
                    ),
                  if (_linkedVibhaag != null)
                    _buildDropdownField(
                      label: Statics.getLabel('Vibhaag'),
                      value: _linkedVibhaagValue,
                      items: _linkedVibhaag!
                          .map((bg) =>
                          DropdownMenuItem(
                            value: bg.geoUnitID.toString(),
                            child: Text(bg.name!),
                          ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedVibhaagValue = value;
                          _selctedLevel = 'Vibhaag';
                          _selctedLevelName = selectedItem.name ?? "";
                          _selectedGeoUnitId = value;
                          // _linkedVibhaagName = selectedItem.name ?? "";
                        });
                        populatelinkedBhaagDropdown(value!);
                      },
                      isDisabled: false,
                    ),
                  if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Bhaag'),
                      value: _linkedbhaagValue,
                      items: _linkedbhaag!
                          .map((bg) =>
                          DropdownMenuItem(
                            value: bg.geoUnitID.toString(),
                            child: Text(bg.name!),
                          ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedbhaagValue = value;
                          _selctedLevel = 'Bhaag';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkedbhaagName = selectedItem.name ?? "";
                          _selectedGeoUnitId = value;
                          populatelinkedShaharDropdown(value!);
                          populatelinkedNagarDropdown(value, null);
                        });
                      },
                      isDisabled: false,
                    ),
                  if (_linkedshahar != null && _linkedshahar!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Shahar'),
                      value: _linkedshaharValue,
                      items: _linkedshahar!
                          .map((bg) =>
                          DropdownMenuItem(
                            value: bg.geoUnitID.toString(),
                            child: Text(bg.name!),
                          ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedshahar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedshaharValue = value;
                          _selectedGeoUnitId = value;
                          _selctedLevel = 'Shahar';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkedshaharName = selectedItem.name ?? "";
                          populatelinkedNagarDropdown(null, value);
                        });
                      },
                      isDisabled: false,
                    ),
                  if (_linkednagar != null && _linkednagar!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Nagar'),
                      value: _linkednagarValue,
                      items: _linkednagar!
                          .map((bg) =>
                          DropdownMenuItem(
                            value: bg.geoUnitID.toString(),
                            child: Text(bg.name!),
                          ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkednagarValue = value;
                          _selectedGeoUnitId = value;
                          _selctedLevel = 'Nagar';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkednagarName = selectedItem.name ?? "";
                          populatelinkedMandalDropdown(value);
                          populatelinkedVastiDropdown(value);
                        });
                      },
                      isDisabled: false,
                    ),
                  // if (_linkedmandal != null && _linkedmandal!.isNotEmpty)
                  //   _buildDropdownField(
                  //     label: Statics.getLabel('Mandal'),
                  //     value: _linkedmandalValue,
                  //     items: _linkedmandal!
                  //         .map((bg) => DropdownMenuItem(
                  //               value: bg.geoUnitID.toString(),
                  //               child: Text(bg.name!),
                  //             ))
                  //         .toList(),
                  //     onChanged: (value) {
                  //       final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                  //       setState(() {
                  //         _linkedmandalValue = value;
                  //         _selectedGeoUnitId = value.toString();
                  //         _selctedLevel = 'Mandal';
                  //         _selctedLevelName = selectedItem.name ?? "";
                  //         _linkedmandalName = selectedItem.name ?? "";
                  //         populatelinkedGraamDropdown(value);
                  //       });
                  //     },
                  //     isDisabled: false,
                  //   ),
                  // if (_linkedgraam != null && _linkedgraam!.isNotEmpty)
                  //   _buildDropdownField(
                  //     label: Statics.getLabel('Graam'),
                  //     value: _linkedgraamValue,
                  //     items: _linkedgraam!
                  //         .map((bg) => DropdownMenuItem(
                  //               value: bg.geoUnitID.toString(),
                  //               child: Text(bg.name!),
                  //             ))
                  //         .toList(),
                  //     onChanged: (value) {
                  //       final selectedItem = _linkedgraam!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                  //       setState(() {
                  //         _linkedgraamValue = value;
                  //         _selectedGeoUnitId = value.toString();
                  //         _selctedLevel = 'Graam';
                  //         _selctedLevelName = selectedItem.name ?? "";
                  //         _linkedgraamName = selectedItem.name ?? "";
                  //       });
                  //     },
                  //     isDisabled: false,
                  //   ),
                  // if (_linkedvasti != null && _linkedvasti!.isNotEmpty)
                  //   _buildDropdownField(
                  //     label: Statics.getLabel('Vasti'),
                  //     value: _linkedvastiValue,
                  //     items: _linkedvasti!
                  //         .map((bg) => DropdownMenuItem(
                  //               value: bg.geoUnitID.toString(),
                  //               child: Text(bg.name!),
                  //             ))
                  //         .toList(),
                  //     onChanged: (value) {
                  //       final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                  //       setState(() {
                  //         _linkedvastiValue = value;
                  //         _selectedGeoUnitId = value.toString();
                  //         _selctedLevel = 'Vasti';
                  //         _selctedLevelName = selectedItem.name ?? "";
                  //         _linkedvastiName = selectedItem.name ?? "";
                  //       });
                  //     },
                  //     isDisabled: false,
                  //   ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // if ((_linkedgraamValue != "" && _linkedgraamValue != null) || (_linkedvastiValue != "" && _linkedvastiValue != null))
                      MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 5,
                        ),
                        color: Theme
                            .of(context)
                            .primaryColor,
                        textColor: Theme
                            .of(context)
                            .primaryTextTheme
                            .labelMedium
                            ?.color,
                        onPressed: () async {
                          _selctedLevelNameList = [];
                          setState(() {});
                          // _selctedLevelNameList.add(_linkedMahaanagarName);
                          // _selctedLevelNameList.add(_linkedVibhaagName);
                          _selctedLevelNameList.add(_linkedbhaagName);
                          _selctedLevelNameList.add(_linkedshaharName);
                          _selctedLevelNameList.add(_linkednagarName);
                          _selctedLevelNameList.add(_linkedmandalName);
                          _selctedLevelNameList.add(_linkedgraamName);
                          _selctedLevelNameList.add(_linkedvastiName);
                          setState(() {});

                          await _getSwList();

                          setState(() {
                            _selctedLevelNames = _selctedLevelNameList
                                .where((e) => e != null && e.isNotEmpty) // remove null or empty strings
                                .cast<String>() // convert from String? to String
                                .join(' -> ');
                            _searched = true;
                            _isExpanded = false;
                          });
                        },
                        child: Text(
                          "${Statics.getLabel('search')}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      MaterialButton(
                          onPressed: () async {
                            setState(() {
                              _searched = false;
                              _selectedGeoUnitId = null;
                              _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                              _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                              type = "praant";
                            });
                            // await populateDropdown(isClear: true);
                          },
                          child: Text(Statics.getLabel('clear'))),
                    ],
                  ),
                ],
              ),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    required bool isDisabled,
  }) {
    return IgnorePointer(
      ignoring: isDisabled,
      child: DropdownButtonFormField(
        decoration: InputDecoration(labelText: label),
        isExpanded: true,
        value: value == "" ? null : value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }

/* Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 5,
                ),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                onPressed: () async {
                  // if(Statics.userDetails[])
                  // await getAbhiyaanGruhaSamparkListData();
                },
                child: Text(
                  "${Statics.getLabel('search')}",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              MaterialButton(
                  onPressed: () {
                    setState(() {
                      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                      _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                      type = "praant";
                    });
                  },
                  child: Text(Statics.getLabel('clear'))),
            ],
          ),*/
}

/// CUSTOM PAINTER CLASS
/// This class handles drawing the point dot and the text value directly above it.
class LabelWithCirclePainter extends FlDotCirclePainter {
  final String label;
  final TextStyle labelStyle;
  final double offsetY;

  LabelWithCirclePainter({
    required this.label,
    required this.labelStyle,
    required this.offsetY,
    double? radius,
    Color? color,
    double? strokeWidth,
    Color? strokeColor,
  }) : super(
    radius: radius,
    color: color ?? Colors.purple,
    strokeWidth: strokeWidth ?? 2,
    strokeColor: strokeColor ?? Colors.purple,
  );

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    // 1. Draw the actual circle dot
    super.draw(canvas, spot, offsetInCanvas);

    // 2. Setup the text painter for the value
    final textPainter = TextPainter(
      text: TextSpan(text: label, style: labelStyle),
      textDirection: txt.TextDirection.ltr,
    )
      ..layout();

    // 3. Position the text (centered horizontally, above the dot)
    final dx = offsetInCanvas.dx - (textPainter.width / 2);
    // final dy = offsetInCanvas.dy - (radius ?? 4) - textPainter.height - 7;
    final dy = offsetInCanvas.dy + offsetY - (offsetY < 0 ? textPainter.height : 0);

    // 4. Paint label onto canvas
    textPainter.paint(canvas, Offset(dx, dy));
  }
}
