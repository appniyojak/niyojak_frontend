import 'package:flutter/material.dart';

import '../helpers/static_data.dart' as Statics;
import '../models/response_model/event_attendance_resp_model.dart';

/// Attendance status for a single swayamsevak on this event.
enum AttendanceStatus { present, half, absent, noResponse }

extension AttendanceStatusVars on AttendanceStatus {
  /// Maps to the same Status codes used by updateSwayamsevakEventStatus
  /// in EventCard (1 = present/यes, 0 = absent/no, 2 = half).
  /// noResponse has no pk value — it's never sent to the API, only used
  /// for local filtering/display before a status exists.
  int? get pkValue {
    switch (this) {
      case AttendanceStatus.present:
        return 1;
      case AttendanceStatus.absent:
        return 0;
      case AttendanceStatus.half:
        return 2;
      case AttendanceStatus.noResponse:
        return null;
    }
  }

  String get label {
    switch (this) {
      case AttendanceStatus.present:
        return Statics.getLabel('AttendancePresent', returnKey: true) ?? 'पूर्ण';
      case AttendanceStatus.half:
        return Statics.getLabel('AttendanceHalf', returnKey: true) ?? 'अर्ध';
      case AttendanceStatus.absent:
        return Statics.getLabel('AttendanceAbsent', returnKey: true) ?? 'गैरहजर';
      case AttendanceStatus.noResponse:
        return Statics.getLabel('AttendanceNoResponse', returnKey: true) ?? 'प्रतिसाद नाही';
    }
  }

  /// Short label used inside the take-attendance 3-way toggle (गैर. instead
  /// of गैरहजर, to match the compact pill in the screenshot).
  String get shortLabel {
    switch (this) {
      case AttendanceStatus.present:
        return Statics.getLabel('AttendancePresentShort', returnKey: true) ?? 'पूर्ण';
      case AttendanceStatus.half:
        return Statics.getLabel('AttendanceHalfShort', returnKey: true) ?? 'अर्ध';
      case AttendanceStatus.absent:
        return Statics.getLabel('AttendanceAbsentShort', returnKey: true) ?? 'गैर.';
      case AttendanceStatus.noResponse:
        return label;
    }
  }

  Color get fgColor {
    switch (this) {
      case AttendanceStatus.present:
        return Color(0xFF1E8E3E);
      case AttendanceStatus.half:
        return Color(0xFF9A7B0A);
      case AttendanceStatus.absent:
        return Color(0xFFC62828);
      case AttendanceStatus.noResponse:
        return Color(0xFF5F5F5F);
    }
  }

  Color get bgColor {
    switch (this) {
      case AttendanceStatus.present:
        return Color(0xFFE6F4EA);
      case AttendanceStatus.half:
        return Color(0xFFFBF0D9);
      case AttendanceStatus.absent:
        return Color(0xFFFCE8E8);
      case AttendanceStatus.noResponse:
        return Color(0xFFEDEDED);
    }
  }
}

class EventAttendanceStatusScreen extends StatefulWidget {
  static const String routeName = '/event-attendance-status';

  const EventAttendanceStatusScreen({Key? key}) : super(key: key);

  @override
  State<EventAttendanceStatusScreen> createState() => _EventAttendanceStatusScreenState();
}

class _EventAttendanceStatusScreenState extends State<EventAttendanceStatusScreen> {
  int? eventId;

  bool _isLoading = true;
  bool _isTakingAttendance = false;

  int _totalExpected = 0;
  int _totalPresent = 0;
  int _totalHalf = 0;
  int _totalAbsent = 0;
  int _totalNoResponse = 0;

  List<AttendanceSwayamsevak> _allSwayamsevak = [];

  /// null == "सगळे" (no filter). Only used in view mode.
  AttendanceStatus? _activeFilter;

  /// Per-row locally-edited status while in take-attendance mode, keyed by
  /// swayamsevakId. Defaults to AttendanceStatus.present for every row the
  /// moment take-attendance mode opens (per your instruction — since there's
  /// no bulk-mark API yet, this locally achieves "everyone starts marked
  /// present" without a network call).
  Map<int, AttendanceStatus> _editedStatus = {};

  /// swayamsevakId currently mid-save, so its row shows a spinner and is
  /// disabled instead of the toggle.
  int? _savingId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  initData() async {
    eventId = ModalRoute.of(context)?.settings.arguments as int?;

    setState(() {});
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    setState(() => _isLoading = true);

    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showToast(Statics.getLabel('internetNotConnected'));
      setState(() => _isLoading = false);
      return;
    }

    try {
      var inputData = {
        "AppUserID": Statics.userDetails["userID"],
        "EventID": eventId,
      };

      var data = await Statics.getEventStatusForAllSwayamsevakData(inputData);

      if (data == null || (data.status != 'Success' && data.status != '200')) {
        Statics.showToast(Statics.getLabel('unableToCompleteProcess'));
        setState(() => _isLoading = false);
        return;
      }

      _totalExpected = data.totalExpected ?? 0;
      _totalPresent = data.totalPresentCnt ?? 0;
      _totalHalf = data.totalHalfpresentCnt ?? 0;
      _totalAbsent = data.totalAbsentCnt ?? 0;
      _totalNoResponse = data.noResponseCnt ?? 0;

      List<AttendanceSwayamsevak> combined = [];
      combined.addAll(data.present ?? []);
      combined.addAll(data.halfpresent ?? []);
      combined.addAll(data.absent ?? []);
      combined.addAll(data.noResponse ?? []);

      setState(() {
        _allSwayamsevak = combined;
        _isLoading = false;
      });
    } catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
      setState(() => _isLoading = false);
    }
  }

  List<AttendanceSwayamsevak> get _filteredList {
    if (_activeFilter == null) return _allSwayamsevak;
    return _allSwayamsevak.where((e) => e.status == _activeFilter).toList();
  }

  void _startTakingAttendance() {
    // Default every row to पूर्ण locally (no bulk API yet — see note above).
    Map<int, AttendanceStatus> defaults = {};
    for (var sw in _allSwayamsevak) {
      defaults[sw.swayamsevakID!] = AttendanceStatus.present;
    }
    setState(() {
      _editedStatus = defaults;
      _isTakingAttendance = true;
    });
  }

  Future<void> _exitTakingAttendance() async {
    setState(() => _isTakingAttendance = false);
    // Refresh counts/list now that individual rows may have changed.
    await _fetchAttendance();
  }

  /// Same underlying API you're already using for the swayamsevak's own
  /// RSVP (Statics.changeEventStatusForSwayamsevakData) — here it's the
  /// owner marking a *different* person's attendance, so SwayamsevakID is
  /// that person's id instead of the current user's.
  Future<void> _updateAttendanceFor(AttendanceSwayamsevak person, AttendanceStatus newStatus) async {
    if (_savingId != null) return;

    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showToast(Statics.getLabel('internetNotConnected'));
      return;
    }

    setState(() => _savingId = person.swayamsevakID);

    bool success = false;
    try {
      var inputData = {
        "EventID": eventId,
        "AppUserID": Statics.userDetails["userID"],
        "Status": newStatus.pkValue,
        "SwayamsevakID": person.swayamsevakID,
        "Remark": person.reason,
      };
      var result = await Statics.changeEventStatusForSwayamsevakData(inputData);
      success = result == true;
    } finally {
      if (mounted) setState(() => _savingId = null);
    }

    if (success) {
      setState(() => _editedStatus[person.swayamsevakID!] = newStatus);
    } else {
      Statics.showToast(Statics.getLabel('RsvpUpdateFailed') ?? 'अद्ययावत करण्यात अडचण आली, पुन्हा प्रयत्न करा');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F5FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF9C2AA0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_isTakingAttendance) {
              _exitTakingAttendance();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          _isTakingAttendance ? (Statics.getLabel('TakeAttendanceTitle') ?? 'उपस्थिती घ्या') : (Statics.getLabel('AttendanceStatusTitle') ?? 'उपस्थिती स्थिती'),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _isTakingAttendance
              ? _buildTakeAttendanceBody()
              : _buildViewBody(),
    );
  }

  // ---------------- View mode ----------------

  Widget _buildViewBody() {
    return RefreshIndicator(
      onRefresh: _fetchAttendance,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard(AttendanceStatus.present, _totalPresent)),
              SizedBox(width: 10),
              Expanded(child: _buildStatCard(AttendanceStatus.half, _totalHalf)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildStatCard(AttendanceStatus.absent, _totalAbsent)),
              SizedBox(width: 10),
              Expanded(child: _buildStatCard(AttendanceStatus.noResponse, _totalNoResponse)),
            ],
          ),
          SizedBox(height: 14),

          // "Take Attendance" entry point into edit mode.
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _allSwayamsevak.isEmpty ? null : _startTakingAttendance,
              icon: Icon(Icons.fact_check_outlined, size: 18),
              label: Text(Statics.getLabel('TakeAttendanceButton') ?? 'उपस्थिती घ्या'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9C2AA0),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          SizedBox(height: 14),

          _buildFilterChips(),
          SizedBox(height: 10),

          if (_filteredList.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  Statics.getLabel('NoDataFound') ?? 'माहिती उपलब्ध नाही',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: _filteredList.asMap().entries.map((entry) {
                  final isLast = entry.key == _filteredList.length - 1;
                  return _buildViewRow(entry.value, isLast);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(AttendanceStatus status, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: status.bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: status.fgColor),
          ),
          SizedBox(height: 2),
          Text(
            status.label,
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: status.fgColor),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final options = <AttendanceStatus?>[null, AttendanceStatus.present, AttendanceStatus.half, AttendanceStatus.absent];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((opt) {
          final isSelected = _activeFilter == opt;
          final label = opt == null ? (Statics.getLabel('AttendanceAll') ?? 'सगळे') : opt.label;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _activeFilter = opt),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildViewRow(AttendanceSwayamsevak person, bool isLast) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.fullName ?? "--",
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                SizedBox(height: 2),
                Text(
                  person.dname ?? "--",
                  style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: person.status.bgColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              person.status.label,
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: person.status.fgColor),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Take-attendance (edit) mode ----------------
  // NOTE: the "सगळे उपस्थित म्हणून चिन्हांकित करा" banner + "लागू करा"
  // bulk-mark button from the reference screenshot is intentionally left
  // out — there's no bulk-mark API yet. Every row instead defaults to
  // पूर्ण locally the moment this mode opens (see _startTakingAttendance),
  // and each row saves individually the moment its toggle is tapped.

  Widget _buildTakeAttendanceBody() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: _allSwayamsevak.map((person) => _buildEditRow(person)).toList(),
    );
  }

  Widget _buildEditRow(AttendanceSwayamsevak person) {
    final current = _editedStatus[person.swayamsevakID] ?? AttendanceStatus.present;
    final isSaving = _savingId == person.swayamsevakID;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              person.fullName ?? "--",
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 10),
          if (isSaving)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF9C2AA0)),
            )
          else
            _buildThreeWayToggle(person, current),
        ],
      ),
    );
  }

  Widget _buildThreeWayToggle(AttendanceSwayamsevak person, AttendanceStatus current) {
    final options = [AttendanceStatus.present, AttendanceStatus.half, AttendanceStatus.absent];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: options.map((opt) {
        final isSelected = current == opt;
        return GestureDetector(
          onTap: isSelected ? null : () => _updateAttendanceFor(person, opt),
          child: Container(
            margin: const EdgeInsets.only(left: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? opt.fgColor : Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: opt.fgColor, width: 1.2),
            ),
            child: Text(
              opt.shortLabel,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : opt.fgColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
