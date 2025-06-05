import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widgets/legend.dart';
import '../providers/bals.dart';

import '../helpers/static_data.dart' as Statics;

class EventDetails extends StatefulWidget {
  int? eventId;
  var onSaveDetails;
  var viewType;
  EventDetails({Key? key, this.eventId, this.onSaveDetails, this.viewType}) : super(key: key);
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  bool _isfetingData = false;

  EventMasterBAL? event;

  List<StaticMasterBAL>? _eventType;
  String? _eventTypeValue;

  var _eventnameCtrl = TextEditingController();
  DateTime? _fromDate, _toDate;
  var _fromDateCntrl = TextEditingController();
  var _toDateCntrl = TextEditingController();

  TimeOfDay? _fromTime;
  var _fromTimeCntrl = TextEditingController();

  TimeOfDay? _toTime;
  var _toTimeCntrl = TextEditingController();

  String? _ownerID;

  var _ownerCtrl = TextEditingController();
  var _descriptionCtrl = TextEditingController();
  var _venueCtrl = TextEditingController();
  var _prepDescriptionCtrl = TextEditingController();

  String? _bhaagValue = "";
  String? _shaharValue = "";
  String? _nagarValue = "";
  String? _mandalValue = "";
  String? _vastiValue = "";
  String? _graamValue = "";
  String? _shaakhaaValue = "";

  List<GeoUnitMasterBAL>? _bhaag;
  List<GeoUnitMasterBAL>? _shahar;
  List<GeoUnitMasterBAL>? _nagar;
  List<GeoUnitMasterBAL>? _mandal;
  List<GeoUnitMasterBAL>? _graam;
  List<GeoUnitMasterBAL>? _vasti;
  List<GeoUnitMasterBAL>? _shaakhaa;

  @override
  void initState() {
    super.initState();
    populateDropdown();
    int? eventID = widget.eventId;
    if (eventID! > 0) {
      getEventDetails(widget.eventId);
    } else {
      if (!mounted) return;
      setState(() {
        event = new EventMasterBAL(
            null, 1, null, "", "", "", "", "", "", null, Statics.userDetails["UserID"], Statics.userDetails["FullName"], "", "", "");

        _ownerCtrl.text = Statics.userDetails["FullName"];
        _ownerID = Statics.userDetails["userID"];
      });
    }
  }

  void populateDropdown() async {
    var data = await Statics.getStaticLDB("EventType");
    if (!mounted) return;
    setState(() {
      _eventType = data;
    });
    populateBhaagDropdown();
  }

  @override
  void dispose() {
    super.dispose();
    _eventnameCtrl.dispose();
    _ownerCtrl.dispose();
    _fromDateCntrl.dispose();
    _toDateCntrl.dispose();
    _fromTimeCntrl.dispose();
    _toTimeCntrl.dispose();
    _descriptionCtrl.dispose();
    _venueCtrl.dispose();
    _prepDescriptionCtrl.dispose();
  }

  void getEventDetails(int? theId) async {
    setState(() {
      _isfetingData = true;
    });
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      var dataList = await Statics.getEventList(theId, null, null, null);
      var data = EventMasterBAL(
          dataList[0]["EventID"],
          dataList[0]["PraantID"],
          dataList[0]["EventTypeID"],
          dataList[0]["EventName"],
          dataList[0]["Description"],
          dataList[0]["FromDateStr"],
          dataList[0]["ToDateStr"],
          dataList[0]["FromTimeStr"],
          dataList[0]["ToTimeStr"],
          dataList[0]["GeoUnitID"],
          dataList[0]["OwnerSwayamsevakID"],
          dataList[0]["OwnerSwayamsevakName"],
          dataList[0]["OwnerSwayamsevakMobileNumber"],
          dataList[0]["PreparationDetail"],
          dataList[0]["Venue"]);

      if (!mounted) return;
      setState(() {
        event = data;
        if (event != null) {
          _eventnameCtrl.text = event!.eventName == null ? "" : event!.eventName!;
          _descriptionCtrl.text = event!.description == null ? "" : event!.description!;

          _fromDate = ((event!.fromDate != null && event!.fromDate != "") ? DateTime.parse(event!.fromDate!) : null);
          _fromDateCntrl.text = ((event!.fromDate != null && event!.fromDate != "") ? DateFormat('dd-MMM-yyyy').format(_fromDate!) : '');
          _toDate = ((event!.toDate != null && event!.toDate != "") ? DateTime.parse(event!.toDate!) : null);
          _toDateCntrl.text = ((event!.toDate != null && event!.toDate != "") ? DateFormat('dd-MMM-yyyy').format(_toDate!) : '');

          final format = DateFormat("hh:mm a");

          _fromTime = ((event!.fromTime != null && event!.fromTime != "") ? TimeOfDay.fromDateTime(format.parse(event!.fromTime!)) : null);

          _fromTimeCntrl.text = event!.fromTime == null ? "" : event!.fromTime!;

          _toTime = ((event!.toTime != null && event!.toTime != "") ? TimeOfDay.fromDateTime(format.parse(event!.toTime!)) : null);

          _toTimeCntrl.text = event!.toTime == null ? "" : event!.toTime!;

          _eventTypeValue = event!.eventTypeID == null ? null : event!.eventTypeID.toString();

          _venueCtrl.text = event!.venue == null ? "" : event!.venue!;
          _prepDescriptionCtrl.text = event!.preparationDetail == null ? "" : event!.preparationDetail!;

          var _geoUnitID = event!.geoUnitID == null ? null : event!.geoUnitID.toString();

          _ownerID = event!.ownerSwayamsevakID.toString();
          _ownerCtrl.text = event!.ownerSwayamsevakName.toString();

          if (_geoUnitID != null) {
            getGeoUnitDets(_geoUnitID);
          }
        }
      });
    }
    setState(() {
      _isfetingData = false;
    });
  }

  _pickFromDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: _fromDate == null ? DateTime.now() : _fromDate!,
        firstDate: DateTime((_fromDate == null ? DateTime.now().year : _fromDate!.year) - 80),
        lastDate: DateTime((_fromDate == null ? DateTime.now().year : _fromDate!.year) + 80));

    var _todaysDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    if (date != null && _todaysDate.isAfter(date)) {
      Statics.showToast(Statics.getLabel('CanNotCreateEventInPast'));
      return;
    }

    if (date != null) {
      setState(() {
        _fromDate = date;
        _fromDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date);
        if (_toDate == null) {
          _toDate = date;
          _toDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date);
        }
      });
    }
  }

  _pickToDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: _toDate == null ? DateTime.now() : _toDate!,
        firstDate: DateTime((_toDate == null ? DateTime.now().year : _toDate!.year) - 80),
        lastDate: DateTime((_toDate == null ? DateTime.now().year : _toDate!.year) + 80));

    var _todaysDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    if (date != null && _todaysDate.isAfter(date)) {
      Statics.showToast(Statics.getLabel('CanNotCreateEventInPast'));
      return;
    }
    if (date != null && _fromDate!.isAfter(date)) {
      Statics.showToast(Statics.getLabel('CanNotCreateEventInPast'));
      return;
    }

    if (date != null) {
      setState(() {
        _toDate = date;
        _toDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date);
      });
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
        _fromTimeCntrl.text = DateFormat("hh:mm")
                .format(new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " + time.hour.toString() + ":" + time.minute.toString())) +
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
        _toTimeCntrl.text = DateFormat("hh:mm")
                .format(new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " + time.hour.toString() + ":" + time.minute.toString())) +
            (time.period == DayPeriod.am ? " AM" : " PM");
      });
    }
  }

  void populateBhaagDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), "", "", "");

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

  void populateMandalDropdown(String nagarIDStr) async {
    _mandalValue = _graamValue = null;
    _mandal = _graam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _mandal = (mnDD.length > 0 ? mnDD : null);
    });
  }

  void populateGraamDropdown(String mandalIDStr) async {
    _graamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _graam = (gmDD.length > 0 ? gmDD : null);
    });
  }

  void populateVastiDropdown(String? nagarIDStr) async {
    _vastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    setState(() {
      _vasti = (vsDD.length > 0 ? vsDD : null);
    });
  }

  void populatelinkedShaakhaDropdown(String iDStr, String strType) async {
    _shaakhaaValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaakhaaLevelID'].toString(), iDStr, strType, '');
    setState(() {
      _shaakhaa = (vsDD.length > 0 ? vsDD : null);
    });
  }

  void getGeoUnitDets(geoUnitID) async {
    GeoUnitMasterBAL? geoUnitDets = await Statics.getGeoUnitsByID(geoUnitID);

    _bhaagValue = geoUnitDets!.levelName == "Bhaag"
        ? geoUnitID
        : geoUnitDets.parentBhaagID == null
            ? null
            : geoUnitDets.parentBhaagID.toString();
    if (_bhaagValue != null) populateShaharDropdown(_bhaagValue!);
    if (geoUnitDets.levelName == "Bhaag") return;

    _shaharValue = geoUnitDets.levelName == "Shahar"
        ? geoUnitID
        : geoUnitDets.parentShaharID == null
            ? null
            : geoUnitDets.parentShaharID.toString();
    if (_shaharValue != null || _bhaagValue != null) populateNagarDropdown(_bhaagValue!, _shaharValue!);
    if (geoUnitDets.levelName == "Shahar") return;

    _nagarValue = geoUnitDets.levelName == "Nagar"
        ? geoUnitID
        : geoUnitDets.parentNagarID == null
            ? null
            : geoUnitDets.parentNagarID.toString();
    if (_nagarValue != null) {
      populateMandalDropdown(_nagarValue!);
      populateVastiDropdown(_nagarValue!);
    }
    if (geoUnitDets.levelName == "Nagar") return;

    _mandalValue = geoUnitDets.levelName == "Mandal"
        ? geoUnitID
        : geoUnitDets.parentMandalID == null
            ? null
            : geoUnitDets.parentMandalID.toString();
    if (_mandalValue != null) populateGraamDropdown(_mandalValue!);
    if (geoUnitDets.levelName == "Mandal") return;

    _graamValue = geoUnitDets.levelName == "Graam"
        ? geoUnitID
        : geoUnitDets.parentMandalID == null
            ? null
            : geoUnitDets.parentGraamID.toString();

    if (_graamValue != null) populatelinkedShaakhaDropdown(_graamValue!, "Graam");
    if (geoUnitDets.levelName == "Graam") return;

    _vastiValue = geoUnitDets.levelName == "Vasti"
        ? geoUnitID
        : geoUnitDets.parentMandalID == null
            ? geoUnitDets.parentVastiID.toString()
            : null;
    if (_vastiValue != null) populatelinkedShaakhaDropdown(_vastiValue!, "Vasti");
    if (geoUnitDets.levelName == "Vasti") return;

    _shaakhaaValue = geoUnitDets.levelName == "Shaakhaa" ? geoUnitID : null;
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
        await saveEventDetails();
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

  saveEventDetails() async {
    int? bhaagVal = _bhaagValue == null || _bhaagValue == "" ? null : int.parse(_bhaagValue!);
    int? shaharVal = _shaharValue == null || _shaharValue == "" ? null : int.parse(_shaharValue!);
    int? nagarVal = _nagarValue == null || _nagarValue == "" ? null : int.parse(_nagarValue!);

    int? mandalVal = _mandalValue == null || _mandalValue == "" ? null : int.parse(_mandalValue!);

    int? graamVal = _graamValue == null || _graamValue == "" ? null : int.parse(_graamValue!);

    int? vastiVal = _vastiValue == null || _vastiValue == "" ? null : int.parse(_vastiValue!);

    int? shaakhaaVal = _shaakhaaValue == null || _shaakhaaValue == "" ? null : int.parse(_shaakhaaValue!);

    int? geoUnitID;
    geoUnitID = shaakhaaVal != null
        ? shaakhaaVal
        : vastiVal != null
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

    if (geoUnitID == null) {
      Statics.showErrorDialog(context, "Please Select Geo Unit");
      return;
    }
    if (_fromDate!.isAfter(_toDate!)) {
      Statics.showErrorDialog(context, Statics.getLabel('ToDateCanNotBeBeforeFromDate'));
      return;
    }
    var inputData = json.encode({
      "EventID": widget.eventId,
      "PraantID": 1,
      "EventName": event!.eventName,
      "OwnerSwayamsevakID": _ownerID,
      "EventTypeID": event!.eventTypeID,
      "GeoUnitID": geoUnitID,
      "FromDateStr": (_fromDate != null ? DateFormat('dd-MM-yyyy').format(_fromDate!) : null),
      "ToDateStr": (_toDate != null ? DateFormat('dd-MM-yyyy').format(_toDate!) : null),
      "FromTimeStr": (_fromTime != null
          ? DateFormat("hh:mm")
                  .format(new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " + _fromTime!.hour.toString() + ":" + _fromTime!.minute.toString())) +
              (_fromTime!.period == DayPeriod.am ? " AM" : " PM")
          : null),
      "ToTimeStr": (_toTime != null
          ? DateFormat("hh:mm")
                  .format(new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " + _toTime!.hour.toString() + ":" + _toTime!.minute.toString())) +
              (_toTime!.period == DayPeriod.am ? " AM" : " PM")
          : null),
      "Venue": event!.venue,
      "PreparationDetail": event!.preparationDetail,
      "Description": event!.description,
      "ModifiedBy": Statics.userDetails["userID"]
    });

    var data = await Statics.saveEventDetails(inputData);
    setState(() {
      widget.eventId = int.parse(data.toString());
      widget.onSaveDetails(widget.eventId);
      if (data == '-1')
        Statics.showToast(Statics.getLabel('unableToSaveData'));
      else
        Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
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
                        controller: _eventnameCtrl,
                        decoration: InputDecoration(labelText: Statics.getLabel('EventName')),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) return (Statics.getLabel('EventNameValidationMessage'));
                          return null;
                        },
                        onSaved: (value) {
                          event!.eventName = value;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _descriptionCtrl,
                        decoration: InputDecoration(labelText: Statics.getLabel('Description')),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          event!.description = value == "" ? null : value;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.7,
                            child: AbsorbPointer(
                              absorbing: true,
                              child: TextFormField(
                                controller: _fromDateCntrl,
                                decoration: InputDecoration(labelText: Statics.getLabel('FromEventDate')),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value!.isEmpty) return (Statics.getLabel('FromEventDateValidationMessage'));
                                  return null;
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            color: Colors.purple,
                            icon: FaIcon(FontAwesomeIcons.solidCalendarAlt),
                            onPressed: _pickFromDate,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.7,
                            child: AbsorbPointer(
                              absorbing: true,
                              child: TextFormField(
                                controller: _toDateCntrl,
                                decoration: InputDecoration(labelText: Statics.getLabel('ToEventDate')),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value!.isEmpty) return (Statics.getLabel('ToEventDateValidationMessage'));
                                  return null;
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            color: Colors.purple,
                            icon: FaIcon(FontAwesomeIcons.solidCalendarAlt),
                            onPressed: _pickToDate,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                      SizedBox(
                        height: 10,
                      ),
                      if(_eventType != null)
                      DropdownButtonFormField(
                        decoration: InputDecoration(labelText: Statics.getLabel('EventType')),
                        isExpanded: true,
                        value: _eventTypeValue == "" ? null : _eventTypeValue,
                        items: _eventType!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _eventTypeValue = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) return (Statics.getLabel('EventTypeValidationMessage'));
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty)
                            event!.eventTypeID = int.parse(value);
                          else
                            event!.eventTypeID = null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _venueCtrl,
                        decoration: InputDecoration(labelText: Statics.getLabel('Venue')),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          event!.venue = value == "" ? null : value;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _prepDescriptionCtrl,
                        decoration: InputDecoration(labelText: Statics.getLabel('PreparationDetail')),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          event!.preparationDetail = value == "" ? null : value;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Legend(legendString: 'TargetGeoUnit', fontsize: 18),
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
                                      textColor: Theme.of(context).primaryTextTheme.button!.color,
                                      onPressed: () {
                                        setState(() {
                                          _bhaagValue = _shaharValue = _nagarValue = _mandalValue = _graamValue = _vastiValue = _shaakhaaValue = null;
                                          _bhaag = _shahar = _nagar = _mandal = _graam = _vasti = _shaakhaa = null;
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
                            if(_bhaag != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                              isExpanded: true,
                              value: _bhaagValue == "" ? null : _bhaagValue,
                              items: _bhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _bhaagValue = value;
                                  populateShaharDropdown(value!);
                                  populateNagarDropdown(value, null);
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
                                onChanged: (value) {
                                  setState(() {
                                    _shaharValue = value;
                                    populateNagarDropdown(null, value);
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
                                onChanged: (value) {
                                  setState(() {
                                    _nagarValue = value;
                                    populateMandalDropdown(value!);
                                    populateVastiDropdown(value);
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
                                onChanged: (value) {
                                  setState(() {
                                    _mandalValue = value;
                                    populateGraamDropdown(value!);
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
                          onChanged: (value) {
                            setState(() {
                              _vastiValue = value;
                              populatelinkedShaakhaDropdown(value!, "Vasti");
                            });
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
                          onChanged: (value) {
                            setState(() {
                              _graamValue = value;
                              populatelinkedShaakhaDropdown(value!, "Graam");
                            });
                          },
                        ),
                      if (_shaakhaa != null && _shaakhaa!.length > 0)
                        DropdownButtonFormField(
                          decoration: InputDecoration(labelText: Statics.getLabel('LinkedShaakhaa')),
                          isExpanded: true,
                          value: _shaakhaaValue == "" ? null : _shaakhaaValue,
                          items: _shaakhaa!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                          onChanged: (value) {
                            setState(() {
                              _shaakhaaValue = value;
                            });
                          },
                        ),
                      if (_shaakhaa != null && _shaakhaa!.length > 0)
                        SizedBox(
                          height: 10,
                        ),
                      SizedBox(height: 10),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        enabled: false,
                        controller: _ownerCtrl,
                        decoration: InputDecoration(labelText: Statics.getLabel('EventOwner')),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 20,
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
                          textColor: Theme.of(context).primaryTextTheme.button!.color,
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
          inAsyncCall: _isfetingData),
    );
  }
}
