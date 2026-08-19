import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../helpers/static_data.dart' as Statics;
import '../models/response_model/event_master_list_resp_model.dart';
import '../models/response_model/new_search_swayamsevak_model.dart';
import '../screens/edit_event.dart';
import '../screens/event_members.dart';
import '../screens/event_vrutta.dart';

/// RSVP answer for "तुम्ही येणार का?" — maps to eventItem.pStatus.
/// Adjust the int mapping in [EventCard._rsvpStatusFromCode] if your API uses different codes.
enum RsvpStatus { yes, no, half }

class EventCard extends StatelessWidget {
  final EventMaster eventItem;
  var _search;

  EventCard(this.eventItem, this._search);

  TextEditingController _swController = TextEditingController();
  String? _swValue;

  // RSVP local state (kept as plain fields on this widget instance, same
  // pattern as _swController/_swValue above — updated via StatefulBuilder
  // in _buildRsvpSection so no extra widget class is needed).
  RsvpStatus? _selectedRsvp;
  TextEditingController _reasonController = TextEditingController();

  var _todaysDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

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
                  _search();
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
    final bool isOwner = eventItem.ownerSwayamsevakID.toString() == Statics.userDetails["userID"];

    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 5, right: 5),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // .event-card
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(14, isOwner ? 7 : 14, 0, 12),
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
                  child: isOwner ? _buildStatsRow() : _buildRsvpSection(),
                ),
              ],
            ),
          ),

          // .badge-mine — shown only when the current user is NOT the owner (invited)
          if (!isOwner) _buildMineBadge(),
        ],
      ),
    );
  }

  // ---- UI pieces as plain Widget-returning functions (no widget classes) ----

  Widget _buildPopupMenu(BuildContext context) {
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
        }
      },
      icon: Icon(
        FontAwesomeIcons.ellipsisV,
        color: Colors.grey.shade700,
        size: 16,
      ),
      itemBuilder: (BuildContext context) {
        return [
          if (eventItem.ownerSwayamsevakID.toString() == Statics.userDetails["userID"]) Statics.MenuItem(Statics.getLabel('EditMenu'), FontAwesomeIcons.edit, 'EditMenu'),
          Statics.MenuItem(Statics.getLabel('ViewMenu'), FontAwesomeIcons.eye, 'ViewMenu'),
          Statics.MenuItem(Statics.getLabel('ApekshitList'), Icons.people, (eventItem.ownerSwayamsevakID.toString() == Statics.userDetails["userID"]) ? 'AddApekshitList' : 'ViewApekshitList'),
          Statics.MenuItem(Statics.getLabel('SharingList'), Icons.share, (eventItem.ownerSwayamsevakID.toString() == Statics.userDetails["userID"]) ? 'AddSharingList' : 'ViewSharingList'),
          if (eventItem.ownerSwayamsevakID.toString() == Statics.userDetails["userID"]) Statics.MenuItem(Statics.getLabel('ChangeOwner'), Icons.restore, 'ChangeOwner'),
          Statics.MenuItem(
              Statics.getLabel('Vrutta'),
              FontAwesomeIcons.eye,
              ((eventItem.ownerSwayamsevakID.toString() == Statics.userDetails["userID"]) &&
                      (DateTime.parse(eventItem.fromDateStr!).isBefore(_todaysDate) || DateTime.parse(eventItem.fromDateStr!) == _todaysDate))
                  ? 'EditVrutta'
                  : 'ViewVrutta'),
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

  Widget _buildMiniSegmented(StateSetter setLocalState) {
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
            onTap: () {
              setLocalState(() {
                _selectedRsvp = opt.$1;
              });
              // TODO: wire to your actual RSVP submit/API call here.
            },
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

  // .rsvp-inline — "तुम्ही येणार का?" + होय/नाही/अर्ध + "कारण" reason field
  // (shown when the answer isn't होय). Shown when isOwner == false.
  // Uses the built-in StatefulBuilder for interactivity instead of a
  // separate widget class.
  Widget _buildRsvpSection() {
    _selectedRsvp ??= _rsvpStatusFromCode(eventItem.pStatus);
    if (_reasonController.text.isEmpty && eventItem.reason != null) {
      _reasonController.text = eventItem.reason!;
    }

    return StatefulBuilder(
      builder: (context, setLocalState) {
        final bool showReason = _selectedRsvp == RsvpStatus.no; // || _selectedRsvp == RsvpStatus.half;

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
                  Text(
                    Statics.getLabel('RsvpQuestion') ?? 'तुम्ही येणार का?',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                  Spacer(),
                  _buildMiniSegmented(setLocalState),
                ],
              ),
              if (showReason) ...[
                SizedBox(height: 10),
                TextField(
                  controller: _reasonController,
                  maxLines: 2,
                  style: TextStyle(fontSize: 12.5),
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: Statics.getLabel('ReasonLabel') ?? 'कारण',
                    labelStyle: TextStyle(fontSize: 12.5),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildMineBadge() {
    return Positioned(
      top: -7,
      left: 12,
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 2),
        decoration: BoxDecoration(
          color: Colors.purple.shade700,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          Statics.getLabel('Apekshit') ?? 'माझा कार्यक्रम',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
