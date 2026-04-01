import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../widgets/legend.dart';

import '../../providers/bals.dart';
import '../../providers/swayamsevak_provider.dart';
import '../../helpers/static_data.dart' as Statics;

class SwayamsevakDaayitva extends StatefulWidget {
  var swId;
  var onSaveSwDetails;
  var viewType;

  SwayamsevakDaayitva({Key? key, this.swId, this.onSaveSwDetails, this.viewType}) : super(key: key);

  State<StatefulWidget> createState() {
    return new SwayamsevakDaayitvaState();
  }
}

class SwayamsevakDaayitvaState extends State<SwayamsevakDaayitva> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  bool _isfetingData = false;

  List<StaticMasterBAL>? _daayitvaFor;
  List<LevelMasterBAL>? _level;
  List<AayaamMasterBAL>? _aayam;
  List<GatividhiMasterBAL>? _gatividhi;
  String? _daayitvaValue = "";

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

  List<DataColumn>? _detailscolumns;
  List<DataRow>? _detailsrows;

  bool? _isExpanded = false;
  bool? _isRelieved = false;

  @override
  void initState() {
    super.initState();
    populateDropdown();
    int swID = int.parse(widget.swId);
    if (swID > 0) {
      getSwDetails(widget.swId);
    } else {
      if (!mounted) return;
      setState(() {
        swDaayitva = new SwayamsevakDaayitvaBAL(swID, 1, null, null, "", null, null, null, null, null, null, null, "", "", "", "", "", false, "");
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _typeAheadController.dispose();
    _startYearCtrl.dispose();
    _endYearCtrl.dispose();
  }

  void populateDropdown() async {
    var data = await Statics.getStaticLDB("DaayitvaFor");
    var data2 = await Statics.getLevelLDB();
    var data3 = await Statics.getAayamLDB();
    var data4 = await Statics.getGatividhiLDB();
    //populateDaayitva(_daayitvaValue);

    if (!mounted) return;
    setState(() {
      _daayitvaFor = data;
      _level = data2;
      _aayam = data3;
      _gatividhi = data4;
    });
  }

  getSwDetails(var theId) async {
    setState(() {
      _isfetingData = true;
    });
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      var data = await SwayamsevakProvider().getSwayamSevakByID(theId, "Daayitva");

      if (data.length > 0) {
        await getDetailsColumnsandRows(data);
        //await getCsv(details);
      } else {
        if (!mounted) return;
        setState(() {
          _detailscolumns = null;
        });
      }
      if (!mounted) return;
      clearScreen();
      setState(() {
        _isfetingData = false;
      });
    }
  }

  getDetailsColumnsandRows(List<dynamic> dataList) async {
    List<DataColumn> cols = [];

    cols.add(new DataColumn(label: Text(Statics.getLabel('GeoUnit'))));
    cols.add(new DataColumn(label: Text(Statics.getLabel('Level'))));
    cols.add(new DataColumn(label: Text(Statics.getLabel('Daayitva'))));
    cols.add(new DataColumn(label: Text(Statics.getLabel('Gatividhi'))));
    cols.add(new DataColumn(label: Text(Statics.getLabel('Aayaam'))));
    cols.add(new DataColumn(label: Text(Statics.getLabel('StartYear'))));
    cols.add(new DataColumn(label: Text(Statics.getLabel('IsCurrent'))));

    List<DataRow> row = [];
    for (var data in dataList) {
      List<DataCell> cells = [];
      cells.add(new DataCell(Container(width: 100, child: Text(data["DaayitvaGeoUnitName"].toString()))));

      cells.add(new DataCell(Container(width: 100, child: Text(data["LevelName"].toString()))));

      cells.add(new DataCell(Container(width: 100, child: Text(data["DaayitvaName"].toString()))));

      cells.add(new DataCell(Container(width: 100, child: Text(data["GatividhiName"] == null ? "" : data["GatividhiName"].toString()))));

      cells.add(new DataCell(Container(width: 100, child: Text(data["AayaamName"] == null ? "" : data["AayaamName"].toString()))));

      cells.add(new DataCell(Container(width: 100, child: Text(data["StartYear"] == null ? "" : data["StartYear"].toString()))));

      cells.add(new DataCell(Container(width: 100, child: Text(data["IsCurrent"] == true ? "✔" : "-"))));

      row.add(new DataRow(cells: cells));
    }
    if (!mounted) return;
    setState(() {
      _detailscolumns = cols;
      _detailsrows = row;
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

  saveSwDetails() async {
    var inputData = json.encode({
      "Daayitva": {
        "SwayamsevakID": int.parse(widget.swId),
        "PraantID": 1,
        "DaayitvaID": swDaayitva!.daayitvaID,
        "LevelID": swDaayitva!.levelID,
        "DaayitvaGeoUnitID": swDaayitva!.daayitvaGeoUnitID,
        "GatividhiID": swDaayitva!.gatividhiID,
        "AayaamID": swDaayitva!.aayaamID,
        "StartYear": swDaayitva!.startYear,
        "IsCurrent": true
      },
      "IsRelieved": _isRelieved,
      "ModifiedBy": Statics.userDetails["userID"].toString()
    });

    var data = await SwayamsevakProvider().saveSwayamsevakDaayitvaForApp(inputData);
    if (!mounted) return;
    setState(() {
      widget.swId = data;
      widget.onSaveSwDetails(widget.swId);
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
      clearScreen();
    });
  }

  void clearScreen() {
    if (!mounted) return;
    setState(() {
      _daayitvaForValue = _levelValue = _geoUnits = _geoUnitsValue = _daayitvaValue = _geoUnitsValue = _aayaamValue = _gatividhiValue = null;
      _daayitvaController.text = _startYearCtrl.text = "";
      _isExpanded = _isRelieved = false;
      int swID = int.parse(widget.swId);
      swDaayitva = new SwayamsevakDaayitvaBAL(swID, 1, null, null, "", null, null, null, null, null, null, null, "", "", "", "", "", false, "");
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
        await getSwDetails(widget.swId);
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
                  Legend(legendString: 'DaayitvaHistory'),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: Statics.getDeviceSize(context).height * 0.2,
                    width: Statics.getDeviceSize(context).width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            DataTable(
                              columnSpacing: 20,
                              headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
                              columns: _detailscolumns == null ? <DataColumn>[DataColumn(label: Text("No Data Found"))] : _detailscolumns!,
                              rows: _detailsrows == null ? <DataRow>[] : _detailsrows!,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AbsorbPointer(
                    absorbing: widget.viewType == "ViewMenu" ? true : false,
                    child: ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          _isExpanded = isExpanded;
                        });
                      },
                      children: [
                        ExpansionPanel(
                          headerBuilder: (BuildContext context, bool isExpanded) {
                            return ListTile(
                              title: Text(Statics.getLabel('SelectGeoUnit')),
                            );
                          },
                          isExpanded: _isExpanded!,
                          body: Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 80,
                                      child: MaterialButton(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                          color: Theme.of(context).primaryColor,
                                          textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                                          onPressed: clearScreen,
                                          child: Text(
                                            Statics.getLabel('clear'),
                                            style: TextStyle(fontSize: 12),
                                          )),
                                    ),
                                  ],
                                ),
                                CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                    title: Text(Statics.getLabel('RelievefromCurrentDaayitva'), style: TextStyle(fontSize: 15)),
                                    checkColor: Colors.white,
                                    activeColor: Colors.purple,
                                    value: _isRelieved == null ? false : _isRelieved,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    onChanged: (value) {
                                      setState(() {
                                        _isRelieved = value;
                                      });
                                    }),
                                if (_isRelieved != true)
                                  AbsorbPointer(
                                    absorbing: _isRelieved == true ? true : false,
                                    child: Column(
                                      children: [
                                        DropdownButtonFormField<StaticMasterBAL>(
                                          decoration: InputDecoration(labelText: Statics.getLabel('SelectDaayitvaFor')),
                                          isExpanded: true,
                                          value: _daayitvaForValue == null ? null : _daayitvaForValue,
                                          items: _daayitvaFor!.map((bg) => DropdownMenuItem(value: bg, child: Text(bg.codeForDisplay!))).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _daayitvaForValue = value;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null) return (Statics.getLabel('DaayitvaForValidationMessage'));
                                            return null;
                                          },
                                          onSaved: (value) {
                                            swDaayitva!.daayitvaFor = value!.staticID;
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
                                                  onSaved: (value) {
                                                    if (value != null && value.isNotEmpty)
                                                      swDaayitva!.aayaamID = int.parse(value);
                                                    else
                                                      swDaayitva!.aayaamID = null;
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
                                                  onSaved: (value) {
                                                    if (value != null && value.isNotEmpty)
                                                      swDaayitva!.gatividhiID = int.parse(value);
                                                    else
                                                      swDaayitva!.gatividhiID = null;
                                                  },
                                                ),
                                              ],
                                            ),
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
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null || value.isEmpty) return (Statics.getLabel('LevelValidationMessage'));
                                            return null;
                                          },
                                          onSaved: (value) {
                                            if (value != null && value.isNotEmpty)
                                              swDaayitva!.levelID = int.parse(value);
                                            else
                                              swDaayitva!.levelID = null;
                                          },
                                        ),
                                        SizedBox(height: 10),
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(labelText: Statics.getLabel('SelectGeoUnit')),
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
                                            if (value != null && value.isNotEmpty)
                                              swDaayitva!.daayitvaGeoUnitID = int.parse(value);
                                            else
                                              swDaayitva!.daayitvaGeoUnitID = null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: Statics.getDeviceSize(context).width * 0.75,
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
                                                      ));
                                                },
                                                // textFieldConfiguration:
                                                //     TextFieldConfiguration(
                                                //         controller: this
                                                //             ._daayitvaController,
                                                //         decoration: InputDecoration(
                                                //             labelText: Statics
                                                //                 .getLabel(
                                                //                     'SelectDaayitva'))),
                                                suggestionsCallback: (pattern) {
                                                  this._daayitvaValue = "";
                                                  return populateDaayitva(_daayitvaForValue == null ? "" : _daayitvaForValue!.staticID.toString(), pattern);
                                                },
                                                itemBuilder: (context, suggestion) {
                                                  return ListTile(
                                                    title: Text(suggestion.daayitvaName!),
                                                  );
                                                },
                                                // validator: (value) {
                                                //   if ((value.isEmpty ||
                                                //       _daayitvaValue == null ||
                                                //       _daayitvaValue.isEmpty)) {
                                                //     return Statics.getLabel(
                                                //         'DaayitvaValidationMessage');
                                                //   }
                                                //   return null;
                                                // },
                                                // transitionBuilder: (context,
                                                //     suggestionsBox,
                                                //     controller) {
                                                //   return suggestionsBox;
                                                // },
                                                onSelected: (suggestion) {
                                                  this._daayitvaController.text = suggestion.daayitvaName!;
                                                  _daayitvaValue = suggestion.daayitvaID.toString();
                                                },
                                                // onSaved: (value) {
                                                //   if (_daayitvaValue != null &&
                                                //       _daayitvaValue.isNotEmpty)
                                                //     swDaayitva!.daayitvaID =
                                                //         int.parse(
                                                //             _daayitvaValue);
                                                //   else
                                                //     swDaayitva!.daayitvaID =
                                                //         null;
                                                // },
                                              ),
                                            ),
                                            IconButton(
                                                color: Colors.purple,
                                                onPressed: () {
                                                  setState(() {
                                                    this._daayitvaController.text = "";
                                                    _daayitvaValue = "";
                                                  });
                                                },
                                                icon: Icon(Icons.cancel)),
                                          ],
                                        ),
                                        TextFormField(
                                          textInputAction: TextInputAction.next,
                                          controller: _startYearCtrl,
                                          decoration: InputDecoration(labelText: Statics.getLabel('StartYear')),
                                          keyboardType: TextInputType.number,
                                          maxLength: 4,
                                          validator: (value) {
                                            if (value!.isNotEmpty && value!.length < 4)
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
                                      ],
                                    ),
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
                ],
              ),
            ),
          ),
        ),
        inAsyncCall: _isfetingData);
  }
}
