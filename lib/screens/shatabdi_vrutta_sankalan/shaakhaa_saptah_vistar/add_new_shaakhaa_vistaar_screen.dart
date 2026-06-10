import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/shaakhaa_vistar_detail_resp_model.dart';
import '../../../providers/bals.dart';
import '../../../providers/swayamsevak_provider.dart';
import '../../../utils/globals.dart';
import '../../../utils/stable_geounit_class.dart';

enum SankalpAadhaarEnum { Kaaryakartaa, Shaakhaa }

class AddNewShaakhaaVistaarScreen extends StatefulWidget {
  static const routeName = '/add-new-shakhaa-vistar-screen';

  const AddNewShaakhaaVistaarScreen({super.key});

  @override
  State<AddNewShaakhaaVistaarScreen> createState() => _AddNewShaakhaaVistaarScreenState();
}

class _AddNewShaakhaaVistaarScreenState extends State<AddNewShaakhaaVistaarScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  bool _isfetchingData = false;

  int? pkidPassed;

  bool _isSankalpit = true;
  SankalpAadhaarEnum _sankalpAadhaarEnum = SankalpAadhaarEnum.Kaaryakartaa;

  // SankalpAadhaarEnum _sankalpAadhaarEnum1 = SankalpAadhaarEnum.Kaaryakartaa;
  // SankalpAadhaarEnum _sankalpAadhaarEnum2 = SankalpAadhaarEnum.Kaaryakartaa;
  // SankalpAadhaarEnum _sankalpAadhaarEnum3 = SankalpAadhaarEnum.Kaaryakartaa;
  int? _sankalpAadhaarSwayamsevakID, _sankalpAadhaarShaakhaaID;

  // var _sankalpCompletionMonthCtrl = TextEditingController();
  // var _sankalpCompletionYearCtrl = TextEditingController();
  var _sankalpAadhaarSwayamsevakCtrl = TextEditingController();
  var _sankalpAadhaarShaakhaaCtrl = TextEditingController();
  String _sankalpAadhaarSwayamsevakValue = "";
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

  ShakhaaVistarDetail? shaakhaa;

  // String? _frequencyValue;
  String? _vayogatValue;
  String? _statusValue;

  String? _sharirikVishayValue;

  String? _dayofWeekValue;

  TimeOfDay? _fromTime;
  var _fromTimeCntrl = TextEditingController();

  TimeOfDay? _toTime;
  var _toTimeCntrl = TextEditingController();

  var bhaagID;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
    if (!mounted) return;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // pkidPassed = ModalRoute.of(context)!.settings.arguments as int?;
  }

  Future<void> initData() async {
    final args = ModalRoute.of(context)?.settings.arguments as String?;

    final dm = await MyAppGlobals.getLevelLDB();

    final controller = context.read<GeoHierarchyController>();

    if (args != null && args.isNotEmpty) {
      final trail = await controller.getTrailFromGeoUnitId(args);
      if (trail != null) await controller.setHierarchyFromTrail(trail: trail);
    } else {
      await controller.initialize(dm);
    }

    setState(() {});
    await populateDropdown();
    getShaakhaaDetails();
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
    // _sankalpCompletionMonthCtrl.dispose();
    // _sankalpCompletionYearCtrl.dispose();
    _sankalpAadhaarShaakhaaCtrl.dispose();
    _sankalpAadhaarSwayamsevakCtrl.dispose();
  }

  Future<void> populateDropdown() async {
    var data = await Statics.getStaticLDB('ShaakhaaFrequency');
    var data2 = await Statics.getStaticLDB('ShaakhaaVayogat');
    var data3 = await Statics.getStaticLDB('ShaakhaaStatus');
    var data4 = await Statics.getStaticLDB('ShaaririkVishay');

    if (!mounted) return;
    setState(() {
      _frequency = data;
      _vayogat = data2;
      _status = data3;
      _shaaririkVishay = data4;
    });
  }

  void getShaakhaaDetails() async {
    print("Shakha IDDD :-  {${pkidPassed}}");

    if (pkidPassed == null) return;

    setState(() {
      _isfetchingData = true;
    });
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      var data = await Statics.getShaakhaaSaptahByIdData(context, (pkidPassed ?? 0).toString());
      log("data -=-=-=>>>>>  $data");
      if (!mounted) return;
      shaakhaa = data;
      if (shaakhaa != null) {
        final controller = context.read<GeoHierarchyController>();

        final trail = await controller.getTrailFromGeoUnitId((shaakhaa?.parentGraamID ?? shaakhaa?.parentVastiID).toString());

        if (trail != null) await controller.setHierarchyFromTrail(trail: trail);
        setState(() {
          _shaakhaanameCtrl.text = shaakhaa!.shaakhaaName.toString();

          // _frequencyValue = shaakhaa!.frequencyID == null ? null : shaakhaa!.frequencyID.toString();

          _dayofWeekValue = shaakhaa!.daysOfWeek == null ? null : shaakhaa!.daysOfWeek.toString();

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
            _isSun = _isMon = _isTue = _isWed = _isThu = _isFri = _isSat = false;
          }

          _dayOfMonthCtrl.text = shaakhaa!.dayOfMonth.toString();
          _locationCtrl.text = shaakhaa!.location.toString();
          // _timingCtrl.text = shaakhaa!.timing.toString();

          final format = DateFormat("hh:mm a");

          _fromTime = ((shaakhaa!.startTimeStr != null && shaakhaa!.startTimeStr != "") ? TimeOfDay.fromDateTime(format.parse(shaakhaa!.startTimeStr!)) : null);

          _fromTimeCntrl.text = shaakhaa!.startTimeStr == null ? "" : shaakhaa!.startTimeStr!;

          _toTime = ((shaakhaa!.endTimeStr != null && shaakhaa!.endTimeStr != "") ? TimeOfDay.fromDateTime(format.parse(shaakhaa!.endTimeStr!)) : null);

          _toTimeCntrl.text = shaakhaa!.endTimeStr == null ? "" : shaakhaa!.endTimeStr!;

          _vayogatValue = shaakhaa!.vayogatID == null ? null : shaakhaa!.vayogatID.toString();

          _remarkCtrl.text = shaakhaa!.remark.toString();

          _isSankalpit = shaakhaa!.isSankalpit == true ? true : false;
          _sankalpAadhaarEnum = (shaakhaa!.sankalpAadhaar == 'Shaakhaa' ? SankalpAadhaarEnum.Shaakhaa : SankalpAadhaarEnum.Kaaryakartaa);
          _sankalpAadhaarSwayamsevakID = shaakhaa!.sankalpAadhaarSwayamsevakID;
          _sankalpAadhaarSwayamsevakValue = (shaakhaa!.sankalpAadhaarSwayamsevakID == null ? '' : shaakhaa!.sankalpAadhaarSwayamsevakID.toString());
          _sankalpAadhaarSwayamsevakCtrl.text = (shaakhaa!.sankalpAadhaarSwayamsevakID == null ? "" : shaakhaa!.sankalpAadhaarSwayamsevakName!);
          _sankalpAadhaarShaakhaaID = shaakhaa!.sankalpAadhaarShaakhaaID;
          _sankalpAadhaarShaakhaaValue = (shaakhaa!.sankalpAadhaarShaakhaaID == null ? '' : shaakhaa!.sankalpAadhaarShaakhaaName.toString());
          _sankalpAadhaarShaakhaaCtrl.text = (shaakhaa!.sankalpAadhaarShaakhaaID == null ? "" : shaakhaa!.shaakhaaNameDevNaagari!);
          // _sankalpCompletionMonthCtrl.text = (shaakhaa!.sankalpCompletionMonth == null ? "" : shaakhaa!.sankalpCompletionMonth.toString());
          // _sankalpCompletionYearCtrl.text = (shaakhaa!.sankalpCompletionYear == null ? "" : shaakhaa!.sankalpCompletionYear.toString());
          _hasToli = shaakhaa!.hasToli == true ? true : false;
          _hasPaalak = shaakhaa!.hasPaalak == true ? true : false;
          _sharirikVishayValue = shaakhaa!.optionalShaaririkVishayID == null ? null : shaakhaa!.optionalShaaririkVishayID.toString();
          _otherOptionalVishayCtrl.text = (shaakhaa!.otherOptionalVishay!);
        });
      }
    }
    setState(() {
      _isfetchingData = false;
    });
  }

  Future<List<dynamic>> populateSankalpAadhaarSwayamsevak(String pattern) async {
    if (pattern.length <= 2) return [];
    var swList = SwayamsevakProvider().getSwayamsevaks(json.encode({
      'AppUserID': Statics.userDetails["userID"],
      'GeoUnitID': context.read<GeoHierarchyController>().hierarchyTrail.bhaagId,
      "SearchCriteria": pattern.isEmpty ? "" : pattern,
    }));
    for (var i in await swList) {
      print(i);
    }

    return swList;
  }

  Future<List<dynamic>> populateSankalpAadhaarShaakhaa(String pattern) async {
    if (pattern.length <= 2) return [];
    var shList = Statics.getShaakhaaList(json.encode({
      'AppUserID': Statics.userDetails["userID"],
      'GeoUnitID': context.read<GeoHierarchyController>().hierarchyTrail.bhaagId,
      "ShaakhaaName": pattern.isEmpty ? null : pattern,
    }));
    return shList;
  }

  saveShaakhaaDetails() async {
    // return;
    var _dayOfWeek = "";
    if (_isSun == true) _dayOfWeek = _dayOfWeek + "0,";
    if (_isMon == true) _dayOfWeek = _dayOfWeek + "1,";
    if (_isTue == true) _dayOfWeek = _dayOfWeek + "2,";
    if (_isWed == true) _dayOfWeek = _dayOfWeek + "3,";
    if (_isThu == true) _dayOfWeek = _dayOfWeek + "4,";
    if (_isFri == true) _dayOfWeek = _dayOfWeek + "5,";
    if (_isSat == true) _dayOfWeek = _dayOfWeek + "6,";

    // if (_isSankalpit == false) {
    //   if (_frequency![_frequency!.indexWhere((p) => p.staticID.toString() == _frequencyValue.toString())].code == "Weekly") if (_dayOfWeek != "")
    //     shaakhaa!.daysOfWeek = _dayOfWeek.substring(0, _dayOfWeek.length - 1);
    //   else {
    //     Statics.showToast(Statics.getLabel('DayOfWeekValidationMessage'));
    //     return;
    //   }
    // }

    var inputData = {
      "PraantID": 1,
      "PkId": pkidPassed ?? 0,
      "ParentBhaagID": int.tryParse(context.read<GeoHierarchyController>().hierarchyTrail.bhaagId ?? ""),
      "ParentShaharID": null,
      //_shaharValue == null || _shaharValue!.isEmpty ? null : _shaharValue,
      "ParentNagarID": int.tryParse(context.read<GeoHierarchyController>().hierarchyTrail.nagarId ?? ""),
      "ParentMandalID": int.tryParse(context.read<GeoHierarchyController>().hierarchyTrail.mandalId ?? ""),
      "ParentGraamID": int.tryParse(context.read<GeoHierarchyController>().hierarchyTrail.graamId ?? ""),
      "ParentVastiID": int.tryParse(context.read<GeoHierarchyController>().hierarchyTrail.vastiId ?? ""),
      "ShaakhaaID": 0,
      "ShaakhaaName": _shaakhaanameCtrl.text,
      "ShaakhaaNameDevNaagari": _shaakhaanameCtrl.text,
      "FrequencyID": 36,
      "DaysOfWeek": shaakhaa?.daysOfWeek ?? '',
      "DayOfMonth": shaakhaa?.dayOfMonth ?? '',
      "VayogatID": int.tryParse(_vayogatValue ?? ""),
      "Location": shaakhaa?.location,
      //"Timing": shaakhaa!.timing,
      /*"StartTimeStr": (_fromTime != null
          ? DateFormat("hh:mm").format(new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " + _fromTime!.hour.toString() + ":" + _fromTime!.minute.toString())) +
              (_fromTime!.period == DayPeriod.am ? " AM" : " PM")
          : null),
      "EndTimeStr": (_toTime != null
          ? DateFormat("hh:mm").format(new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " + _toTime!.hour.toString() + ":" + _toTime!.minute.toString())) +
              (_toTime!.period == DayPeriod.am ? " AM" : " PM")
          : null),*/
      "StartTimeStr": "",
      "EndTimeStr": "",
      "Remark": shaakhaa?.remark ?? "",
      "IsSankalpit": _isSankalpit == true ? true : false,
//========================= OLD REQ PARAM =============================================================================================================================================================================
      "SankalpAadhaar": (_isSankalpit ? _sankalpAadhaarEnum.toString().split('.').last : null),
      "SankalpAadhaarSwayamsevakID": (_isSankalpit ? shaakhaa?.sankalpAadhaarSwayamsevakID : null),
      "SankalpAadhaarShaakhaaID": (_isSankalpit ? shaakhaa?.sankalpAadhaarShaakhaaID : null),
      "SankalpCompletionMonth": (_isSankalpit ? shaakhaa?.sankalpCompletionMonth : null),
      "SankalpCompletionYear": (_isSankalpit ? shaakhaa?.sankalpCompletionYear : null),

      "HasToli": _hasToli == true ? true : false,
      "HasPaalak": _hasPaalak == true ? true : false,
      "OtherOptionalVishay": shaakhaa?.otherOptionalVishay ?? "",
      "OptionalShaaririkVishayID": shaakhaa?.optionalShaaririkVishayID,
      "ModifiedBy": int.tryParse(Statics.userDetails["userID"]) ?? 0
    };

    log("inputData =-=->  ${json.encode(inputData)}");

    var data = await Statics.addNewShaakhaaVistarData(context, inputData);
    if (data == null) return;
    setState(() {});
    Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
  }

  _pickFrmTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _fromTime == null ? TimeOfDay.now() : _fromTime!,
    );

    if (time != null) {
      setState(() {
        _fromTime = time;
        _fromTimeCntrl.text =
            DateFormat("hh:mm").format(new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " + time.hour.toString() + ":" + time.minute.toString())) + (time.period == DayPeriod.am ? " AM" : " PM");
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
        _toTimeCntrl.text =
            DateFormat("hh:mm").format(new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " + time.hour.toString() + ":" + time.minute.toString())) + (time.period == DayPeriod.am ? " AM" : " PM");
      });
    }
  }

  Future<void> _submit() async {
    print("_submit 1");
    if (!_formKey.currentState!.validate()) {
      print("_submit 2");

      // Invalid!
      return;
    }
    print("_submit 3");

    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      print("_submit 4");

      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        print("_submit 5");

        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        print("_submit 6");

        await saveShaakhaaDetails();
      }
      print("_submit 7");
    } on Exception catch (error) {
      print("_submit 8");

      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    } catch (error) {
      print("_submit 9");

      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    }
    print("_submit 10");

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Statics.getLabel('EditShaakhaa')),
      ),
      body: ModalProgressHUD(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              width: Statics.getDeviceSize(context).width,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _shaakhaanameCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('ShaakhaaName')),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) return (Statics.getLabel('ShaakhaaNameValidationMessage'));
                        return null;
                      },
                      onSaved: (value) {
                        shaakhaa?.shaakhaaName = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (ctrl.hasItems(GeoLevel.Vibhaag))
                            GeoDropdownWidget(
                              level: GeoLevel.Vibhaag,
                              title: 'Vibhaag',
                              controller: ctrl,
                              validator: (v) {
                                if (v == null || v!.isEmpty) return (Statics.getLabel('GeoUnitValidationMessage'));
                                return null;
                              },
                            ),
                          if (ctrl.hasItems(GeoLevel.Bhaag))
                            GeoDropdownWidget(
                              level: GeoLevel.Bhaag,
                              title: 'Bhaag',
                              controller: ctrl,
                              validator: (v) {
                                if (v == null || v!.isEmpty) return (Statics.getLabel('SelectBhaagValidationMessage'));
                                return null;
                              },
                            ),

                          if (ctrl.hasItems(GeoLevel.Nagar))
                            GeoDropdownWidget(
                              level: GeoLevel.Nagar,
                              title: 'Nagar',
                              controller: ctrl,
                              validator: (v) {
                                if (v == null || v!.isEmpty) return (Statics.getLabel('SelectNagarValidationMessage'));
                                return null;
                              },
                            ),

                          /// CONDITIONAL
                          if (ctrl.hasItems(GeoLevel.upnagarUpkhanda))
                            GeoDropdownWidget(
                              level: GeoLevel.upnagarUpkhanda,
                              title: 'upnagarUpkhanda',
                              controller: ctrl,
                            ),

                          if (ctrl.hasItems(GeoLevel.Mandal))
                            GeoDropdownWidget(
                              level: GeoLevel.Mandal,
                              title: 'Mandal',
                              controller: ctrl,
                              validator: (v) {
                                if (v == null || v!.isEmpty) return (Statics.getLabel('SelectMandalValidationMessage'));
                                return null;
                              },
                            ),

                          if (ctrl.hasItems(GeoLevel.Graam))
                            GeoDropdownWidget(
                              level: GeoLevel.Graam,
                              title: 'Graam',
                              controller: ctrl,
                              validator: (v) {
                                if (v == null || v!.isEmpty) return (Statics.getLabel('SelectGraamValidationMessage'));
                                return null;
                              },
                            ),

                          if (ctrl.hasItems(GeoLevel.Vasti))
                            GeoDropdownWidget(
                              level: GeoLevel.Vasti,
                              title: 'Vasti',
                              controller: ctrl,
                              validator: (v) {
                                if (v == null || v!.isEmpty) return (Statics.getLabel('VastiValidationMessage'));
                                return null;
                              },
                            ),
                        ],
                      );
                    }),
                    if (_vayogat != null)
                      DropdownButtonFormField(
                        decoration: InputDecoration(labelText: Statics.getLabel('Vayogat')),
                        isExpanded: true,
                        value: _vayogatValue == "" ? null : _vayogatValue,
                        items: _vayogat!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _vayogatValue = value;
                          });
                          print(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) return (Statics.getLabel('VayogatValidationMessage'));
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty)
                            shaakhaa?.vayogatID = int.parse(value);
                          else
                            shaakhaa?.vayogatID = null;
                        },
                      ),
                    SizedBox(
                      height: 10,
                    ),

                    // ===========================   OLD LOGIC =================================================================================
                    IgnorePointer(
                      ignoring: true,
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(Statics.getLabel('IsSankalpit'), style: TextStyle(fontSize: 15)),
                        checkColor: Colors.white,
                        activeColor: Colors.purple,
                        value: _isSankalpit,
                        onChanged: (value) {
                          setState(() {
                            _isSankalpit = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    if (_isSankalpit == true)
                      Column(
                        children: [
                          Text(Statics.getLabel('SankalpAadhaar'), style: TextStyle(decoration: TextDecoration.underline)),
                          RadioListTile<SankalpAadhaarEnum>(
                            title: Text(Statics.getLabel('SankalpAadhaarKaaryakartaa')),
                            value: SankalpAadhaarEnum.Kaaryakartaa,
                            groupValue: _sankalpAadhaarEnum,
                            onChanged: (SankalpAadhaarEnum? value) {
                              setState(() {
                                _sankalpAadhaarEnum = value!;
                              });
                            },
                          ),
                          if (_sankalpAadhaarEnum.toString().split('.').last == 'Kaaryakartaa')
                            Row(
                              children: [
                                Container(
                                  width: Statics.getDeviceSize(context).width * 0.63,
                                  child: TypeAheadField(
                                    controller: _sankalpAadhaarSwayamsevakCtrl,
                                    builder: (context, controller, focusNode) {
                                      return TextField(
                                          controller: controller,
                                          focusNode: focusNode,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: UnderlineInputBorder(),
                                            labelText: Statics.getLabel('SankalpAadhaarKaaryakartaa'),
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
                                      this._sankalpAadhaarSwayamsevakValue = "";
                                      return populateSankalpAadhaarSwayamsevak(pattern);
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
                                      this._sankalpAadhaarSwayamsevakCtrl.text = suggestion["FullName"];
                                      _sankalpAadhaarSwayamsevakValue = suggestion["SwayamsevakID"].toString();
                                      shaakhaa?.sankalpAadhaarSwayamsevakID = int.parse(suggestion["SwayamsevakID"].toString());

                                      print("_sankalpAadhaarSwayamsevakValue:- ${_sankalpAadhaarSwayamsevakValue}  --- ");
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
                                        this._sankalpAadhaarSwayamsevakCtrl.text = "";
                                        _sankalpAadhaarSwayamsevakValue = "";
                                      });
                                    },
                                    icon: Icon(Icons.cancel)),
                              ],
                            ),
                          RadioListTile<SankalpAadhaarEnum>(
                            title: Text(Statics.getLabel('SankalpAadhaarShaakhaa')),
                            value: SankalpAadhaarEnum.Shaakhaa,
                            groupValue: _sankalpAadhaarEnum,
                            onChanged: (SankalpAadhaarEnum? value) {
                              setState(() {
                                _sankalpAadhaarEnum = value!;
                              });
                            },
                          ),
                          if (_sankalpAadhaarEnum.toString().split('.').last == 'Shaakhaa')
                            Row(
                              children: [
                                Container(
                                  width: Statics.getDeviceSize(context).width * 0.63,
                                  child: TypeAheadField(
                                    controller: _sankalpAadhaarShaakhaaCtrl,
                                    builder: (context, controller, focusNode) {
                                      return TextField(
                                          controller: controller,
                                          focusNode: focusNode,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: UnderlineInputBorder(),
                                            labelText: Statics.getLabel('SankalpAadhaarShaakhaa'),
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
                                      return populateSankalpAadhaarShaakhaa(pattern);
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(suggestion["GeoUnitName"]),
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
                                      this._sankalpAadhaarShaakhaaCtrl.text = suggestion["GeoUnitName"];
                                      _sankalpAadhaarShaakhaaValue = suggestion["ShaakhaaID"].toString();
                                      shaakhaa?.sankalpAadhaarShaakhaaID = int.parse(suggestion["ShaakhaaID"].toString());
                                      print("_sankalpAadhaarShaakhaaValue:--${_sankalpAadhaarShaakhaaValue}");
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
                                        this._sankalpAadhaarShaakhaaCtrl.text = "";
                                        _sankalpAadhaarShaakhaaValue = "";
                                      });
                                    },
                                    icon: Icon(Icons.cancel)),
                              ],
                            ),
                          SizedBox(height: 15),
                          /*Text(Statics.getLabel('SankalpTimeLine'), style: TextStyle(decoration: TextDecoration.underline)),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _sankalpCompletionMonthCtrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('SankalpCompletionMonth')),
                            maxLength: 2,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (_isSankalpit == true && value!.isEmpty) return (Statics.getLabel('SankalpCompletionValidationMessage'));
                              return null;
                            },
                            onSaved: (value) {
                              shaakhaa!.sankalpCompletionMonth = int.parse(value!);
                            },
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _sankalpCompletionYearCtrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('SankalpCompletionYear')),
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (_isSankalpit == true && value!.isEmpty) return (Statics.getLabel('SankalpCompletionValidationMessage'));
                              return null;
                            },
                            onSaved: (value) {
                              shaakhaa!.sankalpCompletionYear = int.parse(value!);
                            },
                          ),*/
                        ],
                      ),
                    /*if (_frequency != null)
                      DropdownButtonFormField<StaticMasterBAL>(
                        decoration: InputDecoration(labelText: Statics.getLabel('SelectFrequency')),
                        isExpanded: true,
                        value: _frequencyValue == null
                            ? null
                            : _frequency == null
                                ? null
                                : _frequency![_frequency!.indexWhere((p) => p.staticID.toString() == _frequencyValue.toString())],
                        items: _frequency != null ? _frequency!.map((bg) => DropdownMenuItem(value: bg, child: Text(bg.codeForDisplay!))).toList() : [],
                        onChanged: (value) {
                          setState(() {
                            _frequencyValue = value!.staticID.toString();
                          });
                          print("_frequencyValue  =-=-> $_frequencyValue");
                        },
                        validator: (value) {
                          if (value == null) return (Statics.getLabel('FrequencyValidationMessage'));
                          return null;
                        },
                        onSaved: (value) {
                          shaakhaa?.frequencyID = value?.staticID;
                        },
                      ),*/
                    SizedBox(
                      height: 10,
                    ),
                    // =========================== END OLD LOGIC =================================================================================
                    Container(), // just for separate old and new locgic
                    // ================================================================== NEW LOGIC  ==================================================================

                    // if (_frequency != null)
                    //   DropdownButtonFormField<StaticMasterBAL>(
                    //     decoration: InputDecoration(
                    //         labelText: Statics.getLabel('SelectFrequency')),
                    //     isExpanded: true,
                    //     value: _frequencyValue == null
                    //         ? null
                    //         : _frequency == null
                    //             ? null
                    //             : _frequency![_frequency!.indexWhere((p) =>
                    //                 p.staticID.toString() ==
                    //                 _frequencyValue.toString())],
                    //     items: _frequency != null
                    //         ? _frequency!
                    //             .map((bg) => DropdownMenuItem(
                    //                 value: bg,
                    //                 child: Text(bg.codeForDisplay!)))
                    //             .toList()
                    //         : [],
                    //     onChanged: (value) {
                    //       setState(() {
                    //         _frequencyValue = value!.staticID.toString();
                    //         print("_frequencyValue  =-=-> $_frequencyValue");
                    //       });
                    //     },
                    //     validator: (value) {
                    //       if (value == null)
                    //         return (Statics.getLabel(
                    //             'FrequencyValidationMessage'));
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
                    //   title: Text(Statics.getLabel('IsSankalpit'),
                    //       style: TextStyle(fontSize: 15)),
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

                    // //======================= D1  SELECT  SHAKHA ==================================================================================================================
                    //                       if (_isSankalpit == true &&
                    //                           (_frequencyValue == '34' ||
                    //                               _frequencyValue == '35' ||
                    //                               _frequencyValue == '36'))
                    //                         Column(
                    //                           children: [
                    //                             // Text(Statics.getLabel('SankalpAadhaar') , style: TextStyle(decoration: TextDecoration.underline)),
                    //                             Legend(
                    //                                 legendString: 'SankalpAadhaarShakhaa',
                    //                                 fontsize: 18),
                    //                             RadioListTile<SankalpAadhaarEnum>(
                    //                               title: Text(Statics.getLabel(
                    //                                   'SankalpAadhaarKaaryakartaa')),
                    //                               value: SankalpAadhaarEnum.Kaaryakartaa,
                    //                               groupValue: _sankalpAadhaarEnum1,
                    //                               onChanged: (SankalpAadhaarEnum? value) {
                    //                                 setState(() {
                    //                                   _sankalpAadhaarEnum1 = value!;
                    //                                 });
                    //                               },
                    //                             ),
                    //                             if (_sankalpAadhaarEnum1
                    //                                     .toString()
                    //                                     .split('.')
                    //                                     .last ==
                    //                                 'Kaaryakartaa')
                    //                               Row(
                    //                                 children: [
                    //                                   Container(
                    //                                     width:
                    //                                         Statics.getDeviceSize(context).width *
                    //                                             0.63,
                    //                                     child: TypeAheadField(
                    //                                       controller:
                    //                                           _sankalpAadhaarSwayamsevakCtrl1,
                    //                                       builder:
                    //                                           (context, controller, focusNode) {
                    //                                         return TextField(
                    //                                             controller: controller,
                    //                                             focusNode: focusNode,
                    //                                             decoration: InputDecoration(
                    //                                               isDense: true,
                    //                                               border: UnderlineInputBorder(),
                    //                                               labelText: Statics.getLabel(
                    //                                                   'SankalpAadhaarKaaryakartaa'),
                    //                                             ));
                    //                                       },
                    //                                       suggestionsCallback: (pattern) {
                    //                                         this._sankalpAadhaarSwayamsevakValue1 =
                    //                                             "";
                    //                                         return populateSankalpAadhaarSwayamsevak(
                    //                                             _bhaagValue!, pattern);
                    //                                       },
                    //                                       itemBuilder: (context, suggestion) {
                    //                                         print(suggestion);
                    //                                         return ListTile(
                    //                                           title: Text(suggestion["FullName"]),
                    //                                         );
                    //                                       },
                    //                                       onSelected: (suggestion) {
                    //                                         this
                    //                                             ._sankalpAadhaarSwayamsevakCtrl1
                    //                                             .text = suggestion["FullName"];
                    //                                         _sankalpAadhaarSwayamsevakValue1 =
                    //                                             suggestion["SwayamsevakID"]
                    //                                                 .toString();
                    //                                         shaakhaa!.sankalpAadhaarSwayamsevakID1 =
                    //                                             int.parse(
                    //                                                 suggestion["SwayamsevakID"]
                    //                                                     .toString());
                    //                                         print(
                    //                                             "_sankalpAadhaarSwayamsevakValue:- ${_sankalpAadhaarSwayamsevakValue1}  --- ");
                    //                                       },
                    //                                     ),
                    //                                   ),
                    //                                   IconButton(
                    //                                       color: Colors.purple,
                    //                                       onPressed: () {
                    //                                         setState(() {
                    //                                           this
                    //                                               ._sankalpAadhaarSwayamsevakCtrl1
                    //                                               .text = "";
                    //                                           _sankalpAadhaarSwayamsevakValue1 = "";
                    //                                         });
                    //                                       },
                    //                                       icon: Icon(Icons.cancel)),
                    //                                 ],
                    //                               ),
                    //                             RadioListTile<SankalpAadhaarEnum>(
                    //                               title: Text(
                    //                                   Statics.getLabel('SankalpAadhaarShaakhaa')),
                    //                               value: SankalpAadhaarEnum.Shaakhaa,
                    //                               groupValue: _sankalpAadhaarEnum1,
                    //                               onChanged: (SankalpAadhaarEnum? value) {
                    //                                 setState(() {
                    //                                   _sankalpAadhaarEnum1 = value!;
                    //                                 });
                    //                               },
                    //                             ),
                    //                             if (_sankalpAadhaarEnum1
                    //                                     .toString()
                    //                                     .split('.')
                    //                                     .last ==
                    //                                 'Shaakhaa')
                    //                               Row(
                    //                                 children: [
                    //                                   Container(
                    //                                     width:
                    //                                         Statics.getDeviceSize(context).width *
                    //                                             0.63,
                    //                                     child: TypeAheadField(
                    //                                       controller: _sankalpAadhaarShaakhaaCtrl1,
                    //                                       builder:
                    //                                           (context, controller, focusNode) {
                    //                                         return TextField(
                    //                                             controller: controller,
                    //                                             focusNode: focusNode,
                    //                                             decoration: InputDecoration(
                    //                                               isDense: true,
                    //                                               border: UnderlineInputBorder(),
                    //                                               labelText: Statics.getLabel(
                    //                                                   'SankalpAadhaarShaakhaa'),
                    //                                             ));
                    //                                       },
                    //                                       suggestionsCallback: (pattern) {
                    //                                         this._sankalpAadhaarShaakhaaValue = "";
                    //                                         return populateSankalpAadhaarShaakhaa(
                    //                                             _bhaagValue!, pattern);
                    //                                       },
                    //                                       itemBuilder: (context, suggestion) {
                    //                                         return ListTile(
                    //                                           title:
                    //                                               Text(suggestion["GeoUnitName"]),
                    //                                         );
                    //                                       },
                    //                                       onSelected: (suggestion) {
                    //                                         this._sankalpAadhaarShaakhaaCtrl1.text =
                    //                                             suggestion["GeoUnitName"];
                    //                                         _sankalpAadhaarShaakhaaValue =
                    //                                             suggestion["ShaakhaaID"].toString();
                    //                                         shaakhaa!.sankalpAadhaarShaakhaaID1 =
                    //                                             int.parse(suggestion["ShaakhaaID"]
                    //                                                 .toString());
                    //                                         print(
                    //                                             "_sankalpAadhaarShaakhaaValue:--${_sankalpAadhaarShaakhaaValue}");
                    //                                       },
                    //                                     ),
                    //                                   ),
                    //                                   IconButton(
                    //                                       color: Colors.purple,
                    //                                       onPressed: () {
                    //                                         setState(() {
                    //                                           this
                    //                                               ._sankalpAadhaarShaakhaaCtrl1
                    //                                               .text = "";
                    //                                           _sankalpAadhaarShaakhaaValue = "";
                    //                                         });
                    //                                       },
                    //                                       icon: Icon(Icons.cancel)),
                    //                                 ],
                    //                               ),
                    //                             SizedBox(
                    //                               height: 15,
                    //                             ),
                    //                             Text(Statics.getLabel('SankalpTimeLine'),
                    //                                 style: TextStyle(
                    //                                     decoration: TextDecoration.underline)),
                    //                             TextFormField(
                    //                               textInputAction: TextInputAction.next,
                    //                               controller: _sankalpCompletionMonthCtrl1,
                    //                               decoration: InputDecoration(
                    //                                   labelText: Statics.getLabel(
                    //                                       'SankalpCompletionMonth')),
                    //                               maxLength: 2,
                    //                               keyboardType: TextInputType.number,
                    //                               validator: (value) {
                    //                                 //   // if (_isSankalpit == true && value!.isEmpty) return (Statics.getLabel('SankalpCompletionValidationMessage'));
                    //                                 return null;
                    //                               },
                    //                               onSaved: (value) {
                    //                                 shaakhaa!.sankalpCompletionMonth1 =
                    //                                     int.parse(value!) ?? 00;
                    //                               },
                    //                             ),
                    //                             TextFormField(
                    //                               textInputAction: TextInputAction.next,
                    //                               controller: _sankalpCompletionYearCtrl1,
                    //                               decoration: InputDecoration(
                    //                                   labelText: Statics.getLabel(
                    //                                       'SankalpCompletionYear')),
                    //                               maxLength: 4,
                    //                               keyboardType: TextInputType.number,
                    //                               validator: (value) {
                    //                                 //   if (_isSankalpit == true && value!.isEmpty) return (Statics.getLabel('SankalpCompletionValidationMessage'));
                    //                                 return null;
                    //                               },
                    //                               onSaved: (value) {
                    //                                 shaakhaa!.sankalpCompletionYear1 =
                    //                                     int.parse(value!);
                    //                               },
                    //                             ),
                    //                           ],
                    //                         ),
                    // //======================= D1-D2  SELCT SAAPTAHIK MILAN  ====================================================================
                    //                       if (_isSankalpit == true &&
                    //                           (_frequencyValue == '35' || _frequencyValue == '36'))
                    //                         Column(
                    //                           children: [
                    //                             // Text(Statics.getLabel('SankalpAadhaar'), style: TextStyle(decoration: TextDecoration.underline)),
                    //                             Legend(
                    //                                 legendString: 'SankalpAadhaarSaptahikMilan',
                    //                                 fontsize: 18),
                    //                             RadioListTile<SankalpAadhaarEnum>(
                    //                               title: Text(Statics.getLabel(
                    //                                   'SankalpAadhaarKaaryakartaa')),
                    //                               value: SankalpAadhaarEnum.Kaaryakartaa,
                    //                               groupValue: _sankalpAadhaarEnum2,
                    //                               onChanged: (SankalpAadhaarEnum? value) {
                    //                                 setState(() {
                    //                                   _sankalpAadhaarEnum2 = value!;
                    //                                 });
                    //                               },
                    //                             ),
                    //                             if (_sankalpAadhaarEnum2
                    //                                     .toString()
                    //                                     .split('.')
                    //                                     .last ==
                    //                                 'Kaaryakartaa')
                    //                               Row(
                    //                                 children: [
                    //                                   Container(
                    //                                     width:
                    //                                         Statics.getDeviceSize(context).width *
                    //                                             0.63,
                    //                                     child: TypeAheadField(
                    //                                       controller:
                    //                                           _sankalpAadhaarSwayamsevakCtrl2,
                    //                                       builder:
                    //                                           (context, controller, focusNode) {
                    //                                         return TextField(
                    //                                             controller: controller,
                    //                                             focusNode: focusNode,
                    //                                             decoration: InputDecoration(
                    //                                               isDense: true,
                    //                                               border: UnderlineInputBorder(),
                    //                                               labelText: Statics.getLabel(
                    //                                                   'SankalpAadhaarKaaryakartaa'),
                    //                                             ));
                    //                                       },
                    //                                       suggestionsCallback: (pattern) {
                    //                                         this._sankalpAadhaarSwayamsevakValue2 =
                    //                                             "";
                    //                                         return populateSankalpAadhaarSwayamsevak(
                    //                                             _bhaagValue!, pattern);
                    //                                       },
                    //                                       itemBuilder: (context, suggestion) {
                    //                                         print(suggestion);
                    //                                         return ListTile(
                    //                                           title: Text(suggestion["FullName"]),
                    //                                         );
                    //                                       },
                    //                                       onSelected: (suggestion) {
                    //                                         this
                    //                                             ._sankalpAadhaarSwayamsevakCtrl2
                    //                                             .text = suggestion["FullName"];
                    //                                         _sankalpAadhaarSwayamsevakValue2 =
                    //                                             suggestion["SwayamsevakID"]
                    //                                                 .toString();
                    //                                         shaakhaa!.sankalpAadhaarSwayamsevakID2 =
                    //                                             int.parse(
                    //                                                 suggestion["SwayamsevakID"]
                    //                                                     .toString());
                    //
                    //                                         print(
                    //                                             "_sankalpAadhaarSwayamsevakValue:- ${_sankalpAadhaarSwayamsevakValue2}  --- ");
                    //                                       },
                    //                                     ),
                    //                                   ),
                    //                                   IconButton(
                    //                                       color: Colors.purple,
                    //                                       onPressed: () {
                    //                                         setState(() {
                    //                                           this
                    //                                               ._sankalpAadhaarSwayamsevakCtrl2
                    //                                               .text = "";
                    //                                           _sankalpAadhaarSwayamsevakValue2 = "";
                    //                                         });
                    //                                       },
                    //                                       icon: Icon(Icons.cancel)),
                    //                                 ],
                    //                               ),
                    //                             RadioListTile<SankalpAadhaarEnum>(
                    //                               title: Text(
                    //                                   Statics.getLabel('SankalpAadhaarShaakhaa')),
                    //                               value: SankalpAadhaarEnum.Shaakhaa,
                    //                               groupValue: _sankalpAadhaarEnum2,
                    //                               onChanged: (SankalpAadhaarEnum? value) {
                    //                                 setState(() {
                    //                                   _sankalpAadhaarEnum2 = value!;
                    //                                 });
                    //                               },
                    //                             ),
                    //                             if (_sankalpAadhaarEnum2
                    //                                     .toString()
                    //                                     .split('.')
                    //                                     .last ==
                    //                                 'Shaakhaa')
                    //                               Row(
                    //                                 children: [
                    //                                   Container(
                    //                                     width:
                    //                                         Statics.getDeviceSize(context).width *
                    //                                             0.63,
                    //                                     child: TypeAheadField(
                    //                                       controller: _sankalpAadhaarShaakhaaCtrl2,
                    //                                       builder:
                    //                                           (context, controller, focusNode) {
                    //                                         return TextField(
                    //                                             controller: controller,
                    //                                             focusNode: focusNode,
                    //                                             decoration: InputDecoration(
                    //                                               isDense: true,
                    //                                               border: UnderlineInputBorder(),
                    //                                               labelText: Statics.getLabel(
                    //                                                   'SankalpAadhaarShaakhaa'),
                    //                                             ));
                    //                                       },
                    //                                       suggestionsCallback: (pattern) {
                    //                                         this._sankalpAadhaarShaakhaaValue = "";
                    //                                         return populateSankalpAadhaarShaakhaa(
                    //                                             _bhaagValue!, pattern);
                    //                                       },
                    //                                       itemBuilder: (context, suggestion) {
                    //                                         return ListTile(
                    //                                           title:
                    //                                               Text(suggestion["GeoUnitName"]),
                    //                                         );
                    //                                       },
                    //                                       onSelected: (suggestion) {
                    //                                         this._sankalpAadhaarShaakhaaCtrl2.text =
                    //                                             suggestion["GeoUnitName"];
                    //                                         _sankalpAadhaarShaakhaaValue =
                    //                                             suggestion["ShaakhaaID"].toString();
                    //                                         shaakhaa!.sankalpAadhaarShaakhaaID2 =
                    //                                             int.parse(suggestion["ShaakhaaID"]
                    //                                                 .toString());
                    //                                         print(
                    //                                             "_sankalpAadhaarShaakhaaValue:--${_sankalpAadhaarShaakhaaValue}");
                    //                                       },
                    //                                     ),
                    //                                   ),
                    //                                   IconButton(
                    //                                       color: Colors.purple,
                    //                                       onPressed: () {
                    //                                         setState(() {
                    //                                           this
                    //                                               ._sankalpAadhaarShaakhaaCtrl2
                    //                                               .text = "";
                    //                                           _sankalpAadhaarShaakhaaValue = "";
                    //                                         });
                    //                                       },
                    //                                       icon: Icon(Icons.cancel)),
                    //                                 ],
                    //                               ),
                    //                             SizedBox(
                    //                               height: 15,
                    //                             ),
                    //                             Text(Statics.getLabel('SankalpTimeLine'),
                    //                                 style: TextStyle(
                    //                                     decoration: TextDecoration.underline)),
                    //                             TextFormField(
                    //                               textInputAction: TextInputAction.next,
                    //                               controller: _sankalpCompletionMonthCtrl2,
                    //                               decoration: InputDecoration(
                    //                                   labelText: Statics.getLabel(
                    //                                       'SankalpCompletionMonth')),
                    //                               maxLength: 2,
                    //                               keyboardType: TextInputType.number,
                    //                               validator: (value) {
                    //                                 //   if (_isSankalpit == true && value!.isEmpty) return (Statics.getLabel('SankalpCompletionValidationMessage'));
                    //                                 return null;
                    //                               },
                    //                               onSaved: (value) {
                    //                                 shaakhaa!.sankalpCompletionMonth2 =
                    //                                     int.parse(value!);
                    //                               },
                    //                             ),
                    //                             TextFormField(
                    //                               textInputAction: TextInputAction.next,
                    //                               controller: _sankalpCompletionYearCtrl2,
                    //                               decoration: InputDecoration(
                    //                                   labelText: Statics.getLabel(
                    //                                       'SankalpCompletionYear')),
                    //                               maxLength: 4,
                    //                               keyboardType: TextInputType.number,
                    //                               validator: (value) {
                    //                                 //   if (_isSankalpit == true && value!.isEmpty) return (Statics.getLabel('SankalpCompletionValidationMessage'));
                    //                                 return null;
                    //                               },
                    //                               onSaved: (value) {
                    //                                 shaakhaa!.sankalpCompletionYear2 =
                    //                                     int.parse(value!);
                    //                               },
                    //                             ),
                    //                           ],
                    //                         ),
                    // //======================= D1-D2-D3 SELECT MASIKMILAN/ SANGH MANDALI  ====================================================================
                    //                       if (_isSankalpit == true && _frequencyValue == '36')
                    //                         Column(
                    //                           children: [
                    //                             // Text(Statics.getLabel('SankalpAadhaar'), style: TextStyle(decoration: TextDecoration.underline)),
                    //                             Legend(
                    //                                 legendString:
                    //                                     'SankalpAadhaarMasikMilanSanghaMandali',
                    //                                 fontsize: 18),
                    //                             RadioListTile<SankalpAadhaarEnum>(
                    //                               title: Text(Statics.getLabel(
                    //                                   'SankalpAadhaarKaaryakartaa')),
                    //                               value: SankalpAadhaarEnum.Kaaryakartaa,
                    //                               groupValue: _sankalpAadhaarEnum3,
                    //                               onChanged: (SankalpAadhaarEnum? value) {
                    //                                 setState(() {
                    //                                   _sankalpAadhaarEnum3 = value!;
                    //                                 });
                    //                               },
                    //                             ),
                    //                             if (_sankalpAadhaarEnum3
                    //                                     .toString()
                    //                                     .split('.')
                    //                                     .last ==
                    //                                 'Kaaryakartaa')
                    //                               Row(
                    //                                 children: [
                    //                                   Container(
                    //                                     width:
                    //                                         Statics.getDeviceSize(context).width *
                    //                                             0.63,
                    //                                     child: TypeAheadField(
                    //                                       controller:
                    //                                           _sankalpAadhaarSwayamsevakCtrl3,
                    //                                       builder:
                    //                                           (context, controller, focusNode) {
                    //                                         return TextField(
                    //                                             controller: controller,
                    //                                             focusNode: focusNode,
                    //                                             decoration: InputDecoration(
                    //                                               isDense: true,
                    //                                               border: UnderlineInputBorder(),
                    //                                               labelText: Statics.getLabel(
                    //                                                   'SankalpAadhaarKaaryakartaa'),
                    //                                             ));
                    //                                       },
                    //                                       suggestionsCallback: (pattern) {
                    //                                         this._sankalpAadhaarSwayamsevakValue3 =
                    //                                             "";
                    //                                         return populateSankalpAadhaarSwayamsevak(
                    //                                             _bhaagValue!, pattern);
                    //                                       },
                    //                                       itemBuilder: (context, suggestion) {
                    //                                         print(suggestion);
                    //                                         return ListTile(
                    //                                           title: Text(suggestion["FullName"]),
                    //                                         );
                    //                                       },
                    //                                       onSelected: (suggestion) {
                    //                                         this
                    //                                             ._sankalpAadhaarSwayamsevakCtrl3
                    //                                             .text = suggestion["FullName"];
                    //                                         _sankalpAadhaarSwayamsevakValue3 =
                    //                                             suggestion["SwayamsevakID"]
                    //                                                 .toString();
                    //                                         shaakhaa!.sankalpAadhaarSwayamsevakID3 =
                    //                                             int.parse(
                    //                                                 suggestion["SwayamsevakID"]
                    //                                                     .toString());
                    //
                    //                                         print(
                    //                                             "_sankalpAadhaarSwayamsevakValue:- ${_sankalpAadhaarSwayamsevakValue3}  --- ");
                    //                                       },
                    //                                     ),
                    //                                   ),
                    //                                   IconButton(
                    //                                       color: Colors.purple,
                    //                                       onPressed: () {
                    //                                         setState(() {
                    //                                           this
                    //                                               ._sankalpAadhaarSwayamsevakCtrl3
                    //                                               .text = "";
                    //                                           _sankalpAadhaarSwayamsevakValue3 = "";
                    //                                         });
                    //                                       },
                    //                                       icon: Icon(Icons.cancel)),
                    //                                 ],
                    //                               ),
                    //                             RadioListTile<SankalpAadhaarEnum>(
                    //                               title: Text(
                    //                                   Statics.getLabel('SankalpAadhaarShaakhaa')),
                    //                               value: SankalpAadhaarEnum.Shaakhaa,
                    //                               groupValue: _sankalpAadhaarEnum3,
                    //                               onChanged: (SankalpAadhaarEnum? value) {
                    //                                 setState(() {
                    //                                   _sankalpAadhaarEnum3 = value!;
                    //                                 });
                    //                               },
                    //                             ),
                    //                             if (_sankalpAadhaarEnum3
                    //                                     .toString()
                    //                                     .split('.')
                    //                                     .last ==
                    //                                 'Shaakhaa')
                    //                               Row(
                    //                                 children: [
                    //                                   Container(
                    //                                     width:
                    //                                         Statics.getDeviceSize(context).width *
                    //                                             0.63,
                    //                                     child: TypeAheadField(
                    //                                       controller: _sankalpAadhaarShaakhaaCtrl3,
                    //                                       builder:
                    //                                           (context, controller, focusNode) {
                    //                                         return TextField(
                    //                                             controller: controller,
                    //                                             focusNode: focusNode,
                    //                                             decoration: InputDecoration(
                    //                                               isDense: true,
                    //                                               border: UnderlineInputBorder(),
                    //                                               labelText: Statics.getLabel(
                    //                                                   'SankalpAadhaarShaakhaa'),
                    //                                             ));
                    //                                       },
                    //                                       suggestionsCallback: (pattern) {
                    //                                         this._sankalpAadhaarShaakhaaValue = "";
                    //                                         return populateSankalpAadhaarShaakhaa(
                    //                                             _bhaagValue!, pattern);
                    //                                       },
                    //                                       itemBuilder: (context, suggestion) {
                    //                                         return ListTile(
                    //                                           title:
                    //                                               Text(suggestion["GeoUnitName"]),
                    //                                         );
                    //                                       },
                    //                                       onSelected: (suggestion) {
                    //                                         this._sankalpAadhaarShaakhaaCtrl3.text =
                    //                                             suggestion["GeoUnitName"];
                    //                                         _sankalpAadhaarShaakhaaValue =
                    //                                             suggestion["ShaakhaaID"].toString();
                    //                                         shaakhaa!.sankalpAadhaarShaakhaaID3 =
                    //                                             int.parse(suggestion["ShaakhaaID"]
                    //                                                 .toString());
                    //                                         print(
                    //                                             "_sankalpAadhaarShaakhaaValue:--${_sankalpAadhaarShaakhaaValue}");
                    //                                       },
                    //                                     ),
                    //                                   ),
                    //                                   IconButton(
                    //                                       color: Colors.purple,
                    //                                       onPressed: () {
                    //                                         setState(() {
                    //                                           this
                    //                                               ._sankalpAadhaarShaakhaaCtrl3
                    //                                               .text = "";
                    //                                           _sankalpAadhaarShaakhaaValue = "";
                    //                                         });
                    //                                       },
                    //                                       icon: Icon(Icons.cancel)),
                    //                                 ],
                    //                               ),
                    //                             SizedBox(
                    //                               height: 15,
                    //                             ),
                    //                             Text(Statics.getLabel('SankalpTimeLine'),
                    //                                 style: TextStyle(
                    //                                     decoration: TextDecoration.underline)),
                    //                             TextFormField(
                    //                               textInputAction: TextInputAction.next,
                    //                               controller: _sankalpCompletionMonthCtrl3,
                    //                               decoration: InputDecoration(
                    //                                   labelText: Statics.getLabel(
                    //                                       'SankalpCompletionMonth')),
                    //                               maxLength: 2,
                    //                               keyboardType: TextInputType.number,
                    //                               validator: (value) {
                    //                                 //   if (_isSankalpit == true && value!.isEmpty) return (Statics.getLabel('SankalpCompletionValidationMessage'));
                    //                                 return null;
                    //                               },
                    //                               onSaved: (value) {
                    //                                 shaakhaa!.sankalpCompletionMonth3 =
                    //                                     int.parse(value!);
                    //                               },
                    //                             ),
                    //                             TextFormField(
                    //                               textInputAction: TextInputAction.next,
                    //                               controller: _sankalpCompletionYearCtrl3,
                    //                               decoration: InputDecoration(
                    //                                   labelText: Statics.getLabel(
                    //                                       'SankalpCompletionYear')),
                    //                               maxLength: 4,
                    //                               keyboardType: TextInputType.number,
                    //                               validator: (value) {
                    //                                 //   if (_isSankalpit == true && value!.isEmpty) return (Statics.getLabel('SankalpCompletionValidationMessage'));
                    //                                 return null;
                    //                               },
                    //                               onSaved: (value) {
                    //                                 shaakhaa!.sankalpCompletionYear3 =
                    //                                     int.parse(value!);
                    //                               },
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       SizedBox(
                    //                         height: 10,
                    //                       ),
                    // ================================================================== NEW LOGIC END  ==================================================================
                    /*if (_frequencyValue != null && _frequency != null && _isSankalpit == false)
                      if (_frequency![_frequency!.indexWhere((p) => p.staticID.toString() == _frequencyValue.toString())].code == "Monthly")
                        Column(
                          children: [
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _dayOfMonthCtrl,
                              decoration: InputDecoration(labelText: Statics.getLabel('DayofMonth')),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) return (Statics.getLabel('DayofMonthValidationMessage'));
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
                      else if (_frequency![_frequency!.indexWhere((p) => p.staticID.toString() == _frequencyValue.toString())].code == "Weekly")
                        Column(
                          children: [
                            Text(
                              Statics.getLabel('SelectDayOfWeek'),
                            ),
                            Wrap(
                              children: [
                                SizedBox(
                                  width: Statics.getDeviceSize(context).width * 0.25,
                                  child: CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                    controlAffinity: ListTileControlAffinity.leading,
                                    title: Text(Statics.getLabel('Mon'), style: TextStyle(fontSize: 15)),
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
                                  width: Statics.getDeviceSize(context).width * 0.25,
                                  child: CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                    controlAffinity: ListTileControlAffinity.leading,
                                    title: Text(Statics.getLabel('Tue'), style: TextStyle(fontSize: 15)),
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
                                  width: Statics.getDeviceSize(context).width * 0.25,
                                  child: CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                    controlAffinity: ListTileControlAffinity.leading,
                                    title: Text(Statics.getLabel('Wed'), style: TextStyle(fontSize: 15)),
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
                                  width: Statics.getDeviceSize(context).width * 0.25,
                                  child: CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                    controlAffinity: ListTileControlAffinity.leading,
                                    title: Text(Statics.getLabel('Thu'), style: TextStyle(fontSize: 15)),
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
                                  width: Statics.getDeviceSize(context).width * 0.25,
                                  child: CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                    controlAffinity: ListTileControlAffinity.leading,
                                    title: Text(Statics.getLabel('Fri'), style: TextStyle(fontSize: 15)),
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
                                  width: Statics.getDeviceSize(context).width * 0.25,
                                  child: CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                    controlAffinity: ListTileControlAffinity.leading,
                                    title: Text(Statics.getLabel('Sat'), style: TextStyle(fontSize: 15)),
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
                                  width: Statics.getDeviceSize(context).width * 0.25,
                                  child: CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                    controlAffinity: ListTileControlAffinity.leading,
                                    title: Text(Statics.getLabel('Sun'), style: TextStyle(fontSize: 15)),
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
                        ),*/
                    if (_isSankalpit == false)
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _locationCtrl,
                        decoration: InputDecoration(labelText: Statics.getLabel('Location')),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) return (Statics.getLabel('LocationValidationMessage'));
                          return null;
                        },
                        onSaved: (value) {
                          shaakhaa?.location = value;
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
                                decoration: InputDecoration(labelText: Statics.getLabel('FromTime')),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value!.isEmpty) return (Statics.getLabel('FromTimeValidationMessage'));
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
                                decoration: InputDecoration(labelText: Statics.getLabel('ToTime')),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value!.isEmpty) return (Statics.getLabel('ToTimeValidationMessage'));
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
                    /*if (_isSankalpit == false && _frequencyValue != "36")
                      CheckboxListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(Statics.getLabel('HasToli'), style: TextStyle(fontSize: 15)),
                        checkColor: Colors.white,
                        activeColor: Colors.purple,
                        value: _hasToli == null ? false : _hasToli,
                        onChanged: (value) {
                          setState(() {
                            _hasToli = value!;
                          });
                        },
                      ),
                    if (_isSankalpit == false && _frequencyValue != "36")
                      SizedBox(
                        height: 10,
                      ),*/
                    /*if (_vayogat != null && _isSankalpit == false)
                      if (!((_vayogat!.where((e) => e.staticID.toString() == _vayogatValue && e.code == 'Baal').isNotEmpty) &&
                          (_frequency!.where((e) => e.staticID.toString() == _frequencyValue && e.code == 'Monthly').isNotEmpty)))
                        Column(
                          children: [
                            CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(Statics.getLabel('HasPaalak'), style: TextStyle(fontSize: 15)),
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
                    if (_isSankalpit == false && _frequencyValue != "36")
                      Row(
                        children: [
                          if (_shaaririkVishay != null)
                            Container(
                              width: Statics.getDeviceSize(context).width * 0.75,
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(labelText: Statics.getLabel('OptionalShaaririkVishay')),
                                isExpanded: true,
                                value: _sharirikVishayValue == "" ? null : _sharirikVishayValue,
                                items: _shaaririkVishay!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _sharirikVishayValue = value!;
                                  });
                                },
                                onSaved: (value) {
                                  if (value != null && value.isNotEmpty)
                                    shaakhaa!.optionalShaaririkVishayID = int.parse(value);
                                  else
                                    shaakhaa!.optionalShaaririkVishayID = null;
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
                    if (_isSankalpit == false && _frequencyValue != "36")
                      SizedBox(
                        height: 10,
                      ),
                    if (_isSankalpit == false && _frequencyValue != "36")
                      TextFormField(
                        textInputAction: TextInputAction.newline,
                        controller: _otherOptionalVishayCtrl,
                        minLines: 2,
                        maxLines: 3,
                        decoration: InputDecoration(labelText: Statics.getLabel('OtherOptionalVishay')),
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) {
                          shaakhaa!.otherOptionalVishay = value;
                        },
                      ),
                    if (_isSankalpit == false && _frequencyValue != "36")
                      SizedBox(
                        height: 10,
                      ),
                    if (_isSankalpit == false && _frequencyValue != "36")
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _remarkCtrl,
                        decoration: InputDecoration(labelText: Statics.getLabel('Remark')),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          shaakhaa!.remark = value;
                        },
                      ),*/
                    if (_isSankalpit == false)
                      SizedBox(
                        height: 10,
                      ),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else if (Statics.levelId > 3)
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
          inAsyncCall: _isfetchingData),
    );
  }
}
