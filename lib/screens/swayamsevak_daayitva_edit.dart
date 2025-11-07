import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../providers/swayamsevak_provider.dart';
import '../widgets/legend.dart';
import '../providers/bals.dart';

import '../helpers/static_data.dart' as Statics;

class SwayamSevakDaayitvaEdit extends StatefulWidget {
  static const routeName = '/daayitva-detail-screen';
  var swId;
  var viewType;
  var onSaveSwDetails;
  var daayitvaForID;
  var daayitvaForCode;
  var dataID;

  SwayamSevakDaayitvaEdit({Key? key, this.swId, this.onSaveSwDetails, this.viewType, this.daayitvaForID, this.daayitvaForCode, this.dataID}) : super(key: key);

  @override
  _SwayamSevakDaayitvaEditState createState() => _SwayamSevakDaayitvaEditState();
}

class _SwayamSevakDaayitvaEditState extends State<SwayamSevakDaayitvaEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  bool _isFetchingData = false;
  bool _isCurrent = false;

  List<StaticMasterBAL>? _daayitvaFor;
  List<LevelMasterBAL>? _level;
  List<AayaamMasterBAL>? _aayam;
  List<GatividhiMasterBAL>? _gatividhi;
  String? _daayitvaValue = "";
  String _selectedDaayitvaID = "";
  String? _lblValue = "";

  List<GeoUnitMasterBAL>? _geoUnits;
  TextEditingController _typeAheadController = TextEditingController();

  SwayamsevakDaayitvaBAL? swDaayitva;

  StaticMasterBAL? _daayitvaForValue;
  String? _levelValue = "";
  String? _aayaamValue = "";
  String? _gatividhiValue = "";
  String? _geoUnitsValue = "";

  var _startYearCtrl = TextEditingController();
  var _endYearCtrl = TextEditingController();
  TextEditingController _daayitvaController = TextEditingController();

  List<dynamic>? _sanghaPreritSanstha;
  String? _preritSansthaValue = "";
  var _preritDesgCtrl = TextEditingController();
  var _preritRemarkCtrl = TextEditingController();
  var _othOrgNameCtrl = TextEditingController();
  var _othDesgCtrl = TextEditingController();
  var _othRemarksCtrl = TextEditingController();

  List<AreaOfOperationsBAL> _areaOfOperations = [];

  @override
  void initState() {
    super.initState();
    populateDropdown();
    int dataID = int.parse(widget.dataID);
    print("dataID :::---- $dataID");
    if (dataID > 0) {
      getSwDetails(widget.swId, widget.daayitvaForID, widget.daayitvaForCode, widget.dataID);
    } else {
      if (!mounted) return;
      setState(() {
        swDaayitva = new SwayamsevakDaayitvaBAL(int.parse(widget.swId), 1, null, null, "", null, null, null, null, null, null, null, "", "", "", "", "", false, "");
      });
      populateAreaDetails();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _typeAheadController.dispose();
    _startYearCtrl.dispose();
    _endYearCtrl.dispose();
  }

  populateDropdown() async {
    var data = await Statics.getStaticLDB("DaayitvaFor");
    var data2 = await Statics.getLevelLDB();
    var data3 = await Statics.getAayamLDB();
    var data4 = await Statics.getGatividhiLDB();
    var data5 = await Statics.getSanghaPreritSanstha("1", null, null);
    //populateDaayitva(_daayitvaValue);

    if (!mounted) return;
    setState(() {
      _daayitvaFor = data;
      _level = data2;
      _aayam = data3;
      _gatividhi = data4;
      _sanghaPreritSanstha = data5;
    });
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
        await saveSwDetails();
        // await getSwDetails(widget.swId);
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

  void getSwDetails(var swayamsevakID, var daayitvaForID, var daayitvaForCode, var dataID) async {
    setState(() {
      _isFetchingData = true;
    });
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      print("$swayamsevakID :--- swayamsevakID, $daayitvaForID :- daayitvaForID , $daayitvaForCode :-- daayitvaForCode, $dataID :-- dataID");
      var data = await SwayamsevakProvider().getSwayamSevakDaayitva(swayamsevakID, daayitvaForID, daayitvaForCode, dataID);
      var data1 = await Statics.getStaticLDB("DaayitvaFor");
      await populateDropdown();

      if (data != null) {
        var data2 = await Statics.getDaayitvaLDB("", "", data.daayitvaID.toString());
        if (!mounted) return;
        setState(() {
          swDaayitva = data;
          // _daayitvaFor = data1;
          // if (_daayitvaFor != null) {
          _daayitvaForValue = widget.daayitvaForID != null
              ? _daayitvaFor!.indexWhere((p) => p.staticID.toString() == widget.daayitvaForID) > -1
                  ? _daayitvaFor![_daayitvaFor!.indexWhere((p) => p.staticID.toString() == widget.daayitvaForID)]
                  : null
              : null;
          //}
          _daayitvaValue = swDaayitva!.daayitvaID == null ? null : swDaayitva!.daayitvaID.toString();
          _levelValue = swDaayitva!.levelID == null ? null : swDaayitva!.levelID.toString();
          if (_levelValue != null) populateGeoUnits(_levelValue!);
          _geoUnitsValue = swDaayitva!.daayitvaGeoUnitID == null ? null : swDaayitva!.daayitvaGeoUnitID.toString();
          _daayitvaController.text = (swDaayitva!.daayitvaName == null || swDaayitva!.daayitvaName == ""
              ? (data2 != null && data2.length > 0)
                  ? data2[0].daayitvaName
                  : ""
              : swDaayitva!.daayitvaName)!;
          _startYearCtrl.text = swDaayitva!.startYear == null ? "" : swDaayitva!.startYear.toString();

          _endYearCtrl.text = swDaayitva!.endYear == null ? "" : swDaayitva!.endYear.toString();

          _preritSansthaValue = swDaayitva!.sanghaPreritSansthaaID.toString();

          _gatividhiValue = swDaayitva!.gatividhiID == null ? null : swDaayitva!.gatividhiID.toString();
          _aayaamValue = swDaayitva!.aayaamID == null ? null : swDaayitva!.aayaamID.toString();

          _preritDesgCtrl.text = swDaayitva!.sanghaPreritSansthaaDesignation ?? "";

          _preritRemarkCtrl.text = swDaayitva!.sanghaPreritSansthaaRemark == null ? "" : swDaayitva!.sanghaPreritSansthaaRemark.toString();

          _othOrgNameCtrl.text = swDaayitva!.otherSocialOrganizationName == null ? "" : swDaayitva!.otherSocialOrganizationName.toString();

          _othDesgCtrl.text = swDaayitva!.otherSocialOrganizationDesignation == null ? "" : swDaayitva!.otherSocialOrganizationDesignation.toString();

          _othRemarksCtrl.text = swDaayitva!.otherSocialOrganizationRemark == null ? "" : swDaayitva!.otherSocialOrganizationRemark.toString();

          _isCurrent = swDaayitva!.isCurrent == true ? true : false;
        });
        await populateAreaDetails();
      }
      setState(() {
        _isFetchingData = false;
      });
    }
  }

  populateAreaDetails() async {
    var aoo = await Statics.getStaticLDB("SocialOrganizationAreaOfOperation");
    _areaOfOperations = [];
    var aooArr = swDaayitva == null ? [] : swDaayitva!.areaOfOperationIDs!.split(',');
    for (var data in aoo) {
      _areaOfOperations.add(new AreaOfOperationsBAL(data.staticID, data.code, data.codeForDisplay, (aooArr.contains(data.staticID.toString()) ? true : false)));
    }
  }

  saveSwDetails() async {
    var areaOfOperationIDs = '';

    for (var data in _areaOfOperations) {
      if (data.isSelected!) areaOfOperationIDs = areaOfOperationIDs + data.staticID.toString() + ",";
    }

    if (areaOfOperationIDs.trim() != '') areaOfOperationIDs = areaOfOperationIDs.substring(0, areaOfOperationIDs.length - 1);

    var inputData = json.encode({
      "SwayamsevakID": int.parse(widget.swId),
      "DaayitvaForID": swDaayitva!.daayitvaFor,
      "LevelID": swDaayitva!.levelID,
      "GeoUnitID": swDaayitva!.daayitvaGeoUnitID,
      "DaayitvaID":
          //       _daayitvaForValue != null && _daayitvaForValue!.code != "SanghaPreritSansthaa" && _daayitvaForValue!.code != "OtherSocialOrganization"
          //           ?
          _selectedDaayitvaID == "" ? swDaayitva!.daayitvaID : _selectedDaayitvaID,
      "StartYear": swDaayitva!.startYear,
      "EndYear": swDaayitva!.endYear,
      "GatividhiID": _daayitvaForValue!.code == "Gatividhi" ? swDaayitva!.gatividhiID : null,
      "AayaamID": _daayitvaForValue!.code == "Aayaam" ? swDaayitva!.aayaamID : null,
      "SanghaPreritSansthaaID": _daayitvaForValue!.code == "SanghaPreritSansthaa" ? swDaayitva!.sanghaPreritSansthaaID : null,
      "SocialOrganizationName": _daayitvaForValue!.code == "OtherSocialOrganization" ? swDaayitva!.otherSocialOrganizationName : null,
      "OtherDesignation": _daayitvaForValue!.code == "SanghaPreritSansthaa"
          ? swDaayitva!.sanghaPreritSansthaaDesignation
          : _daayitvaForValue!.code == "OtherSocialOrganization"
              ? swDaayitva!.otherSocialOrganizationDesignation
              : null,
      "OtherRemark": _daayitvaForValue!.code == "SanghaPreritSansthaa"
          ? swDaayitva!.sanghaPreritSansthaaRemark
          : _daayitvaForValue!.code == "OtherSocialOrganization"
              ? swDaayitva!.otherSocialOrganizationRemark
              : null,
      "IsCurrent": _isCurrent,
      "AreaOfOperationIDs": areaOfOperationIDs,
      "ModifiedBy": Statics.userDetails["userID"].toString()
    });
    print(inputData);
// print("swDaayitva?.levelID :--- ${swDaayitva?.levelID}");
// print("swDaayitva?.aayaamID :--- ${swDaayitva?.aayaamID}");
// print("swDaayitva?.areaOfOperationIDs :--- ${swDaayitva?.areaOfOperationIDs}");
// print("swDaayitva?.daayitvaFor :--- ${swDaayitva?.daayitvaFor}");
// print("swDaayitva?.daayitvaGeoUnitID :--- ${swDaayitva?.daayitvaGeoUnitID}");
// print("swDaayitva?.daayitvaID :--- ${swDaayitva?.daayitvaID}");
// print("swDaayitva?.daayitvaName :--- ${swDaayitva?.daayitvaName}");
// print("swDaayitva?.gatividhiID :--- ${swDaayitva?.gatividhiID}");
// print("swDaayitva?.isCurrent :--- ${swDaayitva?.isCurrent}");
// print("swDaayitva?.otherSocialOrganizationDesignation :--- ${swDaayitva?.otherSocialOrganizationDesignation}");
// print("swDaayitva?.otherSocialOrganizationRemark :--- ${swDaayitva?.otherSocialOrganizationRemark}");
// print("swDaayitva?.praantID :--- ${swDaayitva?.praantID}");
// print("swDaayitva?.sanghaPreritSansthaaDesignation :--- ${swDaayitva?.sanghaPreritSansthaaDesignation}");
// print("swDaayitva?.sanghaPreritSansthaaRemark :--- ${swDaayitva?.sanghaPreritSansthaaRemark}");
// print("swDaayitva?.sanghaPreritSansthaaID :--- ${swDaayitva?.sanghaPreritSansthaaID}");
// print("swDaayitva?.endYear :--- ${swDaayitva?.endYear}");
// print("swDaayitva?.startYear :--- ${swDaayitva?.startYear}");
// print("swDaayitva?.swayamsevakID :--- ${swDaayitva?.swayamsevakID}");
    var data = await SwayamsevakProvider().saveSwayamsevakDaayitvaForApp(inputData);
    if (!mounted) return;
    setState(() {
      widget.swId = data;
      widget.onSaveSwDetails(widget.swId);
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    });
  }

  void populateGeoUnits(String levelID) async {
    var data4;
    if (levelID == "") {
      data4 = await Statics.getGeoUnitsByLevel(Statics.levels['MahaanagarLevelID']);
    } else
      data4 = await Statics.getGeoUnitsByLevel(levelID);
    if (!mounted) return;
    setState(() {
      _geoUnits = data4;
    });
  }

  Future<List<DaayitvaMasterBAL>> populateDaayitva(String daayitvaId, String pattern) async {
    var data3 = await Statics.getDaayitvaLDB(daayitvaId, pattern, "");
    return data3;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            width: Statics.getDeviceSize(context).width,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AbsorbPointer(
                    absorbing: widget.viewType == "ViewMenu" ? true : false,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              if (_daayitvaFor != null)
                                DropdownButtonFormField<StaticMasterBAL>(
                                  decoration: InputDecoration(labelText: Statics.getLabel('SelectDaayitvaFor')),
                                  isExpanded: true,
                                  value: _daayitvaForValue == null ? null : _daayitvaForValue,
                                  items: _daayitvaFor!.map((bg) => DropdownMenuItem(value: bg, child: Text(bg.codeForDisplay!))).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _daayitvaForValue = value;
                                    });
                                    print(_daayitvaForValue!.ViewOnly);
                                  },
                                  validator: (value) {
                                    if (value == null) return (Statics.getLabel('DaayitvaForValidationMessage'));
                                    return null;
                                  },
                                  onSaved: (value) {
                                    swDaayitva!.daayitvaFor = value!.staticID;
                                    print("field SelectDaayitvaFor :--${value.staticID}");
                                  },
                                ),
                              if (_daayitvaForValue != null)
                                if (_daayitvaForValue!.code == "Aayaam")
                                  Column(
                                    children: [
                                      SizedBox(height: 10),
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('SelectAayaam')),
                                        isExpanded: true,
                                        value: _aayaamValue == "" ? null : _aayaamValue,
                                        items: _aayam!.map((bg) => DropdownMenuItem(value: bg.aayaamID.toString(), child: Text(bg.aayaamName!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _aayaamValue = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) return (Statics.getLabel('AayaamVaidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty) {
                                            swDaayitva!.aayaamID = int.parse(value);
                                            print("field SelectAayaam :--${value}");
                                          } else {
                                            swDaayitva!.aayaamID = null;
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                else if (_daayitvaForValue!.code == "Gatividhi")
                                  Column(
                                    children: [
                                      SizedBox(height: 10),
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('SelectGatividhi')),
                                        isExpanded: true,
                                        value: _gatividhiValue == "" ? null : _gatividhiValue,
                                        items: _gatividhi!.map((bg) => DropdownMenuItem(value: bg.gatividhiID.toString(), child: Text(bg.gatividhiName!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _gatividhiValue = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) return (Statics.getLabel('GaitividhiVaidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty) {
                                            swDaayitva!.gatividhiID = int.parse(value);
                                            print("field SelectGatividhi :--${value}");
                                          } else {
                                            swDaayitva!.gatividhiID = null;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                              if (_daayitvaForValue != null)
                                if (_daayitvaForValue!.code != "SanghaPreritSansthaa" && _daayitvaForValue!.code != "OtherSocialOrganization")
                                  Column(
                                    children: [
                                      SizedBox(height: 10),
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('SelectLevel')),
                                        isExpanded: true,
                                        value: _levelValue == "" ? null : _levelValue,
                                        items: _level!
                                            .map((bg) => DropdownMenuItem(
                                                value: bg.levelID.toString(),
                                                child: Text(bg.levelName == "Bhaag"
                                                    ? "Bhaag / Jilha"
                                                    : bg.levelName == "Nagar"
                                                        ? "Nagar / Taluka"
                                                        : bg.levelName!)))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _levelValue = value;
                                            populateGeoUnits(value!);
                                            _lblValue = value == "1" ? "Shaakhaa/Saaptaahik/Maasik/Mandali" : "SelectLevelName";
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) return (Statics.getLabel('LevelValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty) {
                                            swDaayitva!.levelID = int.parse(value);
                                            print("field SelectLevel :--${value}");
                                          } else {
                                            swDaayitva!.levelID = null;
                                          }
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      if (_geoUnits != null)
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(labelText: Statics.getLabel(_lblValue == "" ? 'SelectLevelName' : _lblValue!)),
                                          isExpanded: true,
                                          value: _geoUnitsValue == ""
                                              ? null
                                              : _geoUnits != null
                                                  ? _geoUnits!.indexWhere((p) => p.geoUnitID.toString() == _geoUnitsValue) > -1
                                                      ? _geoUnitsValue
                                                      : null
                                                  : null,
                                          items: _geoUnits!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _geoUnitsValue = value;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null || value.isEmpty) return (Statics.getLabel('GeoUnitValidationMessage'));
                                            return null;
                                          },
                                          onSaved: (value) {
                                            if (value != null && value.isNotEmpty) {
                                              swDaayitva!.daayitvaGeoUnitID = int.parse(value);
                                              print("field SelectLevelName :--${value}");
                                            } else
                                              swDaayitva!.daayitvaGeoUnitID = null;
                                          },
                                        ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                              if (_daayitvaForValue != null)
                                if (_daayitvaForValue!.code != "SanghaPreritSansthaa" && _daayitvaForValue!.code != "OtherSocialOrganization")
                                  // Row(
                                  //   children: [
                                  //     Container(
                                  //       width: Statics.getDeviceSize(context).width * 0.63,
                                  //       child: TypeAheadField<DaayitvaMasterBAL>(
                                  //         controller: _daayitvaController,
                                  //         builder: (context, controller, focusNode) {
                                  //           return TextField(
                                  //               controller: _daayitvaController,
                                  //               focusNode: focusNode,
                                  //               decoration: InputDecoration(
                                  //                 isDense: true,
                                  //                 border: UnderlineInputBorder(),
                                  //                 labelText: Statics.getLabel('SelectDaayitva'),
                                  //               )
                                  //           );
                                  //         },
                                  //         // textFieldConfiguration:
                                  //         //     TextFieldConfiguration(
                                  //         //         controller:
                                  //         //             this._daayitvaController,
                                  //         //         decoration: InputDecoration(
                                  //         //             labelText: Statics.getLabel(
                                  //         //                 'SelectDaayitva'))),
                                  //         suggestionsCallback: (pattern) {
                                  //           this._daayitvaValue = "";
                                  //           return populateDaayitva(
                                  //               _daayitvaForValue == null ||
                                  //                       _daayitvaForValue!.code == "SanghaPreritSansthaa" ||
                                  //                       _daayitvaForValue!.code == "OtherSocialOrganization"
                                  //                   ? ""
                                  //                   : _daayitvaForValue!.staticID.toString(),
                                  //               pattern);
                                  //         },
                                  //         itemBuilder: (context, suggestion) {
                                  //           return ListTile(
                                  //             title: Text(suggestion.daayitvaName!),
                                  //           );
                                  //         },
                                  //         // validator: (value) {
                                  //         //   if ((value.isEmpty ||
                                  //         //       _daayitvaValue == null ||
                                  //         //       _daayitvaValue.isEmpty)) {
                                  //         //     return Statics.getLabel(
                                  //         //         'DaayitvaValidationMessage');
                                  //         //   }
                                  //         //   return null;
                                  //         // },
                                  //         // transitionBuilder: (context,
                                  //         //     suggestionsBox, controller) {
                                  //         //   return suggestionsBox;
                                  //         // },
                                  //         onSelected: (suggestion) {
                                  //           this._daayitvaController.text = suggestion.daayitvaName!;
                                  //           _daayitvaValue = suggestion.daayitvaID.toString();
                                  //           print("field SelectDaayitva name :--${suggestion.daayitvaName}");
                                  //           print("field SelectDaayitva ID :--${_daayitvaValue}");
                                  //
                                  //         },
                                  //         // onSaved: (value) {
                                  //         //   if (_daayitvaValue != null &&
                                  //         //       _daayitvaValue.isNotEmpty)
                                  //         //     swDaayitva!.daayitvaID =
                                  //         //         int.parse(_daayitvaValue);
                                  //         //   else
                                  //         //     swDaayitva!.daayitvaID = null;
                                  //         // },
                                  //       ),
                                  //     ),
                                  //     IconButton(
                                  //         color: Colors.purple,
                                  //         onPressed: () {
                                  //           setState(() {
                                  //             this._daayitvaController.text = "";
                                  //             _daayitvaValue = "";
                                  //           });
                                  //         },
                                  //         icon: Icon(Icons.cancel)),
                                  //   ],
                                  // ),
                                  // Row(
                                  //   children: [
                                  //     Container(
                                  //       width: Statics.getDeviceSize(context).width * 0.63,
                                  //       child: TypeAheadField<DaayitvaMasterBAL>(
                                  //         controller: _daayitvaController,
                                  //         builder: (context, controller, focusNode) {
                                  //           return TextField(
                                  //             controller: _daayitvaController,
                                  //             focusNode: focusNode,
                                  //             decoration: InputDecoration(
                                  //               isDense: true,
                                  //               border: UnderlineInputBorder(),
                                  //               labelText: Statics.getLabel('SelectDaayitva'),
                                  //             ),
                                  //           );
                                  //         },
                                  //         suggestionsCallback: (pattern) {
                                  //           _daayitvaValue = "";
                                  //           return populateDaayitva(
                                  //               _daayitvaForValue == null ||
                                  //                   _daayitvaForValue!.code == "SanghaPreritSansthaa" ||
                                  //                   _daayitvaForValue!.code == "OtherSocialOrganization"
                                  //                   ? ""
                                  //                   : _daayitvaForValue!.staticID.toString(),
                                  //               pattern
                                  //           );
                                  //         },
                                  //         itemBuilder: (context, suggestion) {
                                  //           return ListTile(
                                  //             title: Text(suggestion.daayitvaName!),
                                  //           );
                                  //         },
                                  //         onSelected: (suggestion) {
                                  //           setState(() {
                                  //             _daayitvaController.text = suggestion.daayitvaName!;
                                  //             _daayitvaValue = suggestion.daayitvaID.toString();
                                  //             print("field SelectDaayitva name :--${suggestion.daayitvaName}");
                                  //             print("field SelectDaayitva ID :--${_daayitvaValue}");
                                  //           });
                                  //         },
                                  //       ),
                                  //     ),
                                  //     IconButton(
                                  //         color: Colors.purple,
                                  //         onPressed: () {
                                  //           setState(() {
                                  //             _daayitvaController.text = "";
                                  //             _daayitvaValue = "";
                                  //           });
                                  //         },
                                  //         icon: Icon(Icons.cancel)
                                  //     ),
                                  //   ],
                                  // ),
                                  Row(
                                    children: [
                                      Container(
                                        width: Statics.getDeviceSize(context).width * 0.63,
                                        child: TypeAheadField<DaayitvaMasterBAL>(
                                          controller: _daayitvaController,
                                          builder: (context, controller, focusNode) {
                                            return TextField(
                                              controller: _daayitvaController,
                                              focusNode: focusNode,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                border: UnderlineInputBorder(),
                                                labelText: Statics.getLabel('SelectDaayitva'),
                                              ),
                                            );
                                          },
                                          suggestionsCallback: (pattern) {
                                            _daayitvaValue = "";
                                            return populateDaayitva(
                                              _daayitvaForValue == null || _daayitvaForValue!.code == "SanghaPreritSansthaa" || _daayitvaForValue!.code == "OtherSocialOrganization"
                                                  ? ""
                                                  : _daayitvaForValue!.staticID.toString(),
                                              pattern,
                                            );
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return ListTile(
                                              title: Text(suggestion.daayitvaName!),
                                            );
                                          },
                                          onSelected: (suggestion) {
                                            setState(() {
                                              _daayitvaController.text = suggestion.daayitvaName!;
                                              _daayitvaValue = suggestion.daayitvaID.toString();
                                              _selectedDaayitvaID = suggestion.daayitvaID.toString();
                                              print("field SelectDaayitva name :--${suggestion.daayitvaName}");
                                              print("field SelectDaayitva ID :--${_daayitvaValue}");
                                            });
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        color: Colors.purple,
                                        onPressed: () {
                                          setState(() {
                                            _daayitvaController.text = "";
                                            _daayitvaValue = "";
                                            _selectedDaayitvaID = ""; // Reset the class level variable
                                          });
                                        },
                                        icon: Icon(Icons.cancel),
                                      ),
                                    ],
                                  ),
                              if (_daayitvaForValue != null)
                                if (_daayitvaForValue!.code == "SanghaPreritSansthaa")
                                  Column(
                                    children: [
                                      // Legend(
                                      //     legendString: 'Sangha-PreritSansthaa',
                                      //     fontsize: 18),
                                      DropdownButtonFormField<dynamic>(
                                        decoration: InputDecoration(labelText: Statics.getLabel('SansthaaName')),
                                        isExpanded: true,
                                        value: _preritSansthaValue == "" ? null : _preritSansthaValue,
                                        items: _sanghaPreritSanstha!.map((bg) => DropdownMenuItem(value: bg["SanghaPreritSansthaaID"].toString(), child: Text(bg["SansthaaName"]))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _preritSansthaValue = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) return (Statics.getLabel('SansthaaValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty) {
                                            swDaayitva!.sanghaPreritSansthaaID = int.parse(value);
                                            print("field SansthaaName sanghaPreritSansthaaID :--${swDaayitva!.sanghaPreritSansthaaID}");
                                          } else
                                            swDaayitva!.sanghaPreritSansthaaID = null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _preritDesgCtrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('Designation')),
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) return (Statics.getLabel('DesignationValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty) {
                                            swDaayitva!.sanghaPreritSansthaaDesignation = value;
                                            print("field SansthaaName sanghaPreritSansthaaDesignation :--${swDaayitva!.sanghaPreritSansthaaID}");
                                          } else
                                            swDaayitva!.sanghaPreritSansthaaDesignation = null;
                                        },
                                      ),
                                      TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _preritRemarkCtrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('Remarks')),
                                        keyboardType: TextInputType.text,
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            swDaayitva!.sanghaPreritSansthaaRemark = value;
                                          else
                                            swDaayitva!.sanghaPreritSansthaaRemark = null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                              if (_daayitvaForValue != null)
                                if (_daayitvaForValue!.code == "OtherSocialOrganization")
                                  Column(
                                    children: [
                                      // Legend(
                                      //     legendString:
                                      //         'OtherSocialOrganization',
                                      //     fontsize: 18),
                                      TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _othOrgNameCtrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('SansthaaName')),
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) return (Statics.getLabel('DesignationValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty) {
                                            swDaayitva!.otherSocialOrganizationName = value;
                                            print("field SansthaaName otherSocialOrganizationName :--${swDaayitva!.sanghaPreritSansthaaID}");
                                          } else
                                            swDaayitva!.otherSocialOrganizationName = null;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _othDesgCtrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('Designation')),
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) return (Statics.getLabel('OrganizationNameValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            swDaayitva!.otherSocialOrganizationDesignation = value;
                                          else
                                            swDaayitva!.otherSocialOrganizationDesignation = null;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _othRemarksCtrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('Remarks')),
                                        keyboardType: TextInputType.text,
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            swDaayitva!.otherSocialOrganizationRemark = value;
                                          else
                                            swDaayitva!.otherSocialOrganizationRemark = null;
                                        },
                                      ),
                                      SizedBox(height: 20),
                                      Legend(legendString: 'AreaOfOperations', fontsize: 16),
                                      Container(
                                        width: Statics.getDeviceSize(context).width * 0.8,
                                        height: Statics.getDeviceSize(context).height * 0.3,
                                        child: ListView(
                                          children: _areaOfOperations.map((area) {
                                            return new CheckboxListTile(
                                              controlAffinity: ListTileControlAffinity.leading,
                                              title: new Text(area.codeForDisplay!),
                                              value: area.isSelected,
                                              activeColor: Colors.purple,
                                              checkColor: Colors.white,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  area.isSelected = value;
                                                });
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _startYearCtrl,
                                decoration: InputDecoration(labelText: Statics.getLabel('StartYear')),
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                                validator: (value) {
                                  if (value!.isNotEmpty && value.length < 4)
                                    return (Statics.getLabel('ValidStartYearValidationMessage'));
                                  else if (value.isNotEmpty) if ((int.parse(value) > int.parse(DateFormat('yyyy').format(DateTime.now())))) {
                                    return (Statics.getLabel('ValidStartYearValidationMessage'));
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  if (value != null && value.isNotEmpty)
                                    swDaayitva!.startYear = int.parse(value);
                                  else
                                    swDaayitva!.startYear = null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _endYearCtrl,
                                decoration: InputDecoration(labelText: Statics.getLabel('EndYear')),
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                                validator: (value) {
                                  if (value!.isNotEmpty && value.length < 4)
                                    return (Statics.getLabel('ValidEndYearValidationMessage'));
                                  else if (value.isNotEmpty) if ((int.parse(value) > int.parse(DateFormat('yyyy').format(DateTime.now())))) {
                                    return (Statics.getLabel('ValidEndYearValidationMessage'));
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  if (value != null && value.isNotEmpty)
                                    swDaayitva!.endYear = int.parse(value);
                                  else
                                    swDaayitva!.endYear = null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: Statics.getDeviceSize(context).width * 0.8,
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  title: Text(Statics.getLabel('IsCurrent'), style: TextStyle(fontSize: 15)),
                                  checkColor: Colors.white,
                                  activeColor: Colors.purple,
                                  value: _isCurrent == null ? false : _isCurrent,
                                  onChanged: (value) {
                                    setState(() {
                                      _isCurrent = value!;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                          if (_isLoading)
                            CircularProgressIndicator()
                          else if (int.parse(widget.swId) == 0)
                            Text(Statics.getLabel('saveBasicInfo'))
                          else if (widget.viewType == "ViewMenu")
                            Text(Statics.getLabel('canNotMakeChanges'))
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        inAsyncCall: _isFetchingData);
  }
}
