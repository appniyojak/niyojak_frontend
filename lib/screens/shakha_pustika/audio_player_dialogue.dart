import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../helpers/static_data.dart' as Statics;

/// Reusable "now playing" dialog. Works for a remote URL (isLocalFile:
/// false) or a file already downloaded on disk (isLocalFile: true).
///
/// This is the same dialog used inside the results table's download
/// column, and inside SangrahaShkhaPustikaScreen's play button, so the
/// playback UI is identical everywhere.
class AudioPlayerDialog extends StatefulWidget {
  final String title;
  final String audioUrl;
  final bool isLocalFile;

  const AudioPlayerDialog({
    Key? key,
    required this.title,
    required this.audioUrl,
    this.isLocalFile = false,
  }) : super(key: key);

  @override
  State<AudioPlayerDialog> createState() => _AudioPlayerDialogState();
}

class _AudioPlayerDialogState extends State<AudioPlayerDialog> {
  final AudioPlayer _player = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _isCompleted = false; // NEW — tracks whether playback ran to the end
  String? _error;
  late final Source _source; // NEW — kept so we can fully replay via play() after completion

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    await _player.setReleaseMode(ReleaseMode.stop);

    _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });

    _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    _player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _isCompleted = true; // NEW — mark so the next play re-issues play(source)
          _position = _duration; // NEW — show the slider/time at the end instead of snapping to 0
        });
      }
    });

    try {
      // NEW — build and hold the Source once, reused for both first play and replay
      _source = widget.isLocalFile
          ? DeviceFileSource(widget.audioUrl, mimeType: 'audio/mp3') //'audio/${widget.audioUrl.split(".").last}')
          : UrlSource(widget.audioUrl, mimeType: 'audio/mp3'); //'audio/${widget.audioUrl.split(".").last}');

      await _player.play(_source); // CHANGED — play(source) instead of setSourceX + resume
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = Statics.getLabel('FileNotPlayed');
      });
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
      return;
    }

    if (_isCompleted) {
      // NEW — playback had finished; resume() won't restart a completed
      // session on some platforms, so fully re-issue play() instead.
      setState(() {
        _isCompleted = false;
        _position = Duration.zero;
      });
      await _player.play(_source);
      return;
    }

    await _player.resume();
  }

  Future<void> _seekBy(int seconds) async {
    final newPosition = _position + Duration(seconds: seconds);
    final clamped = newPosition < Duration.zero ? Duration.zero : (newPosition > _duration ? _duration : newPosition);

    if (_isCompleted) {
      // NEW — seeking after completion needs a real replay to re-arm the session
      setState(() => _isCompleted = false);
      await _player.play(_source);
    }
    await _player.seek(clamped);
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.cancel_outlined, color: Colors.purple),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isLoading) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: CircularProgressIndicator(),
              ),
            ] else if (_error != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            ] else ...[
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Slider(
                  value: _position.inMilliseconds.clamp(0, _duration.inMilliseconds == 0 ? 1 : _duration.inMilliseconds).toDouble(),
                  min: 0,
                  max: _duration.inMilliseconds == 0 ? 1 : _duration.inMilliseconds.toDouble(),
                  activeColor: primaryColor,
                  onChanged: (value) async {
                    final target = Duration(milliseconds: value.toInt());
                    if (_isCompleted) {
                      // NEW — dragging the slider after completion also needs a real replay
                      setState(() => _isCompleted = false);
                      await _player.play(_source);
                    }
                    await _player.seek(target);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_position), style: const TextStyle(fontSize: 12)),
                    Text(_formatDuration(_duration), style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay_10_rounded),
                    iconSize: 30,
                    color: primaryColor,
                    onPressed: () => _seekBy(-10),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded),
                    iconSize: 48,
                    color: primaryColor,
                    onPressed: _togglePlayPause,
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.forward_10_rounded),
                    iconSize: 30,
                    color: primaryColor,
                    onPressed: () => _seekBy(10),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
