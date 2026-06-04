import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/swayamsevak_provider.dart';
import '../widgets/event_member_card.dart';
import '../widgets/legend.dart';
import '../providers/bals.dart';
import '../helpers/static_data.dart' as Statics;
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class EventMembers extends StatefulWidget {
  static const String routeName = '/event-members-screen';

  @override
  _EventMembersState createState() => _EventMembersState();
}

class _EventMembersState extends State<EventMembers> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Statics.ScreenArguments? args;
  var eventID;
  var viewType;
  bool isSharing = false;
  Future<List<dynamic>>? _memberList;
  List<MenuChoices> choices = [];
  List<String> strEmail = [];
  List<String> strMobile = [];

  bool _isSelectAll = false;

  TextEditingController _swController = TextEditingController();
  String? _swValue = "";

  TextEditingController _soochiController = TextEditingController();
  String? _soochiValue = "";

  var _isLoading = false;
  var _isFirstCall = true;

  @override
  void initState() {
    super.initState();
    populateChoice();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstCall == true) {
      args = ModalRoute.of(context)!.settings.arguments as Statics.ScreenArguments;
      eventID = args!.itemID;
      viewType = args!.viewType;
      if (viewType == "AddApekshitList" || viewType == "ViewApekshitList")
        isSharing = false;
      else
        isSharing = true;

      _memberList = _getMembersList();
    }
    _isFirstCall = false;
  }

  @override
  void dispose() {
    super.dispose();
    _swController.dispose();
    _soochiController.dispose();
  }

  void populateChoice() {
    setState(() {
      choices = [new MenuChoices("SendMail", Icons.mail, Statics.getLabel('SendMail')), new MenuChoices("SendSMS", Icons.sms, Statics.getLabel('SendSMS'))];
    });
  }

  void onSaveDetails() {
    setState(() {
      _memberList = _getMembersList();
    });
  }

  void onCheckCard(var emailID, var mobileNum) {
    if (!strEmail.contains(emailID)) {
      strEmail.add(emailID);
    }
    if (!strMobile.contains(mobileNum)) {
      strMobile.add(mobileNum);
    }
  }

  void onUnCheckCard(var emailID, var mobileNum) {
    if (strEmail.contains(emailID)) {
      strEmail.remove(emailID);
    }
    if (strMobile.contains(mobileNum)) {
      strMobile.remove(mobileNum);
    }
  }

  void onSelectAll(value) {
    _memberList!.then((dataList) {
      for (var data in dataList) {
        if (value == true)
          onCheckCard(data["Email"], data["MobileNumber"]);
        else
          onUnCheckCard(data["Email"], data["MobileNumber"]);
      }
    });
    setState(() {
      _isSelectAll = value!;
    });
  }

  void onMenuSelected(MenuChoices choice) async {
    if (choice.menuType == "SendMail") {
      if (strEmail.length == 0) {
        Statics.showToast("Please select atleast one Member");
        return;
      }
      UrlLauncher.launch("mailto:" + strEmail.join(','));
    } else if (choice.menuType == "SendSMS") {
      if (strMobile.length == 0) {
        Statics.showToast("Please select atleast one Member");
        return;
      }
      UrlLauncher.launch("sms:" + strMobile.join(','));
    }
  }

  Future<List<dynamic>> _getMembersList() async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      return Statics.getEventMembers(eventID, null, isSharing == true ? "Sharing" : "Apekshit");
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  Future<List<dynamic>> populateSwayamSevak(String pattern) async {
    bool isConnected = await Statics.isInternetConnected();

    if (pattern.length < 4) return [];
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
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  Future<List<dynamic>> populateSoochi(String pattern) async {
    bool isConnected = await Statics.isInternetConnected();

    if (pattern.length < 4) return [];
    if (isConnected) {
      return Statics.getSoochiList(pattern, true, true);
    } else {
      return [];
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        await saveEventMembers();
      }
    } on Exception catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    } catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    }

    setState(() {
      _isLoading = false;
    });
  }

  saveEventMembers() async {
    var inputData = json.encode({
      "PraantID": 1,
      "EventID": int.parse(eventID),
      "SwayamsevakID": (_swValue == "") ? null : _swValue,
      "SoochiID": (_soochiValue == "") ? null : _soochiValue,
      "ApekshitOrSharing": isSharing == true ? "Sharing" : "Apekshit",
      "ModifiedBy": Statics.userDetails["userID"]
    });

    var data = await Statics.saveEventMembers(inputData);
    if (data == "-1") {
      Statics.showToast(Statics.getLabel('MemberExits'));
    }
    setState(() {
      _memberList = _getMembersList();
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    });
    _swController.text = "";
    _swValue = null;
    _soochiController.text = "";
    _soochiValue = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (isSharing ? Statics.getLabel('SharingList') : Statics.getLabel('ApekshitList')),
          style: TextStyle(fontSize: 24),
        ),
        actions: <Widget>[
          PopupMenuButton<MenuChoices>(
            onSelected: onMenuSelected,
            icon: Icon(FontAwesomeIcons.ellipsisV),
            itemBuilder: (BuildContext context) {
              return choices.map((MenuChoices choice) {
                return PopupMenuItem<MenuChoices>(
                  value: choice,
                  child: ListTile(leading: Icon(choice.icon), title: Text(choice.menuText!)),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          width: Statics.getDeviceSize(context).width,
          child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              if (viewType != "ViewApekshitList" && viewType != "ViewSharingList")
                Column(
                  children: [
                    Legend(legendString: 'AddMembers', fontsize: 18),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          width: Statics.getDeviceSize(context).width * 0.75,
                          child: TypeAheadField(
                            controller: _soochiController,
                            builder: (context, controller, focusNode) {
                              return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: UnderlineInputBorder(),
                                    labelText: Statics.getLabel('SoochiName'),
                                  ));
                            },
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
                            // validator: (value) {
                            //   if ((value.isEmpty ||
                            //           _swValue == null ||
                            //           _swValue.isEmpty) &&
                            //       (_soochiValue == null ||
                            //           _soochiValue.isEmpty)) {
                            //     return Statics.getLabel(
                            //         'MemberValidationMessage');
                            //   }
                            //   return null;
                            // },
                            // transitionBuilder:
                            //     (context, suggestionsBox, controller) {
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
                              setState(() {
                                this._swController.text = "";
                                _swValue = "";
                              });
                            },
                            icon: Icon(Icons.cancel)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          width: Statics.getDeviceSize(context).width * 0.75,
                          child: TypeAheadField(
                            controller: _soochiController,
                            builder: (context, controller, focusNode) {
                              return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: UnderlineInputBorder(),
                                    labelText: Statics.getLabel('searchSoochiScreenLabel'),
                                  ));
                            },
                            // textFieldConfiguration: TextFieldConfiguration(
                            //     controller: this._soochiController,
                            //     decoration: InputDecoration(
                            //         labelText: Statics.getLabel(
                            //             'searchSoochiScreenLabel'))),
                            suggestionsCallback: (pattern) {
                              this._soochiValue = "";
                              return populateSoochi(pattern);
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion["SoochiName"] + (suggestion["SoochiMemberCount"] == null ? '' : (' (' + suggestion["SoochiMemberCount"].toString() + ')'))),
                                subtitle: Wrap(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(suggestion["OwnerSwayamsevakFullName"]),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(suggestion["Remark"]),
                                  ],
                                ),
                              );
                            },
                            // validator: (value) {
                            //   if ((value.isEmpty ||
                            //           _soochiValue == null ||
                            //           _soochiValue.isEmpty) &&
                            //       (_swValue == null || _swValue.isEmpty)) {
                            //     return Statics.getLabel(
                            //         'SoochiNameValidationMessage');
                            //   }
                            //   return null;
                            // },
                            // transitionBuilder:
                            //     (context, suggestionsBox, controller) {
                            //   return suggestionsBox;
                            // },
                            onSelected: (suggestion) {
                              this._soochiController.text = suggestion["SoochiName"];
                              _soochiValue = suggestion["SoochiID"].toString();
                            },
                          ),
                        ),
                        IconButton(
                            color: Colors.purple,
                            onPressed: () {
                              setState(() {
                                this._soochiController.text = "";
                                _soochiValue = "";
                              });
                            },
                            icon: Icon(Icons.cancel)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                        onPressed: _submit,
                        child: Text(
                          Statics.getLabel('Submit'),
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              Legend(legendString: isSharing == true ? 'SharingList' : 'ApekshitList', fontsize: 18),
              CheckboxListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: Text(Statics.getLabel('SelectAll'), style: TextStyle(fontSize: 15)),
                checkColor: Colors.white,
                activeColor: Colors.purple,
                value: _isSelectAll,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    _isSelectAll = value!;
                    onSelectAll(value);
                  });
                },
              ),
              FutureBuilder<List<dynamic>>(
                future: _memberList,
                builder: (ctx, dataSnapshot) {
                  //print(dataSnapshot.connectionState.toString());
                  //print(dataSnapshot.hasData.toString());
                  //print(_isSearching.toString());
                  if (dataSnapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (dataSnapshot.hasError) {
                    return Center(
                        child: Text(
                      'Server Error, Please Try Again Later',
                      style: TextStyle(color: Colors.red),
                    ));
                  }
                  return dataSnapshot.hasData && dataSnapshot.data!.length > 0
                      ? Column(
                          children: dataSnapshot.data!.map((members) => EventMembersCard(members, onSaveDetails, onCheckCard, onUnCheckCard, viewType, isSharing, _isSelectAll)).toList(),
                        )
                      : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
