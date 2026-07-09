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
  final int value;
  final List<NearbyCompetitor> nearby;

  const RankingData({
    required this.rank,
    required this.totalShaakhaa,
    required this.rankChange,
    required this.stableDays, // ← renamed
    required this.levelLabel,
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
        'Geounitid': dm.geoUnitID,
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
          // RankMovement is +ve when improved (rank number went down = better)
          rankChange: perf.movement == 'Up'
              ? perf.rankMovement.abs()
              : perf.movement == 'Down'
                  ? -perf.rankMovement.abs()
                  : 0,
          stableDays: perf.rankStayedDays,
          levelLabel: _kGeoLevelItems.firstWhere((e) => e.key == _geoLevelId, orElse: () => const MapEntry(0, 'स्तर')).value + ' स्तर',
          value: res.myData.firstWhere((e) => e.ismyshaakha == 1, orElse: () => const MyNearby(geoUnitName: '', presentcnt: 0, rankNo: 0, ismyshaakha: 1)).presentcnt,
          nearby: res.myData
              .map((e) => NearbyCompetitor(
                    rank: e.rankNo,
                    name: e.geoUnitName,
                    value: e.presentcnt,
                    isMe: e.ismyshaakha == 1,
                    myRank: myRank, // ← pass so _NearbyRow knows direction
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
                  : _data == null
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
                              '+$changeAbs पायदान ${changeUp ? "ऊपर" : "नीचे"}',
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
                      '#${data.rank}',
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
                      'पिछले ${data.stableDays} दिनों से इसी पायदान पर!',
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
