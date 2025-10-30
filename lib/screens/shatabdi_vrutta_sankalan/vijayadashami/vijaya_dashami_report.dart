import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niyojak_prod/widgets/single_column_row.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/get_vijayadashmi_report_resp_model.dart';
import '../../../providers/bals.dart';
import '../../../utils/cust_painters.dart';

class VijayadashamiFormReport extends StatefulWidget {
  static const String routeName = '/vijayadashami-form-report';

  const VijayadashamiFormReport({super.key});

  @override
  State<VijayadashamiFormReport> createState() => _VijayadashamiFormReportState();
}

// /// Layout helpers
// class _Section {
//   final String jsonKey;
//   final String title;
//   final List<_Subcol> columns;
//
//   _Section({required this.jsonKey, required this.title, required this.columns});
// }
//
// class _Subcol {
//   final String header;
//   final String dataKey;
//
//   _Subcol({required this.header, required this.dataKey});
// }

/// Front-end supplied layout
class SectionSpec {
  final String title; // Main header text (section name)
  final List<SubcolSpec> columns; // Subheaders under the section
  SectionSpec({required this.title, required this.columns});
}

class SubcolSpec {
  final String header; // Display header in row 2
  final String dataKey; // Key in the API row object
  SubcolSpec({required this.header, required this.dataKey});
}

class _VijayadashamiFormReportState extends State<VijayadashamiFormReport> {
  late ScrollController _scrollController;

  GetVijayadashamiReportModel? vijayadashamiReport;

  final List<bool> _expanded = List.generate(3, (_) => true);

  bool _isLoading = false;
  bool _isSearching = false;
  bool _isExpanded = true;

  // bool isVastiSearch = false;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedBhaag;
  List<GeoUnitMasterBAL>? _linkedShahar;
  List<GeoUnitMasterBAL>? _linkedNagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<StaticMasterBAL>? _baithakTypes;
  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedBhaagValue = '';
  String? _linkedShaharValue = '';
  String? _linkedNagarValue = '';
  String? _linkedgraamValue = "";
  String? _linkedmandalValue = "";
  String? _linkedvastiValue = "";
  String? _baithakTypeValue = '';
  String? _baithakTypeYear = '';
  int? _baithakType;
  String _selectedNagarAndBaithak = '';
  String? mahanagarId = '';
  String? vibhagId = '';

  @override
  void initState() {
    super.initState();
    populateDropdown();
  }

  // Future<void> exportToExcel() async {
  //   var excel = Excel.createExcel();
  //   final sheet = excel['Sheet1'];
  //   sheet.appendRow(['Index', 'Title', 'Mahanagar', 'Vibhag', 'Bhaag', 'Nagar', 'Vasti', 'Gram', 'Mandal']);
  //
  //   int rowIndex = 1;
  //   for (var entry in groupedData.entries) {
  //     final items = entry.value;
  //     for (var item in items) {
  //       final row = [
  //         rowIndex++,
  //         item.title ?? '-',
  //         item.mahanagar ?? '-',
  //         item.vibhag ?? '-',
  //         item.bhaag ?? '-',
  //         item.nagar ?? '-',
  //         item.vasti ?? '-',
  //         item.gram ?? '-',
  //         item.mandal ?? '-',
  //       ];
  //       // print("Adding Row: $row");
  //       sheet.appendRow(row);
  //     }
  //   }
  //
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final path = '${directory.path}/VijayadashamiReport.xlsx';
  //     final file = File(path)
  //       ..createSync(recursive: true)
  //       ..writeAsBytesSync(excel.encode()!);
  //
  //     await OpenFilex.open(path);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Excel file saved and opened successfully: $path')),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to export file: $e')),
  //     );
  //   }
  // }

  /// Create Excel with grouped headers (from SectionSpec), add Total row at the end,
  /// then convert to PDF and save/download both.
  /// - [rows] is the API data list (maps) WITHOUT header info
  /// - [layout] is provided by the front end (sections + subheaders mapping)
  /// - [nameKey] is the key for the "Name" column (e.g., 'nagarupnagarName')
  // void buildExcelAndPdfFromData({required List<Map<String, dynamic>> rows, required List<SectionSpec> layout,
  //     // required String nameKey,
  //     // String excelFileName = 'report.xlsx',
  //     // String pdfFileName = 'report.pdf',
  //     // bool openAfterSave = false,}) async {
  //   if (rows.isEmpty) {
  //     throw ArgumentError('No data rows provided.');
  //   }
  //
  //   // 1) Workbook + sheet
  //   final xls.Workbook wb = xls.Workbook();
  //   final xls.Worksheet sheet = wb.worksheets[0];
  //   sheet.name = 'Report';
  //
  //   // 2) Styles
  //   final headerStyle = wb.styles.add('Header')
  //     ..bold = true
  //     ..hAlign = xls.HAlignType.center
  //     ..vAlign = xls.VAlignType.center
  //     ..borders.all.lineStyle = xls.LineStyle.thin;
  //
  //   final groupHeaderStyle = wb.styles.add('GroupHeader')
  //     ..bold = true
  //     ..hAlign = xls.HAlignType.center
  //     ..vAlign = xls.VAlignType.center
  //     ..borders.left.lineStyle = xls.LineStyle.medium
  //     ..borders.right.lineStyle = xls.LineStyle.medium
  //     ..borders.top.lineStyle = xls.LineStyle.medium
  //     ..borders.bottom.lineStyle = xls.LineStyle.thin
  //     ..backColor = '#D9D9D9';
  //
  //   final subHeaderStyle = wb.styles.add('SubHeader')
  //     ..bold = true
  //     ..hAlign = xls.HAlignType.center
  //     ..vAlign = xls.VAlignType.center
  //     ..borders.left.lineStyle = xls.LineStyle.thin
  //     ..borders.right.lineStyle = xls.LineStyle.thin
  //     ..borders.top.lineStyle = xls.LineStyle.thin
  //     ..borders.bottom.lineStyle = xls.LineStyle.medium;
  //
  //   final cellStyle = wb.styles.add('Cell')..borders.all.lineStyle = xls.LineStyle.thin;
  //
  //   final boldCellStyle = wb.styles.add('BoldCell')
  //     ..bold = true
  //     ..hAlign = xls.HAlignType.center
  //     ..vAlign = xls.VAlignType.center
  //     ..borders.all.lineStyle = xls.LineStyle.medium;
  //
  //   // 3) Header rows (two-row header)
  //   int col = 1; // XlsIO is 1-based
  //   // Sr No (merged across two rows)
  //   sheet.getRangeByIndex(1, col, 2, col).merge();
  //   sheet.getRangeByIndex(1, col).setText('Sr No');
  //   sheet.getRangeByIndex(1, col, 2, col).cellStyle = headerStyle;
  //   col++;
  //
  //   // Name column (merged across two rows)
  //   sheet.getRangeByIndex(1, col, 2, col).merge();
  //   sheet.getRangeByIndex(1, col).setText('Nagar/Upnagar');
  //   sheet.getRangeByIndex(1, col, 2, col).cellStyle = headerStyle;
  //   col++;
  //
  //   // Track section ranges for border styling & totals
  //   final List<Map<String, int>> sectionRanges = [];
  //
  //   for (final section in layout) {
  //     final startCol = col;
  //     // Subheaders in row 2
  //     for (final sub in section.columns) {
  //       sheet.getRangeByIndex(2, col).setText(sub.header);
  //       sheet.getRangeByIndex(2, col).cellStyle = subHeaderStyle;
  //       col++;
  //     }
  //     final endCol = col - 1;
  //
  //     if (endCol >= startCol) {
  //       // Merge and place main header in row 1
  //       sheet.getRangeByIndex(1, startCol, 1, endCol).merge();
  //       sheet.getRangeByIndex(1, startCol).setText(section.title);
  //       sheet.getRangeByIndex(1, startCol, 1, endCol).cellStyle = groupHeaderStyle;
  //
  //       // Make outer borders of the section bold on row 2 (subheaders)
  //       sheet.getRangeByIndex(2, startCol).cellStyle.borders.left.lineStyle = xls.LineStyle.medium;
  //       sheet.getRangeByIndex(2, endCol).cellStyle.borders.right.lineStyle = xls.LineStyle.medium;
  //       sheet.getRangeByIndex(2, startCol, 2, endCol).cellStyle.borders.bottom.lineStyle = xls.LineStyle.medium;
  //
  //       sectionRanges.add({'start': startCol, 'end': endCol});
  //     }
  //   }
  //
  //   // Freeze top two header rows
  //   // sheet.freezePanes(3, 1);
  //
  //   // 4) Data rows + collect totals
  //   int rowIndex = 3;
  //   int sr = 1;
  //   final int totalCols = col - 1;
  //   final List<double?> columnTotals = List<double?>.filled(totalCols + 1, null);
  //
  //   for (final item in rows) {
  //     int writeCol = 1;
  //
  //     // Sr No
  //     sheet.getRangeByIndex(rowIndex, writeCol).setNumber(sr.toDouble());
  //     sheet.getRangeByIndex(rowIndex, writeCol).cellStyle = cellStyle;
  //     writeCol++;
  //
  //     // Name
  //     sheet.getRangeByIndex(rowIndex, writeCol).setText((item[nameKey] ?? '').toString());
  //     sheet.getRangeByIndex(rowIndex, writeCol).cellStyle = cellStyle;
  //     writeCol++;
  //
  //     // Sections data (sum numeric columns only)
  //     for (final section in layout) {
  //       for (final sub in section.columns) {
  //         final dynamic v = item[sub.dataKey];
  //         final cell = sheet.getRangeByIndex(rowIndex, writeCol);
  //         if (v is num) {
  //           cell.setNumber(v.toDouble());
  //           columnTotals[writeCol] = (columnTotals[writeCol] ?? 0) + v.toDouble();
  //         } else if (v is String) {
  //           final parsed = double.tryParse(v);
  //           if (parsed != null) {
  //             cell.setNumber(parsed);
  //             columnTotals[writeCol] = (columnTotals[writeCol] ?? 0) + parsed;
  //           } else {
  //             cell.setText(v);
  //           }
  //         } else if (v == null) {
  //           cell.setText('');
  //         } else {
  //           cell.setText(v.toString());
  //         }
  //         cell.cellStyle = cellStyle;
  //         writeCol++;
  //       }
  //     }
  //
  //     sr++;
  //     rowIndex++;
  //   }
  //
  //   // 5) Total row (merge first two columns and write totals)
  //   final int totalRow = rowIndex;
  //   // Merge Sr No + Name columns
  //   sheet.getRangeByIndex(totalRow, 1, totalRow, 2).merge();
  //   final totalLabelRange = sheet.getRangeByIndex(totalRow, 1);
  //   totalLabelRange.setText('Total');
  //   sheet.getRangeByIndex(totalRow, 1, totalRow, 2).cellStyle = boldCellStyle;
  //
  //   // Totals for each numeric column (from col 3 onwards)
  //   for (int c = 3; c <= totalCols; c++) {
  //     final cell = sheet.getRangeByIndex(totalRow, c);
  //     final sum = columnTotals[c];
  //     if (sum != null) {
  //       cell.setNumber(sum);
  //     } else {
  //       cell.setText('');
  //     }
  //     cell.cellStyle = boldCellStyle;
  //
  //     // Bold outer borders at section boundaries
  //     final bool isStart = sectionRanges.any((r) => r['start'] == c);
  //     final bool isEnd = sectionRanges.any((r) => r['end'] == c);
  //     if (isStart) cell.cellStyle.borders.left.lineStyle = xls.LineStyle.medium;
  //     if (isEnd) cell.cellStyle.borders.right.lineStyle = xls.LineStyle.medium;
  //   }
  //
  //   // 6) Auto-fit columns
  //   for (int c = 1; c <= totalCols; c++) {
  //     sheet.autoFitColumn(c);
  //   }
  //
  //   // 7) Convert to PDF (Excel -> PDF)
  //   final converter = xls.ExcelToPdfConverter(wb);
  //   // Optional: fit to page width for readability
  //   converter.settings = xls.ExcelToPdfConverterSettings()
  //     ..fitSheetOnOnePage = false
  //     ..layoutOptions = xls.LayoutOptions.fitAllColumnsOnOnePage;
  //
  //   final PdfDocument pdfDoc = converter.convert();
  //   final List<int> pdfBytes = pdfDoc.saveSync();
  //   pdfDoc.dispose();
  //
  //   // 8) Save Excel
  //   final List<int> xlsxBytes = wb.saveAsStream();
  //   wb.dispose();
  //
  //   // await _saveBytesCrossPlatform(Uint8List.fromList(xlsxBytes), excelFileName, openAfterSave: openAfterSave);
  //   // await _saveBytesCrossPlatform(Uint8List.fromList(pdfBytes), pdfFileName, openAfterSave: openAfterSave);
  // }

//   void downloadExcel() async {
//     // setState(() {
//     //   _isLoading = true;
//     // });
//     showLoaderDialog(context);
//     final List<Map<String, int>> sectionRanges = [];
//
//     final List<dynamic> rows = (reportExcel['data'] as List?) ?? [];
//     if (rows.isEmpty) {
//       throw ArgumentError('No data found in apiJson["data"].');
//     }
//
//     const String nameKey = 'nagarupnagarName';
//     final first = rows.first as Map<String, dynamic>;
//
//     // ----- Build layout from first item (keeps JSON order)
//     final List<_Section> layout = [];
//     for (final entry in first.entries) {
//       final key = entry.key;
//       final value = entry.value;
//
//       if (key == nameKey) continue;
//       if (value is Map && value.containsKey('mainheader')) {
//         final String mainHeader = (value['mainheader'] ?? key).toString();
//         final List<_Subcol> subcols = [];
//         for (final subEntry in value.entries) {
//           final skey = subEntry.key;
//           if (skey == 'mainheader') continue;
//           if (skey.endsWith('header')) {
//             final display = subEntry.value?.toString() ?? skey;
//             final dataKey = skey.substring(0, skey.length - 'header'.length);
//             subcols.add(_Subcol(header: display, dataKey: dataKey));
//           }
//         }
//         layout.add(_Section(jsonKey: key, title: mainHeader, columns: subcols));
//       }
//     }
//
//     // ----- Create workbook + sheet
//     final excel = exc.Excel.createExcel(); // has default 'Sheet1'
//     // Use a named sheet
//     const sheetName = 'Report';
//     try {
//       if (!excel.sheets.containsKey(sheetName)) {
//         excel.rename('Report', sheetName);
//       }
//       final sheet = excel[sheetName];
//
// // Row/col are ZERO-based in `excel`
//       int col = 0;
//
// // ==== A) Sr No column (merged across 2 header rows)
//       _setText(sheet, row: 0, col: col, value: 'Sr No');
//       sheet.merge(
//         exc.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
//         exc.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 1),
//       );
// // Bold + centered style for "Sr No"
//       final srNoCell = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
//       srNoCell.cellStyle = exc.CellStyle(
//         bold: true,
//         horizontalAlign: exc.HorizontalAlign.Center,
//         verticalAlign: exc.VerticalAlign.Center,
//         leftBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//         rightBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//         // borderAround: BorderStyle.Thin,
//       );
//       final srNoCell1 = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 1));
//       srNoCell1.cellStyle = exc.CellStyle(
//         leftBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//         rightBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//         bottomBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//         // borderAround: BorderStyle.Thin,
//       );
//       col++;
//
// // ==== B) Nagar/Upnagar column
//       _setText(sheet, row: 0, col: col, value: 'Nagar/Upnagar');
//       sheet.merge(
//         exc.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
//         exc.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 1),
//       );
// // Bold + centered
//       final nagarUpNameCell = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
//       nagarUpNameCell.cellStyle = exc.CellStyle(
//         bold: true,
//         horizontalAlign: exc.HorizontalAlign.Center,
//         verticalAlign: exc.VerticalAlign.Center,
//         leftBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//         rightBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//         // borderAround: BorderStyle.Thin,
//       );
//       final nagarUpNameCell1 = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 1));
//       nagarUpNameCell1.cellStyle = exc.CellStyle(
//         leftBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//         rightBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//         bottomBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//         // borderAround: BorderStyle.Thin,
//       );
//       col++;
//
//       // C) Sections
//       for (final section in layout) {
//         final startCol = col;
//         final subCount = section.columns.length;
//         if (subCount == 0) continue;
//         final endCol = startCol + subCount - 1;
//
//         // Subheaders (row 1)
//         for (final sub in section.columns) {
//           // final sub = section.columns[i];
//           // final currentCol = startCol + i;
//           // final bool isLeftEdge = currentCol == startCol;
//           // final bool isRightEdge = currentCol == endCol;
//
//           _setText(sheet, row: 1, col: col, value: sub.header);
//           final subHeaderNameCell = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 1));
//           subHeaderNameCell.cellStyle = exc.CellStyle(
//             bold: true,
//             horizontalAlign: exc.HorizontalAlign.Center,
//             verticalAlign: exc.VerticalAlign.Center,
//             // textWrapping: exc.TextWrapping.Clip,
//             leftBorder: exc.Border(borderStyle: exc.BorderStyle.MediumDashed),
//             rightBorder: exc.Border(borderStyle: exc.BorderStyle.MediumDashed),
//             bottomBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//             topBorder: exc.Border(borderStyle: exc.BorderStyle.MediumDashed),
//             // borderAround: BorderStyle.Thin,
//           );
//
// // After merging and styling the main header:
//           sectionRanges.add({'start': startCol, 'end': endCol});
//
// // Move pointer
//           col++;
//         }
//
//         // Group header (row 0), merged across all its subcolumns
//         sheet.merge(
//           exc.CellIndex.indexByColumnRow(columnIndex: startCol, rowIndex: 0),
//           exc.CellIndex.indexByColumnRow(columnIndex: startCol + subCount - 1, rowIndex: 0),
//         );
//         _setText(sheet, row: 0, col: startCol, value: section.title);
//         final mainHeaderNameCell = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: startCol, rowIndex: 0));
//         mainHeaderNameCell.cellStyle = exc.CellStyle(
//           bold: true,
//           horizontalAlign: exc.HorizontalAlign.Center,
//           verticalAlign: exc.VerticalAlign.Center,
//           // textWrapping: exc.TextWrapping.Clip,
//           leftBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//           rightBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//           bottomBorder: exc.Border(borderStyle: exc.BorderStyle.MediumDashed),
//           // borderAround: BorderStyle.Thin,
//         );
//       }
//
// // === D) Adjust column widths based on header/subheader text length
//       for (int i = 0; i < col; i++) {
//         // Get header and subheader text (from row 0 and 1)
//         final String? mainHeader = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value?.toString();
//         final String? subHeader = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 1)).value?.toString();
//
//         // Pick whichever text is longer
//         final int headerLength = (mainHeader?.length ?? 0);
//         final int subLength = (subHeader?.length ?? 0);
//         final int maxLen = [headerLength, subLength].reduce((a, b) => a > b ? a : b);
//
//         // Excel width units are not the same as characters; multiply by a constant factor
//         double estimatedWidth = maxLen * 1.2;
//
//         // Apply a minimum width to avoid squished small columns
//         if (estimatedWidth < 12) estimatedWidth = 12;
//
//         sheet.setColWidth(i, estimatedWidth);
//       }
//
//       final int totalCols = col; // total number of columns after headers are built
//       final List<double?> columnTotals = List<double?>.filled(totalCols, null);
//
//       // ----- Write data rows starting at row 2
//       int outRow = 2;
//       int srNo = 1;
//
//       for (final item in rows.cast<Map<String, dynamic>>()) {
//         int writeCol = 0;
//
//         // Sr No
//         _setAny(sheet, row: outRow, col: writeCol, value: srNo);
//         final srNoValueCell = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: writeCol, rowIndex: outRow));
//         srNoValueCell.cellStyle = exc.CellStyle(
//           // bold: true,
//           horizontalAlign: exc.HorizontalAlign.Center,
//           verticalAlign: exc.VerticalAlign.Center,
//           // textWrapping: exc.TextWrapping.Clip,
//           leftBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//           rightBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//           // topBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//           // borderAround: BorderStyle.Thin,
//         );
//         writeCol++;
//
//         // Nagar/Upnagar
//         _setAny(sheet, row: outRow, col: writeCol, value: item[nameKey]);
//         final nagarValueCell = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: writeCol, rowIndex: outRow));
//         nagarValueCell.cellStyle = exc.CellStyle(
//           // bold: true,
//           horizontalAlign: exc.HorizontalAlign.Center,
//           verticalAlign: exc.VerticalAlign.Center,
//           // textWrapping: exc.TextWrapping.Clip,
//           leftBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//           rightBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//           // topBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//           // borderAround: BorderStyle.Thin,
//         );
//         writeCol++;
//
//         // Sections data
//         for (final section in layout) {
//           final secMap = (item[section.jsonKey] as Map?) ?? const {};
//           final subCount = section.columns.length;
//           if (subCount == 0) continue;
//           final endCol = writeCol + subCount - 1;
//           for (int i = 0; i < section.columns.length; i++) {
//             final sub = section.columns[i];
//             final currentCol = writeCol + i;
//             final dynamic v = secMap[sub.dataKey];
//             final bool isLeftEdge = currentCol == writeCol;
//             final bool isRightEdge = currentCol == endCol;
//             _setAny(sheet, row: outRow, col: writeCol, value: secMap[sub.dataKey]);
//             final subValueCell = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: writeCol, rowIndex: outRow));
//             subValueCell.cellStyle = exc.CellStyle(
//               // bold: true,
//               horizontalAlign: exc.HorizontalAlign.Center,
//               verticalAlign: exc.VerticalAlign.Center,
//               // textWrapping: exc.TextWrapping.Clip,
//               leftBorder: exc.Border(borderStyle: isLeftEdge ? exc.BorderStyle.Thick : exc.BorderStyle.MediumDashed),
//               rightBorder: exc.Border(borderStyle: isRightEdge ? exc.BorderStyle.Thick : exc.BorderStyle.MediumDashed),
//               // borderAround: BorderStyle.Thin,
//             );
//
//             // accumulate totals if numeric
//             double? numVal;
//             if (v is num) {
//               numVal = v.toDouble();
//             } else if (v is String) {
//               numVal = double.tryParse(v);
//             }
//             if (numVal != null) {
//               columnTotals[writeCol] = (columnTotals[writeCol] ?? 0) + numVal;
//             }
//
//             writeCol++;
//           }
//         }
//
//         srNo++;
//         outRow++;
//       }
//
//       final int totalRow = outRow;
//
// // Merge first two columns (Sr No + Nagar/Upnagar) and write "Total"
//       sheet.merge(
//         exc.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: totalRow),
//         exc.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: totalRow),
//       );
//       _setText(sheet, row: totalRow, col: 0, value: 'Total');
//
// // Style merged "Total" cell (apply to both cells for safety)
//       final totalLeft = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: totalRow));
//       final totalRight = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: totalRow));
//       final totalLabelStyle = exc.CellStyle(
//         bold: true,
//         horizontalAlign: exc.HorizontalAlign.Center,
//         verticalAlign: exc.VerticalAlign.Center,
//         topBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//         bottomBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//         leftBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//         rightBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//       );
//       totalLeft.cellStyle = totalLabelStyle;
//       totalRight.cellStyle = totalLabelStyle;
//
// // Write totals for each subsequent column and style borders
//       for (int c = 2; c < totalCols; c++) {
//         final cell = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: c, rowIndex: totalRow));
//         final sum = columnTotals[c];
//
//         if (sum != null) {
//           cell.value = sum; // numeric
//         } else {
//           cell.value = ''; // keep empty if no numbers encountered in that column
//         }
//
//         // Determine whether this column is at a section boundary
//         bool isStart = false;
//         bool isEnd = false;
//         for (final rng in sectionRanges) {
//           if (c == rng['start']) isStart = true;
//           if (c == rng['end']) isEnd = true;
//         }
//
//         cell.cellStyle = exc.CellStyle(
//           bold: true,
//           horizontalAlign: exc.HorizontalAlign.Center,
//           verticalAlign: exc.VerticalAlign.Center,
//           topBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//           bottomBorder: exc.Border(borderStyle: exc.BorderStyle.Thick),
//           leftBorder: exc.Border(borderStyle: isStart ? exc.BorderStyle.Thick : exc.BorderStyle.MediumDashed),
//           rightBorder: exc.Border(borderStyle: isEnd ? exc.BorderStyle.Thick : exc.BorderStyle.MediumDashed),
//         );
//       }
//     } catch (e) {
//       log("printing the exception >>>>>>>>>>>>>>>> $e");
//       // setState(() {
//       //   _isLoading = false;
//       // });
//       Navigator.of(context, rootNavigator: true).pop();
//     }
//
//     // NOTE: The `excel` package has limited styling; auto-fit/freeze panes aren’t supported.
//
//     // ----- Save/Download
//
//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final path = '${directory.path}/VijayadashamiReport14.xlsx';
//       final file = File(path)
//         ..createSync(recursive: true)
//         ..writeAsBytesSync(excel.encode()!);
//
//       print(path);
//
//       await OpenFilex.open(path);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Excel file saved and opened successfully: $path')),
//       );
//     } catch (e) {
//       // setState(() {
//       //   _isLoading = false;
//       // });
//       Navigator.of(context, rootNavigator: true).pop();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to export file: $e')),
//       );
//     }
//
//     // setState(() {
//     //   _isLoading = false;
//     // });
//     Navigator.of(context, rootNavigator: true).pop();
//   }

  // void _setText(exc.Sheet sheet, {required int row, required int col, required String value}) {
  //   final cell = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row));
  //   cell.value = value; // `excel` will store as string
  // }
  //
  // void _setAny(exc.Sheet sheet, {required int row, required int col, required dynamic value}) {
  //   final cell = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row));
  //   if (value == null) {
  //     cell.value = '';
  //   } else if (value is num) {
  //     cell.value = value; // numbers are fine
  //   } else {
  //     cell.value = value.toString();
  //   }
  // }

  void populateDropdown() async {
    _scrollController = ScrollController();
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    populatelinkedMahaanagarDropdown();
    populatelinkedVibhaagDropdown('');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
    print("_baithakTypes :-- $_baithakTypes");
    setState(() {});
  }

  getReportDataFun() async {
    setState(() {
      vijayadashamiReport = null;
      _isLoading = true;
    });
    Map<String, dynamic> formData = {
      "GeoUnitID": int.tryParse(selctedLevelId.toString()) ?? null,
      "AppUserID": int.tryParse(Statics.userDetails['userID']) ?? null,
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    vijayadashamiReport = await Statics.getVijayaDashamiUtsavReportData(context, formData);
    // log("vijayadashamiReport >>>>>>>>>>>>>>>>> ${jsonDecode(jsonEncode(vijayadashamiReport))}");
    setState(() {
      _isLoading = false;
      vijayadashamiReport;
    });
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedShaharValue = _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedShaharValue = _linkedShahar = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _linkedShahar = (shDD.length > 0 ? shDD : null);
    });
    return shDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkedNagarValue = null;
    _linkedNagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(String nagarIDStr) async {
    _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
    return vsDD;
  }

  String? selctedLevel = 'praant';
  String? selctedLevelName = '';
  String? selctedLevelId = '';
  String? selctedSanchalanLevelId = '';
  String? selctedSanchalanLevelName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Statics.getLabel('VijayadashmiReport'),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // actions: [IconButton(onPressed: buildExcelAndPdfFromData, icon: Icon(Icons.download))],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _isExpanded = isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    isExpanded: _isExpanded,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          Statics.getLabel('selectStar'),
                          style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                    body: Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          if (_linkedMahaanagar != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                              isExpanded: true,
                              value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                              items: _linkedMahaanagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                print(value);
                                setState(() {
                                  _linkedMahaanagarValue = value;
                                  _linkedVibhaagValue = null;
                                  _linkedBhaagValue = null;
                                  _linkedShaharValue = null;
                                  _linkedNagarValue = null;
                                  populatelinkedVibhaagDropdown(value!);
                                  mahanagarId = value;
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Mahanagar';
                                  selctedLevelId = value;
                                });
                              },
                            ),
                          SizedBox(height: 10),
                          if (_linkedVibhaag != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                              isExpanded: true,
                              value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                              items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                print(value);
                                setState(() {
                                  _linkedVibhaagValue = value;
                                  populatelinkedBhaagDropdown(value!);
                                  vibhagId = value;
                                  _linkedBhaagValue = _linkedNagarValue = null;
                                  _linkedBhaag = _linkedNagar = null;
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Vibhaag';
                                  selctedLevelId = value;
                                });
                              },
                            ),
                          SizedBox(height: 10),
                          if (_linkedBhaag != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                              isExpanded: true,
                              value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
                              items: _linkedBhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                setState(() {
                                  _linkedBhaagValue = value;
                                  // populatelinkedShaharDropdown(value!);
                                  populatelinkedNagarDropdown(value, null);
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Bhaag';
                                  selctedLevelId = value;
                                });
                              },
                            ),
                          if (_linkedNagar != null && _linkedNagar!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                              isExpanded: true,
                              value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                              items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                populatelinkedMandalDropdown(value!);
                                populatelinkedVastiDropdown(value);
                                setState(() {
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Nagar';
                                  selctedLevelId = value;

                                  _linkedNagarValue = value;
                                });
                              },
                            ),
                          if (_linkedNagar != null && _linkedNagar!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          if (_linkedmandal != null && _linkedmandal!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Mandal')),
                              isExpanded: true,
                              value: _linkedmandalValue == "" ? null : _linkedmandalValue,
                              items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                setState(() {
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Mandal';
                                  selctedLevelId = value;

                                  _linkedmandalValue = value;
                                  populatelinkedGraamDropdown(value!);
                                });
                              },
                            ),
                          SizedBox(
                            height: 15,
                          ),
                          // if (selctedLevelId != '')
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                              onPressed: () async {
                                await getReportDataFun();
                                setState(() {
                                  _isExpanded = false;
                                  // isVastiSearch = true;
                                });
                              },
                              child: Text("${Statics.getLabel('Filters')}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          if (selctedLevelId != '' || vijayadashamiReport != null)
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                child: Text(Statics.getLabel('clear')),
                                onPressed: () {
                                  setState(() {
                                    // _isExpanded = false;

                                    // Reset dropdowns / linked values
                                    _linkedMahaanagarValue = null;
                                    _linkedVibhaagValue = null;
                                    _linkedBhaagValue = null;
                                    _linkedShaharValue = null;
                                    _linkedNagarValue = null;
                                    _linkedmandalValue = null;
                                    _linkedgraamValue = null;
                                    _linkedvastiValue = null;

                                    // Reset data lists
                                    _linkedBhaag = null;
                                    _linkedShahar = null;
                                    _linkedNagar = null;
                                    _linkedmandal = null;
                                    _linkedgraam = null;
                                    _linkedvasti = null;

                                    // Reset level tracking
                                    selctedLevel = '';
                                    selctedLevelName = '';
                                    selctedLevelId = null;

                                    vijayadashamiReport = null;
                                    populatelinkedVibhaagDropdown('');
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              if (selctedLevel != "" && selctedLevelName != "")
                Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purpleAccent, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${Statics.getLabel(selctedLevel ?? "Mahaanagar")}  ->  ",
                          style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          " $selctedLevelName",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ],
                    )),
              SizedBox(height: 10),
              Divider(color: Colors.black),
              SizedBox(height: 10),
              if (_isLoading) SizedBox(height: MediaQuery.sizeOf(context).height * 0.2, child: Center(child: CircularProgressIndicator())),
              if (vijayadashamiReport?.vijayadashaminagarlist != null && vijayadashamiReport?.vijayadashaminagarlist != []) buildMarathiDataTable(vijayadashamiReport!.vijayadashaminagarlist!),
              SizedBox(height: 18),
              if (vijayadashamiReport?.vijayadashamiReport != null) buildCountCards(vijayadashamiReport!.vijayadashamiReport!),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCountCards(VijayadashamiReport data) {
    int calculateTotalMale() {
      final total = (data.mukhyaatithimale ?? 0) + (data.sadbavkaryamale ?? 0) + (data.sajjanskhatiuppasstitimale ?? 0) + (data.pramukhjhanuppasstitimale ?? 0) + (data.anyauppasstitimale ?? 0);
      return total;
    }

    int calculateTotalFemale() {
      final total =
          (data.mukhyaatithifemale ?? 0) + (data.sadbavkaryafemale ?? 0) + (data.sajjanskhatiuppasstitifemale ?? 0) + (data.pramukhjhanuppasstitifemale ?? 0) + (data.anyanuppasstitifemale ?? 0);
      return total;
    }

    return Column(
      children: [
        ExpansionPanelList(
          expansionCallback: (index, isExpanded) {
            setState(() {
              _expanded[index] = !_expanded[index];
            });
          },
          children: [
            _buildPanel(
              Statics.getLabel("searchSwayamsevakScreenLabel"),
              0,
              Column(
                children: [
                  SingleColumnRow(
                    txtString: Statics.getLabel('present'),
                    fontWeight: FontWeight.w700,
                    value: "",
                    fontsize: 16,
                    rowColor: Colors.purple.shade50,
                    subChild: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('totalPat'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.ekunpat ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        // SizedBox(width: MediaQuery
                        //     .sizeOf(context)
                        //     .width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        // SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('presentGanveshatTotal'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.ekungan ?? 0).toString()),
                          ),
                        ]),
                        // SizedBox(height: 8),
                        // Row(children: [
                        //   Expanded(child: Text(Statics.getLabel('presentSanchalanatTotal'))),
                        //   Container(
                        //     margin: EdgeInsets.only(left: 8),
                        //     child: Text((data.ekunsanchalan ?? 0).toString()),
                        //   ),
                        // ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('anyaUpasthit') + " " + Statics.getLabel('searchSwayamsevakScreenLabel'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.ekunupastiti ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('presentTotal') + " " + Statics.getLabel('searchSwayamsevakScreenLabel'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(((data.ekungan ?? 0) + (data.ekunupastiti ?? 0)).toString()),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  SingleColumnRow(
                    txtString: Statics.getLabel('shakhaMilanPratinidhitwaReport'),
                    fontWeight: FontWeight.w700,
                    value: "",
                    fontsize: 16,
                    rowColor: Colors.purple.shade50,
                    subChild: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('vartamaan') + " " + Statics.getLabel('shakhaMilanPratinidhitwa'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.vartamansaakhapratinidhatva ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('vartamaan') + " " + Statics.getLabel('MilanPratinidhitwa'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.vartamansapthahikpratinidhatva ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('vartamaan') + " " + Statics.getLabel('MaasikMilanPratinidhitwa'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.vartamansanghmandalipratinidhatva ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Total') + " " + Statics.getLabel('pratinidhitva'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(((data.vartamansaakhapratinidhatva ?? 0) + (data.vartamansapthahikpratinidhatva ?? 0) + (data.vartamansanghmandalipratinidhatva ?? 0)).toString()),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  SingleColumnRow(
                    txtString: Statics.getLabel('bhougolikPratinidhitwa'),
                    fontWeight: FontWeight.w700,
                    value: "",
                    fontsize: 16,
                    rowColor: Colors.purple.shade50,
                    subChild: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('vastiPratinidhitwa'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.vasticountpratinidhatva ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('mandalPratinidhitwa'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.mandalcountpratinidhatva ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('gramPratinidhitwa'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.gramcountpratinidhatva ?? 0).toString()),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  // SingleColumnRow(
                  //   txtString: "एकूण पट",
                  //   value: data.ekunpat,
                  // ),
                  // SingleColumnRow(
                  //   txtString: "गणवेशात उपस्थित",
                  //   value: data.ekungan,
                  // ),
                  // SingleColumnRow(txtString: "संचलनात उपस्थित", value: data.ekunsanchalan),
                  // SingleColumnRow(txtString: "अन्य उपस्थित", value: data.ekunupastiti),
                  // SingleColumnRow(txtString: "वर्तमान शाखा प्रतिनिधित्व", value: data.vartamansaakhapratinidhatva),
                  // SingleColumnRow(txtString: "वर्तमान साप्ताहिक मिलन प्रतिनिधित्व", value: data.vartamansapthahikpratinidhatva),
                  // SingleColumnRow(txtString: "वर्तमान मासिक मिलन प्रतिनिधित्व", value: data.vartamansanghmandalipratinidhatva),
                  // // SingleColumnRow(txtString: "वर्तमान संघ मंडली प्रतिनिधित्व", value: data.),
                  // // SingleColumnRow(txtString: "नवीन संकल्पित शाखा प्रतिनिधित्व", value: "5"),
                  // // SingleColumnRow(txtString: "नवीन संकल्पित साप्ताहिक मिलन प्रतिनिधित्व", value: "3"),
                  // // SingleColumnRow(txtString: "नवीन संकल्पित संघ मंडली प्रतिनिधित्व", value: "2"),
                  // SingleColumnRow(txtString: "वस्ती प्रतिनिधित्व", value: data.vasticountpratinidhatva),
                  // SingleColumnRow(txtString: "मंडल प्रतिनिधित्व", value: data.mandalcountpratinidhatva),
                  // SingleColumnRow(txtString: "ग्राम प्रतिनिधित्व", value: data.gramcountpratinidhatva),
                ],
              ),
            ),
            _buildPanel(
              Statics.getLabel("samajScreenLabel"),
              1,
              Column(
                children: [
                  SingleColumnRow(
                    txtString: Statics.getLabel('mukhyaAtithi'),
                    value: "",
                    fontsize: 16,
                    fontWeight: FontWeight.w600,
                    rowColor: Colors.purple.shade50,
                    subChild: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Male'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.mukhyaatithimale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Female'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.mukhyaatithifemale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Total'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(((data.mukhyaatithimale ?? 0) + (data.mukhyaatithifemale ?? 0)).toString()),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  SingleColumnRow(
                    txtString: Statics.getLabel('sadhbhavKarya'),
                    value: "",
                    fontsize: 16,
                    fontWeight: FontWeight.w600,
                    rowColor: Colors.purple.shade50,
                    subChild: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Male'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.sadbavkaryamale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Female'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.sadbavkaryafemale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Total'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(((data.sadbavkaryamale ?? 0) + (data.sadbavkaryafemale ?? 0)).toString()),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  SingleColumnRow(
                    txtString: Statics.getLabel("SajjanShakti"),
                    value: "",
                    fontsize: 16,
                    fontWeight: FontWeight.w600,
                    rowColor: Colors.purple.shade50,
                    subChild: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Male'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.sajjanskhatiuppasstitimale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Female'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.sajjanskhatiuppasstitifemale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Total'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(((data.sajjanskhatiuppasstitimale ?? 0) + (data.sajjanskhatiuppasstitifemale ?? 0)).toString()),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  // SingleColumnRow(
                  //   txtString: "पुरुष",
                  //   value: "22",
                  // ),
                  // SingleColumnRow(
                  //   txtString: "महिला",
                  //   value: "11",
                  // ),
                  // SingleColumnRow(
                  //   txtString: "एकूण",
                  //   value: "33",
                  // ),
                  SingleColumnRow(
                    txtString: Statics.getLabel("PramukhJan"),
                    value: "",
                    fontsize: 16,
                    fontWeight: FontWeight.w600,
                    rowColor: Colors.purple.shade50,
                    subChild: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Male'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.pramukhjhanuppasstitimale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Female'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.pramukhjhanuppasstitifemale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Total'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(((data.pramukhjhanuppasstitimale ?? 0) + (data.pramukhjhanuppasstitifemale ?? 0)).toString()),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  SingleColumnRow(
                    txtString: Statics.getLabel("anyaUpasthit"),
                    value: "",
                    fontsize: 16,
                    fontWeight: FontWeight.w600,
                    rowColor: Colors.purple.shade50,
                    subChild: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Male'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.anyauppasstitimale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Female'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.anyanuppasstitifemale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Total'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(((data.anyauppasstitimale ?? 0) + (data.anyanuppasstitifemale ?? 0)).toString()),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  SingleColumnRow(
                    txtString: Statics.getLabel("presentTotal"),
                    value: "",
                    fontsize: 16,
                    fontWeight: FontWeight.w600,
                    rowColor: Colors.purple.shade50,
                    subChild: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Male'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(calculateTotalMale().toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Female'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(calculateTotalFemale().toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Total'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((calculateTotalMale() + calculateTotalFemale()).toString()),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // _buildPanel(
            //     Statics.getLabel("anyaUpstithSummary"),
            //     2,
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //       child: Column(
            //         children: [
            //           Row(children: [
            //             Expanded(child: Text(Statics.getLabel('Male'))),
            //             Container(
            //               margin: EdgeInsets.only(left: 8),
            //               child: Text((data.ekunmale ?? 0).toString()),
            //             ),
            //           ]),
            //           SizedBox(height: 8),
            //           Row(children: [
            //             Expanded(child: Text(Statics.getLabel('Female'))),
            //             Container(
            //               margin: EdgeInsets.only(left: 8),
            //               child: Text((data.ekunfemale ?? 0).toString()),
            //             ),
            //           ]),
            //           SizedBox(height: 6),
            //           SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
            //           SizedBox(height: 6),
            //           Row(children: [
            //             Expanded(child: Text(Statics.getLabel('presentTotalMaleFemale2'))),
            //             Container(
            //               margin: EdgeInsets.only(left: 8),
            //               child: Text((data.ekumalenfemale ?? 0).toString()),
            //             ),
            //           ]),
            //           SizedBox(height: 6),
            //           SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
            //           SizedBox(height: 6),
            //           //
            //           // SingleColumnRow(
            //           //   txtString: "${Statics.getLabel('presentTotalMaleFemale')} ",
            //           //   value: data.ekumalenfemale.toString(),
            //           // ),
            //           //
            //           Row(children: [
            //             Expanded(child: Text(Statics.getLabel('presentGanveshatTotal'))),
            //             Container(
            //               margin: EdgeInsets.only(left: 8),
            //               child: Text((data.ekunganvash ?? 0).toString()),
            //             ),
            //           ]),
            //           SizedBox(height: 8),
            //           // SingleColumnRow(
            //           //   txtString: "${Statics.getLabel('presentGanveshatTotal')} ",
            //           //   value: data.ekunganvash.toString(),
            //           // ),
            //           //
            //           Row(children: [
            //             Expanded(child: Text(Statics.getLabel('otherSwayamsewakPresentCount'))),
            //             Container(
            //               margin: EdgeInsets.only(left: 8),
            //               child: Text((data.ekunanya ?? 0).toString()),
            //             ),
            //           ]),
            //           SizedBox(height: 8),
            //           // SingleColumnRow(
            //           //   txtString: "${Statics.getLabel('otherSwayamsewakPresentCount')} ",
            //           //   value: data.ekunanya.toString(),
            //           // ),
            //           //
            //           // SingleColumnRow(
            //           //   txtString: "${Statics.getLabel('presentSamajik')} ",
            //           //   value: "${totalShakhaCount + totalMilanCount + totalSanghaMandaliCount}",
            //           // ),
            //           // ✅ Total
            //           SingleColumnRow(
            //             rowColor: Colors.grey.shade300,
            //             txtString: "${Statics.getLabel('presentAllTotal')} ",
            //             value: data.ekunupastitisummary.toString(),
            //           ),
            //           // const SizedBox(height: 10),
            //           // Text(
            //           //   "${Statics.getLabel('Total')} : $total",
            //           //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //           // ),
            //         ],
            //       ),
            //     ),
            //     tileColor: Colors.purple.shade50,),
          ],
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.only(top: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          surfaceTintColor: Colors.transparent,
          child: ExpansionTile(
              tilePadding: EdgeInsets.only(right: 16, left: 16),
              childrenPadding: EdgeInsets.zero,
              collapsedBackgroundColor: Colors.yellow.shade100,
              backgroundColor: Colors.yellow.shade100,
              initiallyExpanded: true,
              shape: RoundedRectangleBorder(side: BorderSide.none),
              title: Text(
                Statics.getLabel("anyaUpstithSummary"),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent.shade700,
                ),
              ),
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 8.0, top: 12),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade800)),
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Male'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.ekunmale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Female'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.ekunfemale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('presentTotalMaleFemale2'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.ekumalenfemale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        //
                        // SingleColumnRow(
                        //   txtString: "${Statics.getLabel('presentTotalMaleFemale')} ",
                        //   value: data.ekumalenfemale.toString(),
                        // ),
                        //
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('presentGanveshatTotal'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.ekunganvash ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        // SingleColumnRow(
                        //   txtString: "${Statics.getLabel('presentGanveshatTotal')} ",
                        //   value: data.ekunganvash.toString(),
                        // ),
                        //
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('otherSwayamsewakPresentCount'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.ekunanya ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        // SingleColumnRow(
                        //   txtString: "${Statics.getLabel('otherSwayamsewakPresentCount')} ",
                        //   value: data.ekunanya.toString(),
                        // ),
                        //
                        // SingleColumnRow(
                        //   txtString: "${Statics.getLabel('presentSamajik')} ",
                        //   value: "${totalShakhaCount + totalMilanCount + totalSanghaMandaliCount}",
                        // ),
                        // ✅ Total
                        SingleColumnRow(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          rowColor: Colors.purple.shade50,
                          txtString: "${Statics.getLabel('presentAllTotal')} ",
                          value: data.ekunupastitisummary.toString(),
                          fontWeight: FontWeight.bold,
                        ),
                        // const SizedBox(height: 10),
                        // Text(
                        //   "${Statics.getLabel('Total')} : $total",
                        //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        // ),
                      ],
                    ),
                  ),
                ),
              ]),
        )
      ],
    );
  }

  ExpansionPanel _buildPanel(String title, int index, Widget child, {Color? tileColor, Color? backgroundColor}) {
    return ExpansionPanel(
      backgroundColor: backgroundColor,
      isExpanded: _expanded[index],
      headerBuilder: (context, isExpanded) {
        return ListTile(
          tileColor: tileColor,
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purpleAccent,
            ),
          ),
        );
      },
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: child,
      ),
    );
  }

  Widget buildMarathiDataTable(List<Vijayadashaminagarlist> data) {
    final List<String> headers = [
      // 'कार्यक्रम स्तर',
      Statics.getLabel('vijayadashmiReportTable1'),
      Statics.getLabel('vijayadashmiReportTable3'),
      Statics.getLabel('vijayadashmiReportTable4'),
      Statics.getLabel('vijayadashmiReportTable6'),
      //sanchalan
      Statics.getLabel('vijayadashmiReportTable2'),
      Statics.getLabel('vijayadashmiReportTable5'),
      Statics.getLabel('vijayadashmiReportTable7'),
    ];

    // return Column(
    //   children: [
    //     Scrollbar(
    //       controller: _scrollController,
    //       thumbVisibility: true,
    //       interactive: true,
    //       thickness: 5,
    //       radius: Radius.circular(10),
    //       child: SingleChildScrollView(
    //         controller: _scrollController,
    //         scrollDirection: Axis.horizontal,
    //         child: DataTable(
    //           columnSpacing: 18,
    //           headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
    //           border: TableBorder(verticalInside: BorderSide(width: 0.7, color: Colors.grey.shade200)),
    //           columns: headers
    //               .map((header) => DataColumn(
    //                     label: Container(
    //                       // constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.2),
    //                       child: Text(header, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
    //                     ),
    //                   ))
    //               .toList(),
    //           rows: data.map((level) {
    //             return DataRow(cells: [
    //               DataCell(Text(level.levelname.toString())),
    //               DataCell(Center(child: Text(level.karykakramcount.toString()))),
    //               DataCell(Center(child: Text(level.shanchalancount.toString()))),
    //               DataCell(Center(child: Text(level.karyakramnirdharitvedhvarcount.toString()))),
    //               DataCell(Center(child: Text(level.vyaktigeetkhantastakcount.toString()))),
    //               DataCell(Center(child: Text(level.shanchalanghosvandancount.toString()))),
    //               DataCell(Center(child: Text(level.skaraykramhisob24tasapurnacount.toString()))),
    //             ]);
    //           }).toList(),
    //         ),
    //       ),
    //     ),
    //     SizedBox(height: 12),
    //     Divider(color: Colors.black),
    //     SizedBox(height: 12),
    //   ],
    // );
    return Row(
      children: [
        DataTable(
          headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
          columnSpacing: 0,
          horizontalMargin: 16,
          border: TableBorder.all(color: Colors.black26),
          columns: [
            DataColumn(
              label: Center(
                child: Text(
                  Statics.getLabel("vijayadashmiReportTable0"),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
          rows: data.map((level) {
                return DataRow(cells: [
                  DataCell(Text(level.levelname.toString())),
                ]);
              }).toList() +
              [
                DataRow(color: MaterialStatePropertyAll(Colors.yellow.shade100), cells: [
                  DataCell(Text(
                    Statics.getLabel("Total"),
                    style: TextStyle(fontWeight: FontWeight.w700),
                  )),
                ])
              ],
        ),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            interactive: true,
            thickness: 5,
            radius: Radius.circular(10),
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 14,
                horizontalMargin: 12,
                headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                border: TableBorder(verticalInside: BorderSide(width: 0.7, color: Colors.grey.shade200)),
                columns: headers
                    .map((header) => DataColumn(
                          label: Container(
                            constraints: BoxConstraints(minWidth: 40, maxWidth: 200),
                            // constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.2),
                            child: Text(header, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ))
                    .toList(),
                rows: data.map((level) {
                      return DataRow(cells: [
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.karykakramcount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.karykakramcount != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.karykakramcount != 0 ? 0 : 10), child: Text(level.karykakramcount.toString())),
                            if (level.karykakramcount != 0)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.karykakramcountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable1"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.karyakramnirdharitvedhvarcount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.karyakramnirdharitvedhvarcount != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.karyakramnirdharitvedhvarcount != 0 ? 0 : 10), child: Text(level.karyakramnirdharitvedhvarcount.toString())),
                            if (level.karyakramnirdharitvedhvarcount != 0)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.karyakramnirdharitvedhvarcountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable3"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.vyaktigeetkhantastakcount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.vyaktigeetkhantastakcount != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.vyaktigeetkhantastakcount != 0 ? 0 : 10), child: Text(level.vyaktigeetkhantastakcount.toString())),
                            if (level.vyaktigeetkhantastakcount != 0)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.vyaktigeetkhantastakcountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable4"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.skaraykramhisob24tasapurnacount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.skaraykramhisob24tasapurnacount != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.skaraykramhisob24tasapurnacount != 0 ? 0 : 10), child: Text(level.skaraykramhisob24tasapurnacount.toString())),
                            if (level.skaraykramhisob24tasapurnacount != 0)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.skaraykramhisob24tasapurnacountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable6"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),

                        //sanchalan
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.shanchalancount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.shanchalancount != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.shanchalancount != 0 ? 0 : 10), child: Text(level.shanchalancount.toString())),
                            if (level.shanchalancount != 0)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.shanchalancountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable2"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.shanchalanghosvandancount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.shanchalanghosvandancount != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.shanchalanghosvandancount != 0 ? 0 : 10), child: Text(level.shanchalanghosvandancount.toString())),
                            if (level.shanchalanghosvandancount != 0)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.shanchalanghosvandancountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable5"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.shanchalansadandacount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.shanchalansadandacount != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.shanchalansadandacount != 0 ? 0 : 10), child: Text(level.shanchalansadandacount.toString())),
                            if (level.shanchalansadandacount != 0)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.shanchalansadandacountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable7"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                      ]);
                    }).toList() +
                    [
                      DataRow(color: MaterialStatePropertyAll(Colors.yellow.shade100), cells: [
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.karykakramcount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.karyakramnirdharitvedhvarcount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.vyaktigeetkhantastakcount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.skaraykramhisob24tasapurnacount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),

                        //sanchalan
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.shanchalancount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.shanchalanghosvandancount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.shanchalansadandacount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                      ])
                    ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  showInfoDialogBox({required String names, required String title}) {
    final ScrollController _scrollController = ScrollController();
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, set) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 24),
              // contentPadding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.purple.shade400)),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    interactive: true,
                    thickness: 5,
                    radius: Radius.circular(10),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 14,
                        horizontalMargin: 12,
                        border: TableBorder.symmetric(inside: BorderSide(width: 0.4, color: Colors.grey.shade400)),
                        showCheckboxColumn: false,
                        headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                        headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        columns: [
                          DataColumn(
                              label: Container(
                            constraints: BoxConstraints(maxWidth: 40),
                            child: Text(" "),
                          )),
                          DataColumn(
                              label: Container(
                            constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width * 0.5),
                            child: Text(
                              "${Statics.getLabel('Name')}",
                            ),
                          )),
                        ],
                        rows: names.split(",").toList().asMap().entries.map((entry) {
                          int index = entry.key;
                          var data = entry.value;
                          return DataRow(cells: [
                            DataCell(Container(constraints: BoxConstraints(maxWidth: 40), child: Text((index + 1).toString()))),
                            DataCell(Text(data, maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true)),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  child: Text(Statics.getLabel("Submit")),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
}
