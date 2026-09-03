import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Runs a given check at most once per calendar day, per unique [key].
///
/// Using a per-key flag (instead of one global "last checked" date) means
/// multiple independent modules can each have their own once-a-day check
/// without stepping on each other — e.g. 'shaakhapustika_monthly' and
/// 'someOtherModule_monthly' track separately.
class OncePerDayGate {
  static const _prefsPrefix = 'oncePerDay_';

  /// [key] — a unique, stable identifier for this specific check (e.g.
  /// 'shaakhapustika_monthly'). [task] — the actual check-and-sync logic to
  /// run if it hasn't run yet today.
  ///
  /// If [task] throws, the "last run" date is NOT recorded, so the next
  /// app open retries today rather than waiting a full day for data that's
  /// still genuinely missing.
  static Future<void> run(String key, Future<void> Function() task) async {
    final prefs = await SharedPreferences.getInstance();
    final prefsKey = '$_prefsPrefix$key';
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastRun = prefs.getString(prefsKey);

    if (lastRun == today) {
      return; // already ran today under this key — skip entirely
    }

    try {
      await task();
      await prefs.setString(prefsKey, today);
    } catch (e) {
      // ignore: avoid_print
      print('OncePerDayGate[$key] failed, will retry next app open: $e');
      // deliberately not persisting — allows retry today, not tomorrow
    }
  }

  static Future<void> deleteFun(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final prefsKey = '$_prefsPrefix$key';

    await prefs.setString(prefsKey, "");
  }
}
