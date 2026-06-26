// ─── Generic Dropdown ─────────────────────────────────────────────────────────
//
// Two modes:
//   1. Pass [child] to wrap a custom widget (e.g. GeoDropdownWidget) in the
//      shared border/padding container — value/items/itemLabel are ignored.
//   2. Pass [value], [items], [itemLabel], [onChanged] (and optionally
//      [itemKey] for non-primitive T) to render a standard DropdownButton.

import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T>? items;
  final String Function(T)? itemLabel;

  /// Optional key extractor used for value matching when T doesn't implement
  /// value equality (e.g. StaticMasterBAL). When provided, the selected item
  /// is located by comparing itemKey(item) == itemKey(value).
  final String Function(T)? itemKey;

  final ValueChanged<T?>? onChanged;
  final Widget? child;

  const AppDropdown({
    this.value,
    this.items,
    this.itemLabel,
    this.itemKey,
    this.onChanged,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E5EA), width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: child ?? _buildDropdown(),
      ),
    );
  }

  Widget _buildDropdown() {
    assert(items != null && itemLabel != null && onChanged != null, '_AppDropdown requires items, itemLabel, and onChanged when child is null.');

    // When itemKey is provided, resolve the matched item from the list so that
    // Flutter's DropdownButton value-equality check always finds a match even
    // when T is a class without operator==.
    T? resolvedValue;
    if (value != null && itemKey != null) {
      final key = itemKey!(value as T);
      resolvedValue = items!.cast<T?>().firstWhere(
            (e) => e != null && itemKey!(e) == key,
            orElse: () => null,
          );
    } else {
      resolvedValue = value;
    }

    return DropdownButton<T>(
      value: resolvedValue,
      isExpanded: true,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Color(0xFFFF6B00),
        size: 22,
      ),
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF1C1C1E),
        fontWeight: FontWeight.w500,
      ),
      items: items!
          .map(
            (e) => DropdownMenuItem<T>(
              value: e,
              child: Text(itemLabel!(e)),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
