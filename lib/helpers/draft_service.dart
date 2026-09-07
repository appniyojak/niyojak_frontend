// ─────────────────────────────────────────────────────────────────────────

// SCHEMA CONVENTION each draft table must follow to use this service:
//   - a discriminator column (default name: 'tablename') identifying which
//     master table the row belongs to, e.g. 'ShaakhaVruttaMaster'
//   - an 'isdraft' column (not strictly required by this service, but kept
//     as a convention from the original Vrutta schema)
//   - UNIQUE(<your key columns>, <discriminator column>) — e.g.
//     UNIQUE(ShaakhaaID, VruttaDate, tablename) for Vrutta. Each new draft
//     table needs its own matching UNIQUE constraint for its own key
//     columns before using this service's fast upsert path.
//
// Each MASTER table should have UNIQUE(<your key columns>) — e.g.
// UNIQUE(ShaakhaaID, VruttaDate) for the Vrutta master tables — so the
// local-cache-on-fetch step (see ASSUMPTION below) can use the fast path.
//
// ASSUMPTION (explicit, not silently baked in): a successful ONLINE fetch
// caches its result into the local master table, and a successful ONLINE
// save also updates that same local cache — otherwise "offline: check
// master table" would never have anything to find.
// ─────────────────────────────────────────────────────────────────────────

import 'dart:developer';

import 'package:niyojak_prod/helpers/static_data.dart';

import 'database_helper.dart';

// import your DatabaseHelper (for `database` getter) and generic ops here:
// import 'database_helper.dart';
// import 'database_helper_generic_ops.dart';
// import your connectivity check:
// import 'connectivity_helper.dart' show isInternetConnected;

enum DraftRecordSource { masterOnline, masterOffline, draft, newEntry }

enum DraftSaveOutcome {
  savedToServer, // status 200 — draft (if any) deleted, master cache updated
  savedToDraftFallback, // online attempt made, but non-200/exception — staged in draft
  savedToDraftOffline, // no connectivity at all — staged in draft
  blockedMasterOffline, // masterOffline source, no connectivity — edits not allowed
}

class DraftLoadResult {
  final Map<String, dynamic>? data;
  final DraftRecordSource source;

  const DraftLoadResult({required this.data, required this.source});
}

class DraftSyncService {
  /// [masterTableName] — the real local table this record's data lives in
  /// when synced, e.g. 'ShaakhaVruttaMaster', 'VistarShaakhaVruttaMaster',
  /// or any future module's master table.
  /// [draftTableName] — the shared or dedicated draft table for this
  /// module, e.g. 'VruttaDraftMaster'.
  /// [keyColumns] — the natural key identifying one record, e.g.
  /// ['ShaakhaaID', 'VruttaDate']. Works with any number of columns.
  /// [keyValues] — the actual values for those columns, in the SAME order
  /// as [keyColumns], e.g. [shaakhaaId, vruttaDate].
  /// [discriminatorColumn] — the draft table's column that records which
  /// master table a draft row belongs to. Defaults to 'tablename' to match
  /// the existing VruttaDraftMaster convention; override if a future draft
  /// table names it differently.
  /// [fetchFromApi] — wrap your module's EXISTING get function; return the
  /// response as a Map, or null on any failure.
  static Future<DraftLoadResult> loadWithFallback({
    required String masterTableName,
    required String draftTableName,
    required List<String> keyColumns,
    required List<Object?> keyValues,
    required Future<Map<String, dynamic>?> Function() fetchFromApi,
    String discriminatorColumn = 'tablename',
  }) async {
    assert(keyColumns.length == keyValues.length, 'keyColumns and keyValues must match in length');

    final connected = await isInternetConnected();

    if (connected != true) {
      log("calling from api");
      final apiResult = await fetchFromApi();
      if (apiResult != null) {
        await _cacheMasterRow(masterTableName, apiResult, keyColumns);
        return DraftLoadResult(data: apiResult, source: DraftRecordSource.masterOnline);
      }
      // Online but the API call failed — fall through to local check,
      // same as a genuine offline case, rather than losing access entirely.
    }

    log("calling from local");
    final masterRow = await _queryOne(masterTableName, keyColumns, keyValues);
    log("masterRow != null >>>> ${masterRow != null}");
    if (masterRow != null) {
      return DraftLoadResult(data: masterRow, source: DraftRecordSource.masterOffline);
    }

    final draftRow = await _queryOne(
      draftTableName,
      keyColumns,
      keyValues,
      extraWhere: '$discriminatorColumn = ?',
      extraArgs: [masterTableName],
    );
    if (draftRow != null) {
      return DraftLoadResult(data: draftRow, source: DraftRecordSource.draft);
    }

    return const DraftLoadResult(data: null, source: DraftRecordSource.newEntry);
  }

  /// [loadedSource] — whatever loadWithFallback returned when this record
  /// was opened for editing.
  /// [formData] — current edited values; MUST include all [keyColumns].
  /// [saveToApi] — wrap your module's EXISTING save function; return the
  /// actual HTTP status code, or null if the call threw / never completed.
  static Future<DraftSaveOutcome> saveWithFallback({
    required String masterTableName,
    required String draftTableName,
    required List<String> keyColumns,
    required DraftRecordSource loadedSource,
    required Map<String, dynamic> formData,
    required Future<int?> Function() saveToApi,
    String discriminatorColumn = 'tablename',
  }) async {
    final keyValues = keyColumns.map((k) => formData[k]).toList();
    final connected = await isInternetConnected();

    if (loadedSource == DraftRecordSource.masterOffline && connected != true) {
      return DraftSaveOutcome.blockedMasterOffline;
    }

    if (connected == true) {
      final statusCode = await saveToApi();

      if (statusCode == 200) {
        await _deleteDraftRow(draftTableName, keyColumns, keyValues, discriminatorColumn, masterTableName);
        await _cacheMasterRow(masterTableName, formData, keyColumns);
        return DraftSaveOutcome.savedToServer;
      }

      await _upsertDraft(draftTableName, formData, keyColumns, discriminatorColumn, masterTableName);
      return DraftSaveOutcome.savedToDraftFallback;
    }

    await _upsertDraft(draftTableName, formData, keyColumns, discriminatorColumn, masterTableName);
    return DraftSaveOutcome.savedToDraftOffline;
  }

  // ── internals ──────────────────────────────────────────────────────

  static Future<Map<String, dynamic>?> _queryOne(
    String tableName,
    List<String> keyColumns,
    List<Object?> keyValues, {
    String? extraWhere,
    List<Object?>? extraArgs,
  }) async {
    final db = await DatabaseHelper.database;
    final whereParts = [...keyColumns.map((c) => '$c = ?'), if (extraWhere != null) extraWhere];
    final args = [...keyValues, ...?extraArgs];
    final rows = await db.query(tableName, where: whereParts.join(' AND '), whereArgs: args, limit: 1);
    return rows.isEmpty ? null : rows.first;
  }

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
      hasUniqueConstraint: true, // requires UNIQUE(keyColumns...) on the master table
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
