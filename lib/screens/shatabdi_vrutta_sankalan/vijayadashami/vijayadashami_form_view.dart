import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:niyojak_prod/screens/shatabdi_vrutta_sankalan/vijayadashami/vijaya_dashami_report.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';
import 'package:niyojak_prod/widgets/single_column_row.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../models/response_model/get_vijaya_dashami_geounit_data.dart';
import '../../../models/response_model/vasti_up_data_model.dart';
import '../../../models/response_model/vijayaDashamiInitModel.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';
import '../../../validation_blocks/validator.dart';
import '../../levels_update_module/levels_manage_tabs.dart';
import 'add_mukhya_atithi_form.dart';
import 'add_vishesh_vyakti.dart';

class VijayadashamiFormView extends StatefulWidget {
  static const String routeName = '/vijayadashami-form-view';

  const VijayadashamiFormView({super.key});

  @override
  State<VijayadashamiFormView> createState() => _VijayadashamiFormViewState();
}

class _VijayadashamiFormViewState extends State<VijayadashamiFormView> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _mainScrollController = ScrollController();

  TextEditingController txtUrlsController = TextEditingController();
  TextEditingController txtUrlDescController = TextEditingController();

  bool _isSearching = false;
  bool _isExpanded = true;
  bool isVastiSearch = false;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedBhaag;
  List<GeoUnitMasterBAL>? _linkedShahar;
  List<GeoUnitMasterBAL>? _linkedNagar;
  List<UpnagarmandallistVijayaDashami>? _linkedUpnagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<GeoUnitMasterBAL>? _linkedupnagar;
  List<StaticMasterBAL>? _baithakTypes;

  String? _linkedupnagarName = "";
  String? _linkedupnagarValue = "";
  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedBhaagValue = "";
  String? _linkedShaharValue = "";
  String? _linkedNagarValue = "";
  String? _linkedNagarValuePopup = '';
  String? _linkedgraamValue = "";
  String? _linkedmandalValue = "";
  String? _linkedupnaragValue = "";
  String? _linkedvastiValue = "";

  // String? _linkedMahaanagarName = '';
  // String? _linkedVibhaagName = '';
  String? _linkedBhaagName = "";
  String? _linkedshaharName = "";
  String? _linkedNagarName = "";
  String? _linkedmandalName = "";
  String? _linkedgraamName = "";
  String? _linkedvastiName = "";
  String? _baithakTypeValue = '';
  String? _baithakTypeYear = '';
  int? _baithakType;
  String _selectedNagarAndBaithak = '';
  String? mahanagarId = '';
  String? vibhagId = '';

  List<int?> selectedUpnagarList = [];

  Vastisarsajjanshakti? selectedPerson;
  Vastisanyaprabhavi? selectedPrabhavi;
  List<Vastisarsajjanshakti> selectedSajjanshaktiItems = [];
  List<Vastisanyaprabhavi> selectedAnyaprabhaviItems = [];

  @override
  void initState() {
    super.initState();
    presentMatrushaktiController.addListener(_calculateTotal);
    presentMaleController.addListener(_calculateTotal);
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _getInitialData());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  List<Map<String, String>> getFilteredLevels(int levelId) {
    Map<int, String> levelMap = {
      2: "SelectVasti",
      4: "Mandal",
      13: "upnagarUpkhanda",
      6: "NagarKaaryakartaaCount",
    };

    List<int> allowedIds;

    switch (levelId) {
      case 2:
        allowedIds = [2];
        break;

      case 4:
        allowedIds = [4];
        break;

      case 13:
        allowedIds = [2, 4, 13];

        // if only Vasti is enabled -> exclude 4
        if (isuservasti == 1 && isusermandal != 1) {
          allowedIds.remove(4);
        }

        // if only Mandal is enabled -> exclude 2
        else if (isusermandal == 1 && isuservasti != 1) {
          allowedIds.remove(2);
        }
        break;

      default:
        // Default logic
        allowedIds = [2, 4, 13, 6];

        // if only Vasti is enabled -> exclude 4
        if (isuservasti == 1 && isusermandal != 1) {
          allowedIds.remove(4);
        }

        // if only Mandal is enabled -> exclude 2
        else if (isusermandal == 1 && isuservasti != 1) {
          allowedIds.remove(2);
        }

        // if both are 1 -> include both
        // no changes needed
        break;
    }

    print(allowedIds);

    return allowedIds.map((id) {
      final key = Statics.getLabel(levelMap[id]!);
      return {id.toString(): key.toString()};
    }).toList();
  }

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
      isuservasti = dm.isvasti;
      isusermandal = dm.ismandal;
    });
    _getInitialData();
    setState(() {
      utsavKontyaStaravarList = getFilteredLevels(dm.levelID ?? 0);
      utsavKontyaStaravar = "6";
    });
    await populateDropdown();
  }

  Future<void> populateAllDropdowns(int level, DropDownModel dm, {bool fromManual = false}) async {
    setState(() {
      selctedLevelId = '';
      _selectedGeoUnitId = _linkedMahaanagarValue =
          _linkedBhaagValue = _linkedShaharValue = _linkedUpnagar = _linkedupnagarValue = _linkedNagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    final selection = prepareSelection(dm);

    // Step 1: Mahaanagar
    await populatelinkedMahaanagarDropdown();
    _linkedMahaanagarValue = (level == 9 ? (dm.geoUnitID ?? 0).toString() : selection.mahaanagar) ?? _linkedMahaanagarValue;
    if (level == 9) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.mahaanagar).toString();
      selctedLevel = 'Mahaanagar';
      selctedLevelId = "9";
      final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      selctedLevelName = selectedItem.name;
    }

    // Step 2: Vibhaag
    await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
    _linkedVibhaagValue = (level == 8 ? (dm.geoUnitID ?? 0).toString() : selection.vibhaag) ?? _linkedVibhaagValue;
    if (level == 8) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.vibhaag).toString();
      selctedLevel = 'Vibhaag';
      selctedLevelId = "8";
      final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      selctedLevelName = selectedItem.name;
    }

    // Step 3: Bhaag
    await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
    _linkedBhaagValue = (level == 7 ? (dm.geoUnitID ?? 0).toString() : selection.bhaag) ?? _linkedBhaagValue;
    if (level == 7) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.bhaag).toString();
      selctedLevel = 'Bhaag';
      selctedLevelId = "7";
      final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      selctedLevelName = selectedItem.name;
    }

    // Step 4: Nagar
    await populatelinkedNagarDropdown(_linkedBhaagValue, null);
    _linkedNagarValue = (level == 6 ? (dm.geoUnitID ?? 0).toString() : selection.nagar) ?? _linkedNagarValue;
    if (level == 6) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.nagar).toString();
      selctedLevel = 'Nagar';
      final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      selctedLevelName = selectedItem.name;
      if (!fromManual) {
        selctedLevelId = utsavKontyaStaravar = "6";
      }
    }

    // Step 5: Upnagar (conditional)
    await populatelinkedUpnagarDropdown(_linkedNagarValue);
    if (selection.upnagar != null && selection.upnagar!.isNotEmpty) {
      _linkedupnagarValue = (level == 13 ? (dm.geoUnitID ?? 0).toString() : selection.upnagar) ?? _linkedupnagarValue;
      if (level == 13) {
        _selectedGeoUnitId = (dm.geoUnitID ?? selection.upnagar).toString();
        selctedLevel = 'upnagarUpkhanda';
        selectedUpnagarList = [];
        if (!fromManual) {
          selctedLevelId = utsavKontyaStaravar = "13";
        }
      }
    }

    if ((level == 6 || level == 13) && (utsavKontyaStaravar == "6" || utsavKontyaStaravar == "13")) {
      selectedUpnagarList = [];
      selctedLevelId = utsavKontyaStaravar;
      data = await Statics.getVijayadashamiInitData(context, Statics.userDetails["userID"], _selectedGeoUnitId, selctedLevel == 'Nagar' ? "6" : utsavKontyaStaravar);
      log("searchVijayaDashami data ${jsonDecode(jsonEncode(data))}");
      setState(() {
        _linkedUpnagar = data?.upnagarmandallist ?? [];
      });
      if ((_linkedUpnagar == null || _linkedUpnagar?.length == 0) && !fromManual) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(Statics.getLabel('AskConfirmation')),
            content: Text(Statics.getLabel('addUpnagarDialogBox')),
            actions: <Widget>[
              TextButton(
                child: Text(Statics.getLabel('add')),
                onPressed: () async {
                  Navigator.of(context).pushReplacementNamed(TabScreen.routeName).then((value) {
                    if (mounted) clearForm();
                  }); //.then((value) => searchVijayaDashami());
                },
              ),
              TextButton(
                child: Text(Statics.getLabel('clear')),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }

      if (level == 13) {
        selectedUpnagarList = [(dm.geoUnitID ?? dm.parentUpaNagarID)];
        _linkedUpnagar?.removeWhere((e) => e.geoUnitID != (dm.geoUnitID ?? dm.parentUpaNagarID));
        setState(() {});
        final selectedItem = _linkedUpnagar?.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
        selctedLevelName = selectedItem?.preferedname;
      }
    }

    // Step 6: Mandal
    await populatelinkedMandalDropdown(
      (selection.upnagar != null && selection.upnagar!.isNotEmpty),
      (selection.upnagar != null && selection.upnagar!.isNotEmpty) ? _linkedupnagarValue : _linkedNagarValue,
    );
    _linkedmandalValue = (level == 4 ? (dm.geoUnitID ?? 0).toString() : selection.mandal) ?? _linkedmandalValue;
    if (level == 4) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.mandal).toString();
      selctedLevel = 'Mandal';
      if (!fromManual) {
        selctedLevelId = utsavKontyaStaravar = "4";
      }
      final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      selctedLevelName = selectedItem.name;
    }
    // // Step 7: Graam
    // await populatelinkedGraamDropdown(_linkedmandalValue);
    // _selectedGeoUnitId = _linkedgraamValue = (level == 3 ? (dm.geoUnitID ?? "").toString() : selection.graam) ?? '';
    //
    // // Step 8: Vasti
    await populatelinkedVastiDropdown(
      (selection.upnagar != null && selection.upnagar!.isNotEmpty),
      (selection.upnagar != null && selection.upnagar!.isNotEmpty) ? _linkedupnagarValue : _linkedNagarValue,
    );
    _linkedvastiValue = (level == 2 ? (dm.geoUnitID ?? 0).toString() : selection.vasti) ?? _linkedvastiValue;
    if (level == 2) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.vasti).toString();
      selctedLevel = 'Vasti';
      if (!fromManual) {
        selctedLevelId = utsavKontyaStaravar = "2";
      }
      final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      selctedLevelName = selectedItem.name;
    }
    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty) _linkedbhaagName = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkednagar != null && _linkednagar!.isNotEmpty) _linkednagarName = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;

    setState(() {});
  }

  _getInitialData() async {
    final args = ModalRoute.of(context)?.settings.arguments as String?;
    if (args != null) await getFormData(formId: int.tryParse(args) ?? 0);
    setState(() {});
  }

  Future<void> clearForm({bool fromManual = false}) async {
    setState(() {
      // Reset int flags (as per your logic: 2 = default)
      programNirdharitVed = 2;
      vaiyaktikGitKantashtha = 2;
      programHishobh24Hour = 2;
      sanchalanZaleKa = 2;
      sanchalanSadandaZalKa = 2;
      sanchalanGhoshVadanZalKa = 2;

      // Reset text controllers
      presentMatrushaktiController.clear();
      presentMaleController.clear();
      patShishuBaalCtrl.clear();
      ganShishuBaalCtrl.clear();
      anyaShishuBaalCtrl.clear();
      patMahavidyaCtrl.clear();
      ganMahavidyaCtrl.clear();
      anyaMahavidyaCtrl.clear();
      patTarunVyavCtrl.clear();
      ganTarunVyavCtrl.clear();
      anyaTarunVyavCtrl.clear();
      patProudhVyavCtrl.clear();
      ganProudhVyavCtrl.clear();
      anyaProudhVyavCtrl.clear();
      txtVaktaNameController.clear();
      txtVaktaTaskController.clear();

      // Reset dropdowns / linked values
      _linkedMahaanagarValue = null;
      _linkedVibhaagValue = null;
      _linkedBhaagValue = null;
      _linkedShaharValue = null;
      _linkedNagarValue = null;
      _linkedupnagarValue = null;
      _linkedmandalValue = null;
      _linkedupnaragValue = null;
      _linkedgraamValue = null;
      _linkedvastiValue = null;
      selectedUpnagarList = [];

      // Reset data lists
      _linkedBhaag = null;
      _linkedShahar = null;
      _linkedNagar = null;
      _linkedmandal = null;
      _linkedgraam = null;
      _linkedvasti = null;

      // Reset level tracking
      selctedLevel = '';
      selctedLevelName = '';
      _selectedGeoUnitId = null;
      selctedLevelIdForMandalDropdown = null;
      selctedLevelIdForVastiDropdown = null;

      // Reset selections
      selectedMukhyaAtithi = null;
      selectedType = null;
      selectedSajjanshaktiItems = [];
      selectedAnyaprabhaviItems = [];
      selectedBhougolikPratinidhitwaVastiIds = null;
      selectedShakhaaPratinidhitwaVastiIds = null;
      selectedMilanPratinidhitwaVastiIds = null;
      selectedSanghaMandaliPratinidhitwaVastiIds = null;

      // Reset counts for Vasti
      selectedVastiCount = 0;
      totalVastiCount = 0;

      // ✅ Reset Sangha Mandali
      countsSanghaMandali = null;
      checkboxSanghaMandaliSelectedItems = [];
      totalSanghaMandaliCount = 0;
      selectedSanghaMandaliCount = 0;
      averageSanghaMandaliCount = "0";
      selectedSanghaMandaliPratinidhitwaVastiIds = null;

      // ✅ Reset Milan
      countsMilan = null;
      checkboxMilanSelectedItems = [];
      totalMilanCount = 0;
      selectedMilanCount = 0;
      averageMilanCount = "0";
      selectedMilanPratinidhitwaVastiIds = null;

      // ✅ Reset Shakha
      checkboxShakhaSelectedItems = [];
      totalShakhaCount = 0;
      selectedShakhaCount = 0;
      averageShakhaCount = "0";
      selectedShakhaaPratinidhitwaVastiIds = null;

      selectedPrabhavi = null;
      selectedPerson = null;
      isVastiSearch = false;
      _isSearching = false;

      selectedFilePath = null;
      _selectedFileNames1 = [];
      _selectedFileNames2 = [];
      _urlsList = [];
      // Re-populate base dropdowns
    });
    await populateAllDropdowns(userLevelId!, ddm!, fromManual: fromManual);
  }

  populateDropdown({bool fromClear = false}) async {
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
    print("_baithakTypes :-- ${_baithakTypes}");
    setState(() {
      _linkedMahaanagarValue = _linkedBhaagValue = _linkedShaharValue = _linkedNagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
      _linkedMahaanagar = _linkedVibhaag = _linkedBhaag = _linkedNagar = _linkedmandal = null;
      selctedLevelName = _selectedGeoUnitId = null;
      _linkedUpnagar = [];
      selctedLevel = "praant";
      isVastiSearch = false;
    });
    populatelinkedMahaanagarDropdown();
    populatelinkedVibhaagDropdown('');
    if (fromClear || userLevelId == null || ddm == null) {
      return;
    }
    await populateAllDropdowns(userLevelId!, ddm!);
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = [];
    _linkedUpnagar = [];
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() => _linkedMahaanagar = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedupnagarValue = _linkedupnagar = _linkedUpnagar = _linkedBhaagValue = _linkedNagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedUpnagar = [];
    final data = utsavKontyaStaravar == "2"
        ? await Statics.getGeoUnitsByLevelAndParentForVasti(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar', '')
        : utsavKontyaStaravar == "4"
            ? await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar', '')
            : utsavKontyaStaravar == "13"
                ? await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar', '')
                : await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar', '');
    setState(() => _linkedVibhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedupnagarValue = _linkedBhaagValue = _linkedNagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedBhaagName = _linkedNagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedupnagar = _linkedBhaag = _linkedNagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
    _linkedUpnagar = [];
    final data = utsavKontyaStaravar == "2"
        ? await Statics.getGeoUnitsByLevelAndParentForVasti(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '')
        : utsavKontyaStaravar == "4"
            ? await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '')
            : utsavKontyaStaravar == "13"
                ? await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '')
                : await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() => _linkedBhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() => _linkedShahar = data.isNotEmpty ? data : null);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkedupnagarValue = _linkedNagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedNagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedupnagar = _linkedNagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    _linkedUpnagar = [];
    final parentID = shaharIDStr ?? bhaagIDStr!;
    final parentType = shaharIDStr != null ? 'Shahar' : 'Bhaag';
    final data = utsavKontyaStaravar == "2"
        ? await Statics.getGeoUnitsByLevelAndParentForVasti(Statics.levels['NagarLevelID'].toString(), parentID, parentType, '')
        : utsavKontyaStaravar == "4"
            ? await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['NagarLevelID'].toString(), parentID, parentType, '')
            : utsavKontyaStaravar == "13"
                ? await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['NagarLevelID'].toString(), parentID, parentType, '')
                : await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), parentID, parentType, '');
    setState(() => _linkedNagar = data.isNotEmpty ? data : null);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedUpnagarDropdown(String? nagarIDStr) async {
    _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = null;
    _linkedupnagarName = _linkedmandalName = _linkedgraamName = null;
    _linkedupnagar = _linkedmandal = _linkedgraam = null;
    _linkedUpnagar = [];
    var mnDD;

    mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');

    setState(() {
      _linkedupnagar = (mnDD.length > 0 ? mnDD : null);
      //_linkedupnagarValue = (userparentUpanagarid ?? userGeoUnitId).toString();
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(bool haveParentUp, String? nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandalName = _linkedgraamName = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD;
    if (haveParentUp) {
      mnDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, "Upnagar", '');
    } else {
      mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, "Nagar", '');
    }
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String? mandalIDStr) async {
    _linkedgraamValue = null;
    _linkedgraamName = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '');
    setState(() => _linkedgraam = data.isNotEmpty ? data : null);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(bool haveParentUp, String? nagarIDStr) async {
    _linkedvastiValue = null;
    _linkedvastiName = null;
    var data;
    if (haveParentUp) {
      print("i am in parents upnagar");
      data = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, "Upnagar", '');
      // print("${mnDD}");
    } else {
      data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, "Nagar", '');
    }
    setState(() => _linkedvasti = data.isNotEmpty ? data : null);
    return data;
  }

  String? selctedLevel = 'praant';
  String? selctedLevelId;
  String? selctedLevelName = '';
  String? _selectedGeoUnitId = '';
  String? selctedLevelIdForMandalDropdown = '';
  String? selctedLevelIdForVastiDropdown = '';
  String? selctedSanchalanLevelId = '';
  String? selctedSanchalanLevelName = '';

  int? programNirdharitVed;
  int? vaiyaktikGitKantashtha;
  int? programHishobh24Hour;
  int? sanchalanZaleKa;
  int? sanchalanSadandaZalKa;
  int? sanchalanGhoshVadanZalKa;

  final TextEditingController presentMaleController = TextEditingController();
  final TextEditingController presentMatrushaktiController = TextEditingController();

  final TextEditingController txtVaktaNameController = TextEditingController();
  final TextEditingController txtVaktaTaskController = TextEditingController();
  final TextEditingController txtUtsavPhotoDescController = TextEditingController();
  final TextEditingController txtUtsavAddPhotoDescController = TextEditingController();

  // Pat Sankhya controllers
  final patShishuBaalCtrl = TextEditingController();
  final patMahavidyaCtrl = TextEditingController();
  final patTarunVyavCtrl = TextEditingController();
  final patProudhVyavCtrl = TextEditingController();

  // Ganveshat Upasthit controllers
  final ganShishuBaalCtrl = TextEditingController();
  final ganMahavidyaCtrl = TextEditingController();
  final ganTarunVyavCtrl = TextEditingController();
  final ganProudhVyavCtrl = TextEditingController();

  // Anya Upasthit controllers
  final anyaShishuBaalCtrl = TextEditingController();
  final anyaMahavidyaCtrl = TextEditingController();
  final anyaTarunVyavCtrl = TextEditingController();
  final anyaProudhVyavCtrl = TextEditingController();

  int _getColumnTotal(List<TextEditingController> ctrls) {
    return ctrls.fold<int>(
      0,
      (sum, c) => sum + (int.tryParse(c.text.trim().isEmpty ? "0" : c.text) ?? 0),
    );
  }

// helper function
  int _rowTotal(String gan, String anya) {
    final g = int.tryParse(gan) ?? 0;
    final a = int.tryParse(anya) ?? 0;
    return g + a;
  }

  // Widget _numberField(
  //   TextEditingController controller, {
  //   TextEditingController? limitController,
  //   TextEditingController? otherController,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.all(4.0),
  //     child: TextField(
  //       controller: controller,
  //       keyboardType: TextInputType.number,
  //       textAlign: TextAlign.center,
  //       decoration: const InputDecoration(
  //         hintText: "0",
  //         border: UnderlineInputBorder(),
  //         focusedBorder: UnderlineInputBorder(
  //           borderSide: BorderSide(color: Colors.deepPurple, width: 2),
  //         ),
  //         enabledBorder: UnderlineInputBorder(
  //           borderSide: BorderSide(color: Colors.grey, width: 1),
  //         ),
  //         isDense: true, // compact look
  //         contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
  //       ),
  //       onChanged: (val) {
  //         if (_isSearching == false) {
  //           Fluttertoast.showToast(
  //             msg: "${Statics.getLabel('NagarSelectionImportant')}",
  //           );
  //           return;
  //         }
  //         if (limitController != null && otherController != null) {
  //           final limit = int.tryParse(limitController.text) ?? 0;
  //           final self = int.tryParse(val) ?? 0;
  //           final other = int.tryParse(otherController.text) ?? 0;
  //
  //           if (self + other > limit) {
  //             controller.text = (limit - other).toString();
  //             controller.selection = TextSelection.fromPosition(
  //               TextPosition(offset: controller.text.length),
  //             );
  //           }
  //         }
  //         if (mounted) setState(() {});
  //       },
  //     ),
  //   );
  // }
  Widget _numberField(
    TextEditingController controller, {
    // bool showPadding = false,
    EdgeInsetsGeometry? padding,
    Color? textBoxColor,
    Color? containerColor,
    TextEditingController? limitController,
    TextEditingController? otherController,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(4.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: containerColor),
      child: TextField(
        controller: controller,
        readOnly: _isSearching == false,
        // 🔑 typing disable when false
        onTap: () {
          if (_isSearching == false) {
            Fluttertoast.showToast(
              msg: "${Statics.getLabel('NagarSelectionImportant')}",
            );
          }
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          filled: textBoxColor != null,
          fillColor: textBoxColor,
          hintText: "0",
          border: UnderlineInputBorder(),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        ),
        onChanged: (val) {
          if (limitController != null && otherController != null) {
            final limit = int.tryParse(limitController.text) ?? 0;
            final self = int.tryParse(val) ?? 0;
            final other = int.tryParse(otherController.text) ?? 0;

            if (self + other > limit) {
              controller.text = (limit - other).toString();
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            }
          }
          if (mounted) setState(() {});
        },
      ),
    );
  }

  int total = 0;

  void _calculateTotal() {
    final int matru = int.tryParse(presentMatrushaktiController.text) ?? 0;
    final int male = int.tryParse(presentMaleController.text) ?? 0;
    setState(() {
      total = matru + male;
    });
  }

  @override
  void dispose() {
    presentMatrushaktiController.dispose();
    presentMaleController.dispose();
    for (var c in [
      patShishuBaalCtrl,
      patMahavidyaCtrl,
      patTarunVyavCtrl,
      patProudhVyavCtrl,
      ganShishuBaalCtrl,
      ganMahavidyaCtrl,
      ganTarunVyavCtrl,
      ganProudhVyavCtrl,
      anyaShishuBaalCtrl,
      anyaMahavidyaCtrl,
      anyaTarunVyavCtrl,
      anyaProudhVyavCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  GetVijayadashamiInitModel? data;

  Future<void> searchVijayaDashami() async {
    data = await Statics.getVijayadashamiInitData(
        context, Statics.userDetails["userID"], selectedUpnagarList.isEmpty ? _selectedGeoUnitId.toString() : selectedUpnagarList.join(","), utsavKontyaStaravar);
    print("searchVijayaDashami data ${data?.vastisarsajjanshakti}");
    selectedPrabhavi = null;
    selectedPerson = null;
    getVastiUpDataList();
    setState(() {});
  }

  String? selectedType;
  int? selectedMukhyaAtithi;

  Future<void> showMukhyaAtithiSelectionPopup(
    BuildContext context, {
    required List<Vastisarsajjanshakti> vastisarsajjanshaktiList,
    required List<Vastisanyaprabhavi> vastisanyaprabhaviList,
    required void Function(String id, String type, dynamic selectedItem) onSubmit,
    required VoidCallback onAdd,
    dynamic preselectedItem,
    String? preselectedType,
  }) async {
    dynamic selectedItem = preselectedItem ?? vastisarsajjanshaktiList.firstWhereOrNull((e) => e.pkid == selectedMukhyaAtithi);
    String? selectedType = preselectedType;
    _linkedNagarValuePopup = "";
    log("showMukhyaAtithiSelectionPopup Opened >>>>>>>>>>>>>>>>>>>>> ");

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, set) {
            // dynamic selectedItem = preselectedItem ?? data!.vastisarsajjanshakti!.firstWhere((e) => e.pkid == selectedMukhyaAtithi);

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          Statics.getLabel('selectMukhyaAtithi'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        icon: const Icon(Icons.close, color: Colors.redAccent),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: Statics.getLabel('Nagar'),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    isExpanded: true,
                    value: _linkedNagarValuePopup == "" ? _linkedNagarValue : _linkedNagarValuePopup,
                    items: _linkedNagar?.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                    onChanged: (value) async {
                      set(() {
                        _linkedNagarValuePopup = value;
                      });
                      final _data = await Statics.getVijayadashamiInitData(context, Statics.userDetails["userID"], value, "6");
                      set(() {
                        vastisarsajjanshaktiList = _data?.vastisarsajjanshakti ?? [];
                        vastisanyaprabhaviList = _data?.vastisanyaprabhavi ?? [];
                        if (selectedType == "sarsajjanshakti") {
                          selectedItem = preselectedItem ?? vastisarsajjanshaktiList.firstWhereOrNull((e) => e.pkid == selectedMukhyaAtithi);
                        } else {
                          selectedItem = preselectedItem ?? vastisanyaprabhaviList.firstWhereOrNull((e) => e.pkId == selectedMukhyaAtithi);
                        }
                      });
                    },
                  ),
                  SizedBox(height: 6),
                  Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onPressed: onAdd,
                        child: Text(
                          Statics.getLabel('fillNewRecord'),
                          style: const TextStyle(color: Colors.purpleAccent),
                        ),
                      )),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                // height: 400,
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.58),
                child: Scrollbar(
                  radius: Radius.circular(8),
                  interactive: true,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                Statics.getLabel('SajjanShakti'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),

                        // ✅ Table
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Table(
                            border: TableBorder.symmetric(
                              inside: const BorderSide(color: Colors.black12),
                            ),
                            columnWidths: const {
                              0: FixedColumnWidth(50),
                            },
                            children: [
                              // Header
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("🔘", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("${Statics.getLabel('Name')}", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              ...vastisarsajjanshaktiList.map((item) {
                                return TableRow(
                                  children: [
                                    Center(
                                        child: Radio(
                                      value: item,
                                      groupValue: selectedItem,
                                      activeColor: Colors.purpleAccent,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      onChanged: (val) {
                                        print("printing the val >>>>>>>> ${jsonEncode(val)}");
                                        set(() {
                                          selectedItem = val;
                                          selectedType = "sarsajjanshakti";
                                        });
                                      },
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(item.name ?? "Unknown"),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                        // ...vastisarsajjanshaktiList.map((item) {
                        //   return RadioListTile(
                        //     title: Text(item.name ?? "Unknown"),
                        //     value: item,
                        //     groupValue: selectedItem,
                        //     activeColor: Colors.purpleAccent,
                        //     contentPadding: EdgeInsets.zero,
                        //     onChanged: (val) {
                        //       print("printing the val >>>>>>>> ${jsonEncode(val)}");
                        //       set(() {
                        //         selectedItem = val;
                        //         selectedType = "sarsajjanshakti";
                        //       });
                        //     },
                        //   );
                        // }),
                        const SizedBox(height: 16),
                        Text(
                          Statics.getLabel('anyaPrabhaviLok'),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const Divider(),

                        // ✅ Table
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Table(
                            border: TableBorder.symmetric(
                              inside: const BorderSide(color: Colors.black12),
                            ),
                            columnWidths: const {
                              0: FixedColumnWidth(50),
                            },
                            children: [
                              // Header
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("🔘", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("${Statics.getLabel('Name')}", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              ...vastisanyaprabhaviList.map((item) {
                                return TableRow(
                                  children: [
                                    Center(
                                        child: Radio(
                                      value: item,
                                      groupValue: selectedItem,
                                      activeColor: Colors.purpleAccent,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      onChanged: (val) {
                                        set(() {
                                          selectedItem = val;
                                          selectedType = "anyaprabhavi";
                                        });
                                      },
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(item.name ?? "Unknown"),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                        // ...vastisanyaprabhaviList.map((item) {
                        //   return RadioListTile(
                        //     title: Text(item.name ?? "Unknown"),
                        //     value: item,
                        //     groupValue: selectedItem,
                        //     activeColor: Colors.blueAccent,
                        //     contentPadding: EdgeInsets.zero,
                        //     onChanged: (val) {
                        //       set(() {
                        //         selectedItem = val;
                        //         selectedType = "anyaprabhavi";
                        //       });
                        //     },
                        //   );
                        // }),
                      ],
                    ),
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 6),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onPressed: () {
                          if (selectedItem != null && selectedType != null) {
                            String id = "";
                            if (selectedType == "sarsajjanshakti") {
                              id = (selectedItem as Vastisarsajjanshakti).pkid.toString();
                            } else {
                              id = (selectedItem as Vastisanyaprabhavi).pkId.toString();
                            }
                            onSubmit(id, selectedType!, selectedItem);
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          Statics.getLabel('Submit'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 15,
                    // ),
                    // OutlinedButton(
                    //   style: OutlinedButton.styleFrom(
                    //     side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    //   ),
                    //   onPressed: onAdd,
                    //   child: Text(
                    //     Statics.getLabel('fillNewRecord'),
                    //     style: const TextStyle(color: Colors.purpleAccent),
                    //   ),
                    // ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  String? selectedSajjanshaktiItemsIds;
  String? selectedAnyaprabhaviItemsIds;

  Future<void> showVisheshAtithiSelectionPopup(
    BuildContext context, {
    required List<Vastisarsajjanshakti> vastisarsajjanshaktiList,
    required List<Vastisanyaprabhavi> vastisanyaprabhaviList,
    required List<Vastisarsajjanshakti> selectedSajjanshaktiItems,
    required List<Vastisanyaprabhavi> selectedAnyaprabhaviItems,
    required dynamic excludedItem,
    required String? sajjanshaktiIds,
    required String? anyaprabhaviIds,
    required String? selectedType, // 👈 नया parameter
    required int? selectedMukhyaAtithi, // 👈 नया parameter
    required VoidCallback onAdd,
    required void Function(
      String sajjanshaktiIds,
      String anyaprabhaviIds,
      List<Vastisarsajjanshakti> selectedSajjanshakti,
      List<Vastisanyaprabhavi> selectedAnyaprabhavi,
    ) onSubmit,
  }) async {
    print("showVisheshAtithiSelectionPopup onTap >>>>>>>>>>>>>>> $sajjanshaktiIds");
    print("showVisheshAtithiSelectionPopup onTap >>>>>>>>>>>>>>> $anyaprabhaviIds");
    _linkedNagarValuePopup = "";

    List<Vastisarsajjanshakti> filteredSajjanshakti = vastisarsajjanshaktiList.where((e) {
      if (excludedItem != null && excludedItem is Vastisarsajjanshakti) {
        if (e.pkid == excludedItem.pkid) return false;
      }

      // 👇 अगर selectedType = "sarsajjanshakti" है तो selectedMukhyaAtithi को exclude करना
      if (selectedType == "sarsajjanshakti" && selectedMukhyaAtithi != null) {
        if (e.pkid == selectedMukhyaAtithi) return false;
      }

      return true;
    }).toList();

    List<Vastisanyaprabhavi> filteredAnyaprabhavi = vastisanyaprabhaviList.where((e) {
      if (excludedItem != null && excludedItem is Vastisanyaprabhavi) {
        if (e.pkId == excludedItem.pkId) return false;
      }

      // 👇 अगर selectedType = "anyaprabhavi" है तो selectedMukhyaAtithi को exclude करना
      if (selectedType == "anyaprabhavi" && selectedMukhyaAtithi != null) {
        if (e.pkId == selectedMukhyaAtithi) return false;
      }

      return true;
    }).toList();

    /// ✅ Preselect items from comma separated IDs
    List<Vastisarsajjanshakti> selectedSajjanshakti = [];
    selectedSajjanshakti.addAll(selectedSajjanshaktiItems);
    if (sajjanshaktiIds != null && sajjanshaktiIds.isNotEmpty) {
      final ids = sajjanshaktiIds.split(",").map((e) => e.trim()).toList();
      // selectedSajjanshakti.addAll(filteredSajjanshakti.where((e) => ids.contains(e.pkid.toString())).toList());
      selectedSajjanshakti.toSet().toList();
    }

    List<Vastisanyaprabhavi> selectedAnyaprabhavi = [];
    selectedAnyaprabhavi.addAll(selectedAnyaprabhaviItems);
    if (anyaprabhaviIds != null && anyaprabhaviIds.isNotEmpty) {
      final ids = anyaprabhaviIds.split(",").map((e) => e.trim()).toList();
      // selectedAnyaprabhavi.addAll(filteredAnyaprabhavi.where((e) => ids.contains(e.pkId.toString())).toList());
      selectedAnyaprabhavi.toSet().toList();
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, set) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              content: Container(
                // padding: const EdgeInsets.all(16),
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Title with Close Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Statics.getLabel('selectVIshishthaAtithi'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.purpleAccent,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: Statics.getLabel('Nagar'),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      isExpanded: true,
                      value: _linkedNagarValuePopup == "" ? _linkedNagarValue : _linkedNagarValuePopup,
                      items: _linkedNagar?.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) async {
                        set(() {
                          _linkedNagarValuePopup = value;
                        });
                        final _data = await Statics.getVijayadashamiInitData(context, Statics.userDetails["userID"], value, "6");

                        set(() {
                          vastisarsajjanshaktiList = _data?.vastisarsajjanshakti ?? [];
                          vastisanyaprabhaviList = _data?.vastisanyaprabhavi ?? [];
                        });
                        set(() {
                          // if (vastisarsajjanshaktiList.isEmpty) return;
                          // if (vastisanyaprabhaviList.isEmpty) return;

                          filteredSajjanshakti = vastisarsajjanshaktiList.where((e) {
                            if (excludedItem != null && excludedItem is Vastisarsajjanshakti) {
                              if (e.pkid == excludedItem.pkid) return false;
                            }

                            // 👇 अगर selectedType = "sarsajjanshakti" है तो selectedMukhyaAtithi को exclude करना
                            if (selectedType == "sarsajjanshakti" && selectedMukhyaAtithi != null) {
                              if (e.pkid == selectedMukhyaAtithi) return false;
                            }

                            return true;
                          }).toList();

                          filteredAnyaprabhavi = vastisanyaprabhaviList.where((e) {
                            if (excludedItem != null && excludedItem is Vastisanyaprabhavi) {
                              if (e.pkId == excludedItem.pkId) return false;
                            }

                            // 👇 अगर selectedType = "anyaprabhavi" है तो selectedMukhyaAtithi को exclude करना
                            if (selectedType == "anyaprabhavi" && selectedMukhyaAtithi != null) {
                              if (e.pkId == selectedMukhyaAtithi) return false;
                            }

                            return true;
                          }).toList();
                        });

                        set(() {
                          if (selectedType == "sarsajjanshakti") {
                            if (sajjanshaktiIds != null && sajjanshaktiIds.isNotEmpty) {
                              print("Printing ids >>>>>>>>> $sajjanshaktiIds");
                              final ids = sajjanshaktiIds.split(",").map((e) => e.trim()).toList();
                              selectedSajjanshakti.addAll(filteredSajjanshakti.where((e) => ids.contains(e.pkid.toString())).toList());
                              selectedSajjanshakti.toSet().toList();
                            }
                            // selectedSajjanshakti = preselectedItem ?? vastisarsajjanshaktiList.firstWhereOrNull((e) => e.pkid == selectedMukhyaAtithi);
                          } else {
                            if (anyaprabhaviIds != null && anyaprabhaviIds.isNotEmpty) {
                              print("Printing ids >>>>>>>>> $anyaprabhaviIds");
                              final ids = anyaprabhaviIds.split(",").map((e) => e.trim()).toList();
                              selectedAnyaprabhavi.addAll(filteredAnyaprabhavi.where((e) => ids.contains(e.pkId.toString())).toList());
                              selectedAnyaprabhavi.toSet().toList();
                            }
                            // selectedAnyaprabhavi = preselectedItem ?? vastisanyaprabhaviList.firstWhereOrNull((e) => e.pkId == selectedMukhyaAtithi);
                          }
                        });
                        // String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                        // String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
                        //
                        // set(() {
                        //   onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                        // });
                      },
                    ),
                    SizedBox(height: 6),
                    Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                          onPressed: onAdd,
                          child: Text(
                            Statics.getLabel('fillNewRecord'),
                            style: const TextStyle(color: Colors.purpleAccent),
                          ),
                        )),
                    SizedBox(height: 6),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            /// Content
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              child: Table(
                                border: TableBorder.symmetric(
                                  inside: const BorderSide(color: Colors.black12),
                                ),
                                columnWidths: const {
                                  0: FixedColumnWidth(50),
                                },
                                children: [
                                  // Header
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                    ),
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("✔", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(Statics.getLabel("Name"), style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  ...filteredSajjanshakti.map((item) {
                                    return TableRow(
                                      children: [
                                        Center(
                                            child: Checkbox(
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          value: selectedSajjanshakti.any((x) => x.pkid == item.pkid),
                                          onChanged: (val) {
                                            set(() {
                                              if (val == true) {
                                                selectedSajjanshakti.add(item);
                                              } else {
                                                selectedSajjanshakti.removeWhere((x) => x.pkid == item.pkid);
                                              }
                                            });
                                            String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                                            String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
                                            log(sajIds);
                                            log("-----------------------------");
                                            log(anyaIds);

                                            onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                                            set(() {});
                                          },
                                        )),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(item.name ?? "Unknown"),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            /// Anya Prabhavi Lok
                            Text(
                              Statics.getLabel('anyaPrabhaviLok'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const Divider(),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              child: Table(
                                border: TableBorder.symmetric(
                                  inside: const BorderSide(color: Colors.black12),
                                ),
                                columnWidths: const {
                                  0: FixedColumnWidth(50),
                                },
                                children: [
                                  // Header
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                    ),
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("✔", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(Statics.getLabel("Name"), style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  ...filteredAnyaprabhavi.map((item) {
                                    return TableRow(
                                      children: [
                                        Center(
                                            child: Checkbox(
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          value: selectedAnyaprabhavi.any((x) => x.pkId == item.pkId),
                                          onChanged: (val) {
                                            set(() {
                                              if (val == true) {
                                                selectedAnyaprabhavi.add(item);
                                              } else {
                                                selectedAnyaprabhavi.removeWhere((x) => x.pkId == item.pkId);
                                              }
                                            });
                                            String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                                            String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");

                                            onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                                            log(sajIds);
                                            log(anyaIds);
                                            set(() {});
                                          },
                                        )),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(item.name ?? "Unknown"),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),

                            // ...filteredAnyaprabhavi.map((item) {
                            //   return CheckboxListTile(
                            //     dense: true,
                            //     contentPadding: EdgeInsets.zero,
                            //     title: Text(item.name ?? "Unknown"),
                            //     value: selectedAnyaprabhavi.any((x) => x.pkId == item.pkId),
                            //     onChanged: (val) {
                            //       set(() {
                            //         if (val == true) {
                            //           selectedAnyaprabhavi.add(item);
                            //         } else {
                            //           selectedAnyaprabhavi.removeWhere((x) => x.pkId == item.pkId);
                            //         }
                            //       });
                            //       String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                            //       String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
                            //
                            //       onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                            //       log(sajIds);
                            //       log(anyaIds);
                            //       set(() {});
                            //     },
                            //   );
                            // }),
                            // Expanded(
                            //   child: SingleChildScrollView(
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         /// Sajjan Shakti
                            //         Text(
                            //           Statics.getLabel('SajjanShakti'),
                            //           style: const TextStyle(
                            //             fontWeight: FontWeight.w600,
                            //             fontSize: 16,
                            //             color: Colors.blueGrey,
                            //           ),
                            //         ),
                            //         const Divider(),
                            //
                            //         ...filteredSajjanshakti.map((item) {
                            //           return CheckboxListTile(
                            //             dense: true,
                            //             contentPadding: EdgeInsets.zero,
                            //             title: Text(item.name ?? "Unknown"),
                            //             value: selectedSajjanshakti.any((x) => x.pkid == item.pkid),
                            //             onChanged: (val) {
                            //               set(() {
                            //                 if (val == true) {
                            //                   selectedSajjanshakti.add(item);
                            //                 } else {
                            //                   selectedSajjanshakti.removeWhere((x) => x.pkid == item.pkid);
                            //                 }
                            //               });
                            //               String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                            //               String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
                            //               log(sajIds);
                            //               log("-----------------------------");
                            //               log(anyaIds);
                            //
                            //               onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                            //               set(() {});
                            //             },
                            //           );
                            //         }),
                            //
                            //         const SizedBox(height: 12),
                            //
                            //         /// Anya Prabhavi Lok
                            //         Text(
                            //           Statics.getLabel('anyaPrabhaviLok'),
                            //           style: const TextStyle(
                            //             fontWeight: FontWeight.w600,
                            //             fontSize: 16,
                            //             color: Colors.blueGrey,
                            //           ),
                            //         ),
                            //         const Divider(),
                            //
                            //         ...filteredAnyaprabhavi.map((item) {
                            //           return CheckboxListTile(
                            //             dense: true,
                            //             contentPadding: EdgeInsets.zero,
                            //             title: Text(item.name ?? "Unknown"),
                            //             value: selectedAnyaprabhavi.any((x) => x.pkId == item.pkId),
                            //             onChanged: (val) {
                            //               set(() {
                            //                 if (val == true) {
                            //                   selectedAnyaprabhavi.add(item);
                            //                 } else {
                            //                   selectedAnyaprabhavi.removeWhere((x) => x.pkId == item.pkId);
                            //                 }
                            //               });
                            //               String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                            //               String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
                            //
                            //               onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                            //               log(sajIds);
                            //               log(anyaIds);
                            //               set(() {});
                            //             },
                            //           );
                            //         }),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purpleAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                              String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");

                              onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);

                              Navigator.pop(context);
                            },
                            child: Text(
                              Statics.getLabel('Submit'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<UpnagarmandallistVijayaDashami> checkboxGraamVastiSelectedItems = [];
  int? selectedVastiCount = 0;
  int totalVastiCount = 0;
  String? selectedBhougolikPratinidhitwaVastiIds;

  Future<void> showGraamVastiMandalUpnagarPopup(
    BuildContext context, {
    required List<UpnagarmandallistVijayaDashami> vastiList,
    List<UpnagarmandallistVijayaDashami>? preselectedItems,
    required void Function(
      List<UpnagarmandallistVijayaDashami> selectedItems,
      int selectedCount,
      int totalCount,
    ) onSubmit,
  }) async {
    List<UpnagarmandallistVijayaDashami> selectedItems = List.from(preselectedItems ?? []);
    print((vastiList.length));
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height * 0.6, // ✅ Standard height
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Title & counts
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${Statics.getLabel('addVastiGram')}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.redAccent),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(),
                    Text(
                      "${Statics.getLabel('totalVastiGram')}: ${vastiList.length}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      "${Statics.getLabel('selectedTotal')}: ${selectedItems.length}",
                      style: const TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                    const SizedBox(height: 10),

                    // ✅ List scrollable
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListView.builder(
                          itemCount: vastiList.length,
                          itemBuilder: (context, index) {
                            final item = vastiList[index];
                            final isSelected = selectedItems.contains(item);

                            return CheckboxListTile(
                              title: Text(item.preferedname ?? ""),
                              value: selectedItems.any((e) => e.geoUnitID == item.geoUnitID), // ✅ check by id
                              onChanged: (bool? checked) {
                                setState(() {
                                  if (checked == true) {
                                    if (!selectedItems.any((e) => e.geoUnitID == item.geoUnitID)) {
                                      selectedItems.add(item);
                                    }
                                  } else {
                                    selectedItems.removeWhere((e) => e.geoUnitID == item.geoUnitID);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ✅ Footer Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        onSubmit(
                          selectedItems,
                          selectedItems.length,
                          vastiList.length,
                        );
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          Statics.getLabel('Submit'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  VastiCounts? countsShakhaa;

  List<Shakhaalist> checkboxShakhaSelectedItems = [];
  int totalShakhaCount = 0;
  int selectedShakhaCount = 0;
  String averageShakhaCount = "0";
  String? selectedShakhaaPratinidhitwaVastiIds;

  Future<void> showShakhaalistPopup(
    BuildContext context, {
    required List<Shakhaalist> shakhaalist,
    List<Shakhaalist>? preselectedItems,
    required void Function(
      List<Shakhaalist> selectedItems,
      VastiCounts counts,
    ) onSubmit,
  }) async {
    log("showShakhaalistPopup Opened >>>>>>>>>>>>>>>>>>>>> ");
    List<Shakhaalist> selectedItems = List.from(preselectedItems ?? []);

    final List<String> vayogatOptions = shakhaalist.map((e) => e.vayogatname ?? "").where((e) => e.isNotEmpty).toSet().toList();

    String? selectedVayogat;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredList = selectedVayogat == null ? shakhaalist : shakhaalist.where((e) => e.vayogatname == selectedVayogat).toList();

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                // ✅ Standard height for popup (60% of screen)
                height: MediaQuery.of(context).size.height * 0.75,
                width: double.maxFinite,
                child: Column(
                  children: [
                    // ✅ Title Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Statics.getLabel('selectshakhaa'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.redAccent),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(),

                    // ✅ Dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        labelText: Statics.getLabel("Vayogat"),
                      ),
                      value: selectedVayogat,
                      items: vayogatOptions.map((v) {
                        return DropdownMenuItem(
                          value: v,
                          child: Text(v),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedVayogat = val;
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    // ✅ Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${Statics.getLabel('Total')} : ${filteredList.where((item) => item.frequencyName == "शाखा").length}",
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          "${Statics.getLabel('selectedTotal')} : ${selectedItems.where((item) => item.frequencyName == "शाखा").length}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ✅ Table inside scroll
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
                          child: Table(
                            border: TableBorder.symmetric(
                              inside: const BorderSide(color: Colors.black12),
                            ),
                            columnWidths: const {
                              0: FixedColumnWidth(50),
                            },
                            children: [
                              // Header
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("✔", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(Statics.getLabel("Name"), style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              ...filteredList.where((item) => item.frequencyName == "शाखा").map((item) {
                                final isSelected = selectedItems.contains(item);

                                return TableRow(
                                  children: [
                                    Center(
                                      child: Checkbox(
                                        value: isSelected,
                                        onChanged: (checked) {
                                          setState(() {
                                            if (checked == true) {
                                              selectedItems.add(item);
                                            } else {
                                              selectedItems.remove(item);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(item.preferedname ?? ""),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ✅ Footer
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        final Map<String, int> vayogatCounts = {};
                        for (var item in selectedItems) {
                          final key = item.vayogatname ?? "Unknown";
                          vayogatCounts[key] = (vayogatCounts[key] ?? 0) + 1;
                        }

                        final counts = VastiCounts(
                          prakarCounts: {},
                          vayogatCounts: vayogatCounts,
                        );

                        onSubmit(selectedItems, counts);
                        Navigator.pop(context);
                      },
                      child: Text(
                        Statics.getLabel('Submit'),
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  VastiCounts? countsMilan;
  List<Shakhaalist> checkboxMilanSelectedItems = [];
  int totalMilanCount = 0;
  int selectedMilanCount = 0;
  String averageMilanCount = "0";
  String? selectedMilanPratinidhitwaVastiIds;

  Future<void> showMilanalistPopup(
    BuildContext context, {
    required List<Shakhaalist> milanalist,
    List<Shakhaalist>? preselectedItems,
    required void Function(
      List<Shakhaalist> selectedItems,
      VastiCounts counts,
    ) onSubmit,
  }) async {
    List<Shakhaalist> selectedItems = List.from(preselectedItems ?? []);

    final List<String> vayogatOptions = milanalist.map((e) => e.vayogatname ?? "").where((e) => e.isNotEmpty).toSet().toList();

    String? selectedVayogat;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredList = selectedVayogat == null ? milanalist : milanalist.where((e) => e.vayogatname == selectedVayogat).toList();

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                // ✅ Standard height for popup (60% of screen)
                height: MediaQuery.of(context).size.height * 0.75,
                width: double.maxFinite,
                child: Column(
                  children: [
                    // ✅ Title Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Statics.getLabel('selectSaptahikMilan'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.redAccent),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(),

                    // ✅ Dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        labelText: Statics.getLabel("Vayogat"),
                      ),
                      value: selectedVayogat,
                      items: vayogatOptions.map((v) {
                        return DropdownMenuItem(
                          value: v,
                          child: Text(v),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedVayogat = val;
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    // ✅ Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${Statics.getLabel('Total')} : ${filteredList.where((item) => item.frequencyName == "साप्ताहिक मिलन").length}",
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          "${Statics.getLabel('selectedTotal')} : ${selectedItems.where((item) => item.frequencyName == "साप्ताहिक मिलन").length}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ✅ Table inside scroll
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
                          child: Table(
                            border: TableBorder.symmetric(
                              inside: const BorderSide(color: Colors.black12),
                            ),
                            columnWidths: const {
                              0: FixedColumnWidth(50),
                            },
                            children: [
                              // Header
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("✔", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(Statics.getLabel("Name"), style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              ...filteredList.where((item) => item.frequencyName == "साप्ताहिक मिलन").map((item) {
                                final isSelected = selectedItems.contains(item);

                                return TableRow(
                                  children: [
                                    Center(
                                      child: Checkbox(
                                        value: isSelected,
                                        onChanged: (checked) {
                                          setState(() {
                                            if (checked == true) {
                                              selectedItems.add(item);
                                            } else {
                                              selectedItems.remove(item);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(item.preferedname ?? ""),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ✅ Footer
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        final Map<String, int> vayogatCounts = {};
                        for (var item in selectedItems) {
                          final key = item.vayogatname ?? "Unknown";
                          vayogatCounts[key] = (vayogatCounts[key] ?? 0) + 1;
                        }

                        final counts = VastiCounts(
                          prakarCounts: {},
                          vayogatCounts: vayogatCounts,
                        );

                        onSubmit(selectedItems, counts);
                        Navigator.pop(context);
                      },
                      child: Text(
                        Statics.getLabel('Submit'),
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  VastiCounts? countsSanghaMandali;
  List<Shakhaalist> checkboxSanghaMandaliSelectedItems = [];
  int totalSanghaMandaliCount = 0;
  int selectedSanghaMandaliCount = 0;
  String averageSanghaMandaliCount = "0";
  String? selectedSanghaMandaliPratinidhitwaVastiIds;

  Future<void> showSanghaMandalialistPopup(
    BuildContext context, {
    required List<Shakhaalist> sanghaMandalialist,
    List<Shakhaalist>? preselectedItems,
    required void Function(
      List<Shakhaalist> selectedItems,
      VastiCounts counts,
    ) onSubmit,
  }) async {
    List<Shakhaalist> selectedItems = List.from(preselectedItems ?? []);

    final List<String> vayogatOptions = sanghaMandalialist.map((e) => e.vayogatname ?? "").where((e) => e.isNotEmpty).toSet().toList();

    String? selectedVayogat;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredList = selectedVayogat == null ? sanghaMandalialist : sanghaMandalialist.where((e) => e.vayogatname == selectedVayogat).toList();

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                // ✅ Standard height for popup (60% of screen)
                height: MediaQuery.of(context).size.height * 0.75,
                width: double.maxFinite,
                child: Column(
                  children: [
                    // ✅ Title Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Statics.getLabel('selectSanghaMandali'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.redAccent),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(),

                    // ✅ Dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        labelText: Statics.getLabel("Vayogat"),
                      ),
                      value: selectedVayogat,
                      items: vayogatOptions.map((v) {
                        return DropdownMenuItem(
                          value: v,
                          child: Text(v),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedVayogat = val;
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    // ✅ Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${Statics.getLabel('Total')} : ${filteredList.where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length}",
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          "${Statics.getLabel('selectedTotal')} : ${selectedItems.where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ✅ Table inside scroll
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
                          child: Table(
                            border: TableBorder.symmetric(
                              inside: const BorderSide(color: Colors.black12),
                            ),
                            columnWidths: const {
                              0: FixedColumnWidth(50),
                            },
                            children: [
                              // Header
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("✔", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(Statics.getLabel("Name"), style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              ...filteredList.where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").map((item) {
                                final isSelected = selectedItems.contains(item);

                                return TableRow(
                                  children: [
                                    Center(
                                      child: Checkbox(
                                        value: isSelected,
                                        onChanged: (checked) {
                                          setState(() {
                                            if (checked == true) {
                                              selectedItems.add(item);
                                            } else {
                                              selectedItems.remove(item);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(item.preferedname ?? ""),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ✅ Footer
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        final Map<String, int> vayogatCounts = {};
                        for (var item in selectedItems) {
                          final key = item.vayogatname ?? "Unknown";
                          vayogatCounts[key] = (vayogatCounts[key] ?? 0) + 1;
                        }

                        final counts = VastiCounts(
                          prakarCounts: {},
                          vayogatCounts: vayogatCounts,
                        );

                        onSubmit(selectedItems, counts);
                        Navigator.pop(context);
                      },
                      child: Text(
                        Statics.getLabel('Submit'),
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String? utsavKontyaStaravar = "";
  List<Map<String, String>> utsavKontyaStaravarList = [
    {"2": "${Statics.getLabel('SelectVasti')}"},
    {"4": "${Statics.getLabel('Mandal')}"},
    {"13": "${Statics.getLabel('upnagarUpkhanda')}"},
    {"6": "${Statics.getLabel('NagarKaaryakartaaCount')}"}
  ];

  VastiUpDataListModel? vastiUpDataListModel;

  Future<void> getVastiUpDataList() async {
    var inputData = json.encode({
      "AppUserID": Statics.userDetails['userID'],
      "GeoUnitID": selectedUpnagarList.isEmpty ? _selectedGeoUnitId.toString() : selectedUpnagarList.join(","),
      "isnagar": int.parse(utsavKontyaStaravar ?? "6"),
    });

    print("_submitForm $inputData");

    vastiUpDataListModel = await Statics.getVastiUpdata(inputData);

    ///
    getFormData();

    ///
    if (vastiUpDataListModel != null) {
      print("Data fetched successfully");
      setState(() {
        print("selectedIdString getVastiUpDataList  --->>>   ${jsonDecode(jsonEncode(vastiUpDataListModel))}");
      });
    } else {
      print("Failed to fetch data");
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GUARD: require geo-unit selection before editing
  // ═══════════════════════════════════════════════════════════════════════════

  bool _guardSearch() {
    if (!_isSearching) {
      Fluttertoast.showToast(msg: Statics.getLabel('NagarSelectionImportant'));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${Statics.getLabel('vijayaDashamiUtsav')}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          if ((userLevelId ?? 0) >= 6 && (userLevelId ?? 0) < 13)
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(VijayadashamiFormReport.routeName);
                },
                icon: Icon(Icons.document_scanner_outlined))
        ],
      ),
      drawer: AppDrawer(),
      body: Form(
        key: _formKey,
        child: ListView(
          controller: _mainScrollController,
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purpleAccent),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.01,
                horizontal: size.width * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${Statics.getLabel('vijaaydashamiStarQuestion')}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('Level')),
                      isExpanded: true,
                      value: utsavKontyaStaravar == "" ? null : utsavKontyaStaravar,
                      items: utsavKontyaStaravarList.map((bg) => DropdownMenuItem(value: bg.keys.first.toString(), child: Text(bg.values.first.toString()))).toList(),
                      onChanged: (value) async {
                        setState(() {
                          utsavKontyaStaravar = value;
                          _isExpanded = true;
                        });
                        await clearForm(fromManual: true);
                        setState(() {
                          utsavKontyaStaravar = value;
                          _isExpanded = true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: RadioListTile<String>(
                  //         contentPadding: EdgeInsets.zero,
                  //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //         title: Text("${Statics.getLabel('NagarKaaryakartaaCount')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  //         value: "6",
                  //         groupValue: utsavKontyaStaravar,
                  //         onChanged: (value) async {
                  //           await clearForm();
                  //           setState(() {
                  //             utsavKontyaStaravar = value;
                  //             _isExpanded = true;
                  //           });
                  //         },
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: RadioListTile<String>(
                  //         contentPadding: EdgeInsets.zero,
                  //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //         title: Text("${Statics.getLabel('upnagarUpkhanda')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  //         value: "13",
                  //         groupValue: utsavKontyaStaravar,
                  //         onChanged: (value) async {
                  //           await clearForm();
                  //           setState(() {
                  //             utsavKontyaStaravar = value;
                  //             _isExpanded = true;
                  //           });
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: RadioListTile<String>(
                  //         contentPadding: EdgeInsets.zero,
                  //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //         title: Text("${Statics.getLabel('Mandal')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  //         value: "4",
                  //         groupValue: utsavKontyaStaravar,
                  //         onChanged: (value) async {
                  //           await clearForm();
                  //           setState(() {
                  //             utsavKontyaStaravar = value;
                  //             _isExpanded = true;
                  //           });
                  //           populatelinkedVibhaagDropdownForMandal('');
                  //         },
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: RadioListTile<String>(
                  //         contentPadding: EdgeInsets.zero,
                  //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //         title: Text("${Statics.getLabel('SelectVasti')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  //         value: "2",
                  //         groupValue: utsavKontyaStaravar,
                  //         onChanged: (value) async {
                  //           await clearForm();
                  //           setState(() {
                  //             utsavKontyaStaravar = value;
                  //             _isExpanded = true;
                  //           });
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
//=======================================   SEARCH FILTERS ==========================================================================================
            stharDropdown(),

            // utsavKontyaStaravar == "2"
            //     ? vastiDropdown()
            //     : utsavKontyaStaravar == "4"
            //         ? mandalDropdown()
            //         : utsavKontyaStaravar == "13"
            //             ? upnagarDropdown()
            //             : nagarDropdown(),
            SizedBox(
              height: 20,
            ),
            if (isVastiSearch == false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    // ""
                    // "${Statics.getLabel('Note')} :- "
                    "${Statics.getLabel('NagarSelectionImportant')}",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: Colors.red,
                  ),
                ],
              ),
            if (selctedLevel != "" && selctedLevelName != "" && isVastiSearch == true)
              Container(
                  // height: 40,
                  width: MediaQuery.sizeOf(context).width,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purpleAccent, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "${Statics.getLabel(selctedLevel ?? 'Nagar')}",
                          style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      if (selctedLevelName != null && selctedLevelName!.isNotEmpty)
                        Flexible(
                          child: Text(
                            "  ->   $selctedLevelName",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ),
                    ],
                  )),
            SizedBox(
              height: 10,
            ),
// ================================== 1 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('utsavLable')}  ${Statics.getLabel('Information')}",
              Column(
                children: [
                  yesNoRadioButton(
                    question: "${Statics.getLabel('ProgramNirdharitTime')}",
                    selectedOption: programNirdharitVed ?? 2,
                    imp: " *",
                    onChanged: (value) {
                      setState(() {
                        programNirdharitVed = value;
                      });
                    },
                  ),
                  yesNoRadioButton(
                    question: "${Statics.getLabel('vaiyaktikGitKantashtha')}",
                    selectedOption: vaiyaktikGitKantashtha ?? 2,
                    imp: " *",
                    onChanged: (value) {
                      setState(() {
                        vaiyaktikGitKantashtha = value;
                      });
                    },
                  ),
                  yesNoRadioButton(
                    question: "${Statics.getLabel('programHishobh24Hour')}",
                    selectedOption: programHishobh24Hour ?? 2,
                    imp: " *",
                    onChanged: (value) {
                      setState(() {
                        programHishobh24Hour = value;
                      });
                    },
                  ),
                ],
              ),
            ),
// ================================== 2 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('mukhyaAtithi')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (_isSearching == false) {
                            Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");
                            return;
                          }
                          final list = data?.vastisarsajjanshakti ?? [];
                          final preselected = list.any((e) => e.pkid == selectedMukhyaAtithi) ? list.firstWhere((e) => e.pkid == selectedMukhyaAtithi) : null;

                          showMukhyaAtithiSelectionPopup(
                            context,
                            vastisarsajjanshaktiList: data?.vastisarsajjanshakti ?? [],
                            vastisanyaprabhaviList: data?.vastisanyaprabhavi ?? [],
                            preselectedItem: preselected,
                            preselectedType: selectedType,
                            onSubmit: (id, type, selectedItem) {
                              setState(() {
                                selectedType = type;
                                if (type == "sarsajjanshakti") {
                                  selectedPerson = selectedItem as Vastisarsajjanshakti;
                                  selectedPrabhavi = null;
                                  selectedMukhyaAtithi = selectedPerson?.pkid;
                                } else {
                                  selectedPrabhavi = selectedItem as Vastisanyaprabhavi;
                                  selectedPerson = null;
                                  selectedMukhyaAtithi = selectedPrabhavi?.pkId;
                                }
                              });
                            },
                            onAdd: () {
                              Navigator.of(context).pushReplacementNamed(
                                AddMukhyaAtithi.routeName,
                                arguments: {'linkedNagar': _linkedNagar, 'selectedLevelId': _linkedNagarValue},
                              ).then((value) => searchVijayaDashami());
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 130,
                          height: 35,
                          decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 5),
                                Text(
                                  "${Statics.getLabel('addMukhyaAtithi')}",
                                  style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Table(
                    border: TableBorder.all(),
                    columnWidths: const {
                      0: FixedColumnWidth(40),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text("${Statics.getLabel('serialNo')}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text("${Statics.getLabel('Name')}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text("${Statics.getLabel('samparkSootraNaav')}"),
                          ),
                          Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('ViewMenu')}")),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(padding: EdgeInsets.all(4), child: Text("1")),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(selectedPerson?.name ?? selectedPrabhavi?.name ?? ""),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(selectedPerson?.samparkasutranava ?? selectedPrabhavi?.samparkAsutraNav ?? ""),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_red_eye, size: 22, color: Colors.purpleAccent),
                            onPressed: () {
                              // 👇 Check which object is available and open popup
                              if (selectedPerson != null) {
                                showPersonDetailsPopup(context, selectedPerson!, 1);
                              } else if (selectedPrabhavi != null) {
                                showPersonDetailsPopup(context, selectedPrabhavi!, 1);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
// ================================== 3 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('specialAtithi')}",
              Column(
                children: [
                  // Button for popup
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (_isSearching == false) {
                            Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");
                            return;
                          }
                          await showVisheshAtithiSelectionPopup(context,
                              vastisarsajjanshaktiList: data?.vastisarsajjanshakti ?? [],
                              vastisanyaprabhaviList: data?.vastisanyaprabhavi ?? [],
                              excludedItem: null,
                              sajjanshaktiIds: selectedSajjanshaktiItemsIds,
                              anyaprabhaviIds: selectedAnyaprabhaviItemsIds,
                              selectedAnyaprabhaviItems: selectedAnyaprabhaviItems,
                              selectedSajjanshaktiItems: selectedSajjanshaktiItems, onSubmit: (sajIds, anyaIds, sajList, anyaList) {
                            print("onSubmit Called >>>>>>>>>>>>>>>>>>>>>>>>>>>");
                            setState(() {
                              selectedSajjanshaktiItemsIds = sajIds;
                              selectedAnyaprabhaviItemsIds = anyaIds;
                              selectedSajjanshaktiItems = sajList;
                              selectedAnyaprabhaviItems = anyaList;
                            });

                            print(selectedSajjanshaktiItemsIds);
                            print(selectedAnyaprabhaviItemsIds);
                            // print(selectedSajjanshaktiItems);
                            // print(selectedAnyaprabhaviItems);
                          }, onAdd: () {
                            submitForm(showLoader: false);
                            Navigator.of(context).pushReplacementNamed(
                              AddVishisthaAtithi.routeName,
                              arguments: {'linkedNagar': _linkedNagar, 'selectedLevelId': _linkedNagarValue},
                            ).then((value) => searchVijayaDashami());
                          }, selectedMukhyaAtithi: selectedMukhyaAtithi, selectedType: selectedType);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 150,
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purpleAccent.shade100),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              "${Statics.getLabel('addVIshishthaAtithi')}",
                              style: TextStyle(
                                color: Colors.purpleAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Table for Sajjanshakti
                  if (selectedSajjanshaktiItems.isNotEmpty) ...[
                    Text("${Statics.getLabel('SajjanShakti')}", style: TextStyle(fontWeight: FontWeight.bold)),
                    Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FixedColumnWidth(40),
                        1: FlexColumnWidth(),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
                          children: [
                            Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('serialNo')}")),
                            Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('Name')}")),
                            Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('samparkSootraNaav')}")),
                            Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('ViewMenu')}")),
                          ],
                        ),
                        ...selectedSajjanshaktiItems.asMap().entries.map((entry) {
                          int srNo = entry.key + 1;
                          final item = entry.value;
                          return TableRow(
                            children: [
                              Padding(padding: const EdgeInsets.all(4), child: Text(srNo.toString())),
                              Padding(padding: const EdgeInsets.all(4), child: Text(item.name ?? "")),
                              Padding(padding: const EdgeInsets.all(4), child: Text(item.samparkasutranava ?? "")),
                              IconButton(
                                icon: Icon(Icons.remove_red_eye, size: 22, color: Colors.purpleAccent),
                                onPressed: () {
                                  showPersonDetailsPopup(context, item, srNo);
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Table for Anyaprabhavi
                  if (selectedAnyaprabhaviItems.isNotEmpty) ...[
                    Text("${Statics.getLabel('anyaPrabhaviLok')}", style: TextStyle(fontWeight: FontWeight.bold)),
                    Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FixedColumnWidth(40),
                        1: FlexColumnWidth(),
                        2: FlexColumnWidth(),
                        3: FixedColumnWidth(50), // 👁 button column
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
                          children: [
                            Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('serialNo')}")),
                            Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('Name')}")),
                            Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('samparkSootraNaav')}")),
                            Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('ViewMenu')}")), // 👁 column heading
                          ],
                        ),
                        ...selectedAnyaprabhaviItems.asMap().entries.map((entry) {
                          int srNo = entry.key + 1;
                          final item = entry.value;

                          return TableRow(
                            children: [
                              Padding(padding: const EdgeInsets.all(4), child: Text(srNo.toString())),
                              Padding(padding: const EdgeInsets.all(4), child: Text(item.name ?? "")),
                              Padding(padding: const EdgeInsets.all(4), child: Text(item.samparkAsutraNav ?? "")),
                              IconButton(
                                icon: Icon(Icons.remove_red_eye, size: 22, color: Colors.purpleAccent),
                                onPressed: () {
                                  showPersonDetailsPopup(context, item, srNo);
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ],
              ),
            ),
// ================================== 4 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('karyakramVakta')}",
              Column(
                children: [
                  textControllerField2(
                    name: Statics.getLabel("karyakramVaktaName"),
                    controller: txtVaktaNameController,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 12),
                  textControllerField2(
                    name: Statics.getLabel("karyakramVaktaTask"),
                    controller: txtVaktaTaskController,
                    keyboardType: TextInputType.name,
                  ),
                ],
              ),
            ),
// ================================== 5 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('swayamsewakUpastithi')}",
              Column(
                children: [
                  Scrollbar(
                    controller: _scrollController,
                    interactive: true,
                    thumbVisibility: true,
                    radius: Radius.circular(8),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal, // 👉 Horizontal scroll
                      child: Container(
                        width: 450,
                        padding: const EdgeInsets.all(8),
                        child: Table(
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          border: TableBorder.all(color: Colors.black),
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(1.5),
                            3: FlexColumnWidth(2.5),
                            4: FlexColumnWidth(2),
                          },
                          children: [
                            // Header Row
                            TableRow(
                              decoration: BoxDecoration(color: Colors.purpleAccent.shade100),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('Vayogat')}", style: const TextStyle(fontSize: 15.6, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('patSankhyaa')}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("${Statics.getLabel('Total')}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('ganveshatPresentCount')}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('otherSwayamsewakPresentCount')}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ],
                            ),

                            // Data Rows
                            TableRow(
                              // decoration: BoxDecoration(color: Colors.grey.shade300),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('Shishu')}/${Statics.getLabel('Baal')}", style: TextStyle(fontSize: 14.5)),
                                ),
                                _numberField(patShishuBaalCtrl, textBoxColor: Colors.grey.shade300, containerColor: Colors.grey.shade300),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.grey.shade300),
                                  child: Text(_rowTotal(ganShishuBaalCtrl.text, anyaShishuBaalCtrl.text).toString()),
                                ),
                                _numberField(ganShishuBaalCtrl, limitController: patShishuBaalCtrl, otherController: anyaShishuBaalCtrl),
                                _numberField(anyaShishuBaalCtrl, limitController: patShishuBaalCtrl, otherController: ganShishuBaalCtrl),
                              ],
                            ),

                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                                  child: Text("${Statics.getLabel('MahaavidyaalayeenTarunLabel')}", style: TextStyle(fontSize: 14.5)),
                                ),
                                _numberField(patMahavidyaCtrl, padding: const EdgeInsets.symmetric(vertical: 12.0), textBoxColor: Colors.grey.shade300, containerColor: Colors.grey.shade300),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.grey.shade300),
                                  child: Text(_rowTotal(ganMahavidyaCtrl.text, anyaMahavidyaCtrl.text).toString()),
                                ),
                                _numberField(ganMahavidyaCtrl, limitController: patMahavidyaCtrl, otherController: anyaMahavidyaCtrl),
                                _numberField(anyaMahavidyaCtrl, limitController: patMahavidyaCtrl, otherController: ganMahavidyaCtrl),
                              ],
                            ),

                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('TarunVyavasaayee')}", style: TextStyle(fontSize: 14.5)),
                                ),
                                _numberField(patTarunVyavCtrl, textBoxColor: Colors.grey.shade300, containerColor: Colors.grey.shade300),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.grey.shade300),
                                  child: Text(_rowTotal(ganTarunVyavCtrl.text, anyaTarunVyavCtrl.text).toString()),
                                ),
                                _numberField(ganTarunVyavCtrl, limitController: patTarunVyavCtrl, otherController: anyaTarunVyavCtrl),
                                _numberField(anyaTarunVyavCtrl, limitController: patTarunVyavCtrl, otherController: ganTarunVyavCtrl),
                              ],
                            ),

                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('ProudhaVyavasaayeeLabel')}", style: TextStyle(fontSize: 14.5)),
                                ),
                                _numberField(patProudhVyavCtrl, textBoxColor: Colors.grey.shade300, containerColor: Colors.grey.shade300),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.grey.shade300),
                                  child: Text(_rowTotal(ganProudhVyavCtrl.text, anyaProudhVyavCtrl.text).toString()),
                                ),
                                _numberField(ganProudhVyavCtrl, limitController: patProudhVyavCtrl, otherController: anyaProudhVyavCtrl),
                                _numberField(anyaProudhVyavCtrl, limitController: patProudhVyavCtrl, otherController: ganProudhVyavCtrl),
                              ],
                            ),

                            // Total Row
                            TableRow(
                              decoration: const BoxDecoration(color: Colors.amberAccent),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('Total')}", style: TextStyle(fontSize: 14.7, fontWeight: FontWeight.w900)),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(_getColumnTotal([patShishuBaalCtrl, patMahavidyaCtrl, patTarunVyavCtrl, patProudhVyavCtrl]).toString(), style: TextStyle(fontWeight: FontWeight.w900)),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        (_getColumnTotal([ganShishuBaalCtrl, ganMahavidyaCtrl, ganTarunVyavCtrl, ganProudhVyavCtrl]) +
                                                _getColumnTotal([anyaShishuBaalCtrl, anyaMahavidyaCtrl, anyaTarunVyavCtrl, anyaProudhVyavCtrl]))
                                            .toString(),
                                        style: TextStyle(fontWeight: FontWeight.w900)),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(_getColumnTotal([ganShishuBaalCtrl, ganMahavidyaCtrl, ganTarunVyavCtrl, ganProudhVyavCtrl]).toString(), style: TextStyle(fontWeight: FontWeight.w900)),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Text(_getColumnTotal([anyaShishuBaalCtrl, anyaMahavidyaCtrl, anyaTarunVyavCtrl, anyaProudhVyavCtrl]).toString(), style: TextStyle(fontWeight: FontWeight.w900)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
// ================================== 6 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('bhougolikPratinidhitwa')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (_isSearching == false) {
                            Fluttertoast.showToast(
                              msg: "${Statics.getLabel('NagarSelectionImportant')}",
                            );
                            return;
                          }
                          showGraamVastiMandalUpnagarPopup(
                            context,
                            vastiList: data?.vastimandallist ?? [],
                            preselectedItems: checkboxGraamVastiSelectedItems,
                            onSubmit: (selectedItems, selectedCount, totalCount) {
                              print("Selected: $selectedCount / $totalCount");
                              setState(() {
                                checkboxGraamVastiSelectedItems = selectedItems;
                                totalVastiCount = totalCount;
                                selectedVastiCount = selectedCount;
                                selectedBhougolikPratinidhitwaVastiIds = selectedItems.map((e) => e.geoUnitID.toString()).join(",");
                              });
                              print("Selected Items: ${selectedItems.map((e) => e.geoUnitID)}");
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
                          // width: 120,
                          height: 35,
                          decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              "${Statics.getLabel('addVastiGram')}",
                              style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('Total')} ${Statics.getLabel('VastiGram')}",
                    value: (data?.vastimandallist ?? []).length.toString(),
                  ),
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('VastiGram')} ${Statics.getLabel('pratinidhitva')}  ",
                    value: selectedVastiCount.toString(),
                  ),
                  SingleColumnRow(
                    rowColor: Colors.grey.shade300,
                    txtString: "${Statics.getLabel('average')} ${Statics.getLabel('pratinidhitva')} ",
                    value: "${(data?.vastimandallist ?? []).length > 0 ? ((selectedVastiCount! / (data?.vastimandallist ?? []).length) * 100).toStringAsFixed(0) : 0} %",
                  )
                ],
              ),
            ),
// ================================== 7 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('shakhaMilanPratinidhitwa')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (_isSearching == false) {
                            Fluttertoast.showToast(
                              msg: "${Statics.getLabel('NagarSelectionImportant')}",
                            );
                            return;
                          }
                          showShakhaalistPopup(
                            context,
                            shakhaalist: data?.shakhaalist ?? [],
                            preselectedItems: checkboxShakhaSelectedItems,
                            onSubmit: (selectedItems, counts) {
                              setState(() {
                                checkboxShakhaSelectedItems = selectedItems;
                                countsShakhaa = counts; // model me store

                                // ✅ Total shakha count
                                totalShakhaCount = (data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length;

                                // ✅ Selected shakha count
                                selectedShakhaCount = selectedItems.where((item) => item.frequencyName == "शाखा").length;
                                selectedShakhaaPratinidhitwaVastiIds = selectedItems.map((e) => e.geoUnitID.toString()).join(",");
                                // ✅ Average shakha count (percentage)
                                if (totalShakhaCount > 0) {
                                  averageShakhaCount = ((selectedShakhaCount / totalShakhaCount) * 100).round().toString();
                                } else {
                                  averageShakhaCount = "0";
                                }
                              });
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 120,
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purpleAccent.shade100),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 5),
                                Text(
                                  "${Statics.getLabel('selectshakhaa')}",
                                  style: const TextStyle(
                                    color: Colors.purpleAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ✅ Results after submit
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('Total')} ${Statics.getLabel('Shaakhaa')} ",
                    value: "${(data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length}",
                  ),
                  SingleColumnRow(
                    txtString: " ${Statics.getLabel('Shaakhaa')} ${Statics.getLabel('pratinidhitva')}",
                    value: "$selectedShakhaCount",
                  ),
                  SingleColumnRow(
                    rowColor: Colors.grey.shade300,
                    txtString: " ${Statics.getLabel('Shaakhaa')} ${Statics.getLabel('average')} ${Statics.getLabel('pratinidhitva')} ",
                    value: ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length > 0
                            ? ((selectedShakhaCount / (data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length) * 100).round().toString()
                            : "0") +
                        " %",
                  ),
                ],
              ),
            ),
// ================================== 8 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('MilanPratinidhitwa')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (_isSearching == false) {
                            Fluttertoast.showToast(
                              msg: "${Statics.getLabel('NagarSelectionImportant')}",
                            );
                            return;
                          }
                          showMilanalistPopup(
                            context,
                            milanalist: data?.shakhaalist ?? [],
                            preselectedItems: checkboxMilanSelectedItems,
                            onSubmit: (selectedItems, counts) {
                              setState(() {
                                selectedMilanPratinidhitwaVastiIds = selectedItems.map((e) => e.geoUnitID.toString()).join(",");
                                checkboxMilanSelectedItems = selectedItems;
                                countsMilan = counts; // model me store

                                // ✅ Total shakha count
                                totalMilanCount = (data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length;

                                // ✅ Selected shakha count
                                selectedMilanCount = selectedItems.where((item) => item.frequencyName == "साप्ताहिक मिलन").length;

                                // ✅ Average shakha count (percentage)
                                if (totalMilanCount > 0) {
                                  averageMilanCount = ((selectedMilanCount / totalMilanCount) * 100).round().toString();
                                } else {
                                  averageMilanCount = "0";
                                }
                              });
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 160,
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purpleAccent.shade100),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${Statics.getLabel('selectSaptahikMilan')}",
                                  style: const TextStyle(
                                    color: Colors.purpleAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ✅ Results after submit
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('Total')} ${Statics.getLabel('SaaptaahikMilan')} ",
                    value: "${(data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length}",
                  ),
                  SingleColumnRow(
                    txtString: " ${Statics.getLabel('SaaptaahikMilan')} ${Statics.getLabel('pratinidhitva')} ",
                    value: "$selectedMilanCount",
                  ),
                  SingleColumnRow(
                    rowColor: Colors.grey.shade300,
                    txtString: " ${Statics.getLabel('SaaptaahikMilan')} ${Statics.getLabel('average')} ${Statics.getLabel('pratinidhitva')} ",
                    value: ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length > 0
                            ? ((selectedMilanCount / ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length)) * 100).round().toString()
                            : "0") +
                        " %",
                  ),
                ],
              ),
            ),
// ================================== 9 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('milanMandali')} ${Statics.getLabel('pratinidhitva')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (_isSearching == false) {
                            Fluttertoast.showToast(
                              msg: "${Statics.getLabel('NagarSelectionImportant')}",
                            );
                            return;
                          }
                          showSanghaMandalialistPopup(
                            context,
                            sanghaMandalialist: data?.shakhaalist ?? [],
                            preselectedItems: checkboxSanghaMandaliSelectedItems,
                            onSubmit: (selectedItems, counts) {
                              setState(() {
                                selectedSanghaMandaliPratinidhitwaVastiIds = selectedItems.map((e) => e.geoUnitID.toString()).join(",");
                                checkboxSanghaMandaliSelectedItems = selectedItems;
                                countsSanghaMandali = counts; // model me store

                                // ✅ Total shakha count
                                totalSanghaMandaliCount = (data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length;

                                // ✅ Selected shakha count
                                selectedSanghaMandaliCount = selectedItems.where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length;

                                // ✅ Average shakha count (percentage)
                                if (totalSanghaMandaliCount > 0) {
                                  averageSanghaMandaliCount = ((selectedSanghaMandaliCount / totalSanghaMandaliCount) * 100).round().toString();
                                } else {
                                  averageSanghaMandaliCount = "0";
                                }
                              });
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
                          // width: 200,
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purpleAccent.shade100),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              "${Statics.getLabel('selectSanghaMandali')}",
                              style: const TextStyle(
                                color: Colors.purpleAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ✅ Results after submit
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('Total')} ${Statics.getLabel('milanMandali')} ",
                    value: "${(data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length}",
                  ),
                  SingleColumnRow(
                    txtString: " ${Statics.getLabel('milanMandali')} ${Statics.getLabel('pratinidhitva')} ",
                    value: "$selectedSanghaMandaliCount",
                  ),
                  SingleColumnRow(
                    rowColor: Colors.grey.shade300,
                    txtString: "${Statics.getLabel('milanMandali')}  ${Statics.getLabel('average')}  ${Statics.getLabel('pratinidhitva')} ",
                    value: ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length > 0
                            ? ((selectedSanghaMandaliCount / ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length)) * 100).round().toString()
                            : "0") +
                        " %",
                  ),
                ],
              ),
            ),
// ================================== 10 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('Total')} ${Statics.getLabel('pratinidhitva')}",
              Column(
                children: [
                  // ✅ Total
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('Total')} ",
                    value:
                        "${((data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length) + ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length) + ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length)}",
                  ),

                  // ✅ Selected
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('Total')}  ${Statics.getLabel('pratinidhitva')}",
                    value: "${selectedShakhaCount + selectedMilanCount + selectedSanghaMandaliCount}",
                  ),

                  // ✅ Average (calculated from above two)
                  SingleColumnRow(
                    rowColor: Colors.grey.shade300,
                    txtString: "${Statics.getLabel('Total')}  ${Statics.getLabel('average')}  ${Statics.getLabel('pratinidhitva')} ",
                    value: (() {
                      final total = ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length) +
                          ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length) +
                          ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length);
                      final selected = selectedShakhaCount + selectedMilanCount + selectedSanghaMandaliCount;

                      if (total == 0) return "0 %";
                      final avg = ((selected / total) * 100).round();
                      return "$avg %";
                    })(),
                  ),
                ],
              ),
            ),
// ================================== 11 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('anyaUpstithMahiti')}",
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: textControllerField2(
                          name: Statics.getLabel("presentMatrushakti"),
                          controller: presentMatrushaktiController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: textControllerField2(
                          name: Statics.getLabel("presentMale"),
                          controller: presentMaleController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  //
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('presentTotalMaleFemale')} ",
                    value: total.toString(),
                  ),
                  //
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('presentGanveshatTotal')} ",
                    value: _getColumnTotal([ganShishuBaalCtrl, ganMahavidyaCtrl, ganTarunVyavCtrl, ganProudhVyavCtrl]).toString(),
                  ),
                  //
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('otherSwayamsewakPresentCount')} ",
                    value: _getColumnTotal([anyaShishuBaalCtrl, anyaMahavidyaCtrl, anyaTarunVyavCtrl, anyaProudhVyavCtrl]).toString(),
                  ),
                  //
                  // SingleColumnRow(
                  //   txtString: "${Statics.getLabel('presentSamajik')} ",
                  //   value: "${totalShakhaCount + totalMilanCount + totalSanghaMandaliCount}",
                  // ),
                  // ✅ Total
                  SingleColumnRow(
                    rowColor: Colors.grey.shade300,
                    txtString: "${Statics.getLabel('presentTotal')} ",
                    value: "${total + _getColumnTotal([ganShishuBaalCtrl, ganMahavidyaCtrl, ganTarunVyavCtrl, ganProudhVyavCtrl]) + _getColumnTotal([
                              anyaShishuBaalCtrl,
                              anyaMahavidyaCtrl,
                              anyaTarunVyavCtrl,
                              anyaProudhVyavCtrl
                            ])}",
                  ),
                  // const SizedBox(height: 10),
                  // Text(
                  //   "${Statics.getLabel('Total')} : $total",
                  //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  // ),
                ],
              ),
            ),
// ================================== 12 QUESTIONS Box =======================================================================
            mainContainer(
              "${Statics.getLabel('sanchalan')}",
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  yesNoRadioButton(
                    question: "${Statics.getLabel('sanchalanZaleKa')}",
                    selectedOption: sanchalanZaleKa ?? 2,
                    imp: " *",
                    onChanged: (value) {
                      setState(() {
                        sanchalanZaleKa = value;
                      });
                    },
                  ),
                  yesNoRadioButton(
                    question: Statics.getLabel('sanchalanSadandaZalKa'),
                    selectedOption: sanchalanSadandaZalKa ?? 2,
                    imp: " *",
                    onChanged: (value) {
                      setState(() {
                        sanchalanSadandaZalKa = value;
                      });
                    },
                  ),
                  yesNoRadioButton(
                    question: Statics.getLabel('sanchalanGhoshVadanZalKa'),
                    selectedOption: sanchalanGhoshVadanZalKa ?? 2,
                    imp: " *",
                    onChanged: (value) {
                      setState(() {
                        sanchalanGhoshVadanZalKa = value;
                      });
                    },
                  ),
                ],
              ),
            ),
// ================================== 13 QUESTIONS Box =======================================================================
            mainContainer(Statics.getLabel('moreInfo'), _moreInfoSection()),
//==============================  SUBMIT BUTTON =======================================================================
            Container(
              child: MaterialButton(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  if (_isSearching == false) {
                    Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");
                    return;
                  }
                  if ([null, 2].contains(programNirdharitVed) ||
                      [null, 2].contains(vaiyaktikGitKantashtha) ||
                      [null, 2].contains(programHishobh24Hour) ||
                      [null, 2].contains(sanchalanZaleKa) ||
                      [null, 2].contains(sanchalanSadandaZalKa) ||
                      [null, 2].contains(sanchalanGhoshVadanZalKa)) {
                    Fluttertoast.showToast(msg: "${Statics.getLabel('impInfoRequired')}");
                    return;
                  }
                  submitForm();
                },
                child: Text(
                  Statics.getLabel('Submit'),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget stharDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purpleAccent),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(
        // vertical: size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.02,
      ),
      child: ExpansionPanelList(
        elevation: 0,
        dividerColor: Colors.transparent,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  Statics.getLabel('selectStar'),
                  style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(onPressed: clearForm, icon: Icon(Icons.refresh), color: Colors.purpleAccent),
                iconColor: Colors.purpleAccent,
              );
            },
            body: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  if (_linkedMahaanagar != null && _linkedMahaanagar!.isNotEmpty && utsavKontyaStaravar != "4")
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 9 || userLevelId == 13),
                      label: Statics.getLabel('Mahaanagar'),
                      value: _linkedMahaanagarValue,
                      items: _linkedMahaanagar!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedMahaanagarValue = value;
                          _linkedVibhaagValue = null;
                          selctedLevel = 'Mahaanagar';
                          selctedLevelId = '9';
                          selctedLevelName = selectedItem.name ?? "";
                          _selectedGeoUnitId = value;
                          // _linkedMahaanagarName = selectedItem.name ?? "";
                          // _resetLinkedValues();
                        });
                        populatelinkedVibhaagDropdown(value!);
                        populatelinkedBhaagDropdown("");
                      },
                    ),
                  if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 8 || userLevelId == 13),
                      label: Statics.getLabel('Vibhaag'),
                      value: _linkedVibhaagValue,
                      items: _linkedVibhaag!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          print("i am in vibhag setstate");
                          _linkedVibhaagValue = value;
                          selctedLevel = 'Vibhaag';
                          selctedLevelId = '8';
                          selctedLevelName = selectedItem.name ?? "";
                          _selectedGeoUnitId = value;
                          // _linkedVibhaagName = selectedItem.name ?? "";
                        });
                        populatelinkedBhaagDropdown(value!);
                      },
                    ),
                  if (_linkedBhaag != null && _linkedBhaag!.isNotEmpty)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 7 || userLevelId == 13),
                      label: Statics.getLabel('Bhaag'),
                      value: _linkedBhaagValue,
                      items: _linkedBhaag!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedBhaagValue = value;
                          selctedLevel = 'Bhaag';
                          selctedLevelId = '7';
                          selctedLevelName = selectedItem.name ?? "";
                          _linkedBhaagName = selectedItem.name ?? "";
                          _selectedGeoUnitId = value;
                          //populatelinkedShaharDropdown(value!);
                          populatelinkedNagarDropdown(value, null);
                        });
                      },
                    ),
                  if (_linkedNagar != null && _linkedNagar!.isNotEmpty)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
                      label: Statics.getLabel('Nagar'),
                      value: _linkedNagarValue,
                      items: _linkedNagar!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: utsavKontyaStaravar == "13"
                          ? (value) async {
                              selectedUpnagarList = [];
                              final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _linkedupnaragValue = null;
                                selctedLevelName = selectedItem.name ?? "";
                                selctedLevel = 'Nagar';
                                selctedLevelId = '6';
                                _selectedGeoUnitId = value;

                                _linkedNagarValue = value;
                              });
                              // await populatelinkedUpnagarDropdown(value);
                              data = await Statics.getVijayadashamiInitData(context, Statics.userDetails["userID"], _selectedGeoUnitId, selctedLevel == 'Nagar' ? "6" : utsavKontyaStaravar);
                              log("searchVijayaDashami data ${jsonDecode(jsonEncode(data))}");
                              selectedPrabhavi = null;
                              selectedPerson = null;
                              setState(() {
                                _linkedUpnagar = data?.upnagarmandallist ?? [];
                              });
                              if (_linkedUpnagar == null || _linkedUpnagar?.length == 0) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(Statics.getLabel('AskConfirmation')),
                                    content: Text(Statics.getLabel('addUpnagarDialogBox')),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(Statics.getLabel('add')),
                                        onPressed: () async {
                                          Navigator.of(context).pushReplacementNamed(TabScreen.routeName).then((value) {
                                            if (mounted) clearForm();
                                          }); //.then((value) => searchVijayaDashami());
                                        },
                                      ),
                                      TextButton(
                                        child: Text(Statics.getLabel('clear')),
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                      )
                                    ],
                                  ),
                                );
                              }

                              return;
                            }
                          : (value) {
                              final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _linkedNagarValue = value;
                                _selectedGeoUnitId = value;
                                selctedLevel = 'Nagar';
                                selctedLevelId = '6';
                                selctedLevelName = selectedItem.name ?? "";
                                _linkedNagarName = selectedItem.name ?? "";
                              });
                              populatelinkedUpnagarDropdown(value);
                              populatelinkedMandalDropdown(false, value);
                              populatelinkedVastiDropdown(false, value);
                            },
                    ),
                  if (utsavKontyaStaravar == "13" && _linkedUpnagar != null && _linkedUpnagar!.length > 0)
                    MultiSelectDialogField(
                      title: Text(Statics.getLabel('upnagarUpkhanda')),
                      buttonText: Text(Statics.getLabel('upnagarUpkhanda')),
                      buttonIcon: Icon(Icons.arrow_drop_down),
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border: Border(bottom: selectedUpnagarList.isEmpty ? BorderSide(color: Colors.grey) : BorderSide.none),
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
                      items: _linkedUpnagar!.map((bg) => MultiSelectItem(bg.geoUnitID, bg.preferedname.toString())).toList(),
                      initialValue: selectedUpnagarList,
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
                        selectedUpnagarList = values.map((e) {
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
                        // if (selectedUpnagarList.contains(values)) {
                        selctedLevel = 'upnagarUpkhanda';
                        if (selectedUpnagarList.isNotEmpty) selctedLevelId = "13";
                        selctedLevelName = _linkedUpnagar!.where((upnagar) => selectedUpnagarList.contains(upnagar.geoUnitID)).map((upnagar) => upnagar.preferedname).toList().join(",");
                        //   selectedUpnagarList.add(bg);
                        // } else {
                        //   selectedUpnagarList.remove(bg);
                        // }
                        setState(() {});

                        // print("selctedLevelId >>>>>>>>>>>>>>>>> $selctedLevelId");
                        print("valueeeeeeeesssss >>>>>>>>>>>>>>> ${selectedUpnagarList.join(",")}");
                      },
                    ),
                  if (["2", "4"].contains(utsavKontyaStaravar) && _linkedupnagar != null && _linkedupnagar!.isNotEmpty)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
                      label: Statics.getLabel('upnagarUpkhanda'),
                      value: _linkedupnagarValue,
                      items: _linkedupnagar!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedupnagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedupnagarValue = value;
                          _selectedGeoUnitId = value;
                          selctedLevel = 'upnagarUpkhanda';
                          selctedLevelId = '13';
                          selctedLevelName = selectedItem.name ?? "";
                          _linkedshaharName = selectedItem.name ?? "";
                          populatelinkedMandalDropdown(true, value);
                          populatelinkedVastiDropdown(true, value);

                          // populatelinkedNagarDropdown(null, value);
                        });
                      },
                    ),
                  if (utsavKontyaStaravar == "4" && _linkedmandal != null && _linkedmandal!.isNotEmpty)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 4),
                      label: Statics.getLabel('Mandal'),
                      value: _linkedmandalValue,
                      items: _linkedmandal!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedmandalValue = value;
                          _selectedGeoUnitId = value.toString();
                          selctedLevel = 'Mandal';
                          selctedLevelId = '4';
                          selctedLevelName = selectedItem.name ?? "";
                          _linkedmandalName = selectedItem.name ?? "";
                          populatelinkedGraamDropdown(value);
                        });
                      },
                    ),
                  /*if (_linkedgraam != null && _linkedgraam!.isNotEmpty)
                    buildDropdownField(
                      label: Statics.getLabel('Graam'),
                      value: _linkedgraamValue,
                      items: _linkedgraam == null
                          ? []
                          : _linkedgraam!
                              .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!),
                                  ))
                              .toList(),
                      onChanged: MyAppGlobals.isDropdownDisabled('Graam')
                          ? (value) {
                              if (value == null) return;
                            }
                          : (value) {
                              final selectedItem = _linkedgraam!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _linkedgraamValue = value;
                                _selectedGeoUnitId = value.toString();
                                selctedLevel = 'Graam';
                                selctedLevelName = selectedItem.name ?? "";
                                _linkedgraamName = selectedItem.name ?? "";
                              });
                            },
                      // isDisabled: MyAppGlobals.isDropdownDisabled('Graam'),
                    ),*/
                  if (utsavKontyaStaravar == "2" && _linkedvasti != null && _linkedvasti!.isNotEmpty)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 2),
                      label: Statics.getLabel('Vasti'),
                      value: _linkedvastiValue,
                      items: _linkedvasti!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedvastiValue = value;
                          _selectedGeoUnitId = value.toString();
                          selctedLevel = 'Vasti';
                          selctedLevelId = '2';
                          selctedLevelName = selectedItem.name ?? "";
                          _linkedvastiName = selectedItem.name ?? "";
                        });
                      },
                    ),
                  SizedBox(height: 15),
                  // if (utsavKontyaStaravarList.any((map) => map.values.contains(Statics.getLabel(selctedLevel ?? ""))))
                  if (selctedLevelId == utsavKontyaStaravar)
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                        onPressed: () {
                          searchVijayaDashami();
                          setState(() {
                            _isExpanded = false;
                            isVastiSearch = true;
                            _isSearching = true;
                          });
                        },
                        child: Text("${Statics.getLabel('Filters')}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                ],
              ),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }

  /*
  Widget vastiDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purpleAccent),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(
        // vertical: size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.02,
      ),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        elevation: 0,
        dividerColor: Colors.transparent,
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  Statics.getLabel('selectStar'),
                  style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                    onPressed: () {
                      clearForm();
                    },
                    icon: Icon(Icons.refresh),
                    color: Colors.purpleAccent),
                iconColor: Colors.purpleAccent,
              );
            },
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  if (_linkedMahaanagar != null)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "${Statics.getLabel('mahaanagar')}"),
                      isExpanded: true,
                      value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                      items: _linkedMahaanagar!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedMahaanagarValue = value;
                          _linkedVibhaagValue = null;
                          _linkedBhaagValue = null;
                          _linkedNagarValue = null;
                          populatelinkedVibhaagDropdown(value!);
                          mahanagarId = value;
                          selctedLevelId = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Mahanagar';
                        });
                        print("Selected Id: $value");
                        print("Selected Level Name: ${selectedItem.name}");
                      },
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_linkedVibhaag != null)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "${Statics.getLabel('vibhaag')}"),
                      isExpanded: true,
                      value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                      items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        print(value);
                        setState(() {
                          _linkedVibhaagValue = value;
                          populatelinkedBhaagDropdown(value!);
                          vibhagId = value;
                          _linkedBhaagValue = _linkedNagarValue = null;
                          _linkedBhaag = _linkedNagar = null;
                          selctedLevelId = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Vibhaag';
                        });
                        print("Selected Id: $value");
                        print("Selected Level Name: ${selectedItem.name}");
                      },
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_linkedBhaag != null)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                      isExpanded: true,
                      value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
                      items: _linkedBhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedBhaagValue = value;
                          populatelinkedNagarDropdown(value, null);
                          selctedLevelId = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Bhaag';
                        });
                        print("Selected Id: $value");
                        print("Selected Level Name: ${selectedItem.name}");
                      },
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_linkedNagar != null && _linkedNagar!.length > 0)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "${Statics.getLabel('NagarShahari')}"),
                      isExpanded: true,
                      value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                      items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedNagarValue = value;
                          populatelinkedVastiDropdown(value!);
                          selctedLevelId = value;
                          selctedLevelIdForVastiDropdown = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Nagar';
                        });
                        print("Selected Id: $value");
                        print("Selected Level Name: ${selectedItem.name}");
                      },
                    ),
                  if (_linkedNagar != null && _linkedNagar!.length > 0)
                    SizedBox(
                      height: 10,
                    ),
                  if (_linkedvasti != null && _linkedvasti!.length > 0)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "${Statics.getLabel('vastiLabel')}"),
                      isExpanded: true,
                      value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                      items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedvastiValue = value;
                          selctedLevelId = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Vasti';
                        });
                        setState(() {});
                        print("Selected Id: $value");
                        print("Selected Level Name: ${selectedItem.name}");
                      },
                    ),
                  if (_linkedvasti != null && _linkedvasti!.length > 0)
                    SizedBox(
                      height: 10,
                    ),
                  if (selctedLevel == "Vasti")
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                        onPressed: () {
                          searchVijayaDashami();
                          setState(() {
                            _isExpanded = false;
                            isVastiSearch = true;
                            _isSearching = true;
                          });
                        },
                        child: Text("${Statics.getLabel('Filters')}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                ],
              ),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }

  Widget mandalDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purpleAccent),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(
        // vertical: size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.02,
      ),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        elevation: 0,
        dividerColor: Colors.transparent,
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  Statics.getLabel('selectStar'),
                  style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                    onPressed: () async {
                      await clearForm();
                      populatelinkedVibhaagDropdownForMandal('');
                    },
                    icon: Icon(Icons.refresh),
                    color: Colors.purpleAccent),
                iconColor: Colors.purpleAccent,
              );
            },
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  if (_linkedVibhaag != null)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('vibhaag')),
                      isExpanded: true,
                      value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                      items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        print(value);
                        setState(() {
                          _linkedVibhaagValue = value;
                          populatelinkedBhaagDropdownForMandal(value!);
                          vibhagId = value;
                          _linkedBhaagValue = _linkedNagarValue = null;
                          _linkedBhaag = _linkedNagar = _linkedmandal = null;
                          selctedLevelId = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'vibhag';
                          _linkedmandalValue = null;
                        });
                        print("Selected Id: $value");
                        print("Selected Level Name: ${selectedItem.name}");
                      },
                    ),
                  SizedBox(height: 10),
                  if (_linkedBhaag != null)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "${Statics.getLabel('Bhaag')}"),
                      isExpanded: true,
                      value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
                      items: _linkedBhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedBhaagValue = value;
                          populatelinkedNagarDropdownForMandal(value, null);
                          selctedLevelId = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'bhag';
                          _linkedmandalValue = null;
                        });
                        print("Selected Id: $value");
                        print("Selected Level Name: ${selectedItem.name}");
                      },
                    ),
                  SizedBox(height: 10),
                  if (_linkedNagar != null && _linkedNagar!.length > 0)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "${Statics.getLabel('taalukaa')}"),
                      isExpanded: true,
                      value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                      items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedNagarValue = value;
                          populatelinkedMandalDropdownForMandal(value!);
                          selctedLevelId = value;
                          selctedLevelIdForMandalDropdown = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'nagar';
                          _linkedmandalValue = null;
                        });
                        print("Selected Id: $value");
                        print("Selected Level Name: ${selectedItem.name}");
                      },
                    ),
                  if (_linkedNagar != null && _linkedNagar!.length > 0) SizedBox(height: 10),
                  if (_linkedmandal != null && _linkedmandal!.length > 0)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "${Statics.getLabel('Mandal')}"),
                      isExpanded: true,
                      value: _linkedmandalValue == "" ? null : _linkedmandalValue,
                      items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedmandalValue = value;
                          selctedLevelId = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Mandal';
                        });
                        setState(() {});
                        print("Selected Id: $value");
                        print("Selected Level Name: ${selectedItem.name}");
                      },
                    ),
                  if (_linkedmandal != null && _linkedmandal!.length > 0) SizedBox(height: 10),
                  if (selctedLevel == 'Mandal')
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                        onPressed: () {
                          searchVijayaDashami();
                          setState(() {
                            _isExpanded = false;
                            isVastiSearch = true;
                            _isSearching = true;
                          });
                        },
                        child: Text("${Statics.getLabel('Filters')}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                ],
              ),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }

  Widget upnagarDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purpleAccent),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(
        // vertical: size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.02,
      ),
      child: ExpansionPanelList(
        elevation: 0,
        dividerColor: Colors.transparent,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  Statics.getLabel('selectStar'),
                  style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                    onPressed: () {
                      clearForm();
                    },
                    icon: Icon(Icons.refresh),
                    color: Colors.purpleAccent),
                iconColor: Colors.purpleAccent,
              );
            },
            body: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  if (_linkedMahaanagar != null)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                      isExpanded: true,
                      value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                      items: _linkedMahaanagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        print(value);
                        setState(() {
                          _linkedMahaanagarValue = value;
                          _linkedVibhaagValue = null;
                          _linkedBhaagValue = null;
                          _linkedShaharValue = null;
                          _linkedNagarValue = null;
                          populatelinkedVibhaagDropdown(value!);
                          mahanagarId = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Mahanagar';
                          selctedLevelId = value;
                        });
                      },
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_linkedVibhaag != null)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                      isExpanded: true,
                      value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                      items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        print(value);
                        setState(() {
                          _linkedVibhaagValue = value;
                          populatelinkedBhaagDropdown(value!);
                          vibhagId = value;
                          _linkedBhaagValue = _linkedNagarValue = null;
                          _linkedBhaag = _linkedNagar = null;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Vibhaag';
                          selctedLevelId = value;
                        });
                      },
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_linkedBhaag != null)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                      isExpanded: true,
                      value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
                      items: _linkedBhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedBhaagValue = value;
                          // populatelinkedShaharDropdown(value!);
                          populatelinkedNagarDropdown(value, null);
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Bhaag';
                          selctedLevelId = value;
                        });
                      },
                    ),
                  if (_linkedNagar != null && _linkedNagar!.length > 0)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                      isExpanded: true,
                      value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                      items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) async {
                        selectedUpnagarList = [];
                        final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedupnaragValue = null;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Nagar';
                          selctedLevelId = value;

                          _linkedNagarValue = value;
                        });
                        data = await Statics.getVijayadashamiInitData(context, Statics.userDetails["userID"], selctedLevelId, selctedLevel == 'Nagar' ? "6" : utsavKontyaStaravar);
                        log("searchVijayaDashami data ${jsonDecode(jsonEncode(data))}");
                        selectedPrabhavi = null;
                        selectedPerson = null;
                        setState(() {
                          _linkedUpnagar = data?.upnagarmandallist ?? [];
                        });
                        if (_linkedUpnagar == null || _linkedUpnagar?.length == 0) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(Statics.getLabel('AskConfirmation')),
                              content: Text(Statics.getLabel('addUpnagarDialogBox')),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(Statics.getLabel('add')),
                                  onPressed: () async {
                                    Navigator.of(context).pushReplacementNamed(TabScreen.routeName).then((value) {
                                      if (mounted) clearForm();
                                    }); //.then((value) => searchVijayaDashami());
                                  },
                                ),
                                TextButton(
                                  child: Text(Statics.getLabel('clear')),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                )
                              ],
                            ),
                          );
                        }

                        return;
                        // populatelinkedMandalDropdown(value!);
                        // populatelinkedVastiDropdown(value);
                      },
                    ),
                  if (_linkedUpnagar != null && _linkedUpnagar!.length > 0)
                    SizedBox(
                      height: 10,
                    ),
                  if ((selctedLevel == 'Nagar' || selctedLevel == 'upnagarUpkhanda') && _linkedUpnagar != null && _linkedUpnagar!.length > 0)
                    MultiSelectDialogField(
                      title: Text(Statics.getLabel('upnagarUpkhanda')),
                      buttonText: Text(Statics.getLabel('upnagarUpkhanda')),
                      buttonIcon: Icon(Icons.arrow_drop_down),
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border: Border(bottom: selectedUpnagarList.isEmpty ? BorderSide(color: Colors.grey) : BorderSide.none),
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
                      items: _linkedUpnagar!.map((bg) => MultiSelectItem(bg.geoUnitID, bg.preferedname.toString())).toList(),
                      initialValue: selectedUpnagarList,
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
                        selectedUpnagarList = values.map((e) {
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
                        // if (selectedUpnagarList.contains(values)) {
                        selctedLevel = 'upnagarUpkhanda';
                        selctedLevelName = _linkedUpnagar!.where((upnagar) => selectedUpnagarList.contains(upnagar.geoUnitID)).map((upnagar) => upnagar.preferedname).toList().join(",");
                        //   selectedUpnagarList.add(bg);
                        // } else {
                        //   selectedUpnagarList.remove(bg);
                        // }
                        setState(() {});

                        // print("selctedLevelId >>>>>>>>>>>>>>>>> $selctedLevelId");
                        print("valueeeeeeeesssss >>>>>>>>>>>>>>> ${selectedUpnagarList.join(",")}");
                      },
                    ),
                  // DropdownButtonFormField(
                  //   decoration: InputDecoration(labelText: Statics.getLabel('upnagarUpkhanda')),
                  //   isExpanded: true,
                  //   value: _linkedupnaragValue == "" ? null : _linkedupnaragValue,
                  //   items: _linkedUpnagar?.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.preferedname.toString()))).toList(),
                  //   onChanged: (value) {
                  //     final selectedItem = _linkedUpnagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                  //     setState(() {
                  //       selctedLevelName = selectedItem?.preferedname ?? "";
                  //       selctedLevel = 'upnagarUpkhanda';
                  //       selctedLevelId = value;
                  //
                  //       _linkedupnaragValue = value;
                  //       // populatelinkedGraamDropdown(value!);
                  //     });
                  //
                  //     print("selctedLevelId >>>>>>>>>>>>>>>>> $selctedLevelId");
                  //   },
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  if (selctedLevel == 'upnagarUpkhanda' && selectedUpnagarList.isNotEmpty)
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                        onPressed: () {
                          searchVijayaDashami();
                          setState(() {
                            _isExpanded = false;
                            isVastiSearch = true;
                            _isSearching = true;
                          });
                        },
                        child: Text("${Statics.getLabel('Filters')}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                ],
              ),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }

  Widget nagarDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purpleAccent),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(
        // vertical: size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.02,
      ),
      child: ExpansionPanelList(
        elevation: 0,
        dividerColor: Colors.transparent,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  Statics.getLabel('selectStar'),
                  style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                    onPressed: () {
                      clearForm();
                    },
                    icon: Icon(Icons.refresh),
                    color: Colors.purpleAccent),
                iconColor: Colors.purpleAccent,
              );
            },
            body: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  if (_linkedMahaanagar != null)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                      isExpanded: true,
                      value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                      items: _linkedMahaanagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        print(value);
                        setState(() {
                          _linkedMahaanagarValue = value;
                          _linkedVibhaagValue = null;
                          _linkedBhaagValue = null;
                          _linkedShaharValue = null;
                          _linkedNagarValue = null;
                          populatelinkedVibhaagDropdown(value!);
                          mahanagarId = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Mahanagar';
                          selctedLevelId = value;
                        });
                      },
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_linkedVibhaag != null)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                      isExpanded: true,
                      value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                      items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        print(value);
                        setState(() {
                          _linkedVibhaagValue = value;
                          populatelinkedBhaagDropdown(value!);
                          vibhagId = value;
                          _linkedBhaagValue = _linkedNagarValue = null;
                          _linkedBhaag = _linkedNagar = null;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Vibhaag';
                          selctedLevelId = value;
                        });
                      },
                    ),
                  SizedBox(height: 10),
                  if (_linkedBhaag != null)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                      isExpanded: true,
                      value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
                      items: _linkedBhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedBhaagValue = value;
                          // populatelinkedShaharDropdown(value!);
                          populatelinkedNagarDropdown(value, null);
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Bhaag';
                          selctedLevelId = value;
                        });
                      },
                    ),
                  if (_linkedNagar != null && _linkedNagar!.length > 0)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                      isExpanded: true,
                      value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                      items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) async {
                        final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Nagar';
                          selctedLevelId = value;

                          _linkedNagarValue = value;
                        });
                        populatelinkedMandalDropdown(value!);
                        populatelinkedVastiDropdown(value);
                      },
                    ),
                  if (_linkedNagar != null && _linkedNagar!.length > 0) SizedBox(height: 10),
                  if (selctedLevel == 'Nagar')
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                        onPressed: () {
                          searchVijayaDashami();
                          setState(() {
                            _isExpanded = false;
                            isVastiSearch = true;
                            _isSearching = true;
                          });
                        },
                        child: Text("${Statics.getLabel('Filters')}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                ],
              ),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }
*/

  String? selectedFilePath;
  List<TypeValueData?> _selectedFileNames1 = [];
  List<TypeValueData?> _selectedFileNames2 = [];
  List<TypeValueData?> _urlsList = [];

  // int? imageAdd = 0;
  final int _maxImages = 3;
  final int _maxAddImages = 10;
  ValueNotifier<bool> loadingNotifier1 = ValueNotifier(false);
  ValueNotifier<bool> loadingNotifier2 = ValueNotifier(false);
  ValueNotifier<bool> loadingNotifier3 = ValueNotifier(false);

  // ── More Info (Section 12) ─────────────────────────────────────────────────
  /// This is the main improved section. Contains:
  ///   1. Sanmelan format text field
  ///   2. Utsav photos (filePickerField1 → _filePickerSection)
  ///   3. Advertisement photos (filePickerField2 → _filePickerSection)
  ///   4. URLs list
  Widget _moreInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Utsav photos ─────────────────────────────────────────────────────
        _filePickerSection(
          question: Statics.getLabel('AddUtsavFiles'),
          subtitle: Statics.getLabel('AddUtsavFilesSubtitle'),
          descHint: Statics.getLabel('AddUtsavFilesDesc'),
          fileList: _selectedFileNames1,
          maxFiles: _maxImages,
          fileType: "utsavimgdata",
          baseUrl: '${Statics.baseUrl}/Files/vijayadhasmifiles/',
          loadingNotifier: loadingNotifier1,
          descController: txtUtsavPhotoDescController,
        ),

        const Divider(height: 32),

        // ── Advertisement photos ──────────────────────────────────────────────
        _filePickerSection(
          question: Statics.getLabel('AddAdvUtsavFiles'),
          subtitle: Statics.getLabel('AddAdvUtsavFilesSubtitle'),
          descHint: Statics.getLabel('AddAdvUtsavFilesDesc'),
          fileList: _selectedFileNames2,
          maxFiles: _maxAddImages,
          fileType: "Add",
          baseUrl: '${Statics.baseUrl}/Files/vijayadhasmifiles/',
          loadingNotifier: loadingNotifier2,
          descController: txtUtsavAddPhotoDescController,
        ),

        const Divider(height: 32),

        // ── URLs ──────────────────────────────────────────────────────────────
        _urlsSection(),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ─────────────────────  FILE PICKER SECTION (MERGED)  ─────────────────────
  // ═══════════════════════════════════════════════════════════════════════════

  /// Single reusable widget replacing the old `filePickerField1` / `filePickerField2`.
  /// Handles upload, view gallery, edit description/image, and delete.
  Widget _filePickerSection({
    required String question,
    required String subtitle,
    required String descHint,
    required List<TypeValueData?> fileList,
    required int maxFiles,
    required String fileType, // "img" or "advimg"
    required String baseUrl,
    required ValueNotifier<bool> loadingNotifier,
    required TextEditingController descController,
  }) {
    final canAdd = fileList.length < maxFiles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header row: title + gallery-view icon ─────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(question, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_red_eye, color: Colors.purpleAccent),
              onPressed: fileList.isEmpty ? null : () => _showGalleryDialog(fileList, baseUrl),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // ── File rows ─────────────────────────────────────────────────────
        ...fileList.map((item) => _fileItemRow(
              item: item,
              baseUrl: baseUrl,
              fileType: fileType,
              fileList: fileList,
            )),

        // ── Add button ────────────────────────────────────────────────────
        if (canAdd)
          Align(
            alignment: Alignment.centerRight,
            child: ValueListenableBuilder<bool>(
              valueListenable: loadingNotifier,
              builder: (_, isLoading, __) => OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onPressed: isLoading
                    ? null
                    : () => _pickAndUploadImage(
                          fileList: fileList,
                          fileType: fileType,
                          descController: descController,
                          descHint: descHint,
                          loadingNotifier: loadingNotifier,
                        ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        "+ ${Statics.getLabel("AddMore")}",
                        style: const TextStyle(fontSize: 14, color: Colors.purple),
                      ),
              ),
            ),
          ),

        // ── Description field ──────────────────────────────────
        const SizedBox(height: 8),
        TextFormField(
          controller: descController,
          textAlignVertical: TextAlignVertical.center,
          autofocus: false,
          readOnly: _isSearching == false,
          onTap: _guardSearch,
          maxLines: 5,
          onChanged: (value) => setState(() {}),
          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            hintText: descHint,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),

        const SizedBox(height: 14),
      ],
    );
  }

  // ─── Single file item row (filename | edit | delete) ──────────────────────
  Widget _fileItemRow({
    required TypeValueData? item,
    required String baseUrl,
    required String fileType,
    required List<TypeValueData?> fileList,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54, width: 1),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          // filename
          Expanded(
            child: Text(
              item?.value ?? Statics.getLabel('selectFile'),
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // edit
          IconButton(
            style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
            tooltip: Statics.getLabel('edit'),
            onPressed: () => _showEditFileDialog(item: item, baseUrl: baseUrl, fileType: fileType),
          ),
          // delete
          IconButton(
            style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () async {
              final shouldDelete = await _showDeleteConfirmDialog(message: Statics.getLabel('AreyouSureYouWantToDeleteImage'));
              if (shouldDelete == true) {
                final ok = await deleteImageDataFun(imageName: (item?.value).toString());
                if (ok) setState(() => fileList.remove(item));
              }
            },
          ),
        ],
      ),
    );
  }

  // ─── Edit file popup ───────────────────────────────────────────────────────
  /// Allows editing the description and optionally replacing the image.
  /// On save: calls `submitImageDataFun` with:
  ///   - `pkid`  = item.pkid
  ///   - `isimg` = true if image was replaced
  ///   - `newfilebase` (via selectedFilePath)
  ///   - `description` = new description text
  Future<void> _showEditFileDialog({
    required TypeValueData? item,
    required String baseUrl,
    required String fileType,
  }) async {
    if (!_guardSearch()) return;
    if (item == null) return;

    final descCtrl = TextEditingController(text: item.description ?? "");
    bool imageReplaced = false;
    String? previewBase64; // local base64 preview after pick
    final savingNotifier = ValueNotifier<bool>(false);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Title ──────────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Statics.getLabel('Edit'),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.redAccent),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    Divider(color: Colors.deepPurple.shade100),
                    const SizedBox(height: 8),

                    // ── Current filename ───────────────────────────────────
                    Text(
                      "${Statics.getLabel('submittedFile')}:   ${item.value ?? ''}",
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                    ),

                    // Preview of new image (if picked)
                    if (item.value != null && item.value!.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: '$baseUrl${item.value}',
                            errorWidget: (_, __, ___) => SizedBox(width: double.infinity, height: 120, child: Center(child: Text(Statics.getLabel("errorOccurred")))),
                            progressIndicatorBuilder: (_, __, ___) => const SizedBox(width: double.infinity, height: 120, child: Center(child: CircularProgressIndicator())),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),

                    // // ── Description field ──────────────────────────────────
                    // TextFormField(
                    //   controller: descCtrl,
                    //   maxLines: 3,
                    //   decoration: InputDecoration(
                    //     labelText: Statics.getLabel('AddSanmelanFilesDesc'),
                    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    //     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    //   ),
                    // ),
                    const SizedBox(height: 16),

                    // ── Replace image section ──────────────────────────────
                    Text(
                      Statics.getLabel('replacedFile'),
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 8),

                    // Preview of new image (if picked)
                    if (previewBase64 != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            base64Decode(previewBase64!.split(',').last),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _iconPickerBtn(
                          icon: Icons.camera_alt,
                          label: Statics.getLabel('camera'),
                          onTap: () async {
                            final base64 = await _pickAndCompressImage(ImageSource.camera);
                            if (base64 != null) {
                              set(() {
                                previewBase64 = base64;
                                selectedFilePath = base64;
                                imageReplaced = true;
                              });
                            }
                          },
                        ),
                        _iconPickerBtn(
                          icon: Icons.photo_library,
                          label: Statics.getLabel('gallery'),
                          onTap: () async {
                            final base64 = await _pickAndCompressImage(ImageSource.gallery);
                            if (base64 != null) {
                              set(() {
                                previewBase64 = base64;
                                selectedFilePath = base64;
                                imageReplaced = true;
                              });
                            }
                          },
                        ),
                        if (imageReplaced)
                          TextButton(
                            onPressed: () {
                              set(() {
                                previewBase64 = null;
                                selectedFilePath = null;
                                imageReplaced = false;
                              });
                            },
                            child: Row(
                              spacing: 4,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.cancel, color: Colors.orange.shade700),
                                Text(
                                  Statics.getLabel('clear'),
                                  style: TextStyle(color: Colors.orange.shade700),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Save button ────────────────────────────────────────
                    ValueListenableBuilder<bool>(
                      valueListenable: savingNotifier,
                      builder: (_, saving, __) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          minimumSize: const Size.fromHeight(44),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: saving
                            ? null
                            : () async {
                                final regExp = RegExp(r'\$(\d+)\$');
                                savingNotifier.value = true;
                                final _res = await submitImageDataFun(
                                  pkid: item.pkid ?? 0,
                                  type: fileType,
                                  isimg: imageReplaced,
                                  filebase: item.value,
                                  newfilebase: imageReplaced ? selectedFilePath : "",
                                  description: descCtrl.text.trim(),
                                );
                                if (_res != null && _res.isNotEmpty) {
                                  String? id;
                                  final match = regExp.firstMatch(_res);
                                  if (match != null) {
                                    id = match.group(1); // "15602"
                                  }
                                  String cleanedText = _res.replaceAll(regExp, '').trim();
                                  final _containAnyDollar = MyAppGlobals.hasValueBetweenDollar(_res);
                                  // Update local item
                                  setState(() {
                                    item.description = descCtrl.text.trim();
                                    if (imageReplaced) {
                                      item.isimg = 1;
                                      item.pkid = _containAnyDollar ? int.tryParse(id.toString()) : 0;
                                      item.newfilebase = selectedFilePath;
                                      item.value = cleanedText;
                                      selectedFilePath = null;
                                    }
                                  });
                                }
                                savingNotifier.value = false;
                                if (mounted) Navigator.pop(ctx);
                              },
                        child: saving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(
                                Statics.getLabel('Submit'),
                                style: const TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Gallery / view-all dialog ─────────────────────────────────────────────
  void _showGalleryDialog(List<TypeValueData?> fileList, String baseUrl) {
    showDialog(
      context: context,
      builder: (ctx) => Material(
        child: StatefulBuilder(builder: (context, set) {
          String _currentImg = "";
          return Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ),
                const SizedBox(height: 10),
                ...fileList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final fi = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${index + 1}. ${fi?.value}",
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                set(() => _currentImg = fi.toString());
                                loadingNotifier3.value = true;
                                await MyAppGlobals.downloadFile('$baseUrl${fi?.value}', (fi?.value).toString());
                                loadingNotifier3.value = false;
                                set(() => _currentImg = "");
                              },
                              icon: ValueListenableBuilder<bool>(
                                valueListenable: loadingNotifier3,
                                builder: (_, loading, __) => loading && fi.toString() == _currentImg
                                    ? const SizedBox(
                                        width: 17,
                                        height: 17,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.download, color: Colors.purple),
                              ),
                            ),
                          ],
                        ),
                        if ((fi?.description ?? "").isNotEmpty) Text(fi!.description!, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.5)),
                        const SizedBox(height: 6),
                        CachedNetworkImage(
                          imageUrl: '$baseUrl${fi?.value}',
                          errorWidget: (_, __, ___) => SizedBox(width: double.infinity, height: 120, child: Center(child: Text(Statics.getLabel("errorOccurred")))),
                          progressIndicatorBuilder: (_, __, ___) => const SizedBox(width: double.infinity, height: 120, child: Center(child: CircularProgressIndicator())),
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ─── Pick + upload flow (add new) ──────────────────────────────────────────
  Future<void> _pickAndUploadImage({
    required List<TypeValueData?> fileList,
    required String fileType,
    required TextEditingController descController,
    required String descHint,
    required ValueNotifier<bool> loadingNotifier,
  }) async {
    if (!_guardSearch()) return;
    loadingNotifier.value = true;

    // Ask for description + source
    final isCamera = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text(Statics.getLabel('AddSanmelanFiles')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TextFormField(
              //   controller: descController,
              //   maxLines: 3,
              //   decoration: InputDecoration(
              //     hintText: descHint,
              //     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              //   ),
              // ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _iconPickerBtn(
                      icon: Icons.camera_alt,
                      label: Statics.getLabel('camera'),
                      onTap: () {
                        // if (descController.text.trim().isEmpty) {
                        //   Statics.showToast(descHint);
                        //   return;
                        // }
                        Navigator.pop(ctx, true);
                      }),
                  _iconPickerBtn(
                      icon: Icons.photo_library,
                      label: Statics.getLabel('gallery'),
                      onTap: () {
                        // if (descController.text.trim().isEmpty) {
                        //   Statics.showToast(descHint);
                        //   return;
                        // }
                        Navigator.pop(ctx, false);
                      }),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(Statics.getLabel('clear')),
              onPressed: () {
                loadingNotifier.value = false;
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );

    if (isCamera == null) {
      loadingNotifier.value = false;
      return;
    }

    try {
      final regExp = RegExp(r'\$(\d+)\$');
      final base64File = await _pickAndCompressImage(isCamera ? ImageSource.camera : ImageSource.gallery);
      if (base64File != null) {
        selectedFilePath = base64File;
        final resultName = await submitImageDataFun(
          pkid: 0,
          type: fileType,
          showLoader: true,
          isimg: true,
          description: descController.text.trim(),
        );
        String? id;
        if (resultName != null && resultName.isNotEmpty) {
          final match = regExp.firstMatch(resultName);
          if (match != null) {
            id = match.group(1); // "15602"
          }
          String cleanedText = resultName.replaceAll(regExp, '').trim();
          final _containAnyDollar = MyAppGlobals.hasValueBetweenDollar(resultName);
          setState(() {
            fileList.add(TypeValueData(
              pkid: int.tryParse(id.toString()) ?? 0,
              type: fileType,
              value: cleanedText,
              // description: descController.text.trim(),
            ));
            // descController.clear();
            selectedFilePath = null;
          });
        }
      }
    } catch (e) {
      log("Error during file processing: $e");
    } finally {
      loadingNotifier.value = false;
    }
    setState(() {});
  }

  // ─── Image pick + compress helper ─────────────────────────────────────────
  Future<String?> _pickAndCompressImage(ImageSource source) async {
    final result = await ImagePicker().pickImage(source: source);
    if (result == null) return null;
    try {
      final file = File(result.path);
      img.Image? original = img.decodeImage(file.readAsBytesSync());
      if (original == null) return null;
      img.Image compressed = img.copyResize(original, width: original.width);
      while (compressed.length > 2 * 1024 * 1024) {
        compressed = img.copyResize(compressed, width: (compressed.width * 0.9).toInt());
      }
      final bytes = img.encodeJpg(compressed, quality: 85);
      return "data:image/jpg;base64,${base64Encode(bytes)}";
    } catch (e) {
      log("Image compress error: $e");
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // URL SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _urlsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Statics.getLabel('AddLinks'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: txtUrlsController,
          readOnly: !_isSearching,
          onTap: () => _guardSearch(),
          onChanged: (_) => setState(() {}),
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            hintText: Statics.getLabel("url"),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: txtUrlDescController,
          maxLines: 3,
          maxLength: 160,
          readOnly: !_isSearching,
          onTap: () => _guardSearch(),
          onChanged: (_) => setState(() {}),
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            hintText: Statics.getLabel("urlDesc"),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () async {
              if (txtUrlsController.text.trim().isNotEmpty && txtUrlDescController.text.trim().isNotEmpty) {
                final valid = await isValidUrl(txtUrlsController.text.trim());
                if (!valid) {
                  Fluttertoast.showToast(msg: Statics.getLabel('urlValidation'));
                  return;
                }
                setState(() {
                  _urlsList.add(TypeValueData(
                    type: "url",
                    value: txtUrlsController.text.trim(),
                    description: txtUrlDescController.text.trim(),
                    pkid: 0,
                  ));
                  txtUrlsController.clear();
                  txtUrlDescController.clear();
                });
              } else {
                if (!_guardSearch()) return;
                if (txtUrlDescController.text.trim().isEmpty) {
                  Fluttertoast.showToast(msg: Statics.getLabel('urlDescIsImp'));
                } else {
                  Fluttertoast.showToast(msg: Statics.getLabel('urlValidation'));
                }
              }
            },
            child: Text("+ ${Statics.getLabel("Add")}"),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          runSpacing: 8,
          spacing: 8,
          children: _urlsList.asMap().entries.map((entry) {
            final srNo = entry.key + 1;
            final url = entry.value;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$srNo. ", style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            final uri = Uri.parse((url?.value).toString());
                            if (await isValidUrl((url?.value).toString())) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Text(
                            (url?.value).toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline, decorationColor: Colors.blue),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text((url?.description).toString(), style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () async {
                      final del = await _showDeleteConfirmDialog(message: Statics.getLabel('AreyouSureYouWantToDeleteUrl'));
                      if (del == true) {
                        setState(() => _urlsList.removeWhere((e) => e == url));
                      }
                    },
                    child: const Icon(Icons.delete_forever, color: Colors.red, size: 18),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SMALL HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Generic confirm-delete dialog — returns `true` if user confirms.
  Future<bool?> _showDeleteConfirmDialog({required String message}) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          Statics.getLabel('AskConfirmation'),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade700, fontSize: 18),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(message, style: TextStyle(fontSize: 16, color: Colors.red.shade800)),
        ),
        actions: [
          TextButton(
            child: Text(Statics.getLabel('ConfirmationNo')),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(Statics.getLabel('ConfirmationYes'), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  /// Small icon + label button used in image-source pickers.
  Widget _iconPickerBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filled(
          onPressed: onTap,
          icon: Icon(icon),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  /// Purple outline button used throughout (add mukhya atithi, add graam …).
  Widget _outlineButton({required String label, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purpleAccent.shade100),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(label, style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold)),
      ),
    );
  }

// ================================ END  Swayamsewak POPUP ==================================================================

// ================================ Select Vasti POPUP ==================================================================

  Widget textControllerField2({
    required String name,
    required TextEditingController controller,
    double height = 50.0,
    TextInputType keyboardType = TextInputType.text,
    bool isEdit = false,
    String? hintTextString,
    String? imp,
    int? maxInput,
    bool isTextBold = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isTextBold ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: imp,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: height,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: keyboardType == TextInputType.number ? [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))] : [],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              filled: true,
              fillColor: Colors.white,
              hintText: hintTextString,
            ),
            readOnly: isEdit || _isSearching == false,
            maxLength: maxInput,
            onTap: () {
              if (_isSearching == false) {
                Fluttertoast.showToast(
                  msg: "${Statics.getLabel('NagarSelectionImportant')}",
                );
              }
            },
            buildCounter: (context, {int? currentLength, int? maxLength, bool? isFocused}) => null,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget mainContainer(String header, Widget child) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        // padding: EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent), borderRadius: BorderRadius.all(Radius.circular(10))),

        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.01,
          horizontal: size.width * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              header,
              style: TextStyle(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Divider(color: Colors.black87, thickness: 1),
            SizedBox(
              height: 10,
            ),
            // Container(margin: giveChildPadding ? EdgeInsets.symmetric(horizontal: size.width * 0.03) : null, child: child),
            child,
          ],
        ),
      ),
    );
  }

  Widget yesNoRadioButton({
    required String question,
    required Function(int) onChanged,
    required int selectedOption,
    int? questionNumber,
    String? imp,
    bool isDisable = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "${questionNumber != null ? "$questionNumber. " : ""}$question",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: imp,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Radio<int>(
              value: 1,
              groupValue: selectedOption,
              onChanged: isDisable
                  ? null
                  : (value) {
                      if (!_isSearching) {
                        // ✅ Search disabled => show toast
                        Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");
                        return;
                      }
                      if (value != null) onChanged(value);
                    },
              activeColor: Colors.purpleAccent,
            ),
            Text(
              "${Statics.getLabel('ConfirmationYes')}",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(width: 20),
            Radio<int>(
              value: 0,
              groupValue: selectedOption,
              onChanged: isDisable
                  ? null
                  : (value) {
                      if (!_isSearching) {
                        Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");
                        return;
                      }
                      if (value != null) onChanged(value);
                    },
              activeColor: Colors.purpleAccent,
            ),
            Text(
              "${Statics.getLabel('ConfirmationNo')}",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> submitForm({bool showLoader = true}) async {
    Map<String, dynamic> formData = {
      "GeoUnitID": selectedUpnagarList.isEmpty ? _selectedGeoUnitId.toString() : selectedUpnagarList.join(","),
      "AppUserID": int.parse(Statics.userDetails['userID']),
      "is_nagar": int.parse(utsavKontyaStaravar!),
      "shanchalan_zaleka": sanchalanZaleKa,
      "shanchalan_sadan_zaleka": sanchalanSadandaZalKa,
      "shanchalan_ghosvandan_zaleka": sanchalanGhoshVadanZalKa,
      "karyakram_nirdharit_vedhvar_zaleka": programNirdharitVed,
      "vyakti_geet_khantasta_khoteka": vaiyaktikGitKantashtha,
      "karaykram_hisob_24_tasa_purna_zaleka": programHishobh24Hour,
      "mukhya_atithi_id": selectedMukhyaAtithi,
      "mukhya_atithi_is_sajjan_shakti": selectedType == "sarsajjanshakti" ? 1 : 0,
      "visitit_atithi_sajjan_shaktiids": selectedSajjanshaktiItems.map((e) => e.pkid.toString()).join(","),
      "visitit_atithi_anyaprabha_vi_lokamids": selectedAnyaprabhaviItems.map((e) => e.pkId.toString()).join(","),
      "bhougolik_pratinidhatva_ids": selectedBhougolikPratinidhitwaVastiIds,
      "bhougolik_pratinidhatva_count": selectedVastiCount,
      "shakha_pratinidhatva_ids": selectedShakhaaPratinidhitwaVastiIds,
      "shakha_pratinidhatva_count": selectedShakhaCount,
      "milan_pratinidhatva_ids": selectedMilanPratinidhitwaVastiIds,
      "milan_pratinidhatva_count": selectedMilanCount,
      "manasik_sangh_mandali_pratinidhatva_ids": selectedSanghaMandaliPratinidhitwaVastiIds,
      "manasik_sangh_mandali_pratinidhatva_count": selectedSanghaMandaliCount,
      "anya_upastiti_matrushakti": presentMatrushaktiController.text,
      "anya_upastiti_male": presentMaleController.text,
      "baal_pat": patShishuBaalCtrl.text,
      "baal_gan": ganShishuBaalCtrl.text,
      "baal_anya": anyaShishuBaalCtrl.text,
      "Mahavidya_pat": patMahavidyaCtrl.text,
      "Mahavidya_gan": ganMahavidyaCtrl.text,
      "Mahavidya_anya": anyaMahavidyaCtrl.text,
      "TarunVyav_pat": patTarunVyavCtrl.text,
      "TarunVyav_gan": ganTarunVyavCtrl.text,
      "TarunVyav_anya": anyaTarunVyavCtrl.text,
      "ProudhVyav_pat": patProudhVyavCtrl.text,
      "ProudhVyav_gan": ganProudhVyavCtrl.text,
      "ProudhVyav_anya": anyaProudhVyavCtrl.text,
      "urls": _urlsList,
      "karyakramVaktaName": txtVaktaNameController.text.trim(),
      "karyakramVaktaTask": txtVaktaTaskController.text.trim(),
      "utsavPhotoDesc": txtUtsavPhotoDescController.text.trim(),
      "utsavAddPhotoDesc": txtUtsavAddPhotoDescController.text.trim(),
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    await Statics.saveVijayaDashamiUtsavData(context, formData, showLoader);
    getFormData();
  }

  Future<String?> submitImageDataFun({
    bool showLoader = false,
    bool isimg = false,
    required int pkid,
    required String type,
    String? filebase,
    String? newfilebase,
    required String description,
  }) async {
    final formData = {
      "pkid": pkid,
      "GeoUnitID": selectedUpnagarList.isEmpty ? _selectedGeoUnitId.toString() : selectedUpnagarList.join(","),
      "filebase": filebase ?? selectedFilePath,
      "type": type,
      "Desc": description,
      "newfilebase": newfilebase ?? "",
      "isimg": isimg ? 1 : 0,
    };
    log("Image Data:\n${const JsonEncoder.withIndent('  ').convert(formData)}");
    return await Statics.saveVijayaDashamiImageData(context: context, inputJson: formData, showLoader: showLoader);
  }

  Future<bool> deleteImageDataFun({
    bool showLoader = true,
    required String imageName,
  }) async {
    final formData = {"GeoUnitID": selectedUpnagarList.isEmpty ? _selectedGeoUnitId.toString() : selectedUpnagarList.join(","), "filepath": imageName};
    return await Statics.deleteVijayaDashamiImageData(context: context, inputJson: formData, showLoader: showLoader);
  }

  GetVijayadashamiDataByGeoUnitModel? getVijayaDashamiUtsavDataByGeounitData;

  Future<void> getFormData({int? formId}) async {
    Map<String, dynamic> formData = {
      "GeoUnitID": selectedUpnagarList.isEmpty ? _selectedGeoUnitId.toString() : selectedUpnagarList.join(","),
      "AppUserID": int.parse(Statics.userDetails['userID']),
      "isnagar": int.parse(utsavKontyaStaravar!),
      "pkid": formId ?? 0,
    };

    String formattedJson = jsonEncode(formData);
    log("Form Data (JSON):\n$formattedJson");
    getVijayaDashamiUtsavDataByGeounitData = await Statics.getVijayaDashamiUtsavDataByGeounit(context, formData);
    log("getVijayaDashamiUtsavDataByGeounitData ${jsonDecode(jsonEncode(getVijayaDashamiUtsavDataByGeounitData))}");

    final _geodata = getVijayaDashamiUtsavDataByGeounitData?.geodata;

    if (_geodata != null && formId != null) {
      utsavKontyaStaravar = _geodata.levelID.toString();
      setState(() {});
      if (_geodata.parentMahaanagarID != null && _geodata.parentMahaanagarID != 0) {
        _linkedMahaanagarValue = _geodata.parentMahaanagarID.toString();
        await populatelinkedVibhaagDropdown(_geodata.parentMahaanagarID.toString());
      }
      if (_geodata.parentVibhaagID != null && _geodata.parentVibhaagID != 0) {
        await populatelinkedBhaagDropdown(_geodata.parentVibhaagID.toString());
        _linkedVibhaagValue = _geodata.parentVibhaagID.toString();
      }
      if (_geodata.parentBhaagID != null && _geodata.parentBhaagID != 0) {
        await populatelinkedNagarDropdown(_geodata.parentBhaagID.toString(), null);
        _linkedBhaagValue = _geodata.parentBhaagID.toString();
      }
      if (_geodata.parentNagarID != null && _geodata.parentNagarID != 0) {
        await populatelinkedMandalDropdown(false, _geodata.parentNagarID.toString());
        await populatelinkedVastiDropdown(
          (_geodata.parentUpnagarID != null && _geodata.parentUpnagarID != 0),
          (_geodata.parentUpnagarID != null && _geodata.parentUpnagarID != 0) ? _geodata.parentUpnagarID.toString() : _geodata.parentNagarID.toString(),
        );
        _linkedNagarValue = _geodata.parentNagarID.toString();
      }
      if (_geodata.levelID == 6) {
        _linkedNagarValue = _geodata.geounitid.toString();
      } else if (_geodata.levelID == 4) {
        _linkedmandalValue = _geodata.geounitid.toString();
      } else if (_geodata.levelID == 2) {
        _linkedvastiValue = _geodata.geounitid.toString();
      }
      if (_geodata.geounitid != null && _geodata.geounitid != 0 && _geodata.levelID != 13) {
        _selectedGeoUnitId = _geodata.geounitid.toString();
      }
      if (_geodata.levelID == 13) {
        selctedLevel = 'upnagarUpkhanda';
        data = await Statics.getVijayadashamiInitData(context, Statics.userDetails["userID"], _geodata.parentNagarID.toString(), "6");
        setState(() {
          _linkedUpnagar = data?.upnagarmandallist ?? [];
        });
        selectedUpnagarList = _geodata.geounitid.toString().split(",").map((e) => int.tryParse(e)).toList();
      }

      setState(() {
        _isExpanded = false;
        isVastiSearch = true;
        _isSearching = true;
      });

      await scrollToBottom();
    }

    setState(() {
      VijayadashamiUtsav utsav = getVijayaDashamiUtsavDataByGeounitData!.vijayadashamiUtsav!;

      _urlsList = getVijayaDashamiUtsavDataByGeounitData?.urldata ?? [];
      txtVaktaNameController.text = getVijayaDashamiUtsavDataByGeounitData?.vijayadashamiUtsav?.karyakramVaktaName ?? "";
      txtVaktaTaskController.text = getVijayaDashamiUtsavDataByGeounitData?.vijayadashamiUtsav?.karyakramVaktaTask ?? "";
      txtUtsavPhotoDescController.text = getVijayaDashamiUtsavDataByGeounitData?.vijayadashamiUtsav?.utsavPhotoDesc ?? "";
      txtUtsavAddPhotoDescController.text = getVijayaDashamiUtsavDataByGeounitData?.vijayadashamiUtsav?.utsavAddPhotoDesc ?? "";
      _selectedFileNames1 = getVijayaDashamiUtsavDataByGeounitData?.eventdata ?? [];
      _selectedFileNames2 = getVijayaDashamiUtsavDataByGeounitData?.adddata ?? [];

      // Example text controllers
      presentMatrushaktiController.text = utsav.anyaUpastitiMatrushakti?.toString() ?? '';
      presentMaleController.text = utsav.anyaUpastitiMale?.toString() ?? '';

      patShishuBaalCtrl.text = utsav.baalPat?.toString() ?? '';
      ganShishuBaalCtrl.text = utsav.baalGan?.toString() ?? '';
      anyaShishuBaalCtrl.text = utsav.baalAnya?.toString() ?? '';

      patMahavidyaCtrl.text = utsav.mahavidyaPat?.toString() ?? '';
      ganMahavidyaCtrl.text = utsav.mahavidyaGan?.toString() ?? '';
      anyaMahavidyaCtrl.text = utsav.mahavidyaAnya?.toString() ?? '';

      patTarunVyavCtrl.text = utsav.tarunVyavPat?.toString() ?? '';
      ganTarunVyavCtrl.text = utsav.tarunVyavGan?.toString() ?? '';
      anyaTarunVyavCtrl.text = utsav.tarunVyavAnya?.toString() ?? '';

      patProudhVyavCtrl.text = utsav.proudhVyavPat?.toString() ?? '';
      ganProudhVyavCtrl.text = utsav.proudhVyavGan?.toString() ?? '';
      anyaProudhVyavCtrl.text = utsav.proudhVyavAnya?.toString() ?? '';

      // Example int variables
      sanchalanZaleKa = utsav.shanchalanZaleka ?? 2;
      sanchalanSadandaZalKa = utsav.shanchalanSadanZaleka ?? 2;
      sanchalanGhoshVadanZalKa = utsav.shanchalanGhosvandanZaleka ?? 2;
      programNirdharitVed = utsav.karyakramNirdharitVedhvarZaleka ?? 2;
      vaiyaktikGitKantashtha = utsav.vyaktiGeetKhantastaKhoteka ?? 2;
      programHishobh24Hour = utsav.karaykramHisob24TasaPurnaZaleka ?? 2;

      // selectedMukhyaAtithi = utsav.mukhyaAtithiId;
      // selectedType = utsav.mukhyaAtithiIsSajjanShakti == 1
      //     ? "sarsajjanshakti"
      //     : "anyaprabhavi";

      selectedSajjanshaktiItemsIds = utsav.visititAtithiSajjanShaktiids;
      // Sajjan Shakti
      if (selectedSajjanshaktiItemsIds != null && selectedSajjanshaktiItemsIds!.isNotEmpty && data?.vastisarsajjanshakti != null) {
        // final idSet = selectedSajjanshaktiItemsIds!.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty).toSet(); // remove duplicates

        selectedSajjanshaktiItems = getVijayaDashamiUtsavDataByGeounitData?.visititAtithiVastisarsajjanshakti ?? [];
      } else {
        selectedSajjanshaktiItems = [];
      }
      selectedAnyaprabhaviItemsIds = utsav.visititAtithiAnyaprabhaViLokamids;
      // Anya Prabhavi
      if (selectedAnyaprabhaviItemsIds != null && selectedAnyaprabhaviItemsIds!.isNotEmpty && data?.vastisanyaprabhavi != null) {
        // final idSet = selectedAnyaprabhaviItemsIds!.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();

        selectedAnyaprabhaviItems = getVijayaDashamiUtsavDataByGeounitData?.visititAtithiVastisarAnyaprabhavilokam ?? [];
      } else {
        selectedAnyaprabhaviItems = [];
      }

      selectedMukhyaAtithi = utsav.mukhyaAtithiId;
      selectedType = utsav.mukhyaAtithiIsSajjanShakti == 1 ? "sarsajjanshakti" : "anyaprabhavi";

      if (selectedType == "sarsajjanshakti") {
        // if (getVijayaDashamiUtsavDataByGeounitData?.mukhyaAtithiVastisarsajjanshakti != []) {
        //   selectedPerson = getVijayaDashamiUtsavDataByGeounitData?.mukhyaAtithiVastisarsajjanshakti?.first;
        // }
        final listP = getVijayaDashamiUtsavDataByGeounitData?.mukhyaAtithiVastisarsajjanshakti;
        if (listP != null && listP.isNotEmpty) {
          selectedPerson = listP.first;
        }
        // selectedPerson = (data?.vastisarsajjanshakti ?? []).firstWhere(
        //   (e) => e.pkid == selectedMukhyaAtithi,
        // );
        selectedPrabhavi = null;
      } else {
        print("====================");
        print(getVijayaDashamiUtsavDataByGeounitData?.mukhyaAtithiVastisarAnyaprabhavilokam);
        final list = getVijayaDashamiUtsavDataByGeounitData?.mukhyaAtithiVastisarAnyaprabhavilokam;
        if (list != null && list.isNotEmpty) {
          selectedPrabhavi = list.first;
        }
        // selectedPrabhavi = (data?.vastisanyaprabhavi ?? []).where((e) => e.pkId == selectedMukhyaAtithi).toList().isNotEmpty
        //     ? (data?.vastisanyaprabhavi ?? []).firstWhere((e) => e.pkId == selectedMukhyaAtithi)
        //     : null;

        selectedPerson = null;
      }
//============================================   bhougolik pratinidhitwa =================================================================
      selectedBhougolikPratinidhitwaVastiIds = utsav.bhougolikPratinidhatvaIds ?? '';

      if (selectedBhougolikPratinidhitwaVastiIds != null && selectedBhougolikPratinidhitwaVastiIds!.isNotEmpty && data?.vastimandallist != null) {
        final idSet = selectedBhougolikPratinidhitwaVastiIds!.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();

        checkboxGraamVastiSelectedItems = data!.vastimandallist!.where((item) => idSet.contains(item.geoUnitID.toString())).toList();
      } else {
        checkboxGraamVastiSelectedItems = [];
      }
      selectedVastiCount = utsav.bhougolikPratinidhatvaCount ?? 0;
      print("++++++++++++++++++++++++++");
      print(selectedVastiCount);
      print(utsav.bhougolikPratinidhatvaCount);
      selectedVastiCount = utsav.bhougolikPratinidhatvaCount ?? 0;

//============================================   SHAKHAA pratinidhitwa =================================================================

      selectedShakhaaPratinidhitwaVastiIds = utsav.shakhaPratinidhatvaIds ?? '';
      if (selectedShakhaaPratinidhitwaVastiIds != null && selectedShakhaaPratinidhitwaVastiIds!.isNotEmpty && data?.shakhaalist != null) {
        final idSet = selectedShakhaaPratinidhitwaVastiIds!.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();

        checkboxShakhaSelectedItems = data!.shakhaalist!.where((item) => idSet.contains(item.geoUnitID.toString())).toList();
      } else {
        checkboxShakhaSelectedItems = [];
      }
      selectedShakhaCount = utsav.shakhaPratinidhatvaCount ?? 0;
//============================================   MILAN pratinidhitwa =================================================================
      selectedMilanPratinidhitwaVastiIds = utsav.milanPratinidhatvaIds ?? '';
      if (selectedMilanPratinidhitwaVastiIds != null && selectedMilanPratinidhitwaVastiIds!.isNotEmpty && data?.shakhaalist != null) {
        final idSet = selectedMilanPratinidhitwaVastiIds!.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();

        checkboxMilanSelectedItems = data!.shakhaalist!.where((item) => idSet.contains(item.geoUnitID.toString())).toList();
      } else {
        checkboxMilanSelectedItems = [];
      }

      selectedMilanCount = utsav.milanPratinidhatvaCount ?? 0;
//============================================   MASIKMILAN SANGHA MANDALI  pratinidhitwa =================================================================

      selectedSanghaMandaliPratinidhitwaVastiIds = utsav.manasikSanghMandaliPratinidhatvaIds ?? '';
      if (selectedSanghaMandaliPratinidhitwaVastiIds != null && selectedSanghaMandaliPratinidhitwaVastiIds!.isNotEmpty && data?.shakhaalist != null) {
        final idSet = selectedSanghaMandaliPratinidhitwaVastiIds!.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();

        checkboxSanghaMandaliSelectedItems = data!.shakhaalist!.where((item) => idSet.contains(item.geoUnitID.toString())).toList();
      } else {
        checkboxSanghaMandaliSelectedItems = [];
      }

      selectedSanghaMandaliCount = utsav.manasikSanghMandaliPratinidhatvaCount ?? 0;
      totalVastiCount = utsav.bhougolikEkunvasti ?? 0;
      totalShakhaCount = utsav.shakhaPratinidhatvaEkun ?? 0;
      totalMilanCount = utsav.milanPratinidhatvaEkun ?? 0;
      totalSanghaMandaliCount = utsav.manasikSanghMandaliPratinidhatvaEkun ?? 0;
      averageShakhaCount = utsav.shakhaPratinidhatvaSahasari.toString();
      averageMilanCount = utsav.milanPratinidhatvaSahasari.toString();
      averageSanghaMandaliCount = utsav.manasikSanghMandaliPratinidhatvaSahasari.toString();
    });
  }

  Future<void> scrollToBottom() async {
    if (!_mainScrollController.hasClients) return;

    await _mainScrollController.animateTo(
      _mainScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );

    await Future.delayed(const Duration(milliseconds: 100));

    await _mainScrollController.animateTo(
      _mainScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> showPersonDetailsPopup(BuildContext context, dynamic item, int srNo) {
    List<Map<String, String>> details = [];

    // Agar Vastisarsajjanshakti ka object aaya
    if (item is Vastisarsajjanshakti) {
      details = [
        {"${Statics.getLabel('Vasti')} :": item.vastiname ?? ""},
        {"${Statics.getLabel('Name')} :": item.name ?? ""},
        {"${Statics.getLabel('Address')} :": item.address ?? ""},
        {"${Statics.getLabel('mobileNumberLabel')} :": item.doorabhaash ?? ""},
        {"${Statics.getLabel('shreni')}  :": item.selectedDropdownValueName ?? ""},
        {"${Statics.getLabel('OrganizationName')}  :": item.sanstheCheNaav ?? ""},
        {"${Statics.getLabel('sansthetKuthalaPadavar')}   :": item.sansthechaKuthalaPadavar ?? ""},
        {"${Statics.getLabel('samparkSthiti')}  :": item.selectedDropdownValueName1 ?? ""},
        {"${Statics.getLabel('special')} :": item.visheshname ?? ""},
        {"${Statics.getLabel('prabhavKshetra')} :": item.prabhaavkshetrName ?? ""},
        {"${Statics.getLabel('samparkSootraNaav')} :": item.samparkasutranava ?? ""},
        {"${Statics.getLabel('samparakSootraDoorbhash')} :": item.samparkasutraMobileNumber ?? ""},
      ];
    }

    // Agar Vastisanyaprabhavi ka object aaya
    else if (item is Vastisanyaprabhavi) {
      details = [
        {"${Statics.getLabel('Vasti')}  :": item.vastiName ?? ""},
        {"${Statics.getLabel('Name')} :": item.name ?? ""},
        {"${Statics.getLabel('Address')}:": item.address ?? ""},
        {"${Statics.getLabel('mobileNumberLabel')} :": item.doorabhaash ?? ""},
        {"${Statics.getLabel('shreni')}  :": item.shreneeName ?? ""},
        {"${Statics.getLabel('upshreni')} :": item.upshreneeName ?? ""},
        {"${Statics.getLabel('otherUpshreni')}  :": item.otherUpshrenee ?? ""},
        {"${Statics.getLabel('upshreni')}2 :": item.upshrenee2Name ?? ""},
        {"${Statics.getLabel('otherUpshreni')}2 :": item.otherUpshrenee2 ?? ""},
        {"${Statics.getLabel('special')}  :": item.visheshName ?? ""},
        {"${Statics.getLabel('prabhavKshetra')} :": item.prabhaavKshetreName ?? ""},
        {"${Statics.getLabel('other')} ${Statics.getLabel('special')}  :": item.anyaVishesMahiti ?? ""},
        {"${Statics.getLabel('samparkStithi')} :": item.samparkSthit ?? ""},
        {"${Statics.getLabel('samparkSootraNaav')} :": item.samparkAsutraNav ?? ""},
        {"${Statics.getLabel('samparakSootraDoorbhash')} :": item.samparkaSutraDoorbhash ?? ""},
      ];
    }

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Header with gradient
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.purpleAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${Statics.getLabel('PersonalDetails')}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // 🔹 Details List
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: details
                          .map(
                            (e) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      e.keys.first,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      e.values.first.isEmpty ? "-" : e.values.first,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // 🔹 Footer Button
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      minimumSize: const Size.fromHeight(45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    label: Text(
                      "${Statics.getLabel('bandKara')}",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class VastiPerson {
  String? samparkasutranava;
  String? address;
  String? doorabhaash;
  int? isactive;
  String? name;
  int? pkid;
  String? prabhaavkshetrName;
  int? prabhaavkshetrid;
  String? samparkasutraMobileNumber;
  String? samparksthitiName;
  int? samparksthitiid;
  String? sanstheCheNaav;
  String? sansthechaKuthalaPadavar;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  String? selectedDropdownValueName2;
  String? shreneedhiName;
  int? shreneeid;
  int? vastiid;
  String? vastiname;
  int? visheshId;
  String? visheshname;

  VastiPerson({
    this.samparkasutranava,
    this.address,
    this.doorabhaash,
    this.isactive,
    this.name,
    this.pkid,
    this.prabhaavkshetrName,
    this.prabhaavkshetrid,
    this.samparkasutraMobileNumber,
    this.samparksthitiName,
    this.samparksthitiid,
    this.sanstheCheNaav,
    this.sansthechaKuthalaPadavar,
    this.selectedDropdownValueName,
    this.selectedDropdownValueName1,
    this.selectedDropdownValueName2,
    this.shreneedhiName,
    this.shreneeid,
    this.vastiid,
    this.vastiname,
    this.visheshId,
    this.visheshname,
  });
}

class VastiCounts {
  final Map<String, int> prakarCounts;
  final Map<String, int> vayogatCounts;

  VastiCounts({
    required this.prakarCounts,
    required this.vayogatCounts,
  });

  // Factory for JSON parsing
  factory VastiCounts.fromJson(Map<String, dynamic> json) {
    return VastiCounts(
      prakarCounts: Map<String, int>.from(json['prakarCounts'] ?? {}),
      vayogatCounts: Map<String, int>.from(json['vayogatCounts'] ?? {}),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'prakarCounts': prakarCounts,
      'vayogatCounts': vayogatCounts,
    };
  }
}
