import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanListResponse.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanLoginDataResponse.dart';
import 'package:niyojak_prod/models/response_model/VisheshVyaktiListResponse.dart';
import 'package:niyojak_prod/providers/bals.dart';
import 'package:niyojak_prod/providers/swayamsevak_provider.dart';
import 'package:niyojak_prod/screens/view_vishesh_vyakti_shodh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/static_data.dart' as Statics;
import '../models/response_model/dropdown_level_responsemodel.dart';
import '../utils/globals.dart';
import 'edit_vishesh_vyakti_shod.dart';

class VisheshVyaktiShodhScreen extends StatefulWidget {
  static const routeName = '/vishesh-vyakti-shodh-screen';

  @override
  State<VisheshVyaktiShodhScreen> createState() => _VisheshVyaktiShodhScreenState();
}

class _VisheshVyaktiShodhScreenState extends State<VisheshVyaktiShodhScreen> {
  String selectedGruhaAbhiyanValue = "";
  TextEditingController searchPhoneController = TextEditingController();
  TextEditingController searchPhoneDialogController = TextEditingController();
  bool _isSearching = false;
  GruhasamparkVisheshVyaktiData? argsData;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedupnagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;

  bool _linkedMahaanagarDisable = false;
  bool _linkedVibhaagDisable = false;
  bool _linkedbhaagDisable = false;
  bool _linkedshaharDisable = false;
  bool _linkednagarDisable = false;
  bool _linkedmandalDisable = false;
  bool _linkedgraamDisable = false;
  bool _linkedvastiDisable = false;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedupnagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";
  String _selectedNagarAndBaithak = '';
  String? mahanagarName;

  String? vibhagName;

  String? bhagName;

  String? nagarName;

  String? vastiName;

  TextEditingController anyaSansthaController = TextEditingController();

  String selectedDayitvValue = "";
  List<AbhiyaanList> abhiyaanDataList = [];
  bool _isExpanded = false;
  AbhiyanSwayamsevakdata? initialData;

  String selectedSansthaValue = '';
  String selectedVisheshValue = '';

  String? _selectedGeoUnitId = '';
  String? _selctedLevel = '';

  List<GruhasamparkVisheshVyaktiData> VisheshVyaktiDataList = [];

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    _linkedVibhaag = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedupnagarValue = _linkedupnagar = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaag = _linkedupnagar = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedupnagarValue = _linkedupnagar = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedupnagar = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedbhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _linkedshahar = (shDD.length > 0 ? shDD : null);
    });
    return shDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    print("populatelinkedNagarDropdown   $bhaagIDStr  =====  $shaharIDStr ");
    _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedupnagar = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedUpnagarDropdown(String? nagarIDStr) async {
    _linkedupnagarValue = _linkedvastiValue = null;
    //_linkedupnagarName = _linkedmandalName = _linkedgraamName = null;
    _linkedupnagar = _linkedvasti = null;
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

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  getAbhiyaanListData() async {
    print("getAbhiyaanListData1");
    try {
      print("getAbhiyaanListData1");

      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        print("getAbhiyaanListData2");

        setState(() {
          _isSearching = true;
        });
        var result = await SwayamsevakProvider().getAbhiyanList();
        if (result.status == "200") {
          print("getAbhiyaanListData3");

          print("succeed");
          abhiyaanDataList = result.abhiyaanList!;
          selectedGruhaAbhiyanValue = abhiyaanDataList.first.abhiyaanID.toString();
          setState(() {
            _isSearching = false;
          });
        } else {
          print("getAbhiyaanListData4");

          setState(() {
            _isSearching = false;
          });
          Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
        }
        print("getAbhiyaanListData5");
      }
    } catch (e) {
      print(e);
      setState(() {
        _isSearching = false;
      });
      Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
    }
  }

  @override
  void initState() {
    getInitialData();

    getAbhiyaanListData();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
    });
    await populateDropdown();
  }

  //////////////////////////////////////////////////////////////////////////////////////

  Future<void> populateAllDropdowns(int level, DropDownModel dm) async {
    setState(() {
      _selectedGeoUnitId = _linkedMahaanagarValue = _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = null;
    });
    final selection = prepareSelection(dm);

    // Step 1: Mahaanagar
    await populatelinkedMahaanagarDropdown();
    _linkedMahaanagarValue = (level == 9 ? (dm.geoUnitID ?? 0).toString() : selection.mahaanagar) ?? _linkedMahaanagarValue;
    if (level == 9) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.mahaanagar).toString();
      _selctedLevel = 'Mahaanagar';
    }

    // Step 2: Vibhaag
    await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
    _linkedVibhaagValue = (level == 8 ? (dm.geoUnitID ?? 0).toString() : selection.vibhaag) ?? _linkedVibhaagValue;
    if (level == 8) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.vibhaag).toString();
      _selctedLevel = 'Vibhaag';
    }

    // Step 3: Bhaag
    await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
    _linkedbhaagValue = (level == 7 ? (dm.geoUnitID ?? 0).toString() : selection.bhaag) ?? _linkedbhaagValue;
    if (level == 7) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.bhaag).toString();
      _selctedLevel = 'Bhaag';
    }

    // Step 4: Nagar
    await populatelinkedNagarDropdown(_linkedbhaagValue, null);
    _linkednagarValue = (level == 6 ? (dm.geoUnitID ?? 0).toString() : selection.nagar) ?? _linkednagarValue;
    if (level == 6) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.nagar).toString();
      _selctedLevel = 'Nagar';
    }

    // Step 5: Upnagar (conditional)
    await populatelinkedUpnagarDropdown(_linkednagarValue);
    if (selection.upnagar != null && selection.upnagar!.isNotEmpty) {
      _linkedupnagarValue = (level == 13 ? (dm.geoUnitID ?? "").toString() : selection.upnagar) ?? '';
      if (level == 13) {
        _selectedGeoUnitId = (dm.geoUnitID ?? selection.upnagar).toString();
        _selctedLevel = 'upnagarUpkhanda';
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
    }
    // Step 7: Graam
    await populatelinkedGraamDropdown(_linkedmandalValue!);
    _linkedgraamValue = (level == 3 ? (dm.geoUnitID ?? "").toString() : selection.graam) ?? '';
    if (level == 3) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.graam).toString();
      _selctedLevel = 'Graam';
      // _getForm();
    }
    // Step 8: Vasti
    await populatelinkedVastiDropdown(
      (selection.upnagar != null && selection.upnagar!.isNotEmpty),
      (selection.upnagar != null && selection.upnagar!.isNotEmpty) ? (_linkedupnagarValue) : _linkednagarValue,
    );
    _linkedvastiValue = (level == 2 ? (dm.geoUnitID ?? "").toString() : selection.vasti) ?? '';
    if (level == 2) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.vasti).toString();
      _selctedLevel = 'Vasti';
      // _getForm();
    }

    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedBhaag != null && _linkedBhaag!.isNotEmpty) _linkedbhaagName = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedNagar != null && _linkedNagar!.isNotEmpty) _linkednagarName = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;

    setState(() {});
  }

  getInitialData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = pref.getString("AbhiyanSwayamsevakData");
    print(data);
    if (data != null) {
      initialData = AbhiyanSwayamsevakdata.fromJson(jsonDecode(data));
      setState(() {});
    }
  }

  getVisheshVyaktiListData() async {
    // try {
    print("object 1");
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      setState(() {
        _isSearching = true;
      });
      print("selectedGruhaAbhiyanValue  $selectedGruhaAbhiyanValue");
      var data = {
        "SanstyaType": selectedSansthaValue == null || selectedSansthaValue == "" ? anyaSansthaController.text : selectedSansthaValue,
        "Vishesh": selectedVisheshValue == null ? "" : selectedVisheshValue,
        // "AbhiyaanID": int.parse(selectedGruhaAbhiyanValue),  //old
        "AbhiyaanID": selectedGruhaAbhiyanValue!.isNotEmpty ? int.parse(selectedGruhaAbhiyanValue!) : 0,
        "Mahanagar": _linkedMahaanagarValue == null || _linkedMahaanagarValue == "" ? 0 : int.parse(_linkedMahaanagarValue!),
        "Vibhag": _linkedVibhaagValue == null || _linkedVibhaagValue == "" ? 0 : int.parse(_linkedVibhaagValue!),
        "BhaagID": _linkedbhaagValue == null || _linkedbhaagValue == "" ? 0 : int.parse(_linkedbhaagValue!),
        "NagarID": _linkednagarValue == null || _linkednagarValue == "" ? 0 : int.parse(_linkednagarValue!),
        "MandalID": _linkedmandalValue == null || _linkedmandalValue == "" ? 0 : int.parse(_linkedmandalValue!),
        "VastiID": _linkedvastiValue == null || _linkedvastiValue == "" ? 0 : int.parse(_linkedvastiValue!),
        "GramID": _linkedgraamValue == null || _linkedgraamValue == "" ? 0 : int.parse(_linkedgraamValue!),
      };
      print(data);
      var result = await SwayamsevakProvider().getVisheshVyaktikList(jsonEncode(data));
      if (result.status == "200") {
        print("VisheshVyaktiDataList $VisheshVyaktiDataList");
        VisheshVyaktiDataList = result.gruhasamparkVisheshVyaktiData!;
        setState(() {
          _isSearching = false;
        });
      } else {
        print("object 3");
        setState(() {
          _isSearching = false;
        });
        Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
      }
    }
    // } catch (e) {
    //   print("object 4");
    //
    //   setState(() {
    //     _isSearching = false;
    //   });
    //   print(e);
    //   Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
    // }
    print("_linkedbhaagValue $_linkedbhaagValue");
    int? mahaanagarVal = _linkedMahaanagarValue == null || _linkedMahaanagarValue == "" ? null : int.parse(_linkedMahaanagarValue!);
    int? vibhaagVal = _linkedVibhaagValue == null || _linkedVibhaagValue == "" ? null : int.parse(_linkedVibhaagValue!);
    int? bhaagVal = _linkedbhaagValue == null || _linkedbhaagValue == "" ? null : int.parse(_linkedbhaagValue!);
    int? nagarVal = _linkednagarValue == null || _linkednagarValue == "" ? null : int.parse(_linkednagarValue!);
    int? vasVal = _linkedvastiValue == null || _linkedvastiValue == "" ? null : int.parse(_linkedvastiValue!);

    // setState(() {
    //  mahanagarName =_linkedMahaanagar == null ?"-":  _linkedMahaanagar!.firstWhere((element) => element.geoUnitID == mahaanagarVal).name!;
    //   vibhagName =_linkedVibhaag == null ?"-": _linkedVibhaag!.firstWhere((element) => element.geoUnitID == vibhaagVal).name!;
    //   bhagName =_linkedbhaag == null ?"-":   _linkedbhaag!.firstWhere((element) => element.geoUnitID == bhaagVal).name!;
    //   nagarName =_linkednagar == null ?"-":  _linkednagar!.firstWhere((element) => element.geoUnitID == nagarVal).name!;
    //   vastiName =_linkedvasti == null ?"-":   _linkedvasti!.firstWhere((element) => element.geoUnitID == vasVal).name!;
    //   _selectedNagarAndBaithak =
    //       (mahaanagarVal == null ? '' : _linkedMahaanagar!.firstWhere((element) => element.geoUnitID == mahaanagarVal).name!) +
    //           ' | ' +
    //           (vibhaagVal == null ? ' - ' : _linkedVibhaag!.firstWhere((element) => element.geoUnitID == vibhaagVal).name!) +
    //           ' | ' +
    //           (bhaagVal == null ? ' - ' : _linkedbhaag!.firstWhere((element) => element.geoUnitID == bhaagVal).name!) +
    //           ' | ' +
    //           (nagarVal == null ? ' - ' : _linkednagar!.firstWhere((element) => element.geoUnitID == nagarVal).name!);
    // });
    print("_selectedNagarAndBaithak -->  $_selectedNagarAndBaithak");
  }

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
    if (initialData != null) {
      setState(() {
        if (initialData!.parentMahaanagarID != null) {
          _isExpanded = true;
          _linkedMahaanagarDisable = true;
          _linkedMahaanagarValue = initialData!.parentMahaanagarID.toString();
        }
        if (initialData!.parentVibhaagID != null) {
          _isExpanded = true;
          _linkedVibhaagDisable = true;
          _linkedVibhaagValue = initialData!.parentVibhaagID.toString();
          populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
        }
        if (initialData!.parentBhaagID != null) {
          _isExpanded = true;
          _linkedbhaagDisable = true;
          _linkedbhaagValue = initialData!.parentBhaagID.toString();
          populatelinkedNagarDropdown(_linkedbhaagValue!, null);
        }
        if (initialData!.parentNagarID != null) {
          _isExpanded = true;
          _linkednagarDisable = true;
          _linkednagarValue = initialData!.parentNagarID.toString();
          populatelinkedMandalDropdown(false, _linkednagarValue!);
          populatelinkedVastiDropdown(false, _linkednagarValue!);
        }
        if (initialData!.parentMandalID != null) {
          _isExpanded = true;
          _linkedmandalDisable = true;
          _linkedmandalValue = initialData!.parentMandalID.toString();
          populatelinkedGraamDropdown(_linkedmandalValue!);
        }
        if (initialData!.levelName == "Vasti" && initialData!.geoUnitID != null) {
          _isExpanded = true;
          _linkedvastiDisable = true;
          _linkedvastiValue = initialData!.geoUnitID.toString();
        } else if (initialData!.levelName == "Graam" && initialData!.geoUnitID != null) {
          _isExpanded = true;
          _linkedgraamDisable = true;
          _linkedgraamValue = initialData!.geoUnitID.toString();
        } else if (initialData!.levelName == "Mandal" && initialData!.geoUnitID != null) {
          _isExpanded = true;
          _linkedmandalDisable = true;
          _linkedmandalValue = initialData!.geoUnitID.toString();
          populatelinkedGraamDropdown(_linkedmandalValue!);
        } else if (initialData!.levelName == "Nagar" && initialData!.geoUnitID != null) {
          _isExpanded = true;
          _linkednagarDisable = true;
          _linkednagarValue = initialData!.geoUnitID.toString();
          populatelinkedMandalDropdown(false, _linkednagarValue!);
          populatelinkedVastiDropdown(false, _linkednagarValue!);
        } else if (initialData!.levelName == "Bhaag" && initialData!.geoUnitID != null) {
          _isExpanded = true;
          _linkedbhaagDisable = true;
          _linkedbhaagValue = initialData!.geoUnitID.toString();
          populatelinkedNagarDropdown(_linkedbhaagValue, null);
        } else {
          _isExpanded = false;
          // _linkedgraamDisable = true;
          _linkedbhaagValue = null;
          _linkedshaharValue = null;
          _linkednagarValue = null;
          _linkedmandalValue = null;
          _linkedgraamValue = null;
          _linkedvastiValue = null;
        }
      });
    }

    setState(() {});
    if (fromClear || userLevelId == null || ddm == null) {
      return;
    }
    await populateAllDropdowns(userLevelId!, ddm!);
  }

  Future<void> _getCsv() async {
    if (VisheshVyaktiDataList.isEmpty) {
      Statics.showToast("No data available");
      return;
    }

    setState(() {
      _isSearching = true;
    });

    List<List<dynamic>> rows = [];
    List<dynamic> header = [];

    header.add('Full Name');
    header.add("Mobile Number");
    header.add("Address");
    header.add('Sanstha Type');
    header.add("Other Sanstha Type");
    header.add("Sanstha Name");
    header.add("Sanstha Padh");
    header.add("Vishesh Type");
    header.add("Vishesh Note");
    header.add("Mahanagar");
    header.add("Vibhag");
    header.add("Bhaag");
    header.add("Nagar");
    // header.add("Shahar");
    header.add("Mandal");
    header.add("Graam");
    header.add("Vasti");

    rows.add(header);

    for (var data in VisheshVyaktiDataList) {
      List<dynamic> row = [];

      row.add(data.visheshVyaktiName ?? "-");
      row.add(data.mobileNumber ?? "-");
      row.add(data.address ?? "-");
      row.add(data.sansthaType != "धार्मिक" && data.sansthaType != "सामाजिक" && data.sansthaType != "शैक्षणिक" && data.sansthaType != "सेवा" && data.sansthaType != "सांस्कृतिक"
          ? "अन्य"
          : data.sansthaType);
      row.add(
          data.sansthaType == "धार्मिक" || data.sansthaType == "सामाजिक" || data.sansthaType == "शैक्षणिक" || data.sansthaType == "सेवा" || data.sansthaType == "सांस्कृतिक" ? "-" : data.sansthaType);
      row.add(data.sansthaName ?? "-");
      row.add(data.sansthaPadh ?? "-");
      row.add(data.visheshNote ?? "-");
      row.add(data.anyaVishesh ?? "-");

      // Mahanagar //9
      List<GeoUnitMasterBAL> mahanagarList = await populatelinkedMahaanagarDropdown();
      if (mahanagarList.where((element) => element.geoUnitID == data.parentMahaanagarID).isNotEmpty) {
        row.add(mahanagarList.firstWhere((element) => element.geoUnitID == data.parentMahaanagarID).name);
      } else {
        row.add("-");
      }
      // Vibhag  // 10
      List<GeoUnitMasterBAL> vibhagList = await populatelinkedVibhaagDropdown(data.parentMahaanagarID.toString() == "0" ? "" : data.parentMahaanagarID.toString());
      if (vibhagList.where((element) => element.geoUnitID == data.parentVibhaagID).isNotEmpty) {
        row.add(vibhagList.firstWhere((element) => element.geoUnitID == data.parentVibhaagID).name);
        print("parentVibhaagID ${data.parentVibhaagID}");
        print("parentMahaanagarID ${data.parentMahaanagarID}");
      } else {
        row.add("-");
        print("parentVibhaagID 1 ${data.parentVibhaagID}");
        print("parentMahaanagarID 1 ${data.parentMahaanagarID}");
      }
      // Bhag //11
      List<GeoUnitMasterBAL> bhagList = await populatelinkedBhaagDropdown(data.parentVibhaagID.toString()) ?? [];
      if (bhagList.where((element) => element.geoUnitID == data.parentBhaagID).isNotEmpty) {
        row.add(bhagList.firstWhere((element) => element.geoUnitID == data.parentBhaagID).name);
      } else {
        row.add("-");
      }
      // Nagar //12
      // if(data.parentBhaagID.toString() != "0"){
      List<GeoUnitMasterBAL> nagarList = await populatelinkedNagarDropdown(data.parentBhaagID.toString(), null);
      if (nagarList.where((element) => element.geoUnitID == data.parentNagarID).isNotEmpty) {
        row.add(nagarList.firstWhere((element) => element.geoUnitID == data.parentNagarID).name);
      } else {
        row.add("-");
        print("data.parentBhaagID.toString()-${data.parentBhaagID.toString()}====data.parentShaharID.toString()${data.parentShaharID.toString()}");
      }
      // } else if(data.parentShaharID.toString() != "0"){
      //   List<GeoUnitMasterBAL> nagarList = await populatelinkedNagarDropdown('null',data.parentShaharID.toString());
      //   if(nagarList.where((element) =>  element.geoUnitID == data.parentNagarID).isNotEmpty) {
      //     row.add(nagarList.firstWhere((element) => element.geoUnitID == data.parentNagarID).name);
      //   } else {
      //     row.add("-");
      //     print("data.parentBhaagID.toString()-${data.parentBhaagID.toString()}====data.parentShaharID.toString()${data.parentShaharID.toString()}");
      //   }
      // }

      // Shahar //13
      // List<GeoUnitMasterBAL> shaharList = await populatelinkedShaharDropdown(data.parentBhaagID.toString()) ?? [];
      // if(shaharList.where((element) =>  element.geoUnitID == data.parentShaharID).isNotEmpty) {
      //   row.add(shaharList.firstWhere((element) => element.geoUnitID == data.parentShaharID).name);
      // } else {
      //   row.add("-");
      // }
      // Mandal //14
      List<GeoUnitMasterBAL> mandalList = await populatelinkedMandalDropdown(false, data.parentNagarID.toString()) ?? [];
      if (mandalList.where((element) => element.geoUnitID == data.parentMandalID).isNotEmpty) {
        row.add(mandalList.firstWhere((element) => element.geoUnitID == data.parentMandalID).name);
      } else {
        row.add("-");
      }
      // Gram//15
      List<GeoUnitMasterBAL> gramList = await populatelinkedGraamDropdown(data.parentMandalID.toString()) ?? [];
      if (gramList.where((element) => element.geoUnitID == data.parentGraamID).isNotEmpty) {
        row.add(gramList.firstWhere((element) => element.geoUnitID == data.parentGraamID).name);
      } else {
        row.add("-");
      }
      // Vasti //16
      List<GeoUnitMasterBAL> vastiList = await populatelinkedVastiDropdown(false, data.parentNagarID.toString()) ?? [];
      if (vastiList.where((element) => element.geoUnitID == data.parentVastiID).isNotEmpty) {
        row.add(vastiList.firstWhere((element) => element.geoUnitID == data.parentVastiID).name);
      } else {
        row.add("-");
      }
      rows.add(row);
    }

    if (rows.length > 1) {
      String fileName = "VisheshVyaktiShodh_" + DateFormat('ddMMyyyyHHmmss').format(DateTime.now());
      Statics.convertToCsv(rows, fileName, context);
    }

    setState(() {
      _isSearching = false;
    });
  }

  void deletevisheshvyakti(var context, var gruhasamparkVisheshID) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(Statics.getLabel('AskConfirmation')),
            content: Text(Statics.getLabel('AreyouSureYouWantToDeleteVisheshvyakti')),
            actions: <Widget>[
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationYes')),
                onPressed: () async {
                  var data = await Statics.deleteVisheshVyaktiForApp(json.encode({"abhiyangruhasamparkid": gruhasamparkVisheshID}));
                  if (data.contains("Deleted Successfully")) {
                    // widget.refreshList();
                    setState(() {
                      Statics.showToast(Statics.getLabel('VisheshVyaktiDeletedSuccessfully'));
                    });
                  } else
                    Statics.showToast(Statics.getLabel('CouldnotDeleteSwayamsevakTransfer'));

                  Navigator.of(ctx).pop();
                },
              ),
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationNo')),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    } on Exception catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    } catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          mini: true,
          tooltip: Statics.getLabel("ExportToExcel"),
          onPressed: _getCsv,
          child: Icon(Icons.download_sharp),
          backgroundColor: Colors.green,
        ),
        appBar: AppBar(
          title: Text(
            "${Statics.getLabel('searchVisheshVyaktiScreenBanner')}  :",
            style: TextStyle(fontSize: 24),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _isSearching,
          child: SingleChildScrollView(
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
                              selectedGruhaAbhiyanValue = newValue!;
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
                                  items: _linkedMahaanagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      _linkedMahaanagarValue = value;
                                      _linkedVibhaagValue = null;
                                      _linkedbhaagValue = null;
                                      _linkedshaharValue = null;
                                      _linkednagarValue = null;
                                      _linkedupnagarValue = null;
                                      _linkedmandalValue = null;
                                      _linkedgraamValue = null;
                                      _linkedvastiValue = null;

                                      _linkedMahaanagarDisable = false;
                                      _linkedVibhaagDisable = false;
                                      _linkedbhaagDisable = false;
                                      _linkedshaharDisable = false;
                                      _linkednagarDisable = false;
                                      _linkedmandalDisable = false;
                                      _linkedgraamDisable = false;
                                      _linkedvastiDisable = false;

                                      _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedupnagar = _linkedmandal = _linkedgraam = _linkedvasti = null;

                                      populatelinkedVibhaagDropdown(value!);
                                    });
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
                                      _linkedVibhaagValue = value!;
                                      _linkedbhaagValue = null;
                                      _linkedshaharValue = null;
                                      _linkednagarValue = null;
                                      _linkedmandalValue = null;
                                      _linkedgraamValue = null;
                                      _linkedvastiValue = null;
                                      populatelinkedBhaagDropdown(value!);
                                    });
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
                                      _linkedshaharValue = null;
                                      _linkednagarValue = null;
                                      _linkedmandalValue = null;
                                      _linkedgraamValue = null;
                                      _linkedvastiValue = null;
                                      populatelinkedShaharDropdown(value!);
                                      populatelinkedNagarDropdown(value, null);
                                    });
                                  },
                                ),
                              if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                                SizedBox(
                                  height: 10,
                                ),
                              /*if (_linkedshahar != null && _linkedshahar!.length > 0)
                                buildDropdownField(
                                  isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
                                  label: Statics.getLabel('Nagar'),
                                  value: _linkedshaharValue == "" ? null : _linkedshaharValue,
                                  items: _linkedshahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _linkedshaharValue = value;
                                      _linkednagarValue = null;
                                      _linkedmandalValue = null;
                                      _linkedgraamValue = null;
                                      _linkedvastiValue = null;
                                      populatelinkedNagarDropdown(null, value);
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
                                      _linkedmandalValue = null;
                                      _linkedgraamValue = null;
                                      _linkedvastiValue = null;
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
                                      _linkedmandalValue = null;
                                      _linkedgraamValue = null;
                                      _linkedvastiValue = null;
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
                                      _linkedgraamValue = null;
                                      _linkedvastiValue = null;
                                      populatelinkedGraamDropdown(value!);
                                    });
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
                                      _linkedvastiValue = null;
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "${Statics.getLabel('shreni')}  :",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: EdgeInsets.only(right: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          isDense: true,
                          iconSize: 30,
                          underline: SizedBox(),
                          value: selectedSansthaValue == "" ? null : selectedSansthaValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSansthaValue = newValue!;
                            });
                          },
                          items: <String>["धार्मिक", "सामाजिक", "शैक्षणिक", "सेवा", "सांस्कृतिक", "अन्य"].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      // if(selectedSansthaValue == "अन्य")
                      //   Padding(
                      //     padding: const EdgeInsets.all(5.0),
                      //     child: TextFormField(
                      //       autofocus: true,
                      //       textInputAction: TextInputAction.done,
                      //       controller: anyaSansthaController,
                      //       decoration: InputDecoration(
                      //         hintText: "संस्था कुठल्या विषयात काम करते",
                      //
                      //       ),
                      //       keyboardType: TextInputType.text,
                      //       onSaved: (value) {
                      //         // swDetails.fullName = value.trim();
                      //       },
                      //     ),
                      //   ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 9.0),
                        child: Text(
                          "${Statics.getLabel('special')}                       :",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.52,
                        // margin: EdgeInsets.only(right: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            isDense: true,
                            iconSize: 30,
                            underline: SizedBox(),
                            value: selectedVisheshValue == "" ? null : selectedVisheshValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedVisheshValue = newValue!;
                              });
                            },
                            items: <String>["अनुकूल", "प्रतिकूल", "तटस्थ", "संघाशी जुडू इच्छितात", "जुने स्वयंसेवक", "अन्य"].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Text(value),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
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
                        mahanagarName = vibhagName = bhagName = nagarName = vastiName = "";
                        await getVisheshVyaktiListData();
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
                            selectedVisheshValue = selectedSansthaValue = "";
                            _isSearching = false;
                            VisheshVyaktiDataList = [];
                          });
                          populateDropdown();
                        },
                        child: Text(Statics.getLabel('clear'))),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                VisheshVyaktiDataList.isNotEmpty
                    ? Container(
                        height: 500,
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                          // physics: NeverScrollableScrollPhysics(),
                          itemCount: VisheshVyaktiDataList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Card(
                                  margin: EdgeInsets.all(5),
                                  elevation: 5,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                    title: Text(VisheshVyaktiDataList[index].visheshVyaktiName!),
                                    // leading: Checkbox(
                                    //     checkColor: Colors.white,
                                    //     activeColor: Colors.purple,
                                    //     value: widget._isChecked == null ? false : widget._isChecked,
                                    //     onChanged: (value) {
                                    //       setState(() {
                                    //         widget._isChecked = value;
                                    //         if (value == true)
                                    //           widget.onCheckCard(
                                    //               widget.swItem.address, widget.swItem.participantNumber);
                                    //         else
                                    //           widget.onUnCheckCard(
                                    //               widget.swItem.address, widget.swItem.participantNumber);
                                    //       });
                                    //     }),
                                    trailing: Container(
                                      height: 50,
                                      width: 0.1 * Statics.getDeviceSize(context).width,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            right: 0.0,
                                            top: 0.0,
                                            child: PopupMenuButton(
                                              padding: EdgeInsets.all(5),
                                              onSelected: (value) async {
                                                if (value == "सुधार") {
                                                  await Navigator.of(context).pushNamed(
                                                    EditVisheshVyaktiScreen.routeName,
                                                    arguments: VisheshVyaktiDataList[index],
                                                  );
                                                  getVisheshVyaktiListData();
                                                  print("argsData  ${VisheshVyaktiDataList[index].toJson()}");
                                                } else if (value == "हटाएं") {
                                                  setState(() {
                                                    deletevisheshvyakti(context, VisheshVyaktiDataList[index].gruhasamparkVisheshID);
                                                  });
                                                } else if (value == "माहिती पहा") {
                                                  await Navigator.of(context).pushNamed(
                                                    ViewVisheshVyaktiScreen.routeName,
                                                    arguments: VisheshVyaktiDataList[index],
                                                  );
                                                  print("View Information: ${VisheshVyaktiDataList[index].toJson()}");
                                                }
                                                print("object");
                                              },
                                              child: Icon(
                                                FontAwesomeIcons.ellipsisV,
                                                color: Colors.grey,
                                              ),
                                              itemBuilder: (BuildContext context) {
                                                return ['सुधार', 'हटाएं', 'माहिती पहा'].map((String abc) {
                                                  return PopupMenuItem(
                                                    value: abc,
                                                    child: ListTile(
                                                      dense: true,
                                                      contentPadding: EdgeInsets.zero,
                                                      visualDensity: VisualDensity.compact,
                                                      leading: Icon(
                                                        abc == 'सुधार'
                                                            ? Icons.edit
                                                            : abc == 'हटाएं'
                                                                ? Icons.delete
                                                                : Icons.info, // Icon for "माहिती पहा"
                                                        color: Colors.purple,
                                                      ),
                                                      title: Text(abc),
                                                    ),
                                                  );
                                                }).toList();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: Container(
                                        child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(VisheshVyaktiDataList[index].sansthaName!),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(VisheshVyaktiDataList[index].visheshNote!),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Wrap(direction: Axis.vertical, spacing: 5, children: [
                                          if (VisheshVyaktiDataList[index].mobileNumber != null && VisheshVyaktiDataList[index].mobileNumber!.isNotEmpty)
                                            RichText(
                                                text: TextSpan(
                                              text: 'M: ${VisheshVyaktiDataList[index].mobileNumber.toString()}',
                                              style: TextStyle(color: Colors.blue),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  launch("tel://" + VisheshVyaktiDataList[index].mobileNumber.toString());
                                                },
                                            )),
                                          if (VisheshVyaktiDataList[index].address != null && VisheshVyaktiDataList[index].address!.isNotEmpty)
                                            RichText(
                                              text: TextSpan(
                                                text: 'A: ${VisheshVyaktiDataList[index].address.toString()}',
                                                style: TextStyle(color: Colors.blue),
                                                // recognizer: TapGestureRecognizer()
                                                //   ..onTap = () {
                                                //     launch("mailto:" + VisheshVyaktiDataList[index].address.toString());
                                                //   }
                                              ),
                                            )
                                        ])
                                      ],
                                    )),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      )
                    : Container(margin: EdgeInsets.symmetric(vertical: 70), child: Text(Statics.getLabel('noDataFoundTryAnotherSearch'))),
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

// void _getCsv() {
//
//   if(abhiyaanSwayamsevakDataList.isEmpty){
//     Statics.showToast("No data available");
//     return null;
//   }
//
//   setState(() {
//     _isSearching = true;
//   });
//
//   List<List<dynamic>> rows = List<List<dynamic>>();
//   List<dynamic> header = List();
//
//   header.add('Abhiyan');
//   // header.add('Abhiyan Swayamsevak ID');
//   // header.add("Swayamsevak ID");
//   header.add('Full Name');
//   header.add("Mobile Number");
//   header.add("E-mail");
//   header.add("Daayitva Name");
//   // header.add("Level ID");
//   // header.add("GeoUnit ID");
//   header.add("Sanstha Name");
//   header.add("Sanstha Padh");
//   header.add("Sanstha Type");
//   // header.add("bhaag ID");
//   // header.add("nagar ID");
//   // header.add("mandal ID");
//   // header.add("graam ID");
//   // header.add("vasti ID");
//
//
//   rows.add(header);
//
//   for (int i = 0; i < abhiyaanSwayamsevakDataList.length; i++){
//     var data = abhiyaanSwayamsevakDataList[i];
//
//     List<dynamic> row = List();
//
//     row.add(abhiyaanDataList.firstWhere((element) => element.abhiyaanID.toString() == selectedSwayamAbhiyanValue).abhiyaanName);
//     // row.add(data.abhiyanSwayamsevakID.toString());
//     // row.add(data.swayamsevakID.toString());
//     row.add(data.participantName.toString());
//     row.add(data.participantNumber.toString());
//     row.add(data.address.toString());
//     row.add(data.daayityaName.toString());
//     // row.add(data.levelID.toString());
//     // row.add(data.levelName.toString());
//     row.add(data.sansthaName);
//     row.add(data.sansthaPadh);
//     row.add(data.sansthaType);
//     // row.add(data.bhaagId.toString());
//     // row.add(data.nagarId.toString());
//     // row.add(data.mandalId.toString());
//     // row.add(data.gramId.toString());
//     // row.add(data.vastiId.toString());
//
//     rows.add(row);
//   }
//
//   if (rows.length > 1) {
//     Statics.convertToCsv(rows, "AbhiyaanSwayamSevaks" + "_" + DateFormat('ddmmyyyyHHmmss').format(DateTime.now()));
//   }
//
//   setState(() {
//     _isSearching = false;
//   });
//
// }
}
