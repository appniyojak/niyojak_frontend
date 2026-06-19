import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
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
  Map<String, dynamic>? args;

  final controller = createGeoController();

  int? pkidPassed;
  int? geoidPassed;

  bool _isSankalpit = true;
  SankalpAadhaarEnum _sankalpAadhaarEnum = SankalpAadhaarEnum.Kaaryakartaa;

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

  final List<TextEditingController> _aadharControllers = [];

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
    _aadharControllers.add(TextEditingController());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
    // if (!mounted) return;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    pkidPassed = int.tryParse((args?["pkid"] ?? 0).toString());
    geoidPassed = int.tryParse((args?["geoid"] ?? 0).toString());
    log("LOG >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $args");
  }

  Future<void> initData() async {
    final dm = await MyAppGlobals.getLevelLDB();

    if (args != null && geoidPassed != null) {
      final trail = await controller.getTrailFromGeoUnitId((geoidPassed ?? 0).toString());
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
    // Always dispose controllers to avoid memory leaks
    for (var controller in _aadharControllers) {
      controller.dispose();
    }
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

  // Add a new text field (Max 5)
  void _addNewField() {
    if (_aadharControllers.length < 5 && _areAllFieldsValid()) {
      setState(() {
        _aadharControllers.add(TextEditingController());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all existing fields before adding a new one!"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Remove a field automatically if it gets cleared
  void _handleFieldChange(int index, String value) {
    // If text is cleared AND we have more than the minimum of 1 field
    if (value.trim().isEmpty && _aadharControllers.length > 1) {
      // Use PostFrameCallback to prevent element tree conflicts during active rendering
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _aadharControllers[index].dispose();
          _aadharControllers.removeAt(index);
        });
      });
    } else {
      // Re-trigger state build to update the "Add More" button's enabled/disabled visual state
      setState(() {});
    }
  }

  void _removeField(int index) {
    setState(() {
      // 1. Dispose to prevent memory leaks
      _aadharControllers[index].dispose();

      // 2. Remove the controller from the list
      _aadharControllers.removeAt(index);

      // Note: If you maintain any other lists corresponding to this index
      // (e.g., FocusNodes, or a list of saved string values),
      // make sure to remove the item at this index from those lists as well.
    });
  }

  // Checks both emptiness AND duplicates to control the "Add More" button
  bool _areAllFieldsValid() {
    // 1. Check for empty fields
    bool hasEmpty = _aadharControllers.any((c) => c.text.trim().isEmpty);
    if (hasEmpty) return false;

    // 2. Check for duplicates (case-insensitive)
    List<String> names = _aadharControllers.map((c) => c.text.trim().toLowerCase()).toList();
    Set<String> uniqueNames = names.toSet();

    // If the Set length is smaller than the List length, duplicates exist
    if (names.length != uniqueNames.length) return false;

    return true;
  }

  // TextFormField level validator
  String? _validateField(String? value, int index) {
    if (value == null || value.trim().isEmpty) {
      return "Field cannot be empty";
    }

    final currentName = value.trim().toLowerCase();
    int duplicateCount = 0;

    // Count how many times this exact text appears across all controllers
    for (var controller in _aadharControllers) {
      if (controller.text.trim().toLowerCase() == currentName) {
        duplicateCount++;
      }
    }

    if (duplicateCount > 1) {
      return Statics.getLabel("duplicationValidation");
    }

    return null;
  }

  // 1. Prepare data to SEND to the API
  Map<String, dynamic> preparePayloadForApi(Map<String, dynamic> payload) {
    for (int i = 1; i <= 5; i++) {
      if (i <= _aadharControllers.length) {
        payload['aadhar$i'] = _aadharControllers[i - 1].text.trim();
      } else {
        payload['aadhar$i'] = ""; // Set empty if field doesn't exist
      }
    }
    return payload;
  }

  // 2. Load data received FROM the API
  void loadDataFromModel(ShakhaaVistarDetail model) {
    setState(() {
      // Safely clear out old controllers to prevent memory leaks
      for (var controller in _aadharControllers) {
        controller.dispose();
      }
      _aadharControllers.clear();

      // Group properties into a temporary list for easy iteration
      final apiFields = [
        model.aadhar1,
        model.aadhar2,
        model.aadhar3,
        model.aadhar4,
        model.aadhar5,
      ];

      // Loop through your model data and build controllers
      for (String? value in apiFields) {
        if (value != null && value.trim().isNotEmpty) {
          _aadharControllers.add(TextEditingController(text: value));
        }
      }

      // Safety fallback: Ensure at least one blank field exists if model data was empty
      if (_aadharControllers.isEmpty) {
        _aadharControllers.add(TextEditingController());
      }
    });
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
    log("Shakha IDDD :-  $pkidPassed");

    if (pkidPassed == null || pkidPassed == 0) return;

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
        final trail = await controller.getTrailFromGeoUnitId((shaakhaa?.parentGraamID ?? shaakhaa?.parentVastiID).toString());

        if (trail != null) await controller.setHierarchyFromTrail(trail: trail);
        loadDataFromModel(shaakhaa!);
        setState(() {
          _shaakhaanameCtrl.text = (shaakhaa?.shaakhaaName ?? "").toString();

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

          _vayogatValue = (shaakhaa?.vayogatID == null || shaakhaa?.vayogatID == 0) ? null : (shaakhaa?.vayogatID ?? "").toString();

          _remarkCtrl.text = shaakhaa!.remark.toString();

          _isSankalpit = shaakhaa?.isSankalpit ?? true;
          _sankalpAadhaarEnum = (shaakhaa!.sankalpAadhaar == 'Shaakhaa' ? SankalpAadhaarEnum.Shaakhaa : SankalpAadhaarEnum.Kaaryakartaa);
          _sankalpAadhaarSwayamsevakID = shaakhaa!.sankalpAadhaarSwayamsevakID;
          _sankalpAadhaarSwayamsevakValue = (shaakhaa!.sankalpAadhaarSwayamsevakID == null ? '' : shaakhaa!.sankalpAadhaarSwayamsevakID.toString());
          _sankalpAadhaarSwayamsevakCtrl.text = (shaakhaa!.sankalpAadhaarSwayamsevakID == null ? "" : shaakhaa!.sankalpAadhaarSwayamsevakName!);
          _sankalpAadhaarShaakhaaID = shaakhaa!.sankalpAadhaarShaakhaaID;
          _sankalpAadhaarShaakhaaValue = (shaakhaa!.sankalpAadhaarShaakhaaID == null ? '' : (shaakhaa?.sankalpAadhaarShaakhaaName ?? ""));
          _sankalpAadhaarShaakhaaCtrl.text = (shaakhaa!.sankalpAadhaarShaakhaaID == null ? "" : (shaakhaa?.sankalpAadhaarShaakhaaName ?? ""));
          // _sankalpCompletionMonthCtrl.text = (shaakhaa!.sankalpCompletionMonth == null ? "" : shaakhaa!.sankalpCompletionMonth.toString());
          // _sankalpCompletionYearCtrl.text = (shaakhaa!.sankalpCompletionYear == null ? "" : shaakhaa!.sankalpCompletionYear.toString());
          _hasToli = shaakhaa!.hasToli == true ? true : false;
          _hasPaalak = shaakhaa!.hasPaalak == true ? true : false;
          _sharirikVishayValue = shaakhaa!.optionalShaaririkVishayID == null ? null : shaakhaa!.optionalShaaririkVishayID.toString();
          _otherOptionalVishayCtrl.text = (shaakhaa!.otherOptionalVishay ?? "");
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
      'GeoUnitID': controller.hierarchyTrail.bhaagId,
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
      'GeoUnitID': controller.hierarchyTrail.bhaagId,
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
      "ParentBhaagID": int.tryParse(controller.hierarchyTrail.bhaagId ?? ""),
      "ParentShaharID": null,
      //_shaharValue == null || _shaharValue!.isEmpty ? null : _shaharValue,
      "ParentNagarID": int.tryParse(controller.hierarchyTrail.nagarId ?? ""),
      "ParentMandalID": int.tryParse(controller.hierarchyTrail.mandalId ?? ""),
      "ParentGraamID": int.tryParse(controller.hierarchyTrail.graamId ?? ""),
      "ParentVastiID": int.tryParse(controller.hierarchyTrail.vastiId ?? ""),
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

    final _finalInputData = preparePayloadForApi(inputData);

    log("inputData =-=->  ${json.encode(_finalInputData)}");

    var data = await Statics.addNewShaakhaaVistarData(context, _finalInputData);
    if (data == null) return;
    setState(() {});
    if (data == "200") {
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
      Navigator.of(context).pop(true);
    }
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
                    SizedBox(height: 10),

                    ///
                    ChangeNotifierProvider.value(
                      value: controller,
                      child: Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (ctrl.hasItems(GeoLevel.Vibhaag))
                              GeoDropdownWidget(
                                level: GeoLevel.Vibhaag,
                                title: 'Vibhaag',
                                controller: ctrl,
                                isDisabled: (userLevelId ?? 0) < 8 || userLevelId == 13,
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
                                isDisabled: (userLevelId ?? 0) < 7 || userLevelId == 13,
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
                                isDisabled: (userLevelId ?? 0) < 6 || userLevelId == 13,
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
                                isDisabled: (userLevelId ?? 0) < 6 || userLevelId == 13,
                              ),

                            if (ctrl.hasItems(GeoLevel.Mandal))
                              GeoDropdownWidget(
                                level: GeoLevel.Mandal,
                                title: 'Mandal',
                                controller: ctrl,
                                isDisabled: (userLevelId ?? 0) < 4,
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
                                isDisabled: userLevelId == 3,
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
                                isDisabled: userLevelId == 2,
                                validator: (v) {
                                  if (v == null || v!.isEmpty) return (Statics.getLabel('VastiValidationMessage'));
                                  return null;
                                },
                              ),
                          ],
                        );
                      }),
                    ),

                    ///

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
                    SizedBox(height: 10),
                    /*IgnorePointer(
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
                    ),*/
                    SizedBox(height: 14),
                    Text(
                      Statics.getLabel('addAadharPerson'),
                      style: TextStyle(color: Colors.black, decoration: TextDecoration.underline, fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "* ${Statics.getLabel('Note')} : ",
                          style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600, decoration: TextDecoration.underline, decorationColor: Colors.red, fontStyle: FontStyle.italic),
                        ),
                        Expanded(
                          child: Text(
                            Statics.getLabel('addAadharPersonTip'),
                            style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _aadharControllers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              // The Dynamic TextFormField
                              Expanded(
                                child: TextFormField(
                                  controller: _aadharControllers[index],
                                  decoration: InputDecoration(
                                    labelText: "${Statics.getLabel("name")} ${index + 1}",
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  validator: (value) => _validateField(value, index),
                                  onChanged: (value) => _handleFieldChange(index, value),
                                ),
                              ),
                              const SizedBox(width: 10),

                              // 1. Cancel Button (Show ONLY on newly added fields, i.e., index > 0)
                              if (index > 0)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: IconButton(
                                    icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                                    tooltip: "Remove",
                                    onPressed: () => _removeField(index), // Logic provided below
                                  ),
                                ),

                              // 2. "Add More" button ONLY on the last item and if count < 5
                              if (index == _aadharControllers.length - 1 && _aadharControllers.length < 5)
                                ElevatedButton.icon(
                                  onPressed: _areAllFieldsValid() ? _addNewField : null,
                                  icon: const Icon(Icons.add),
                                  label: Text(Statics.getLabel("AddMore")),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                  ),
                                )
                              else if (index == 0)
                                // Empty placeholder to keep alignment consistent for the first item
                                const SizedBox(width: 21),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 21),

                    if (_isLoading)
                      CircularProgressIndicator()
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
          inAsyncCall: _isfetchingData),
    );
  }
}
