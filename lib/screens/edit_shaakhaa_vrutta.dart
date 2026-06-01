import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../helpers/static_data.dart' as Statics;
import '../providers/bals.dart';
import '../utils/globals.dart';

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
  var _newshishuCtrl = TextEditingController();
  var _baalCtrl = TextEditingController();
  var _newbaalCtrl = TextEditingController();
  var _tarunVidhyaarthiCtrl = TextEditingController();
  var _newtarunVidhyaarthiCtrl = TextEditingController();
  var _tarunVyavsaayeeCtrl = TextEditingController();
  var _newtarunVyavsaayeeCtrl = TextEditingController();
  var _proudhaCtrl = TextEditingController();
  var _newproudhaCtrl = TextEditingController();
  var _matrushaktiCtrl = TextEditingController();
  var _newmatrushaktiCtrl = TextEditingController();
  var _abhyaagatCtrl = TextEditingController();
  var _pravasiKaryakartaCountCtrl = TextEditingController();
  var _anyaPravasiKaryakartaCountCtrl = TextEditingController();
  var _remarkCtrl = TextEditingController();

  // bool _isMandatoryShaaririk = false;
  // bool _isMandatoryBouddhik = false;
  bool _isOptionalShaaririk = false;
  bool _isOptionalOther = false;
  var vayogatCode = '';
  var frequencyId = 0;
  List<StaticMasterBAL> _frequency = [];

  bool _isDoneDeepBreathing = false;
  bool _isDoneDandaPrahaar = false;
  bool _isDoneSooryaNamaskaar = false;
  bool _isDoneSanchalanAbhyaas = false;

  bool _isDoneUrdhvapad = false;
  bool _isDoneBoodhKatha = false;
  bool _isDoneBoudhikDays = false;
  String? _selectedBoudhikDaysId;
  var _anyaBoudhikDaysCtrl = TextEditingController();
  bool _isDoneSewaDays = false;

  // String? _selectedSewaDaysId;

  bool _isDoneSaanghikGeet = false;
  bool _isDoneAmrutaVachan = false;
  bool _isDoneSubhaashit = false;

  List<StaticMasterBAL?> _boudhikDaysList = [];
  List<StaticMasterBAL?> _sewaDaysList = [];
  List<int?> _selectedSewaDaysList = [];

  @override
  void initState() {
    super.initState();
    int vruttaID = int.tryParse(widget.vruttaID == null ? "0" : widget.vruttaID) ?? 0;
    int shaakhaaID = int.tryParse(widget.shaakhaaID == null ? "0" : widget.shaakhaaID.toString()) ?? 0;
    populateShaakhaVayogat(shaakhaaID.toString());
    if (vruttaID > 0) {
      getSwDetails(widget.vruttaID);
    } else {
      if (!mounted) return;
      setState(() {
        vrutta = new ShaakhaaVruttaBAL(
          vruttaID,
          1,
          shaakhaaID,
          "",
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          "",
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          null,
          null,
          false,
          null,
        );
      });
    }
  }

  void populateShaakhaVayogat(shaakhaaID) async {
    var data = await Statics.getShaakhaaByID(shaakhaaID);
    var data2 = await Statics.getStaticLDB('ShaakhaaVayogat');
    var data3 = await Statics.getStaticLDB('ShaakhaaFrequency');
    _boudhikDaysList = await Statics.getStaticLDB('boudhikDaysList');
    _sewaDaysList = await Statics.getStaticLDB('sewaDaysList');
    if (data != null) {
      var code = data2[data2.indexWhere((e) => e.staticID == data.vayogatID)].code;
      var freq = data.frequencyID;
      setState(() {
        vayogatCode = code!;
        _frequency = data3;
        frequencyId = freq ?? 0;
      });

      // print("code >>>>>>>>>>>>>>>>>>>>>>>>>>>>> $code");
      print("frequencyId >>>>>>>>>>>>>>>>>>>>>>>>>>>>> $frequencyId");
    }
    setState(() {});
    // _boudhikDaysList.forEach((e) => print("e >>>>>>>>>>>>>>>>>>>> ${e?.toJson()}"));
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
          _newshishuCtrl.text = vrutta!.newshishuCount == null ? "" : vrutta!.newshishuCount.toString();
          _baalCtrl.text = vrutta!.baalVidyaarthiCount == null ? "" : vrutta!.baalVidyaarthiCount.toString();
          _newbaalCtrl.text = vrutta!.newbaalVidyaarthiCount == null ? "" : vrutta!.newbaalVidyaarthiCount.toString();
          _tarunVidhyaarthiCtrl.text = vrutta!.tarunVidyaarthiCount == null ? "" : vrutta!.tarunVidyaarthiCount.toString();
          _newtarunVidhyaarthiCtrl.text = vrutta!.newtarunVidyaarthiCount == null ? "" : vrutta!.newtarunVidyaarthiCount.toString();
          _tarunVyavsaayeeCtrl.text = vrutta!.tarunVyavasaayeeCount == null ? "" : vrutta!.tarunVyavasaayeeCount.toString();
          _newtarunVyavsaayeeCtrl.text = vrutta!.newtarunVyavasaayeeCount == null ? "" : vrutta!.newtarunVyavasaayeeCount.toString();
          _proudhaCtrl.text = vrutta!.proudhaVyavasaayeeCount == null ? "" : vrutta!.proudhaVyavasaayeeCount.toString();
          _newproudhaCtrl.text = vrutta!.newproudhaVyavasaayeeCount == null ? "" : vrutta!.newproudhaVyavasaayeeCount.toString();
          _matrushaktiCtrl.text = vrutta!.matruskatiCount == null ? "" : vrutta!.matruskatiCount.toString();
          _newmatrushaktiCtrl.text = vrutta!.newmatruskatiCount == null ? "" : vrutta!.newmatruskatiCount.toString();
          _abhyaagatCtrl.text = vrutta!.abhyaagatCount == null ? "" : vrutta!.abhyaagatCount.toString();
          _pravasiKaryakartaCountCtrl.text = vrutta!.pravasiKaryakartaCount == null ? "" : vrutta!.pravasiKaryakartaCount.toString();
          _anyaPravasiKaryakartaCountCtrl.text = vrutta!.anyaPravasiKaryakartaCount == null ? "" : vrutta!.anyaPravasiKaryakartaCount.toString();
          _remarkCtrl.text = vrutta!.remark == null ? "" : vrutta!.remark.toString();

          // _isMandatoryShaaririk =
          //     vrutta!.isMandatoryShaaririk == true ? true : false;

          // _isMandatoryBouddhik =
          //     vrutta!.isMandatoryBouddhik == true ? true : false;

          _isOptionalShaaririk = vrutta?.isOptionalShaaririk ?? false;

          _isOptionalOther = vrutta?.isOptionalOther ?? false;

          _isDoneDeepBreathing = vrutta?.isDoneDeepBreathing ?? false;
          _isDoneDandaPrahaar = vrutta?.isDoneDandaPrahaar ?? false;
          _isDoneSooryaNamaskaar = vrutta?.isDoneSooryaNamaskaar ?? false;
          _isDoneSanchalanAbhyaas = vrutta?.isDoneSanchalanAbhyaas ?? false;
          _isDoneSaanghikGeet = vrutta?.isDoneSaanghikGeet ?? false;
          _isDoneAmrutaVachan = vrutta?.isDoneAmrutaVachan ?? false;
          _isDoneSubhaashit = vrutta?.isDoneSubhaashit ?? false;
          _isDoneUrdhvapad = vrutta?.isDoneUrdhvapad ?? false;
          _isDoneBoodhKatha = vrutta?.isDoneBoodhKatha ?? false;
          _isDoneBoudhikDays = vrutta?.isDoneBoudhikDays ?? false;
          _isDoneSewaDays = vrutta?.isDoneSewaDays ?? false;

          _selectedBoudhikDaysId = vrutta?.SelectedBoudhikDaysId;
          _anyaBoudhikDaysCtrl.text = vrutta?.AnyaBoudhikDays ?? "";
          _selectedSewaDaysList = vrutta?.SelectedSewaDaysId?.split(',').map((e) => int.tryParse(e)).where((e) => e != null).cast<int>().toList() ?? [];
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
      "NewShishuCount": _newshishuCtrl.text.trim() == "" ? null : int.parse(_newshishuCtrl.text),
      "BaalVidyaarthiCount": _baalCtrl.text.trim() == "" ? null : int.parse(_baalCtrl.text),
      "NewBaalVidyaarthiCount": _newbaalCtrl.text.trim() == "" ? null : int.parse(_newbaalCtrl.text),
      "TarunVidyaarthiCount": _tarunVidhyaarthiCtrl.text.trim() == "" ? null : int.parse(_tarunVidhyaarthiCtrl.text),
      "NewTarunVidyaarthiCount": _newtarunVidhyaarthiCtrl.text.trim() == "" ? null : int.parse(_newtarunVidhyaarthiCtrl.text),
      "TarunVyavasaayeeCount": _tarunVyavsaayeeCtrl.text.trim() == "" ? null : int.parse(_tarunVyavsaayeeCtrl.text),
      "NewTarunVyavasaayeeCount": _newtarunVyavsaayeeCtrl.text.trim() == "" ? null : int.parse(_newtarunVyavsaayeeCtrl.text),
      "ProudhaVyavasaayeeCount": _proudhaCtrl.text.trim() == "" ? null : int.parse(_proudhaCtrl.text),
      "NewProudhaVyavasaayeeCount": _newproudhaCtrl.text.trim() == "" ? null : int.parse(_newproudhaCtrl.text),
      "MatrushaktiCount": _matrushaktiCtrl.text.trim() == "" ? null : int.parse(_matrushaktiCtrl.text),
      "NewMatrushaktiCount": _newmatrushaktiCtrl.text.trim() == "" ? null : int.parse(_newmatrushaktiCtrl.text),
      "AbhyaagatCount": _abhyaagatCtrl.text.trim() == "" ? null : int.parse(_abhyaagatCtrl.text),
      "PravasiKaryakartaCount": _pravasiKaryakartaCountCtrl.text.trim() == "" ? null : int.parse(_pravasiKaryakartaCountCtrl.text),
      "AnyaPravasiKaryakartaCount": _anyaPravasiKaryakartaCountCtrl.text.trim() == "" ? null : int.parse(_anyaPravasiKaryakartaCountCtrl.text),
      // "IsMandatoryShaaririk": _isMandatoryShaaririk,
      // "IsMandatoryBouddhik": _isMandatoryBouddhik,
      "IsDoneDeepBreathing": vayogatCode == "Proudh Vyavasaayee" ? _isDoneDeepBreathing : null,
      "IsDoneDandaPrahaar": vayogatCode == "Proudh Vyavasaayee" ? null : _isDoneDandaPrahaar,
      "IsDoneSooryaNamaskaar": vayogatCode == "Proudh Vyavasaayee" ? null : _isDoneSooryaNamaskaar,
      "IsDoneSanchalanAbhyaas": vayogatCode == "Proudh Vyavasaayee" ? null : _isDoneSanchalanAbhyaas,
      "IsDoneUrdhvapad": vayogatCode == "Baal" ? _isDoneUrdhvapad : null,
      "IsDoneSaanghikGeet": _isDoneSaanghikGeet,
      "IsDoneAmrutaVachan": _isDoneAmrutaVachan,
      "IsDoneSubhaashit": _isDoneSubhaashit,
      "IsDoneBoodhKatha": _isDoneBoodhKatha,
      "IsDoneBoudhikDays": _isDoneBoudhikDays,
      "BoudhikDaysId": _selectedBoudhikDaysId,
      "AnyaBoudhikDays": _anyaBoudhikDaysCtrl.text.trim(),
      "IsDoneSewaDays": _isDoneSewaDays,
      "SewaDaysId": _selectedSewaDaysList.isNotEmpty ? _selectedSewaDaysList.where((e) => e != null).join(",") : "",
      "IsOptionalShaaririk": _isOptionalShaaririk,
      "IsOptionalOther": _isOptionalOther,
      "Remark": _remarkCtrl.text.trim() == "" ? null : _remarkCtrl.text,
      "ModifiedBy": Statics.userDetails["userID"]
    });
    var data = await Statics.saveShaakhaaVruttaForApp(inputData);
    setState(() {
      widget.vruttaID = data;
      if (widget.onSaveDetails != null) widget.onSaveDetails();
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
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
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
                    SizedBox(height: 14),
                    Text(
                      Statics.getLabel('ShishuCount') + " " + Statics.getLabel('ShishuCountRange'),
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    SizedBox(height: 8),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: numTextField(
                            controller: _shishuCtrl,
                            labelText: Statics.getLabel('Total'),
                            onSaved: (value) {
                              vrutta!.shishuCount = value == "" ? null : int.parse(value!);
                            },
                          ),
                        ),
                        Expanded(
                          child: numTextField(
                            readOnly: _shishuCtrl.text.isEmpty,
                            controller: _newshishuCtrl,
                            expectedController: _shishuCtrl,
                            labelText: Statics.getLabel('newAdmission'),
                            onSaved: (value) {
                              vrutta!.newshishuCount = value == "" ? null : int.parse(value!);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14),
                    Text(
                      Statics.getLabel('BaalCount') + " " + Statics.getLabel('BaalCountRange'),
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    SizedBox(height: 8),
                    Row(spacing: 12, children: [
                      Expanded(
                        child: numTextField(
                          controller: _baalCtrl,
                          labelText: Statics.getLabel('Total'),
                          onSaved: (value) {
                            vrutta!.baalVidyaarthiCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: numTextField(
                          readOnly: _baalCtrl.text.isEmpty,
                          controller: _newbaalCtrl,
                          expectedController: _baalCtrl,
                          labelText: Statics.getLabel('newAdmission'),
                          onSaved: (value) {
                            vrutta!.newbaalVidyaarthiCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                      ),
                    ]),
                    SizedBox(height: 14),
                    Text(
                      Statics.getLabel('TarunVidyaarthiCount') + " " + Statics.getLabel('TarunVidyaarthiCountRange'),
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    SizedBox(height: 8),
                    Row(spacing: 12, children: [
                      Expanded(
                        child: numTextField(
                          controller: _tarunVidhyaarthiCtrl,
                          labelText: Statics.getLabel('Total'),
                          onSaved: (value) {
                            vrutta!.tarunVidyaarthiCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: numTextField(
                          readOnly: _tarunVidhyaarthiCtrl.text.isEmpty,
                          controller: _newtarunVidhyaarthiCtrl,
                          expectedController: _tarunVidhyaarthiCtrl,
                          labelText: Statics.getLabel('newAdmission'),
                          onSaved: (value) {
                            vrutta!.newtarunVidyaarthiCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                      ),
                    ]),
                    SizedBox(height: 14),
                    Text(
                      Statics.getLabel('TarunVyavasaayeeCount') + " " + Statics.getLabel('TarunVyavasaayeeCountRange'),
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    SizedBox(height: 8),
                    Row(spacing: 12, children: [
                      Expanded(
                        child: numTextField(
                          controller: _tarunVyavsaayeeCtrl,
                          labelText: Statics.getLabel('Total'),
                          onSaved: (value) {
                            vrutta!.tarunVyavasaayeeCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: numTextField(
                          readOnly: _tarunVyavsaayeeCtrl.text.isEmpty,
                          controller: _newtarunVyavsaayeeCtrl,
                          expectedController: _tarunVyavsaayeeCtrl,
                          labelText: Statics.getLabel('newAdmission'),
                          onSaved: (value) {
                            vrutta!.newtarunVyavasaayeeCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                      ),
                    ]),
                    SizedBox(height: 14),
                    Text(
                      Statics.getLabel('ProudhaCount') + " " + Statics.getLabel('ProudhaCountRange'),
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    SizedBox(height: 8),
                    Row(spacing: 12, children: [
                      Expanded(
                        child: numTextField(
                          controller: _proudhaCtrl,
                          labelText: Statics.getLabel('Total'),
                          onSaved: (value) {
                            vrutta!.proudhaVyavasaayeeCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: numTextField(
                          readOnly: _proudhaCtrl.text.isEmpty,
                          controller: _newproudhaCtrl,
                          expectedController: _proudhaCtrl,
                          labelText: Statics.getLabel('newAdmission'),
                          onSaved: (value) {
                            vrutta!.newproudhaVyavasaayeeCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                      ),
                    ]),
                    if (_frequency.isNotEmpty && _frequency.firstWhere((e) => e.staticID == frequencyId).code == "Monthly") ...[
                      SizedBox(height: 14),
                      Text(
                        Statics.getLabel('MatrushaktiCount'),
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      SizedBox(height: 8),
                      Row(spacing: 12, children: [
                        Expanded(
                          child: numTextField(
                            controller: _matrushaktiCtrl,
                            labelText: Statics.getLabel('Total'),
                            onSaved: (value) {
                              vrutta!.proudhaVyavasaayeeCount = value == "" ? null : int.parse(value!);
                            },
                          ),
                        ),
                        Expanded(
                          child: numTextField(
                            controller: _newmatrushaktiCtrl,
                            expectedController: _matrushaktiCtrl,
                            labelText: Statics.getLabel('newAdmission'),
                            onSaved: (value) {
                              vrutta!.newproudhaVyavasaayeeCount = value == "" ? null : int.parse(value!);
                            },
                          ),
                        ),
                      ])
                    ],
                    SizedBox(height: 10),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _abhyaagatCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('AbhyaagatCount')),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        vrutta!.abhyaagatCount = value == "" ? null : int.parse(value!);
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _pravasiKaryakartaCountCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('PravasiKaryakartaCount')),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        vrutta!.abhyaagatCount = value == "" ? null : int.parse(value!);
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _anyaPravasiKaryakartaCountCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('AnyaPravasiKaryakartaCount')),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        vrutta!.abhyaagatCount = value == "" ? null : int.parse(value!);
                      },
                    ),
                    SizedBox(height: 10),
                    if (_frequency.isNotEmpty && _frequency.firstWhere((e) => e.staticID == frequencyId).code != "Monthly") ...[
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
                            SizedBox(height: 10),
                          ],
                        )
                      else if (vayogatCode == "Baal")
                        Column(
                          children: [
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.8,
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Text(Statics.getLabel("Minimum5minutesUrdhvapad"), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _isDoneUrdhvapad,
                                onChanged: (value) {
                                  setState(() {
                                    _isDoneUrdhvapad = value!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 10),
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
                            SizedBox(height: 10),
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
                            SizedBox(height: 10),
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
                            SizedBox(height: 10),
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
                      SizedBox(height: 10),
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
                      SizedBox(height: 10),
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
                      SizedBox(height: 10),
                      SizedBox(
                        width: Statics.getDeviceSize(context).width * 0.8,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(Statics.getLabel("BoodhKathaOnceWeek"), style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _isDoneBoodhKatha,
                          onChanged: (value) {
                            setState(() {
                              _isDoneBoodhKatha = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: Statics.getDeviceSize(context).width * 0.8,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(Statics.getLabel("BoudhikDays"), style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _isDoneBoudhikDays,
                          onChanged: (value) {
                            setState(() {
                              _isDoneBoudhikDays = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      if (_isDoneBoudhikDays) ...[
                        buildDropdownField(
                          label: Statics.getLabel('BoudhikDays'),
                          value: _selectedBoudhikDaysId,
                          items: _boudhikDaysList!
                              .map((bg) => DropdownMenuItem(
                                    value: bg?.staticID.toString(),
                                    child: Text(bg?.codeForDisplay ?? "--"),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedBoudhikDaysId = value;
                            });
                            print(_selectedBoudhikDaysId);
                            print(_boudhikDaysList.firstWhere((e) => e?.codeForDisplay == Statics.getLabel("anyaOption"))?.staticID);
                            print(_selectedBoudhikDaysId == _boudhikDaysList.firstWhere((e) => e?.codeForDisplay == Statics.getLabel("anyaOption"))?.staticID.toString());
                          },
                        ),
                        SizedBox(height: 10),
                        if (_selectedBoudhikDaysId == _boudhikDaysList.firstWhere((e) => e?.codeForDisplay == Statics.getLabel("anyaOption"))?.staticID.toString())
                          TextFormField(
                            controller: _anyaBoudhikDaysCtrl,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) => setState(() {}),
                            decoration: InputDecoration(
                              labelText: Statics.getLabel("anyaOption"),
                              labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
                              // fillColor: Colors.grey.shade50,
                              // filled: true,
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(8),
                              //   borderSide: BorderSide.none, // Hide default border
                              // ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Align left of field
                            ),
                            style: const TextStyle(color: Colors.black, fontSize: 14), // Original fields looked greyed out
                          ),
                      ],
                      SizedBox(
                        width: Statics.getDeviceSize(context).width * 0.8,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(Statics.getLabel("SewaDays"), style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _isDoneSewaDays,
                          onChanged: (value) {
                            setState(() {
                              _isDoneSewaDays = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      if (_isDoneSewaDays) ...[
                        MultiSelectDialogField(
                          title: Text(Statics.getLabel('SewaDays')),
                          buttonText: Text(Statics.getLabel('SewaDays')),
                          buttonIcon: Icon(Icons.arrow_drop_down),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                            border: Border.all(color: _sewaDaysList.isEmpty ? Colors.grey.shade400 : Colors.transparent),
                          ),
                          confirmText: Text(
                            Statics.getLabel('Submit'),
                            style: const TextStyle(color: Colors.purple),
                          ),
                          cancelText: Text(
                            Statics.getLabel('clear'),
                            style: const TextStyle(color: Colors.purple),
                          ),
                          searchable: false,
                          listType: MultiSelectListType.LIST,
                          items: _sewaDaysList.map((bg) => MultiSelectItem(bg?.staticID, (bg?.codeForDisplay ?? "--").toString())).toList(),
                          initialValue: _selectedSewaDaysList,
                          chipDisplay: MultiSelectChipDisplay(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.purple, width: 0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              // icon: Icon(Icons.done, color: Colors.purple, size: 16),
                              chipColor: Colors.white,
                              textStyle: TextStyle(fontSize: 12, color: Colors.purple, fontWeight: FontWeight.w500)),
                          // onSaved: (newValue) {},
                          onConfirm: (values) {
                            _selectedSewaDaysList = values.map((e) {
                              // Check if the element is an integer
                              if (e is int) {
                                return e;
                              }
                              // If it's a string, try to parse it
                              else if (e is String) {
                                return int.tryParse(e); // Use tryParse to handle invalid strings and return null
                              }
                              // Otherwise, return null or handle as needed
                              return null;
                            }).toList();
                            print("valueeeeeeeesssss >>>>>>>>>>>>>>> $values");
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 10),
                      ],
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
                      //   height: 10
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
                      //   height: 10
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
                      SizedBox(height: 10),
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
                      SizedBox(height: 10),
                    ],
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _remarkCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('Remarks')),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        vrutta!.remark = value == "" ? null : value;
                      },
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: (_isLoading)
                          ? CircularProgressIndicator()
                          : (widget.viewType == "ViewMenu")
                              ? Text(Statics.getLabel('canNotMakeChanges'))
                              : MaterialButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                                  onPressed: () {
                                    // return;
                                    _submit(context);
                                  },
                                  child: Text(
                                    Statics.getLabel('Submit'),
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                    )
                  ]),
                ),
              ),
            ),
          ),
          inAsyncCall: _isFetchingData),
    );
  }

  Widget numTextField({
    required TextEditingController controller,
    Color? fillColor,
    bool readOnly = false,
    TextEditingController? expectedController,
    required String labelText,
    void Function(String?)? onSaved,
    String? Function(String?)? validator,
  }) {
    if (expectedController != null) {
      expectedController.addListener(() {
        final expected = int.tryParse(expectedController.text) ?? 0;
        final current = int.tryParse(controller.text) ?? 0;

        if (current > expected) {
          controller.clear(); // or controller.text = "0";
        }
      });
    }
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      readOnly: readOnly,
      onSaved: onSaved,
      validator: validator,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
        if (expectedController != null)
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.text.isEmpty) return newValue;

            final int? aValue = int.tryParse(expectedController.text);
            final int? bValue = int.tryParse(newValue.text);

            if (aValue == null || bValue == null) return newValue;

            if (bValue > aValue) {
              return oldValue; // reject input
            }

            return newValue;
          }),
      ],
      onChanged: (value) => setState(() {}),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
        fillColor: fillColor ?? Colors.grey.shade50,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none, // Hide default border
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Align left of field
      ),
      style: const TextStyle(color: Colors.black, fontSize: 14), // Original fields looked greyed out
    );
  }
}
