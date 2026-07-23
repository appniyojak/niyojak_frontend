import 'package:flutter/material.dart';

// ─── Filter Label ─────────────────────────────────────────────────────────────

class FilterLabel extends StatelessWidget {
  final String text;

  const FilterLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      );
}

/// Rotating accent colors per nesting depth — gives each level a distinct
/// identity without needing hand-drawn tree lines or row-height math.
const List<Color> depthAccents = [
  Color(0xFF6366F1), // indigo — depth 1
  Color(0xFF06B6D4), // cyan   — depth 2
  Color(0xFFF97316), // orange — depth 3
  Color(0xFFEC4899), // pink   — depth 4+ (cycles)
];

Color accentForDepth(int depth) => depthAccents[(depth - 1) % depthAccents.length];

/// Wraps a subtree one indent level deeper: a soft accent-colored left
/// border + tinted background + rounded corner. No height math, works
/// with any number of nested levels and any mix of expanded/collapsed
/// rows underneath.
Widget nestedGroup(int depth, Widget child) {
  if (depth == 0) return child;
  final accent = accentForDepth(depth);
  return Container(
    margin: const EdgeInsets.only(left: 10, top: 2, bottom: 6),
    padding: const EdgeInsets.only(left: 12),
    decoration: BoxDecoration(
      color: accent.withOpacity(0.04),
      borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
      border: Border(left: BorderSide(color: accent.withOpacity(0.45), width: 3)),
    ),
    child: child,
  );
}
