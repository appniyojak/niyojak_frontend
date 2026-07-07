import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/shaakhaa_vistar_report_repo_model.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';
import '../../../utils/stable_geounit_class.dart';
import '../../../widgets/horizontal_graph_bar_widget.dart';
import '../../../widgets/reusable_tab_cards.dart';
import 'shakhaa_saptah_form_screen.dart';

// ─────────────────────────────────────────────
//  Page
// ─────────────────────────────────────────────
class ShakhaaSaptahReportTab extends StatefulWidget {
  final Function(int id, bool fromYes, String viewType) onIdTap;

  const ShakhaaSaptahReportTab({super.key, required this.onIdTap});

  @override
  State<ShakhaaSaptahReportTab> createState() => ShakhaaSaptahReportTabState();
}

class ShakhaaSaptahReportTabState extends State<ShakhaaSaptahReportTab> with AutomaticKeepAliveClientMixin {
// This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  final controller = createGeoController();

  // bool isShakhaaSelected = true;
  bool isDailySelected = true;
  bool _isExpanded = true;
  bool _searched = false;

  ShaakhaaVistaarReport? report;
  List<AttendanceData> _dailyPresent = [];
  List<AttendanceData> _dailyNew = [];
  List<AttendanceData> _weeklyPresent = [];
  List<AttendanceData> _weeklyNew = [];

  List<GeoUnitMasterBAL>? _linkedshaakhaa;
  GeoUnitMasterBAL? selectedshaakhaa;

  // _getData(bool isShakhaa, {bool isStart = false}) async {
  //   // await _setData();
  //   if (!isStart) isShakhaaSelected = isShakhaa;
  //   print("clear button pressed");
  //
  //   _searched = false;
  //   context.read<GeoHierarchyController>().loadHierarchyForUser();
  //   setState(() {});
  // }

  _getResultData(bool isDaily, {bool isStart = false}) async {
    // await _setData();
    if (!isStart) isDailySelected = isDaily;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initData());
  }

  initData() async {
    final dm = await MyAppGlobals.getLevelLDB();

    await controller.initialize(dm);

    // isShakhaaSelected = (controller.ctrlUserLevelId == 1);

    setState(() {});

    if ([2, 3].contains(controller.ctrlUserLevelId)) {
      populatelinkedShaakhaDropdown(controller.deepestSelectedGeoUnitId ?? "0", controller.ctrlUserLevelId == 3);
    }
    if (controller.ctrlUserLevelId == 1) {
      selectedshaakhaa = controller.deepestSelectedGeoUnitBAL;
    }
    getReportDataFun(controller.deepestSelectedGeoUnitId);
  }

  populatelinkedShaakhaDropdown(String iDStr, bool isGraam) async {
    selectedshaakhaa = null;
    _searched = false;
    report = null;
    setState(() {});
    Map<String, dynamic> formData = {
      "Geounitid": iDStr,
      "appuserid": int.tryParse(Statics.userDetails['userID']) ?? null,
    };

    // String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    // log("Form Data (JSON):\n$formattedJson");
    final _list = await Statics.getGeoShaakhaaForReportData(context, formData);
    // var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaakhaaLevelID'].toString(), iDStr, isGraam ? "Graam" : "Vasti", '');
    if (mounted)
      setState(() {
        _linkedshaakhaa = _list ?? [];
      });
  }

  ///////////////////////////////////////////////////////////////////////
  getReportDataFun(dynamic selectedGeoUnitId) async {
    report = null;
    setState(() {});
    Map<String, dynamic> formData = {
      "Geounitid": selectedGeoUnitId == null ? null : int.tryParse(selectedGeoUnitId.toString()),
      "appuserid": int.tryParse(Statics.userDetails['userID']) ?? null,
      "isnew": selectedshaakhaa?.isnew ?? 0,
    };

    // String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    // log("Form Data (JSON):\n$formattedJson");
    report = await Statics.getShaakhaaSaptahReportData(context, formData);
    // log("vijayadashamiReport >>>>>>>>>>>>>>>>> ${jsonDecode(jsonEncode(vijayadashamiReport))}");
    setState(() {
      report;
      _searched = true;
      _isExpanded = false;
    });

    // Add / edit rows here to show more attendance categories
    _dailyPresent = [
      AttendanceData(label: Statics.getLabel('upastithi'), today: (report?.todayTotalCnt ?? 0).toDouble(), yesterday: (report?.yesterdayTotalCnt ?? 0).toDouble()),
      // AttendanceData(label: Statics.getLabel('upastithi'), today: 145, yesterday: 110),
    ];
    _dailyNew = [
      AttendanceData(label: Statics.getLabel('admission'), today: (report?.todayNewTotalCnt ?? 0).toDouble(), yesterday: (report?.yesterdayNewTotalCnt ?? 0).toDouble()),
      // AttendanceData(label: Statics.getLabel(key)('admission'), today: 145, yesterday: 110),
    ];
    _weeklyPresent = [
      AttendanceData(label: Statics.getLabel('upastithi'), today: (report?.thisWeekTotalCnt ?? 0).toDouble(), yesterday: (report?.lastWeekTotalCnt ?? 0).toDouble()),
      // AttendanceData(label: Statics.getLabel('upastithi'), today: 145, yesterday: 110),
    ];
    _weeklyNew = [
      AttendanceData(label: Statics.getLabel('admission'), today: (report?.thisWeekNewTotalCnt ?? 0).toDouble(), yesterday: (report?.lastWeekNewTotalCnt ?? 0).toDouble()),
      // AttendanceData(label: Statics.getLabel(key)('admission'), today: 145, yesterday: 110),
    ];
    setState(() {});
  }

  ///////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            // _typeTab(),
            vastiGraamDropdown(),
            if (_searched)
              if (report == null)
                SizedBox(
                  height: 170,
                  child: Center(
                    child: Text(Statics.getLabel("noDataFoundTryAnotherSearch")),
                  ),
                )
              else ...[
                _typeResultTab(),
                _buildHeader(),
                if (selectedshaakhaa == null)
                  isDailySelected
                      ? ReusableBarTabCard(
                          todayShakhaa: report?.todayShakhaa,
                          totalshakhaa: report?.totalshakhaa,
                          yesterdayShakhaa: report?.yesterdayShakhaa,
                        )
                      : ReusableBarTabCard(
                          todayShakhaa: report?.thisWeekShakhaa,
                          totalshakhaa: report?.totalshakhaa,
                          yesterdayShakhaa: report?.previousWeekShakhaa,
                          mainLabel: Statics.getLabel("shakhaaTulna"),
                          currentTotalLabel: Statics.getLabel("thisWeekTotalShakhaa"),
                          currentLabel: Statics.getLabel("currentWeekShakhaa"),
                          lastLabel: Statics.getLabel('previousWeekShakhaa'),
                          totalLabel: Statics.getLabel("totalShakhaaSampann"),
                        )
                else ...[
                  _attendanceCard(title: "${Statics.getLabel('Total')} ${Statics.getLabel('upastithi')}", data: isDailySelected ? _dailyPresent : _weeklyPresent, isDaily: isDailySelected),
                  _attendanceCard(title: "${Statics.getLabel('Total')} ${Statics.getLabel('newAdmission')}", data: isDailySelected ? _dailyNew : _weeklyNew, isDaily: isDailySelected)
                ]
              ]
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${!isDailySelected ? Statics.getLabel("weekly") : Statics.getLabel("daily")} ${Statics.getLabel("comparison")}',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        SizedBox(height: 2),
        Text(
          Statics.getLabel(!isDailySelected ? 'thisVsLastWeek' : 'todayVsYesterday'),
          style: TextStyle(fontSize: 13, color: Color(0xFFE68449)),
        ),
      ],
    );
  }

  Widget _attendanceCard({
    required String title,
    required List<AttendanceData> data,
    bool isDaily = false,
    Color? color,
  }) {
    // Chart height scales with number of categories
    final double chartHeight = data.length * 120.0 + 60.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card header ──────────────────────────
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.groups_outlined, color: Color(0xFF1565C0), size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Horizontal bar chart ─────────────────
          SizedBox(
            height: chartHeight,
            width: MediaQuery.sizeOf(context).width,
            child: HorizontalBarChart(
              data: data,
              showEditIcon: selectedshaakhaa != null && isDaily, // Replaces hardcoded icon logic

              // 1. Customize the Text dynamically
              tooltipTextBuilder: (selectedData, isYesterday) {
                String timeLabel = Statics.getLabel(isYesterday ? (isDaily ? "yesterdays" : "lastWeek") : (isDaily ? "today" : "thisWeek"));

                double val = isYesterday ? selectedData.yesterday : selectedData.today;
                return '${selectedData.label} \n\t $timeLabel -> $val';
              },

              // 2. Customize the Tap Action dynamically
              onTooltipTap: (selectedData, isYesterday) {
                if (userLevelId == 1) {
                  widget.onIdTap(report?.mid ?? 0, isYesterday, "EditVrutta");
                  setState(() {});
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShakhaaSaptahFormScreen(
                      shaakhaaId: report?.mid,
                      isNew: selectedshaakhaa?.isnew == 1,
                      fromYesterday: isYesterday,
                      viewType: "EditVrutta",
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // ── Legend ───────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LegendDot(color: color ?? Color(0xFFE68449), label: Statics.getLabel(!isDailySelected ? 'lastWeek' : 'yesterdays'), bold: false),
              SizedBox(width: 24),
              LegendDot(color: color ?? Color(0xFF1565C0), label: Statics.getLabel(!isDailySelected ? 'thisWeek' : 'today'), bold: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget vastiGraamDropdown() {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
        return ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _isExpanded = isExpanded;
            });
          },
          children: [
            ExpansionPanel(
              isExpanded: _isExpanded,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(Statics.getLabel('Filters')),
                );
              },
              body: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    GeoDropdownWidget(
                      level: GeoLevel.Mahaanagar,
                      title: 'Mahaanagar',
                      controller: ctrl,
                      onChanged: (p0) => setState(() {
                        _searched = false;
                        _linkedshaakhaa = selectedshaakhaa = null;
                      }),
                    ),

                    // if (ctrl.hasItems(GeoLevel.vibhaag))
                    GeoDropdownWidget(
                      level: GeoLevel.Vibhaag,
                      title: 'Vibhaag',
                      controller: ctrl,
                      onChanged: (p0) => setState(() {
                        _searched = false;
                        _linkedshaakhaa = selectedshaakhaa = null;
                      }),
                    ),

                    if (ctrl.hasItems(GeoLevel.Bhaag))
                      GeoDropdownWidget(
                        level: GeoLevel.Bhaag,
                        title: 'Bhaag',
                        controller: ctrl,
                        onChanged: (p0) => setState(() {
                          _searched = false;
                          _linkedshaakhaa = selectedshaakhaa = null;
                        }),
                      ),

                    if (ctrl.hasItems(GeoLevel.Nagar))
                      GeoDropdownWidget(
                        level: GeoLevel.Nagar,
                        title: 'Nagar',
                        controller: ctrl,
                        onChanged: (p0) => setState(() {
                          _searched = false;
                          _linkedshaakhaa = selectedshaakhaa = null;
                        }),
                      ),

                    ////////////////////////////////////////
                    /// CONDITIONAL

                    if (ctrl.hasItems(GeoLevel.upnagarUpkhanda))
                      GeoDropdownWidget(
                        level: GeoLevel.upnagarUpkhanda,
                        title: 'upnagarUpkhanda',
                        controller: ctrl,
                        onChanged: (p0) => setState(() {
                          _searched = false;
                          _linkedshaakhaa = selectedshaakhaa = null;
                        }),
                      ),

                    ////////////////////////////////////////

                    if (ctrl.hasItems(GeoLevel.Mandal))
                      GeoDropdownWidget(
                        level: GeoLevel.Mandal,
                        title: 'Mandal',
                        controller: ctrl,
                        onChanged: (p0) => setState(() {
                          _searched = false;
                          _linkedshaakhaa = selectedshaakhaa = null;
                        }),
                      ),

                    if (ctrl.hasItems(GeoLevel.Graam))
                      GeoDropdownWidget(
                        level: GeoLevel.Graam,
                        title: 'Graam',
                        controller: ctrl,
                        onChanged: (p0) => populatelinkedShaakhaDropdown(p0, true),
                      ),

                    if (ctrl.hasItems(GeoLevel.Vasti))
                      GeoDropdownWidget(
                        level: GeoLevel.Vasti,
                        title: 'Vasti',
                        controller: ctrl,
                        onChanged: (p0) => populatelinkedShaakhaDropdown(p0, false),
                      ),

                    if (ctrl.ctrlUserLevelId == 1 && ctrl.hasItems(GeoLevel.Shaakhaa))
                      GeoDropdownWidget(
                        level: GeoLevel.Shaakhaa,
                        title: 'Shaakhaa',
                        controller: ctrl,
                      ),
                    if (ctrl.ctrlUserLevelId != 1 && _linkedshaakhaa != null && _linkedshaakhaa!.isNotEmpty)
                      DropdownButtonFormField<GeoUnitMasterBAL>(
                        decoration: InputDecoration(labelText: Statics.getLabel("Shaakhaa")),
                        isExpanded: true,
                        value: selectedshaakhaa,
                        items: _linkedshaakhaa!
                            .map((bg) => DropdownMenuItem(
                                  value: bg,
                                  child: Text(
                                    bg.geoUnitName.toString(),
                                    style: TextStyle(color: bg.isnew == 1 ? Colors.blue : Colors.black),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() {
                          _searched = false;
                          selectedshaakhaa = value;
                        }),
                      ),

                    SizedBox(height: 12),
                    /*if (isShakhaaSelected)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (ctrl.deepestSelectedLevelId == 1)
                            MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              color: Theme.of(context).primaryColor,
                              textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                              onPressed: () {
                                final trail = ctrl.hierarchyTrail;

                                print(trail.toJson());
                                print(ctrl.deepestSelectedLevelId);
                                setState(() {
                                  _searched = true;
                                });
                                // _search("Search", context);
                              },
                              child: Text(
                                Statics.getLabel('Search'),
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          MaterialButton(
                              onPressed: () {
                                print("clear button pressed");

                                setState(() {
                                  _searched = false;
                                });
                                ctrl.loadHierarchyForUser();
                              },
                              child: Text(Statics.getLabel('clear'))),
                        ],
                      )
                    else*/
                    if ((context.read<GeoHierarchyController>().ctrlUserLevelId ?? 0) > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                            onPressed: () {
                              // final trail = ctrl.hierarchyTrail;
                              //
                              // print(trail.toJson());
                              // print(ctrl.deepestSelectedLevelId);
                              setState(() {
                                _searched = true;
                              });
                              getReportDataFun(selectedshaakhaa?.geoUnitID ?? ctrl.deepestSelectedGeoUnitId);
                            },
                            child: Text(
                              Statics.getLabel('Search'),
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          MaterialButton(
                              onPressed: () {
                                print("clear button pressed");

                                setState(() {
                                  _searched = false;
                                  _linkedshaakhaa = selectedshaakhaa = null;
                                });
                                ctrl.loadHierarchyForUser();
                              },
                              child: Text(Statics.getLabel('clear'))),
                        ],
                      )
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  /*Widget _typeTab() {
    return AnimatedContainer(
      margin: EdgeInsets.symmetric(horizontal: 6),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: MediaQuery.sizeOf(context).width,
      height: 40,
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: !isShakhaaSelected ? (MediaQuery.sizeOf(context).width * 0.47) : 8,
            child: Container(
              width: (MediaQuery.sizeOf(context).width * 0.47 - 12),
              height: 36,
              decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(12)),
            ),
          ),
          if ((userLevelId ?? 0) > 1)
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _getData(true),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                      child: Text("Shaakhaa Only", style: TextStyle(color: isShakhaaSelected ? Colors.white : Colors.black)),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => _getData(false),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                      child: Text("Level Wise", style: TextStyle(color: isShakhaaSelected ? Colors.black : Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }*/

  Widget _typeResultTab() {
    return AnimatedContainer(
      margin: EdgeInsets.symmetric(horizontal: 6),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: MediaQuery.sizeOf(context).width,
      height: 40,
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: !isDailySelected ? (MediaQuery.sizeOf(context).width * 0.47) : 8,
            child: Container(
              width: (MediaQuery.sizeOf(context).width * 0.47 - 12),
              height: 36,
              decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(12)),
            ),
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _getResultData(true),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                    child: Text(Statics.getLabel("daily"), style: TextStyle(color: isDailySelected ? Colors.white : Colors.black)),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => _getResultData(false),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                    child: Text(Statics.getLabel("weekly"), style: TextStyle(color: isDailySelected ? Colors.black : Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
