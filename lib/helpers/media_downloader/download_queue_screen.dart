import 'package:flutter/material.dart';

import 'media_downloader_helper.dart';
import 'media_downloader_service.dart';

/// Note: 'completed' downloads are deleted from the queue table by design
/// (path moves to the parent record instead), so there's no "completed"
/// tab — a row plays a brief checkmark + fade-out animation on completion
/// instead of just vanishing, then it's gone.
class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Downloads'),
          /*bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [Tab(text: 'Active'), Tab(text: 'Pending'), Tab(text: 'Failed')],
        ),*/
        ),
        body: _StatusList(status: 'downloading', showOverallHeader: true)
        /*TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: const [
          _StatusList(status: 'downloading', showOverallHeader: true),
          _StatusList(status: 'pending'),
          _StatusList(status: 'failed'),
        ],
      ),*/
        );
  }
}

class _StatusList extends StatefulWidget {
  final String status;
  final bool showOverallHeader;

  const _StatusList({required this.status, this.showOverallHeader = false});

  @override
  State<_StatusList> createState() => _StatusListState();
}

class _StatusListState extends State<_StatusList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Map<String, dynamic>> _items = [];
  final ScrollController _scrollController = ScrollController();
  static const _pageSize = 30;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent - 200) {
        _loadMore();
      }
    });
    MediaDownloadService.instance.liveEvents.listen(_onLiveEvent);
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    final page = await MediaDownloadQueueDao.getPageWithMeta(
      widget.status,
      limit: _pageSize,
      offset: _items.length,
    );
    for (final row in page) {
      _items.add(row);
      _listKey.currentState?.insertItem(_items.length - 1, duration: const Duration(milliseconds: 250));
    }
    _hasMore = page.length == _pageSize;
    _isLoading = false;
    if (mounted) setState(() {});
  }

  Future<void> _reload() async {
    if (mounted)
      setState(() {
        _items.clear();
        _hasMore = true;
      });
    await _loadMore();
  }

  // Routes a live event to: update-in-place, animate a new arrival in, or
  // animate a departure out — depending on whether the event's new status
  // still belongs in THIS tab.
  void _onLiveEvent(DownloadLiveEvent event) {
    final index = _items.indexWhere((i) => i['taskId'] == event.taskId);

    switch (event.type) {
      case DownloadLiveEventType.progress:
        if (index != -1 && widget.status == 'downloading') {
          if (mounted) setState(() => _items[index] = {..._items[index], 'progress': event.progress});
        }
        break;

      case DownloadLiveEventType.completed:
        // A completed item leaves every tab it might be sitting in.
        if (index != -1) _playCompletionThenRemove(index);
        break;

      case DownloadLiveEventType.statusChanged:
      case DownloadLiveEventType.failed:
        _reconcileTabMembership(index, event.status, event.errorMessage);
        break;
    }
  }

  void _reconcileTabMembership(int index, String? newStatus, String? errorMessage) {
    final belongsHere = newStatus == widget.status;

    if (belongsHere && index == -1) {
      // Item transitioned into this tab (e.g. pending -> downloading) —
      // re-fetch its row (with joined meta) and slide it in at the top.
      _fetchSingleAndInsertAtTop();
    } else if (!belongsHere && index != -1) {
      _removeAnimated(index);
    } else if (belongsHere && index != -1 && errorMessage != null) {
      if (mounted) setState(() => _items[index] = {..._items[index], 'errorMessage': errorMessage});
    }
  }

  Future<void> _fetchSingleAndInsertAtTop() async {
    final page = await MediaDownloadQueueDao.getPageWithMeta(widget.status, limit: 1, offset: 0);
    if (page.isEmpty) return;
    final row = page.first;
    if (_items.any((i) => i['taskId'] == row['taskId'])) return;
    _items.insert(0, row);
    _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 300));
  }

  void _removeAnimated(int index) {
    final removed = _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildRow(removed, animation, isLeaving: true),
      duration: const Duration(milliseconds: 300),
    );
  }

  void _playCompletionThenRemove(int index) {
    if (mounted) setState(() => _items[index] = {..._items[index], '_justCompleted': true});
    Future.delayed(const Duration(milliseconds: 700), () {
      final i = _items.indexWhere((item) => item == _items[index]);
      if (i != -1) _removeAnimated(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showOverallHeader) _OverallProgressHeader(items: _items),
        Expanded(
          child: _items.isEmpty && !_isLoading
              ? Center(child: Text('No ${widget.status} downloads'))
              : RefreshIndicator(
                  onRefresh: _reload,
                  child: AnimatedList(
                    key: _listKey,
                    controller: _scrollController,
                    initialItemCount: _items.length,
                    itemBuilder: (context, index, animation) {
                      if (index >= _items.length) return const SizedBox.shrink();
                      return _buildRow(_items[index], animation);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildRow(Map<String, dynamic> row, Animation<double> animation, {bool isLeaving = false}) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: _DownloadTile(row: row),
      ),
    );
  }
}

/// A thin animated bar at the top of the Active tab — gives an immediate,
/// at-a-glance sense of motion even before the user looks at individual rows.
class _OverallProgressHeader extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const _OverallProgressHeader({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final totalProgress = items.fold<int>(0, (sum, i) => sum + (i['progress'] as int? ?? 0));
    final overall = totalProgress / (items.length * 100);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
      child: Row(
        children: [
          Text('Downloading ${items.length} file${items.length == 1 ? '' : 's'}', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: 10),
          Expanded(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              tween: Tween(begin: 0, end: overall.clamp(0, 1)),
              builder: (context, value, _) => ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: value, minHeight: 6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadTile extends StatelessWidget {
  final Map<String, dynamic> row;

  const _DownloadTile({required this.row});

  @override
  Widget build(BuildContext context) {
    final title = (row['karyakramname'] as String?)?.trim();
    final displayTitle = (title == null || title.isEmpty) ? 'Media #${row['pkid']}' : title;
    final status = row['status'] as String;
    final progress = (row['progress'] as int? ?? 0);
    final errorMessage = row['errorMessage'] as String?;
    final justCompleted = row['_justCompleted'] == true;

    return ListTile(
      leading: justCompleted
          ? const Icon(Icons.check_circle, color: Colors.green)
          : status == 'downloading'
              ? const _PulsingIcon(icon: Icons.downloading, color: Colors.blue)
              : status == 'failed'
                  ? const Icon(Icons.error_outline, color: Colors.red)
                  : const _PulsingIcon(icon: Icons.schedule, color: Colors.grey),
      title: Text(displayTitle),
      subtitle: justCompleted
          ? const Text('Downloaded', style: TextStyle(color: Colors.green))
          : status == 'failed'
              ? Text(errorMessage ?? 'Failed', style: const TextStyle(color: Colors.red))
              : status == 'downloading'
                  ? _SmoothProgressBar(progress: progress)
                  : const _WaitingLabel(),
      trailing: status == 'failed' // || status == 'pending'
          ? IconButton(
              icon: const Icon(Icons.refresh, color: Colors.orange),
              tooltip: 'Retry',
              onPressed: () => MediaDownloadService.instance.retryNow(row['taskId'] as String),
            )
          : status == 'downloading'
              ? _AnimatedPercentText(progress: progress)
              : null,
    );
  }
}

/// Smoothly interpolates between progress values instead of jumping — the
/// key fix for the "laggy" feel, since TweenAnimationBuilder animates from
/// whatever value it was last showing to the new one, not just on entry.
class _SmoothProgressBar extends StatelessWidget {
  final int progress;

  const _SmoothProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        tween: Tween(begin: 0, end: progress / 100),
        builder: (context, value, _) => ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: value, minHeight: 5),
        ),
      ),
    );
  }
}

class _AnimatedPercentText extends StatelessWidget {
  final int progress;

  const _AnimatedPercentText({required this.progress});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      duration: const Duration(milliseconds: 350),
      tween: IntTween(begin: 0, end: progress),
      builder: (context, value, _) => Text('$value%', style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

/// Waiting-to-start items show 0% forever until dispatched — without some
/// motion here, they look frozen/broken. A soft pulse signals "still alive,
/// just queued" without implying real progress is happening.
class _WaitingLabel extends StatelessWidget {
  const _WaitingLabel();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _PulsingDot(),
        SizedBox(width: 6),
        Text('Waiting to start', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.3, end: 1.0).animate(_controller),
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
      ),
    );
  }
}

/// Same pulse concept applied to a leading icon, for downloading/pending rows.
class _PulsingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;

  const _PulsingIcon({required this.icon, required this.color});

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.4, end: 1.0).animate(_controller),
      child: Icon(widget.icon, color: widget.color),
    );
  }
}

class DownloadBadge extends StatelessWidget {
  const DownloadBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, int>>(
      stream: MediaDownloadService.instance.statusCounts,
      builder: (context, snapshot) {
        final counts = snapshot.data ?? {};
        final active = (counts['pending'] ?? 0) + (counts['downloading'] ?? 0);
        final failed = counts['failed'] ?? 0;

        return IconButton(
          tooltip: 'Downloads',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const DownloadsScreen()),
          ),
          icon: Badge(
            isLabelVisible: active > 0 || failed > 0,
            label: Text('${active > 0 ? active : failed}'),
            backgroundColor: failed > 0 && active == 0 ? Colors.red : null,
            child: Icon(
              active > 0 ? Icons.downloading : Icons.download_outlined,
            ),
          ),
        );
      },
    );
  }
}
