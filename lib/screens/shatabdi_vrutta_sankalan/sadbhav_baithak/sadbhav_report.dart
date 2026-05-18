import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../models/response_model/sadbhav_baithak_report_model.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';

class SadbhavReportTab extends StatefulWidget {
  const SadbhavReportTab({super.key});

  @override
  State<SadbhavReportTab> createState() => _SadbhavReportTabState();
}

class _SadbhavReportTabState extends State<SadbhavReportTab> with AutomaticKeepAliveClientMixin {
// This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  late ScrollController _scrollController;
  bool _searched = false;
  bool _isExpanded = true;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedupnagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedupnagarValue = "";

  // String? _linkedNagarValuePopup = '';
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";

  // String? _linkedMahaanagarName = '';
  // String? _linkedVibhaagName = '';
  String? _linkedbhaagName = "";
  String? _linkedshaharName = "";
  String? _linkednagarName = "";
  String? _linkedupnagarName = "";
  String? _linkedmandalName = "";
  String? _linkedgraamName = "";
  String? _linkedvastiName = "";

  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  String _selctedLevelNames = '';
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId;

  List<ReportData> report = [];

  final List<bool> _expanded = List.generate(3, (_) => true);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
    });
    await populateDropdown();
  }

  //////////////////////////////////////////////////////////////////////////////////////

  Future<void> populateAllDropdowns(int level, DropDownModel dm) async {
    setState(() {
      _selectedGeoUnitId = _linkedMahaanagarValue = _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = null;
    });
    final selection = prepareSelection(dm);

    // Step 1: Mahaanagar
    await populatelinkedMahaanagarDropdown();
    _linkedMahaanagarValue = (level == 9 ? (dm.geoUnitID ?? 0).toString() : selection.mahaanagar) ?? _linkedMahaanagarValue;
    if (level == 9) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.mahaanagar).toString();
      _selctedLevel = 'Mahaanagar';
      final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      _selctedLevelName = selectedItem.name;
    }

    // Step 2: Vibhaag
    await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
    _linkedVibhaagValue = (level == 8 ? (dm.geoUnitID ?? 0).toString() : selection.vibhaag) ?? _linkedVibhaagValue;
    if (level == 8) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.vibhaag).toString();
      _selctedLevel = 'Vibhaag';
      final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      _selctedLevelName = selectedItem.name;
    }

    // Step 3: Bhaag
    await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
    _linkedbhaagValue = (level == 7 ? (dm.geoUnitID ?? 0).toString() : selection.bhaag) ?? _linkedbhaagValue;
    if (level == 7) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.bhaag).toString();
      _selctedLevel = 'Bhaag';
      final selectedItem = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      _selctedLevelName = selectedItem.name;
    }

    // Step 4: Nagar
    await populatelinkedNagarDropdown(_linkedbhaagValue, null);
    _linkednagarValue = (level == 6 ? (dm.geoUnitID ?? 0).toString() : selection.nagar) ?? _linkednagarValue;
    if (level == 6) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.nagar).toString();
      _selctedLevel = 'Nagar';
      final selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      _selctedLevelName = selectedItem.name;
    }

    // Step 5: Upnagar (conditional)
    await populatelinkedUpnagarDropdown(_linkednagarValue);
    if (selection.upnagar != null && selection.upnagar!.isNotEmpty) {
      _linkedupnagarValue = (level == 13 ? (dm.geoUnitID ?? "").toString() : selection.upnagar) ?? '';
      if (level == 13) {
        _selectedGeoUnitId = (dm.geoUnitID ?? selection.upnagar).toString();
        _selctedLevel = 'upnagarUpkhanda';
        final selectedItem = _linkedupnagar!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
        _selctedLevelName = selectedItem.name;
      }
    }

    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedBhaag != null && _linkedBhaag!.isNotEmpty) _linkedbhaagName = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedNagar != null && _linkedNagar!.isNotEmpty) _linkednagarName = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;

    setState(() {});
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    setState(() {
      _linkedMahaanagarValue = _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = null;
      _linkedMahaanagar = _linkedVibhaag = _linkedbhaag = _linkednagar = null;
      _selctedLevelName = _selectedGeoUnitId = null;
      _selctedLevel = "praant";
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
    if (fromClear || userLevelId == null || ddm == null) {
      print("object is null");
      return;
    }
    print("object is not null >>>>>>>>>>>>>>>>>>>>>>");
    await populateAllDropdowns(userLevelId!, ddm!);
    setState(() {});
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '', isAbhiyaan: false);
    setState(() => _linkedMahaanagar = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedbhaagValue = _linkednagarValue = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar', '', isAbhiyaan: false);
    setState(() => _linkedVibhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkednagarValue = null;
    //_linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedbhaag = _linkednagar = _linkedvasti = [];
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '', isAbhiyaan: false);
    setState(() => _linkedbhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkednagarValue = _linkedupnagarValue = null;
    //_linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkednagar = _linkedupnagar = _linkedvasti = null;
    final parentID = shaharIDStr ?? bhaagIDStr!;
    final parentType = shaharIDStr != null ? 'Shahar' : 'Bhaag';
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), parentID, parentType, '', isAbhiyaan: false);
    setState(() => _linkednagar = data.isNotEmpty ? data : null);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedUpnagarDropdown(String? nagarIDStr) async {
    _linkedvastiValue = null;
    //_linkedupnagarName = _linkedmandalName = _linkedgraamName = null;
    _linkedvasti = null;
    var mnDD;

    mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');

    setState(() {
      _linkedupnagar = (mnDD.length > 0 ? mnDD : null);
      //_linkedupnagarValue = (userparentUpanagarid ?? userGeoUnitId).toString();
    });
    return mnDD;
  }

//   Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
//     _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
//     List<GeoUnitMasterBAL> data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '', isAbhiyaan: false);
//     setState(() {
//       _linkedMahaanagar = data;
//     });
//     return data;
//   }
//
//   Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
//     _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
//     _linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
//     print("populatelinkedVibhaagDropdown $mahaanagarIDStr");
//     var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '', isAbhiyaan: false);
//     setState(() {
//       _linkedVibhaag = data;
//     });
//     return data;
//   }
//
//   Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
//     _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
//     _linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
//     _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
//     var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '', isAbhiyaan: false);
//     setState(() {
//       _linkedbhaag = data;
//     });
//     return data;
//   }
//
//   Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(String bhaagIDStr) async {
//     _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
//     _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
//     var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '', isAbhiyaan: false);
//     setState(() {
//       _linkedshahar = (shDD.length > 0 ? shDD : null);
//     });
//     return shDD;
//   }
//
//   Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
// // print("populatelinkedNagarDropdown ${bhaagIDStr} == ${shaharIDStr}  ");
//     _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
//     _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
//     _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
//     print("print LevelID > ${Statics.userDetails["LevelID"]}");
//     print("shaharIDStr shaharIDStr $shaharIDStr");
//     if (shaharIDStr != null) {
//       var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr!, 'Shahar', '', isAbhiyaan: false);
//       setState(() {
//         _linkednagar = (ngDD.length > 0 ? ngDD : null);
//       });
//       return ngDD;
//     } else {
//       var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '', isAbhiyaan: false);
//       setState(() {
//         _linkednagar = (ngDD.length > 0 ? ngDD : null);
//       });
//       return ngDD;
//     }
//   }
//
//   Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(String? nagarIDStr) async {
//     _linkedmandalValue = _linkedgraamValue = null;
//     _linkedmandalName = _linkedgraamName = null;
//     _linkedmandal = _linkedgraam = null;
//     var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, 'Nagar', '', isAbhiyaan: false);
//     setState(() {
//       _linkedmandal = (mnDD.length > 0 ? mnDD : null);
//     });
//     return mnDD;
//   }
//
//   Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String? mandalIDStr) async {
//     _linkedgraamValue = null;
//     _linkedgraamName = null;
//     var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '', isAbhiyaan: false);
//     setState(() {
//       _linkedgraam = (gmDD.length > 0 ? gmDD : null);
//     });
//     return gmDD;
//   }
//
//   Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String? nagarIDStr) async {
//     _linkedvastiValue = null;
//     _linkedvastiName = null;
//     var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', '', isAbhiyaan: false);
//     setState(() {
//       _linkedvasti = (vsDD.length > 0 ? vsDD : null);
//     });
//     return vsDD;
//   }

  //////////////////////////////////////////////////////////////////////////////////////

  getReportDataFun() async {
    setState(() {
      report = [];
      // _isLoading = true;
    });
    Map<String, dynamic> formData = {
      "geounitid": int.tryParse(_selectedGeoUnitId.toString()) ?? null,
      "appuserid": int.tryParse(Statics.userDetails['userID']) ?? null,
    };

    // String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    // log("Form Data (JSON):\n$formattedJson");
    report = await Statics.SadbhavBaithakReportData(context, formData) ?? [];
    // log("vijayadashamiReport >>>>>>>>>>>>>>>>> ${jsonDecode(jsonEncode(vijayadashamiReport))}");
    setState(() {
      report;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     Statics.getLabel('hinduSammelanReport'),
      //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //   ),
      //   // actions: [IconButton(onPressed: getExcelReportDataFun, icon: Icon(Icons.download))],
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Text(
            //       "*Dummy Data",
            //       style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            //     )
            //   ],
            // ),
            SizedBox(height: 10),
            _buildExpansionPanel(),
            SizedBox(height: 20),
            if (_searched) ...[
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
                        "${Statics.getLabel(_selctedLevel ?? "Mahaanagar")}  ->  ",
                        style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        " $_selctedLevelName",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  )),
              SizedBox(height: 10),
              Divider(color: Colors.black),
              SizedBox(height: 10),
              if (report.isNotEmpty) buildMarathiDataTable(report),
              SizedBox(height: 18),
            ]
          ],
        ),
      ),
    );
  }

  Widget buildMarathiDataTable(List<ReportData> data) {
    bool showRemaining = data.any((item) => item.remainingcnt != null);
    final List<String> headers = [
      // 'कार्यक्रम स्तर',
      Statics.getLabel('sadbhavReportTable1'),
      Statics.getLabel('sadbhavReportTable15'),
      if (showRemaining) Statics.getLabel('sadbhavReportTable155'),
      Statics.getLabel('sadbhavReportTable2'),
      Statics.getLabel('sadbhavReportTable3'),
      Statics.getLabel('sadbhavReportTable4'),
      Statics.getLabel('sadbhavReportTable5'),
      Statics.getLabel('sadbhavReportTable6'),
      Statics.getLabel('sadbhavReportTable7'),
      Statics.getLabel('sadbhavReportTable8'),
    ];

    return Row(
      children: [
        DataTable(
          headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
          columnSpacing: 0,
          horizontalMargin: 16,
          // dataRowMinHeight: 70,
          dataRowMaxHeight: 75,

          border: TableBorder.all(color: Colors.black26),
          columns: [
            DataColumn(
              label: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(minWidth: 40, maxWidth: 115),
                child: Text(
                  Statics.getLabel("sadbhavReportTable0"),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
          rows: data.map((level) {
                return DataRow(cells: [
                  DataCell(Container(
                      constraints: BoxConstraints(minWidth: 40, maxWidth: 115),
                      child: Text(
                        level.levelname.toString(),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ))),
                ]);
              }).toList() +
              [
                DataRow(color: MaterialStatePropertyAll(Colors.yellow.shade100), cells: [
                  DataCell(Container(
                    constraints: BoxConstraints(minWidth: 40, maxWidth: 120),
                    child: Text(
                      Statics.getLabel("Total"),
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
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
                dataRowMaxHeight: 75,
                headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                border: TableBorder(verticalInside: BorderSide(width: 0.7, color: Colors.grey.shade200)),
                columns: headers
                    .map((header) => DataColumn(
                          label: Container(
                            constraints: BoxConstraints(minWidth: 40, maxWidth: 200),
                            // constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.2),
                            child: Text(header, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ))
                    .toList(),
                rows: data.map((level) {
                      return DataRow(cells: [
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.baithakcount != 0 && level.baithaknames != null && level.baithaknames!.isNotEmpty) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.baithakcount != 0 && level.baithaknames != null && level.baithaknames!.isNotEmpty) SizedBox(width: 1),
                            Container(
                                margin: EdgeInsets.only(right: (level.baithakcount != 0 && level.baithaknames != null && level.baithaknames!.isNotEmpty) ? 0 : 10),
                                child: Text(level.baithakcount.toString())),
                            if (level.baithakcount != 0 && level.baithaknames != null && level.baithaknames!.isNotEmpty)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.baithaknames ?? "", title: Statics.getLabel("sadbhavReportTable1"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.startedcnt != 0 && level.startedname != null && level.startedname!.isNotEmpty) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.startedcnt != 0 && level.startedname != null && level.startedname!.isNotEmpty) SizedBox(width: 1),
                            Container(
                                margin: EdgeInsets.only(right: (level.startedcnt != 0 && level.startedname != null && level.startedname!.isNotEmpty) ? 0 : 10),
                                child: Text(level.startedcnt.toString())),
                            if (level.startedcnt != 0 && level.startedname != null && level.startedname!.isNotEmpty)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.startedname ?? "", title: Statics.getLabel("sadbhavReportTable15"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        if (showRemaining)
                          DataCell(Center(
                              child: Row(
                            mainAxisAlignment: (level.remainingcnt != 0 && level.remainingname != null && level.remainingname!.isNotEmpty) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                            children: [
                              if (level.remainingcnt != 0 && level.remainingname != null && level.remainingname!.isNotEmpty) SizedBox(width: 1),
                              Container(
                                  margin: EdgeInsets.only(right: (level.remainingcnt != 0 && level.remainingname != null && level.remainingname!.isNotEmpty) ? 0 : 10),
                                  child: Text(level.remainingcnt.toString())),
                              if (level.remainingcnt != 0 && level.remainingname != null && level.remainingname!.isNotEmpty)
                                InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: () {
                                    showInfoDialogBox(names: level.remainingname ?? "", title: Statics.getLabel("sadbhavReportTable155"));
                                  },
                                  child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                                ),
                            ],
                          ))),
                        DataCell(Center(child: Text(level.namecount.toString()))),
                        DataCell(Center(child: Text(level.totalmalecount.toString()))),
                        DataCell(Center(child: Text(level.presentmale.toString()))),
                        DataCell(Center(child: Text(level.totalfemalecount.toString()))),
                        DataCell(Center(child: Text(level.presentfemale.toString()))),
                        DataCell(Center(child: Text(level.totalcount.toString()))),
                        DataCell(Center(child: Text(level.totalpresentcount.toString()))),
                      ]);
                    }).toList() +
                    [
                      DataRow(color: MaterialStatePropertyAll(Colors.yellow.shade100), cells: [
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.baithakcount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.startedcnt ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        if (showRemaining)
                          DataCell(Center(
                              child: Text(
                            data.fold(0, (sum, item) => sum + (item.remainingcnt ?? 0)).toString(),
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.namecount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.totalmalecount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.presentmale ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.totalfemalecount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.presentfemale ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.totalcount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.totalpresentcount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                      ])
                    ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  showInfoDialogBox({required String names, required String title}) {
    final ScrollController _scrollController = ScrollController();
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, set) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              // contentPadding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.purple.shade400)),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
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
                        border: TableBorder.symmetric(inside: BorderSide(width: 0.4, color: Colors.grey.shade400)),
                        showCheckboxColumn: false,
                        headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                        headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        columns: [
                          DataColumn(
                              label: Container(
                            constraints: BoxConstraints(maxWidth: 40),
                            child: Text(" "),
                          )),
                          DataColumn(
                              label: Container(
                            constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width * 0.5),
                            child: Text(
                              "${Statics.getLabel('Name')}",
                            ),
                          )),
                        ],
                        rows: names.split(",").toList().asMap().entries.map((entry) {
                          int index = entry.key;
                          var data = entry.value;
                          return DataRow(cells: [
                            DataCell(Container(constraints: BoxConstraints(maxWidth: 40), child: Text((index + 1).toString()))),
                            DataCell(Text(data, maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true)),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  child: Text(Statics.getLabel("bandKara")),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildExpansionPanel() {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.9,
      // margin: EdgeInsets.symmetric(horizontal: 20),
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
                  "${Statics.getLabel('selectStar')}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              );
            },
            body: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  if (_linkedMahaanagar != null)
                    buildDropdownField(
                      label: Statics.getLabel('Mahaanagar'),
                      value: _linkedMahaanagarValue,
                      items: _linkedMahaanagar!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) async {
                        final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _searched = false;
                          _linkedMahaanagarValue = value;
                          _linkedVibhaagValue = null;
                          _selctedLevel = 'Mahaanagar';
                          _selctedLevelName = selectedItem.name ?? "";
                          _selectedGeoUnitId = value;
                          // _linkedMahaanagarName = selectedItem.name ?? "";
                          // _resetLinkedValues();
                        });
                        populatelinkedVibhaagDropdown(value!);
                        populatelinkedBhaagDropdown("");
                      },
                      isDisabled: ((userLevelId ?? 0) < 9 || userLevelId == 13),
                    ),
                  if (_linkedVibhaag != null)
                    buildDropdownField(
                      label: Statics.getLabel('Vibhaag'),
                      value: _linkedVibhaagValue,
                      items: _linkedVibhaag!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _searched = false;
                          _linkedVibhaagValue = value;
                          _selctedLevel = 'Vibhaag';
                          _selctedLevelName = selectedItem.name ?? "";
                          _selectedGeoUnitId = value;
                          // _linkedVibhaagName = selectedItem.name ?? "";
                        });
                        populatelinkedBhaagDropdown(value!);
                      },
                      isDisabled: ((userLevelId ?? 0) < 8 || userLevelId == 13),
                    ),
                  if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty)
                    buildDropdownField(
                      label: Statics.getLabel('Bhaag'),
                      value: _linkedbhaagValue,
                      items: _linkedbhaag!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _searched = false;
                          _linkedbhaagValue = value;
                          _selctedLevel = 'Bhaag';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkedbhaagName = selectedItem.name ?? "";
                          _selectedGeoUnitId = value;
                        });
                        populatelinkedNagarDropdown(value, null);
                      },
                      isDisabled: ((userLevelId ?? 0) < 7 || userLevelId == 13),
                    ),
                  // if (_linkedshahar != null && _linkedshahar!.isNotEmpty)
                  //   _buildDropdownField(
                  //     label: Statics.getLabel('Shahar'),
                  //     value: _linkedshaharValue,
                  //     items: _linkedshahar!
                  //         .map((bg) => DropdownMenuItem(
                  //               value: bg.geoUnitID.toString(),
                  //               child: Text(bg.name!),
                  //             ))
                  //         .toList(),
                  //     onChanged: (value) {
                  //       final selectedItem = _linkedshahar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                  //       setState(() {
                  //         _searched = false;
                  //         _linkedshaharValue = value;
                  //         _selectedGeoUnitId = value;
                  //         _selctedLevel = 'Shahar';
                  //         _selctedLevelName = selectedItem.name ?? "";
                  //         _linkedshaharName = selectedItem.name ?? "";
                  //         populatelinkedNagarDropdown(null, value);
                  //       });
                  //     },
                  //     isDisabled: false,
                  //   ),
                  if (_linkednagar != null && _linkednagar!.isNotEmpty)
                    buildDropdownField(
                      label: Statics.getLabel('Nagar'),
                      value: _linkednagarValue,
                      items: _linkednagar!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _searched = false;
                          _linkednagarValue = value;
                          _selectedGeoUnitId = value;
                          _selctedLevel = 'Nagar';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkednagarName = selectedItem.name ?? "";
                        });
                        populatelinkedUpnagarDropdown(value);
                      },
                      isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
                    ),
                  if (_linkedupnagar != null && _linkedupnagar!.isNotEmpty)
                    buildDropdownField(
                      label: Statics.getLabel('upnagarUpkhanda'),
                      value: _linkedupnagarValue,
                      items: _linkedupnagar!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedupnagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _searched = false;
                          _linkedupnagarValue = value;
                          _selectedGeoUnitId = value;
                          _selctedLevel = 'upnagarUpkhanda';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkedupnagarName = selectedItem.name ?? "";
                        });
                      },
                      isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
                    ),
                  // if (_linkedmandal != null && _linkedmandal!.isNotEmpty)
                  //   _buildDropdownField(
                  //     label: Statics.getLabel('Mandal'),
                  //     value: _linkedmandalValue,
                  //     items: _linkedmandal!
                  //         .map((bg) => DropdownMenuItem(
                  //       value: bg.geoUnitID.toString(),
                  //       child: Text(bg.name!),
                  //     ))
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
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
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

                          await getReportDataFun();

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
                              _selctedLevelName = "";
                              _selectedGeoUnitId = null;
                              _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                              _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                              _selctedLevel = "praant";
                              report = [];
                            });

                            await populateDropdown();
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
}
