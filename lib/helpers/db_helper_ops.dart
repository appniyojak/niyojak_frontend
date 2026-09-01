// ─────────────────────────────────────────────────────────────────────────
// Generic CRUD / sync operations for DatabaseHelper (sqflite)
//
// Design notes (agreed in discussion, not assumed):
// - Every bulk/single op accepts `keyColumns` — the logical identity of a
//   row, regardless of whether it's backed by a real PRIMARY KEY/UNIQUE
//   constraint.
// - `hasUniqueConstraint` tells the function whether it can trust SQLite's
//   own conflict resolution (fast path, via ConflictAlgorithm) or whether
//   it must manually query-then-insert/update per row (slow path, only
//   option when there's no real constraint backing keyColumns).
//   * hasUniqueConstraint = true  -> fast path. Cannot distinguish
//     insert vs update per-row without an extra query (defeats the
//     purpose of the fast path), so both are reported under `inserted`.
//   * hasUniqueConstraint = false -> slow path. Accurate inserted/updated
//     split, at the cost of one SELECT per row.
// - All bulk ops run inside a single db.transaction. Per-row failures are
//   caught and counted in `failed`; they do NOT abort the whole
//   transaction (per requirement: skip failures, don't roll back).
// - All ops return DbOperationResult for debugging/logging by the caller.
// - No concurrent transactions — callers should await each sync call
//   sequentially. SQLite only allows one writer at a time regardless, so
//   concurrent transactions would only queue internally with no real
//   throughput benefit, and add lock-contention risk.
// ─────────────────────────────────────────────────────────────────────────



/// Result of any create/update/delete operation, returned for debugging
/// and logging purposes. Callers are free to ignore it.
class DbOperationResult {
  final int inserted;
  final int updated;
  final int deleted;
  final int skipped;
  final int failed;

  const DbOperationResult({
    this.inserted = 0,
    this.updated = 0,
    this.deleted = 0,
    this.skipped = 0,
    this.failed = 0,
  });

  DbOperationResult operator +(DbOperationResult other) => DbOperationResult(
        inserted: inserted + other.inserted,
        updated: updated + other.updated,
        deleted: deleted + other.deleted,
        skipped: skipped + other.skipped,
        failed: failed + other.failed,
      );

  @override
  String toString() => 'DbOperationResult(inserted: $inserted, updated: $updated, deleted: $deleted, skipped: $skipped, failed: $failed)';
}

/// Thrown when a required key column is missing/null on an item passed
/// into a keyed operation. Caught internally by bulk ops (counted as
/// `failed`); surfaces directly from single-row ops.
class MissingKeyColumnException implements Exception {
  final String column;
  final String tableName;

  MissingKeyColumnException(this.column, this.tableName);

  @override
  String toString() => 'MissingKeyColumnException: "$column" is required for table "$tableName"';
}
