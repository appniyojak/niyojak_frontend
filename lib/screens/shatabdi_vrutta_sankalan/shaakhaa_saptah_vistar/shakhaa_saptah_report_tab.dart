import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/shaakhaa_vistar_report_repo_model.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';
import '../../../utils/stable_geounit_class.dart';
import 'shakhaa_saptah_form_screen.dart';

// ─────────────────────────────────────────────
//  Data model
// ─────────────────────────────────────────────
class AttendanceData {
  final String label; // Y-axis category label
  final double today;
  final double yesterday;

  const AttendanceData({
    required this.label,
    required this.today,
    required this.yesterday,
  });
}

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
      getReportDataFun(controller.deepestSelectedGeoUnitId);
    }
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
                  isDailySelected ? DailyTab(report: report!) : WeeklyTab(report: report!)
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
            child: _HorizontalBarChart(data: data, shaakhaaId: report?.mid, isDaily: isDaily, selectedshaakhaa: selectedshaakhaa, onIdTap: widget.onIdTap),
          ),

          const SizedBox(height: 16),

          // ── Legend ───────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: color ?? Color(0xFFE68449), label: Statics.getLabel(!isDailySelected ? 'lastWeek' : 'yesterdays'), bold: false),
              SizedBox(width: 24),
              _LegendDot(color: color ?? Color(0xFF1565C0), label: Statics.getLabel(!isDailySelected ? 'thisWeek' : 'today'), bold: true),
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

class _HorizontalBarChart extends StatefulWidget {
  final List<AttendanceData> data;
  final int? shaakhaaId;
  final bool isDaily;
  final GeoUnitMasterBAL? selectedshaakhaa;
  final Function(int id, bool fromYes, String viewType) onIdTap;

  const _HorizontalBarChart({required this.data, required this.shaakhaaId, required this.isDaily, this.selectedshaakhaa, required this.onIdTap});

  @override
  State<_HorizontalBarChart> createState() => _HorizontalBarChartState();
}

class _HorizontalBarChartState extends State<_HorizontalBarChart> {
  // State variables to hold the tap position and selected bar data
  Offset? _tapPosition;
  int? _touchedGroupIndex;
  int? _touchedRodIndex;

  // 1. DYNAMIC INTERVAL CALCULATOR: Chooses a clean step size to prevent label overlap
  double get _calculatedInterval {
    double maxVal = 0;
    for (var d in widget.data) {
      if (d.today > maxVal) maxVal = d.today;
      if (d.yesterday > maxVal) maxVal = d.yesterday;
    }
    if (maxVal == 0) return 40.0;

    // Aim for roughly 4 to 5 interval splits across the axis
    double rawInterval = maxVal / 4;

    if (rawInterval <= 15) return 20.0;
    if (rawInterval <= 30) return 40.0;
    if (rawInterval <= 60) return 50.0;
    if (rawInterval <= 120) return 100.0;
    if (rawInterval <= 300) return 250.0;
    if (rawInterval <= 600) return 500.0;
    return (rawInterval / 500).ceil() * 500.0; // Fallback for massive values (1000, 1500, etc.)
  }

  // Compute maximum bound dynamically to align grid lines uniformly
  double get _calculatedMaxX {
    if (widget.data.isEmpty) return 150.0;
    double maxVal = 0;
    for (var d in widget.data) {
      if (d.today > maxVal) maxVal = d.today;
      if (d.yesterday > maxVal) maxVal = d.yesterday;
    }

    // FIX: If the maximum value is 0, return a default max limit (e.g., 40.0).
    // This gives the grey background track an actual length to stretch across.
    if (maxVal == 0) return 40.0;

    final interval = _calculatedInterval;
    return ((maxVal / interval).ceil() * interval).toDouble();
  }

  List<BarChartGroupData> _buildGroups() {
    final maxLimit = _calculatedMaxX;

    return List.generate(widget.data.length, (i) {
      final d = widget.data[i];
      return BarChartGroupData(
        x: i,
        groupVertically: false,
        barsSpace: 6,
        barRods: [
          // 1. Yesterday / Previous Week Track
          BarChartRodData(
            toY: maxLimit, // ◄ Stretches the touch hit-box to full length
            width: 18,
            borderRadius: BorderRadius.circular(4),
            rodStackItems: [
              BarChartRodStackItem(0, d.yesterday, const Color(0xFFE68449)), // Filled value segment
              BarChartRodStackItem(d.yesterday, maxLimit, const Color(0xFFF0F0F0)), // Empty background segment
            ],
          ),
          // 2. Today / Current Week Track
          BarChartRodData(
            toY: maxLimit, // ◄ Stretches the touch hit-box to full length
            width: 18,
            borderRadius: BorderRadius.circular(4),
            rodStackItems: [
              BarChartRodStackItem(0, d.today, const Color(0xFF1565C0)), // Filled value segment
              BarChartRodStackItem(d.today, maxLimit, const Color(0xFFF0F0F0)), // Empty background segment
            ],
          ),
        ],
      );
    });
  }

  /*List<BarChartGroupData> _buildGroups() {
    final maxLimit = _calculatedMaxX;

    return List.generate(widget.data.length, (i) {
      final d = widget.data[i];
      return BarChartGroupData(
        x: i,
        groupVertically: false,
        barsSpace: 6,
        barRods: [
          // Yesterday (gray)
          BarChartRodData(
            toY: d.yesterday,
            color: const Color(0xFFB0BEC5),
            width: 18,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: (d.yesterday > d.today ? d.yesterday : d.today) + 100,
              color: const Color(0xFFF0F0F0),
            ),
          ),
          // Today (blue)
          BarChartRodData(
            toY: d.today,
            color: const Color(0xFF1565C0),
            width: 18,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: (d.yesterday > d.today ? d.yesterday : d.today) + 100,
              color: const Color(0xFFF0F0F0),
            ),
          ),
        ],
      );
    });
  }*/

  Widget _leftTitleWidget(double value, TitleMeta meta) {
    final interval = _calculatedInterval;

// Safety check for floating-point modulo precision
    final remainder = value % interval;
    if (remainder > 0.01 && (interval - remainder) > 0.01) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: RotatedBox(
        quarterTurns: 3,
        child: Text(
          value.toInt().toString(),
          style: const TextStyle(fontSize: 11, color: Color(0xFFE68449), fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _bottomTitleWidget(double value, TitleMeta meta) {
    final idx = value.toInt();
    if (idx < 0 || idx >= widget.data.length) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: RotatedBox(
        quarterTurns: 3,
        child: Text(
          widget.data[idx].label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFE68449),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dynamicInterval = _calculatedInterval;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1. The Chart
        BarChart(
          BarChartData(
            rotationQuarterTurns: 1,
            maxY: _calculatedMaxX,
            // maxY: (widget.data[0].yesterday > widget.data[0].today ? widget.data[0].yesterday : widget.data[0].today) + 100,
            minY: 0,
            groupsSpace: 20,
            barGroups: _buildGroups(),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              drawHorizontalLine: false,
              verticalInterval: dynamicInterval,
              getDrawingVerticalLine: (_) => const FlLine(
                color: Color(0xFFEEEEEE),
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: dynamicInterval,
                  getTitlesWidget: _leftTitleWidget,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 58,
                  getTitlesWidget: _bottomTitleWidget,
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),

            // 2. Updated Touch Data
            barTouchData: BarTouchData(
              enabled: true,
              handleBuiltInTouches: false, // Disables standard hover tooltips
              touchCallback: (FlTouchEvent event, barTouchResponse) {
                // Only act when the user taps down/up on the screen
                if (event is FlTapUpEvent) {
                  // If the user tapped empty space inside the chart, clear the popup
                  if (barTouchResponse == null || barTouchResponse.spot == null) {
                    if (_tapPosition != null) {
                      setState(() {
                        _tapPosition = null;
                        _touchedGroupIndex = null;
                        _touchedRodIndex = null;
                      });
                    }
                    return;
                  }

                  // If the user tapped a bar, record the coordinates and index
                  setState(() {
                    _tapPosition = event.localPosition;
                    _touchedGroupIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                    _touchedRodIndex = barTouchResponse.spot!.touchedRodDataIndex;
                  });
                }
              },
            ),
          ),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
        ),

        // 3. Floating Edit Button Container
        if (_tapPosition != null)
          Positioned(
            top: _tapPosition!.dx + 40,
            right: _tapPosition!.dy - 90,
            // FractionalTranslation shifts the container so it centers itself
            // above the exact tap point rather than starting from the top-left corner
            child: FractionalTranslation(
              translation: const Offset(-0.5, -1.2),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: (widget.selectedshaakhaa == null)
                      ? null
                      : () {
                          // TODO: Execute your edit logic here
                          final selectedData = widget.data[_touchedGroupIndex!];
                          final day = _touchedRodIndex == 0 ? 'Yesterday' : 'Today';
                          print('Edit tapped for ${selectedData.label} - $day');

                          // Optional: Hide container after pressing edit
                          setState(() => _tapPosition = null);

                          if (userLevelId == 1) {
                            widget.onIdTap(widget.shaakhaaId ?? 0, _touchedRodIndex == 0, "EditVrutta");
                            setState(() {});
                            return;
                          }

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShakhaaSaptahFormScreen(
                                        shaakhaaId: widget.shaakhaaId,
                                        fromYesterday: _touchedRodIndex == 0,
                                        viewType: "EditVrutta",
                                      )));
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA9A9ED), // Matches your old tooltip color
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${widget.data[_touchedGroupIndex!].label} \n\t ${Statics.getLabel(_touchedRodIndex == 0 ? (widget.isDaily ? "yesterdays" : "lastWeek") : (widget.isDaily ? "today" : "thisWeek"))} -> ${_touchedRodIndex == 0 ? widget.data[_touchedGroupIndex!].yesterday : widget.data[_touchedGroupIndex!].today}',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        if ((widget.selectedshaakhaa != null) && widget.isDaily) Icon(Icons.edit, size: 16, color: Colors.grey.shade900),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Legend dot
// ─────────────────────────────────────────────
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool bold;

  const _LegendDot({
    required this.color,
    required this.label,
    required this.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: bold ? Color(0xFF1565C0) : const Color(0xFFE68449),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// DAILY TAB
// ─────────────────────────────────────────────
class DailyTab extends StatelessWidget {
  final ShaakhaaVistaarReport report;

  const DailyTab({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final total = report.totalshakhaa ?? 0;
    final previous = report.yesterdayShakhaa ?? 0;
    final current = report.todayShakhaa ?? 0;

    final percentageChange = previous == 0 ? 0.0 : ((current - previous) / previous) * 100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card 1: कुल शाखा संकल्प
          _StatCard(
            label: Statics.getLabel('totalShakhaaSampann'),
            value: total.toString(),
            showBadge: false,
          ),
          const SizedBox(height: 12),
          // Card 2: आज की कुल शाखा
          _StatCard(
            label: Statics.getLabel('todayTotalShakhaa'),
            value: current.toString(),
            showBadge: true,
            badgeText: '${percentageChange.abs().toStringAsFixed(1)}',
            badgePositive: percentageChange >= 0,
          ),
          const SizedBox(height: 12),
          // Comparison Card
          _ComparisonCard(
            title: Statics.getLabel('dailyShakhaaTulna'),
            rows: [
              _BarRow(label: Statics.getLabel('totalShakhaaSampann'), value: total.toDouble(), maxValue: total.toDouble(), color: Color(0xFF1E90FF)),
              _BarRow(label: Statics.getLabel('yesterdaysShakhaa'), value: previous.toDouble(), maxValue: total.toDouble(), color: Color(0xFFFF8C00)),
              _BarRow(label: Statics.getLabel('todaysShakhaa'), value: current.toDouble(), maxValue: total.toDouble(), color: Color(0xFFFF8C00)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WEEKLY TAB
// ─────────────────────────────────────────────
class WeeklyTab extends StatelessWidget {
  final ShaakhaaVistaarReport report;

  const WeeklyTab({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final total = report.totalshakhaa ?? 0;
    final previous = report.previousWeekShakhaa ?? 0;
    final current = report.thisWeekShakhaa ?? 0;

    final percentageChange = previous == 0 ? 0.0 : ((current - previous) / previous) * 100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*// Section title
          const Text(
            'शाखा विवरण',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),*/
          const SizedBox(height: 12),

          // Card 1: कुल शाखा संकल्प
          _StatCard(
            label: Statics.getLabel('totalShakhaaSampann'),
            value: total.toString(),
            showBadge: false,
          ),
          const SizedBox(height: 12),

          // Card 2: सप्ताह की कुल शाखा
          _StatCard(
            label: Statics.getLabel('thisWeekTotalShakhaa'),
            value: current.toString(),
            showBadge: true,
            badgeText: '${percentageChange.abs().toStringAsFixed(1)}',
            badgePositive: percentageChange >= 0,
          ),
          const SizedBox(height: 12),

          // Comparison Card (Shakha)
          _ComparisonCard(
            title: Statics.getLabel('weeklyShakhaaTulna'),
            rows: [
              _BarRow(label: Statics.getLabel('totalShakhaaSampann'), value: total.toDouble(), maxValue: total.toDouble(), color: Color(0xFF1E90FF)),
              _BarRow(label: Statics.getLabel('previousWeekShakhaa'), value: previous.toDouble(), maxValue: total.toDouble(), color: Color(0xFFFF8C00)),
              _BarRow(label: Statics.getLabel('currentWeekShakhaa'), value: current.toDouble(), maxValue: total.toDouble(), color: Color(0xFFFF8C00)),
            ],
          ),
          const SizedBox(height: 24),

          /*// Section title: मिलन विवरण
          const Text(
            'साप्ताहिक मिलन विवरण',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),

          // Card 3: कुल मिलन संकल्प
          _StatCard(
            label: 'कुल मिलन संकल्प',
            value: '3,000',
            showBadge: false,
          ),
          const SizedBox(height: 12),

          // Card 4: सप्ताह के कुल मिलन
          _StatCard(
            label: 'सप्ताह के कुल मिलन',
            value: '2,800',
            showBadge: true,
            badgeText: '3.4%',
            badgePositive: false,
          ),
          const SizedBox(height: 12),

          // Comparison Card (Milan)
          _ComparisonCard(
            title: 'साप्ताहिक मिलन तुलना',
            rows: const [
              _BarRow(label: 'कुल मिलन संकल्प', value: 3000, maxValue: 3000, color: Color(0xFF1E90FF)),
              _BarRow(label: 'पिछले सप्ताह के मिलन', value: 2900, maxValue: 3000, color: Color(0xFFFF8C00)),
              _BarRow(label: 'इस सप्ताह के मिलन', value: 2800, maxValue: 3000, color: Color(0xFFFF8C00)),
            ],
          ),*/
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// REUSABLE WIDGETS
// ─────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool showBadge;
  final String? badgeText;
  final bool badgePositive;

  const _StatCard({
    required this.label,
    required this.value,
    required this.showBadge,
    this.badgeText,
    this.badgePositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8E8E93),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              if (showBadge && badgeText != null)
                _PercentBadge(
                  text: badgeText!,
                  isPositive: badgePositive,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PercentBadge extends StatelessWidget {
  final String text;
  final bool isPositive;

  const _PercentBadge({required this.text, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? const Color(0xFF34C759) : const Color(0xFFFF3B30);
    final icon = isPositive ? '↑' : '↓';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 2),
        Text(
          '$text%',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

// Data class for bar rows
class _BarRow {
  final String label;
  final double value;
  final double maxValue;
  final Color color;

  const _BarRow({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
  });
}

class _ComparisonCard extends StatelessWidget {
  final String title;
  final List<_BarRow> rows;

  const _ComparisonCard({
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with icon
          Row(
            children: [
              const Icon(
                Icons.show_chart,
                size: 16,
                color: Color(0xFF8E8E93),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3A3A3C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bar rows
          ...rows.map((row) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _BarRowWidget(row: row),
              )),
        ],
      ),
    );
  }
}

class _BarRowWidget extends StatelessWidget {
  final _BarRow row;

  const _BarRowWidget({super.key, required this.row});

  String _formatValue(double v) {
    if (v >= 1000) {
      return v.toInt().toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
    }
    return v.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    final fraction = row.value / row.maxValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label + value
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              row.label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF3A3A3C),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              _formatValue(row.value),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A3A3C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // Progress bar
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Background track
                Container(
                  height: 8,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E5EA),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Filled bar
                Container(
                  height: 8,
                  width: constraints.maxWidth * fraction,
                  decoration: BoxDecoration(
                    color: row.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
