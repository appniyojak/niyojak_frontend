import 'package:flutter/material.dart';

import '../../../helpers/static_data.dart' as Statics;
import 'helper_widgets.dart';
import 'module_constants.dart';

// ─────────────────────────────────────────────────────────────────────────
// 1. DATA MODEL — real tree instead of MapEntry<parent, List<child>>
// ─────────────────────────────────────────────────────────────────────────

class ProgrammeBarNode {
  final ProgrammeBar bar;
  final List<ProgrammeBarNode> children;

  const ProgrammeBarNode({required this.bar, required this.children});
}

class ProgrammeActivity {
  final String name;
  final bool completed;

  const ProgrammeActivity(this.name, this.completed);
}

class ProgrammeBar {
  final String name;
  final String parentActivity; // NEW
  final double progressFraction;
  final int totalDays;
  final double percent;
  final List<SubPeriod> subPeriods;

  const ProgrammeBar({
    required this.name,
    required this.parentActivity, // NEW
    required this.progressFraction,
    required this.totalDays,
    required this.percent,
    this.subPeriods = const [],
  });
}

class SubPeriod {
  final String label;
  final String days;
  final String percent;

  const SubPeriod(this.label, this.days, this.percent);
}

// ─────────────────────────────────────────────────────────────────────────
// 2. GROUPING — same fix as the activity checklist: recursively attach
//    children-of-children instead of stopping after one level. Same
//    O(n) parent index + cycle guard.
// ─────────────────────────────────────────────────────────────────────────

List<ProgrammeBarNode> groupProgrammeBars(List<ProgrammeBar> bars) {
  final Set<String> names = bars.map((b) => b.name).toSet();

  final Map<String, List<ProgrammeBar>> childrenByParent = {};
  for (final b in bars) {
    if (b.parentActivity.isNotEmpty && names.contains(b.parentActivity)) {
      childrenByParent.putIfAbsent(b.parentActivity, () => []).add(b);
    }
  }

  final topLevel = bars.where((b) {
    return b.parentActivity.isEmpty || !names.contains(b.parentActivity);
  }).toList();

  ProgrammeBarNode buildNode(ProgrammeBar data, Set<String> ancestors) {
    if (ancestors.contains(data.name)) {
      return ProgrammeBarNode(bar: data, children: const []);
    }
    final nextAncestors = {...ancestors, data.name};
    final childData = childrenByParent[data.name] ?? const [];
    final childNodes = childData.map((c) => buildNode(c, nextAncestors)).toList();
    return ProgrammeBarNode(bar: data, children: childNodes);
  }

  return topLevel.map((p) => buildNode(p, const {})).toList();
}

// ─────────────────────────────────────────────────────────────────────────
// 3. WIDGETS
// ─────────────────────────────────────────────────────────────────────────

class ProgrammeBarsSection extends StatelessWidget {
  final List<ProgrammeBarNode> grouped;
  final DurationTypes kalavadha;

  const ProgrammeBarsSection({required this.grouped, required this.kalavadha});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: grouped.map((node) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ProgrammeBarTile(node: node, kalavadha: kalavadha),
        );
      }).toList(),
    );
  }
}

/// Single recursive entry point: picks a plain card for a leaf bar or an
/// expandable group for a bar that has children, at any depth.
class ProgrammeBarTile extends StatelessWidget {
  final ProgrammeBarNode node;
  final DurationTypes kalavadha;
  final int depth;

  const ProgrammeBarTile({super.key, required this.node, required this.kalavadha, this.depth = 0});

  @override
  Widget build(BuildContext context) {
    if (node.children.isEmpty) {
      return _ProgrammeBarCard(bar: node.bar, kalavadha: kalavadha, isChild: depth > 0);
    }
    return _ExpandableProgrammeBarGroup(node: node, kalavadha: kalavadha, depth: depth);
  }
}

class _ProgrammeBarCard extends StatelessWidget {
  final ProgrammeBar bar;
  final DurationTypes kalavadha;
  final bool isChild;
  final bool embedded;
  final bool showTotalBadge;

  const _ProgrammeBarCard({
    required this.bar,
    required this.kalavadha,
    this.isChild = false,
    this.embedded = false,
    this.showTotalBadge = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                Statics.getLabel(bar.name, returnKey: true),
                style: TextStyle(
                  fontSize: isChild ? 13.5 : 15,
                  fontWeight: isChild ? FontWeight.w500 : FontWeight.w600,
                  color: const Color(0xFF1C1C1E),
                ),
              ),
            ),
            if (showTotalBadge)
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${Statics.getLabel("Total")}: ${bar.totalDays} ${Statics.getLabel("daysonly")} (${bar.percent.toStringAsFixed(2)}%)',
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE65100),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5EA),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: bar.progressFraction.isNaN ? 0.0 : bar.progressFraction.clamp(0.0, 1.0).toDouble(),
              alignment: Alignment.centerLeft,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B00),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        // Inline horizontal scroll only for a plain standalone top-level
        // card. Once a card is embedded as an ExpansionTile header, or
        // nested as a child, it's either squeezed inside a ListTile
        // (which clips tall composite content like this) or would stack
        // up messily under nested cards — so route those cases to a
        // bottom sheet instead of trying to cram the row in place.
        if (bar.subPeriods.isNotEmpty)
          if (!embedded && !isChild) _buildInlineSubPeriods() else _buildSubPeriodsTrigger(context),
      ],
    );

    if (embedded) return content; // parent wrapper below supplies the box + padding

    return Container(
      decoration: BoxDecoration(
        color: isChild ? const Color(0xFFFAFAFC) : Colors.white,
        borderRadius: BorderRadius.circular(isChild ? 8 : 0),
        border: isChild ? Border.all(color: const Color(0xFFF0F0F0)) : null,
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: content,
    );
  }

  Widget _buildInlineSubPeriods() {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: SingleChildScrollView(
        controller: ScrollController(keepScrollOffset: false),
        primary: false,
        padding: const EdgeInsets.only(left: 12),
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 6,
          children: bar.subPeriods.map((sp) => _SubPeriodCell(subPeriod: sp)).toList(),
        ),
      ),
    );
  }

  /// Small tappable chip that opens the weekly breakdown in a bottom
  /// sheet instead of inline, so nested/header cards stay compact.
  Widget _buildSubPeriodsTrigger(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showSubPeriodsSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_view_week_rounded, size: 14, color: Color(0xFF6366F1)),
              const SizedBox(width: 6),
              Text(
                '${Statics.getLabel("weekOnly")} ${Statics.getLabel("Total")} (${bar.subPeriods.length})',
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF6366F1)),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right_rounded, size: 14, color: Color(0xFF6366F1)),
            ],
          ),
        ),
      ),
    );
  }

  void _showSubPeriodsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5EA),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  Statics.getLabel(bar.name, returnKey: true),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1E)),
                ),
                const SizedBox(height: 14),
                ...bar.subPeriods.map((sp) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              sp.label,
                              style: TextStyle(fontSize: 13.5, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text(
                            sp.days,
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.black),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${sp.percent}%',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.indigo),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ExpandableProgrammeBarGroup extends StatelessWidget {
  final ProgrammeBarNode node;
  final DurationTypes kalavadha;
  final int depth;

  const _ExpandableProgrammeBarGroup({
    required this.node,
    required this.kalavadha,
    this.depth = 0,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTopLevel = depth == 0;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: isTopLevel ? Border.all(color: const Color(0xFFF0F0F0)) : null,
        ),
        child: ExpansionTile(
          key: PageStorageKey('${node.bar.name}-$depth'),
          controlAffinity: ListTileControlAffinity.leading,
          initiallyExpanded: true,
          tilePadding: EdgeInsets.fromLTRB(isTopLevel ? 16 : 10, 16, 16, 18),
          childrenPadding: EdgeInsets.zero,
          title: _ProgrammeBarCard(bar: node.bar, kalavadha: kalavadha, embedded: true, isChild: !isTopLevel, showTotalBadge: false),
          children: [
            nestedGroup(
              depth + 1,
              Column(
                children: node.children
                    .map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ProgrammeBarTile(node: c, kalavadha: kalavadha, depth: depth + 1),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubPeriodCell extends StatelessWidget {
  final SubPeriod subPeriod;

  const _SubPeriodCell({required this.subPeriod});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 70, maxWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
      ),
      child: Column(
        spacing: 2,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subPeriod.label,
            softWrap: true,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subPeriod.days,
            softWrap: true,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Text(
            '${subPeriod.percent}%',
            softWrap: true,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }
}
