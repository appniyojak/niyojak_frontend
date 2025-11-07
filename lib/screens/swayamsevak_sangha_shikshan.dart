import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../providers/bals.dart';
import '../providers/swayamsevak_provider.dart';
import '../helpers/static_data.dart' as Statics;

class SwayamsevakSanghaShikshan extends StatefulWidget {
  var swId;
  var onSaveSwDetails;
  var viewType;

  SwayamsevakSanghaShikshan({Key? key, this.swId, this.onSaveSwDetails, this.viewType}) : super(key: key);

  State<StatefulWidget> createState() {
    return new SwayamsevakSanghaShikshanState();
  }
}

class SwayamsevakSanghaShikshanState extends State<SwayamsevakSanghaShikshan> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  bool _isfetingData = false;

  SwayamsevakSanghaShikshanBAL? swSansghaShikshan;

  var _prarambhikYearCntrl = TextEditingController();
  var _praathamikYearCntrl = TextEditingController();
  var _prathamVarshaYearCntrl = TextEditingController();
  var _dwitiyaVarshaYearCntrl = TextEditingController();
  var _trutiyaVarshaYearCntrl = TextEditingController();
  var _yearsAsPraathamikShikshakCntrl = TextEditingController();
  var _yearsAsPrathamVarshaShikshakCtrl = TextEditingController();
  var _yearsAsDwityaVarshaShikshakCtrl = TextEditingController();
  var _yearsAsTrutiyaVarshaShikshakCtrl = TextEditingController();

  bool? _wrkAsShikshak = false;
  bool? _isDwitiyaEligible = false;
  bool? _isTrutiyaEligible = false;

  bool? _isTrainedInMukhyaDanda = false;
  bool? _isTrainedInMukhyaNiyuddha = false;
  bool? _isTrainedInMukhyaPadavinyas = false;
  bool? _isTrainedInMukhyaYogaasan = false;
  bool? _isTrainedInMukhyaYogachaap = false;
  bool? _isTrainedInMukhyaDandaYuddha = false;
  bool? _isTrainedInMukhyaYog = false;

  bool? _isTrainedInAnyaDanda = false;
  bool? _isTrainedInAnyaNiyuddha = false;
  bool? _isTrainedInAnyaPadavinyas = false;
  bool? _isTrainedInAnyaYogaasan = false;
  bool? _isTrainedInAnyaYogachaap = false;
  bool? _isTrainedInAnyaDandaYuddha = false;
  bool? _isTrainedInAnyaYog = false;

  bool? _isMukhyaSharirikVishayExpanded = false;
  bool? _isAnyaSharirikVishayExpanded = false;

  @override
  void initState() {
    super.initState();
    int swID = int.parse(widget.swId);
    if (swID > 0) {
      getSwDetails(widget.swId);
    } else {
      if (!mounted) return;
      setState(() {
        swSansghaShikshan = new SwayamsevakSanghaShikshanBAL(swID, 0, 1, null, null, null, null, null, null, null, null, null);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _prarambhikYearCntrl.dispose();
    _praathamikYearCntrl.dispose();
    _prathamVarshaYearCntrl.dispose();
    _dwitiyaVarshaYearCntrl.dispose();
    _trutiyaVarshaYearCntrl.dispose();
    _yearsAsPraathamikShikshakCntrl.dispose();
    _yearsAsPrathamVarshaShikshakCtrl.dispose();
    _yearsAsDwityaVarshaShikshakCtrl.dispose();
    _yearsAsTrutiyaVarshaShikshakCtrl.dispose();
  }

  void getSwDetails(var theId) async {
    setState(() {
      _isfetingData = true;
    });
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      var data = await SwayamsevakProvider().getSwayamSevakByID(theId, "SanghaShikshanSharirikVishay");
      if (!mounted) return;
      setState(() {
        if (data != null) {
          swSansghaShikshan = data.sanghaShikshan;
          List<ShaaririkVishayBAL> shaaririkLst = data.sharirikVishay;

          if (swSansghaShikshan != null) {
            _prarambhikYearCntrl.text = swSansghaShikshan!.prarambhikYear == null ? "" : swSansghaShikshan!.prarambhikYear.toString();
            _praathamikYearCntrl.text = swSansghaShikshan!.praathamikYear == null ? "" : swSansghaShikshan!.praathamikYear.toString();
            _prathamVarshaYearCntrl.text = swSansghaShikshan!.prathamVarshaYear == null ? "" : swSansghaShikshan!.prathamVarshaYear.toString();
            _dwitiyaVarshaYearCntrl.text = swSansghaShikshan!.dwitiyaVarshaYear == null ? "" : swSansghaShikshan!.dwitiyaVarshaYear.toString();
            _trutiyaVarshaYearCntrl.text = swSansghaShikshan!.trutiyaVarshaYear == null ? "" : swSansghaShikshan!.trutiyaVarshaYear.toString();
            _yearsAsPraathamikShikshakCntrl.text = swSansghaShikshan!.yearsAsPraathamikShikshak == null ? "" : swSansghaShikshan!.yearsAsPraathamikShikshak.toString();
            _yearsAsPrathamVarshaShikshakCtrl.text = swSansghaShikshan!.yearsAsPrathamVarshaShikshak == null ? "" : swSansghaShikshan!.yearsAsPrathamVarshaShikshak.toString();
            _yearsAsDwityaVarshaShikshakCtrl.text = swSansghaShikshan!.yearsAsDwityaVarshaShikshak == null ? "" : swSansghaShikshan!.yearsAsDwityaVarshaShikshak.toString();
            _yearsAsTrutiyaVarshaShikshakCtrl.text = swSansghaShikshan!.yearsAsTrutiyaVarshaShikshak == null ? "" : swSansghaShikshan!.yearsAsTrutiyaVarshaShikshak.toString();
            if (_dwitiyaVarshaYearCntrl.text == "" && _trutiyaVarshaYearCntrl.text == "" && _prarambhikYearCntrl.text == "" && _praathamikYearCntrl.text == "" && _prathamVarshaYearCntrl.text == "") {
              _wrkAsShikshak = false;
            } else {
              _wrkAsShikshak = true;
            }
            _isDwitiyaEligible = _dwitiyaVarshaYearCntrl.text != "" ? true : false;
            _isTrutiyaEligible = _trutiyaVarshaYearCntrl.text != "" ? true : false;
          }

          clearFields();

          if (shaaririkLst.length > 0)
            for (var data in shaaririkLst) {
              if (data.shaaririkVishayCode == "Danda" || data.shaaririkVishayCode == "दंड") {
                if (data.vishayFamiliarity == 1)
                  _isTrainedInMukhyaDanda = true;
                else if (data.vishayFamiliarity == 9)
                  _isTrainedInAnyaDanda = true;
                else
                  _isTrainedInMukhyaDanda = _isTrainedInAnyaDanda = false;
              }

              if (data.shaaririkVishayCode == "Niyuddha" || data.shaaririkVishayCode == "नियुद्ध") {
                if (data.vishayFamiliarity == 1)
                  _isTrainedInMukhyaNiyuddha = true;
                else if (data.vishayFamiliarity == 9)
                  _isTrainedInAnyaNiyuddha = true;
                else
                  _isTrainedInMukhyaNiyuddha = _isTrainedInAnyaNiyuddha = false;
              }

              if (data.shaaririkVishayCode == "Yogaasan" || data.shaaririkVishayCode == "योगासन") {
                if (data.vishayFamiliarity == 1)
                  _isTrainedInMukhyaYogaasan = true;
                else if (data.vishayFamiliarity == 9)
                  _isTrainedInAnyaYogaasan = true;
                else
                  _isTrainedInMukhyaYogaasan = _isTrainedInAnyaYogaasan = false;
              }

              if (data.shaaririkVishayCode == "Yoga-Chaap" || data.shaaririkVishayCode == "योगचाप") {
                if (data.vishayFamiliarity == 1)
                  _isTrainedInMukhyaYogachaap = true;
                else if (data.vishayFamiliarity == 9)
                  _isTrainedInAnyaYogachaap = true;
                else
                  _isTrainedInMukhyaYogachaap = _isTrainedInAnyaYogachaap = false;
              }

              if (data.shaaririkVishayCode == "Pada-Vinyaas" || data.shaaririkVishayCode == "पदविन्यास") {
                if (data.vishayFamiliarity == 1)
                  _isTrainedInMukhyaPadavinyas = true;
                else if (data.vishayFamiliarity == 9)
                  _isTrainedInAnyaPadavinyas = true;
                else
                  _isTrainedInMukhyaPadavinyas = _isTrainedInAnyaPadavinyas = false;
              }

              if (data.shaaririkVishayCode == "Danda-Yuddha" || data.shaaririkVishayCode == "दंड युद्ध") {
                if (data.vishayFamiliarity == 1)
                  _isTrainedInMukhyaDandaYuddha = true;
                else if (data.vishayFamiliarity == 9)
                  _isTrainedInAnyaDandaYuddha = true;
                else
                  _isTrainedInMukhyaDandaYuddha = _isTrainedInAnyaDandaYuddha = false;
              }

              if (data.shaaririkVishayCode == "Yog" || data.shaaririkVishayCode == "योग") {
                if (data.vishayFamiliarity == 1)
                  _isTrainedInMukhyaYog = true;
                else if (data.vishayFamiliarity == 9)
                  _isTrainedInAnyaYog = true;
                else
                  _isTrainedInMukhyaYog = _isTrainedInAnyaYog = false;
              }
            }
        }
      });
    }

    setState(() {
      _isfetingData = false;
    });
  }

  void clearFields() {
    _isTrainedInMukhyaDanda = _isTrainedInAnyaDanda = false;
    _isTrainedInMukhyaNiyuddha = _isTrainedInAnyaNiyuddha = false;
    _isTrainedInMukhyaYogaasan = _isTrainedInAnyaYogaasan = false;
    _isTrainedInMukhyaYogachaap = _isTrainedInAnyaYogachaap = false;
    _isTrainedInMukhyaPadavinyas = _isTrainedInAnyaPadavinyas = false;
    _isTrainedInMukhyaDandaYuddha = _isTrainedInAnyaDandaYuddha = false;
    _isTrainedInMukhyaYog = _isTrainedInAnyaYog = false;
  }

  Future<void> _submit() async {
    print(_isTrainedInMukhyaDanda);
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
    if (_isDwitiyaEligible == true &&
        _isTrainedInMukhyaDanda == false &&
        _isTrainedInMukhyaNiyuddha == false &&
        _isTrainedInMukhyaYogaasan == false &&
        _isTrainedInMukhyaYogachaap == false &&
        _isTrainedInMukhyaPadavinyas == false &&
        _isTrainedInMukhyaDandaYuddha == false &&
        _isTrainedInMukhyaYog == false) return Statics.showMessageDialog(context, Statics.getLabel('PleaseSelectatleastoneMukhyaVishay'));
    String strShaaririkVishay = getShaaririkStr();
    var inputData = '{' +
        '"SanghaShikshan": {' +
        ' "SwayamsevakID": ' +
        int.parse(widget.swId).toString() +
        ',' +
        ' "PraantID": 1,' +
        ' "PrarambhikYear":' +
        (swSansghaShikshan!.prarambhikYear == null ? "null" : swSansghaShikshan!.prarambhikYear.toString()) +
        ',' +
        ' "PraathamikYear":' +
        (swSansghaShikshan!.praathamikYear == null ? "null" : swSansghaShikshan!.praathamikYear.toString()) +
        ',' +
        ' "PrathamVarshaYear":' +
        (swSansghaShikshan!.prathamVarshaYear == null ? "null" : swSansghaShikshan!.prathamVarshaYear.toString()) +
        ',' +
        ' "DwitiyaVarshaYear":' +
        (swSansghaShikshan!.dwitiyaVarshaYear == null ? "null" : swSansghaShikshan!.dwitiyaVarshaYear.toString()) +
        ',' +
        ' "TrutiyaVarshaYear":' +
        (swSansghaShikshan!.trutiyaVarshaYear == null ? "null" : swSansghaShikshan!.trutiyaVarshaYear.toString()) +
        ',' +
        ' "YearsAsPraathamikShikshak":' +
        ((swSansghaShikshan!.yearsAsPraathamikShikshak == null || _isDwitiyaEligible == false || _wrkAsShikshak == false) ? "null" : swSansghaShikshan!.yearsAsPraathamikShikshak.toString()) +
        ',' +
        ' "YearsAsPrathamVarshaShikshak":' +
        ((swSansghaShikshan!.yearsAsPrathamVarshaShikshak == null || _isTrutiyaEligible == false || _wrkAsShikshak == false) ? "null" : swSansghaShikshan!.yearsAsPrathamVarshaShikshak.toString()) +
        ',' +
        ' "YearsAsDwitiyaVarshaShikshak":' +
        ((swSansghaShikshan!.yearsAsDwityaVarshaShikshak == null || _isTrutiyaEligible == false || _wrkAsShikshak == false) ? "null" : swSansghaShikshan!.yearsAsDwityaVarshaShikshak.toString()) +
        ',' +
        ' "YearsAsTrutiyaVarshaShikshak":' +
        ((swSansghaShikshan!.yearsAsTrutiyaVarshaShikshak == null || _isTrutiyaEligible == false || _wrkAsShikshak == false) ? "null" : swSansghaShikshan!.yearsAsTrutiyaVarshaShikshak.toString()) +
        '},' +
        '"ListShaaririkVishay": [' +
        strShaaririkVishay +
        '],' +
        '"ModifiedBy": ' +
        Statics.userDetails["userID"] +
        '}';
    print("saveSwDetails inputData ==> $inputData");
    var data = await SwayamsevakProvider().swayamsevakSanghaShikshanSHaaririkVishayForApp(inputData);
    print("saveSwDetails data ==> $data");

    setState(() {
      widget.swId = data;
      widget.onSaveSwDetails(widget.swId);
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    });
  }

  String getShaaririkStr() {
    String strData = '';

    if (_isTrainedInMukhyaDanda == true)
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "Danda", "VishayFamiliarity": 1 },';
    else if (_isTrainedInAnyaDanda == true)
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "Danda", "VishayFamiliarity": 9 },';
    else
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "Danda", "VishayFamiliarity": null },';

    if (_isTrainedInMukhyaNiyuddha == true)
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "Niyuddha", "VishayFamiliarity": 1 },';
    else if (_isTrainedInAnyaNiyuddha == true)
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "Niyuddha", "VishayFamiliarity": 9 },';
    else
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "Niyuddha", "VishayFamiliarity": null },';

    if (_isTrainedInMukhyaYogaasan == true)
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "Yogaasan", "VishayFamiliarity": 1 },';
    else if (_isTrainedInAnyaYogaasan == true)
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "Yogaasan", "VishayFamiliarity": 9 },';
    else
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "Yogaasan", "VishayFamiliarity": null },';

    if (_isTrainedInMukhyaYogachaap == true)
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "YogaChaap", "VishayFamiliarity": 1 },';
    else if (_isTrainedInAnyaYogachaap == true)
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "YogaChaap", "VishayFamiliarity": 9 },';
    else
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "YogaChaap", "VishayFamiliarity": null },';

    if (_isTrainedInMukhyaPadavinyas == true)
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "PadaVinyaas", "VishayFamiliarity": 1 },';
    else if (_isTrainedInAnyaPadavinyas == true)
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "PadaVinyaas", "VishayFamiliarity": 9 },';
    else
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "PadaVinyaas", "VishayFamiliarity": null },';

    if (_isTrainedInMukhyaDandaYuddha == true)
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "DandaYuddha", "VishayFamiliarity": 1 },';
    else if (_isTrainedInAnyaDandaYuddha == true)
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "DandaYuddha", "VishayFamiliarity": 9 },';
    else
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "DandaYuddha", "VishayFamiliarity": null },';

    if (_isTrainedInMukhyaYog == true)
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "Yog", "VishayFamiliarity": 1 },';
    else if (_isTrainedInAnyaYog == true)
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "Yog", "VishayFamiliarity": 9 },';
    else
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "ShaaririkVishayCode": "Yog", "VishayFamiliarity": null },';

    strData = strData.substring(0, strData.length - 1);
    return strData;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
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
                      controller: _prarambhikYearCntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('PrarambhikVargaYear')),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      validator: (value) {
                        if (value!.isNotEmpty && value.length < 4)
                          return (Statics.getLabel('PrarambhikVargaYearValidationMessage'));
                        else if (value.isNotEmpty && (int.parse(value) > int.parse(DateFormat('yyyy').format(DateTime.now())))) {
                          return (Statics.getLabel('ValidPrarambhikVargaYearValidationMessage'));
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swSansghaShikshan!.prarambhikYear = int.parse(value);
                        else
                          swSansghaShikshan!.prarambhikYear = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _praathamikYearCntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('PraathamikVargaYear')),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      validator: (value) {
                        if (value!.isNotEmpty && value.length < 4)
                          return (Statics.getLabel('PraathamikVargaYearValidationMessage'));
                        else if (value.isNotEmpty && (int.parse(value) > int.parse(DateFormat('yyyy').format(DateTime.now())))) {
                          return (Statics.getLabel('ValidPraathamikVargaYearValidationMessage'));
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swSansghaShikshan!.praathamikYear = int.parse(value);
                        else
                          swSansghaShikshan!.praathamikYear = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _prathamVarshaYearCntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('PrathamVarshaYear')),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      validator: (value) {
                        if (value!.isNotEmpty && value.length < 4)
                          return (Statics.getLabel('PrathamVarshaYearValidationMessage'));
                        else if (value.isNotEmpty && (int.parse(value) > int.parse(DateFormat('yyyy').format(DateTime.now())))) {
                          return (Statics.getLabel('ValidPrathamVarshaYearValidationMessage'));
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swSansghaShikshan!.prathamVarshaYear = int.parse(value);
                        else
                          swSansghaShikshan!.prathamVarshaYear = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _dwitiyaVarshaYearCntrl,
                      onChanged: (value) {
                        setState(() {
                          _isDwitiyaEligible = value != "" ? true : false;
                        });
                      },
                      decoration: InputDecoration(labelText: Statics.getLabel('DwitiyaVarshaYear')),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      validator: (value) {
                        if (value!.isNotEmpty && value.length < 4)
                          return (Statics.getLabel('DwitiyaVarshaYearValidationMessage'));
                        else if (value.isNotEmpty && (int.parse(value) > int.parse(DateFormat('yyyy').format(DateTime.now())))) {
                          return (Statics.getLabel('ValidDwitiyaVarshaYearValidationMessage'));
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swSansghaShikshan!.dwitiyaVarshaYear = int.parse(value);
                        else
                          swSansghaShikshan!.dwitiyaVarshaYear = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _trutiyaVarshaYearCntrl,
                      onChanged: (value) {
                        setState(() {
                          _isTrutiyaEligible = value != "" ? true : false;
                        });
                      },
                      decoration: InputDecoration(labelText: Statics.getLabel('TrutiyaVarshaYear')),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      validator: (value) {
                        if (value!.isNotEmpty && value.length < 4)
                          return (Statics.getLabel('TrutiyaVarshaYearValidationMessage'));
                        else if (value.isNotEmpty && (int.parse(value) > int.parse(DateFormat('yyyy').format(DateTime.now())))) {
                          return (Statics.getLabel('ValidTrutiyaVarshaYearValidationMessage'));
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty)
                          swSansghaShikshan!.trutiyaVarshaYear = int.parse(value);
                        else
                          swSansghaShikshan!.trutiyaVarshaYear = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_isDwitiyaEligible!)
                      CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(Statics.getLabel('WorkedAsShikshakinVarga'), style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _wrkAsShikshak == null ? false : _wrkAsShikshak,
                          onChanged: (value) {
                            setState(() {
                              _wrkAsShikshak = value;
                            });
                          }),
                    if (_wrkAsShikshak == true)
                      Column(
                        children: [
                          if (_isDwitiyaEligible!)
                            Column(
                              children: [
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _yearsAsPraathamikShikshakCntrl,
                                  decoration: InputDecoration(labelText: Statics.getLabel('YearsAsPraathamikShikshak')),
                                  keyboardType: TextInputType.number,
                                  maxLength: 2,
                                  onSaved: (value) {
                                    if (value != null && value.isNotEmpty)
                                      swSansghaShikshan!.yearsAsPraathamikShikshak = int.parse(value);
                                    else
                                      swSansghaShikshan!.yearsAsPraathamikShikshak = null;
                                  },
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          if (_isTrutiyaEligible!)
                            Column(
                              children: [
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _yearsAsPrathamVarshaShikshakCtrl,
                                  decoration: InputDecoration(labelText: Statics.getLabel('YearsAsPrathamShikshak')),
                                  keyboardType: TextInputType.number,
                                  maxLength: 2,
                                  onSaved: (value) {
                                    if (value != null && value.isNotEmpty)
                                      swSansghaShikshan!.yearsAsPrathamVarshaShikshak = int.parse(value);
                                    else
                                      swSansghaShikshan!.yearsAsPrathamVarshaShikshak = null;
                                  },
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _yearsAsDwityaVarshaShikshakCtrl,
                                  decoration: InputDecoration(labelText: Statics.getLabel('YearsAsDwitiyaShikshak')),
                                  keyboardType: TextInputType.number,
                                  maxLength: 2,
                                  onSaved: (value) {
                                    if (value != null && value.isNotEmpty)
                                      swSansghaShikshan!.yearsAsDwityaVarshaShikshak = int.parse(value);
                                    else
                                      swSansghaShikshan!.yearsAsDwityaVarshaShikshak = null;
                                  },
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _yearsAsTrutiyaVarshaShikshakCtrl,
                                  decoration: InputDecoration(labelText: Statics.getLabel('YearsAsTrutiyaShikshak')),
                                  keyboardType: TextInputType.number,
                                  maxLength: 2,
                                  onSaved: (value) {
                                    if (value != null && value.isNotEmpty)
                                      swSansghaShikshan!.yearsAsTrutiyaVarshaShikshak = int.parse(value);
                                    else
                                      swSansghaShikshan!.yearsAsTrutiyaVarshaShikshak = null;
                                  },
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    // if ((_yearsAsPraathamikShikshakCntrl.text != "" ||
                    //         _yearsAsDwityaVarshaShikshakCtrl.text != "" ||
                    //         _yearsAsTrutiyaVarshaShikshakCtrl.text != "" ||
                    //         _yearsAsPrathamVarshaShikshakCtrl.text != "") &&
                    //     _wrkAsShikshak == true &&
                    if (_isDwitiyaEligible == true)
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(5),
                            height: 30,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.purple),
                            child: Center(
                                child: Text(
                              Statics.getLabel('ShaaririkVishay'),
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                            )),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          ExpansionPanelList(
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                _isMukhyaSharirikVishayExpanded = isExpanded;
                              });
                            },
                            children: [
                              ExpansionPanel(
                                headerBuilder: (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text(Statics.getLabel('MukhyaShaaririkVishay')),
                                  );
                                },
                                body: Container(
                                  //margin: EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Wrap(
                                        direction: Axis.horizontal,
                                        spacing: 10,
                                        children: [
                                          SizedBox(
                                            width: Statics.getDeviceSize(context).width * 0.4,
                                            child: AbsorbPointer(
                                              absorbing: _isTrainedInAnyaDanda == true ? true : false,
                                              child: CheckboxListTile(
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                  title: Text(Statics.getLabel('Danda'), style: TextStyle(fontSize: 15)),
                                                  checkColor: Colors.white,
                                                  activeColor: Colors.purple,
                                                  value: _isTrainedInMukhyaDanda == null ? false : _isTrainedInMukhyaDanda,
                                                  controlAffinity: ListTileControlAffinity.leading,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _isTrainedInMukhyaDanda = value;
                                                      _isTrainedInMukhyaNiyuddha = _isTrainedInMukhyaYogaasan =
                                                          _isTrainedInMukhyaYogachaap = _isTrainedInMukhyaPadavinyas = _isTrainedInMukhyaDandaYuddha = _isTrainedInMukhyaYog = false;
                                                    });
                                                  }),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Statics.getDeviceSize(context).width * 0.4,
                                            child: AbsorbPointer(
                                              absorbing: _isTrainedInAnyaNiyuddha == true ? true : false,
                                              child: CheckboxListTile(
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                  title: Text(Statics.getLabel('Niyuddha'), style: TextStyle(fontSize: 15)),
                                                  checkColor: Colors.white,
                                                  activeColor: Colors.purple,
                                                  value: _isTrainedInMukhyaNiyuddha == null ? false : _isTrainedInMukhyaNiyuddha,
                                                  controlAffinity: ListTileControlAffinity.leading,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _isTrainedInMukhyaNiyuddha = value;

                                                      _isTrainedInMukhyaDanda = _isTrainedInMukhyaYogaasan =
                                                          _isTrainedInMukhyaYogachaap = _isTrainedInMukhyaPadavinyas = _isTrainedInMukhyaDandaYuddha = _isTrainedInMukhyaYog = false;
                                                    });
                                                  }),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Statics.getDeviceSize(context).width * 0.4,
                                            child: AbsorbPointer(
                                              absorbing: _isTrainedInAnyaYogaasan == true ? true : false,
                                              child: CheckboxListTile(
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                  title: Text(Statics.getLabel('Yogaasan'), style: TextStyle(fontSize: 15)),
                                                  checkColor: Colors.white,
                                                  activeColor: Colors.purple,
                                                  value: _isTrainedInMukhyaYogaasan == null ? false : _isTrainedInMukhyaYogaasan,
                                                  controlAffinity: ListTileControlAffinity.leading,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _isTrainedInMukhyaYogaasan = value;

                                                      _isTrainedInMukhyaDanda = _isTrainedInMukhyaNiyuddha =
                                                          _isTrainedInMukhyaYogachaap = _isTrainedInMukhyaPadavinyas = _isTrainedInMukhyaDandaYuddha = _isTrainedInMukhyaYog = false;
                                                    });
                                                  }),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Statics.getDeviceSize(context).width * 0.4,
                                            child: AbsorbPointer(
                                              absorbing: _isTrainedInAnyaYogachaap == true ? true : false,
                                              child: CheckboxListTile(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                title: Text(Statics.getLabel('Yogachaap'), style: TextStyle(fontSize: 15)),
                                                checkColor: Colors.white,
                                                activeColor: Colors.purple,
                                                value: _isTrainedInMukhyaYogachaap == null ? false : _isTrainedInMukhyaYogachaap,
                                                controlAffinity: ListTileControlAffinity.leading,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _isTrainedInMukhyaYogachaap = value;

                                                    _isTrainedInMukhyaDanda = _isTrainedInMukhyaNiyuddha =
                                                        _isTrainedInMukhyaYogaasan = _isTrainedInMukhyaPadavinyas = _isTrainedInMukhyaDandaYuddha = _isTrainedInMukhyaYog = false;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Statics.getDeviceSize(context).width * 0.4,
                                            child: AbsorbPointer(
                                              absorbing: _isTrainedInAnyaPadavinyas == true ? true : false,
                                              child: CheckboxListTile(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                title: Text(Statics.getLabel('Padavinyas'), style: TextStyle(fontSize: 15)),
                                                checkColor: Colors.white,
                                                activeColor: Colors.purple,
                                                value: _isTrainedInMukhyaPadavinyas == null ? false : _isTrainedInMukhyaPadavinyas,
                                                controlAffinity: ListTileControlAffinity.leading,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _isTrainedInMukhyaPadavinyas = value;

                                                    _isTrainedInMukhyaDanda = _isTrainedInMukhyaNiyuddha =
                                                        _isTrainedInMukhyaYogaasan = _isTrainedInMukhyaYogachaap = _isTrainedInMukhyaDandaYuddha = _isTrainedInMukhyaYog = false;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Statics.getDeviceSize(context).width * 0.4,
                                            child: AbsorbPointer(
                                              absorbing: _isTrainedInAnyaDandaYuddha == true ? true : false,
                                              child: CheckboxListTile(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                title: Text(Statics.getLabel('DandaYuddha'), style: TextStyle(fontSize: 15)),
                                                checkColor: Colors.white,
                                                activeColor: Colors.purple,
                                                value: _isTrainedInMukhyaDandaYuddha == null ? false : _isTrainedInMukhyaDandaYuddha,
                                                controlAffinity: ListTileControlAffinity.leading,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _isTrainedInMukhyaDandaYuddha = value;

                                                    _isTrainedInMukhyaDanda = _isTrainedInMukhyaNiyuddha =
                                                        _isTrainedInMukhyaYogaasan = _isTrainedInMukhyaYogachaap = _isTrainedInMukhyaPadavinyas = _isTrainedInMukhyaYog = false;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Statics.getDeviceSize(context).width * 0.4,
                                            child: AbsorbPointer(
                                              absorbing: _isTrainedInAnyaYog == true ? true : false,
                                              child: CheckboxListTile(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                title: Text(Statics.getLabel('Yog'), style: TextStyle(fontSize: 15)),
                                                checkColor: Colors.white,
                                                activeColor: Colors.purple,
                                                value: _isTrainedInMukhyaYog == null ? false : _isTrainedInMukhyaYog,
                                                controlAffinity: ListTileControlAffinity.leading,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _isTrainedInMukhyaYog = value;

                                                    _isTrainedInMukhyaDanda = _isTrainedInMukhyaNiyuddha =
                                                        _isTrainedInMukhyaYogaasan = _isTrainedInMukhyaYogachaap = _isTrainedInMukhyaPadavinyas = _isTrainedInMukhyaDandaYuddha = false;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                isExpanded: widget.viewType == "ViewMenu" ? true : _isMukhyaSharirikVishayExpanded!,
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ExpansionPanelList(
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                _isAnyaSharirikVishayExpanded = isExpanded;
                              });
                            },
                            children: [
                              ExpansionPanel(
                                headerBuilder: (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text(Statics.getLabel('AnyaShaaririkVishay')),
                                  );
                                },
                                body: Container(
                                  //margin: EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Wrap(
                                        direction: Axis.horizontal,
                                        spacing: 10,
                                        children: [
                                          SizedBox(
                                            width: Statics.getDeviceSize(context).width * 0.4,
                                            child: AbsorbPointer(
                                              absorbing: _isTrainedInMukhyaDanda == true ? true : false,
                                              child: CheckboxListTile(
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                  title: Text(Statics.getLabel('Danda'), style: TextStyle(fontSize: 15)),
                                                  checkColor: Colors.white,
                                                  activeColor: Colors.purple,
                                                  value: _isTrainedInAnyaDanda == null ? false : _isTrainedInAnyaDanda,
                                                  controlAffinity: ListTileControlAffinity.leading,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _isTrainedInAnyaDanda = value;
                                                    });
                                                  }),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Statics.getDeviceSize(context).width * 0.4,
                                            child: AbsorbPointer(
                                              absorbing: _isTrainedInMukhyaNiyuddha == true ? true : false,
                                              child: CheckboxListTile(
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                  title: Text(Statics.getLabel('Niyuddha'), style: TextStyle(fontSize: 15)),
                                                  checkColor: Colors.white,
                                                  activeColor: Colors.purple,
                                                  value: _isTrainedInAnyaNiyuddha == null ? false : _isTrainedInAnyaNiyuddha,
                                                  controlAffinity: ListTileControlAffinity.leading,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _isTrainedInAnyaNiyuddha = value;
                                                    });
                                                  }),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Statics.getDeviceSize(context).width * 0.4,
                                            child: AbsorbPointer(
                                              absorbing: _isTrainedInMukhyaYogaasan == true ? true : false,
                                              child: CheckboxListTile(
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                  title: Text(Statics.getLabel('Yogaasan'), style: TextStyle(fontSize: 15)),
                                                  checkColor: Colors.white,
                                                  activeColor: Colors.purple,
                                                  value: _isTrainedInAnyaYogaasan == null ? false : _isTrainedInAnyaYogaasan,
                                                  controlAffinity: ListTileControlAffinity.leading,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _isTrainedInAnyaYogaasan = value;
                                                    });
                                                  }),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Statics.getDeviceSize(context).width * 0.4,
                                            child: AbsorbPointer(
                                              absorbing: _isTrainedInMukhyaYogachaap == true ? true : false,
                                              child: CheckboxListTile(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                title: Text(Statics.getLabel('Yogachaap'), style: TextStyle(fontSize: 15)),
                                                checkColor: Colors.white,
                                                activeColor: Colors.purple,
                                                value: _isTrainedInAnyaYogachaap == null ? false : _isTrainedInAnyaYogachaap,
                                                controlAffinity: ListTileControlAffinity.leading,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _isTrainedInAnyaYogachaap = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Statics.getDeviceSize(context).width * 0.4,
                                            child: AbsorbPointer(
                                              absorbing: _isTrainedInMukhyaPadavinyas == true ? true : false,
                                              child: CheckboxListTile(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                title: Text(Statics.getLabel('Padavinyas'), style: TextStyle(fontSize: 15)),
                                                checkColor: Colors.white,
                                                activeColor: Colors.purple,
                                                value: _isTrainedInAnyaPadavinyas == null ? false : _isTrainedInAnyaPadavinyas,
                                                controlAffinity: ListTileControlAffinity.leading,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _isTrainedInAnyaPadavinyas = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Statics.getDeviceSize(context).width * 0.4,
                                            child: AbsorbPointer(
                                              absorbing: _isTrainedInMukhyaDandaYuddha == true ? true : false,
                                              child: CheckboxListTile(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                title: Text(Statics.getLabel('DandaYuddha'), style: TextStyle(fontSize: 15)),
                                                checkColor: Colors.white,
                                                activeColor: Colors.purple,
                                                value: _isTrainedInAnyaDandaYuddha == null ? false : _isTrainedInAnyaDandaYuddha,
                                                controlAffinity: ListTileControlAffinity.leading,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _isTrainedInAnyaDandaYuddha = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Statics.getDeviceSize(context).width * 0.4,
                                            child: AbsorbPointer(
                                              absorbing: _isTrainedInMukhyaYog == true ? true : false,
                                              child: CheckboxListTile(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                title: Text(Statics.getLabel('Yog'), style: TextStyle(fontSize: 15)),
                                                checkColor: Colors.white,
                                                activeColor: Colors.purple,
                                                value: _isTrainedInAnyaYog == null ? false : _isTrainedInAnyaYog,
                                                controlAffinity: ListTileControlAffinity.leading,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _isTrainedInAnyaYog = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                isExpanded: widget.viewType == "ViewMenu" ? true : _isAnyaSharirikVishayExpanded!,
                              ),
                            ],
                          ),
                        ],
                      ),
                    SizedBox(height: 20),
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
          ),
        ),
        inAsyncCall: _isfetingData);
  }
}
