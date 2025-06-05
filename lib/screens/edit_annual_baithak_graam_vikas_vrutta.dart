import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../providers/bals.dart';

import '../helpers/static_data.dart' as Statics;

class EditAnnualBaithakGraamVikasVrutta extends StatefulWidget {
  static const String routeName = '/edit-annual-baithak-graam-vikas-vrutta';
  var annualBaithakGraamVikasVruttaID;
  var geoUnitID;
  var geoUnitName;
  var annualBaithakTypeID;
  var annualBaithakTypeCode;
  var onSaveDetails;
  var viewType;
  EditAnnualBaithakGraamVikasVrutta(
      {Key? key,
      this.annualBaithakGraamVikasVruttaID,
      this.geoUnitID,
      this.geoUnitName,
      this.annualBaithakTypeID,
      this.annualBaithakTypeCode,
      this.onSaveDetails,
      this.viewType})
      : super(key: key);
  @override
  _EditAnnualBaithakGraamVikasVruttaState createState() => _EditAnnualBaithakGraamVikasVruttaState();
}

class _EditAnnualBaithakGraamVikasVruttaState extends State<EditAnnualBaithakGraamVikasVrutta> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var _isLoading = false;

  bool _isFetchingData = false;

  AnnualBaithakGraamVikasBAL? graamVikas;

  bool _isUdayGraam = false;
  bool _isPrabhaatGraam = false;
  String _radioSelection = '';

  @override
  void initState() {
    super.initState();
    int abGraamVikasVruttaID = (widget.annualBaithakGraamVikasVruttaID == null ? 0 : (widget.annualBaithakGraamVikasVruttaID as int));
    int geoUnitID = (widget.geoUnitID as int);
    String geoUnitName = widget.geoUnitName.toString();
    int baithakTypeID = (widget.annualBaithakTypeID as int);
    String baithakTypeCode = widget.annualBaithakTypeCode.toString();
    if (geoUnitID != 0) populateAnnualBaithakGraamVikas(baithakTypeID, geoUnitID);
  }

  void populateAnnualBaithakGraamVikas(int btID, int guID) async {
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
      retVal = (await Statics.getAnnualBaithakGraamVikasForApp(strInput))[0];
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    }

    setState(() {
      graamVikas = AnnualBaithakGraamVikasBAL.fromMap(retVal);
      _isUdayGraam = graamVikas!.isUdayGraam == true ? true : false;
      _isPrabhaatGraam = graamVikas!.isPrabhaatGraam == true ? true : false;
      _radioSelection = graamVikas!.isUdayGraam == null || graamVikas!.isUdayGraam == false
          ? (graamVikas!.isPrabhaatGraam == null || graamVikas!.isPrabhaatGraam == false ? '' : 'prabhaatGraam')
          : 'udayGraam';

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
        await saveAnnualBaithakGraamVikas(context);
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

  saveAnnualBaithakGraamVikas(BuildContext context) async {
    var inputData = json.encode({
      "AppUserID": Statics.userDetails["userID"],
      "AnnualBaithakGraamVikasVruttaID":
          (widget.annualBaithakGraamVikasVruttaID == null ? 0 : int.parse(widget.annualBaithakGraamVikasVruttaID.toString())),
      "GeoUnitID": (widget.geoUnitID == null ? 0 : int.parse(widget.geoUnitID.toString())),
      "AnnualBaithakTypeID": (widget.annualBaithakTypeID == null ? 0 : int.parse(widget.annualBaithakTypeID.toString())),
      "IsUdayGraam": _isUdayGraam,
      "IsPrabhaatGraam": _isPrabhaatGraam,
      "ModifiedBy": Statics.userDetails["userID"],
    });
    var oID = await Statics.saveAnnualBaithakGraamVikasForApp(inputData);
    setState(() {
      widget.annualBaithakGraamVikasVruttaID = oID;
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
          Statics.getLabel('annualBaithakGraamVikasVruttaTitle'),
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
                  Text(graamVikas == null ? '' : (graamVikas!.geoUnitName!)),
                  Text(graamVikas == null ? '' : graamVikas!.annualBaithakTypeCode!),
                  SizedBox(
                    height: 10,
                  ),
                  RadioListTile(
                    title: Text(Statics.getLabel("isUdayGraam"), style: TextStyle(fontSize: 15)),
                    activeColor: Colors.purple,
                    value: 'udayGraam',
                    groupValue: _radioSelection,
                    onChanged: (value) {
                      setState(() {
                        _isUdayGraam = true;
                        _isPrabhaatGraam = false;
                        _radioSelection = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text(Statics.getLabel("isPrabhaatGraam"), style: TextStyle(fontSize: 15)),
                    activeColor: Colors.purple,
                    value: 'prabhaatGraam',
                    groupValue: _radioSelection,
                    onChanged: (value) {
                      setState(() {
                        _isUdayGraam = false;
                        _isPrabhaatGraam = true;
                        _radioSelection = value.toString();
                      });
                    },
                  ),
                  Text(
                    Statics.getLabel('Cancel'),
                    style: TextStyle(fontSize: 15),
                  ),
                  IconButton(
                      alignment: Alignment.topLeft,
                      color: Colors.purple,
                      onPressed: () {
                        setState(() {
                          _isUdayGraam = false;
                          _isPrabhaatGraam = false;
                          _radioSelection = '';
                        });
                      },
                      icon: Icon(Icons.cancel)),
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
