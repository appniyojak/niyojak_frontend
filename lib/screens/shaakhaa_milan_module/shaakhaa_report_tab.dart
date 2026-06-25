import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../models/response_model/shaakhaa_milan_report_models.dart';
import '../../providers/bals.dart';
import '../../utils/globals.dart';
import '../../utils/stable_geounit_class.dart';

// ─── Data Models ─────────────────────────────────────────────────────────────

enum DurationTypes { daily, weekly, monthly, quarterly, halfYearly, yearly }

extension Duration on DurationTypes {
  String get name {
    switch (this) {
      case DurationTypes.daily:
        return 'दैनिक';
      case DurationTypes.weekly:
        return 'साप्ताहिक';
      case DurationTypes.monthly:
        return 'मासिक';
      case DurationTypes.quarterly:
        return 'त्रैमासिक';
      case DurationTypes.halfYearly:
        return 'अर्धवार्षिक';
      case DurationTypes.yearly:
        return 'वार्षिक';
    }
  }

  int get pkValues {
    switch (this) {
      case DurationTypes.daily:
        return 1;
      case DurationTypes.weekly:
        return 7;
      case DurationTypes.monthly:
        return 30;
      case DurationTypes.quarterly:
        return 90;
      case DurationTypes.halfYearly:
        return 180;
      case DurationTypes.yearly:
        return 360;
    }
  }
}

class BreakdownItem {
  final String label;
  final String value;

  const BreakdownItem(this.label, this.value);
}

class ProgrammeActivity {
  final String name;
  final bool completed;

  const ProgrammeActivity(this.name, this.completed);
}

class ProgrammeBar {
  final String name;
  final double progressFraction;
  final int totalDays;
  final double percent;
  final List<SubPeriod> subPeriods;

  const ProgrammeBar({
    required this.name,
    required this.progressFraction,
    required this.totalDays,
    required this.percent,
    this.subPeriods = const [],
  });
}

class SubPeriod {
  final String label;
  final String days;
  final String percent;

  const SubPeriod(this.label, this.days, this.percent);
}

// ─── Sentinel for "Total" entry ───────────────────────────────────────────────
// A fixed staticID of -1 is used as a sentinel so we can reliably identify
// the synthetic "एकुण" item regardless of DB-returned data.
const int _kTotalStaticlID = 0;

StaticMasterBAL get _totalEntry => StaticMasterBAL(_kTotalStaticlID, 1, 'ShaakhaaVayogat', 'Total', Statics.getLabel('Total'), 0, 0, '', '');

// ─── Screen ──────────────────────────────────────────────────────────────────

class ShaakhaaReportTabScreen extends StatefulWidget {
  const ShaakhaaReportTabScreen({super.key});

  @override
  State<ShaakhaaReportTabScreen> createState() => _ShaakhaaReportTabScreenState();
}

class _ShaakhaaReportTabScreenState extends State<ShaakhaaReportTabScreen> {
  final controller = createGeoController();

  DurationTypes _kalavadha = DurationTypes.daily;

  // Vayogat dropdown — always starts with the synthetic "Total" entry.
  // After DB load, DB items are appended after it.
  List<StaticMasterBAL> _vayogatOptions = [_totalEntry];

  // Selected vayogat — defaults to the Total sentinel.
  StaticMasterBAL _selectedVayogat = _totalEntry;

  /// True when the currently-selected vayogat is the "Total / एकुण" entry.
  /// Used to decide whether to show the baal/ni/madhya/praudhh breakdown row.
  bool get _isTotal => (controller.deepestSelectedLevelId != 1) && (_selectedVayogat.code == "Total");

  bool _isLoading = false;
  bool _isSearched = false;
  bool _isExpanded = true;
  String _card1Value = '';
  String _card2Value = '';
  List<BreakdownItem> _card1Breakdown = [];
  List<BreakdownItem> _card2Breakdown = [];
  List<ProgrammeActivity> _activities = [];
  List<ProgrammeBar> _programmeBars = [];

  // ── All-level daily (levelId != 1) ────────────────────────────────────────────
  bool _isAllLevel = false;
  String _allTotalPresent = '';
  List<BreakdownItem> _allPresentBreakdown = [];

// TODO: card 2 average needs shaakhaa count from API — flagged for backend
  String _allAvgPresent = '--';
  List<BreakdownItem> _allAvgBreakdown = [];
  String _allNewPresent = '';
  List<BreakdownItem> _allNewBreakdown = [];
  List<ActivityData> _allAData = [];

  // ── Add alongside existing all-level vars ─────────────────────────────────────
  List<ActivityChartData> _allActivityChartData = [];

// ── Add helper (call from every all-level fetch branch) ──────────────────────
  void _mapAllLevelPData(List<PresentList> pData) {
    _allTotalPresent = pData.fold<int>(0, (s, p) => s + p.totalpresent).toString();
    _allPresentBreakdown = pData.map((p) => BreakdownItem(p.vagogatname, p.totalpresent.toString())).toList();
    _allNewPresent = pData.fold<int>(0, (s, p) => s + p.totalnewpresent).toString();
    _allNewBreakdown = pData.map((p) => BreakdownItem(p.vagogatname, p.totalnewpresent.toString())).toList();
    _allAvgPresent = '--'; // TODO: backend to supply shaakhaa count for avg
    _allAvgBreakdown = [];
  }

  // ── Computed labels ────────────────────────────────────────────────────────

  String get card1Label {
    switch (_kalavadha) {
      case DurationTypes.daily:
        return 'आज की उपस्थिति';
      case DurationTypes.weekly:
        return 'सरासरी उपस्थिति (साप्ताहिक)';
      case DurationTypes.monthly:
        return 'सरासरी उपस्थिति (मासिक)';
      case DurationTypes.quarterly:
        return 'सरासरी उपस्थिति (त्रैमासिक)';
      case DurationTypes.halfYearly:
        return 'सरासरी उपस्थिति (अर्धवार्षिक)';
      case DurationTypes.yearly:
        return 'सरासरी उपस्थिति (वार्षिक)';
    }
  }

  String get card2Label {
    switch (_kalavadha) {
      case DurationTypes.daily:
        return 'आज की नवीन भरती';
      case DurationTypes.weekly:
        return 'नवीन भरती (साप्ताहिक)';
      case DurationTypes.monthly:
        return 'नवीन भरती (मासिक)';
      case DurationTypes.quarterly:
        return 'नवीन भरती (त्रैमासिक)';
      case DurationTypes.halfYearly:
        return 'नवीन भरती (अर्धवार्षिक)';
      case DurationTypes.yearly:
        return 'नवीन भरती (वार्षिक)';
    }
  }

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
    await _fetchReport();
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

  Future<void> _fetchReport() async {
    final ctrl = controller;
    final geoUnitId = int.tryParse(ctrl.deepestSelectedGeoUnitId ?? "0") ?? 0;

    final req = {
      "AppUserID": int.tryParse(Statics.userDetails["userID"] ?? "5693") ?? "5693",
      "Geounitid": geoUnitId,
      "vayogat": ctrl.deepestSelectedLevelId != 1 ? _selectedVayogat.staticID : 0,
      "days": _kalavadha.pkValues,
    };

    if (!mounted) return;
    _isExpanded = false;
    setState(() => _isLoading = _isSearched = true);
    final isAll = ctrl.deepestSelectedLevelId != 1;
    setState(() => _isAllLevel = isAll);

    try {
      switch (_kalavadha) {
        case DurationTypes.daily:
          if (!isAll) {
            // ── Shaakhaa level (existing logic) ─────────────────────────────
            final res = await Statics.fetchShaakhaaDaily(req);
            if (!mounted) return;
            if (res == null) {
              Statics.showToast(Statics.getLabel('NoDataFound'));
              setState(() => _isSearched = false);
              return;
            }
            setState(() {
              _card1Value = res.totalpresent.toString();
              _card2Value = res.totalnewpresent.toString();
              _card1Breakdown = [];
              _card2Breakdown = [];
              _activities = res.data.map((e) => ProgrammeActivity(e.activity, e.value == 1)).toList();
              _programmeBars = [];
              // clear all-level state
              _allPresentBreakdown = [];
              _allNewBreakdown = [];
              _allAData = [];
            });
          } else {
            // ── All levels (new) ────────────────────────────────────────────
            final res = await Statics.fetchAllDaily(req);
            if (!mounted) return;
            if (res == null) {
              Statics.showToast(Statics.getLabel('NoDataFound'));
              setState(() => _isSearched = false);
              return;
            }
            final _list = res.pData;
            setState(() {
              // Card 1 — total attendance (sum across vayogats)
              _allTotalPresent = res.pData.firstWhere((e) => e.vagogatname == "ekun").totalpresent.toString();
              _allPresentBreakdown = _list.where((e) => e.vagogatname != "ekun").toList().map((p) => BreakdownItem(p.vagogatname, p.totalpresent.toString())).toList();

              // Card 2 — average per shaakhaa
              // TODO: backend needs to return shaakhaa count or pre-computed avg
              _allAvgPresent = '--';
              _allAvgBreakdown = [];

              // Card 3 — new enrollment (sum across vayogats)
              _allNewPresent = res.pData.firstWhere((e) => e.vagogatname == "ekun").totalnewpresent.toString();
              _allNewBreakdown = _list.where((e) => e.vagogatname != "ekun").toList().map((p) => BreakdownItem(p.vagogatname, p.totalnewpresent.toString())).toList();

              // Programme bars
              _allAData = res.aData;

              // clear shaakhaa-level state
              _activities = [];
            });
          }
          break;

        case DurationTypes.weekly:
          if (!isAll) {
            final res = await Statics.fetchShaakhaaWeekly(req);
            if (!mounted) return;
            if (res == null) {
              Statics.showToast(Statics.getLabel('NoDataFound'));
              setState(() => _isSearched = false);
              return;
            }
            setState(() {
              _card1Value = res.totalpresent.toString();
              _card2Value = res.totalnewpresent.toString();
              _card1Breakdown = [];
              _card2Breakdown = [];
              _activities = [];
              _programmeBars = res.data.map((e) {
                final pct = double.tryParse(e.percentage) ?? 0;
                return ProgrammeBar(
                  name: e.activity,
                  progressFraction: pct / 100,
                  totalDays: e.value,
                  percent: pct,
                );
              }).toList();
            });
          } else {
            // ── all levels ────────────────────────────────────────────────────
            final res = await Statics.fetchAllWeekly(req);
            if (!mounted) return;
            if (res == null) {
              Statics.showToast(Statics.getLabel('NoDataFound'));
              setState(() => _isSearched = false);
              return;
            }
            setState(() {
              _mapAllLevelPData(res.pData);
              _activities = [];
              _programmeBars = [];
              // Group by Activity → one ActivityChartData per activity
              final grouped = <String, List<AllWeeklyActivity>>{};
              for (final e in res.aData) grouped.putIfAbsent(e.activity, () => []).add(e);
              _allActivityChartData = grouped.entries
                  .map((e) => ActivityChartData(
                        activityKey: e.key,
                        bars: e.value
                            .map((w) => ChartBarData(
                                  xLabel: 'दिन ${w.timesDone}',
                                  value: w.shaakhaCount,
                                  tooltipTitle: 'दिन ${w.timesDone}',
                                ))
                            .toList(),
                      ))
                  .toList();
            });
          }
          break;

        case DurationTypes.monthly:
          if (!isAll) {
            final res = await Statics.fetchShaakhaaMonthly(req);
            if (!mounted) return;
            if (res == null) {
              Statics.showToast(Statics.getLabel('NoDataFound'));
              setState(() => _isSearched = false);
              return;
            }
            setState(() {
              _card1Value = res.totalpresent.toString();
              _card2Value = res.totalnewpresent.toString();
              _card1Breakdown = [];
              _card2Breakdown = [];
              _activities = [];
              _programmeBars = res.mData.map((e) {
                final pct = double.tryParse(e.percentage28Days) ?? 0;
                return ProgrammeBar(
                  name: e.activity,
                  progressFraction: pct / 100,
                  totalDays: e.total28Days,
                  percent: pct,
                  subPeriods: [
                    SubPeriod(
                      e.week1Range.isNotEmpty ? e.week1Range : 'सप्ताह १',
                      '${e.week1} दिन',
                      (double.tryParse(e.week1Percent) ?? 0).toStringAsFixed(2),
                    ),
                    SubPeriod(
                      e.week2Range.isNotEmpty ? e.week2Range : 'सप्ताह २',
                      '${e.week2} दिन',
                      (double.tryParse(e.week2Percent) ?? 0).toStringAsFixed(2),
                    ),
                    SubPeriod(
                      e.week3Range.isNotEmpty ? e.week3Range : 'सप्ताह ३',
                      '${e.week3} दिन',
                      (double.tryParse(e.week3Percent) ?? 0).toStringAsFixed(2),
                    ),
                    SubPeriod(
                      e.week4Range.isNotEmpty ? e.week4Range : 'सप्ताह ४',
                      '${e.week4} दिन',
                      (double.tryParse(e.week4Percent) ?? 0).toStringAsFixed(2),
                    ),
                  ],
                );
              }).toList();
            });
          } else {
            // ── all levels ────────────────────────────────────────────────────
            final res = await Statics.fetchAllMonthly(req);
            if (!mounted) return;
            if (res == null) {
              Statics.showToast(Statics.getLabel('NoDataFound'));
              setState(() => _isSearched = false);
              return;
            }
            setState(() {
              _mapAllLevelPData(res.pData);
              _activities = [];
              _programmeBars = [];
              final grouped = <String, List<AllMonthlyActivity>>{};
              for (final e in res.aData) grouped.putIfAbsent(e.activity, () => []).add(e);
              _allActivityChartData = grouped.entries
                  .map((e) => ActivityChartData(
                        activityKey: e.key,
                        bars: e.value
                            .map((m) => ChartBarData(
                                  xLabel: m.weekRange.isNotEmpty ? m.weekRange : m.weekcolumn,
                                  value: m.shaakhaCount,
                                  tooltipTitle: m.weekRange.isNotEmpty ? m.weekRange : m.weekcolumn,
                                ))
                            .toList(),
                      ))
                  .toList();
            });
          }
          break;

        case DurationTypes.quarterly:
        case DurationTypes.halfYearly:
        case DurationTypes.yearly:
          if (!isAll) {
            final res = await Statics.fetchShaakhaaMultiMonthly(req);
            if (!mounted) return;
            if (res == null) {
              Statics.showToast(Statics.getLabel('NoDataFound'));
              setState(() => _isSearched = false);
              return;
            }
            setState(() {
              _card1Value = res.totalpresent.toString();
              _card2Value = res.totalnewpresent.toString();
              _card1Breakdown = [];
              _card2Breakdown = [];
              _activities = [];
              _programmeBars = res.data.map((e) {
                // Overall % = average of all months
                final avgPct = e.months.isEmpty ? 0.0 : e.months.map((m) => m.percentage).reduce((a, b) => a + b) / e.months.length;
                final totalDays = e.months.fold<int>(0, (sum, m) => sum + m.value);

                return ProgrammeBar(
                  name: e.activity,
                  progressFraction: avgPct / 100,
                  totalDays: totalDays,
                  percent: avgPct,
                  subPeriods: e.months
                      .map((m) => SubPeriod(
                            m.range.isNotEmpty ? m.range : 'माह ${m.monthNo}',
                            '${m.value} दिन',
                            m.percentage.toStringAsFixed(2),
                          ))
                      .toList(),
                );
              }).toList();
            });
          } else {
            // ── all levels ────────────────────────────────────────────────────
            final res = await Statics.fetchAllMultiMonthly(req);
            if (!mounted) return;
            if (res == null) {
              Statics.showToast(Statics.getLabel('NoDataFound'));
              setState(() => _isSearched = false);
              return;
            }
            setState(() {
              _mapAllLevelPData(res.pData);
              _activities = [];
              _programmeBars = [];
              _allActivityChartData = res.aData
                  .map((e) => ActivityChartData(
                        activityKey: e.activity,
                        bars: e.months
                            .map((m) => ChartBarData(
                                  xLabel: m.range.isNotEmpty ? m.range : 'माह ${m.monthNo}',
                                  value: m.value,
                                  tooltipTitle: m.range.isNotEmpty ? m.range : 'माह ${m.monthNo}',
                                ))
                            .toList(),
                      ))
                  .toList();
            });
          }
          break;

        default:
          // quarterly / halfYearly / yearly — next step
          break;
      }
    } catch (e, stack) {
      print("Exception: $e \n$stack");
      return null;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///
              _filterSection(),

              ///

              if (_isLoading)
                SizedBox(
                  height: 170,
                  child: const Center(
                      child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: Color(0xFFFF6B00)),
                  )),
                )
              else if (!_isSearched)
                SizedBox(height: 170, child: Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch'))))
              else ...[
                // ── Stat Cards ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _isAllLevel
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    label: card1Label,
                                    value: _allTotalPresent,
                                    icon: Icons.people_outline,
                                    iconColor: const Color(0xFF6366F1),
                                    iconBg: const Color(0xFFEDE9FE),
                                    showBreakdown: _allPresentBreakdown.isNotEmpty,
                                    breakdown: _allPresentBreakdown,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _StatCard(
                                    label: 'आज की सरासरी संख्या',
                                    value: _allAvgPresent,
                                    icon: Icons.analytics_outlined,
                                    iconColor: const Color(0xFFF59E0B),
                                    iconBg: const Color(0xFFFEF3C7),
                                    showBreakdown: false,
                                    breakdown: const [],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _StatCard(
                              label: card2Label,
                              value: _allNewPresent,
                              icon: Icons.person_add_alt_1_outlined,
                              iconColor: const Color(0xFF10B981),
                              iconBg: const Color(0xFFD1FAE5),
                              showBreakdown: _allNewBreakdown.isNotEmpty,
                              breakdown: _allNewBreakdown,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                label: card1Label,
                                value: _card1Value,
                                icon: Icons.people_outline,
                                iconColor: const Color(0xFF6366F1),
                                iconBg: const Color(0xFFEDE9FE),
                                showBreakdown: _isTotal,
                                breakdown: _card1Breakdown,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _StatCard(
                                label: card2Label,
                                value: _card2Value,
                                icon: Icons.person_add_alt_1_outlined,
                                iconColor: const Color(0xFF10B981),
                                iconBg: const Color(0xFFD1FAE5),
                                showBreakdown: _isTotal,
                                breakdown: _card2Breakdown,
                              ),
                            ),
                          ],
                        ),
                ),

                const SizedBox(height: 10),

                // ── Programme / Chart section ────────────────────────────────
                if (_kalavadha == DurationTypes.daily) ...[
                  if (_isAllLevel) _AllLevelProgrammeBarsSection(aData: _allAData) else _DailyChecklistWidget(activities: _activities),
                ] else ...[
                  if (_isAllLevel)
                    _AllLevelChartSection(
                      activityCharts: _allActivityChartData,
                      kalavadha: _kalavadha,
                    )
                  else
                    _ProgrammeBarsSection(bars: _programmeBars, kalavadha: _kalavadha),
                ],

                const SizedBox(height: 20),
              ]
            ],
          ),
        ),
      ),
    );
  }

  // ── Filter section ─────────────────────────────────────────────────────────

  Widget _filterSection() {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<GeoHierarchyController>(
        builder: (_, ctrl, __) {
          return Column(
            spacing: 12,
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
                    headerBuilder: (_, __) => ListTile(title: Text(Statics.getLabel('TargetGeoUnitDetails'))),
                    body: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                      child: Column(
                        spacing: 8,
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
                            ),

                          if (ctrl.hasItems(GeoLevel.Vasti))
                            GeoDropdownWidget(
                              level: GeoLevel.Vasti,
                              title: 'Vasti',
                              controller: ctrl,
                              decoration: styledDropdownDecoration(Statics.getLabel("Vasti")),
                            ),

                          if (ctrl.hasItems(GeoLevel.Shaakhaa))
                            GeoDropdownWidget(
                              level: GeoLevel.Shaakhaa,
                              title: 'Shaakhaa',
                              controller: ctrl,
                              decoration: styledDropdownDecoration(Statics.getLabel("Shaakhaa")),
                              onChanged: (p0) => _fetchReport(),
                            ),

                          const SizedBox(height: 6),

                          // ── Kalavadhi + Vayogat row ──────────────────
                          Row(
                            spacing: 12,
                            children: [
                              // Kalavadhi dropdown
                              Expanded(
                                child: Column(
                                  spacing: 2,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _FilterLabel('२. कालावधी'),
                                    _AppDropdown<DurationTypes>(
                                      value: _kalavadha,
                                      items: DurationTypes.values,
                                      itemLabel: (v) => v.name,
                                      onChanged: (v) {
                                        setState(() => _kalavadha = v!);
                                        _fetchReport();
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              // Vayogat dropdown — populated from DB with Total prepended
                              if (ctrl.deepestSelectedLevelId != 1)
                                Expanded(
                                  child: Column(
                                    spacing: 2,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _FilterLabel('३. ${Statics.getLabel("Vayogat")}'),
                                      _AppDropdown<StaticMasterBAL>(
                                        value: _selectedVayogat,
                                        items: _vayogatOptions,
                                        // Use staticID-based equality so the sentinel
                                        // and DB items are both matched correctly.
                                        itemKey: (v) => v.staticID?.toString() ?? '',
                                        itemLabel: (v) => v.codeForDisplay ?? '--',
                                        onChanged: (v) {
                                          if (v != null) {
                                            setState(() => _selectedVayogat = v);
                                            _fetchReport();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ── FRD / selection summary banner ───────────────
              if (_isSearched)
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
                              '${Statics.getLabel(ctrl.deepestSelectedLevelName ?? "praant")}: '
                              '${ctrl.deepestSelectedGeoUnitName ?? ""}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1D4ED8),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_kalavadha.name} + ${_selectedVayogat.codeForDisplay ?? ""}',
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
            ],
          );
        },
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

// ─── Generic Dropdown ─────────────────────────────────────────────────────────
//
// Two modes:
//   1. Pass [child] to wrap a custom widget (e.g. GeoDropdownWidget) in the
//      shared border/padding container — value/items/itemLabel are ignored.
//   2. Pass [value], [items], [itemLabel], [onChanged] (and optionally
//      [itemKey] for non-primitive T) to render a standard DropdownButton.

class _AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T>? items;
  final String Function(T)? itemLabel;

  /// Optional key extractor used for value matching when T doesn't implement
  /// value equality (e.g. StaticMasterBAL). When provided, the selected item
  /// is located by comparing itemKey(item) == itemKey(value).
  final String Function(T)? itemKey;

  final ValueChanged<T?>? onChanged;
  final Widget? child;

  const _AppDropdown({
    this.value,
    this.items,
    this.itemLabel,
    this.itemKey,
    this.onChanged,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E5EA), width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: child ?? _buildDropdown(),
      ),
    );
  }

  Widget _buildDropdown() {
    assert(items != null && itemLabel != null && onChanged != null, '_AppDropdown requires items, itemLabel, and onChanged when child is null.');

    // When itemKey is provided, resolve the matched item from the list so that
    // Flutter's DropdownButton value-equality check always finds a match even
    // when T is a class without operator==.
    T? resolvedValue;
    if (value != null && itemKey != null) {
      final key = itemKey!(value as T);
      resolvedValue = items!.cast<T?>().firstWhere(
            (e) => e != null && itemKey!(e) == key,
            orElse: () => null,
          );
    } else {
      resolvedValue = value;
    }

    return DropdownButton<T>(
      value: resolvedValue,
      isExpanded: true,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Color(0xFFFF6B00),
        size: 22,
      ),
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF1C1C1E),
        fontWeight: FontWeight.w500,
      ),
      items: items!
          .map(
            (e) => DropdownMenuItem<T>(
              value: e,
              child: Text(itemLabel!(e)),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

// ─── Stat Card ────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  /// When true (i.e. vayogat == Total / एकुण) the बाल/वि./व्य./प्रौढ
  /// breakdown tile-row is rendered below the divider.
  final bool showBreakdown;

  final List<BreakdownItem> breakdown;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.showBreakdown,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Label row + circular icon ──────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF3A3A3C),
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Full circle — matches the screenshot's large round icon
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // ── Main value ─────────────────────────────────────
          Text(
            value,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1C1E),
            ),
          ),

          // ── Breakdown tiles (only when Total / एकुण selected) ──
          if (showBreakdown) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5EA)),
            const SizedBox(height: 12),
            // Each breakdown item is its own rounded tile
            Row(
              children: breakdown
                  .map(
                    (b) => Expanded(
                      child: Container(
                        // Small gap between tiles via margin on all but last
                        margin: EdgeInsets.only(
                          right: b == breakdown.last ? 0 : 6,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              b.label.substring(0, 3),
                              style: const TextStyle(
                                fontSize: 9,
                                color: Color(0xFF8E8E93),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              b.value,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1C1C1E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Daily Checklist Widget ───────────────────────────────────────────────────
class _DailyChecklistWidget extends StatelessWidget {
  final List<ProgrammeActivity> activities;

  const _DailyChecklistWidget({required this.activities});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFBF5),
              border: Border(
                bottom: BorderSide(color: Color(0xFFFFF3E0), width: 1),
              ),
            ),
            child: Row(
              children: const [
                Icon(Icons.bar_chart_rounded, size: 18, color: Color(0xFFFF6B00)),
                SizedBox(width: 8),
                Text(
                  'दैनिक कार्यक्रम हुआ या नहीं?',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
              ],
            ),
          ),
          ...activities.map((a) => _ChecklistRow(activity: a)),
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  final ProgrammeActivity activity;

  const _ChecklistRow({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF2F2F7), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            activity.name,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1C1C1E),
              fontWeight: FontWeight.w400,
            ),
          ),
          Icon(
            activity.completed ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: 22,
            color: activity.completed ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }
}

// ─── Programme Bars Section ───────────────────────────────────────────────────

class _ProgrammeBarsSection extends StatelessWidget {
  final List<ProgrammeBar> bars;
  final DurationTypes kalavadha;

  const _ProgrammeBarsSection({
    required this.bars,
    required this.kalavadha,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: bars
          .map(
            (bar) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ProgrammeBarCard(bar: bar, kalavadha: kalavadha),
            ),
          )
          .toList(),
    );
  }
}

class _ProgrammeBarCard extends StatelessWidget {
  final ProgrammeBar bar;
  final DurationTypes kalavadha;

  const _ProgrammeBarCard({required this.bar, required this.kalavadha});

  @override
  Widget build(BuildContext context) {
    final hasSubPeriods = bar.subPeriods.isNotEmpty;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  Statics.getLabel(bar.name),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${Statics.getLabel("Total")}: ${bar.totalDays} दिन (${bar.percent.toStringAsFixed(2)}%)',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE65100),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 8,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5EA),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    height: 8,
                    width: constraints.maxWidth * bar.progressFraction,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B00),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
          if (hasSubPeriods) ...[
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: bar.subPeriods.map((sp) => _SubPeriodCell(subPeriod: sp)).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SubPeriodCell extends StatelessWidget {
  final SubPeriod subPeriod;

  const _SubPeriodCell({required this.subPeriod});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 90,
      constraints: BoxConstraints(minWidth: 70, maxWidth: 120),
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
      ),
      child: Column(
        spacing: 2,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subPeriod.label,
            softWrap: true,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subPeriod.days,
            softWrap: true,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Text(
            '${subPeriod.percent}%',
            softWrap: true,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── All-Level Daily Section ──────────────────────────────────────────────────

class _AllDailySection extends StatelessWidget {
  final String totalPresent;
  final List<BreakdownItem> presentBreakdown;
  final String avgPresent;
  final List<BreakdownItem> avgBreakdown;
  final String newPresent;
  final List<BreakdownItem> newBreakdown;
  final List<ActivityData> aData;
  final String selectedVayogatLabel;

  const _AllDailySection({
    required this.totalPresent,
    required this.presentBreakdown,
    required this.avgPresent,
    required this.avgBreakdown,
    required this.newPresent,
    required this.newBreakdown,
    required this.aData,
    required this.selectedVayogatLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              // Row: total attendance + average
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'कुल उपस्थिति ($selectedVayogatLabel)',
                      value: totalPresent,
                      icon: Icons.people_outline,
                      iconColor: const Color(0xFF6366F1),
                      iconBg: const Color(0xFFEDE9FE),
                      showBreakdown: presentBreakdown.isNotEmpty,
                      breakdown: presentBreakdown,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      label: 'आज की सरासरी संख्या',
                      value: avgPresent,
                      icon: Icons.analytics_outlined,
                      iconColor: const Color(0xFFF59E0B),
                      iconBg: const Color(0xFFFEF3C7),
                      showBreakdown: avgBreakdown.isNotEmpty,
                      breakdown: avgBreakdown,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Full-width: new enrollment
              _StatCard(
                label: 'नवीन भरती ($selectedVayogatLabel)',
                value: newPresent,
                icon: Icons.person_add_alt_1_outlined,
                iconColor: const Color(0xFF10B981),
                iconBg: const Color(0xFFD1FAE5),
                showBreakdown: newBreakdown.isNotEmpty,
                breakdown: newBreakdown,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (aData.isNotEmpty) _AllLevelProgrammeBarsSection(aData: aData),
      ],
    );
  }
}

// ─── All-Level Programme Bars ─────────────────────────────────────────────────

class _AllLevelProgrammeBarsSection extends StatelessWidget {
  final List<ActivityData> aData;

  const _AllLevelProgrammeBarsSection({required this.aData});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFBF5),
              border: Border(
                bottom: BorderSide(color: Color(0xFFFFF3E0), width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'कार्यक्रमों के अनुसार स्थिति (%)',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'पूर्ण भरने वाली शाखाओं के आधार पर प्रतिशत',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8E8E93),
                  ),
                ),
              ],
            ),
          ),
          ...aData.map((e) => _AllLevelBarRow(activity: e)),
        ],
      ),
    );
  }
}

class _AllLevelBarRow extends StatelessWidget {
  final ActivityData activity;

  const _AllLevelBarRow({required this.activity});

  @override
  Widget build(BuildContext context) {
    final pct = (double.tryParse(activity.percentage) ?? 0.0).clamp(0.0, 100.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF2F2F7), width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            spacing: 8,
            children: [
              // Activity name
              Expanded(
                child: Text(
                  Statics.getLabel(activity.activity),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1C1C1E),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Percentage label
              Text(
                '${pct.toStringAsFixed(2)}%',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6366F1),
                ),
              ),
            ],
          ),
          // Progress bar
          LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Container(
                  height: 8,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E5EA),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 8,
                  width: constraints.maxWidth * (pct / 100),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// ─── Chart Data Classes ───────────────────────────────────────────────────────

class ChartBarData {
  final String xLabel;
  final int value;
  final String tooltipTitle;

  const ChartBarData({required this.xLabel, required this.value, required this.tooltipTitle});
}

class ActivityChartData {
  final String activityKey;
  final List<ChartBarData> bars;

  const ActivityChartData({required this.activityKey, required this.bars});
}

// ─── All-Level Chart Section ──────────────────────────────────────────────────

class _AllLevelChartSection extends StatefulWidget {
  final List<ActivityChartData> activityCharts;
  final DurationTypes kalavadha;

  const _AllLevelChartSection({required this.activityCharts, required this.kalavadha});

  @override
  State<_AllLevelChartSection> createState() => _AllLevelChartSectionState();
}

class _AllLevelChartSectionState extends State<_AllLevelChartSection> {
  bool _showAll = false;

  String get _sectionTitle {
    switch (widget.kalavadha) {
      case DurationTypes.weekly:
        return 'साप्ताहिक के अनुसार कार्यक्रम करने वाली शाखाएँ';
      case DurationTypes.monthly:
        return 'मासिक के अनुसार कार्यक्रम करने वाली शाखाएँ';
      case DurationTypes.quarterly:
        return 'त्रैमासिक के अनुसार कार्यक्रम करने वाली शाखाएँ';
      case DurationTypes.halfYearly:
        return 'अर्धवार्षिक के अनुसार कार्यक्रम करने वाली शाखाएँ';
      case DurationTypes.yearly:
        return 'वार्षिक के अनुसार कार्यक्रम करने वाली शाखाएँ';
      default:
        return 'कार्यक्रम करने वाली शाखाएँ';
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = _showAll ? widget.activityCharts : widget.activityCharts.take(3).toList();
    final total = widget.activityCharts.length;

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFBF5),
              border: Border(bottom: BorderSide(color: Color(0xFFFFF3E0), width: 1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bar_chart_rounded, size: 18, color: Color(0xFFFF6B00)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _sectionTitle,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1E)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                const Text(
                  'प्रत्येक गतिविधि का सप्ताह/माह के अनुसार बार ग्राफ',
                  style: TextStyle(fontSize: 11, color: Color(0xFF8E8E93)),
                ),
              ],
            ),
          ),

          // Activity charts
          ...visible.map((ac) => _ActivityChartCard(chartData: ac)),

          // Show all button (shows total count, hidden once expanded)
          if (!_showAll && total > 3)
            GestureDetector(
              onTap: () => setState(() => _showAll = true),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'अन्य सभी $total कार्यक्रम देखें',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFFF6B00)),
                ),
              ),
            )
          else
            const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ─── Activity Chart Card ──────────────────────────────────────────────────────

class _ActivityChartCard extends StatefulWidget {
  final ActivityChartData chartData;

  const _ActivityChartCard({required this.chartData});

  @override
  State<_ActivityChartCard> createState() => _ActivityChartCardState();
}

class _ActivityChartCardState extends State<_ActivityChartCard> {
  int? _tappedIndex;

  static const double _tooltipH = 52.0;
  static const double _maxBarH = 120.0;
  static const double _xLabelH = 24.0;
  static const double _barWidth = 36.0;
  static const double _barGap = 12.0;
  static const double _yAxisW = 34.0;

  @override
  Widget build(BuildContext context) {
    final bars = widget.chartData.bars;
    if (bars.isEmpty) return const SizedBox.shrink();

    final maxVal = bars.map((b) => b.value).fold(0, (a, b) => a > b ? a : b);
    final effectiveMax = maxVal == 0 ? 1 : maxVal;

    // 4 evenly-spaced Y-axis labels from bottom (0) to top (max)
    final step = effectiveMax / 3;
    final yLabels = [effectiveMax, (step * 2).round(), step.round(), 0];

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF2F2F7), width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Activity title
          Text(
            Statics.getLabel(widget.chartData.activityKey),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
          ),
          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Y-axis labels — padded top by _tooltipH so labels align with bar tops
              // padded bottom by _xLabelH so labels only span the bar area
              SizedBox(
                width: _yAxisW,
                height: _tooltipH + _maxBarH + _xLabelH,
                child: Padding(
                  padding: const EdgeInsets.only(top: _tooltipH, bottom: _xLabelH),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: yLabels
                        .map((v) => Text(
                              '$v',
                              style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(width: 4),

              // Bars — horizontally scrollable when many
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: bars.length > 5 ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: bars.asMap().entries.map((entry) {
                      final i = entry.key;
                      final bar = entry.value;
                      final isTapped = _tappedIndex == i;
                      final barH = (_maxBarH * (bar.value / effectiveMax)).clamp(4.0, _maxBarH);

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() => _tappedIndex = isTapped ? null : i),
                        child: SizedBox(
                          width: _barWidth + _barGap,
                          height: _tooltipH + _maxBarH + _xLabelH,
                          child: Column(
                            children: [
                              // ── Tooltip reserved space ───────────────────
                              SizedBox(
                                height: _tooltipH,
                                child: isTapped
                                    ? Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: const Color(0xFFFFE0B2), width: 1),
                                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(bar.tooltipTitle, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFFE65100))),
                                              Text('branches : ${bar.value}', style: const TextStyle(fontSize: 10, color: Color(0xFF6366F1))),
                                            ],
                                          ),
                                        ),
                                      )
                                    : null,
                              ),

                              // ── Bar (grows from bottom of this area) ─────
                              SizedBox(
                                height: _maxBarH,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: _barWidth,
                                    height: barH,
                                    decoration: BoxDecoration(
                                      color: isTapped ? const Color(0xFFFFF3E0) : const Color(0xFFFF6B00),
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                      border: isTapped ? Border.all(color: const Color(0xFFFF6B00), width: 1.5) : null,
                                    ),
                                  ),
                                ),
                              ),

                              // ── X label ──────────────────────────────────
                              SizedBox(
                                height: _xLabelH,
                                width: _barWidth + _barGap,
                                child: Center(
                                  child: Text(
                                    bar.xLabel,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 9, color: Colors.grey.shade600, height: 1.2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
