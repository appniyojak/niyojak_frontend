import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../providers/bals.dart';

import '../helpers/static_data.dart' as Statics;

class EditAnnualBaithakMukhyaMaargVrutta extends StatefulWidget {
  static const String routeName = '/edit-annual-baithak-mukhya-maarg-vrutta';
  var annualBaithakMukhyaMaargVruttaID;
  var geoUnitID;
  var geoUnitName;
  var annualBaithakTypeID;
  var annualBaithakTypeCode;
  var onSaveDetails;
  var viewType;
  EditAnnualBaithakMukhyaMaargVrutta(
      {Key? key,
      this.annualBaithakMukhyaMaargVruttaID,
      this.geoUnitID,
      this.geoUnitName,
      this.annualBaithakTypeID,
      this.annualBaithakTypeCode,
      this.onSaveDetails,
      this.viewType})
      : super(key: key);
  @override
  _EditAnnualBaithakMukhyaMaargVruttaState createState() => _EditAnnualBaithakMukhyaMaargVruttaState();
}

class _EditAnnualBaithakMukhyaMaargVruttaState extends State<EditAnnualBaithakMukhyaMaargVrutta> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var _isLoading = false;

  bool _isFetchingData = false;

  AnnualBaithakMukhyaMaargBAL? mukhyaMaarg;

  var _shaakhaaCountCtrl = TextEditingController();
  var _saaptaahikCountCtrl = TextEditingController();
  var _maasikCountCtrl = TextEditingController();
  var _graamPramukhNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    int abMukhyaMaargVruttaID = (widget.annualBaithakMukhyaMaargVruttaID == null ? 0 : (widget.annualBaithakMukhyaMaargVruttaID as int));
    int geoUnitID = (widget.geoUnitID as int);
    String geoUnitName = widget.geoUnitName.toString();
    int baithakTypeID = (widget.annualBaithakTypeID as int);
    String baithakTypeCode = widget.annualBaithakTypeCode.toString();
    populateAnnualBaithakMukhyaMaarg(baithakTypeID, geoUnitID);
  }

  @override
  void dispose() {
    super.dispose();
    _shaakhaaCountCtrl.dispose();
    _saaptaahikCountCtrl.dispose();
    _maasikCountCtrl.dispose();
    _graamPramukhNameCtrl.dispose();
  }

  void populateAnnualBaithakMukhyaMaarg(int btID, int guID) async {
    setState(() {
      _isFetchingData = true;
    });
    dynamic retVal;
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
        "ShaharID": null,
        "NagarID": null,
        "AnnualBaithakTypeID": btID,
        "GeoUnitID": guID,
      });
      retVal = (await Statics.getAnnualBaithakMukhyaMaargForApp(strInput))[0];
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    }

    setState(() {
      mukhyaMaarg = AnnualBaithakMukhyaMaargBAL.fromMap(retVal);
      _shaakhaaCountCtrl.text = (mukhyaMaarg!.shaakhaaCount == null ? '' : mukhyaMaarg!.shaakhaaCount.toString());
      _saaptaahikCountCtrl.text = (mukhyaMaarg!.saaptaahikCount == null ? '' : mukhyaMaarg!.saaptaahikCount.toString());
      _maasikCountCtrl.text = (mukhyaMaarg!.maasikCount == null ? '' : mukhyaMaarg!.maasikCount.toString());
      _graamPramukhNameCtrl.text = (mukhyaMaarg!.graamPramukhName == null ? '' : mukhyaMaarg!.graamPramukhName.toString());

      _isFetchingData = false;
    });
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
        await saveAnnualBaithakMukhyaMaarg(context);
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

  saveAnnualBaithakMukhyaMaarg(BuildContext context) async {
    var inputData = json.encode({
      "AppUserID": Statics.userDetails["userID"],
      "AnnualBaithakMukhyaMaargVruttaID":
          (widget.annualBaithakMukhyaMaargVruttaID == null ? 0 : int.parse(widget.annualBaithakMukhyaMaargVruttaID.toString())),
      "GeoUnitID": (widget.geoUnitID == null ? 0 : int.parse(widget.geoUnitID.toString())),
      "AnnualBaithakTypeID": (widget.annualBaithakTypeID == null ? 0 : int.parse(widget.annualBaithakTypeID.toString())),
      "ShaakhaaCount": _shaakhaaCountCtrl.text.trim() == '' ? null : int.parse(_shaakhaaCountCtrl.text),
      "SaaptaahikCount": _saaptaahikCountCtrl.text.trim() == '' ? null : int.parse(_saaptaahikCountCtrl.text),
      "MaasikCount": _maasikCountCtrl.text.trim() == '' ? null : int.parse(_maasikCountCtrl.text),
      "GraamPramukhName": _graamPramukhNameCtrl.text.trim() == '' ? null : _graamPramukhNameCtrl.text,
      "ModifiedBy": Statics.userDetails["userID"]
    });
    var oID = await Statics.saveAnnualBaithakMukhyaMaargForApp(inputData);
    setState(() {
      widget.annualBaithakMukhyaMaargVruttaID = oID;
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
          Statics.getLabel('annualBaithakMukhyaMaargVruttaTitle'),
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
                  Text(mukhyaMaarg == null ? '' : (mukhyaMaarg!.geoUnitName!)),
                  Text(mukhyaMaarg == null ? '' : mukhyaMaarg!.annualBaithakTypeCode!),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _shaakhaaCountCtrl,
                    decoration: InputDecoration(labelText: Statics.getLabel('shaakhaaCount')),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
                      return null;
                    },
                    onSaved: (value) {
                      mukhyaMaarg!.shaakhaaCount = value == "" ? null : int.parse(value!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _saaptaahikCountCtrl,
                    decoration: InputDecoration(labelText: Statics.getLabel('saaptaahikCount')),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
                      return null;
                    },
                    onSaved: (value) {
                      mukhyaMaarg!.saaptaahikCount = value == "" ? null : int.parse(value!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _maasikCountCtrl,
                    decoration: InputDecoration(labelText: Statics.getLabel('mandaliCount')),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
                      return null;
                    },
                    onSaved: (value) {
                      mukhyaMaarg!.maasikCount = value == "" ? null : int.parse(value!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _graamPramukhNameCtrl,
                    decoration: InputDecoration(labelText: Statics.getLabel('graamPramukhName')),
                    keyboardType: TextInputType.text,
                    onSaved: (value) {
                      mukhyaMaarg!.graamPramukhName = value == "" ? null : value;
                    },
                  ),
                  SizedBox(
                    height: 10,
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
