import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:background_downloader/background_downloader.dart';

import '../../models/response_model/media_download_master_model.dart';
import 'media_downloader_helper.dart';

/// What requestDownload() found/did — lets the caller update its UI
/// immediately without waiting for a stream event.
enum RequestDownloadResult { alreadyDownloaded, alreadyInProgress, startedNow }

/// One live event per task update — pushed immediately, un-throttled, purely
/// for driving smooth UI. Persistence to the DB is throttled separately;
/// the UI should never wait on a DB round trip to reflect a progress tick.
class DownloadLiveEvent {
  final String taskId;
  final DownloadLiveEventType type;
  final int? progress; // 0-100, present for progress events
  final String? status; // present for status-change events
  final String? errorMessage;

  const DownloadLiveEvent({
    required this.taskId,
    required this.type,
    this.progress,
    this.status,
    this.errorMessage,
  });
}

enum DownloadLiveEventType { progress, statusChanged, completed, failed }

/// Wraps background_downloader with:
/// - bounded concurrency (native holding queue — survives app kill)
/// - classified retry/backoff (permanent failures like 404 never retry)
/// - throttled progress PERSISTENCE (avoid a DB write per progress tick)
/// - an un-throttled live event stream for smooth UI (separate from the above)
///
/// PACKAGE API NOTE: a few calls below are marked "verify" — the exact
/// method/enum names for holding-queue configuration and for reading a
/// completed task's final file path have changed across background_downloader
/// versions. Check these against the version in your pubspec before running.
class MediaDownloadService {
  MediaDownloadService._(this.mediaBaseUrl);

  static MediaDownloadService? _instance;
  final String mediaBaseUrl;

  /// Call once at app boot with your build-flavor's media base URL.
  static MediaDownloadService configure(String mediaBaseUrl) {
    _instance ??= MediaDownloadService._(mediaBaseUrl);
    return _instance!;
  }

  /// Use everywhere else, after configure() has run once.
  static MediaDownloadService get instance {
    assert(_instance != null, 'Call MediaDownloadService.configure(baseUrl) before using .instance');
    return _instance!;
  }

  static const int maxConcurrentDownloads = 3;
  static const String mediaSubdirectory = 'allNiyojakMedia';

  final StreamController<Map<String, int>> _statusCountsController = StreamController<Map<String, int>>.broadcast();

  /// Subscribe to this for the app bar badge — status counts only, not
  /// per-row progress. Fires on every status transition.
  Stream<Map<String, int>> get statusCounts => _statusCountsController.stream;

  final StreamController<DownloadLiveEvent> _liveEventsController = StreamController<DownloadLiveEvent>.broadcast();

  /// Subscribe to this on the Downloads screen for smooth, immediate
  /// per-row updates — every progress tick, not throttled. Cheap because
  /// it's an in-memory event, no DB round trip.
  Stream<DownloadLiveEvent> get liveEvents => _liveEventsController.stream;

  final Map<String, int> _lastPersistedProgress = {};

  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    // Bound concurrency at the native level so it survives background/kill.
    // VERIFY: exact configure() signature for your installed version —
    // this limits total simultaneous downloads regardless of how many are
    // enqueued at once via enqueueAll.
    await FileDownloader().configure(
      globalConfig: [(Config.holdingQueue, (maxConcurrentDownloads, null, null))],
    );

    FileDownloader().updates.listen(_handleUpdate);

    // Activates persistence and resumes tracking of tasks that were
    // in-flight when the app was last killed.
    await FileDownloader().start();

    await _reconcileAfterRestart();
    await _refreshCounts();
  }

  /// Call this right after a successful media-list sync from the API.
  Future<void> enqueueFromApiMediaList(List<Map<String, dynamic>> rawMediaList) async {
    await MediaDownloadQueueDao.enqueueNewMedia(rawMediaList);
    await _dispatchPendingToDownloader();
  }

  /// THE single entry point for starting a download — used by BOTH the
  /// auto-sync loop (enqueueFromApiMediaList) internally in bulk, AND any
  /// manual "download" tap from a screen like search_shaakhaa_pustika_screen.
  /// Never call FileDownloader directly from a screen — always come through
  /// here, or the two paths can race and duplicate work.
  ///
  /// Returns a status the caller can show immediately in the UI without
  /// waiting for a stream event.
  Future<RequestDownloadResult> requestDownload({
    required int pkid,
    required String tablename,
    required String remoteFilepath,
    String? existingLocalFilepath, // pass the row's current filepath from your search results, if any
  }) async {
    // 1. Already downloaded AND the file is still actually there?
    if (existingLocalFilepath != null && existingLocalFilepath.isNotEmpty) {
      final file = File(existingLocalFilepath);
      if (await file.exists()) {
        return RequestDownloadResult.alreadyDownloaded;
      }
      // Path was recorded but the file's gone (user cleared storage, etc.)
      // — fall through and treat this as needing a fresh download.
    }

    final taskId = '${tablename}_$pkid';
    final existing = await MediaDownloadQueueDao.getByTaskId(taskId);

    if (existing != null) {
      switch (existing.status) {
        case 'downloading':
          return RequestDownloadResult.alreadyInProgress; // don't duplicate — just let the UI watch it
        case 'pending':
          await _dispatchSingleImmediately(existing);
          return RequestDownloadResult.startedNow;
        case 'failed':
          await retryNow(taskId);
          return RequestDownloadResult.startedNow;
        default:
          return RequestDownloadResult.alreadyInProgress;
      }
    }

    // Not in the queue at all — insert it, then dispatch immediately rather
    // than waiting for the next bulk auto-sync cycle to pick it up.
    final item = MediaDownloadQueueItem.fromApiJson({
      'pkid': pkid,
      'tablename': tablename,
      'filepath': remoteFilepath,
    });
    await MediaDownloadQueueDao.enqueueNewMedia([
      {'pkid': pkid, 'tablename': tablename, 'filepath': remoteFilepath},
    ]);
    await _dispatchSingleImmediately(item);
    return RequestDownloadResult.startedNow;
  }

  /// Dispatches exactly one task right away, ahead of the normal bulk
  /// dispatch loop — for user-initiated requests where they're actively
  /// waiting. VERIFY: if your installed background_downloader version
  /// supports a `priority` field on DownloadTask, set it here (lower value
  /// = higher priority is the common convention, but confirm against your
  /// version's docs) so it also jumps ahead within the native holding queue,
  /// not just ahead of our own Dart-side dispatch loop.
  Future<void> _dispatchSingleImmediately(MediaDownloadQueueItem item) async {
    final task = DownloadTask(
      taskId: item.taskId,
      url: '$mediaBaseUrl/${item.remoteFilepath}',
      filename: item.remoteFilepath.split('/').last,
      directory: mediaSubdirectory,
      baseDirectory: BaseDirectory.applicationDocuments,
      updates: Updates.statusAndProgress,
      // priority: 0, // VERIFY field name/semantics for your installed version
    );
    final accepted = await FileDownloader().enqueue(task);
    if (accepted) {
      await MediaDownloadQueueDao.updateStatus(item.taskId, status: 'downloading');
      _liveEventsController.add(DownloadLiveEvent(taskId: item.taskId, type: DownloadLiveEventType.statusChanged, status: 'downloading'));
      await _refreshCounts();
    }
  }

  Future<void> retryNow(String taskId) async {
    await MediaDownloadQueueDao.updateStatus(taskId, status: 'pending', errorMessage: null);
    _liveEventsController.add(DownloadLiveEvent(taskId: taskId, type: DownloadLiveEventType.statusChanged, status: 'pending'));
    await _dispatchPendingToDownloader();
  }

  Future<void> _dispatchPendingToDownloader() async {
    final pending = await MediaDownloadQueueDao.getByStatus('pending');
    if (pending.isEmpty) return;

    final tasks = pending
        .map((item) => DownloadTask(
              taskId: item.taskId,
              url: '$mediaBaseUrl/${item.remoteFilepath}',
              filename: item.remoteFilepath.split('/').last,
              directory: mediaSubdirectory,
              // VERIFY: BaseDirectory enum name for your installed version.
              baseDirectory: BaseDirectory.applicationDocuments,
              updates: Updates.statusAndProgress,
            ))
        .toList();

    // Recommended over looping enqueue() for large batches (per package docs).
    final results = await FileDownloader().enqueueAll(tasks);

    for (var i = 0; i < pending.length; i++) {
      if (results[i]) {
        await MediaDownloadQueueDao.updateStatus(pending[i].taskId, status: 'downloading');
        _liveEventsController.add(DownloadLiveEvent(
          taskId: pending[i].taskId,
          type: DownloadLiveEventType.statusChanged,
          status: 'downloading',
        ));
      }
      // if not accepted, leave as 'pending' — stays visible to the user as queued/waiting
    }
    await _refreshCounts();
  }

  Future<void> _handleUpdate(TaskUpdate update) async {
    if (update is TaskStatusUpdate) {
      switch (update.status) {
        case TaskStatus.complete:
          // VERIFY: how your installed version exposes the final saved path.
          final localPath = await update.task.filePath();
          await MediaDownloadQueueDao.completeDownload(update.task.taskId, localPath);
          _liveEventsController.add(DownloadLiveEvent(taskId: update.task.taskId, type: DownloadLiveEventType.completed));
          break;

        case TaskStatus.failed:
          final statusCode = update.responseStatusCode;
          final permanent = statusCode == 404;
          final message = update.exception?.description ?? 'Download failed (status $statusCode)';
          final newStatus = await MediaDownloadQueueDao.recordFailure(
            update.task.taskId,
            errorMessage: message,
            permanent: permanent,
          );
          _liveEventsController.add(DownloadLiveEvent(
            taskId: update.task.taskId,
            type: DownloadLiveEventType.failed,
            status: newStatus,
            errorMessage: message,
          ));
          if (newStatus == 'pending') {
            _scheduleBackoffRetry(update.task.taskId);
          }
          break;

        case TaskStatus.canceled:
          await MediaDownloadQueueDao.updateStatus(update.task.taskId, status: 'paused');
          _liveEventsController.add(DownloadLiveEvent(taskId: update.task.taskId, type: DownloadLiveEventType.statusChanged, status: 'paused'));
          break;

        default:
          break;
      }
      await _refreshCounts();
    } else if (update is TaskProgressUpdate) {
      final percent = (update.progress * 100).round();
      // Live UI gets every tick, immediately, no DB involved.
      _liveEventsController.add(DownloadLiveEvent(taskId: update.task.taskId, type: DownloadLiveEventType.progress, progress: percent));
      // DB persistence stays throttled — this is about disk I/O cost, not UI smoothness.
      _throttledProgressPersist(update.task.taskId, percent);
    }
  }

  void _scheduleBackoffRetry(String taskId) async {
    final item = await MediaDownloadQueueDao.getByTaskId(taskId);
    if (item == null) return;
    final delaySeconds = 5 * pow(2, item.retryCount).toInt();
    Future.delayed(Duration(seconds: delaySeconds), () {
      _dispatchPendingToDownloader();
    });
  }

  void _throttledProgressPersist(String taskId, int percent) {
    final last = _lastPersistedProgress[taskId] ?? -1;
    if (percent - last >= 5 || percent == 100) {
      _lastPersistedProgress[taskId] = percent;
      MediaDownloadQueueDao.updateStatus(taskId, status: 'downloading', progress: percent);
    }
  }

  Future<void> _reconcileAfterRestart() async {
    final stuck = await MediaDownloadQueueDao.getByStatus('downloading');
    if (stuck.isEmpty) return;

    final activeTaskIds = (await FileDownloader().allTasks()).map((t) => t.taskId).toSet();

    for (final item in stuck) {
      if (!activeTaskIds.contains(item.taskId)) {
        await MediaDownloadQueueDao.updateStatus(item.taskId, status: 'pending');
      }
    }
    await _dispatchPendingToDownloader();
  }

  Future<void> _refreshCounts() async {
    final counts = await MediaDownloadQueueDao.getStatusCounts();
    _statusCountsController.add(counts);
  }

  void dispose() {
    _statusCountsController.close();
    _liveEventsController.close();
  }
}
