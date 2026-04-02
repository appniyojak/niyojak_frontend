import 'package:flutter/material.dart';

class ScrollableDataTable extends StatelessWidget {
  final List<String>? leftFixedHeaders;
  final List<DataRow>? leftFixedRows;
  final List<String> headers;
  final List<DataRow> rows;
  final double? columnSpacing, columnSpacingForLeft;
  final double? horizontalMargin, horizontalMarginForLeft;
  final double? dataRowMaxHeight, dataRowMaxHeightForLeft;
  final WidgetStateProperty<Color?>? headingRowColor, headingRowColorForLeft;
  final EdgeInsetsGeometry? headerMargin, headerMarginForLeft;

  const ScrollableDataTable(
      {super.key,
      this.leftFixedHeaders,
      this.leftFixedRows,
      required this.headers,
      required this.rows,
      this.columnSpacing,
      this.horizontalMargin,
      this.dataRowMaxHeight,
      this.columnSpacingForLeft,
      this.horizontalMarginForLeft,
      this.dataRowMaxHeightForLeft,
      this.headingRowColor,
      this.headingRowColorForLeft,
      this.headerMargin,
      this.headerMarginForLeft});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leftFixedHeaders != null && leftFixedRows != null)
          DataTable(
            headingRowColor: headingRowColorForLeft ??
                headingRowColor ??
                MaterialStateColor.resolveWith(
                  (_) => Theme.of(context).colorScheme.secondary.withOpacity(0.15),
                ),
            border: TableBorder.all(color: Colors.black12),
            columnSpacing: columnSpacingForLeft ?? columnSpacing ?? 16,
            horizontalMargin: horizontalMarginForLeft ?? horizontalMargin ?? 12,
            dataRowMaxHeight: dataRowMaxHeightForLeft ?? dataRowMaxHeight ?? 58,
            decoration: BoxDecoration(color: Colors.white),
            columns: leftFixedHeaders!
                .map((c) => DataColumn(
                      label: Container(
                        margin: headerMarginForLeft ?? headerMargin,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 60, maxWidth: 170),
                          child: Text(c, textAlign: TextAlign.center, softWrap: true, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ))
                .toList(),
            rows: leftFixedRows!,
          ),
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: headingRowColor ??
                  MaterialStateColor.resolveWith(
                    (_) => Theme.of(context).colorScheme.secondary.withOpacity(0.15),
                  ),
              border: TableBorder.all(color: Colors.black12),
              columnSpacing: columnSpacing ?? 16,
              horizontalMargin: horizontalMargin ?? 12,
              dataRowMaxHeight: dataRowMaxHeight ?? 58,
              decoration: BoxDecoration(color: Colors.white),
              columns: headers
                  .map((c) => DataColumn(
                        label: Container(
                          margin: headerMargin,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 40, maxWidth: 170),
                            child: Text(c, textAlign: TextAlign.center, softWrap: true, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ))
                  .toList(),
              rows: rows,
            ),
          ),
        ),
      ],
    );
  }
}

DataCell customDataRowCell(String label, {BoxConstraints? constraints, TextStyle? labelStyle, Decoration? cellDecoration, EdgeInsetsGeometry? cellPadding, EdgeInsetsGeometry? cellMargin}) {
  return DataCell(Center(
    child: Container(
      decoration: cellDecoration,
      padding: cellPadding,
      margin: cellMargin,
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: constraints ?? BoxConstraints(minWidth: 40, maxWidth: 170),
        child: Text(
          label,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: labelStyle ?? TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    ),
  ));
}

///BY AI
/*
/// Encapsulates visual styling for a [DataTable].
/// Pass separate instances to [ScrollableDataTable] for the left fixed
/// panel and the scrollable panel. Any field left null falls back to the
/// Flutter / widget default.
class DataTableStyle {
  final double? columnSpacing;
  final double? horizontalMargin;
  final double? dataRowMaxHeight;
  final WidgetStateProperty<Color?>? headingRowColor;
  final EdgeInsetsGeometry? headerMargin;

  const DataTableStyle({
    this.columnSpacing,
    this.horizontalMargin,
    this.dataRowMaxHeight,
    this.headingRowColor,
    this.headerMargin,
  });

  /// Creates a copy of this style, overriding only the supplied fields.
  DataTableStyle copyWith({
    double? columnSpacing,
    double? horizontalMargin,
    double? dataRowMaxHeight,
    WidgetStateProperty<Color?>? headingRowColor,
    EdgeInsetsGeometry? headerMargin,
  }) {
    return DataTableStyle(
      columnSpacing: columnSpacing ?? this.columnSpacing,
      horizontalMargin: horizontalMargin ?? this.horizontalMargin,
      dataRowMaxHeight: dataRowMaxHeight ?? this.dataRowMaxHeight,
      headingRowColor: headingRowColor ?? this.headingRowColor,
      headerMargin: headerMargin ?? this.headerMargin,
    );
  }
}

/// A data table that optionally pins one or more columns on the left while
/// the remaining columns scroll horizontally.
///
/// Example usage:
/// ```dart
/// ScrollableDataTable(
///   mainStyle: DataTableStyle(columnSpacing: 20),
///   leftStyle: DataTableStyle(columnSpacing: 12),   // overrides left panel only
///   leftFixedHeaders: ['Name', 'ID'],
///   leftFixedRows: myPinnedRows,
///   headers: myScrollableHeaders,
///   rows: myScrollableRows,
/// )
/// ```
class ScrollableDataTable extends StatelessWidget {
  final List<String>? leftFixedHeaders;
  final List<DataRow>? leftFixedRows;
  final List<String> headers;
  final List<DataRow> rows;

  /// Style applied to the scrollable (right) panel.
  final DataTableStyle mainStyle;

  /// Style applied to the fixed (left) panel.
  /// Fields not set here fall back to [mainStyle].
  final DataTableStyle? leftStyle;

  const ScrollableDataTable({
    super.key,
    this.leftFixedHeaders,
    this.leftFixedRows,
    required this.headers,
    required this.rows,
    this.mainStyle = const DataTableStyle(),
    this.leftStyle,
  });

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Builds a header cell with consistent styling.
  DataColumn _buildColumn(String label, EdgeInsetsGeometry? margin) {
    return DataColumn(
      label: Container(
        margin: margin,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 40, maxWidth: 170),
          child: Text(
            label,
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  /// Returns the effective heading row color, using the theme's secondary
  /// color at 10 % opacity as the sensible default.
  WidgetStateProperty<Color?> _resolvedHeadingColor(
    BuildContext context,
    WidgetStateProperty<Color?>? override,
  ) {
    return override ??
        WidgetStateColor.resolveWith(
          (_) => Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        );
  }

  /// Builds a [DataTable] from the provided style + data.
  DataTable _buildTable({
    required BuildContext context,
    required List<String> columnHeaders,
    required List<DataRow> tableRows,
    required DataTableStyle style,
  }) {
    return DataTable(
      headingRowColor: _resolvedHeadingColor(context, style.headingRowColor),
      border: TableBorder.all(color: Colors.black12),
      columnSpacing: style.columnSpacing ?? 16,
      horizontalMargin: style.horizontalMargin ?? 12,
      dataRowMaxHeight: style.dataRowMaxHeight ?? 58,
      columns: columnHeaders.map((header) => _buildColumn(header, style.headerMargin)).toList(),
      rows: tableRows,
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final bool hasLeftPanel = leftFixedHeaders != null && leftFixedRows != null;

    // Merge: start from mainStyle and override with leftStyle fields.
    final DataTableStyle resolvedLeftStyle = hasLeftPanel
        ? (mainStyle.copyWith()).copyWith(
            columnSpacing: leftStyle?.columnSpacing,
            horizontalMargin: leftStyle?.horizontalMargin,
            dataRowMaxHeight: leftStyle?.dataRowMaxHeight,
            headingRowColor: leftStyle?.headingRowColor,
            headerMargin: leftStyle?.headerMargin,
          )
        : mainStyle;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ── Fixed left panel ────────────────────────────────────────────────
        if (hasLeftPanel)
          _buildTable(
            context: context,
            columnHeaders: leftFixedHeaders!,
            tableRows: leftFixedRows!,
            style: resolvedLeftStyle,
          ),

        // ── Horizontally scrollable right panel ─────────────────────────────
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildTable(
              context: context,
              columnHeaders: headers,
              tableRows: rows,
              style: mainStyle,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Static factory — keeps the helper co-located with the widget
  // ---------------------------------------------------------------------------

  /// Creates a consistently styled [DataCell].
  ///
  /// ```dart
  /// ScrollableDataTable.buildCell('John Doe')
  /// ScrollableDataTable.buildCell('Active', style: TextStyle(color: Colors.green))
  /// ```
  static DataCell buildCell(
    String label, {
    BoxConstraints? constraints,
    TextStyle? style,
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return DataCell(
      Container(
        decoration: decoration,
        padding: padding,
        margin: margin,
        alignment: Alignment.center,
        // single alignment — no redundant Center()
        child: ConstrainedBox(
          constraints: constraints ?? const BoxConstraints(minWidth: 40, maxWidth: 170),
          child: Text(
            label,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: style ?? const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

// ── Optional ergonomic extension ──────────────────────────────────────────────
/// Lets you turn any [String] directly into a [DataCell]:
///
/// ```dart
/// 'John Doe'.toDataCell()
/// 'Active'.toDataCell(style: TextStyle(color: Colors.green))
/// ```
extension StringDataCellX on String {
  DataCell toCustomDataCell({
    BoxConstraints? constraints,
    TextStyle? style,
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return ScrollableDataTable.buildCell(
      this,
      constraints: constraints,
      style: style,
      decoration: decoration,
      padding: padding,
      margin: margin,
    );
  }
}
*/

///BY AI 2
/*
/// A reusable horizontally-scrollable data table that replaces
/// the `HorizontalDataTable` package with Flutter's built-in widgets.
///
/// Usage:
/// ```dart
/// ScrollableDataTable(
///   fixedColumn: ColumnDef('Name', 100),
///   scrollableColumns: [ColumnDef('Age', 80), ColumnDef('Score', 80)],
///   rows: myData,
///   fixedCellBuilder: (row, i) => Text(row.name),
///   scrollableCellBuilder: (row, i, colIndex) => Text(row.values[colIndex]),
/// )
/// ```
class ColumnDef {
  final String label;
  final double width;
  final Alignment alignment;

  const ColumnDef(this.label, this.width, {this.alignment = Alignment.center});
}

class ScrollableDataTable2<T> extends StatelessWidget {
  final ColumnDef fixedColumn;
  final List<ColumnDef> scrollableColumns;
  final List<T> rows;
  final Widget Function(T item, int index) fixedCellBuilder;
  final Widget Function(T item, int index, int colIndex) scrollableCellBuilder;
  final bool Function(int index)? isTotalRow;
  final double rowHeight;
  final double headerHeight;
  final String? noDataLabel;

  const ScrollableDataTable2({
    super.key,
    required this.fixedColumn,
    required this.scrollableColumns,
    required this.rows,
    required this.fixedCellBuilder,
    required this.scrollableCellBuilder,
    this.isTotalRow,
    this.rowHeight = 52,
    this.headerHeight = 60,
    this.noDataLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(noDataLabel ?? 'No data found', style: const TextStyle(fontWeight: FontWeight.normal)),
      );
    }

    return SizedBox(
      height: _calcHeight(),
      child: Row(
        children: [
          // Fixed left column
          SizedBox(
            width: fixedColumn.width,
            child: Column(
              children: [
                _headerCell(fixedColumn),
                Expanded(
                  child: ListView.separated(
                    itemCount: rows.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.black54, thickness: 0),
                    itemBuilder: (ctx, i) => _dataCell(
                      child: fixedCellBuilder(rows[i], i),
                      width: fixedColumn.width,
                      alignment: fixedColumn.alignment,
                      highlight: isTotalRow?.call(i) ?? false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Scrollable right columns
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: scrollableColumns.fold<double>(0, (sum, c) => sum + c.width),
                child: Column(
                  children: [
                    Row(children: scrollableColumns.map(_headerCell).toList()),
                    Expanded(
                      child: ListView.separated(
                        itemCount: rows.length,
                        separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.black54, thickness: 0),
                        itemBuilder: (ctx, i) {
                          final highlight = isTotalRow?.call(i) ?? false;
                          return Row(
                            children: List.generate(scrollableColumns.length, (ci) {
                              final col = scrollableColumns[ci];
                              return _dataCell(
                                child: scrollableCellBuilder(rows[i], i, ci),
                                width: col.width,
                                alignment: col.alignment,
                                highlight: highlight,
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calcHeight() {
    final dataH = rows.length * (rowHeight + 1); // +1 for divider
    return (headerHeight + dataH).clamp(80, 340);
  }

  Widget _headerCell(ColumnDef col) {
    return Container(
      width: col.width,
      height: headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: col.alignment,
      color: Colors.grey.shade200,
      child: Text(
        col.label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget _dataCell({
    required Widget child,
    required double width,
    required Alignment alignment,
    bool highlight = false,
  }) {
    return Container(
      width: width,
      height: rowHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: alignment,
      color: highlight ? Colors.orange.withOpacity(0.08) : Colors.white,
      child: child,
    );
  }
}*/
