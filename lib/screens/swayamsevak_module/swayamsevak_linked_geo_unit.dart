import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../providers/bals.dart';
import '../../providers/swayamsevak_provider.dart';

import '../../helpers/static_data.dart' as Statics;

class SwayamsevakLinkedGeoUnit extends StatefulWidget {
  var swId;
  var onSaveSwDetails;
  var viewType;

  SwayamsevakLinkedGeoUnit({Key? key, this.swId, this.onSaveSwDetails, this.viewType}) : super(key: key);

  State<StatefulWidget> createState() {
    return new SwayamsevakLinkedGeoUnitState();
  }
}

class SwayamsevakLinkedGeoUnitState extends State<SwayamsevakLinkedGeoUnit> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;

  AutoCompleteTextField? vastiTextField;
  AutoCompleteTextField? gramTextField;

  SwayamsevakLinkedGeoUnitBAL? swLinkedGeoUnit;

  String? _geoUnitsVasti = "";
  String? _geoUnitsGraam = "";
  String? _geoUnitsShaakhaa = "";

  TextEditingController _vastiController = TextEditingController();
  TextEditingController _graamController = TextEditingController();
  TextEditingController _shaakhaaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    int swID = int.parse(widget.swId);
    if (swID > 0) {
      getSwDetails(widget.swId);
    } else {
      if (!mounted) return;
      setState(() {
        swLinkedGeoUnit = new SwayamsevakLinkedGeoUnitBAL(swID, 1, null, "", null, "", null, "");
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _vastiController.dispose();
    _graamController.dispose();
    _shaakhaaController.dispose();
  }

  void getSwDetails(var theId) async {
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      var data = await SwayamsevakProvider().getSwayamSevakByID(theId, "LinkedGeoUnits");
      if (!mounted) return;
      setState(() {
        swLinkedGeoUnit = data;
        if (swLinkedGeoUnit != null) {
          _geoUnitsVasti = swLinkedGeoUnit!.linkedVastiID == null ? null : swLinkedGeoUnit!.linkedVastiID.toString();
          _vastiController.text = swLinkedGeoUnit!.linkedVastiName.toString();

          _geoUnitsGraam = swLinkedGeoUnit!.linkedGraamID == null ? null : swLinkedGeoUnit!.linkedGraamID.toString();
          _graamController.text = swLinkedGeoUnit!.linkedGraamName.toString();

          _geoUnitsShaakhaa = swLinkedGeoUnit!.linkedShaakhaaID == null ? null : swLinkedGeoUnit!.linkedShaakhaaID.toString();
          _shaakhaaController.text = swLinkedGeoUnit!.linkedShaakhaaName.toString();
        }
      });
    }
  }

  Future<List<GeoUnitMasterBAL>> populateGeoUnits(var id, var unitName) async {
    var data = await Statics.getGeoUnitsLDB(id, unitName);
    return data;
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
      }
    } on Exception catch (error) {
      _showErrorDialog(Statics.getLabel('unableToCompleteProcess'));
    } catch (error) {
      _showErrorDialog(Statics.getLabel('unableToCompleteProcess'));
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(Statics.getLabel('errorOccurred')),
        content: Text(message),
        actions: <Widget>[
          MaterialButton(
            child: Text(Statics.getLabel('okay')),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  saveSwDetails() async {
    var inputData = json.encode({
      "ScreenName": "LinkedGeoUnit",
      "SwayamsevakID": int.parse(widget.swId),
      "BasicInfo": null,
      "OtherInfo": null,
      "SanghaShikshan": null,
      "ShaaririkVishay": null,
      "Occupation": null,
      "LinkedGeoUnit": {
        "SwayamsevakID": int.parse(widget.swId),
        "PraantID": 1,
        "LinkedVastiID": swLinkedGeoUnit!.linkedVastiID,
        "LinkedGraamID": swLinkedGeoUnit!.linkedGraamID,
        "LinkedShaakhaaID": swLinkedGeoUnit!.linkedShaakhaaID,
        "IsCurrent": true
      },
      "Daayitva": null,
      "ModifiedBy": 1
    });

    var data = await SwayamsevakProvider().saveSwayamsevakDetails(inputData);
    setState(() {
      widget.swId = data;
      widget.onSaveSwDetails(widget.swId);
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    });
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        width: Statics.getDeviceSize(context).width,
        child: AbsorbPointer(
          absorbing: widget.viewType == "ViewMenu" ? true : false,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      width: Statics.getDeviceSize(context).width * 0.75,
                      child: TypeAheadField<GeoUnitMasterBAL>(
                        controller: _vastiController,
                        builder: (context, controller, focusNode) {
                          return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                labelText: Statics.getLabel('SelectVasti'),
                              ));
                        },
                        // textFieldConfiguration: TextFieldConfiguration(
                        //     controller: this._vastiController,
                        //     decoration: InputDecoration(
                        //         labelText: Statics.getLabel('SelectVasti'))),
                        suggestionsCallback: (pattern) {
                          this._vastiController.text = "";
                          this._geoUnitsVasti = "";
                          return populateGeoUnits("2", pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion.fullName!),
                          );
                        },
                        // transitionBuilder:
                        //     (context, suggestionsBox, controller) {
                        //   return suggestionsBox;
                        // },
                        onSelected: (suggestion) {
                          this._vastiController.text = suggestion.fullName!;
                          this._geoUnitsVasti = suggestion.geoUnitID.toString();
                        },
                        // validator: (value) {
                        //   if ((value.isEmpty ||
                        //           _geoUnitsVasti == null ||
                        //           _geoUnitsVasti.isEmpty) &&
                        //       (_geoUnitsGraam == null ||
                        //           _geoUnitsGraam.isEmpty)) {
                        //     return Statics.getLabel('VastiValidationMessage');
                        //   }
                        //   return null;
                        // },
                        // onSaved: (value) {
                        //   if (_geoUnitsVasti != null &&
                        //       _geoUnitsVasti.isNotEmpty)
                        //     swLinkedGeoUnit!.linkedVastiID =
                        //         int.parse(_geoUnitsVasti);
                        //   else
                        //     swLinkedGeoUnit!.linkedVastiID = null;
                        // },
                      ),
                    ),
                    IconButton(
                        color: Colors.purple,
                        onPressed: () {
                          setState(() {
                            this._vastiController.text = "";
                            _geoUnitsVasti = "";
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
                      child: TypeAheadField<GeoUnitMasterBAL>(
                        controller: _graamController,
                        builder: (context, controller, focusNode) {
                          return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                labelText: Statics.getLabel('SelectGraam'),
                              ));
                        },
                        // textFieldConfiguration: TextFieldConfiguration(
                        //     controller: this._graamController,
                        //     decoration: InputDecoration(
                        //         labelText: Statics.getLabel('SelectGraam'))),
                        suggestionsCallback: (pattern) {
                          this._graamController.text = "";
                          this._geoUnitsGraam = "";
                          return populateGeoUnits("3", pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion.fullName!),
                          );
                        },
                        // transitionBuilder:
                        //     (context, suggestionsBox, controller) {
                        //   return suggestionsBox;
                        // },
                        onSelected: (suggestion) {
                          this._graamController.text = suggestion.fullName!;
                          this._geoUnitsGraam = suggestion.geoUnitID.toString();
                        },
                        // validator: (value) {
                        //   if ((value.isEmpty ||
                        //           _geoUnitsGraam == null ||
                        //           _geoUnitsGraam.isEmpty) &&
                        //       (_geoUnitsVasti == null ||
                        //           _geoUnitsVasti.isEmpty)) {
                        //     return Statics.getLabel(
                        //         'SelectGraamValidationMessage');
                        //   }
                        //   return null;
                        // },
                        // onSaved: (value) {
                        //   if (_geoUnitsGraam != null &&
                        //       _geoUnitsGraam.isNotEmpty)
                        //     swLinkedGeoUnit!.linkedGraamID =
                        //         int.parse(_geoUnitsGraam);
                        //   else
                        //     swLinkedGeoUnit!.linkedGraamID = null;
                        // },
                      ),
                    ),
                    IconButton(
                        color: Colors.purple,
                        onPressed: () {
                          setState(() {
                            this._graamController.text = "";
                            _geoUnitsGraam = "";
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
                      child: TypeAheadField<GeoUnitMasterBAL>(
                        controller: _shaakhaaController,
                        builder: (context, controller, focusNode) {
                          return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                labelText: Statics.getLabel('SelectShaakhaa'),
                              ));
                        },
                        // textFieldConfiguration: TextFieldConfiguration(
                        //     controller: this._shaakhaaController,
                        //     decoration: InputDecoration(
                        //         labelText: Statics.getLabel('SelectShaakhaa'))),
                        suggestionsCallback: (pattern) {
                          this._shaakhaaController.text = "";
                          this._geoUnitsShaakhaa = "";
                          return populateGeoUnits("1", pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion.fullName!),
                          );
                        },
                        // transitionBuilder:
                        //     (context, suggestionsBox, controller) {
                        //   return suggestionsBox;
                        // },
                        onSelected: (suggestion) {
                          this._shaakhaaController.text = suggestion.fullName!;
                          this._geoUnitsShaakhaa = suggestion.geoUnitID.toString();
                        },
                        // onSaved: (value) {
                        //   if (_geoUnitsShaakhaa != null &&
                        //       _geoUnitsShaakhaa.isNotEmpty)
                        //     swLinkedGeoUnit!.linkedShaakhaaID =
                        //         int.parse(_geoUnitsShaakhaa);
                        //   else
                        //     swLinkedGeoUnit!.linkedShaakhaaID = null;
                        // },
                      ),
                    ),
                    IconButton(
                        color: Colors.purple,
                        onPressed: () {
                          setState(() {
                            this._shaakhaaController.text = "";
                            _geoUnitsShaakhaa = "";
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
      ),
    );
  }
}
