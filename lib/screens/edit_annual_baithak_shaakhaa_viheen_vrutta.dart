import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../providers/bals.dart';

import '../helpers/static_data.dart' as Statics;

class EditAnnualBaithakShaakhaaViheenVrutta extends StatefulWidget {
  static const String routeName = '/edit-annual-baithak-shaakhaa-viheen-vrutta';
  var annualBaithakShaakhaaViheenVruttaID;
  var geoUnitID;
  var geoUnitName;
  var annualBaithakTypeID;
  var annualBaithakTypeCode;
  var onSaveDetails;
  var viewType;

  EditAnnualBaithakShaakhaaViheenVrutta(
      {Key? key, this.annualBaithakShaakhaaViheenVruttaID, this.geoUnitID, this.geoUnitName, this.annualBaithakTypeID, this.annualBaithakTypeCode, this.onSaveDetails, this.viewType})
      : super(key: key);

  @override
  _EditAnnualBaithakShaakhaaViheenVruttaState createState() => _EditAnnualBaithakShaakhaaViheenVruttaState();
}

class _EditAnnualBaithakShaakhaaViheenVruttaState extends State<EditAnnualBaithakShaakhaaViheenVrutta> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var _isLoading = false;

  bool _isFetchingData = false;
  String _radioSelection = '';

  AnnualBaithakShaakhaaViheenBAL? shaakhaaViheen;

  var _praathamikCountCtrl = TextEditingController();
  var _praathamikSakriyaCountCtrl = TextEditingController();
  var _prathamGeneralCountCtrl = TextEditingController();
  var _prathamGeneralSakriyaCountCtrl = TextEditingController();
  var _prathamSpecialCountCtrl = TextEditingController();
  var _prathamSpecialSakriyaCountCtrl = TextEditingController();
  var _dwitiyaGeneralCountCtrl = TextEditingController();
  var _dwitiyaGeneralSakriyaCountCtrl = TextEditingController();
  var _dwitiyaSpecialCountCtrl = TextEditingController();
  var _dwitiyaSpecialSakriyaCountCtrl = TextEditingController();
  var _trutiyaGeneralCountCtrl = TextEditingController();
  var _trutiyaGeneralSakriyaCountCtrl = TextEditingController();
  var _trutiyaSpecialCountCtrl = TextEditingController();
  var _trutiyaSpecialSakriyaCountCtrl = TextEditingController();
  var _vaartaapatraCountCtrl = TextEditingController();
  bool _isShaakhaaInPast = false;
  bool _isSaaptaahikInPast = false;
  bool _isMandaliInPast = false;

  @override
  void initState() {
    super.initState();
    int abShaakhaaViheenVruttaID = (widget.annualBaithakShaakhaaViheenVruttaID == null ? 0 : (widget.annualBaithakShaakhaaViheenVruttaID as int));
    int geoUnitID = (widget.geoUnitID as int);
    String geoUnitName = widget.geoUnitName.toString();
    int baithakTypeID = (widget.annualBaithakTypeID as int);
    String baithakTypeCode = widget.annualBaithakTypeCode.toString();
    populateAnnualBaithakShaakhaaViheen(baithakTypeID, geoUnitID);
  }

  @override
  void dispose() {
    super.dispose();
    _praathamikCountCtrl.dispose();
    _praathamikSakriyaCountCtrl.dispose();
    _prathamGeneralCountCtrl.dispose();
    _prathamGeneralSakriyaCountCtrl.dispose();
    _prathamSpecialCountCtrl.dispose();
    _prathamSpecialSakriyaCountCtrl.dispose();
    _dwitiyaGeneralCountCtrl.dispose();
    _dwitiyaGeneralSakriyaCountCtrl.dispose();
    _dwitiyaSpecialCountCtrl.dispose();
    _dwitiyaSpecialSakriyaCountCtrl.dispose();
    _trutiyaGeneralCountCtrl.dispose();
    _trutiyaGeneralSakriyaCountCtrl.dispose();
    _trutiyaSpecialCountCtrl.dispose();
    _trutiyaSpecialSakriyaCountCtrl.dispose();
    _vaartaapatraCountCtrl.dispose();
  }

  void populateAnnualBaithakShaakhaaViheen(int btID, int guID) async {
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
      retVal = (await Statics.getAnnualBaithakShaakhaaViheenForApp(strInput))[0];
      //return retVal['ListShaakhaaVrutta'];
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      //return null;
    }

    setState(() {
      shaakhaaViheen = AnnualBaithakShaakhaaViheenBAL.fromMap(retVal);
      _isShaakhaaInPast = shaakhaaViheen!.isShaakhaaInPast == true ? true : false;
      _isSaaptaahikInPast = shaakhaaViheen!.isSaaptaahikInPast == true ? true : false;
      _isMandaliInPast = shaakhaaViheen!.isMandaliInPast == true ? true : false;
      _praathamikCountCtrl.text = (shaakhaaViheen!.praathamikCount == null ? '' : shaakhaaViheen!.praathamikCount.toString());
      _praathamikSakriyaCountCtrl.text = (shaakhaaViheen!.praathamikSakriyaCount == null ? '' : shaakhaaViheen!.praathamikSakriyaCount.toString());
      _prathamGeneralCountCtrl.text = (shaakhaaViheen!.prathamGeneralCount == null ? '' : shaakhaaViheen!.prathamGeneralCount.toString());
      _prathamGeneralSakriyaCountCtrl.text = (shaakhaaViheen!.prathamGeneralSakriyaCount == null ? '' : shaakhaaViheen!.prathamGeneralSakriyaCount.toString());
      _prathamSpecialCountCtrl.text = (shaakhaaViheen!.prathamSpecialCount == null ? '' : shaakhaaViheen!.prathamSpecialCount.toString());
      _prathamSpecialSakriyaCountCtrl.text = (shaakhaaViheen!.prathamSpecialSakriyaCount == null ? '' : shaakhaaViheen!.prathamSpecialSakriyaCount.toString());
      _dwitiyaGeneralCountCtrl.text = (shaakhaaViheen!.dwitiyaGeneralCount == null ? '' : shaakhaaViheen!.dwitiyaGeneralCount.toString());
      _dwitiyaGeneralSakriyaCountCtrl.text = (shaakhaaViheen!.dwitiyaGeneralSakriyaCount == null ? '' : shaakhaaViheen!.dwitiyaGeneralSakriyaCount.toString());
      _dwitiyaSpecialCountCtrl.text = (shaakhaaViheen!.dwitiyaSpecialCount == null ? '' : shaakhaaViheen!.dwitiyaSpecialCount.toString());
      _dwitiyaSpecialSakriyaCountCtrl.text = (shaakhaaViheen!.dwitiyaSpecialSakriyaCount == null ? '' : shaakhaaViheen!.dwitiyaSpecialSakriyaCount.toString());
      _trutiyaGeneralCountCtrl.text = (shaakhaaViheen!.trutiyaGeneralCount == null ? '' : shaakhaaViheen!.trutiyaGeneralCount.toString());
      _trutiyaGeneralSakriyaCountCtrl.text = (shaakhaaViheen!.trutiyaGeneralSakriyaCount == null ? '' : shaakhaaViheen!.trutiyaGeneralSakriyaCount.toString());
      _trutiyaSpecialCountCtrl.text = (shaakhaaViheen!.trutiyaSpecialCount == null ? '' : shaakhaaViheen!.trutiyaSpecialCount.toString());
      _trutiyaSpecialSakriyaCountCtrl.text = (shaakhaaViheen!.trutiyaSpecialSakriyaCount == null ? '' : shaakhaaViheen!.trutiyaSpecialSakriyaCount.toString());
      _vaartaapatraCountCtrl.text = (shaakhaaViheen!.vaartaapatraCount == null ? '' : shaakhaaViheen!.vaartaapatraCount.toString());

      if (shaakhaaViheen!.isShaakhaaInPast != null && shaakhaaViheen!.isShaakhaaInPast == true)
        _radioSelection = 'Shaakhaa';
      else if (shaakhaaViheen!.isSaaptaahikInPast != null && shaakhaaViheen!.isSaaptaahikInPast == true)
        _radioSelection = 'Saaptaahik';
      else if (shaakhaaViheen!.isMandaliInPast != null && shaakhaaViheen!.isMandaliInPast == true)
        _radioSelection = 'Mandali';
      else
        _radioSelection = '';

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
        await saveAnnualBaithakShaakhaaViheen(context);
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

  saveAnnualBaithakShaakhaaViheen(BuildContext context) async {
    var inputData = json.encode({
      "AppUserID": Statics.userDetails["userID"],
      "AnnualBaithakShaakhaaViheenVruttaID": (widget.annualBaithakShaakhaaViheenVruttaID == null ? 0 : int.parse(widget.annualBaithakShaakhaaViheenVruttaID.toString())),
      "GeoUnitID": (widget.geoUnitID == null ? 0 : int.parse(widget.geoUnitID.toString())),
      "AnnualBaithakTypeID": (widget.annualBaithakTypeID == null ? 0 : int.parse(widget.annualBaithakTypeID.toString())),
      "IsShaakhaaInPast": _isShaakhaaInPast,
      "IsSaaptaahikInPast": _isSaaptaahikInPast,
      "IsMandaliInPast": _isMandaliInPast,
      "PraathamikCount": _praathamikCountCtrl.text.trim() == '' ? null : int.parse(_praathamikCountCtrl.text),
      "PraathamikSakriyaCount": _praathamikSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_praathamikSakriyaCountCtrl.text),
      "PrathamGeneralCount": _prathamGeneralCountCtrl.text.trim() == '' ? null : int.parse(_prathamGeneralCountCtrl.text),
      "PrathamGeneralSakriyaCount": _prathamGeneralSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_prathamGeneralSakriyaCountCtrl.text),
      "PrathamSpecialCount": _prathamSpecialCountCtrl.text.trim() == '' ? null : int.parse(_prathamSpecialCountCtrl.text),
      "PrathamSpecialSakriyaCount": _prathamSpecialSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_prathamSpecialSakriyaCountCtrl.text),
      "DwitiyaGeneralCount": _dwitiyaGeneralCountCtrl.text.trim() == '' ? null : int.parse(_dwitiyaGeneralCountCtrl.text),
      "DwitiyaGeneralSakriyaCount": _dwitiyaGeneralSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_dwitiyaGeneralSakriyaCountCtrl.text),
      "DwitiyaSpecialCount": _dwitiyaSpecialCountCtrl.text.trim() == '' ? null : int.parse(_dwitiyaSpecialCountCtrl.text),
      "DwitiyaSpecialSakriyaCount": _dwitiyaSpecialSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_dwitiyaSpecialSakriyaCountCtrl.text),
      "TrutiyaGeneralCount": _trutiyaGeneralCountCtrl.text.trim() == '' ? null : int.parse(_trutiyaGeneralCountCtrl.text),
      "TrutiyaGeneralSakriyaCount": _trutiyaGeneralSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_trutiyaGeneralSakriyaCountCtrl.text),
      "TrutiyaSpecialCount": _trutiyaSpecialCountCtrl.text.trim() == '' ? null : int.parse(_trutiyaSpecialCountCtrl.text),
      "TrutiyaSpecialSakriyaCount": _trutiyaSpecialSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_trutiyaSpecialSakriyaCountCtrl.text),
      "VaartaapatraCount": _vaartaapatraCountCtrl.text.trim() == '' ? null : int.parse(_vaartaapatraCountCtrl.text),
      "ModifiedBy": Statics.userDetails["userID"]
    });
    var oID = await Statics.saveAnnualBaithakShaakhaaViheenForApp(inputData);
    setState(() {
      widget.annualBaithakShaakhaaViheenVruttaID = oID;
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
          Statics.getLabel('annualBaithakShaakhaaViheenVruttaTitle'),
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
                  Text(shaakhaaViheen == null ? '' : (shaakhaaViheen!.geoUnitName!)),
                  Text(shaakhaaViheen == null ? '' : shaakhaaViheen!.annualBaithakTypeCode!),

                  if (shaakhaaViheen != null && shaakhaaViheen!.annualBaithakTypeID == Statics.abPratinidhiSabhaa)
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(Statics.getLabel('isShaakhaaInPast'), style: TextStyle(fontSize: 15)),
                        RadioListTile(
                          title: Text(Statics.getLabel('Shaakhaa'), style: TextStyle(fontSize: 15)),
                          activeColor: Colors.purple,
                          value: 'Shaakhaa',
                          groupValue: _radioSelection,
                          onChanged: (value) {
                            setState(() {
                              _isShaakhaaInPast = true;
                              _isSaaptaahikInPast = false;
                              _isMandaliInPast = false;
                              _radioSelection = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text(Statics.getLabel('SaaptaahikMilan'), style: TextStyle(fontSize: 15)),
                          activeColor: Colors.purple,
                          value: 'Saaptaahik',
                          groupValue: _radioSelection,
                          onChanged: (value) {
                            setState(() {
                              _isShaakhaaInPast = false;
                              _isSaaptaahikInPast = true;
                              _isMandaliInPast = false;
                              _radioSelection = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text(Statics.getLabel('Mandali'), style: TextStyle(fontSize: 15)),
                          activeColor: Colors.purple,
                          value: 'Mandali',
                          groupValue: _radioSelection,
                          onChanged: (value) {
                            setState(() {
                              _isShaakhaaInPast = false;
                              _isSaaptaahikInPast = false;
                              _isMandaliInPast = true;
                              _radioSelection = value.toString();
                            });
                          },
                        ),
                      ],
                    ),

                  // SizedBox(
                  //   height: 10,
                  // ),
                  // TextFormField(
                  //   textInputAction: TextInputAction.next,
                  //   controller: _vaartaapatraCountCtrl,
                  //   decoration: InputDecoration(
                  //       labelText: Statics.getLabel('getVaartaapatraCount')),
                  //   keyboardType: TextInputType.number,
                  //   validator: (value) {
                  //     if (value == null || value == '')
                  //       return (Statics.getLabel('mandatoryInformation'));
                  //     return null;
                  //   },
                  //   onSaved: (value) {
                  //     shaakhaaViheen!.vaartaapatraCount =
                  //         value == "" ? null : int.parse(value);
                  //   },
                  // ),

                  SizedBox(
                    height: 30,
                  ),
                  Table(
                    columnWidths: {
                      0: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.3),
                      1: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.3),
                      2: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.04),
                      3: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.3)
                    },
                    children: [
                      TableRow(
                        children: [
                          Container(
                              height: 40,
                              child: Text(
                                Statics.getLabel('sanghShikshaVarg'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          Container(height: 40, child: Text(Statics.getLabel('shikshaarthiCount'), style: TextStyle(fontWeight: FontWeight.bold))),
                          Container(height: 40, child: Text('', style: TextStyle(fontWeight: FontWeight.bold))),
                          Container(height: 40, child: Text(Statics.getLabel('sakriyaCount'), style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                      TableRow(children: [
                        Text(Statics.getLabel('praathamikVarsh')),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _praathamikCountCtrl,
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            shaakhaaViheen!.praathamikCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                        Text(''),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _praathamikSakriyaCountCtrl,
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            shaakhaaViheen!.praathamikSakriyaCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                      ]),
                      // TableRow(children: [
                      //   Text(Statics.getLabel('prathamGeneral')),
                      //   TextFormField(
                      //     textInputAction: TextInputAction.next,
                      //     controller: _prathamGeneralCountCtrl,
                      //     keyboardType: TextInputType.number,
                      //     onSaved: (value) {
                      //       shaakhaaViheen!.prathamGeneralCount =
                      //           value == "" ? null : int.parse(value);
                      //     },
                      //   ),
                      //   Text(''),
                      //   TextFormField(
                      //     textInputAction: TextInputAction.next,
                      //     controller: _prathamGeneralSakriyaCountCtrl,
                      //     keyboardType: TextInputType.number,
                      //     onSaved: (value) {
                      //       shaakhaaViheen!.prathamGeneralSakriyaCount =
                      //           value == "" ? null : int.parse(value);
                      //     },
                      //   ),
                      // ]),
                      // TableRow(children: [
                      //   Text(Statics.getLabel('prathamSpecial')),
                      //   TextFormField(
                      //     textInputAction: TextInputAction.next,
                      //     controller: _prathamSpecialCountCtrl,
                      //     keyboardType: TextInputType.number,
                      //     onSaved: (value) {
                      //       shaakhaaViheen!.prathamSpecialCount =
                      //           value == "" ? null : int.parse(value);
                      //     },
                      //   ),
                      //   Text(''),
                      //   TextFormField(
                      //     textInputAction: TextInputAction.next,
                      //     controller: _prathamSpecialSakriyaCountCtrl,
                      //     keyboardType: TextInputType.number,
                      //     onSaved: (value) {
                      //       shaakhaaViheen!.prathamSpecialSakriyaCount =
                      //           value == "" ? null : int.parse(value);
                      //     },
                      //   ),
                      // ]),
                      // TableRow(children: [
                      //   Text(Statics.getLabel('dwitiyaGeneral')),
                      //   TextFormField(
                      //     textInputAction: TextInputAction.next,
                      //     controller: _dwitiyaGeneralCountCtrl,
                      //     keyboardType: TextInputType.number,
                      //     onSaved: (value) {
                      //       shaakhaaViheen!.dwitiyaGeneralCount =
                      //           value == "" ? null : int.parse(value);
                      //     },
                      //   ),
                      //   Text(''),
                      //   TextFormField(
                      //     textInputAction: TextInputAction.next,
                      //     controller: _dwitiyaGeneralSakriyaCountCtrl,
                      //     keyboardType: TextInputType.number,
                      //     onSaved: (value) {
                      //       shaakhaaViheen!.dwitiyaGeneralSakriyaCount =
                      //           value == "" ? null : int.parse(value);
                      //     },
                      //   ),
                      // ]),
                      // TableRow(children: [
                      //   Text(Statics.getLabel('dwitiyaSpecial')),
                      //   TextFormField(
                      //     textInputAction: TextInputAction.next,
                      //     controller: _dwitiyaSpecialCountCtrl,
                      //     keyboardType: TextInputType.number,
                      //     onSaved: (value) {
                      //       shaakhaaViheen!.dwitiyaSpecialCount =
                      //           value == "" ? null : int.parse(value);
                      //     },
                      //   ),
                      //   Text(''),
                      //   TextFormField(
                      //     textInputAction: TextInputAction.next,
                      //     controller: _dwitiyaSpecialSakriyaCountCtrl,
                      //     keyboardType: TextInputType.number,
                      //     onSaved: (value) {
                      //       shaakhaaViheen!.dwitiyaSpecialSakriyaCount =
                      //           value == "" ? null : int.parse(value);
                      //     },
                      //   ),
                      // ]),
                      // TableRow(children: [
                      //   Text(Statics.getLabel('trutiyaGeneral')),
                      //   TextFormField(
                      //     textInputAction: TextInputAction.next,
                      //     controller: _trutiyaGeneralCountCtrl,
                      //     keyboardType: TextInputType.number,
                      //     onSaved: (value) {
                      //       shaakhaaViheen!.trutiyaGeneralCount =
                      //           value == "" ? null : int.parse(value);
                      //     },
                      //   ),
                      //   Text(''),
                      //   TextFormField(
                      //     textInputAction: TextInputAction.next,
                      //     controller: _trutiyaGeneralSakriyaCountCtrl,
                      //     keyboardType: TextInputType.number,
                      //     onSaved: (value) {
                      //       shaakhaaViheen!.trutiyaGeneralSakriyaCount =
                      //           value == "" ? null : int.parse(value);
                      //     },
                      //   ),
                      // ]),
                      // TableRow(children: [
                      //   Text(Statics.getLabel('trutiyaSpecial')),
                      //   TextFormField(
                      //     textInputAction: TextInputAction.next,
                      //     controller: _trutiyaSpecialCountCtrl,
                      //     keyboardType: TextInputType.number,
                      //     onSaved: (value) {
                      //       shaakhaaViheen!.trutiyaSpecialCount =
                      //           value == "" ? null : int.parse(value);
                      //     },
                      //   ),
                      //   Text(''),
                      //   TextFormField(
                      //     textInputAction: TextInputAction.next,
                      //     controller: _trutiyaSpecialSakriyaCountCtrl,
                      //     keyboardType: TextInputType.number,
                      //     onSaved: (value) {
                      //       shaakhaaViheen!.trutiyaSpecialSakriyaCount =
                      //           value == "" ? null : int.parse(value);
                      //     },
                      //   ),
                      // ]),
                    ],
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
                      textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
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
