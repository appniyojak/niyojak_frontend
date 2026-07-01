import 'package:flutter/material.dart';

import '../../helpers/static_data.dart' as Statics;

// ─── Enums ────────────────────────────────────────────────────────────────────

enum _TimePeriod { today, yesterday, lastWeek, lastMonth, last3Months }

enum _RankTab { upasthiti, naveenBharti, kaaryakram }

// ─── Models ───────────────────────────────────────────────────────────────────
class _TabItem {
  final _RankTab tab;
  final IconData icon;
  final String label;

  const _TabItem(this.tab, this.icon, this.label);
}

class RankingData {
  final int rank;
  final int totalShaakhaa;
  final int rankChange; // +ve = up, -ve = down, 0 = no change
  final int stableWeeks; // "पिछले N सप्ताह से इसी पायदान पर"
  final String levelLabel; // "नगर स्तर"
  final int value; // score / count
  final List<NearbyCompetitor> nearby;

  const RankingData({
    required this.rank,
    required this.totalShaakhaa,
    required this.rankChange,
    required this.stableWeeks,
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

  const NearbyCompetitor({
    required this.rank,
    required this.name,
    required this.value,
    required this.isMe,
  });
}

// ─── Dummy data ───────────────────────────────────────────────────────────────

RankingData _dummyData(_TimePeriod p, _RankTab t) => RankingData(
      rank: 3,
      totalShaakhaa: 18,
      rankChange: 4,
      stableWeeks: 2,
      levelLabel: 'नगर स्तर',
      value: 48,
      nearby: const [
        NearbyCompetitor(rank: 2, name: 'भगत सिंह शाखा', value: 52, isMe: false),
        NearbyCompetitor(rank: 3, name: 'शिवाजी नगर शाखा', value: 48, isMe: true),
        NearbyCompetitor(rank: 4, name: 'सुभाष चंद्र शाखा', value: 45, isMe: false),
      ],
    );

// ─── Screen ───────────────────────────────────────────────────────────────────

class ShaakhaaRankingScreen extends StatefulWidget {
  static const routeName = '/shaakhaa-ranking-screen';

  const ShaakhaaRankingScreen({super.key});

  @override
  State<ShaakhaaRankingScreen> createState() => _ShaakhaaRankingScreenState();
}

class _ShaakhaaRankingScreenState extends State<ShaakhaaRankingScreen> {
  _TimePeriod _period = _TimePeriod.lastMonth;
  _RankTab _tab = _RankTab.upasthiti;
  String _geoLevel = 'नगर';
  String _vayogatScope = 'मेरी आयुगट की शाखाओं में';

  bool _isLoading = false;
  RankingData? _data;

  // ── Period labels ──────────────────────────────────────────────────────────

  String _periodLabel(_TimePeriod p) {
    switch (p) {
      case _TimePeriod.today:
        return 'आज';
      case _TimePeriod.yesterday:
        return 'कल';
      case _TimePeriod.lastWeek:
        return 'पिछले सप्ताह';
      case _TimePeriod.lastMonth:
        return 'पिछले महीने';
      case _TimePeriod.last3Months:
        return 'पिछले ३ महीने';
    }
  }

  String get _currentPeriodLabel => _periodLabel(_period);

  String get _tabBasisLabel {
    switch (_tab) {
      case _RankTab.upasthiti:
        return 'कुल उपस्थिति';
      case _RankTab.naveenBharti:
        return 'नवीन भरती';
      case _RankTab.kaaryakram:
        return 'कार्यक्रम निरंतरता';
    }
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _fetchRanking();
  }

  Future<void> _fetchRanking() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500)); // TODO: real API
    if (!mounted) return;
    setState(() {
      _data = _dummyData(_period, _tab);
      _isLoading = false;
    });
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
                            _RankCard(
                              data: _data!,
                              periodLabel: _currentPeriodLabel,
                            ),
                            const SizedBox(height: 14),
                            _NearbySection(
                              data: _data!,
                              basisLabel: _tabBasisLabel,
                            ),
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
        children: _TimePeriod.values.map((p) {
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
                _periodLabel(p),
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
          // Geo level dropdown
          Expanded(
            child: _FilterDropdown(
              icon: Icons.location_on_outlined,
              iconColor: const Color(0xFFFF6B00),
              value: _geoLevel,
              items: const ['महानगर', 'विभाग', 'भाग', 'नगर', 'मंडल'],
              onChanged: (v) {
                if (v != null) setState(() => _geoLevel = v);
                _fetchRanking();
              },
            ),
          ),
          const SizedBox(width: 10),
          // Vayogat scope dropdown
          Expanded(
            child: _FilterDropdown(
              icon: Icons.people_alt_outlined,
              iconColor: const Color(0xFF6366F1),
              value: _vayogatScope,
              items: const [
                'मेरी आयुगट की शाखाओं में',
                'सभी शाखाओं में',
              ],
              onChanged: (v) {
                if (v != null) setState(() => _vayogatScope = v);
                _fetchRanking();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _TabRow() {
    final tabs = [
      _TabItem(_RankTab.upasthiti, Icons.people_outline, 'कुल उपस्थिति'),
      _TabItem(_RankTab.naveenBharti, Icons.person_add_alt_1_outlined, 'नवीन भरती'),
      _TabItem(_RankTab.kaaryakram, Icons.show_chart, 'कार्यक्रम\nनिरंतरता'),
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

          /*// ── Stable-since info bar ──────────────────────────────────────
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
                      'पिछले ${data.stableWeeks} सप्ताह से इसी पायदान पर!',
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
          ),*/
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

  // String get _motivationalText {
  //   if (competitor.isMe) return '';
  //   // Rows above the user (smaller rank number = better)
  //   if (competitor.rank < _myRank) return 'बस थोड़ा और आगे निकलो!';
  //   return 'इन्हें पीछे ही रखो!';
  // }

  // We derive "my rank" from context — the isMe flag tells us which row is us,
  // so rows with rank < mine are above, rows with rank > mine are below.
  // Since we don't have _data here we rely on the list order:
  // rank above = motivational push-up, rank below = motivational keep-ahead.
  int get _myRank => 3; // TODO: pass as param when wiring real API

  Color get _iconColor {
    if (competitor.isMe) return const Color(0xFFFF6B00);
    if (competitor.rank < _myRank) return const Color(0xFF6366F1);
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
                /*if (!competitor.isMe) ...[
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(
                        competitor.rank < _myRank ? Icons.arrow_forward_rounded : Icons.shield_outlined,
                        size: 12,
                        color: _iconColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _motivationalText,
                        style: TextStyle(
                          fontSize: 11,
                          color: _iconColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],*/
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
