import 'package:flutter/foundation.dart';

import '../helpers/static_data.dart' as Statics;
import '../models/response_model/home_screen_main_data_resp_model.dart';
import 'aggregators.dart';

enum DashboardStatus { initial, loading, loaded, error }

/// Holds and exposes the home-screen dashboard data via the Provider pattern.
///
/// This replaces the old `refreshDashboardData()` top-level function, which
/// mutated ~15 global mutable lists as a side effect and returned the raw
/// decoded JSON. Instead:
///   - the network call, parsing, and derived "with total row" tables are
///     all driven from one immutable-per-load [HomeScreenData] instance,
///   - loading / error / success are explicit states a widget can react to,
///     instead of the caller having to show/hide a loader dialog itself,
///   - `notifyListeners()` tells only the widgets that actually read this
///     provider to rebuild, instead of every screen depending on globals.
///
/// Wire it up once near the top of the widget tree:
/// ```dart
/// ChangeNotifierProvider(create: (_) => DashboardProvider()),
/// ```
///
/// and consume it from any descendant:
/// ```dart
/// final dashboard = context.watch<DashboardProvider>();
///
/// if (dashboard.isLoading) return const CircularProgressIndicator();
/// if (dashboard.hasError) return Text(dashboard.errorMessage ?? 'Error');
/// return Text('${dashboard.data?.totalSwayamsevakCount}');
/// ```
class DashboardProvider extends ChangeNotifier {
  DashboardStatus _status = DashboardStatus.initial;
  HomeScreenData? _data;
  String? _errorMessage;

  DashboardStatus get status => _status;

  HomeScreenData? get data => _data;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == DashboardStatus.loading;

  bool get hasError => _status == DashboardStatus.error;

  bool get hasData => _data != null;

  // ---------------------------------------------------------------------
  // Derived "with total row" table views.
  //
  // These recompute from `_data` on every access rather than caching, which
  // keeps the provider simple (no cache-invalidation bugs) and is cheap:
  // each is a single pass over a small list. If profiling ever shows this
  // matters, memoize by re-deriving only inside `fetchDashboard` instead.
  // ---------------------------------------------------------------------

  List<ListShaakhaaCountByVayogat> get shaakhaaCountByVayogat => _data == null ? const [] : DashboardAggregations.shaakhaaCountByVayogatWithTotal(_data!);

  List<ListKaaryakartaaCountByGatividhi> get kaaryakartaaByGatividhi => _data == null ? const [] : DashboardAggregations.kaaryakartaaByGatividhiWithTotal(_data!);

  List<ListKaaryakartaaCountByAayaam> get kaaryakartaaByAayaam => _data == null ? const [] : DashboardAggregations.kaaryakartaaByAayaamWithTotal(_data!);

  List<ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation> get preritSansthaaKaaryakartaa => _data == null ? const [] : DashboardAggregations.preritSansthaaKaaryakartaaWithTotal(_data!);

  List<ListSocialOrganizationKaaryakartaaCountByAreaOfOperation> get socialOrgKaaryakartaa => _data == null ? const [] : DashboardAggregations.socialOrgKaaryakartaaWithTotal(_data!);

  List<ListSwayamsevakCountByStudentCategory> get studentCategory => _data == null ? const [] : DashboardAggregations.studentCategoryWithTotal(_data!);

  List<ListSwayamsevakCountByVyavasaayeeCategory> get vyavasaayeeCategory => _data == null ? const [] : DashboardAggregations.vyavasaayeeCategoryWithTotal(_data!);

  List<ListYesterdayVrutta> get yesterdayVruttaDetail => _data == null ? const [] : DashboardAggregations.yesterdayVruttaDetailWithTotal(_data!);

  List<ListYesterdayVruttaSummary> get yesterdayVruttaSummary => _data == null ? const [] : DashboardAggregations.yesterdayVruttaSummaryWithTotal(_data!);

  List<ListYesterdayPraantShaakhaaCountByVayogat> get yesterdayPraantShaakhaaCountByVayogat => _data == null ? const [] : DashboardAggregations.yesterdayPraantWithTotal(_data!);

  List<ListSankalpByAadhaar> get sankalpByAadhaar => _data == null ? const [] : DashboardAggregations.sankalpByAadhaarWithTotal(_data!);

  List<BhaugolikVistaarRow> get bhaugolikVistaar => _data?.bhaugolikVistaarData == null ? const [] : DashboardAggregations.bhaugolikVistaarRows(_data!.bhaugolikVistaarData!);

  List<AppVersion> get appVersions => _data?.appVersion ?? const [];

  /// Fetches dashboard data for [userId] / [targetGeoUnitId] and updates
  /// state accordingly. Safe to call repeatedly (e.g. pull-to-refresh) —
  /// each call resets to `loading` first so listeners can show a spinner
  /// instead of the caller having to open/close a loader dialog manually.
  Future<void> fetchDashboard({
    required String? userId,
    required String? targetGeoUnitId,
  }) async {
    _status = DashboardStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await Statics.getDashboardData({
        'AppUserID': userId,
        'TargetGeoUnitID': targetGeoUnitId,
      });

      if (result == null) {
        _status = DashboardStatus.error;
        _errorMessage = 'Unable to load dashboard data. Please check your connection and try again.';
      } else {
        _data = result;
        _status = DashboardStatus.loaded;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('DashboardProvider.fetchDashboard error: $e');
      }
      _status = DashboardStatus.error;
      _errorMessage = 'Something went wrong while loading the dashboard.';
    }

    notifyListeners();
  }

  /// Returns to the initial, empty state (e.g. on logout).
  void reset() {
    _status = DashboardStatus.initial;
    _data = null;
    _errorMessage = null;
    notifyListeners();
  }
}
