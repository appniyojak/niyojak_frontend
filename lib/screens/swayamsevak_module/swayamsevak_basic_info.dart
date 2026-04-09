import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../providers/bals.dart';
import '../../providers/swayamsevak_provider.dart';
import '../../widgets/legend.dart';

class SwayamsevakBasicInfo extends StatefulWidget {
  var swId;
  var onSaveSwDetails;
  final String viewType;
  final String? preFilledName;
  final String? preFilledMobile;
  final String? preFilledEmail;

  SwayamsevakBasicInfo({
    Key? key,
    required this.swId,
    required this.onSaveSwDetails,
    required this.viewType,
    this.preFilledName,
    this.preFilledMobile,
    this.preFilledEmail,
  }) : super(key: key);

  State<StatefulWidget> createState() {
    return new SwayamsevakBasicInfoState();
  }
}

class SwayamsevakBasicInfoState extends State<SwayamsevakBasicInfo> {
  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController emailController;
  late TextEditingController birthDateController;
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;

  bool _isfetingData = false;

  SwayamsevakBAL? swDetails;

  var _fullNameCntrl = TextEditingController();
  var _mobileCntrl = TextEditingController();
  var _emailCntrl = TextEditingController();
  var _birthDateCntrl = TextEditingController();

  DateTime? _birthDate;

  String? _bhaagValue = "";
  String? _shaharValue = "";
  String? _nagarValue = "";
  String? _mandalValue = "";
  String? _vastiValue = "";
  String? _graamValue = "";

  List<GeoUnitMasterBAL>? _bhaag;
  List<GeoUnitMasterBAL>? _shahar;
  List<GeoUnitMasterBAL>? _nagar;
  List<GeoUnitMasterBAL>? _mandal;
  List<GeoUnitMasterBAL>? _graam;
  List<GeoUnitMasterBAL>? _vasti;

  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<GeoUnitMasterBAL>? _linkedShaakhaa;

  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";
  String? _linkedShaakhaaValue = "";

  bool _canUseApp = false;

  @override
  void initState() {
    super.initState();
    int swID = int.parse(widget.swId.toString());
    populateDropdown();
    if (swID > 0) {
      getSwDetails(widget.swId);
    } else {
      if (!mounted) return;
      if (mounted)
        setState(() {
          swDetails = new SwayamsevakBAL(swID, 1, "", "", "", "", null, "", null, "", null, "", false, false);
        });
    }
    print("viewType ${widget.viewType} -- name ${widget.preFilledName} -- email ${widget.preFilledEmail} -- mobile ${widget.preFilledMobile}");
    // Initialize controllers with pre-filled data
    nameController = TextEditingController(text: widget.preFilledName ?? '');
    mobileController = TextEditingController(text: widget.preFilledMobile ?? '');
    emailController = TextEditingController(text: widget.preFilledEmail ?? '');
  }

  void getSwDetails(var theId) async {
    if (mounted)
      setState(() {
        _isfetingData = true;
      });
    var data;
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      data = await SwayamsevakProvider().getSwayamSevakByID(theId.toString(), "BasicInfo");
      if (!mounted) return;
      if (mounted)
        setState(() {
          swDetails = data;
          if (swDetails != null) {
            _fullNameCntrl.text = swDetails!.fullName.toString();
            _mobileCntrl.text = swDetails!.mobileNumber.toString();
            _emailCntrl.text = swDetails!.email.toString();

            _birthDate = ((swDetails!.birthDate != null && swDetails!.birthDate != "") ? (DateFormat('dd/MM/yyyy').parse(swDetails!.birthDate!.split(" ").first)) : null);
            _birthDateCntrl.text = ((swDetails!.birthDate != null && swDetails!.birthDate != "") ? DateFormat('dd-MMM-yyyy').format(_birthDate!) : '');

            var _geoUnitID = swDetails!.linkedGeoUnitID == null ? null : swDetails!.linkedGeoUnitID.toString();

            if (_geoUnitID != null) {
              getGeoUnitDets(_geoUnitID);
            }

            _linkedShaakhaaValue = swDetails!.linkedShaakhaaID == null ? null : swDetails!.linkedShaakhaaID.toString();

            if (_linkedShaakhaaValue != null) {
              getLinkedGeoUnitDets(_linkedShaakhaaValue);
            }

            _canUseApp = swDetails!.canUseApp!;
          }
        });
    }
    if (mounted)
      setState(() {
        _isfetingData = false;
      });
  }

  void getGeoUnitDets(geoUnitID) async {
    GeoUnitMasterBAL? geoUnitDets = await Statics.getGeoUnitsByID(geoUnitID);

    if (geoUnitDets != null) {
      _bhaagValue = (geoUnitDets.parentBhaagID == null ? null : geoUnitDets.parentBhaagID.toString());
      if (_bhaagValue != null) populateShaharDropdown(_bhaagValue!);

      _shaharValue = (geoUnitDets.parentShaharID == null ? null : geoUnitDets.parentShaharID.toString());
      if (_shaharValue != null || _bhaagValue != null) populateNagarDropdown(_bhaagValue, _shaharValue);

      _nagarValue = (geoUnitDets.parentNagarID == null ? null : geoUnitDets.parentNagarID.toString());
      if (_nagarValue != null) {
        populateMandalDropdown(_nagarValue!);
        populateVastiDropdown(_nagarValue!);
      }

      _mandalValue = (geoUnitDets.parentMandalID == null ? null : geoUnitDets.parentMandalID.toString());
      if (_mandalValue != null) populateGraamDropdown(_mandalValue!);

      _graamValue = (geoUnitDets.parentMandalID == null ? null : geoUnitDets.geoUnitID.toString());

      _vastiValue = (geoUnitDets.parentMandalID == null ? geoUnitDets.geoUnitID.toString() : null);
    }
  }

  void getLinkedGeoUnitDets(geoUnitID) async {
    GeoUnitMasterBAL? geoUnitDets = await Statics.getGeoUnitsByID(geoUnitID);

    if (geoUnitDets != null) {
      _linkedbhaagValue = geoUnitDets.parentBhaagID == null ? null : geoUnitDets.parentBhaagID.toString();
      if (_linkedbhaagValue != null) populatelinkedShaharDropdown(_linkedbhaagValue!);

      _linkedshaharValue = geoUnitDets.parentShaharID == null ? null : geoUnitDets.parentShaharID.toString();
      if (_linkedshaharValue != null || _bhaagValue != null) populatelinkedNagarDropdown(_linkedbhaagValue, _linkedshaharValue);

      _linkednagarValue = geoUnitDets.parentNagarID == null ? null : geoUnitDets.parentNagarID.toString();
      if (_linkednagarValue != null) {
        populatelinkedMandalDropdown(_linkednagarValue!);
        populatelinkedVastiDropdown(_linkednagarValue!);
      }

      _linkedmandalValue = geoUnitDets.parentMandalID == null ? null : geoUnitDets.parentMandalID.toString();
      if (_linkedmandalValue != null) populatelinkedGraamDropdown(_linkedmandalValue!);

      _linkedgraamValue = geoUnitDets.parentGraamID == null ? null : geoUnitDets.parentGraamID.toString();

      if (_linkedgraamValue != null) populatelinkedShaakhaDropdown(_linkedgraamValue!, "Graam");

      _linkedvastiValue = geoUnitDets.parentVastiID == null ? null : geoUnitDets.parentVastiID.toString();
      if (_linkedvastiValue != null) populatelinkedShaakhaDropdown(_linkedvastiValue!, "Vasti");
      _linkedShaakhaaValue = geoUnitID;
    }
  }

  _pickDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: _birthDate == null ? DateTime.now() : _birthDate!,
        firstDate: DateTime((_birthDate == null ? DateTime.now().year : _birthDate!.year) - 80),
        lastDate: DateTime((_birthDate == null ? DateTime.now().year : _birthDate!.year) + 80));

    if (date != null) {
      if (mounted)
        setState(() {
          _birthDate = date;
          _birthDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date);
        });
    }
  }

  // void populatelinkedBhaagDropdown() async {
  //   _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), "", "", "");
  //   print("populatelinkedBhaagDropdown ${data.toList()}");
  //   setState(() {
  //     _linkedbhaag = data;
  //   });
  // }
  void populatelinkedBhaagDropdown() async {
    _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), "", "", "");

    print("populatelinkedBhaagDropdown ${data.toList()}");

    if (mounted) {
      if (mounted)
        setState(() {
          _linkedbhaag = data;
        });
    } else {
      _linkedbhaag = data;
    }
  }

  void populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedshaharValue = _linkedvastiValue = _linkedshahar = _linkedvasti = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    if (mounted)
      setState(() {
        _linkedshahar = (shDD.length > 0 ? shDD : null);
      });
  }

  void populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      if (mounted)
        setState(() {
          _linkednagar = (ngDD.length > 0 ? ngDD : null);
        });
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      if (mounted)
        setState(() {
          _linkednagar = (ngDD.length > 0 ? ngDD : null);
        });
    }
  }

  void populatelinkedMandalDropdown(String nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    if (mounted)
      setState(() {
        _linkedmandal = (mnDD.length > 0 ? mnDD : null);
      });
  }

  void populatelinkedGraamDropdown(String mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    if (mounted)
      setState(() {
        _linkedgraam = (gmDD.length > 0 ? gmDD : null);
      });
  }

  void populatelinkedVastiDropdown(String nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    if (mounted)
      setState(() {
        _linkedvasti = (vsDD.length > 0 ? vsDD : null);
      });
  }

  void populatelinkedShaakhaDropdown(String iDStr, String strType) async {
    _linkedShaakhaaValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaakhaaLevelID'].toString(), iDStr, strType, '');
    if (mounted)
      setState(() {
        _linkedShaakhaa = (vsDD.length > 0 ? vsDD : null);
      });
  }

  Future<void> saveSwDetails() async {
    var inputData = json.encode({
      "BasicInfo": {
        "SwayamsevakID": int.parse(widget.swId.toString()),
        "PraantID": 1,
        "FullName": swDetails!.fullName,
        "MobileNumber": swDetails!.mobileNumber,
        "Email": swDetails!.email,
        "BirthDateStr": (_birthDate != null ? DateFormat('dd-MM-yyyy').format(_birthDate!) : null),
        "LinkedGeoUnitID": swDetails!.linkedGeoUnitID,
        "LinkedShaakhaaID": swDetails!.linkedShaakhaaID,
        "CanUseApp": _canUseApp,
      },
      "ModifiedBy": Statics.userDetails["userID"].toString()
    });

    var data = await SwayamsevakProvider().saveSwayamsevakDetails(inputData);
    if (mounted)
      setState(() {
        if (data == '-11') {
          Statics.showToast(Statics.getLabel('unableToCompleteProcess'));
        } else if (data == '-12') {
          Statics.showToast(Statics.getLabel('uniqueMobileNumberViolation'));
        } else {
          widget.swId = data;
          widget.onSaveSwDetails(widget.swId);
          Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
        }
      });
  }

  void populateDropdown() async {
    populateBhaagDropdown();
    populatelinkedBhaagDropdown();
  }

  void populateBhaagDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), "", "", "");

    if (mounted)
      setState(() {
        _bhaag = data;
      });
  }

  void populateShaharDropdown(String bhaagIDStr) async {
    _shaharValue = null;
    _vastiValue = null;
    _shahar = null;
    _vasti = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    if (mounted)
      setState(() {
        _shahar = (shDD.length > 0 ? shDD : null);
      });
  }

  void populateNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _nagarValue = null;
    _mandalValue = null;
    _graamValue = null;
    _vastiValue = null;
    _nagar = _mandal = _graam = _vasti = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      if (mounted)
        setState(() {
          _nagar = (ngDD.length > 0 ? ngDD : null);
        });
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      if (mounted)
        setState(() {
          _nagar = (ngDD.length > 0 ? ngDD : null);
        });
    }
  }

  void populateMandalDropdown(String nagarIDStr) async {
    _mandalValue = _graamValue = null;
    _mandal = _graam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    if (mounted)
      setState(() {
        _mandal = (mnDD.length > 0 ? mnDD : null);
      });
  }

  void populateGraamDropdown(String mandalIDStr) async {
    _graamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    if (mounted)
      setState(() {
        _graam = (gmDD.length > 0 ? gmDD : null);
      });
  }

  void populateVastiDropdown(String nagarIDStr) async {
    _vastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    if (mounted)
      setState(() {
        _vasti = (vsDD.length > 0 ? vsDD : null);
      });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    if (mounted)
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
      var msg = error.toString();
      if (mounted) {
        if (msg != '') Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
      } else
        Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    } catch (error) {
      print(error);
      if (mounted) {
        Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
      }
    }
    if (mounted) {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _fullNameCntrl.dispose();
    _mobileCntrl.dispose();
    _emailCntrl.dispose();
    _birthDateCntrl.dispose();
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
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
                    Legend(legendString: 'BasicInfo', fontsize: 18),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: widget.viewType == 'JoinRss' ? nameController : _fullNameCntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('FullName')),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) return (Statics.getLabel('FullNameValidationMessage'));
                        return null;
                      },
                      onSaved: (value) {
                        swDetails!.fullName = value!.trim();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: widget.viewType == 'JoinRss' ? mobileController : _mobileCntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('Mobile')),
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      validator: (value) {
                        if (value!.isEmpty || value.trim().length < 10) return (Statics.getLabel('MobileValidationMessage'));
                        return null;
                      },
                      onSaved: (value) {
                        swDetails!.mobileNumber = value!.trim();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: widget.viewType == 'JoinRss' ? emailController : _emailCntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('Email')),
                      keyboardType: TextInputType.emailAddress,
                      maxLength: 100,
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          if (!value.contains('@')) return (Statics.getLabel('EmailValidationMessage'));
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value!.isNotEmpty)
                          swDetails!.email = value.trim();
                        else
                          swDetails!.email = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: Statics.getDeviceSize(context).width * 0.7,
                          child: TextFormField(
                            readOnly: true,
                            controller: _birthDateCntrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('BirthDate')),
                            textInputAction: TextInputAction.next,
                            // controller: widget.viewType == 'JoinRss' ? emailController : _emailCntrl,
                            // maxLength: 100,
                            validator: (value) {
                              if (value == null || value.toString().trim().isEmpty || value.trim() == "") {
                                return (Statics.getLabel('DobValidationMessage'));
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value!.isNotEmpty)
                                swDetails!.birthDate = value.trim();
                              else
                                swDetails!.birthDate = null;
                            },
                          ),
                        ),
                        IconButton(
                          color: Colors.purple,
                          icon: FaIcon(FontAwesomeIcons.solidCalendarAlt),
                          onPressed: _pickDate,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Legend(legendString: 'LinkedGeoUnit', fontsize: 18),
                    Container(
                      //margin: EdgeInsets.all(10),
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
                                    onPressed: () {
                                      setState(() {
                                        _bhaagValue = _shaharValue = _nagarValue = _mandalValue = _graamValue = _vastiValue = null;
                                        _bhaag = _shahar = _nagar = _mandal = _graam = _vasti = null;
                                      });
                                      populateBhaagDropdown();
                                    },
                                    child: Text(
                                      Statics.getLabel('clear'),
                                      style: TextStyle(fontSize: 12),
                                    )),
                              ),
                            ],
                          ),
                          if (_bhaag != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                              isExpanded: true,
                              value: _bhaagValue == "" ? null : _bhaagValue,
                              items: _bhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              validator: (value) {
                                if ((value == null || value.isEmpty)) {
                                  return Statics.getLabel('SelectBhaagValidationMessage');
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _bhaagValue = value;
                                  populateShaharDropdown(value!);
                                  populateNagarDropdown(value, null);
                                  if (widget.swId == "0") {
                                    _linkedbhaagValue = value;
                                    populatelinkedShaharDropdown(value);
                                    populatelinkedNagarDropdown(value, null);
                                  }
                                });
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_shahar != null && _shahar!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                              isExpanded: true,
                              value: _shaharValue == "" ? null : _shaharValue,
                              items: _shahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              validator: (value) {
                                if ((value == null || value.isEmpty)) {
                                  return Statics.getLabel('SelectShaharValidationMessage');
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _shaharValue = value;
                                  populateNagarDropdown(null, value);
                                  if (widget.swId == "0") {
                                    _linkedshaharValue = value;
                                    populatelinkedNagarDropdown(null, value);
                                  }
                                });
                              },
                            ),
                          if (_shahar != null && _shahar!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          if (_nagar != null && _nagar!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                              isExpanded: true,
                              value: _nagarValue == "" ? null : _nagarValue,
                              items: _nagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              validator: (value) {
                                if ((value == null || value.isEmpty)) {
                                  return Statics.getLabel('SelectNagarValidationMessage');
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _nagarValue = value;
                                  populateMandalDropdown(value!);
                                  populateVastiDropdown(value!);
                                  if (widget.swId == "0") {
                                    _linkednagarValue = value;
                                    populatelinkedMandalDropdown(value);
                                    populatelinkedVastiDropdown(value);
                                  }
                                });
                              },
                            ),
                          if (_nagar != null && _nagar!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          if (_mandal != null && _mandal!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Mandal')),
                              isExpanded: true,
                              value: _mandalValue == "" ? null : _mandalValue,
                              items: _mandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              validator: (value) {
                                if ((value == null || value.isEmpty)) {
                                  return Statics.getLabel('SelectMandalValidationMessage');
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _mandalValue = value;
                                  populateGraamDropdown(value!);
                                  if (widget.swId == "0") {
                                    _linkedmandalValue = value;
                                    populatelinkedGraamDropdown(value);
                                  }
                                });
                              },
                            ),
                          if (_mandal != null && _mandal!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_vasti != null && _vasti!.length > 0)
                      DropdownButtonFormField(
                        decoration: InputDecoration(labelText: Statics.getLabel('SelectVasti')),
                        isExpanded: true,
                        value: _vastiValue == ""
                            ? null
                            : _vasti != null
                                ? _vasti!.indexWhere((p) => p.geoUnitID.toString() == _vastiValue) > -1
                                    ? _vastiValue
                                    : null
                                : null,
                        items: _vasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                        validator: (value) {
                          if ((value == null || value.isEmpty) && (_graamValue == null || _graamValue!.isEmpty)) {
                            return Statics.getLabel('VastiValidationMessage');
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _vastiValue = value;
                            if (widget.swId == "0") {
                              _linkedvastiValue = value;
                              populatelinkedShaakhaDropdown(value!, "Vasti");
                            }
                          });
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty)
                            swDetails!.linkedGeoUnitID = int.parse(value);
                          else
                            swDetails!.linkedGeoUnitID = null;
                        },
                      ),
                    if (_vasti != null && _vasti!.length > 0)
                      SizedBox(
                        height: 10,
                      ),
                    if (_graam != null && _graam!.length > 0)
                      DropdownButtonFormField(
                        decoration: InputDecoration(labelText: Statics.getLabel('SelectGraam')),
                        isExpanded: true,
                        value: _graamValue == "" ? null : _graamValue,
                        items: _graam!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                        validator: (value) {
                          if ((value == null || value.isEmpty) && (_vastiValue == null || _vastiValue!.isEmpty)) {
                            return Statics.getLabel('SelectGraamValidationMessage');
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _graamValue = value;
                            if (widget.swId == "0") {
                              _linkedgraamValue = value;
                              populatelinkedShaakhaDropdown(value!, "Graam");
                            }
                          });
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty)
                            swDetails!.linkedGeoUnitID = int.parse(value);
                          else
                            swDetails!.linkedGeoUnitID = null;
                        },
                      ),
                    SizedBox(height: 20),
                    Legend(legendString: "LinkedShaakhaa", fontsize: 18),
                    SizedBox(height: 10),
                    Container(
                      //margin: EdgeInsets.all(20),
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
                                  onPressed: () {
                                    setState(() {
                                      _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = _linkedShaakhaaValue = null;
                                      _linkedbhaag = _linkedshahar = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = _linkedShaakhaa = null;
                                    });
                                    populateBhaagDropdown();
                                  },
                                  child: Text(Statics.getLabel("clear"), style: TextStyle(fontSize: 12)),
                                ),
                              ),
                            ],
                          ),
                          if (_linkedbhaag != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                              isExpanded: true,
                              value: _linkedbhaagValue == "" ? null : _linkedbhaagValue,
                              items: _linkedbhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _linkedbhaagValue = value;
                                  populatelinkedShaharDropdown(value!);
                                  populatelinkedNagarDropdown(value, null);
                                });
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_linkedshahar != null && _linkedshahar!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                              isExpanded: true,
                              value: _linkedshaharValue == "" ? null : _linkedshaharValue,
                              items: _linkedshahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _linkedshaharValue = value;
                                  populatelinkedNagarDropdown(null, value);
                                });
                              },
                            ),
                          if (_linkedshahar != null && _linkedshahar!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          if (_linkednagar != null && _linkednagar!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                              isExpanded: true,
                              value: _linkednagarValue == "" ? null : _linkednagarValue,
                              items: _linkednagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _linkednagarValue = value;
                                  populatelinkedMandalDropdown(value!);
                                  populatelinkedVastiDropdown(value);
                                });
                              },
                            ),
                          if (_linkednagar != null && _linkednagar!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          if (_linkedmandal != null && _linkedmandal!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Mandal')),
                              isExpanded: true,
                              value: _linkedmandalValue == "" ? null : _linkedmandalValue,
                              items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _linkedmandalValue = value;
                                  populatelinkedGraamDropdown(value!);
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
                                  populatelinkedShaakhaDropdown(value!, "Graam");
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
                                  populatelinkedShaakhaDropdown(value!, "Vasti");
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                    if (_linkedShaakhaa != null && _linkedShaakhaa!.length > 0)
                      DropdownButtonFormField(
                        decoration: InputDecoration(labelText: Statics.getLabel('LinkedShaakhaa')),
                        isExpanded: true,
                        value: _linkedShaakhaaValue == "" ? null : _linkedShaakhaaValue,
                        items: _linkedShaakhaa!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _linkedShaakhaaValue = value;
                          });
                        },
                        // validator: (value) {
                        //   if ((value == null || value.isEmpty) &&
                        //       (_linkedShaakhaaValue == null ||
                        //           _linkedShaakhaaValue.isEmpty)) {
                        //     return Statics.getLabel(
                        //         'ShaakhaaNameValidationMessage');
                        //   }
                        //   return null;
                        // },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty)
                            swDetails!.linkedShaakhaaID = int.parse(value);
                          else
                            swDetails!.linkedShaakhaaID = null;
                        },
                      ),
                    if (_linkedShaakhaa != null && _linkedShaakhaa!.length > 0)
                      SizedBox(
                        height: 10,
                      ),
                    // AbsorbPointer(
                    //   absorbing: (((Statics.userDetails["LevelName"] == "Bhaag" ||
                    //                       Statics.userDetails["LevelName"] == "भाग/जिल्हा" ||
                    //                       Statics.userDetails["LevelName"] == "Nagar" ||
                    //                       Statics.userDetails["LevelName"] == "Nagar\/Taalukaa" ||
                    //                       Statics.userDetails["LevelName"] == "नगर/तालुका" ||
                    //                       Statics.userDetails["LevelName"] == "Vibhaag" ||
                    //                       Statics.userDetails["LevelName"] == "विभाग" ||
                    //                       Statics.userDetails['LevelName'] == 'Mahaanagar' ||
                    //                       Statics.userDetails['LevelName'] == 'महानगर' ||
                    //                       Statics.userDetails["LevelName"] == "Praant" ||
                    //                       Statics.userDetails["LevelName"] == "प्रांत") &&
                    //                   (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
                    //                       Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
                    //                       Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
                    //                       Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
                    //                       Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" ||
                    //                       Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
                    //                       Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh" ||
                    //                       Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
                    //                       Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh" ||
                    //                       Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
                    //                       Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh" ||
                    //                       Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
                    //                       Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" ||
                    //                       Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
                    //                       Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
                    //                       Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" ||
                    //                       Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
                    //                       Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
                    //                       Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" ||
                    //                       Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
                    //                       Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
                    //                       Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" ||
                    //                       Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
                    //                       Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
                    //                       Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" ||
                    //                       Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
                    //                       Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
                    //                       Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" ||
                    //                       Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
                    //                       Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
                    //                       Statics.userDetails["DaayitvaName"] == "App Sanyojak" ||
                    //                       Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
                    //                       Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
                    //                       Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
                    //                       Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
                    //                       Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
                    //                       Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
                    //                       Statics.userDetails["DaayitvaName"] == "सह कार्यवाह" ||
                    //                       Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' ||
                    //                       Statics.userDetails['DaayitvaName'] == 'कार्यालय प्रमुख')) ||
                    //               (Statics.userDetails['LevelName'] == 'Praant' ||
                    //                   Statics.userDetails['LevelName'] == 'प्रांत' && Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
                    //                   Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
                    //                   Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
                    //                   Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
                    //                   Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" ||
                    //                   Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
                    //                   Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh" ||
                    //                   Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
                    //                   Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh" ||
                    //                   Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
                    //                   Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh" ||
                    //                   Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
                    //                   Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" ||
                    //                   Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
                    //                   Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
                    //                   Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" ||
                    //                   Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
                    //                   Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
                    //                   Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" ||
                    //                   Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
                    //                   Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
                    //                   Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" ||
                    //                   Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
                    //                   Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
                    //                   Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" ||
                    //                   Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
                    //                   Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
                    //                   Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" ||
                    //                   Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
                    //                   Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
                    //                   Statics.userDetails["DaayitvaName"] == "App Sanyojak" ||
                    //                   Statics.userDetails["DaayitvaName"] == "एप संयोजक") ||
                    //               (Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
                    //                   Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
                    //                   Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||
                    //                   Statics.userDetails['DaayitvaName'] == 'सह प्रचारक')) ==
                    //           true
                    //       ? false
                    //       : true,
                    //   child:
                    CheckboxListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(Statics.getLabel('CanUseApp'), style: TextStyle(fontSize: 15)),
                        checkColor: Colors.white,
                        activeColor: Colors.purple,
                        value: _canUseApp == null ? false : _canUseApp,
                        onChanged: (value) {
                          setState(() {
                            _canUseApp = value!;
                          });
                        }),
                    // ),
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
