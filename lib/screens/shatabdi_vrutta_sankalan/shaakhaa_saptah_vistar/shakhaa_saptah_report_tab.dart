import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../utils/globals.dart';
import '../../../utils/stable_geounit_class.dart';

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

class _ShakhaaSaptahReportTabState extends State<ShakhaaSaptahReportTab> {
  bool isShakhaaSelected = true;
  bool isDailySelected = true;
  bool _isExpanded = true;
  bool _searched = false;

  _getData(bool isShakhaa, {bool isStart = false}) async {
    // await _setData();
    if (!isStart) isShakhaaSelected = isShakhaa;
    print("clear button pressed");

    _searched = false;
    context.read<GeoHierarchyController>().loadHierarchyForUser();
    setState(() {});
  }

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

      setState(() {});
    });
  }

  // Add / edit rows here to show more attendance categories
  static const List<AttendanceData> _dailyPresent = [
    AttendanceData(label: 'उपस्थिति', today: 145, yesterday: 110),
  ];
  static const List<AttendanceData> _dailyNew = [
    AttendanceData(label: 'भरती', today: 145, yesterday: 110),
  ];
  static const List<AttendanceData> _weeklyPresent = [
    AttendanceData(label: 'उपस्थिति', today: 145, yesterday: 110),
  ];
  static const List<AttendanceData> _weeklyNew = [
    AttendanceData(label: 'भरती', today: 145, yesterday: 110),
  ];

  static const double _maxX = 160;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            _typeTab(),
            vastiGraamDropdown(),
            if (_searched) ...[
              _typeResultTab(),
              _buildHeader(),
              _attendanceCard(title: isDailySelected ? "कुल उपस्थिति" : "साप्ताहिक उपस्थिति", data: isDailySelected ? _dailyPresent : _weeklyPresent, maxX: _maxX),
              _attendanceCard(title: isDailySelected ? "कुल नई भरती" : "साप्ताहिक नई भरती", data: isDailySelected ? _dailyNew : _weeklyNew, maxX: _maxX)
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
    required double maxX,
    // bool isWeekly = false,
    Color? color,
  }) {
    // Chart height scales with number of categories
    final double chartHeight = data.length * 90.0 + 60.0;

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
            child: _HorizontalBarChart(data: data, maxX: maxX),
          ),

          const SizedBox(height: 16),

          // ── Legend ───────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: color ?? Color(0xFF1565C0), label: !isDailySelected ? 'पिछले सप्ताह' : 'कल', bold: false),
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
                    level: GeoLevel.mahaanagar,
                    title: 'Mahaanagar',
                    controller: ctrl,
                  ),

                  // if (ctrl.hasItems(GeoLevel.vibhaag))
                  GeoDropdownWidget(
                    level: GeoLevel.vibhaag,
                    title: 'Vibhaag',
                    controller: ctrl,
                  ),

                  if (ctrl.hasItems(GeoLevel.bhaag))
                    GeoDropdownWidget(
                      level: GeoLevel.bhaag,
                      title: 'Bhaag',
                      controller: ctrl,
                    ),

                  if (ctrl.hasItems(GeoLevel.nagar))
                    GeoDropdownWidget(
                      level: GeoLevel.nagar,
                      title: 'Nagar',
                      controller: ctrl,
                    ),

                  ////////////////////////////////////////
                  /// CONDITIONAL

                  if (ctrl.hasItems(GeoLevel.upnagar))
                    GeoDropdownWidget(
                      level: GeoLevel.upnagar,
                      title: 'upnagarUpkhanda',
                      controller: ctrl,
                    ),

                  ////////////////////////////////////////

                  if (ctrl.hasItems(GeoLevel.mandal))
                    GeoDropdownWidget(
                      level: GeoLevel.mandal,
                      title: 'Mandal',
                      controller: ctrl,
                    ),

                  if (ctrl.hasItems(GeoLevel.graam))
                    GeoDropdownWidget(
                      level: GeoLevel.graam,
                      title: 'Graam',
                      controller: ctrl,
                    ),

                  if (ctrl.hasItems(GeoLevel.vasti))
                    GeoDropdownWidget(
                      level: GeoLevel.vasti,
                      title: 'Vasti',
                      controller: ctrl,
                    ),

                  if (ctrl.hasItems(GeoLevel.shakhaa))
                    GeoDropdownWidget(
                      level: GeoLevel.shakhaa,
                      title: 'Shaakhaa',
                      controller: ctrl,
                    ),

                  SizedBox(height: 12),
                  if (isShakhaaSelected)
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
                  else
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
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _typeTab() {
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
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _getData(true),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                    child: Text("Shakhaa Only", style: TextStyle(color: isShakhaaSelected ? Colors.white : Colors.black)),
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
  }

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

class _HorizontalBarChart extends StatelessWidget {
  final List<AttendanceData> data;
  final double maxX;

  const _HorizontalBarChart({required this.data, required this.maxX});

  List<BarChartGroupData> _buildGroups() {
    return List.generate(data.length, (i) {
      final d = data[i];
      return BarChartGroupData(
        x: i,
        groupVertically: false,
        barsSpace: 6,
        barRods: [
          // Yesterday (gray)
          BarChartRodData(
            toY: d.yesterday,
            color: Color(0xFFB0BEC5),
            width: 18,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxX,
              color: const Color(0xFFF0F0F0),
            ),
          ),
          // Today (blue)
          BarChartRodData(
            toY: d.today,
            color: Color(0xFF1565C0),
            width: 18,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxX,
              color: const Color(0xFFF0F0F0),
            ),
          ),
        ],
      );
    });
  }

  // Numbers along the bottom (0 → 160)
  // Counter-rotated with quarterTurns: 3 to stay upright after +90° chart rotation
  Widget _leftTitleWidget(double value, TitleMeta meta) {
    if (value % 40 != 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: RotatedBox(
        quarterTurns: 3, // ← counter-rotate: +90° chart − 90° label = 0° net
        child: Text(
          value.toInt().toString(),
          style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
        ),
      ),
    );
  }

  // Category labels on the left (e.g. "उपस्थिति")
  // Counter-rotated with quarterTurns: 3 to stay upright
  Widget _bottomTitleWidget(double value, TitleMeta meta) {
    final idx = value.toInt();
    if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: RotatedBox(
        quarterTurns: 3, // ← same counter-rotation
        child: Text(
          data[idx].label,
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
    return RotatedBox(
      quarterTurns: 1, // ← KEY FIX: was 3, must be 1 for left→right bars
      child: BarChart(
        BarChartData(
          maxY: maxX,
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
            // After quarterTurns:1 rotation:
            //   original LEFT axis  → visual BOTTOM  (shows 0–160 numbers)
            //   original BOTTOM axis → visual LEFT    (shows category label)
            //   original RIGHT & TOP → hidden
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
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => const Color(0xFF1A1A2E),
              // tooltipRoundedRadius: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final label = rodIndex == 0 ? 'कल' : 'आज';
                return BarTooltipItem(
                  '$label: ${rod.toY.toInt()}',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
        ),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
      ),
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
