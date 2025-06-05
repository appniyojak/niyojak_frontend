import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../providers/bals.dart';

import '../helpers/static_data.dart' as Statics;

class EditShaakhaaVrutta extends StatefulWidget {
  static const String routeName = '/edit-shaakhaa-vrutta-screen';
  var shaakhaaID;
  var vruttaID;
  var onSaveDetails;
  var viewType;
  EditShaakhaaVrutta({Key? key, this.shaakhaaID, this.vruttaID, this.onSaveDetails, this.viewType}) : super(key: key);
  @override
  _EditShaakhaaVruttaState createState() => _EditShaakhaaVruttaState();
}

class _EditShaakhaaVruttaState extends State<EditShaakhaaVrutta> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  ShaakhaaVruttaBAL? vrutta;
  var _isLoading = false;

  bool _isFetchingData = false;

  DateTime? _vruttaDate;
  var _vruttaDateCntrl = TextEditingController();
  var _shishuCtrl = TextEditingController();
  var _baalCtrl = TextEditingController();
  var _tarunVidhyaarthiCtrl = TextEditingController();
  var _tarunVyavsaayeeCtrl = TextEditingController();
  var _proudhaCtrl = TextEditingController();
  var _abhyaagatCtrl = TextEditingController();
  var _remarkCtrl = TextEditingController();

  // bool _isMandatoryShaaririk = false;
  // bool _isMandatoryBouddhik = false;
  bool _isOptionalShaaririk = false;
  bool _isOptionalOther = false;
  var vayogatCode = '';

  bool _isDoneDeepBreathing = false;
  bool _isDoneDandaPrahaar = false;
  bool _isDoneSooryaNamaskaar = false;
  bool _isDoneSanchalanAbhyaas = false;
  bool _isDoneSaanghikGeet = false;
  bool _isDoneAmrutaVachan = false;
  bool _isDoneSubhaashit = false;

  @override
  void initState() {
    super.initState();
    int vruttaID = int.parse(widget.vruttaID == null ? "0" : widget.vruttaID);
    int shaakhaaID = int.parse(widget.shaakhaaID == null ? "0" : widget.shaakhaaID.toString());
    populateShaakhaVayogat(shaakhaaID.toString());
    if (vruttaID > 0) {
      getSwDetails(widget.vruttaID);
    } else {
      if (!mounted) return;
      setState(() {
        vrutta = new ShaakhaaVruttaBAL(vruttaID, 1, shaakhaaID, "", null, null, null, null, null, null, "", false, false, false, false, false, false,
            false, false, false, false, false);
      });
    }
  }

  void populateShaakhaVayogat(shaakhaaID) async {
    var data = await Statics.getShaakhaaByID(shaakhaaID);
    var data2 = await Statics.getStaticLDB('ShaakhaaVayogat');
    if (data != null) {
      ShaakhaaMasterBAL shaakhaa = data;
      var code = data2[data2.indexWhere((e) => e.staticID == shaakhaa.vayogatID)].code;
      setState(() {
        vayogatCode = code!;
      });
    }
  }

  void getSwDetails(var theId) async {
    setState(() {
      _isFetchingData = true;
    });
    var dataList;
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      dataList = await Statics.getShaakhaaVruttaListForApp(null, theId);
      var data = ShaakhaaVruttaBAL.fromMap(dataList[0]);
      if (!mounted) return;
      setState(() {
        vrutta = data;
        if (vrutta != null) {
          _vruttaDate = ((vrutta!.vruttaDate != null && vrutta!.vruttaDate != "") ? DateFormat("yyyy/MM/dd").parse(vrutta!.vruttaDate!) : null);
          _vruttaDateCntrl.text = ((vrutta!.vruttaDate != null && vrutta!.vruttaDate != "") ? DateFormat('dd-MMM-yyyy').format(_vruttaDate!) : '');
          _shishuCtrl.text = vrutta!.shishuCount == null ? "" : vrutta!.shishuCount.toString();
          _baalCtrl.text = vrutta!.baalVidyaarthiCount == null ? "" : vrutta!.baalVidyaarthiCount.toString();
          _tarunVidhyaarthiCtrl.text = vrutta!.tarunVidyaarthiCount == null ? "" : vrutta!.tarunVidyaarthiCount.toString();
          _tarunVyavsaayeeCtrl.text = vrutta!.tarunVyavasaayeeCount == null ? "" : vrutta!.tarunVyavasaayeeCount.toString();
          _proudhaCtrl.text = vrutta!.proudhaVyavasaayeeCount == null ? "" : vrutta!.proudhaVyavasaayeeCount.toString();
          _abhyaagatCtrl.text = vrutta!.abhyaagatCount == null ? "" : vrutta!.abhyaagatCount.toString();
          _remarkCtrl.text = vrutta!.remark == null ? "" : vrutta!.remark.toString();

          // _isMandatoryShaaririk =
          //     vrutta!.isMandatoryShaaririk == true ? true : false;

          // _isMandatoryBouddhik =
          //     vrutta!.isMandatoryBouddhik == true ? true : false;

          _isOptionalShaaririk = vrutta!.isOptionalShaaririk == true ? true : false;

          _isOptionalOther = vrutta!.isOptionalOther == true ? true : false;

          _isDoneDeepBreathing = vrutta!.isDoneDeepBreathing == true ? true : false;
          _isDoneDandaPrahaar = vrutta!.isDoneDandaPrahaar == true ? true : false;
          _isDoneSooryaNamaskaar = vrutta!.isDoneSooryaNamaskaar == true ? true : false;
          _isDoneSanchalanAbhyaas = vrutta!.isDoneSanchalanAbhyaas == true ? true : false;
          _isDoneSaanghikGeet = vrutta!.isDoneSaanghikGeet == true ? true : false;
          _isDoneAmrutaVachan = vrutta!.isDoneAmrutaVachan == true ? true : false;
          _isDoneSubhaashit = vrutta!.isDoneSubhaashit == true ? true : false;
        }
      });
    }
    setState(() {
      _isFetchingData = false;
    });
  }

  _pickFromDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: _vruttaDate == null ? DateTime.now() : _vruttaDate!,
        firstDate: DateTime((_vruttaDate == null ? DateTime.now().year : _vruttaDate!.year) - 80),
        lastDate: DateTime((_vruttaDate == null ? DateTime.now().year : _vruttaDate!.year) + 80));

    var _todaysDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

    if (date != null) {
      var _formattedDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(date));
      if (_formattedDate.isAfter(_todaysDate)) {
        Statics.showToast("Vrutta Date cannot be a Future Date.");
        return;
      }
    }

    if (date != null) {
      setState(() {
        _vruttaDate = date;
        _vruttaDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date);
      });
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
        await saveVruttaDetails(context);
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

  saveVruttaDetails(BuildContext context) async {
    var inputData = json.encode({
      "ShaakhaaVruttaID": int.parse(widget.vruttaID),
      "PraantID": 1,
      "ShaakhaaID": int.parse(widget.shaakhaaID),
      "VruttaDateStr": (_vruttaDate != null ? DateFormat('dd-MM-yyyy').format(_vruttaDate!) : null),
      "ShishuCount": _shishuCtrl.text.trim() == "" ? null : int.parse(_shishuCtrl.text),
      "BaalVidyaarthiCount": _baalCtrl.text.trim() == "" ? null : int.parse(_baalCtrl.text),
      "TarunVidyaarthiCount": _tarunVidhyaarthiCtrl.text.trim() == "" ? null : int.parse(_tarunVidhyaarthiCtrl.text),
      "TarunVyavasaayeeCount": _tarunVyavsaayeeCtrl.text.trim() == "" ? null : int.parse(_tarunVyavsaayeeCtrl.text),
      "ProudhaVyavasaayeeCount": _proudhaCtrl.text.trim() == "" ? null : int.parse(_proudhaCtrl.text),
      "AbhyaagatCount": _abhyaagatCtrl.text.trim() == "" ? null : int.parse(_abhyaagatCtrl.text),
      // "IsMandatoryShaaririk": _isMandatoryShaaririk,
      // "IsMandatoryBouddhik": _isMandatoryBouddhik,
      "IsDoneDeepBreathing": vayogatCode == "Proudh Vyavasaayee" ? _isDoneDeepBreathing : null,
      "IsDoneDandaPrahaar": vayogatCode == "Proudh Vyavasaayee" ? null : _isDoneDandaPrahaar,
      "IsDoneSooryaNamaskaar": vayogatCode == "Proudh Vyavasaayee" ? null : _isDoneSooryaNamaskaar,
      "IsDoneSanchalanAbhyaas": vayogatCode == "Proudh Vyavasaayee" ? null : _isDoneSanchalanAbhyaas,
      "IsDoneSaanghikGeet": _isDoneSaanghikGeet,
      "IsDoneAmrutaVachan": _isDoneAmrutaVachan,
      "IsDoneSubhaashit": _isDoneSubhaashit,
      "IsOptionalShaaririk": _isOptionalShaaririk,
      "IsOptionalOther": _isOptionalOther,
      "Remark": _remarkCtrl.text.trim() == "" ? null : _remarkCtrl.text,
      "ModifiedBy": Statics.userDetails["userID"]
    });
    var data = await Statics.saveShaakhaaVruttaForApp(inputData);
    setState(() {
      widget.vruttaID = data;
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
          Statics.getLabel('Vrutta'),
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: ModalProgressHUD(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              width: Statics.getDeviceSize(context).width,
              child: AbsorbPointer(
                absorbing: widget.viewType == "ViewMenu" ? true : false,
                child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    Row(
                      children: [
                        SizedBox(
                          width: Statics.getDeviceSize(context).width * 0.7,
                          child: AbsorbPointer(
                            absorbing: true,
                            child: TextFormField(
                              controller: _vruttaDateCntrl,
                              decoration: InputDecoration(labelText: Statics.getLabel('VruttaDate')),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty) return (Statics.getLabel('VruttaDateValidationMessage'));
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
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _shishuCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('ShishuCount')),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        vrutta!.shishuCount = value == "" ? null : int.parse(value!);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _baalCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('BaalCount')),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        vrutta!.baalVidyaarthiCount = value == "" ? null : int.parse(value!);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _tarunVidhyaarthiCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('TarunVidyaarthiCount')),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        vrutta!.tarunVidyaarthiCount = value == "" ? null : int.parse(value!);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _tarunVyavsaayeeCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('TarunVyavasaayeeCount')),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        vrutta!.tarunVyavasaayeeCount = value == "" ? null : int.parse(value!);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _proudhaCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('ProudhaCount')),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        vrutta!.proudhaVyavasaayeeCount = value == "" ? null : int.parse(value!);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _abhyaagatCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('AbhyaagatCount')),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        vrutta!.abhyaagatCount = value == "" ? null : int.parse(value!);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (vayogatCode == "Proudh Vyavasaayee")
                      Column(
                        children: [
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.8,
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(Statics.getLabel("Minimum5minutesDeepBreathing"), style: TextStyle(fontSize: 15)),
                              checkColor: Colors.white,
                              activeColor: Colors.purple,
                              value: _isDoneDeepBreathing,
                              onChanged: (value) {
                                setState(() {
                                  _isDoneDeepBreathing = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.8,
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(Statics.getLabel("Minimum1minuteDandaPrahaar"), style: TextStyle(fontSize: 15)),
                              checkColor: Colors.white,
                              activeColor: Colors.purple,
                              value: _isDoneDandaPrahaar,
                              onChanged: (value) {
                                setState(() {
                                  _isDoneDandaPrahaar = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.8,
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(Statics.getLabel("Minimum5minutesSooryaNamaskaar"), style: TextStyle(fontSize: 15)),
                              checkColor: Colors.white,
                              activeColor: Colors.purple,
                              value: _isDoneSooryaNamaskaar,
                              onChanged: (value) {
                                setState(() {
                                  _isDoneSooryaNamaskaar = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.8,
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(Statics.getLabel("Minimum5minutesSanchalanAbhyaas"), style: TextStyle(fontSize: 15)),
                              checkColor: Colors.white,
                              activeColor: Colors.purple,
                              value: _isDoneSanchalanAbhyaas,
                              onChanged: (value) {
                                setState(() {
                                  _isDoneSanchalanAbhyaas = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    SizedBox(
                      width: Statics.getDeviceSize(context).width * 0.8,
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(Statics.getLabel("SaanghikGeet"), style: TextStyle(fontSize: 15)),
                        checkColor: Colors.white,
                        activeColor: Colors.purple,
                        value: _isDoneSaanghikGeet,
                        onChanged: (value) {
                          setState(() {
                            _isDoneSaanghikGeet = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: Statics.getDeviceSize(context).width * 0.8,
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(Statics.getLabel("AmrutaVachan"), style: TextStyle(fontSize: 15)),
                        checkColor: Colors.white,
                        activeColor: Colors.purple,
                        value: _isDoneAmrutaVachan,
                        onChanged: (value) {
                          setState(() {
                            _isDoneAmrutaVachan = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: Statics.getDeviceSize(context).width * 0.8,
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(Statics.getLabel("Subhaashit"), style: TextStyle(fontSize: 15)),
                        checkColor: Colors.white,
                        activeColor: Colors.purple,
                        value: _isDoneSubhaashit,
                        onChanged: (value) {
                          setState(() {
                            _isDoneSubhaashit = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // SizedBox(
                    //   width: Statics.getDeviceSize(context).width * 0.8,
                    //   child: CheckboxListTile(
                    //     contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    //     controlAffinity: ListTileControlAffinity.leading,
                    //     title: Text(Statics.getLabel("ConductedAnivaaryaShaaririkKaaryakram"),
                    //         style: TextStyle(fontSize: 15)),
                    //     checkColor: Colors.white,
                    //     activeColor: Colors.purple,
                    //     value: _isMandatoryShaaririk == null
                    //         ? false
                    //         : _isMandatoryShaaririk,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         _isMandatoryShaaririk = value;
                    //       });
                    //     },
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // SizedBox(
                    //   width: Statics.getDeviceSize(context).width * 0.8,
                    //   child: CheckboxListTile(
                    //     contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    //     controlAffinity: ListTileControlAffinity.leading,
                    //     title: Text(Statics.getLabel("ConductedAnivaaryaBouddhikKaaryakram"),
                    //         style: TextStyle(fontSize: 15)),
                    //     checkColor: Colors.white,
                    //     activeColor: Colors.purple,
                    //     value: _isMandatoryBouddhik == null
                    //         ? false
                    //         : _isMandatoryBouddhik,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         _isMandatoryBouddhik = value;
                    //       });
                    //     },
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    SizedBox(
                      width: Statics.getDeviceSize(context).width * 0.8,
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(Statics.getLabel("ConductedOptionalShaaririkVishay"), style: TextStyle(fontSize: 15)),
                        checkColor: Colors.white,
                        activeColor: Colors.purple,
                        value: _isOptionalShaaririk,
                        onChanged: (value) {
                          setState(() {
                            _isOptionalShaaririk = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: Statics.getDeviceSize(context).width * 0.8,
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(Statics.getLabel("ConductedOtherOptionalKaaryakram"), style: TextStyle(fontSize: 15)),
                        checkColor: Colors.white,
                        activeColor: Colors.purple,
                        value: _isOptionalOther,
                        onChanged: (value) {
                          setState(() {
                            _isOptionalOther = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _remarkCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('Remarks')),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        vrutta!.remark = value == "" ? null : value;
                      },
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
                        onPressed: () {
                          _submit(context);
                        },
                        child: Text(
                          Statics.getLabel('Submit'),
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                  ]),
                ),
              ),
            ),
          ),
          inAsyncCall: _isFetchingData),
    );
  }
}
