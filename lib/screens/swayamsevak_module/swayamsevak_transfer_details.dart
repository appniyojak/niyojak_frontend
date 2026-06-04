import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:niyojak_prod/screens/search_swayamsevak_transfer.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../providers/bals.dart';

class SwayamsevakTransferDetails extends StatefulWidget {
  var swayamsevakTransferID;
  var swayamsevakID;
  var onSaveDetails;
  var viewType;

  SwayamsevakTransferDetails({Key? key, this.swayamsevakTransferID, this.swayamsevakID, this.onSaveDetails, this.viewType}) : super(key: key);

  State<StatefulWidget> createState() {
    return new SwayamsevakTransferDetailState();
  }
}

class SwayamsevakTransferDetailState extends State<SwayamsevakTransferDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  bool _isFetchingData = false;

  List<GeoUnitMasterBAL>? _bhaagList;
  List<GeoUnitMasterBAL>? _shaharList;
  List<GeoUnitMasterBAL>? _nagarList;
  List<GeoUnitMasterBAL>? _upnagarList;
  List<GeoUnitMasterBAL>? _mandalList;
  List<GeoUnitMasterBAL>? _graamList;
  List<GeoUnitMasterBAL>? _vastiList;

  var _remarkCtrl = TextEditingController();

  List<StaticMasterBAL>? _statusList;

  SwayamsevakTransferBAL? _swayamsevakTransfer;

  String? _statusValue;
  String? _sourceBhaagName;

  String? _bhaagValue = "";
  String? _shaharValue = "";
  String? _nagarValue = "";
  String? _upnagarValue = "";
  String? _mandalValue = "";
  String? _graamValue = "";
  String? _vastiValue = "";

  Future<dynamic>? _transferRecrod;

  var bhaagID;
  int? lSwayamsevakTransferID;
  int? lSwayamsevakID;

  @override
  void initState() {
    super.initState();
    lSwayamsevakTransferID = (widget.swayamsevakTransferID == null ? null : int.parse(widget.swayamsevakTransferID));
    lSwayamsevakID = (widget.swayamsevakID == null ? null : int.parse(widget.swayamsevakID));

    _transferRecrod = _getTransferRecord(lSwayamsevakTransferID, lSwayamsevakID);
  }

  @override
  void dispose() {
    super.dispose();
    _remarkCtrl.dispose();
  }

  void populateShaharDropdown(String? bhaagIDStr) async {
    _upnagarValue = _shaharValue = null;
    _vastiValue = null;
    _shaharList = null;
    _upnagarList = _vastiList = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
    setState(() {
      _shaharList = (shDD.length > 0 ? shDD : null);
    });
  }

  void populateNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _upnagarValue = _nagarValue = null;
    _mandalValue = null;
    _graamValue = null;
    _vastiValue = null;
    _upnagarList = _nagarList = _mandalList = _graamList = _vastiList = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _nagarList = (ngDD.length > 0 ? ngDD : null);
      });
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _nagarList = (ngDD.length > 0 ? ngDD : null);
      });
    }
  }

  populateUpnagarDropdown(String? nagarIDStr) async {
    _upnagarValue = _mandalValue = _graamValue = _vastiValue = null;
    _upnagarList = _mandalList = _graamList = _vastiList = null;
    var mnDD;

    mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');

    setState(() {
      _upnagarList = (mnDD.length > 0 ? mnDD : null);
      //_linkedupnagarValue = (userparentUpanagarid ?? userGeoUnitId).toString();
    });
  }

  void populateMandalDropdown(bool haveParentUp, String nagarIDStr) async {
    _mandalValue = _graamValue = null;
    _mandalList = _graamList = null;
    var mnDD;
    if (haveParentUp) {
      mnDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, "Upnagar", '');
    } else {
      mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    }
    setState(() {
      _mandalList = (mnDD.length > 0 ? mnDD : null);
    });
  }

  void populateGraamDropdown(String mandalIDStr) async {
    _graamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _graamList = (gmDD.length > 0 ? gmDD : null);
    });
  }

  void populateVastiDropdown(bool haveParentUp, String nagarIDStr) async {
    _vastiValue = null;
    var vsDD;
    if (haveParentUp) {
      print("i am in parents upnagar vasti");
      vsDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, "Upnagar", '');
      // print("${mnDD}");
    } else {
      vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, "Nagar", '');
    }
    setState(() {
      _vastiList = (vsDD.length > 0 ? vsDD : null);
    });
  }

  void getGeoUnitDets(var levelName, var geoUnitID) async {
    GeoUnitMasterBAL? geoUnitDets;
    List<GeoUnitMasterBAL> geoUnitList = await Statics.getGeoUnitMasterForApp(geoUnitID, '1', '', '', '', '', '', '', '', '', '', '');
    if (geoUnitList != null && geoUnitList.length > 0) geoUnitDets = geoUnitList[0];

    //GeoUnitMasterBAL geoUnitDets = await Statics.getGeoUnitsByID(geoUnitID);

    if (geoUnitDets != null) {
      _bhaagValue = geoUnitDets.parentBhaagID == null ? null : geoUnitDets.parentBhaagID.toString();
      if (_bhaagValue != null) populateShaharDropdown(_bhaagValue!);

      _shaharValue = geoUnitDets.parentShaharID == null ? null : geoUnitDets.parentShaharID.toString();
      if (_shaharValue != null || _bhaagValue != null) populateNagarDropdown(_bhaagValue!, _shaharValue!);

      _nagarValue = geoUnitDets.parentNagarID == null ? null : geoUnitDets.parentNagarID.toString();
      if (_nagarValue != null) {
        populateMandalDropdown(false, _nagarValue!);
        populateVastiDropdown(false, _nagarValue!);
      }

      _mandalValue = geoUnitDets.parentMandalID == null ? null : geoUnitDets.parentMandalID.toString();
      if (_mandalValue != null) populateGraamDropdown(_mandalValue!);

      _graamValue = geoUnitDets.parentMandalID == null ? null : geoUnitDets.geoUnitID.toString();

      _vastiValue = geoUnitDets.parentMandalID == null ? geoUnitDets.geoUnitID.toString() : null;
    }
  }

  saveSwayamsevakTransfer() async {
    var inputData = json.encode({
      "SwayamsevakTransferID": _swayamsevakTransfer!.swayamsevakTransferID,
      "SwayamsevakID": _swayamsevakTransfer!.swayamsevakID,
      "SourceBhaagID": _swayamsevakTransfer!.sourceBhaagID,
      "SourceLinkedGeoUnitID": _swayamsevakTransfer!.sourceLinkedGeoUnitID,
      "DestinationBhaagID": _swayamsevakTransfer!.destinationBhaagID,
      "DestinationLinkedGeoUnitID": _swayamsevakTransfer!.destinationLinkedGeoUnitID,
      "StatusID": _swayamsevakTransfer!.statusID,
      "Remark": _swayamsevakTransfer!.remark
    });

    var outputTransferID = await Statics.saveSwayamsevakTransferDetails(inputData);
    _swayamsevakTransfer!.swayamsevakTransferID = int.parse(outputTransferID);
    setState(() {
      widget.swayamsevakTransferID = outputTransferID;
      widget.onSaveDetails(outputTransferID);
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
      Navigator.of(context).pushReplacementNamed(SearchSwayamsevakTransfer.routeName);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();

    bool isVastiEmpty = _vastiValue == null || _vastiValue!.isEmpty;
    bool isGraamEmpty = _graamValue == null || _graamValue!.isEmpty;

    if (_statusValue == "220" && isVastiEmpty && isGraamEmpty) {
      Statics.showMessageDialog(context, Statics.getLabel('VastiGraamValidation'));
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        await saveSwayamsevakTransfer();
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

  Future<dynamic> _getTransferRecord(var theId, var swId) async {
    var data = await Statics.getSwayamsevakTransferByID(theId == null || theId == 0 ? '0' : theId.toString(), swId == null || swId == 0 ? '0' : swId.toString());

    _swayamsevakTransfer = data;
    if (_swayamsevakTransfer != null) {
      _graamValue = _swayamsevakTransfer!.graamID == null ? null : _swayamsevakTransfer!.graamID.toString();
      if (_graamValue != null) {
        getGeoUnitDets('Graam', _graamValue);
      }

      _vastiValue = _swayamsevakTransfer!.vastiID == null ? null : _swayamsevakTransfer!.vastiID.toString();
      if (_vastiValue != null) {
        getGeoUnitDets('Vasti', _vastiValue);
      }

      if (_bhaagValue != null && _graamValue == null && _vastiValue == null) {
        _bhaagValue = _swayamsevakTransfer!.destinationBhaagID == null ? null : _swayamsevakTransfer!.destinationBhaagID.toString();
        populateShaharDropdown(_bhaagValue.toString());
        populateNagarDropdown(_bhaagValue.toString(), null);
      }

      var statusData = await Statics.getStaticLDB('SwayamsevakTransferStatus');
      _statusList = statusData;

      var bhaagData = await Statics.getGeoUnitMasterForApp('', '1', '', Statics.levels['BhaagLevelID'], '', '', '', '', '', '', '', '');
      _bhaagList = bhaagData;

      _statusValue = _swayamsevakTransfer!.statusID == null ? null : _swayamsevakTransfer!.statusID.toString();

      _remarkCtrl.text = _swayamsevakTransfer!.remark.toString();

      _sourceBhaagName = _swayamsevakTransfer!.sourceBhaagName;
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              width: Statics.getDeviceSize(context).width,
              child: AbsorbPointer(
                absorbing: widget.viewType == "ViewMenu" ? true : false,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      FutureBuilder<dynamic>(
                        future: _transferRecrod,
                        builder: (ctx, dataSnapshot) {
                          List<Widget> fbChildren;
                          if (dataSnapshot.connectionState != ConnectionState.done) {
                            fbChildren = <Widget>[Center(child: CircularProgressIndicator())];
                          } else if (dataSnapshot.hasError) {
                            print(dataSnapshot.error);
                            fbChildren = <Widget>[
                              Center(
                                  child: Text(
                                'Server Error, Please Try Again Later',
                                style: TextStyle(color: Colors.red),
                              ))
                            ];
                          } else if (dataSnapshot.hasData) {
                            fbChildren = <Widget>[
                              Column(children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(dataSnapshot.data.swayamsevakName + ' ' + ', ' + dataSnapshot.data.mobileNumber, style: TextStyle(fontSize: 16)),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(Statics.getLabel('sourceBhaagLabel') + ': ' + dataSnapshot.data.sourceBhaagName, style: TextStyle(fontSize: 16)),
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(Statics.getLabel('destinationBhaagLabel') + ': ' + dataSnapshot.data.destinationBhaagName, style: TextStyle(fontSize: 16))),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(Statics.getLabel('initiatedDate') + ': ' + dataSnapshot.data.initiatedDate, style: TextStyle(fontSize: 16)),
                                ),
                                if (dataSnapshot.data.completeDate != '')
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(Statics.getLabel('completeDate') + ': ' + dataSnapshot.data.completeDate, style: TextStyle(fontSize: 16)),
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (_bhaagList != null)
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                                    isExpanded: true,
                                    value: _bhaagValue == "" ? null : _bhaagValue,
                                    items: _bhaagList!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                    onSaved: (value) {
                                      if (value != null && value.isNotEmpty) {
                                        _swayamsevakTransfer!.destinationBhaagID = int.parse(value);
                                      } else {
                                        _swayamsevakTransfer!.destinationBhaagID = null;
                                      }
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _bhaagValue = value;
                                        _upnagarValue = _upnagarList = null;
                                      });
                                      populateShaharDropdown(value!);
                                      populateNagarDropdown(value, null);
                                    },
                                    validator: (value) {
                                      if ((value == null || value.isEmpty)) {
                                        return Statics.getLabel('SelectBhaagValidationMessage');
                                      }
                                      return null;
                                    },
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (_shaharList != null && _shaharList!.length > 0)
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                                    isExpanded: true,
                                    value: _shaharValue == "" ? null : _shaharValue,
                                    items: _shaharList!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _shaharValue = value;
                                      });
                                      populateNagarDropdown(null, value);
                                    },
                                    // validator: (value) {
                                    //   if ((value == null || value.isEmpty)) {
                                    //     return Statics.getLabel('SelectShaharValidationMessage');
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                if (_shaharList != null && _shaharList!.length > 0)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (_nagarList != null && _nagarList!.length > 0)
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                                    isExpanded: true,
                                    value: _nagarValue == "" ? null : _nagarValue,
                                    items: _nagarList!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _nagarValue = value;
                                      });
                                      populateUpnagarDropdown(value);
                                      populateMandalDropdown(false, value!);
                                      populateVastiDropdown(false, value);
                                    },
                                    // validator: (value) {
                                    //   if ((value == null || value.isEmpty)) {
                                    //     return Statics.getLabel('SelectNagarValidationMessage');
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                if (_nagarList != null && _nagarList!.length > 0)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (_upnagarList != null && _upnagarList!.length > 0)
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(labelText: Statics.getLabel('upnagarUpkhanda')),
                                    isExpanded: true,
                                    value: _upnagarValue == "" ? null : _upnagarValue,
                                    items: _upnagarList!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _upnagarValue = value;
                                      });
                                      populateMandalDropdown(true, value!);
                                      populateVastiDropdown(true, value);
                                    },
                                    // validator: (value) {
                                    //   if ((value == null || value.isEmpty)) {
                                    //     return Statics.getLabel('SelectNagarValidationMessage');
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                if (_upnagarList != null && _upnagarList!.length > 0)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (_mandalList != null && _mandalList!.length > 0)
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(labelText: Statics.getLabel('Mandal')),
                                    isExpanded: true,
                                    value: _mandalValue == "" ? null : _mandalValue,
                                    items: _mandalList!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _mandalValue = value;
                                      });
                                      populateGraamDropdown(value!);
                                    },
                                    // validator: (value) {
                                    //   if ((value == null || value.isEmpty)) {
                                    //     return Statics.getLabel('SelectMandalValidationMessage');
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                if (_mandalList != null && _mandalList!.length > 0)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (_vastiList != null && _vastiList!.length > 0)
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(labelText: Statics.getLabel('SelectVasti')),
                                    isExpanded: true,
                                    value: _vastiValue == ""
                                        ? null
                                        : _vastiList != null
                                            ? _vastiList!.indexWhere((p) => p.geoUnitID.toString() == _vastiValue) > -1
                                                ? _vastiValue
                                                : null
                                            : null,
                                    items: _vastiList!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                    // validator: (value) {
                                    //   if ((value == null || value.isEmpty) && (_graamValue == null || _graamValue!.isEmpty)) {
                                    //     return Statics.getLabel('VastiValidationMessage');
                                    //   }
                                    //   return null;
                                    // },
                                    onChanged: (value) {
                                      setState(() {
                                        _vastiValue = value;
                                      });
                                    },
                                    onSaved: (value) {
                                      if (value != null && value.isNotEmpty) {
                                        _swayamsevakTransfer!.vastiID = int.parse(value);
                                        _swayamsevakTransfer!.destinationLinkedGeoUnitID = int.parse(value);
                                      } else {
                                        _swayamsevakTransfer!.vastiID = null;
                                        _swayamsevakTransfer!.destinationLinkedGeoUnitID = null;
                                      }
                                    },
                                  ),
                                if (_vastiList != null && _vastiList!.length > 0)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (_graamList != null && _graamList!.length > 0)
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(labelText: Statics.getLabel('SelectGraam')),
                                    isExpanded: true,
                                    value: _graamValue == "" ? null : _graamValue,
                                    items: _graamList!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                    // validator: (value) {
                                    //   if ((value == null || value.isEmpty) && (_graamValue == null || _graamValue!.isEmpty)) {
                                    //     return Statics.getLabel('SelectGraamValidationMessage');
                                    //   }
                                    //   return null;
                                    // },
                                    onChanged: (value) {
                                      setState(() {
                                        _graamValue = value;
                                      });
                                    },
                                    onSaved: (value) {
                                      if (value != null && value.isNotEmpty) {
                                        _swayamsevakTransfer!.graamID = int.parse(value);
                                        _swayamsevakTransfer!.destinationLinkedGeoUnitID = int.parse(value);
                                      } else {
                                        _swayamsevakTransfer!.graamID = null;
                                        _swayamsevakTransfer!.destinationLinkedGeoUnitID = null;
                                      }
                                    },
                                  ),
                                if (_graamList != null && _graamList!.length > 0)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (_statusList != null)
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(labelText: Statics.getLabel('Status')),
                                    isExpanded: true,
                                    value: _statusValue == "" ? null : _statusValue,
                                    items: _statusList!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _statusValue = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return (Statics.getLabel('StatusValidationMessage'));
                                      return null;
                                    },
                                    onSaved: (value) {
                                      if (value != null && value.isNotEmpty)
                                        _swayamsevakTransfer!.statusID = int.parse(value);
                                      else
                                        _swayamsevakTransfer!.statusID = null;
                                    },
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _remarkCtrl,
                                  decoration: InputDecoration(labelText: Statics.getLabel('Remark')),
                                  keyboardType: TextInputType.text,
                                  onSaved: (value) {
                                    _swayamsevakTransfer!.remark = value;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (_isLoading)
                                  CircularProgressIndicator()
                                else if (widget.viewType == "ViewMenu" || dataSnapshot.data.statusCode == 'Complete')
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
                              ])
                            ];
                          } else {
                            fbChildren = <Widget>[
                              Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch'))),
                            ];
                          }
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: fbChildren,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          inAsyncCall: _isFetchingData),
    );
  }
}
