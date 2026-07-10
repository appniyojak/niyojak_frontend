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
