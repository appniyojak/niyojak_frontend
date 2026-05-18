import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanListResponse.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanLoginDataResponse.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanSwayamsevakListResponse.dart';
import 'package:niyojak_prod/models/response_model/AbhiyanGruhasamparkResponse.dart';
import 'package:niyojak_prod/providers/bals.dart';
import 'package:niyojak_prod/providers/swayamsevak_provider.dart';
import 'package:niyojak_prod/screens/AbhiyaanSwayamsevak.dart';
import 'package:niyojak_prod/screens/AddGruhaSamparkScreen.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/static_data.dart' as Statics;
import '../models/response_model/dropdown_level_responsemodel.dart';
import '../utils/globals.dart';
import 'AbhiyanAddSwayamsevak.dart';
import 'VisheshVyaktShodhScreen.dart';
import 'home_screen/home_screen.dart';

class AbhiyanScreen extends StatefulWidget {
  static const routeName = '/abhiyan-screen';

  @override
  State<AbhiyanScreen> createState() => _AbhiyanScreenState();
}

class _AbhiyanScreenState extends State<AbhiyanScreen> with SingleTickerProviderStateMixin {
  String? selectedGruhaAbhiyanValue = "";
  TabController? _tabController;
  TextEditingController searchPhoneController = TextEditingController();
  TextEditingController searchPhoneDialogController = TextEditingController();

  bool _isSearching = false;

  List<LevelMasterBAL>? _level;
  List<GeoUnitMasterBAL>? _geoUnits;
  String? _levelValue = "";
  String? _geoUnitsValue = "";

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedupnagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;

  bool? _linkedMahaanagarDisable = false;
  bool? _linkedVibhaagDisable = false;
  bool? _linkedbhaagDisable = false;
  bool? _linkedshaharDisable = false;
  bool? _linkednagarDisable = false;
  bool? _linkedmandalDisable = false;
  bool? _linkedgraamDisable = false;
  bool? _linkedvastiDisable = false;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedupnagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";
  String? type;
  String? _selectedGeoUnitId;
  String? _selctedLevel;
  List<MenuChoices> choices = [];
  String? selectedDayitvValue = "";
  List<AbhiyaanList> abhiyaanDataList = [];
  List<AbhiyanSwayamsevakList> abhiyaanSwayamsevakDataList = [];
  bool _isExpanded = false;
  AbhiyanSwayamsevakdata? initialData;

  AbhiyanGruhasamparkData? abhiyaanGruhaSamparkDataList;

  Future<void> populateDropdown({bool fromClear = false}) async {
    setState(() {
      _linkedshaharValue = null;
      _linkednagarValue = null;
      _linkedmandalValue = null;
      _linkedgraamValue = null;
      _linkedvastiValue = null;
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
    // if (initialData != null) {
    //   setState(() {
    //     if (initialData!.parentMahaanagarID != null) {
    //       _isExpanded = true;
    //       _linkedMahaanagarDisable = true;
    //       _linkedMahaanagarValue = initialData!.parentMahaanagarID.toString();
    //     }
    //     if (initialData!.parentVibhaagID != null) {
    //       populatelinkedVibhaagDropdown('');
    //       _isExpanded = true;
    //       _linkedVibhaagDisable = true;
    //       _linkedVibhaagValue = initialData!.parentVibhaagID.toString();
    //     }
    //     if (initialData!.parentBhaagID != null) {
    //       _isExpanded = true;
    //       _linkedbhaagDisable = true;
    //       _linkedbhaagValue = initialData!.parentBhaagID.toString();
    //       populatelinkedNagarDropdown(_linkedbhaagValue, null);
    //     }
    //     if (initialData!.parentNagarID != null) {
    //       _isExpanded = true;
    //       _linkednagarDisable = true;
    //       _linkednagarValue = initialData!.parentNagarID.toString();
    //       populatelinkedMandalDropdown(_linkednagarValue);
    //       populatelinkedVastiDropdown(_linkednagarValue);
    //     }
    //     if (initialData!.parentMandalID != null) {
    //       _isExpanded = true;
    //       _linkedmandalDisable = true;
    //       _linkedmandalValue = initialData!.parentMandalID.toString();
    //       populatelinkedGraamDropdown(_linkedmandalValue);
    //     }
    //     if (initialData!.levelName == "Vasti" && initialData!.geoUnitID != null) {
    //       _isExpanded = true;
    //       _linkedvastiDisable = true;
    //       _linkedvastiValue = initialData!.geoUnitID.toString();
    //     } else if (initialData!.levelName == "Graam" && initialData!.geoUnitID != null) {
    //       _isExpanded = true;
    //       _linkedgraamDisable = true;
    //       _linkedgraamValue = initialData!.geoUnitID.toString();
    //     } else if (initialData!.levelName == "Mandal" && initialData!.geoUnitID != null) {
    //       _isExpanded = true;
    //       _linkedmandalDisable = true;
    //       _linkedmandalValue = initialData!.geoUnitID.toString();
    //       populatelinkedGraamDropdown(_linkedmandalValue);
    //     } else if (initialData!.levelName == "Nagar" && initialData!.geoUnitID != null) {
    //       _isExpanded = true;
    //       _linkednagarDisable = true;
    //       _linkednagarValue = initialData!.geoUnitID.toString();
    //       populatelinkedMandalDropdown(_linkednagarValue);
    //       populatelinkedVastiDropdown(_linkednagarValue);
    //     } else if (initialData!.levelName == "Bhaag" && initialData!.geoUnitID != null) {
    //       _isExpanded = true;
    //       _linkedbhaagDisable = true;
    //       _linkedbhaagValue = initialData!.geoUnitID.toString();
    //       populatelinkedNagarDropdown(_linkedbhaagValue, null);
    //     } else {
    //       _isExpanded = false;
    //       // _linkedgraamDisable = true;
    //       _linkedbhaagValue = null;
    //       _linkedshaharValue = null;
    //       _linkednagarValue = null;
    //       _linkedmandalValue = null;
    //       _linkedgraamValue = null;
    //       _linkedvastiValue = null;
    //     }
    //   });
    // }

    setState(() {});
    if (fromClear || userLevelId == null || ddm == null) {
      return;
    }
    await populateAllDropdowns(userLevelId!, ddm!);
  }

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
    });
    await populateDropdown();
    getInitialData();
    Future.delayed(Duration.zero, () async {
      await getAbhiyaanListData();
    });
  }

  Future<void> populateAllDropdowns(int level, DropDownModel dm) async {
    setState(() {
      _selectedGeoUnitId = _linkedMahaanagarValue = _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = null;
    });
    final selection = prepareSelection(dm);

    // Step 1: Mahaanagar
    await populatelinkedMahaanagarDropdown();
    _linkedMahaanagarValue = (level == 9 ? (dm.geoUnitID ?? "").toString() : selection.mahaanagar) ?? '';
    if (level == 9) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.mahaanagar).toString();
      _selctedLevel = 'Mahanagar';
      type = "mahanagar";

      // final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      // selctedLevelName = selectedItem.name;
    }

    // Step 2: Vibhaag
    await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
    _linkedVibhaagValue = (level == 8 ? (dm.geoUnitID ?? "").toString() : selection.vibhaag) ?? '';
    if (level == 8) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.vibhaag).toString();
      _selctedLevel = 'Vibhaag';
      type = "vibhag";

      // final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      // selctedLevelName = selectedItem.name;
    }

    // Step 3: Bhaag
    await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
    _linkedbhaagValue = (level == 7 ? (dm.geoUnitID ?? "").toString() : selection.bhaag) ?? '';
    if (level == 7) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.bhaag).toString();
      _selctedLevel = 'Bhaag';
      type = "bhag";

      // final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      // selctedLevelName = selectedItem.name;
    }

    // Step 4: Nagar
    await populatelinkedNagarDropdown(_linkedbhaagValue, null);
    _linkednagarValue = (level == 6 ? (dm.geoUnitID ?? "").toString() : selection.nagar) ?? '';
    if (level == 6) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.nagar).toString();
      _selctedLevel = 'Nagar';
      type = "nagar";

      // final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      // selctedLevelName = selectedItem.name;
    }

    // Step 5: Upnagar (conditional)
    await populatelinkedUpnagarDropdown(_linkednagarValue);
    if (selection.upnagar != null && selection.upnagar!.isNotEmpty) {
      _linkedupnagarValue = (level == 13 ? (dm.geoUnitID ?? "").toString() : selection.upnagar) ?? '';
      if (level == 13) {
        _selectedGeoUnitId = (dm.geoUnitID ?? selection.upnagar).toString();
        _selctedLevel = 'upnagarUpkhanda';
        type = "upnagar";
      }
    }

    // Step 6: Mandal
    await populatelinkedMandalDropdown(
      (selection.upnagar != null && selection.upnagar!.isNotEmpty),
      (selection.upnagar != null && selection.upnagar!.isNotEmpty) ? (_linkedupnagarValue!) : _linkednagarValue!,
    );
    _linkedmandalValue = (level == 4 ? (dm.geoUnitID ?? "").toString() : selection.mandal) ?? '';
    if (level == 4) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.mandal).toString();
      _selctedLevel = 'Mandal';
      type = "mandal";
    }
    // Step 7: Graam
    await populatelinkedGraamDropdown(_linkedmandalValue!);
    _linkedgraamValue = (level == 3 ? (dm.geoUnitID ?? "").toString() : selection.graam) ?? '';
    if (level == 3) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.graam).toString();
      _selctedLevel = 'Graam';
      type = "gram";
    }
    // Step 8: Vasti
    await populatelinkedVastiDropdown(
      (selection.upnagar != null && selection.upnagar!.isNotEmpty),
      (selection.upnagar != null && selection.upnagar!.isNotEmpty) ? _linkedupnagarValue! : _linkednagarValue!,
    );
    _linkedvastiValue = (level == 2 ? (dm.geoUnitID ?? "").toString() : selection.vasti) ?? '';
    if (level == 2) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.vasti).toString();
      _selctedLevel = 'Vasti';
      type = "vasti";

      // _getForm();
    }
    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty) _linkedbhaagName = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkednagar != null && _linkednagar!.isNotEmpty) _linkednagarName = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;

    setState(() {});
  }

  populatelinkedMahaanagarDropdown() async {
    _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
  }

  populatelinkedVibhaagDropdown(String? mahaanagarIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr!, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    setState(() {
      _linkedVibhaag = data;
    });
  }

  Future<void> populatelinkedBhaagDropdown(String? vibhaagIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr!, 'Vibhaag', '');
    setState(() {
      _linkedbhaag = data;
    });
  }

  Future<void> populatelinkedShaharDropdown(String? bhaagIDStr) async {
    _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
    setState(() {
      _linkedshahar = (shDD.length > 0 ? shDD : null);
    });
  }

  Future<void> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedUpnagarDropdown(String? nagarIDStr) async {
    _linkedvastiValue = null;
    //_linkedupnagarName = _linkedmandalName = _linkedgraamName = null;
    _linkedvasti = null;
    var mnDD;

    mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');

    setState(() {
      _linkedupnagar = (mnDD.length > 0 ? mnDD : null);
      //_linkedupnagarValue = (userparentUpanagarid ?? userGeoUnitId).toString();
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(bool haveParentUp, String? nagarIDStr) async {
    _linkedvastiValue = null;
    //_linkedvastiName = null;
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

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(bool haveParentUp, String nagarIDStr) async {
    //setState(() => viewcontainer = false);
    _linkedgraamValue = null;
    _linkedgraam = null;
    var data;
    if (haveParentUp) {
      data = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['MandalLevelID'].toString(), nagarIDStr, "Upnagar", '');
    } else {
      data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, "Nagar", '');
    }
    //var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedmandal = data.isNotEmpty ? data : null;
    });
    return data;
  }

  Future<void> populatelinkedGraamDropdown(String? mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    populateChoice();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  getInitialData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = pref.getString("AbhiyanSwayamsevakData");
    print(data);
    if (data != null) {
      initialData = AbhiyanSwayamsevakdata.fromJson(jsonDecode(data));
      type = initialData!.levelName!.toLowerCase();
      print("initialData!  ---> ${json.encode(initialData)}");
      print("initialData!.levelName  ---> ${type}");
      setState(() {});
    }
  }

  getAbhiyaanListData() async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        setState(() {
          _isSearching = true;
        });
        var result = await SwayamsevakProvider().getAbhiyanList();
        if (result.status == "200") {
          print("succeed");
          abhiyaanDataList = result.abhiyaanList!;
          selectedGruhaAbhiyanValue = abhiyaanDataList.first.abhiyaanID.toString();

          setState(() {
            _isSearching = false;
          });
        } else {
          setState(() {
            _isSearching = false;
          });
          Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
        }
      }
    } catch (e) {
      print(e);
      setState(() {
        _isSearching = false;
      });
      Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
    }
  }

  getAbhiyaanGruhaSamparkListData() async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        setState(() {
          _isSearching = true;
        });

        // if(_linkedMahaanagarValue == null || _linkedMahaanagarValue == "" &&
        //     _linkedVibhaagValue == null || _linkedVibhaagValue == "" &&
        //     _linkedbhaagValue == null || _linkedbhaagValue == "" &&
        //     _linkednagarValue == null || _linkednagarValue == "" &&
        //     _linkedmandalValue == null || _linkedmandalValue == "" &&
        //     _linkedvastiValue == null || _linkedvastiValue == "" &&
        //     _linkedgraamValue == null || _linkedgraamValue == "" ){
        //   type = "prant";
        // }else if(_linkedMahaanagarValue != null || _linkedMahaanagarValue != "" &&
        //     _linkedVibhaagValue == null || _linkedVibhaagValue == "" &&
        //     _linkedbhaagValue == null || _linkedbhaagValue == "" &&
        //     _linkednagarValue == null || _linkednagarValue == "" &&
        //     _linkedmandalValue == null || _linkedmandalValue == "" &&
        //     _linkedvastiValue == null || _linkedvastiValue == "" &&
        //     _linkedgraamValue == null || _linkedgraamValue == "" ){
        //   type = "mahanagar";
        // }else if(_linkedMahaanagarValue != null || _linkedMahaanagarValue != "" &&
        //     _linkedVibhaagValue != null || _linkedVibhaagValue != "" &&
        //     _linkedbhaagValue == null || _linkedbhaagValue == "" &&
        //     _linkednagarValue == null || _linkednagarValue == "" &&
        //     _linkedmandalValue == null || _linkedmandalValue == "" &&
        //     _linkedvastiValue == null || _linkedvastiValue == "" &&
        //     _linkedgraamValue == null || _linkedgraamValue == "" ){
        //   type = "vibhag";
        // }else if(_linkedMahaanagarValue != null || _linkedMahaanagarValue != "" &&
        //     _linkedVibhaagValue != null || _linkedVibhaagValue != "" &&
        //     _linkedbhaagValue != null || _linkedbhaagValue != "" &&
        //     _linkednagarValue == null || _linkednagarValue == "" &&
        //     _linkedmandalValue == null || _linkedmandalValue == "" &&
        //     _linkedvastiValue == null || _linkedvastiValue == "" &&
        //     _linkedgraamValue == null || _linkedgraamValue == "" ){
        //   type = "bhag";
        // }else if(_linkedMahaanagarValue != null || _linkedMahaanagarValue != "" &&
        //     _linkedVibhaagValue != null || _linkedVibhaagValue != "" &&
        //     _linkedbhaagValue != null || _linkedbhaagValue != "" &&
        //     _linkednagarValue != null || _linkednagarValue != "" &&
        //     _linkedmandalValue == null || _linkedmandalValue == ""&&
        //     _linkedvastiValue == null || _linkedvastiValue == "" &&
        //     _linkedgraamValue == null || _linkedgraamValue == "" ){
        //   type = "nagar";
        // }else if(_linkedMahaanagarValue != null || _linkedMahaanagarValue != "" &&
        //     _linkedVibhaagValue != null || _linkedVibhaagValue != "" &&
        //     _linkedbhaagValue != null || _linkedbhaagValue != "" &&
        //     _linkednagarValue != null || _linkednagarValue != "" &&
        //     _linkedvastiValue != null || _linkedvastiValue != "" &&
        //     _linkedmandalValue == null || _linkedmandalValue == ""&&
        //     _linkedgraamValue == null || _linkedgraamValue == "" ){
        //   type = "vasti";
        // }else if(_linkedMahaanagarValue != null || _linkedMahaanagarValue != "" &&
        //     _linkedVibhaagValue != null || _linkedVibhaagValue != "" &&
        //     _linkedbhaagValue != null || _linkedbhaagValue != "" &&
        //     _linkednagarValue != null || _linkednagarValue != "" &&
        //     _linkedvastiValue == null || _linkedvastiValue == "" &&
        //     _linkedmandalValue != null || _linkedmandalValue != ""&&
        //     _linkedgraamValue == null || _linkedgraamValue == "" ){
        //   type = "mandal";
        // }else if(_linkedMahaanagarValue != null || _linkedMahaanagarValue != "" &&
        //     _linkedVibhaagValue != null || _linkedVibhaagValue != "" &&
        //     _linkedbhaagValue != null || _linkedbhaagValue != "" &&
        //     _linkednagarValue != null || _linkednagarValue != "" &&
        //     _linkedvastiValue == null || _linkedvastiValue == "" &&
        //     _linkedmandalValue != null || _linkedmandalValue != ""&&
        //     _linkedgraamValue != null || _linkedgraamValue != "" ){
        //   type = "gram";
        // }

        var data = {
          "CreatedByID": initialData!.abhiyanSwayamsevakID!,
          "AbhiyaanID": int.parse(selectedGruhaAbhiyanValue!),
          "Mahanagar": _linkedMahaanagarValue == null || _linkedMahaanagarValue == "" ? 0 : int.parse(_linkedMahaanagarValue!),
          "Vibhag": _linkedVibhaagValue == null || _linkedVibhaagValue == "" ? 0 : int.parse(_linkedVibhaagValue!),
          "BhaagID": _linkedbhaagValue == null || _linkedbhaagValue == "" ? 0 : int.parse(_linkedbhaagValue!),
          "NagarID": _linkednagarValue == null || _linkednagarValue == "" ? 0 : int.parse(_linkednagarValue!),
          "MandalID": _linkedmandalValue == null || _linkedmandalValue == "" ? 0 : int.parse(_linkedmandalValue!),
          "VastiID": _linkedvastiValue == null || _linkedvastiValue == "" ? 0 : int.parse(_linkedvastiValue!),
          "GramID": _linkedgraamValue == null || _linkedgraamValue == "" ? 0 : int.parse(_linkedgraamValue!),
          "type": type
        };

        print(data);

        var result = await SwayamsevakProvider().getAbhiyaGruhaSamparkList(jsonEncode(data));
        if (result.status == "200") {
          print("succeed");
          abhiyaanGruhaSamparkDataList = result.abhiyanGruhasamparkData;

          setState(() {
            _isSearching = false;
          });
        } else {
          setState(() {
            _isSearching = false;
          });
          Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
        }
      }
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      print(e);
      Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
    }
  }

  void populateChoice() {
    setState(() {
      choices = _tabController!.index != 1
          ? [
              new MenuChoices("AddGruha", Icons.add, "${Statics.getLabel('addGruhaSampark')}"),
              new MenuChoices("visheshVyakti", Icons.perm_contact_cal_outlined, "${Statics.getLabel('searchVisheshVyaktiScreenBanner')}"),
            ]
          : [
              new MenuChoices("EditMenu", Icons.add, "${Statics.getLabel('addSahabhagiKaryakarta')}"),
              // new MenuChoices("AbhiyaanSwayam", Icons.perm_contact_cal_outlined,
              //     "सहभागी कार्यकर्ता"),
            ];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onMenuSelected(MenuChoices choice) async {
    print(choice.menuType);
    if (choice.menuType == "AddGruha") {
      Navigator.of(context).pushNamed(AddGruhaSamparkScreen.routeName);
    } else if (choice.menuType == "AbhiyaanSwayam") {
      Navigator.of(context).pushNamed(AbhiyaanSwayamsevak.routeName);
    } else if (choice.menuType == "visheshVyakti") {
      Navigator.of(context).pushNamed(VisheshVyaktiShodhScreen.routeName);
    } else if (choice.menuType == "EditMenu") {
      Navigator.of(context).pushNamed(AbhiyanAddSwayamsevakScreen.routeName);
    }
  }

  late Size size = MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.routeName);
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "${Statics.getLabel('Abhiyaan')}",
              style: TextStyle(fontSize: 24),
            ),
            actions: <Widget>[
              if (_tabController!.index == 1)
                PopupMenuButton<MenuChoices>(
                  onSelected: onMenuSelected,
                  icon: Icon(FontAwesomeIcons.ellipsisV),
                  itemBuilder: (BuildContext context) {
                    return choices.map((MenuChoices choice) {
                      return PopupMenuItem<MenuChoices>(
                        value: choice,
                        child: ListTile(leading: Icon(choice.icon), title: Text(choice.menuText!)),
                      );
                    }).toList();
                  },
                )
              else
                PopupMenuButton<MenuChoices>(
                  onSelected: onMenuSelected,
                  icon: Icon(FontAwesomeIcons.ellipsisV),
                  itemBuilder: (BuildContext context) {
                    return choices.map((MenuChoices choice) {
                      return PopupMenuItem<MenuChoices>(
                        value: choice,
                        child: ListTile(leading: Icon(choice.icon), title: Text(choice.menuText!)),
                      );
                    }).toList();
                  },
                ),
            ],
            bottom: new TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              onTap: (v) {
                _levelValue = "";
                _geoUnitsValue = "";
                setState(() {});
                populateChoice();
                Future.delayed(Duration(milliseconds: 800), () {
                  setState(() {});
                });
              },
              physics: NeverScrollableScrollPhysics(),
              tabs: <Widget>[
                Tab(
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        FontAwesomeIcons.houseUser,
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: size.width * 0.31,
                        alignment: Alignment.center,
                        child: Text(
                          "${Statics.getLabel('GruhaSampark')}",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      Icon(Icons.people),
                      SizedBox(width: 5),
                      Expanded(
                        child: Center(
                          // width: size.width*0.31,
                          child: Text(
                            "${Statics.getLabel('searchAbhiyaanParticipantScreenLabel')}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          drawer: (Statics.userDetails['userID'].toString().isEmpty || Statics.userDetails['userID'] == "0") ? AppAbhiyanDrawer() : AppDrawer(),
          body: ModalProgressHUD(
            inAsyncCall: _isSearching,
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              "${Statics.getLabel('Abhiyaan')}",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 5, right: 0, top: 5, bottom: 5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                              child: DropdownButton(
                                isExpanded: true,
                                isDense: true,
                                iconSize: 30,
                                underline: SizedBox(),
                                value: selectedGruhaAbhiyanValue == "" ? null : selectedGruhaAbhiyanValue,
                                onChanged: (newValue) {
                                  print(newValue);
                                  setState(() {
                                    selectedGruhaAbhiyanValue = newValue;
                                  });
                                },
                                items: abhiyaanDataList.map((value) {
                                  return DropdownMenuItem(
                                    value: value.abhiyaanID.toString(),
                                    child: Text(value.abhiyaanName!),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        // margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(width: 0.7, color: Colors.grey.shade700)),
                        child: ExpansionPanelList(
                          elevation: 0,
                          expandedHeaderPadding: EdgeInsets.zero,
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _isExpanded = isExpanded;
                              // if(_swSthaanList != null){
                              //   _search2("Search");
                              // }
                            });
                          },
                          children: [
                            ExpansionPanel(
                              backgroundColor: Colors.transparent,
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(
                                    "${Statics.getLabel('SelectLevel')}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                );
                              },
                              body: Container(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    if (_linkedMahaanagar != null)
                                      buildDropdownField(
                                        isDisabled: ((userLevelId ?? 0) < 9 || userLevelId == 13),
                                        label: Statics.getLabel('Mahaanagar'),
                                        value: _linkedMahaanagarValue,
                                        items: _linkedMahaanagar!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                                        onChanged: (value) {
                                          print(value);
                                          setState(() {
                                            _linkedMahaanagarValue = value;
                                            _linkedVibhaagValue = null;
                                            _linkedupnagarValue = null;
                                            _linkednagarValue = null;

                                            _linkedMahaanagarDisable = false;
                                            _linkedVibhaagDisable = false;
                                            _linkedbhaagDisable = false;
                                            _linkedshaharDisable = false;
                                            _linkednagarDisable = false;
                                            _linkedmandalDisable = false;
                                            _linkedgraamDisable = false;
                                            _linkedvastiDisable = false;

                                            _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedupnagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
                                            type = "mahanagar";
                                          });
                                          populatelinkedVibhaagDropdown(value);
                                        },
                                      ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    if (_linkedVibhaag != null && _linkedVibhaag!.length > 0)
                                      buildDropdownField(
                                        isDisabled: ((userLevelId ?? 0) < 8 || userLevelId == 13),
                                        label: Statics.getLabel('Vibhaag'),
                                        value: _linkedVibhaagValue,
                                        items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedVibhaagValue = value;
                                            type = "vibhag";
                                          });
                                          populatelinkedBhaagDropdown(value);
                                        },
                                      ),
                                    if (_linkedVibhaag != null && _linkedVibhaag!.length > 0)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                                      buildDropdownField(
                                        isDisabled: ((userLevelId ?? 0) < 7 || userLevelId == 13),
                                        label: Statics.getLabel('Bhaag'),
                                        value: _linkedbhaagValue == "" ? null : _linkedbhaagValue,
                                        items: _linkedbhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedbhaagValue = value;
                                            type = "bhag";
                                          });
                                          populatelinkedShaharDropdown(value);
                                          populatelinkedNagarDropdown(value, null);
                                        },
                                      ),
                                    if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    /*if (_linkedshahar != null && _linkedshahar!.length > 0)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                                        isExpanded: true,
                                        value: _linkedshaharValue == "" ? null : _linkedshaharValue,
                                        items: _linkedshahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedshaharValue = value;
                                            populatelinkedNagarDropdown(null, value);
                                            type = "shahar";
                                          });
                                        },
                                      ),
                                    if (_linkedshahar != null && _linkedshahar!.length > 0)
                                      SizedBox(
                                        height: 10,
                                      ),*/
                                    if (_linkednagar != null && _linkednagar!.length > 0)
                                      buildDropdownField(
                                        isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
                                        label: Statics.getLabel('Nagar'),
                                        value: _linkednagarValue == "" ? null : _linkednagarValue,
                                        items: _linkednagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkednagarValue = value;
                                            type = "nagar";
                                          });
                                          populatelinkedUpnagarDropdown(value!);
                                          populatelinkedMandalDropdown(false, value!);
                                          populatelinkedVastiDropdown(false, value);
                                        },
                                      ),
                                    if (_linkednagar != null && _linkednagar!.length > 0)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    if (_linkedupnagar != null && _linkedupnagar!.length > 0)
                                      buildDropdownField(
                                        isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
                                        label: Statics.getLabel('upnagarUpkhanda'),
                                        value: _linkedupnagarValue == "" ? null : _linkedupnagarValue,
                                        items: _linkedupnagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedupnagarValue = value;
                                            type = "upnagarUpkhanda";
                                          });
                                          populatelinkedMandalDropdown(true, value!);
                                          populatelinkedVastiDropdown(true, value);
                                        },
                                      ),
                                    if (_linkedupnagar != null && _linkedupnagar!.length > 0)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    if (_linkedmandal != null && _linkedmandal!.length > 0)
                                      buildDropdownField(
                                        isDisabled: ((userLevelId ?? 0) < 4),
                                        label: Statics.getLabel('Mandal'),
                                        value: _linkedmandalValue == "" ? null : _linkedmandalValue,
                                        items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedmandalValue = value;
                                            type = "mandal";
                                          });
                                          populatelinkedGraamDropdown(value);
                                        },
                                      ),
                                    if (_linkedmandal != null && _linkedmandal!.length > 0)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    if (_linkedgraam != null && _linkedgraam!.length > 0)
                                      buildDropdownField(
                                        isDisabled: ((userLevelId ?? 0) < 3),
                                        label: Statics.getLabel('Graam'),
                                        value: _linkedgraamValue == "" ? null : _linkedgraamValue,
                                        items: _linkedgraam!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedgraamValue = value;
                                            type = "gram";
                                          });
                                        },
                                      ),
                                    if (_linkedvasti != null && _linkedvasti!.length > 0)
                                      buildDropdownField(
                                        isDisabled: ((userLevelId ?? 0) < 2),
                                        label: Statics.getLabel('Vasti'),
                                        value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                                        items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedvastiValue = value;
                                            type = "vasti";
                                          });
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              isExpanded: _isExpanded,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.symmetric(
                              horizontal: 35,
                              vertical: 5,
                            ),
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                            onPressed: () async {
                              // if(Statics.userDetails[])
                              await getAbhiyaanGruhaSamparkListData();
                            },
                            child: Text(
                              "${Statics.getLabel('search')}",
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          MaterialButton(
                              onPressed: () {
                                setState(() {
                                  _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                                  _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                                  type = "praant";
                                });
                                populateDropdown();
                              },
                              child: Text(Statics.getLabel('clear'))),
                        ],
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      if (abhiyaanGruhaSamparkDataList != null)
                        Row(
                          children: [
                            // Column for Label
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3.5,
                              child: Center(
                                  child: Text(
                                '${Statics.getLabel('praant')}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              )),
                            ),
                            // Column for Counts
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    // Today's Count
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3.2,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              Statics.getLabel('todayVrutta'),
                                              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
                                            ),
                                            Text(
                                              abhiyaanGruhaSamparkDataList?.pMyAajCount.toString() == 'null' ? '0' : abhiyaanGruhaSamparkDataList!.sMyAajCount.toString(),
                                              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Yesterday's Count
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3.2,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              Statics.getLabel('YesterdayVrutta'),
                                              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
                                            ),
                                            Text(
                                              abhiyaanGruhaSamparkDataList?.pKalchaCount.toString() ?? "0",
                                              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Total Count
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3.2,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              Statics.getLabel('TotalGruhaSampark'),
                                              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
                                            ),
                                            Text(
                                              abhiyaanGruhaSamparkDataList?.pEkunCount.toString() ?? "0",
                                              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (abhiyaanGruhaSamparkDataList != null)
                        Divider(
                          thickness: 2,
                          color: Colors.black45,
                        ),
                      if (abhiyaanGruhaSamparkDataList != null)
                        Row(
                          children: [
                            // Column for Label
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3.5,
                              child: Center(
                                child: Text(
                                  '${Statics.getLabel('newsOfMyLevel')}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                            // Column for Counts
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    // Today's Count
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3.2,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              Statics.getLabel('todayVrutta'),
                                              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
                                            ),
                                            Text(
                                              abhiyaanGruhaSamparkDataList?.sMyAajCount.toString() ?? "0",
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Yesterday's Count
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3.2,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              Statics.getLabel('YesterdayVrutta'),
                                              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
                                            ),
                                            Text(
                                              abhiyaanGruhaSamparkDataList?.sMyKalchaCount.toString() ?? "0",
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Total Count
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3.2,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              Statics.getLabel('TotalGruhaSampark'),
                                              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
                                            ),
                                            Text(
                                              abhiyaanGruhaSamparkDataList?.sTotalCount.toString() ?? "0",
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                      if (abhiyaanGruhaSamparkDataList != null)
                        Divider(
                          thickness: 2,
                          color: Colors.black45,
                        ),
                      if (abhiyaanGruhaSamparkDataList != null)
                        Center(
                            child: Text(
                          '${Statics.getLabel("anotherLevelNews")}',
                          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600, fontSize: 19),
                        )),
                      if (abhiyaanGruhaSamparkDataList != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              abhiyaanGruhaSamparkDataList!.abhiyaancount!.isEmpty
                                  ? Text(Statics.getLabel('NoDataFound'), style: TextStyle(fontSize: 16))
                                  : Row(
                                      children: [
                                        DataTable(
                                          columnSpacing: 5.0,
                                          border: TableBorder.all(color: Colors.black26),
                                          columns: [
                                            DataColumn(
                                              label: Center(
                                                child: Text(
                                                  Statics.getLabel('Location'),
                                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ],
                                          rows: abhiyaanGruhaSamparkDataList!.abhiyaancount!.map((data) {
                                            return DataRow(
                                              cells: [
                                                DataCell(
                                                  Center(child: Text(data.naav ?? 'N/A')),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: DataTable(
                                              // columnSpacing: 5.0,
                                              border: TableBorder.all(color: Colors.black26),
                                              columns: [
                                                DataColumn(
                                                  label: Center(
                                                    child: Text(
                                                      Statics.getLabel('todayVrutta'),
                                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Center(
                                                    child: Text(
                                                      Statics.getLabel('YesterdayVrutta'),
                                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Center(
                                                    child: Text(
                                                      Statics.getLabel('TotalGruhaSampark'),
                                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              rows: abhiyaanGruhaSamparkDataList!.abhiyaancount!.map((data) {
                                                return DataRow(
                                                  cells: [
                                                    DataCell(Center(child: Text(data.aajchacount?.toString() ?? '0'))),
                                                    DataCell(Center(child: Text(data.kalchacount?.toString() ?? '0'))),
                                                    DataCell(Center(child: Text(data.total?.toString() ?? '0'))),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                  child: Text(
                                '${Statics.getLabel("chotaBaithaktable")}',
                                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600, fontSize: 19),
                              )),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  DataTable(
                                    columnSpacing: 5.0,
                                    border: TableBorder.all(color: Colors.black26),
                                    columns: [
                                      DataColumn(
                                        label: Center(
                                          child: Text(
                                            Statics.getLabel('Location'),
                                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: abhiyaanGruhaSamparkDataList!.abhiyaancount!.map((data) {
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Center(child: Text(data.naav ?? 'N/A')),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        // columnSpacing: 5.0,
                                        border: TableBorder.all(color: Colors.black26),
                                        columns: [
                                          DataColumn(
                                            label: Center(
                                              child: Text(
                                                Statics.getLabel('todayChotaBaithak'),
                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Center(
                                              child: Text(
                                                Statics.getLabel('todayChotaBaithakMaleCount'),
                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Center(
                                              child: Text(
                                                Statics.getLabel('todayChotaBaithakFemaleCount'),
                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Center(
                                              child: Text(
                                                Statics.getLabel('todayChotaBaithakTotalCount'),
                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Center(
                                              child: Text(
                                                Statics.getLabel('yesterdayChotaBaithak'),
                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Center(
                                              child: Text(
                                                Statics.getLabel('yesterdayChotaBaithakMaleCount'),
                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Center(
                                              child: Text(
                                                Statics.getLabel('yesterdayChotaBaithakFemaleCount'),
                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Center(
                                              child: Text(
                                                Statics.getLabel('yesterdayChotaBaithakTotalCount'),
                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Center(
                                              child: Text(
                                                Statics.getLabel('TotalChotaBaithak'),
                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Center(
                                              child: Text(
                                                Statics.getLabel('TotalChotaBaithakMale'),
                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Center(
                                              child: Text(
                                                Statics.getLabel('TotalChotaBaithakFemale'),
                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Center(
                                              child: Text(
                                                Statics.getLabel('TotalChotaBaithakCount'),
                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows: abhiyaanGruhaSamparkDataList!.abhiyaancount!.map((data) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Center(child: Text(data.isaajchaChotaBaithak.toString()))),
                                              DataCell(Center(child: Text(data.aajchaChotaBaithakcountMale?.toString() ?? '0'))),
                                              DataCell(Center(child: Text(data.aajchaChotaBaithakcountFemale?.toString() ?? '0'))),
                                              DataCell(Center(child: Text("${data.totalaajchaChotaBaithakcount}"))),
                                              DataCell(Center(child: Text(data.isKalchaChotaBaithak?.toString() ?? '0'))),
                                              DataCell(Center(child: Text(data.kalchaChotaBaithakcountMale?.toString() ?? '0'))),
                                              DataCell(Center(child: Text(data.kalchaChotaBaithakcountFemale?.toString() ?? '0'))),
                                              DataCell(Center(child: Text(data.totalkalchaChotaBaithakcount?.toString() ?? '0'))),
                                              DataCell(Center(child: Text("${data.isTotalChotaBaithak?.toString()}"))),
                                              DataCell(Center(child: Text("${data.totalChotaBaithakMale?.toString()}"))),
                                              DataCell(Center(child: Text("${data.totalChotaBaithakFemale?.toString()}"))),
                                              DataCell(Center(child: Text("${data.totalChotaBaithak?.toString()}"))),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // SingleChildScrollView(
                              //   scrollDirection: Axis.horizontal,
                              //   child: DataTable(
                              //     columns: [
                              //       DataColumn(label: Text(Statics.getLabel('Location'),style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
                              //       DataColumn(label: Text(Statics.getLabel('todayVrutta'),style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
                              //       DataColumn(label: Text("${Statics.getLabel('YesterdayVrutta')}",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),)),
                              //       DataColumn(label: Center(child: Text("${Statics.getLabel('TotalGruhaSampark')}",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),))),
                              //     ],
                              //     rows: abhiyaanGruhaSamparkDataList!.abhiyaancount!.map((data) {
                              //       return DataRow(
                              //         cells: [
                              //           DataCell(Text(data.naav ?? 'N/A')),
                              //           DataCell(Text(data.aajchacount?.toString() ?? '0')),
                              //           DataCell(Text(data.kalchacount?.toString() ?? '0')),
                              //           DataCell(Text(data.total?.toString() ?? '0')),
                              //         ],
                              //       );
                              //     }).toList(),
                              //   ),
                              // ),

                              // SizedBox(
                              //   height: 15,
                              // ),
                              // Center(
                              //     child: Text(
                              //   '${Statics.getLabel("anotherLevelNews")}',
                              //   style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600, fontSize: 19),
                              // )),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Container(
                              //       width: MediaQuery.of(context).size.width / 2.5,
                              //       child: Center(
                              //           child: Text(
                              //             "${Statics.getLabel('YesterdayVrutta')}",
                              //         style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                              //       )),
                              //     ),
                              //     Container(
                              //       width: MediaQuery.of(context).size.width / 2.5,
                              //       child: Center(
                              //           child: Text(
                              //             "${Statics.getLabel('TotalGruhaSampark')}",
                              //         style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                              //       )),
                              //     ),
                              //   ],
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Container(
                              //       width: MediaQuery.of(context).size.width / 2.5,
                              //       child: Center(
                              //           child: Text(
                              //         abhiyaanGruhaSamparkDataList!.anyaKalchaCount.toString() ?? "0",
                              //         style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                              //       )),
                              //     ),
                              //     Container(
                              //       width: MediaQuery.of(context).size.width / 2.5,
                              //       child: Center(
                              //           child: Text(
                              //         abhiyaanGruhaSamparkDataList!.anayaEkunCount.toString() ?? "0",
                              //         style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                              //       )),
                              //     ),
                              //   ],
                              // ),
                              SizedBox(
                                height: 7,
                              ),
                              Divider(
                                thickness: 2,
                                color: Colors.black45,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Center(
                                  child: Text(
                                '${Statics.getLabel('geographicalNews')}',
                                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600, fontSize: 19),
                              )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.8,
                                    child: Center(
                                        child: Text(
                                      "",
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.5,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('Total')}",
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      // "संपर्क अभियान झाले",
                                      "${Statics.getLabel('samparkaAbhiyan')}",
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                                    )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.8,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('NagarShahari')}",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.ekunNagar.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.abhiyanNagarCount.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                    )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.8,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('graaminTaaluka')}",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.ekunTaluka.toString() == "null" ? "0" : abhiyaanGruhaSamparkDataList!.ekunTaluka.toString(),
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.abhiyanTalukaCount.toString() == 'null' ? "0" : abhiyaanGruhaSamparkDataList!.abhiyanTalukaCount.toString(),
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                    )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.8,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('VastiKaaryakartaaCount')}",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.ekunVasti.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.abhiyanVastiCount.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                    )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.8,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('mandal')}",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.ekunMandal.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.abhiyanMandalCount.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                    )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.8,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('GraamKaaryakartaaCount')}",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.ekunGram.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.abhiyanGramCount.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                    )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Divider(
                                thickness: 2,
                                color: Colors.black45,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Center(
                                  child: Text(
                                "${Statics.getLabel('visheshVyaktiCount')}",
                                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600, fontSize: 19),
                              )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                      child: Text(
                                        "${Statics.getLabel('shreni')}",
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17, color: Colors.purpleAccent),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                      child: Text(
                                        "${Statics.getLabel('count')}",
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17, color: Colors.purpleAccent),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('dhaarmik')}",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.dharmik.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                    )),
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('saamaajik')}",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.samajik.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                    )),
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('saiksanik')}",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.shaishanik.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                    )),
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('seva')}",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.sewa.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                    )),
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('saanskrtik')}",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.sanskrutik.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                    )),
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('other')}",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.anya.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                    )),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.black45,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('Total')}",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                      child: Text(
                                        ((abhiyaanGruhaSamparkDataList!.dharmik ?? 0) +
                                                (abhiyaanGruhaSamparkDataList!.samajik ?? 0) +
                                                (abhiyaanGruhaSamparkDataList!.shaishanik ?? 0) +
                                                (abhiyaanGruhaSamparkDataList!.sewa ?? 0) +
                                                (abhiyaanGruhaSamparkDataList!.sanskrutik ?? 0) +
                                                (abhiyaanGruhaSamparkDataList!.anya ?? 0))
                                            .toString(),
                                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 7,
                              ),

                              Divider(
                                thickness: 2,
                                color: Colors.black45,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Center(
                                  child: Text(
                                "${Statics.getLabel('special')}",
                                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600, fontSize: 19),
                              )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('anukool')}",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.anukulDharmik.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                    )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('pratikool')}",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.pratikulSamajik.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                    )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('tatasth')}",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.tShaishanik.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                    )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('wantToJoin')}",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.jSewa.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                    )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('oldSvayansevak')}",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      abhiyaanGruhaSamparkDataList!.jSSanskrutik.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                    )),
                                  ),
                                ],
                              ),

                              Divider(
                                thickness: 1,
                                color: Colors.black45,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                        child: Text(
                                      "${Statics.getLabel('Total')}",
                                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                                    )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: Center(
                                      child: Text(
                                        ((abhiyaanGruhaSamparkDataList!.anukulDharmik ?? 0) +
                                                (abhiyaanGruhaSamparkDataList!.pratikulSamajik ?? 0) +
                                                (abhiyaanGruhaSamparkDataList!.tShaishanik ?? 0) +
                                                (abhiyaanGruhaSamparkDataList!.jSewa ?? 0) +
                                                (abhiyaanGruhaSamparkDataList!.jSSanskrutik ?? 0))
                                            .toString(),
                                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Divider(
                                thickness: 2,
                                color: Colors.black45,
                              ),
                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ),

                      // if (abhiyaanGruhaSamparkDataList.isNotEmpty)
                      //   Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      //     child: Table(
                      //       border: TableBorder.all(width: 0.3),
                      //       columnWidths: {0: FixedColumnWidth(150)},
                      //       children: [
                      //         TableRow(
                      //           children: [
                      //             TableCell(
                      //               child: Container(
                      //                 color: Theme.of(context).primaryColor.withOpacity(0.2),
                      //                 height: 45,
                      //                 child: Center(
                      //                     child: Text(
                      //                   'तारीख',
                      //                   style: TextStyle(fontWeight: FontWeight.bold),
                      //                 )),
                      //               ),
                      //             ),
                      //             TableCell(
                      //               child: Container(
                      //                 color: Theme.of(context).primaryColor.withOpacity(0.2),
                      //                 height: 45,
                      //                 child: Center(child: Text("${Statics.getLabel('count')}", style: TextStyle(fontWeight: FontWeight.bold))),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //         for (int i = 0; i < abhiyaanGruhaSamparkDataList.length; i++)
                      //           TableRow(
                      //             children: [
                      //               TableCell(
                      //                 child: Container(
                      //                     height: 40,
                      //                     decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.2))),
                      //                     padding: const EdgeInsets.symmetric(vertical: 5.0),
                      //                     child: Center(child: Text(abhiyaanGruhaSamparkDataList[i].abhiyanDate.split(" ").first))),
                      //               ),
                      //               TableCell(
                      //                 child: Container(
                      //                     height: 40,
                      //                     decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.2))),
                      //                     padding: const EdgeInsets.symmetric(vertical: 5.0),
                      //                     child: Center(child: Text(abhiyaanGruhaSamparkDataList[i].gruhasamparkCount.toString()))),
                      //               ),
                      //             ],
                      //           ),
                      //
                      //         // Add more TableRows for additional rows
                      //       ],
                      //     ),
                      //   ),
                    ],
                  ),
                ),
                AbhiyaanSwayamsevak(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  addSwayamsevak() {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "स्वयंसेवक   :",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Container(
                // height: 30,
                width: 120,
                margin: EdgeInsets.only(right: 10),
                child: TextField(
                  controller: searchPhoneDialogController,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  autofocus: false,
                  inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      isDense: true,
                      labelText: "फोन द्वारे शोधा",
                      contentPadding: EdgeInsets.only(left: 12, right: 12, top: 15, bottom: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Text(
              "उपलब्ध नाही",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ),
          MaterialButton(
            color: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onPressed: () {},
            child: Text(
              "जोडा",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
