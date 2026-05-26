import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niyojak_prod/utils/globals.dart';
import 'package:provider/provider.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/yuva_sangam_report_model.dart';
import '../../../utils/stable_geounit_class.dart';

class YuvaSangamReportTab extends StatefulWidget {
  const YuvaSangamReportTab({super.key});

  @override
  State<YuvaSangamReportTab> createState() => _YuvaSangamReportTabState();
}

class _YuvaSangamReportTabState extends State<YuvaSangamReportTab> with AutomaticKeepAliveClientMixin {
// This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  late ScrollController _scrollController;
  bool _searched = false;
  bool _isExpanded = true;

  List<Yuvrpt> report = [];

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
    report = [];
    setState(() {});
    Map<String, dynamic> formData = {
      "geounitid": int.tryParse(selectedGeoUnitId.toString()) ?? 0,
      "appuserid": int.tryParse(Statics.userDetails['userID']) ?? null,
    };

    // String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    // log("Form Data (JSON):\n$formattedJson");
    report = await Statics.YuvaSangamReportData(context, formData) ?? [];
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

  Widget buildMarathiDataTable(List<Yuvrpt> data) {
    final List<String> headers = [
      Statics.getLabel('yuvaReportTable1'),
      Statics.getLabel('yuvaReportTable2'),
      Statics.getLabel('yuvaReportTable3'),
      Statics.getLabel('yuvaReportTable4'),
      Statics.getLabel('yuvaReportTable15'),
      Statics.getLabel('yuvaReportTable5'),
      Statics.getLabel('yuvaReportTable16'),
      Statics.getLabel('yuvaReportTable6'),
      Statics.getLabel('yuvaReportTable17'),
      Statics.getLabel('yuvaReportTable7'),
      Statics.getLabel('yuvaReportTable18'),
      Statics.getLabel('yuvaReportTable8'),
      Statics.getLabel('yuvaReportTable19'),
      Statics.getLabel('yuvaReportTable9'),
      Statics.getLabel('yuvaReportTable20'),
      Statics.getLabel('yuvaReportTable10'),
      Statics.getLabel('yuvaReportTable21'),
      Statics.getLabel('yuvaReportTable11'),
      Statics.getLabel('yuvaReportTable22'),
      Statics.getLabel('yuvaReportTable12'),
      Statics.getLabel('yuvaReportTable23'),
      Statics.getLabel('yuvaReportTable13'),
      Statics.getLabel('yuvaReportTable24'),
      Statics.getLabel('yuvaReportTable14'),
      Statics.getLabel('yuvaReportTable25'),
      Statics.getLabel('yuvaReportTable26'),
      Statics.getLabel('yuvaReportTable27'),
      Statics.getLabel('yuvaReportTable28'),
      Statics.getLabel('yuvaReportTable29'),
      Statics.getLabel('yuvaReportTable30'),
      Statics.getLabel('yuvaReportTable31'),
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
                columnSpacing: 0,
                horizontalMargin: 12,
                // dataRowMaxHeight: 75,
                headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                border: TableBorder(verticalInside: BorderSide(width: 0.7, color: Colors.grey.shade200)),
                columns: headers
                    .map((header) => DataColumn(
                          label: Container(
                            margin: EdgeInsets.symmetric(horizontal: 14),
                            constraints: BoxConstraints(minWidth: 40, maxWidth: 250),
                            // constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.2),
                            child: Text(header, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ))
                    .toList(),
                rows: data.map((level) {
                      return DataRow(cells: [
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.ekunyuva != 0 && level.ekunyuvaname != null && level.ekunyuvaname!.isNotEmpty) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.ekunyuva != 0 && level.ekunyuvaname != null && level.ekunyuvaname!.isNotEmpty) SizedBox(width: 1),
                            Container(
                                margin: EdgeInsets.only(right: (level.ekunyuva != 0 && level.ekunyuvaname != null && level.ekunyuvaname!.isNotEmpty) ? 0 : 10), child: Text(level.ekunyuva.toString())),
                            if (level.ekunyuva != 0 && level.ekunyuvaname != null && level.ekunyuvaname!.isNotEmpty)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.ekunyuvaname ?? "", title: Statics.getLabel("yuvaReportTable1"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment:
                              (level.completeyuva != 0 && level.completeyuvaname != null && level.completeyuvaname!.isNotEmpty) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.completeyuva != 0 && level.completeyuvaname != null && level.completeyuvaname!.isNotEmpty) SizedBox(width: 1),
                            Container(
                                margin: EdgeInsets.only(right: (level.completeyuva != 0 && level.completeyuvaname != null && level.completeyuvaname!.isNotEmpty) ? 0 : 10),
                                child: Text(level.completeyuva.toString())),
                            if (level.completeyuva != 0 && level.completeyuvaname != null && level.completeyuvaname!.isNotEmpty)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.completeyuvaname ?? "", title: Statics.getLabel("yuvaReportTable2"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.pendingyuva != 0 && level.pendingyuvaname != null && level.pendingyuvaname!.isNotEmpty) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.pendingyuva != 0 && level.pendingyuvaname != null && level.pendingyuvaname!.isNotEmpty) SizedBox(width: 1),
                            Container(
                                margin: EdgeInsets.only(right: (level.pendingyuva != 0 && level.pendingyuvaname != null && level.pendingyuvaname!.isNotEmpty) ? 0 : 10),
                                child: Text(level.pendingyuva.toString())),
                            if (level.pendingyuva != 0 && level.pendingyuvaname != null && level.pendingyuvaname!.isNotEmpty)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.pendingyuvaname ?? "", title: Statics.getLabel("yuvaReportTable3"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        DataCell(Center(child: Text(level.yuvaexpectmaha.toString()))),
                        DataCell(Center(child: Text(level.yuvapresentmaha.toString()))),
//
                        DataCell(Center(child: Text(level.yuvaexpecttarun.toString()))),
                        DataCell(Center(child: Text(level.yuvapresenttarun.toString()))),
//
                        DataCell(Center(child: Text(level.yuvaexpectpradhyapak.toString()))),
                        DataCell(Center(child: Text(level.yuvapresentpradhyapak.toString()))),
                        //
                        DataCell(Center(child: Text(level.ekunexcept.toString(), style: TextStyle(fontWeight: FontWeight.w700)))),
                        DataCell(Center(child: Text(level.ekunpresent.toString(), style: TextStyle(fontWeight: FontWeight.w700)))),
                        //
                        DataCell(Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              border: Border.all(color: Colors.black26, width: 0.7),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              level.yuvaexpectmandal.toString(),
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ))),
                        DataCell(Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              border: Border.all(color: Colors.black26, width: 0.7),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              level.yuvapresentmandal.toString(),
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ))),
                        //
                        DataCell(Center(child: Text(level.mahaexpectmaha.toString()))),
                        DataCell(Center(child: Text(level.mahapresentmaha.toString()))),
                        //
                        DataCell(Center(child: Text(level.mahaexpectvasti.toString()))),
                        DataCell(Center(child: Text(level.mahapresentvasti.toString()))),
                        //
                        DataCell(Center(child: Text(level.yuvasangamexceptmahashaakha.toString()))),
                        DataCell(Center(child: Text(level.yuvasangampresentmahashaakha.toString()))),
                        //
                        DataCell(Center(child: Text(level.yuvasangamexceptmahashaakhasankalpit.toString()))),
                        DataCell(Center(child: Text(level.yuvasangampresentmahashaakhasankalpit.toString()))),
                        //
                        DataCell(Center(child: Text(level.yuvasangamexceptvartmantarun.toString()))),
                        DataCell(Center(child: Text(level.yuvasangampresentvartmantarun.toString()))),
                        //
                        DataCell(Center(child: Text(level.yuvasangamexceptvartmantarunsankalpit.toString()))),
                        DataCell(Center(child: Text(level.yuvasangampresentvartmantarunsankalpit.toString()))),
                        //
                        DataCell(Center(child: Text(level.yuvasangamexceptshaakha.toString()))),
                        DataCell(Center(child: Text(level.yuvasangampresentshaakha.toString()))),
                        //
                        DataCell(Center(child: Text(level.yuvasangamexceptvartmansankalpit.toString()))),
                        DataCell(Center(child: Text(level.yuvasangampresentsankalpitshaakha.toString()))),
                        //
                        DataCell(Center(child: Text(level.totalyuvasangamexceptshaakha.toString()))),
                        DataCell(Center(child: Text(level.totalyuvasangampresentshaakha.toString()))),
                      ]);
                    }).toList() +
                    [
                      DataRow(color: MaterialStatePropertyAll(Colors.yellow.shade100), cells: [
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.ekunyuva ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.completeyuva ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.pendingyuva ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvaexpectmaha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvapresentmaha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvaexpecttarun ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvapresenttarun ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvaexpectpradhyapak ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvapresentpradhyapak ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.ekunexcept ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.ekunpresent ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvaexpectmandal ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvapresentmandal ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.mahaexpectmaha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.mahapresentmaha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.mahaexpectvasti ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.mahapresentvasti ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangamexceptmahashaakha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangampresentmahashaakha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangamexceptmahashaakhasankalpit ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangampresentmahashaakhasankalpit ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangamexceptvartmantarun ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangampresentvartmantarun ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangamexceptvartmantarunsankalpit ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangampresentvartmantarunsankalpit ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangampresentshaakha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangampresentsankalpitshaakha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangamexceptshaakha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangamexceptvartmansankalpit ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.totalyuvasangamexceptshaakha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.totalyuvasangampresentshaakha ?? 0)).toString(),
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
                          onChanged: () => setState(() => _searched = false),
                        ),

                        // if (ctrl.hasItems(GeoLevel.vibhaag))
                        GeoDropdownWidget(
                          level: GeoLevel.Vibhaag,
                          title: 'Vibhaag',
                          controller: ctrl,
                          onChanged: () => setState(() => _searched = false),
                        ),

                        if (ctrl.hasItems(GeoLevel.Bhaag))
                          GeoDropdownWidget(
                            level: GeoLevel.Bhaag,
                            title: 'Bhaag',
                            controller: ctrl,
                            onChanged: () => setState(() => _searched = false),
                          ),

                        if (ctrl.hasItems(GeoLevel.Nagar))
                          GeoDropdownWidget(
                            level: GeoLevel.Nagar,
                            title: 'Nagar',
                            controller: ctrl,
                            onChanged: () => setState(() => _searched = false),
                          ),

                        ////////////////////////////////////////
                        /// CONDITIONAL

                        if (ctrl.hasItems(GeoLevel.upnagarUpkhanda))
                          GeoDropdownWidget(
                            level: GeoLevel.upnagarUpkhanda,
                            title: 'upnagarUpkhanda',
                            controller: ctrl,
                            onChanged: () => setState(() => _searched = false),
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
