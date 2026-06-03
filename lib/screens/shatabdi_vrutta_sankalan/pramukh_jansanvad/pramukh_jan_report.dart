import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/sadbhav_baithak_report_model.dart';
import '../../../utils/globals.dart';
import '../../../utils/stable_geounit_class.dart';

class PramukhJansanvadReportTab extends StatefulWidget {
  const PramukhJansanvadReportTab({super.key});

  @override
  State<PramukhJansanvadReportTab> createState() => _PramukhJansanvadReportTabState();
}

class _PramukhJansanvadReportTabState extends State<PramukhJansanvadReportTab> with AutomaticKeepAliveClientMixin {
// This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  late ScrollController _scrollController;
  bool _searched = false;
  bool _isExpanded = true;

  List<ReportData> report = [];

  final List<bool> _expanded = List.generate(3, (_) => true);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    final dm = await MyAppGlobals.getLevelLDB();

    final controller = context.read<GeoHierarchyController>();

    await controller.initialize(dm);

    setState(() {});
  }

  //////////////////////////////////////////////////////////////////////////////////////

  getReportDataFun(String? selectedGeoUnitId) async {
    setState(() {
      report = [];
      // _isLoading = true;
    });
    Map<String, dynamic> formData = {
      "geounitid": int.tryParse(selectedGeoUnitId.toString()) ?? 0,
      "appuserid": int.tryParse(Statics.userDetails['userID']) ?? null,
    };

    // String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    // log("Form Data (JSON):\n$formattedJson");
    report = await Statics.PramukhJanReportData(context, formData) ?? [];
    // log("vijayadashamiReport >>>>>>>>>>>>>>>>> ${jsonDecode(jsonEncode(vijayadashamiReport))}");
    setState(() {
      report;
      _searched = true;
      _isExpanded = false;
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
            if (_searched) ...[
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
      // Statics.getLabel('sadbhavReportTable1'),
      // Statics.getLabel('sadbhavReportTable15'),
      // if (showRemaining) Statics.getLabel('sadbhavReportTable155'),
      Statics.getLabel('sanvaadReportTable1'),
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
          // dataRowMaxHeight: 75,

          border: TableBorder.all(color: Colors.black26),
          columns: [
            DataColumn(
              label: Container(
                alignment: Alignment.center,
                // constraints: BoxConstraints(minWidth: 40, maxWidth: 90),
                child: Text(
                  Statics.getLabel("SelectLevel"),
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
                        level.levelname == "रेल्वे स्थानक / शहर / अन्य" ? "अन्य" : level.levelname.toString(),
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
                // dataRowMaxHeight: 75,
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
                                  showInfoDialogBox(names: level.baithaknames ?? "", title: Statics.getLabel("sanvaadReportTable1"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        // DataCell(Center(
                        //     child: Row(
                        //   mainAxisAlignment: (level.startedcnt != 0 && level.startedname != null && level.startedname!.isNotEmpty) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                        //   children: [
                        //     if (level.startedcnt != 0 && level.startedname != null && level.startedname!.isNotEmpty) SizedBox(width: 1),
                        //     Container(
                        //         margin: EdgeInsets.only(right: (level.startedcnt != 0 && level.startedname != null && level.startedname!.isNotEmpty) ? 0 : 10),
                        //         child: Text(level.startedcnt.toString())),
                        //     if (level.startedcnt != 0 && level.startedname != null && level.startedname!.isNotEmpty)
                        //       InkWell(
                        //         borderRadius: BorderRadius.circular(50),
                        //         onTap: () {
                        //           showInfoDialogBox(names: level.startedname ?? "", title: Statics.getLabel("sadbhavReportTable3"));
                        //         },
                        //         child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                        //       ),
                        //   ],
                        // ))),
                        // if (showRemaining)
                        //   DataCell(Center(
                        //       child: Row(
                        //     mainAxisAlignment: (level.remainingcnt != 0 && level.remainingname != null && level.remainingname!.isNotEmpty) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                        //     children: [
                        //       if (level.remainingcnt != 0 && level.remainingname != null && level.remainingname!.isNotEmpty) SizedBox(width: 1),
                        //       Container(
                        //           margin: EdgeInsets.only(right: (level.remainingcnt != 0 && level.remainingname != null && level.remainingname!.isNotEmpty) ? 0 : 10),
                        //           child: Text(level.remainingcnt.toString())),
                        //       if (level.remainingcnt != 0 && level.remainingname != null && level.remainingname!.isNotEmpty)
                        //         InkWell(
                        //           borderRadius: BorderRadius.circular(50),
                        //           onTap: () {
                        //             showInfoDialogBox(names: level.remainingname ?? "", title: Statics.getLabel("sadbhavReportTable4"));
                        //           },
                        //           child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                        //         ),
                        //     ],
                        //   ))),
                        // DataCell(Center(child: Text(level.namecount.toString()))),
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
                        // DataCell(Center(
                        //     child: Text(
                        //   data.fold(0, (sum, item) => sum + (item.baithakcount ?? 0)).toString(),
                        //   style: TextStyle(fontWeight: FontWeight.w700),
                        // ))),
                        // DataCell(Center(
                        //     child: Text(
                        //   data.fold(0, (sum, item) => sum + (item.startedcnt ?? 0)).toString(),
                        //   style: TextStyle(fontWeight: FontWeight.w700),
                        // ))),
                        // if (showRemaining)
                        //   DataCell(Center(
                        //       child: Text(
                        //     data.fold(0, (sum, item) => sum + (item.remainingcnt ?? 0)).toString(),
                        //     style: TextStyle(fontWeight: FontWeight.w700),
                        //   ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.baithakcount ?? 0)).toString(),
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
                        rows: names.split("{niyodev}").toList().asMap().entries.map((entry) {
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
    return Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
      return Column(
        children: [
          Container(
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
                        GeoDropdownWidget(
                          level: GeoLevel.Mahaanagar,
                          title: 'Mahaanagar',
                          controller: ctrl,
                          onChanged: (v) => setState(() => _searched = false),
                        ),

                        // if (ctrl.hasItems(GeoLevel.vibhaag))
                        GeoDropdownWidget(
                          level: GeoLevel.Vibhaag,
                          title: 'Vibhaag',
                          controller: ctrl,
                          onChanged: (v) => setState(() => _searched = false),
                        ),

                        if (ctrl.hasItems(GeoLevel.Bhaag))
                          GeoDropdownWidget(
                            level: GeoLevel.Bhaag,
                            title: 'Bhaag',
                            controller: ctrl,
                            onChanged: (v) => setState(() => _searched = false),
                          ),

                        if (ctrl.hasItems(GeoLevel.Nagar))
                          GeoDropdownWidget(
                            level: GeoLevel.Nagar,
                            title: 'Nagar',
                            controller: ctrl,
                            onChanged: (v) => setState(() => _searched = false),
                          ),

                        /// CONDITIONAL
                        if (ctrl.hasItems(GeoLevel.upnagarUpkhanda))
                          GeoDropdownWidget(
                            level: GeoLevel.upnagarUpkhanda,
                            title: 'upnagarUpkhanda',
                            controller: ctrl,
                            onChanged: (v) => setState(() => _searched = false),
                          ),

                        if (ctrl.hasItems(GeoLevel.Mandal))
                          GeoDropdownWidget(
                            level: GeoLevel.Mandal,
                            title: 'Mandal',
                            controller: ctrl,
                            onChanged: (v) => setState(() => _searched = false),
                          ),
                        SizedBox(height: 21),
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
                              onPressed: () async => await getReportDataFun(ctrl.deepestSelectedGeoUnitId),
                              child: Text(
                                "${Statics.getLabel('search')}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            MaterialButton(
                                onPressed: () async {
                                  setState(() {
                                    _searched = false;
                                    report = [];
                                  });
                                  ctrl.loadHierarchyForUser();
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
          ),
          SizedBox(height: 20),
          if (_searched)
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
                      "${Statics.getLabel(ctrl.deepestSelectedLevelName ?? "praant")}",
                      style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    if (ctrl.deepestSelectedGeoUnitName != null && ctrl.deepestSelectedGeoUnitName!.isNotEmpty)
                      Text(
                        "  ->   ${ctrl.deepestSelectedGeoUnitName}",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                  ],
                )),
        ],
      );
    });
  }
}
