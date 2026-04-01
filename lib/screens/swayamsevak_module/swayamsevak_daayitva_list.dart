import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../providers/bals.dart';
import '../../providers/swayamsevak_provider.dart';
import '../edit_daayitva.dart';

//import '../screens/swayamsevak_daayitva_edit.dart';
import '../../widgets/daayitva_card.dart';
import '../../widgets/legend.dart';

class DaayitvaList extends StatefulWidget {
  var swId;
  var onSaveSwDetails;
  var viewType;

  DaayitvaList({Key? key, this.swId, this.onSaveSwDetails, this.viewType}) : super(key: key);

  @override
  _DaayitvaListState createState() => _DaayitvaListState();
}

class _DaayitvaListState extends State<DaayitvaList> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  bool _isfetingData = false;

  SwayamsevakDaayitvaPageBAL? swDaayitvaPage;

  var _maxDaayitvaCntrl = TextEditingController();
  var _fromYearCntrl = TextEditingController();
  var _toYearCntrl = TextEditingController();
  var _vistarakYearCountCntrl = TextEditingController();
  var _vistarakMonthCountCntrl = TextEditingController();
  var _vistarakWeekCountCntrl = TextEditingController();
  var _pracharakYearCountCntrl = TextEditingController();
  var _maxDaayitvaWhenPracharakCntrl = TextEditingController();

  bool? _wasPrachaarak = false;
  bool? _wasVistaarak = false;

  List<dynamic>? _daayitvaList;

  @override
  void initState() {
    super.initState();

    int swID = int.parse(widget.swId);
    if (swID > 0) {
      getSwDetails(widget.swId);
    } else {
      if (!mounted) return;
      setState(() {
        swDaayitvaPage = new SwayamsevakDaayitvaPageBAL(swID, "", null, null, false, null, null, null, false, null, "maxDaayitvaWhenPrachaarak");
        _daayitvaList = null;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _maxDaayitvaCntrl.dispose();
    _fromYearCntrl.dispose();
    _toYearCntrl.dispose();
    _vistarakYearCountCntrl.dispose();
    _vistarakMonthCountCntrl.dispose();
    _vistarakWeekCountCntrl.dispose();
    _pracharakYearCountCntrl.dispose();
    _maxDaayitvaWhenPracharakCntrl.dispose();
  }

  void getSwDetails(var theId) async {
    setState(() {
      _isfetingData = true;
    });
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      print("theId====> $theId");
      var data = await SwayamsevakProvider().getSwayamSevakByID(theId, "DaayitvaPage");
      var data2 = await SwayamsevakProvider().getSwayamSevakByID(widget.swId.toString(), "DaayitvaList");
      if (data != null) {
        if (!mounted) return;
        setState(() {
          _daayitvaList = data2;
          swDaayitvaPage = data;
          if (swDaayitvaPage != null) {
            _maxDaayitvaCntrl.text = swDaayitvaPage!.maxPastDaayitva ?? "";
            _fromYearCntrl.text = swDaayitvaPage!.maxPastDaayitvaFromYear == null ? "" : swDaayitvaPage!.maxPastDaayitvaFromYear.toString();
            _toYearCntrl.text = swDaayitvaPage!.maxPastDaayitvaToYear == null ? "" : swDaayitvaPage!.maxPastDaayitvaToYear.toString();
            _wasVistaarak = swDaayitvaPage!.hasBeenVistaarak == null ? false : swDaayitvaPage!.hasBeenVistaarak;

            _vistarakWeekCountCntrl.text = swDaayitvaPage!.vistaarakWeekCount == null ? "" : swDaayitvaPage!.vistaarakWeekCount.toString();

            _vistarakMonthCountCntrl.text = swDaayitvaPage!.vistaarakMonthCount == null ? "" : swDaayitvaPage!.vistaarakMonthCount.toString();

            _vistarakYearCountCntrl.text = swDaayitvaPage!.vistaarakYearCount == null ? "" : swDaayitvaPage!.vistaarakYearCount.toString();

            _wasPrachaarak = swDaayitvaPage!.hasBeenPrachaarak == null ? false : swDaayitvaPage!.hasBeenPrachaarak;

            _pracharakYearCountCntrl.text = swDaayitvaPage!.prachaarakYearCount == null ? "" : swDaayitvaPage!.prachaarakYearCount.toString();

            _maxDaayitvaWhenPracharakCntrl.text = swDaayitvaPage!.maxDaayitvaWhenPrachaarak == null ? "" : swDaayitvaPage!.maxDaayitvaWhenPrachaarak.toString();
          }
        });
      }
      setState(() {
        _isfetingData = false;
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

  saveSwDetails() async {
    var inputData = json.encode({
      "PageData": {
        "SwayamsevakID": int.parse(widget.swId),
        "MaxPastDaayitva": swDaayitvaPage!.maxPastDaayitva,
        "MaxPastDaayitvaFromYear": swDaayitvaPage!.maxPastDaayitvaFromYear,
        "MaxPastDaayitvaToYear": swDaayitvaPage!.maxPastDaayitvaToYear,
        "HasBeenVistaarak": _wasVistaarak,
        "VistaarakWeekCount": _wasVistaarak == true ? swDaayitvaPage!.vistaarakWeekCount : null,
        "VistaarakMonthCount": _wasVistaarak == true ? swDaayitvaPage!.vistaarakMonthCount : null,
        "VistaarakYearCount": _wasVistaarak == true ? swDaayitvaPage!.vistaarakYearCount : null,
        "HasBeenPrachaarak": _wasPrachaarak,
        "PrachaarakYearCount": _wasPrachaarak == true ? swDaayitvaPage!.prachaarakYearCount : null,
        "MaxDaayitvaWhenPrachaarak": _wasPrachaarak == true ? swDaayitvaPage!.maxDaayitvaWhenPrachaarak : null
      },
      "ModifiedBy": Statics.userDetails["userID"].toString()
    });
    var data = await SwayamsevakProvider().saveSwayamsevakDaayitvaPageData(inputData);
    setState(() {
      widget.swId = data;
      widget.onSaveSwDetails(widget.swId);
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            width: Statics.getDeviceSize(context).width,
            child: Column(
              children: [
                AbsorbPointer(
                  absorbing: widget.viewType == "ViewMenu" ? true : false,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        if (int.parse(widget.swId) > 0)
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
                                    Navigator.of(context)
                                        .pushNamed(EditDaayitva.routeName, arguments: Statics.ScreenArguments2(widget.swId, Statics.getLabel('EditMenu'), widget.onSaveSwDetails, null, null, "0"));
                                  },
                                  child: Text(Statics.getLabel('AddButton'), style: TextStyle(fontSize: 12)),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 8),
                        Text(
                          Statics.getLabel('daayitvaTip'),
                          style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _maxDaayitvaCntrl,
                          decoration: InputDecoration(labelText: Statics.getLabel('MaxDaayitva')),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty && _wasPrachaarak == false && _wasVistaarak == false) return (Statics.getLabel('MaxDaayitvaValidationMessage'));
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null && value.isNotEmpty)
                              swDaayitvaPage!.maxPastDaayitva = value;
                            else
                              swDaayitvaPage!.maxPastDaayitva = null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _fromYearCntrl,
                          decoration: InputDecoration(labelText: Statics.getLabel('FromYear')),
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          validator: (value) {
                            if (value!.isEmpty && _wasPrachaarak == false && _wasVistaarak == false) return (Statics.getLabel('FromYearValidationMessage'));
                            if (value.isNotEmpty && value.length < 4)
                              return (Statics.getLabel('ValidFromYearValidationMessage'));
                            else if (value.isNotEmpty) if ((int.parse(value) > int.parse(DateFormat('yyyy').format(DateTime.now())))) {
                              return (Statics.getLabel('ValidFromYearValidationMessage'));
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null && value.isNotEmpty)
                              swDaayitvaPage!.maxPastDaayitvaFromYear = int.parse(value);
                            else
                              swDaayitvaPage!.maxPastDaayitvaFromYear = null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _toYearCntrl,
                          decoration: InputDecoration(labelText: Statics.getLabel('ToYear')),
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          validator: (value) {
                            if (value!.isEmpty && _wasPrachaarak == false && _wasVistaarak == false) return (Statics.getLabel('ToYearValidationMessage'));
                            if (value.isNotEmpty && value.length < 4)
                              return (Statics.getLabel('ValidToYearValidationMessage'));
                            else if (value.isNotEmpty) if ((int.parse(value) < int.parse(_fromYearCntrl.text == "" ? "0" : _fromYearCntrl.text))) {
                              return (Statics.getLabel('ValidToYearValidationMessage'));
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null && value.isNotEmpty)
                              swDaayitvaPage!.maxPastDaayitvaToYear = int.parse(value);
                            else
                              swDaayitvaPage!.maxPastDaayitvaToYear = null;
                          },
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: Statics.getDeviceSize(context).width * 0.85,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(Statics.getLabel('HasBeenVistaarak'), style: TextStyle(fontSize: 15)),
                            checkColor: Colors.white,
                            activeColor: Colors.purple,
                            value: _wasVistaarak == null ? false : _wasVistaarak,
                            onChanged: (value) {
                              setState(() {
                                _wasVistaarak = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        if (_wasVistaarak == true)
                          Column(
                            children: [
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _vistarakWeekCountCntrl,
                                decoration: InputDecoration(labelText: Statics.getLabel('VistaarakWeekCount')),
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                                onSaved: (value) {
                                  if (value != null && value.isNotEmpty)
                                    swDaayitvaPage!.vistaarakWeekCount = int.parse(value);
                                  else
                                    swDaayitvaPage!.vistaarakWeekCount = null;
                                },
                                validator: (value) {
                                  if (_wasVistaarak == true && value!.isEmpty && _vistarakMonthCountCntrl.text.trim().isEmpty && _vistarakYearCountCntrl.text.trim().isEmpty)
                                    return (Statics.getLabel('PleaseEnterAtleastOneOfThree'));

                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _vistarakMonthCountCntrl,
                                decoration: InputDecoration(labelText: Statics.getLabel('VistaarakMonthCount')),
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                                onSaved: (value) {
                                  if (value != null && value.isNotEmpty)
                                    swDaayitvaPage!.vistaarakMonthCount = int.parse(value);
                                  else
                                    swDaayitvaPage!.vistaarakMonthCount = null;
                                },
                                validator: (value) {
                                  if (_wasVistaarak == true && value!.isEmpty && _vistarakWeekCountCntrl.text.trim().isEmpty && _vistarakYearCountCntrl.text.trim().isEmpty)
                                    return (Statics.getLabel('PleaseEnterAtleastOneOfThree'));

                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _vistarakYearCountCntrl,
                                decoration: InputDecoration(labelText: Statics.getLabel('VistaarakYearCount')),
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                                onSaved: (value) {
                                  if (value != null && value.isNotEmpty)
                                    swDaayitvaPage!.vistaarakYearCount = int.parse(value);
                                  else
                                    swDaayitvaPage!.vistaarakYearCount = null;
                                },
                                validator: (value) {
                                  if (_wasVistaarak == true && value!.isEmpty && _vistarakWeekCountCntrl.text.trim().isEmpty && _vistarakMonthCountCntrl.text.trim().isEmpty)
                                    return (Statics.getLabel('PleaseEnterAtleastOneOfThree'));

                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        SizedBox(
                          width: Statics.getDeviceSize(context).width * 0.85,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(Statics.getLabel('HasBeenPrachaarak'), style: TextStyle(fontSize: 15)),
                            checkColor: Colors.white,
                            activeColor: Colors.purple,
                            value: _wasPrachaarak == null ? false : _wasPrachaarak,
                            onChanged: (value) {
                              setState(() {
                                _wasPrachaarak = value;
                              });
                            },
                          ),
                        ),
                        if (_wasPrachaarak == true)
                          Column(
                            children: [
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _pracharakYearCountCntrl,
                                decoration: InputDecoration(labelText: Statics.getLabel('PrachaarakYearCount')),
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                                onSaved: (value) {
                                  if (value != null && value.isNotEmpty)
                                    swDaayitvaPage!.prachaarakYearCount = int.parse(value);
                                  else
                                    swDaayitvaPage!.prachaarakYearCount = null;
                                },
                                validator: (value) {
                                  if (_wasPrachaarak == true && value!.isEmpty) return (Statics.getLabel('PleaseEnterPrachaarakYearCount'));

                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _maxDaayitvaWhenPracharakCntrl,
                                decoration: InputDecoration(labelText: Statics.getLabel('MaxDaayitvaWhenPrachaarak')),
                                keyboardType: TextInputType.text,
                                onSaved: (value) {
                                  if (value != null && value.isNotEmpty)
                                    swDaayitvaPage!.maxDaayitvaWhenPrachaarak = value;
                                  else
                                    swDaayitvaPage!.maxDaayitvaWhenPrachaarak = null;
                                },
                                validator: (value) {
                                  if (_wasPrachaarak == true && value!.isEmpty) return (Statics.getLabel('PleaseEnterMaxDaayitvaWhenPracharak'));

                                  return null;
                                },
                              ),
                            ],
                          ),
                        SizedBox(height: 10),
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
                SizedBox(height: 20),
                Legend(legendString: "DaayitvaHistory", fontsize: 18),
                Container(
                  height: Statics.getDeviceSize(context).height * 0.5,
                  child: ListView.builder(
                    itemCount: _daayitvaList == null ? 1 : _daayitvaList!.length,
                    itemBuilder: (context, i) {
                      if (_daayitvaList == null || _daayitvaList!.length == 0) {
                        return Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
                      } else {
                        return ListTile(
                          title: DaayitvaCard(widget.swId, _daayitvaList![i], widget.viewType, widget.onSaveSwDetails, getSwDetails),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        inAsyncCall: _isfetingData);
  }
}
