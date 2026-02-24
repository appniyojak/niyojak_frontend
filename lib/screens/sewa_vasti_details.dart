import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helpers/static_data.dart' as Statics;
import '../providers/bals.dart';
import '../widgets/legend.dart';

class SewaVastiDetails extends StatefulWidget {
  var sewaVastiID;
  var onSaveDetails;
  var viewType;

  SewaVastiDetails({Key? key, this.sewaVastiID, this.onSaveDetails, this.viewType}) : super(key: key);

  @override
  _SewaVastiDetailsState createState() => _SewaVastiDetailsState();
}

class _SewaVastiDetailsState extends State<SewaVastiDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  bool _isfetingData = false;
  SewaVastiList? sDetails;

  var _sewaVastiNameCntrl = TextEditingController();
  var _population = TextEditingController();
  var _remarkCntrl = TextEditingController();

  String? _bhaagValue = "";
  String? _shaharValue = "";
  String? _nagarValue = "";
  String? selectedgeoUnitID = "";
  String? selectedLevel = "";

  List<GeoUnitMasterBAL>? _bhaag;
  List<GeoUnitMasterBAL>? _shahar;
  List<GeoUnitMasterBAL>? _nagar;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";
  String? type = "praant";
  bool _isExpanded = false;

  List<NecessitiesBAL> _necessities = [];

  void initState() {
    populateDropdown();
    super.initState();
    // populateBhaagDropdown();
    int sewaVastiID = int.parse(widget.sewaVastiID);
    if (sewaVastiID > 0) {
      populateDropdown();
      getSewaVastiDetails(widget.sewaVastiID);
    } else {
      if (!mounted) return;
      setState(() {
        // sDetails = new SewaVastiList(0, sewaVastiID, "", null, null, null, "", "", "", "", "", "", "", "");
        sDetails = new SewaVastiList(
            bhaagName: "",
            bhaagID: 0,
            graamID: "",
            graamName: "",
            mahaanagarID: 0,
            mahaanagarName: "",
            mandalID: "",
            mandalName: "",
            nagarID: 0,
            nagarName: "",
            necessarySewaTypeIDs: "",
            population: "",
            praantID: 0,
            remark: "",
            sewaVastiID: 0,
            sewaVastiName: "",
            shaharID: "",
            shaharName: "",
            vastiID: 0,
            vastiName: "",
            vibhaagID: 0,
            vibhaagName: "");
      });
      populateAreaDetails();
    }
  }

  // void populateBhaagDropdown() async {
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), "", "", "");
  //
  //   setState(() {
  //     _bhaag = data;
  //   });
  // }

  void populateAreaDetails() async {
    var svn = await Statics.getStaticLDB("SewaVastiNecessity");
    _necessities = [];
    var svnArr = (sDetails == null || sDetails!.necessarySewaTypeIDs == null) ? [] : sDetails!.necessarySewaTypeIDs!.split(',');
    for (var data in svn) {
      _necessities.add(new NecessitiesBAL(data.staticID, data.code, data.codeForDisplay, (svnArr.contains(data.staticID.toString()) ? true : false)));
    }
  }

  void populateShaharDropdown(String bhaagIDStr) async {
    _shaharValue = null;
    _shahar = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _shahar = (shDD.length > 0 ? shDD : null);
    });
  }

  void populateNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _nagarValue = null;
    _nagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _nagar = (ngDD.length > 0 ? ngDD : null);
      });
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _nagar = (ngDD.length > 0 ? ngDD : null);
      });
    }
  }

  // void getSewaVastiDetails(var theId) async {
  //   setState(() {
  //     _isfetingData = true;
  //   });
  //   bool isConnected = await Statics.isInternetConnected();
  //   if (!isConnected) {
  //     Statics.showMessageDialog(
  //         context, Statics.getLabel('internetNotConnected'));
  //   } else {
  //     String strInput = json.encode({
  //       "AppUserID": Statics.userDetails["userID"].toString(),
  //       "BhaagID": null,
  //       "ShaharID": null,
  //       "NagarID": null,
  //       "SewaVastiID": theId
  //     });
  //     var dataList = await Statics.getSewaVastiForApp(strInput);
  //     var data = null;
  //
  //     if (dataList[0].isNotEmpty &&
  //         dataList[0] != null &&
  //         dataList[0].length > 0) {
  //       data = SewaVastiList.fromJson(dataList[0]);
  //     } else {
  //       data = null;
  //     }
  //     if (!mounted) return;
  //     setState(() {
  //       sDetails = data;
  //       if (sDetails != null) {
  //         _sewaVastiNameCntrl.text = sDetails!.sewaVastiName.toString();
  //
  //         _bhaagValue =
  //             sDetails!.bhaagID == null ? null : sDetails!.bhaagID.toString();
  //         if (_bhaagValue != null) {
  //           populateShaharDropdown(_bhaagValue!);
  //           populateNagarDropdown(_bhaagValue, null);
  //         }
  //         _shaharValue =
  //             sDetails!.shaharID == null ? null : sDetails!.shaharID.toString();
  //
  //         if (_shaharValue != null) {
  //           populateNagarDropdown(null, _shaharValue);
  //         }
  //         if (sDetails != null) {
  //           setState(() {
  //             if (sDetails!.mahaanagarID != null) {
  //               print(
  //                   "getSewaVastiDetails sDetails!.mahaanagarID -- ${sDetails!.mahaanagarID}");
  //               _isExpanded = true;
  //               _linkedMahaanagarValue = sDetails!.mahaanagarID.toString();
  //             }
  //             if (sDetails!.vibhaagID != null) {
  //               print(
  //                   "getSewaVastiDetails sDetails!.vibhaagID -- ${sDetails!.vibhaagID}");
  //
  //               populatelinkedVibhaagDropdown('');
  //               _isExpanded = true;
  //               _linkedVibhaagValue = sDetails!.vibhaagID.toString();
  //               populatelinkedBhaagDropdown(_linkedVibhaagValue);
  //             }
  //             if (sDetails!.bhaagID != null) {
  //               print(
  //                   "getSewaVastiDetails sDetails!.bhaagID -- ${sDetails!.bhaagID}");
  //
  //               _isExpanded = true;
  //               _linkedbhaagValue = sDetails!.bhaagID.toString();
  //               populatelinkedNagarDropdown(_linkedbhaagValue, null);
  //             }
  //             if (sDetails!.nagarID != null) {
  //               print(
  //                   "getSewaVastiDetails sDetails!.nagarID -- ${sDetails!.nagarID}");
  //
  //               _isExpanded = true;
  //               _linkednagarValue = sDetails!.nagarID.toString();
  //               populatelinkedMandalDropdown(_linkednagarValue);
  //               populatelinkedVastiDropdown(_linkednagarValue);
  //             }
  //             if (sDetails!.mandalID != null) {
  //               print(
  //                   "getSewaVastiDetails sDetails!.mandalID -- ${sDetails!.mandalID}");
  //
  //               _isExpanded = true;
  //               _linkedmandalValue = sDetails!.mandalID.toString();
  //               populatelinkedGraamDropdown(_linkedmandalValue);
  //             }
  //             if (sDetails!.vastiName != "" && sDetails!.vastiID != null) {
  //               print(
  //                   "getSewaVastiDetails sDetails!.vastiName -- ${sDetails!.vastiName} -- ${sDetails!.vastiID}");
  //
  //               _isExpanded = true;
  //               _linkedvastiValue = sDetails!.vastiID.toString();
  //             } else if (sDetails!.graamName != "" &&
  //                 sDetails!.graamID != null) {
  //               print(
  //                   "getSewaVastiDetails sDetails!.graamName -- ${sDetails!.graamName} -- ${sDetails!.graamID}");
  //
  //               _isExpanded = true;
  //               _linkedgraamValue = sDetails!.graamID.toString();
  //             } else if (sDetails!.mandalName == "" &&
  //                 sDetails!.mandalID != null) {
  //               print(
  //                   "getSewaVastiDetails sDetails!.mandalName -- ${sDetails!.mandalName} -- ${sDetails!.mandalID}");
  //
  //               _isExpanded = true;
  //               _linkedmandalValue = sDetails!.mandalID.toString();
  //               populatelinkedGraamDropdown(_linkedmandalValue);
  //             } else if (sDetails!.nagarName == "" &&
  //                 sDetails!.nagarID != null) {
  //               print(
  //                   "getSewaVastiDetails sDetails!.nagarName -- ${sDetails!.nagarID} -- ${sDetails!.nagarName}");
  //
  //               _isExpanded = true;
  //               _linkednagarValue = sDetails!.nagarID.toString();
  //               populatelinkedMandalDropdown(_linkednagarValue);
  //               populatelinkedVastiDropdown(_linkednagarValue);
  //             } else if (sDetails!.bhaagName != "" &&
  //                 sDetails!.bhaagID != null) {
  //               print(
  //                   "getSewaVastiDetails sDetails!.bhaagName --- ${sDetails!.bhaagName} --- ${sDetails!.bhaagID}");
  //
  //               _isExpanded = true;
  //               _linkedbhaagValue = sDetails!.bhaagID.toString();
  //               populatelinkedNagarDropdown(_linkedbhaagValue, null);
  //             } else {
  //               print("else");
  //
  //               _isExpanded = false;
  //               // _linkedgraamDisable = true;
  //               _linkedbhaagValue = null;
  //               _linkedshaharValue = null;
  //               _linkednagarValue = null;
  //               _linkedmandalValue = null;
  //               _linkedgraamValue = null;
  //               _linkedvastiValue = null;
  //             }
  //           });
  //         }
  //
  //         _nagarValue =
  //             sDetails!.nagarID == null ? null : sDetails!.nagarID.toString();
  //         populateAreaDetails();
  //         _population.text = sDetails!.population.toString();
  //         _remarkCntrl.text =
  //             sDetails!.remark == null ? "" : sDetails!.remark.toString();
  //       }
  //     });
  //   }
  //   setState(() {
  //     _isfetingData = false;
  //   });
  // }

  void getSewaVastiDetails(var theId) async {
    setState(() {
      _isfetingData = true;
    });

    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      setState(() {
        _isfetingData = false;
      });
      return;
    }

    final strInput = json.encode({"AppUserID": Statics.userDetails["userID"].toString(), "BhaagID": null, "ShaharID": null, "NagarID": null, "SewaVastiID": theId});

    final dataList = await Statics.getSewaVastiForApp(strInput);

    if (!mounted) return;

    SewaVastiList? data;
    if (dataList.isNotEmpty && dataList[0].isNotEmpty) {
      data = SewaVastiList.fromJson(dataList[0]);
    }

    setState(() {
      sDetails = data;
      if (sDetails == null) {
        _isExpanded = false;
        _linkedbhaagValue = null;
        _linkedshaharValue = null;
        _linkednagarValue = null;
        _linkedmandalValue = null;
        _linkedgraamValue = null;
        _linkedvastiValue = null;
        _isfetingData = false;
        return;
      }

      _sewaVastiNameCntrl.text = sDetails!.sewaVastiName ?? "";

      // Primary dropdown values
      _bhaagValue = sDetails!.bhaagID?.toString();
      _shaharValue = sDetails!.shaharID?.toString();
      _nagarValue = sDetails!.nagarID?.toString();
      _population.text = sDetails!.population?.toString() ?? "";
      _remarkCntrl.text = sDetails!.remark ?? "";
      type = "mahanagar";

      // Populate dropdowns
      if (_bhaagValue != null) {
        populateShaharDropdown(_bhaagValue!);
        populateNagarDropdown(_bhaagValue, null);
        type = "bhag";
      }

      if (_shaharValue != null) {
        populateNagarDropdown(null, _shaharValue);
        type = "shahar";
      }

      // Linked hierarchy dropdowns
      _isExpanded = false;

      if (sDetails!.mahaanagarID != null) {
        _linkedMahaanagarValue = sDetails!.mahaanagarID.toString();
        _isExpanded = true;
        type = "mahanagar";
      }

      if (sDetails!.vibhaagID != null) {
        _linkedVibhaagValue = sDetails!.vibhaagID.toString();
        populatelinkedVibhaagDropdown('');
        populatelinkedBhaagDropdown(_linkedVibhaagValue);
        type = "vibhag";
        _isExpanded = true;
      }

      if (sDetails!.bhaagID != null) {
        _linkedbhaagValue = sDetails!.bhaagID.toString();
        populatelinkedNagarDropdown(_linkedbhaagValue, null);
        type = "bhag";
        _isExpanded = true;
      }

      if (sDetails!.nagarID != null) {
        _linkednagarValue = sDetails!.nagarID.toString();
        populatelinkedMandalDropdown(_linkednagarValue);
        populatelinkedVastiDropdown(_linkednagarValue);
        print("_linkednagarValue $_linkednagarValue  -----");
        type = "nagar";
        _isExpanded = true;
      }

      if (sDetails!.mandalID != null) {
        _linkedmandalValue = sDetails!.mandalID.toString();
        populatelinkedGraamDropdown(_linkedmandalValue);
        type = "mandal";
        _isExpanded = true;
      }

      if (sDetails!.vastiID != null && (sDetails!.vastiName?.isNotEmpty ?? false)) {
        _linkedvastiValue = sDetails!.vastiID.toString();
        type = "vasti";
        _isExpanded = true;
      } else if (sDetails!.graamID != null && (sDetails!.graamName?.isNotEmpty ?? false)) {
        _linkedgraamValue = sDetails!.graamID.toString();
        type = "gram";
        _isExpanded = true;
      }

      populateAreaDetails();
      _isfetingData = false;
    });
  }

  Future<void> _submit() async {
    print("_submit 1");
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    if (_necessities.where((e) => e.isSelected == true).length <= 0) {
      print("_submit 2");

      Statics.showToast(Statics.getLabel('NecessitiesValidationMessage'));
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    // try {
    print("_submit 3");

    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      print("_submit 4");

      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      print("_submit 5");

      await saveSwDetails();
    }
    print("_submit 6");

    // } on Exception catch (error) {
    //   print("_submit 7");
    //   log("error :-  $error");
    //   Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    // } catch (error) {
    //   print("_submit 8");
    //
    //   Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    // }
    print("_submit 9 ");

    setState(() {
      _isLoading = false;
    });
  }

  saveSwDetails() async {
    var necessitiesIDs = '';

    for (var data in _necessities) {
      if (data.isSelected!) necessitiesIDs = necessitiesIDs + data.staticID.toString() + ",";
    }

    if (necessitiesIDs.trim() != '') necessitiesIDs = necessitiesIDs.substring(0, necessitiesIDs.length - 1);

    var inputData = json.encode({
      "SewaVastiID": widget.sewaVastiID,
      "PraantID": 1,
      "BhaagID": _bhaagValue == ""
          ? null
          : _linkedbhaagValue == ""
              ? null
              : _linkedbhaagValue ?? _bhaagValue,
      "ShaharID": _shaharValue == ""
          ? null
          : _linkedshaharValue == ""
              ? null
              : _linkedshaharValue ?? _shaharValue,
      "NagarID": _nagarValue == ""
          ? null
          : _linkednagarValue == ""
              ? null
              : _linkednagarValue ?? _nagarValue,
      "SewaVastiName": sDetails!.sewaVastiName,
      "Population": sDetails!.population,
      "NecessarySewaTypeIDs": necessitiesIDs == "" ? null : necessitiesIDs,
      "Remark": sDetails!.remark,
      "type": type,
      "geounitid": type == "praant"
          ? null
          : type == "mahanagar"
              ? _linkedMahaanagarValue
              : type == "vibhag"
                  ? _linkedVibhaagValue
                  : type == "bhag"
                      ? _linkedbhaagValue ?? _bhaagValue
                      : type == "nagar"
                          ? _linkednagarValue ?? _nagarValue
                          : type == "mandal"
                              ? _linkedmandalValue
                              : type == "gram"
                                  ? _linkedgraamValue
                                  : type == "vasti"
                                      ? _linkedvastiValue
                                      : null,
      "ModifiedBy": Statics.userDetails["userID"].toString()
    });
    var data = await Statics.saveSewaVastiForApp(inputData);
    setState(() {
      widget.sewaVastiID = data;
      widget.onSaveDetails(widget.sewaVastiID);
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    });
  }

  Future<void> populateDropdown() async {
    setState(() {
      _linkedshaharValue = null;
      _linkednagarValue = null;
      _linkedmandalValue = null;
      _linkedgraamValue = null;
      _linkedvastiValue = null;
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');

    log("sDetails   :---   $sDetails");
  }

  populatelinkedMahaanagarDropdown() async {
    print("populatelinkedMahaanagarDropdown Runnnn");
    _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
  }

  populatelinkedVibhaagDropdown(String? mahaanagarIDStr) async {
    print("populatelinkedVibhaagDropdown Runnnn");

    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr!, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    setState(() {
      _linkedVibhaag = data;
    });
  }

  void populatelinkedBhaagDropdown(String? vibhaagIDStr) async {
    print("populatelinkedBhaagDropdown Runnnn");

    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr!, 'Vibhaag', '');
    setState(() {
      _linkedbhaag = data;
    });
  }

  // void populatelinkedShaharDropdown(String? bhaagIDStr) async {
  //   print("populatelinkedShaharDropdown Runnnn");
  //
  //   _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   var shDD = await Statics.getGeoUnitsByLevelAndParent(
  //       Statics.levels['ShaharLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
  //   setState(() {
  //     _linkedshahar = (shDD.length > 0 ? shDD : null);
  //   });
  // }

  void populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    // if (shaharIDStr != null) {
    //   print("populatelinkedNagarDropdown Runnnn 111");
    //
    //   var ngDD = await Statics.getGeoUnitsByLevelAndParent(
    //       Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
    //   setState(() {
    //     _linkednagar = (ngDD.length > 0 ? ngDD : null);
    //   });
    // } else {
    print("populatelinkedNagarDropdown Runnnn 222");

    var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
    print("Statics.levels['NagarLevelID'] ${Statics.levels['NagarLevelID']}");
    setState(() {
      _linkednagar = (ngDD.length > 0 ? ngDD : null);
    });
    // }
  }

  void populatelinkedMandalDropdown(String? nagarIDStr) async {
    print("populatelinkedMandalDropdown Runnnn");

    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
  }

  void populatelinkedGraamDropdown(String? mandalIDStr) async {
    print("populatelinkedGraamDropdown Runnnn");

    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
  }

  void populatelinkedVastiDropdown(String? nagarIDStr) async {
    print("populatelinkedVastiDropdown Runnnn");

    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', '');

    // print("vsDD ------  $vsDD");
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
      // print("vsDD ------  $_linkedvasti");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
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
                    Legend(legendString: "searchSewaVastiScreenLabel", fontsize: 18),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _sewaVastiNameCntrl,
                      decoration: InputDecoration(
                        labelText: Statics.getLabel('SewaVastiName'),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) return (Statics.getLabel('SewaVastiNameValidationMessage'));
                        return null;
                      },
                      onSaved: (value) {
                        sDetails!.sewaVastiName = value!.trim();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          if (_linkedMahaanagar != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                              isExpanded: true,
                              value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                              items: _linkedMahaanagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  print("mahanagar: $value");
                                  _linkedMahaanagarValue = value;
                                  _linkedVibhaagValue = null;

                                  _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
                                  type = "mahanagar";
                                  populatelinkedVibhaagDropdown(value);
                                });
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_linkedVibhaag != null && _linkedVibhaag!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                              isExpanded: true,
                              value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                              items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _linkedVibhaagValue = value;
                                  populatelinkedBhaagDropdown(value);
                                  print("vibhag: $value");
                                  type = "vibhag";
                                });
                              },
                            ),
                          if (_linkedVibhaag != null && _linkedVibhaag!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                              isExpanded: true,
                              value: _linkedbhaagValue == "" ? null : _linkedbhaagValue,
                              items: _linkedbhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _linkedbhaagValue = value;
                                  // populatelinkedShaharDropdown(value);
                                  populatelinkedNagarDropdown(value, null);
                                  print("bhag: $value");

                                  type = "bhag";
                                });
                              },
                            ),
                          if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          // if (_linkedshahar != null &&
                          //     _linkedshahar!.length > 0)
                          //   DropdownButtonFormField(
                          //     decoration: InputDecoration(
                          //         labelText: Statics.getLabel('Shahar')),
                          //     isExpanded: true,
                          //     value: _linkedshaharValue == ""
                          //         ? null
                          //         : _linkedshaharValue,
                          //     items: _linkedshahar!
                          //         .map((bg) => DropdownMenuItem(
                          //             value: bg.geoUnitID.toString(),
                          //             child: Text(bg.name!)))
                          //         .toList(),
                          //     onChanged: (value) {
                          //       setState(() {
                          //         _linkedshaharValue = value;
                          //         populatelinkedNagarDropdown(null, value);
                          //         print("shahar: $value");
                          //
                          //         type = "shahar";
                          //       });
                          //     },
                          //   ),
                          // if (_linkedshahar != null &&
                          //     _linkedshahar!.length > 0)
                          //   SizedBox(
                          //     height: 10,
                          //   ),
                          if (_linkednagar != null && _linkednagar!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: Statics.getLabel('Nagar'),
                              ),
                              isExpanded: true,
                              value: _linkednagarValue == "" ? null : _linkednagarValue,
                              items: _linkednagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _linkednagarValue = value;
                                  populatelinkedMandalDropdown(value);
                                  populatelinkedVastiDropdown(value);
                                  print("nagar: $value");
                                  type = "nagar";
                                });
                              },
                            ),
                          if (_linkednagar != null && _linkednagar!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          if (_linkedmandal != null && _linkedmandal!.length > 0)
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: Statics.getLabel('Mandal'),
                              ),
                              isExpanded: true,
                              value: (_linkedmandalValue != null && _linkedmandalValue!.isNotEmpty) ? _linkedmandalValue : null,
                              items: _linkedmandal?.map((bg) {
                                return DropdownMenuItem<String>(
                                  value: bg.geoUnitID.toString(),
                                  child: Text(bg.name ?? ''),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _linkedmandalValue = value;
                                  populatelinkedGraamDropdown(value);
                                  print("mandal: $value");
                                  type = "mandal";
                                });
                              },
                            ),

                          if (_linkedmandal != null && _linkedmandal!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          if (_linkedgraam != null && _linkedgraam!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Graam')),
                              isExpanded: true,
                              value: _linkedgraamValue == "" ? null : _linkedgraamValue,
                              items: _linkedgraam!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _linkedgraamValue = value;
                                  print("gram: $value");

                                  type = "gram";
                                });
                              },
                            ),
                          if (_linkedvasti != null && _linkedvasti!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Vasti')),
                              isExpanded: true,
                              value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                              items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _linkedvastiValue = value;
                                  print("vasti: $value");

                                  type = "vasti";
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                    // if(_bhaag != null)
                    // DropdownButtonFormField(
                    //   decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                    //   isExpanded: true,
                    //   value: _bhaagValue == "" ? null : _bhaagValue,
                    //   items: _bhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _bhaagValue = value;
                    //       populateShaharDropdown(value!);
                    //       populateNagarDropdown(value, null);
                    //     });
                    //   },
                    //   onSaved: (value) {
                    //     if (value != null && value.isNotEmpty)
                    //       sDetails!.bhaagID = int.parse(value);
                    //     else
                    //       sDetails!.bhaagID = null;
                    //   },
                    //   validator: (value) {
                    //     if ((value == null || value.isEmpty)) {
                    //       return Statics.getLabel('SelectBhaagValidationMessage');
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // if (_shahar != null && _shahar!.length > 0)
                    //   DropdownButtonFormField(
                    //     decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                    //     isExpanded: true,
                    //     value: _shaharValue == "" ? null : _shaharValue,
                    //     items: _shahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                    //     onChanged: (value) {
                    //       setState(() {
                    //         _shaharValue = value;
                    //         populateNagarDropdown(null, value);
                    //       });
                    //     },
                    //     onSaved: (value) {
                    //       if (value != null && value.isNotEmpty)
                    //         sDetails!.shaharID = int.parse(value);
                    //       else
                    //         sDetails!.shaharID = null;
                    //     },
                    //     validator: (value) {
                    //       if ((value == null || value.isEmpty)) {
                    //         return Statics.getLabel('SelectShaharValidationMessage');
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    // if (_shahar != null && _shahar!.length > 0)
                    //   SizedBox(
                    //     height: 10,
                    //   ),
                    // if (_nagar != null && _nagar!.length > 0)
                    //   DropdownButtonFormField(
                    //     decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                    //     isExpanded: true,
                    //     value: _nagarValue == "" ? null : _nagarValue,
                    //     items: _nagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                    //     onChanged: (value) {
                    //       setState(() {
                    //         _nagarValue = value;
                    //       });
                    //     },
                    //     onSaved: (value) {
                    //       if (value != null && value.isNotEmpty)
                    //         sDetails!.nagarID = int.parse(value);
                    //       else
                    //         sDetails!.nagarID = null;
                    //     },
                    //     validator: (value) {
                    //       if ((value == null || value.isEmpty)) {
                    //         return Statics.getLabel('SelectNagarValidationMessage');
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    // if (_nagar != null && _nagar!.length > 0)
                    //   SizedBox(
                    //     height: 30,
                    //   ),
                    Legend(legendString: 'Necessities', fontsize: 18),
                    Container(
                      width: Statics.getDeviceSize(context).width * 0.8,
                      child: ListView(
                        shrinkWrap: true,
                        children: _necessities.map((area) {
                          return new CheckboxListTile(
                            // dense: true,
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
                    SizedBox(height: 40),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _population,
                      decoration: InputDecoration(labelText: Statics.getLabel('Population')),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) return (Statics.getLabel('PopulationValidationMessage'));
                        return null;
                      },
                      onSaved: (value) {
                        sDetails!.population = value!.trim();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _remarkCntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('Remark')),
                      keyboardType: TextInputType.emailAddress,
                      maxLength: 100,
                      onSaved: (value) {
                        if (value!.isNotEmpty)
                          sDetails!.remark = value;
                        else
                          sDetails!.remark = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_isLoading)
                      CircularProgressIndicator()
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
        ),
        inAsyncCall: _isfetingData);
  }
}
