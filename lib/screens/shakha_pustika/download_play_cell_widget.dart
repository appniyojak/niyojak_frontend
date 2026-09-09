import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../helpers/media_downloader/media_downloader_helper.dart';
import '../../helpers/media_downloader/media_downloader_service.dart';
import '../../helpers/static_data.dart' as Statics;
import 'audio_helper.dart';
import 'audio_player_dialogue.dart';

enum _CellState { checking, notDownloaded, queuedOrDownloading, downloaded, failed }

class DownloadPlayCell extends StatefulWidget {
  final int pkid;
  final String tablename;
  final String remoteRelativePath; // raw path as returned by the search API, e.g. "Files/shaakhapustika/xxx.mp4"
  final String resolvedUrlForDiskCheck; // _resolveFileUrl(remoteRelativePath) — only used to derive the local filename
  final String title;
  final bool fromDataTable;
  final bool showDeleteIcon;

  const DownloadPlayCell({
    required this.pkid,
    required this.tablename,
    required this.remoteRelativePath,
    required this.resolvedUrlForDiskCheck,
    required this.title,
    this.fromDataTable = false,
    this.showDeleteIcon = false,
  });

  @override
  State<DownloadPlayCell> createState() => DownloadPlayCellState();
}

class DownloadPlayCellState extends State<DownloadPlayCell> {
  _CellState _state = _CellState.checking;
  String? _localPath;
  int _progress = 0;
  String? _errorMessage;
  StreamSubscription<DownloadLiveEvent>? _liveSub;

  final AudioPlayer _player = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<Duration>? _durationSub;
  StreamSubscription<Duration>? _positionSub;
  bool _playerReady = false;

  String get _taskId => '${widget.tablename}_${widget.pkid}';

  @override
  void initState() {
    super.initState();
    _bootstrap();
    _liveSub = MediaDownloadService.instance.liveEvents.listen(_onLiveEvent);
  }

  @override
  void dispose() {
    _liveSub?.cancel();
    _playerStateSub?.cancel();
    _durationSub?.cancel();
    _positionSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    if (widget.remoteRelativePath.isEmpty) {
      setState(() => _state = _CellState.notDownloaded);
      return;
    }

    // Fast path: check disk directly first — cheap, and correctly reflects
    // a file downloaded by EITHER this screen or the background auto-sync,
    // since both write to the same subdirectory with the same filename scheme.
    final path = await AudioFileHelper.getLocalFilePath(widget.resolvedUrlForDiskCheck);
    if (await File(path).exists()) {
      if (!mounted) return;
      setState(() {
        _localPath = path;
        _state = _CellState.downloaded;
      });
      _setupPlayerIfNeeded();
      return;
    }

    // Not on disk — check whether the background auto-sync already has this
    // queued or in progress, so we don't show a plain "tap to download"
    // icon for something that's already moving.
    final queueItem = await MediaDownloadQueueDao.getByTaskId(_taskId);
    if (!mounted) return;
    if (queueItem != null && (queueItem.status == 'downloading' || queueItem.status == 'pending')) {
      setState(() {
        _state = _CellState.queuedOrDownloading;
        _progress = queueItem.progress;
      });
    } else if (queueItem != null && queueItem.status == 'failed') {
      setState(() {
        _state = _CellState.failed;
        _errorMessage = queueItem.errorMessage;
      });
    } else {
      setState(() => _state = _CellState.notDownloaded);
    }
  }

  Future<void> _setupPlayerIfNeeded() async {
    if (_playerReady || _localPath == null) return;
    _playerReady = true;
    await _player.setSourceDeviceFile(_localPath!);
    final dur = await _player.getDuration();
    if (dur != null && mounted) setState(() => _duration = dur);

    _playerStateSub = _player.onPlayerStateChanged.listen((s) {
      if (mounted) setState(() => _playerState = s);
    });
    _durationSub = _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    _positionSub = _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
  }

  Future<void> _togglePlay() async {
    if (_playerState == PlayerState.playing) {
      await _player.pause();
    } else {
      await _player.resume();
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _onLiveEvent(DownloadLiveEvent event) {
    if (event.taskId != _taskId || !mounted) return;

    switch (event.type) {
      case DownloadLiveEventType.progress:
        setState(() {
          _state = _CellState.queuedOrDownloading;
          _progress = event.progress ?? _progress;
        });
        break;
      case DownloadLiveEventType.statusChanged:
        setState(() => _state = _CellState.queuedOrDownloading);
        break;
      case DownloadLiveEventType.completed:
        _bootstrap(); // re-check disk to pick up the final local path
        break;
      case DownloadLiveEventType.failed:
        setState(() {
          _state = _CellState.failed;
          _errorMessage = event.errorMessage;
        });
        break;
    }
  }

  Future<void> _startDownload() async {
    setState(() => _state = _CellState.queuedOrDownloading);
    final result = await MediaDownloadService.instance.requestDownload(
      pkid: widget.pkid,
      tablename: widget.tablename,
      remoteFilepath: widget.remoteRelativePath,
      existingLocalFilepath: _localPath,
    );

    if (!mounted) return;
    if (result == RequestDownloadResult.alreadyDownloaded) {
      await _bootstrap();
    }
    // alreadyInProgress / startedNow: liveEvents will drive further updates
  }

  Future<void> _deleteFile() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(Statics.getLabel('Alert')),
        content: Text(Statics.getLabel('ToDeleteFile')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(Statics.getLabel('Cancel'))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(Statics.getLabel('DeleteFile'), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      if (_localPath != null) {
        await _player.stop();
        _playerReady = false;
        final file = File(_localPath!);
        if (await file.exists()) await file.delete();

        // Keep the local DB in sync — if this pkid's row was pointing at
        // the file we just deleted, clear it so other screens reading the
        // local table don't serve a dangling path.
        await MediaDownloadQueueDao.clearLocalFilepathIfMatches(
          tablename: widget.tablename,
          pkid: widget.pkid,
          localPathToClear: _localPath!,
        );
      }
      if (!mounted) return;
      setState(() {
        _state = _CellState.notDownloaded;
        _localPath = null;
      });
      Statics.showToast(Statics.getLabel('FileGetDeleted'));
    } catch (e) {
      Statics.showToast(Statics.getLabel('ProblemMassage'));
    }
  }

  void _playFile() {
    if (_localPath == null) return;
    showDialog(
      context: context,
      builder: (_) => AudioPlayerDialog(title: '🎧', audioUrl: _localPath!, isLocalFile: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.remoteRelativePath.isEmpty) {
      return const Center(child: Text('---'));
    }

    switch (_state) {
      case _CellState.checking:
        return const Center(
          child: SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)),
        );

      case _CellState.queuedOrDownloading:
        return Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: _progress > 0 ? _progress / 100 : null, // indeterminate while waiting, determinate once ticking
            ),
          ),
        );

      case _CellState.downloaded:
        final total = _duration.inMilliseconds > 0 ? _duration.inMilliseconds.toDouble() : 1.0;
        final current = _position.inMilliseconds.clamp(0, total.toInt()).toDouble();
        if (widget.fromDataTable)
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(onTap: _playFile, child: const Icon(Icons.remove_red_eye_rounded, color: Colors.green, size: 19)),
              const SizedBox(width: 12),
              InkWell(onTap: _deleteFile, child: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 19)),
            ],
          );
        return Row(
          children: [
            InkWell(
              onTap: _togglePlay,
              child: Icon(
                _playerState == PlayerState.playing ? Icons.pause_circle_filled : Icons.play_circle_fill,
                color: Colors.deepOrange,
                size: 32,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  min: 0,
                  max: total,
                  value: current,
                  onChanged: (v) => _player.seek(Duration(milliseconds: v.toInt())),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(_formatDuration(_position), style: const TextStyle(fontSize: 11, color: Colors.black54)),
            const SizedBox(width: 8),
            if (widget.showDeleteIcon) InkWell(onTap: _deleteFile, child: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 19)),
          ],
        );

      case _CellState.failed:
        return Center(
          child: InkWell(
            onTap: _startDownload,
            child: const Icon(Icons.refresh, color: Colors.orange, size: 19),
          ),
        );

      case _CellState.notDownloaded:
        return Center(
          child: InkWell(onTap: _startDownload, child: const Icon(Icons.download, color: Colors.blue, size: 19)),
        );
    }
  }
}
