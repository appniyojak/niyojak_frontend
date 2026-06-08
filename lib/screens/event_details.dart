import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../helpers/static_data.dart' as Statics;
import '../providers/bals.dart';
import '../utils/globals.dart';
import '../utils/stable_geounit_class.dart';
import '../widgets/legend.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
    int? eventID = widget.eventId;
    if (eventID! > 0) {
      getEventDetails(widget.eventId);
    } else {
      if (!mounted) return;
      setState(() {
        event = new EventMasterBAL(null, 1, null, "", "", "", "", "", "", null, Statics.userDetails["UserID"], Statics.userDetails["FullName"], "", "", "");

        _ownerCtrl.text = Statics.userDetails["FullName"];
        _ownerID = Statics.userDetails["userID"];
      });
    }
  }

  Future<void> initData() async {
    final dm = await MyAppGlobals.getLevelLDB();

    final controller = context.read<GeoHierarchyController>();

    await controller.initialize(dm);

    populateDropdown();
    setState(() {});
  }

  void populateDropdown() async {
    var data = await Statics.getStaticLDB("EventType");
    if (!mounted) return;
    setState(() {
      _eventType = data;
    });
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
      event = data;
      if (event != null) {
        setState(() {
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

          _ownerID = event!.ownerSwayamsevakID.toString();
          _ownerCtrl.text = event!.ownerSwayamsevakName.toString();
        });
        var _geoUnitID = event!.geoUnitID == null ? null : event!.geoUnitID.toString();

        if (_geoUnitID != null) {
          final controller = context.read<GeoHierarchyController>();

          final trail = await controller.getTrailFromGeoUnitId(_geoUnitID.toString());
        }
        setState(() {});
      }
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
      "GeoUnitID": context.read<GeoHierarchyController>().deepestSelectedGeoUnitId,
      "FromDateStr": (_fromDate != null ? DateFormat('dd-MM-yyyy').format(_fromDate!) : null),
      "ToDateStr": (_toDate != null ? DateFormat('dd-MM-yyyy').format(_toDate!) : null),
      "FromTimeStr": (_fromTime != null
          ? DateFormat("hh:mm").format(new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " + _fromTime!.hour.toString() + ":" + _fromTime!.minute.toString())) +
              (_fromTime!.period == DayPeriod.am ? " AM" : " PM")
          : null),
      "ToTimeStr": (_toTime != null
          ? DateFormat("hh:mm").format(new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " + _toTime!.hour.toString() + ":" + _toTime!.minute.toString())) +
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
                      if (_eventType != null)
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
                      dropdownSection(),

                      ///
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
          inAsyncCall: _isfetingData),
    );
  }

  Widget dropdownSection() {
    return Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
      return Column(
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
                      setState(() {});
                      ctrl.loadHierarchyForUser();
                    },
                    child: Text(
                      Statics.getLabel('clear'),
                      style: TextStyle(fontSize: 12),
                    )),
              ),
            ],
          ),

          // if (ctrl.hasItems(GeoLevel.vibhaag))
          GeoDropdownWidget(
            level: GeoLevel.Vibhaag,
            title: 'Vibhaag',
            controller: ctrl,
          ),

          if (ctrl.hasItems(GeoLevel.Bhaag))
            GeoDropdownWidget(
              level: GeoLevel.Bhaag,
              title: 'Bhaag',
              controller: ctrl,
            ),

          if (ctrl.hasItems(GeoLevel.Nagar))
            GeoDropdownWidget(
              level: GeoLevel.Nagar,
              title: 'Nagar',
              controller: ctrl,
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
            ),

          if (ctrl.hasItems(GeoLevel.Graam))
            GeoDropdownWidget(
              level: GeoLevel.Graam,
              title: 'Graam',
              controller: ctrl,
            ),

          if (ctrl.hasItems(GeoLevel.Vasti))
            GeoDropdownWidget(
              level: GeoLevel.Vasti,
              title: 'Vasti',
              controller: ctrl,
            ),

          if (ctrl.hasItems(GeoLevel.Shaakhaa))
            GeoDropdownWidget(
              level: GeoLevel.Shaakhaa,
              title: 'Shaakhaa',
              controller: ctrl,
            ),
        ],
      );
    });
  }
}
