import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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

class HorizontalBarChart extends StatefulWidget {
  final List<AttendanceData> data;

  // DYNAMIC PROPERTIES ADDED:
  /// Callback triggered when the tooltip is tapped.
  /// Passes the selected data and a boolean indicating if it's the "Yesterday/Left" bar.
  final void Function(AttendanceData selectedData, bool isYesterday)? onTooltipTap;

  /// A builder function to completely customize the text inside the tooltip.
  final String Function(AttendanceData selectedData, bool isYesterday)? tooltipTextBuilder;

  /// Controls whether the edit icon is shown inside the tooltip.
  final bool showEditIcon;

  const HorizontalBarChart({
    Key? key,
    required this.data,
    this.onTooltipTap,
    this.tooltipTextBuilder,
    this.showEditIcon = false,
  }) : super(key: key);

  @override
  State<HorizontalBarChart> createState() => HorizontalBarChartState();
}

class HorizontalBarChartState extends State<HorizontalBarChart> {
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

    double rawInterval = maxVal / 4;

    if (rawInterval <= 15) return 20.0;
    if (rawInterval <= 30) return 40.0;
    if (rawInterval <= 60) return 50.0;
    if (rawInterval <= 120) return 100.0;
    if (rawInterval <= 300) return 250.0;
    if (rawInterval <= 600) return 500.0;
    return (rawInterval / 500).ceil() * 500.0;
  }

  // Compute maximum bound dynamically to align grid lines uniformly
  double get _calculatedMaxX {
    if (widget.data.isEmpty) return 150.0;
    double maxVal = 0;
    for (var d in widget.data) {
      if (d.today > maxVal) maxVal = d.today;
      if (d.yesterday > maxVal) maxVal = d.yesterday;
    }

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
            toY: maxLimit,
            width: 18,
            borderRadius: BorderRadius.circular(4),
            rodStackItems: [
              BarChartRodStackItem(0, d.yesterday, const Color(0xFFE68449)),
              BarChartRodStackItem(d.yesterday, maxLimit, const Color(0xFFF0F0F0)),
            ],
          ),
          // 2. Today / Current Week Track
          BarChartRodData(
            toY: maxLimit,
            width: 18,
            borderRadius: BorderRadius.circular(4),
            rodStackItems: [
              BarChartRodStackItem(0, d.today, const Color(0xFF1565C0)),
              BarChartRodStackItem(d.today, maxLimit, const Color(0xFFF0F0F0)),
            ],
          ),
        ],
      );
    });
  }

  Widget _leftTitleWidget(double value, TitleMeta meta) {
    final interval = _calculatedInterval;
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
      padding: const EdgeInsets.only(top: 2),
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
                  reservedSize: 72,
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
              handleBuiltInTouches: false,
              touchCallback: (FlTouchEvent event, barTouchResponse) {
                if (event is FlTapUpEvent) {
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

        // 3. Floating Edit Button Container (NOW DYNAMIC)
        if (_tapPosition != null && _touchedGroupIndex != null && _touchedRodIndex != null)
          Positioned(
            top: _tapPosition!.dx + 40,
            right: _tapPosition!.dy - 90,
            child: FractionalTranslation(
              translation: const Offset(-0.5, -1.2),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  // Triggers the injected callback instead of hardcoded logic
                  onTap: !widget.showEditIcon || widget.onTooltipTap == null
                      ? null
                      : () {
                          final selectedData = widget.data[_touchedGroupIndex!];
                          final isYesterday = _touchedRodIndex == 0;

                          // Execute external callback
                          widget.onTooltipTap!(selectedData, isYesterday);

                          // Hide container after pressing edit
                          setState(() => _tapPosition = null);
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA9A9ED),
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
                          // Generates text dynamically using the builder, or falls back to standard text
                          widget.tooltipTextBuilder != null
                              ? widget.tooltipTextBuilder!(widget.data[_touchedGroupIndex!], _touchedRodIndex == 0)
                              : '${widget.data[_touchedGroupIndex!].label} \n ${(_touchedRodIndex == 0) ? widget.data[_touchedGroupIndex!].yesterday : widget.data[_touchedGroupIndex!].today}',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (widget.showEditIcon) Icon(Icons.edit, size: 16, color: Colors.grey.shade900),
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
class LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool bold;

  const LegendDot({
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
