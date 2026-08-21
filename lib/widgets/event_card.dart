import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../helpers/static_data.dart' as Statics;
import '../models/response_model/event_master_list_resp_model.dart';
import '../models/response_model/new_search_swayamsevak_model.dart';
import '../screens/edit_event.dart';
import '../screens/event_attendance_screen.dart';
import '../screens/event_members.dart';
import '../screens/event_vrutta.dart';

/// RSVP answer for "तुम्ही येणार का?" — maps to eventItem.pStatus.
/// Adjust the int mapping in [_EventCardState._rsvpStatusFromCode] if your API uses different codes.
enum RsvpStatus { yes, no, half }

extension RsvpStatusVars on RsvpStatus {
  String get name {
    switch (this) {
      case RsvpStatus.yes:
        return Statics.getLabel('ConfirmationYes', returnKey: true);
      case RsvpStatus.no:
        return Statics.getLabel('ConfirmationNo', returnKey: true);
      case RsvpStatus.half:
        return Statics.getLabel('ConfirmationHalf', returnKey: true);
    }
  }

  int get pkValues {
    switch (this) {
      case RsvpStatus.yes:
        return 1;
      case RsvpStatus.no:
        return 0;
      case RsvpStatus.half:
        return 2;
    }
  }
}

class EventCard extends StatefulWidget {
  final EventMaster eventItem;
  final void Function() search;

  EventCard(this.eventItem, this.search);

  @override
  State<EventCard> createState() => _EventCardState();
}

// NOTE on the fix: EventCard used to be a StatelessWidget storing RSVP/menu
// state as plain instance fields. Every rebuild of the parent list (e.g. the
// keyboard opening for the reason TextField, or the PopupMenuButton
// triggering a rebuild) creates a brand-new EventCard(...) instance in your
// itemBuilder, which wiped those fields back to their defaults. Converting
// to StatefulWidget means Flutter keeps ONE _EventCardState object alive
// across those rebuilds, so _selectedRsvp / _reasonController / _swController
// now actually persist. Everything else stays as plain methods on this
// State class — no extra widget classes.
class _EventCardState extends State<EventCard> {
  TextEditingController _swController = TextEditingController();
  String? _swValue;

  RsvpStatus? _selectedRsvp;
  TextEditingController _reasonController = TextEditingController();
  bool _isUpdatingRsvp = false;

  // Whether the RSVP section is showing the होय/नाही/अर्ध picker (true) or
  // the confirmed one-line summary with "बदला" (false). Null until the
  // first build decides a default (edit if no answer yet, confirmed if
  // there's already a saved response).
  bool? _isEditingRsvp;

  var _todaysDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

  var _eventnameCtrl = TextEditingController();
  DateTime? _fromDate, _toDate;
  var _fromDateCntrl = TextEditingController();
  var _toDateCntrl = TextEditingController();

  TimeOfDay? _fromTime;
  var _fromTimeCntrl = TextEditingController();

  TimeOfDay? _toTime;
  var _toTimeCntrl = TextEditingController();

  @override
  void dispose() {
    _swController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<List<SwayamsevakNewData>> populateSwayamSevak(String pattern) async {
    bool isConnected = await Statics.isInternetConnected();

    if (pattern.length < 4) return [];
    if (isConnected) {
      var inputData = {
        'AppUserID': Statics.userDetails["userID"],
        'GeounitId': 0,
        "SearchText": pattern.isEmpty ? "" : pattern,
        "From": "karyakram",
      };

      var swList = await Statics.searchSwayamsevakNewData(inputData);

      return swList ?? [];
    } else {
      Statics.showToast(Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  Future<bool> updateSwayamsevakEventStatus() async {
    bool isConnected = await Statics.isInternetConnected();

    if (isConnected) {
      var inputData = {
        "EventID": widget.eventItem.eventID,
        "AppUserID": Statics.userDetails["userID"],
        "Status": _selectedRsvp?.pkValues,
        "SwayamsevakID": Statics.userDetails["userID"],
        "Remark": _reasonController.text.trim()
      };

      var swList = await Statics.changeEventStatusForSwayamsevakData(inputData);

      return swList;
    } else {
      Statics.showToast(Statics.getLabel('internetNotConnected'));
      return false;
    }
  }

  // ---- RSVP submit flow (wired to updateSwayamsevakEventStatus) ----

  /// Calls the change-status API with whatever is currently in
  /// _selectedRsvp / _reasonController, shows a loading state while the
  /// request is in flight, toasts the result, and refreshes the parent
  /// list (widget._search()) on success — same pattern _changeEventOwner
  /// already uses.
  Future<bool> _submitRsvp() async {
    if (_isUpdatingRsvp) return false;

    setState(() => _isUpdatingRsvp = true);
    bool success = false;
    try {
      success = await updateSwayamsevakEventStatus();
    } finally {
      if (mounted) setState(() => _isUpdatingRsvp = false);
    }

    if (success) {
      Statics.showToast(Statics.getLabel('RsvpUpdateSuccess') ?? 'तुमचा प्रतिसाद नोंदवला गेला');
      if (mounted) setState(() => _isEditingRsvp = false);
      widget.search();
    } else {
      Statics.showToast(Statics.getLabel('RsvpUpdateFailed') ?? 'प्रतिसाद नोंदवताना अडचण आली, पुन्हा प्रयत्न करा');
    }
    return success;
  }

  /////////////////////////////////////////////
  _pickFromDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: _fromDate == null ? DateTime.now() : _fromDate!,
        firstDate: DateTime((_fromDate == null ? DateTime.now().year : _fromDate!.year) - 80),
        lastDate: DateTime((_fromDate == null ? DateTime.now().year : _fromDate!.year) + 80));

    var _todaysDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    if (date != null && _todaysDate.isAfter(date)) {
      Statics.showToast(Statics.getLabel('CanNotCreateEventInPast'));
      return;
    }

    if (date != null) {
      setState(() {
        _fromDate = date;
        _fromDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date);
        if (_toDate == null) {
          _toDate = date;
          _toDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date);
        }
      });
    }
  }

  _pickToDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: _toDate == null ? DateTime.now() : _toDate!,
        firstDate: DateTime((_toDate == null ? DateTime.now().year : _toDate!.year) - 80),
        lastDate: DateTime((_toDate == null ? DateTime.now().year : _toDate!.year) + 80));

    var _todaysDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    if (date != null && _todaysDate.isAfter(date)) {
      Statics.showToast(Statics.getLabel('CanNotCreateEventInPast'));
      return;
    }
    if (date != null && _fromDate!.isAfter(date)) {
      Statics.showToast(Statics.getLabel('CanNotCreateEventInPast'));
      return;
    }

    if (date != null) {
      setState(() {
        _toDate = date;
        _toDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date);
      });
    }
  }

  _pickFrmTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _fromTime == null ? TimeOfDay.now() : _fromTime!,
    );

    if (time != null) {
      setState(() {
        _fromTime = time;
        _fromTimeCntrl.text =
            DateFormat("hh:mm").format(new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " + time.hour.toString() + ":" + time.minute.toString())) + (time.period == DayPeriod.am ? " AM" : " PM");
      });
    }
  }

  _pickToTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _toTime == null ? TimeOfDay.now() : _toTime!,
    );

    if (time != null) {
      setState(() {
        _toTime = time;
        _toTimeCntrl.text =
            DateFormat("hh:mm").format(new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " + time.hour.toString() + ":" + time.minute.toString())) + (time.period == DayPeriod.am ? " AM" : " PM");
      });
    }
  }

  showDuplicateDialog() async {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Column(
              spacing: 12,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Statics.getLabel("DuplicateEvent"),
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: true,
                        child: TextFormField(
                          controller: _fromDateCntrl,
                          decoration: InputDecoration(labelText: Statics.getLabel('FromEventDate')),
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.isEmpty) return (Statics.getLabel('FromEventDateValidationMessage'));
                            return null;
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      color: Colors.purple,
                      icon: FaIcon(FontAwesomeIcons.solidCalendarAlt),
                      onPressed: _pickFromDate,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: true,
                        child: TextFormField(
                          controller: _fromTimeCntrl,
                          decoration: InputDecoration(labelText: Statics.getLabel('FromTime')),
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.isEmpty) return (Statics.getLabel('FromTimeValidationMessage'));
                            return null;
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      color: Colors.purple,
                      icon: FaIcon(FontAwesomeIcons.clock),
                      onPressed: _pickFrmTime,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: true,
                        child: TextFormField(
                          controller: _toDateCntrl,
                          decoration: InputDecoration(labelText: Statics.getLabel('ToEventDate')),
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.isEmpty) return (Statics.getLabel('ToEventDateValidationMessage'));
                            return null;
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      color: Colors.purple,
                      icon: FaIcon(FontAwesomeIcons.solidCalendarAlt),
                      onPressed: _pickToDate,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: true,
                        child: TextFormField(
                          controller: _toTimeCntrl,
                          decoration: InputDecoration(labelText: Statics.getLabel('ToTime')),
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.isEmpty) return (Statics.getLabel('ToTimeValidationMessage'));
                            return null;
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      color: Colors.purple,
                      icon: FaIcon(FontAwesomeIcons.clock),
                      onPressed: _pickToTime,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                MaterialButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                  onPressed: () => _submitDuplicate(ctx),
                  child: Text(
                    Statics.getLabel('Submit'),
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then(
      (value) => value == true ? widget.search() : null,
    );
  }

  _submitDuplicate(BuildContext ctx) async {
    if (_fromDate!.isAfter(_toDate!)) {
      Statics.showErrorDialog(context, Statics.getLabel('ToDateCanNotBeBeforeFromDate'));
      return;
    }
    var inputData = json.encode({
      "EventID": widget.eventItem.eventID,
      "FromDateStr": (_fromDate != null ? DateFormat('dd-MM-yyyy').format(_fromDate!) : null),
      "ToDateStr": (_toDate != null ? DateFormat('dd-MM-yyyy').format(_toDate!) : null),
      "FromTimeStr": (_fromTime != null
          ? DateFormat("hh:mm").format(new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " + _fromTime!.hour.toString() + ":" + _fromTime!.minute.toString())) +
              (_fromTime!.period == DayPeriod.am ? " AM" : " PM")
          : null),
      "ToTimeStr": (_toTime != null
          ? DateFormat("hh:mm").format(new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " + _toTime!.hour.toString() + ":" + _toTime!.minute.toString())) +
              (_toTime!.period == DayPeriod.am ? " AM" : " PM")
          : null),
      "ModifiedBy": Statics.userDetails["userID"]
    });

    var data = await Statics.saveDuplicateEventDetails(inputData);

    if (data == null) {
      Statics.showToast(Statics.getLabel('unableToSaveData'));
      return;
    } else if (data == false) {
      Statics.showToast(Statics.getLabel('dataAlreadyExists'));
      return;
    }
    setState(() {});

    Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    Navigator.pop(ctx, true);
  }

  /////////////////////////////////////////////

  /// Handles a tap on होय / नाही / अर्ध.
  /// - होय / अर्ध submit immediately (no reason needed) and collapse back
  ///   to the confirmed summary line on success.
  /// - नाही reveals the reason field; actual submit happens from the
  ///   field's confirm button via _onReasonConfirmed.
  Future<void> _onRsvpOptionTapped(RsvpStatus status) async {
    if (_isUpdatingRsvp) return;

    final previous = _selectedRsvp;
    setState(() => _selectedRsvp = status);

    if (status == RsvpStatus.no) {
      // Wait for the reason field's confirm action.
      return;
    }

    final ok = await _submitRsvp();
    if (!ok && mounted) {
      setState(() => _selectedRsvp = previous);
    }
  }

  Future<void> _onReasonConfirmed() async {
    if (_reasonController.text.trim().isEmpty) {
      Statics.showToast(Statics.getLabel('ReasonValidationMessage') ?? 'कृपया कारण नमूद करा');
      return;
    }
    await _submitRsvp();
  }

  void _changeEventOwner(var context, var eventID) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Select'),
            content: Row(
              children: [
                Container(
                  width: Statics.getDeviceSize(context).width * 0.5,
                  child: TypeAheadField(
                    controller: _swController,
                    builder: (context, controller, focusNode) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          isDense: true,
                          border: UnderlineInputBorder(),
                          labelText: Statics.getLabel('searchSwayamsevakLabel'),
                        ),
                      );
                    },
                    // textFieldConfiguration: TextFieldConfiguration(
                    //     controller: this.,
                    //     decoration: InputDecoration(
                    //         labelText:
                    //             Statics.getLabel('searchSwayamsevakLabel'))),
                    suggestionsCallback: (pattern) {
                      this._swValue = "";
                      return populateSwayamSevak(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion.fullName ?? "--"),
                        subtitle: Wrap(
                          children: [
                            Text(
                              (suggestion.daayitvaGeoUnitName ?? "--") + "-",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              (suggestion.levelName ?? "--") + "-",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              suggestion.daayitvaName ?? "--",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    },
                    // transitionBuilder: (context, suggestionsBox, controller) {
                    //   return suggestionsBox;
                    // },
                    onSelected: (suggestion) {
                      this._swController.text = suggestion.fullName ?? "--";
                      _swValue = suggestion.swayamSevakID.toString();
                    },
                  ),
                ),
                IconButton(
                    color: Colors.purple,
                    onPressed: () {
                      this._swController.text = "";
                      _swValue = "";
                    },
                    icon: Icon(Icons.cancel)),
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('Submit'),
                onPressed: () async {
                  if (_swValue == null || _swValue == "") {
                    return Statics.showToast(Statics.getLabel('MemberValidationMessage'));
                  }
                  var inputData = json.encode({"EventID": eventID, "NewOwnerSwayamsevakID": _swValue, "ModifiedBy": Statics.userDetails["userID"]});
                  var data = await Statics.changeEventOwnerForApp(inputData);
                  if (data == "Event Owner Changed Successfully ") {
                    Statics.showToast(Statics.getLabel('EventOwnerChangedSuccessfully'));
                  } else
                    Statics.showToast(Statics.getLabel('CouldnotChangeOwner'));

                  _swValue = null;
                  _swController.text = "";
                  widget.search();
                  Navigator.of(ctx).pop();
                },
              ),
              MaterialButton(
                child: Text('Cancel'),
                onPressed: () {
                  _swValue = null;
                  _swController.text = "";
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    } on Exception catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    } catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    }
  }

  static RsvpStatus? _rsvpStatusFromCode(int? pStatus) {
    switch (pStatus) {
      case 1:
        return RsvpStatus.yes;
      case 0:
        return RsvpStatus.no;
      case 2:
        return RsvpStatus.half;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventItem = widget.eventItem;
    final bool isOwner = eventItem.ownerSwayamsevakID.toString() == Statics.userDetails["userID"];
    final bool isSharing = eventItem.isSharing == 1;

    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 5, right: 5),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // .event-card
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(14, (isOwner || !isSharing) ? 7 : 14, 0, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // .name
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 2,
                        children: [
                          Text(
                            eventItem.eventName ?? "--",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          // .type
                          Text(
                            eventItem.eventTypeCode ?? "--",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // .menu-dots
                    _buildPopupMenu(context),
                  ],
                ),
                SizedBox(height: 6),
                // .datetime
                Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.parse(eventItem.fromDateStr!)) + "  " + (eventItem.fromTimeStr ?? "") + " - " + (eventItem.toTimeStr ?? ""),
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 2),
                // .loc
                Text(
                  eventItem.geoUnitName ?? "--",
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade700,
                  ),
                ),

                // .stats (owner) / .rsvp-inline (not owner)
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: (isOwner) ? _buildStatsRow() : _buildRsvpSection(),
                ),
              ],
            ),
          ),

          // .badge-mine — shown only when the current user is NOT the owner (invited)
          Positioned(
            top: -7,
            left: 12,
            child: Row(
              spacing: 4,
              children: [if (!isOwner) _buildMineBadge("Apekshit"), if (isSharing) _buildMineBadge("Sharing")],
            ),
          ),
        ],
      ),
    );
  }

  // ---- UI pieces as plain Widget-returning methods (no widget classes) ----

  Widget _buildPopupMenu(BuildContext context) {
    final eventItem = widget.eventItem;

    final _isOwner = eventItem.ownerSwayamsevakID.toString() == Statics.userDetails["userID"];
    final _isSharing = eventItem.isSharing == 1;

    return PopupMenuButton(
      padding: EdgeInsets.zero,
      onSelected: (value) {
        if (value == "EditMenu" || value == "ViewMenu") {
          Navigator.of(context).pushNamed(EditEvent.routeName, arguments: Statics.ScreenArguments(eventItem.eventID!, value));
        } else if (value == "AddApekshitList" || value == "ViewApekshitList" || value == "AddSharingList" || value == "ViewSharingList") {
          Navigator.of(context).pushNamed(EventMembers.routeName, arguments: Statics.ScreenArguments(eventItem.eventID!, value));
        } else if (value == "ChangeOwner") {
          _changeEventOwner(context, eventItem.eventID);
        } else if (value == "EditVrutta" || value == "ViewVrutta") {
          print("value  == $value");
          Navigator.of(context).pushNamed(EventVrutta.routeName, arguments: Statics.ScreenArguments(eventItem.eventID!, value));
        } else if (value == "attendance") {
          print("value  == $value");
          Navigator.of(context).pushNamed(EventAttendanceStatusScreen.routeName, arguments: eventItem.eventID).then((value) => widget.search());
        } else if (value == "DuplicateEvent") {
          print("value  == $value");
          showDuplicateDialog();
          // Navigator.of(context).pushNamed(EditEvent.routeName, arguments: Statics.ScreenArguments(eventItem.eventID!, value)).then((value) => widget._search());
        }
      },
      icon: Icon(
        FontAwesomeIcons.ellipsisV,
        color: Colors.grey.shade700,
        size: 16,
      ),
      itemBuilder: (BuildContext context) {
        return [
          if (_isOwner || _isSharing) Statics.MenuItem(Statics.getLabel('EditMenu'), FontAwesomeIcons.edit, 'EditMenu'),
          if ((_isOwner || _isSharing) && eventItem.isfuture == 0) Statics.MenuItem(Statics.getLabel('attendance'), Icons.playlist_add_check_rounded, 'attendance'),
          Statics.MenuItem(Statics.getLabel('ViewMenu'), FontAwesomeIcons.eye, 'ViewMenu'),
          Statics.MenuItem(Statics.getLabel('ApekshitList'), Icons.people, (_isOwner || _isSharing) ? 'AddApekshitList' : 'ViewApekshitList'),
          Statics.MenuItem(Statics.getLabel('SharingList'), Icons.share, (_isOwner || _isSharing) ? 'AddSharingList' : 'ViewSharingList'),
          if (_isOwner || _isSharing) Statics.MenuItem(Statics.getLabel('ChangeOwner'), Icons.restore, 'ChangeOwner'),
          Statics.MenuItem(Statics.getLabel('Vrutta'), FontAwesomeIcons.eye,
              ((_isOwner || _isSharing) && (DateTime.parse(eventItem.fromDateStr!).isBefore(_todaysDate) || DateTime.parse(eventItem.fromDateStr!) == _todaysDate)) ? 'EditVrutta' : 'ViewVrutta'),
          if (_isOwner || _isSharing) Statics.MenuItem(Statics.getLabel('DuplicateEvent'), Icons.sticky_note_2, 'DuplicateEvent'),
        ].map((Statics.MenuItem menuItem) {
          return PopupMenuItem(
            //value: menuItem.menuVal,
            value: menuItem.menuKey,
            child: ListTile(
              leading: Icon(
                menuItem.iconVal,
                color: Colors.purple,
              ),
              title: Text(menuItem.menuVal),
            ),
          );
        }).toList();
      },
    );
  }

  Widget _buildStatPill(String emoji, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: TextStyle(fontSize: 12)),
        SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }

  // .stats — expected / present / absent pills, shown when isOwner == true.
  Widget _buildStatsRow() {
    final eventItem = widget.eventItem;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          _buildStatPill('👥', '${eventItem.apekshitCnt ?? 0} ${Statics.getLabel("Apekshit")}', Colors.purple.shade700),
          SizedBox(width: 14),
          _buildStatPill('✅', '${eventItem.presentCnt ?? 0} ${Statics.getLabel("Present")}', Colors.green.shade700),
          SizedBox(width: 14),
          _buildStatPill('❌', '${eventItem.absentCnt ?? 0} ${Statics.getLabel("Absent")}', Colors.red.shade700),
        ],
      ),
    );
  }

  /// Segmented control OR a small spinner while a request is in flight.
  Widget _buildRsvpControl() {
    if (_isUpdatingRsvp) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.purple.shade700),
      );
    }
    return _buildMiniSegmented();
  }

  Widget _buildMiniSegmented() {
    const options = [
      (RsvpStatus.yes, 'ConfirmationYes'),
      (RsvpStatus.no, 'ConfirmationNo'),
      (RsvpStatus.half, 'ConfirmationHalf'),
    ];

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((opt) {
          final isSelected = _selectedRsvp == opt.$1;
          return GestureDetector(
            onTap: () => _onRsvpOptionTapped(opt.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.purple.shade700 : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                Statics.getLabel(opt.$2, returnKey: true),
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Confirmed one-line summary shown once a response is saved:
  /// "✓ प्रतिसाद : होय / अर्ध" or "✗ कारण : <reason>" — plus "बदला" to
  /// go back into edit mode (the होय/नाही/अर्ध picker).
  Widget _buildRsvpConfirmed() {
    final bool isNo = _selectedRsvp == RsvpStatus.no;
    final bool isHalf = _selectedRsvp == RsvpStatus.half;
    final IconData icon = isHalf
        ? Icons.timelapse_rounded
        : isNo
            ? Icons.cancel
            : Icons.check_circle;
    final Color color = isHalf
        ? Colors.orange.shade700
        : isNo
            ? Colors.red.shade700
            : Colors.green.shade700;
    final String label = isNo ? '${Statics.getLabel('ReasonLabel') ?? 'कारण'} : ${_reasonController.text}' : '${Statics.getLabel('ResponseLabel') ?? 'प्रतिसाद'} : ${_selectedRsvp?.name ?? ''}';

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _isEditingRsvp = true),
            child: Text(
              Statics.getLabel('change') ?? 'बदला',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Colors.purple.shade700,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // .rsvp-inline — either the confirmed summary + "बदला", or (in edit mode)
  // "तुम्ही येणार का?" + होय/नाही/अर्ध + "कारण" reason field (reason only
  // for नाही). Shown when isOwner == false.
  Widget _buildRsvpSection() {
    final eventItem = widget.eventItem;
    _selectedRsvp ??= _rsvpStatusFromCode(eventItem.pStatus);
    if (_reasonController.text.isEmpty && eventItem.reason != null) {
      _reasonController.text = eventItem.reason!;
    }
    // First build: show the confirmed summary if there's already a saved
    // response, otherwise go straight to the picker.
    _isEditingRsvp ??= _selectedRsvp == null;

    if (_isEditingRsvp == false) {
      return _buildRsvpConfirmed();
    }

    final bool showReason = _selectedRsvp == RsvpStatus.no;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  Statics.getLabel('RsvpQuestion') ?? 'तुम्ही येणार का?',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.black87),
                ),
              ),
              _buildRsvpControl(),
            ],
          ),
          if (showReason) ...[
            SizedBox(height: 10),
            TextField(
              controller: _reasonController,
              enabled: !_isUpdatingRsvp,
              minLines: 1,
              maxLines: 3,
              style: TextStyle(fontSize: 12.5),
              onSubmitted: (_) => _onReasonConfirmed(),
              decoration: InputDecoration(
                isDense: true,
                labelText: Statics.getLabel('ReasonLabel') ?? 'कारण',
                labelStyle: TextStyle(fontSize: 12.5),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                suffixIcon: IconButton(
                  icon: Icon(Icons.check_circle, color: Colors.purple.shade700, size: 20),
                  onPressed: _isUpdatingRsvp ? null : _onReasonConfirmed,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMineBadge(String label) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 2),
      decoration: BoxDecoration(
        color: Colors.purple.shade700,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        Statics.getLabel(label, returnKey: true),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
