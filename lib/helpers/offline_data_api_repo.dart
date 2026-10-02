// ─────────────────────────────────────────────────────────────────────────
// DataRepository — single entry point for "try the API, fall back to local"
//
// getList / getById: plain read-and-cache-nothing fetches (unchanged
// contract from the old ApiRepository).
//
// loadWithFallback / saveWithFallback: draft-aware record editing.
//
// SCHEMA CONVENTION each draft table must follow to use loadWithFallback/
// saveWithFallback:
//   - a discriminator column (default name: 'tablename') identifying which
//     master table the row belongs to, e.g. 'ShaakhaVruttaMaster'
//   - an 'isdraft' column (not strictly required by this service, but kept
//     as a convention from the original Vrutta schema)
//   - UNIQUE(<your key columns>, <discriminator column>) — e.g.
//     UNIQUE(ShaakhaaID, VruttaDate, tablename) for Vrutta.
//
// Each MASTER table should have UNIQUE(<your key columns>) — e.g.
// UNIQUE(ShaakhaaID, VruttaDate) — so the local-cache-on-fetch step can
// use the fast upsert path.
//
// ASSUMPTION: a successful ONLINE fetch caches its result into the local
// master table, and a successful ONLINE save also updates that same local
// cache — otherwise "offline: check master table" would never find anything.
// ─────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:niyojak_prod/helpers/static_data.dart';

import 'database_helper.dart';

enum DraftRecordSource { masterOnline, masterOffline, draft, newEntry }

enum DraftSaveOutcome {
  savedToServer, // status 200 — draft (if any) deleted, master cache updated
  savedToDraftFallback, // online attempt made, but non-200/exception — staged in draft
  savedToDraftOffline, // no connectivity at all — staged in draft
  blockedMasterOffline, // masterOffline source, no connectivity — edits not allowed
}

typedef DraftRow = (Map<String, dynamic>? data, DraftRecordSource source);

/// [T] is whatever shape your record is — usually Map<String, dynamic>.
class DraftLoadResult<T> {
  final T? data;
  final DraftRecordSource source;

  const DraftLoadResult({required this.data, required this.source});
}

/// [T] is whatever shape your record is — usually Map<String, dynamic>.
class DraftSaveResult {
  final Map<String, dynamic>? data;
  final DraftSaveOutcome outcome;

  const DraftSaveResult({required this.data, required this.outcome});
}

class OfflineDataApiRepo {
  static const _headers = {'Content-Type': 'application/json', 'Accept': '*/*'};

  // ── plain reads ──────────────────────────────────────────────────────

  /// null = error / unavailable, [] = no data
  static Future<List<T>?> getList<T>({
    required String url,
    required Map<String, dynamic> body,
    required List<T> Function(Map<String, dynamic> json) parse,
    required Future<List<T>> Function() fromLocal,
    bool Function()? skipLocalFallback,
    BuildContext? context,
    bool fallbackOnException = true,
  }) async {
    final showLoader = context != null;
    if (showLoader) showLoaderDialog(context);
    try {
      return await _fetch<List<T>>(
        apiCall: () => _post<List<T>>(url, body, parse),
        fromLocal: fromLocal,
        skipLocalFallback: skipLocalFallback ?? () => levelId > 7 && levelId != 13,
        fallbackOnException: fallbackOnException,
      );
    } catch (e) {
      log("Exception at getList >>>>>>>>> $e");
    } finally {
      if (showLoader && context.mounted) Navigator.of(context, rootNavigator: true).pop();
    }
    return null;
  }

  static Future<T?> getById<T>({
    required String url,
    required Map<String, dynamic> body,
    required T? Function(Map<String, dynamic> json) parse,
    required Future<T?> Function() fromLocal,
    bool Function()? skipLocalFallback,
    BuildContext? context,
    bool fallbackOnException = true,
  }) async {
    final showLoader = context != null;
    if (showLoader) showLoaderDialog(context);
    try {
      return await _fetch<T>(
        apiCall: () => _post<T?>(url, body, parse),
        fromLocal: fromLocal,
        skipLocalFallback: skipLocalFallback ?? () => levelId > 7 && levelId != 13,
        fallbackOnException: fallbackOnException,
      );
    } catch (e) {
      log("Exception at getById >>>>>>>>> $e");
    } finally {
      if (showLoader && context.mounted) Navigator.of(context, rootNavigator: true).pop();
    }
    return null;
  }

  // ── draft-aware load ────────────────────────────────────────────────

  /// [masterTableName] — the real local table this record's data lives in
  /// when synced, e.g. 'ShaakhaVruttaMaster', 'VistarShaakhaVruttaMaster'.
  /// [draftTableName] — the shared or dedicated draft table for this module.
  /// [keyColumns] / [keyValues] — the natural key, matched by position.
  /// [fetchFromApi] — wrap your module's EXISTING get function; return the
  /// response as a Map, or null on any failure.
  static Future<DraftLoadResult<Map<String, dynamic>>> loadWithFallback({
    required String masterTableName,
    required String draftTableName,
    required List<String> keyColumns,
    required List<Object?> keyValues,
    required Future<Map<String, dynamic>?> Function() fetchFromApi,
    String discriminatorColumn = 'tablename',
    String? where,
    List<Object?>? whereArgs,
  }) async {
    assert(keyColumns.length == keyValues.length, 'keyColumns and keyValues must match in length');
    assert((where == null) == (whereArgs == null), 'where and whereArgs must both be provided or both omitted');

    final lookupWhere = where ?? keyColumns.map((c) => '$c = ?').join(' AND ');
    final lookupArgs = whereArgs ?? keyValues;

    log("loadWithFallback function called >>>>>>> ");

    final resolved = await _fetch<DraftRow>(
      apiCall: () async {
        final apiResult = await fetchFromApi();
        return apiResult == null ? null : (apiResult, DraftRecordSource.masterOnline);
      },
      onApiSuccess: (row) => _cacheMasterRow(masterTableName, row.$1!, keyColumns),
      fromLocal: () async {
        // Draft checked FIRST: an offline edit in progress must win over a
        // stale synced master row, or the user's in-progress work would be
        // silently hidden behind the old server copy.
        /*final draftRow = await _queryOne(
          draftTableName,
          keyColumns,
          keyValues,
          extraWhere: '$discriminatorColumn = ?',
          extraArgs: [masterTableName],
        );*/
        final draftRow = await DatabaseHelper.getOneOfflineData<Map<String, dynamic>>(
          tableName: draftTableName,
          fromMap: (map) => map,
          where: '$lookupWhere AND $discriminatorColumn = ?',
          whereArgs: [...lookupArgs, masterTableName],
        );

        if (draftRow != null) return (draftRow, DraftRecordSource.draft);

        // No draft — check master. If found, this record is synced but has
        // no local edit staged, and we're offline/unreachable: caller MUST
        // treat `masterOffline` as blocked-for-editing at load time (see
        // usage note below), not just at save time.
        final masterRow = await DatabaseHelper.getOneOfflineData<Map<String, dynamic>>(
          tableName: masterTableName,
          fromMap: (map) => map,
          where: where,
          whereArgs: whereArgs,
        );
        if (masterRow != null) return (masterRow, DraftRecordSource.masterOffline);

        return (null, DraftRecordSource.newEntry);
      },
    );

    if (resolved == null) return const DraftLoadResult(data: null, source: DraftRecordSource.newEntry);
    return DraftLoadResult(data: resolved.$1, source: resolved.$2);
  }

  /// [loadedSource] — whatever loadWithFallback returned when this record
  /// was opened for editing.
  /// [formData] — current edited values; MUST include all [keyColumns].
  /// [saveToApi] — wrap your module's EXISTING save function; return the
  /// actual HTTP status code, or null if the call threw / never completed.
  ///
  /// Not routed through `_fetch`: this is a write with a pre-check
  /// (blockedMasterOffline) that must run before any API attempt, and two
  /// distinct "didn't reach the server" outcomes depending on connectivity —
  /// shapes `_fetch` isn't built for.
  static Future<DraftSaveResult> saveWithFallback({
    required String masterTableName,
    required String draftTableName,
    required List<String> keyColumns,
    required DraftRecordSource loadedSource,
    required Map<String, dynamic> formData,
    required Future<Map<String, dynamic>?> Function() saveToApi,
    String discriminatorColumn = 'tablename',
  }) async {
    final keyValues = keyColumns.map((k) => formData[k]).toList();
    final connected = await isInternetConnected();

    if (loadedSource == DraftRecordSource.masterOffline && connected != true) {
      return DraftSaveResult(data: null, outcome: DraftSaveOutcome.blockedMasterOffline);
    }

    log("Printing the inputData >>>>>>>>> $formData");

    if (connected == true) {
      final res = await saveToApi();

      if (res != null && (res["Status"].toString() == "200" || res["Status"].toString() == "Success")) {
        await _deleteDraftRow(draftTableName, keyColumns, keyValues, discriminatorColumn, masterTableName);
        await _cacheMasterRow(masterTableName, formData, keyColumns);
        return DraftSaveResult(data: res, outcome: DraftSaveOutcome.savedToServer);
      }

      await _upsertDraft(draftTableName, formData, keyColumns, discriminatorColumn, masterTableName);
      return DraftSaveResult(data: res, outcome: DraftSaveOutcome.savedToDraftFallback);
    }

    await _upsertDraft(draftTableName, formData, keyColumns, discriminatorColumn, masterTableName);
    return DraftSaveResult(data: null, outcome: DraftSaveOutcome.savedToDraftOffline);
  }

  // ── shared core ─────────────────────────────────────────────────────

  static Future<R?> _fetch<R>({
    required Future<R?> Function() apiCall,
    required Future<R?> Function() fromLocal,
    Future<void> Function(R data)? onApiSuccess,
    bool Function()? skipLocalFallback,
    bool fallbackOnException = true,
  }) async {
    Future<R?> local() async {
      if (skipLocalFallback?.call() ?? false) return null;
      log("falling back to local data");
      return await fromLocal();
    }

    final connected = await isInternetConnected();
    if (connected != true) {
      log("offline — going straight to local");
      return local();
    }

    try {
      final result = await apiCall();
      if (result != null) {
        if (onApiSuccess != null) await onApiSuccess(result);
        return result;
      }
      log("api call returned null — falling back to local");
      return await local();
    } catch (e) {
      log("Exception at _fetch >>>>>>>>> $e");
      return fallbackOnException ? await local() : null;
    }
  }

  static Future<R?> _post<R>(String url, Map<String, dynamic> body, R Function(Map<String, dynamic>) parse) async {
    log("api >>> $url");
    log("req >>> ${jsonEncode(body)}");
    final response = await http.post(Uri.parse(url), headers: _headers, body: jsonEncode(body));
    if (response.statusCode != 200) {
      log("API failed ${response.statusCode} - ${response.body}");
      return null;
    }
    log("response.body >>>>>>>> ${response.body}");
    return parse(jsonDecode(response.body) as Map<String, dynamic>);
  }

  // ── local DB internals (draft) ──────────────────────────────────────

  // static Future<Map<String, dynamic>?> _queryOne(
  //   String tableName,
  //   List<String> keyColumns,
  //   List<Object?> keyValues, {
  //   String? extraWhere,
  //   List<Object?>? extraArgs,
  // }) async {
  //   final db = await DatabaseHelper.database;
  //   final whereParts = [...keyColumns.map((c) => '$c = ?'), if (extraWhere != null) extraWhere];
  //   final args = [...keyValues, ...?extraArgs];
  //   final rows = await db.query(tableName, where: whereParts.join(' AND '), whereArgs: args, limit: 1);
  //   return rows.isEmpty ? null : rows.first;
  // }

  static Future<void> _cacheMasterRow(
    String masterTableName,
    Map<String, dynamic> data,
    List<String> keyColumns,
  ) async {
    await DatabaseHelper.upsertOne<Map<String, dynamic>>(
      tableName: masterTableName,
      item: data,
      toMap: (item) => item,
      keyColumns: keyColumns,
      hasUniqueConstraint: false, // requires UNIQUE(keyColumns...) on the master table
    );
  }

  static Future<void> _upsertDraft(
    String draftTableName,
    Map<String, dynamic> formData,
    List<String> keyColumns,
    String discriminatorColumn,
    String masterTableName,
  ) async {
    final draftRow = {
      ...formData,
      discriminatorColumn: masterTableName,
      'isdraft': 1,
    };
    await DatabaseHelper.upsertOne<Map<String, dynamic>>(
      tableName: draftTableName,
      item: draftRow,
      toMap: (item) => item,
      keyColumns: [...keyColumns, discriminatorColumn],
      hasUniqueConstraint: true, // requires UNIQUE(keyColumns..., discriminatorColumn) on the draft table
    );
  }

  static Future<void> _deleteDraftRow(
    String draftTableName,
    List<String> keyColumns,
    List<Object?> keyValues,
    String discriminatorColumn,
    String masterTableName,
  ) async {
    final db = await DatabaseHelper.database;
    final where = [...keyColumns.map((c) => '$c = ?'), '$discriminatorColumn = ?'].join(' AND ');
    final args = [...keyValues, masterTableName];
    await db.delete(draftTableName, where: where, whereArgs: args);
  }
}
