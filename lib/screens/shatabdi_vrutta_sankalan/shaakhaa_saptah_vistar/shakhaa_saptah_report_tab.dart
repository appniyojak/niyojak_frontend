import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/shaakhaa_vistar_report_repo_model.dart';
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
  const ShakhaaSaptahReportTab({super.key});

  @override
  State<ShakhaaSaptahReportTab> createState() => _ShakhaaSaptahReportTabState();
}

class _ShakhaaSaptahReportTabState extends State<ShakhaaSaptahReportTab> with AutomaticKeepAliveClientMixin {
// This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  // bool isShakhaaSelected = true;
  bool isDailySelected = true;
  bool _isExpanded = true;
  bool _searched = false;

  ShaakhaaVistaarReport? report;
  List<AttendanceData> _dailyPresent = [];
  List<AttendanceData> _dailyNew = [];
  List<AttendanceData> _weeklyPresent = [];
  List<AttendanceData> _weeklyNew = [];

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dm = await MyAppGlobals.getLevelLDB();

      final controller = context.read<GeoHierarchyController>();

      await controller.initialize(dm);

      // isShakhaaSelected = (controller.ctrlUserLevelId == 1);

      setState(() {});
    });
  }

  ///////////////////////////////////////////////////////////////////////
  getReportDataFun(String? selectedGeoUnitId) async {
    report = null;
    setState(() {});
    Map<String, dynamic> formData = {
      "Geounitid": selectedGeoUnitId == null ? null : int.tryParse(selectedGeoUnitId.toString()),
      "appuserid": int.tryParse(Statics.userDetails['userID']) ?? null,
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
      AttendanceData(label: 'उपस्थिति', today: (report?.todayTotalCnt ?? 0).toDouble(), yesterday: (report?.yesterdayTotalCnt ?? 0).toDouble()),
      // AttendanceData(label: 'उपस्थिति', today: 145, yesterday: 110),
    ];
    _dailyNew = [
      AttendanceData(label: 'भरती', today: (report?.todayNewTotalCnt ?? 0).toDouble(), yesterday: (report?.yesterdayNewTotalCnt ?? 0).toDouble()),
      // AttendanceData(label: 'भरती', today: 145, yesterday: 110),
    ];
    _weeklyPresent = [
      AttendanceData(label: 'उपस्थिति', today: (report?.thisWeekTotalCnt ?? 0).toDouble(), yesterday: (report?.lastWeekTotalCnt ?? 0).toDouble()),
      // AttendanceData(label: 'उपस्थिति', today: 145, yesterday: 110),
    ];
    _weeklyNew = [
      AttendanceData(label: 'भरती', today: (report?.thisWeekNewTotalCnt ?? 0).toDouble(), yesterday: (report?.lastWeekNewTotalCnt ?? 0).toDouble()),
      // AttendanceData(label: 'भरती', today: 145, yesterday: 110),
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
                _attendanceCard(title: isDailySelected ? "कुल उपस्थिति" : "साप्ताहिक उपस्थिति", data: isDailySelected ? _dailyPresent : _weeklyPresent, isDaily: isDailySelected),
                _attendanceCard(title: isDailySelected ? "कुल नई भरती" : "साप्ताहिक नई भरती", data: isDailySelected ? _dailyNew : _weeklyNew, isDaily: isDailySelected)
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
          '${!isDailySelected ? "साप्ताहिक" : "दैनिक"} तुलना',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        SizedBox(height: 2),
        Text(
          !isDailySelected ? '(इस VS पिछले सप्ताह)' : '(आज VS कल)',
          style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
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
            child: _HorizontalBarChart(data: data, shaakhaaId: report?.mid, isDaily: isDaily),
          ),

          const SizedBox(height: 16),

          // ── Legend ───────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: color ?? Color(0xFFB0BEC5), label: !isDailySelected ? 'पिछले सप्ताह' : 'कल', bold: false),
              SizedBox(width: 24),
              _LegendDot(color: color ?? Color(0xFF1565C0), label: !isDailySelected ? 'इस सप्ताह' : 'आज', bold: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget vastiGraamDropdown() {
    return Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
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
                  ),

                  // if (ctrl.hasItems(GeoLevel.vibhaag))
                  GeoDropdownWidget(
                    level: GeoLevel.Vibhaag,
                    title: 'Vibhaag',
                    controller: ctrl,
                  ),

                  if (ctrl.hasItems(GeoLevel.Bhaag))
                    GeoDropdownWidget(
                      level: GeoLevel.Bhaag,
                      title: 'Bhaag',
                      controller: ctrl,
                    ),

                  if (ctrl.hasItems(GeoLevel.Nagar))
                    GeoDropdownWidget(
                      level: GeoLevel.Nagar,
                      title: 'Nagar',
                      controller: ctrl,
                    ),

                  ////////////////////////////////////////
                  /// CONDITIONAL

                  if (ctrl.hasItems(GeoLevel.upnagarUpkhanda))
                    GeoDropdownWidget(
                      level: GeoLevel.upnagarUpkhanda,
                      title: 'upnagarUpkhanda',
                      controller: ctrl,
                    ),

                  ////////////////////////////////////////

                  if (ctrl.hasItems(GeoLevel.Mandal))
                    GeoDropdownWidget(
                      level: GeoLevel.Mandal,
                      title: 'Mandal',
                      controller: ctrl,
                    ),

                  if (ctrl.hasItems(GeoLevel.Graam))
                    GeoDropdownWidget(
                      level: GeoLevel.Graam,
                      title: 'Graam',
                      controller: ctrl,
                    ),

                  if (ctrl.hasItems(GeoLevel.Vasti))
                    GeoDropdownWidget(
                      level: GeoLevel.Vasti,
                      title: 'Vasti',
                      controller: ctrl,
                    ),

                  if (ctrl.hasItems(GeoLevel.Shaakhaa))
                    GeoDropdownWidget(
                      level: GeoLevel.Shaakhaa,
                      title: 'Shaakhaa',
                      controller: ctrl,
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
                            getReportDataFun(ctrl.deepestSelectedGeoUnitId);
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
                ],
              ),
            ),
          ),
        ],
      );
    });
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
                    child: Text("दैनिक", style: TextStyle(color: isDailySelected ? Colors.white : Colors.black)),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => _getResultData(false),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                    child: Text("साप्ताहिक", style: TextStyle(color: isDailySelected ? Colors.black : Colors.white)),
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

  const _HorizontalBarChart({required this.data, required this.shaakhaaId, required this.isDaily});

  @override
  State<_HorizontalBarChart> createState() => _HorizontalBarChartState();
}

class _HorizontalBarChartState extends State<_HorizontalBarChart> {
  // State variables to hold the tap position and selected bar data
  Offset? _tapPosition;
  int? _touchedGroupIndex;
  int? _touchedRodIndex;

  List<BarChartGroupData> _buildGroups() {
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
  }

  Widget _leftTitleWidget(double value, TitleMeta meta) {
    if (value % 40 != 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: RotatedBox(
        quarterTurns: 3,
        child: Text(
          value.toInt().toString(),
          style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
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
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. The Chart
        BarChart(
          BarChartData(
            rotationQuarterTurns: 1,
            maxY: (widget.data[0].yesterday > widget.data[0].today ? widget.data[0].yesterday : widget.data[0].today) + 100,
            minY: 0,
            groupsSpace: 20,
            barGroups: _buildGroups(),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              drawHorizontalLine: false,
              verticalInterval: 40,
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
                  interval: 40,
                  getTitlesWidget: _leftTitleWidget,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 52,
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
            top: _tapPosition!.dx,
            left: _tapPosition!.dy,
            // FractionalTranslation shifts the container so it centers itself
            // above the exact tap point rather than starting from the top-left corner
            child: FractionalTranslation(
              translation: const Offset(-0.5, -1.2),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: context.read<GeoHierarchyController>().deepestSelectedLevelId != 1
                      ? null
                      : () {
                          // TODO: Execute your edit logic here
                          final selectedData = widget.data[_touchedGroupIndex!];
                          final day = _touchedRodIndex == 0 ? 'Yesterday' : 'Today';
                          print('Edit tapped for ${selectedData.label} - $day');

                          // Optional: Hide container after pressing edit
                          setState(() => _tapPosition = null);

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
                          '${widget.data[_touchedGroupIndex!].label} \n\t ${_touchedRodIndex == 0 ? (widget.isDaily ? "कल" : "पिछले सप्ताह") : (widget.isDaily ? "आज" : "इस सप्ताह")} -> ${_touchedRodIndex == 0 ? widget.data[_touchedGroupIndex!].yesterday : widget.data[_touchedGroupIndex!].today}',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        if (context.read<GeoHierarchyController>().deepestSelectedLevelId == 1 && widget.isDaily) Icon(Icons.edit, size: 16, color: Colors.grey.shade900),
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
            color: bold ? Color(0xFF1565C0) : const Color(0xFF888888),
          ),
        ),
      ],
    );
  }
}
