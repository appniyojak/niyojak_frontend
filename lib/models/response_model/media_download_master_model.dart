// ─────────────────────────────────────────────────────────────────────────
// MediaDownloadQueue — schema + model
//
// Add this CREATE TABLE to your onCreate (and onUpgrade with a version bump,
// since this is a new table on an existing DB for upgrading users):
//
// CREATE TABLE IF NOT EXISTS MediaDownloadQueue (
//   id INTEGER PRIMARY KEY AUTOINCREMENT,
//   pkid INTEGER NOT NULL,
//   tablename TEXT NOT NULL,
//   remoteFilepath TEXT NOT NULL,
//   localFilepath TEXT,
//   taskId TEXT NOT NULL,
//   status TEXT NOT NULL DEFAULT 'pending',   -- pending | downloading | paused | failed
//   progress INTEGER NOT NULL DEFAULT 0,      -- 0-100, throttled writes (see service)
//   retryCount INTEGER NOT NULL DEFAULT 0,
//   errorMessage TEXT,
//   createdAt TEXT NOT NULL,
//   updatedAt TEXT,
//   UNIQUE(pkid, tablename)
// );
//
// Note: there is deliberately NO 'completed' row left behind — per your
// requirement, on successful download the row is deleted from this table
// and the local path is written into the main content table instead (see
// MediaDownloadQueueDao.completeDownload). If you ever want a "recently
// completed" history for the Downloads screen, that needs a *separate*
// small log table — ask if you want that added later.
// ─────────────────────────────────────────────────────────────────────────

class MediaDownloadQueueItem {
  final int? id;
  final int pkid;
  final String tablename;
  final String remoteFilepath;
  final String? localFilepath;
  final String taskId;
  final String status;
  final int progress;
  final int retryCount;
  final String? errorMessage;
  final String createdAt;
  final String? updatedAt;

  const MediaDownloadQueueItem({
    this.id,
    required this.pkid,
    required this.tablename,
    required this.remoteFilepath,
    this.localFilepath,
    required this.taskId,
    this.status = 'pending',
    this.progress = 0,
    this.retryCount = 0,
    this.errorMessage,
    required this.createdAt,
    this.updatedAt,
  });

  /// Builds a queue item from one raw entry of the API's `mediaList`, e.g.
  /// {"filepath": "Files/shaakhapustika/xxx.mp4", "pkid": 40, "tablename": "shaakhapustika"}
  factory MediaDownloadQueueItem.fromApiJson(Map<String, dynamic> json) {
    final pkid = json['pkid'] as int;
    final tablename = json['tablename'] as String;
    final remoteFilepath = json['filepath'] as String;
    final now = DateTime.now().toIso8601String();
    return MediaDownloadQueueItem(
      pkid: pkid,
      tablename: tablename,
      remoteFilepath: remoteFilepath,
      taskId: '${tablename}_$pkid',
      createdAt: now,
      updatedAt: now,
    );
  }

  factory MediaDownloadQueueItem.fromMap(Map<String, dynamic> map) => MediaDownloadQueueItem(
        id: map['id'] as int?,
        pkid: map['pkid'] as int,
        tablename: map['tablename'] as String,
        remoteFilepath: map['remoteFilepath'] as String,
        localFilepath: map['localFilepath'] as String?,
        taskId: map['taskId'] as String,
        status: map['status'] as String? ?? 'pending',
        progress: map['progress'] as int? ?? 0,
        retryCount: map['retryCount'] as int? ?? 0,
        errorMessage: map['errorMessage'] as String?,
        createdAt: map['createdAt'] as String,
        updatedAt: map['updatedAt'] as String?,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'pkid': pkid,
        'tablename': tablename,
        'remoteFilepath': remoteFilepath,
        'localFilepath': localFilepath,
        'taskId': taskId,
        'status': status,
        'progress': progress,
        'retryCount': retryCount,
        'errorMessage': errorMessage,
        'createdAt': createdAt,
        'updatedAt': DateTime.now().toIso8601String(),
      };

  MediaDownloadQueueItem copyWith({
    String? status,
    int? progress,
    int? retryCount,
    String? errorMessage,
    String? localFilepath,
  }) =>
      MediaDownloadQueueItem(
        id: id,
        pkid: pkid,
        tablename: tablename,
        remoteFilepath: remoteFilepath,
        localFilepath: localFilepath ?? this.localFilepath,
        taskId: taskId,
        status: status ?? this.status,
        progress: progress ?? this.progress,
        retryCount: retryCount ?? this.retryCount,
        errorMessage: errorMessage,
        createdAt: createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );
}
