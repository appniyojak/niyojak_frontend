// ─────────────────────────────────────────────
// DAILY TAB
// ─────────────────────────────────────────────
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/static_data.dart' as Statics;

class ReusableBarTabCard extends StatelessWidget {
  // final ShaakhaaVistaarReport report;
  final int? totalshakhaa, yesterdayShakhaa, todayShakhaa;
  final String? mainLabel, totalLabel, lastLabel, currentLabel, currentTotalLabel, note;
  final bool inRow;
  final bool isHighlighted;
  final List<BarRow>? rows;

  const ReusableBarTabCard(
      {super.key,
      this.totalshakhaa,
      this.yesterdayShakhaa,
      this.todayShakhaa,
      this.mainLabel,
      this.totalLabel,
      this.lastLabel,
      this.currentLabel,
      this.currentTotalLabel,
      this.rows,
      this.note,
      this.inRow = false,
      this.isHighlighted = false});

  @override
  Widget build(BuildContext context) {
    final total = totalshakhaa ?? 0;
    final previous = (yesterdayShakhaa ?? 0);
    final current = (todayShakhaa ?? 0);
    final calPrevious = yesterdayShakhaa == 0 ? 1 : (yesterdayShakhaa ?? 1);
    final calCurrent = todayShakhaa == 0 ? 1 : (todayShakhaa ?? 1);

    final percentageChange = (current == previous)
        ? 0
        : previous == 0
            ? (((calCurrent + 1) - calPrevious) / calPrevious) * 100
            : ((current - previous) / previous) * 100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card 1: कुल शाखा संकल्प
          if (inRow)
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: StatCard(
                    label: totalLabel ?? Statics.getLabel('totalShakhaaSampann'),
                    value: total.toString(),
                    showBadge: false,
                    isHighlighted: isHighlighted,
                  ),
                ),
                // Card 2: आज की कुल शाखा
                Expanded(
                  child: StatCard(
                    label: currentTotalLabel ?? currentLabel ?? Statics.getLabel('todayTotalShakhaa'),
                    value: current.toString(),
                    showBadge: true,
                    badgeText: '${percentageChange.abs().toStringAsFixed(1)}',
                    badgePositive: percentageChange >= 0,
                    isHighlighted: isHighlighted,
                  ),
                ),
              ],
            )
          else ...[
            StatCard(
              label: totalLabel ?? Statics.getLabel('totalShakhaaSampann'),
              value: total.toString(),
              showBadge: false,
            ),
            const SizedBox(height: 12),
            // Card 2: आज की कुल शाखा
            StatCard(
              label: currentTotalLabel ?? currentLabel ?? Statics.getLabel('todayTotalShakhaa'),
              value: current.toString(),
              showBadge: true,
              badgeText: '${percentageChange.abs().toStringAsFixed(1)}',
              badgePositive: percentageChange >= 0,
            ),
          ],
          const SizedBox(height: 12),
          // Comparison Card
          ComparisonCard(
            title: mainLabel ?? Statics.getLabel('dailyShakhaaTulna'),
            note: note,
            rows: [
                  BarRow(
                    label: totalLabel ?? Statics.getLabel('totalShakhaaSampann'),
                    maxValue: total.toDouble(),
                    mainSegment: BarSegment(
                      label: totalLabel ?? Statics.getLabel('totalShakhaaSampann'),
                      value: total.toDouble(),
                      color: const Color(0xFF1E90FF),
                    ),
                  ),
                  BarRow(
                    label: lastLabel ?? Statics.getLabel('yesterdaysShakhaa'),
                    maxValue: total.toDouble(),
                    mainSegment: BarSegment(
                      label: lastLabel ?? Statics.getLabel('yesterdaysShakhaa'),
                      value: previous.toDouble(),
                      color: const Color(0xFFFF8C00),
                    ),
                  ),
                  BarRow(
                    label: currentLabel ?? Statics.getLabel('todaysShakhaa'),
                    maxValue: total.toDouble(),
                    mainSegment: BarSegment(
                      label: currentLabel ?? Statics.getLabel('todaysShakhaa'),
                      value: current.toDouble(),
                      color: const Color(0xFF00B533),
                    ),
                  ),
                ] +
                (rows ?? []),
          ),
        ],
      ),
    );
  }
}

/*// ─────────────────────────────────────────────
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
              _BarRow(label: Statics.getLabel('currentWeekShakhaa'), value: current.toDouble(), maxValue: total.toDouble(), color: Color(0xFF00B533)),
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
}*/

// ─────────────────────────────────────────────
// REUSABLE WIDGETS
// ─────────────────────────────────────────────

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool showBadge;
  final String? badgeText;
  final bool badgePositive;
  final bool isHighlighted;

  const StatCard({
    required this.label,
    required this.value,
    required this.showBadge,
    this.badgeText,
    this.badgePositive = true,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // 1. Outer container handles the shadow
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: !isHighlighted
            ? []
            : [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.08), // Slight orange tint to the shadow
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      // 2. ClipRRect ensures the blur doesn't bleed outside the rounded corners
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        // 3. BackdropFilter applies the frosted glass blur to whatever is behind it
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          // 4. Inner container handles the gradient, border, and content
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // The distinctive Apple "glass edge reflection"
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1.0,
              ),
              // The frosted white to orange hint gradient
              gradient: !isHighlighted
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.4), // Lighter top-left
                        Colors.white.withOpacity(0.1), // Transparent middle
                        Colors.deepOrange.withOpacity(0.15), // Orange hint bottom-right
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF8E8E93), // Works well on light glass
                    fontWeight: FontWeight.w500,
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
                        color: Colors.black, // Dark text for contrast
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
          ),
        ),
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
class BarSegment {
  final String label;
  final double value;
  final Color color;

  const BarSegment({
    required this.label,
    required this.value,
    required this.color,
  });
}

// Data class for bar rows — now supports a main segment + any number of
// smaller "other" segments, all stacked into one bar.
class BarRow {
  final String label;
  final double maxValue;
  final BarSegment mainSegment;
  final List<BarSegment> otherSegments;

  const BarRow({
    required this.label,
    required this.maxValue,
    required this.mainSegment,
    this.otherSegments = const [],
  });

  // All segments in display order (main first, then the rest)
  List<BarSegment> get segments => [mainSegment, ...otherSegments];

  // Sum of every segment's value (e.g. 626 + 27 + 125 + 97 = 875)
  double get totalValue => segments.fold(0.0, (sum, s) => sum + s.value);

  double get totalValueOfOther => otherSegments.fold(0.0, (sum, s) => sum + s.value);
}

class ComparisonCard extends StatelessWidget {
  final String title;
  final String? note;
  final List<BarRow> rows;

  const ComparisonCard({
    required this.title,
    this.note,
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

          const SizedBox(height: 8),
          if (note != null)
            Row(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "* " + Statics.getLabel('Note') + " : ",
                  style:
                      TextStyle(fontSize: 10, color: Colors.red.shade700, fontWeight: FontWeight.w600, decoration: TextDecoration.underline, decorationColor: Colors.red, fontStyle: FontStyle.italic),
                ),
                Flexible(
                  child: Text(
                    note!,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}

class _BarRowWidget extends StatelessWidget {
  final BarRow row;

  const _BarRowWidget({super.key, required this.row});

  String _formatValue(double v) {
    return NumberFormat.decimalPattern('en_IN').format(v.toInt());
  }

  @override
  Widget build(BuildContext context) {
    final total = row.totalValue;
    final fraction = row.maxValue == 0 ? 0.0 : total / row.maxValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label + total value (e.g. "875")
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: Text(
                row.label,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF3A3A3C),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Text(
              "${_formatValue(row.mainSegment.value)}" + (row.totalValueOfOther == 0 ? "" : " (${_formatValue(row.totalValueOfOther)})"),
              style: const TextStyle(
                fontSize: 12.5,
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
            final filledWidth = constraints.maxWidth * fraction;

            return Stack(
              children: [
                // Background track (represents maxValue, e.g. 1000)
                Container(
                  height: 10,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E5EA),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Filled, segmented bar (represents totalValue, e.g. 875)
                //doing filledWidth - (row.segments.length) because we are having margin on right: 1
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 10,
                    width: filledWidth,
                    child: Row(
                      children: [
                        for (final segment in row.segments)
                          _SegmentTapTarget(
                            // width of this s+egment relative to the filled portion
                            width: total == 0 ? 0 : (filledWidth - (row.segments.length)) * ((segment.value) / total),
                            segment: segment,
                          ),
                      ],
                    ),
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

// A single colored slice of the bar. Tapping it reveals its label/value
// via a tooltip (tooltip is tap-triggered, not hover/long-press).
class _SegmentTapTarget extends StatelessWidget {
  final double width;
  final BarSegment segment;

  const _SegmentTapTarget({
    required this.width,
    required this.segment,
  });

  @override
  Widget build(BuildContext context) {
    if (width <= 0) return const SizedBox.shrink();

    return Tooltip(
      message: '${segment.label}: ${segment.value.toInt()}',
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 2),
      preferBelow: false,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 11.5,
        fontWeight: FontWeight.w500,
      ),
      child: Container(
        height: 10,
        width: width,
        // tiny gap between segments so they read as distinct slices
        margin: const EdgeInsets.only(right: 1),
        color: segment.color,
      ),
    );
  }
}
