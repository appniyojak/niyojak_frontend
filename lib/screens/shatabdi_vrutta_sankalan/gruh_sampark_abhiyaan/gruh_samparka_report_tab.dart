import 'package:flutter/material.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/AbhiyaanListResponse.dart';
import '../../../models/response_model/AbhiyaanLoginDataResponse.dart';
import '../../../providers/bals.dart';
import '../../../providers/swayamsevak_provider.dart';

class GruhSamparkaReportTab extends StatefulWidget {
  final AbhiyanSwayamsevakdata? initialData;

  const GruhSamparkaReportTab({super.key, this.initialData});

  @override
  State<GruhSamparkaReportTab> createState() => _GruhSamparkaReportTabState();
}

class _GruhSamparkaReportTabState extends State<GruhSamparkaReportTab> {
  bool _isSearching = false;

  String? selectedGruhaAbhiyanValue = "";
  List<AbhiyaanList> abhiyaanDataList = [
    AbhiyaanList.fromJson({
      "AbhiyaanID": 1,
      "AbhiyaanName": Statics.getLabel('gruhSamparkAbhiyan') + " (${Statics.getLabel('shatabdiVarsha')})",
      "EndDate": null,
      "EndDateStr": null,
      "PraantID": 1,
      "Remark": "C1-10 Rs, C2-100 Rs, C3-1000 Rs",
      "StartDate": null,
      "StartDateStr": null
    })
  ];

  // List<AbhiyanSwayamsevakList> abhiyaanSwayamsevakDataList = [];

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
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId = '';

  bool _isExpanded = false;
  bool _searched = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    populateDropdown();
    Future.delayed(Duration.zero, () async {
      // await getAbhiyaanListData();
      selectedGruhaAbhiyanValue = abhiyaanDataList.first.abhiyaanID.toString();
    });
  }

  Future<void> populateDropdown() async {
    setState(() {
      _linkedshaharValue = null;
      _linkednagarValue = null;
      _linkedmandalValue = null;
      _linkedgraamValue = null;
      _linkedvastiValue = null;
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
    // if (widget.initialData != null) {
    setState(() {
      //     if (widget.initialData!.parentMahaanagarID != null) {
      //       _isExpanded = true;
      //       _linkedMahaanagarDisable = true;
      //       _linkedMahaanagarValue = widget.initialData!.parentMahaanagarID.toString();
      //     }
      //     if (widget.initialData!.parentVibhaagID != null) {
      //       populatelinkedVibhaagDropdown('');
      //       _isExpanded = true;
      //       _linkedVibhaagDisable = true;
      //       _linkedVibhaagValue = widget.initialData!.parentVibhaagID.toString();
      //     }
      //     if (widget.initialData!.parentBhaagID != null) {
      //       _isExpanded = true;
      //       _linkedbhaagDisable = true;
      //       _linkedbhaagValue = widget.initialData!.parentBhaagID.toString();
      //       populatelinkedNagarDropdown(_linkedbhaagValue, null);
      //     }
      //     if (widget.initialData!.parentNagarID != null) {
      //       _isExpanded = true;
      //       _linkednagarDisable = true;
      //       _linkednagarValue = widget.initialData!.parentNagarID.toString();
      //       populatelinkedMandalDropdown(_linkednagarValue);
      //       populatelinkedVastiDropdown(_linkednagarValue);
      //     }
      //     if (widget.initialData!.parentMandalID != null) {
      //       _isExpanded = true;
      //       _linkedmandalDisable = true;
      //       _linkedmandalValue = widget.initialData!.parentMandalID.toString();
      //       populatelinkedGraamDropdown(_linkedmandalValue);
      //     }
      //     if (widget.initialData!.levelName == "Vasti" && widget.initialData!.geoUnitID != null) {
      //       _isExpanded = true;
      //       _linkedvastiDisable = true;
      //       _linkedvastiValue = widget.initialData!.geoUnitID.toString();
      //     } else if (widget.initialData!.levelName == "Graam" && widget.initialData!.geoUnitID != null) {
      //       _isExpanded = true;
      //       _linkedgraamDisable = true;
      //       _linkedgraamValue = widget.initialData!.geoUnitID.toString();
      //     } else if (widget.initialData!.levelName == "Mandal" && widget.initialData!.geoUnitID != null) {
      //       _isExpanded = true;
      //       _linkedmandalDisable = true;
      //       _linkedmandalValue = widget.initialData!.geoUnitID.toString();
      //       populatelinkedGraamDropdown(_linkedmandalValue);
      //     } else if (widget.initialData!.levelName == "Nagar" && widget.initialData!.geoUnitID != null) {
      //       _isExpanded = true;
      //       _linkednagarDisable = true;
      //       _linkednagarValue = widget.initialData!.geoUnitID.toString();
      //       populatelinkedMandalDropdown(_linkednagarValue);
      //       populatelinkedVastiDropdown(_linkednagarValue);
      //     } else if (widget.initialData!.levelName == "Bhaag" && widget.initialData!.geoUnitID != null) {
      //       _isExpanded = true;
      //       _linkedbhaagDisable = true;
      //       _linkedbhaagValue = widget.initialData!.geoUnitID.toString();
      //       populatelinkedNagarDropdown(_linkedbhaagValue, null);
      //     } else {
      _isExpanded = true;
      // _linkedgraamDisable = true;
      _linkedbhaagValue = null;
      _linkedshaharValue = null;
      _linkednagarValue = null;
      _linkedmandalValue = null;
      _linkedgraamValue = null;
      _linkedvastiValue = null;
      // }
    });
    // }
  }

  populatelinkedMahaanagarDropdown() async {
    _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
  }

  populatelinkedVibhaagDropdown(String? mahaanagarIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr!, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    setState(() {
      _linkedVibhaag = data;
    });
  }

  void populatelinkedBhaagDropdown(String? vibhaagIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr!, 'Vibhaag', '');
    setState(() {
      _linkedbhaag = data;
    });
  }

  void populatelinkedShaharDropdown(String? bhaagIDStr) async {
    _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
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

  void populatelinkedMandalDropdown(String? nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
  }

  void populatelinkedGraamDropdown(String? mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
  }

  void populatelinkedVastiDropdown(String? nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
  }

  final horizontalController = ScrollController();
  final horizontalController2 = ScrollController();

  getAbhiyaanListData() async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        setState(() {
          _isSearching = true;
        });
        var result = await SwayamsevakProvider().getAbhiyanList();
        if (result.status == "200") {
          print("succeed");
          abhiyaanDataList = result.abhiyaanList!;
          selectedGruhaAbhiyanValue = abhiyaanDataList.first.abhiyaanID.toString();

          setState(() {
            _isSearching = false;
          });
        } else {
          setState(() {
            _isSearching = false;
          });
          Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
        }
      }
    } catch (e) {
      print(e);
      setState(() {
        _isSearching = false;
      });
      Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "${Statics.getLabel('Abhiyaan')} ${Statics.getLabel('Reportonly')}",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            _buildExpansionPanel(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            if (_searched) ...[
              levelWiseTable(),
              SizedBox(height: 12),
              dateWiseTable(),
            ],
          ],
        ),
      ),
    );
  }

  Widget levelWiseTable() {
    final level = [Statics.getLabel("Graam"), Statics.getLabel("Vasti")];
    final headers = [
      "संपर्कित घरे", //Statics.getLabel('vijayadashmiReportTable1'),
      "वितरित करपत्रक", //Statics.getLabel('vijayadashmiReportTable3'),
      "पुस्तक विक्री संख्या", //Statics.getLabel('vijayadashmiReportTable4'),
      "विशेष संख्या",
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
                ...level.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(item)),
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
                    columnSpacing: 14,
                    horizontalMargin: 12,
                    headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                    border: TableBorder(
                      verticalInside: BorderSide(width: 0.7, color: Colors.grey.shade200),
                    ),
                    columns: headers
                        .map((header) => DataColumn(
                              label: Container(
                                constraints: const BoxConstraints(minWidth: 30, maxWidth: 200),
                                child: Text(
                                  header,
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ))
                        .toList(),
                    rows: [
                      // per-item rows
                      // ...group.map((item) {
                      //   return
                      DataRow(cells: [
                        DataCell(Center(child: Text((40).toString()))),
                        DataCell(Center(child: Text((40).toString()))),
                        DataCell(Center(child: Text((40).toString()))),
                        DataCell(Center(child: Text((40).toString()))),
                      ]),
                      DataRow(cells: [
                        DataCell(Center(child: Text((20).toString()))),
                        DataCell(Center(child: Text((20).toString()))),
                        DataCell(Center(child: Text((20).toString()))),
                        DataCell(Center(child: Text((20).toString()))),
                      ]),
                      // }).toList(),
                      // totals row
                      DataRow(
                        color: MaterialStatePropertyAll(Colors.yellow.shade100),
                        cells: [
                          DataCell(Center(
                              child: Text(
                            40.toString(), //totalSampark.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ))),
                          DataCell(Center(
                              child: Text(
                            40.toString(), //totalVitarit.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ))),
                          DataCell(Center(
                              child: Text(
                            40.toString(), //totalPustak.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ))),
                          DataCell(Center(
                              child: Text(
                            40.toString(), //totalPustak.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ))),
                        ],
                      ),
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

  Widget dateWiseTable() {
    final level = [
      "संपर्कित घरे",
      "वितरित करपत्रक",
      "पुस्तक विक्री संख्या",
      "विशेष संख्या",
    ];
    final headers = [
      "Date 1", //Statics.getLabel('vijayadashmiReportTable1'),
      "Date 2", //Statics.getLabel('vijayadashmiReportTable3'),
      "Date 3", //Statics.getLabel('vijayadashmiReportTable4'),
      "Date 4",
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
                ...level.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(item)),
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
                controller: horizontalController2,
                child: SingleChildScrollView(
                  controller: horizontalController2,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 14,
                    horizontalMargin: 12,
                    headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                    border: TableBorder(
                      verticalInside: BorderSide(width: 0.7, color: Colors.grey.shade200),
                    ),
                    columns: headers
                        .map((header) => DataColumn(
                              label: Container(
                                constraints: const BoxConstraints(minWidth: 30, maxWidth: 200),
                                child: Text(
                                  header,
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ))
                        .toList(),
                    rows: [
                      // per-item rows
                      // ...group.map((item) {
                      //   return
                      DataRow(cells: [
                        DataCell(Center(child: Text((40).toString()))),
                        DataCell(Center(child: Text((40).toString()))),
                        DataCell(Center(child: Text((40).toString()))),
                        DataCell(Center(child: Text((40).toString()))),
                      ]),
                      DataRow(cells: [
                        DataCell(Center(child: Text((20).toString()))),
                        DataCell(Center(child: Text((20).toString()))),
                        DataCell(Center(child: Text((20).toString()))),
                        DataCell(Center(child: Text((20).toString()))),
                      ]),
                      DataRow(cells: [
                        DataCell(Center(child: Text((40).toString()))),
                        DataCell(Center(child: Text((40).toString()))),
                        DataCell(Center(child: Text((40).toString()))),
                        DataCell(Center(child: Text((40).toString()))),
                      ]),
                      DataRow(cells: [
                        DataCell(Center(child: Text((20).toString()))),
                        DataCell(Center(child: Text((20).toString()))),
                        DataCell(Center(child: Text((20).toString()))),
                        DataCell(Center(child: Text((20).toString()))),
                      ]),
                      // }).toList(),
                      // totals row
                      DataRow(
                        color: MaterialStatePropertyAll(Colors.yellow.shade100),
                        cells: [
                          DataCell(Center(
                              child: Text(
                            40.toString(), //totalSampark.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ))),
                          DataCell(Center(
                              child: Text(
                            40.toString(), //totalVitarit.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ))),
                          DataCell(Center(
                              child: Text(
                            40.toString(), //totalPustak.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ))),
                          DataCell(Center(
                              child: Text(
                            40.toString(), //totalPustak.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ))),
                        ],
                      ),
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

  Widget _buildExpansionPanel() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
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
                          .map((bg) => DropdownMenuItem(
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
                          .map((bg) => DropdownMenuItem(
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
                          .map((bg) => DropdownMenuItem(
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
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedshahar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedshaharValue = value;
                          _selectedGeoUnitId = value.toString();
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
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkednagarValue = value;
                          _selectedGeoUnitId = value.toString();
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
                      if ((_linkednagarValue != "" && _linkednagarValue != null))
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

                            // if (dateController.text.isEmpty) {
                            //   Statics.showToast(Statics.getLabel("selectDate"));
                            //   return;
                            // }

                            // data = await Statics.getSajjanAndAnyaGuestData(
                            //     context,
                            //     Statics.userDetails["userID"],
                            //     _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!,
                            //     _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? "2" : "3");
                            setState(() {});
                            // if(Statics.userDetails[])
                            // await _getSwList();

                            setState(() {
                              // _selectedTolisIds = [];
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
                              // _searched = false;
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
