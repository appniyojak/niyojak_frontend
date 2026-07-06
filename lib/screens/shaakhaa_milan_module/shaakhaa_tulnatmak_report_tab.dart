import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../models/response_model/shaakhaa_milan_tulnatmak_model.dart';
import '../../providers/bals.dart';
import '../../utils/globals.dart';
import '../../utils/stable_geounit_class.dart';
import 'report_widgets/custom_app_dropdowns.dart';

// ─── Shared visual tokens ─────────────────────────────────────────────────────

final BoxDecoration _cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ],
);

// Dynamic color palette — used for both "years" (bar chart series) and
// "activities" (line chart series), since both lists are now data-driven
// and not a fixed length of 4-5 like the old mock.
const List<Color> _palette = [
  Color(0xFFF472B6),
  Color(0xFFFB923C),
  Color(0xFF60A5FA),
  Color(0xFF4ADE80),
  Color(0xFFA78BFA),
  Color(0xFFFBBF24),
  Color(0xFF34D399),
  Color(0xFFF87171),
  Color(0xFF38BDF8),
  Color(0xFF9CA3AF),
];

Color _colorAt(int index) => _palette[index % _palette.length];

class ActivitySeries {
  final String activity;
  final List<int> months; // sorted distinct months present, e.g. [1..12]
  final List<String> years; // sorted distinct years present, e.g. [2022,2023,2024]
  final Map<String, Map<int, int>> values; // year -> month -> SCount

  ActivitySeries({
    required this.activity,
    required this.months,
    required this.years,
    required this.values,
  });
}

List<ActivitySeries> buildActivitySeries(List<HGraph> hData) {
  final byActivity = <String, List<HGraph>>{};
  for (final h in hData) {
    byActivity.putIfAbsent(h.activity, () => []).add(h);
  }

  final activityNames = byActivity.keys.toList()..sort();
  return activityNames.map((act) {
    final rows = byActivity[act]!;
    final months = rows.map((r) => r.month).toSet().toList()..sort();
    final years = rows.map((r) => r.year).toSet().toList()..sort((a, b) => (int.tryParse(a) ?? 0).compareTo(int.tryParse(b) ?? 0));

    final values = <String, Map<int, int>>{};
    for (final r in rows) {
      values.putIfAbsent(r.year, () => {});
      values[r.year]![r.month] = r.sCount;
    }

    return ActivitySeries(activity: act, months: months, years: years, values: values);
  }).toList();
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

/// Generic legend row: list of (label, color) pairs. Used for both the
/// year-series legend (bar chart) and the activity-series legend (line
/// chart), since both sets are now data-driven rather than fixed.
class LegendRow extends StatelessWidget {
  final List<MapEntry<String, Color>> items;
  final bool isLine;

  const LegendRow({super.key, required this.items, this.isLine = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: isLine ? 0 : 10, bottom: isLine ? 10 : 12),
      child: Wrap(
        spacing: 10,
        runSpacing: 6,
        children: items.map((e) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isLine ? 14 : 10,
                height: isLine ? 2 : 10,
                decoration: BoxDecoration(
                  color: e.value,
                  borderRadius: BorderRadius.circular(isLine ? 1 : 2),
                ),
              ),
              const SizedBox(width: 4),
              Text(e.key, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─── Main Screen ──────────────────────────────────────────────────────────────

class ShaakhaaTulnatmakReportTab extends StatefulWidget {
  const ShaakhaaTulnatmakReportTab({super.key});

  @override
  State<ShaakhaaTulnatmakReportTab> createState() => _ShaakhaaTulnatmakReportTabState();
}

// ─── Sentinel for "Total" entry ───────────────────────────────────────────────
// A fixed staticID of -1 is used as a sentinel so we can reliably identify
// the synthetic "एकुण" item regardless of DB-returned data.
const int _kTotalStaticlID = 0;

StaticMasterBAL get _totalEntry => StaticMasterBAL(_kTotalStaticlID, 1, 'ShaakhaaVayogat', 'Total', Statics.getLabel('Total'), 0, 0, '', '');

class _ShaakhaaTulnatmakReportTabState extends State<ShaakhaaTulnatmakReportTab> with AutomaticKeepAliveClientMixin {
// This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  final controller = createGeoController();

  final GlobalKey _globalKey = GlobalKey();

  bool _isExcelDownloading = false;

  // Year selector range for the "प्रारंभ वर्ष / अंत वर्ष" dropdowns.
  static const int _startYear = 2023;
  static const int _maxSpan = 4; // inclusive span, e.g. 2022-2025

  late final List<int> allYears = List.generate(
    DateTime.now().year - _startYear + 1,
    (i) => _startYear + i,
  );

  String vayogat = "एकूण";
  late int toYear = allYears.last;
  late int fromYear = (toYear - (_maxSpan - 1)) < _startYear ? _startYear : toYear - (_maxSpan - 1);

  bool isLoading = false;
  String? errorMessage;
  TulnatmakResponse? response;

  // Vayogat dropdown — always starts with the synthetic "Total" entry.
  // After DB load, DB items are appended after it.
  List<StaticMasterBAL> _vayogatOptions = [_totalEntry];

  // Selected vayogat — defaults to the Total sentinel.
  StaticMasterBAL _selectedVayogat = _totalEntry;

  // ── Tapped bar tracking for _buildBarChart tooltip ────────────────────────────
  int _tappedGroupIndex = -1;
  int _tappedRodIndex = -1;

  static const double _barAreaHeight = 160.0;
  static const double _tooltipReservedH = 62.0;
  static const double _xLabelReservedH = 48.0;
  static const double _totalChartH = _tooltipReservedH + _barAreaHeight + _xLabelReservedH;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initData());
  }

  Future<void> _initData() async {
    final dm = await MyAppGlobals.getLevelLDB();
    await controller.initialize(dm);
    await _populateVayogatDropdown();
    await _fetchData();
    if (mounted) setState(() {});
  }

  /// Fetches vayogat list from DB and prepends the synthetic Total entry.
  /// The selected value is reset to Total whenever the list is refreshed.
  Future<void> _populateVayogatDropdown({bool fromClear = false}) async {
    final dbItems = await Statics.getStaticLDB('ShaakhaaVayogat');

    if (!mounted) return;
    setState(() {
      // Total is always the first item; DB items follow in their natural order.
      _vayogatOptions = [_totalEntry, ...dbItems];

      // Keep current selection if it still exists in the new list, otherwise
      // fall back to Total (safe default).
      final stillValid = _vayogatOptions.any(
        (e) => e?.staticID == _selectedVayogat.staticID,
      );
      if (!stillValid) _selectedVayogat = _totalEntry;
    });
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final req = {
        "AppUserID": int.tryParse(Statics.userDetails['userID'] ?? "0") ?? 0,
        "Geounitid": int.tryParse(controller.deepestSelectedGeoUnitId ?? "0"),
        "vayogat": controller.deepestSelectedLevelId != 1 ? _selectedVayogat.staticID : 0,
        "startyear": fromYear,
        "endyear": toYear,
      };
      final res = await Statics.fetchTulnatmak(req);
      if (res?.isSuccess == false) {
        setState(() {
          errorMessage = res?.message.isNotEmpty == true ? res?.message : "errorOccurred";
          isLoading = false;
        });
        return;
      }
      setState(() {
        response = res;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "internetNotConnected";
        isLoading = false;
      });
    }
  }

  void _handleFromYear(int y) {
    setState(() {
      fromYear = y;
      // clamp toYear so span never exceeds _maxSpan years
      final maxAllowedTo = fromYear + (_maxSpan - 1);
      if (toYear < fromYear) {
        toYear = fromYear;
      } else if (toYear > maxAllowedTo) {
        toYear = maxAllowedTo > allYears.last ? allYears.last : maxAllowedTo;
      }
    });
    // _fetchData();
  }

  void _handleToYear(int y) {
    setState(() => toYear = y);
    // _fetchData();
  }

  /////////////////////////////////////////////////////////////////////////
  Future<void> takeScreenShot({bool doCrop = false}) async {
    setState(() => _isExcelDownloading = true);
    try {
      // 1. Fetch the RenderRepaintBoundary safely
      final boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        print("Error: Boundary context not found.");
        return;
      }
      final boundarySize = boundary.size;

      const maxTextureDimension = 16384.0; // Skia/Impeller hard cap
      const desiredPixelRatio = 3.0;

      // Clamp pixelRatio so neither dimension exceeds the GPU texture limit
      final maxRatioForHeight = maxTextureDimension / boundarySize.height;
      final maxRatioForWidth = maxTextureDimension / boundarySize.width;
      final safePixelRatio = [desiredPixelRatio, maxRatioForHeight, maxRatioForWidth].reduce((a, b) => a < b ? a : b);

      print("Boundary size: $boundarySize, using pixelRatio: $safePixelRatio");

      // 2. Capture the master image context from GPU memory
      final image = await boundary.toImage(pixelRatio: safePixelRatio);
      print("Captured image size: ${image.width} x ${image.height}");

      // Extract raw bytes for the full image backup
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final customDir = Directory('${directory.path}/MyCustomFolder');
      if (!(await customDir.exists())) {
        await customDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imgFile = File('${customDir.path}/screenshot_$timestamp.png');
      await imgFile.writeAsBytes(pngBytes);
      print("Screenshot saved to ${imgFile.path}");

      // 3. Setup PDF document layout constraints
      final pdf = pw.Document();
      const double pageWidthPt = 595.27; // A4 page width in logical points
      const double pageHeightPt = 841.89; // A4 page height in logical points

      // 4. Slice the master image safely across separate PDF pages
      //croppin pagination
      if (doCrop) {
        const double targetAspectRatio = pageHeightPt / pageWidthPt;

        final double imgWidthPx = image.width.toDouble();
        final double imgHeightPx = image.height.toDouble();

        // Map pagination slices entirely based on the image's layout aspect ratio
        final double sliceHeightPx = imgWidthPx * targetAspectRatio;
        final int numPages = (imgHeightPx / sliceHeightPx).ceil();

        log("Generating PDF... Total pages calculated: $numPages");

        for (int pageNum = 0; pageNum < numPages; pageNum++) {
          final double yOffsetPx = pageNum * sliceHeightPx;

          // Handle the bottom remainder crop slice for the last page
          final double currentSliceHeightPx = (yOffsetPx + sliceHeightPx > imgHeightPx) ? (imgHeightPx - yOffsetPx) : sliceHeightPx;

          // Pass the image object directly (Memory-efficient approach)
          final Uint8List pageImgBytes = await _cropImage(
            image,
            imgWidthPx,
            currentSliceHeightPx,
            yOffsetPx,
            sliceHeightPx,
          );

          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              margin: pw.EdgeInsets.symmetric(horizontal: 24), // Edge-to-edge flush canvas
              build: (pw.Context context) {
                return pw.Center(
                  child: pw.Image(
                    pw.MemoryImage(pageImgBytes),
                    fit: pw.BoxFit.contain,
                  ),
                );
              },
            ),
          );
        }
      } else {
        log("Generating PDF... No Crop");
        // No cropping/pagination — just place the whole image on ONE page
        final pdfImage = pw.MemoryImage(pngBytes);

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.symmetric(vertical: 18),
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(pdfImage, fit: pw.BoxFit.contain),
              );
            },
          ),
        );
      }

      // 5. Save and launch the completed PDF document
      final pdfBytes = await pdf.save();
      final pdfFile = File('${customDir.path}/screenshot_$timestamp.pdf');
      await pdfFile.writeAsBytes(pdfBytes);

      print("PDF saved to ${pdfFile.path}");
      final result = await OpenFilex.open(pdfFile.path);
      print("Open file result: ${result.message}");
    } catch (e) {
      print("Error processing screenshot or PDF extraction: $e");
    } finally {
      setState(() => _isExcelDownloading = false);
    }
  }

  /// Helper function to crop the ui.Image instantly on canvas.
  /// Avoids byte-decoding loops to keep RAM footprint low.
  Future<Uint8List> _cropImage(
    ui.Image srcImage,
    double width,
    double height,
    double yOffset,
    double canvasHeight,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width, canvasHeight));

    final srcRect = Rect.fromLTWH(0, yOffset, width, height);
    final destRect = Rect.fromLTWH(0, 0, width, height);

    canvas.drawImageRect(srcImage, srcRect, destRect, Paint());

    final picture = recorder.endRecording();
    final img = await picture.toImage(width.toInt(), canvasHeight.toInt());

    // Convert to PNG
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  /////////////////////////////////////////////////////////////////////////

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      floatingActionButton: response == null
          ? Offstage()
          : FloatingActionButton(
              tooltip: Statics.getLabel("ExportToExcel"),
              onPressed: takeScreenShot,
              child: _isExcelDownloading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                      // padding: EdgeInsets.all(8),
                    )
                  : Icon(Icons.download_sharp),
              backgroundColor: Colors.green,
            ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Page Title ──
                Text(
                  Statics.getLabel("उपस्थिती व भरती विश्लेषण", returnKey: true),
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
                ),
                const SizedBox(height: 3),
                Text(
                  "वर्षनिहाय तुलना अहवाल",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade300),
                ),
                const SizedBox(height: 14),

                // ── Filters Card ──
                _filterSection(),
                const SizedBox(height: 14),

                if (isLoading && response == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(child: CircularProgressIndicator(color: Colors.orange)),
                  )
                else if (errorMessage != null && response == null)
                  _errorState()
                else if (response != null)
                  _content(response!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterSection() {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration,
          child: Column(
            spacing: 6,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Geo hierarchy dropdowns ──────────────────
              _FilterLabel('१. ${Statics.getLabel("selectStar")}'),

              GeoDropdownWidget(
                level: GeoLevel.Mahaanagar,
                title: 'Mahaanagar',
                controller: ctrl,
                decoration: styledDropdownDecoration(Statics.getLabel("Mahaanagar")),
              ),

              GeoDropdownWidget(
                level: GeoLevel.Vibhaag,
                title: 'Vibhaag',
                controller: ctrl,
                decoration: styledDropdownDecoration(Statics.getLabel("Vibhaag")),
              ),

              if (ctrl.hasItems(GeoLevel.Bhaag))
                GeoDropdownWidget(
                  level: GeoLevel.Bhaag,
                  title: 'Bhaag',
                  controller: ctrl,
                  decoration: styledDropdownDecoration(Statics.getLabel("Bhaag")),
                ),

              if (ctrl.hasItems(GeoLevel.Nagar))
                GeoDropdownWidget(
                  level: GeoLevel.Nagar,
                  title: 'Nagar',
                  controller: ctrl,
                  decoration: styledDropdownDecoration(Statics.getLabel("Nagar")),
                ),

              if (ctrl.hasItems(GeoLevel.upnagarUpkhanda))
                GeoDropdownWidget(
                  level: GeoLevel.upnagarUpkhanda,
                  title: 'upnagarUpkhanda',
                  controller: ctrl,
                  decoration: styledDropdownDecoration(Statics.getLabel("upnagarUpkhanda")),
                ),

              if (ctrl.hasItems(GeoLevel.Mandal))
                GeoDropdownWidget(
                  level: GeoLevel.Mandal,
                  title: 'Mandal',
                  controller: ctrl,
                  decoration: styledDropdownDecoration(Statics.getLabel("Mandal")),
                ),

              if (ctrl.hasItems(GeoLevel.Graam))
                GeoDropdownWidget(
                  level: GeoLevel.Graam,
                  title: 'Graam',
                  controller: ctrl,
                  decoration: styledDropdownDecoration(Statics.getLabel("Graam")),
                  isSankalpit: true,
                ),

              if (ctrl.hasItems(GeoLevel.Vasti))
                GeoDropdownWidget(
                  level: GeoLevel.Vasti,
                  title: 'Vasti',
                  controller: ctrl,
                  decoration: styledDropdownDecoration(Statics.getLabel("Vasti")),
                  isSankalpit: true,
                ),

              if (ctrl.hasItems(GeoLevel.Shaakhaa))
                GeoDropdownWidget(
                  level: GeoLevel.Shaakhaa,
                  title: 'Shaakhaa',
                  controller: ctrl,
                  decoration: styledDropdownDecoration(Statics.getLabel("Shaakhaa")),
                ),

              if (ctrl.deepestSelectedLevelId != 1) ...[
                const SizedBox(),
                _FilterLabel('२. ${Statics.getLabel("Vayogat")}'),
                AppDropdown<StaticMasterBAL>(
                  value: _selectedVayogat,
                  items: _vayogatOptions,
                  // Use staticID-based equality so the sentinel
                  // and DB items are both matched correctly.
                  itemKey: (v) => v.staticID?.toString() ?? '',
                  itemLabel: (v) => v.codeForDisplay ?? '--',
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _selectedVayogat = v);
                    }
                  },
                ),
              ],
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: _yearSelect(
                      label: "प्रारंभ वर्ष (से)",
                      value: fromYear,
                      options: allYears,
                      onChanged: _handleFromYear,
                    ),
                  ),
                  Expanded(
                    child: _yearSelect(
                      label: "अंत वर्ष (तक)",
                      value: toYear,
                      options: allYears.where((y) => y >= fromYear).toList(),
                      //options: allYears.where((y) => y >= fromYear && y <= fromYear + (_maxSpan - 1)).toList(),
                      onChanged: _handleToYear,
                    ),
                  ),
                ],
              ),

              // ── Kalavadhi + Vayogat row ──────────────────
              if (ctrl.deepestSelectedLevelId != 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 12,
                  children: [
                    // Kalavadhi dropdown
                    MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                      onPressed: _fetchData,
                      child: Text(
                        Statics.getLabel('Search'),
                        style: TextStyle(fontSize: 25),
                      ),
                    ),

                    // Vayogat dropdown — populated from DB with Total prepended
                    MaterialButton(
                        onPressed: () {
                          print("clear button pressed");
                          response = null;
                          setState(() => isLoading = false);
                          ctrl.loadHierarchyForUser();
                        },
                        child: Text(Statics.getLabel('clear')))
                  ],
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _errorState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECDD3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Statics.getLabel(errorMessage ?? "unableToCompleteProcess"),
            style: const TextStyle(fontSize: 13, color: Color(0xFFB91C1C)),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _fetchData,
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text("noDataFoundTryAnotherSearch"),
          ),
        ],
      ),
    );
  }

  Widget _content(TulnatmakResponse data) {
    final vMap = <String, Map<int, int>>{};
    for (final v in data.vData) {
      vMap.putIfAbsent(v.code, () => {});
      vMap[v.code]![v.year] = v.totalPresent;
    }
    final barGroups = vMap.keys.toList()..sort();
    final barYears = data.vData.map((v) => v.year).toSet().toList()..sort();

    final activitySeries = buildActivitySeries(data.hData);

    final totalIsNeg = data.totalGrowth.trim().startsWith('-');
    final newIsNeg = data.newGrowth.trim().startsWith('-');

    final _shaakhaacount = data.shaakhaacount.toString();
    final _milancount = data.milancount.toString();
    final _mansikcount = data.mansikcount.toString();
    final _sangacount = data.sangacount.toString();

    return RepaintBoundary(
      key: _globalKey,
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: LinearProgressIndicator(color: Colors.orange, minHeight: 2),
              ),

            // ── KPI Cards ──

            // ── FRD / selection summary banner ───────────────
            Container(
              width: double.infinity,
              color: const Color(0xFFEFF6FF),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Color(0xFF3B82F6)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${Statics.getLabel(controller.deepestSelectedLevelName ?? "praant")}: '
                          '${controller.deepestSelectedGeoUnitName ?? ""}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${controller.deepestSelectedLevelId != 1 ? "${_selectedVayogat.codeForDisplay ?? ""}" : ""}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            if (controller.deepestSelectedLevelId != 1) ...[
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: _statCard(Statics.getLabel("shaakhaaCount"), _shaakhaacount),
                  ),
                  Expanded(
                    child: _statCard(Statics.getLabel("saaptaahikMilanCount"), _milancount),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: _statCard(Statics.getLabel("masikMilanCount"), _mansikcount),
                  ),
                  Expanded(
                    child: _statCard(Statics.getLabel("sanghaCount"), _sangacount),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _kpiCard(
                    label: "उपस्थिती (YoY)",
                    showUp: !totalIsNeg,
                    valueText: data.totalGrowth.isEmpty ? "0" : data.totalGrowth,
                    // valueColor: totalIsNeg ? const Color(0xFFB91C1C) : const Color(0xFF15803D),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _kpiCard(
                    label: "नवीन भरती (YoY)",
                    showUp: !newIsNeg,
                    valueText: data.newGrowth.isEmpty ? "0" : data.newGrowth,
                    // valueColor: newIsNeg ? const Color(0xFFB91C1C) : const Color(0xFF15803D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Bar Chart: वयोगट अनुसार उपस्थिती ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.bar_chart, size: 15, color: Colors.orange),
                      SizedBox(width: 7),
                      Text(
                        "आयुगट अनुसार उपस्थिती तुलना",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
                      ),
                    ],
                  ),
                  LegendRow(
                    items: [
                      for (var i = 0; i < barYears.length; i++) MapEntry("${barYears[i]}", _colorAt(i)),
                    ],
                  ),
                  barGroups.isEmpty ? _emptyChartPlaceholder() : SizedBox(height: 270, child: _buildBarChart(vMap, barGroups, barYears)),
                  const SizedBox(height: 14),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Karyakram continuity (single combined chart) ──
            Row(
              children: const [
                Icon(Icons.show_chart, size: 15, color: Colors.orange),
                SizedBox(width: 7),
                Text(
                  "कार्यक्रम निरंतरता ट्रेंड",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 2, bottom: 12),
              child: Text(
                "महिन्यानिहाय गतिविधी (वर्षनिहाय तुलना)",
                style: TextStyle(fontSize: 11, color: Colors.grey.shade300),
              ),
            ),
            if (activitySeries.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration,
                child: _emptyChartPlaceholder(),
              )
            else
              ...activitySeries.map((series) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Statics.getLabel(series.activity, returnKey: true),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 10),
                        child: Text(
                          "${series.years.length} ${Statics.getLabel("yearonly")} · ${series.months.length} ${Statics.getLabel("monthOnly")}",
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade300),
                        ),
                      ),
                      LegendRow(
                        isLine: true,
                        items: [
                          for (var i = 0; i < series.years.length; i++) MapEntry(series.years[i], _colorAt(i)),
                        ],
                      ),
                      SizedBox(height: 180, child: _buildActivityLineChart(series)),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _emptyChartPlaceholder() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text("या निवडीसाठी डेटा उपलब्ध नाही.", style: TextStyle(fontSize: 12, color: Colors.grey.shade300)),
      ),
    );
  }

  // ─── Year (from/to) select field ───────────────────────────────────────────

  Widget _yearSelect({
    required String label,
    required int value,
    required List<int> options,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade300)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, size: 18),
              style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
              items: options.map((y) => DropdownMenuItem(value: y, child: Text("$y"))).toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard(String key, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade700, width: 0.7), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Flexible(child: Text(key, maxLines: 2, softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.5, color: Colors.black, fontWeight: FontWeight.w500))),
          Expanded(
              child: Text(value,
                  maxLines: 2, softWrap: true, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end, style: TextStyle(fontSize: 15, color: Colors.deepOrange, fontWeight: FontWeight.w900))),
        ],
      ),
    );
  }

  // ─── KPI card ───────────────────────────────────────────────────────────────

  Widget _kpiCard({
    required String label,
    required bool showUp,
    required String valueText,
  }) {
    final _mColor = showUp ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _mColor.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _mColor.withAlpha(190)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: _mColor.withAlpha(200), fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: _mColor.withAlpha(30), borderRadius: BorderRadius.circular(6)),
                child: Icon(
                  showUp ? Icons.trending_up : Icons.trending_down,
                  size: 13,
                  color: _mColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "$valueText%",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: _mColor),
          ),
        ],
      ),
    );
  }

  // ─── Bar chart: वयोगट अनुसार उपस्थिती (driven by vData) ─────────────────────

  Widget _buildBarChart(Map<String, Map<int, int>> vMap, List<String> groups, List<int> years) {
    double maxV = 0;
    for (final g in groups) {
      for (final y in years) {
        final v = (vMap[g]?[y] ?? 0).toDouble();
        if (v > maxV) maxV = v;
      }
    }
    final maxY = (maxV / 10) * 10 + 10;

    // ── Wrap in fixed-height SizedBox so tooltip never overlaps siblings ────────
    return SizedBox(
      height: _totalChartH,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => const FlLine(color: Color(0xFFF3F4F6), strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              // ← UNTOUCHED
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 37,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 9.5, color: Color(0xFF6B7280)),
                ),
              ),
            ),

            // ── CHANGED: topTitles now reserves space + renders tooltip ─────────
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: _tooltipReservedH,
                getTitlesWidget: (x, _) {
                  final gIdx = x.toInt();
                  if (gIdx != _tappedGroupIndex || gIdx < 0 || gIdx >= groups.length) {
                    return const SizedBox.shrink();
                  }
                  final yr = years[_tappedRodIndex];
                  final val = vMap[groups[gIdx]]?[yr] ?? 0;
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFFE0B2), width: 1),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: Text(
                        '$yr : $val',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: _xLabelReservedH,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= groups.length) return const SizedBox();
                  return Container(
                    width: 60,
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(groups[idx], softWrap: true, maxLines: 2, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                  );
                },
              ),
            ),
          ),

          // ── CHANGED: disable built-in floating tooltip; use touchCallback ──────
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => Colors.transparent,
              tooltipPadding: EdgeInsets.zero,
              tooltipMargin: 0,
              getTooltipItem: (_, __, ___, ____) => null,
            ),
            touchCallback: (event, response) {
              if (event is FlTapUpEvent) {
                final gIdx = response?.spot?.touchedBarGroupIndex ?? -1;
                final rIdx = response?.spot?.touchedRodDataIndex ?? -1;
                setState(() {
                  if (_tappedGroupIndex == gIdx && _tappedRodIndex == rIdx) {
                    // second tap on same bar → dismiss
                    _tappedGroupIndex = -1;
                    _tappedRodIndex = -1;
                  } else {
                    _tappedGroupIndex = gIdx;
                    _tappedRodIndex = rIdx;
                  }
                });
              }
            },
          ),

          // ── UNTOUCHED: color palette + grouped bar logic ───────────────────────
          barGroups: List.generate(groups.length, (i) {
            final g = groups[i];

            // Alternating band: even groups = warm light orange, odd = cool light grey
            final bandColor = i.isEven
                ? const Color(0xFFFFF3E0) // light saffron
                : const Color(0xFFF0F4FF); // light lavender

            return BarChartGroupData(
              x: i,
              barsSpace: 1, // ← was 2; tighter so bg bands merge
              barRods: List.generate(years.length, (j) {
                final yr = years[j];
                final val = (vMap[g]?[yr] ?? 0).toDouble();
                return BarChartRodData(
                  toY: val,
                  color: _colorAt(j),
                  // ← UNTOUCHED colour palette
                  width: 14,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),

                  // ── ADD: full-height background band per group ────────────────
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: bandColor,
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }

  // ─── Line chart: one per Activity, month on x-axis, year as series ────────

  Widget _buildActivityLineChart(ActivitySeries series) {
    final months = series.months;
    final years = series.years;

    double maxV = 0;
    for (final yr in years) {
      for (final m in months) {
        final v = (series.values[yr]?[m] ?? 0).toDouble();
        if (v > maxV) maxV = v;
      }
    }
    final maxY = maxV == 0 ? 10.0 : (maxV / 10) * 10 + 10;

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => const FlLine(color: Color(0xFFF3F4F6), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            axisNameWidget: Text(Statics.getLabel("monthOnly")),
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= months.length) return const SizedBox();
                final m = months[idx];
                final label = "${idx + 1}";
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
              ),
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.white,
            tooltipBorderRadius: BorderRadius.circular(8),
            getTooltipItems: (spots) {
              return spots.map((s) {
                final yr = years[s.barIndex];
                return LineTooltipItem(
                  "$yr : ${s.y.toInt()}",
                  const TextStyle(color: Color(0xFF374151), fontSize: 12, fontWeight: FontWeight.w600),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: List.generate(years.length, (i) {
          final yr = years[i];
          final spots = List.generate(months.length, (j) {
            final m = months[j];
            final val = (series.values[yr]?[m] ?? 0).toDouble();
            return FlSpot(j.toDouble(), val);
          });
          final color = _colorAt(i);
          return LineChartBarData(
            spots: spots,
            isCurved: true,
            preventCurveOverShooting: true,
            color: color,
            barWidth: 2,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                radius: 4,
                color: color,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Filter Label ─────────────────────────────────────────────────────────────

class _FilterLabel extends StatelessWidget {
  final String text;

  const _FilterLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF8E8E93),
          fontWeight: FontWeight.w400,
        ),
      );
}
