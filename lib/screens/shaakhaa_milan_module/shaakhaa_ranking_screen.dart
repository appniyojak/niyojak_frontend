import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../models/response_model/dropdown_level_responsemodel.dart';
import '../../models/response_model/shaakhaa_report_models.dart';
import '../../utils/globals.dart';
import 'report_widgets/module_constants.dart';

// ─── Models ───────────────────────────────────────────────────────────────────
class _TabItem {
  final RankTab tab;
  final IconData icon;
  final String label;

  const _TabItem(this.tab, this.icon, this.label);
}

class RankingData {
  final int rank;
  final int totalShaakhaa;
  final int rankChange;
  final int stableDays; // ← was stableWeeks; now actual days from API
  final String levelLabel;
  final String movement;
  final int value;
  final List<NearbyCompetitor> nearby;

  const RankingData({
    required this.rank,
    required this.totalShaakhaa,
    required this.rankChange,
    required this.stableDays, // ← renamed
    required this.levelLabel,
    required this.movement,
    required this.value,
    required this.nearby,
  });
}

class NearbyCompetitor {
  final int rank;
  final String name;
  final int value;
  final bool isMe;
  final int myRank; // ← ADD; used to determine direction arrow

  const NearbyCompetitor({
    required this.rank,
    required this.name,
    required this.value,
    required this.isMe,
    required this.myRank,
  });
}

// Geo level items: (levelId, displayLabel)
// TODO: confirm IDs match your DB GeoLevel table
List<MapEntry<int, String>> _kGeoLevelItems = [
  MapEntry(10, Statics.getLabel("praant")),
  MapEntry(9, Statics.getLabel("Mahaanagar")),
  MapEntry(8, Statics.getLabel("Vibhaag")),
  MapEntry(7, Statics.getLabel("Bhaag")),
  MapEntry(6, Statics.getLabel("Nagar")),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class ShaakhaaRankingScreen extends StatefulWidget {
  static const routeName = '/shaakhaa-ranking-screen';

  const ShaakhaaRankingScreen({super.key});

  @override
  State<ShaakhaaRankingScreen> createState() => _ShaakhaaRankingScreenState();
}

class _ShaakhaaRankingScreenState extends State<ShaakhaaRankingScreen> {
  DurationTypes _period = DurationTypes.monthly;
  RankTab _tab = RankTab.upasthiti;
  int _geoLevelId = 6; // default: नगर
  int _vayogat = 1; // 1 = मेरी आयुगट, 0 = सभी

  late DropDownModel dm;
  String? geoId;

  // Karyakram tab
  String? _selectedKname;

  bool _isLoading = false;
  RankingData? _data;
  List<MylvlGraph> _gData = [];

  // ── Period labels ──────────────────────────────────────────────────────────

  String get _currentPeriodLabel => _period.pastName;

  String get _tabBasisLabel {
    switch (_tab) {
      case RankTab.upasthiti:
        return 'कुल उपस्थिति';
      case RankTab.naveenBharti:
        return 'नवीन भरती';
      case RankTab.kaaryakram:
        return 'कार्यक्रम निरंतरता';
    }
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _initData());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    geoId = ModalRoute.of(context)?.settings.arguments as String?;
  }

  _initData() async {
    dm = await MyAppGlobals.getLevelLDB();

    setState(() {});
    _fetchRanking();
  }

  Future<void> _fetchRanking() async {
    // Gate: karyakram tab needs an activity selected first
    if (_tab == RankTab.kaaryakram && _selectedKname == null) {
      setState(() {
        _data = null;
      });
      return;
    }

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final req = {
        'AppUserID': int.tryParse(Statics.userDetails['userID'] ?? '0') ?? 0,
        'Geounitid': geoId ?? dm.geoUnitID,
        'day': _period.pkValues,
        'level': _geoLevelId,
        'vayogat': _vayogat,
        'istotal': _tab == RankTab.naveenBharti ? 1 : 0,
        'kname': _tab == RankTab.kaaryakram ? (_selectedKname ?? '') : '',
      };

      final res = await Statics.fetchMyShakhaaRanking(req);
      if (!mounted) return;

      if (res == null || res.status != 'Success' || res.myperformancedata == null) {
        setState(() {
          _data = null;
          _isLoading = false;
        });
        return;
      }

      final perf = res.myperformancedata!;
      final myRank = perf.currentRank;

      setState(() {
        _gData = res.gData;
        _data = RankingData(
          rank: perf.currentRank,
          totalShaakhaa: perf.totalshaakha,
          movement: perf.movement,
          rankChange: perf.previousRank == 0 ? 0 : perf.previousRank - perf.currentRank,
          stableDays: perf.rankStayedDays,
          levelLabel: (_kGeoLevelItems.firstWhere((e) => e.key == _geoLevelId, orElse: () => const MapEntry(0, 'स्तर')).value) + ' स्तर',
          value: res.myData.firstWhere((e) => e.ismyshaakha == 1, orElse: () => MyNearby(geoUnitName: '', presentcnt: 0, rankNo: 0, ismyshaakha: 1)).presentcnt,
          nearby: res.myData
              .map((e) => NearbyCompetitor(
                    rank: e.rankNo,
                    name: e.geoUnitName,
                    value: e.presentcnt,
                    isMe: e.ismyshaakha == 1,
                    myRank: perf.currentRank,
                  ))
              .toList(),
        );
        _isLoading = false;
      });
    } catch (e, s) {
      debugPrint('fetchMyShakhaa error: $e\n$s');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: Text("मेरी शाखा का पायदान"),
        backgroundColor: Color(0xFFFF6B00),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            // ── Fixed filters ──────────────────────────────────────────────
            _TimePeriodChips(),
            const SizedBox(height: 10),
            _GeoVayogatRow(),
            const SizedBox(height: 10),
            _TabRow(),
            const SizedBox(height: 10),

            // ── Scrollable content ─────────────────────────────────────────
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Color(0xFFFF6B00)),
                    )
                  : _data == null && _tab != RankTab.kaaryakram
                      ? Center(
                          child: Text(
                            Statics.getLabel('NoDataFound'),
                            style: const TextStyle(fontSize: 14, color: Color(0xFF8E8E93)),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                          children: [
                            // ── Karyakram activity dropdown ───────────────
                            if (_tab == RankTab.kaaryakram) ...[
                              const SizedBox(height: 4),
                              const Text(
                                'रैंकिंग के लिए विशिष्ट कार्यक्रम चुनें:',
                                style: TextStyle(fontSize: 11, color: Color(0xFF8E8E93)),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xFFE5E5EA), width: 1.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedKname,
                                    isExpanded: true,
                                    hint: const Text('कार्यक्रम चुनें...', style: TextStyle(fontSize: 14, color: Color(0xFF8E8E93))),
                                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFFFF6B00), size: 22),
                                    items: karyakramItems
                                        .map((e) => DropdownMenuItem(
                                              value: e.key,
                                              child: Text(Statics.getLabel(e.value, returnKey: true)),
                                            ))
                                        .toList(),
                                    onChanged: (v) {
                                      if (v != null) {
                                        setState(() => _selectedKname = v);
                                        _fetchRanking();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],

                            // ── Placeholder until activity chosen ─────────
                            if (_tab == RankTab.kaaryakram && _selectedKname == null)
                              Container(
                                height: 180,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.touch_app_outlined, size: 38, color: Color(0xFFFF6B00)),
                                    SizedBox(height: 12),
                                    Text('ऊपर से कार्यक्रम चुनें', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
                                    SizedBox(height: 4),
                                    Text(
                                      'रैंकिंग देखने के लिए एक कार्यक्रम\nचुनना आवश्यक है',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 11.5, color: Color(0xFF8E8E93)),
                                    ),
                                  ],
                                ),
                              )
                            else if (_data != null) ...[
                              _RankCard(data: _data!, periodLabel: _currentPeriodLabel),
                              const SizedBox(height: 14),
                              _NearbySection(data: _data!, basisLabel: _tabBasisLabel),

                              // ── Rank trend chart ─────────────────────────────
                              if (_gData.length > 1) _RankTrendChart(gData: _gData),
                            ],
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Sub-widgets (inline builders) ──────────────────────────────────────────

  Widget _TimePeriodChips() {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        children: DurationTypes.values.where((e) => e != DurationTypes.daily).toList().map((p) {
          final sel = _period == p;
          return GestureDetector(
            onTap: () {
              setState(() => _period = p);
              _fetchRanking();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: sel ? const Color(0xFFFF6B00) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: sel ? const Color(0xFFFF6B00) : const Color(0xFFE5E5EA),
                  width: 1.2,
                ),
              ),
              child: Text(
                p.pastName,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: sel ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _GeoVayogatRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          // Geo level
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E5EA), width: 1.2),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _geoLevelId,
                  isExpanded: true,
                  icon: const SizedBox.shrink(),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF1C1C1E)),
                  selectedItemBuilder: (_) => _kGeoLevelItems
                      .map((e) => Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFFFF6B00)),
                              const SizedBox(width: 6),
                              Expanded(child: Text(e.value, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500))),
                              const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Color(0xFFFF6B00)),
                            ],
                          ))
                      .toList(),
                  items: _kGeoLevelItems.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _geoLevelId = v);
                    _fetchRanking();
                  },
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Vayogat scope
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E5EA), width: 1.2),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _vayogat,
                  isExpanded: true,
                  icon: const SizedBox.shrink(),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF1C1C1E)),
                  selectedItemBuilder: (_) => [1, 0]
                      .map((v) => Row(
                            children: [
                              const Icon(Icons.people_alt_outlined, size: 16, color: Color(0xFF6366F1)),
                              const SizedBox(width: 6),
                              Expanded(
                                  child: Text(
                                v == 1 ? 'मेरी आयुगट की शाखाओं में' : 'सभी शाखाओं में',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
                              )),
                              const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Color(0xFFFF6B00)),
                            ],
                          ))
                      .toList(),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('मेरी आयुगट की शाखाओं में')),
                    DropdownMenuItem(value: 0, child: Text('सभी शाखाओं में')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _vayogat = v);
                    _fetchRanking();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _TabRow() {
    final tabs = [
      _TabItem(RankTab.upasthiti, Icons.people_outline, 'कुल उपस्थिति'),
      _TabItem(RankTab.naveenBharti, Icons.person_add_alt_1_outlined, 'नवीन भरती'),
      _TabItem(RankTab.kaaryakram, Icons.show_chart, 'कार्यक्रम\nनिरंतरता'),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: tabs.map((t) {
          final sel = _tab == t.tab;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _tab = t.tab);
                _fetchRanking();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: sel ? const Color(0xFFEDE9FE) : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Column(
                  children: [
                    Icon(
                      t.icon,
                      size: 20,
                      color: sel ? const Color(0xFF6366F1) : const Color(0xFF8E8E93),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                        color: sel ? const Color(0xFF6366F1) : const Color(0xFF8E8E93),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Filter Dropdown ──────────────────────────────────────────────────────────

class _FilterDropdown extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E5EA), width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const SizedBox.shrink(),
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF1C1C1E),
            fontWeight: FontWeight.w500,
          ),
          selectedItemBuilder: (_) => items
              .map(
                (e) => Row(
                  children: [
                    Icon(icon, size: 16, color: iconColor),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        e,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1C1C1E),
                        ),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Color(0xFFFF6B00)),
                  ],
                ),
              )
              .toList(),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ─── Rank Card ────────────────────────────────────────────────────────────────

class _RankCard extends StatelessWidget {
  final RankingData data;
  final String periodLabel;

  const _RankCard({required this.data, required this.periodLabel});

  @override
  Widget build(BuildContext context) {
    final changeUp = data.rankChange > 0;
    final changeDown = data.rankChange < 0;
    final changeAbs = data.rankChange.abs();
    final changeStr = data.movement;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B00), Color(0xFFFF8C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Level • Period + change chip ───────────────────────────
                Row(
                  children: [
                    Text(
                      '${data.levelLabel} • $periodLabel',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (changeUp || changeDown)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: changeUp ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              changeUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${changeUp ? "+" : "-"}$changeStr',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'कोई बदलाव नहीं',
                          style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                // ── Big rank number ────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '#${data.rank == 0 ? "-" : data.rank}',
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '/ ${data.totalShaakhaa} शाखाओं में',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Decorative hourglass icon
                    const Spacer(),
                    Opacity(
                      opacity: 0.18,
                      child: const Icon(
                        Icons.hourglass_bottom_rounded,
                        size: 72,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),

          // ── Stable-since info bar ──────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xBF000000), // semi-transparent dark
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 16, color: Colors.white70),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'स्थिति बनाए रखने का समय',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Colors.white60,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.stableDays <= 0
                          ? 'पहली बार इस पायदान पर!'
                          : data.stableDays == 1
                              ? 'आज इस पायदान पर आए!'
                              : 'पिछले ${data.stableDays} दिनों से इसी पायदान पर!',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Rank Trend Chart ─────────────────────────────────────────────────────────

class _RankTrendChart extends StatefulWidget {
  final List<MylvlGraph> gData;

  const _RankTrendChart({required this.gData});

  @override
  State<_RankTrendChart> createState() => _RankTrendChartState();
}

class _RankTrendChartState extends State<_RankTrendChart> {
  // -1 = default to last point (most recent)
  int _shownIndex = -1;

  int get _n => widget.gData.length;

  int get _resolvedIndex => _shownIndex < 0 ? _n - 1 : _shownIndex.clamp(0, _n - 1);

  /// Picks a "nice" step (1, 2, 5, 10, 20, 50, 100 ...) so the axis divides
  /// cleanly instead of the old raw-divide-by-5/10 branches, which produced
  /// inconsistent spacing depending on which bucket the value fell in.
  int _niceStep(num range) {
    if (range <= 0) return 1;
    final rawStep = range / 3.0; // aim for ~3 divisions
    final exponent = (log(rawStep) / ln10).floor();
    final magnitude = pow(10, exponent).toDouble();
    final residual = rawStep / magnitude;

    double niceResidual;
    if (residual <= 1) {
      niceResidual = 1;
    } else if (residual <= 2) {
      niceResidual = 2;
    } else if (residual <= 5) {
      niceResidual = 5;
    } else {
      niceResidual = 10;
    }
    final step = (niceResidual * magnitude).round();
    return step < 1 ? 1 : step;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.gData.isEmpty) return const SizedBox.shrink();

    final n = _n;

    // ── Y range: derived ONLY from gData (no injected current-rank point) ──
    final ranks = widget.gData.map((e) => e.rankNo).toList();
    final minRank = ranks.reduce((a, b) => a < b ? a : b);
    final maxRank = ranks.reduce((a, b) => a > b ? a : b);

    final step = _niceStep(maxRank - minRank);

    // Floor/ceil to clean multiples of `step`, never going below rank 1.
    int niceMin = (minRank ~/ step) * step;
    if (niceMin < 1) niceMin = 1;
    int niceMax = ((maxRank + step - 1) ~/ step) * step;
    if (niceMax <= niceMin) niceMax = niceMin + step;

    final interval = step.toDouble();

    // Negate so rank 1 = top, higher rank number = lower on screen.
    final double minY = -niceMax.toDouble();
    final double maxY = -niceMin.toDouble();

    // ── Spots — one per API data point, nothing synthetic added ──────────
    final spots = <FlSpot>[
      for (final e in widget.gData.asMap().entries) FlSpot(e.key.toDouble(), -e.value.rankNo.toDouble()),
    ];

    // ── X labels: prefer DateRange (actually unique per point); fall back
    // to periodType+periodNo only if DateRange is missing. The previous
    // code always used periodType+periodNo even though DateRange was
    // available, which is what caused repeated labels (e.g. "Day 1"
    // showing up for two different weeks).
    final xLabels = widget.gData.map((e) => '${e.periodType} ${e.periodNo}').toList();
    final ttLabels = widget.gData.map((e) => e.dateRange.trim().isNotEmpty ? e.dateRange : '${e.periodType} ${e.periodNo}').toList();

    // ── Which x indices to show — evenly spaced, always unique, capped
    // at a max tick count so labels never crowd or repeat.
    const maxTicks = 5;
    final showSet = <int>{};
    if (n <= maxTicks) {
      showSet.addAll(List.generate(n, (i) => i));
    } else {
      final tickCount = maxTicks;
      for (int i = 0; i < tickCount; i++) {
        final idx = (i * (n - 1) / (tickCount - 1)).round();
        showSet.add(idx.clamp(0, n - 1));
      }
    }

    final shownIdx = _resolvedIndex;

    // ── Line data — single bar with all spots = always fully connected.
    final barData = LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.35,
      preventCurveOverShooting: true,
      color: const Color(0xFFFF6B00),
      barWidth: 2.5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, _, __, idx) => FlDotCirclePainter(
          radius: idx == shownIdx ? 6.5 : 4,
          color: Colors.white,
          strokeWidth: 2.5,
          strokeColor: const Color(0xFFFF6B00),
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B00).withOpacity(0.10),
            const Color(0xFFFF6B00).withOpacity(0.01),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );

    // Small horizontal buffer on minX/maxX keeps the first/last dot from
    // sitting flush against the chart border, so the whole line reads as
    // centered rather than pinned to the edges.
    const edgePad = 0.4;

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'पायदान का इतिहास (Rank Trend)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'समय के साथ आपके प्रदर्शन में सुधार\n(ग्राफ में ऊपर जाना = बेहतर रैंक)',
            style: TextStyle(fontSize: 10.5, color: Color(0xFF8E8E93), height: 1.3),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: Padding(
              // Symmetric horizontal padding keeps the plotted line visually
              // centered inside the card instead of hugging the left axis.
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: LineChart(
                LineChartData(
                  minX: -edgePad,
                  maxX: (n - 1) + edgePad,
                  minY: minY - edgePad,
                  maxY: maxY + edgePad,
                  clipData: const FlClipData.all(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: interval,
                    getDrawingHorizontalLine: (_) => const FlLine(
                      color: Color(0xFFF2F2F7),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(color: Color(0xFFE5E5EA), width: 1),
                      left: BorderSide(color: Color(0xFFE5E5EA), width: 1),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    // ── Y labels: only within [niceMin, niceMax] ──────────
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        minIncluded: false,
                        // maxIncluded: false,
                        interval: interval,
                        getTitlesWidget: (value, _) {
                          final rank = (-value).round();
                          if (rank < niceMin || rank > niceMax) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              '$rank',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
                            ),
                          );
                        },
                      ),
                    ),
                    // ── X labels: unique, evenly spaced, capped count ─────
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        minIncluded: false,
                        maxIncluded: false,
                        interval: 1,
                        reservedSize: 36,
                        getTitlesWidget: (value, _) {
                          final idx = value.round();
                          if (idx < 0 || idx >= xLabels.length) {
                            return const SizedBox.shrink();
                          }
                          if (!showSet.contains(idx)) return const SizedBox.shrink();

                          final isLatest = idx == n - 1;
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              xLabels[idx],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: isLatest ? FontWeight.w700 : FontWeight.w400,
                                color: isLatest ? const Color(0xFFFF6B00) : Colors.grey.shade500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => Colors.white,
                      tooltipBorder: const BorderSide(color: Color(0xFFFFE0B2), width: 1),
                      tooltipBorderRadius: BorderRadius.circular(8),
                      tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      getTooltipItems: (lineBarSpots) {
                        return lineBarSpots.map((spot) {
                          final rank = (-spot.y).round();
                          final label = ttLabels[spot.spotIndex];
                          return LineTooltipItem(
                            '$label\n',
                            const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFE65100),
                            ),
                            children: [
                              TextSpan(
                                text: 'पायदान : Rank #$rank',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6366F1),
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      },
                    ),
                    getTouchedSpotIndicator: (_, spotIndexes) => spotIndexes
                        .map((_) => TouchedSpotIndicatorData(
                              const FlLine(
                                color: Color(0xFFFF6B00),
                                strokeWidth: 1.5,
                                dashArray: [4, 4],
                              ),
                              FlDotData(
                                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                                  radius: 6.5,
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                  strokeColor: const Color(0xFFFF6B00),
                                ),
                              ),
                            ))
                        .toList(),
                    touchCallback: (event, response) {
                      if (event is FlTapUpEvent || event is FlPanUpdateEvent) {
                        final idx = response?.lineBarSpots?.first.spotIndex ?? -1;
                        if (idx >= 0) setState(() => _shownIndex = idx);
                      }
                    },
                    handleBuiltInTouches: true,
                  ),
                  lineBarsData: [barData],
                  showingTooltipIndicators: [
                    ShowingTooltipIndicators([
                      LineBarSpot(barData, 0, spots[shownIdx]),
                    ]),
                  ],
                ),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Nearby Competition Section ───────────────────────────────────────────────

class _NearbySection extends StatelessWidget {
  final RankingData data;
  final String basisLabel;

  const _NearbySection({required this.data, required this.basisLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                const Icon(Icons.my_location_rounded, size: 16, color: Color(0xFFFF6B00)),
                const SizedBox(width: 8),
                const Text(
                  'आस-पास की प्रतिस्पर्धा',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'आधार: $basisLabel',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF2F2F7)),

          // Rows
          ...data.nearby.map((c) => _NearbyRow(competitor: c)),

          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

class _NearbyRow extends StatelessWidget {
  final NearbyCompetitor competitor;

  const _NearbyRow({required this.competitor});

  Color get _iconColor {
    if (competitor.isMe) return const Color(0xFFFF6B00);
    if (competitor.rank < competitor.myRank) return const Color(0xFF6366F1);
    return const Color(0xFF22C55E);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: competitor.isMe ? const Color(0xFFFFF3E0) : Colors.transparent,
        border: const Border(
          bottom: BorderSide(color: Color(0xFFF2F2F7), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Rank badge
          SizedBox(
            width: 32,
            child: Text(
              '#${competitor.rank}',
              style: TextStyle(
                fontSize: competitor.isMe ? 15 : 13.5,
                fontWeight: FontWeight.w800,
                color: competitor.isMe ? const Color(0xFFFF6B00) : const Color(0xFF8E8E93),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Name + motivational text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  competitor.isMe ? '${competitor.name} (आप)' : competitor.name,
                  style: TextStyle(
                    fontSize: competitor.isMe ? 14 : 13,
                    fontWeight: competitor.isMe ? FontWeight.w800 : FontWeight.w500,
                    color: competitor.isMe ? const Color(0xFF1C1C1E) : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Score chip
          Container(
            constraints: BoxConstraints(minWidth: competitor.isMe ? 44 : 40),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: competitor.isMe ? const Color(0xFFFF6B00) : const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${competitor.value}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: competitor.isMe ? 15 : 13.5,
                fontWeight: competitor.isMe ? FontWeight.w800 : FontWeight.w600,
                color: competitor.isMe ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
