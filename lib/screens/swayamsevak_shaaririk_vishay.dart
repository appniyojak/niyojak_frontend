import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widgets/legend.dart';

import '../providers/swayamsevak_provider.dart';
import '../providers/bals.dart';
import '../helpers/static_data.dart' as Statics;

class SwayamsevakShaaririkVishay extends StatefulWidget {
  var swId;
  var onSaveSwDetails;
  var viewType;

  SwayamsevakShaaririkVishay({Key? key, this.swId, this.onSaveSwDetails, this.viewType}) : super(key: key);

  State<StatefulWidget> createState() {
    return new SwayamsevakShaaririkVishayState();
  }
}

class SwayamsevakShaaririkVishayState extends State<SwayamsevakShaaririkVishay> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  bool _isfetingData = false;

  SwayamsevakSharirikGhoshVishayBAL? swShaarirkiGhoshVishay;

  bool? _isTrainedInPrathamVanshi = false;
  bool? _isTrainedInPrathamVenu = false;
  bool? _isTrainedInPrathamAanak = false;
  bool? _isTrainedInPrathamShankha = false;
  bool? _isTrainedInPrathamNaagaanga = false;
  bool? _isTrainedInPrathamTurya = false;
  bool? _isTrainedInPrathamSwarad = false;
  bool? _isTrainedInPrathamGomukha = false;

  bool? _isTrainedInDwitiyaVanshi = false;
  bool? _isTrainedInDwitiyaVenu = false;
  bool? _isTrainedInDwitiyaAanak = false;
  bool? _isTrainedInDwitiyaShankha = false;
  bool? _isTrainedInDwitiyaNaagaanga = false;
  bool? _isTrainedInDwitiyaTurya = false;
  bool? _isTrainedInDwitiyaSwarad = false;
  bool? _isTrainedInDwitiyaGomukha = false;

  bool? _isTrainedInTrutiyaVanshi = false;
  bool? _isTrainedInTrutiyaVenu = false;
  bool? _isTrainedInTrutiyaAanak = false;
  bool? _isTrainedInTrutiyaShankha = false;
  bool? _isTrainedInTrutiyaNaagaanga = false;
  bool? _isTrainedInTrutiyaTurya = false;
  bool? _isTrainedInTrutiyaSwarad = false;
  bool? _isTrainedInTrutiyaGomukha = false;

  bool? _isTrainedInAnyaVanshi = false;
  bool? _isTrainedInAnyaVenu = false;
  bool? _isTrainedInAnyaAanak = false;
  bool? _isTrainedInAnyaShankha = false;
  bool? _isTrainedInAnyaNaagaanga = false;
  bool? _isTrainedInAnyaTurya = false;
  bool? _isTrainedInAnyaSwarad = false;
  bool? _isTrainedInAnyaGomukha = false;

  bool? _isPrathamVanshiLipi = false;
  bool? _isPrathamVenuLipi = false;
  bool? _isPrathamAanakLipi = false;
  bool? _isPrathamShankhaLipi = false;
  bool? _isPrathamNaagaangaLipi = false;
  bool? _isPrathamTuryaLipi = false;
  bool? _isPrathamSwaradLipi = false;
  bool? _isPrathamGomukhaLipi = false;

  bool? _isDwitiyaVanshiLipi = false;
  bool? _isDwitiyaVenuLipi = false;
  bool? _isDwitiyaAanakLipi = false;
  bool? _isDwitiyaShankhaLipi = false;
  bool? _isDwitiyaNaagaangaLipi = false;
  bool? _isDwitiyaTuryaLipi = false;
  bool? _isDwitiyaSwaradLipi = false;
  bool? _isDwitiyaGomukhaLipi = false;

  bool? _isTrutiyaVanshiLipi = false;
  bool? _isTrutiyaVenuLipi = false;
  bool? _isTrutiyaAanakLipi = false;
  bool? _isTrutiyaShankhaLipi = false;
  bool? _isTrutiyaNaagaangaLipi = false;
  bool? _isTrutiyaTuryaLipi = false;
  bool? _isTrutiyaSwaradLipi = false;
  bool? _isTrutiyaGomukhaLipi = false;

  bool? _isAnyaVanshiLipi = false;
  bool? _isAnyaVenuLipi = false;
  bool? _isAnyaAanakLipi = false;
  bool? _isAnyaShankhaLipi = false;
  bool? _isAnyaNaagaangaLipi = false;
  bool? _isAnyaTuryaLipi = false;
  bool? _isAnyaSwaradLipi = false;
  bool? _isAnyaGomukhaLipi = false;

  bool? _isPrathamGhoshVishayExpanded = false;
  bool? _isDwitiyaGhoshVishayExpanded = false;
  bool? _isTrutiyaGhoshVishayExpanded = false;
  bool? _isAnyaGhoshVishayExpanded = false;

  var _vanshiRachanaaCountPrathamCntrl = TextEditingController();
  var _venuRachanaaCountPrathamCntrl = TextEditingController();
  var _aanakRachanaaCountPrathamCntrl = TextEditingController();
  var _shankhaRachanaaCountPrathamCntrl = TextEditingController();
  var _naagaangRachanaaCountPrathamCntrl = TextEditingController();
  var _turyaRachanaaCountPrathamCtrl = TextEditingController();
  var _swaradaRachanaaCountPrathamCtrl = TextEditingController();
  var _gomukhaRachanaaCountPrathamCtrl = TextEditingController();

  var _vanshiRachanaaCountDwitiyaCntrl = TextEditingController();
  var _venuRachanaaCountDwitiyaCntrl = TextEditingController();
  var _aanakRachanaaCountDwitiyaCntrl = TextEditingController();
  var _shankhaRachanaaCountDwitiyaCntrl = TextEditingController();
  var _naagaangRachanaaCountDwitiyaCntrl = TextEditingController();
  var _turyaRachanaaCountDwitiyaCtrl = TextEditingController();
  var _swaradaRachanaaCountDwitiyaCtrl = TextEditingController();
  var _gomukhaRachanaaCountDwitiyaCtrl = TextEditingController();

  var _vanshiRachanaaCountTrutiyaCntrl = TextEditingController();
  var _venuRachanaaCountTrutiyaCntrl = TextEditingController();
  var _aanakRachanaaCountTrutiyaCntrl = TextEditingController();
  var _shankhaRachanaaCountTrutiyaCntrl = TextEditingController();
  var _naagaangRachanaaCountTrutiyaCntrl = TextEditingController();
  var _turyaRachanaaCountTrutiyaCtrl = TextEditingController();
  var _swaradaRachanaaCountTrutiyaCtrl = TextEditingController();
  var _gomukhaRachanaaCountTrutiyaCtrl = TextEditingController();

  var _vanshiRachanaaCountAnyaCntrl = TextEditingController();
  var _venuRachanaaCountAnyaCntrl = TextEditingController();
  var _aanakRachanaaCountAnyaCntrl = TextEditingController();
  var _shankhaRachanaaCountAnyaCntrl = TextEditingController();
  var _naagaangRachanaaCountAnyaCntrl = TextEditingController();
  var _turyaRachanaaCountAnyaCtrl = TextEditingController();
  var _swaradaRachanaaCountAnyaCtrl = TextEditingController();
  var _gomukhaRachanaaCountAnyaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    int swID = int.parse(widget.swId);
    if (swID > 0) {
      getSwDetails(widget.swId);
    } else {
      if (!mounted) return;
      setState(() {
        swShaarirkiGhoshVishay = new SwayamsevakSharirikGhoshVishayBAL(null, null);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _vanshiRachanaaCountPrathamCntrl.dispose();
    _venuRachanaaCountPrathamCntrl.dispose();
    _aanakRachanaaCountPrathamCntrl.dispose();
    _shankhaRachanaaCountPrathamCntrl.dispose();
    _naagaangRachanaaCountPrathamCntrl.dispose();
    _turyaRachanaaCountPrathamCtrl.dispose();
    _swaradaRachanaaCountPrathamCtrl.dispose();
    _gomukhaRachanaaCountPrathamCtrl.dispose();

    _vanshiRachanaaCountDwitiyaCntrl.dispose();
    _venuRachanaaCountDwitiyaCntrl.dispose();
    _aanakRachanaaCountDwitiyaCntrl.dispose();
    _shankhaRachanaaCountDwitiyaCntrl.dispose();
    _naagaangRachanaaCountDwitiyaCntrl.dispose();
    _turyaRachanaaCountDwitiyaCtrl.dispose();
    _swaradaRachanaaCountDwitiyaCtrl.dispose();
    _gomukhaRachanaaCountDwitiyaCtrl.dispose();

    _vanshiRachanaaCountTrutiyaCntrl.dispose();
    _venuRachanaaCountTrutiyaCntrl.dispose();
    _aanakRachanaaCountTrutiyaCntrl.dispose();
    _shankhaRachanaaCountTrutiyaCntrl.dispose();
    _naagaangRachanaaCountTrutiyaCntrl.dispose();
    _turyaRachanaaCountTrutiyaCtrl.dispose();
    _swaradaRachanaaCountTrutiyaCtrl.dispose();
    _gomukhaRachanaaCountTrutiyaCtrl.dispose();

    _vanshiRachanaaCountAnyaCntrl.dispose();
    _venuRachanaaCountAnyaCntrl.dispose();
    _aanakRachanaaCountAnyaCntrl.dispose();
    _shankhaRachanaaCountAnyaCntrl.dispose();
    _naagaangRachanaaCountAnyaCntrl.dispose();
    _turyaRachanaaCountAnyaCtrl.dispose();
    _swaradaRachanaaCountAnyaCtrl.dispose();
    _gomukhaRachanaaCountAnyaCtrl.dispose();
  }

  void getSwDetails(var theId) async {
    setState(() {
      _isfetingData = true;
    });
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      var data = await SwayamsevakProvider().getSwayamSevakByID(theId, "GhoshVishayInfo");
      if (!mounted) return;
      setState(() {
        swShaarirkiGhoshVishay = data;
        if (swShaarirkiGhoshVishay != null) {
          List<GhoshVishayBAL> ghoshVishayLst = swShaarirkiGhoshVishay!.ghoshVishay!;

          clearFields();

          if (ghoshVishayLst.length > 0) {
            for (var data in ghoshVishayLst) {
              if (data.vaadyaCode == "Venu" || data.vaadyaCode == "वेणु") {
                if (data.vaadyaFamiliarity == 1) {
                  _isTrainedInPrathamVenu = true;
                  _venuRachanaaCountPrathamCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isPrathamVenuLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 2) {
                  _isTrainedInDwitiyaVenu = true;
                  _venuRachanaaCountDwitiyaCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isDwitiyaVenuLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 3) {
                  _isTrainedInTrutiyaVenu = true;
                  _venuRachanaaCountTrutiyaCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isTrutiyaVenuLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 9) {
                  _isTrainedInAnyaVenu = true;
                  _venuRachanaaCountAnyaCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isAnyaVenuLipi = data.isUnderstandLipi;
                } else {
                  _isTrainedInAnyaVenu = _isTrainedInPrathamVenu = _isTrainedInDwitiyaVenu = _isTrainedInTrutiyaVenu = false;
                  _isAnyaVenuLipi = _isPrathamVenuLipi = _isDwitiyaVenuLipi = _isTrutiyaVenuLipi = false;
                  _venuRachanaaCountAnyaCntrl.text = _venuRachanaaCountDwitiyaCntrl.text = _venuRachanaaCountPrathamCntrl.text = _venuRachanaaCountTrutiyaCntrl.text = "";
                }
              }
              print("data.vaadyaCode=====>  ${data.vaadyaCode}");
              if (data.vaadyaCode == "वंशी" || data.vaadyaCode == "Vanshi") {
                if (data.vaadyaFamiliarity == 1) {
                  _isTrainedInPrathamVanshi = true;
                  _vanshiRachanaaCountPrathamCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isPrathamVanshiLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 2) {
                  _isTrainedInDwitiyaVanshi = true;
                  _vanshiRachanaaCountDwitiyaCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isDwitiyaVanshiLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 3) {
                  _isTrainedInTrutiyaVanshi = true;
                  _vanshiRachanaaCountTrutiyaCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isTrutiyaVanshiLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 9) {
                  _isTrainedInAnyaVanshi = true;
                  _vanshiRachanaaCountAnyaCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isAnyaVanshiLipi = data.isUnderstandLipi;
                } else {
                  _isTrainedInAnyaVanshi = _isTrainedInPrathamVanshi = _isTrainedInDwitiyaVanshi = _isTrainedInTrutiyaVanshi = false;
                  _isAnyaVanshiLipi = _isPrathamVanshiLipi = _isDwitiyaVanshiLipi = _isTrutiyaVanshiLipi = false;
                  _vanshiRachanaaCountAnyaCntrl.text = _vanshiRachanaaCountDwitiyaCntrl.text = _vanshiRachanaaCountPrathamCntrl.text = _vanshiRachanaaCountTrutiyaCntrl.text = "";
                }
              }

              if (data.vaadyaCode == "आनक" || data.vaadyaCode == "Aanak") {
                if (data.vaadyaFamiliarity == 1) {
                  _isTrainedInPrathamAanak = true;
                  _aanakRachanaaCountPrathamCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isPrathamAanakLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 2) {
                  _isTrainedInDwitiyaAanak = true;
                  _aanakRachanaaCountDwitiyaCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isDwitiyaAanakLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 3) {
                  _isTrainedInTrutiyaAanak = true;
                  _aanakRachanaaCountTrutiyaCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isTrutiyaAanakLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 9) {
                  _isTrainedInAnyaAanak = true;
                  _aanakRachanaaCountAnyaCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isAnyaAanakLipi = data.isUnderstandLipi;
                } else {
                  _isTrainedInAnyaAanak = _isTrainedInPrathamAanak = _isTrainedInDwitiyaAanak = _isTrainedInTrutiyaAanak = false;
                  _isAnyaAanakLipi = _isPrathamAanakLipi = _isDwitiyaAanakLipi = _isTrutiyaAanakLipi = false;
                  _aanakRachanaaCountAnyaCntrl.text = _aanakRachanaaCountDwitiyaCntrl.text = _aanakRachanaaCountPrathamCntrl.text = _aanakRachanaaCountTrutiyaCntrl.text = "";
                }
              }

              if (data.vaadyaCode == "शंख" || data.vaadyaCode == "Shankha") {
                if (data.vaadyaFamiliarity == 1) {
                  _isTrainedInPrathamShankha = true;
                  _shankhaRachanaaCountPrathamCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isPrathamShankhaLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 2) {
                  _isTrainedInDwitiyaShankha = true;
                  _shankhaRachanaaCountDwitiyaCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isDwitiyaShankhaLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 3) {
                  _isTrainedInTrutiyaShankha = true;
                  _shankhaRachanaaCountTrutiyaCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isTrutiyaShankhaLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 9) {
                  _isTrainedInAnyaShankha = true;
                  _shankhaRachanaaCountAnyaCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isAnyaShankhaLipi = data.isUnderstandLipi;
                } else {
                  _isTrainedInAnyaShankha = _isTrainedInPrathamShankha = _isTrainedInDwitiyaShankha = _isTrainedInTrutiyaShankha = false;
                  _isAnyaShankhaLipi = _isPrathamShankhaLipi = _isDwitiyaShankhaLipi = _isTrutiyaShankhaLipi = false;
                  _shankhaRachanaaCountAnyaCntrl.text = _shankhaRachanaaCountDwitiyaCntrl.text = _shankhaRachanaaCountPrathamCntrl.text = _shankhaRachanaaCountTrutiyaCntrl.text = "";
                }
              }

              if (data.vaadyaCode == "नागांग" || data.vaadyaCode == "Naagaanga") {
                if (data.vaadyaFamiliarity == 1) {
                  _isTrainedInPrathamNaagaanga = true;
                  _naagaangRachanaaCountPrathamCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isPrathamNaagaangaLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 2) {
                  _isTrainedInDwitiyaNaagaanga = true;
                  _naagaangRachanaaCountDwitiyaCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isDwitiyaNaagaangaLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 3) {
                  _isTrainedInTrutiyaNaagaanga = true;
                  _naagaangRachanaaCountTrutiyaCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isTrutiyaNaagaangaLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 9) {
                  _isTrainedInAnyaNaagaanga = true;
                  _naagaangRachanaaCountAnyaCntrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isAnyaNaagaangaLipi = data.isUnderstandLipi;
                } else {
                  _isTrainedInAnyaNaagaanga = _isTrainedInPrathamNaagaanga = _isTrainedInDwitiyaNaagaanga = _isTrainedInTrutiyaNaagaanga = false;
                  _isAnyaNaagaangaLipi = _isPrathamNaagaangaLipi = _isDwitiyaNaagaangaLipi = _isTrutiyaNaagaangaLipi = false;
                  _naagaangRachanaaCountAnyaCntrl.text = _naagaangRachanaaCountDwitiyaCntrl.text = _naagaangRachanaaCountPrathamCntrl.text = _naagaangRachanaaCountTrutiyaCntrl.text = "";
                }
              }

              if (data.vaadyaCode == "तूर्य" || data.vaadyaCode == "Turya") {
                if (data.vaadyaFamiliarity == 1) {
                  _isTrainedInPrathamTurya = true;
                  _turyaRachanaaCountPrathamCtrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isPrathamTuryaLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 2) {
                  _isTrainedInDwitiyaTurya = true;
                  _turyaRachanaaCountDwitiyaCtrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isDwitiyaTuryaLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 3) {
                  _isTrainedInTrutiyaTurya = true;
                  _turyaRachanaaCountTrutiyaCtrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isTrutiyaTuryaLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 9) {
                  _isTrainedInAnyaTurya = true;
                  _turyaRachanaaCountAnyaCtrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isAnyaTuryaLipi = data.isUnderstandLipi;
                } else {
                  _isTrainedInAnyaTurya = _isTrainedInPrathamTurya = _isTrainedInDwitiyaTurya = _isTrainedInTrutiyaTurya = false;
                  _isAnyaTuryaLipi = _isPrathamTuryaLipi = _isDwitiyaTuryaLipi = _isTrutiyaTuryaLipi = false;
                  _turyaRachanaaCountAnyaCtrl.text = _turyaRachanaaCountDwitiyaCtrl.text = _turyaRachanaaCountPrathamCtrl.text = _turyaRachanaaCountTrutiyaCtrl.text = "";
                }
              }

              if (data.vaadyaCode == "स्वरद" || data.vaadyaCode == "Swarada") {
                if (data.vaadyaFamiliarity == 1) {
                  _isTrainedInPrathamSwarad = true;
                  _swaradaRachanaaCountPrathamCtrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isPrathamSwaradLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 2) {
                  _isTrainedInDwitiyaSwarad = true;
                  _swaradaRachanaaCountDwitiyaCtrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isDwitiyaSwaradLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 3) {
                  _isTrainedInTrutiyaSwarad = true;
                  _swaradaRachanaaCountTrutiyaCtrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isTrutiyaSwaradLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 9) {
                  _isTrainedInAnyaSwarad = true;
                  _swaradaRachanaaCountAnyaCtrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isAnyaSwaradLipi = data.isUnderstandLipi;
                } else {
                  _isTrainedInAnyaSwarad = _isTrainedInPrathamSwarad = _isTrainedInDwitiyaSwarad = _isTrainedInTrutiyaSwarad = false;
                  _isAnyaSwaradLipi = _isPrathamSwaradLipi = _isDwitiyaSwaradLipi = _isTrutiyaSwaradLipi = false;
                  _swaradaRachanaaCountAnyaCtrl.text = _swaradaRachanaaCountDwitiyaCtrl.text = _swaradaRachanaaCountPrathamCtrl.text = _swaradaRachanaaCountTrutiyaCtrl.text = "";
                }
              }

              if (data.vaadyaCode == "गोमुख" || data.vaadyaCode == "Gomukha") {
                if (data.vaadyaFamiliarity == 1) {
                  _isTrainedInPrathamGomukha = true;
                  _gomukhaRachanaaCountPrathamCtrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isPrathamGomukhaLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 2) {
                  _isTrainedInDwitiyaGomukha = true;
                  _gomukhaRachanaaCountDwitiyaCtrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isDwitiyaGomukhaLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 3) {
                  _isTrainedInTrutiyaGomukha = true;
                  _gomukhaRachanaaCountTrutiyaCtrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isTrutiyaGomukhaLipi = data.isUnderstandLipi;
                } else if (data.vaadyaFamiliarity == 9) {
                  _isTrainedInAnyaGomukha = true;
                  _gomukhaRachanaaCountAnyaCtrl.text = data.rachanaaCount == null ? "" : data.rachanaaCount.toString();
                  _isAnyaGomukhaLipi = data.isUnderstandLipi;
                } else {
                  _isTrainedInAnyaGomukha = _isTrainedInPrathamGomukha = _isTrainedInDwitiyaGomukha = _isTrainedInTrutiyaGomukha = false;
                  _isAnyaGomukhaLipi = _isPrathamGomukhaLipi = _isDwitiyaGomukhaLipi = _isTrutiyaGomukhaLipi = false;
                  _gomukhaRachanaaCountAnyaCtrl.text = _gomukhaRachanaaCountDwitiyaCtrl.text = _gomukhaRachanaaCountPrathamCtrl.text = _gomukhaRachanaaCountTrutiyaCtrl.text = "";
                }
              }
            }
          }
        }
      });
    }
    setState(() {
      _isfetingData = false;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      Statics.showToast("There are some validation issues. Cannot submit");
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

  void clearFields() {
    _isTrainedInAnyaVenu = _isTrainedInPrathamVenu = _isTrainedInDwitiyaVenu = _isTrainedInTrutiyaVenu = false;
    _isAnyaVenuLipi = _isPrathamVenuLipi = _isDwitiyaVenuLipi = _isTrutiyaVenuLipi = false;
    _venuRachanaaCountAnyaCntrl.text = _venuRachanaaCountDwitiyaCntrl.text = _venuRachanaaCountPrathamCntrl.text = _venuRachanaaCountTrutiyaCntrl.text = "";

    _isTrainedInAnyaVanshi = _isTrainedInPrathamVanshi = _isTrainedInDwitiyaVanshi = _isTrainedInTrutiyaVanshi = false;
    _isAnyaVanshiLipi = _isPrathamVanshiLipi = _isDwitiyaVanshiLipi = _isTrutiyaVanshiLipi = false;
    _vanshiRachanaaCountAnyaCntrl.text = _vanshiRachanaaCountDwitiyaCntrl.text = _vanshiRachanaaCountPrathamCntrl.text = _vanshiRachanaaCountTrutiyaCntrl.text = "";

    _isTrainedInAnyaAanak = _isTrainedInPrathamAanak = _isTrainedInDwitiyaAanak = _isTrainedInTrutiyaAanak = false;
    _isAnyaAanakLipi = _isPrathamAanakLipi = _isDwitiyaAanakLipi = _isTrutiyaAanakLipi = false;
    _aanakRachanaaCountAnyaCntrl.text = _aanakRachanaaCountDwitiyaCntrl.text = _aanakRachanaaCountPrathamCntrl.text = _aanakRachanaaCountTrutiyaCntrl.text = "";

    _isTrainedInAnyaShankha = _isTrainedInPrathamShankha = _isTrainedInDwitiyaShankha = _isTrainedInTrutiyaShankha = false;
    _isAnyaShankhaLipi = _isPrathamShankhaLipi = _isDwitiyaShankhaLipi = _isTrutiyaShankhaLipi = false;
    _shankhaRachanaaCountAnyaCntrl.text = _shankhaRachanaaCountDwitiyaCntrl.text = _shankhaRachanaaCountPrathamCntrl.text = _shankhaRachanaaCountTrutiyaCntrl.text = "";

    _isTrainedInAnyaNaagaanga = _isTrainedInPrathamNaagaanga = _isTrainedInDwitiyaNaagaanga = _isTrainedInTrutiyaNaagaanga = false;
    _isAnyaNaagaangaLipi = _isPrathamNaagaangaLipi = _isDwitiyaNaagaangaLipi = _isTrutiyaNaagaangaLipi = false;
    _naagaangRachanaaCountAnyaCntrl.text = _naagaangRachanaaCountDwitiyaCntrl.text = _naagaangRachanaaCountPrathamCntrl.text = _naagaangRachanaaCountTrutiyaCntrl.text = "";

    _isTrainedInAnyaTurya = _isTrainedInPrathamTurya = _isTrainedInDwitiyaTurya = _isTrainedInTrutiyaTurya = false;
    _isAnyaTuryaLipi = _isPrathamTuryaLipi = _isDwitiyaTuryaLipi = _isTrutiyaTuryaLipi = false;
    _turyaRachanaaCountAnyaCtrl.text = _turyaRachanaaCountDwitiyaCtrl.text = _turyaRachanaaCountPrathamCtrl.text = _turyaRachanaaCountTrutiyaCtrl.text = "";

    _isTrainedInAnyaSwarad = _isTrainedInPrathamSwarad = _isTrainedInDwitiyaSwarad = _isTrainedInTrutiyaSwarad = false;
    _isAnyaSwaradLipi = _isPrathamSwaradLipi = _isDwitiyaSwaradLipi = _isTrutiyaSwaradLipi = false;
    _swaradaRachanaaCountAnyaCtrl.text = _swaradaRachanaaCountDwitiyaCtrl.text = _swaradaRachanaaCountPrathamCtrl.text = _swaradaRachanaaCountTrutiyaCtrl.text = "";

    _isTrainedInAnyaGomukha = _isTrainedInPrathamGomukha = _isTrainedInDwitiyaGomukha = _isTrainedInTrutiyaGomukha = false;
    _isAnyaGomukhaLipi = _isPrathamGomukhaLipi = _isDwitiyaVenuLipi = _isTrutiyaGomukhaLipi = false;
    _gomukhaRachanaaCountAnyaCtrl.text = _gomukhaRachanaaCountDwitiyaCtrl.text = _gomukhaRachanaaCountPrathamCtrl.text = _gomukhaRachanaaCountTrutiyaCtrl.text = "";
  }

  saveSwDetails() async {
    String strGhoshVishay = getGhoshStr();

    if (strGhoshVishay == "") {
      Statics.showErrorDialog(context, "Please enter details to be saved");
      return;
    }

    var inputData = '{' + '"ListGhoshVishay":[' + strGhoshVishay + ']' + ',"ModifiedBy":' + Statics.userDetails["userID"] + '}';
    //print(inputData);
    var data = await SwayamsevakProvider().saveSwayamsevakGhoshForApp(inputData);
    setState(() {
      widget.swId = data;
      widget.onSaveSwDetails(widget.swId);
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    });
  }

  String getGhoshStr() {
    String strData = '';
    if (_isTrainedInPrathamVanshi == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Vanshi", "VaadyaFamiliarity": 1, "RachanaaCount": ' +
          _vanshiRachanaaCountPrathamCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isPrathamVanshiLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInDwitiyaVanshi == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Vanshi", "VaadyaFamiliarity": 2, "RachanaaCount": ' +
          _vanshiRachanaaCountDwitiyaCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isDwitiyaVanshiLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInTrutiyaVanshi == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Vanshi", "VaadyaFamiliarity": 3, "RachanaaCount": ' +
          _vanshiRachanaaCountTrutiyaCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isTrutiyaVanshiLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInAnyaVanshi == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Vanshi", "VaadyaFamiliarity": 9, "RachanaaCount": ' +
          _vanshiRachanaaCountAnyaCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isAnyaVanshiLipi == true ? "true" : "false") +
          ' },';
    else
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "VaadyaCode": "Vanshi", "VaadyaFamiliarity": null, "RachanaaCount": null, "IsUnderstandLipi": null },';

    if (_isTrainedInPrathamVenu == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Venu", "VaadyaFamiliarity": 1, "RachanaaCount": ' +
          _venuRachanaaCountPrathamCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isPrathamVenuLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInDwitiyaVenu == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Venu", "VaadyaFamiliarity": 2, "RachanaaCount": ' +
          _venuRachanaaCountDwitiyaCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isDwitiyaVenuLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInTrutiyaVenu == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Venu", "VaadyaFamiliarity": 3, "RachanaaCount": ' +
          _venuRachanaaCountTrutiyaCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isTrutiyaVenuLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInAnyaVenu == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Venu", "VaadyaFamiliarity": 9, "RachanaaCount": ' +
          _venuRachanaaCountAnyaCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isAnyaVenuLipi == true ? "true" : "false") +
          ' },';
    else
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "VaadyaCode": "Venu", "VaadyaFamiliarity": null, "RachanaaCount": null, "IsUnderstandLipi": null },';

    if (_isTrainedInPrathamAanak == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Aanak", "VaadyaFamiliarity": 1, "RachanaaCount": ' +
          _aanakRachanaaCountPrathamCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isPrathamAanakLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInDwitiyaAanak == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Aanak", "VaadyaFamiliarity": 2, "RachanaaCount": ' +
          _aanakRachanaaCountDwitiyaCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isDwitiyaAanakLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInTrutiyaAanak == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Aanak", "VaadyaFamiliarity": 3, "RachanaaCount": ' +
          _aanakRachanaaCountTrutiyaCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isTrutiyaAanakLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInAnyaAanak == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Aanak", "VaadyaFamiliarity": 9, "RachanaaCount": ' +
          _aanakRachanaaCountAnyaCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isAnyaAanakLipi == true ? "true" : "false") +
          ' },';
    else
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "VaadyaCode": "Aanak", "VaadyaFamiliarity": null, "RachanaaCount": null, "IsUnderstandLipi": null },';

    if (_isTrainedInPrathamShankha == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Shankha", "VaadyaFamiliarity": 1, "RachanaaCount": ' +
          _shankhaRachanaaCountPrathamCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isPrathamShankhaLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInDwitiyaShankha == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Shankha", "VaadyaFamiliarity": 2, "RachanaaCount": ' +
          _shankhaRachanaaCountDwitiyaCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isDwitiyaShankhaLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInTrutiyaShankha == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Shankha", "VaadyaFamiliarity": 3, "RachanaaCount": ' +
          _shankhaRachanaaCountTrutiyaCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isTrutiyaShankhaLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInAnyaShankha == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Shankha", "VaadyaFamiliarity": 9, "RachanaaCount": ' +
          _shankhaRachanaaCountAnyaCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isAnyaShankhaLipi == true ? "true" : "false") +
          ' },';
    else
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "VaadyaCode": "Shankha", "VaadyaFamiliarity": null, "RachanaaCount": null, "IsUnderstandLipi": null },';

    if (_isTrainedInPrathamNaagaanga == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Naagaanga", "VaadyaFamiliarity": 1, "RachanaaCount": ' +
          _naagaangRachanaaCountPrathamCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isPrathamVanshiLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInDwitiyaNaagaanga == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Naagaanga", "VaadyaFamiliarity": 2, "RachanaaCount": ' +
          _naagaangRachanaaCountDwitiyaCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isDwitiyaNaagaangaLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInTrutiyaNaagaanga == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Naagaanga", "VaadyaFamiliarity": 3, "RachanaaCount": ' +
          _naagaangRachanaaCountTrutiyaCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isTrutiyaNaagaangaLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInAnyaNaagaanga == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Naagaanga", "VaadyaFamiliarity": 9, "RachanaaCount": ' +
          _naagaangRachanaaCountAnyaCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isAnyaNaagaangaLipi == true ? "true" : "false") +
          ' },';
    else
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "VaadyaCode": "Naagaanga", "VaadyaFamiliarity": null, "RachanaaCount": null, "IsUnderstandLipi": null },';

    if (_isTrainedInPrathamTurya == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Turya", "VaadyaFamiliarity": 1, "RachanaaCount": ' +
          _turyaRachanaaCountPrathamCtrl.text +
          ', "IsUnderstandLipi": ' +
          (_isPrathamTuryaLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInDwitiyaTurya == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Turya", "VaadyaFamiliarity": 2, "RachanaaCount": ' +
          _turyaRachanaaCountDwitiyaCtrl.text +
          ', "IsUnderstandLipi": ' +
          (_isDwitiyaTuryaLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInTrutiyaTurya == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Turya", "VaadyaFamiliarity": 3, "RachanaaCount": ' +
          _turyaRachanaaCountTrutiyaCtrl.text +
          ', "IsUnderstandLipi": ' +
          (_isTrutiyaTuryaLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInAnyaTurya == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Turya", "VaadyaFamiliarity": 9, "RachanaaCount": ' +
          _turyaRachanaaCountAnyaCtrl.text +
          ', "IsUnderstandLipi": ' +
          (_isAnyaTuryaLipi == true ? "true" : "false") +
          ' },';
    else
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "VaadyaCode": "Turya", "VaadyaFamiliarity": null, "RachanaaCount": null, "IsUnderstandLipi": null },';

    if (_isTrainedInPrathamSwarad == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Swarada", "VaadyaFamiliarity": 1, "RachanaaCount": ' +
          _swaradaRachanaaCountPrathamCtrl.text +
          ', "IsUnderstandLipi": ' +
          (_isPrathamSwaradLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInDwitiyaSwarad == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Swarada", "VaadyaFamiliarity": 2, "RachanaaCount": ' +
          _swaradaRachanaaCountDwitiyaCtrl.text +
          ', "IsUnderstandLipi": ' +
          (_isDwitiyaSwaradLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInTrutiyaSwarad == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Swarada", "VaadyaFamiliarity": 3, "RachanaaCount": ' +
          _swaradaRachanaaCountTrutiyaCtrl.text +
          ', "IsUnderstandLipi": ' +
          (_isTrutiyaSwaradLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInAnyaSwarad == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Swarada", "VaadyaFamiliarity": 9, "RachanaaCount": ' +
          _swaradaRachanaaCountAnyaCtrl.text +
          ', "IsUnderstandLipi": ' +
          (_isAnyaSwaradLipi == true ? "true" : "false") +
          ' },';
    else
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "VaadyaCode": "Swarada", "VaadyaFamiliarity": null, "RachanaaCount": null, "IsUnderstandLipi": null },';

    if (_isTrainedInPrathamGomukha == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Gomukha", "VaadyaFamiliarity": 1, "RachanaaCount": ' +
          _vanshiRachanaaCountPrathamCntrl.text +
          ', "IsUnderstandLipi": ' +
          (_isPrathamGomukhaLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInDwitiyaGomukha == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Gomukha", "VaadyaFamiliarity": 2, "RachanaaCount": ' +
          _gomukhaRachanaaCountDwitiyaCtrl.text +
          ', "IsUnderstandLipi": ' +
          (_isDwitiyaGomukhaLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInTrutiyaGomukha == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Gomukha", "VaadyaFamiliarity": 3, "RachanaaCount": ' +
          _gomukhaRachanaaCountTrutiyaCtrl.text +
          ', "IsUnderstandLipi": ' +
          (_isTrutiyaGomukhaLipi == true ? "true" : "false") +
          ' },';
    else if (_isTrainedInAnyaGomukha == true)
      strData += '{"SwayamsevakID": ' +
          widget.swId +
          ', "PraantID": 1, "VaadyaCode": "Gomukha", "VaadyaFamiliarity": 9, "RachanaaCount": ' +
          _gomukhaRachanaaCountAnyaCtrl.text +
          ', "IsUnderstandLipi": ' +
          (_isAnyaGomukhaLipi == true ? "true" : "false") +
          ' },';
    else
      strData += '{"SwayamsevakID": ' + widget.swId + ', "PraantID": 1, "VaadyaCode": "Gomukha", "VaadyaFamiliarity": null, "RachanaaCount": null, "IsUnderstandLipi": null },';

    strData = strData.substring(0, strData.length - 1);
    return strData;
  }

  void setFieldsbyType(String type, String vaadyaType) {
    setState(() {
      if (type == "Pratham") {
        if (vaadyaType != "Vanshi") {
          _isTrainedInPrathamVanshi = _isPrathamVanshiLipi = false;
          _vanshiRachanaaCountPrathamCntrl.text = "";
        }

        if (vaadyaType != "Venu") {
          _isTrainedInPrathamVenu = _isPrathamVenuLipi = false;
          _venuRachanaaCountPrathamCntrl.text = "";
        }

        if (vaadyaType != "Aanak") {
          _isTrainedInPrathamAanak = _isPrathamAanakLipi = false;
          _aanakRachanaaCountPrathamCntrl.text = "";
        }
        if (vaadyaType != "Shankha") {
          _isTrainedInPrathamShankha = _isPrathamShankhaLipi = false;
          _shankhaRachanaaCountPrathamCntrl.text = "";
        }
        if (vaadyaType != "Naagaanga") {
          _isTrainedInPrathamNaagaanga = _isPrathamNaagaangaLipi = false;
          _naagaangRachanaaCountPrathamCntrl.text = "";
        }
        if (vaadyaType != "Turya") {
          _isTrainedInPrathamTurya = _isPrathamTuryaLipi = false;
          _turyaRachanaaCountPrathamCtrl.text = "";
        }
        if (vaadyaType != "Swarad") {
          _isTrainedInPrathamSwarad = _isPrathamSwaradLipi = false;
          _swaradaRachanaaCountPrathamCtrl.text = "";
        }
        if (vaadyaType != "Gomukha") {
          _isTrainedInPrathamGomukha = _isPrathamGomukhaLipi = false;
          _gomukhaRachanaaCountPrathamCtrl.text = "";
        }
      } else if (type == "Dwitiya") {
        if (vaadyaType != "Vanshi") {
          _isTrainedInDwitiyaVanshi = _isDwitiyaVanshiLipi = false;
          _vanshiRachanaaCountDwitiyaCntrl.text = "";
        }

        if (vaadyaType != "Venu") {
          _isTrainedInDwitiyaVenu = _isDwitiyaVenuLipi = false;
          _venuRachanaaCountDwitiyaCntrl.text = "";
        }

        if (vaadyaType != "Aanak") {
          _isTrainedInDwitiyaAanak = _isDwitiyaAanakLipi = false;
          _aanakRachanaaCountDwitiyaCntrl.text = "";
        }
        if (vaadyaType != "Shankha") {
          _isTrainedInDwitiyaShankha = _isDwitiyaShankhaLipi = false;
          _shankhaRachanaaCountDwitiyaCntrl.text = "";
        }
        if (vaadyaType != "Naagaanga") {
          _isTrainedInDwitiyaNaagaanga = _isDwitiyaNaagaangaLipi = false;
          _naagaangRachanaaCountDwitiyaCntrl.text = "";
        }
        if (vaadyaType != "Turya") {
          _isTrainedInDwitiyaTurya = _isDwitiyaTuryaLipi = false;
          _turyaRachanaaCountDwitiyaCtrl.text = "";
        }
        if (vaadyaType != "Swarad") {
          _isTrainedInDwitiyaSwarad = _isDwitiyaSwaradLipi = false;
          _swaradaRachanaaCountDwitiyaCtrl.text = "";
        }
        if (vaadyaType != "Gomukha") {
          _isTrainedInDwitiyaGomukha = _isDwitiyaGomukhaLipi = false;
          _gomukhaRachanaaCountDwitiyaCtrl.text = "";
        }
      } else if (type == "Trutiya") {
        if (vaadyaType != "Vanshi") {
          _isTrainedInTrutiyaVanshi = _isTrutiyaVanshiLipi = false;
          _vanshiRachanaaCountTrutiyaCntrl.text = "";
        }

        if (vaadyaType != "Venu") {
          _isTrainedInTrutiyaVenu = _isTrutiyaVenuLipi = false;
          _venuRachanaaCountTrutiyaCntrl.text = "";
        }

        if (vaadyaType != "Aanak") {
          _isTrainedInTrutiyaAanak = _isTrutiyaAanakLipi = false;
          _aanakRachanaaCountTrutiyaCntrl.text = "";
        }
        if (vaadyaType != "Shankha") {
          _isTrainedInTrutiyaShankha = _isTrutiyaShankhaLipi = false;
          _shankhaRachanaaCountTrutiyaCntrl.text = "";
        }
        if (vaadyaType != "Naagaanga") {
          _isTrainedInTrutiyaNaagaanga = _isTrutiyaNaagaangaLipi = false;
          _naagaangRachanaaCountTrutiyaCntrl.text = "";
        }
        if (vaadyaType != "Turya") {
          _isTrainedInTrutiyaTurya = _isTrutiyaTuryaLipi = false;
          _turyaRachanaaCountTrutiyaCtrl.text = "";
        }
        if (vaadyaType != "Swarad") {
          _isTrainedInTrutiyaSwarad = _isTrutiyaSwaradLipi = false;
          _swaradaRachanaaCountTrutiyaCtrl.text = "";
        }
        if (vaadyaType != "Gomukha") {
          _isTrainedInTrutiyaGomukha = _isTrutiyaGomukhaLipi = false;
          _gomukhaRachanaaCountTrutiyaCtrl.text = "";
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
            width: Statics.getDeviceSize(context).width,
            padding: EdgeInsets.all(10),
            child: AbsorbPointer(
              absorbing: widget.viewType == "ViewMenu" ? true : false,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Legend(legendString: 'GhoshVishay', fontsize: 18),
                    ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          _isPrathamGhoshVishayExpanded = isExpanded;
                        });
                      },
                      children: [
                        ExpansionPanel(
                          headerBuilder: (BuildContext context, bool isExpanded) {
                            return ListTile(
                              title: Text(Statics.getLabel('GhoshPrathamVaadya')),
                            );
                          },
                          body: Container(
                            //margin: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Wrap(
                                  direction: Axis.horizontal,
                                  spacing: 5,
                                  children: [
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInDwitiyaVanshi == true || _isTrainedInTrutiyaVanshi == true || _isTrainedInAnyaVanshi == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Vanshi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInPrathamVanshi == null ? false : _isTrainedInPrathamVanshi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInPrathamVanshi = value;
                                              setFieldsbyType("Pratham", "Vanshi");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _vanshiRachanaaCountPrathamCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('VanshiRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInPrathamVanshi == null ? false : _isTrainedInPrathamVanshi,
                                        validator: (value) {
                                          if (_isTrainedInPrathamVanshi != null && (_isTrainedInPrathamVanshi! && value!.isEmpty)) return (Statics.getLabel('VanshiValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _vanshiRachanaaCountPrathamCntrl.text = value;
                                          else
                                            _vanshiRachanaaCountPrathamCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInPrathamVanshi!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isPrathamVanshiLipi == null ? false : _isPrathamVanshiLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isPrathamVanshiLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInDwitiyaVenu == true || _isTrainedInTrutiyaVenu == true || _isTrainedInAnyaVenu == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Venu') + '               ', style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInPrathamVenu == null ? false : _isTrainedInPrathamVenu,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInPrathamVenu = value;
                                              setFieldsbyType("Pratham", "Venu");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _venuRachanaaCountPrathamCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('VenuRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInPrathamVenu == null ? false : _isTrainedInPrathamVenu,
                                        validator: (value) {
                                          if (_isTrainedInPrathamVenu != null && (_isTrainedInPrathamVenu! && value!.isEmpty)) return (Statics.getLabel('VenuValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _venuRachanaaCountPrathamCntrl.text = value;
                                          else
                                            _venuRachanaaCountPrathamCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInPrathamVenu!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isPrathamVenuLipi == null ? false : _isPrathamVenuLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isPrathamVenuLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInDwitiyaAanak == true || _isTrainedInTrutiyaAanak == true || _isTrainedInAnyaAanak == true) ? true : false,
                                        child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Aanak'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInPrathamAanak == null ? false : _isTrainedInPrathamAanak,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInPrathamAanak = value;
                                                setFieldsbyType("Pratham", "Aanak");
                                              });
                                            }),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _aanakRachanaaCountPrathamCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('AanakRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInPrathamAanak == null ? false : _isTrainedInPrathamAanak,
                                        validator: (value) {
                                          if (_isTrainedInPrathamAanak != null && (_isTrainedInPrathamAanak! && value!.isEmpty)) return (Statics.getLabel('AanakValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _aanakRachanaaCountPrathamCntrl.text = value;
                                          else
                                            _aanakRachanaaCountPrathamCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInPrathamAanak!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isPrathamAanakLipi == null ? false : _isPrathamAanakLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isPrathamAanakLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInDwitiyaShankha == true || _isTrainedInTrutiyaShankha == true || _isTrainedInAnyaShankha == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Shankha'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInPrathamShankha == null ? false : _isTrainedInPrathamShankha,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInPrathamShankha = value;
                                              setFieldsbyType("Pratham", "Shankha");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _shankhaRachanaaCountPrathamCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('ShankhaRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInPrathamShankha == null ? false : _isTrainedInPrathamShankha,
                                        validator: (value) {
                                          if (_isTrainedInPrathamShankha != null && (_isTrainedInPrathamShankha! && value!.isEmpty)) return (Statics.getLabel('ShankhaValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _shankhaRachanaaCountPrathamCntrl.text = value;
                                          else
                                            _shankhaRachanaaCountPrathamCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInPrathamShankha!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isPrathamShankhaLipi == null ? false : _isPrathamShankhaLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isPrathamShankhaLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInDwitiyaNaagaanga == true || _isTrainedInTrutiyaNaagaanga == true || _isTrainedInAnyaNaagaanga == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Naagaanga'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInPrathamNaagaanga == null ? false : _isTrainedInPrathamNaagaanga,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInPrathamNaagaanga = value;
                                              setFieldsbyType("Pratham", "Naagaanga");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _naagaangRachanaaCountPrathamCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('NaagaangaRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInPrathamNaagaanga == null ? false : _isTrainedInPrathamNaagaanga,
                                        validator: (value) {
                                          if (_isTrainedInPrathamNaagaanga != null && (_isTrainedInPrathamNaagaanga! && value!.isEmpty)) return (Statics.getLabel('NaagaangaValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _naagaangRachanaaCountPrathamCntrl.text = value;
                                          else
                                            _naagaangRachanaaCountPrathamCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInPrathamNaagaanga!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isPrathamNaagaangaLipi == null ? false : _isPrathamNaagaangaLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isPrathamNaagaangaLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInDwitiyaTurya == true || _isTrainedInTrutiyaTurya == true || _isTrainedInAnyaTurya == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Turya'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInPrathamTurya == null ? false : _isTrainedInPrathamTurya,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInPrathamTurya = value;
                                              setFieldsbyType("Pratham", "Turya");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _turyaRachanaaCountPrathamCtrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('TuryaRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInPrathamTurya == null ? false : _isTrainedInPrathamTurya,
                                        validator: (value) {
                                          if (_isTrainedInPrathamTurya != null && (_isTrainedInPrathamTurya! && value!.isEmpty)) return (Statics.getLabel('TuryaValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _turyaRachanaaCountPrathamCtrl.text = value;
                                          else
                                            _turyaRachanaaCountPrathamCtrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInPrathamTurya!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isPrathamTuryaLipi == null ? false : _isPrathamTuryaLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isPrathamTuryaLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInDwitiyaSwarad == true || _isTrainedInTrutiyaSwarad == true || _isTrainedInAnyaSwarad == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Swarad'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInPrathamSwarad == null ? false : _isTrainedInPrathamSwarad,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInPrathamSwarad = value;
                                              setFieldsbyType("Pratham", "Swarad");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _swaradaRachanaaCountPrathamCtrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('SwaradRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInPrathamSwarad == null ? false : _isTrainedInPrathamSwarad,
                                        validator: (value) {
                                          if (_isTrainedInPrathamSwarad != null && (_isTrainedInPrathamSwarad! && value!.isEmpty)) return (Statics.getLabel('SwaradValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _swaradaRachanaaCountPrathamCtrl.text = value;
                                          else
                                            _swaradaRachanaaCountPrathamCtrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInPrathamSwarad!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isPrathamSwaradLipi == null ? false : _isPrathamSwaradLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isPrathamSwaradLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInDwitiyaGomukha == true || _isTrainedInTrutiyaGomukha == true || _isTrainedInAnyaGomukha == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Gomukha') + '      ', style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInPrathamGomukha == null ? false : _isTrainedInPrathamGomukha,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInPrathamGomukha = value;
                                              setFieldsbyType("Pratham", "Gomukha");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _gomukhaRachanaaCountPrathamCtrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('GomukhaRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInPrathamGomukha == null ? false : _isTrainedInPrathamGomukha,
                                        validator: (value) {
                                          if (_isTrainedInPrathamGomukha != null && (_isTrainedInPrathamGomukha! && value!.isEmpty)) return (Statics.getLabel('GomukhaValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _gomukhaRachanaaCountPrathamCtrl.text = value;
                                          else
                                            _gomukhaRachanaaCountPrathamCtrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInPrathamGomukha!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isPrathamGomukhaLipi == null ? false : _isPrathamGomukhaLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isPrathamGomukhaLipi = value;
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
                          isExpanded: widget.viewType == "ViewMenu" ? true : _isPrathamGhoshVishayExpanded!,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          _isDwitiyaGhoshVishayExpanded = isExpanded;
                        });
                      },
                      children: [
                        ExpansionPanel(
                          headerBuilder: (BuildContext context, bool isExpanded) {
                            return ListTile(
                              title: Text(Statics.getLabel('GhoshDwitiyaVaadya')),
                            );
                          },
                          body: Container(
                            //margin: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Wrap(
                                  direction: Axis.horizontal,
                                  spacing: 5,
                                  children: [
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamVanshi == true || _isTrainedInTrutiyaVanshi == true || _isTrainedInAnyaVanshi == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Vanshi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInDwitiyaVanshi == null ? false : _isTrainedInDwitiyaVanshi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInDwitiyaVanshi = value;
                                              setFieldsbyType("Dwitiya", "Vanshi");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _vanshiRachanaaCountDwitiyaCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('VanshiRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInDwitiyaVanshi == null ? false : _isTrainedInDwitiyaVanshi,
                                        validator: (value) {
                                          if (_isTrainedInDwitiyaVanshi != null && (_isTrainedInDwitiyaVanshi! && value!.isEmpty)) return (Statics.getLabel('VanshiValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _vanshiRachanaaCountDwitiyaCntrl.text = value;
                                          else
                                            _vanshiRachanaaCountDwitiyaCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInDwitiyaVanshi!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isDwitiyaVanshiLipi == null ? false : _isDwitiyaVanshiLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isDwitiyaVanshiLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamVenu == true || _isTrainedInTrutiyaVenu == true || _isTrainedInAnyaVenu == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Venu') + '               ', style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInDwitiyaVenu == null ? false : _isTrainedInDwitiyaVenu,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInDwitiyaVenu = value;
                                              setFieldsbyType("Dwitiya", "Venu");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _venuRachanaaCountDwitiyaCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('VenuRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInDwitiyaVenu == null ? false : _isTrainedInDwitiyaVenu,
                                        validator: (value) {
                                          if (_isTrainedInDwitiyaVenu != null && (_isTrainedInDwitiyaVenu! && value!.isEmpty)) return (Statics.getLabel('VenuValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _venuRachanaaCountDwitiyaCntrl.text = value;
                                          else
                                            _venuRachanaaCountDwitiyaCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInDwitiyaVenu!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isDwitiyaVenuLipi == null ? false : _isDwitiyaVenuLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isDwitiyaVenuLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamAanak == true || _isTrainedInTrutiyaAanak == true || _isTrainedInAnyaAanak == true) ? true : false,
                                        child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Aanak'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInDwitiyaAanak == null ? false : _isTrainedInDwitiyaAanak,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInDwitiyaAanak = value;
                                                setFieldsbyType("Dwitiya", "Aanak");
                                              });
                                            }),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _aanakRachanaaCountDwitiyaCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('AanakRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInDwitiyaAanak == null ? false : _isTrainedInDwitiyaAanak,
                                        validator: (value) {
                                          if (_isTrainedInDwitiyaAanak != null && (_isTrainedInDwitiyaAanak! && value!.isEmpty)) return (Statics.getLabel('AanakValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _aanakRachanaaCountDwitiyaCntrl.text = value;
                                          else
                                            _aanakRachanaaCountDwitiyaCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInDwitiyaAanak!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isDwitiyaAanakLipi == null ? false : _isDwitiyaAanakLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isDwitiyaAanakLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamShankha == true || _isTrainedInTrutiyaShankha == true || _isTrainedInAnyaShankha == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Shankha'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInDwitiyaShankha == null ? false : _isTrainedInDwitiyaShankha,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInDwitiyaShankha = value;
                                              setFieldsbyType("Dwitiya", "Shankha");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _shankhaRachanaaCountDwitiyaCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('ShankhaRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInDwitiyaShankha == null ? false : _isTrainedInDwitiyaShankha,
                                        validator: (value) {
                                          if (_isTrainedInDwitiyaShankha != null && (_isTrainedInDwitiyaShankha! && value!.isEmpty)) return (Statics.getLabel('ShankhaValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _shankhaRachanaaCountDwitiyaCntrl.text = value;
                                          else
                                            _shankhaRachanaaCountDwitiyaCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInDwitiyaShankha!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isDwitiyaShankhaLipi == null ? false : _isDwitiyaShankhaLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isDwitiyaShankhaLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamNaagaanga == true || _isTrainedInTrutiyaNaagaanga == true || _isTrainedInAnyaNaagaanga == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Naagaanga'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInDwitiyaNaagaanga == null ? false : _isTrainedInDwitiyaNaagaanga,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInDwitiyaNaagaanga = value;
                                              setFieldsbyType("Dwitiya", "Naagaanga");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _naagaangRachanaaCountDwitiyaCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('NaagaangaRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInDwitiyaNaagaanga == null ? false : _isTrainedInDwitiyaNaagaanga,
                                        validator: (value) {
                                          if (_isTrainedInDwitiyaNaagaanga != null && (_isTrainedInDwitiyaNaagaanga! && value!.isEmpty)) return (Statics.getLabel('NaagaangaValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _naagaangRachanaaCountDwitiyaCntrl.text = value;
                                          else
                                            _naagaangRachanaaCountDwitiyaCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInDwitiyaNaagaanga!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isDwitiyaNaagaangaLipi == null ? false : _isDwitiyaNaagaangaLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isDwitiyaNaagaangaLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamTurya == true || _isTrainedInTrutiyaTurya == true || _isTrainedInAnyaTurya == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Turya'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInDwitiyaTurya == null ? false : _isTrainedInDwitiyaTurya,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInDwitiyaTurya = value;
                                              setFieldsbyType("Dwitiya", "Turya");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _turyaRachanaaCountDwitiyaCtrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('TuryaRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInDwitiyaTurya == null ? false : _isTrainedInDwitiyaTurya,
                                        validator: (value) {
                                          if (_isTrainedInDwitiyaTurya != null && (_isTrainedInDwitiyaTurya! && value!.isEmpty)) return (Statics.getLabel('TuryaValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _turyaRachanaaCountDwitiyaCtrl.text = value;
                                          else
                                            _turyaRachanaaCountDwitiyaCtrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInDwitiyaTurya!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isDwitiyaTuryaLipi == null ? false : _isDwitiyaTuryaLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isDwitiyaTuryaLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamSwarad == true || _isTrainedInTrutiyaSwarad == true || _isTrainedInAnyaSwarad == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Swarad'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInDwitiyaSwarad == null ? false : _isTrainedInDwitiyaSwarad,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInDwitiyaSwarad = value;
                                              setFieldsbyType("Dwitiya", "Swarad");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _swaradaRachanaaCountDwitiyaCtrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('SwaradRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInDwitiyaSwarad == null ? false : _isTrainedInDwitiyaSwarad,
                                        validator: (value) {
                                          if (_isTrainedInDwitiyaSwarad != null && (_isTrainedInDwitiyaSwarad! && value!.isEmpty)) return (Statics.getLabel('SwaradValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _swaradaRachanaaCountDwitiyaCtrl.text = value;
                                          else
                                            _swaradaRachanaaCountDwitiyaCtrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInDwitiyaSwarad!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isDwitiyaSwaradLipi == null ? false : _isDwitiyaSwaradLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isDwitiyaSwaradLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamGomukha == true || _isTrainedInTrutiyaGomukha == true || _isTrainedInAnyaGomukha == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Gomukha') + '      ', style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInDwitiyaGomukha == null ? false : _isTrainedInDwitiyaGomukha,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInDwitiyaGomukha = value;
                                              setFieldsbyType("Dwitiya", "Gomukha");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _gomukhaRachanaaCountDwitiyaCtrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('GomukhaRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInDwitiyaGomukha == null ? false : _isTrainedInDwitiyaGomukha,
                                        validator: (value) {
                                          if (_isTrainedInDwitiyaGomukha != null && (_isTrainedInDwitiyaGomukha! && value!.isEmpty)) return (Statics.getLabel('GomukhaValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _gomukhaRachanaaCountDwitiyaCtrl.text = value;
                                          else
                                            _gomukhaRachanaaCountDwitiyaCtrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInDwitiyaGomukha!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isDwitiyaGomukhaLipi == null ? false : _isDwitiyaGomukhaLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isDwitiyaGomukhaLipi = value;
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
                          isExpanded: widget.viewType == "ViewMenu" ? true : _isDwitiyaGhoshVishayExpanded!,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          _isTrutiyaGhoshVishayExpanded = isExpanded;
                        });
                      },
                      children: [
                        ExpansionPanel(
                          headerBuilder: (BuildContext context, bool isExpanded) {
                            return ListTile(
                              title: Text(Statics.getLabel('GhoshTrutiyaVaadya')),
                            );
                          },
                          body: Container(
                            //margin: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Wrap(
                                  direction: Axis.horizontal,
                                  spacing: 5,
                                  children: [
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamVanshi == true || _isTrainedInDwitiyaVanshi == true || _isTrainedInAnyaVanshi == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Vanshi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInTrutiyaVanshi == null ? false : _isTrainedInTrutiyaVanshi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInTrutiyaVanshi = value;
                                              setFieldsbyType("Trutiya", "Vanshi");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _vanshiRachanaaCountTrutiyaCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('VanshiRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInTrutiyaVanshi == null ? false : _isTrainedInTrutiyaVanshi,
                                        validator: (value) {
                                          if (_isTrainedInTrutiyaVanshi != null && (_isTrainedInTrutiyaVanshi! && value!.isEmpty)) return (Statics.getLabel('VanshiValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _vanshiRachanaaCountTrutiyaCntrl.text = value;
                                          else
                                            _vanshiRachanaaCountTrutiyaCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInTrutiyaVanshi!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrutiyaVanshiLipi == null ? false : _isTrutiyaVanshiLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrutiyaVanshiLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamVenu == true || _isTrainedInDwitiyaVenu == true || _isTrainedInAnyaVenu == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Venu') + '               ', style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInTrutiyaVenu == null ? false : _isTrainedInTrutiyaVenu,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInTrutiyaVenu = value;
                                              setFieldsbyType("Trutiya", "Venu");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _venuRachanaaCountTrutiyaCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('VenuRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInTrutiyaVenu == null ? false : _isTrainedInTrutiyaVenu,
                                        validator: (value) {
                                          if (_isTrainedInTrutiyaVenu != null && (_isTrainedInTrutiyaVenu! && value!.isEmpty)) return (Statics.getLabel('VenuValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _venuRachanaaCountTrutiyaCntrl.text = value;
                                          else
                                            _venuRachanaaCountTrutiyaCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInTrutiyaVenu!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrutiyaVenuLipi == null ? false : _isTrutiyaVenuLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrutiyaVenuLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamAanak == true || _isTrainedInDwitiyaAanak == true || _isTrainedInAnyaAanak == true) ? true : false,
                                        child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Aanak'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInTrutiyaAanak == null ? false : _isTrainedInTrutiyaAanak,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInTrutiyaAanak = value;
                                                setFieldsbyType("Trutiya", "Aanak");
                                              });
                                            }),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _aanakRachanaaCountTrutiyaCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('AanakRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInTrutiyaAanak == null ? false : _isTrainedInTrutiyaAanak,
                                        validator: (value) {
                                          if (_isTrainedInTrutiyaAanak != null && (_isTrainedInTrutiyaAanak! && value!.isEmpty)) return (Statics.getLabel('AanakValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _aanakRachanaaCountTrutiyaCntrl.text = value;
                                          else
                                            _aanakRachanaaCountTrutiyaCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInTrutiyaAanak!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrutiyaAanakLipi == null ? false : _isTrutiyaAanakLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrutiyaAanakLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamShankha == true || _isTrainedInDwitiyaShankha == true || _isTrainedInAnyaShankha == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Shankha'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInTrutiyaShankha == null ? false : _isTrainedInTrutiyaShankha,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInTrutiyaShankha = value;
                                              setFieldsbyType("Trutiya", "Shankha");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _shankhaRachanaaCountTrutiyaCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('ShankhaRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInTrutiyaShankha == null ? false : _isTrainedInTrutiyaShankha,
                                        validator: (value) {
                                          if (_isTrainedInTrutiyaShankha != null && (_isTrainedInTrutiyaShankha! && value!.isEmpty)) return (Statics.getLabel('ShankhaValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _shankhaRachanaaCountTrutiyaCntrl.text = value;
                                          else
                                            _shankhaRachanaaCountTrutiyaCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInTrutiyaShankha!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrutiyaShankhaLipi == null ? false : _isTrutiyaShankhaLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrutiyaShankhaLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamNaagaanga == true || _isTrainedInDwitiyaNaagaanga == true || _isTrainedInAnyaNaagaanga == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Naagaanga'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInTrutiyaNaagaanga == null ? false : _isTrainedInTrutiyaNaagaanga,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInTrutiyaNaagaanga = value;
                                              setFieldsbyType("Trutiya", "Naagaanga");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _naagaangRachanaaCountTrutiyaCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('NaagaangaRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInTrutiyaNaagaanga == null ? false : _isTrainedInTrutiyaNaagaanga,
                                        validator: (value) {
                                          if (_isTrainedInTrutiyaNaagaanga != null && (_isTrainedInTrutiyaNaagaanga! && value!.isEmpty)) return (Statics.getLabel('NaagaangaValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _naagaangRachanaaCountTrutiyaCntrl.text = value;
                                          else
                                            _naagaangRachanaaCountTrutiyaCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInTrutiyaNaagaanga!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrutiyaNaagaangaLipi == null ? false : _isTrutiyaNaagaangaLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrutiyaNaagaangaLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamTurya == true || _isTrainedInDwitiyaTurya == true || _isTrainedInAnyaTurya == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Turya'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInTrutiyaTurya == null ? false : _isTrainedInTrutiyaTurya,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInTrutiyaTurya = value;
                                              setFieldsbyType("Trutiya", "Turya");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _turyaRachanaaCountTrutiyaCtrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('TuryaRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInTrutiyaTurya == null ? false : _isTrainedInTrutiyaTurya,
                                        validator: (value) {
                                          if (_isTrainedInTrutiyaTurya != null && (_isTrainedInTrutiyaTurya! && value!.isEmpty)) return (Statics.getLabel('TuryaValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _turyaRachanaaCountTrutiyaCtrl.text = value;
                                          else
                                            _turyaRachanaaCountTrutiyaCtrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInTrutiyaTurya!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrutiyaTuryaLipi == null ? false : _isTrutiyaTuryaLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrutiyaTuryaLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamSwarad == true || _isTrainedInDwitiyaSwarad == true || _isTrainedInAnyaSwarad == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Swarad'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInTrutiyaSwarad == null ? false : _isTrainedInTrutiyaSwarad,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInTrutiyaSwarad = value;
                                              setFieldsbyType("Trutiya", "Swarad");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _swaradaRachanaaCountTrutiyaCtrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('SwaradRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInTrutiyaSwarad == null ? false : _isTrainedInTrutiyaSwarad,
                                        validator: (value) {
                                          if (_isTrainedInTrutiyaSwarad != null && (_isTrainedInTrutiyaSwarad! && value!.isEmpty)) return (Statics.getLabel('SwaradValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _swaradaRachanaaCountTrutiyaCtrl.text = value;
                                          else
                                            _swaradaRachanaaCountTrutiyaCtrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInTrutiyaSwarad!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrutiyaSwaradLipi == null ? false : _isTrutiyaSwaradLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrutiyaSwaradLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamGomukha == true || _isTrainedInDwitiyaGomukha == true || _isTrainedInAnyaGomukha == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Gomukha') + '      ', style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInTrutiyaGomukha == null ? false : _isTrainedInTrutiyaGomukha,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInTrutiyaGomukha = value;
                                              setFieldsbyType("Trutiya", "Gomukha");
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _gomukhaRachanaaCountTrutiyaCtrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('GomukhaRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInTrutiyaGomukha == null ? false : _isTrainedInTrutiyaGomukha,
                                        validator: (value) {
                                          if (_isTrainedInTrutiyaGomukha != null && (_isTrainedInTrutiyaGomukha! && value!.isEmpty)) return (Statics.getLabel('GomukhaValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _gomukhaRachanaaCountTrutiyaCtrl.text = value;
                                          else
                                            _gomukhaRachanaaCountTrutiyaCtrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInTrutiyaGomukha!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrutiyaGomukhaLipi == null ? false : _isTrutiyaGomukhaLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrutiyaGomukhaLipi = value;
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
                          isExpanded: widget.viewType == "ViewMenu" ? true : _isTrutiyaGhoshVishayExpanded!,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          _isAnyaGhoshVishayExpanded = isExpanded;
                        });
                      },
                      children: [
                        ExpansionPanel(
                          headerBuilder: (BuildContext context, bool isExpanded) {
                            return ListTile(
                              title: Text(Statics.getLabel('GhoshAnyaVaadya')),
                            );
                          },
                          body: Container(
                            //margin: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Wrap(
                                  direction: Axis.horizontal,
                                  spacing: 5,
                                  children: [
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamVanshi == true || _isTrainedInDwitiyaVanshi == true || _isTrainedInTrutiyaVanshi == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Vanshi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInAnyaVanshi == null ? false : _isTrainedInAnyaVanshi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInAnyaVanshi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _vanshiRachanaaCountAnyaCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('VanshiRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInAnyaVanshi == null ? false : _isTrainedInAnyaVanshi,
                                        validator: (value) {
                                          if (_isTrainedInAnyaVanshi != null && (_isTrainedInAnyaVanshi! && value!.isEmpty)) return (Statics.getLabel('VanshiValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _vanshiRachanaaCountAnyaCntrl.text = value;
                                          else
                                            _vanshiRachanaaCountAnyaCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInAnyaVanshi!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isAnyaVanshiLipi == null ? false : _isAnyaVanshiLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isAnyaVanshiLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamVenu == true || _isTrainedInDwitiyaVenu == true || _isTrainedInTrutiyaVenu == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Venu') + '               ', style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInAnyaVenu == null ? false : _isTrainedInAnyaVenu,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInAnyaVenu = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _venuRachanaaCountAnyaCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('VenuRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInAnyaVenu == null ? false : _isTrainedInAnyaVenu,
                                        validator: (value) {
                                          if (_isTrainedInAnyaVenu != null && (_isTrainedInAnyaVenu! && value!.isEmpty)) return (Statics.getLabel('VenuValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _venuRachanaaCountAnyaCntrl.text = value;
                                          else
                                            _venuRachanaaCountAnyaCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInAnyaVenu!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isAnyaVenuLipi == null ? false : _isAnyaVenuLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isAnyaVenuLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamAanak == true || _isTrainedInDwitiyaAanak == true || _isTrainedInTrutiyaAanak == true) ? true : false,
                                        child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Aanak'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInAnyaAanak == null ? false : _isTrainedInAnyaAanak,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInAnyaAanak = value;
                                              });
                                            }),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _aanakRachanaaCountAnyaCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('AanakRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInAnyaAanak == null ? false : _isTrainedInAnyaAanak,
                                        validator: (value) {
                                          if (_isTrainedInAnyaAanak != null && (_isTrainedInAnyaAanak! && value!.isEmpty)) return (Statics.getLabel('AanakValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _aanakRachanaaCountAnyaCntrl.text = value;
                                          else
                                            _aanakRachanaaCountAnyaCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInAnyaAanak!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isAnyaAanakLipi == null ? false : _isAnyaAanakLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isAnyaAanakLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamShankha == true || _isTrainedInDwitiyaShankha == true || _isTrainedInTrutiyaShankha == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Shankha'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInAnyaShankha == null ? false : _isTrainedInAnyaShankha,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInAnyaShankha = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _shankhaRachanaaCountAnyaCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('ShankhaRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInAnyaShankha == null ? false : _isTrainedInAnyaShankha,
                                        validator: (value) {
                                          if (_isTrainedInAnyaShankha != null && (_isTrainedInAnyaShankha! && value!.isEmpty)) return (Statics.getLabel('ShankhaValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _shankhaRachanaaCountAnyaCntrl.text = value;
                                          else
                                            _shankhaRachanaaCountAnyaCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInAnyaShankha!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isAnyaShankhaLipi == null ? false : _isAnyaShankhaLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isAnyaShankhaLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamNaagaanga == true || _isTrainedInDwitiyaNaagaanga == true || _isTrainedInTrutiyaNaagaanga == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Naagaanga'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInAnyaNaagaanga == null ? false : _isTrainedInAnyaNaagaanga,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInAnyaNaagaanga = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _naagaangRachanaaCountAnyaCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('NaagaangaRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInAnyaNaagaanga == null ? false : _isTrainedInAnyaNaagaanga,
                                        validator: (value) {
                                          if (_isTrainedInAnyaNaagaanga != null && (_isTrainedInAnyaNaagaanga! && value!.isEmpty)) return (Statics.getLabel('NaagaangaValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _naagaangRachanaaCountAnyaCntrl.text = value;
                                          else
                                            _naagaangRachanaaCountAnyaCntrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInAnyaNaagaanga!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isAnyaNaagaangaLipi == null ? false : _isAnyaNaagaangaLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isAnyaNaagaangaLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamTurya == true || _isTrainedInDwitiyaTurya == true || _isTrainedInTrutiyaTurya == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Turya'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInAnyaTurya == null ? false : _isTrainedInAnyaTurya,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInAnyaTurya = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _turyaRachanaaCountAnyaCtrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('TuryaRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInAnyaTurya == null ? false : _isTrainedInAnyaTurya,
                                        validator: (value) {
                                          if (_isTrainedInAnyaTurya != null && (_isTrainedInAnyaTurya! && value!.isEmpty)) return (Statics.getLabel('TuryaValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _turyaRachanaaCountAnyaCtrl.text = value;
                                          else
                                            _turyaRachanaaCountAnyaCtrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInAnyaTurya!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isAnyaTuryaLipi == null ? false : _isAnyaTuryaLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isAnyaTuryaLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamSwarad == true || _isTrainedInDwitiyaSwarad == true || _isTrainedInTrutiyaSwarad == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Swarad'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInAnyaSwarad == null ? false : _isTrainedInAnyaSwarad,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInAnyaSwarad = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _swaradaRachanaaCountAnyaCtrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('SwaradRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInAnyaSwarad == null ? false : _isTrainedInAnyaSwarad,
                                        validator: (value) {
                                          if (_isTrainedInAnyaSwarad != null && (_isTrainedInAnyaSwarad! && value!.isEmpty)) return (Statics.getLabel('SwaradValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _swaradaRachanaaCountAnyaCtrl.text = value;
                                          else
                                            _swaradaRachanaaCountAnyaCtrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInAnyaSwarad!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isAnyaSwaradLipi == null ? false : _isAnyaSwaradLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isAnyaSwaradLipi = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.35,
                                      child: AbsorbPointer(
                                        absorbing: (_isTrainedInPrathamGomukha == true || _isTrainedInDwitiyaGomukha == true || _isTrainedInTrutiyaGomukha == true) ? true : false,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('Gomukha') + '      ', style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isTrainedInAnyaGomukha == null ? false : _isTrainedInAnyaGomukha,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isTrainedInAnyaGomukha = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.2,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _gomukhaRachanaaCountAnyaCtrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('GomukhaRachanaaCount')),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        enabled: _isTrainedInAnyaGomukha == null ? false : _isTrainedInAnyaGomukha,
                                        validator: (value) {
                                          if (_isTrainedInAnyaGomukha != null && (_isTrainedInAnyaGomukha! && value!.isEmpty)) return (Statics.getLabel('GomukhaValidationMessage'));
                                          return null;
                                        },
                                        onSaved: (value) {
                                          if (value != null && value.isNotEmpty)
                                            _gomukhaRachanaaCountAnyaCtrl.text = value;
                                          else
                                            _gomukhaRachanaaCountAnyaCtrl.text = "";
                                        },
                                      ),
                                    ),
                                    AbsorbPointer(
                                      absorbing: !_isTrainedInAnyaGomukha!,
                                      child: SizedBox(
                                        width: Statics.getDeviceSize(context).width * 0.35,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                          title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                          checkColor: Colors.white,
                                          activeColor: Colors.purple,
                                          value: _isAnyaGomukhaLipi == null ? false : _isAnyaGomukhaLipi,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              _isAnyaGomukhaLipi = value;
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
                          isExpanded: widget.viewType == "ViewMenu" ? true : _isAnyaGhoshVishayExpanded!,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
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
