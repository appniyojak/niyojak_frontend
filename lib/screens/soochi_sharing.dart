import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widgets/sharing_card.dart';
import '../widgets/legend.dart';
import '../providers/swayamsevak_provider.dart';
import '../providers/bals.dart';
import '../helpers/static_data.dart' as Statics;
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class SoochiSharing extends StatefulWidget {
  static const String routeName = '/soochi-sharing-screen';
  @override
  _SoochiSharingState createState() => _SoochiSharingState();
}

class _SoochiSharingState extends State<SoochiSharing> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Statics.ScreenArguments? args;
  var soochiId;
  var viewType;
  Future<List<dynamic>>? _sharingList;
  List<MenuChoices> choices = [];
  List<String> strEmail = [];
  List<String> strMobile = [];
  TextEditingController _swController = TextEditingController();
  String? _swValue = "";
  TextEditingController _soochiController = TextEditingController();
  String? _soochiValue = "";

  var _isLoading = false;
  var _isFirstCall = true;
  var _canEdit = true;

  bool _isSelectAll = false;

  bool _isfetingData = false;

  void initState() {
    super.initState();
    populateChoice();
    setState(() {
      print("dswnfs");
      _sharingList = _getSharingList();
      //Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstCall == true) {
      args = ModalRoute.of(context)!.settings.arguments as Statics.ScreenArguments;
      soochiId = args!.itemID;
      viewType = args!.viewType;
      _sharingList = _getSharingList();
    }
    _isFirstCall = false;
  }

  @override
  void dispose() {
    super.dispose();
    _swController.dispose();
    _soochiController.dispose();

  }

  void onSaveDetails() {
    setState(() {
      _sharingList = _getSharingList();
      //Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    });
  }

  void populateChoice() {
    setState(() {
      choices = [
        new MenuChoices("SendMail", Icons.mail, Statics.getLabel('SendMail')),
        new MenuChoices("SendSMS", Icons.sms, Statics.getLabel('SendSMS'))
      ];
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
    _sharingList!.then((dataList) {
      for (var data in dataList) {
        if (value == true)
          onCheckCard(data["Email"], data["MobileNumber"]);
        else
          onUnCheckCard(data["Email"], data["MobileNumber"]);
      }
    });
    setState(() {
      _isSelectAll = value;
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

  Future<List<dynamic>> _getSharingList() async {
    print("_getSharingList_getSharingList running");
    setState(() {
      _isfetingData = true;
    });
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      setState(() {
        _isfetingData = false;
      });
      return Statics.getSoochiSharing(soochiId);
    } else {
      setState(() {
        _isfetingData = false;
      });
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  void _getCsv() async {
    setState(() {
      _isfetingData = true;
    });
    List<dynamic> dataList = await _getSharingList();
    List<List<dynamic>> rows = [];
    List<dynamic> header = [];
    header.add("Full Name");
    header.add("Mobile Number");
    header.add("E-mail");
    header.add("Bhaag Name");
    header.add("Shahar Name");
    header.add("Nagar Name");
    header.add("Mandal Name");
    header.add("Graam Name");
    header.add("Vasti Name");
    header.add("Shaakhaa Name");
    header.add("Daayitva GeoUnit Name");
    header.add("Level Name");
    header.add("Daayitva Name");
    rows.add(header);

    for (int i = 0; i < dataList.length; i++) {
      var data = dataList[i];

      List<dynamic> row = [];
      row.add(data["SwayamsevakFullName"].toString());
      row.add(data["MobileNumber"].toString());
      row.add(data["Email"].toString());
      row.add(data["BhaagName"].toString());
      row.add(data["ShaharName"].toString());
      row.add(data["NagarName"].toString());
      row.add(data["MandalName"].toString());
      row.add(data["GraamName"].toString());
      row.add(data["VastiName"].toString());
      row.add(data["ShaakhaaName"].toString());
      row.add(data["DaayitvaGeoUnitName"].toString());
      row.add(data["DaayitvaLevelName"].toString());
      row.add(data["DaayitvaName"].toString());
      rows.add(row);
    }
    if (rows.length > 1) {
      Statics.convertToCsv(rows, "SoochiMembersList" + "_" + DateFormat('ddmmyyyyHHmmss').format(DateTime.now()),context);
    }
    setState(() {
      _isfetingData = false;
    });
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
        await saveSoochiSharing();
      }
    } on Exception catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
      print("error == > $error");
    } catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
      print("error1 == > $error");

    }

    setState(() {
      _isLoading = false;
    });
  }

  saveSoochiSharing() async {

    var inputData = json.encode({
      "SoochiSharingID": 0,
      "PraantID": 1,
      "SoochiID": soochiId,
      "SwayamsevakID": (_swValue == "" || _swValue == null) ? null : _swValue,
      "SourceSoochiID":(_soochiValue == "" || _soochiValue == null) ? null : _soochiValue,
      "CanEdit": _canEdit,
      "ModifiedBy": Statics.userDetails["userID"]
    });

    var data = await Statics.saveSoochiSharing(inputData);
    print("data ==>  $data");

    if (data == "-1") {
      Statics.showToast(Statics.getLabel('SharingExits'));
    }
    setState(() {
      _sharingList = _getSharingList();
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    });
    _swController.text = "";
    _soochiController.text = "";
    _swValue = null;
    _soochiValue = null;
    _canEdit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Statics.getLabel('searchSoochiScreenLabel'),
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
      floatingActionButton: FloatingActionButton(
        mini: true,
        heroTag: "btn3",
        tooltip: Statics.getLabel("ExportToExcel"),
        onPressed: _getCsv,
        child: Icon(Icons.download_sharp),
        backgroundColor: Colors.green,
      ),
      body: ModalProgressHUD(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              width: Statics.getDeviceSize(context).width,
              child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  if (viewType != "ViewSharing")
                    Column(
                      children: [
                        Legend(legendString: 'AddSharing', fontsize: 18),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              width: Statics.getDeviceSize(context).width * 0.75,
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
                                //     controller: this._swController,
                                //     decoration: InputDecoration(
                                //         labelText: Statics.getLabel(
                                //             'searchSwayamsevakLabel'))),
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
                                      )
                                  );
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
                                    title: Text(suggestion["SoochiName"] +
                                        (suggestion["SoochiMemberCount"] == null ? '' : (' (' + suggestion["SoochiMemberCount"].toString() + ')'))),
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
                                //   } else if (_soochiValue == soochiId) {
                                //     return Statics.getLabel(
                                //         'SameSoochiValidationMessage');
                                //   }
                                //   return null;
                                // },
                                // transitionBuilder:
                                //     (context, suggestionsBox, controller) {
                                //   return suggestionsBox;
                                // },
                                onSelected: (suggestion) {
                                  if (suggestion["SoochiID"].toString() == soochiId) {
                                    Statics.showErrorDialog(context, Statics.getLabel("SameSoochiValidationMessage"));
                                    this._soochiController.text = "";
                                    _soochiValue = null;
                                  } else {
                                    this._soochiController.text = suggestion["SoochiName"];
                                    _soochiValue = suggestion["SoochiID"].toString();
                                  }
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
                        CheckboxListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            title: Text(Statics.getLabel('CanEdit'), style: TextStyle(fontSize: 15)),
                            checkColor: Colors.white,
                            activeColor: Colors.purple,
                            value: _canEdit == null ? false : _canEdit,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) {
                              setState(() {
                                _canEdit = value!;
                              });
                            }),
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
                            textColor: Theme.of(context).primaryTextTheme.button!.color,
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
                  Legend(legendString: 'Sharedwith', fontsize: 18),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    title: Text(Statics.getLabel('SelectAll'), style: TextStyle(fontSize: 15)),
                    checkColor: Colors.white,
                    activeColor: Colors.purple,
                    value:  _isSelectAll,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) {
                      setState(() {
                        _isSelectAll = value!;
                        onSelectAll(value);
                      });
                    },
                  ),
                  FutureBuilder<List<dynamic>>(
                    future: _sharingList,
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
                          style: TextStyle(color: Theme.of(context).errorColor),
                        ));
                      }
                      return
                        // dataSnapshot.hasData && dataSnapshot.data!.length > 0
                        //   ?
                      // Text("${dataSnapshot.data}");
                      Column(
                              children: dataSnapshot.data!
                                  .map((sharing) => SoochiSharingCard(sharing, onSaveDetails, onCheckCard, onUnCheckCard, viewType, _isSelectAll))
                                  .toList(),
                            );
                          // : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
                    },
                  ),
                ]),
              ),
            ),
          ),
          inAsyncCall: _isfetingData!),
    );
  }
}
