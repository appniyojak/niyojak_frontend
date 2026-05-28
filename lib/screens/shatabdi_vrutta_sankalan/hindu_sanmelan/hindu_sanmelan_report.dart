import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/hindu_sanmelan_report_model.dart';
import '../../../utils/cust_painters.dart';
import '../../../utils/globals.dart';
import '../../../utils/stable_geounit_class.dart';
import '../../../widgets/single_column_row.dart';

class HinduSanmelanReport extends StatefulWidget {
  final Function(String id) onIdTap;

  // static const String routeName = '/hindu_sanmelan-report-view';

  const HinduSanmelanReport({required this.onIdTap, super.key});

  @override
  State<HinduSanmelanReport> createState() => _HinduSanmelanReportState();
}

class _HinduSanmelanReportState extends State<HinduSanmelanReport> with AutomaticKeepAliveClientMixin {
// This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  late ScrollController _scrollController;
  bool _searched = false;
  bool _isExpanded = true;

  HinduSanmelanReportModel? report;

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
    report = null;
    setState(() {});
    Map<String, dynamic> formData = {
      "GeoUnitID": int.tryParse(selectedGeoUnitId ?? "0") ?? 0,
      "AppUserID": int.tryParse(Statics.userDetails['userID']) ?? null,
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    report = await Statics.getHinduSanmelanReportData(context, formData);
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
              if (report?.table1 != null && report?.table1 != []) buildMarathiDataTable(report?.table1 ?? []),
              SizedBox(height: 18),
              if (report != null) buildCountCards(report!),
              SizedBox(height: 30),
            ]
          ],
        ),
      ),
    );
  }

  Widget buildCountCards(HinduSanmelanReportModel data) {
    int calculateTotalMale() {
      final total = (data.samaj?.mukhyaatithimale ?? 0) + (data.samaj?.sadbavkaryamale ?? 0) + (data.samaj?.sajjanskhatiuppasstitimale ?? 0) + (data.samaj?.pramukhjhanuppasstitimale ?? 0);
      return total;
    }

    int calculateTotalFemale() {
      final total = (data.samaj?.mukhyaatithifemale ?? 0) + (data.samaj?.sadbavkaryafemale ?? 0) + (data.samaj?.sajjanskhatiuppasstitifemale ?? 0) + (data.samaj?.pramukhjhanuppasstitifemale ?? 0);
      return total;
    }

    return Column(
      spacing: 12,
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: ExpansionTile(
            tilePadding: EdgeInsets.only(right: 16, left: 16),
            childrenPadding: EdgeInsets.zero,
            collapsedBackgroundColor: Colors.purple.shade50,
            collapsedTextColor: Colors.blueAccent.shade700,
            // backgroundColor: Colors.purple.shade100,
            initiallyExpanded: true,
            shape: RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.circular(12)),
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              Statics.getLabel("OtherInfo"),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade600,
              ),
            ),
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.white),
                padding: EdgeInsets.only(bottom: 12),
                // padding: EdgeInsets.symmetric(horizontal: 14),
                child: SingleColumnRow(
                  dividerColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  subChildPadding: EdgeInsets.only(top: 12, bottom: 6, right: 12, left: 0),
                  txtString: null,
                  fontWeight: FontWeight.w700,
                  value: "",
                  fontsize: 16,
                  rowColor: Colors.purple.shade50,
                  subChild: Column(
                    spacing: 8,
                    children: [
                      SizedBox(),
                      Row(children: [
                        Expanded(
                            child: Text(
                          Statics.getLabel('images'),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          child: Row(
                            spacing: 2,
                            children: [
                              Text(
                                (data.otherinfo?.imgCount ?? 0).toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (data.otherinfo?.imgCount != 0)
                                InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: () {
                                    final _names = data.otherinfo?.imgCountnames;
                                    if (_names != null && _names.isNotEmpty) showInfoDialogBox(names: _names, title: Statics.getLabel("images"), showEye: true);
                                  },
                                  child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 14),
                                ),
                            ],
                          ),
                        ),
                      ]),
                      Row(children: [
                        Expanded(
                            child: Text(
                          Statics.getLabel('advImages'),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          child: Row(
                            spacing: 2,
                            children: [
                              Text(
                                (data.otherinfo?.advCount ?? 0).toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (data.otherinfo?.advCount != 0)
                                InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: () {
                                    final _names = data.otherinfo?.advCountnames;
                                    if (_names != null && _names.isNotEmpty) showInfoDialogBox(names: _names, title: Statics.getLabel("advImages"), showEye: true);
                                  },
                                  child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 14),
                                ),
                            ],
                          ),
                        ),
                      ]),
                      Row(children: [
                        Expanded(
                            child: Text(
                          Statics.getLabel('advLinks'),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          child: Row(
                            spacing: 2,
                            children: [
                              Text(
                                (data.otherinfo?.urlCount ?? 0).toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (data.otherinfo?.urlCount != 0)
                                InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: () {
                                    final _names = data.otherinfo?.urlCountnames;
                                    if (_names != null && _names.isNotEmpty) showInfoDialogBox(names: _names, title: Statics.getLabel("advLinks"), showEye: true);
                                  },
                                  child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 14),
                                ),
                            ],
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),

        //
        Card(
          margin: EdgeInsets.zero,
          child: ExpansionTile(
            tilePadding: EdgeInsets.only(right: 16, left: 16),
            childrenPadding: EdgeInsets.zero,
            collapsedBackgroundColor: Colors.purple.shade50,
            collapsedTextColor: Colors.blueAccent.shade700,
            // backgroundColor: Colors.purple.shade100,
            initiallyExpanded: true,
            shape: RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.circular(12)),
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              Statics.getLabel("bhougolikPratinidhitwa"),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade600,
              ),
            ),
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.white),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                // padding: EdgeInsets.symmetric(horizontal: 14),
                // margin: EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  margin: EdgeInsets.only(left: 16, right: 8),
                  child: Row(children: [
                    Expanded(child: Text("${Statics.getLabel('Total')} ${Statics.getLabel('Vasti')}")),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text((data.bhougolikprati?.totalvasti ?? 0).toString()),
                    ),
                  ]),
                ),
              ),
              SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                margin: EdgeInsets.only(left: 16, right: 8),
                child: Row(children: [
                  Expanded(
                      child: Text(
                    Statics.getLabel('SanmelanStartedCountVasti'),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      (data.bhougolikprati?.vastiStartedcount ?? 0).toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
              ),
              SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
              Container(
                decoration: BoxDecoration(color: Colors.white),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                // padding: EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  margin: EdgeInsets.only(left: 16, right: 8),
                  child: Row(children: [
                    Expanded(child: Text("${Statics.getLabel('Total')} ${Statics.getLabel('Mandal')}")),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text((data.bhougolikprati?.totalmandalCount ?? 0).toString()),
                    ),
                  ]),
                ),
              ),
              SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                margin: EdgeInsets.only(left: 16, right: 8),
                child: Row(children: [
                  Expanded(
                      child: Text(
                    Statics.getLabel('SanmelanStartedCountMandal'),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      (data.bhougolikprati?.totalmandalStartedcount ?? 0).toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
              ),
              SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
              Container(
                decoration: BoxDecoration(color: Colors.white),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                // padding: EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  margin: EdgeInsets.only(left: 16, right: 8),
                  child: Row(children: [
                    Expanded(child: Text("${Statics.getLabel('Total')} ${Statics.getLabel('Graam')}")),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text((data.bhougolikprati?.totalgramCount ?? 0).toString()),
                    ),
                  ]),
                ),
              ),
              SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                margin: EdgeInsets.only(left: 16, right: 8),
                child: Row(children: [
                  Expanded(
                      child: Text(
                    Statics.getLabel('gramPratinidhitwa'),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      (data.bhougolikprati?.pratigramcount ?? 0).toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
              ),
              SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
              Container(height: 8, width: MediaQuery.sizeOf(context).width, color: Colors.white),
            ],
          ),
        ),

        //
        Card(
          margin: EdgeInsets.zero,
          child: ExpansionTile(
            tilePadding: EdgeInsets.only(right: 16, left: 16),
            childrenPadding: EdgeInsets.zero,
            collapsedTextColor: Colors.blueAccent.shade700,
            // backgroundColor: Colors.purple.shade100,
            initiallyExpanded: true,
            shape: RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.circular(12)),
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              Statics.getLabel("samajScreenLabel"),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade600,
              ),
            ),
            children: [
              Container(
                  decoration: BoxDecoration(color: Colors.white),
                  padding: EdgeInsets.only(bottom: 12),
                  // padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    children: [
                      SingleColumnRow(
                        dividerColor: Colors.grey.shade400,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        subChildPadding: EdgeInsets.only(top: 2, bottom: 6, right: 12, left: 12),
                        txtString: Statics.getLabel('mukhyaAtithi'),
                        value: "",
                        fontsize: 16,
                        fontWeight: FontWeight.w600,
                        rowColor: Colors.purple.shade50,
                        subChild: Column(
                          children: [
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Male'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text((data.samaj?.mukhyaatithimale ?? 0).toString()),
                              ),
                            ]),
                            SizedBox(height: 8),
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Female'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text((data.samaj?.mukhyaatithifemale ?? 0).toString()),
                              ),
                            ]),
                            SizedBox(height: 6),
                            SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                            SizedBox(height: 6),
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Total'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text(((data.samaj?.mukhyaatithimale ?? 0) + (data.samaj?.mukhyaatithifemale ?? 0)).toString()),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      SingleColumnRow(
                        dividerColor: Colors.grey.shade400,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        subChildPadding: EdgeInsets.only(top: 2, bottom: 6, right: 12, left: 12),
                        txtString: Statics.getLabel('sadhbhavKarya'),
                        value: "",
                        fontsize: 16,
                        fontWeight: FontWeight.w600,
                        rowColor: Colors.purple.shade50,
                        subChild: Column(
                          children: [
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Male'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text((data.samaj?.sadbavkaryamale ?? 0).toString()),
                              ),
                            ]),
                            SizedBox(height: 8),
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Female'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text((data.samaj?.sadbavkaryafemale ?? 0).toString()),
                              ),
                            ]),
                            SizedBox(height: 6),
                            SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                            SizedBox(height: 6),
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Total'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text(((data.samaj?.sadbavkaryamale ?? 0) + (data.samaj?.sadbavkaryafemale ?? 0)).toString()),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      SingleColumnRow(
                        dividerColor: Colors.grey.shade400,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        subChildPadding: EdgeInsets.only(top: 2, bottom: 6, right: 12, left: 12),
                        txtString: Statics.getLabel("SajjanShakti"),
                        value: "",
                        fontsize: 16,
                        fontWeight: FontWeight.w600,
                        rowColor: Colors.purple.shade50,
                        subChild: Column(
                          children: [
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Male'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text((data.samaj?.sajjanskhatiuppasstitimale ?? 0).toString()),
                              ),
                            ]),
                            SizedBox(height: 8),
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Female'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text((data.samaj?.sajjanskhatiuppasstitifemale ?? 0).toString()),
                              ),
                            ]),
                            SizedBox(height: 6),
                            SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                            SizedBox(height: 6),
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Total'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text(((data.samaj?.sajjanskhatiuppasstitimale ?? 0) + (data.samaj?.sajjanskhatiuppasstitifemale ?? 0)).toString()),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      SingleColumnRow(
                        dividerColor: Colors.grey.shade400,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        subChildPadding: EdgeInsets.only(top: 2, bottom: 6, right: 12, left: 12),
                        txtString: Statics.getLabel("PramukhJan"),
                        value: "",
                        fontsize: 16,
                        fontWeight: FontWeight.w600,
                        rowColor: Colors.purple.shade50,
                        subChild: Column(
                          children: [
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Male'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text((data.samaj?.pramukhjhanuppasstitimale ?? 0).toString()),
                              ),
                            ]),
                            SizedBox(height: 8),
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Female'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text((data.samaj?.pramukhjhanuppasstitifemale ?? 0).toString()),
                              ),
                            ]),
                            SizedBox(height: 6),
                            SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                            SizedBox(height: 6),
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Total'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text(((data.samaj?.pramukhjhanuppasstitimale ?? 0) + (data.samaj?.pramukhjhanuppasstitifemale ?? 0)).toString()),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      // SingleColumnRow(
                      //   dividerColor: Colors.grey.shade400,
                      //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      //   subChildPadding: EdgeInsets.only(top: 2, bottom: 6, right: 12, left: 12),
                      //   txtString: Statics.getLabel("anyaUpasthit"),
                      //   value: "",
                      //   fontsize: 16,
                      //   fontWeight: FontWeight.w600,
                      //   rowColor: Colors.purple.shade50,
                      //   subChild: Column(
                      //     children: [
                      //       Row(children: [
                      //         Expanded(child: Text(Statics.getLabel('Male'))),
                      //         Container(
                      //           margin: EdgeInsets.only(left: 8),
                      //           child: Text((data.anyauppasstitimale ?? 0).toString()),
                      //         ),
                      //       ]),
                      //       SizedBox(height: 8),
                      //       Row(children: [
                      //         Expanded(child: Text(Statics.getLabel('Female'))),
                      //         Container(
                      //           margin: EdgeInsets.only(left: 8),
                      //           child: Text((data.anyanuppasstitifemale ?? 0).toString()),
                      //         ),
                      //       ]),
                      //       SizedBox(height: 6),
                      //       SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                      //       SizedBox(height: 6),
                      //       Row(children: [
                      //         Expanded(child: Text(Statics.getLabel('Total'))),
                      //         Container(
                      //           margin: EdgeInsets.only(left: 8),
                      //           child: Text(((data.anyauppasstitimale ?? 0) + (data.anyanuppasstitifemale ?? 0)).toString()),
                      //         ),
                      //       ]),
                      //     ],
                      //   ),
                      // ),
                      SingleColumnRow(
                        dividerColor: Colors.grey.shade400,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        subChildPadding: EdgeInsets.only(top: 2, bottom: 6, right: 12, left: 12),
                        txtString: Statics.getLabel("anyaUpasthit"),
                        value: "",
                        fontsize: 16,
                        fontWeight: FontWeight.w600,
                        rowColor: Colors.purple.shade50,
                        subChild: Column(
                          children: [
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Male'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text((data.samaj?.malecount ?? 0).toString()),
                              ),
                            ]),
                            SizedBox(height: 8),
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Female'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text((data.samaj?.femalecount ?? 0).toString()),
                              ),
                            ]),
                            SizedBox(height: 6),
                            SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                            SizedBox(height: 6),
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Total'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text((((data.samaj?.malecount ?? 0)) + ((data.samaj?.femalecount ?? 0))).toString()),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      SingleColumnRow(
                        dividerColor: Colors.grey.shade400,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        subChildPadding: EdgeInsets.only(top: 2, bottom: 6, right: 12, left: 12),
                        txtString: Statics.getLabel("presentTotal"),
                        value: "",
                        fontsize: 16,
                        fontWeight: FontWeight.w600,
                        rowColor: Colors.purple.shade50,
                        subChild: Column(
                          children: [
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Male'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text((data.samaj?.ekuntotalmale ?? 0).toString()),
                              ),
                            ]),
                            SizedBox(height: 8),
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Female'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text((data.samaj?.ekuntotalfemale ?? 0).toString()),
                              ),
                            ]),
                            SizedBox(height: 6),
                            SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                            SizedBox(height: 6),
                            Row(children: [
                              Expanded(child: Text(Statics.getLabel('Total'))),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text(((data.samaj?.ekuntotalmale ?? 0) + (data.samaj?.ekuntotalfemale ?? 0)).toString()),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),

        // //
        // Card(
        //   clipBehavior: Clip.antiAlias,
        //   margin: EdgeInsets.only(top: 16),
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        //   surfaceTintColor: Colors.transparent,
        //   child: ExpansionTile(
        //       tilePadding: EdgeInsets.only(right: 16, left: 16),
        //       childrenPadding: EdgeInsets.zero,
        //       collapsedBackgroundColor: Colors.yellow.shade100,
        //       backgroundColor: Colors.yellow.shade100,
        //       initiallyExpanded: true,
        //       shape: RoundedRectangleBorder(side: BorderSide.none),
        //       title: Text(
        //         Statics.getLabel("anyaUpstithSummary"),
        //         style: TextStyle(
        //           fontWeight: FontWeight.bold,
        //           color: Colors.blueAccent.shade700,
        //         ),
        //       ),
        //       children: [
        //         Container(
        //           color: Colors.white,
        //           padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 8.0, top: 12),
        //           child: Container(
        //             decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade800)),
        //             padding: EdgeInsets.all(12),
        //             child: Column(
        //               children: [
        //                 Row(children: [
        //                   Expanded(child: Text(Statics.getLabel('Male'))),
        //                   Container(
        //                     margin: EdgeInsets.only(left: 8),
        //                     child: Text((data.ekunmale ?? 0).toString()),
        //                   ),
        //                 ]),
        //                 SizedBox(height: 8),
        //                 Row(children: [
        //                   Expanded(child: Text(Statics.getLabel('Female'))),
        //                   Container(
        //                     margin: EdgeInsets.only(left: 8),
        //                     child: Text((data.ekunfemale ?? 0).toString()),
        //                   ),
        //                 ]),
        //                 SizedBox(height: 8),
        //                 // ✅ Total
        //                 SingleColumnRow(
        //                   padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        //                   rowColor: Colors.purple.shade50,
        //                   txtString: "${Statics.getLabel('presentAllTotal')} ",
        //                   value: data.ekumalenfemale.toString(),
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ]),
        // )
      ],
    );
  }

  ExpansionPanel _buildPanel(String title, int index, Widget child, {Color? tileColor, Color? backgroundColor}) {
    return ExpansionPanel(
      backgroundColor: backgroundColor,
      isExpanded: _expanded[index],
      headerBuilder: (context, isExpanded) {
        return ListTile(
          tileColor: tileColor,
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purpleAccent,
            ),
          ),
        );
      },
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: child,
      ),
    );
  }

  Widget buildMarathiDataTable(List<Table1> data) {
    final List<String> headers = [
      // 'कार्यक्रम स्तर',
      Statics.getLabel('sanmelanReportTable1'),
      Statics.getLabel('sanmelanReportTable2'),
      Statics.getLabel('sanmelanReportTable3'),
      Statics.getLabel('sanmelanReportTable4'),
      Statics.getLabel('sanmelanReportTable5'),
      Statics.getLabel('sanmelanReportTable6'),
    ];

    return Row(
      children: [
        DataTable(
          headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
          columnSpacing: 0,
          horizontalMargin: 16,
          border: TableBorder.all(color: Colors.black26),
          columns: [
            DataColumn(
              label: Container(
                constraints: BoxConstraints(minWidth: 40, maxWidth: 70),
                child: Text(
                  Statics.getLabel("sanmelanReportTable0"),
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
                  DataCell(Text(level.levelMarathi.toString())),
                ]);
              }).toList() +
              [
                DataRow(color: MaterialStatePropertyAll(Colors.yellow.shade100), cells: [
                  DataCell(Text(
                    Statics.getLabel("Total"),
                    style: TextStyle(fontWeight: FontWeight.w700),
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
                          mainAxisAlignment: (level.sanmelancount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.sanmelancount != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.sanmelancount != 0 ? 0 : 10), child: Text(level.sanmelancount.toString())),
                            if (level.sanmelancount != 0)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.sanmelancountnames ?? "", title: Statics.getLabel("sanmelanReportTable1"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        DataCell(Center(
                            child: level.levelMarathi == Statics.getLabel("Vasti")
                                ? Text("--")
                                : Row(
                                    mainAxisAlignment: (level.grammprati != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                                    children: [
                                      if (level.grammprati != 0) SizedBox(width: 1),
                                      Container(margin: EdgeInsets.only(right: level.grammprati != 0 ? 0 : 10), child: Text(level.grammprati.toString())),
                                      if (level.grammprati != 0)
                                        InkWell(
                                          borderRadius: BorderRadius.circular(50),
                                          onTap: () {
                                            showInfoDialogBox(names: level.grammpratinames ?? "", title: Statics.getLabel("sanmelanReportTable2"));
                                          },
                                          child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                                        ),
                                    ],
                                  ))),
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // if (level.specialpersontotalcount != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.specialpersontotalcount != 0 ? 0 : 10), child: Text(level.specialpersontotalcount.toString())),
                            // if (level.specialpersontotalcount != 0)
                            //   InkWell(
                            //     borderRadius: BorderRadius.circular(50),
                            //     onTap: () {
                            //       showInfoDialogBox(names: level.specialpersontotalcountnames ?? "", title: Statics.getLabel("sanmelanReportTable3"));
                            //     },
                            //     child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                            //   ),
                          ],
                        ))),

                        //sanchalan
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // if (level.totalmale != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.totalmale != 0 ? 0 : 10), child: Text(level.totalmale.toString())),
                            // if (level.totalmale != 0)
                            //   InkWell(
                            //     borderRadius: BorderRadius.circular(50),
                            //     onTap: () {
                            //       showInfoDialogBox(names: level.totalmalenames ?? "", title: Statics.getLabel("sanmelanReportTable4"));
                            //     },
                            //     child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                            //   ),
                          ],
                        ))),
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // if (level.totalfemale != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.totalfemale != 0 ? 0 : 10), child: Text(level.totalfemale.toString())),
                            // if (level.totalfemale != 0)
                            //   InkWell(
                            //     borderRadius: BorderRadius.circular(50),
                            //     onTap: () {
                            //       showInfoDialogBox(names: level.totalfemalenames ?? "", title: Statics.getLabel("sanmelanReportTable5"));
                            //     },
                            //     child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                            //   ),
                          ],
                        ))),
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // if (level.ekunfinalcount != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.totalcount != 0 ? 0 : 10), child: Text(level.totalcount.toString())),
                            // if (level.ekunfinalcount != 0)
                            //   InkWell(
                            //     borderRadius: BorderRadius.circular(50),
                            //     onTap: () {
                            //       showInfoDialogBox(names: level.ekunfinalcountnames ?? "", title: Statics.getLabel("sanmelanReportTable6"));
                            //     },
                            //     child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                            //   ),
                          ],
                        ))),
                      ]);
                    }).toList() +
                    [
                      DataRow(color: MaterialStatePropertyAll(Colors.yellow.shade100), cells: [
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.sanmelancount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.grammprati ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.specialpersontotalcount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),

                        //sanchalan
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.totalmale ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.totalfemale ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.totalcount ?? 0)).toString(),
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

  bool hasValueBetweenDollar(String input) {
    final regExp = RegExp(r'\$(.*?)\$');
    final match = regExp.firstMatch(input);

    return match != null && match.group(1)!.isNotEmpty;
  }

  showInfoDialogBox({required String names, required String title, bool showEye = false}) {
    final ScrollController _scrollController = ScrollController();
    final regExp = RegExp(r'\$(\d+)\$');
    final _containAnyDollar = hasValueBetweenDollar(names);
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
                          if (showEye && _containAnyDollar)
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
                          String? id;
                          final match = regExp.firstMatch(data);
                          if (match != null) {
                            id = match.group(1); // "15602"
                          }
                          String cleanedText = data.replaceAll(regExp, '').trim();
                          return DataRow(cells: [
                            DataCell(Container(constraints: BoxConstraints(maxWidth: 40), child: Text((index + 1).toString()))),
                            if (showEye && _containAnyDollar)
                              DataCell(InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    if (id != null && id.isNotEmpty) widget.onIdTap(id);
                                  },
                                  child: Icon(Icons.remove_red_eye, color: Colors.purple))),
                            DataCell(Text(cleanedText.replaceAll("\$", ""), maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true)),
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
                        "${Statics.getLabel('vastiGramNivda')}",
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

                        ////////////////////////////////////////
                        /// CONDITIONAL

                        if (ctrl.hasItems(GeoLevel.Vasti))
                          GeoDropdownWidget(
                            level: GeoLevel.Vasti,
                            title: 'Vasti',
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
                              onPressed: () => getReportDataFun(ctrl.deepestSelectedGeoUnitId),
                              child: Text(
                                "${Statics.getLabel('search')}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            MaterialButton(
                                onPressed: () async {
                                  setState(() {
                                    _searched = false;
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
              ),
            ),
        ],
      );
    });
  }
}
