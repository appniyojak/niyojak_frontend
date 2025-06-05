import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../screens/event_vrutta.dart';
import '../providers/swayamsevak_provider.dart';
import '../screens/edit_event.dart';
import '../screens/event_members.dart';

import '../helpers/static_data.dart' as Statics;

class EventCard extends StatelessWidget {
  final eventItem;
  var _search;
  EventCard(this.eventItem, this._search);
  TextEditingController _swController = TextEditingController();
  String? _swValue;

  var _todaysDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

  Future<List<dynamic>?> populateSwayamSevak(String pattern) async {
    bool isConnected = await Statics.isInternetConnected();

    if (pattern.length < 4) return null;
    if (isConnected) {
      var inputData = json.encode({
        "AppUserID": Statics.userDetails["userID"],
        "SearchCriteria": _swController.text.isEmpty ? null : _swController.text,
        "BloodGroupID": null,
        "MotherTongueID": null,
        "ShaakhaaExperience": null,
        "GeoUnitID": null,
        "IsPratidnyit": null,
        "PratidnyaYear": null,
        "IsGanaveshComplete": null,
        "NoCap": null,
        "NoShirt": null,
        "NoPant": null,
        "NoBelt": null,
        "NoShoes": null,
        "NoSocks": null,
        "NoDanda": null,
        "VehicleType": null,
        "HasDriver": null,
        "SanghaShikshanCode": null,
        "SanghaShikshanYearFrom": null,
        "SanghaShikshanYearTo": null,
        "MukhyaShaaririkVishayCodes": null,
        "AnyaShaaririkVishayCodes": null,
        "PrathamVaadyaCodes": null,
        "DwitiyaVaadyaCodes": null,
        "TrutiyaVaadyaCodes": null,
        "AnyaVaadyaCodes": null,
        "OccupationCategoryID": null,
        "EducationInstitutionName": null,
        "EducationStandardID": null,
        "EducationProgramID": null,
        "EducationProgramName": null,
        "GovernmentDepartment": null,
        "Designation": null,
        "OfficeLocation": null,
        "WeeklyOffDayIDs": null,
        "OrganizationName": null,
        "IndustryVertical": null,
        "OrganizationAtRetirement": null,
        "DesignationAtRetirement": null,
        "DepartmentAtRetirement": null,
        "DaayitvaForID": null,
        "DaayitvaID": null,
        "DaayitvaLevelID": null,
        "DaayitvaGeoUnitID": null,
        "SortOrder": "Name",
      });

      return SwayamsevakProvider().getSwayamsevaks(inputData);
    } else {
      Statics.showToast(Statics.getLabel('internetNotConnected'));
      return null;
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
                          )
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
                        title: Text(suggestion["FullName"]),
                        subtitle: Wrap(
                          children: [
                            Text(
                              suggestion["DaayitvaGeoUnitName"] + "-",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              suggestion["LevelName"] + "-",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              suggestion["DaayitvaName"],
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
                      this._swController.text = suggestion["FullName"];
                      _swValue = suggestion["SwayamsevakID"].toString();
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 5,
      child: ListTile(
        title: Text(eventItem["EventName"]),
        trailing: Container(
          height: 50,
          width: 0.1 * Statics.getDeviceSize(context).width,
          child: Stack(
            children: [
              Positioned(
                right: 0.0,
                top: 0.0,
                child: PopupMenuButton(
                  onSelected: (value) {
                    if (value == "EditMenu" || value == "ViewMenu") {
                      Navigator.of(context)
                          .pushNamed(EditEvent.routeName, arguments: Statics.ScreenArguments(eventItem["EventID"] ,value));
                    } else if (value == "AddApekshitList" || value == "ViewApekshitList" || value == "AddSharingList" || value == "ViewSharingList") {
                      Navigator.of(context)
                          .pushNamed(EventMembers.routeName, arguments: Statics.ScreenArguments(eventItem["EventID"], value));
                    } else if (value == "ChangeOwner") {
                      _changeEventOwner(context, eventItem["EventID"]);
                    } else if (value == "EditVrutta" || value == "ViewVrutta") {
                      print("value  == $value");
                      Navigator.of(context)
                          .pushNamed(EventVrutta.routeName, arguments: Statics.ScreenArguments(eventItem["EventID"], value));
                    }
                  },
                  icon: Icon(
                    FontAwesomeIcons.ellipsisV,
                    color: Colors.grey,
                  ),
                  itemBuilder: (BuildContext context) {
                    return [
                      if (eventItem["OwnerSwayamsevakID"].toString() == Statics.userDetails["userID"])
                        Statics.MenuItem(Statics.getLabel('EditMenu'), FontAwesomeIcons.edit, 'EditMenu'),
                      Statics.MenuItem(Statics.getLabel('ViewMenu'), FontAwesomeIcons.eye, 'ViewMenu'),
                      Statics.MenuItem(Statics.getLabel('ApekshitList'), Icons.people,
                          (eventItem["OwnerSwayamsevakID"].toString() == Statics.userDetails["userID"]) ? 'AddApekshitList' : 'ViewApekshitList'),
                      Statics.MenuItem(Statics.getLabel('SharingList'), Icons.share,
                          (eventItem["OwnerSwayamsevakID"].toString() == Statics.userDetails["userID"]) ? 'AddSharingList' : 'ViewSharingList'),
                      if (eventItem["OwnerSwayamsevakID"].toString() == Statics.userDetails["userID"])
                        Statics.MenuItem(Statics.getLabel('ChangeOwner'), Icons.restore, 'ChangeOwner'),
                      Statics.MenuItem(
                          Statics.getLabel('Vrutta'),
                          FontAwesomeIcons.eye,
                          ((eventItem["OwnerSwayamsevakID"].toString() == Statics.userDetails["userID"]) &&
                                  (DateTime.parse(eventItem["FromDateStr"]).isBefore(_todaysDate) ||
                                      DateTime.parse(eventItem["FromDateStr"]) == _todaysDate))
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
                ),
              ),
            ],
          ),
        ),
        subtitle: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(eventItem["EventTypeCode"]),
                SizedBox(
                  width: 5,
                ),
                Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(eventItem["FromDateStr"])) +
                    "  " +
                    eventItem["FromTimeStr"] +
                    " - " +
                    eventItem["ToTimeStr"]),
                SizedBox(
                  height: 5,
                ),
                Text(eventItem["GeoUnitName"]),
              ],
            )),
      ),
    );
  }
}
