import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../providers/bals.dart';

import '../helpers/static_data.dart' as Statics;

class SoochiDetails extends StatefulWidget {
  static const String routeName = '/edit-shaakhaa-screen';
  var soochiId;
  var onSaveDetails;
  var viewType;

  SoochiDetails({Key? key, this.soochiId, this.onSaveDetails, this.viewType}) : super(key: key);

  State<StatefulWidget> createState() {
    return new SoochiDetailsState();
  }
}

class SoochiDetailsState extends State<SoochiDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  bool _isfetingData = false;

  SoochiMasterBAL? soochi;

  List<StaticMasterBAL>? _status;
  String? _statusValue;
  String? _ownerID;

  var _soochinameCtrl = TextEditingController();
  var _remarkCtrl = TextEditingController();
  var _ownerCtrl = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _soochinameCtrl.dispose();
    _remarkCtrl.dispose();
    _ownerCtrl.dispose();
  }

  @override
  void initState() {
    super.initState();
    populateDropdown();
    int shaakhaaID = int.parse(widget.soochiId);
    if (shaakhaaID > 0) {
      getSocchiDetails(widget.soochiId);
    } else {
      if (!mounted) return;
      setState(() {
        soochi = new SoochiMasterBAL(null, 1, "", Statics.userDetails["UserID"], Statics.userDetails["FullName"], null, "", "");
        _ownerCtrl.text = Statics.userDetails["FullName"];
        _ownerID = Statics.userDetails["userID"];
      });
    }
  }

  void getSocchiDetails(var theId) async {
    setState(() {
      _isfetingData = true;
    });
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      var data = await Statics.getSoochiDetails(theId);
      if (!mounted) return;
      setState(() {
        soochi = data;
        if (soochi != null) {
          _soochinameCtrl.text = soochi!.soochiName.toString();
          _statusValue = soochi!.statusID == null ? null : soochi!.statusID.toString();
          _ownerCtrl.text = soochi!.ownerSwayamsevakFullName.toString();
          _ownerID = soochi!.ownerSwayamsevakID.toString();
          _remarkCtrl.text = soochi!.remark.toString();
        }
      });
    }
    setState(() {
      _isfetingData = false;
    });
  }

  void populateDropdown() async {
    var data = await Statics.getStaticLDB("SoochiStatus");
    if (!mounted) return;
    setState(() {
      _status = data;
    });
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
        await saveSoochiDetails();
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

  saveSoochiDetails() async {
    var inputData = json.encode({
      "SoochiID": int.parse(widget.soochiId),
      "PraantID": 1,
      "OwnerSwayamsevakID": _ownerID,
      "SoochiName": soochi!.soochiName,
      "Remark": soochi!.remark,
      "StatusID": soochi!.statusID,
      "ModifiedBy": Statics.userDetails["userID"]
    });

    var data = await Statics.saveSoochiDetails(inputData);
    setState(() {
      widget.soochiId = data;
      widget.onSaveDetails(widget.soochiId);
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
                        controller: _soochinameCtrl,
                        decoration: InputDecoration(labelText: Statics.getLabel('SoochiName')),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) return (Statics.getLabel('SoochiNameValidationMessage'));
                          return null;
                        },
                        onSaved: (value) {
                          soochi!.soochiName = value;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (_status != null)
                        DropdownButtonFormField(
                          decoration: InputDecoration(labelText: Statics.getLabel('Status')),
                          isExpanded: true,
                          value: _statusValue == "" ? null : _statusValue,
                          items: _status!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
                          onChanged: (value) {
                            setState(() {
                              _statusValue = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) return (Statics.getLabel('StatusValidationMessage'));
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null && value.isNotEmpty)
                              soochi!.statusID = int.parse(value);
                            else
                              soochi!.statusID = null;
                          },
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _remarkCtrl,
                        decoration: InputDecoration(labelText: Statics.getLabel('Remark')),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          soochi!.remark = value;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        enabled: false,
                        controller: _ownerCtrl,
                        decoration: InputDecoration(labelText: Statics.getLabel('SoochiOwner')),
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
}
