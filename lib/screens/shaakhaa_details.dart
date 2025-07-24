import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helpers/static_data.dart' as Statics;
import '../providers/bals.dart';
import '../providers/swayamsevak_provider.dart';

enum SankalpAadhaarEnum { Kaaryakartaa, Shaakhaa }

class ShaakhaaDetails extends StatefulWidget {
  var shaakhaaId;
  var onSaveDetails;
  var viewType;
  ShaakhaaDetails(
      {Key? key, this.shaakhaaId, this.onSaveDetails, this.viewType})
      : super(key: key);
  State<StatefulWidget> createState() {
    return new ShaakhaaDetailState();
  }
}

class ShaakhaaDetailState extends State<ShaakhaaDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  bool _isfetchingData = false;

  List<GeoUnitMasterBAL>? _bhaag;
  List<GeoUnitMasterBAL>? _shahar;
  List<GeoUnitMasterBAL>? _nagar;
  List<GeoUnitMasterBAL>? _mandal;
  List<GeoUnitMasterBAL>? _graam;
  List<GeoUnitMasterBAL>? _vasti;

  bool _isSankalpit = false;
  SankalpAadhaarEnum _sankalpAadhaarEnum = SankalpAadhaarEnum.Kaaryakartaa;
  // SankalpAadhaarEnum _sankalpAadhaarEnum1 = SankalpAadhaarEnum.Kaaryakartaa;
  // SankalpAadhaarEnum _sankalpAadhaarEnum2 = SankalpAadhaarEnum.Kaaryakartaa;
  // SankalpAadhaarEnum _sankalpAadhaarEnum3 = SankalpAadhaarEnum.Kaaryakartaa;
  int? _sankalpAadhaarSwayamsevakID, _sankalpAadhaarShaakhaaID;
  // int? _sankalpAadhaarSwayamsevakID1, _sankalpAadhaarShaakhaaID1;
  // int? _sankalpAadhaarSwayamsevakID2, _sankalpAadhaarShaakhaaID2;
  // int? _sankalpAadhaarSwayamsevakID3, _sankalpAadhaarShaakhaaID3;
  var _sankalpCompletionMonthCtrl = TextEditingController();
  // var _sankalpCompletionMonthCtrl1 = TextEditingController();
  // var _sankalpCompletionMonthCtrl2 = TextEditingController();
  // var _sankalpCompletionMonthCtrl3 = TextEditingController();
  var _sankalpCompletionYearCtrl = TextEditingController();
  // var _sankalpCompletionYearCtrl1 = TextEditingController();
  // var _sankalpCompletionYearCtrl2 = TextEditingController();
  // var _sankalpCompletionYearCtrl3 = TextEditingController();
  var _sankalpAadhaarSwayamsevakCtrl = TextEditingController();
  // var _sankalpAadhaarSwayamsevakCtrl1 = TextEditingController();
  // var _sankalpAadhaarSwayamsevakCtrl2 = TextEditingController();
  // var _sankalpAadhaarSwayamsevakCtrl3 = TextEditingController();
  var _sankalpAadhaarShaakhaaCtrl = TextEditingController();
  // var _sankalpAadhaarShaakhaaCtrl1 = TextEditingController();
  // var _sankalpAadhaarShaakhaaCtrl2 = TextEditingController();
  // var _sankalpAadhaarShaakhaaCtrl3 = TextEditingController();
  String _sankalpAadhaarSwayamsevakValue = "";
  // String _sankalpAadhaarSwayamsevakValue1 = "";
  // String _sankalpAadhaarSwayamsevakValue2 = "";
  // String _sankalpAadhaarSwayamsevakValue3 = "";
  String _sankalpAadhaarShaakhaaValue = "";
  bool _isMon = false;
  bool _isTue = false;
  bool _isWed = false;
  bool _isThu = false;
  bool _isFri = false;
  bool _isSat = false;
  bool _isSun = false;

  bool _hasToli = false;
  bool _hasPaalak = false;

  var _dayOfMonthCtrl = TextEditingController();
  var _locationCtrl = TextEditingController();
  //var _timingCtrl = TextEditingController();
  var _remarkCtrl = TextEditingController();
  var _shaakhaanameCtrl = TextEditingController();

  var _otherOptionalVishayCtrl = TextEditingController();

  List<StaticMasterBAL>? _frequency;
  List<StaticMasterBAL>? _vayogat;
  List<StaticMasterBAL>? _status;
  List<StaticMasterBAL>? _shaaririkVishay;

  ShaakhaaMasterBAL? shaakhaa;

  String? _frequencyValue;
  String? _vayogatValue;
  String? _statusValue;

  String? _sharirikVishayValue;

  String? _bhaagValue = "";
  String? _shaharValue = "";
  String? _nagarValue = "";
  String? _mandalValue = "";
  String? _vastiValue = "";
  String? _graamValue = "";

  String? _dayofWeekValue;

  TimeOfDay? _fromTime;
  var _fromTimeCntrl = TextEditingController();

  TimeOfDay? _toTime;
  var _toTimeCntrl = TextEditingController();

  var bhaagID;

  @override
  void initState() {
    super.initState();
    populateDropdown();
    int shaakhaaID = int.parse(widget.shaakhaaId);
    if (shaakhaaID > 0) {
      getShaakhaaDetails(widget.shaakhaaId);
    } else {
      if (!mounted) return;
      setState(() {
        shaakhaa = new ShaakhaaMasterBAL(
            shaakhaaID,
            1,
            null,
            "",
            null,
            null,
            "",
            null,
            "",
            "",
            "",
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            false,
            "",
            // "","","",
            null,
            // null, null, null,
            "",
            // "","","",
            null,
            // null,null,null,
            "",
            // "","","",
            0,
            // 0,0,0,
            0,
            // 0, 0, 0,
            false,
            false,
            null,
            "",
            "",
            "");
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _dayOfMonthCtrl.dispose();
    _locationCtrl.dispose();
    //_timingCtrl.dispose();
    _fromTimeCntrl.dispose();
    _toTimeCntrl.dispose();
    _remarkCtrl.dispose();
    _shaakhaanameCtrl.dispose();
    _otherOptionalVishayCtrl.dispose();
    _sankalpCompletionMonthCtrl.dispose();
    // _sankalpCompletionMonthCtrl1.dispose();
    // _sankalpCompletionMonthCtrl2.dispose();
    // _sankalpCompletionMonthCtrl3.dispose();
    _sankalpCompletionYearCtrl.dispose();
    // _sankalpCompletionYearCtrl1.dispose();
    // _sankalpCompletionYearCtrl2.dispose();
    // _sankalpCompletionYearCtrl3.dispose();
    _sankalpAadhaarShaakhaaCtrl.dispose();
    // _sankalpAadhaarShaakhaaCtrl1.dispose();
    // _sankalpAadhaarShaakhaaCtrl2.dispose();
    // _sankalpAadhaarShaakhaaCtrl3.dispose();
    _sankalpAadhaarSwayamsevakCtrl.dispose();
    // _sankalpAadhaarSwayamsevakCtrl1.dispose();
    // _sankalpAadhaarSwayamsevakCtrl2.dispose();
    // _sankalpAadhaarSwayamsevakCtrl3.dispose();
  }

  void populateDropdown() async {
    var data = await Statics.getStaticLDB('ShaakhaaFrequency');
    var data2 = await Statics.getStaticLDB('ShaakhaaVayogat');
    var data3 = await Statics.getStaticLDB('ShaakhaaStatus');
    var data4 = await Statics.getStaticLDB('ShaaririkVishay');
    populateBhaagDropdown();

    if (!mounted) return;
    setState(() {
      _frequency = data;
      _vayogat = data2;
      _status = data3;
      _shaaririkVishay = data4;
    });
  }

  void populateBhaagDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['BhaagLevelID'].toString(), "", "", "");

    setState(() {
      _bhaag = data;
    });
  }

  void populateShaharDropdown(String bhaagIDStr) async {
    _shaharValue = null;
    _vastiValue = null;
    _shahar = null;
    _vasti = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
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
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(
          Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _nagar = (ngDD.length > 0 ? ngDD : null);
      });
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(
          Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _nagar = (ngDD.length > 0 ? ngDD : null);
      });
    }
  }

  void populateMandalDropdown(String nagarIDStr) async {
    _mandalValue = _graamValue = null;
    _mandal = _graam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _mandal = (mnDD.length > 0 ? mnDD : null);
    });
  }

  void populateGraamDropdown(String mandalIDStr) async {
    _graamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _graam = (gmDD.length > 0 ? gmDD : null);
    });
  }

  void populateVastiDropdown(String nagarIDStr) async {
    _vastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _vasti = (vsDD.length > 0 ? vsDD : null);
    });
  }

  void getShaakhaaDetails(var theId) async {
    print("Shakha IDDD :-  {$theId}");

    setState(() {
      _isfetchingData = true;
    });
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(
          context, Statics.getLabel('internetNotConnected'));
    } else {
      var data = await Statics.getShaakhaaByID(theId);
      if (!mounted) return;
      setState(() {
        shaakhaa = data;
        if (shaakhaa != null) {
          _graamValue =
              shaakhaa!.graamID == null ? null : shaakhaa!.graamID.toString();

          if (_graamValue != null) {
            getGeoUnitDets(_graamValue);
          }

          _vastiValue =
              shaakhaa!.vastiID == null ? null : shaakhaa!.vastiID.toString();

          if (_vastiValue != null) {
            getGeoUnitDets(_vastiValue);
          }

          _shaakhaanameCtrl.text = shaakhaa!.geoUnitName.toString();

          _frequencyValue = shaakhaa!.frequencyID == null
              ? null
              : shaakhaa!.frequencyID.toString();

          _dayofWeekValue = shaakhaa!.dayOfWeek == null
              ? null
              : shaakhaa!.dayOfWeek.toString();

          if (_dayofWeekValue != null) {
            var arr = _dayofWeekValue!.split(',');
            _isSun = arr.contains("0") ? true : false;
            _isMon = arr.contains("1") ? true : false;
            _isTue = arr.contains("2") ? true : false;
            _isWed = arr.contains("3") ? true : false;
            _isThu = arr.contains("4") ? true : false;
            _isFri = arr.contains("5") ? true : false;
            _isSat = arr.contains("6") ? true : false;
          } else {
            _isSun =
                _isMon = _isTue = _isWed = _isThu = _isFri = _isSat = false;
          }

          _dayOfMonthCtrl.text = shaakhaa!.dayOfMonth.toString();
          _locationCtrl.text = shaakhaa!.location.toString();
          //_timingCtrl.text = shaakhaa!.timing.toString();

          final format = DateFormat("hh:mm a");

          _fromTime = ((shaakhaa!.fromTime != null && shaakhaa!.fromTime != "")
              ? TimeOfDay.fromDateTime(format.parse(shaakhaa!.fromTime!))
              : null);

          _fromTimeCntrl.text =
              shaakhaa!.fromTime == null ? "" : shaakhaa!.fromTime!;

          _toTime = ((shaakhaa!.toTime != null && shaakhaa!.toTime != "")
              ? TimeOfDay.fromDateTime(format.parse(shaakhaa!.toTime!))
              : null);

          _toTimeCntrl.text = shaakhaa!.toTime == null ? "" : shaakhaa!.toTime!;

          _vayogatValue = shaakhaa!.vayogatID == null
              ? null
              : shaakhaa!.vayogatID.toString();

          _statusValue =
              shaakhaa!.statusID == null ? null : shaakhaa!.statusID.toString();

          _remarkCtrl.text = shaakhaa!.remark.toString();

          _isSankalpit = shaakhaa!.isSankalpit == true ? true : false;
          _sankalpAadhaarEnum = (shaakhaa!.sankalpAadhaar == 'Shaakhaa'
              ? SankalpAadhaarEnum.Shaakhaa
              : SankalpAadhaarEnum.Kaaryakartaa);
          // _sankalpAadhaarEnum1 = (shaakhaa!.sankalpAadhaar1 == 'Shaakhaa' ? SankalpAadhaarEnum.Shaakhaa : SankalpAadhaarEnum.Kaaryakartaa);
          // _sankalpAadhaarEnum2 = (shaakhaa!.sankalpAadhaar2 == 'Shaakhaa' ? SankalpAadhaarEnum.Shaakhaa : SankalpAadhaarEnum.Kaaryakartaa);
          // _sankalpAadhaarEnum3 = (shaakhaa!.sankalpAadhaar3 == 'Shaakhaa' ? SankalpAadhaarEnum.Shaakhaa : SankalpAadhaarEnum.Kaaryakartaa);
          _sankalpAadhaarSwayamsevakID = shaakhaa!.sankalpAadhaarSwayamsevakID;
          // _sankalpAadhaarSwayamsevakID1 = shaakhaa!.sankalpAadhaarSwayamsevakID1;
          // _sankalpAadhaarSwayamsevakID2 = shaakhaa!.sankalpAadhaarSwayamsevakID2;
          // _sankalpAadhaarSwayamsevakID3 = shaakhaa!.sankalpAadhaarSwayamsevakID3;
          _sankalpAadhaarSwayamsevakValue =
              (shaakhaa!.sankalpAadhaarSwayamsevakID == null
                  ? ''
                  : shaakhaa!.sankalpAadhaarSwayamsevakID.toString());
          // _sankalpAadhaarSwayamsevakValue1 = (shaakhaa!.sankalpAadhaarSwayamsevakID1 == null ? '' : shaakhaa!.sankalpAadhaarSwayamsevakID1.toString());
          // _sankalpAadhaarSwayamsevakValue2 = (shaakhaa!.sankalpAadhaarSwayamsevakID2 == null ? '' : shaakhaa!.sankalpAadhaarSwayamsevakID2.toString());
          // _sankalpAadhaarSwayamsevakValue3 = (shaakhaa!.sankalpAadhaarSwayamsevakID3 == null ? '' : shaakhaa!.sankalpAadhaarSwayamsevakID3.toString());
          _sankalpAadhaarSwayamsevakCtrl.text =
              (shaakhaa!.sankalpAadhaarSwayamsevakID == null
                  ? ""
                  : shaakhaa!.sankalpAadhaarSwayamsevakName!);
          // _sankalpAadhaarSwayamsevakCtrl1.text = (shaakhaa!.sankalpAadhaarSwayamsevakID1 == null ? "" : shaakhaa!.sankalpAadhaarSwayamsevakName1!);
          // _sankalpAadhaarSwayamsevakCtrl2.text = (shaakhaa!.sankalpAadhaarSwayamsevakID2 == null ? "" : shaakhaa!.sankalpAadhaarSwayamsevakName2!);
          // _sankalpAadhaarSwayamsevakCtrl3.text = (shaakhaa!.sankalpAadhaarSwayamsevakID3 == null ? "" : shaakhaa!.sankalpAadhaarSwayamsevakName3!);
          _sankalpAadhaarShaakhaaID = shaakhaa!.sankalpAadhaarShaakhaaID;
          // _sankalpAadhaarShaakhaaID1 = shaakhaa!.sankalpAadhaarShaakhaaID1;
          // _sankalpAadhaarShaakhaaID2 = shaakhaa!.sankalpAadhaarShaakhaaID2;
          // _sankalpAadhaarShaakhaaID3 = shaakhaa!.sankalpAadhaarShaakhaaID3;
          _sankalpAadhaarShaakhaaValue =
              (shaakhaa!.sankalpAadhaarShaakhaaID == null
                  ? ''
                  : shaakhaa!.sankalpAadhaarShaakhaaID.toString());
          // _sankalpAadhaarShaakhaaValue = (shaakhaa!.sankalpAadhaarShaakhaaID1 == null ? '' : shaakhaa!.sankalpAadhaarShaakhaaID1.toString());
          // _sankalpAadhaarShaakhaaValue = (shaakhaa!.sankalpAadhaarShaakhaaID2 == null ? '' : shaakhaa!.sankalpAadhaarShaakhaaID2.toString());
          // _sankalpAadhaarShaakhaaValue = (shaakhaa!.sankalpAadhaarShaakhaaID3 == null ? '' : shaakhaa!.sankalpAadhaarShaakhaaID3.toString());
          _sankalpAadhaarShaakhaaCtrl.text =
              (shaakhaa!.sankalpAadhaarShaakhaaID == null
                  ? ""
                  : shaakhaa!.sankalpAadhaarShaakhaaName!);
          // _sankalpAadhaarShaakhaaCtrl1.text = (shaakhaa!.sankalpAadhaarShaakhaaID1 == null ? "" : shaakhaa!.sankalpAadhaarShaakhaaName1!);
          // _sankalpAadhaarShaakhaaCtrl2.text = (shaakhaa!.sankalpAadhaarShaakhaaID2 == null ? "" : shaakhaa!.sankalpAadhaarShaakhaaName2!);
          // _sankalpAadhaarShaakhaaCtrl3.text = (shaakhaa!.sankalpAadhaarShaakhaaID3 == null ? "" : shaakhaa!.sankalpAadhaarShaakhaaName3!);
          _sankalpCompletionMonthCtrl.text =
              (shaakhaa!.sankalpCompletionMonth == null
                  ? ""
                  : shaakhaa!.sankalpCompletionMonth.toString());
          // _sankalpCompletionMonthCtrl1.text = (shaakhaa!.sankalpCompletionMonth1 == null ? "" : shaakhaa!.sankalpCompletionMonth1.toString());
          // _sankalpCompletionMonthCtrl2.text = (shaakhaa!.sankalpCompletionMonth2 == null ? "" : shaakhaa!.sankalpCompletionMonth2.toString());
          // _sankalpCompletionMonthCtrl3.text = (shaakhaa!.sankalpCompletionMonth3 == null ? "" : shaakhaa!.sankalpCompletionMonth3.toString());
          _sankalpCompletionYearCtrl.text =
              (shaakhaa!.sankalpCompletionYear == null
                  ? ""
                  : shaakhaa!.sankalpCompletionYear.toString());
          // _sankalpCompletionYearCtrl1.text = (shaakhaa!.sankalpCompletionYear1 == null ? "" : shaakhaa!.sankalpCompletionYear1.toString());
          // _sankalpCompletionYearCtrl2.text = (shaakhaa!.sankalpCompletionYear2 == null ? "" : shaakhaa!.sankalpCompletionYear2.toString());
          // _sankalpCompletionYearCtrl3.text = (shaakhaa!.sankalpCompletionYear3 == null ? "" : shaakhaa!.sankalpCompletionYear3.toString());
          // _hasToli = shaakhaa!.hasToli == true ? true : false;
          // _hasPaalak = shaakhaa!.hasPaalak == true ? true : false;
          _sharirikVishayValue = shaakhaa!.shaaririkVishayID == null
              ? null
              : shaakhaa!.shaaririkVishayID.toString();
          _otherOptionalVishayCtrl.text = (shaakhaa!.otherShaaririkVishay!);
        }
      });
    }
    setState(() {
      _isfetchingData = false;
    });
  }

  void getGeoUnitDets(geoUnitID) async {
    GeoUnitMasterBAL? geoUnitDets = await Statics.getGeoUnitsByID(geoUnitID);

    if (geoUnitDets != null) {
      _bhaagValue = geoUnitDets.parentBhaagID == null
          ? null
          : geoUnitDets.parentBhaagID.toString();
      if (_bhaagValue != null) populateShaharDropdown(_bhaagValue!);

      _shaharValue = geoUnitDets.parentShaharID == null
          ? null
          : geoUnitDets.parentShaharID.toString();
      if (_shaharValue != null || _bhaagValue != null)
        populateNagarDropdown(_bhaagValue, _shaharValue);

      _nagarValue = geoUnitDets.parentNagarID == null
          ? null
          : geoUnitDets.parentNagarID.toString();
      if (_nagarValue != null) {
        populateMandalDropdown(_nagarValue!);
        populateVastiDropdown(_nagarValue!);
      }

      _mandalValue = geoUnitDets.parentMandalID == null
          ? null
          : geoUnitDets.parentMandalID.toString();
      if (_mandalValue != null) populateGraamDropdown(_mandalValue!);

      _graamValue = geoUnitDets.parentMandalID == null
          ? null
          : geoUnitDets.geoUnitID.toString();

      _vastiValue = geoUnitDets.parentMandalID == null
          ? geoUnitDets.geoUnitID.toString()
          : null;
    }
  }

  Future<List<dynamic>> populateSankalpAadhaarSwayamsevak(
      String geoUnitID, String pattern) async {
    if (pattern.length <= 2) return [];
    var swList = SwayamsevakProvider().getSwayamsevaks(json.encode({
      'AppUserID': Statics.userDetails["userID"],
      'GeoUnitID': geoUnitID.isEmpty ? null : geoUnitID,
      "SearchCriteria": pattern.isEmpty ? "" : pattern,
    }));
    for (var i in await swList) {
      print(i);
    }

    return swList;
  }

  Future<List<dynamic>> populateSankalpAadhaarShaakhaa(
      String geoUnitID, String pattern) async {
    if (pattern.length <= 2) return [];
    var shList = Statics.getShaakhaaList(json.encode({
      'AppUserID': Statics.userDetails["userID"],
      'GeoUnitID': geoUnitID,
      "ShaakhaaName": pattern.isEmpty ? null : pattern,
    }));
    return shList;
  }

  saveShaakhaaDetails() async {
    var _dayOfWeek = "";
    if (_isSun == true) _dayOfWeek = _dayOfWeek + "0,";
    if (_isMon == true) _dayOfWeek = _dayOfWeek + "1,";
    if (_isTue == true) _dayOfWeek = _dayOfWeek + "2,";
    if (_isWed == true) _dayOfWeek = _dayOfWeek + "3,";
    if (_isThu == true) _dayOfWeek = _dayOfWeek + "4,";
    if (_isFri == true) _dayOfWeek = _dayOfWeek + "5,";
    if (_isSat == true) _dayOfWeek = _dayOfWeek + "6,";

    if (_isSankalpit == false) {
      if (_frequency![_frequency!.indexWhere(
                  (p) => p.staticID.toString() == _frequencyValue.toString())]
              .code ==
          "Weekly") if (_dayOfWeek != "")
        shaakhaa!.dayOfWeek = _dayOfWeek.substring(0, _dayOfWeek.length - 1);
      else {
        Statics.showToast(Statics.getLabel('DayOfWeekValidationMessage'));
        return;
      }
    }
    // if (_isSankalpit == true && (_frequencyValue == '34' || _frequencyValue == '35'|| _frequencyValue == '36') )
    // {
    //   if (shaakhaa!.sankalpAadhaarShaakhaaID1 == null && shaakhaa!.sankalpAadhaarSwayamsevakID1 == null) {
    //     // print("shaakhaa!.sankalpAadhaarShaakhaaID :-- ${shaakhaa!.sankalpAadhaarShaakhaaID} ------ shaakhaa!.sankalpAadhaarSwayamsevakID :- ${shaakhaa!.sankalpAadhaarSwayamsevakID} ");
    //     Statics.showToast(Statics.getLabel('SankalpAadharValidationMessage'));
    //     return;
    //   }
    //   if (shaakhaa!.sankalpCompletionYear1! < DateTime.now().year ||
    //       (shaakhaa!.sankalpCompletionYear1 == DateTime.now().year && shaakhaa!.sankalpCompletionMonth1! < DateTime.now().month)) {
    //     Statics.showToast(Statics.getLabel('SankalpCompletionValidationMessage'));
    //     return;
    //   }
    // }
    // if (_isSankalpit == true && (_frequencyValue == '35' || _frequencyValue == '36' ))
    // {
    //   if (shaakhaa!.sankalpAadhaarShaakhaaID2 == null && shaakhaa!.sankalpAadhaarSwayamsevakID2 == null) {
    //     // print("shaakhaa!.sankalpAadhaarShaakhaaID :-- ${shaakhaa!.sankalpAadhaarShaakhaaID} ------ shaakhaa!.sankalpAadhaarSwayamsevakID :- ${shaakhaa!.sankalpAadhaarSwayamsevakID} ");
    //     Statics.showToast(Statics.getLabel('SankalpAadharValidationMessage'));
    //     return;
    //   }
    //   if (shaakhaa!.sankalpCompletionYear2! < DateTime.now().year ||
    //       (shaakhaa!.sankalpCompletionYear2 == DateTime.now().year && shaakhaa!.sankalpCompletionMonth2! < DateTime.now().month)) {
    //     Statics.showToast(Statics.getLabel('SankalpCompletionValidationMessage'));
    //     return;
    //   }
    // }
    // if (_isSankalpit == true && _frequencyValue == '36')
    // {
    //   if (shaakhaa!.sankalpAadhaarShaakhaaID3 == null && shaakhaa!.sankalpAadhaarSwayamsevakID3 == null) {
    //     // print("shaakhaa!.sankalpAadhaarShaakhaaID :-- ${shaakhaa!.sankalpAadhaarShaakhaaID} ------ shaakhaa!.sankalpAadhaarSwayamsevakID :- ${shaakhaa!.sankalpAadhaarSwayamsevakID} ");
    //     Statics.showToast(Statics.getLabel('SankalpAadharValidationMessage'));
    //     return;
    //   }
    //   if (shaakhaa!.sankalpCompletionYear3! < DateTime.now().year ||
    //       (shaakhaa!.sankalpCompletionYear3 == DateTime.now().year && shaakhaa!.sankalpCompletionMonth3! < DateTime.now().month)) {
    //     Statics.showToast(Statics.getLabel('SankalpCompletionValidationMessage'));
    //     return;
    //   }
    // }

    var inputData = json.encode({
      "PraantID": 1,
      "ParentBhaagID": _bhaagValue,
      "ParentShaharID":
          _shaharValue == null || _shaharValue!.isEmpty ? null : _shaharValue,
      "ParentNagarID":
          _nagarValue == null || _nagarValue!.isEmpty ? null : _nagarValue,
      "ParentMandalID":
          _mandalValue == null || _mandalValue!.isEmpty ? null : _mandalValue,
      "ParentGraamID": shaakhaa!.graamID,
      "ParentVastiID": shaakhaa!.vastiID,
      "ShaakhaaID": int.parse(widget.shaakhaaId),
      "ShaakhaaName": shaakhaa!.geoUnitName,
      "ShaakhaaNameDevNaagari": shaakhaa!.geoUnitName,
      "FrequencyID": shaakhaa!.frequencyID,
      "DaysOfWeek": shaakhaa!.dayOfWeek,
      "DayOfMonth": shaakhaa!.dayOfMonth,
      "VayogatID": shaakhaa!.vayogatID == null ? null : shaakhaa!.vayogatID,
      "Location": shaakhaa!.location,
      //"Timing": shaakhaa!.timing,
      "StartTimeStr": (_fromTime != null
          ? DateFormat("hh:mm").format(new DateFormat("yyyy-MM-dd hh:mm").parse(
                  "2021-02-01 " +
                      _fromTime!.hour.toString() +
                      ":" +
                      _fromTime!.minute.toString())) +
              (_fromTime!.period == DayPeriod.am ? " AM" : " PM")
          : null),
      "EndTimeStr": (_toTime != null
          ? DateFormat("hh:mm").format(new DateFormat("yyyy-MM-dd hh:mm").parse(
                  "2021-02-01 " +
                      _toTime!.hour.toString() +
                      ":" +
                      _toTime!.minute.toString())) +
              (_toTime!.period == DayPeriod.am ? " AM" : " PM")
          : null),
      "Remark": shaakhaa!.remark,
      "IsSankalpit": _isSankalpit == true ? true : false,
//========================= OLD REQ PARAM =============================================================================================================================================================================
      "SankalpAadhaar": (_isSankalpit
          ? _sankalpAadhaarEnum.toString().split('.').last
          : null),
      "SankalpAadhaarSwayamsevakID":
          (_isSankalpit ? shaakhaa!.sankalpAadhaarSwayamsevakID : null),
      "SankalpAadhaarShaakhaaID":
          (_isSankalpit ? shaakhaa!.sankalpAadhaarShaakhaaID : null),
      "SankalpCompletionMonth":
          (_isSankalpit ? shaakhaa!.sankalpCompletionMonth : null),
      "SankalpCompletionYear":
          (_isSankalpit ? shaakhaa!.sankalpCompletionYear : null),
//=========================  NEW REQ PARAM  =============================================================================================================================================================================
//       "SankalpAadhaar1": (_isSankalpit ? _sankalpAadhaarEnum1.toString().split('.').last : null),
//       "SankalpAadhaar2": (_isSankalpit ? _sankalpAadhaarEnum2.toString().split('.').last : null),
//       "SankalpAadhaar3": (_isSankalpit ? _sankalpAadhaarEnum3.toString().split('.').last : null),
//       "SankalpAadhaarSwayamsevakID1": (_isSankalpit ? shaakhaa!.sankalpAadhaarSwayamsevakID1 : null),
//       "SankalpAadhaarSwayamsevakID2": (_isSankalpit ? shaakhaa!.sankalpAadhaarSwayamsevakID2 : null),
//       "SankalpAadhaarSwayamsevakID3": (_isSankalpit ? shaakhaa!.sankalpAadhaarSwayamsevakID3 : null),
//       "SankalpAadhaarShaakhaaID1": (_isSankalpit ? shaakhaa!.sankalpAadhaarShaakhaaID1 : null),
//       "SankalpAadhaarShaakhaaID2": (_isSankalpit ? shaakhaa!.sankalpAadhaarShaakhaaID2 : null),
//       "SankalpAadhaarShaakhaaID3": (_isSankalpit ? shaakhaa!.sankalpAadhaarShaakhaaID3 : null),
//       "SankalpCompletionMonth1": (_isSankalpit ? shaakhaa!.sankalpCompletionMonth1 : null),
//       "SankalpCompletionMonth2": (_isSankalpit ? shaakhaa!.sankalpCompletionMonth2 : null),
//       "SankalpCompletionMonth3": (_isSankalpit ? shaakhaa!.sankalpCompletionMonth3 : null),
//       "SankalpCompletionYear1": (_isSankalpit ? shaakhaa!.sankalpCompletionYear1 : null),
//       "SankalpCompletionYear2": (_isSankalpit ? shaakhaa!.sankalpCompletionYear2 : null),
//       "SankalpCompletionYear3": (_isSankalpit ? shaakhaa!.sankalpCompletionYear3 : null),

//========================= END NEW REQ PARAM   =============================================================================================================================================================================

      "HasToli": _hasToli == true ? true : false,
      "HasPaalak": _hasPaalak == true ? true : false,
      "OtherOptionalVishay": shaakhaa!.otherShaaririkVishay,
      "OptionalShaaririkVishayID": shaakhaa!.shaaririkVishayID,
      "ModifiedBy": Statics.userDetails["userID"]
    });

    print("inputData =-=->  $inputData");

    var data = await Statics.saveShaakhaaDetails(inputData);
    setState(() {
      widget.shaakhaaId = data;
      widget.onSaveDetails(widget.shaakhaaId);
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    });
  }

  _pickFrmTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _fromTime == null ? TimeOfDay.now() : _fromTime!,
    );

    if (time != null) {
      setState(() {
        _fromTime = time;
        _fromTimeCntrl.text = DateFormat("hh:mm").format(
                new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " +
                    time.hour.toString() +
                    ":" +
                    time.minute.toString())) +
            (time.period == DayPeriod.am ? " AM" : " PM");
      });
    }
  }

  _pickToTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _toTime == null ? TimeOfDay.now() : _toTime!,
    );

    if (time != null) {
      setState(() {
        _toTime = time;
        _toTimeCntrl.text = DateFormat("hh:mm").format(
                new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " +
                    time.hour.toString() +
                    ":" +
                    time.minute.toString())) +
            (time.period == DayPeriod.am ? " AM" : " PM");
      });
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
        Statics.showMessageDialog(
            context, Statics.getLabel('internetNotConnected'));
      } else {
        await saveShaakhaaDetails();
      }
    } on Exception catch (error) {
      Statics.showErrorDialog(
          context, Statics.getLabel('unableToCompleteProcess'));
    } catch (error) {
      Statics.showErrorDialog(
          context, Statics.getLabel('unableToCompleteProcess'));
    }

    setState(() {
      _isLoading = false;
    });
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
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _shaakhaanameCtrl,
                        decoration: InputDecoration(
                            labelText: Statics.getLabel('ShaakhaaName')),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty)
                            return (Statics.getLabel(
                                'ShaakhaaNameValidationMessage'));
                          return null;
                        },
                        onSaved: (value) {
                          shaakhaa!.geoUnitName = value;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (_bhaag != null)
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                              labelText: Statics.getLabel('Bhaag')),
                          isExpanded: true,
                          value: _bhaagValue == "" ? null : _bhaagValue,
                          items: _bhaag!
                              .map((bg) => DropdownMenuItem(
                                  value: bg.geoUnitID.toString(),
                                  child: Text(bg.name!)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _bhaagValue = value;
                              populateShaharDropdown(value!);
                              populateNagarDropdown(value, null);
                            });
                          },
                          validator: (value) {
                            if ((value == null || value.isEmpty)) {
                              return Statics.getLabel(
                                  'SelectBhaagValidationMessage');
                            }
                            return null;
                          },
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      if (_shahar != null && _shahar!.length > 0)
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                              labelText: Statics.getLabel('Shahar')),
                          isExpanded: true,
                          value: _shaharValue == "" ? null : _shaharValue,
                          items: _shahar!
                              .map((bg) => DropdownMenuItem(
                                  value: bg.geoUnitID.toString(),
                                  child: Text(bg.name!)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _shaharValue = value;
                              populateNagarDropdown(null, value);
                            });
                          },
                          validator: (value) {
                            if ((value == null || value.isEmpty)) {
                              return Statics.getLabel(
                                  'SelectShaharValidationMessage');
                            }
                            return null;
                          },
                        ),
                      if (_shahar != null && _shahar!.length > 0)
                        SizedBox(
                          height: 10,
                        ),
                      if (_nagar != null && _nagar!.length > 0)
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                              labelText: Statics.getLabel('Nagar')),
                          isExpanded: true,
                          value: _nagarValue == "" ? null : _nagarValue,
                          items: _nagar!
                              .map((bg) => DropdownMenuItem(
                                  value: bg.geoUnitID.toString(),
                                  child: Text(bg.name!)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _nagarValue = value;
                              populateMandalDropdown(value!);
                              populateVastiDropdown(value);
                            });
                          },
                          validator: (value) {
                            if ((value == null || value.isEmpty)) {
                              return Statics.getLabel(
                                  'SelectNagarValidationMessage');
                            }
                            return null;
                          },
                        ),
                      if (_nagar != null && _nagar!.length > 0)
                        SizedBox(
                          height: 10,
                        ),
                      if (_mandal != null && _mandal!.length > 0)
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                              labelText: Statics.getLabel('Mandal')),
                          isExpanded: true,
                          value: _mandalValue == "" ? null : _mandalValue,
                          items: _mandal!
                              .map((bg) => DropdownMenuItem(
                                  value: bg.geoUnitID.toString(),
                                  child: Text(bg.name!)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _mandalValue = value;
                              populateGraamDropdown(value!);
                            });
                          },
                          validator: (value) {
                            if ((value == null || value.isEmpty)) {
                              return Statics.getLabel(
                                  'SelectMandalValidationMessage');
                            }
                            return null;
                          },
                        ),
                      if (_mandal != null && _mandal!.length > 0)
                        SizedBox(
                          height: 10,
                        ),
                      if (_vasti != null && _vasti!.length > 0)
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                              labelText: Statics.getLabel('SelectVasti')),
                          isExpanded: true,
                          value: _vastiValue == ""
                              ? null
                              : _vasti != null
                                  ? _vasti!.indexWhere((p) =>
                                              p.geoUnitID.toString() ==
                                              _vastiValue) >
                                          -1
                                      ? _vastiValue
                                      : null
                                  : null,
                          items: _vasti!
                              .map((bg) => DropdownMenuItem(
                                  value: bg.geoUnitID.toString(),
                                  child: Text(bg.name!)))
                              .toList(),
                          validator: (value) {
                            if ((value == null || value.isEmpty) &&
                                (_graamValue == null || _graamValue!.isEmpty)) {
                              return Statics.getLabel('VastiValidationMessage');
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _vastiValue = value;
                            });
                          },
                          onSaved: (value) {
                            if (value != null && value.isNotEmpty)
                              shaakhaa!.vastiID = int.parse(value);
                            else
                              shaakhaa!.vastiID = null;
                          },
                        ),
                      if (_vasti != null && _vasti!.length > 0)
                        SizedBox(
                          height: 10,
                        ),
                      if (_graam != null && _graam!.length > 0)
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                              labelText: Statics.getLabel('SelectGraam')),
                          isExpanded: true,
                          value: _graamValue == "" ? null : _graamValue,
                          items: _graam!
                              .map((bg) => DropdownMenuItem(
                                  value: bg.geoUnitID.toString(),
                                  child: Text(bg.name!)))
                              .toList(),
                          validator: (value) {
                            if ((value == null || value.isEmpty) &&
                                (_vastiValue == null || _vastiValue!.isEmpty)) {
                              return Statics.getLabel(
                                  'SelectGraamValidationMessage');
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _graamValue = value;
                            });
                          },
                          onSaved: (value) {
                            if (value != null && value.isNotEmpty)
                              shaakhaa!.graamID = int.parse(value);
                            else
                              shaakhaa!.graamID = null;
                          },
                        ),
                      if (_graam != null && _graam!.length > 0)
                        SizedBox(
                          height: 10,
                        ),
                      if (_vayogat != null)
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                              labelText: Statics.getLabel('Vayogat')),
                          isExpanded: true,
                          value: _vayogatValue == "" ? null : _vayogatValue,
                          items: _vayogat!
                              .map((bg) => DropdownMenuItem(
                                  value: bg.staticID.toString(),
                                  child: Text(bg.codeForDisplay!)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _vayogatValue = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return (Statics.getLabel(
                                  'VayogatValidationMessage'));
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null && value.isNotEmpty)
                              shaakhaa!.vayogatID = int.parse(value);
                            else
                              shaakhaa!.vayogatID = null;
                          },
                        ),
                      SizedBox(
                        height: 10,
                      ),

//===========================   OLD LOGIC =================================================================================
                      CheckboxListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(Statics.getLabel('IsSankalpit'),
                            style: TextStyle(fontSize: 15)),
                        checkColor: Colors.white,
                        activeColor: Colors.purple,
                        value: _isSankalpit,
                        onChanged: (value) {
                          setState(() {
                            _isSankalpit = value!;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      if (_isSankalpit == true)
                        Column(
                          children: [
                            Text(Statics.getLabel('SankalpAadhaar'),
                                style: TextStyle(
                                    decoration: TextDecoration.underline)),
                            RadioListTile<SankalpAadhaarEnum>(
                              title: Text(Statics.getLabel(
                                  'SankalpAadhaarKaaryakartaa')),
                              value: SankalpAadhaarEnum.Kaaryakartaa,
                              groupValue: _sankalpAadhaarEnum,
                              onChanged: (SankalpAadhaarEnum? value) {
                                setState(() {
                                  _sankalpAadhaarEnum = value!;
                                });
                              },
                            ),
                            if (_sankalpAadhaarEnum
                                    .toString()
                                    .split('.')
                                    .last ==
                                'Kaaryakartaa')
                              Row(
                                children: [
                                  Container(
                                    width:
                                        Statics.getDeviceSize(context).width *
                                            0.63,
                                    child: TypeAheadField(
                                      controller:
                                          _sankalpAadhaarSwayamsevakCtrl,
                                      builder:
                                          (context, controller, focusNode) {
                                        return TextField(
                                            controller: controller,
                                            focusNode: focusNode,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              border: UnderlineInputBorder(),
                                              labelText: Statics.getLabel(
                                                  'SankalpAadhaarKaaryakartaa'),
                                            ));
                                      },
                                      // textFieldConfiguration:
                                      //     TextFieldConfiguration(
                                      //         controller:
                                      //             this._sankalpAadhaarSwayamsevakCtrl,
                                      //         decoration: InputDecoration(
                                      //             labelText: Statics.getLabel(
                                      //                 'SankalpAadhaarKaaryakartaa'))),

                                      suggestionsCallback: (pattern) {
                                        this._sankalpAadhaarSwayamsevakValue =
                                            "";
                                        return populateSankalpAadhaarSwayamsevak(
                                            _bhaagValue!, pattern);
                                      },
                                      itemBuilder: (context, suggestion) {
                                        print(suggestion);
                                        return ListTile(
                                          title: Text(suggestion["FullName"]),
                                        );
                                      },
                                      // validator: (value) {
                                      //   if ((value.isEmpty ||
                                      //       _sankalpAadhaarSwayamsevakValue == null ||
                                      //       _sankalpAadhaarSwayamsevakValue.isEmpty)) {
                                      //     return Statics.getLabel(
                                      //         'SankalpAadhaarKaaryakartaaValidationMessage');
                                      //   }
                                      //   return null;
                                      // },
                                      // transitionBuilder: (context,
                                      //     suggestionsBox, controller) {
                                      //   return suggestionsBox;
                                      // },
                                      onSelected: (suggestion) {
                                        this
                                            ._sankalpAadhaarSwayamsevakCtrl
                                            .text = suggestion["FullName"];
                                        _sankalpAadhaarSwayamsevakValue =
                                            suggestion["SwayamsevakID"]
                                                .toString();
                                        shaakhaa!.sankalpAadhaarShaakhaaID =
                                            int.parse(
                                                suggestion["SwayamsevakID"]
                                                    .toString());

                                        print(
                                            "_sankalpAadhaarSwayamsevakValue:- ${_sankalpAadhaarSwayamsevakValue}  --- ");
                                      },
                                      // onSaved: (value) {
                                      //   if (_sankalpAadhaarSwayamsevakValue != null &&
                                      //       _sankalpAadhaarSwayamsevakValue.isNotEmpty){
                                      //     shaakhaa!.sankalpAadhaarSwayamsevakID =
                                      //         int.parse(_sankalpAadhaarSwayamsevakValue);
                                      //     shaakhaa!.sankalpAadhaarShaakhaaID = null;
                                      //       }
                                      //   else {
                                      //     shaakhaa!.sankalpAadhaarSwayamsevakID = null;
                                      //     shaakhaa!.sankalpAadhaarShaakhaaID = null;
                                      //   }
                                      // },
                                    ),
                                  ),
                                  IconButton(
                                      color: Colors.purple,
                                      onPressed: () {
                                        setState(() {
                                          this
                                              ._sankalpAadhaarSwayamsevakCtrl
                                              .text = "";
                                          _sankalpAadhaarSwayamsevakValue = "";
                                        });
                                      },
                                      icon: Icon(Icons.cancel)),
                                ],
                              ),
                            RadioListTile<SankalpAadhaarEnum>(
                              title: Text(
                                  Statics.getLabel('SankalpAadhaarShaakhaa')),
                              value: SankalpAadhaarEnum.Shaakhaa,
                              groupValue: _sankalpAadhaarEnum,
                              onChanged: (SankalpAadhaarEnum? value) {
                                setState(() {
                                  _sankalpAadhaarEnum = value!;
                                });
                              },
                            ),
                            if (_sankalpAadhaarEnum
                                    .toString()
                                    .split('.')
                                    .last ==
                                'Shaakhaa')
                              Row(
                                children: [
                                  Container(
                                    width:
                                        Statics.getDeviceSize(context).width *
                                            0.63,
                                    child: TypeAheadField(
                                      controller: _sankalpAadhaarShaakhaaCtrl,
                                      builder:
                                          (context, controller, focusNode) {
                                        return TextField(
                                            controller: controller,
                                            focusNode: focusNode,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              border: UnderlineInputBorder(),
                                              labelText: Statics.getLabel(
                                                  'SankalpAadhaarShaakhaa'),
                                            ));
                                      },
                                      // textFieldConfiguration:
                                      // TextFieldConfiguration(
                                      //     controller:
                                      //         this._sankalpAadhaarShaakhaaCtrl,
                                      //     decoration: InputDecoration(
                                      //         labelText: Statics.getLabel(
                                      //             'SankalpAadhaarShaakhaa'))),

                                      suggestionsCallback: (pattern) {
                                        this._sankalpAadhaarShaakhaaValue = "";
                                        return populateSankalpAadhaarShaakhaa(
                                            _bhaagValue!, pattern);
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title:
                                              Text(suggestion["GeoUnitName"]),
                                        );
                                      },
                                      // validator: (value) {
                                      //   if ((value.isEmpty ||
                                      //       _sankalpAadhaarShaakhaaValue == null ||
                                      //       _sankalpAadhaarShaakhaaValue.isEmpty)) {
                                      //     return Statics.getLabel(
                                      //         'SankalpAadhaarShaakhaaValidationMessage');
                                      //   }
                                      //   return null;
                                      // },
                                      // transitionBuilder: (context,
                                      //     suggestionsBox, controller) {
                                      //   return suggestionsBox;
                                      // },
                                      onSelected: (suggestion) {
                                        this._sankalpAadhaarShaakhaaCtrl.text =
                                            suggestion["GeoUnitName"];
                                        _sankalpAadhaarShaakhaaValue =
                                            suggestion["ShaakhaaID"].toString();
                                        shaakhaa!.sankalpAadhaarShaakhaaID =
                                            int.parse(suggestion["ShaakhaaID"]
                                                .toString());
                                        print(
                                            "_sankalpAadhaarShaakhaaValue:--${_sankalpAadhaarShaakhaaValue}");
                                      },
                                      // onSaved: (value) {
                                      //   if (_sankalpAadhaarShaakhaaValue != null &&
                                      //       _sankalpAadhaarShaakhaaValue.isNotEmpty)
                                      //     {
                                      //       shaakhaa!.sankalpAadhaarShaakhaaID =
                                      //         int.parse(_sankalpAadhaarShaakhaaValue);
                                      //       shaakhaa!.sankalpAadhaarSwayamsevakID = null;
                                      //     }
                                      //   else {
                                      //     shaakhaa!.sankalpAadhaarShaakhaaID = null;
                                      //     shaakhaa!.sankalpAadhaarSwayamsevakID = null;
                                      //   }
                                      // },
                                    ),
                                  ),
                                  IconButton(
                                      color: Colors.purple,
                                      onPressed: () {
                                        setState(() {
                                          this
                                              ._sankalpAadhaarShaakhaaCtrl
                                              .text = "";
                                          _sankalpAadhaarShaakhaaValue = "";
                                        });
                                      },
                                      icon: Icon(Icons.cancel)),
                                ],
                              ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(Statics.getLabel('SankalpTimeLine'),
                                style: TextStyle(
                                    decoration: TextDecoration.underline)),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _sankalpCompletionMonthCtrl,
                              decoration: InputDecoration(
                                  labelText: Statics.getLabel(
                                      'SankalpCompletionMonth')),
                              maxLength: 2,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (_isSankalpit == true && value!.isEmpty)
                                  return (Statics.getLabel(
                                      'SankalpCompletionValidationMessage'));
                                return null;
                              },
                              onSaved: (value) {
                                shaakhaa!.sankalpCompletionMonth =
                                    int.parse(value!);
                              },
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _sankalpCompletionYearCtrl,
                              decoration: InputDecoration(
                                  labelText: Statics.getLabel(
                                      'SankalpCompletionYear')),
                              maxLength: 4,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (_isSankalpit == true && value!.isEmpty)
                                  return (Statics.getLabel(
                                      'SankalpCompletionValidationMessage'));
                                return null;
                              },
                              onSaved: (value) {
                                shaakhaa!.sankalpCompletionYear =
                                    int.parse(value!);
                              },
                            ),
                          ],
                        ),
                      if (_frequency != null)
                        DropdownButtonFormField<StaticMasterBAL>(
                          decoration: InputDecoration(
                              labelText: Statics.getLabel('SelectFrequency')),
                          isExpanded: true,
                          value: _frequencyValue == null
                              ? null
                              : _frequency == null
                                  ? null
                                  : _frequency![_frequency!.indexWhere((p) =>
                                      p.staticID.toString() ==
                                      _frequencyValue.toString())],
                          items: _frequency != null
                              ? _frequency!
                                  .map((bg) => DropdownMenuItem(
                                      value: bg,
                                      child: Text(bg.codeForDisplay!)))
                                  .toList()
                              : [],
                          onChanged: (value) {
                            setState(() {
                              _frequencyValue = value!.staticID.toString();
                              print("_frequencyValue  =-=-> $_frequencyValue");
                            });
                          },
                          validator: (value) {
                            if (value == null)
                              return (Statics.getLabel(
                                  'FrequencyValidationMessage'));
                            return null;
                          },
                          onSaved: (value) {
                            shaakhaa!.frequencyID = value!.staticID;
                          },
                        ),
                      SizedBox(
                        height: 10,
                      ),
// =========================== END OLD LOGIC =================================================================================

                      // if(_frequency != null)
                      //   DropdownButtonFormField<StaticMasterBAL>(
                      //     decoration: InputDecoration(labelText: Statics.getLabel('SelectFrequency')),
                      //     isExpanded: true,
                      //     value: _frequencyValue == null
                      //         ? null
                      //         : _frequency == null
                      //         ? null
                      //         : _frequency![_frequency!.indexWhere((p) => p.staticID.toString() == _frequencyValue.toString())],
                      //     items:
                      //     _frequency != null ? _frequency!.map((bg) => DropdownMenuItem(value: bg, child: Text(bg.codeForDisplay!))).toList() : [],
                      //     onChanged: (value) {
                      //       setState(() {
                      //         _frequencyValue = value!.staticID.toString();
                      //         print("_frequencyValue  =-=-> $_frequencyValue");
                      //       });
                      //     },
                      //     validator: (value) {
                      //       if (value == null) return (Statics.getLabel('FrequencyValidationMessage'));
                      //       return null;
                      //     },
                      //     onSaved: (value) {
                      //       shaakhaa!.frequencyID = value!.staticID;
                      //     },
                      //   ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      //
                      // CheckboxListTile(
                      //   contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      //   controlAffinity: ListTileControlAffinity.leading,
                      //   title: Text(Statics.getLabel('IsSankalpit'), style: TextStyle(fontSize: 15)),
                      //   checkColor: Colors.white,
                      //   activeColor: Colors.purple,
                      //   value: _isSankalpit,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _isSankalpit = value!;
                      //     });
                      //   },
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),

// ================================================================== NEW LOGIC  ==================================================================
//======================= D1  SELECT  SHAKHA ==================================================================================================================
//                       if (_isSankalpit == true && (_frequencyValue == '34' || _frequencyValue == '35'|| _frequencyValue == '36') )
//                         Column(
//                           children: [
//                             // Text(Statics.getLabel('SankalpAadhaar') , style: TextStyle(decoration: TextDecoration.underline)),
//                             Legend(legendString: 'SankalpAadhaarShakhaa', fontsize: 18),
//                             RadioListTile<SankalpAadhaarEnum>(
//                               title: Text(Statics.getLabel('SankalpAadhaarKaaryakartaa')),
//                               value: SankalpAadhaarEnum.Kaaryakartaa,
//                               groupValue: _sankalpAadhaarEnum1,
//                               onChanged: (SankalpAadhaarEnum? value) {
//                                 setState(() {
//                                   _sankalpAadhaarEnum1 = value!;
//                                 });
//                               },
//                             ),
//                             if (_sankalpAadhaarEnum1.toString().split('.').last == 'Kaaryakartaa')
//                               Row(
//                                 children: [
//                                   Container(
//                                     width: Statics.getDeviceSize(context).width * 0.63,
//                                     child: TypeAheadField(
//                                       controller: _sankalpAadhaarSwayamsevakCtrl1,
//                                       builder: (context, controller, focusNode) {
//                                         return TextField(
//                                             controller: controller,
//                                             focusNode: focusNode,
//                                             decoration: InputDecoration(
//                                               isDense: true,
//                                               border: UnderlineInputBorder(),
//                                               labelText: Statics.getLabel('SankalpAadhaarKaaryakartaa'),
//                                             )
//                                         );
//                                       },
//                                       suggestionsCallback: (pattern) {
//                                         this._sankalpAadhaarSwayamsevakValue1 = "";
//                                         return populateSankalpAadhaarSwayamsevak(_bhaagValue!, pattern);
//                                       },
//                                       itemBuilder: (context, suggestion) {
//                                         print(suggestion);
//                                         return ListTile(
//                                           title: Text(suggestion["FullName"]),
//                                         );
//                                       },
//                                       onSelected: (suggestion) {
//                                         this._sankalpAadhaarSwayamsevakCtrl1.text = suggestion["FullName"];
//                                         _sankalpAadhaarSwayamsevakValue1 = suggestion["SwayamsevakID"].toString();
//                                         shaakhaa!.sankalpAadhaarSwayamsevakID1 = int.parse(suggestion["SwayamsevakID"].toString());
//                                         print("_sankalpAadhaarSwayamsevakValue:- ${_sankalpAadhaarSwayamsevakValue1}  --- ");
//                                       },
//                                     ),
//                                   ),
//                                   IconButton(
//                                       color: Colors.purple,
//                                       onPressed: () {
//                                         setState(() {
//                                           this._sankalpAadhaarSwayamsevakCtrl1.text = "";
//                                           _sankalpAadhaarSwayamsevakValue1 = "";
//                                         });
//                                       },
//                                       icon: Icon(Icons.cancel)),
//                                 ],
//                               ),
//                             RadioListTile<SankalpAadhaarEnum>(
//                               title: Text(Statics.getLabel('SankalpAadhaarShaakhaa')),
//                               value: SankalpAadhaarEnum.Shaakhaa,
//                               groupValue: _sankalpAadhaarEnum1,
//                               onChanged: (SankalpAadhaarEnum? value) {
//                                 setState(() {
//                                   _sankalpAadhaarEnum1 = value!;
//                                 });
//                               },
//                             ),
//                             if (_sankalpAadhaarEnum1.toString().split('.').last == 'Shaakhaa')
//                               Row(
//                                 children: [
//                                   Container(
//                                     width: Statics.getDeviceSize(context).width * 0.63,
//                                     child: TypeAheadField(
//                                       controller: _sankalpAadhaarShaakhaaCtrl1,
//                                       builder: (context, controller, focusNode) {
//                                         return TextField(
//                                             controller: controller,
//                                             focusNode: focusNode,
//                                             decoration: InputDecoration(
//                                               isDense: true,
//                                               border: UnderlineInputBorder(),
//                                               labelText: Statics.getLabel('SankalpAadhaarShaakhaa'),
//                                             )
//                                         );
//                                       },
//                                       suggestionsCallback: (pattern) {
//                                         this._sankalpAadhaarShaakhaaValue = "";
//                                         return populateSankalpAadhaarShaakhaa(_bhaagValue!, pattern);
//
//                                       },
//                                       itemBuilder: (context, suggestion) {
//                                         return ListTile(
//                                           title: Text(suggestion["GeoUnitName"]),
//                                         );
//                                       },
//                                       onSelected: (suggestion) {
//                                         this._sankalpAadhaarShaakhaaCtrl1.text = suggestion["GeoUnitName"];
//                                         _sankalpAadhaarShaakhaaValue = suggestion["ShaakhaaID"].toString();
//                                         shaakhaa!.sankalpAadhaarShaakhaaID1 =int.parse(suggestion["ShaakhaaID"].toString());
//                                         print("_sankalpAadhaarShaakhaaValue:--${_sankalpAadhaarShaakhaaValue}");
//                                       },
//                                     ),
//                                   ),
//                                   IconButton(
//                                       color: Colors.purple,
//                                       onPressed: () {
//                                         setState(() {
//                                           this._sankalpAadhaarShaakhaaCtrl1.text = "";
//                                           _sankalpAadhaarShaakhaaValue = "";
//                                         });
//                                       },
//                                       icon: Icon(Icons.cancel)),
//                                 ],
//                               ),
//                             SizedBox(
//                               height: 15,
//                             ),
//                             Text(Statics.getLabel('SankalpTimeLine'), style: TextStyle(decoration: TextDecoration.underline)),
//                             TextFormField(
//                               textInputAction: TextInputAction.next,
//                               controller: _sankalpCompletionMonthCtrl1,
//                               decoration: InputDecoration(labelText: Statics.getLabel('SankalpCompletionMonth')),
//                               maxLength: 2,
//                               keyboardType: TextInputType.number,
//                            validator: (value) {
//                               //   // if (_isSankalpit == true && value!.isEmpty) return (Statics.getLabel('SankalpCompletionValidationMessage'));
//                              return null;
//                              },
//                               onSaved: (value) {
//                                 shaakhaa!.sankalpCompletionMonth1 = int.parse(value!) ?? 00;
//                               },
//                             ),
//                             TextFormField(
//                               textInputAction: TextInputAction.next,
//                               controller: _sankalpCompletionYearCtrl1,
//                               decoration: InputDecoration(labelText: Statics.getLabel('SankalpCompletionYear')),
//                               maxLength: 4,
//                               keyboardType: TextInputType.number,
//                               validator: (value) {
//                               //   if (_isSankalpit == true && value!.isEmpty) return (Statics.getLabel('SankalpCompletionValidationMessage'));
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 shaakhaa!.sankalpCompletionYear1 = int.parse(value!);
//                               },
//                             ),
//                           ],
//                         ),
// //======================= D1-D2  SELCT SAAPTAHIK MILAN  ====================================================================
//                       if (_isSankalpit == true && (_frequencyValue == '35' || _frequencyValue == '36' ))
//                         Column(
//                           children: [
//                             // Text(Statics.getLabel('SankalpAadhaar'), style: TextStyle(decoration: TextDecoration.underline)),
//                             Legend(legendString: 'SankalpAadhaarSaptahikMilan', fontsize: 18),
//                             RadioListTile<SankalpAadhaarEnum>(
//                               title: Text(Statics.getLabel('SankalpAadhaarKaaryakartaa')),
//                               value: SankalpAadhaarEnum.Kaaryakartaa,
//                               groupValue: _sankalpAadhaarEnum2,
//                               onChanged: (SankalpAadhaarEnum? value) {
//                                 setState(() {
//                                   _sankalpAadhaarEnum2 = value!;
//                                 });
//                               },
//                             ),
//                             if (_sankalpAadhaarEnum2.toString().split('.').last == 'Kaaryakartaa')
//                               Row(
//                                 children: [
//                                   Container(
//                                     width: Statics.getDeviceSize(context).width * 0.63,
//                                     child: TypeAheadField(
//                                       controller: _sankalpAadhaarSwayamsevakCtrl2,
//                                       builder: (context, controller, focusNode) {
//                                         return TextField(
//                                             controller: controller,
//                                             focusNode: focusNode,
//                                             decoration: InputDecoration(
//                                               isDense: true,
//                                               border: UnderlineInputBorder(),
//                                               labelText: Statics.getLabel('SankalpAadhaarKaaryakartaa'),
//                                             )
//                                         );
//                                       },
//                                       suggestionsCallback: (pattern) {
//                                         this._sankalpAadhaarSwayamsevakValue2 = "";
//                                         return populateSankalpAadhaarSwayamsevak(_bhaagValue!, pattern);
//                                       },
//                                       itemBuilder: (context, suggestion) {
//                                         print(suggestion);
//                                         return ListTile(
//                                           title: Text(suggestion["FullName"]),
//                                         );
//                                       },
//                                       onSelected: (suggestion) {
//                                         this._sankalpAadhaarSwayamsevakCtrl2.text = suggestion["FullName"];
//                                         _sankalpAadhaarSwayamsevakValue2 = suggestion["SwayamsevakID"].toString();
//                                         shaakhaa!.sankalpAadhaarSwayamsevakID2 = int.parse(suggestion["SwayamsevakID"].toString());
//
//                                         print("_sankalpAadhaarSwayamsevakValue:- ${_sankalpAadhaarSwayamsevakValue2}  --- ");
//                                       },
//                                     ),
//                                   ),
//                                   IconButton(
//                                       color: Colors.purple,
//                                       onPressed: () {
//                                         setState(() {
//                                           this._sankalpAadhaarSwayamsevakCtrl2.text = "";
//                                           _sankalpAadhaarSwayamsevakValue2 = "";
//                                         });
//                                       },
//                                       icon: Icon(Icons.cancel)),
//                                 ],
//                               ),
//                             RadioListTile<SankalpAadhaarEnum>(
//                               title: Text(Statics.getLabel('SankalpAadhaarShaakhaa')),
//                               value: SankalpAadhaarEnum.Shaakhaa,
//                               groupValue: _sankalpAadhaarEnum2,
//                               onChanged: (SankalpAadhaarEnum? value) {
//                                 setState(() {
//                                   _sankalpAadhaarEnum2 = value!;
//                                 });
//                               },
//                             ),
//                             if (_sankalpAadhaarEnum2.toString().split('.').last == 'Shaakhaa')
//                               Row(
//                                 children: [
//                                   Container(
//                                     width: Statics.getDeviceSize(context).width * 0.63,
//                                     child: TypeAheadField(
//                                       controller: _sankalpAadhaarShaakhaaCtrl2,
//                                       builder: (context, controller, focusNode) {
//                                         return TextField(
//                                             controller: controller,
//                                             focusNode: focusNode,
//                                             decoration: InputDecoration(
//                                               isDense: true,
//                                               border: UnderlineInputBorder(),
//                                               labelText: Statics.getLabel('SankalpAadhaarShaakhaa'),
//                                             )
//                                         );
//                                       },
//                                       suggestionsCallback: (pattern) {
//                                         this._sankalpAadhaarShaakhaaValue = "";
//                                         return populateSankalpAadhaarShaakhaa(_bhaagValue!, pattern);
//
//                                       },
//                                       itemBuilder: (context, suggestion) {
//                                         return ListTile(
//                                           title: Text(suggestion["GeoUnitName"]),
//                                         );
//                                       },
//                                       onSelected: (suggestion) {
//                                         this._sankalpAadhaarShaakhaaCtrl2.text = suggestion["GeoUnitName"];
//                                         _sankalpAadhaarShaakhaaValue = suggestion["ShaakhaaID"].toString();
//                                         shaakhaa!.sankalpAadhaarShaakhaaID2 =int.parse(suggestion["ShaakhaaID"].toString());
//                                         print("_sankalpAadhaarShaakhaaValue:--${_sankalpAadhaarShaakhaaValue}");
//                                       },
//                                     ),
//                                   ),
//                                   IconButton(
//                                       color: Colors.purple,
//                                       onPressed: () {
//                                         setState(() {
//                                           this._sankalpAadhaarShaakhaaCtrl2.text = "";
//                                           _sankalpAadhaarShaakhaaValue = "";
//                                         });
//                                       },
//                                       icon: Icon(Icons.cancel)),
//                                 ],
//                               ),
//                             SizedBox(
//                               height: 15,
//                             ),
//                             Text(Statics.getLabel('SankalpTimeLine'), style: TextStyle(decoration: TextDecoration.underline)),
//                             TextFormField(
//                               textInputAction: TextInputAction.next,
//                               controller: _sankalpCompletionMonthCtrl2,
//                               decoration: InputDecoration(labelText: Statics.getLabel('SankalpCompletionMonth')),
//                               maxLength: 2,
//                               keyboardType: TextInputType.number,
//                               validator: (value) {
//                               //   if (_isSankalpit == true && value!.isEmpty) return (Statics.getLabel('SankalpCompletionValidationMessage'));
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 shaakhaa!.sankalpCompletionMonth2 = int.parse(value!);
//                               },
//                             ),
//                             TextFormField(
//                               textInputAction: TextInputAction.next,
//                               controller: _sankalpCompletionYearCtrl2,
//                               decoration: InputDecoration(labelText: Statics.getLabel('SankalpCompletionYear')),
//                               maxLength: 4,
//                               keyboardType: TextInputType.number,
//                               validator: (value) {
//                               //   if (_isSankalpit == true && value!.isEmpty) return (Statics.getLabel('SankalpCompletionValidationMessage'));
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 shaakhaa!.sankalpCompletionYear2 = int.parse(value!);
//                               },
//                             ),
//                           ],
//                         ),
// //======================= D1-D2-D3 SELECT MASIKMILAN/ SANGH MANDALI  ====================================================================
//                       if (_isSankalpit == true && _frequencyValue == '36')
//                         Column(
//                           children: [
//                             // Text(Statics.getLabel('SankalpAadhaar'), style: TextStyle(decoration: TextDecoration.underline)),
//                             Legend(legendString: 'SankalpAadhaarMasikMilanSanghaMandali', fontsize: 18),
//                             RadioListTile<SankalpAadhaarEnum>(
//                               title: Text(Statics.getLabel('SankalpAadhaarKaaryakartaa')),
//                               value: SankalpAadhaarEnum.Kaaryakartaa,
//                               groupValue: _sankalpAadhaarEnum3,
//                               onChanged: (SankalpAadhaarEnum? value) {
//                                 setState(() {
//                                   _sankalpAadhaarEnum3 = value!;
//                                 });
//                               },
//                             ),
//                             if (_sankalpAadhaarEnum3.toString().split('.').last == 'Kaaryakartaa')
//                               Row(
//                                 children: [
//                                   Container(
//                                     width: Statics.getDeviceSize(context).width * 0.63,
//                                     child: TypeAheadField(
//                                       controller: _sankalpAadhaarSwayamsevakCtrl3,
//                                       builder: (context, controller, focusNode) {
//                                         return TextField(
//                                             controller: controller,
//                                             focusNode: focusNode,
//                                             decoration: InputDecoration(
//                                               isDense: true,
//                                               border: UnderlineInputBorder(),
//                                               labelText: Statics.getLabel('SankalpAadhaarKaaryakartaa'),
//                                             )
//                                         );
//                                       },
//                                       suggestionsCallback: (pattern) {
//                                         this._sankalpAadhaarSwayamsevakValue3 = "";
//                                         return populateSankalpAadhaarSwayamsevak(_bhaagValue!, pattern);
//                                       },
//                                       itemBuilder: (context, suggestion) {
//                                         print(suggestion);
//                                         return ListTile(
//                                           title: Text(suggestion["FullName"]),
//                                         );
//                                       },
//                                       onSelected: (suggestion) {
//                                         this._sankalpAadhaarSwayamsevakCtrl3.text = suggestion["FullName"];
//                                         _sankalpAadhaarSwayamsevakValue3 = suggestion["SwayamsevakID"].toString();
//                                         shaakhaa!.sankalpAadhaarSwayamsevakID3 = int.parse(suggestion["SwayamsevakID"].toString());
//
//                                         print("_sankalpAadhaarSwayamsevakValue:- ${_sankalpAadhaarSwayamsevakValue3}  --- ");
//                                       },
//                                     ),
//                                   ),
//                                   IconButton(
//                                       color: Colors.purple,
//                                       onPressed: () {
//                                         setState(() {
//                                           this._sankalpAadhaarSwayamsevakCtrl3.text = "";
//                                           _sankalpAadhaarSwayamsevakValue3 = "";
//                                         });
//                                       },
//                                       icon: Icon(Icons.cancel)),
//                                 ],
//                               ),
//                             RadioListTile<SankalpAadhaarEnum>(
//                               title: Text(Statics.getLabel('SankalpAadhaarShaakhaa')),
//                               value: SankalpAadhaarEnum.Shaakhaa,
//                               groupValue: _sankalpAadhaarEnum3,
//                               onChanged: (SankalpAadhaarEnum? value) {
//                                 setState(() {
//                                   _sankalpAadhaarEnum3 = value!;
//                                 });
//                               },
//                             ),
//                             if (_sankalpAadhaarEnum3.toString().split('.').last == 'Shaakhaa')
//                               Row(
//                                 children: [
//                                   Container(
//                                     width: Statics.getDeviceSize(context).width * 0.63,
//                                     child: TypeAheadField(
//                                       controller: _sankalpAadhaarShaakhaaCtrl3,
//                                       builder: (context, controller, focusNode) {
//                                         return TextField(
//                                             controller: controller,
//                                             focusNode: focusNode,
//                                             decoration: InputDecoration(
//                                               isDense: true,
//                                               border: UnderlineInputBorder(),
//                                               labelText: Statics.getLabel('SankalpAadhaarShaakhaa'),
//                                             )
//                                         );
//                                       },
//                                       suggestionsCallback: (pattern) {
//                                         this._sankalpAadhaarShaakhaaValue = "";
//                                         return populateSankalpAadhaarShaakhaa(_bhaagValue!, pattern);
//
//                                       },
//                                       itemBuilder: (context, suggestion) {
//                                         return ListTile(
//                                           title: Text(suggestion["GeoUnitName"]),
//                                         );
//                                       },
//                                       onSelected: (suggestion) {
//                                         this._sankalpAadhaarShaakhaaCtrl3.text = suggestion["GeoUnitName"];
//                                         _sankalpAadhaarShaakhaaValue = suggestion["ShaakhaaID"].toString();
//                                         shaakhaa!.sankalpAadhaarShaakhaaID3 =int.parse(suggestion["ShaakhaaID"].toString());
//                                         print("_sankalpAadhaarShaakhaaValue:--${_sankalpAadhaarShaakhaaValue}");
//                                       },
//                                     ),
//                                   ),
//                                   IconButton(
//                                       color: Colors.purple,
//                                       onPressed: () {
//                                         setState(() {
//                                           this._sankalpAadhaarShaakhaaCtrl3.text = "";
//                                           _sankalpAadhaarShaakhaaValue = "";
//                                         });
//                                       },
//                                       icon: Icon(Icons.cancel)),
//                                 ],
//                               ),
//                             SizedBox(
//                               height: 15,
//                             ),
//                             Text(Statics.getLabel('SankalpTimeLine'), style: TextStyle(decoration: TextDecoration.underline)),
//                             TextFormField(
//                               textInputAction: TextInputAction.next,
//                               controller: _sankalpCompletionMonthCtrl3,
//                               decoration: InputDecoration(labelText: Statics.getLabel('SankalpCompletionMonth')),
//                               maxLength: 2,
//                               keyboardType: TextInputType.number,
//                               validator: (value) {
//                               //   if (_isSankalpit == true && value!.isEmpty) return (Statics.getLabel('SankalpCompletionValidationMessage'));
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 shaakhaa!.sankalpCompletionMonth3 = int.parse(value!);
//                               },
//                             ),
//                             TextFormField(
//                               textInputAction: TextInputAction.next,
//                               controller: _sankalpCompletionYearCtrl3,
//                               decoration: InputDecoration(labelText: Statics.getLabel('SankalpCompletionYear')),
//                               maxLength: 4,
//                               keyboardType: TextInputType.number,
//                               validator: (value) {
//                               //   if (_isSankalpit == true && value!.isEmpty) return (Statics.getLabel('SankalpCompletionValidationMessage'));
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 shaakhaa!.sankalpCompletionYear3 = int.parse(value!);
//                               },
//                             ),
//                           ],
//                         ),
//                       SizedBox(
//                         height: 10,
//                       ),
// ================================================================== NEW LOGIC END  ==================================================================
                      if (_frequencyValue != null &&
                          _frequency != null &&
                          _isSankalpit == false)
                        if (_frequency![_frequency!.indexWhere((p) =>
                                    p.staticID.toString() ==
                                    _frequencyValue.toString())]
                                .code ==
                            "Monthly")
                          Column(
                            children: [
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _dayOfMonthCtrl,
                                decoration: InputDecoration(
                                    labelText: Statics.getLabel('DayofMonth')),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return (Statics.getLabel(
                                        'DayofMonthValidationMessage'));
                                  return null;
                                },
                                onSaved: (value) {
                                  shaakhaa!.dayOfMonth = value;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        else if (_frequency![_frequency!.indexWhere((p) =>
                                    p.staticID.toString() ==
                                    _frequencyValue.toString())]
                                .code ==
                            "Weekly")
                          Column(
                            children: [
                              Text(
                                Statics.getLabel('SelectDayOfWeek'),
                              ),
                              Wrap(
                                children: [
                                  SizedBox(
                                    width:
                                        Statics.getDeviceSize(context).width *
                                            0.25,
                                    child: CheckboxListTile(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(Statics.getLabel('Mon'),
                                          style: TextStyle(fontSize: 15)),
                                      checkColor: Colors.white,
                                      activeColor: Colors.purple,
                                      value: _isMon,
                                      onChanged: (value) {
                                        setState(() {
                                          _isMon = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        Statics.getDeviceSize(context).width *
                                            0.25,
                                    child: CheckboxListTile(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(Statics.getLabel('Tue'),
                                          style: TextStyle(fontSize: 15)),
                                      checkColor: Colors.white,
                                      activeColor: Colors.purple,
                                      value: _isTue,
                                      onChanged: (value) {
                                        setState(() {
                                          _isTue = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        Statics.getDeviceSize(context).width *
                                            0.25,
                                    child: CheckboxListTile(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(Statics.getLabel('Wed'),
                                          style: TextStyle(fontSize: 15)),
                                      checkColor: Colors.white,
                                      activeColor: Colors.purple,
                                      value: _isWed,
                                      onChanged: (value) {
                                        setState(() {
                                          _isWed = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        Statics.getDeviceSize(context).width *
                                            0.25,
                                    child: CheckboxListTile(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(Statics.getLabel('Thu'),
                                          style: TextStyle(fontSize: 15)),
                                      checkColor: Colors.white,
                                      activeColor: Colors.purple,
                                      value: _isThu,
                                      onChanged: (value) {
                                        setState(() {
                                          _isThu = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        Statics.getDeviceSize(context).width *
                                            0.25,
                                    child: CheckboxListTile(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(Statics.getLabel('Fri'),
                                          style: TextStyle(fontSize: 15)),
                                      checkColor: Colors.white,
                                      activeColor: Colors.purple,
                                      value: _isFri,
                                      onChanged: (value) {
                                        setState(() {
                                          _isFri = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        Statics.getDeviceSize(context).width *
                                            0.25,
                                    child: CheckboxListTile(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(Statics.getLabel('Sat'),
                                          style: TextStyle(fontSize: 15)),
                                      checkColor: Colors.white,
                                      activeColor: Colors.purple,
                                      value: _isSat,
                                      onChanged: (value) {
                                        setState(() {
                                          _isSat = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        Statics.getDeviceSize(context).width *
                                            0.25,
                                    child: CheckboxListTile(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(Statics.getLabel('Sun'),
                                          style: TextStyle(fontSize: 15)),
                                      checkColor: Colors.white,
                                      activeColor: Colors.purple,
                                      value: _isSun,
                                      onChanged: (value) {
                                        setState(() {
                                          _isSun = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                      if (_isSankalpit == false)
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _locationCtrl,
                          decoration: InputDecoration(
                              labelText: Statics.getLabel('Location')),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty)
                              return (Statics.getLabel(
                                  'LocationValidationMessage'));
                            return null;
                          },
                          onSaved: (value) {
                            shaakhaa!.location = value;
                          },
                        ),
                      if (_isSankalpit == false)
                        SizedBox(
                          height: 10,
                        ),
                      if (_isSankalpit == false)
                        Row(
                          children: [
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.7,
                              child: AbsorbPointer(
                                absorbing: true,
                                child: TextFormField(
                                  controller: _fromTimeCntrl,
                                  decoration: InputDecoration(
                                      labelText: Statics.getLabel('FromTime')),
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return (Statics.getLabel(
                                          'FromTimeValidationMessage'));
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                              color: Colors.purple,
                              icon: FaIcon(FontAwesomeIcons.clock),
                              onPressed: _pickFrmTime,
                            ),
                          ],
                        ),
                      if (_isSankalpit == false)
                        SizedBox(
                          height: 10,
                        ),
                      if (_isSankalpit == false)
                        Row(
                          children: [
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.7,
                              child: AbsorbPointer(
                                absorbing: true,
                                child: TextFormField(
                                  controller: _toTimeCntrl,
                                  decoration: InputDecoration(
                                      labelText: Statics.getLabel('ToTime')),
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return (Statics.getLabel(
                                          'ToTimeValidationMessage'));
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                              color: Colors.purple,
                              icon: FaIcon(FontAwesomeIcons.clock),
                              onPressed: _pickToTime,
                            ),
                          ],
                        ),
                      if (_isSankalpit == false)
                        SizedBox(
                          height: 10,
                        ),
                      if (_isSankalpit == false)
                        CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(Statics.getLabel('HasToli'),
                              style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _hasToli == null ? false : _hasToli,
                          onChanged: (value) {
                            setState(() {
                              _hasToli = value!;
                            });
                          },
                        ),
                      if (_isSankalpit == false)
                        SizedBox(
                          height: 10,
                        ),
                      if (_vayogat != null && _isSankalpit == false)
                        if (_vayogat!.indexWhere((e) =>
                                    e.staticID.toString() == _vayogatValue &&
                                    e.code == 'Baal') >
                                -1
                            ? true
                            : false)
                          Column(
                            children: [
                              CheckboxListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 0),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text(Statics.getLabel('HasPaalak'),
                                    style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _hasPaalak,
                                onChanged: (value) {
                                  setState(() {
                                    _hasPaalak = value!;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                      if (_isSankalpit == false)
                        Row(
                          children: [
                            if (_shaaririkVishay != null)
                              Container(
                                width:
                                    Statics.getDeviceSize(context).width * 0.75,
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                      labelText: Statics.getLabel(
                                          'OptionalShaaririkVishay')),
                                  isExpanded: true,
                                  value: _sharirikVishayValue == ""
                                      ? null
                                      : _sharirikVishayValue,
                                  items: _shaaririkVishay!
                                      .map((bg) => DropdownMenuItem(
                                          value: bg.staticID.toString(),
                                          child: Text(bg.codeForDisplay!)))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _sharirikVishayValue = value!;
                                    });
                                  },
                                  onSaved: (value) {
                                    if (value != null && value.isNotEmpty)
                                      shaakhaa!.shaaririkVishayID =
                                          int.parse(value);
                                    else
                                      shaakhaa!.shaaririkVishayID = null;
                                  },
                                ),
                              ),
                            IconButton(
                                color: Colors.purple,
                                onPressed: () {
                                  setState(() {
                                    this._sharirikVishayValue = null;
                                  });
                                },
                                icon: Icon(Icons.cancel)),
                          ],
                        ),
                      if (_isSankalpit == false)
                        SizedBox(
                          height: 10,
                        ),
                      if (_isSankalpit == false)
                        TextFormField(
                          textInputAction: TextInputAction.newline,
                          controller: _otherOptionalVishayCtrl,
                          minLines: 2,
                          maxLines: 3,
                          decoration: InputDecoration(
                              labelText:
                                  Statics.getLabel('OtherOptionalVishay')),
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) {
                            shaakhaa!.otherShaaririkVishay = value;
                          },
                        ),
                      if (_isSankalpit == false)
                        SizedBox(
                          height: 10,
                        ),
                      if (_isSankalpit == false)
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _remarkCtrl,
                          decoration: InputDecoration(
                              labelText: Statics.getLabel('Remark')),
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            shaakhaa!.remark = value;
                          },
                        ),
                      if (_isSankalpit == false)
                        SizedBox(
                          height: 10,
                        ),
                      if (_isLoading)
                        CircularProgressIndicator()
                      else if (widget.viewType == "ViewMenu")
                        Text(Statics.getLabel('canNotMakeChanges'))
                      else if (((Statics.userDetails['LevelName'] == 'Bhaag' ||
                                  Statics.userDetails['LevelName'] ==
                                      'भाग/जिल्हा' ||
                                  Statics.userDetails['LevelName'] ==
                                      'भाग/जिल्हा' ||
                                  Statics.userDetails['LevelName'] ==
                                      'Nagar/Taalukaa' ||
                                  Statics.userDetails['LevelName'] == 'Nagar' ||
                                  Statics.userDetails['LevelName'] ==
                                      'नगर/तालुका') &&
                              (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
                                  Statics.userDetails["DaayitvaName"] ==
                                      "जॉयन आर.एस.एस. संयोजक" ||
                                  Statics.userDetails["DaayitvaName"] ==
                                      "Join RSS Pramukh" ||
                                  Statics.userDetails["DaayitvaName"] ==
                                      "जॉयन आर.एस.एस. प्रमुख" ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'Kaaryavaah' ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'कार्यवाह' ||
                                  Statics.userDetails["DaayitvaName"] ==
                                      "karyalay sachiv" ||
                                  Statics.userDetails["DaayitvaName"] ==
                                      "कार्यालय सचिव" ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'Saha-Kaaryavaah' ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'सह कार्यवाह' ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'Baal Vidyaarthi Pramukh' ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'बाल विद्यार्थी प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'बाल विद्यार्थी प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'Mahaavidyaalayeen Vidyaarthi Pramukh' ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'महाविद्यालयीन प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'महाविद्यालयीन प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'Vyavasaayee Pramukh' ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'व्यवसायी प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'व्यवसायी प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'Vyavasaayee Saha-Pramukh' ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'व्यवसायी सह प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'व्यवसायी सह प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'Tarun Vyavsayee Pramukh' ||
                                  Statics.userDetails['DaayitvaName'] ==
                                      'तरुण व्यवसायी प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Pramukh' ||
                                  Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Sah Pramukh' ||
                                  Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Sah Pramukh' ||
                                  Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] == 'Bal Vidyarthi Sah Pramukh' ||
                                  Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] == 'Mahavidyaleen Vidyarthi Sah Pramukh' ||
                                  Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
                                  Statics.userDetails['DaayitvaName'] == 'App Sanyojak' ||
                                  Statics.userDetails['DaayitvaName'] == 'एप संयोजक' ||
                                  Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' ||
                                  Statics.userDetails['DaayitvaName'] == 'कार्यालय प्रमुख')) ||
                          (Statics.userDetails['LevelName'] == 'Praant' || Statics.userDetails['LevelName'] == 'प्रांत' && Statics.userDetails['DaayitvaName'] == 'Baal Vidyaarthi Pramukh' || Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख' || Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख' || Statics.userDetails['DaayitvaName'] == 'Mahaavidyaalayeen Vidyaarthi Pramukh' || Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख' || Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख' || Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Pramukh' || Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख' || Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख' || Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Saha-Pramukh' || Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Pramukh' || Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' || Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' || Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Pramukh' || Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' || Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' || Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Sah Pramukh' || Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Sah Pramukh' || Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'Bal Vidyarthi Sah Pramukh' || Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'Mahavidyaleen Vidyarthi Sah Pramukh' || Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'App Sanyojak' || Statics.userDetails['DaayitvaName'] == 'एप संयोजक') ||
                          (Statics.userDetails['DaayitvaName'] == 'Prachaarak' || Statics.userDetails['DaayitvaName'] == 'प्रचारक' || Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' || Statics.userDetails['DaayitvaName'] == 'सह प्रचारक'))
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor:
                              Theme.of(context).primaryTextTheme.button!.color,
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
          inAsyncCall: _isfetchingData),
    );
  }
}
