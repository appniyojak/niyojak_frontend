import '../../models/response_model/media_download_master_model.dart';
import '../database_helper.dart';

const String kMediaQueueTable = 'MediaDownloadQueue';
const int kMaxRetries = 3;

class MediaDownloadQueueDao {
  /// Filters a raw API mediaList down to items worth queuing, then inserts
  /// them (insert-or-skip — never overwrites an in-flight/queued item).
  ///
  /// Edge case handled: if a media entry's `pkid` doesn't yet exist in its
  /// parent table (out-of-order sync), we skip it and log a warning rather
  /// than inserting a queue row that can never resolve to a real record.
  /// NOTE: confirm with backend whether this can actually happen — if the
  /// API guarantees the parent row always syncs first, this check is just
  /// a safety net and will rarely trigger.
  // Map the API's `tablename` value to your real SQL table name.
  // Add more entries here as other content types gain media support.
  static const Map<String, String> _apiTableToSqlTable = {
    'shaakhapustika': 'OfflineShaakhaPustika',
  };

  static String _resolveSqlTable(String apiTableName) => _apiTableToSqlTable[apiTableName] ?? apiTableName;

  static Future<List<MediaDownloadQueueItem>> enqueueNewMedia(
    List<Map<String, dynamic>> rawMediaList,
  ) async {
    final db = await DatabaseHelper.database;

    // Parse first, skipping malformed entries.
    final parsedItems = <MediaDownloadQueueItem>[];
    for (final json in rawMediaList) {
      try {
        parsedItems.add(MediaDownloadQueueItem.fromApiJson(json));
      } catch (e) {
        // ignore: avoid_print
        print('Skipping malformed media entry: $json ($e)');
      }
    }
    if (parsedItems.isEmpty) return [];

    // Batch the parent-existence check: one query per distinct SQL table,
    // instead of one query per item. At 500+ items this is the difference
    // between 1-2 queries and 500 — avoids exactly the kind of DB lock
    // contention that shows up if this runs alongside a large sync
    // transaction on the same table.
    final itemsByTable = <String, List<MediaDownloadQueueItem>>{};
    for (final item in parsedItems) {
      itemsByTable.putIfAbsent(_resolveSqlTable(item.tablename), () => []).add(item);
    }

    final validItems = <MediaDownloadQueueItem>[];
    for (final entry in itemsByTable.entries) {
      final sqlTable = entry.key;
      final items = entry.value;
      final pkids = items.map((i) => i.pkid).toSet().toList();

      final placeholders = List.filled(pkids.length, '?').join(',');
      final existingRows = await db.rawQuery(
        'SELECT pkid FROM $sqlTable WHERE pkid IN ($placeholders)',
        pkids,
      );
      final existingPkids = existingRows.map((r) => r['pkid'] as int).toSet();

      for (final item in items) {
        if (existingPkids.contains(item.pkid)) {
          validItems.add(item);
        } else {
          // ignore: avoid_print
          print('Skipping media for missing parent: $sqlTable.pkid=${item.pkid}');
        }
      }
    }

    if (validItems.isEmpty) return [];

    await DatabaseHelper.bulkInsertOrSkip<MediaDownloadQueueItem>(
      tableName: kMediaQueueTable,
      items: validItems,
      toMap: (item) => item.toMap(),
      keyColumns: ['pkid', 'tablename'],
      hasUniqueConstraint: true, // backed by UNIQUE(pkid, tablename)
    );

    return validItems;
  }

  static Future<List<MediaDownloadQueueItem>> getByStatus(
    String status, {
    int? limit,
    int? offset,
  }) async {
    final db = await DatabaseHelper.database;
    final rows = await db.query(
      kMediaQueueTable,
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'createdAt ASC',
      limit: limit,
      offset: offset,
    );
    return rows.map(MediaDownloadQueueItem.fromMap).toList();
  }

  static Future<MediaDownloadQueueItem?> getByTaskId(String taskId) async {
    final db = await DatabaseHelper.database;
    final rows = await db.query(kMediaQueueTable, where: 'taskId = ?', whereArgs: [taskId], limit: 1);
    if (rows.isEmpty) return null;
    return MediaDownloadQueueItem.fromMap(rows.first);
  }

  /// Status counts for the app bar badge, e.g. {pending: 12, downloading: 3, failed: 1}
  static Future<Map<String, int>> getStatusCounts() async {
    final db = await DatabaseHelper.database;
    final rows = await db.rawQuery('SELECT status, COUNT(*) as cnt FROM $kMediaQueueTable GROUP BY status');
    return {for (final row in rows) row['status'] as String: row['cnt'] as int};
  }

  static Future<void> updateStatus(
    String taskId, {
    required String status,
    int? progress,
    String? errorMessage,
  }) async {
    final db = await DatabaseHelper.database;
    final values = <String, dynamic>{
      'status': status,
      'updatedAt': DateTime.now().toIso8601String(),
    };
    if (progress != null) values['progress'] = progress;
    if (errorMessage != null) values['errorMessage'] = errorMessage;
    await db.update(kMediaQueueTable, values, where: 'taskId = ?', whereArgs: [taskId]);
  }

  /// Marks a failed attempt. Returns the new status ('pending' if it will
  /// retry, 'failed' if retries are exhausted or the failure is permanent).
  static Future<String> recordFailure(
    String taskId, {
    required String errorMessage,
    required bool permanent,
  }) async {
    final db = await DatabaseHelper.database;
    final rows = await db.query(kMediaQueueTable, where: 'taskId = ?', whereArgs: [taskId], limit: 1);
    if (rows.isEmpty) return 'failed';

    final currentRetryCount = rows.first['retryCount'] as int? ?? 0;
    final newRetryCount = currentRetryCount + 1;
    final willRetry = !permanent && newRetryCount <= kMaxRetries;
    final newStatus = willRetry ? 'pending' : 'failed';

    await db.update(
      kMediaQueueTable,
      {
        'status': newStatus,
        'retryCount': newRetryCount,
        'errorMessage': errorMessage,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'taskId = ?',
      whereArgs: [taskId],
    );
    return newStatus;
  }

  /// The one atomic cross-table operation: on successful download, write
  /// the local path into the PARENT table (identified dynamically by
  /// `tablename`/`pkid` stored on the queue row) and remove the queue row
  /// — both in a single transaction, so an app kill mid-write can never
  /// leave an orphaned queue row or a parent row missing its path.
  static Future<void> completeDownload(String taskId, String localFilepath) async {
    final db = await DatabaseHelper.database;

    await db.transaction((txn) async {
      final rows = await txn.query(kMediaQueueTable, where: 'taskId = ?', whereArgs: [taskId], limit: 1);
      if (rows.isEmpty) return; // nothing to reconcile — already handled or stale update

      final item = MediaDownloadQueueItem.fromMap(rows.first);

      await txn.update(
        _resolveSqlTable(item.tablename), // dynamic — supports future tables beyond OfflineShaakhaPustika
        {'filepath': localFilepath},
        where: 'pkid = ?',
        whereArgs: [item.pkid],
      );

      await txn.delete(kMediaQueueTable, where: 'taskId = ?', whereArgs: [taskId]);
    });
  }

  /// Paged + joined read for the Downloads screen, so each row can show
  /// something more useful than a raw pkid (adjust the joined columns to
  /// whatever OfflineShaakhaPustika exposes that's worth showing, e.g.
  /// karyakramname). Kept generic since `tablename` varies per row.
  static Future<List<Map<String, dynamic>>> getPageWithMeta(
    String status, {
    required int limit,
    required int offset,
  }) async {
    final db = await DatabaseHelper.database;
    // Joining dynamically across possible `tablename` values isn't safe in
    // one SQL statement — group by tablename first, then join per-table.
    // For a single-table setup (just OfflineShaakhaPustika today) this
    // simplifies to one query:
    return db.rawQuery('''
      SELECT q.*, p.karyakramname, p.vayogatname
      FROM $kMediaQueueTable q
      LEFT JOIN OfflineShaakhaPustika p ON p.pkid = q.pkid AND q.tablename = 'OfflineShaakhaPustika'
      WHERE q.status = ?
      ORDER BY q.createdAt ASC
      LIMIT ? OFFSET ?
    ''', [status, limit, offset]);
  }
}
