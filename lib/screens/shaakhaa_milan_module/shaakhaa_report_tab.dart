import 'dart:core';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../models/response_model/shaakhaa_milan_report_models.dart';
import '../../providers/bals.dart';
import '../../utils/globals.dart';
import '../../utils/stable_geounit_class.dart';
import 'report_widgets/custom_app_dropdowns.dart';
import 'report_widgets/module_constants.dart';
import 'shaakhaa_ranking_screen.dart';

// ─── Data Models ─────────────────────────────────────────────────────────────

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
  final String parentActivity; // NEW
  final double progressFraction;
  final int totalDays;
  final double percent;
  final List<SubPeriod> subPeriods;

  const ProgrammeBar({
    required this.name,
    required this.parentActivity, // NEW
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
  bool _isCleared = false;
  bool _isExpanded = true;
  String _card1Value = '';
  String _card2Value = '';
  int _shaakhaacount = 0;
  int _milancount = 0;
  int _mansikcount = 0;
  int _sangacount = 0;
  List<BreakdownItem> _card1Breakdown = [];
  List<BreakdownItem> _card2Breakdown = [];
  List<ActivityData> _activities = [];
  List<MapEntry<ActivityData, List<ActivityData>>> _groupedActivitiesList = [];
  List<ProgrammeBar> _programmeBars = [];

  // ── All-level daily (levelId != 1) ────────────────────────────────────────────
  bool _isAllLevel = false;
  int _allTotalPresent = 0;
  List<BreakdownItem> _allPresentBreakdown = [];

// TODO: card 2 average needs shaakhaa count from API — flagged for backend
  String _allAvgPresent = '--';
  List<BreakdownItem> _allAvgBreakdown = [];
  int _allNewPresent = 0;
  List<BreakdownItem> _allNewBreakdown = [];
  List<ActivityData> _allAData = [];

  // ── Add alongside existing all-level vars ─────────────────────────────────────
  List<ActivityChartData> _allActivityChartData = [];

  // ── Top 10 count lists (all-level, non-daily only) ────────────────────────────
  List<TotalCountShaakhaa> _shaakhatotalcount = [];
  List<TotalCountShaakhaa> _shaakhanewcount = [];
  List<TotalCountShaakhaa> _sapthahiktotalcount = [];
  List<TotalCountShaakhaa> _sapthahiknewcount = [];

// ── Add helper (call from every all-level fetch branch) ──────────────────────
  void _mapAllLevelPData(List<PresentList> pData) {
    // _allTotalPresent = pData.fold<int>(0, (s, p) => s + p.totalpresent);
    _allTotalPresent = pData.firstWhere((e) => e.vagogatname == "ekun").totalpresent;
    _allPresentBreakdown = pData.where((e) => e.vagogatname != "ekun").toList().map((p) => BreakdownItem(p.vagogatname, p.totalpresent.toString())).toList();
    // _allNewPresent = pData.fold<int>(0, (s, p) => s + p.totalnewpresent);
    _allNewPresent = pData.firstWhere((e) => e.vagogatname == "ekun").totalnewpresent;
    _allNewBreakdown = pData.where((e) => e.vagogatname != "ekun").toList().map((p) => BreakdownItem(p.vagogatname, p.totalnewpresent.toString())).toList();
    _allAvgPresent = '--'; // TODO: backend to supply shaakhaa count for avg
    _allAvgBreakdown = [];
  }

  // ── Computed labels ────────────────────────────────────────────────────────

  String get card1Label {
    switch (_kalavadha) {
      case DurationTypes.daily:
        return Statics.getLabel('todaystotalupastithi');
      case DurationTypes.weekly:
        return Statics.getLabel('weeklytotalupastithi');
      case DurationTypes.monthly:
        return Statics.getLabel('monthlytotalupastithi');
      case DurationTypes.quarterly:
        return Statics.getLabel('quarterlytotalupastithi');
      case DurationTypes.halfYearly:
        return Statics.getLabel('halfyearlytotalupastithi');
      case DurationTypes.yearly:
        return Statics.getLabel('yearlytotalupastithi');
      default:
        return "";
    }
  }

  String get card2Label {
    switch (_kalavadha) {
      case DurationTypes.daily:
        return Statics.getLabel("todaysNewupastithi");
      case DurationTypes.weekly:
        return Statics.getLabel("weeklyNewupastithi");
      case DurationTypes.monthly:
        return Statics.getLabel("monthlyNewupastithi");
      case DurationTypes.quarterly:
        return Statics.getLabel("quarterlyNewupastithi");
      case DurationTypes.halfYearly:
        return Statics.getLabel("halfyearlyNewupastithi");
      case DurationTypes.yearly:
        return Statics.getLabel("yearlyNewupastithi");
      default:
        return "";
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

  /// Groups flat activity list into parent -> children structure.
  /// - Activities with empty/null parentActivity are treated as top-level.
  /// - An activity becomes a child if its `parentactivity` matches another activity's `activity` name.
  List<MapEntry<ActivityData, List<ActivityData>>> _groupActivities(List<ActivityData> activities) {
    final Set<String> activityNames = activities.map((a) => a.activity).toSet();

    // Top-level = no parent, OR parent doesn't match any known activity (orphan, treat as top-level)
    final topLevel = activities.where((a) {
      return a.parentactivity.isEmpty || !activityNames.contains(a.parentactivity);
    }).toList();

    return topLevel.map((parent) {
      final children = activities.where((a) => a.parentactivity.isNotEmpty && a.parentactivity == parent.activity).toList();
      return MapEntry(parent, children);
    }).toList();
  }

  List<MapEntry<ProgrammeBar, List<ProgrammeBar>>> _groupProgrammeBars(List<ProgrammeBar> bars) {
    final names = bars.map((b) => b.name).toSet();
    final topLevel = bars.where((b) => b.parentActivity.isEmpty || !names.contains(b.parentActivity)).toList();

    return topLevel.map((parent) {
      final children = bars.where((b) => b.parentActivity.isNotEmpty && b.parentActivity == parent.name).toList();
      return MapEntry(parent, children);
    }).toList();
  }

  Future<void> _fetchReport() async {
    _isCleared = true;
    setState(() => _isSearched = false);
    final geoUnitId = int.tryParse(controller.deepestSelectedGeoUnitId ?? "0") ?? 0;

    final req = {
      "AppUserID": int.tryParse(Statics.userDetails["userID"] ?? "5693") ?? "5693",
      "Geounitid": geoUnitId,
      "vayogat": controller.deepestSelectedLevelId != 1 ? _selectedVayogat.staticID : 0,
      "days": _kalavadha.pkValues,
    };

    if (!mounted) return;
    _isExpanded = false;
    setState(() => _isLoading = _isSearched = true);
    final isAll = controller.deepestSelectedLevelId != 1;
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
              setState(() => _isSearched = _isCleared = false);
              return;
            }
            _groupedActivitiesList = _groupActivities(res.data.toList());
            setState(() {
              _card1Value = res.totalpresent.toString();
              _card2Value = res.totalnewpresent.toString();
              _card1Breakdown = [];
              _card2Breakdown = [];

              _activities = res.data.toList();
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
              setState(() => _isSearched = _isCleared = false);
              return;
            }
            setState(() {
              _mapAllLevelPData(res.pData);
              // Programme bars
              _allAData = res.aData;

              _shaakhaacount = res.shaakhaacount ?? 0;
              _milancount = res.milancount ?? 0;
              _mansikcount = res.mansikcount ?? 0;
              _sangacount = res.sangacount ?? 0;

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
              setState(() => _isSearched = _isCleared = false);
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
                  parentActivity: e.parentactivity ?? '',
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
              setState(() => _isSearched = _isCleared = false);
              return;
            }
            setState(() {
              _mapAllLevelPData(res.pData);
              _activities = [];
              _programmeBars = [];

              _shaakhaacount = res.shaakhaacount ?? 0;
              _milancount = res.milancount ?? 0;
              _mansikcount = res.mansikcount ?? 0;
              _sangacount = res.sangacount ?? 0;
              _shaakhatotalcount = res.shaakhatotalcount;
              _shaakhanewcount = res.shaakhanewcount;
              _sapthahiktotalcount = res.sapthahiktotalcount;
              _sapthahiknewcount = res.sapthahiknewcount;
              // Group by Activity → one ActivityChartData per activity
              final grouped = <String, List<AllWeeklyActivity>>{};
              for (final e in res.aData) grouped.putIfAbsent(e.activity, () => []).add(e);
              _allActivityChartData = grouped.entries
                  .map((e) => ActivityChartData(
                        activityKey: e.key,
                        bars: e.value
                            .map((w) => ChartBarData(
                                  xLabel: '${w.timesDone} ${Statics.getLabel("daysonly")}',
                                  value: w.shaakhaCount,
                                  tooltipTitle: '${w.timesDone} ${Statics.getLabel("daysonly")}',
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
              setState(() => _isSearched = _isCleared = false);
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
                  parentActivity: e.parentactivity,
                  progressFraction: pct / 100,
                  totalDays: e.total28Days,
                  percent: pct,
                  subPeriods: [
                    SubPeriod(
                      e.week1Range.isNotEmpty ? e.week1Range : '${Statics.getLabel("weekOnly")} १',
                      '${e.week1} ${Statics.getLabel("daysonly")}',
                      (double.tryParse(e.week1Percent) ?? 0).toStringAsFixed(2),
                    ),
                    SubPeriod(
                      e.week2Range.isNotEmpty ? e.week2Range : '${Statics.getLabel("weekOnly")} २',
                      '${e.week2} ${Statics.getLabel("daysonly")}',
                      (double.tryParse(e.week2Percent) ?? 0).toStringAsFixed(2),
                    ),
                    SubPeriod(
                      e.week3Range.isNotEmpty ? e.week3Range : '${Statics.getLabel("weekOnly")} ३',
                      '${e.week3} ${Statics.getLabel("daysonly")}',
                      (double.tryParse(e.week3Percent) ?? 0).toStringAsFixed(2),
                    ),
                    SubPeriod(
                      e.week4Range.isNotEmpty ? e.week4Range : '${Statics.getLabel("weekOnly")} ४',
                      '${e.week4} ${Statics.getLabel("daysonly")}',
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
              setState(() => _isSearched = _isCleared = false);
              return;
            }
            setState(() {
              _mapAllLevelPData(res.pData);
              _activities = [];
              _programmeBars = [];

              _shaakhaacount = res.shaakhaacount ?? 0;
              _milancount = res.milancount ?? 0;
              _mansikcount = res.mansikcount ?? 0;
              _sangacount = res.sangacount ?? 0;
              _shaakhatotalcount = res.shaakhatotalcount;
              _shaakhanewcount = res.shaakhanewcount;
              _sapthahiktotalcount = res.sapthahiktotalcount;
              _sapthahiknewcount = res.sapthahiknewcount;
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
              setState(() => _isSearched = _isCleared = false);
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
                  parentActivity: e.parentactivity,
                  progressFraction: avgPct / 100,
                  totalDays: totalDays,
                  percent: avgPct,
                  subPeriods: e.months
                      .map((m) => SubPeriod(
                            m.range.isNotEmpty ? m.range : '${m.monthNo} ${Statics.getLabel("monthOnly")}',
                            '${m.value} ${Statics.getLabel("daysonly")}',
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
              setState(() => _isSearched = _isCleared = false);
              return;
            }
            setState(() {
              _mapAllLevelPData(res.pData);
              _activities = [];
              _programmeBars = [];

              _shaakhaacount = res.shaakhaacount ?? 0;
              _milancount = res.milancount ?? 0;
              _mansikcount = res.mansikcount ?? 0;
              _sangacount = res.sangacount ?? 0;
              _shaakhatotalcount = res.shaakhatotalcount;
              _shaakhanewcount = res.shaakhanewcount;
              _sapthahiktotalcount = res.sapthahiktotalcount;
              _sapthahiknewcount = res.sapthahiknewcount;
              _allActivityChartData = res.aData
                  .map((e) => ActivityChartData(
                        activityKey: e.activity,
                        bars: e.months
                            .map((m) => ChartBarData(
                                  xLabel: m.range.isNotEmpty ? m.range : '${m.monthNo} ${Statics.getLabel("monthOnly")}',
                                  value: m.value,
                                  tooltipTitle: m.range.isNotEmpty ? m.range : '${m.monthNo} ${Statics.getLabel("monthOnly")}',
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
      if (mounted) setState(() => _isLoading = _isCleared = false);
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
              else if (_isCleared)
                SizedBox(height: 170)
              else if (!_isSearched)
                SizedBox(height: 170, child: Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch'))))
              else ...[
                // ── Stat Cards ──────────────────────────────────────────────
                if (controller.deepestSelectedLevelId != 1) ...[
                  Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: _statCard(Statics.getLabel("shaakhaaCount"), _shaakhaacount.toString()),
                      ),
                      Expanded(
                        child: _statCard(Statics.getLabel("saaptaahikMilanCount"), _milancount.toString()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: _statCard(Statics.getLabel("masikMilanCount"), _mansikcount.toString()),
                      ),
                      Expanded(
                        child: _statCard(Statics.getLabel("sanghaCount"), _sangacount.toString()),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _isAllLevel
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              spacing: 8,
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    label: card1Label,
                                    value: _allTotalPresent.toString(),
                                    icon: Icons.people_outline,
                                    iconColor: const Color(0xFF6366F1),
                                    iconBg: const Color(0xFFEDE9FE),
                                    showBreakdown: _allPresentBreakdown.isNotEmpty && _selectedVayogat.staticID == 0,
                                    breakdown: _allPresentBreakdown,
                                  ),
                                ),
                                /*Expanded(
                                  child: _StatCard(
                                    label: 'आज की सरासरी संख्या',
                                    value: _allAvgPresent,
                                    icon: Icons.analytics_outlined,
                                    iconColor: const Color(0xFFF59E0B),
                                    iconBg: const Color(0xFFFEF3C7),
                                    showBreakdown: false,
                                    breakdown: const [],
                                  ),
                                ),*/
                              ],
                            ),
                            const SizedBox(height: 10),
                            _StatCard(
                              label: card2Label,
                              value: _allNewPresent.toString(),
                              icon: Icons.person_add_alt_1_outlined,
                              iconColor: const Color(0xFF10B981),
                              iconBg: const Color(0xFFD1FAE5),
                              showBreakdown: _allNewBreakdown.isNotEmpty && _selectedVayogat.staticID == 0,
                              breakdown: _allNewBreakdown,
                            ),
                          ],
                        )
                      : Row(
                          spacing: 8,
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
                if (controller.ctrlUserLevelId == 1) navigateToRanking(),
                const SizedBox(height: 10),

                // ── Programme / Chart section ────────────────────────────────
                if (_kalavadha == DurationTypes.daily) ...[
                  if (_isAllLevel) _AllLevelProgrammeBarsSection(aData: _allAData) else _DailyChecklistWidget(groupActivities: _groupedActivitiesList),
                ] else ...[
                  if (_isAllLevel)
                    AllLevelChartSection(
                      activityCharts: _allActivityChartData,
                      kalavadha: _kalavadha,
                    )
                  else
                    _ProgrammeBarsSection(grouped: _groupProgrammeBars(_programmeBars), kalavadha: _kalavadha),
                ],

                // ── Top 10 — only when all-level + non-daily ──────────────
                if (_isAllLevel && _kalavadha != DurationTypes.daily)
                  _Top10ShaakhaaSection(
                    shaakhatotalcount: _shaakhatotalcount,
                    shaakhanewcount: _shaakhanewcount,
                    sapthahiktotalcount: _sapthahiktotalcount,
                    sapthahiknewcount: _sapthahiknewcount,
                    activityKeys: _allActivityChartData.map((e) => e.activityKey).toList(),
                    geoUnitId: int.tryParse(controller.deepestSelectedGeoUnitId ?? "0") ?? 0,
                    vayogat: _selectedVayogat.staticID ?? 0,
                    days: _kalavadha.pkValues,
                  ),
                const SizedBox(height: 20),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget navigateToRanking() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(ShaakhaaRankingScreen.routeName),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B00), Color(0xFFFF8C00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B00).withOpacity(0.30),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Icon block ─────────────────────────────────────────────────
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),

            const SizedBox(width: 14),

            // ── Text ───────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Statics.getLabel('shaakhaaRanking'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    Statics.getLabel('shaakhaaRankingSubTitle'),
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.white70,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // ── Arrow ──────────────────────────────────────────────────────
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 15,
              ),
            ),
          ],
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
                            onChanged: (p0) => setState(() => _isCleared = true),
                          ),

                          GeoDropdownWidget(
                            level: GeoLevel.Vibhaag,
                            title: 'Vibhaag',
                            controller: ctrl,
                            decoration: styledDropdownDecoration(Statics.getLabel("Vibhaag")),
                            onChanged: (p0) => setState(() => _isCleared = true),
                          ),

                          if (ctrl.hasItems(GeoLevel.Bhaag))
                            GeoDropdownWidget(
                              level: GeoLevel.Bhaag,
                              title: 'Bhaag',
                              controller: ctrl,
                              decoration: styledDropdownDecoration(Statics.getLabel("Bhaag")),
                              onChanged: (p0) => setState(() => _isCleared = true),
                            ),

                          if (ctrl.hasItems(GeoLevel.Nagar))
                            GeoDropdownWidget(
                              level: GeoLevel.Nagar,
                              title: 'Nagar',
                              controller: ctrl,
                              decoration: styledDropdownDecoration(Statics.getLabel("Nagar")),
                              onChanged: (p0) => setState(() => _isCleared = true),
                            ),

                          if (ctrl.hasItems(GeoLevel.upnagarUpkhanda))
                            GeoDropdownWidget(
                              level: GeoLevel.upnagarUpkhanda,
                              title: 'upnagarUpkhanda',
                              controller: ctrl,
                              decoration: styledDropdownDecoration(Statics.getLabel("upnagarUpkhanda")),
                              onChanged: (p0) => setState(() => _isCleared = true),
                            ),

                          if (ctrl.hasItems(GeoLevel.Mandal))
                            GeoDropdownWidget(
                              level: GeoLevel.Mandal,
                              title: 'Mandal',
                              controller: ctrl,
                              decoration: styledDropdownDecoration(Statics.getLabel("Mandal")),
                              onChanged: (p0) => setState(() => _isCleared = true),
                            ),

                          if (ctrl.hasItems(GeoLevel.Graam))
                            GeoDropdownWidget(
                              level: GeoLevel.Graam,
                              title: 'Graam',
                              controller: ctrl,
                              decoration: styledDropdownDecoration(Statics.getLabel("Graam")),
                              onChanged: (p0) => setState(() => _isCleared = true),
                              isSankalpit: true,
                            ),

                          if (ctrl.hasItems(GeoLevel.Vasti))
                            GeoDropdownWidget(
                              level: GeoLevel.Vasti,
                              title: 'Vasti',
                              controller: ctrl,
                              decoration: styledDropdownDecoration(Statics.getLabel("Vasti")),
                              onChanged: (p0) => setState(() => _isCleared = true),
                              isSankalpit: true,
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
                                    _FilterLabel('२. ${Statics.getLabel("duration")}'),
                                    AppDropdown<DurationTypes>(
                                      value: _kalavadha,
                                      items: DurationTypes.values.where((e) => e != DurationTypes.today && e != DurationTypes.yesterday).toList(),
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
                                            _fetchReport();
                                          }
                                        },
                                      ),
                                    ],
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
                                  onPressed: _fetchReport,
                                  child: Text(
                                    Statics.getLabel('Search'),
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),

                                // Vayogat dropdown — populated from DB with Total prepended
                                MaterialButton(
                                    onPressed: () {
                                      print("clear button pressed");
                                      _isCleared = true;
                                      setState(() => _isSearched = false);
                                      ctrl.loadHierarchyForUser();
                                    },
                                    child: Text(Statics.getLabel('clear')))
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
                              '${_kalavadha.name} ${ctrl.deepestSelectedLevelId != 1 ? "+ ${_selectedVayogat.codeForDisplay ?? ""}" : ""}',
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
                  .toList()
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
                              b.label.contains("Proudh")
                                  ? Statics.getLabel(b.label.replaceAll(' ', ''), returnKey: true).split(" ").first
                                  : Statics.getLabel(b.label.replaceAll(' ', '') == "TarunVidyaarthi" ? "mahavidya" : b.label.replaceAll(' ', ''), returnKey: true).substring(0, 3),
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
  // final List<ActivityData> activities;
  final List<MapEntry<ActivityData, List<ActivityData>>> groupActivities;

  const _DailyChecklistWidget({required this.groupActivities});

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
          // ...activities.map((a) => _ChecklistRow(activity: a)),
          ...groupActivities.map((entry) {
            final parent = entry.key;
            final children = entry.value;
            return children.isEmpty ? _ChecklistRow(activity: parent) : _ExpandableParentTile(parent: parent, children: children);
          }),
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  final ActivityData activity;
  final bool isChild;

  const _ChecklistRow({required this.activity, this.isChild = false});

  @override
  Widget build(BuildContext context) {
    final bool isDone = activity.value >= 1;
    final Color statusColor = isDone ? const Color(0xFF22C55E) : const Color(0xFFEF4444);

    return Container(
      decoration: BoxDecoration(
        color: isChild ? const Color(0xFFFAFAFC) : Colors.white,
        border: const Border(
          bottom: BorderSide(color: Color(0xFFF2F2F7), width: 1),
        ),
      ),
      padding: EdgeInsets.only(
        left: isChild ? 0 : 16, // no left padding for children; stub handles spacing
        right: 16,
        top: isChild ? 12 : 16,
        bottom: isChild ? 12 : 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                if (isChild) ...[
                  // horizontal stub connecting the shared trunk line to the label
                  Container(
                    margin: const EdgeInsets.only(left: 28),
                    width: 16,
                    height: 1.5,
                    color: const Color(0xFFD1D1D6),
                  ),
                  const SizedBox(width: 8),
                ] else
                  const SizedBox.shrink(),
                Expanded(
                  child: Text(
                    Statics.getLabel(activity.activity, returnKey: true),
                    style: TextStyle(
                      fontSize: isChild ? 13.5 : 14.5,
                      color: isChild ? const Color(0xFF48484A) : const Color(0xFF1C1C1E),
                      fontWeight: isChild ? FontWeight.w400 : FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: isChild ? 26 : 30,
            height: isChild ? 26 : 30,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDone ? Icons.check_rounded : Icons.close_rounded,
              size: isChild ? 15 : 18,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableParentTile extends StatelessWidget {
  final ActivityData parent;
  final List<ActivityData> children;

  const _ExpandableParentTile({required this.parent, required this.children});

  static const double _rowHeight = 52; // fixed height assumption per child row (single-line text)
  static const double _trunkX = 28;

  @override
  Widget build(BuildContext context) {
    final bool isDone = parent.value >= 1;
    final Color statusColor = isDone ? const Color(0xFF22C55E) : const Color(0xFFEF4444);

    return Theme(
      // strip default divider lines ExpansionTile adds, we already draw our own borders
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: PageStorageKey(parent.activity),
        // preserves expand state across rebuilds/_fetchData()
        initiallyExpanded: true,
        // keep existing "always visible" behavior by default
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: EdgeInsets.zero,
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        controlAffinity: ListTileControlAffinity.leading,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                Statics.getLabel(parent.activity, returnKey: true),
                style: const TextStyle(
                  fontSize: 14.5,
                  color: Color(0xFF1C1C1E),
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDone ? Icons.check_rounded : Icons.close_rounded,
                size: 18,
                color: statusColor,
              ),
            ),
          ],
        ),
        // default chevron auto-appears here, animated by ExpansionTile itself
        children: [
          Stack(
            children: [
              if (children.length > 1)
                Positioned(
                  left: _trunkX,
                  top: 0,
                  child: Container(
                    width: 1.5,
                    height: (children.length - 1) * _rowHeight + (_rowHeight / 2),
                    color: const Color(0xFFD1D1D6),
                  ),
                ),
              Column(
                children: children
                    .map((c) => SizedBox(
                          height: _rowHeight,
                          child: _ChecklistRow(activity: c, isChild: true),
                        ))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Programme Bars Section ───────────────────────────────────────────────────

class _ProgrammeBarsSection extends StatelessWidget {
  // final List<ProgrammeBar> bars;
  final List<MapEntry<ProgrammeBar, List<ProgrammeBar>>> grouped;
  final DurationTypes kalavadha;

  const _ProgrammeBarsSection({required this.grouped, required this.kalavadha});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: grouped.map((entry) {
        final parent = entry.key;
        final children = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: children.isEmpty ? _ProgrammeBarCard(bar: parent, kalavadha: kalavadha) : _ExpandableProgrammeBarGroup(parent: parent, children: children, kalavadha: kalavadha),
        );
      }).toList(),
    );
  }
}

class _ProgrammeBarCard extends StatelessWidget {
  final ProgrammeBar bar;
  final DurationTypes kalavadha;
  final bool isChild; // NEW
  final bool embedded; // NEW

  const _ProgrammeBarCard({
    required this.bar,
    required this.kalavadha,
    this.isChild = false,
    this.embedded = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                Statics.getLabel(bar.name, returnKey: true),
                style: TextStyle(
                  fontSize: isChild ? 13.5 : 15,
                  fontWeight: isChild ? FontWeight.w500 : FontWeight.w600,
                  color: const Color(0xFF1C1C1E),
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${Statics.getLabel("Total")}: ${bar.totalDays} ${Statics.getLabel("daysonly")} (${bar.percent.toStringAsFixed(2)}%)',
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE65100),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5EA),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: bar.progressFraction.isNaN ? 0.0 : bar.progressFraction.clamp(0.0, 1.0).toDouble(),
              alignment: Alignment.centerLeft,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B00),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        if (bar.subPeriods.isNotEmpty) ...[
          const SizedBox(height: 14),
          SingleChildScrollView(
            controller: ScrollController(keepScrollOffset: false),
            primary: false,
            padding: EdgeInsets.only(left: 12),
            scrollDirection: Axis.horizontal,
            child: Row(
              // shrinkWrap: true,scrollDirection: Axis.horizontal,
              spacing: 6,
              children: bar.subPeriods.map((sp) => _SubPeriodCell(subPeriod: sp)).toList(),
            ),
          ),
        ],
      ],
    );

    if (embedded) return content; // parent wrapper below supplies the box + padding

    return Container(
      decoration: BoxDecoration(
        color: isChild ? const Color(0xFFFAFAFC) : Colors.white,
        borderRadius: BorderRadius.circular(isChild ? 8 : 0),
        border: isChild ? Border.all(color: const Color(0xFFF0F0F0)) : null,
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: content,
    );
  }
}

class _ExpandableProgrammeBarGroup extends StatelessWidget {
  final ProgrammeBar parent;
  final List<ProgrammeBar> children;
  final DurationTypes kalavadha;

  const _ExpandableProgrammeBarGroup({
    required this.parent,
    required this.children,
    required this.kalavadha,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: ExpansionTile(
          key: PageStorageKey(parent.name),
          controlAffinity: ListTileControlAffinity.leading,
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          childrenPadding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
          title: _ProgrammeBarCard(bar: parent, kalavadha: kalavadha, embedded: true),
          children: List.generate(children.length, (i) {
            final isLast = i == children.length - 1;
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 28,
                    child: CustomPaint(painter: _TreeLinePainter(isLast: isLast)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ProgrammeBarCard(
                        key: ValueKey(children[i].name),
                        bar: children[i],
                        kalavadha: kalavadha,
                        isChild: true,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
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
      // margin: const EdgeInsets.only(right: 6),
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

class AllLevelChartSection extends StatefulWidget {
  final List<ActivityChartData> activityCharts;
  final DurationTypes kalavadha;

  const AllLevelChartSection({
    super.key,
    required this.activityCharts,
    required this.kalavadha,
  });

  @override
  State<AllLevelChartSection> createState() => _AllLevelChartSectionState();
}

class _AllLevelChartSectionState extends State<AllLevelChartSection> {
  bool _showAll = false;

  String get _sectionTitle {
    switch (widget.kalavadha) {
      case DurationTypes.weekly:
        return "${Statics.getLabel("reportBarGraphTitle")} ${Statics.getLabel("weekly")}";
      case DurationTypes.monthly:
        return "${Statics.getLabel("reportBarGraphTitle")} ${Statics.getLabel("monthly")}";
      case DurationTypes.quarterly:
        return "${Statics.getLabel("reportBarGraphTitle")} ${Statics.getLabel("quarterly")}";
      case DurationTypes.halfYearly:
        return "${Statics.getLabel("reportBarGraphTitle")} ${Statics.getLabel("halfyearly")}";
      case DurationTypes.yearly:
        return "${Statics.getLabel("reportBarGraphTitle")} ${Statics.getLabel("yearly")}";
      default:
        return Statics.getLabel("reportBarGraphTitle");
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
          // ── Section header ───────────────────────────────────
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
              children: [
                Row(
                  children: [
                    const Icon(Icons.bar_chart_rounded, size: 18, color: Color(0xFFFF6B00)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _sectionTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C1C1E),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  Statics.getLabel('reportBarGraphSubtitle'),
                  style: TextStyle(fontSize: 11, color: Color(0xFF8E8E93)),
                ),
              ],
            ),
          ),

          // ── Activity charts ──────────────────────────────────
          ...visible.map((ac) => _ActivityChartCard(chartData: ac, kalavadha: widget.kalavadha)),

          // ── Show-all / bottom padding ────────────────────────
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF6B00),
                  ),
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
  final DurationTypes kalavadha;

  const _ActivityChartCard({required this.chartData, required this.kalavadha});

  @override
  State<_ActivityChartCard> createState() => _ActivityChartCardState();
}

class _ActivityChartCardState extends State<_ActivityChartCard> {
  int _tappedIndex = -1;

  // ── Layout constants ──────────────────────────────────────────────────────

  /// Height of the bar-drawing area only (no titles).
  static const double _barAreaHeight = 160.0;

  /// Space fl_chart reserves at the top for our tooltip widget.
  static const double _tooltipReservedH = 62.0;

  /// Space fl_chart reserves at the bottom for x-axis labels.
  static const double _xLabelReservedH = 32.0;

  /// Total canvas height = tooltip space + bars + x-labels.
  static const double _totalChartH = _tooltipReservedH + _barAreaHeight + _xLabelReservedH;

  String? get _sectionTitle {
    switch (widget.kalavadha) {
      case DurationTypes.monthly:
        return Statics.getLabel("weekOnly");
      case DurationTypes.quarterly:
        return Statics.getLabel("monthOnly");
      case DurationTypes.halfYearly:
        return Statics.getLabel("monthOnly");
      case DurationTypes.yearly:
        return Statics.getLabel("monthOnly");
      default:
        return null;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  int _niceMax(int rawMax) {
    if (rawMax <= 0) return 10;
    const steps = [1, 2, 5, 10, 20, 25, 50, 100, 200, 250, 500, 1000];
    final magnitude = rawMax <= 10 ? 1 : (rawMax <= 100 ? 10 : 100);
    for (final s in steps) {
      final candidate = (rawMax / (s * magnitude)).ceil() * s * magnitude;
      if (candidate >= rawMax) return candidate;
    }
    return rawMax;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bars = widget.chartData.bars;
    if (bars.isEmpty) return const SizedBox.shrink();

    final rawMax = bars.map((b) => b.value).fold(0, (a, b) => a > b ? a : b);
    final maxY = _niceMax(rawMax).toDouble();
    final yInterval = maxY / 3;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF2F2F7), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Activity title ──────────────────────────────────
          Text(
            Statics.getLabel(widget.chartData.activityKey),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 10),

          // ── Y-axis labels + chart — no scrolling ───────────
          // Both sit in a fixed-height SizedBox so the inner
          // Column(spaceBetween) always has a bounded parent.
          SizedBox(
            height: _totalChartH,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Y-axis labels (pinned left) ──────────────
                SizedBox(
                  width: 30,
                  height: _totalChartH,
                  child: Padding(
                    // Push labels down past the tooltip reservation so
                    // they align with the actual bar-drawing area.
                    padding: const EdgeInsets.only(
                      top: _tooltipReservedH,
                      bottom: _xLabelReservedH,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [maxY, maxY * 2 / 3, maxY / 3, 0.0]
                          .map(
                            (v) => Text(
                              v.toInt().toString(),
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),

                const SizedBox(width: 4),

                // ── BarChart fills remaining width exactly ────
                // Expanded gives fl_chart a tight bounded width.
                // spaceAround distributes up to 12 bars evenly
                // across the full device width — no scroll needed.
                Expanded(
                  child: SizedBox(
                    height: _totalChartH,
                    child: BarChart(
                      _buildChartData(bars: bars, maxY: maxY, yInterval: yInterval, bottomTitle: _sectionTitle, kalavadha: widget.kalavadha),
                      swapAnimationDuration: const Duration(milliseconds: 200),
                      swapAnimationCurve: Curves.easeOut,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Chart data builder ─────────────────────────────────────────────────────

  BarChartData _buildChartData({
    required List<ChartBarData> bars,
    required double maxY,
    required double yInterval,
    required String? bottomTitle,
    required DurationTypes? kalavadha,
  }) {
    /// Visual rod width handed to fl_chart.
    double _barRodWidth = widget.kalavadha == DurationTypes.yearly ? 21.0 : 28;

    return BarChartData(
      maxY: maxY,
      minY: 0,

      // ── Touch / tap ────────────────────────────────────────
      barTouchData: BarTouchData(
        enabled: true,
        // Disable fl_chart's built-in floating tooltip entirely;
        // we render our custom tooltip inside topTitles instead.
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 0,
          getTooltipItem: (_, __, ___, ____) => null,
        ),
        touchCallback: (event, response) {
          if (event is FlTapUpEvent) {
            final tappedIdx = response?.spot?.touchedBarGroupIndex ?? -1;
            setState(() {
              _tappedIndex = _tappedIndex == tappedIdx ? -1 : tappedIdx;
            });
          }
        },
      ),

      // ── Grid ───────────────────────────────────────────────
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: yInterval,
        getDrawingHorizontalLine: (_) => const FlLine(
          color: Color(0xFFE5E5EA),
          strokeWidth: 1,
          dashArray: [4, 4],
        ),
      ),

      // ── Border — bottom axis line only ─────────────────────
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE5E5EA), width: 1),
        ),
      ),

      // ── Titles ─────────────────────────────────────────────
      titlesData: FlTitlesData(
        show: true,
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),

        // Top title slot is used exclusively to render our custom tooltip.
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: _tooltipReservedH,
            getTitlesWidget: (x, _) {
              final idx = x.toInt();
              if (idx != _tappedIndex || idx < 0 || idx >= bars.length) {
                return const SizedBox.shrink();
              }
              final bar = bars[idx];
              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFFFFE0B2),
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kalavadha == DurationTypes.monthly ? bar.tooltipTitle : bar.tooltipTitle.replaceFirst("-", "-\n"),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE65100),
                        ),
                      ),
                      Text(
                        '${Statics.getLabel("Shaakhaa")} : ${bar.value}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Bottom titles = x-axis labels.
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: _xLabelReservedH,
            getTitlesWidget: (x, _) {
              final idx = x.toInt();
              if (idx < 0 || idx >= bars.length) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  bottomTitle != null ? "$bottomTitle ${idx + 1}" : bars[idx].xLabel,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade600,
                    height: 1.2,
                  ),
                ),
              );
            },
          ),
        ),
      ),

      // ── Bar groups ─────────────────────────────────────────
      barGroups: bars.asMap().entries.map((entry) {
        final i = entry.key;
        final bar = entry.value;
        final isTapped = _tappedIndex == i;

        return BarChartGroupData(
          x: i,
          barsSpace: 0,
          barRods: [
            BarChartRodData(
              toY: bar.value.toDouble(),
              width: _barRodWidth,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
              color: isTapped ? const Color(0xFFFFF3E0) : const Color(0xFFFF6B00),
              borderSide: isTapped
                  ? const BorderSide(
                      color: Color(0xFFFF6B00),
                      width: 1.5,
                    )
                  : BorderSide.none,
            ),
          ],
        );
      }).toList(),

      // groupsSpace drives the horizontal gap between bar groups.
      // Together with _barRodWidth this gives each group _barGroupWidth px.
      // groupsSpace: _barGroupWidth - _barRodWidth,
      // groupsSpace: 12,
      alignment: BarChartAlignment.spaceAround,
    );
  }
}
// ─── Top 10 Enums ─────────────────────────────────────────────────────────────

enum _Top10Tab { shaakhaa, saptahikMilan }

// ─── Top 10 Section ───────────────────────────────────────────────────────────

class _Top10ShaakhaaSection extends StatefulWidget {
  final List<TotalCountShaakhaa> shaakhatotalcount;
  final List<TotalCountShaakhaa> shaakhanewcount;
  final List<TotalCountShaakhaa> sapthahiktotalcount;
  final List<TotalCountShaakhaa> sapthahiknewcount;
  final List<String> activityKeys;
  final int geoUnitId;
  final int vayogat;
  final int days;

  const _Top10ShaakhaaSection({
    required this.shaakhatotalcount,
    required this.shaakhanewcount,
    required this.sapthahiktotalcount,
    required this.sapthahiknewcount,
    required this.activityKeys,
    required this.geoUnitId,
    required this.vayogat,
    required this.days,
  });

  @override
  State<_Top10ShaakhaaSection> createState() => _Top10ShaakhaaSectionState();
}

class _Top10ShaakhaaSectionState extends State<_Top10ShaakhaaSection> {
  _Top10Tab _tab = _Top10Tab.shaakhaa;
  RankTab _filter = RankTab.upasthiti;

  // Karyakram state
  String _selectedKname = karyakramItems.first.key;
  bool _kLoading = false;
  List<TotalCountShaakhaa> _karyakramList = [];

  // Resolve list for upasthiti / naveen filters
  List<TotalCountShaakhaa> get _activeList {
    if (_tab == _Top10Tab.shaakhaa) {
      return _filter == RankTab.upasthiti ? widget.shaakhatotalcount : widget.shaakhanewcount;
    } else {
      return _filter == RankTab.upasthiti ? widget.sapthahiktotalcount : widget.sapthahiknewcount;
    }
  }

  // Called whenever tab/kname changes while on कार्यक्रम filter
  Future<void> _fetchKaryakram() async {
    if (!mounted) return;
    setState(() {
      _kLoading = true;
      _karyakramList = [];
    });

    try {
      final req = {
        "AppUserID": int.tryParse(Statics.userDetails["userID"] ?? "5693") ?? "5693",
        "Geounitid": widget.geoUnitId,
        "vayogat": widget.vayogat,
        "days": widget.days,
        "isshakha": _tab == _Top10Tab.shaakhaa ? 1 : 0,
        "kname": _selectedKname,
      };

      final res = await Statics.fetchKaryakram(req);
      if (!mounted) return;
      if (res != null && res.status == 'Success') {
        setState(() => _karyakramList = res.mdata.take(10).toList());
      }
    } catch (e) {
      debugPrint('Karyakram fetch error: $e');
    } finally {
      if (mounted) setState(() => _kLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showKaryakram = _filter == RankTab.kaaryakram;
    final top10 = showKaryakram ? _karyakramList : _activeList.take(10).toList();

    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFF3E0), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: const [
                Icon(Icons.emoji_events_rounded, color: Color(0xFFFF6B00), size: 20),
                SizedBox(width: 6),
                Icon(Icons.star_rounded, color: Color(0xFFFFBF00), size: 16),
                SizedBox(width: 6),
                Text(
                  'शीर्ष 10 उत्कृष्ट शाखा',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
              ],
            ),
          ),

          // ── Tab row ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(child: _buildTab('शाखा', _Top10Tab.shaakhaa)),
                const SizedBox(width: 8),
                Expanded(child: _buildTab('साप्ताहिक मिलन', _Top10Tab.saptahikMilan)),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Filter chips ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _buildChip('उपस्थिति', RankTab.upasthiti),
                const SizedBox(width: 8),
                _buildChip('नवीन भरती', RankTab.naveenBharti),
                const SizedBox(width: 8),
                _buildChip('कार्यक्रम', RankTab.kaaryakram),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Karyakram activity dropdown ───────────────────────────────────
          if (showKaryakram) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'रैंकिंग के लिए विशिष्ट कार्यक्रम चुनें:',
                    style: TextStyle(fontSize: 11, color: Color(0xFF8E8E93)),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE5E5EA), width: 1.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedKname,
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
                        items: karyakramItems
                            .map((e) => DropdownMenuItem(
                                  value: e.key,
                                  child: Text(Statics.getLabel(e.value, returnKey: true)),
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => _selectedKname = v);
                            _fetchKaryakram();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          const Divider(height: 1, color: Color(0xFFF2F2F7)),

          // ── List / loader / empty ─────────────────────────────────────────
          if (showKaryakram && _kLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFFFF6B00)),
              ),
            )
          else if (top10.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Center(
                child: Text(
                  'कोई डेटा उपलब्ध नहीं',
                  style: TextStyle(fontSize: 13, color: Color(0xFF8E8E93)),
                ),
              ),
            )
          else
            ...top10.asMap().entries.map(
                  (e) => _RankRow(rank: e.key + 1, item: e.value),
                ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTab(String label, _Top10Tab tab) {
    final sel = _tab == tab;
    return GestureDetector(
      onTap: () {
        setState(() => _tab = tab);
        // Re-fetch if already on कार्यक्रम filter
        if (_filter == RankTab.kaaryakram) _fetchKaryakram();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: sel ? const Color(0xFFFF6B00) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: sel ? const Color(0xFFFF6B00) : const Color(0xFFE5E5EA),
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: sel ? Colors.white : const Color(0xFF8E8E93),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, RankTab filter) {
    final sel = _filter == filter;
    return GestureDetector(
      onTap: () {
        setState(() => _filter = filter);
        // Trigger fetch when switching TO कार्यक्रम
        if (filter == RankTab.kaaryakram && _karyakramList.isEmpty) {
          _fetchKaryakram();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: sel ? const Color(0xFFE65100) : const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: sel ? Colors.white : const Color(0xFF6B6B6B),
          ),
        ),
      ),
    );
  }
}

// ─── Rank Row ─────────────────────────────────────────────────────────────────

class _RankRow extends StatelessWidget {
  final int rank;
  final TotalCountShaakhaa item;

  const _RankRow({required this.rank, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF2F2F7), width: 1)),
      ),
      child: Row(
        children: [
          // ── Rank indicator ───────────────────────────────────────────────
          SizedBox(width: 30, child: _rankWidget()),

          const SizedBox(width: 12),

          // ── Branch info ──────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.shaakhaname,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.trailname.isNotEmpty ? item.trailname : 'कुल आधार',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),

          // ── Score chip ───────────────────────────────────────────────────
          Container(
            constraints: const BoxConstraints(minWidth: 44),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${item.totalpresent}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE65100),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rankWidget() {
    switch (rank) {
      case 1:
        return const Icon(Icons.emoji_events_rounded, color: Color(0xFFFFBF00), size: 28);
      case 2:
        return const Icon(Icons.emoji_events_rounded, color: Color(0xFFADB5BD), size: 26);
      case 3:
        return const Icon(Icons.emoji_events_rounded, color: Color(0xFFCD7F32), size: 24);
      default:
        return Center(
          child: Text(
            '$rank',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8E8E93),
            ),
          ),
        );
    }
  }
}

class _TreeLinePainter extends CustomPainter {
  final bool isLast;

  _TreeLinePainter({required this.isLast});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD1D1D6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final double midY = size.height / 2;
    final double centerX = size.width / 2;

    canvas.drawLine(Offset(centerX, 0), Offset(centerX, midY), paint); // trunk down to stub
    canvas.drawLine(Offset(centerX, midY), Offset(size.width, midY), paint); // stub into the card
    if (!isLast) {
      canvas.drawLine(Offset(centerX, midY), Offset(centerX, size.height), paint); // continue trunk to next sibling
    }
  }

  @override
  bool shouldRepaint(covariant _TreeLinePainter oldDelegate) => oldDelegate.isLast != isLast;
}
