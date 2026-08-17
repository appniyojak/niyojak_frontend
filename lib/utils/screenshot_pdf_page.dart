import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Reusable utility that captures whatever widget is wrapped in a
/// [RepaintBoundary], saves it as a PNG, converts it into a PDF
/// (optionally paginated via [doCrop]), and opens the resulting PDF.
///
/// Call it from any screen — nothing here is tied to a specific
/// widget tree or State class.
class ScreenshotPdfExporter {
  ScreenshotPdfExporter._();

  /// [globalKey] must be attached to the `RepaintBoundary` you want to
  /// capture on the calling screen.
  ///
  /// [isLoading] is flipped true/false around the operation so the caller
  /// can drive its own loading UI (spinner, disabled button, etc.) via
  /// `ValueListenableBuilder`.
  static Future<void> takeScreenShot({
    required GlobalKey globalKey,
    ValueNotifier<bool>? isLoading,
    bool doCrop = false,
    String folderName = 'MyCustomFolder',
    String filePrefix = 'screenshot',
    PdfPageFormat pageFormat = PdfPageFormat.a4,
    pw.EdgeInsets pdfMargin = const pw.EdgeInsets.symmetric(vertical: 18),
    double desiredPixelRatio = 3.0,
    bool openAfterSave = true,
    void Function(File pngFile, File pdfFile)? onSuccess,
    void Function(Object error)? onError,
  }) async {
    isLoading?.value = true;
    try {
      // 1. Fetch the RenderRepaintBoundary safely
      final boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw StateError(
          'RepaintBoundary not found for the given globalKey. '
          'Make sure the key is attached to a mounted RepaintBoundary.',
        );
      }
      final boundarySize = boundary.size;

      const maxTextureDimension = 16384.0; // Skia/Impeller hard cap

      // Clamp pixelRatio so neither dimension exceeds the GPU texture limit
      final maxRatioForHeight = maxTextureDimension / boundarySize.height;
      final maxRatioForWidth = maxTextureDimension / boundarySize.width;
      final safePixelRatio = [desiredPixelRatio, maxRatioForHeight, maxRatioForWidth].reduce((a, b) => a < b ? a : b);

      log('Boundary size: $boundarySize, using pixelRatio: $safePixelRatio');

      // 2. Capture the master image from GPU memory
      final image = await boundary.toImage(pixelRatio: safePixelRatio);

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final customDir = Directory('${directory.path}/$folderName');
      if (!(await customDir.exists())) {
        await customDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imgFile = File('${customDir.path}/${filePrefix}_$timestamp.png');
      await imgFile.writeAsBytes(pngBytes);
      log('Screenshot saved to ${imgFile.path}');

      // 3. Build the PDF
      final pdf = pw.Document();

      if (doCrop) {
        // Slice the master image across separate PDF pages based on
        // the target page's aspect ratio.
        final double targetAspectRatio = pageFormat.height / pageFormat.width;

        final double imgWidthPx = image.width.toDouble();
        final double imgHeightPx = image.height.toDouble();

        final double sliceHeightPx = imgWidthPx * targetAspectRatio;
        final int numPages = (imgHeightPx / sliceHeightPx).ceil();

        log('Generating PDF... Total pages calculated: $numPages');

        for (int pageNum = 0; pageNum < numPages; pageNum++) {
          final double yOffsetPx = pageNum * sliceHeightPx;

          final double currentSliceHeightPx = (yOffsetPx + sliceHeightPx > imgHeightPx) ? (imgHeightPx - yOffsetPx) : sliceHeightPx;

          final Uint8List pageImgBytes = await _cropImage(
            image,
            imgWidthPx,
            currentSliceHeightPx,
            yOffsetPx,
            sliceHeightPx,
          );

          pdf.addPage(
            pw.Page(
              pageFormat: pageFormat,
              margin: pdfMargin,
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
        log('Generating PDF... No Crop');
        final pdfImage = pw.MemoryImage(pngBytes);

        pdf.addPage(
          pw.Page(
            pageFormat: pageFormat,
            margin: pdfMargin,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(pdfImage, fit: pw.BoxFit.contain),
              );
            },
          ),
        );
      }

      // 4. Save and optionally open the completed PDF
      final pdfBytes = await pdf.save();
      final pdfFile = File('${customDir.path}/${filePrefix}_$timestamp.pdf');
      await pdfFile.writeAsBytes(pdfBytes);
      log('PDF saved to ${pdfFile.path}');

      if (openAfterSave) {
        final result = await OpenFilex.open(pdfFile.path);
        log('Open file result: ${result.message}');
      }

      onSuccess?.call(imgFile, pdfFile);
    } catch (e) {
      if (onError != null) {
        onError(e);
      } else {
        log('Error processing screenshot or PDF extraction: $e');
      }
    } finally {
      isLoading?.value = false;
    }
  }

  /// Crops the ui.Image instantly on canvas. Avoids byte-decoding loops to
  /// keep RAM footprint low.
  static Future<Uint8List> _cropImage(
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

    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}

/*


/// Result of a successful export — paths to both generated files.
class ScreenshotExportResult {
  final File pngFile;
  final File pdfFile;

  const ScreenshotExportResult({
    required this.pngFile,
    required this.pdfFile,
  });
}

/// Reusable utility that captures whatever widget is wrapped in a
/// [RepaintBoundary], saves it as a PNG, converts it into a PDF
/// (optionally paginated via [doCrop]), and opens the resulting PDF.
///
/// Call it from any screen — nothing here is tied to a specific
/// widget tree or State class.
///
/// This function does NOT manage any loading state itself. It simply
/// returns a `Future`, so wrap the call in your own try/finally (or
/// whatever state management you use) to drive a loading indicator:
///
/// ```dart
/// setState(() => _isDownloading = true);
/// try {
///   final result = await ScreenshotPdfExporter.takeScreenShot(
///     globalKey: _repaintKey,
///   );
///   // use result.pngFile / result.pdfFile
/// } catch (e) {
///   // show your own error UI
/// } finally {
///   setState(() => _isDownloading = false);
/// }
/// ```

  /// [globalKey] must be attached to the `RepaintBoundary` you want to
  /// capture on the calling screen.
  ///
  /// Throws on failure (e.g. `StateError` if the boundary isn't found) —
  /// catch it at the call site along with your own loading-state handling.
  static Future<ScreenshotExportResult> takeScreenShot({
    required GlobalKey globalKey,
    bool doCrop = false,
    String folderName = 'MyCustomFolder',
    String filePrefix = 'screenshot',
    PdfPageFormat pageFormat = PdfPageFormat.a4,
    pw.EdgeInsets pdfMargin = const pw.EdgeInsets.symmetric(vertical: 18),
    double desiredPixelRatio = 3.0,
    bool openAfterSave = true,
  }) async {
    // 1. Fetch the RenderRepaintBoundary safely
    final boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      throw StateError(
        'RepaintBoundary not found for the given globalKey. '
        'Make sure the key is attached to a mounted RepaintBoundary.',
      );
    }
    final boundarySize = boundary.size;

    const maxTextureDimension = 16384.0; // Skia/Impeller hard cap

    // Clamp pixelRatio so neither dimension exceeds the GPU texture limit
    final maxRatioForHeight = maxTextureDimension / boundarySize.height;
    final maxRatioForWidth = maxTextureDimension / boundarySize.width;
    final safePixelRatio =
        [desiredPixelRatio, maxRatioForHeight, maxRatioForWidth]
            .reduce((a, b) => a < b ? a : b);

    log('Boundary size: $boundarySize, using pixelRatio: $safePixelRatio');

    // 2. Capture the master image from GPU memory
    final image = await boundary.toImage(pixelRatio: safePixelRatio);

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final directory = await getApplicationDocumentsDirectory();
    final customDir = Directory('${directory.path}/$folderName');
    if (!(await customDir.exists())) {
      await customDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final imgFile = File('${customDir.path}/${filePrefix}_$timestamp.png');
    await imgFile.writeAsBytes(pngBytes);
    log('Screenshot saved to ${imgFile.path}');

    // 3. Build the PDF
    final pdf = pw.Document();

    if (doCrop) {
      // Slice the master image across separate PDF pages based on
      // the target page's aspect ratio.
      final double targetAspectRatio = pageFormat.height / pageFormat.width;

      final double imgWidthPx = image.width.toDouble();
      final double imgHeightPx = image.height.toDouble();

      final double sliceHeightPx = imgWidthPx * targetAspectRatio;
      final int numPages = (imgHeightPx / sliceHeightPx).ceil();

      log('Generating PDF... Total pages calculated: $numPages');

      for (int pageNum = 0; pageNum < numPages; pageNum++) {
        final double yOffsetPx = pageNum * sliceHeightPx;

        final double currentSliceHeightPx =
            (yOffsetPx + sliceHeightPx > imgHeightPx)
                ? (imgHeightPx - yOffsetPx)
                : sliceHeightPx;

        final Uint8List pageImgBytes = await _cropImage(
          image,
          imgWidthPx,
          currentSliceHeightPx,
          yOffsetPx,
          sliceHeightPx,
        );

        pdf.addPage(
          pw.Page(
            pageFormat: pageFormat,
            margin: pdfMargin,
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
      log('Generating PDF... No Crop');
      final pdfImage = pw.MemoryImage(pngBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: pageFormat,
          margin: pdfMargin,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(pdfImage, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
    }

    // 4. Save and optionally open the completed PDF
    final pdfBytes = await pdf.save();
    final pdfFile = File('${customDir.path}/${filePrefix}_$timestamp.pdf');
    await pdfFile.writeAsBytes(pdfBytes);
    log('PDF saved to ${pdfFile.path}');

    if (openAfterSave) {
      final openResult = await OpenFilex.open(pdfFile.path);
      log('Open file result: ${openResult.message}');
    }

    return ScreenshotExportResult(pngFile: imgFile, pdfFile: pdfFile);
  }
*/
