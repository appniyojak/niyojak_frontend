import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../providers/bals.dart';
import '../../providers/swayamsevak_provider.dart';
import '../../widgets/legend.dart';

class SwayamsevakOtherInfo extends StatefulWidget {
  var swId;
  var onSaveSwDetails;
  var viewType;

  SwayamsevakOtherInfo({Key? key, this.swId, this.onSaveSwDetails, this.viewType}) : super(key: key);

  State<StatefulWidget> createState() {
    return new SwayamsevakOtherInfoState();
  }
}

class SwayamsevakOtherInfoState extends State<SwayamsevakOtherInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  bool _isfetingData = false;

  List<StateMasterBAL>? _curState;

  String? _curStateValue = "";
  bool _isPratidnyit = false;

  // bool _isGanaveshComplete = true;
  bool _has2Wheeler = false;
  bool _has3Wheeler = false;
  bool _has4Wheeler = false;
  bool _hasVehicleDriver = false;

  List<StateMasterBAL>? _permanantState;

  String? _permanantStateValue = "";

  List<dynamic>? _curDistrict;
  String? _curDistrictValue = null;

  List<dynamic>? _permanantDistrict;
  String? _permanantDistrictValue = "";

  String? _bldGrpvalue = "";
  String? _bldGrpCode = "";
  String? _mthrTngvalue = "";
  String? _prfrdLangvalue = "";
  String? _fbUsage = "";
  String? _instaUsage = "";
  String? _kooUsage = "";
  String? _twtUsage = "";

  String? _preritSansthaValue = "";

  SwayamsevakOtherInfoBAL? swOtherInfo;

  List<StaticMasterBAL>? _bldGroupList;
  List<StaticMasterBAL>? _motherTongue;
  List<StaticMasterBAL>? _prfrdLang;

  var _curAddressLine1Cntrl = TextEditingController();
  var _curAddressLine2Cntrl = TextEditingController();
  var _curGraamCityCntrl = TextEditingController();
  var _curPostOfficeCntrl = TextEditingController();

  //var _curCityCntrl = TextEditingController();
  //var _curDistrictCtrl = TextEditingController();
  var _curPinCodeCtrl = TextEditingController();

  var _permanantAddressLine1Cntrl = TextEditingController();
  var _permanantAddressLine2Cntrl = TextEditingController();
  var _permanantGraamCityCntrl = TextEditingController();
  var _permanantPostOfficeCntrl = TextEditingController();

  //var _permanantCityCntrl = TextEditingController();
  //var _permanantDistrictCtrl = TextEditingController();
  var _permanantPinCodeCtrl = TextEditingController();

  var _preritDesgCtrl = TextEditingController();
  var _preritRemarkCtrl = TextEditingController();
  var _othOrgNameCtrl = TextEditingController();
  var _othDesgCtrl = TextEditingController();
  var _othRemarksCtrl = TextEditingController();

  var _othLangCntrl = TextEditingController();
  var _faceBookPageCntrl = TextEditingController();

  bool? _sameAsCurrentAddress = false;

  var _pratidnyaYearCtrl = TextEditingController();

  //var _shaakhaaExperienceCtrl = TextEditingController();
  List<StaticMasterBAL>? _shaakhaSanchalan;
  List<dynamic>? _sanghaPreritSanstha;
  String? _shaakhaSanchalanvalue = "";

  // DateTime? _birthDate;

  // var _birthDateCntrl = TextEditingController();
  var _sanghaPraveshYearCtrl = TextEditingController();

  int _feildNum = 0;

  List<DropdownMenuItem<String>> _fieldType = [
    new DropdownMenuItem(child: Text(Statics.getLabel("SecondaryMobile")), value: "SecondaryMobile"),
    new DropdownMenuItem(child: Text(Statics.getLabel("OfficePhone")), value: "OfficePhone"),
    new DropdownMenuItem(child: Text(Statics.getLabel("HomePhone")), value: "HomePhone"),
    new DropdownMenuItem(child: Text(Statics.getLabel("WhatsAppNumber")), value: "WhatsAppNumber"),
  ];

  String _firstFieldValue = "";
  String _secondFieldValue = "";
  String _thirdFieldValue = "";
  String _fourthFieldValue = "";

  bool _shwFirstField = false;
  bool _shwSecondField = false;
  bool _shwThirdField = false;
  bool _shwfourthField = false;

  var _txtNumber1Ctrl = TextEditingController();
  var _txtNumber2Ctrl = TextEditingController();
  var _txtNumber3Ctrl = TextEditingController();
  var _txtNumber4Ctrl = TextEditingController();
  var _txtSecondayEmailCtrl = TextEditingController();
  var _txtTwitterHandleCtrl = TextEditingController();
  var _txtInstagramHandleCtrl = TextEditingController();
  var _txtKooHandleCtrl = TextEditingController();

  bool _hasCap = false;
  bool _hasShirt = false;
  bool _hasPant = false;
  bool _hasBelt = false;
  bool _hasShoes = false;
  bool _hasSocks = false;
  bool _hasDanda = true;

  // bool _hasbeenVistarak = false;
  //bool _hasBeenPrachaarak = false;

  bool _hasShaakhaaExperience = false;
  bool _hasBaalShaakhaaExperience = false;
  bool _hasTarunVidShaakhaaExperience = false;
  bool _hasTarunVyavShaakhaaExperience = false;
  bool _hasProudhaVyavShaakhaaExperience = false;

  bool _hasShaakhaaOpeningExperience = false;
  bool _hasBaalShaakhaaOpeningExperience = false;
  bool _hasTarunVidShaakhaaOpeningExperience = false;
  bool _hasTarunVyavShaakhaaOpeningExperience = false;
  bool _hasProudhaVyavShaakhaaOpeningExperience = false;

  //var _txtMaxDaayitvaCtrl = TextEditingController();
  // var _txtVistaarakWeekCountCtrl = TextEditingController();
  // var _txtVistaarakMonthCountCtrl = TextEditingController();
  // var _txtVistaarakYearCountCtrl = TextEditingController();
  // var _txtPrachaarakYearCountCtrl = TextEditingController();

  List<DropdownMenuItem<String>> _usage = [
    new DropdownMenuItem(child: Text(Statics.getLabel('SocialMediaUsageNone')), value: "None"),
    new DropdownMenuItem(child: Text(Statics.getLabel('SocialMediaUsageLow')), value: "Low"),
    new DropdownMenuItem(child: Text(Statics.getLabel('SocialMediaUsageMedium')), value: "Medium"),
    new DropdownMenuItem(child: Text(Statics.getLabel('SocialMediaUsageHigh')), value: "High"),
  ];

  List<AreaOfExpertiseBAL> _areaOfExpertise = [];
  List<AreaOfInterestBAL> _areaOfInterest = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      populateDropdown();
    });
    int swID = int.parse(widget.swId);
    print("swID -->  $swID");

    if (swID > 0) {
      getSwDetails(widget.swId);
    } else {
      if (!mounted) return;
      setState(() {
        swOtherInfo = new SwayamsevakOtherInfoBAL(
            swID,
            0,
            1,
            "",
            "",
            "",
            "",
            null,
            "",
            null,
            "",
            "",
            "",
            "",
            null,
            "",
            null,
            false,
            null,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            null,
            "",
            null,
            "",
            "",
            null,
            "",
            "",
            "",
            "",
            false,
            false,
            false,
            false,
            false,
            null,
            false,
            false,
            false,
            false,
            false,
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            false,
            false,
            null,
            null,
            null,
            null,
            "");
      });
      populateAreaDetails();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _curAddressLine1Cntrl.dispose();
    _curAddressLine2Cntrl.dispose();
    _curGraamCityCntrl.dispose();
    _curPostOfficeCntrl.dispose();
    //_curCityCntrl.dispose();
    //_curDistrictCtrl.dispose();
    _curPinCodeCtrl.dispose();
    _permanantAddressLine1Cntrl.dispose();
    _permanantAddressLine2Cntrl.dispose();
    _permanantGraamCityCntrl.dispose();
    _permanantPostOfficeCntrl.dispose();
    //_permanantCityCntrl.dispose();
    // _permanantDistrictCtrl.dispose();
    _permanantPinCodeCtrl.dispose();
    _pratidnyaYearCtrl.dispose();
    //_shaakhaaExperienceCtrl.dispose();
    // _birthDateCntrl.dispose();
    _sanghaPraveshYearCtrl.dispose();
    _preritDesgCtrl.dispose();
    _preritRemarkCtrl.dispose();
    _othOrgNameCtrl.dispose();
    _othDesgCtrl.dispose();
    _othRemarksCtrl.dispose();
    _txtNumber1Ctrl.dispose();
    _txtNumber2Ctrl.dispose();
    _txtNumber3Ctrl.dispose();
    _txtNumber4Ctrl.dispose();
    _txtSecondayEmailCtrl.dispose();
    _faceBookPageCntrl.dispose();
    _txtTwitterHandleCtrl.dispose();
    _txtInstagramHandleCtrl.dispose();
    _txtKooHandleCtrl.dispose();

    //_txtMaxDaayitvaCtrl.dispose();
    // _txtVistaarakMonthCountCtrl.dispose();
    // _txtVistaarakWeekCountCtrl.dispose();
    // _txtVistaarakYearCountCtrl.dispose();
    // _txtPrachaarakYearCountCtrl.dispose();
  }

  void getSwDetails(var theId) async {
    setState(() {
      _isfetingData = true;
    });
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      var data = await SwayamsevakProvider().getSwayamSevakByID(theId, "OtherInfo");
      if (!mounted) return;
      setState(() {
        swOtherInfo = data;
        if (swOtherInfo != null) {
          _curAddressLine1Cntrl.text = (swOtherInfo?.currentAddressLine1 ?? "").toString();
          _curAddressLine2Cntrl.text = (swOtherInfo?.currentAddressLine2 ?? "").toString();
          _curGraamCityCntrl.text = (swOtherInfo?.currentGraamCityName ?? "").toString();
          _curPostOfficeCntrl.text = (swOtherInfo?.currentPostOffice ?? "").toString();

          _curPinCodeCtrl.text = (swOtherInfo?.currentPinCode ?? "").toString();
          _curStateValue = (swOtherInfo?.currentStateID ?? "").toString();

          _permanantAddressLine1Cntrl.text = (swOtherInfo?.permanentAddressLine1 ?? "").toString();
          _permanantAddressLine2Cntrl.text = (swOtherInfo?.permanentAddressLine2 ?? "").toString();
          _permanantGraamCityCntrl.text = (swOtherInfo?.permanentGraamCityName ?? "").toString();
          _permanantPostOfficeCntrl.text = (swOtherInfo?.permanentPostOffice ?? "").toString();

          _permanantPinCodeCtrl.text = (swOtherInfo?.permanentPinCode ?? "").toString();
          _permanantStateValue = swOtherInfo?.permanentStateID == null ? null : swOtherInfo?.permanentStateID.toString();

          _isPratidnyit = swOtherInfo?.isPratidnyit ?? false;
          _pratidnyaYearCtrl.text = (swOtherInfo?.pratidnyaYear ?? "").toString();

          _hasCap = swOtherInfo?.hasCap ?? false;
          _hasShirt = swOtherInfo?.hasShirt ?? false;
          _hasBelt = swOtherInfo?.hasBelt ?? false;
          print("_hasBelt = swOtherInfo?.hasBelt ?? false;  $_hasBelt");
          _hasPant = swOtherInfo?.hasPant ?? false;
          _hasShoes = swOtherInfo?.hasShoes ?? false;
          _hasSocks = swOtherInfo?.hasSocks ?? false;
          _hasDanda = swOtherInfo?.hasDanda ?? false;

          _has2Wheeler = swOtherInfo?.has2WVehicle ?? false;
          _has3Wheeler = swOtherInfo?.has3WVehicle ?? false;
          _has4Wheeler = swOtherInfo?.has4WVehicle ?? false;
          _hasVehicleDriver = swOtherInfo?.hasVehicleDriver ?? false;

          _bldGrpvalue = swOtherInfo?.bloodGroupID == null ? null : swOtherInfo!.bloodGroupID.toString();

          _bldGrpCode = swOtherInfo?.bloodGroupCode == null ? null : swOtherInfo!.bloodGroupCode.toString();

          _mthrTngvalue = swOtherInfo?.motherTongueID == null ? null : swOtherInfo!.motherTongueID.toString();

          _othLangCntrl.text = (swOtherInfo?.motherTongueCode ?? "").toString();

          _faceBookPageCntrl.text = (swOtherInfo?.facebookUsage ?? "").toString();

          // _birthDate = ((swOtherInfo!.birthDate != null && swOtherInfo!.birthDate != "") ? DateTime.parse(swOtherInfo!.birthDate!) : null);
          // _birthDateCntrl.text = ((swOtherInfo!.birthDate != null && swOtherInfo!.birthDate != "") ? DateFormat('dd-MMM-yyyy').format(_birthDate!) : '');

          _sanghaPraveshYearCtrl.text = (swOtherInfo?.sanghaPraveshYear ?? "").toString();

          _fbUsage = swOtherInfo!.facebookUsage == null ? null : swOtherInfo!.facebookUsage.toString();

          _twtUsage = swOtherInfo!.twitterUsage == null ? null : swOtherInfo!.twitterUsage.toString();

          _instaUsage = swOtherInfo!.instagramUsage == null ? null : swOtherInfo!.instagramUsage.toString();

          _kooUsage = swOtherInfo!.kooUsage == null ? null : (swOtherInfo?.kooUsage ?? "");

          _hasShaakhaaExperience = swOtherInfo?.hasShaakhaaExperience ?? false;
          _hasBaalShaakhaaExperience = swOtherInfo?.hasBaalShaakhaaExperience ?? false;
          _hasTarunVyavShaakhaaExperience = swOtherInfo?.hasTarunVyavasaayeeShaakhaaExperience ?? false;
          _hasTarunVidShaakhaaExperience = swOtherInfo?.hasTarunVidyaarthiShaakhaaExperience ?? false;
          _hasProudhaVyavShaakhaaExperience = swOtherInfo?.hasProudhaVyavasaayeeShaakhaaExperience ?? false;

          _shaakhaSanchalanvalue = (swOtherInfo?.shaakhaaExperienceYearID ?? "").toString();

          _hasShaakhaaOpeningExperience = swOtherInfo?.hasShaakhaaOpeningExperience ?? false;
          _hasBaalShaakhaaOpeningExperience = swOtherInfo?.hasBaalShaakhaaOpeningExperience ?? false;
          _hasTarunVyavShaakhaaOpeningExperience = swOtherInfo?.hasTarunVyavasaayeeShaakhaaOpeningExperience ?? false;
          _hasTarunVidShaakhaaOpeningExperience = swOtherInfo?.hasTarunVidyaarthiShaakhaaOpeningExperience ?? false;
          _hasProudhaVyavShaakhaaOpeningExperience = swOtherInfo?.hasProudhaVyavasaayeeShaakhaaOpeningExperience ?? false;

          _txtNumber1Ctrl.text = (swOtherInfo?.secondaryMobileNumber ?? "").toString();

          _txtNumber2Ctrl.text = (swOtherInfo?.officePhoneNumber ?? "").toString();

          _txtNumber3Ctrl.text = (swOtherInfo?.homePhoneNumber ?? "").toString();

          _txtNumber4Ctrl.text = (swOtherInfo?.whatsAppNumber ?? "").toString();

          _txtSecondayEmailCtrl.text = (swOtherInfo?.secondaryEmail ?? "").toString();

          _txtInstagramHandleCtrl.text = (swOtherInfo?.instagramHandle ?? "").toString();

          _txtKooHandleCtrl.text = (swOtherInfo?.kooHandle ?? "").toString();

          _txtTwitterHandleCtrl.text = (swOtherInfo?.twitterHandle ?? "").toString();

          _faceBookPageCntrl.text = (swOtherInfo?.facebookPage ?? "").toString();

          _feildNum = 0;
          _shwFirstField = false;
          _shwSecondField = false;
          _shwThirdField = false;
          _shwfourthField = false;

          if (_txtNumber1Ctrl.text.isNotEmpty) {
            _shwFirstField = true;
            _feildNum = _feildNum + 1;
            _firstFieldValue = "SecondaryMobile";
          }

          if (_txtNumber2Ctrl.text.isNotEmpty) {
            _shwSecondField = true;
            _feildNum = _feildNum + 1;
            _secondFieldValue = "OfficePhone";
          }

          if (_txtNumber3Ctrl.text.isNotEmpty) {
            _shwThirdField = true;
            _feildNum = _feildNum + 1;
            _thirdFieldValue = "HomePhone";
          }

          if (_txtNumber4Ctrl.text.isNotEmpty) {
            _shwfourthField = true;
            _feildNum = _feildNum + 1;
            _fourthFieldValue = "WhatsAppNumber";
          }

          // _txtMaxDaayitvaCtrl.text = swOtherInfo!.maxDaayitva == null
          //     ? null
          //     : swOtherInfo!.maxDaayitva.toString();

          // _hasBeenPrachaarak =
          //     swOtherInfo!.hasBeenPrachaarak ?? false;

          // _hasbeenVistarak =
          //     swOtherInfo!.hasBeenVistaarak ?? false;

          // _txtVistaarakMonthCountCtrl.text =
          //     swOtherInfo!.vistaarakMonthCount == null
          //         ? null
          //         : swOtherInfo!.vistaarakMonthCount.toString();

          // _txtVistaarakWeekCountCtrl.text =
          //     swOtherInfo!.vistaarakWeekCount == null
          //         ? null
          //         : swOtherInfo!.vistaarakWeekCount.toString();

          // _txtVistaarakYearCountCtrl.text =
          //     swOtherInfo!.vistaarakYearCount == null
          //         ? null
          //         : swOtherInfo!.vistaarakYearCount.toString();

          // _txtPrachaarakYearCountCtrl.text =
          //     swOtherInfo!.prachaarakYearCount == null
          //         ? null
          //         : swOtherInfo!.prachaarakYearCount.toString();
        }
      });
    }
    await populateAreaDetails();
    await populateDistrictDetails();
    setState(() {
      _isfetingData = false;
    });
  }

  populateDistrictDetails() async {
    await populateDistrict(_curStateValue, "Current");
    setState(() {
      if (swOtherInfo!.currentDistrictID != null) {
        _curDistrictValue = swOtherInfo!.currentDistrictID.toString();
      }
    });

    await populateDistrict(_permanantStateValue, "Permanent");
    setState(() {
      if (swOtherInfo!.permanentDistrictID != null) {
        _permanantDistrictValue = swOtherInfo!.permanentDistrictID.toString();
      }
    });
  }

  populateAreaDetails() async {
    var aoi = await Statics.getStaticLDB("AreaOfInterest");
    var aoe = await Statics.getStaticLDB("AreaOfExpertise");
    _areaOfInterest = [];
    _areaOfExpertise = [];
    var aoiArr = (swOtherInfo == null || swOtherInfo!.areasOfInterestIDs == null) ? [] : swOtherInfo!.areasOfInterestIDs!.split(',');
    var aoeArr = (swOtherInfo == null || swOtherInfo!.areasOfInterestIDs == null) ? [] : swOtherInfo!.areasOfExpertiseIDs!.split(',');
    for (var data in aoi) {
      _areaOfInterest.add(new AreaOfInterestBAL(data.staticID, data.code, data.codeForDisplay, (aoiArr.contains(data.staticID.toString()) ? true : false)));
    }

    for (var data in aoe) {
      _areaOfExpertise.add(new AreaOfExpertiseBAL(data.staticID, data.code, data.codeForDisplay, (aoeArr.contains(data.staticID.toString()) ? true : false)));
    }
  }

  saveSwDetails() async {
    var areaOfInterestIDs = '';
    var areaOfExpertiseIDs = '';

    for (var data in _areaOfInterest) {
      if (data.isSelected!) areaOfInterestIDs = areaOfInterestIDs + data.staticID.toString() + ",";
    }

    for (var data in _areaOfExpertise) {
      if (data.isSelected!) areaOfExpertiseIDs = areaOfExpertiseIDs + data.staticID.toString() + ",";
    }

    if (areaOfInterestIDs.trim() != '') areaOfInterestIDs = areaOfInterestIDs.substring(0, areaOfInterestIDs.length - 1);

    if (areaOfExpertiseIDs.trim() != '') areaOfExpertiseIDs = areaOfExpertiseIDs.substring(0, areaOfExpertiseIDs.length - 1);

    var inputData = json.encode({
      "OtherInfo": {
        "SwayamsevakID": int.parse(widget.swId),
        "PraantID": 1,
        "CurrentAddressLine1": swOtherInfo?.currentAddressLine1,
        "CurrentAddressLine2": swOtherInfo?.currentAddressLine2,
        "CurrentGraamName": swOtherInfo?.currentGraamCityName,
        "CurrentPostOffice": swOtherInfo?.currentPostOffice,
        "CurrentDistrictID": swOtherInfo?.currentDistrictID,
        "CurrentPinCode": swOtherInfo?.currentPinCode,
        "CurrentStateID": swOtherInfo?.currentStateID,
        "PermanentAddressLine1": swOtherInfo?.permanentAddressLine1,
        "PermanentAddressLine2": swOtherInfo?.permanentAddressLine2,
        "PermanentGraamName": swOtherInfo?.permanentGraamCityName,
        "PermanentPostOffice": swOtherInfo?.permanentPostOffice,
        "PermanentDistrictID": swOtherInfo?.permanentDistrictID,
        "PermanentPinCode": swOtherInfo?.permanentPinCode,
        "PermanentStateID": swOtherInfo?.permanentStateID,
        "BloodGroupID": swOtherInfo?.bloodGroupID,
        "BloodGroupCode": swOtherInfo?.bloodGroupCode,
        "MotherTongueID": swOtherInfo?.motherTongueID,
        "MotherTongueCode": swOtherInfo?.motherTongueCode,
        // "BirthDateStr": (_birthDate != null ? DateFormat('dd-MM-yyyy').format(_birthDate!) : null),
        "SanghaPraveshYear": swOtherInfo?.sanghaPraveshYear,
        "FacebookUsage": swOtherInfo?.facebookUsage,
        "TwitterUsage": swOtherInfo?.twitterUsage,
        "KooUsage": "", //swOtherInfo?.kooUsage,
        "InstagramUsage": swOtherInfo?.instagramUsage,
        "IsPratidnyit": _isPratidnyit,
        "PratidnyaYear": swOtherInfo?.pratidnyaYear,
        //"IsGanaveshComplete": _isGanaveshComplete,
        "HasCap": _hasCap ?? false,
        "HasShirt": _hasShirt ?? false,
        "HasPant": _hasPant ?? false,
        "HasBelt": _hasBelt ?? false,
        "HasShoes": _hasShoes ?? false,
        "HasSocks": _hasSocks ?? false,
        "HasDanda": _hasDanda ?? false,
        "HasShaakhaaSanchaalanExperience": _hasShaakhaaExperience ?? false,
        "HasBaalShaakhaaExperience": _hasBaalShaakhaaExperience ?? false,
        "HasTarunVidyaarthiShaakhaaExperience": _hasTarunVidShaakhaaExperience ?? false,
        "HasTarunVyavasaayeeShaakhaaExperience": _hasTarunVyavShaakhaaExperience ?? false,
        "HasProudhaVyavasaayeeShaakhaaExperience": _hasProudhaVyavShaakhaaExperience ?? false,
        "ShaakhaaExperienceYearID": swOtherInfo?.shaakhaaExperienceYearID,
        "HasShaakhaaOpeningExperience": _hasShaakhaaOpeningExperience ?? false,
        "HasBaalShaakhaaOpeningExperience": _hasBaalShaakhaaOpeningExperience ?? false,
        "HasTarunVidyaarthiShaakhaaOpeningExperience": _hasTarunVidShaakhaaOpeningExperience ?? false,
        "HasTarunVyavasaayeeShaakhaaOpeningExperience": _hasTarunVyavShaakhaaOpeningExperience ?? false,
        "HasProudhaVyavasaayeeShaakhaaOpeningExperience": _hasProudhaVyavShaakhaaOpeningExperience ?? false,
        "Has2WVehicle": _has2Wheeler ?? false,
        "Has3WVehicle": _has3Wheeler ?? false,
        "Has4WVehicle": _has4Wheeler ?? false,
        "HasVehicleDriver": _hasVehicleDriver ?? false,
        "AreaOfInterestIDs": areaOfInterestIDs.trim() == '' ? null : areaOfInterestIDs,
        "AreaOfExpertiseIDs": areaOfExpertiseIDs.trim() == '' ? null : areaOfExpertiseIDs,
        "SecondaryMobileNumber": swOtherInfo?.secondaryMobileNumber == "" ? null : swOtherInfo?.secondaryMobileNumber,
        "OfficePhoneNumber": swOtherInfo?.officePhoneNumber == "" ? null : swOtherInfo?.officePhoneNumber,
        "HomePhoneNumber": swOtherInfo?.homePhoneNumber == "" ? null : swOtherInfo?.homePhoneNumber,
        "WhatsAppNumber": swOtherInfo?.whatsAppNumber == "" ? null : swOtherInfo?.whatsAppNumber,
        "FacebookPage": swOtherInfo?.facebookPage,
        "SecondaryEmail": swOtherInfo?.secondaryEmail,
        "TwitterHandle": swOtherInfo?.twitterHandle,
        "InstagramHandle": swOtherInfo?.instagramHandle,
        "KooHandle": "", //swOtherInfo?.kooHandle,
        "MaxDaayitva": swOtherInfo?.maxDaayitva,
        "HasBeenVistaarak": null,
        "HasBeenPrachaarak": null,
        "VistaarakWeekCount": null,
        "VistaarakMonthCount": null,
        "VistaarakYearCount": null,
        "PrachaarakYearCount": null,
      },
      "ModifiedBy": Statics.userDetails["userID"].toString()
    });

    var data = await SwayamsevakProvider().saveSwayamsevakOtherInfoForApp(inputData);
    setState(() {
      widget.swId = data;
      widget.onSaveSwDetails(widget.swId);
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    });
  }

  void populateDropdown() async {
    var data = await Statics.getStateLDB("Current");
    var data5 = await Statics.getStateLDB("");
    var data1 = await Statics.getStaticLDB("BloodGroup");
    var data2 = await Statics.getStaticLDB("MotherTongue");
    var data3 = await Statics.getStaticLDB("ShaakhaaExperienceYear");

    var data4 = await Statics.getSanghaPreritSanstha("1", null, null);

    // if (!mounted)

    // print("data5 >>>>>>>>>>>>>>>> ");
    data.forEach((e) => print("data >>>>>>>>>>>>>>>> ${e.toJson()}"));

    setState(() {
      _curState = data.isEmpty ? null : data;
      _permanantState = data5;
      _bldGroupList = data1;
      _motherTongue = data2;
      _shaakhaSanchalan = data3;
      _shaakhaSanchalan = data3;
      _sanghaPreritSanstha = data4;
    });
    // return;
  }

  // _pickDate() async {
  //   DateTime? date = await showDatePicker(
  //       context: context,
  //       initialDate: _birthDate == null ? DateTime.now() : _birthDate!,
  //       firstDate: DateTime((_birthDate == null ? DateTime.now().year : _birthDate!.year) - 80),
  //       lastDate: DateTime((_birthDate == null ? DateTime.now().year : _birthDate!.year) + 80));
  //
  //   if (date != null) {
  //     setState(() {
  //       _birthDate = date;
  //       _birthDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date);
  //     });
  //   }
  // }

  populateDistrict(String? stateID, String type) async {
    var data = await Statics.getDistrictForApp("1", stateID, null);
    setState(() {
      if (type == "Current") {
        // Filter IsInPraant=true
        _curDistrict = data.where((element) => element["IsInPraant"] == true).toList();
        _curDistrictValue = null;
      } else {
        _permanantDistrict = data; // Do not filter
        _permanantDistrictValue = null;
      }
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
                    Legend(legendString: 'CurrentAddress', fontsize: 18),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _curAddressLine1Cntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('AddressLine1')),
                      keyboardType: TextInputType.text,
                      // validator: (value) {
                      //   if (value.isEmpty)
                      //     return (Statics.getLabel(
                      //         'AddressLine1ValidationMessage'));
                      //   return null;
                      // },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swOtherInfo!.currentAddressLine1 = value;
                        else
                          swOtherInfo!.currentAddressLine1 = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _curAddressLine2Cntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('AddressLine2')),
                      keyboardType: TextInputType.text,
                      // validator: (value) {
                      //   if (value.isEmpty)
                      //     return (Statics.getLabel(
                      //         'AddressLine2ValidationMessage'));
                      //   return null;
                      // },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swOtherInfo!.currentAddressLine2 = value;
                        else
                          swOtherInfo!.currentAddressLine2 = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _curGraamCityCntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('Graam') + "/" + Statics.getLabel('City')),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swOtherInfo!.currentGraamCityName = value;
                        else
                          swOtherInfo!.currentGraamCityName = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _curPostOfficeCntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('PostOffice')),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swOtherInfo!.currentPostOffice = value;
                        else
                          swOtherInfo!.currentPostOffice = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // TextFormField(
                    //   textInputAction: TextInputAction.next,
                    //   controller: _curCityCntrl,
                    //   decoration:
                    //       InputDecoration(labelText: Statics.getLabel('City')),
                    //   keyboardType: TextInputType.text,
                    //   onSaved: (value) {
                    //     if (value != null && value.isNotEmpty)
                    //       swOtherInfo!.currentCity = value;
                    //     else
                    //       swOtherInfo!.currentCity = null;
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    if (_curStateValue != "null")
                      // Text("_curState::--- ${_curState![0].stateName}--${_curStateValue}--"),
                      DropdownButtonFormField(
                        decoration: InputDecoration(labelText: Statics.getLabel('SelectState')),
                        isExpanded: true,
                        value: _curStateValue == "" ? null : _curStateValue,
                        items: _curState?.map((bg) => DropdownMenuItem(value: bg.stateID.toString(), child: Text(bg.stateName!))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _curStateValue = value!;
                            populateDistrict(value, "Current");
                          });
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty)
                            swOtherInfo!.currentStateID = int.parse(value);
                          else
                            swOtherInfo!.currentStateID = null;
                        },
                      ),
                    SizedBox(height: 10),
                    if (_curDistrict != null)
                      DropdownButtonFormField(
                        decoration: InputDecoration(labelText: Statics.getLabel('District')),
                        isExpanded: true,
                        value: _curDistrictValue == null
                            ? null
                            : _curDistrict != null
                                ? _curDistrict!.indexWhere((p) => p["DistrictID"].toString() == _curDistrictValue) > -1
                                    ? _curDistrictValue
                                    : null
                                : null,
                        items: _curDistrict!.map((bg) => DropdownMenuItem(value: bg["DistrictID"].toString(), child: Text(bg["DistrictName"]))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _curDistrictValue = value;
                          });
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty)
                            swOtherInfo!.currentDistrictID = int.parse(value);
                          else
                            swOtherInfo!.currentDistrictID = null;
                        },
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _curPinCodeCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('Pincode')),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swOtherInfo!.currentPinCode = value;
                        else
                          swOtherInfo!.currentPinCode = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                      height: 40,
                    ),
                    Legend(legendString: 'PermanentAddress', fontsize: 18),
                    CheckboxListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(Statics.getLabel('SameasCurrentAddress'), style: TextStyle(fontSize: 15)),
                        checkColor: Colors.white,
                        activeColor: Colors.purple,
                        value: _sameAsCurrentAddress == null ? false : _sameAsCurrentAddress,
                        onChanged: (value) {
                          setState(() {
                            _sameAsCurrentAddress = value;
                            if (value == true) {
                              _permanantAddressLine1Cntrl.text = _curAddressLine1Cntrl.text;
                              _permanantAddressLine2Cntrl.text = _curAddressLine2Cntrl.text;
                              // _permanantCityCntrl.text = _curCityCntrl.text;

                              _permanantGraamCityCntrl.text = _curGraamCityCntrl.text;
                              _permanantPinCodeCtrl.text = _curPinCodeCtrl.text;
                              _permanantPostOfficeCntrl.text = _curPostOfficeCntrl.text;
                              _permanantStateValue = _curStateValue;
                              _permanantDistrictValue = _curDistrictValue;
                            } else {
                              _permanantAddressLine1Cntrl.text = _permanantAddressLine2Cntrl.text =
                                  //_permanantCityCntrl.text =
                                  _permanantGraamCityCntrl.text = _permanantPinCodeCtrl.text = _permanantPostOfficeCntrl.text = "";

                              _permanantStateValue = _permanantDistrictValue = null;
                            }
                          });
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _permanantAddressLine1Cntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('AddressLine1')),
                      keyboardType: TextInputType.text,
                      // validator: (value) {
                      //   if (value.isEmpty)
                      //     return (Statics.getLabel(
                      //         'AddressLine1ValidationMessage'));
                      //   return null;
                      // },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swOtherInfo!.permanentAddressLine1 = value;
                        else
                          swOtherInfo!.permanentAddressLine1 = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _permanantAddressLine2Cntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('AddressLine2')),
                      keyboardType: TextInputType.text,
                      // validator: (value) {
                      //   if (value.isEmpty)
                      //     return (Statics.getLabel(
                      //         'AddressLine2ValidationMessage'));
                      //   return null;
                      // },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swOtherInfo!.permanentAddressLine2 = value;
                        else
                          swOtherInfo!.permanentAddressLine2 = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _permanantGraamCityCntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('Graam') + "/" + Statics.getLabel('City')),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swOtherInfo!.permanentGraamCityName = value;
                        else
                          swOtherInfo!.permanentGraamCityName = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _permanantPostOfficeCntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('PostOffice')),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swOtherInfo!.permanentPostOffice = value;
                        else
                          swOtherInfo!.permanentPostOffice = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // TextFormField(
                    //   textInputAction: TextInputAction.next,
                    //   controller: _permanantCityCntrl,
                    //   decoration:
                    //       InputDecoration(labelText: Statics.getLabel('City')),
                    //   keyboardType: TextInputType.text,
                    //   onSaved: (value) {
                    //     if (value != null && value.isNotEmpty)
                    //       swOtherInfo!.permanentCity = value;
                    //     else
                    //       swOtherInfo!.permanentCity = null;
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // TextFormField(
                    //   textInputAction: TextInputAction.next,
                    //   controller: _permanantDistrictCtrl,
                    //   decoration: InputDecoration(
                    //       labelText: Statics.getLabel('District')),
                    //   keyboardType: TextInputType.text,
                    //   onSaved: (value) {
                    //     if (value != null && value.isNotEmpty)
                    //       swOtherInfo!.permanentDistrict = value;
                    //     else
                    //       swOtherInfo!.permanentDistrict = null;
                    //   },
                    // ),
                    if (_permanantState != null)
                      DropdownButtonFormField(
                        decoration: InputDecoration(labelText: Statics.getLabel('SelectState')),
                        isExpanded: true,
                        value: _permanantStateValue == "" ? null : _permanantStateValue,
                        items: _permanantState!.map((bg) => DropdownMenuItem(value: bg.stateID.toString(), child: Text(bg.stateName!))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _permanantStateValue = value;
                            populateDistrict(value!, "Permanent");
                          });
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty)
                            swOtherInfo!.permanentStateID = int.parse(value);
                          else
                            swOtherInfo!.permanentStateID = null;
                        },
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_permanantDistrict != null)
                      DropdownButtonFormField(
                        decoration: InputDecoration(labelText: Statics.getLabel('District')),
                        isExpanded: true,
                        value: _permanantDistrictValue == ""
                            ? null
                            : _permanantDistrict != null
                                ? _permanantDistrict!.indexWhere((p) => p["DistrictID"].toString() == _permanantDistrictValue) > -1
                                    ? _permanantDistrictValue
                                    : null
                                : null,
                        items: _permanantDistrict!.map((bg) => DropdownMenuItem(value: bg["DistrictID"].toString(), child: Text(bg["DistrictName"]))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _permanantDistrictValue = value;
                          });
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty)
                            swOtherInfo!.permanentDistrictID = int.parse(value);
                          else
                            swOtherInfo!.permanentDistrictID = null;
                        },
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _permanantPinCodeCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('Pincode')),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swOtherInfo!.permanentPinCode = value;
                        else
                          swOtherInfo!.permanentPinCode = null;
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Legend(legendString: 'ContactDetails', fontsize: 18),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_circle),
                          iconSize: 40,
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            setState(() {
                              var actnum = 0;

                              if (_shwFirstField == true) actnum = actnum + 1;
                              if (_shwSecondField == true) actnum = actnum + 1;
                              if (_shwThirdField == true) actnum = actnum + 1;
                              if (_shwfourthField == true) actnum = actnum + 1;

                              if (_feildNum < 4) _feildNum = _feildNum + 1;
                              if (_shwFirstField == false) {
                                _shwFirstField = true;
                                actnum = actnum + 1;
                                if (actnum == _feildNum) return;
                              }

                              if (_shwSecondField == false) {
                                _shwSecondField = true;
                                actnum = actnum + 1;
                                if (actnum == _feildNum) return;
                              }
                              if (_shwThirdField == false) {
                                _shwThirdField = true;
                                actnum = actnum + 1;
                                if (actnum == _feildNum) return;
                              }
                              if (_shwfourthField == false) {
                                _shwfourthField = true;

                                actnum = actnum + 1;
                                if (actnum == _feildNum) return;
                              }
                            });
                          },
                        ),
                        Text(Statics.getLabel('OtherPhoneNumbers')),
                      ],
                    ),
                    if (_shwFirstField == true)
                      Row(
                        children: [
                          Container(
                            width: Statics.getDeviceSize(context).width * 0.32,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Type')),
                              isExpanded: true,
                              value: _firstFieldValue == "" ? null : _firstFieldValue,
                              items: _fieldType,
                              validator: (value) {
                                if (value!.isNotEmpty) if (value == _secondFieldValue || value == _thirdFieldValue || value == _fourthFieldValue) return (Statics.getLabel('TypeValidationMessage'));
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _firstFieldValue = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: Statics.getDeviceSize(context).width * 0.03),
                          Container(
                            width: Statics.getDeviceSize(context).width * 0.4,
                            padding: EdgeInsets.fromLTRB(10, 22, 10, 0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _txtNumber1Ctrl,
                              decoration: InputDecoration(labelText: Statics.getLabel('Number')),
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              validator: (value) {
                                if (value!.isEmpty || value.trim().length < 10) return (Statics.getLabel('MobileValidationMessage'));
                                return null;
                              },
                              onSaved: (value) {
                                if (_firstFieldValue == "SecondaryMobile")
                                  swOtherInfo!.secondaryMobileNumber = value;
                                else if (_firstFieldValue == "OfficePhone")
                                  swOtherInfo!.officePhoneNumber = value;
                                else if (_firstFieldValue == "HomePhone")
                                  swOtherInfo!.homePhoneNumber = value;
                                else if (_firstFieldValue == "WhatsAppNumber") swOtherInfo!.whatsAppNumber = value;
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_circle_sharp),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                if (_firstFieldValue == "SecondaryMobile")
                                  swOtherInfo!.secondaryMobileNumber = null;
                                else if (_firstFieldValue == "OfficePhone")
                                  swOtherInfo!.officePhoneNumber = null;
                                else if (_firstFieldValue == "HomePhone")
                                  swOtherInfo!.homePhoneNumber = null;
                                else if (_firstFieldValue == "WhatsAppNumber") swOtherInfo!.whatsAppNumber = null;
                                _shwFirstField = false;
                                _txtNumber1Ctrl.text = "";
                                _firstFieldValue = "";
                                if (_feildNum > 0) _feildNum = _feildNum - 1;
                              });
                            },
                          ),
                        ],
                      ),
                    if (_shwSecondField == true)
                      Row(
                        children: [
                          Container(
                            width: Statics.getDeviceSize(context).width * 0.32,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Type')),
                              isExpanded: true,
                              value: _secondFieldValue == "" ? null : _secondFieldValue,
                              items: _fieldType,
                              validator: (value) {
                                if (value!.isNotEmpty) if (value == _firstFieldValue || value == _thirdFieldValue || value == _fourthFieldValue) return (Statics.getLabel('TypeValidationMessage'));
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _secondFieldValue = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: Statics.getDeviceSize(context).width * 0.03),
                          Container(
                            width: Statics.getDeviceSize(context).width * 0.4,
                            padding: EdgeInsets.fromLTRB(10, 22, 10, 0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _txtNumber2Ctrl,
                              decoration: InputDecoration(labelText: Statics.getLabel('Number')),
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              validator: (value) {
                                if (value!.isEmpty || value.trim().length < 10) return (Statics.getLabel('MobileValidationMessage'));
                                return null;
                              },
                              onSaved: (value) {
                                if (_secondFieldValue == "SecondaryMobile")
                                  swOtherInfo!.secondaryMobileNumber = value;
                                else if (_secondFieldValue == "OfficePhone")
                                  swOtherInfo!.officePhoneNumber = value;
                                else if (_secondFieldValue == "HomePhone")
                                  swOtherInfo!.homePhoneNumber = value;
                                else if (_secondFieldValue == "WhatsAppNumber") swOtherInfo!.whatsAppNumber = value;
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_circle_sharp),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                if (_secondFieldValue == "SecondaryMobile")
                                  swOtherInfo!.secondaryMobileNumber = null;
                                else if (_secondFieldValue == "OfficePhone")
                                  swOtherInfo!.officePhoneNumber = null;
                                else if (_secondFieldValue == "HomePhone")
                                  swOtherInfo!.homePhoneNumber = null;
                                else if (_secondFieldValue == "WhatsAppNumber") swOtherInfo!.whatsAppNumber = null;
                                _shwSecondField = false;
                                _txtNumber2Ctrl.text = "";
                                _secondFieldValue = "";
                                if (_feildNum > 0) _feildNum = _feildNum - 1;
                              });
                            },
                          ),
                        ],
                      ),
                    if (_shwThirdField == true)
                      Row(
                        children: [
                          Container(
                            width: Statics.getDeviceSize(context).width * 0.32,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Type')),
                              isExpanded: true,
                              value: _thirdFieldValue == "" ? null : _thirdFieldValue,
                              items: _fieldType,
                              validator: (value) {
                                if (value!.isNotEmpty) if (value == _secondFieldValue || value == _firstFieldValue || value == _fourthFieldValue) return (Statics.getLabel('TypeValidationMessage'));
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _thirdFieldValue = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: Statics.getDeviceSize(context).width * 0.03),
                          Container(
                            width: Statics.getDeviceSize(context).width * 0.4,
                            padding: EdgeInsets.fromLTRB(10, 22, 10, 0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _txtNumber3Ctrl,
                              decoration: InputDecoration(labelText: Statics.getLabel('Number')),
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              validator: (value) {
                                if (value!.isEmpty || value.trim().length < 10) return (Statics.getLabel('MobileValidationMessage'));
                                return null;
                              },
                              onSaved: (value) {
                                if (_thirdFieldValue == "SecondaryMobile")
                                  swOtherInfo!.secondaryMobileNumber = value;
                                else if (_thirdFieldValue == "OfficePhone")
                                  swOtherInfo!.officePhoneNumber = value;
                                else if (_thirdFieldValue == "HomePhone")
                                  swOtherInfo!.homePhoneNumber = value;
                                else if (_thirdFieldValue == "WhatsAppNumber") swOtherInfo!.whatsAppNumber = value;
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_circle_sharp),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                if (_thirdFieldValue == "SecondaryMobile")
                                  swOtherInfo!.secondaryMobileNumber = null;
                                else if (_thirdFieldValue == "OfficePhone")
                                  swOtherInfo!.officePhoneNumber = null;
                                else if (_thirdFieldValue == "HomePhone")
                                  swOtherInfo!.homePhoneNumber = null;
                                else if (_thirdFieldValue == "WhatsAppNumber") swOtherInfo!.whatsAppNumber = null;
                                _shwThirdField = false;
                                _txtNumber3Ctrl.text = "";
                                _thirdFieldValue = "";
                                if (_feildNum > 0) _feildNum = _feildNum - 1;
                              });
                            },
                          ),
                        ],
                      ),
                    if (_shwfourthField == true)
                      Row(
                        children: [
                          Container(
                            width: Statics.getDeviceSize(context).width * 0.32,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Type')),
                              isExpanded: true,
                              value: _fourthFieldValue == "" ? null : _fourthFieldValue,
                              items: _fieldType,
                              validator: (value) {
                                if (value!.isNotEmpty) if (value == _secondFieldValue || value == _thirdFieldValue || value == _firstFieldValue) return (Statics.getLabel('TypeValidationMessage'));
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _fourthFieldValue = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: Statics.getDeviceSize(context).width * 0.03),
                          Container(
                            width: Statics.getDeviceSize(context).width * 0.4,
                            padding: EdgeInsets.fromLTRB(10, 22, 10, 0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _txtNumber4Ctrl,
                              decoration: InputDecoration(labelText: Statics.getLabel('Number')),
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              validator: (value) {
                                if (value!.isEmpty || value.trim().length < 10) return (Statics.getLabel('MobileValidationMessage'));
                                return null;
                              },
                              onSaved: (value) {
                                if (_fourthFieldValue == "SecondaryMobile")
                                  swOtherInfo!.secondaryMobileNumber = value;
                                else if (_fourthFieldValue == "OfficePhone")
                                  swOtherInfo!.officePhoneNumber = value;
                                else if (_fourthFieldValue == "HomePhone")
                                  swOtherInfo!.homePhoneNumber = value;
                                else if (_fourthFieldValue == "WhatsAppNumber") swOtherInfo!.whatsAppNumber = value;
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_circle_sharp),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                if (_fourthFieldValue == "SecondaryMobile")
                                  swOtherInfo!.secondaryMobileNumber = null;
                                else if (_fourthFieldValue == "OfficePhone")
                                  swOtherInfo!.officePhoneNumber = null;
                                else if (_fourthFieldValue == "HomePhone")
                                  swOtherInfo!.homePhoneNumber = null;
                                else if (_fourthFieldValue == "WhatsAppNumber") swOtherInfo!.whatsAppNumber = null;
                                _shwfourthField = false;
                                _txtNumber4Ctrl.text = "";
                                _fourthFieldValue = "";
                                if (_feildNum > 0) _feildNum = _feildNum - 1;
                              });
                            },
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _txtSecondayEmailCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('SecondaryEmail')),
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
                          swOtherInfo!.secondaryEmail = value.trim();
                        else
                          swOtherInfo!.secondaryEmail = null;
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Legend(legendString: 'PratidnyaDetails', fontsize: 18),
                    Wrap(
                      children: [
                        SizedBox(
                          width: Statics.getDeviceSize(context).width * 0.4,
                          child: CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(Statics.getLabel('IsPratidnyit'), style: TextStyle(fontSize: 15)),
                              checkColor: Colors.white,
                              activeColor: Colors.purple,
                              value: _isPratidnyit == null ? false : _isPratidnyit,
                              onChanged: (value) {
                                setState(() {
                                  _isPratidnyit = value!;
                                });
                              }),
                        ),
                        SizedBox(
                          width: Statics.getDeviceSize(context).width * 0.4,
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _pratidnyaYearCtrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('PratidnyaYear')),
                            keyboardType: TextInputType.number,
                            enabled: _isPratidnyit == null ? false : _isPratidnyit,
                            maxLength: 4,
                            validator: (value) {
                              if (_isPratidnyit != null) {
                                if (_isPratidnyit && value!.isEmpty)
                                  return (Statics.getLabel('PratidnyaYearValidationMessage'));
                                else if (!_isPratidnyit && value!.isNotEmpty) {
                                  value = "";
                                  return ('Pratidnya Year Not Required');
                                } else if (_isPratidnyit && value!.length < 4)
                                  return (Statics.getLabel('ValidYearValidationMessage'));
                                else if (_isPratidnyit && (int.parse(value!) > int.parse(DateFormat('yyyy').format(DateTime.now())))) {
                                  return Statics.getLabel('ValidYearValidationMessage');
                                }
                              }

                              return null;
                            },
                            onSaved: (value) {
                              if (value != null && value.isNotEmpty)
                                swOtherInfo!.pratidnyaYear = int.parse(value);
                              else
                                swOtherInfo!.pratidnyaYear = null;
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Legend(legendString: 'GanveshDetails', fontsize: 18),
                    // CheckboxListTile(
                    //   controlAffinity: ListTileControlAffinity.leading,
                    //   contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    //   title: Text(Statics.getLabel('IsGanveshComplete'),
                    //       style: TextStyle(fontSize: 15)),
                    //   checkColor: Colors.white,
                    //   activeColor: Colors.purple,
                    //   value: _isGanaveshComplete == null
                    //       ? false
                    //       : _isGanaveshComplete,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _isGanaveshComplete = value;
                    //       if (value == true) {
                    //         _noCap = _noBelt = _noDanda = _noPant =
                    //             _noShirt = _noShoes = _noSocks = false;
                    //       }
                    //     });
                    //   },
                    // ),
                    SizedBox(height: 10),
                    AbsorbPointer(
                      absorbing: false,
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 10,
                        children: [
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.4,
                            child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                title: Text(Statics.getLabel('HasCap'), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _hasCap == null ? false : _hasCap,
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged: (value) {
                                  setState(() {
                                    _hasCap = value!;
                                  });
                                }),
                          ),
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.4,
                            child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                title: Text(Statics.getLabel('HasShirt'), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _hasShirt == null ? false : _hasShirt,
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged: (value) {
                                  setState(() {
                                    _hasShirt = value!;
                                  });
                                }),
                          ),
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.4,
                            child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                title: Text(Statics.getLabel('HasPant'), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _hasPant == null ? false : _hasPant,
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged: (value) {
                                  setState(() {
                                    _hasPant = value!;
                                  });
                                }),
                          ),
                          // Text("_hasBelt $_hasBelt"),
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.4,
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              title: Text(Statics.getLabel('HasBelt'), style: TextStyle(fontSize: 15)),
                              checkColor: Colors.white,
                              activeColor: Colors.purple,
                              value: _hasBelt == null ? false : _hasBelt,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (value) {
                                setState(() {
                                  _hasBelt = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.4,
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              title: Text(Statics.getLabel('HasShoes'), style: TextStyle(fontSize: 15)),
                              checkColor: Colors.white,
                              activeColor: Colors.purple,
                              value: _hasShoes == null ? false : _hasShoes,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (value) {
                                setState(() {
                                  _hasShoes = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.4,
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              title: Text(Statics.getLabel('HasSocks'), style: TextStyle(fontSize: 15)),
                              checkColor: Colors.white,
                              activeColor: Colors.purple,
                              value: _hasSocks == null ? false : _hasSocks,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (value) {
                                setState(() {
                                  _hasSocks = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.4,
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              title: Text(Statics.getLabel('HasDanda'), style: TextStyle(fontSize: 15)),
                              checkColor: Colors.white,
                              activeColor: Colors.purple,
                              value: _hasDanda == null ? false : _hasDanda,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (value) {
                                setState(() {
                                  _hasDanda = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Legend(legendString: 'VehicleDetails', fontsize: 18),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Text(Statics.getLabel('Has2Wheeler') + ' ?'),
                        SizedBox(
                          width: Statics.getDeviceSize(context).width * 0.4,
                          child: CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(Statics.getLabel('Has2Wheeler'), style: TextStyle(fontSize: 15)),
                              checkColor: Colors.white,
                              activeColor: Colors.purple,
                              value: _has2Wheeler == null ? false : _has2Wheeler,
                              onChanged: (value) {
                                setState(() {
                                  _has2Wheeler = value!;
                                });
                              }),
                        ),
                        //Text(Statics.getLabel('Has3Wheeler') + ' ?'),
                        SizedBox(
                          width: Statics.getDeviceSize(context).width * 0.4,
                          child: CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(Statics.getLabel('Has3Wheeler'), style: TextStyle(fontSize: 15)),
                              checkColor: Colors.white,
                              activeColor: Colors.purple,
                              value: _has3Wheeler == null ? false : _has3Wheeler,
                              onChanged: (value) {
                                setState(() {
                                  _has3Wheeler = value!;
                                });
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Text(Statics.getLabel('Has4Wheeler') + ' ? '),
                        SizedBox(
                          width: Statics.getDeviceSize(context).width * 0.4,
                          child: CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(Statics.getLabel('Has4Wheeler'), style: TextStyle(fontSize: 15)),
                              checkColor: Colors.white,
                              activeColor: Colors.purple,
                              value: _has4Wheeler == null ? false : _has4Wheeler,
                              onChanged: (value) {
                                setState(() {
                                  _has4Wheeler = value!;
                                });
                              }),
                        ),
                        //Text(Statics.getLabel('HasVehicleDriver')),
                        if (_has4Wheeler == true)
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.4,
                            child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Text(Statics.getLabel('HasVehicleDriver'), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _hasVehicleDriver == null ? false : _hasVehicleDriver,
                                onChanged: (value) {
                                  setState(() {
                                    _hasVehicleDriver = value!;
                                  });
                                }),
                          )
                        else
                          SizedBox(width: Statics.getDeviceSize(context).width * 0.4),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Legend(legendString: 'OtherInfo', fontsize: 18),
                    if (_bldGroupList != null)
                      // Text(_bldGroupList.toString()),
                      DropdownButtonFormField(
                        decoration: InputDecoration(labelText: Statics.getLabel('SelectBloodGroup')),
                        isExpanded: true,
                        value: _bldGrpvalue == "" ? null : _bldGrpvalue,
                        items: _bldGroupList!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _bldGrpvalue = value!;
                          });
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty)
                            swOtherInfo!.bloodGroupID = int.parse(value);
                          else
                            swOtherInfo!.bloodGroupID = null;
                        },
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_motherTongue != null)
                      DropdownButtonFormField(
                        decoration: InputDecoration(labelText: Statics.getLabel('SelectMotherTongue')),
                        isExpanded: true,
                        value: _mthrTngvalue == "" ? null : _mthrTngvalue,
                        items: _motherTongue!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _mthrTngvalue = value!;
                          });
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty)
                            swOtherInfo!.motherTongueID = int.parse(value);
                          else
                            swOtherInfo!.motherTongueID = null;
                        },
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_motherTongue != null)
                      if ((_motherTongue!.indexWhere((p) => p.staticID.toString() == _mthrTngvalue) > -1
                              ? _motherTongue![_motherTongue!.indexWhere((p) => p.staticID.toString() == _mthrTngvalue)].code
                              : "") ==
                          "Other")
                        Column(
                          children: [
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _othLangCntrl,
                              decoration: InputDecoration(labelText: Statics.getLabel('OtherLanguage')),
                              keyboardType: TextInputType.text,
                              maxLength: 10,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return (Statics.getLabel('OtherLanguageValidationMessage'));
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty)
                                  swOtherInfo!.motherTongueCode = value;
                                else
                                  swOtherInfo!.motherTongueCode = null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                    // Row(
                    //   children: [
                    //     SizedBox(
                    //       width: Statics.getDeviceSize(context).width * 0.7,
                    //       child: TextField(
                    //         enabled: false,
                    //         controller: _birthDateCntrl,
                    //         decoration: InputDecoration(labelText: Statics.getLabel('BirthDate')),
                    //         textInputAction: TextInputAction.done,
                    //       ),
                    //     ),
                    //     IconButton(
                    //       color: Colors.purple,
                    //       icon: FaIcon(FontAwesomeIcons.solidCalendarAlt),
                    //       onPressed: _pickDate,
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _sanghaPraveshYearCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('SanghaPraveshYear')),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          if (value.length < 4)
                            return (Statics.getLabel('ValidYearValidationMessage'));
                          else if (int.parse(value) > int.parse(DateFormat('yyyy').format(DateTime.now()))) {
                            return (Statics.getLabel('ValidYearValidationMessage'));
                          }
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swOtherInfo!.sanghaPraveshYear = int.parse(value);
                        else
                          swOtherInfo!.sanghaPraveshYear = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: Statics.getDeviceSize(context).width * 0.8,
                      child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          title: Text(Statics.getLabel('HasShaakhaaSanchaalanExperience'), style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _hasShaakhaaExperience == null ? false : _hasShaakhaaExperience,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) {
                            setState(() {
                              _hasShaakhaaExperience = value!;
                            });
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_hasShaakhaaExperience == true)
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 10,
                        children: [
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.4,
                            child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                title: Text(Statics.getLabel('Baal'), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _hasBaalShaakhaaExperience == null ? false : _hasBaalShaakhaaExperience,
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged: (value) {
                                  setState(() {
                                    _hasBaalShaakhaaExperience = value!;
                                  });
                                }),
                          ),
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.4,
                            child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                title: Text(Statics.getLabel('TarunVidyaarthi'), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _hasTarunVidShaakhaaExperience == null ? false : _hasTarunVidShaakhaaExperience,
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged: (value) {
                                  setState(() {
                                    _hasTarunVidShaakhaaExperience = value!;
                                  });
                                }),
                          ),
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.4,
                            child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                title: Text(Statics.getLabel('TarunVyavasaayee'), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _hasTarunVyavShaakhaaExperience == null ? false : _hasTarunVyavShaakhaaExperience,
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged: (value) {
                                  setState(() {
                                    _hasTarunVyavShaakhaaExperience = value!;
                                  });
                                }),
                          ),
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.4,
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              title: Text(Statics.getLabel('ProudhVyavasaayee'), style: TextStyle(fontSize: 15)),
                              checkColor: Colors.white,
                              activeColor: Colors.purple,
                              value: _hasProudhaVyavShaakhaaExperience == null ? false : _hasProudhaVyavShaakhaaExperience,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (value) {
                                setState(() {
                                  _hasProudhaVyavShaakhaaExperience = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 10),
                    if (_shaakhaSanchalan != null)
                      DropdownButtonFormField(
                        decoration: InputDecoration(labelText: Statics.getLabel('ShaakhaaSanchaalan')),
                        isExpanded: true,
                        value: _shaakhaSanchalanvalue == "" ? null : _shaakhaSanchalanvalue,
                        items: _shaakhaSanchalan!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _shaakhaSanchalanvalue = value!;
                          });
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty)
                            swOtherInfo!.shaakhaaExperienceYearID = int.parse(value);
                          else
                            swOtherInfo!.shaakhaaExperienceYearID = null;
                        },
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_hasShaakhaaExperience == true)
                      Column(
                        children: [
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.8,
                            child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                title: Text(Statics.getLabel('HasShaakhaaOpeningExperience'), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _hasShaakhaaOpeningExperience == null ? false : _hasShaakhaaOpeningExperience,
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged: (value) {
                                  setState(() {
                                    _hasShaakhaaOpeningExperience = value!;
                                  });
                                }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_hasShaakhaaOpeningExperience == true)
                            Wrap(
                              direction: Axis.horizontal,
                              spacing: 10,
                              children: [
                                SizedBox(
                                  width: Statics.getDeviceSize(context).width * 0.4,
                                  child: CheckboxListTile(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                      title: Text(Statics.getLabel('Baal'), style: TextStyle(fontSize: 15)),
                                      checkColor: Colors.white,
                                      activeColor: Colors.purple,
                                      value: _hasBaalShaakhaaOpeningExperience == null ? false : _hasBaalShaakhaaOpeningExperience,
                                      controlAffinity: ListTileControlAffinity.leading,
                                      onChanged: (value) {
                                        setState(() {
                                          _hasBaalShaakhaaOpeningExperience = value!;
                                        });
                                      }),
                                ),
                                SizedBox(
                                  width: Statics.getDeviceSize(context).width * 0.4,
                                  child: CheckboxListTile(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                      title: Text(Statics.getLabel('TarunVidyaarthi'), style: TextStyle(fontSize: 15)),
                                      checkColor: Colors.white,
                                      activeColor: Colors.purple,
                                      value: _hasTarunVidShaakhaaOpeningExperience == null ? false : _hasTarunVidShaakhaaOpeningExperience,
                                      controlAffinity: ListTileControlAffinity.leading,
                                      onChanged: (value) {
                                        setState(() {
                                          _hasTarunVidShaakhaaOpeningExperience = value!;
                                        });
                                      }),
                                ),
                                SizedBox(
                                  width: Statics.getDeviceSize(context).width * 0.4,
                                  child: CheckboxListTile(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                      title: Text(Statics.getLabel('TarunVyavasaayee'), style: TextStyle(fontSize: 15)),
                                      checkColor: Colors.white,
                                      activeColor: Colors.purple,
                                      value: _hasTarunVyavShaakhaaOpeningExperience == null ? false : _hasTarunVyavShaakhaaOpeningExperience,
                                      controlAffinity: ListTileControlAffinity.leading,
                                      onChanged: (value) {
                                        setState(() {
                                          _hasTarunVyavShaakhaaOpeningExperience = value!;
                                        });
                                      }),
                                ),
                                SizedBox(
                                  width: Statics.getDeviceSize(context).width * 0.4,
                                  child: CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                    title: Text(Statics.getLabel('ProudhVyavasaayee'), style: TextStyle(fontSize: 15)),
                                    checkColor: Colors.white,
                                    activeColor: Colors.purple,
                                    value: _hasProudhaVyavShaakhaaExperience == null ? false : _hasProudhaVyavShaakhaaOpeningExperience,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    onChanged: (value) {
                                      setState(() {
                                        _hasProudhaVyavShaakhaaOpeningExperience = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    // TextFormField(
                    //   textInputAction: TextInputAction.next,
                    //   controller: _txtMaxDaayitvaCtrl,
                    //   decoration: InputDecoration(
                    //       labelText: Statics.getLabel('MaxDaayitva')),
                    //   keyboardType: TextInputType.text,
                    //   onSaved: (value) {
                    //     if (value != null && value.isNotEmpty)
                    //       swOtherInfo!.maxDaayitva = value;
                    //     else
                    //       swOtherInfo!.maxDaayitva = null;
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: [
                    //     // Text(Statics.getLabel('Has2Wheeler') + ' ?'),
                    //     SizedBox(
                    //       width: Statics.getDeviceSize(context).width * 0.4,
                    //       child: CheckboxListTile(
                    //           contentPadding:
                    //               EdgeInsets.symmetric(horizontal: 0),
                    //           controlAffinity: ListTileControlAffinity.leading,
                    //           title: Text(
                    //               Statics.getLabel('HasBeenVistaarak') ,
                    //               style: TextStyle(fontSize: 15)),
                    //           checkColor: Colors.white,
                    //           activeColor: Colors.purple,
                    //           value: _hasbeenVistarak == null
                    //               ? false
                    //               : _hasbeenVistarak,
                    //           onChanged: (value) {
                    //             setState(() {
                    //               _hasbeenVistarak = value;
                    //             });
                    //           }),
                    //     ),
                    //     SizedBox(
                    //       width: Statics.getDeviceSize(context).width * 0.4,
                    //       child: CheckboxListTile(
                    //           contentPadding:
                    //               EdgeInsets.symmetric(horizontal: 0),
                    //           controlAffinity: ListTileControlAffinity.leading,
                    //           title: Text(
                    //               Statics.getLabel('HasBeenPrachaarak') ,
                    //               style: TextStyle(fontSize: 15)),
                    //           checkColor: Colors.white,
                    //           activeColor: Colors.purple,
                    //           value: _hasBeenPrachaarak == null
                    //               ? false
                    //               : _hasBeenPrachaarak,
                    //           onChanged: (value) {
                    //             setState(() {
                    //               _hasBeenPrachaarak = value;
                    //             });
                    //           }),
                    //     ),
                    //   ],
                    // ),
                    // if (_hasbeenVistarak == true)
                    //   SizedBox(
                    //     height: 10,
                    //   ),
                    // if (_hasbeenVistarak == true)
                    //   TextFormField(
                    //     textInputAction: TextInputAction.next,
                    //     controller: _txtVistaarakWeekCountCtrl,
                    //     decoration: InputDecoration(
                    //         labelText: Statics.getLabel('VistaarakWeekCount')),
                    //     keyboardType: TextInputType.number,
                    //     onSaved: (value) {
                    //       if (value != null && value.isNotEmpty)
                    //         swOtherInfo!.vistaarakWeekCount = int.parse(value);
                    //       else
                    //         swOtherInfo!.vistaarakWeekCount = null;
                    //     },
                    //   ),
                    // if (_hasbeenVistarak == true)
                    //   SizedBox(
                    //     height: 10,
                    //   ),
                    // if (_hasbeenVistarak == true)
                    //   TextFormField(
                    //     textInputAction: TextInputAction.next,
                    //     controller: _txtVistaarakMonthCountCtrl,
                    //     decoration: InputDecoration(
                    //         labelText: Statics.getLabel('VistaarakMonthCount')),
                    //     keyboardType: TextInputType.number,
                    //     onSaved: (value) {
                    //       if (value != null && value.isNotEmpty)
                    //         swOtherInfo!.vistaarakMonthCount = int.parse(value);
                    //       else
                    //         swOtherInfo!.vistaarakMonthCount = null;
                    //     },
                    //   ),
                    // if (_hasbeenVistarak == true)
                    //   SizedBox(
                    //     height: 10,
                    //   ),
                    // if (_hasbeenVistarak == true)
                    //   TextFormField(
                    //     textInputAction: TextInputAction.next,
                    //     controller: _txtVistaarakYearCountCtrl,
                    //     decoration: InputDecoration(
                    //         labelText: Statics.getLabel('VistaarakYearCount')),
                    //     keyboardType: TextInputType.number,
                    //     onSaved: (value) {
                    //       if (value != null && value.isNotEmpty)
                    //         swOtherInfo!.vistaarakYearCount = int.parse(value);
                    //       else
                    //         swOtherInfo!.vistaarakYearCount = null;
                    //     },
                    //   ),
                    // if (_hasbeenVistarak == true)
                    //   SizedBox(
                    //     height: 10,
                    //   ),
                    // if (_hasBeenPrachaarak == true)
                    //   TextFormField(
                    //     textInputAction: TextInputAction.next,
                    //     controller: _txtPrachaarakYearCountCtrl,
                    //     decoration: InputDecoration(
                    //         labelText: Statics.getLabel('PrachaarakYearCount')),
                    //     keyboardType: TextInputType.number,
                    //     onSaved: (value) {
                    //       if (value != null && value.isNotEmpty)
                    //         swOtherInfo!.prachaarakYearCount = int.parse(value);
                    //       else
                    //         swOtherInfo!.prachaarakYearCount = null;
                    //     },
                    //   ),
                    SizedBox(
                      height: 40,
                    ),
                    Legend(legendString: 'SocialMedia', fontsize: 18),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _faceBookPageCntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('FaceBookPage')),
                      keyboardType: TextInputType.text,
                      maxLength: 100,
                      onSaved: (value) {
                        if (value!.isNotEmpty)
                          swOtherInfo!.facebookPage = value.trim();
                        else
                          swOtherInfo!.facebookPage = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _txtTwitterHandleCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('TwitterHandle')),
                      keyboardType: TextInputType.text,
                      maxLength: 100,
                      onSaved: (value) {
                        if (value!.isNotEmpty)
                          swOtherInfo!.twitterHandle = value.trim();
                        else
                          swOtherInfo!.twitterHandle = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _txtInstagramHandleCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('InstagramHandle')),
                      keyboardType: TextInputType.text,
                      maxLength: 100,
                      onSaved: (value) {
                        if (value!.isNotEmpty)
                          swOtherInfo!.instagramHandle = value.trim();
                        else
                          swOtherInfo!.instagramHandle = null;
                      },
                    ),
                    // SizedBox(
                    //   height: 10
                    // ),
                    // TextFormField(
                    //   textInputAction: TextInputAction.next,
                    //   controller: _txtKooHandleCtrl,
                    //   decoration: InputDecoration(labelText: Statics.getLabel('KooHandle')),
                    //   keyboardType: TextInputType.text,
                    //   maxLength: 100,
                    //   onSaved: (value) {
                    //     if (value!.isNotEmpty)
                    //       swOtherInfo!.kooHandle = value.trim();
                    //     else
                    //       swOtherInfo!.kooHandle = null;
                    //   },
                    // ),
                    SizedBox(height: 10),
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('SelectFacebookUsage')),
                      isExpanded: true,
                      value: _fbUsage == "" ? null : _fbUsage,
                      items: _usage,
                      onChanged: (value) {
                        setState(() {
                          _fbUsage = value;
                        });
                      },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swOtherInfo!.facebookUsage = value;
                        else
                          swOtherInfo!.facebookUsage = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('SelectTwitterUsage')),
                      isExpanded: true,
                      value: _twtUsage == "" ? null : _twtUsage,
                      items: _usage,
                      onChanged: (value) {
                        setState(() {
                          _twtUsage = value;
                        });
                      },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swOtherInfo!.twitterUsage = value;
                        else
                          swOtherInfo!.twitterUsage = null;
                      },
                    ),
                    SizedBox(height: 10),
                    // DropdownButtonFormField(
                    //   decoration: InputDecoration(labelText: Statics.getLabel('SelectKooUsage')),
                    //   isExpanded: true,
                    //   value: _kooUsage == "" ? null : _kooUsage,
                    //   items: _usage,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _kooUsage = value;
                    //     });
                    //   },
                    //   onSaved: (value) {
                    //     if (value != null && value.isNotEmpty)
                    //       swOtherInfo!.kooUsage = value;
                    //     else
                    //       swOtherInfo!.kooUsage = null;
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 10
                    // ),
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('SelectInstaUsage')),
                      isExpanded: true,
                      value: _instaUsage == "" ? null : _instaUsage,
                      items: _usage,
                      onChanged: (value) {
                        setState(() {
                          _instaUsage = value;
                        });
                      },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swOtherInfo!.instagramUsage = value;
                        else
                          swOtherInfo!.instagramUsage = null;
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Legend(legendString: 'AreasOfInterest', fontsize: 18),
                    Container(
                      width: Statics.getDeviceSize(context).width * 0.8,
                      height: Statics.getDeviceSize(context).height * 0.3,
                      child: ListView(
                        children: _areaOfInterest.map((area) {
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
                    SizedBox(height: 40),
                    Legend(legendString: 'AreaOfExpertise', fontsize: 18),
                    Container(
                      width: Statics.getDeviceSize(context).width * 0.8,
                      height: Statics.getDeviceSize(context).height * 0.3,
                      child: ListView(
                        children: _areaOfExpertise.map((area) {
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
                    // Legend(legendString: 'Sangha-PreritSansthaa', fontsize: 18),
                    // DropdownButtonFormField<dynamic>(
                    //   decoration: InputDecoration(
                    //       labelText: Statics.getLabel('SansthaaName')),
                    //   isExpanded: true,
                    //   value: _preritSansthaValue == ""
                    //       ? null
                    //       : _preritSansthaValue,
                    //   items: _sanghaPreritSanstha != null
                    //       ? _sanghaPreritSanstha
                    //           .map((bg) => DropdownMenuItem(
                    //               value:
                    //                   bg["SanghaPreritSansthaaID"].toString(),
                    //               child: Text(bg["SansthaaName"])))
                    //           .toList()
                    //       : [],
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _preritSansthaValue = value;
                    //     });
                    //   },
                    //   onSaved: (value) {
                    //     if (value != null && value.isNotEmpty)
                    //       swOtherInfo!.sanghaPreritSansthaaID = int.parse(value);
                    //     else
                    //       swOtherInfo!.sanghaPreritSansthaaID = null;
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // TextFormField(
                    //   textInputAction: TextInputAction.next,
                    //   controller: _preritDesgCtrl,
                    //   decoration: InputDecoration(
                    //       labelText: Statics.getLabel('Designation')),
                    //   keyboardType: TextInputType.text,
                    //   onSaved: (value) {
                    //     if (value != null && value.isNotEmpty)
                    //       swOtherInfo!.sanghaPreritSansthaaDesignation = value;
                    //     else
                    //       swOtherInfo!.sanghaPreritSansthaaDesignation = null;
                    //   },
                    // ),
                    // TextFormField(
                    //   textInputAction: TextInputAction.next,
                    //   controller: _preritRemarkCtrl,
                    //   decoration: InputDecoration(
                    //       labelText: Statics.getLabel('Remarks')),
                    //   keyboardType: TextInputType.text,
                    //   onSaved: (value) {
                    //     if (value != null && value.isNotEmpty)
                    //       swOtherInfo!.sanghaPreritSansthaaRemark = value;
                    //     else
                    //       swOtherInfo!.sanghaPreritSansthaaRemark = null;
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 40,
                    // ),
                    // Legend(
                    //     legendString: 'OtherSocialOrganization', fontsize: 18),
                    // TextFormField(
                    //   textInputAction: TextInputAction.next,
                    //   controller: _othOrgNameCtrl,
                    //   decoration: InputDecoration(
                    //       labelText: Statics.getLabel('SansthaaName')),
                    //   keyboardType: TextInputType.text,
                    //   onSaved: (value) {
                    //     if (value != null && value.isNotEmpty)
                    //       swOtherInfo!.otherSocialOrganizationName = value;
                    //     else
                    //       swOtherInfo!.otherSocialOrganizationName = null;
                    //   },
                    // ),
                    // SizedBox(height: 10),
                    // TextFormField(
                    //   textInputAction: TextInputAction.next,
                    //   controller: _othDesgCtrl,
                    //   decoration: InputDecoration(
                    //       labelText: Statics.getLabel('Designation')),
                    //   keyboardType: TextInputType.text,
                    //   onSaved: (value) {
                    //     if (value != null && value.isNotEmpty)
                    //       swOtherInfo!.otherSocialOrganizationDesignation =
                    //           value;
                    //     else
                    //       swOtherInfo!.otherSocialOrganizationDesignation = null;
                    //   },
                    // ),
                    // TextFormField(
                    //   textInputAction: TextInputAction.next,
                    //   controller: _othRemarksCtrl,
                    //   decoration: InputDecoration(
                    //       labelText: Statics.getLabel('Remarks')),
                    //   keyboardType: TextInputType.text,
                    //   onSaved: (value) {
                    //     if (value != null && value.isNotEmpty)
                    //       swOtherInfo!.otherSocialOrganizationRemark = value;
                    //     else
                    //       swOtherInfo!.otherSocialOrganizationRemark = null;
                    //   },
                    // ),
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
        ),
        inAsyncCall: _isfetingData);
  }
}
