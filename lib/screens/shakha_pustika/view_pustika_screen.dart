// import 'package:audioplayers/audioplayers.dart';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart' as flutter_html;
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../models/response_model/offline_shaakhaa_pustika_resp_model.dart';
import '../../utils/globals.dart';
import 'download_play_cell_widget.dart';

class ViewPustikaScreen extends StatefulWidget {
  static var routeName = '/view-pustika-screen';

  final List<OfflineShaakhaPustika> karyakramList;
  final String? vayogatVal;
  final bool showAppBar;

  const ViewPustikaScreen({required this.karyakramList, this.vayogatVal, this.showAppBar = false, super.key});

  @override
  State<ViewPustikaScreen> createState() => _ViewPustikaScreenState();
}

class _ViewPustikaScreenState extends State<ViewPustikaScreen> {
  String kFileBaseUrl = Statics.baseUrl;

  bool _isDownloading = false;
  int? _selecteditemid;

  static const List<Color> _karyakramHues = [
    Color(0xFF3F51B5), // Indigo
    Color(0xFF00897B), // Teal
    Color(0xFF8E24AA), // Purple
    Color(0xFFD84315), // Deep Orange
  ];

  String _stripHtmlTags(String? htmlText) {
    if (htmlText == null || htmlText.trim().isEmpty) return '-';
    var text = htmlText
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    return text.isEmpty ? '-' : text;
  }

  String _resolveFileUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path; // already absolute, leave as-is
    }
    // avoid double slashes when joining
    final base = kFileBaseUrl.endsWith('/') ? kFileBaseUrl : '$kFileBaseUrl/';
    final rel = path.startsWith('/') ? path.substring(1) : path;
    return '$base$rel';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async => await AudioPlayer.global.setAudioContext(AudioContextConfig().build()));
  }

  // Future<void> _openLink(String url) async {
  //   final uri = Uri.tryParse(url.trim());
  //   if (uri == null) {
  //     Statics.showToast(Statics.getLabel('ProblemMassage'));
  //     return;
  //   }
  //   final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   if (!launched) {
  //     Statics.showToast(Statics.getLabel('ProblemMassage'));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              elevation: 1,
              centerTitle: true,
              title: Text(
                '${Statics.getLabel('ShakhaPustika')} माहिती',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            )
          : null,
      body: SingleChildScrollView(child: _buildResultsBook(widget.karyakramList)),
    );
  }

  static const Color _saffron = Color(0xFF8600D4); // Color(0xFFD45D00); // will use them for new design!
  static const Color _saffron2 = Color(0xFFC320F0); // Color(0xFFF07020); // will use them for new design!
  static const Color _gold = Color(0xFF8620A8); // Color(0xFFA87820); // will use them for new design!
  static const Color _warmBg = Color(0xFFFCE5FF); // Color(0xFFFFF0E5); // will use them for new design!

  Widget _buildResultsBook(List<OfflineShaakhaPustika> karyakramList) {
    if (karyakramList.isEmpty) {
      return Container(
        alignment: Alignment.center,
        height: MediaQuery.sizeOf(context).height * 0.75,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(Statics.getLabel('NoInfoText')),
      );
    }

    final sorted = List<OfflineShaakhaPustika>.from(karyakramList)..sort((a, b) => (a.orderby ?? 0).compareTo(b.orderby ?? 0));

    final Map<int, List<OfflineShaakhaPustika>> grouped = {};
    for (final item in sorted) {
      final id = item.karyakramid ?? -1;
      grouped.putIfAbsent(id, () => []).add(item);
    }

    final headerItem = sorted.first;
    final monthLabel = (headerItem.monthno != null && headerItem.monthno! >= 1 && headerItem.monthno! <= 12) ? monthNameMarathi(headerItem.monthno!) : '-';
    final groups = grouped.entries.toList();

    return Container(
      padding: EdgeInsets.only(bottom: 16),
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 3, offset: const Offset(0, 1)),
          BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_saffron, _saffron2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 24,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 17),
                    const SizedBox(width: 6),
                    Text(
                      '$monthLabel ${headerItem.yearno ?? ''}',
                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          widget.vayogatVal ?? headerItem.vayogatname ?? '--',
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 2,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.groups_rounded, color: Colors.white, size: 17),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < groups.length; i++) ...[
                  _buildKaryakramSection(groups[i].value),
                  if (i != groups.length - 1) ...[
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(child: Divider(color: _gold.withOpacity(0.35), thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.circle, size: 4, color: _gold.withOpacity(0.6)),
                        ),
                        Expanded(child: Divider(color: _gold.withOpacity(0.35), thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 18),
                  ] else
                    const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKaryakramSection(List<OfflineShaakhaPustika> items) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
              color: _warmBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _gold.withOpacity(0.4), width: 1),
            ),
            child: Text(
              items.first.karyakramname ?? '-',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: _saffron, letterSpacing: 0.2),
            ),
          ),
        ),
        const SizedBox(height: 14),
        for (int i = 0; i < items.length; i++) ...[
          _buildKaryakramItem(items[i]),
          if (i != items.length - 1) ...[
            const SizedBox(height: 10),
            Divider(color: Colors.grey.shade200, thickness: 1),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }

  String _extractBodyContent(String? html) {
    if (html == null || html.trim().isEmpty) return '';
    final match = RegExp(r'<body[^>]*>([\s\S]*)<\/body>', caseSensitive: false).firstMatch(html);
    return match != null ? match.group(1)!.trim() : html.trim();
  }

  String _getPlainTextFromHtml(String htmlString) {
    if (htmlString.isEmpty) return '';

    // 1. Replace <br> and <p> tags with actual line breaks for the clipboard
    String text = htmlString.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
    text = text.replaceAll(RegExp(r'</(p|div|h[1-6])>', caseSensitive: false), '\n\n');

    // 2. Remove all remaining HTML tags (like <body>, <span>, <strong>, etc.)
    text = text.replaceAll(RegExp(r'<[^>]*>'), '');

    // 3. Decode common HTML entities so they look normal
    text = text.replaceAll('&nbsp;', ' ').replaceAll('&amp;', '&').replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&quot;', '"').replaceAll('&#39;', "'");

    return text.trim();
  }

  Future<void> _openLink(String url) async {
    String finalUrl = url.trim();
    if (!finalUrl.startsWith('http://') && !finalUrl.startsWith('https://')) {
      finalUrl = 'https://$finalUrl';
    }
    final uri = Uri.tryParse(finalUrl);
    if (uri == null) return;

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      Statics.showToast(Statics.getLabel('ProblemMassage'));
    }
  }

  Future<void> _openAnyaFile(int id, String url, filenameSave) async {
    log("clicked anya file >>>>>>>>>>>>> $url");
    // log("clicked anya file name >>>>>>>>>>>>> $name");

    final uri = Uri.tryParse(url.trim());
    if (uri == null) {
      Statics.showToast(Statics.getLabel('ProblemMassage'));
      return;
    }

    // NEW — image extensions check (case-insensitive), matched against the
    // path portion of the URL so query params (?x=1) don't interfere.
    const imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
    final lowerPath = uri.path.toLowerCase();
    final isImage = imageExtensions.any((ext) => lowerPath.endsWith(ext));

    final filename = "${filenameSave}_${url.split("/").last}";

    if (isImage) {
      _showGalleryDialog(url, filename);
      return;
    }
    // final filename = "$filenameSave${url.split(".").last}";

    try {
      // await launchUrl(uri, mode: LaunchMode.externalApplication);
      await downloadExcelTemplate(id, url, filename);
    } catch (e) {
      Statics.showToast(Statics.getLabel('ProblemMassage'));
    }
  }

  Future<void> downloadExcelTemplate(int id, String url, String fileName) async {
    _selecteditemid = id;
    setState(() => _isDownloading = true);

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Directory dir = await getApplicationDocumentsDirectory();
        final String savePath = "${dir.path}/$fileName";
        final File file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);

        await OpenFilex.open(savePath);
      } else {
        Statics.showToast("${Statics.getLabel('templateDownloadFailed')}");
      }
    } catch (e) {
      print("Error downloading template: $e");
      Statics.showToast("${Statics.getLabel('templateDownloadFailed')}");
    } finally {
      _selecteditemid = null;
      setState(() => _isDownloading = false);
    }
  }

  // ─── Gallery / view-all dialog ─────────────────────────────────────────────
  void _showGalleryDialog(String baseUrl, String filename) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Container(
          // margin: EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          color: Colors.transparent,
          padding: const EdgeInsets.all(20),
          child: StatefulBuilder(builder: (context, set) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        Statics.getLabel("DoDownload"),
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ),
                    IconButton(
                      onPressed: _isDownloading
                          ? null
                          : () async {
                              set(() => _isDownloading = true);
                              await MyAppGlobals.downloadFile(baseUrl, (filename).toString());
                              set(() => _isDownloading = false);
                            },
                      icon: _isDownloading
                          ? const SizedBox(
                              width: 17,
                              height: 17,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.download, color: Colors.purple),
                    ),
                  ],
                ),
                Flexible(
                  child: CachedNetworkImage(
                    imageUrl: baseUrl,
                    errorWidget: (_, __, ___) => SizedBox(width: double.infinity, height: 120, child: Center(child: Text(Statics.getLabel("errorOccurred")))),
                    progressIndicatorBuilder: (_, __, ___) => const SizedBox(width: double.infinity, height: 120, child: Center(child: CircularProgressIndicator())),
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildKaryakramItem(OfflineShaakhaPustika item) {
    final rawRelativePath = item.filepath ?? '';
    final hasAudio = rawRelativePath.isNotEmpty;
    final audioUrl = _resolveFileUrl(rawRelativePath);
    final subjectPlain = _stripHtmlTags(item.subjecttext); // keep — still used as title below
    final subjectHtml = _extractBodyContent(item.subjecttext);
    final hasLink = (item.urllink ?? '').trim().isNotEmpty;
    final monthLabel = (item.monthno! >= 1 && item.monthno! <= 12) ? monthNameMarathi(item.monthno!) : '-';

    final rawAnyaPath = item.anyapath ?? '';
    final hasAnyaFile = rawAnyaPath.isNotEmpty;
    final anyaUrl = _resolveFileUrl(rawAnyaPath);
    final isAnyaMp4 = rawAnyaPath.toLowerCase().endsWith('.mp4');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, // Ensures full width for proper alignment
      children: [
        if (hasAudio) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _warmBg.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DownloadPlayCell(
              pkid: item.pkid!,
              tablename: 'shaakhapustika',
              remoteRelativePath: rawRelativePath,
              resolvedUrlForDiskCheck: audioUrl,
              title: subjectPlain,
            ),
          ),
          const SizedBox(height: 12),
        ],

        if (hasAnyaFile) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _warmBg.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: isAnyaMp4
                ? DownloadPlayCell(
                    pkid: item.pkid!,
                    tablename: 'shaakhapustika',
                    remoteRelativePath: rawAnyaPath,
                    resolvedUrlForDiskCheck: anyaUrl,
                    title: subjectPlain,
                  )
                : InkWell(
                    onTap: () => _openAnyaFile(item.karyakramid ?? 0, anyaUrl, "${item.karyakramname}_${monthLabel}_${item.yearno}"),
                    child: Row(
                      children: [
                        Icon(Icons.insert_drive_file_rounded, size: 18, color: _saffron),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            rawAnyaPath.split('/').last,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13.5,
                              color: _saffron,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const Icon(Icons.open_in_new, size: 16, color: _saffron),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 12),
        ],

        // --- ACTION BAR: Link and Copy Button ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns buttons to the right
          children: [
            // --- NEW COPY BUTTON ---
            if (subjectHtml.isNotEmpty)
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () async {
                  // Convert HTML to clean plain text
                  final plainText = _getPlainTextFromHtml(subjectHtml);

                  // Copy to clipboard
                  await Clipboard.setData(ClipboardData(text: plainText));

                  // Optional: Show a little popup message to confirm it copied
                  if (context.mounted) {
                    Statics.showToast('Text copied to clipboard');
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.copy_rounded, size: 13, color: Colors.grey[700]), // Change color as needed
                    const SizedBox(width: 3),
                    Text(
                      Statics.getLabel('copy'),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            if (hasLink) ...[
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () => _openLink(item.urllink!),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.link_rounded, size: 15, color: _saffron),
                      const SizedBox(width: 3),
                      Text(
                        Statics.getLabel('GeetUrl'),
                        style: TextStyle(
                          fontSize: 14,
                          color: _saffron,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8), // Some spacing before the HTML text begins

        // --- HTML CONTENT ---
        subjectHtml.isEmpty
            ? const Text(
                '-',
                style: TextStyle(fontSize: 13.5, color: Color(0xFF3A3A3A), height: 1.55),
              )
            : SelectionArea(
                child: flutter_html.Html(
                  data: subjectHtml,
                  onLinkTap: (url, attributes, element) {
                    if (url != null && url.trim().isNotEmpty) {
                      _openLink(url);
                    }
                  },
                  style: {
                    "body": flutter_html.Style(
                      margin: flutter_html.Margins.zero,
                      padding: flutter_html.HtmlPaddings.zero,
                      fontSize: flutter_html.FontSize(13.5),
                      color: const Color(0xFF3A3A3A),
                      lineHeight: flutter_html.LineHeight(1.55),
                    ),
                    "p": flutter_html.Style(
                      margin: flutter_html.Margins.zero,
                      padding: flutter_html.HtmlPaddings.only(bottom: 6),
                    ),
                  },
                ),
              ),
      ],
    );
  }
// Widget _buildKaryakramItem(OfflineShaakhaPustika item) {
//   final rawRelativePath = item.filepath ?? '';
//   final hasAudio = rawRelativePath.isNotEmpty;
//   final audioUrl = _resolveFileUrl(rawRelativePath);
//   final subjectPlain = _stripHtmlTags(item.subjecttext);
//   final hasLink = (item.urllink ?? '').trim().isNotEmpty;
//
//   return Column(
//     mainAxisSize: MainAxisSize.min,
//     crossAxisAlignment: CrossAxisAlignment.stretch,
//     children: [
//       if (hasAudio) ...[
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//           decoration: BoxDecoration(
//             color: _warmBg.withOpacity(0.6),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: DownloadPlayCell(
//             pkid: item.pkid!,
//             tablename: 'shaakhapustika',
//             remoteRelativePath: rawRelativePath,
//             resolvedUrlForDiskCheck: audioUrl,
//             title: subjectPlain,
//           ),
//         ),
//         const SizedBox(height: 12),
//       ],
//       Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 3,
//             child: Text(
//               subjectPlain,
//               style: const TextStyle(fontSize: 13.5, color: Color(0xFF3A3A3A), height: 1.55),
//             ),
//           ),
//           if (hasLink) ...[
//             const SizedBox(width: 14),
//             Expanded(
//               flex: 2,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(6),
//                 onTap: () => _openLink(item.urllink!),
//                 child: Align(
//                   alignment: Alignment.topRight,
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.link_rounded, size: 13, color: _saffron),
//                       const SizedBox(width: 3),
//                       Text(
//                         Statics.getLabel('GeetUrl'), // e.g. "लिंक उघडा" / "Link"
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: _saffron,
//                           fontWeight: FontWeight.w600,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     ],
//   );
// }
}
