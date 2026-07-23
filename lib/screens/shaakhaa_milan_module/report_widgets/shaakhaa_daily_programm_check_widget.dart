// ─── Daily Checklist Widget ───────────────────────────────────────────────────
import 'package:flutter/material.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/shaakhaa_milan_report_models.dart';
import 'helper_widgets.dart';

//--------------------------------------------------------

class Completion {
  final int done;
  final int total;

  const Completion(this.done, this.total);
}

Completion computeCompletion(ActivityNode node) {
  if (node.children.isEmpty) {
    return Completion(node.activity.value >= 1 ? 1 : 0, 1);
  }
  int done = 0, total = 0;
  for (final c in node.children) {
    final r = computeCompletion(c);
    done += r.done;
    total += r.total;
  }
  return Completion(done, total);
}

class DailyChecklistWidget extends StatelessWidget {
  // final List<ActivityData> activities;
  final List<ActivityNode> groupActivities;

  const DailyChecklistWidget({required this.groupActivities});

  @override
  Widget build(BuildContext context) {
    if (groupActivities.isEmpty) return SizedBox();

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFBF5),
              border: Border(
                bottom: BorderSide(color: Color(0xFFFFF3E0), width: 1),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.bar_chart_rounded, size: 18, color: Color(0xFFFF6B00)),
                SizedBox(width: 8),
                Text(
                  Statics.getLabel('dailyActivityHeader', returnKey: true),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
              ],
            ),
          ),
          // ...activities.map((a) => _ChecklistRow(activity: a)),
          ...groupActivities.map((node) => ActivityTile(node: node))
        ],
      ),
    );
  }
}

/// Small rounded pill showing "done/total" for a group. Color communicates
/// progress at a glance: gray = not started, amber = in progress,
/// green = fully done — same visual language as the leaf check/x circles.
class _ProgressBadge extends StatelessWidget {
  final int done;
  final int total;

  const _ProgressBadge({required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    final bool complete = total > 0 && done == total;
    final bool started = done > 0;
    final Color color = complete
        ? const Color(0xFF22C55E)
        : started
            ? const Color(0xFFF59E0B)
            : const Color(0xFF9CA3AF);

    return Container(
      constraints: const BoxConstraints(minWidth: 34),
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(13),
      ),
      alignment: Alignment.center,
      child: Text(
        '$done/$total',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color, height: 1),
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  final ActivityNode node;
  final int depth;

  const ActivityTile({super.key, required this.node, this.depth = 0});

  @override
  Widget build(BuildContext context) {
    if (node.children.isEmpty) {
      return _ChecklistRow(activity: node.activity, depth: depth);
    }
    return _ExpandableParentTile(node: node, depth: depth);
  }
}

class _ChecklistRow extends StatelessWidget {
  final ActivityData activity;
  final int depth;

  const _ChecklistRow({required this.activity, this.depth = 0});

  @override
  Widget build(BuildContext context) {
    final bool isChild = depth > 0;
    final bool isDone = activity.value >= 1;
    final Color statusColor = isDone ? const Color(0xFF22C55E) : const Color(0xFFEF4444);

    return Container(
      decoration: BoxDecoration(
        color: isChild ? Colors.transparent : Colors.white,
        borderRadius: isChild ? BorderRadius.circular(8) : BorderRadius.zero,
        border: isChild ? null : const Border(bottom: BorderSide(color: Color(0xFFF2F2F7), width: 1)),
      ),
      padding: EdgeInsets.symmetric(horizontal: isChild ? 10 : 16, vertical: isChild ? 10 : 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              Statics.getLabel(activity.activity, returnKey: true),
              style: TextStyle(
                fontSize: isChild ? 13.5 : 14.5,
                color: isChild ? const Color(0xFF48484A) : const Color(0xFF1C1C1E),
                fontWeight: isChild ? FontWeight.w400 : FontWeight.w600,
                height: 1.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: isChild ? 26 : 30,
            height: isChild ? 26 : 30,
            decoration: BoxDecoration(color: statusColor.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(
              isDone ? Icons.check_rounded : Icons.close_rounded,
              size: isChild ? 15 : 18,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableParentTile extends StatelessWidget {
  final ActivityNode node;
  final int depth;

  const _ExpandableParentTile({required this.node, this.depth = 0});

  @override
  Widget build(BuildContext context) {
    final ActivityData parent = node.activity;
    final Completion completion = computeCompletion(node);
    final bool isTopLevel = depth == 0;

    final tile = Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: isTopLevel
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              )
            : null,
        clipBehavior: isTopLevel ? Clip.antiAlias : Clip.none,
        child: ExpansionTile(
          key: PageStorageKey('${parent.activity}-$depth'),
          initiallyExpanded: true,
          tilePadding: EdgeInsets.symmetric(horizontal: isTopLevel ? 16 : 10, vertical: 2),
          childrenPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          controlAffinity: ListTileControlAffinity.leading,
          // Group header is not itself "done/not done", so no check/x here —
          // the progress badge communicates status instead.
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  Statics.getLabel(parent.activity, returnKey: true),
                  style: TextStyle(
                    fontSize: isTopLevel ? 14.5 : 13.5,
                    color: const Color(0xFF1C1C1E),
                    fontWeight: isTopLevel ? FontWeight.w700 : FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              _ProgressBadge(done: completion.done, total: completion.total),
            ],
          ),
          children: [
            nestedGroup(
              depth + 1,
              Column(
                children: node.children.map((c) => ActivityTile(node: c, depth: depth + 1)).toList(),
              ),
            ),
          ],
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: isTopLevel ? 10 : 0),
      child: tile,
    );
  }
}
