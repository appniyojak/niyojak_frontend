import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_delta_from_html/parser/html_to_delta.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niyojak_prod/screens/shakha_pustika/sangraha_shkha_pustika_screen.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../../../utils/globals.dart';
import '../../helpers/media_downloader/media_downloader_helper.dart';
import '../../helpers/media_downloader/media_downloader_service.dart';
import '../../helpers/static_data.dart' as Statics;
import '../../models/request_model/shakha_pustika_list_requestmodel.dart';
import '../../models/response_model/offline_shaakhaa_pustika_resp_model.dart';
import '../../providers/bals.dart';
import '../../utils/stable_geounit_class.dart'; // NEW — shared "is this file downloaded / where does it live" logic
import '../home_screen/home_screen.dart';
import 'audio_helper.dart';
import 'audio_player_dialogue.dart'; // NEW — shared public play dialog (same file used by SangrahaShkhaPustikaScreen)

class ShakhaPustika extends StatefulWidget {
  static var routeName = '/shakhapustika';

  @override
  State<ShakhaPustika> createState() => _ShakhaPustika();
}

class _ShakhaPustika extends State<ShakhaPustika> with TickerProviderStateMixin {
  bool _isExpanded = false;
  final _controller = createGeoController();
  List<StaticMasterBAL>? _vayogat;
  String? _vayogatValue;
  List<String> _selectedVayogat = [];

  // ── Karyakram dropdown state ─────────────────────────────────────
  String? _karyakramValue;

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
    final dm = await MyAppGlobals.getLevelLDB();
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
    await _searchShaakhaPustika(karyakramval: -1);
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
    if (_vayogatValue == null || _vayogatValue == '') {
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
    final bool canPopScreen = _tabController?.index == 0;

    return PopScope(
      canPop: canPopScreen,
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: _isSearching ? const Center(child: CircularProgressIndicator()) : _buildResults(_apiList),
    );
  }

  // Fixed palette — one color per karyakram, cycles if there are ever more than 4.
  static const List<Color> _karyakramPalette = [
    Color(0xFF5C6BC0), // indigo
    Color(0xFF26A69A), // teal
    Color(0xFFEF6C51), // deep orange
    Color(0xFF8D6E63), // brown
  ];

  /// Entry point — decides table vs card layout.
  Widget _buildResults(List<OfflineShaakhaPustika> karyakramList) {
    if (Statics.levelId != 7) {
      return _buildResultsCards(karyakramList);
    }
    return _buildResultsTable(karyakramList);
  }

  Widget _buildResultsCards(List<OfflineShaakhaPustika> karyakramList) {
    if (karyakramList.isEmpty) {
      return Container(
        alignment: Alignment.center,
        height: MediaQuery.sizeOf(context).height * 0.75,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(Statics.getLabel('NoInfoText')),
      );
    }

    // Group items by karyakramid, preserving first-seen order so colors stay stable.
    final Map<int, List<OfflineShaakhaPustika>> grouped = {};
    for (final item in karyakramList) {
      final id = item.karyakramid ?? -1;
      grouped.putIfAbsent(id, () => []).add(item);
    }

    final groupIds = grouped.keys.toList();
    final Map<int, Color> colorForId = {
      for (int i = 0; i < groupIds.length; i++) groupIds[i]: _karyakramPalette[i % _karyakramPalette.length],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 8),
          child: Text(
            Statics.getLabel('KeepScrolling'),
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 12),
          itemCount: groupIds.length,
          itemBuilder: (context, index) {
            final id = groupIds[index];
            return _buildKaryakramGroupCard(id, grouped[id]!, colorForId[id]!);
          },
        ),
      ],
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
              value: _vayogatValue == "" ? null : _vayogatValue,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: primaryColor),
              items: _vayogat!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
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
                    _karyakramValue = null;
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

  Widget _buildKaryakramGroupCard(int karyakramId, List<OfflineShaakhaPustika> items, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: const BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(2)),
            ),
            child: Text(
              items.first.karyakramname?.isNotEmpty == true ? items.first.karyakramname! : 'Karyakram $karyakramId',
              style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14),
            ),
          ),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [
                    _buildItemTile(item, color),
                    if (item != items.last) Divider(height: 1, color: Colors.grey.shade200, indent: 14, endIndent: 14),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildItemTile(OfflineShaakhaPustika item, Color accentColor) {
    final monthLabel = (item.monthno != null && item.monthno! >= 1 && item.monthno! <= 12) ? _monthNameMarathi(item.monthno!) : '-';
    final content = item.subjecttext ?? '-';
    final rawRelativePath = item.filepath ?? '';
    final audioUrl = _resolveFileUrl(rawRelativePath);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(content, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    Text('${Statics.getLabel('month')}: $monthLabel', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    Text('${Statics.getLabel('VayogatCode')}: ${item.vayogatname ?? '-'}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
          if (_karyakramValue == '310') ...[
            const SizedBox(width: 8),
            SizedBox(
              width: 50,
              child: _DownloadPlayCell(
                pkid: item.pkid!,
                tablename: 'shaakhapustika',
                remoteRelativePath: rawRelativePath,
                resolvedUrlForDiskCheck: audioUrl,
                title: content,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultsTable(List<OfflineShaakhaPustika> karyakramList) {
    final primaryColor = Theme.of(context).primaryColor;
    final _showDownloadColumn = levelId == 9 || levelId == 10 || levelId == 11;

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
                  headingRowColor: MaterialStateProperty.all(primaryColor),
                  dataRowColor: MaterialStateProperty.all(Colors.white),
                  columnSpacing: 14,
                  columns: [
                    if (karyakramList.isNotEmpty) DataColumn(label: _tableHeaderCell(Statics.getLabel('ViewMenu'))),
                    if (_karyakramValue == '310') DataColumn(label: _tableHeaderCell(Statics.getLabel('DoDownload'))),
                    DataColumn(label: _tableHeaderCell(Statics.getLabel('month'))),
                    DataColumn(label: _tableHeaderCell(Statics.getLabel('VayogatCode'))),
                    DataColumn(label: _tableHeaderCell(Statics.getLabel('tapshil'))),
                    // if (_showDownloadColumn) DataColumn(label: _tableHeaderCell(Statics.getLabel('downloadBtn'))),
                  ],
                  rows: karyakramList.map((item) {
                    final monthLabel = (item.monthno! >= 1 && item.monthno! <= 12) ? _monthNameMarathi(item.monthno!) : '-';
                    final content = item.subjecttext ?? '-';
                    final rawRelativePath = item.filepath ?? '';
                    final audioUrl = _resolveFileUrl(rawRelativePath); // still used for the disk-check filename derivation
                    // print("Resolved file URL: ${_resolveFileUrl(item.filepath ?? '-')}");
                    return DataRow(
                      cells: [
                        if (karyakramList.isNotEmpty) DataCell(_tableInfoCellFromItem(item)), // CHANGED — accepts item directly
                        if (_karyakramValue == '310')
                          DataCell(_DownloadPlayCell(
                            pkid: item.pkid!,
                            tablename: 'shaakhapustika',
                            remoteRelativePath: rawRelativePath,
                            resolvedUrlForDiskCheck: audioUrl,
                            title: content,
                          )),
                        DataCell(_tableDataCell(monthLabel)),
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

  Widget _tableInfoCellFromItem(OfflineShaakhaPustika item) {
    final primaryColor = Theme.of(context).primaryColor;
    final bool isAudioKaryakram = _karyakramValue == '310';
    final String audioUrl = _resolveFileUrl(item.filepath ?? '');
    final bool hasAudioFile = isAudioKaryakram && audioUrl.isNotEmpty;

    Future<void> goToInfoScreen(String selectedAction) async {
      dynamic result; // NEW — capture what SangrahaShkhaPustikaScreen pops back

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
                onTap: () => goToInfoScreen('view'),
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
                    child: Text(_monthNameMarathi(m), style: const TextStyle(fontSize: 15)),
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
    final List<int> years = List.generate(15, (i) => DateTime.now().year - 10 + i);
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

  String _monthNameMarathi(int month) {
    var months = [
      Statics.getLabel('Jan'),
      Statics.getLabel('Feb'),
      Statics.getLabel('Mar'),
      Statics.getLabel('Apr'),
      Statics.getLabel('May'),
      Statics.getLabel('Jun'),
      Statics.getLabel('Jul'),
      Statics.getLabel('Aug'),
      Statics.getLabel('Sept'),
      Statics.getLabel('Oct'),
      Statics.getLabel('Nov'),
      Statics.getLabel('Dec'),
    ];
    return months[month - 1];
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
                      if (ctrl.hasItems(GeoLevel.Bhaag)) ...[
                        const SizedBox(height: 14),
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

enum _CellState { checking, notDownloaded, queuedOrDownloading, downloaded, failed }

class _DownloadPlayCell extends StatefulWidget {
  final int pkid;
  final String tablename;
  final String remoteRelativePath; // raw path as returned by the search API, e.g. "Files/shaakhapustika/xxx.mp4"
  final String resolvedUrlForDiskCheck; // _resolveFileUrl(remoteRelativePath) — only used to derive the local filename
  final String title;

  const _DownloadPlayCell({
    required this.pkid,
    required this.tablename,
    required this.remoteRelativePath,
    required this.resolvedUrlForDiskCheck,
    required this.title,
  });

  @override
  State<_DownloadPlayCell> createState() => _DownloadPlayCellState();
}

class _DownloadPlayCellState extends State<_DownloadPlayCell> {
  _CellState _state = _CellState.checking;
  String? _localPath;
  int _progress = 0;
  String? _errorMessage;
  StreamSubscription<DownloadLiveEvent>? _liveSub;

  String get _taskId => '${widget.tablename}_${widget.pkid}';

  @override
  void initState() {
    super.initState();
    _bootstrap();
    _liveSub = MediaDownloadService.instance.liveEvents.listen(_onLiveEvent);
  }

  @override
  void dispose() {
    _liveSub?.cancel();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    if (widget.remoteRelativePath.isEmpty) {
      setState(() => _state = _CellState.notDownloaded);
      return;
    }

    // Fast path: check disk directly first — cheap, and correctly reflects
    // a file downloaded by EITHER this screen or the background auto-sync,
    // since both write to the same subdirectory with the same filename scheme.
    final path = await AudioFileHelper.getLocalFilePath(widget.resolvedUrlForDiskCheck);
    if (await File(path).exists()) {
      if (!mounted) return;
      setState(() {
        _localPath = path;
        _state = _CellState.downloaded;
      });
      return;
    }

    // Not on disk — check whether the background auto-sync already has this
    // queued or in progress, so we don't show a plain "tap to download"
    // icon for something that's already moving.
    final queueItem = await MediaDownloadQueueDao.getByTaskId(_taskId);
    if (!mounted) return;
    if (queueItem != null && (queueItem.status == 'downloading' || queueItem.status == 'pending')) {
      setState(() {
        _state = _CellState.queuedOrDownloading;
        _progress = queueItem.progress;
      });
    } else if (queueItem != null && queueItem.status == 'failed') {
      setState(() {
        _state = _CellState.failed;
        _errorMessage = queueItem.errorMessage;
      });
    } else {
      setState(() => _state = _CellState.notDownloaded);
    }
  }

  void _onLiveEvent(DownloadLiveEvent event) {
    if (event.taskId != _taskId || !mounted) return;

    switch (event.type) {
      case DownloadLiveEventType.progress:
        setState(() {
          _state = _CellState.queuedOrDownloading;
          _progress = event.progress ?? _progress;
        });
        break;
      case DownloadLiveEventType.statusChanged:
        setState(() => _state = _CellState.queuedOrDownloading);
        break;
      case DownloadLiveEventType.completed:
        _bootstrap(); // re-check disk to pick up the final local path
        break;
      case DownloadLiveEventType.failed:
        setState(() {
          _state = _CellState.failed;
          _errorMessage = event.errorMessage;
        });
        break;
    }
  }

  Future<void> _startDownload() async {
    setState(() => _state = _CellState.queuedOrDownloading);
    final result = await MediaDownloadService.instance.requestDownload(
      pkid: widget.pkid,
      tablename: widget.tablename,
      remoteFilepath: widget.remoteRelativePath,
      existingLocalFilepath: _localPath,
    );

    if (!mounted) return;
    if (result == RequestDownloadResult.alreadyDownloaded) {
      await _bootstrap();
    }
    // alreadyInProgress / startedNow: liveEvents will drive further updates
  }

  Future<void> _deleteFile() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(Statics.getLabel('Alert')),
        content: Text(Statics.getLabel('ToDeleteFile')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(Statics.getLabel('Cancel'))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(Statics.getLabel('DeleteFile'), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      if (_localPath != null) {
        final file = File(_localPath!);
        if (await file.exists()) await file.delete();

        // Keep the local DB in sync — if this pkid's row was pointing at
        // the file we just deleted, clear it so other screens reading the
        // local table don't serve a dangling path.
        await MediaDownloadQueueDao.clearLocalFilepathIfMatches(
          tablename: widget.tablename,
          pkid: widget.pkid,
          localPathToClear: _localPath!,
        );
      }
      if (!mounted) return;
      setState(() {
        _state = _CellState.notDownloaded;
        _localPath = null;
      });
      Statics.showToast(Statics.getLabel('FileGetDeleted'));
    } catch (e) {
      Statics.showToast(Statics.getLabel('ProblemMassage'));
    }
  }

  void _playFile() {
    if (_localPath == null) return;
    showDialog(
      context: context,
      builder: (_) => AudioPlayerDialog(title: '🎧', audioUrl: _localPath!, isLocalFile: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.remoteRelativePath.isEmpty) {
      return const Center(child: Text('---'));
    }

    switch (_state) {
      case _CellState.checking:
        return const Center(
          child: SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)),
        );

      case _CellState.queuedOrDownloading:
        return Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: _progress > 0 ? _progress / 100 : null, // indeterminate while waiting, determinate once ticking
            ),
          ),
        );

      case _CellState.downloaded:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(onTap: _playFile, child: const Icon(Icons.remove_red_eye_rounded, color: Colors.green, size: 19)),
            const SizedBox(width: 12),
            InkWell(onTap: _deleteFile, child: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 19)),
          ],
        );

      case _CellState.failed:
        return Center(
          child: InkWell(
            onTap: _startDownload,
            child: const Icon(Icons.refresh, color: Colors.orange, size: 19),
          ),
        );

      case _CellState.notDownloaded:
        return Center(
          child: InkWell(onTap: _startDownload, child: const Icon(Icons.download, color: Colors.blue, size: 19)),
        );
    }
  }
}
