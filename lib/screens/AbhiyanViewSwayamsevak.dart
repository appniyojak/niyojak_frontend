import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanListResponse.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanLoginDataResponse.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanSwayamsevakListResponse.dart';
import 'package:niyojak_prod/providers/bals.dart';
import 'package:niyojak_prod/providers/swayamsevak_provider.dart';
import 'package:niyojak_prod/widgets/swayamsevak_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/static_data.dart' as Statics;

class AbhiyanViewSwayamsevakScreen extends StatefulWidget {
  static const String routeName = '/abhiyan-view-swayamsevak-screen';

  State<StatefulWidget> createState() {
    return new AbhiyanViewSwayamsevakScreenState();
  }
}

class AbhiyanViewSwayamsevakScreenState extends State<AbhiyanViewSwayamsevakScreen> {
  AbhiyanSwayamsevakList? args;
  String? selectedAbhiyanValue = "";
  String? selectedSansthaValue = "";
  String? selectedDayitvValue = "";

  TextEditingController _anyaSansthaCntrl = TextEditingController();
  TextEditingController _sansthaNameCntrl = TextEditingController();
  TextEditingController _sansthaPadhCntrl = TextEditingController();
  TextEditingController _fullNameCntrl = TextEditingController();
  TextEditingController _emailCntrl = TextEditingController();
  TextEditingController _mobileCntrl = TextEditingController();

  List<LevelMasterBAL>? _level;
  List<GeoUnitMasterBAL>? _geoUnits;
  String? _levelValue = "";
  String? _geoUnitsValue = "";
  bool _isExpanded = false;

  bool _isSelectAll = false;

  List<dynamic>? _swList;
  List<String> strEmail = [];
  List<String> strMobile = [];
  bool? _isSearching = false;

  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;

  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";

  String? _sanghaShikshaVarsha = "";
  String? _vehicleValue = "";

  bool _isTrainedInMukhyaDanda = false;
  bool _isTrainedInMukhyaNiyuddha = false;
  bool _isTrainedInMukhyaPadavinyas = false;
  bool _isTrainedInMukhyaYogaasan = false;
  bool _isTrainedInMukhyaYogachaap = false;
  bool _isTrainedInMukhyaDandaYuddha = false;
  bool _isTrainedInAnyaDanda = false;
  bool _isTrainedInAnyaNiyuddha = false;
  bool _isTrainedInAnyaPadavinyas = false;
  bool _isTrainedInAnyaYogaasan = false;
  bool _isTrainedInAnyaYogachaap = false;
  bool _isTrainedInAnyaDandaYuddha = false;

  StaticMasterBAL? _daayitvaForValue;

  String? _daayitvaValue = "";

  bool _isGanveshComplete = false;
  bool _noCap = false;
  bool _noShirt = false;
  bool _noPant = false;
  bool _noBelt = false;
  bool _noShoes = false;
  bool _noSocks = false;
  bool _noDanda = false;

  bool? _isPratidnyit = null;

  StaticMasterBAL? _standardValue;

  bool _isTrainedInPrathamVanshi = false;
  bool _isTrainedInPrathamVenu = false;
  bool _isTrainedInPrathamAanak = false;
  bool _isTrainedInPrathamShankha = false;
  bool _isTrainedInPrathamNaagaanga = false;
  bool _isTrainedInPrathamTurya = false;
  bool _isTrainedInPrathamSwarad = false;
  bool _isTrainedInPrathamGomukha = false;

  bool _isTrainedInDwitiyaVanshi = false;
  bool _isTrainedInDwitiyaVenu = false;
  bool _isTrainedInDwitiyaAanak = false;
  bool _isTrainedInDwitiyaShankha = false;
  bool _isTrainedInDwitiyaNaagaanga = false;
  bool _isTrainedInDwitiyaTurya = false;
  bool _isTrainedInDwitiyaSwarad = false;
  bool _isTrainedInDwitiyaGomukha = false;

  bool _isTrainedInTrutiyaVanshi = false;
  bool _isTrainedInTrutiyaVenu = false;
  bool _isTrainedInTrutiyaAanak = false;
  bool _isTrainedInTrutiyaShankha = false;
  bool _isTrainedInTrutiyaNaagaanga = false;
  bool _isTrainedInTrutiyaTurya = false;
  bool _isTrainedInTrutiyaSwarad = false;
  bool _isTrainedInTrutiyaGomukha = false;

  bool _isTrainedInAnyaVanshi = false;
  bool _isTrainedInAnyaVenu = false;
  bool _isTrainedInAnyaAanak = false;
  bool _isTrainedInAnyaShankha = false;
  bool _isTrainedInAnyaNaagaanga = false;
  bool _isTrainedInAnyaTurya = false;
  bool _isTrainedInAnyaSwarad = false;
  bool _isTrainedInAnyaGomukha = false;

  bool? _isPrathamLipi = null;
  bool? _isDwitiyaLipi = null;
  bool? _isTrutiyaLipi = null;
  bool? _isAnyaLipi = null;

  String? _preritSansthaValue = "";
  var _othOrgNameCtrl = TextEditingController();
  String? _sortingOnValue = "Name";
  bool? _isMon = null;
  bool? _isTue = null;
  bool? _isWed = null;
  bool? _isThu = null;
  bool? _isFri = null;
  bool? _isSat = null;
  bool? _isSun = null;

  bool? _hasVehicleDriver = false;
  bool? _hasBeenShikshak = null;
  bool? _noDaayitva = null;
  bool? _pravaasi = null;

  final _searchController = TextEditingController();
  var _shikshaFromYearCntrl = TextEditingController();
  var _shikshaToYearCntrl = TextEditingController();

  var _schoolNameCntrl = TextEditingController();

  String? _bldGrpvalue = "";
  String? _mthrTngvalue = "";
  String? _shaakhaSanchalanvalue = "";

  int? _educationUniversityID = null;
  var _pratidnyaYearCtrl = TextEditingController();
  var _educationUniversityNameCntrl = TextEditingController();
  var _educationOthrUniversityNameCntrl = TextEditingController();
  int? _collegeID = null;
  var _collegeOthrNameCntrl = TextEditingController();
  var _educationStandardNameCntrl = TextEditingController();
  var _educationOthrStandardNameCntrl = TextEditingController();
  int? _educationProgramID = null;
  var _educationProgramName = TextEditingController();
  var _educationOthrProgramName = TextEditingController();
  int? _educationCourseID = null;
  var _educationCourseName = TextEditingController();
  var _educationOthrCourseName = TextEditingController();
  List<MenuChoices> choices = [];
  var _rachanaaCountPrathamCntrl = TextEditingController();
  var _rachanaaCountDwitiyaCntrl = TextEditingController();
  var _rachanaaCountTrutiyaCntrl = TextEditingController();
  var _rachanaaCountAnyaCntrl = TextEditingController();

  var _govtDeptCtrl = TextEditingController();
  var _organizationNameCtrl = TextEditingController();
  var _industrialVerticalCtrl = TextEditingController();
  var _officeLocationCtrl = TextEditingController();
  var _organizationAtRetirementCtrl = TextEditingController();
  var _desgAtRetirementCtrl = TextEditingController();
  var _deptAtRetirementCtrl = TextEditingController();

  StaticMasterBAL? _categoryValue;

  List newData = [];
  bool showFields = false;
  List<AbhiyaanList> abhiyaanDataList = [];
  AbhiyanSwayamsevakdata? initialData;

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

  Future<void> _search(String? strType) async {
    setState(() {
      _isSearching = true;
    });
    await _getSwList(strType);
    setState(() {
      _isSearching = false;
    });
  }

  Future populatelinkedBhaagDropdown() async {
    print("bhaag called");
    _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), "", "", "");
    setState(() {
      _linkedbhaag = data;
    });
    print("bhaag end");
  }

  Future populatelinkedShaharDropdown(String? bhaagIDStr) async {
    _linkedshaharValue = _linkedvastiValue = _linkedshahar = _linkedvasti = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
    setState(() {
      _linkedshahar = (shDD.length > 0 ? shDD : null);
    });
  }

  Future populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    }
  }

  Future populatelinkedMandalDropdown(String? nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
  }

  Future populatelinkedGraamDropdown(String? mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
  }

  Future populatelinkedVastiDropdown(String? nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
  }

  Future _getSwList(String? strType) async {
    print("calling");
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      int? bhaagVal = _linkedbhaagValue == null || _linkedbhaagValue == "" ? null : int.parse(_linkedbhaagValue!);
      int? shaharVal = _linkedshaharValue == null || _linkedshaharValue == "" ? null : int.parse(_linkedshaharValue!);
      int? nagarVal = _linkednagarValue == null || _linkednagarValue == "" ? null : int.parse(_linkednagarValue!);
      int? mandalVal = _linkedmandalValue == null || _linkedmandalValue == "" ? null : int.parse(_linkedmandalValue!);
      int? graamVal = _linkedgraamValue == null || _linkedgraamValue == "" ? null : int.parse(_linkedgraamValue!);
      int? vastiVal = _linkedvastiValue == null || _linkedvastiValue == "" ? null : int.parse(_linkedvastiValue!);

      int? geoUnitID;
      geoUnitID = vastiVal != null
          ? vastiVal
          : graamVal != null
              ? graamVal
              : mandalVal != null
                  ? mandalVal
                  : nagarVal != null
                      ? nagarVal
                      : shaharVal != null
                          ? shaharVal
                          : bhaagVal != null
                              ? bhaagVal
                              : null;

      String? mukhyaVishay = "";
      String? anyaVishay = "";

      if (_isTrainedInMukhyaDanda == true) mukhyaVishay += "Danda,";
      if (_isTrainedInMukhyaDandaYuddha == true) mukhyaVishay += "DandaYuddha,";
      if (_isTrainedInMukhyaNiyuddha == true) mukhyaVishay += "Niyuddha,";
      if (_isTrainedInMukhyaPadavinyas == true) mukhyaVishay += "PadaVinyaas,";
      if (_isTrainedInMukhyaYogaasan == true) mukhyaVishay += "Yogaasan,";
      if (_isTrainedInMukhyaYogachaap == true) mukhyaVishay += "YogaChaap,";

      mukhyaVishay = mukhyaVishay == "" ? null : mukhyaVishay.substring(0, mukhyaVishay.length - 1);

      if (_isTrainedInAnyaDanda == true) anyaVishay += "Danda,";
      if (_isTrainedInAnyaDandaYuddha == true) anyaVishay += "DandaYuddha,";
      if (_isTrainedInAnyaNiyuddha == true) anyaVishay += "Niyuddha,";
      if (_isTrainedInAnyaPadavinyas == true) anyaVishay += "PadaVinyaas,";
      if (_isTrainedInAnyaYogaasan == true) anyaVishay += "Yogaasan,";
      if (_isTrainedInAnyaYogachaap == true) anyaVishay += "YogaChaap,";

      anyaVishay = anyaVishay == "" ? null : anyaVishay.substring(0, anyaVishay.length - 1);

      String? prathamVaadya = "";
      if (_isTrainedInPrathamAanak == true) prathamVaadya += "Aanak,";
      if (_isTrainedInPrathamGomukha == true) prathamVaadya += "Gomukha,";
      if (_isTrainedInPrathamNaagaanga == true) prathamVaadya += "Naagaanga,";
      if (_isTrainedInPrathamShankha == true) prathamVaadya += "Shankha,";
      if (_isTrainedInPrathamSwarad == true) prathamVaadya += "Swarada,";
      if (_isTrainedInPrathamTurya == true) prathamVaadya += "Turya,";
      if (_isTrainedInPrathamVanshi == true) prathamVaadya += "Vanshi,";
      if (_isTrainedInPrathamVenu == true) prathamVaadya += "Venu,";

      prathamVaadya = prathamVaadya == "" ? null : prathamVaadya.substring(0, prathamVaadya.length - 1);

      String? dwitiyaVaadya = "";
      if (_isTrainedInDwitiyaAanak == true) dwitiyaVaadya += "Aanak,";
      if (_isTrainedInDwitiyaGomukha == true) dwitiyaVaadya += "Gomukha,";
      if (_isTrainedInDwitiyaNaagaanga == true) dwitiyaVaadya += "Naagaanga,";
      if (_isTrainedInDwitiyaShankha == true) dwitiyaVaadya += "Shankha,";
      if (_isTrainedInDwitiyaSwarad == true) dwitiyaVaadya += "Swarada,";
      if (_isTrainedInDwitiyaTurya == true) dwitiyaVaadya += "Turya,";
      if (_isTrainedInDwitiyaVanshi == true) dwitiyaVaadya += "Vanshi,";
      if (_isTrainedInDwitiyaVenu == true) dwitiyaVaadya += "Venu,";

      dwitiyaVaadya = dwitiyaVaadya == "" ? null : dwitiyaVaadya.substring(0, dwitiyaVaadya.length - 1);

      String? trutiyaVaadya = "";
      if (_isTrainedInTrutiyaAanak == true) trutiyaVaadya += "Aanak,";
      if (_isTrainedInTrutiyaGomukha == true) trutiyaVaadya += "Gomukha,";
      if (_isTrainedInTrutiyaNaagaanga == true) trutiyaVaadya += "Naagaanga,";
      if (_isTrainedInTrutiyaShankha == true) trutiyaVaadya += "Shankha,";
      if (_isTrainedInTrutiyaSwarad == true) trutiyaVaadya += "Swarada,";
      if (_isTrainedInTrutiyaTurya == true) trutiyaVaadya += "Turya,";
      if (_isTrainedInTrutiyaVanshi == true) trutiyaVaadya += "Vanshi,";
      if (_isTrainedInTrutiyaVenu == true) trutiyaVaadya += "Venu,";

      trutiyaVaadya = trutiyaVaadya == "" ? null : trutiyaVaadya.substring(0, trutiyaVaadya.length - 1);

      String? anyaVaadya = "";
      if (_isTrainedInAnyaAanak == true) anyaVaadya += "Aanak,";
      if (_isTrainedInAnyaGomukha == true) anyaVaadya += "Gomukha,";
      if (_isTrainedInAnyaNaagaanga == true) anyaVaadya += "Naagaanga,";
      if (_isTrainedInAnyaShankha == true) anyaVaadya += "Shankha,";
      if (_isTrainedInAnyaSwarad == true) anyaVaadya += "Swarada,";
      if (_isTrainedInAnyaTurya == true) anyaVaadya += "Turya,";
      if (_isTrainedInAnyaVanshi == true) anyaVaadya += "Vanshi,";
      if (_isTrainedInAnyaVenu == true) anyaVaadya += "Venu,";

      anyaVaadya = anyaVaadya == "" ? null : anyaVaadya.substring(0, anyaVaadya.length - 1);
      String? educationOrgName = "";

      if (_categoryValue != null) {
        if (_categoryValue!.code == "School Student") {
          educationOrgName = _schoolNameCntrl.text.isEmpty ? null : _schoolNameCntrl.text;
          _collegeID == null;
        } else if (_categoryValue!.code == 'Jr College') {
          _collegeID == null;
          educationOrgName = _collegeOthrNameCntrl.text.isEmpty ? null : _collegeOthrNameCntrl.text;
        } else if (_categoryValue!.code == 'Senior College' ||
            _categoryValue!.code == 'Post Graduate' ||
            _categoryValue!.code == 'Professional Studies' ||
            _categoryValue!.code == 'Correspondence Course') {
          educationOrgName = "";
        }
      }

      String? _weeklyOffDay = "";
      if (_isSun == true) _weeklyOffDay = _weeklyOffDay + "0,";
      if (_isMon == true) _weeklyOffDay = _weeklyOffDay + "1,";
      if (_isTue == true) _weeklyOffDay = _weeklyOffDay + "2,";
      if (_isWed == true) _weeklyOffDay = _weeklyOffDay + "3,";
      if (_isThu == true) _weeklyOffDay = _weeklyOffDay + "4,";
      if (_isFri == true) _weeklyOffDay = _weeklyOffDay + "5,";
      if (_isSat == true) _weeklyOffDay = _weeklyOffDay + "6,";

      _weeklyOffDay = _weeklyOffDay == "" ? null : _weeklyOffDay.substring(0, _weeklyOffDay.length - 1);

      var inputData = json.encode({
        "AppUserID": Statics.userDetails["userID"],
        // "AppUserID": "5693",
        "SearchCriteria": args!.participantNumber,
        "BloodGroupID": _bldGrpvalue == "" ? null : _bldGrpvalue,
        "MotherTongueID": _mthrTngvalue == "" ? null : _mthrTngvalue,
        "ShaakhaaExperienceYearID": _shaakhaSanchalanvalue == "" ? null : _shaakhaSanchalanvalue,
        "GeoUnitID": geoUnitID,
        "IsPratidnyit": _isPratidnyit,
        "PratidnyaYear": _pratidnyaYearCtrl.text.isEmpty ? null : _pratidnyaYearCtrl.text,
        "IsGanaveshComplete": _isGanveshComplete,
        "NoCap": _noCap,
        "NoShirt": _noShirt,
        "NoPant": _noPant,
        "NoBelt": _noBelt,
        "NoShoes": _noShoes,
        "NoSocks": _noSocks,
        "NoDanda": _noDanda,
        "VehicleType": _vehicleValue == "" ? null : _vehicleValue,
        "HasDriver": _hasVehicleDriver,
        "SanghaShikshanCode": _sanghaShikshaVarsha == "" ? null : _sanghaShikshaVarsha,
        "SanghaShikshanYearFrom": _shikshaFromYearCntrl.text.isEmpty ? null : _shikshaFromYearCntrl.text,
        "SanghaShikshanYearTo": _shikshaToYearCntrl.text.isEmpty ? null : _shikshaToYearCntrl.text,
        "HasBeenOTCShikshak": _hasBeenShikshak,
        "MukhyaShaaririkVishayCodes": mukhyaVishay == "" ? null : mukhyaVishay,
        "AnyaShaaririkVishayCodes": anyaVishay == "" ? null : anyaVishay,
        "PrathamVaadyaCodes": prathamVaadya == "" ? null : prathamVaadya,
        "DwitiyaVaadyaCodes": dwitiyaVaadya == "" ? null : dwitiyaVaadya,
        "TrutiyaVaadyaCodes": trutiyaVaadya == "" ? null : trutiyaVaadya,
        "AnyaVaadyaCodes": anyaVaadya == "" ? null : anyaVaadya,
        "IsUnderstandLipiPrathamVaadya": _isPrathamLipi,
        "IsUnderstandLipiDwitiyaVaadya": _isDwitiyaLipi,
        "IsUnderstandLipiTrutiyaVaadya": _isTrutiyaLipi,
        "IsUnderstandLipiAnyaVaadya": _isAnyaLipi,
        "RachanaaCountPrathamVaadya": _rachanaaCountPrathamCntrl.text.isEmpty ? null : _rachanaaCountPrathamCntrl.text,
        "RachanaaCountDwitiyaVaadya": _rachanaaCountDwitiyaCntrl.text.isEmpty ? null : _rachanaaCountDwitiyaCntrl.text,
        "RachanaaCountTrutiyaVaadya": _rachanaaCountTrutiyaCntrl.text.isEmpty ? null : _rachanaaCountTrutiyaCntrl.text,
        "RachanaaCountAnyaVaadya": _rachanaaCountAnyaCntrl.text.isEmpty ? null : _rachanaaCountAnyaCntrl.text,
        "OccupationCategoryID": _categoryValue == null ? null : _categoryValue!.staticID,
        "EducationUniversityID": _educationUniversityID,
        "EducationUniversityName": _educationUniversityNameCntrl.text.trim() != "Other"
            ? null
            : _educationOthrUniversityNameCntrl.text.trim() == ""
                ? null
                : _educationOthrUniversityNameCntrl.text,
        "EducationInstitutionID": _collegeID,
        "EducationInstitutionName": educationOrgName == "" ? null : educationOrgName,
        "EducationProgramID": _educationProgramID,
        "EducationProgramName": _educationProgramName.text.trim() != "Other"
            ? null
            : _educationOthrProgramName.text.trim() == ""
                ? null
                : _educationOthrProgramName.text,
        "EducationCourseID": _educationCourseID,
        "EducationCourseName": _educationCourseName.text.trim() != "Other"
            ? null
            : _educationOthrCourseName.text.trim() == ""
                ? null
                : _educationOthrCourseName.text,
        "EducationStandardID": _standardValue == null ? null : _standardValue!.staticID,
        "EducationStandardName": _standardValue != null && _standardValue!.code == "Other"
            ? _educationOthrStandardNameCntrl.text.trim() == ""
                ? null
                : _educationStandardNameCntrl.text
            : null,
        "GovernmentDepartment": _govtDeptCtrl.text.isEmpty ? null : _govtDeptCtrl.text,
        "Designation": null,
        "OfficeLocation": _officeLocationCtrl.text.isEmpty ? null : _officeLocationCtrl.text,
        "WeeklyOffDayIDs": _weeklyOffDay,
        "OrganizationName": _organizationNameCtrl.text.isEmpty ? null : _organizationNameCtrl.text,
        "IndustryVertical": _industrialVerticalCtrl.text.isEmpty ? null : _industrialVerticalCtrl.text,
        "OrganizationAtRetirement": _organizationAtRetirementCtrl.text.isEmpty ? null : _organizationAtRetirementCtrl.text,
        "DesignationAtRetirement": _desgAtRetirementCtrl.text.isEmpty ? null : _desgAtRetirementCtrl.text,
        "DepartmentAtRetirement": _deptAtRetirementCtrl.text.isEmpty ? null : _deptAtRetirementCtrl.text,
        "DaayitvaForID": _daayitvaForValue == null ? null : _daayitvaForValue!.staticID,
        "DaayitvaID": _daayitvaValue == "" ? null : _daayitvaValue,
        "DaayitvaLevelID": _levelValue == "" ? null : _levelValue,
        "DaayitvaGeoUnitID": _geoUnitsValue == "" ? null : _geoUnitsValue,
        "IsNoDaayitva": _noDaayitva,
        "IsPravaasi": _pravaasi,
        "SanghaPreritSansthaaID": _preritSansthaValue == "" ? null : _preritSansthaValue,
        "SocialOrganizationName": _othOrgNameCtrl.text.isEmpty ? null : _othOrgNameCtrl.text,
        "SortOrder": _sortingOnValue == "Name" ? "FullName" : "SwayamsevakID",
      });
      if (strType == "Search") {
        newData = await SwayamsevakProvider().getAbhiyanSwayamsevaks(inputData);
        if (newData.isEmpty) {
          _mobileCntrl.text = _searchController.text;
          showFields = true;
          setState(() {});
        }
        return newData;
      } else if (strType == "Export") {
        SwayamsevakProvider().getSwayamsevaksForExport(inputData);
        return null;
      } else {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
        return null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await getAbhiyaanListData();
    populatelinkedBhaagDropdown();
    _level = await Statics.getLevelLDB();
    _level!.removeWhere((element) => element.levelName == "Shaakhaa");
    _level!.removeWhere((element) => element.levelName == "Shahar");
    _level!.removeWhere((element) => element.levelName == "Kshetra");
    _level!.removeWhere((element) => element.levelName == "Akhil Bhaaratiya");
    // _search("Search");
    await getInitialData();
    setState(() {});
    await setData();
    setState(() {});
  }

  getInitialData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = pref.getString("AbhiyanSwayamsevakData");
    if (data != null) {
      initialData = AbhiyanSwayamsevakdata.fromJson(jsonDecode(data));
    }
  }

  setData() async {
    selectedAbhiyanValue = args!.abhiyanID.toString();
    if (args!.swayamsevakID == 0) {
      showFields = true;
      _fullNameCntrl.text = args!.participantName!;
      _mobileCntrl.text = args!.participantNumber!;
      _emailCntrl.text = args!.email!;
      selectedSansthaValue = args!.sansthaType;
      _sansthaNameCntrl.text = args!.sansthaName!;
      _sansthaPadhCntrl.text = args!.sansthaPadh!;
      _isExpanded = true;
      _linkedbhaagValue = args!.bhaagId.toString();
      await populatelinkedNagarDropdown(_linkedbhaagValue, null);
      setState(() {});
      _linkednagarValue = args!.nagarId.toString();
      await populatelinkedMandalDropdown(_linkednagarValue);
      await populatelinkedVastiDropdown(_linkednagarValue);
      setState(() {});
      _linkedmandalValue = args!.mandalId == 0 ? null : args!.mandalId.toString();
      await populatelinkedGraamDropdown(_linkedmandalValue);
      setState(() {});
      print(args!.gramId);
      print(args!.vastiId);
      _linkedgraamValue = args!.gramId == 0 ? null : args!.gramId.toString();
      _linkedvastiValue = args!.vastiId == 0 ? null : args!.vastiId.toString();

      // if(initialData != null){
      //   setState(() {
      //     if(initialData.parentBhaagID != null){
      //       _isExpanded = true;
      //       _linkedbhaagValue = initialData.parentBhaagID.toString();
      //       populatelinkedNagarDropdown(_linkedbhaagValue, null);
      //     }
      //     if(initialData.parentNagarID != null){
      //       _isExpanded = true;
      //       _linkednagarValue = initialData.parentNagarID.toString();
      //       populatelinkedMandalDropdown(_linkednagarValue);
      //       populatelinkedVastiDropdown(_linkednagarValue);
      //     }
      //     if(initialData.parentMandalID != null){
      //       _isExpanded = true;
      //       _linkedmandalValue = initialData.parentMandalID.toString();
      //       populatelinkedGraamDropdown(_linkedmandalValue);
      //     }
      //     if(initialData.levelName == "Vasti" && initialData.geoUnitID != null){
      //       _isExpanded = true;
      //       _linkedvastiValue = initialData.geoUnitID.toString();
      //     } else if (initialData.levelName == "Graam" &&initialData.geoUnitID != null){
      //       _isExpanded = true;
      //       _linkedgraamValue = initialData.geoUnitID.toString();
      //     }
      //   });
      // }
    } else {
      await _search("Search");
      setState(() {});
    }
    setState(() {
      _isSearching = true;
    });
    _levelValue = args!.levelID.toString();
    await populateGeoUnits(args!.levelID.toString());
    _geoUnitsValue = args!.levelName.toString();
    selectedDayitvValue = args!.daayityaName;
    setState(() {
      _isSearching = false;
    });

    setState(() {});
  }

  getAbhiyaanListData() async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        setState(() {
          _isSearching = true;
        });
        var result = await SwayamsevakProvider().getAbhiyanList();
        if (result.status == "200") {
          print("succeed");
          abhiyaanDataList = result.abhiyaanList!;
          selectedAbhiyanValue = abhiyaanDataList.first.abhiyaanID.toString();
          setState(() {
            _isSearching = false;
          });
        } else {
          setState(() {
            _isSearching = false;
          });
          Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
        }
      }
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
    }
  }

  saveAbhiyaanSwayamsevakCall() async {
    try {
      List<UserDataBAL> user = await Statics.getUserDataLDB();

      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        var data = {
          "AbhiyanSwayamsevakID": args!.abhiyanSwayamsevakID,
          "AbhiyaanID": selectedAbhiyanValue,
          "SwayamsevakID": newData.isNotEmpty ? newData.first['SwayamsevakID'] : "",
          "MobileNo": newData.isNotEmpty ? args!.participantNumber : _mobileCntrl.text,
          // "MobileNo": _mobileCntrl.text,
          "full_name": _fullNameCntrl.text,
          "Email": _emailCntrl.text,
          "samajik_sanstha": selectedSansthaValue,
          "sanstha_name": _sansthaNameCntrl.text,
          "SansthaPadh": _sansthaPadhCntrl.text,
          "DaayitvaName": selectedDayitvValue,
          "bhaag_id": _linkedbhaagValue != null && _linkedbhaagValue!.isNotEmpty ? int.parse(_linkedbhaagValue!) : 0,
          "nagar_id": _linkednagarValue != null && _linkednagarValue!.isNotEmpty ? int.parse(_linkednagarValue!) : 0,
          "vasti_id": _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? int.parse(_linkedvastiValue!) : 0,
          "mandal_id": _linkedmandalValue != null && _linkedmandalValue!.isNotEmpty ? int.parse(_linkedmandalValue!) : 0,
          "gram_id": _linkedgraamValue != null && _linkedgraamValue!.isNotEmpty ? int.parse(_linkedgraamValue!) : 0,
          "LevelID": _levelValue,
          "LevelName": _geoUnitsValue,
          "AbhiyanDaayitvaID": 0,
          "Mahangarid": 0,
          "Vibhagid": 0,
        };

        var result = await SwayamsevakProvider().saveAbhiyanSwayamsevak(jsonEncode(data));
        if (result.status == "200") {
          print("succeed");
          Statics.showToast(result.message);
          // setState(() {});
          Navigator.of(context).pop();
        } else {
          Statics.showToast(result.message);
        }
      }
    } catch (e) {
      Statics.showToast(Statics.getLabel('unableToSaveData'));
    }
  }

  populateGeoUnits(String? levelID) async {
    var data4;
    if (levelID == "") {
      data4 = await Statics.getGeoUnitsByLevel(Statics.levels['MahaanagarLevelID']);
    } else
      data4 = await Statics.getGeoUnitsByLevel(levelID!);
    if (!mounted) return;
    setState(() {
      _geoUnits = data4;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as AbhiyanSwayamsevakList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('सहभागी कार्यकर्ता माहिती'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isSearching!,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: IgnorePointer(
              ignoring: false,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        "अभियान  :",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.88,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                        child: DropdownButton(
                          isExpanded: true,
                          isDense: true,
                          iconSize: 30,
                          underline: SizedBox(),
                          value: selectedAbhiyanValue == "" ? null : selectedAbhiyanValue,
                          onChanged: (newValue) {
                            // print(newValue);
                            // setState(() {
                            //   selectedAbhiyanValue = newValue;
                            // });
                          },
                          items: abhiyaanDataList.map((value) {
                            return DropdownMenuItem(
                              value: value.abhiyaanID.toString(),
                              child: Text(value.abhiyaanName!),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "${Statics.getLabel('Search')}              :",
                  //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  //     ),
                  //     Container(
                  //       width: MediaQuery.of(context).size.width * 0.6,
                  //       // margin: EdgeInsets.only(right: 5),
                  //       alignment: Alignment.center,
                  //       child: TextField(
                  //         controller: _searchController,
                  //         style: TextStyle(fontSize: 16),
                  //         autofocus: false,
                  //         onChanged: (v) {
                  //           if (v.isEmpty) {
                  //             showFields = false;
                  //           }
                  //           setState(() {});
                  //         },
                  //         inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                  //         keyboardType: TextInputType.phone,
                  //         decoration: InputDecoration(
                  //           isDense: true,
                  //           contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  //           suffixIcon: InkWell(
                  //             onTap: () async {
                  //               FocusScope.of(context).unfocus();
                  //               if (_searchController.text.length < 10) {
                  //                 Statics.showToast(Statics.getLabel('MobileValidationMessage'));
                  //                 return null;
                  //               }
                  //               await _search("Search");
                  //               setState(() {});
                  //             },
                  //             borderRadius: BorderRadius.circular(30),
                  //             child: Icon(
                  //               Icons.search,
                  //               size: 25,
                  //             ),
                  //           ),
                  //           border: OutlineInputBorder(
                  //               borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                  //           enabledBorder: OutlineInputBorder(
                  //               borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                  //           focusedBorder: OutlineInputBorder(
                  //               borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  if (newData.isNotEmpty && args!.participantNumber != null && args!.participantNumber!.isNotEmpty)
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(5.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: newData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return AbhiyanSwayamsevakCard(newData[index], _search);
                        },
                      ),
                    ),
                  // if (_isSearching)
                  // Container(
                  //     height: MediaQuery.of(context).size.height * 0.2,
                  //     width: MediaQuery.of(context).size.width,
                  //     padding: const EdgeInsets.all(5.0),
                  //     child: Center(
                  //       child: CircularProgressIndicator(),
                  //     )),
                  if (newData.isNotEmpty && _searchController.text.isNotEmpty)
                    SizedBox(
                      height: 15,
                    ),
                  if (showFields)
                    Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _fullNameCntrl,
                          decoration: InputDecoration(
                            labelText: Statics.getLabel('FullName'),
                            isDense: true,
                            border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) return (Statics.getLabel('FullNameValidationMessage'));
                            return null;
                          },
                          onSaved: (value) {
                            // swDetails.fullName = value.trim();
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _mobileCntrl,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: Statics.getLabel('Mobile'),
                            isDense: true,
                            border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          ),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                          validator: (value) {
                            if (value!.isEmpty || value.trim().length < 10) return (Statics.getLabel('MobileValidationMessage'));
                            return null;
                          },
                          onSaved: (value) {
                            // swDetails.mobileNumber = value.trim();
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _emailCntrl,
                          decoration: InputDecoration(
                            labelText: Statics.getLabel('Email'),
                            isDense: true,
                            border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) return (Statics.getLabel('ValidEmailBodyValidationMessage'));
                            return null;
                          },
                          onSaved: (value) {
                            // swDetails.fullName = value.trim();
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(width: 0.7, color: Colors.grey.shade700)),
                          child: ExpansionPanelList(
                            elevation: 0,
                            expandedHeaderPadding: EdgeInsets.zero,
                            expansionCallback: (int? index, bool isExpanded) {
                              setState(() {
                                _isExpanded = isExpanded;
                                // if(_swSthaanList != null){
                                //   _search2("Search");
                                // }
                              });
                            },
                            children: [
                              ExpansionPanel(
                                backgroundColor: Colors.transparent,
                                headerBuilder: (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text(Statics.getLabel('SelectGeoUnit')),
                                  );
                                },
                                body: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      if (_linkedbhaag != null)
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                                          isExpanded: true,
                                          value: _linkedbhaagValue == "" ? null : _linkedbhaagValue,
                                          items: _linkedbhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                          onChanged: (value) {
                                            // setState(() {
                                            //   _linkedbhaagValue = value;
                                            //   populatelinkedShaharDropdown(value);
                                            //   populatelinkedNagarDropdown(value, null);
                                            // });
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
                                            // setState(() {
                                            //   _linkedshaharValue = value;
                                            //   populatelinkedNagarDropdown(null, value);
                                            // });
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
                                            // setState(() {
                                            //   _linkednagarValue = value;
                                            //   populatelinkedMandalDropdown(value);
                                            //   populatelinkedVastiDropdown(value);
                                            // });
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
                                            // setState(() {
                                            //   _linkedmandalValue = value;
                                            //   populatelinkedGraamDropdown(value);
                                            // });
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
                                            // setState(() {
                                            //   _linkedgraamValue = value;
                                            // });
                                          },
                                        ),
                                      if (_linkedvasti != null && _linkedvasti!.length > 0)
                                        DropdownButtonFormField(
                                          decoration: InputDecoration(labelText: Statics.getLabel('Vasti')),
                                          isExpanded: true,
                                          value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                                          items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                          onChanged: (value) {
                                            // setState(() {
                                            //   _linkedvastiValue = value;
                                            // });
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                                isExpanded: _isExpanded,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 9.0),
                              child: Text(
                                "${Statics.getLabel('shreni')} :",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.58,
                              // margin: EdgeInsets.only(right: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      isDense: true,
                                      iconSize: 30,
                                      underline: SizedBox(),
                                      value: selectedSansthaValue == "" ? null : selectedSansthaValue,
                                      onChanged: (String? newValue) {
                                        //   setState(() {
                                        //     selectedSansthaValue = newValue;
                                        //   });
                                      },
                                      items: <String>["धार्मिक", "सामाजिक", "शैक्षणिक", "सेवा", "सांस्कृतिक", "अन्य"].map<DropdownMenuItem<String>>((String? value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 3.0),
                                            child: Text(value!),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  if (selectedSansthaValue == "अन्य")
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: TextFormField(
                                        autofocus: true,
                                        textInputAction: TextInputAction.done,
                                        controller: _anyaSansthaCntrl,
                                        decoration: InputDecoration(
                                          hintText: "संस्था कुठल्या विषयात काम करते",
                                        ),
                                        keyboardType: TextInputType.text,
                                        onSaved: (value) {
                                          // swDetails.fullName = value.trim();
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _sansthaNameCntrl,
                          decoration: InputDecoration(
                            labelText: "${Statics.getLabel('OrganizationName')}",
                            isDense: true,
                            border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          ),
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            // swDetails.fullName = value.trim();
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _sansthaPadhCntrl,
                          decoration: InputDecoration(
                            labelText: "${Statics.getLabel('sansthetKuthalaPadavar')}",
                            isDense: true,
                            border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          ),
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            // swDetails.fullName = value.trim();
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${Statics.getLabel('SelectLevel')}    :",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      if (_level != null)
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            isDense: true,
                            iconSize: 30,
                            underline: SizedBox(),
                            value: _levelValue == "" ? null : _levelValue,
                            onChanged: (String? newValue) {
                              // setState(() {
                              //   selectedDayitvValue = "";
                              //   _levelValue = newValue;
                              //   _geoUnitsValue = "";
                              //   print(newValue);
                              // });
                              // populateGeoUnits(newValue);
                            },
                            items: _level!
                                .map((bg) => DropdownMenuItem(
                                    value: bg.levelID.toString(),
                                    child: Text(bg.levelName == "Bhaag"
                                        ? "Bhaag / Jilha"
                                        : bg.levelName == "Nagar"
                                            ? "Nagar / Taluka"
                                            : bg.levelName!)))
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                  if (_levelValue != "")
                    SizedBox(
                      height: 15,
                    ),
                  if (_levelValue != "")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${Statics.getLabel('SelectLevelName')}     :",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        if (_geoUnits != null)
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              isDense: true,
                              iconSize: 30,
                              underline: SizedBox(),
                              value: _geoUnitsValue == "" ? null : _geoUnitsValue,
                              onChanged: (String? newValue) {
                                // selectedDayitvValue = "";
                                // _geoUnitsValue = newValue;
                                // print(newValue);
                                // setState(() {});
                              },
                              items: _geoUnits!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            ),
                          ),
                      ],
                    ),
                  SizedBox(
                    height: 15,
                  ),
                  if (_levelValue != "" && _geoUnitsValue != "")
                    // _levelValue == "2" || _levelValue == "3"
                    //     ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "दायित्व             :",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            isDense: true,
                            iconSize: 30,
                            underline: SizedBox(),
                            value: selectedDayitvValue == "" ? null : selectedDayitvValue,
                            onChanged: (String? newValue) {
                              // setState(() {
                              //   selectedDayitvValue = newValue;
                              // });
                            },
                            items: <String>["अभियान प्रमुख", "अभियान सह प्रमुख", "अभियान टोळी सदस्य"].map<DropdownMenuItem<String>>((String? value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Text(value!),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  //     : Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "दायित्व             :",
                  //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  //     ),
                  //     Container(
                  //       width: MediaQuery.of(context).size.width * 0.6,
                  //       alignment: Alignment.center,
                  //       padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                  //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                  //       child: DropdownButton<String>(
                  //         isExpanded: true,
                  //         isDense: true,
                  //         iconSize: 30,
                  //         underline: SizedBox(),
                  //         value: selectedDayitvValue == "" ? null : selectedDayitvValue,
                  //         onChanged: (String? newValue) {
                  //           // setState(() {
                  //           //   selectedDayitvValue = newValue;
                  //           // });
                  //         },
                  //         items: <String>["अभियान प्रमुख", "अभियान सह प्रमुख","अभियान टोळी सदस्य"].map<DropdownMenuItem<String>>((String? value) {
                  //           return DropdownMenuItem<String>(
                  //             value: value,
                  //             child: Padding(
                  //               padding: const EdgeInsets.only(top: 3.0),
                  //               child: Text(value!),
                  //             ),
                  //           );
                  //         }).toList(),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                  // MaterialButton(
                  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: 15,
                  //     vertical: 8,
                  //   ),
                  //   color: Theme.of(context).primaryColor,
                  //   textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                  //   onPressed: () async {
                  //     if (selectedAbhiyanValue!.isEmpty) {
                  //       print("अभियान निवडा");
                  //       Statics.showToast("अभियान निवडा");
                  //       return null;
                  //     } else if (showFields && _fullNameCntrl.text.isEmpty) {
                  //       print("पूर्ण नाव प्रविष्ट करा");
                  //       Statics.showToast("पूर्ण नाव प्रविष्ट करा");
                  //       return null;
                  //     } else if (showFields && _mobileCntrl.text.isEmpty) {
                  //       print("मोबाइल क्रमांक प्रविष्ट करा");
                  //       Statics.showToast("मोबाइल क्रमांक प्रविष्ट करा");
                  //       return null;
                  //     } else if (showFields && _linkedvastiValue == null && _linkedgraamValue == null) {
                  //       print("निवास स्थान निवडा");
                  //       Statics.showToast("निवास स्थान निवडा");
                  //       return null;
                  //     } else if (showFields && selectedSansthaValue == "अन्य" && _anyaSansthaCntrl.text.isEmpty) {
                  //       print("अन्य संस्था प्रविष्ट करा");
                  //       Statics.showToast("अन्य संस्था प्रविष्ट करा");
                  //       return null;
                  //     } else if (showFields && selectedSansthaValue != "" && _sansthaNameCntrl.text.isEmpty) {
                  //       print("संस्थेचे नाव प्रविष्ट करा");
                  //       Statics.showToast("संस्थेचे नाव प्रविष्ट करा");
                  //       return null;
                  //     } else if (showFields && selectedSansthaValue != "" && _sansthaPadhCntrl.text.isEmpty) {
                  //       print("संस्थेमध्ये पद प्रविष्ट करा");
                  //       Statics.showToast("संस्थेमध्ये पद प्रविष्ट करा");
                  //       return null;
                  //     } else if (_levelValue!.isEmpty) {
                  //       print("${Statics.getLabel('selectStar')}");
                  //       Statics.showToast("${Statics.getLabel('selectStar')}");
                  //       return null;
                  //     } else if (_geoUnitsValue!.isEmpty) {
                  //       print("स्तराचे नाव निवडा");
                  //       Statics.showToast("स्तराचे नाव निवडा");
                  //       return null;
                  //     } else if (selectedDayitvValue!.isEmpty) {
                  //       print("दायित्व निवडा");
                  //       Statics.showToast("दायित्व निवडा");
                  //       return null;
                  //     } else {
                  //       if (!showFields && newData.isEmpty) {
                  //         Statics.showToast("मोबाइल क्रमांक प्रविष्ट करा");
                  //         return null;
                  //       }
                  //       print("saving data");
                  //
                  //       // await saveAbhiyaanSwayamsevakCall();
                  //     }
                  //     // _submit(context);
                  //   },
                  //   child: Text(
                  //     Statics.getLabel('Submit'),
                  //     style: TextStyle(fontSize: 22),
                  //   ),
                  // ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
