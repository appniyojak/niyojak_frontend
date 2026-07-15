import 'package:flutter/material.dart';

class SelectItem<T> {
  final T value;
  final String label;

  const SelectItem(this.value, this.label);
}

class GroupedMultiSelectField<T> extends StatefulWidget {
  final String title;
  final String buttonText;
  final String confirmText;
  final String cancelText;

  /// Group name -> items in that group.
  final Map<String, List<SelectItem<T>>> groupedItems;
  final List<T> initialValue;
  final ValueChanged<List<T>> onConfirm;

  final Color emptyBorderColor;
  final Color filledBorderColor;
  final Color accentColor;

  const GroupedMultiSelectField({
    Key? key,
    required this.title,
    required this.buttonText,
    required this.groupedItems,
    required this.initialValue,
    required this.onConfirm,
    this.confirmText = 'Submit',
    this.cancelText = 'clear',
    this.emptyBorderColor = const Color(0xFFBDBDBD), // grey.shade400
    this.filledBorderColor = Colors.transparent,
    this.accentColor = Colors.purple,
  }) : super(key: key);

  @override
  State<GroupedMultiSelectField<T>> createState() => _GroupedMultiSelectFieldState<T>();
}

class _GroupedMultiSelectFieldState<T> extends State<GroupedMultiSelectField<T>> {
  late List<T> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = List<T>.from(widget.initialValue);
  }

  List<SelectItem<T>> get _allItems => widget.groupedItems.values.expand((e) => e).toList();

  String _labelFor(T value) {
    for (final item in _allItems) {
      if (item.value == value) return item.label;
    }
    return value.toString();
  }

  Future<void> _openDialog() async {
    final result = await showDialog<List<T>>(
      context: context,
      builder: (ctx) => _GroupedMultiSelectDialog<T>(
        title: widget.title,
        confirmText: widget.confirmText,
        cancelText: widget.cancelText,
        groupedItems: widget.groupedItems,
        initialValue: _selectedValues,
        accentColor: widget.accentColor,
      ),
    );

    // Dialog returns null when cancelled/dismissed -> keep prior selection.
    if (result != null) {
      setState(() {
        _selectedValues = result;
      });
      widget.onConfirm(_selectedValues);
    }
  }

  void _removeChip(T value) {
    setState(() {
      _selectedValues.remove(value);
    });
    widget.onConfirm(_selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*Text(widget.title, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        const SizedBox(height: 4),*/
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _openDialog,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              border: Border.all(
                color: _selectedValues.isEmpty ? widget.emptyBorderColor : widget.filledBorderColor,
              ),
            ),
            child: Row(
              children: [
                Expanded(child: Text(widget.buttonText)),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (_selectedValues.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _selectedValues.map((value) {
              return Chip(
                label: Text(
                  _labelFor(value),
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: widget.accentColor, width: 0.7),
                ),
                deleteIcon: Icon(Icons.close, size: 16, color: widget.accentColor),
                onDeleted: () => _removeChip(value),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _GroupedMultiSelectDialog<T> extends StatefulWidget {
  final String title;
  final String confirmText;
  final String cancelText;
  final Map<String, List<SelectItem<T>>> groupedItems;
  final List<T> initialValue;
  final Color accentColor;

  const _GroupedMultiSelectDialog({
    Key? key,
    required this.title,
    required this.confirmText,
    required this.cancelText,
    required this.groupedItems,
    required this.initialValue,
    required this.accentColor,
  }) : super(key: key);

  @override
  State<_GroupedMultiSelectDialog<T>> createState() => _GroupedMultiSelectDialogState<T>();
}

class _GroupedMultiSelectDialogState<T> extends State<_GroupedMultiSelectDialog<T>> {
  late Set<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<T>.from(widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(widget.title),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      content: SizedBox(
        width: double.maxFinite,
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: widget.groupedItems.entries.map((entry) {
                  final groupName = entry.key;
                  final items = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text(
                          groupName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.accentColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      ...items.map((item) {
                        final isChecked = _selected.contains(item.value);
                        return CheckboxListTile(
                          dense: true,
                          value: isChecked,
                          activeColor: widget.accentColor,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(item.label),
                          onChanged: (checked) {
                            setDialogState(() {
                              if (checked == true) {
                                _selected.add(item.value);
                              } else {
                                _selected.remove(item.value);
                              }
                            });
                          },
                        );
                      }),
                      const Divider(height: 1),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      actions: [
        TextButton(
          // Matches original behavior: dismiss without applying the
          // in-progress selection.
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(widget.cancelText, style: TextStyle(color: widget.accentColor)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_selected.toList()),
          child: Text(widget.confirmText, style: TextStyle(color: widget.accentColor)),
        ),
      ],
    );
  }
}
