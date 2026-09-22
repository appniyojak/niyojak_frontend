import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_delta_from_html/parser/html_to_delta.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niyojak_prod/screens/shakha_pustika/sangraha_shkha_pustika_screen.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/globals.dart';
import '../../helpers/static_data.dart' as Statics;
import '../../models/request_model/shakha_pustika_list_requestmodel.dart';
import '../../models/response_model/offline_shaakhaa_pustika_resp_model.dart';
import '../../providers/bals.dart';
import '../../utils/stable_geounit_class.dart'; // NEW — shared "is this file downloaded / where does it live" logic
import '../home_screen/home_screen.dart';
import 'audio_helper.dart';
import 'download_play_cell_widget.dart';
import 'view_pustika_screen.dart'; // NEW — shared public play dialog (same file used by SangrahaShkhaPustikaScreen)

class ShakhaPustika extends StatefulWidget {
  static var routeName = '/shakhapustika';

  @override
  State<ShakhaPustika> createState() => _ShakhaPustika();
}

class _ShakhaPustika extends State<ShakhaPustika> with TickerProviderStateMixin {
  bool _isExpanded = false;
  final _controller = createGeoController();
  List<StaticMasterBAL?>? _vayogat;
  String? _vayogatValue;
  List<String> _selectedVayogat = [];

  // ── Karyakram dropdown state ─────────────────────────────────────
  // String? _karyakramValue;

  // ── single Month-Year picker state ─────────────────────────────

  int? _selectedMonth;
  int? _selectedYear;
  bool _isSearched = false;
  int levelId = 0;

  // ── NEW: extra text fields ─────────────────────────────────────
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  // ── NEW: audio file picker state ────────────────────────────────
  PlatformFile? _selectedAudioFile;

  // ── UI constants ─────────────────────────────────────────────────
  static const double _cardRadius = 16;

  final AudioPlayer _audioPlayer = AudioPlayer();

  int? currentYear;
  int? currentMonth;
  List<OfflineShaakhaPustika> _apiList = [];
  bool _isSearching = false;
  int? geoUnitId;
  int cUserId = 0;
  List<StaticMasterBAL>? _karyakram;
  String kFileBaseUrl = Statics.baseUrl;
  TabController? _tabController;

// ── Dummy result data for the table ──

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    //await Statics.getUpdateShakhaPustikaList;
    _tabController = new TabController(length: 2, vsync: this);
    _tabController?.addListener(_handleTabChange);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _initData());
  }

  @override
  void dispose() {
    _topicController.dispose();
    _remarkController.dispose();
    _audioPlayer.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _vayogatValue = pref.getString("selectedVayogat");

    final dm = await MyAppGlobals.getLevelLDB();
    final _userData = await MyAppGlobals.getUserDataDB();
    print("Printing levelid:${dm.levelID}");
    levelId = dm.levelID ?? 0;
    await _controller.initialize(dm);

    await populateDropdown();
    currentYear = DateTime.now().year;
    currentMonth = DateTime.now().month;
    //if (widget.hitApiWtoDropdown) _search(_controller.deepestSelectedGeoUnitId, context);
    _selectedYear = currentYear;
    _selectedMonth = currentMonth;
    List<UserDataBAL> user = await Statics.getUserDataLDB();
    //await Statics.populateUserDetailsMap();
    print("userid:${user.map((e) => e.swayamsevakID)}");
    cUserId = user.first.swayamsevakID ?? 0;
    if (levelId > 7 && levelId != 13) {
      _tabController?.animateTo(1);
    } else if (levelId == 1 || (_vayogatValue != null && _vayogatValue!.isNotEmpty)) {
      // _vayogatValue = (_userData.vayogatid ?? 0).toString();
      await _searchShaakhaPustika(karyakramval: -1);
    } else {
      _tabController?.animateTo(1);
    }
  }

  void _handleTabChange() {
    if (mounted) {
      setState(() {}); // Rebuilds to update the PopScope's allowed status
    }
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    var data = await Statics.getStaticLDB('ShaakhaaVayogat');
    var data1 = await Statics.getStaticLDB('ShaakhaaFrequency');
    var data2 = await Statics.getKrayakramList();
    if (!mounted) return;
    setState(() {
      _vayogat = data;
      _karyakram = data2;
      // _frequency = data1;
    });

    log("_vayogat?.length >>>>>> ${_vayogat?.length.toString()}");
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

  String _extractBodyContent(String html) {
    final match = RegExp(r'<body[^>]*>([\s\S]*)<\/body>', caseSensitive: false).firstMatch(html);
    return match != null ? match.group(1)!.trim() : html;
  }

  // Future<void> _playAudio(String url) async {
  //   print("inside play audio$url");
  //   try {
  //     await _audioPlayer.stop();
  //     await _audioPlayer.play(UrlSource(url));
  //   } catch (e) {
  //     log('Audio play error: $e');
  //   }
  // }

  // ── NEW: pick an audio file from the device ─────────────────────
  Future<void> _pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedAudioFile = result.files.first;
      });
      log("Audio selected: ${_selectedAudioFile?.name}");
    }
  }

  void _showValidationPopup(String validationText) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            Statics.getLabel('Suchna'),
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
          ),
          content: Text(
            Statics.getLabel(validationText, returnKey: true),
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              //style: ButtonStyle(backgroundColor: Colors.purple, foregroundColor: Colors.white),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _searchShaakhaPustika({int? karyakramval}) async {
    bool isVibhagLevelUser = false;
    _apiList = [];
    geoUnitId = int.tryParse(_controller.deepestSelectedGeoUnitId.toString());
    if (levelId != 1 && (_vayogatValue == null || _vayogatValue == '')) {
      Statics.showToast(Statics.getLabel('VayogatValidationMessage'));
      return;
    }
    if (_selectedMonth == null || _selectedYear == null) {
      Statics.showToast(Statics.getLabel('ChooseMonthYearValidation'));
      return;
    }

    setState(() => _isSearching = true);
    if (levelId <= 8 || levelId == 13) {
      isVibhagLevelUser = true;
    }
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("selectedVayogat", _vayogatValue ?? '');

      final requestModel = GetShaakhaPustikaListRequest(
        cuserid: cUserId,
        geounitid: isVibhagLevelUser ? 0 : geoUnitId ?? 0,
        karyakramid: -1,
        //int.tryParse(_karyakramValue.toString()) ?? -1,
        monthno: _selectedMonth!,
        yearno: _selectedYear!,
        vayogatid: int.tryParse(_vayogatValue ?? '') ?? 0,
      );

      final respData = await Statics.getUpdateShakhaPustikaList(requestModel);

      if (!mounted) return;

      // log((respData?.length).toString());

      if (respData != null) {
        setState(() {
          _apiList.addAll(respData);
        });
        _tabController?.animateTo(0);
        if (respData.isEmpty) {
          Statics.showToast(Statics.getLabel('NoInfoText'));
        }
      } else {
        Statics.showToast(Statics.getLabel('ProblemGettingInfoMsg'));
      }
    } catch (e) {
      log("Error fetching shaakha pustika list: $e");
      if (mounted) {
        Statics.showToast(Statics.getLabel('SomethingWentWrong'));
      }
    } finally {
      if (mounted)
        setState(() {
          _isSearching = false;
          _isSearched = true;
        });
    }
  }

//-------------------- MAIN BUILD -------------------//
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    // 2. Determine if the system back button is allowed to close/pop the screen.
    // It should pop normally if it's a single screen OR if the user is already on the first tab (index 0).

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // If the system already handled the pop (canPop was true), do nothing.
        if (didPop) return;

        // If canPop was false, it means we are on the multi-tab layout and on the second tab (index 1).
        // Move back to the first tab instead of exiting.
        if (_tabController?.index == 1) {
          _tabController?.animateTo(0);
        } else {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: Text(
            Statics.getLabel('ShakhaPustika'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              physics: NeverScrollableScrollPhysics(),
              unselectedLabelStyle: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
              labelStyle: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event, size: 18),
                      SizedBox(width: 10),
                      Text(
                        Statics.getLabel("Pustika"),
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.globe,
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Text(
                        Statics.getLabel("Filters"),
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ]),
          actions: [
            if (levelId == 7)
              IconButton(
                onPressed: () async {
                  final result = await Navigator.of(context).pushNamed(SangrahaShkhaPustikaScreen.routeName);
                  if (result == true && mounted) {
                    await _searchShaakhaPustika(); // refresh table with same filters
                  }
                },
                icon: const Icon(Icons.add),
              )
          ],
        ),
        drawer: AppDrawer(),
        body: ChangeNotifierProvider.value(
          value: _controller,
          child: Consumer<GeoHierarchyController>(
            builder: (_, ctrl, __) {
              // final bhaagSelected = (ctrl.getSelectedValue(GeoLevel.Bhaag)?.isNotEmpty ?? false);
              final bhaagSelected = (ctrl.getSelectedValue(GeoLevel.Bhaag)?.isNotEmpty ?? false);
              return TabBarView(
                controller: _tabController, // make sure this is passed explicitly
                children: [
                  // ── Tab 2: Results ──
                  _buildResultsTab(),

                  // ── Tab 1: Filters ──
                  SingleChildScrollView(
                    padding: EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (levelId > 8 && levelId != 13) _sectionCard(child: _dropDownSection(ctrl)),
                        const SizedBox(height: 16),
                        _sectionCard(child: _karyakramSection(primaryColor, ctrl, bhaagSelected)),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildResultsTab() {
    if (!_isSearched) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            Statics.getLabel('SearchToSeeResults') ?? 'Search to see results',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return _isSearching ? const Center(child: CircularProgressIndicator()) : _buildResults(_apiList);
  }

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

  /// Entry point — decides table vs card layout.
  Widget _buildResults(List<OfflineShaakhaPustika> karyakramList) {
    final matches = _vayogat?.where((e) => e?.staticID.toString() == _vayogatValue);

    final code = matches != null && matches.isNotEmpty ? matches.first?.codeForDisplay : null;

    if (Statics.levelId != 7) {
      return ViewPustikaScreen(karyakramList: karyakramList, vayogatVal: code);
    }
    return SingleChildScrollView(padding: EdgeInsets.all(14), child: _buildResultsTable(karyakramList));
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      isDense: false,
      filled: true,
      fillColor: const Color(0xFFF9FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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
  Widget _karyakramSection(Color primaryColor, GeoHierarchyController ctrl, bool bhagSelected) {
    final isvibhagSelectionApplied = levelId == 9 || levelId == 10 || levelId == 11;
    return Stack(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Statics.getLabel('KaryakramHeading'), Icons.event_note_rounded, primaryColor),
          const SizedBox(height: 16),

          /* // ── कार्यक्रम निवडा dropdown ──
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
                // _selectedMonth = DateTime.now().month;
                // _selectedYear = DateTime.now().year;
                // _vayogatValue = null;
              });
              log("karyajkramchosing:$_karyakramValue");
            },
          ),

          const SizedBox(height: 20),*/

          Text(
            Statics.getLabel('ChooseMonthYearValidation'),
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
          //if (_vayogat != null) _vayogatMultiSelectDropdown(primaryColor),
          if (_vayogat != null && levelId != 1)
            DropdownButtonFormField(
              decoration: _boxedDecoration(label: Statics.getLabel('Vayogat')),
              isExpanded: true,
              isDense: false,
              value: _vayogatValue == "" ? null : _vayogatValue,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: primaryColor),
              items: _vayogat!.map((bg) => DropdownMenuItem(value: bg?.staticID.toString(), child: Text(bg?.codeForDisplay ?? "--"))).toList(),
              onChanged: (value) {
                setState(() {
                  _vayogatValue = value;
                });
              },
            ),

          const SizedBox(height: 20),

          const SizedBox(height: 6),

          // ── Search / Reset buttons ──
          Row(
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
                  onPressed: _searchShaakhaPustika,
                  child: _isSearching
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          Statics.getLabel('Search'),
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                onPressed: () {
                  setState(() {
                    // _karyakramValue = null;
                    _selectedMonth = DateTime.now().month;
                    _selectedYear = DateTime.now().year;
                    _vayogatValue = null;
                    _isSearched = false;
                    _apiList.clear();
                    ctrl.loadHierarchyForUser();
                  });
                },
                child: Text(
                  Statics.getLabel('clear'),
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
            ],
          ),
        ],
      ),
      if (!bhagSelected && isvibhagSelectionApplied)
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _showValidationPopup("SelectBhaagValidationMessage"),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
    ]);
  }

  Widget _buildResultsTable(List<OfflineShaakhaPustika> karyakramList) {
    final primaryColor = Theme.of(context).primaryColor;
    final _showDownloadColumn = levelId == 9 || levelId == 10 || levelId == 11;
    final containsGeet = karyakramList.any((e) => e.karyakramid != 309);

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //_sectionTitle(Statics.getLabel('Result'), Icons.table_chart_rounded, primaryColor),
        const SizedBox(height: 12),
        if (karyakramList.isEmpty) ...[
          Container(
            alignment: Alignment.center,
            height: MediaQuery.sizeOf(context).height * 0.75,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(Statics.getLabel('NoInfoText')),
          )
        ] else ...[
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              Statics.getLabel('KeepScrolling'),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                ),
                child: DataTable(
                  border: TableBorder.all(color: Colors.grey.shade300),
                  horizontalMargin: 8,
                  headingRowColor: MaterialStateProperty.all(primaryColor),
                  dataRowColor: MaterialStateProperty.all(Colors.white),
                  columnSpacing: 14,
                  columns: [
                    if (karyakramList.isNotEmpty) DataColumn(label: _tableHeaderCell(Statics.getLabel('Information'))),
                    if (containsGeet) DataColumn(label: _tableHeaderCell(Statics.getLabel('Geet'))),
                    DataColumn(label: _tableHeaderCell(Statics.getLabel('karyakramWiseSeq'))),
                    DataColumn(label: _tableHeaderCell(Statics.getLabel('VayogatCode'))),
                    DataColumn(label: _tableHeaderCell(Statics.getLabel('tapshil'))),
                    // if (_showDownloadColumn) DataColumn(label: _tableHeaderCell(Statics.getLabel('downloadBtn'))),
                  ],
                  rows: karyakramList.map((item) {
                    final monthLabel = (item.monthno! >= 1 && item.monthno! <= 12) ? monthNameMarathi(item.monthno!) : '-';
                    final content = item.subjecttext ?? '-';
                    final rawRelativePath = item.filepath ?? '';
                    final karyakramValuee = item.karyakramid ?? 0;
                    final audioUrl = _resolveFileUrl(rawRelativePath); // still used for the disk-check filename derivation
                    // print("Resolved file URL: ${_resolveFileUrl(item.filepath ?? '-')}");
                    return DataRow(
                      cells: [
                        if (karyakramList.isNotEmpty) DataCell(_tableInfoCellFromItem(item, karyakramList)), // CHANGED — accepts item directly
                        if (containsGeet)
                          DataCell(DownloadPlayCell(
                            pkid: item.pkid!,
                            tablename: 'shaakhapustika',
                            remoteRelativePath: rawRelativePath,
                            resolvedUrlForDiskCheck: audioUrl,
                            title: content,
                            fromDataTable: true,
                          )),
                        DataCell(_tableDataCell(item.karyakramname ?? '-')),
                        DataCell(_tableDataCell(item.vayogatname ?? '-')),

                        DataCell(SizedBox(width: 100, child: _tableVishayCell(content))),
                        //if (_showDownloadColumn) DataCell(_tableDownloadCell(audioUrl, true, content)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ]
      ],
    );
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

  Widget _tableInfoCellFromItem(OfflineShaakhaPustika item, List<OfflineShaakhaPustika> karyakramList) {
    final primaryColor = Theme.of(context).primaryColor;
    final bool isAudioKaryakram = item.karyakramid != 309;
    final String audioUrl = _resolveFileUrl(item.filepath ?? '');
    final bool hasAudioFile = isAudioKaryakram && audioUrl.isNotEmpty;
    final matches = _vayogat?.where((e) => e?.staticID.toString() == _vayogatValue);

    final code = matches != null && matches.isNotEmpty ? matches.first?.codeForDisplay : null;
    Future<void> goToInfoScreen(String selectedAction) async {
      dynamic result; // NEW — capture what SangrahaShkhaPustikaScreen pops back

      if (selectedAction == "view") {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewPustikaScreen(showAppBar: true, vayogatVal: code, karyakramList: karyakramList)));
        return;
      }

      if (hasAudioFile) {
        // गीत (audio) rows — check the shared helper before navigating.
        final downloaded = await AudioFileHelper.isDownloaded(audioUrl);
        if (!downloaded) {
          _showValidationPopup("DownloadFileValidation");
          return;
        }
        final localPath = await AudioFileHelper.getLocalFilePath(audioUrl);
        if (!mounted) return;
        result = await Navigator.of(context).pushNamed(
          SangrahaShkhaPustikaScreen.routeName,
          arguments: {
            'isEditable': selectedAction == 'edit',
            'pkid': item.pkid,
            'localAudioPath': localPath,
          },
        );
      } else {
        result = await Navigator.of(context).pushNamed(
          SangrahaShkhaPustikaScreen.routeName,
          arguments: {
            'isEditable': selectedAction == 'edit',
            'pkid': item.pkid,
          },
        );
      }

      // NEW — if the edit/save screen returned true, re-run the search
      // with the same filters so the table reflects the latest data.
      if (result == true && mounted) {
        await _searchShaakhaPustika();
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Center(
        child: (item.canupdate == 1) // CHANGED — gate edit option by canupdate
            ? PopupMenuButton<String>(
                icon: Icon(Icons.info_outline, color: primaryColor, size: 20),
                tooltip: Statics.getLabel('ViewMenu'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onSelected: goToInfoScreen,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 8),
                        Text(Statics.getLabel('EditMenu')),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility_outlined, size: 18),
                        SizedBox(width: 8),
                        Text(Statics.getLabel('ViewMenu')),
                      ],
                    ),
                  ),
                ],
              )
            : InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewPustikaScreen(showAppBar: true, vayogatVal: code, karyakramList: karyakramList))),
                child: Icon(Icons.info_outline, color: primaryColor, size: 20),
              ),
      ),
    );
  }

  Widget _tableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
      ),
    );
  }

  Widget _tableDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  Widget _tableVishayCell(String text) {
    //final bool hasAudio = audioUrl.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text.isEmpty ? '---' : _htmlToPlainText(text),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }

// ── Vayogat multi-select dropdown (native, stays open on tap) ──
  Widget _vayogatMultiSelectDropdown(Color primaryColor) {
    final selectedLabels = _vayogat!.where((v) => _selectedVayogat.contains(v?.staticID.toString())).map((v) => v?.codeForDisplay ?? '').join(', ');

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
            final id = item?.staticID.toString();

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
                          _selectedVayogat.add(id!);
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
                                _selectedVayogat.add(id!);
                              } else {
                                _selectedVayogat.remove(id);
                              }
                            });
                            menuSetState(() {});
                          },
                        ),
                        Flexible(
                          child: Text(
                            item?.codeForDisplay ?? '',
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

// ── Month picker field ──
  Widget _monthPickerField(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Statics.getLabel('SelectMonth'),
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
    // final List<int> years = List.generate(7, (i) => DateTime.now().year - 3 + i);
    // final List<int> years = List.generate(
    //   2028 - 2023 + 1,
    //   (i) => 2023 + i,
    // );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Statics.getLabel('SelectYear'),
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
                    spacing: 12,
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
                      if (ctrl.hasItems(GeoLevel.Vibhaag))
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
                      if (ctrl.hasItems(GeoLevel.Bhaag))
                        GeoDropdownWidget(
                          level: GeoLevel.Bhaag,
                          title: 'Bhaag',
                          controller: ctrl,
                          decoration: _boxedDecoration(hint: Statics.getLabel('Bhaag')),
                          validator: (v) {
                            if (v == null || v!.isEmpty) return (Statics.getLabel('SelectBhaagValidationMessage'));
                            return null;
                          },
                        ),
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
