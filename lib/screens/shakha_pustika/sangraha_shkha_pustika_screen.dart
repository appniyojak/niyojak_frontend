import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as flutter_html;
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_delta_from_html/parser/html_to_delta.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart' as delta_html;

import '../../../utils/globals.dart';
import '../../helpers/static_data.dart' as Statics;
import '../../models/request_model/shakha_pustika_req_model.dart';
import '../../providers/bals.dart';
import '../../utils/stable_geounit_class.dart';
import '../../validation_blocks/validator.dart';
import 'audio_player_dialogue.dart';

class SangrahaShkhaPustikaScreen extends StatefulWidget {
  static var routeName = '/sangrahashakhapustika';

  @override
  State<SangrahaShkhaPustikaScreen> createState() => _SangrahaShkhaPustikaScreen();
}

class _SangrahaShkhaPustikaScreen extends State<SangrahaShkhaPustikaScreen> {
  bool _isExpanded = false;
  final _controller = createGeoController();
  List<StaticMasterBAL>? _vayogat;
  List<StaticMasterBAL>? _karyakram;
  String? _vayogatValue;
  List<String> _selectedVayogat = [];
  int levelId = 0;

  // ── Karyakram dropdown state ─────────────────────────────────────

  String? _karyakramValue;

  // ── single Month-Year picker state ─────────────────────────────
  DateTime? _selectedMonthYear;
  String? _choosenKaryakram;
  int? _selectedMonth;
  int? _selectedYear;

  // ── NEW: extra text fields ─────────────────────────────────────
  final TextEditingController _topicController = TextEditingController();
  final quill.QuillController _topicQuillController = quill.QuillController.basic();
  final TextEditingController _remarkController = TextEditingController();

  // ── NEW: audio file picker state ────────────────────────────────
  PlatformFile? _selectedAudioFile;
  PlatformFile? _selectedAnyaFile;

  // ── UI constants ─────────────────────────────────────────────────
  static const double _cardRadius = 16;

  // ── NEW: editable / read-only mode (set via route arguments) ─────
  bool _isEditable = true;
  bool _argsLoaded = false;
  int? _incomingPkId;
  String? _originalHtmlFromApi;
  Map<String, String>? _incomingRow;
  int cUserId = 0;
  int? currentYear;
  int? currentMonth;
  final TextEditingController _linkController = TextEditingController(); // NEW — for "दुआ" link field
  bool _isSaving = false; // NEW — loading state for save button
  String? _existingAudioName; // NEW — shows previously saved audio file name
  String? _localAudioPath; // NEW — path of the already-downloaded audio file
  String? _existingAnyaFileName; // NEW — shows previously saved "any file" (karyakram 311) name
  bool get _hasPlayableAudio => _localAudioPath != null;
  bool _isLoading = true;
  bool _isOpeningLink = false;
  final ScrollController _quillScrollController = ScrollController();
  late FocusNode _quillFocusNode;
  Timer? _scrollDebounce;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argsLoaded) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map) {
        _isEditable = args['isEditable'];
        print("is editable:$_isEditable");
        final row = args['row'];
        _incomingPkId = args['pkid'];
        _localAudioPath = args['localAudioPath'] as String?; // NEW
        if (row is Map) {
          _incomingRow = Map<String, String>.from(row);
        }
      }
      _argsLoaded = true;
      //_prefillFromIncomingRow();
    }
  }

// ── NEW: populate form fields from the incoming row data ─────────
//   void _prefillFromIncomingRow() {
//     final row = _incomingRow;
//     if (row == null) return;
//
//     // Month → find matching index (assuming row['month'] is Marathi name like 'जुलै')
//     final monthName = row['month'];
//     if (monthName != null && monthName.isNotEmpty) {
//       final idx = _monthNamesMarathiList.indexOf(monthName);
//       if (idx != -1) _selectedMonth = idx + 1;
//     }
//
//     // Year, if you store it separately in the row (add 'year' key if needed)
//     final yearStr = row['year'];
//     if (yearStr != null && yearStr.isNotEmpty) {
//       _selectedYear = int.tryParse(yearStr);
//     }
//
//     // Karyakram type — only if it matches one of your dropdown options
//     final karyakram = row['karyakram']; // add this key when building the row map
//     // if (karyakram != null && _karyakramOptions.contains(karyakram)) {
//     //   _karyakramValue = karyakram;
//     // }
//
//     // Text content
//     _topicController.text = row['content'] ?? '';
//
//     _remarkController.text = row['tapshilInfo'] ?? row['otherInfo'] ?? '';
//
//     // Vayogat — row stores display name, your dropdown works on staticID,
//     // so match by codeForDisplay once _vayogat is loaded (see step 2)
//     _pendingVayogatLabel = row['vayogat'];
//   }

// Helper list for month name lookup (reuses your existing naming)
  static const _monthNamesMarathiList = ['जानेवारी', 'फेब्रुवारी', 'मार्च', 'एप्रिल', 'मे', 'जून', 'जुलै', 'ऑगस्ट', 'सप्टेंबर', 'ऑक्टोबर', 'नोव्हेंबर', 'डिसेंबर'];

// Holds the vayogat label until _vayogat list is loaded, then resolved
  String? _pendingVayogatLabel;

  @override
  void initState() {
    super.initState();
    //_topicQuillController = quill.QuillController.basic();
    _quillFocusNode = FocusNode();
    _topicQuillController.addListener(_syncTopicControllerFromQuill);
    _quillScrollController.addListener(_onQuillScroll); // NEW
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _initData());
  }

  void _onQuillScroll() {
    _scrollDebounce?.cancel();
    _scrollDebounce = Timer(const Duration(milliseconds: 8), () {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _quillScrollController.removeListener(_onQuillScroll); // NEW
    _quillFocusNode.dispose();
    _quillScrollController.dispose();
    _topicController.dispose();
    _remarkController.dispose();
    _linkController.dispose();
    _topicQuillController.removeListener(_syncTopicControllerFromQuill); // NEW
    _topicQuillController.dispose(); // NEW
    super.dispose();
  }

  Future<void> _initData() async {
    _isExpanded = !_isEditable ? true : false;
    final dm = await MyAppGlobals.getLevelLDB();
    levelId = dm.levelID ?? 0;
    await _controller.initialize(dm);
    List<UserDataBAL> user = await Statics.getUserDataLDB();

    currentYear = DateTime.now().year;
    currentMonth = DateTime.now().month;
    //if (widget.hitApiWtoDropdown) _search(_controller.deepestSelectedGeoUnitId, context);
    _selectedYear = currentYear;
    _selectedMonth = currentMonth;
    //await Statics.populateUserDetailsMap();
    print("userid:${user.map((e) => e.swayamsevakID)}");
    cUserId = user.first.swayamsevakID ?? 0;
    await populateDropdown();
    print("checking incoming id is coming or not:$_incomingPkId");
    //if (widget.hitApiWtoDropdown) _search(_controller.deepestSelectedGeoUnitId, context);
    if (_incomingPkId != null && _incomingPkId != 0) {
      await _fetchAndPrefillShaakhaPustika(_incomingPkId!); // NEW
    }
    if (mounted) {
      setState(() => _isLoading = false); // CHANGED — stop loader once full data is in
    }
    setState(() {});
  }

  void _syncTopicControllerFromQuill() {
    // _topicController.text = _topicQuillController.document.toDelta().toString();
    _topicController.text = _topicQuillController.document.toPlainText().trimRight();
  }

// NEW — pushes plain text (e.g. from API prefill) into the Quill document
  void _setQuillContentFromPlainText(String text) {
    _topicQuillController.document = quill.Document()..insert(0, text);
    _topicQuillController.moveCursorToEnd();
  }

  void _setQuillContentFromStoredValue(String? stored) {
    if (stored == null || stored.trim().isEmpty) {
      _topicQuillController.document = quill.Document();
      return;
    }
    try {
      final bodyOnly = _extractBodyContent(stored);
      final delta = HtmlToDelta().convert(bodyOnly);
      _topicQuillController.document = quill.Document.fromDelta(delta);
    } catch (e) {
      _topicQuillController.document = quill.Document()..insert(0, stored);
    }
    _topicQuillController.moveCursorToEnd();
  }

  String _extractBodyContent(String html) {
    final match = RegExp(r'<body[^>]*>([\s\S]*)<\/body>', caseSensitive: false).firstMatch(html);
    return match != null ? match.group(1)!.trim() : html;
  }

  String _stripHtmlTags(String html) {
    if (html.isEmpty) return '';
    final bodyOnly = _extractBodyContent(html);
    // Remove all HTML tags, decode common entities, collapse extra whitespace
    final withoutTags = bodyOnly
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
    return withoutTags.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String _htmlToPlainText(String? html) {
    if (html == null || html.trim().isEmpty) return '';
    // print("html:$html");
    try {
      final bodyOnly = _extractBodyContent(html);
      final delta = HtmlToDelta().convert(bodyOnly);
      final doc = quill.Document.fromDelta(delta);
      return doc.toPlainText().trim();
    } catch (e) {
      // Fallback: regex strip if Quill parsing fails for some reason
      final bodyOnly = _extractBodyContent(html);
      final stripped = bodyOnly
          .replaceAll(RegExp(r'<[^>]*>'), ' ')
          .replaceAll('&nbsp;', ' ')
          .replaceAll('\u000a', ' ')
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .replaceAll('&#39;', "'");
      return stripped.replaceAll(RegExp(r'\s+'), ' ').trim();
    }
  }

// NEW — fetches by pkid and prefills the form for both view & edit
  Future<void> _fetchAndPrefillShaakhaPustika(int pkid) async {
    print("pkid:$_incomingPkId");
    final respData = await Statics.getShaakhaPustikaById(pkid);
    log("byidresponse:$respData");
    final data = respData;
    if (data == null) return;

    _karyakramValue = data.karyakramid.toString();
    _selectedMonth = data.monthno;
    _selectedYear = data.yearno;
    _selectedVayogat = (data.vayogatid ?? '').toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    _topicController.text = data.subjecttext ?? '';
    //_setQuillContentFromPlainText(_topicController.text); // NEW
    //_setQuillContentFromStoredValue(_topicController.text);
    _originalHtmlFromApi = data.subjecttext ?? ''; // NEW — keep raw HTML safe here
    _setQuillContentFromStoredValue(_originalHtmlFromApi); // load into editor (unaffected by listener overwrite issue since it's a separate field now)

    _linkController.text = data.urllink ?? '';
    _existingAudioName = data.filepath; // NEW field, see below
    _existingAnyaFileName = data.anyapath; // NEW
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    var data = await Statics.getStaticLDB('ShaakhaaVayogat');
    var data1 = await Statics.getStaticLDB('ShaakhaaFrequency');
    var data2 = await Statics.getKrayakramList();
    if (!mounted) return;
    setState(() {
      _vayogat = data;
      _karyakram = data2;
      // NEW — resolve vayogat selection now that the list is available
      // if (_pendingVayogatLabel != null && _vayogat != null) {
      //   final match = _vayogat!.firstWhereOrNull(
      //     (v) => v.codeForDisplay == _pendingVayogatLabel,
      //   );
      //   if (match != null) {
      //     _selectedVayogat = [match.staticID.toString()];
      //   }
      //   _pendingVayogatLabel = null;
      // }
    });
  }

  Future<void> _saveShaakhaPustika() async {
    print("inside save");
    // Basic validation
    if (_karyakramValue == null) {
      Statics.showToast(Statics.getLabel("ChooseKaryakram"));
      return;
    }
    if (_selectedMonth == null || _selectedYear == null) {
      Statics.showToast(Statics.getLabel("ChooseMonthYearValidation"));
      return;
    }
    if (_selectedVayogat.isEmpty) {
      Statics.showToast(Statics.getLabel("selectVayogat"));
      return;
    }
    if (_linkController.text.trim().isNotEmpty) {
      final valid = await isValidUrl(_linkController.text.trim());
      if (!valid) {
        Statics.showToast(Statics.getLabel('urlValidation'));
        return;
      }
    }
    setState(() => _isSaving = true);

    try {
      // Convert selected audio file to base64 (only relevant for 'गीत')
      String? fileBase64;
      String? filePathName;
      String? anyabase64;
      String? anyapathName;
      // print("inside selected audio file:$_selectedAudioFile");
      // print("inside selected anya file:$_selectedAnyaFile");
      if (_selectedAudioFile != null) {
        filePathName = _selectedAudioFile!.name;

        if (_selectedAudioFile!.bytes != null) {
          // bytes already available (web, or withData: true worked)
          fileBase64 = base64Encode(_selectedAudioFile!.bytes!);
        } else if (_selectedAudioFile!.path != null) {
          // fallback — read bytes from the file path (mobile/desktop)
          final fileBytes = await File(_selectedAudioFile!.path!).readAsBytes();
          fileBase64 = base64Encode(fileBytes);
        } else {
          // neither bytes nor path available — bail out safely
          if (mounted) {
            Statics.showToast(Statics.getLabel("FailedToReadFile"));
          }
          setState(() => _isSaving = false);
          return;
        }

        log("Audio file encoded, base64 length: ${fileBase64.length}");
      } else if (_selectedAnyaFile != null) {
        anyapathName = _selectedAnyaFile!.name;

        // NEW — extension from the picked file, falls back to 'dat' to match
        // the backend's own fallback (".dat") if somehow empty/unknown.
        final rawExt = (_selectedAnyaFile!.extension ?? '').trim();
        final ext = rawExt.isEmpty ? 'dat' : rawExt;

        Uint8List? rawBytes;
        if (_selectedAnyaFile!.bytes != null) {
          rawBytes = _selectedAnyaFile!.bytes!;
        } else if (_selectedAnyaFile!.path != null) {
          rawBytes = await File(_selectedAnyaFile!.path!).readAsBytes();
        } else {
          if (mounted) {
            Statics.showToast(Statics.getLabel("FailedToReadFile"));
          }
          setState(() => _isSaving = false);
          return;
        }

        // NEW — prefix as a Data URL so the .NET API can extract the extension:
        // header is everything before the first comma; it looks for "/" then ";"
        // and takes what's between them as the extension. "file/<ext>;base64,"
        // satisfies that regardless of the file's real MIME type.
        final encoded = base64Encode(rawBytes);
        anyabase64 = 'data:file/$ext;base64,$encoded';

        log("Anya file encoded, base64 length: ${anyabase64.length}, extension: $ext");
      } else if (_existingAnyaFileName != null && _existingAnyaFileName!.isNotEmpty) {
        // edit flow — no new file picked, keep referencing the existing one
        anyapathName = _existingAnyaFileName;
        anyabase64 = null;
      } else if (_existingAudioName != null && _existingAudioName!.isNotEmpty) {
        // ── NEW: no new file picked, but an existing audio file is already
        // attached to this record (edit flow) — keep referencing it so the
        // update doesn't wipe it out. Don't send fileBase64 since there's
        // nothing new to upload.
        filePathName = _existingAudioName;
        fileBase64 = null;
      }
      final quillFragmentHtml = delta_html.QuillDeltaToHtmlConverter(
        _topicQuillController.document.toDelta().toJson(),
        delta_html.ConverterOptions(
          converterOptions: delta_html.OpConverterOptions(
            inlineStylesFlag: true, // emit style="text-align:center" instead of class="ql-align-center"
          ),
        ),
      ).convert();

      final fullHtml = _wrapAsFullHtmlDocument(quillFragmentHtml);
      log("full html:$fullHtml");
      //final int? currentUserId = int.tryParse(Statics.userDetails['UserID']!.toString());
      //print("karyakramid:${_karyakramIdMap[]}")
      final requestModel = CreateUpdateShaakhaPustikaRequest(
        pkid: _incomingPkId == null ? 0 : _incomingPkId!,
        karyakramid: int.tryParse(_karyakramValue.toString()) ?? 0,
        monthno: _selectedMonth!,
        yearno: _selectedYear!,
        cuserid: cUserId,
        vayogatid: _selectedVayogat.join(','),
        subjecttext: fullHtml,
        filepath: filePathName ?? "",
        anyapath: anyapathName ?? "",
        urllink: _linkController.text.trim(),
        filebase64: fileBase64 ?? "",
        anyabase64: anyabase64 ?? "",
      );

      // log("request model:${requestModel.toJson()}");
      final respData = await Statics.createUpdateShaakhaPustika(requestModel);

      if (!mounted) return;

      if (respData != null && respData["Status"] == '200') {
        final message = respData["Message"] ?? 'यशस्वीरित्या जतन झाले';
        Navigator.of(context).pop(true); // return true to caller
        Statics.showToast(Statics.getLabel("dataSavedSuccessfully"));
      } else {
        Statics.showToast(respData?["Message"] == 'Already Exists' ? Statics.getLabel('dataAlreadyExists') : Statics.getLabel("ProblemGettingInfoMsg"));
      }
    } catch (e) {
      log("Error saving shaakha pustika: $e");
      if (mounted) {
        Statics.showToast(Statics.getLabel("SomethingWentWrong"));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _wrapAsFullHtmlDocument(String bodyContent) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
    </head>
    <body>
      $bodyContent
    </body>
    </html>
    ''';
  }

  // ── NEW: pick an audio file from the device ─────────────────────
  Future<void> _pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      withData: true, // CHANGED — ensures bytes are loaded into memory
    );

    if (result == null) return;

    final file = result.files.first;

    final extension = file.extension?.toLowerCase();

    const allowedAudioExtensions = {
      'mp3',
      'wav',
      'm4a',
      'aac',
      'ogg',
      'flac',
      'amr',
    };

    if (!allowedAudioExtensions.contains(extension)) {
      Statics.showToast('Please select an audio file');
      return;
    }

    if (result != null && result.files.isNotEmpty) {
      final picked = result.files.first;

      // NEW — calculate size and enforce 25 MB limit
      const maxSizeBytes = 25 * 1024 * 1024; // 25 MB
      final pickedSizeMb = picked.size / (1024 * 1024);

      if (picked.size > maxSizeBytes) {
        log("Rejected audio file — size: ${pickedSizeMb.toStringAsFixed(2)} MB");
        if (mounted) await _showFileSizeExceededDialog(pickedSizeMb);

        return; // reject — don't set _selectedAudioFile
      }
      setState(() {
        _selectedAudioFile = result.files.first;
      });
      log("Audio name: ${_selectedAudioFile?.name}");
      log("Audio size: ${_selectedAudioFile?.size}");
      log("Audio bytes: ${_selectedAudioFile?.bytes != null}");
      //log("Audio selected: ${_selectedAudioFile?.name}, size: ${_selectedAudioFile?.size}, hasBytes: ${_selectedAudioFile?.bytes != null}");
    }
  }

  Future<void> _pickAnyaFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final picked = result.files.first;

      const maxSizeBytes = 25 * 1024 * 1024; // 25 MB — same limit as audio
      final pickedSizeMb = picked.size / (1024 * 1024);

      if (picked.size > maxSizeBytes) {
        log("Rejected anya file — size: ${pickedSizeMb.toStringAsFixed(2)} MB");
        if (mounted) await _showFileSizeExceededDialog(pickedSizeMb);
        return; // reject — don't set _selectedAnyaFile
      }

      setState(() {
        _selectedAnyaFile = picked;
      });
      log("Anya name: ${_selectedAnyaFile?.name}");
      log("Anya size: ${_selectedAnyaFile?.size}");
      log("Anya bytes: ${_selectedAnyaFile?.bytes != null}");
    }
  }

  Future<void> _showFileSizeExceededDialog(double pickedSizeMb) {
    return showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('फाईल आकार मर्यादा'),
          content: Text(
            'निवडलेली फाईल ${pickedSizeMb.toStringAsFixed(2)} MB आहे. कृपया 25 MB पेक्षा लहान फाईल निवडा.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text(Statics.getLabel('OK')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(
          _incomingPkId == null || !_isEditable
              ? '${Statics.getLabel('ShakhaPustika')} ${Statics.getLabel('Submit')}'
              : _isEditable
                  ? '${Statics.getLabel('ShakhaPustika')} ${Statics.getLabel('Edit')}'
                  : '${Statics.getLabel('ShakhaPustika')} ${Statics.getLabel('Information')}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      //drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ChangeNotifierProvider.value(
              value: _controller,
              child: Consumer<GeoHierarchyController>(
                builder: (_, ctrl, __) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Audio playback card — deliberately OUTSIDE the
                        // AbsorbPointer below, so it stays tappable even when
                        // _isEditable is false (which it always is for गीत rows).
                        Opacity(
                          opacity: _isEditable ? 1.0 : 0.7,
                          child: AbsorbPointer(
                            absorbing: !_isEditable,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (levelId > 7 && levelId != 13) const SizedBox(height: 16),
                                _sectionCard(
                                  child: _karyakramSection(primaryColor, ctrl),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),

                        if (!_isEditable && (_karyakramValue != '309')) ...[
                          _sectionCard(child: _audioPlaySection(primaryColor)),
                          const SizedBox(height: 10),
                          _sectionCard(child: _isOpeningLink ? Center(child: CircularProgressIndicator()) : _clickOnLink())
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  // ── Reusable card wrapper for each section ──────────────────────
  Widget _sectionCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  // ── Section title helper ────────────────────────────────────────
  Widget _sectionTitle(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  // ── Common dropdown decoration ──────────────────────────────────
  InputDecoration _boxedDecoration({String? label, String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      isDense: true,
      filled: true,
      fillColor: const Color(0xFFF9FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.6),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // Karyakram dropdown + Month-Year fields + text fields + audio picker
  // ─────────────────────────────────────────────────────────────────────
  Widget _karyakramSection(Color primaryColor, GeoHierarchyController geoctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(Statics.getLabel('sanvaadKaryakramData'), Icons.event_note_rounded, primaryColor),
        const SizedBox(height: 16),

        // ── कार्यक्रम निवडा dropdown ──
        Text(
          Statics.getLabel('ChooseKaryakramTitle'),
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          decoration: _boxedDecoration(hint: Statics.getLabel('Filters')),
          isExpanded: true,
          value: _karyakramValue,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: primaryColor),
          items: _karyakram
              ?.map((k) => DropdownMenuItem<String>(
                    value: k.staticID.toString(),
                    child: Text(k.codeForDisplay.toString(), style: const TextStyle(fontSize: 15)),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _karyakramValue = value;
              // _selectedMonth = null;
              // _selectedYear = null;
              // _selectedVayogat = [];
            });
            log("karyajkramchosing:$_karyakramValue");
          },
        ),

        const SizedBox(height: 20),

        Text(
          Statics.getLabel('selectMonth'),
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
        ),
        // const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _yearPickerField(primaryColor)),
            const SizedBox(width: 16),
            Expanded(child: _monthPickerField(primaryColor)),
          ],
        ),

        const SizedBox(height: 20),
        if (_vayogat != null) _vayogatMultiSelectDropdown(primaryColor),
        // if (_vayogat != null)
        //   DropdownButtonFormField(
        //     decoration: _boxedDecoration(label: Statics.getLabel('Vayogat')),
        //     isExpanded: true,
        //     value: _vayogatValue == "" ? null : _vayogatValue,
        //     icon: Icon(Icons.keyboard_arrow_down_rounded, color: primaryColor),
        //     items: _vayogat!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
        //     onChanged: (value) {
        //       setState(() {
        //         _vayogatValue = value;
        //       });
        //     },
        //   ),

        const SizedBox(height: 20),

        // ── NEW: two text fields ──
        // if (_karyakramValue == '308' || _karyakramValue == '309') ...[
        //   TextFormField(
        //     controller: _topicController,
        //     decoration: _boxedDecoration(label: 'विषय'),
        //     style: const TextStyle(fontSize: 15),
        //   ),
        //   const SizedBox(height: 16),
        // ],

        // if (_karyakramValue == '311') ...[
        //   TextFormField(
        //     keyboardType: TextInputType.multiline,
        //     controller: _remarkController,
        //     decoration: _boxedDecoration(label: Statics.getLabel('OtherField')),
        //     style: const TextStyle(fontSize: 15),
        //   ),
        //   const SizedBox(height: 20),
        // ],
        // if (_karyakramValue == '308' || _karyakramValue == '309') ...[
        //   Text(
        //     'विषय',
        //     style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
        //   ),
        //   const SizedBox(height: 6),
        //   Container(
        //     decoration: BoxDecoration(
        //       color: const Color(0xFFF9FAFC),
        //       borderRadius: BorderRadius.circular(10),
        //       border: Border.all(color: Colors.grey.shade300),
        //     ),
        //     clipBehavior: Clip.antiAlias,
        //     child: AbsorbPointer(
        //       absorbing: !_isEditable, // respects your existing view/edit mode
        //       child: Column(
        //         children: [
        //           //quill.QuillEditor.basic(configurations: quill.QuillSimpleToolbar(configurations: null,), focusNode: focusNode, scrollController: scrollController)
        //           quill.QuillSimpleToolbar(
        //             // controller: _topicQuillController,
        //             configurations: quill.QuillSimpleToolbarConfigurations(
        //               showFontFamily: false,
        //               showFontSize: false,
        //               showSubscript: false,
        //               showSuperscript: false,
        //               showSearchButton: false,
        //               showClearFormat: false,
        //               showCodeBlock: false,
        //               showQuote: false,
        //               controller: _topicQuillController,
        //             ),
        //           ),
        //           Container(
        //             height: 160,
        //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        //             child: quill.QuillEditor.basic(
        //               configurations: quill.QuillEditorConfigurations(
        //                 controller: _topicQuillController,
        //                 placeholder: 'विषय लिहा',
        //                 padding: EdgeInsets.zero,
        //                 expands: true,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        //   const SizedBox(height: 16),
        // ],

        // if (_karyakramValue == 'अन्य' || _karyakramValue == 'सुभाषित' || _karyakramValue == 'अमृतवचन' || _karyakramValue == 'गीत') ...[
        //   TextFormField(
        //     keyboardType: TextInputType.multiline,
        //     controller: _remarkController,
        //     decoration: _boxedDecoration(label: 'अन्य विषय'),
        //     style: const TextStyle(fontSize: 15),
        //   ),
        //   const SizedBox(height: 20),
        // ],

        // ── NEW: audio file picker ──
        if (["308", "310"].contains(_karyakramValue) && _isEditable) ...[
          Text(
            Statics.getLabel('ChooseAudioFile'),
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: _pickAudioFile,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.audiotrack_rounded, color: primaryColor),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedAudioFile?.name ?? _existingAudioName ?? Statics.getLabel('TapToChooseFile'), // CHANGED
                            style: TextStyle(
                              fontSize: 14,
                              color: (_selectedAudioFile == null && _existingAudioName == null) ? Colors.grey.shade600 : Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.upload_file_rounded, color: primaryColor, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
              if (_selectedAudioFile != null || _existingAudioName != null)
                IconButton(
                    onPressed: () async {
                      final _res = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(Statics.getLabel("alert")),
                            content: Text(Statics.getLabel("ToDeleteFile")),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(Statics.getLabel("ConfirmationYes"))),
                              TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(Statics.getLabel("ConfirmationNo"))),
                            ],
                          );
                        },
                      );

                      if (_res) {
                        _selectedAudioFile = null;
                        _existingAudioName = null;
                      }
                      setState(() {});
                    },
                    icon: Icon(Icons.delete_forever_rounded, color: Colors.red))
            ],
          ),
          const SizedBox(height: 8),
          Text(
            Statics.getLabel('AddAudioLink').replaceAll(
                '{Audio}',
                _karyakram?.any((e) => e.staticID == 309) == true
                    ? Statics.getLabel('File')
                    : (_karyakram?.firstWhere((e) => e.staticID.toString() == _karyakramValue.toString()).codeForDisplay.toString().split(" ").last ?? Statics.getLabel("Geet"))),
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _linkController,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                hintText: Statics.getLabel("AudioUrl").replaceAll(
                    '{Audio}',
                    _karyakram?.any((e) => e.staticID == 309) == true
                        ? Statics.getLabel('File')
                        : (_karyakram?.firstWhere((e) => e.staticID.toString() == _karyakramValue.toString()).codeForDisplay.toString().split(" ").last ?? Statics.getLabel("Geet"))),
                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    )),
                enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ))),
          ),
          const SizedBox(height: 26),
        ],

        // ── NEW: generic "any file" picker — only for karyakram 311 ──
        if (_karyakramValue == '311' && _isEditable) ...[
          Text(
            Statics.getLabel('chooseFile'), // NEW LABEL — please add to your labels source
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: _pickAnyaFile,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.attach_file_rounded, color: primaryColor),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedAnyaFile?.name ?? _existingAnyaFileName ?? Statics.getLabel('TapToChooseFile'),
                            style: TextStyle(
                              fontSize: 14,
                              color: (_selectedAnyaFile == null && _existingAnyaFileName == null) ? Colors.grey.shade600 : Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.upload_file_rounded, color: primaryColor, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
              if (_selectedAnyaFile != null || _existingAnyaFileName != null)
                IconButton(
                    onPressed: () async {
                      final _res = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(Statics.getLabel("alert")),
                            content: Text(Statics.getLabel("ToDeleteFile")),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(Statics.getLabel("ConfirmationYes"))),
                              TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(Statics.getLabel("ConfirmationNo"))),
                            ],
                          );
                        },
                      );

                      if (_res) {
                        _selectedAnyaFile = null;
                        _existingAnyaFileName = null;
                      }
                      setState(() {});
                    },
                    icon: Icon(Icons.delete_forever_rounded, color: Colors.red))
            ],
          ),
          const SizedBox(height: 8),
          Text(
            Statics.getLabel('AddAudioLink').replaceAll('{Audio}', Statics.getLabel('File')),
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _linkController,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                hintText: Statics.getLabel("AudioUrl").replaceAll('{Audio}', Statics.getLabel('File')),
                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    )),
                enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ))),
          ),
          const SizedBox(height: 26),
        ],

        const SizedBox(height: 6),

        Text(
          Statics.getLabel('SubjectTxt'),
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        if (!_isEditable) ...[
          // ── VIEW MODE: render saved HTML as formatted rich text ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: flutter_html.Html(
              data: _htmlToPlainText(_originalHtmlFromApi).isNotEmpty ? _originalHtmlFromApi : '—',
              style: {
                "body": flutter_html.Style(
                  margin: flutter_html.Margins.zero,
                  padding: flutter_html.HtmlPaddings.zero,
                  fontSize: flutter_html.FontSize(15),
                ),
              },
            ),
            //_htmlToPlainText(_topicController.text).isNotEmpty ? _htmlToPlainText(_topicController.text) : '—',
          ),
        ] else ...[
          // ── EDIT MODE: Quill rich text editor ──
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                quill.QuillSimpleToolbar(
                  configurations: quill.QuillSimpleToolbarConfigurations(
                      controller: _topicQuillController,
                      showFontFamily: false,
                      showFontSize: false,
                      showSubscript: false,
                      showSuperscript: false,
                      showSearchButton: false,
                      showClearFormat: false,
                      showCodeBlock: false,
                      showQuote: false,
                      showColorButton: false,
                      showBackgroundColorButton: false,
                      showAlignmentButtons: true),
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                //   child: Listener(
                //     behavior: HitTestBehavior.translucent,
                //     onPointerDown: (event) {
                //       // NEW — record where the drag starts, every time, regardless of focus
                //       _topicDragStartY = event.position.dy;
                //       _topicDragStartOffset = _topicEditorScrollController.hasClients ? _topicEditorScrollController.offset : 0;
                //     },
                //     onPointerMove: (event) {
                //       if (_topicEditorFocusNode.hasFocus) return; // focused → let Quill's own scroll/selection handle it
                //       if (!_topicEditorScrollController.hasClients) return;
                //
                //       final position = _topicEditorScrollController.position;
                //       final dy = event.position.dy - _topicDragStartY;
                //       print("dy: $dy, hasClients: ${_topicEditorScrollController.hasClients}");
                //       final newOffset = (_topicDragStartOffset - dy).clamp(
                //         position.minScrollExtent,
                //         position.maxScrollExtent,
                //       );
                //       _topicEditorScrollController.jumpTo(newOffset);
                //       print("maxScrollExtent: ${position.maxScrollExtent}, pixels after jump: ${_topicEditorScrollController.position.pixels}"); // NEW
                //     },
                //     child: quill.QuillEditor.basic(
                //       focusNode: _topicEditorFocusNode,
                //       scrollController: _topicEditorScrollController,
                //       configurations: quill.QuillEditorConfigurations(
                //         controller: _topicQuillController,
                //         placeholder: Statics.getLabel('SubjectTxtSubText'),
                //         padding: EdgeInsets.zero,
                //         scrollable: true,
                //         expands: false,
                //         minHeight: 120,
                //         maxHeight: 260,
                //       ),
                //     ),
                //   ),
                // ),

                Container(
                  height: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Scrollbar(
                    controller: _quillScrollController,
                    interactive: true,
                    thumbVisibility: true,
                    child: quill.QuillEditor.basic(
                      scrollController: _quillScrollController,
                      focusNode: _quillFocusNode,
                      configurations: quill.QuillEditorConfigurations(
                          controller: _topicQuillController, placeholder: Statics.getLabel('SubjectTxtSubText'), padding: EdgeInsets.zero, expands: false, scrollable: true),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),

        // ── Search / Reset buttons ──
        !_isEditable
            ? Center(
                child: Text(
                Statics.getLabel('UnEditable'),
                style: TextStyle(color: Colors.purple),
              ))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Theme.of(context).primaryTextTheme.labelMedium?.color ?? Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      onPressed: _isSaving ? null : _saveShaakhaPustika,
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(
                              Statics.getLabel('Submit'),
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                  if (_incomingPkId == null) ...[
                    const SizedBox(width: 14),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                      onPressed: () async {
                        setState(() {
                          _karyakramValue = null;
                          _selectedMonth = null;
                          _selectedYear = null;
                          _selectedVayogat = [];
                        });
                        await geoctrl.loadHierarchyForUser();
                      },
                      child: Text(
                        Statics.getLabel('clear'),
                        style: const TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ),
                  ]
                ],
              ),
      ],
    );
  }

// ── Vayogat multi-select dropdown (native, stays open on tap) ──
  Widget _vayogatMultiSelectDropdown(Color primaryColor) {
    final selectedLabels = _vayogat!.where((v) => _selectedVayogat.contains(v.staticID.toString())).map((v) => v.codeForDisplay ?? '').join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: _boxedDecoration(hint: Statics.getLabel('Vayogat')),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: primaryColor),
          // Show joined selected labels instead of a single value
          hint: Text(
            selectedLabels.isEmpty ? Statics.getLabel('Vayogat') : selectedLabels,
            style: TextStyle(
              fontSize: 15,
              color: selectedLabels.isEmpty ? Colors.grey.shade600 : Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          onChanged: (_) {},
          // handled inside each item via checkbox/InkWell
          selectedItemBuilder: (context) {
            return _vayogat!.map((item) {
              return Text(
                selectedLabels.isEmpty ? '' : selectedLabels,
                overflow: TextOverflow.ellipsis,
              );
            }).toList();
          },
          items: _vayogat!.map((item) {
            final id = item.staticID.toString();

            return DropdownMenuItem<String>(
              value: id,
              enabled: true,
              child: StatefulBuilder(
                builder: (context, menuSetState) {
                  final isChecked = _selectedVayogat.contains(id);

                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isChecked) {
                          _selectedVayogat.remove(id);
                        } else {
                          _selectedVayogat.add(id);
                        }
                      });
                      menuSetState(() {});
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          activeColor: primaryColor,
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                _selectedVayogat.add(id);
                              } else {
                                _selectedVayogat.remove(id);
                              }
                            });
                            menuSetState(() {});
                          },
                        ),
                        Flexible(
                          child: Text(
                            item.codeForDisplay ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _openLink() async {
    if (_isOpeningLink) return; // NEW — prevent double-taps while already loading

    final link = _linkController.text.trim();

    if (link.isEmpty) return;

    final uri = Uri.tryParse(link);

    if (uri == null || !uri.hasScheme || !(uri.scheme == 'http' || uri.scheme == 'https')) {
      _showLinkErrorDialog(Statics.getLabel('UrlNotValid'));
      return;
    }

    setState(() => _isOpeningLink = true); // NEW — show loader

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        _showLinkErrorDialog(Statics.getLabel('UrlException'));
      }
    } catch (e) {
      if (mounted) {
        _showLinkErrorDialog(Statics.getLabel('UrlException'));
      }
    } finally {
      if (mounted) {
        setState(() => _isOpeningLink = false); // NEW — hide loader regardless of outcome
      }
    }
  }

  void _showLinkErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(Statics.getLabel('Problem')),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text(Statics.getLabel('OK')),
            ),
          ],
        );
      },
    );
  }

  Widget _clickOnLink() {
    final link = _linkController.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Statics.getLabel('GeetUrl'),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.link,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  link.isNotEmpty ? link : Statics.getLabel('GeetUrlNotExist'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: link.isNotEmpty ? Colors.blue.shade700 : Colors.grey.shade600,
                    decoration: link.isNotEmpty ? TextDecoration.underline : TextDecoration.none,
                  ),
                ),
              ),
              if (link.isNotEmpty) ...[
                const SizedBox(width: 10), // NEW — small gap so the spinner doesn't hug the text
                if (_isOpeningLink) ...[
                  // NEW — loader shown while the link is resolving/launching
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ] else ...[
                  InkWell(
                    onTap: _openLink,
                    child: Icon(
                      Icons.open_in_new,
                      size: 18,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _audioPlaySection(Color primaryColor) {
    final hasAudio = _localAudioPath != null && _localAudioPath!.trim().isNotEmpty; // NEW — guards both null and empty string

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(Statics.getLabel('AudioFile'), Icons.audiotrack_rounded, primaryColor),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(
                hasAudio ? Icons.music_note_rounded : Icons.music_off_rounded, // NEW — visual cue when absent
                color: hasAudio ? primaryColor : Colors.grey.shade500,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hasAudio ? Statics.getLabel('ClickBtnToHearAudioFile') : Statics.getLabel('AudioFileNotAvailable'), // NEW — shown when there's no file
                  style: TextStyle(
                    fontSize: 14,
                    color: hasAudio ? Colors.black87 : Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasAudio) // NEW — button only rendered when audio actually exists
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AudioPlayerDialog(
                        title: Statics.getLabel('ShakhaPustika'),
                        audioUrl: _localAudioPath!,
                        isLocalFile: true,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 26),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

// ── Month picker field ──
  Widget _monthPickerField(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Statics.getLabel('selectMonth'),
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<int>(
          decoration: _boxedDecoration(hint: Statics.getLabel('SankalpCompletionMonth')),
          isExpanded: true,
          value: _selectedMonth,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: primaryColor),
          items: List.generate(12, (i) => i + 1)
              .map((m) => DropdownMenuItem<int>(
                    value: m,
                    child: Text(monthNameMarathi(m), style: const TextStyle(fontSize: 15)),
                  ))
              .toList(),
          onChanged: (v) {
            setState(() {
              _selectedMonth = v;
            });
          },
        ),
      ],
    );
  }

// ── Year picker field ──
  Widget _yearPickerField(Color primaryColor) {
    final int startYear = 2023;
    final int endYear = DateTime.now().year + 2;
    final List<int> years = List.generate(
      endYear - startYear + 1,
      (i) => startYear + i,
    );
    // final List<int> years = List.generate(15, (i) => DateTime.now().year - 13 + i);
    // final List<int> years = List.generate(
    //   2028 - 2023 + 1,
    //   (i) => 2023 + i,
    // );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Statics.getLabel('selectYear'),
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<int>(
          decoration: _boxedDecoration(hint: Statics.getLabel('SankalpCompletionYear')),
          isExpanded: true,
          value: _selectedYear,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: primaryColor),
          items: years
              .map((y) => DropdownMenuItem<int>(
                    value: y,
                    child: Text('$y', style: const TextStyle(fontSize: 15)),
                  ))
              .toList(),
          onChanged: (v) {
            setState(() {
              _selectedYear = v;
            });
          },
        ),
      ],
    );
  }

  // ── single Month-Year picker field ──
  Widget _monthYearPickerField(Color primaryColor) {
    final displayText = _selectedMonthYear == null ? '' : '${monthNameMarathi(_selectedMonthYear!.month)} ${_selectedMonthYear!.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Statics.getLabel('SelectMonthYear'),
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
        ),
        //const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: _showMonthYearPickerDialog,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    displayText.isEmpty ? Statics.getLabel('Filters') : displayText,
                    style: TextStyle(
                      fontSize: 15,
                      color: displayText.isEmpty ? Colors.grey.shade600 : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.calendar_month_rounded, color: primaryColor, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── dialog with Month + Year dropdowns ──
  Future<void> _showMonthYearPickerDialog() async {
    int selectedMonth = _selectedMonthYear?.month ?? DateTime.now().month;
    int selectedYear = _selectedMonthYear?.year ?? DateTime.now().year;

    final List<int> years = List.generate(15, (i) => DateTime.now().year - 10 + i);

    await showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(Statics.getLabel('SelectMonthYear')),
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: selectedMonth,
                      items: List.generate(12, (i) => i + 1)
                          .map((m) => DropdownMenuItem<int>(
                                value: m,
                                child: Text(monthNameMarathi(m)),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setDialogState(() => selectedMonth = v);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: selectedYear,
                      items: years
                          .map((y) => DropdownMenuItem<int>(
                                value: y,
                                child: Text('$y'),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setDialogState(() => selectedYear = v);
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogCtx).pop(),
                  child: Text(Statics.getLabel('Cancel')),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedMonthYear = DateTime(selectedYear, selectedMonth);
                    });
                    Navigator.of(dialogCtx).pop();
                  },
                  child: Text(Statics.getLabel('OK')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // Geo dropdown section — logic unchanged, styling enhanced
  // ─────────────────────────────────────────────────────────────────────
  Widget _dropDownSection(GeoHierarchyController ctrl) {
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionPanelList(
            elevation: 0,
            expandedHeaderPadding: EdgeInsets.zero,
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _isExpanded = isExpanded;
              });
            },
            children: [
              // if ((int.parse(Statics.userDetails['LevelID']) > 1))
              ExpansionPanel(
                backgroundColor: Colors.transparent,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.filter_alt_rounded, color: primaryColor),
                    title: Text(
                      Statics.getLabel('Filters'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  );
                },
                body: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 6),
                  child: Column(
                    children: [
                      GeoDropdownWidget(
                        level: GeoLevel.Mahaanagar,
                        title: 'Mahaanagar',
                        controller: ctrl,
                        decoration: _boxedDecoration(hint: Statics.getLabel('Mahaanagar')),
                        validator: (v) {
                          if (v == null || v!.isEmpty) return (Statics.getLabel('GeoUnitValidationMessage'));
                          return null;
                        },
                      ),
                      if (ctrl.hasItems(GeoLevel.Vibhaag)) ...[
                        const SizedBox(height: 14),
                        GeoDropdownWidget(
                          level: GeoLevel.Vibhaag,
                          title: 'Vibhaag',
                          controller: ctrl,
                          decoration: _boxedDecoration(hint: Statics.getLabel('Vibhaag')),
                          validator: (v) {
                            if (v == null || v!.isEmpty) return (Statics.getLabel('GeoUnitValidationMessage'));
                            return null;
                          },
                        ),
                      ],
                      // if (ctrl.hasItems(GeoLevel.Bhaag)) ...[
                      //   const SizedBox(height: 14),
                      //   GeoDropdownWidget(
                      //     level: GeoLevel.Bhaag,
                      //     title: 'Bhaag',
                      //     controller: ctrl,
                      //     decoration: _boxedDecoration(hint: Statics.getLabel('Bhaag')),
                      //     validator: (v) {
                      //       if (v == null || v!.isEmpty) return (Statics.getLabel('SelectBhaagValidationMessage'));
                      //       return null;
                      //     },
                      //   ),
                      // ],
                    ],
                  ),
                ),
                isExpanded: _isExpanded,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
