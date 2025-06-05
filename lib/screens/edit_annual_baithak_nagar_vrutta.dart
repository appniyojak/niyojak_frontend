import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../providers/bals.dart';

import '../helpers/static_data.dart' as Statics;

class EditAnnualBaithakNagarVrutta extends StatefulWidget {
  static const String routeName = '/edit-annual-baithak-nagar-vrutta';
  var annualBaithakNagarVruttaID;
  var geoUnitID;
  var geoUnitName;
  var annualBaithakTypeID;
  var annualBaithakTypeCode;
  var onSaveDetails;
  var viewType;
  EditAnnualBaithakNagarVrutta(
      {Key? key,
      this.annualBaithakNagarVruttaID,
      this.geoUnitID,
      this.geoUnitName,
      this.annualBaithakTypeID,
      this.annualBaithakTypeCode,
      this.onSaveDetails,
      this.viewType})
      : super(key: key);
  @override
  _EditAnnualBaithakNagarVruttaState createState() => _EditAnnualBaithakNagarVruttaState();
}

class _EditAnnualBaithakNagarVruttaState extends State<EditAnnualBaithakNagarVrutta> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var _isLoading = false;

  bool _isFetchingData = false;

  AnnualBaithakNagarVruttaBAL? nagarVrutta;

  var _sewaVastiCountCtrl = TextEditingController();
  var _shaakhaaYuktaSewaVastiCountCntrl = TextEditingController();
  var _sewaKaaryaYuktaSewaVastiCountCtrl = TextEditingController();
  bool _isSankalpaPoorna = false;
  bool _isNiyojanDone = false;
  int? _baithakTypeID;

  @override
  void initState() {
    super.initState();
    int abNagarVruttaID = (widget.annualBaithakNagarVruttaID == null ? 0 : (widget.annualBaithakNagarVruttaID as int));
    int geoUnitID = (widget.geoUnitID as int);
    String geoUnitName = widget.geoUnitName.toString();
    int baithakTypeID = (widget.annualBaithakTypeID as int);
    String baithakTypeCode = widget.annualBaithakTypeCode.toString();
    populateAnnualBaithakNagarVrutta(baithakTypeID, geoUnitID);
  }

  @override
  void dispose() {
    super.dispose();
    _sewaVastiCountCtrl.dispose();
    _shaakhaaYuktaSewaVastiCountCntrl.dispose();
    _sewaKaaryaYuktaSewaVastiCountCtrl.dispose();
  }

  void populateAnnualBaithakNagarVrutta(int btID, int nagarID) async {
    setState(() {
      _isFetchingData = true;
    });
    dynamic retVal;
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
        "NagarID": nagarID,
        "AnnualBaithakTypeID": btID,
      });
      retVal = await Statics.getAnnualBaithakNagarVruttaForApp(strInput);

      setState(() {
        nagarVrutta = AnnualBaithakNagarVruttaBAL.fromMap(retVal);
        _baithakTypeID = btID;
        _sewaVastiCountCtrl.text = (nagarVrutta!.sewaVastiCount == null ? '' : nagarVrutta!.sewaVastiCount.toString());
        _shaakhaaYuktaSewaVastiCountCntrl.text =
            (nagarVrutta!.shaakhaaYuktaSewaVastiCount == null ? '' : nagarVrutta!.shaakhaaYuktaSewaVastiCount.toString());
        _sewaKaaryaYuktaSewaVastiCountCtrl.text =
            (nagarVrutta!.sewaKaaryaYuktaSewaVastiCount == null ? '' : nagarVrutta!.sewaKaaryaYuktaSewaVastiCount.toString());

        _isSankalpaPoorna = nagarVrutta!.isSankalpaPoorna == true ? true : false;
        _isNiyojanDone = nagarVrutta!.isNiyojanDone == true ? true : false;

        _isFetchingData = false;
      });
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    }
  }

  Future<void> _submit(BuildContext context) async {
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
        await saveAnnualBaithakNagarVrutta(context);
      }
    } on Exception catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    } catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  saveAnnualBaithakNagarVrutta(BuildContext context) async {
    var inputData = json.encode({
      "AppUserID": Statics.userDetails["userID"],
      "AnnualBaithakNagarVruttaID": (widget.annualBaithakNagarVruttaID == null ? 0 : int.parse(widget.annualBaithakNagarVruttaID.toString())),
      "GeoUnitID": (widget.geoUnitID == null ? 0 : int.parse(widget.geoUnitID.toString())),
      "AnnualBaithakTypeID": (widget.annualBaithakTypeID == null ? 0 : int.parse(widget.annualBaithakTypeID.toString())),
      "SewaVastiCount": _sewaVastiCountCtrl.text.trim() == '' ? null : int.parse(_sewaVastiCountCtrl.text),
      "ShaakhaaYuktaSewaVastiCount": _shaakhaaYuktaSewaVastiCountCntrl.text.trim() == '' ? null : int.parse(_shaakhaaYuktaSewaVastiCountCntrl.text),
      "SewaKaaryaYuktaSewaVastiCount":
          _sewaKaaryaYuktaSewaVastiCountCtrl.text.trim() == '' ? null : int.parse(_sewaKaaryaYuktaSewaVastiCountCtrl.text),
      "IsSankalpaPoorna": _isSankalpaPoorna,
      "IsNiyojanDone": _isNiyojanDone,
      "ModifiedBy": Statics.userDetails["userID"]
    });
    var oID = await Statics.saveAnnualBaithakNagarVruttaForApp(inputData);
    setState(() {
      widget.annualBaithakNagarVruttaID = oID;
      widget.onSaveDetails();
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Statics.getLabel('annualBaithakNagarVruttaTitle'),
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isFetchingData,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            width: Statics.getDeviceSize(context).width,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(nagarVrutta == null ? '' : nagarVrutta!.geoUnitName!),
                  if (_baithakTypeID == Statics.abPratinidhiSabhaa)
                    Column(
                      children: <Widget>[
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _sewaVastiCountCtrl,
                          decoration: InputDecoration(labelText: Statics.getLabel('sewaVastiCount')),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
                            return null;
                          },
                          onSaved: (value) {
                            nagarVrutta!.sewaVastiCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _shaakhaaYuktaSewaVastiCountCntrl,
                          decoration: InputDecoration(labelText: Statics.getLabel('shaakhaaYuktaSewaVastiCount')),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
                            return null;
                          },
                          onSaved: (value) {
                            nagarVrutta!.shaakhaaYuktaSewaVastiCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _sewaKaaryaYuktaSewaVastiCountCtrl,
                          decoration: InputDecoration(labelText: Statics.getLabel('sewaKaaryaYuktaSewaVastiCount')),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
                            return null;
                          },
                          onSaved: (value) {
                            nagarVrutta!.sewaKaaryaYuktaSewaVastiCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  if (_baithakTypeID != Statics.abPratinidhiSabhaa)
                    Column(
                      children: <Widget>[
                        SizedBox(
                          width: Statics.getDeviceSize(context).width * 0.8,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            controlAffinity: ListTileControlAffinity.trailing,
                            title: Text(Statics.getLabel("isSankalpaPoorna"), style: TextStyle(fontSize: 15)),
                            checkColor: Colors.white,
                            activeColor: Colors.purple,
                            value: _isSankalpaPoorna,
                            onChanged: (value) {
                              setState(() {
                                _isSankalpaPoorna = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: Statics.getDeviceSize(context).width * 0.8,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            controlAffinity: ListTileControlAffinity.trailing,
                            title: Text(Statics.getLabel("isVaarshikNiyojanDone"), style: TextStyle(fontSize: 15)),
                            checkColor: Colors.white,
                            activeColor: Colors.purple,
                            value: _isNiyojanDone,
                            onChanged: (value) {
                              setState(() {
                                _isNiyojanDone = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else if (widget.viewType == "ViewOnly")
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
                      onPressed: () {
                        _submit(context);
                      },
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
    );
  }
}
