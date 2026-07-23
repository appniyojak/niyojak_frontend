import 'package:flutter/material.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/shaakhaa_milan_report_models.dart';
import 'helper_widgets.dart';

List<ActivityNode> groupActivities(List<ActivityData> activities) {
  final Set<String> activityNames = activities.map((a) => a.activity).toSet();

  final Map<String, List<ActivityData>> childrenByParent = {};
  for (final a in activities) {
    if (a.parentactivity.isNotEmpty && activityNames.contains(a.parentactivity)) {
      childrenByParent.putIfAbsent(a.parentactivity, () => []).add(a);
    }
  }

  // Top-level = no parent, OR parent doesn't match any known activity
  // (orphan, treat as top-level) — same rule as before.
  final topLevel = activities.where((a) {
    return a.parentactivity.isEmpty || !activityNames.contains(a.parentactivity);
  }).toList();

  ActivityNode buildNode(ActivityData data, Set<String> ancestors) {
    if (ancestors.contains(data.activity)) {
      return ActivityNode(activity: data, children: const []);
    }
    final nextAncestors = {...ancestors, data.activity};
    final childData = childrenByParent[data.activity] ?? const [];
    final childNodes = childData.map((c) => buildNode(c, nextAncestors)).toList();
    return ActivityNode(activity: data, children: childNodes);
  }

  return topLevel.map((p) => buildNode(p, const {})).toList();
}

class AllLevelProgrammeBarsSection extends StatelessWidget {
  final List<ActivityNode> grouped;

  const AllLevelProgrammeBarsSection({required this.grouped});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFBF5),
              border: Border(
                bottom: BorderSide(color: Color(0xFFFFF3E0), width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'कार्यक्रमों के अनुसार स्थिति (%)',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'पूर्ण भरने वाली शाखाओं के आधार पर प्रतिशत',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8E8E93),
                  ),
                ),
              ],
            ),
          ),
          ...grouped.map((node) => AllLevelBarTile(node: node)),
        ],
      ),
    );
  }
}

/// Single recursive entry point: picks a plain row for a leaf activity or
/// an expandable group for one that has children, at any depth.
class AllLevelBarTile extends StatelessWidget {
  final ActivityNode node;
  final int depth;

  const AllLevelBarTile({super.key, required this.node, this.depth = 0});

  @override
  Widget build(BuildContext context) {
    if (node.children.isEmpty) {
      return _AllLevelBarRow(activity: node.activity, isChild: depth > 0);
    }
    return _ExpandableAllLevelBarGroup(node: node, depth: depth);
  }
}

class _AllLevelBarRow extends StatelessWidget {
  final ActivityData activity;
  final bool isChild;
  final bool embedded; // lets a parent wrapper (e.g. ExpansionTile) supply the box + padding

  const _AllLevelBarRow({
    required this.activity,
    this.isChild = false,
    this.embedded = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (double.tryParse(activity.percentage) ?? 0.0).clamp(0.0, 100.0);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                Statics.getLabel(activity.activity, returnKey: true),
                style: TextStyle(
                  fontSize: isChild ? 12.5 : 14,
                  fontWeight: isChild ? FontWeight.w500 : FontWeight.w600,
                  color: const Color(0xFF1C1C1E),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${pct.toStringAsFixed(2)}%',
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6366F1),
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
              widthFactor: (pct / 100).isNaN ? 0.0 : (pct / 100).clamp(0.0, 1.0),
              alignment: Alignment.centerLeft,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );

    if (embedded) return content; // parent wrapper supplies the box + padding

    return Container(
      decoration: BoxDecoration(
        color: isChild ? const Color(0xFFFAFAFC) : Colors.white,
        borderRadius: BorderRadius.circular(isChild ? 8 : 0),
        border: isChild ? Border.all(color: Colors.grey.shade300) : Border.symmetric(horizontal: BorderSide(color: Colors.grey.shade300, width: 0.7)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: content,
    );
  }
}

class _ExpandableAllLevelBarGroup extends StatelessWidget {
  final ActivityNode node;
  final int depth;

  const _ExpandableAllLevelBarGroup({required this.node, this.depth = 0});

  @override
  Widget build(BuildContext context) {
    final bool isTopLevel = depth == 0;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          border: isTopLevel ? Border.symmetric(horizontal: BorderSide(color: const Color(0xFFF0F0F0))) : null,
        ),
        child: ExpansionTile(
          key: PageStorageKey('${node.activity.activity}-$depth'),
          controlAffinity: ListTileControlAffinity.leading,
          initiallyExpanded: true,
          tilePadding: EdgeInsets.fromLTRB(isTopLevel ? 16 : 10, 8, 16, 12),
          childrenPadding: EdgeInsets.zero,
          title: _AllLevelBarRow(activity: node.activity, embedded: true, isChild: !isTopLevel),
          children: [
            nestedGroup(
              depth + 1,
              Column(
                children: node.children
                    .map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: AllLevelBarTile(node: c, depth: depth + 1),
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
