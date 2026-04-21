import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../models/response_model/sadbhav_baithak_resp_model.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';

class AddNewKaryakramScreen extends StatefulWidget {
  static const String routeName = '/add-new-yuva-karyakram-jan';

  const AddNewKaryakramScreen({super.key});

  @override
  State<AddNewKaryakramScreen> createState() => _AddNewKaryakramScreenState();
}

class _AddNewKaryakramScreenState extends State<AddNewKaryakramScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _searched = false;
  bool _isExpanded = true;

  TextEditingController dateController = TextEditingController();
  TextEditingController txtGivenGroupNameController = TextEditingController();

  // TextEditingController txtPramukhNameController = TextEditingController();
  // TextEditingController txtPramukhMobileController = TextEditingController();
  // TextEditingController txtCentreNameController = TextEditingController();

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedupnagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedupnagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";

  // String? _linkedMahaanagarName = '';
  // String? _linkedVibhaagName = '';
  String? _linkedbhaagName = "";
  String? _linkedshaharName = "";
  String? _linkednagarName = "";
  String? _linkedupnagarName = "";
  String? _linkedmandalName = "";
  String? _linkedgraamName = "";
  String? _linkedvastiName = "";

  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  String _selctedLevelNames = '';
  List<int?> _selctedLevelList = [];
  String? _selectedGeoUnitIdForCreat;
  List<String> _selectedNagarIds = [];

  int? baithakId;
  bool _isViewOnly = false;
  bool _showSearch = true;

  List<Map<String, dynamic>> karyakramLevelsList = [
    {"${Statics.getLabel("Bhaag")}": 1},
    // {"${Statics.getLabel("railwayStation")}": 2},
    // {"${Statics.getLabel("Shahar")}": 3},
    {"${Statics.getLabel("other")}": 4},
    {"${Statics.getLabel("Nagar")}": 5},
    {"${Statics.getLabel("upnagarUpkhanda")}": 6},
    {"${Statics.getLabel("Mandal")}": 7},
  ];
  int? _selectedKaryakramLevelId;

  List<Nagardata> nagarList = [];

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => populateDropdown());
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getData());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
      _selectedKaryakramLevelId = dm.levelID==7 ? 1 : dm.levelID==6 ? 5 : dm.levelID==13 ? 6 : dm.levelID==4 ? 7 : null;
      _selectedKaryakramLevelId = dm.levelID==7 ? 1 : dm.levelID==6 ? 5 : dm.levelID==13 ? 6 : dm.levelID==4 ? 7 : null;
    });
    await populateDropdown();
    getData();
  }

  GeoSelection prepareSelection(DropDownModel dm) {
    return GeoSelection(
      mahaanagar: dm.parentMahaanagarID?.toString() ?? '',
      vibhaag: dm.parentVibhaagID?.toString() ?? '',
      bhaag: dm.parentBhaagID?.toString() ?? '',
      nagar: dm.parentNagarID?.toString() ?? '',
      upnagar: dm.parentUpaNagarID?.toString() ?? '',
      mandal: dm.parentMandalID?.toString() ?? '',
      graam: dm.parentGraamID?.toString() ?? '',
      vasti: dm.parentVastiID?.toString() ?? '',
    );
  }

  Future<void> populateAllDropdowns(int level, DropDownModel dm) async {
    setState(() {
      _selectedGeoUnitIdForCreat = _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    final selection = prepareSelection(dm);

    // Step 1: Mahaanagar
    await populatelinkedMahaanagarDropdown();
    _selectedGeoUnitIdForCreat = _linkedMahaanagarValue = (level == 9 ? (dm.geoUnitID ?? "").toString() : selection.mahaanagar) ?? '';
    _selctedLevel = 'Mahaanagar';

    // Step 2: Vibhaag
    await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
    _selectedGeoUnitIdForCreat = _linkedVibhaagValue = (level == 8 ? (dm.geoUnitID ?? "").toString() : selection.vibhaag) ?? '';
    _selctedLevel = 'Vibhaag';

    // Step 3: Bhaag
    await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
    _selectedGeoUnitIdForCreat = _linkedbhaagValue = (level == 7 ? (dm.geoUnitID ?? "").toString() : selection.bhaag) ?? '';
    _selctedLevel = 'Bhaag';

    // Step 4: Nagar
    await populatelinkedNagarDropdown(_linkedbhaagValue);
    _selectedGeoUnitIdForCreat = _linkednagarValue = (level == 6 ? (dm.geoUnitID ?? "").toString() : selection.nagar) ?? '';
    _selctedLevel = 'Nagar';

    // Step 5: Upnagar (conditional)
    if (selection.upnagar != null && selection.upnagar!.isNotEmpty) {
      await populatelinkedUpnagarDropdown(_linkednagarValue);
      _selectedGeoUnitIdForCreat = _linkedupnagarValue = (level == 13 ? (dm.geoUnitID ?? "").toString() : selection.upnagar) ?? '';
    }

    // Step 6: Mandal
    await populatelinkedMandalDropdown(
      selection.upnagar != null ? "Nagar" : "Upnagar",
      selection.upnagar != null ? _linkednagarValue : _linkedupnagarValue,
    );
    _selectedGeoUnitIdForCreat = _linkedmandalValue = (level == 4 ? (dm.geoUnitID ?? "").toString() : selection.mandal) ?? '';

    // // Step 7: Graam
    // await populatelinkedGraamDropdown(_linkedmandalValue);
    // _selectedGeoUnitId = _linkedgraamValue = (level == 3 ? (dm.geoUnitID ?? "").toString() : selection.graam) ?? '';
    //
    // // Step 8: Vasti
    // await populatelinkedVastiDropdown(_linkedNagarValue);
    // _selectedGeoUnitId = _linkedvastiValue = (level == 2 ? (dm.geoUnitID ?? "").toString() : selection.vasti) ?? '';

    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty) _linkedbhaagName = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkednagar != null && _linkednagar!.isNotEmpty) _linkednagarName = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;

    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _isViewOnly = args?["viewOnly"] ?? false;
    baithakId = args?["id"] ?? 0;
    // _selectedGeoUnitId = args?["geoUnitId"] ?? 0;
    // getData();
    // viewType = args!.viewType;
  }

  getData() async {
    if (baithakId == 0) return;
    var formData = {
      "ids": baithakId,
      "AppUserID": int.parse(Statics.userDetails['userID']),
    };

    final _baithak = await Statics.GetPramukhJanListByIdData(context: context, inputJson: formData, showLoader: true);
    print("getData api HiTttttt >>>>>>>>>>>>>>>>>");

    final _master = _baithak?.masterdata?.first;
    // selectedKendra = _baithak?.masterdata?.first ?? selectedKendra ?? null;

    if (_baithak != null && _master != null) {
      setState(() {
        _searched = true;
        _isExpanded = false;
        txtGivenGroupNameController.text = _master.name ?? "";
        _selectedKaryakramLevelId = _master.shatapdistharlevelid;
      });

      if (_master.parentMahaanagarID != null && _master.parentMahaanagarID != 0) {
        _linkedMahaanagarValue = _master.parentMahaanagarID.toString();
        await populatelinkedVibhaagDropdown(_master.parentMahaanagarID.toString());
      }
      if (_master.parentVibhaagID != null && _master.parentVibhaagID != 0) {
        await populatelinkedBhaagDropdown(_master.parentVibhaagID.toString());
        _linkedVibhaagValue = _master.parentVibhaagID.toString();
      }
      if (_master.parentBhaagID != null && _master.parentBhaagID != 0) {
        await populatelinkedNagarDropdown(_master.parentBhaagID.toString());
        _linkedbhaagValue = _master.parentBhaagID.toString();
      }
      if (_master.parentNagarID != null && _master.parentNagarID != 0) {
        await populatelinkedUpnagarDropdown(_master.parentNagarID.toString());
        await populatelinkedMandalDropdown('Nagar', _master.parentNagarID.toString());
        _linkednagarValue = _master.parentNagarID.toString();
      }
      if (_master.parentUpaNagarID != null && _master.parentUpaNagarID != 0) {
        await populatelinkedMandalDropdown('Upnagar', _master.parentUpaNagarID.toString());
        _linkedupnagarValue = _master.parentUpaNagarID.toString();
      }
      if (_master.parentMandalID != null && _master.parentMandalID != 0) {
        _linkedmandalValue = _master.parentMandalID.toString();
      }
      if (_master.geounitid != null && _master.geounitid != 0) {
        if (_linkedbhaagValue == null || _linkedbhaagValue!.isEmpty) _linkedbhaagValue = _master.geounitid.toString();
        if (_linkednagarValue == null || _linkedbhaagValue!.isEmpty) _linkednagarValue = _master.geounitid.toString();
        if (_linkedupnagarValue == null || _linkedbhaagValue!.isEmpty) _linkedupnagarValue = _master.geounitid.toString();
        if (_linkedmandalValue == null || _linkedbhaagValue!.isEmpty) _linkedmandalValue = _master.geounitid.toString();
        _selectedGeoUnitIdForCreat = _master.geounitid.toString();
      }
      nagarList = _baithak.nagardata ?? [];
      setState(() {});
      if (nagarList.isNotEmpty) _selectedNagarIds.addAll(nagarList.where((e) => e.chkstatus == 1 || e.chkstatus == 2).map((e) => e.geoUnitID.toString()).toList());
      setState(() {});
    }
  }

  // checkIfExistsFun() async {
  //   if (!_formKey.currentState!.validate()) {
  //     Statics.showToast(Statics.getLabel("impInfoRequired"));
  //     return;
  //   }
  //   if (dateController.text.trim().isEmpty) {
  //     Statics.showToast(Statics.getLabel("selectDate"));
  //     return;
  //   }
  //   if (([2, 3, 4].contains(_selectedKaryakramLevelId)) && txtGivenGroupNameController.text.isEmpty) {
  //     Statics.showToast(Statics.getLabel("baithakNameValidationMessage"));
  //     return;
  //   }
  //   FocusManager.instance.primaryFocus?.unfocus();
  //   if (!((([2, 3, 4].contains(_selectedKaryakramLevelId)) && _selctedLevel == Statics.getLabel('Bhaag')) ||
  //       _selctedLevel == karyakramLevelsList.firstWhere((e) => e.values.first == _selectedKaryakramLevelId).keys.first)) {
  //     Statics.showToast("Please select the required GeoUnit");
  //     return;
  //   }
  //
  //   var formData = {
  //     "stharid": _selectedKaryakramLevelId,
  //     "geounitid": _selectedGeoUnitIdForCreat,
  //     "id": baithakId ?? 0,
  //     "appuserid": int.parse(Statics.userDetails['userID']),
  //   };
  //
  //   final _create = await Statics.CreateYuvaSangamData(context: context, inputJson: formData, showLoader: true);
  //   //
  //   if (_create) {
  //     Statics.showToast(Statics.getLabel("dataAlreadyExists"));
  //     return;
  //   }
  //   setState(() {
  //     _searched = true;
  //     _isExpanded = false;
  //     nagarList = _existData.nagardata ?? [];
  //   });
  //   if (_selectedKaryakramLevelId != 4) await createSadbhavBaithakFun();
  // }

  getNagarList() async {
    print(_selectedGeoUnitIdForCreat);
    await populatelinkedNagarDropdown(_selectedGeoUnitIdForCreat);
    setState(() {
      _searched = true;
    });
  }

  createSadbhavBaithakFun() async {
    if (!_formKey.currentState!.validate()) {
      Statics.showToast(Statics.getLabel("impInfoRequired"));
      return;
    }
    if (dateController.text.trim().isEmpty) {
      Statics.showToast(Statics.getLabel("selectDate"));
      return;
    }
    if (_selectedKaryakramLevelId == 4 && txtGivenGroupNameController.text.isEmpty) {
      Statics.showToast(Statics.getLabel("baithakNameValidationMessage"));
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    if (!((_selectedKaryakramLevelId == 4 && _selctedLevel == Statics.getLabel('Bhaag')) ||
        _selctedLevel == karyakramLevelsList.firstWhere((e) => e.values.first == _selectedKaryakramLevelId).keys.first)) {
      Statics.showToast("Please select the required GeoUnit");
      return;
    }

// last 3 (ya jitne available ho)
    final lastThree = _selctedLevelList.length > 3 ? _selctedLevelList.sublist(_selctedLevelList.length - 3) : _selctedLevelList;

// null remove karke join
    final result = lastThree.where((e) => e != null).join(',');
    Map<String, dynamic> formData = {
      "yuvadate": dateController.text.trim(),
      "trailids": result,
      "name": txtGivenGroupNameController.text.trim(),
      "nagarids": _selectedNagarIds.isEmpty ? "" : _selectedNagarIds.join(", "),
      "shatapdistharlevelid": _selectedKaryakramLevelId,
      "geounitid": _selectedGeoUnitIdForCreat,
      "cuserid": int.parse(Statics.userDetails['userID']),
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    final _res = await Statics.CreateYuvaSangamData(context: context, inputJson: formData, showLoader: true);
    if (_res) {
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
      Navigator.pop(context);
    }
    // getFormData();
  }

  clearForm() async {
    setState(() {
      _searched = false;
      _selectedGeoUnitIdForCreat = null;
      nagarList = [];
      _selectedKaryakramLevelId = null;
      txtGivenGroupNameController.clear();
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
      _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
    });
    // clearForm();
    await populateDropdown();
  }

  //////////////////////////////////////////////////////////////////////////////////////

  Future<void> populateDropdown({bool fromClear = false}) async {
    setState(() {
      _selctedLevelList = [];
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
      _linkedMahaanagar = _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedupnagar = _linkedmandal = null;
      _selctedLevelName = _selectedGeoUnitIdForCreat = null;
      nagarList = [];
      _selctedLevel = "praant";
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');

    if (fromClear || userLevelId == null || ddm == null){
      print("object is null");
      print("object is null ${userLevelId == null}");
      print("object is null ${ddm == null}");
      return;
    }
    print("object is not null >>>>>>>>>>>>>>>>>>>>>>");
    await populateAllDropdowns(userLevelId!, ddm!);
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    nagarList = [];
    List<GeoUnitMasterBAL> data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedupnagar = _linkedupnagar = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    nagarList = [];
    print("populatelinkedVibhaagDropdown $mahaanagarIDStr");
    var data;
    if (_selectedKaryakramLevelId == 7) {
      data = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    } else if (_selectedKaryakramLevelId == 6) {
      data = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    } else {
      data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    }
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedupnagar = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
    nagarList = [];
    var data;
    if (_selectedKaryakramLevelId == 7) {
      data = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    } else if (_selectedKaryakramLevelId == 6) {
      data = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    } else {
      data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    }
    setState(() {
      _linkedbhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    nagarList = [];
    var shDD;
    if (_selectedKaryakramLevelId == 7) {
      shDD = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    } else if (_selectedKaryakramLevelId == 6) {
      shDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    } else {
      shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    }
    setState(() {
      _linkedshahar = (shDD.length > 0 ? shDD : null);
    });
    return shDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr) async {
    var ngDD;
// print("populatelinkedNagarDropdown ${bhaagIDStr} == ${shaharIDStr}  ");
    _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagarName = _linkedupnagar = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    nagarList = [];
    print("print LevelID > ${Statics.userDetails["LevelID"]}");
    if (_selectedKaryakramLevelId == 7) {
      ngDD = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    } else if (_selectedKaryakramLevelId == 6) {
      ngDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    } else {
      ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    }
    return ngDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedUpnagarDropdown(String? nagarIDStr) async {
    _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = null;
    _linkedupnagarName = _linkedmandalName = _linkedgraamName = null;
    _linkedupnagar = _linkedmandal = _linkedgraam = null;
    nagarList = [];
    var mnDD;
    if (_selectedKaryakramLevelId == 7) {
      mnDD = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    } else if (_selectedKaryakramLevelId == 6) {
      mnDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    } else {
      mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    }
    setState(() {
      _linkedupnagar = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(String parentType, String? nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandalName = _linkedgraamName = null;
    _linkedmandal = _linkedgraam = null;
    nagarList = [];
    var mnDD;
    if (_selectedKaryakramLevelId == 7) {
      mnDD = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, parentType, '');
    } else if (_selectedKaryakramLevelId == 6) {
      mnDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, parentType, '');
    } else {
      mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, parentType, '');
    }
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  // Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String? mandalIDStr) async {
  //   _linkedgraamValue = null;
  //   _linkedgraamName = null;
  //   var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '');
  //   setState(() {
  //     _linkedgraam = (gmDD.length > 0 ? gmDD : null);
  //   });
  //   return gmDD;
  // }

  // Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String parentType, String? nagarIDStr) async {
  //   _linkedvastiValue = null;
  //   _linkedvastiName = null;
  //   var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, parentType, '');
  //   setState(() {
  //     _linkedvasti = (vsDD.length > 0 ? vsDD : null);
  //   });
  //   return vsDD;
  // }

  //////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${Statics.getLabel('selectKaryakramLevel')}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        "${Statics.getLabel('date2')} : ",
                        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Text(
                    //   " *",
                    //   style: TextStyle(fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
                    // ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: dateController,
                        style: TextStyle(fontSize: 14),
                        autofocus: false,
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: dateController.text.isEmpty ? DateTime.now() : DateFormat("dd/MM/yyyy").parse(dateController.text),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            dateController.text = DateFormat("dd/MM/yyyy").format(date);
                            setState(() {});
                          }
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                            isDense: true,
                            hintText: "DD/MM/YYYY",
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),
                _buildDropdownField(
                  // ignoring: dateController.text.isEmpty || (baithakId != null && baithakId != 0),
                  label: Statics.getLabel('selectStar'),
                  value: _selectedKaryakramLevelId == null ? null : _selectedKaryakramLevelId.toString(),
                  items: karyakramLevelsList
                      .map((bg) => DropdownMenuItem(
                            value: bg.values.first.toString(),
                            child: Text(bg.keys.first),
                          ))
                      .toList(),
                  // onTap: dateController.text.isEmpty ? null : () {},
                  onChanged: (value) {
                    // if (dateController.text.isEmpty) {
                    //   Statics.showToast("Please select date first");
                    //   return;
                    // }
                    populateDropdown();
                    _searched = false;
                    // dateController.clear();
                    setState(() => _selectedKaryakramLevelId = int.tryParse(value.toString()));
                    nagarList = [];
                    print("baithakId >>>>>>>>>>>>>>>> ${baithakId}");
                  },
                  isDisabled: false,
                ),
                SizedBox(height: 18),
                if ([2, 3, 4].contains(_selectedKaryakramLevelId))
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "${Statics.getLabel("Name")} : ",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: TextFormField(
                          controller: txtGivenGroupNameController,
                          style: TextStyle(fontSize: 14),
                          autofocus: false,
                          readOnly: _isViewOnly,
                          decoration: InputDecoration(
                              isDense: true,
                              hintText: Statics.getLabel("addName"),
                              contentPadding: EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              )),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 18),
                if (_selectedKaryakramLevelId != null) nagarDropdown(),
                SizedBox(height: 18),
                // if ((([2, 3, 4].contains(_selectedKaryakramLevelId)) && _selctedLevel == Statics.getLabel('Bhaag')) || _selctedLevel == _selectedKaryakramLevel)

                if (!_isViewOnly && !([2, 3, 4].contains(_selectedKaryakramLevelId) && (baithakId != null && baithakId != 0)))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // if ((_linkedgraamValue != "" && _linkedgraamValue != null) || (_linkedvastiValue != "" && _linkedvastiValue != null))
                      MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 5,
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                        onPressed: [2, 3, 4].contains(_selectedKaryakramLevelId) ? getNagarList : createSadbhavBaithakFun,
                        child: Text(
                          "${Statics.getLabel([2, 3, 4].contains(_selectedKaryakramLevelId) ? 'search' : "Add")}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      MaterialButton(onPressed: clearForm, child: Text(Statics.getLabel('clear'))),
                    ],
                  ),
                SizedBox(height: 18),
                if (_searched && [2, 3, 4].contains(_selectedKaryakramLevelId) && _linkednagar != null && _linkednagar!.isNotEmpty) ...[
                  Wrap(
                    spacing: 12,
                    runSpacing: 18,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: _linkednagar!
                        .map(
                          (nagar) => IgnorePointer(
                            ignoring: _isViewOnly,
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              child: CheckboxListTile(
                                value: _selectedNagarIds.contains(nagar.geoUnitID.toString()),
                                onChanged: (value) {
                                  if (_selectedNagarIds.contains(nagar.geoUnitID.toString())) {
                                    _selectedNagarIds.removeWhere((e) => e.toString() == nagar.geoUnitID.toString());
                                    // nagar.chkstatus = 0;
                                  } else {
                                    _selectedNagarIds.add(nagar.geoUnitID.toString());
                                    // nagar.chkstatus = 1;
                                  }
                                  setState(() {
                                    // print(nagar.chkstatus);
                                    print(_selectedNagarIds);
                                  });
                                },
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                controlAffinity: ListTileControlAffinity.leading,
                                dense: true,
                                title: Text(
                                  (nagar.geoUnitName ?? "--"),
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                          // (nagar) => GestureDetector(
                          //   onTap: () {
                          //     if (_selectedNagarIds.contains(nagar.geoUnitID.toString()))
                          //       _selectedNagarIds.removeWhere((e) => e.toString() == nagar.geoUnitID.toString());
                          //     else
                          //       _selectedNagarIds.add(nagar.geoUnitID.toString());
                          //     setState(() {});
                          //   },
                          //   child: SizedBox(
                          //     width: MediaQuery.sizeOf(context).width * 0.4,
                          //     child: Row(
                          //       spacing: 8,
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         Icon(
                          //           _selectedNagarIds.contains(nagar.geoUnitID.toString()) ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                          //           color: _selectedNagarIds.contains(nagar.geoUnitID.toString()) ? Colors.purple : Colors.black,
                          //         ),
                          //         Expanded(child: Text(nagar.geoname ?? "--")),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 24),
                  if (_selectedNagarIds.isNotEmpty && !_isViewOnly)
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 12,
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                        onPressed: createSadbhavBaithakFun,
                        child: Text(
                          "${Statics.getLabel('Submit')}",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                ],
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textControllerField2(
      {required String name,
      required TextEditingController controller,
      // double height = 50.0,
      TextInputType keyboardType = TextInputType.text,
      bool isEdit = false,
      String? hintTextString,
      String? imp,
      int? maxInput,
      bool isTextBold = true,
      String? Function(String?)? validator}) {
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
        TextFormField(
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
          // readOnly: isEdit || !_searched,
          maxLength: maxInput,
          buildCounter: (context, {int? currentLength, int? maxLength, bool? isFocused}) => null,
          validator: validator,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget nagarDropdown() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          if (![6, 7].contains(_selectedKaryakramLevelId) && _linkedMahaanagar != null)
            _buildDropdownField(
              ignoring: _isViewOnly ? _isViewOnly : (baithakId != null && baithakId != 0) && [2, 3, 4].contains(_selectedKaryakramLevelId),
              label: Statics.getLabel('Mahaanagar'),
              value: _linkedMahaanagarValue,
              items: _linkedMahaanagar!
                  .map((bg) => DropdownMenuItem(
                        value: bg.geoUnitID.toString(),
                        child: Text(bg.name!),
                      ))
                  .toList(),
              onChanged: (value) async {
                final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                setState(() {
                  _linkedMahaanagarValue = value;
                  _linkedVibhaagValue = null;
                  _selctedLevel = Statics.getLabel('Mahaanagar');
                  _selctedLevelName = selectedItem.name ?? "";
                  _selectedGeoUnitIdForCreat = value;
                  _selctedLevelList.add(selectedItem.geoUnitID);
                  // _linkedMahaanagarName = selectedItem.name ?? "";
                  // _resetLinkedValues();
                });
                populatelinkedVibhaagDropdown(value!);
                populatelinkedBhaagDropdown("");
              },
              isDisabled: false,
            ),
          if (_linkedVibhaag != null)
            _buildDropdownField(
              ignoring: _isViewOnly ? _isViewOnly : (baithakId != null && baithakId != 0) && [2, 3, 4].contains(_selectedKaryakramLevelId),
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
                  _linkedVibhaagValue = value;
                  _selctedLevel = Statics.getLabel('Vibhaag');
                  _selctedLevelName = selectedItem.name ?? "";
                  _selectedGeoUnitIdForCreat = value;
                  _selctedLevelList.add(selectedItem.geoUnitID);
                  // _linkedVibhaagName = selectedItem.name ?? "";
                });
                populatelinkedBhaagDropdown(value!);
              },
              isDisabled: false,
            ),
          if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty)
            _buildDropdownField(
              ignoring: _isViewOnly ? _isViewOnly : (baithakId != null && baithakId != 0) && [2, 3, 4].contains(_selectedKaryakramLevelId),
              label: Statics.getLabel('Bhaag'),
              value: _linkedbhaagValue,
              items: _linkedbhaag!
                  .map((bg) => DropdownMenuItem(
                        value: bg.geoUnitID.toString(),
                        child: Text(bg.name!),
                      ))
                  .toList(),
              onChanged: (value) {
                final selectedItem = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                setState(() {
                  _linkedbhaagValue = value;
                  _selctedLevel = Statics.getLabel('Bhaag');
                  _selctedLevelName = selectedItem.name ?? "";
                  _linkedbhaagName = selectedItem.name ?? "";
                  _selectedGeoUnitIdForCreat = value;
                  _selctedLevelList.add(selectedItem.geoUnitID);
                  populatelinkedShaharDropdown(value!);
                  populatelinkedNagarDropdown(value);
                });
              },
              isDisabled: false,
            ),
          if ([5, 6, 7].contains(_selectedKaryakramLevelId) && _linkednagar != null && _linkednagar!.isNotEmpty)
            _buildDropdownField(
              label: Statics.getLabel('Nagar'),
              value: _linkednagarValue,
              items: _linkednagar!
                  .map((bg) => DropdownMenuItem(
                        value: bg.geoUnitID.toString(),
                        child: Text(bg.name!),
                      ))
                  .toList(),
              onChanged: (value) {
                final selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                setState(() {
                  _linkednagarValue = value;
                  _selectedGeoUnitIdForCreat = value;
                  _selctedLevel = Statics.getLabel('Nagar');
                  _selctedLevelName = selectedItem.name ?? "";
                  _linkednagarName = selectedItem.name ?? "";
                  _selctedLevelList.add(selectedItem.geoUnitID);
                  populatelinkedUpnagarDropdown(value);
                  populatelinkedMandalDropdown('Nagar', value);
                  // populatelinkedVastiDropdown('Nagar', value);
                });
              },
              isDisabled: false,
            ),
          if ([6, 7].contains(_selectedKaryakramLevelId) && _linkedupnagar != null && _linkedupnagar!.isNotEmpty)
            _buildDropdownField(
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
                  _selectedGeoUnitIdForCreat = value;
                  _selctedLevel = Statics.getLabel('upnagarUpkhanda');
                  _selctedLevelName = selectedItem.name ?? "";
                  _linkedupnagarName = selectedItem.name ?? "";
                  _selctedLevelList.add(selectedItem.geoUnitID);
                  populatelinkedMandalDropdown('Upnagar', value);
                  // populatelinkedVastiDropdown('Upnagar', value);
                });
              },
              isDisabled: false,
            ),
          if ([7].contains(_selectedKaryakramLevelId) && _linkedmandal != null && _linkedmandal!.isNotEmpty)
            _buildDropdownField(
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
                  _selectedGeoUnitIdForCreat = value.toString();
                  _selctedLevel = Statics.getLabel('Mandal');
                  _selctedLevelName = selectedItem.name ?? "";
                  _linkedmandalName = selectedItem.name ?? "";
                  _selctedLevelList.add(selectedItem.geoUnitID);
                  // populatelinkedGraamDropdown(value);
                });
              },
              isDisabled: false,
            ),
          // if (_linkedgraam != null && _linkedgraam!.isNotEmpty)
          //   _buildDropdownField(
          //     label: Statics.getLabel('Graam'),
          //     value: _linkedgraamValue,
          //     items: _linkedgraam!
          //         .map((bg) => DropdownMenuItem(
          //               value: bg.geoUnitID.toString(),
          //               child: Text(bg.name!),
          //             ))
          //         .toList(),
          //     onChanged: (value) {
          //       final selectedItem = _linkedgraam!.firstWhere((bg) => bg.geoUnitID.toString() == value);
          //       setState(() {
          //         _linkedgraamValue = value;
          //         _selectedGeoUnitId = value.toString();
          //         _selctedLevel = 'Graam';
          //         _selctedLevelName = selectedItem.name ?? "";
          //         _linkedgraamName = selectedItem.name ?? "";
          //       });
          //     },
          //     isDisabled: false,
          //   ),
          // if (_linkedvasti != null && _linkedvasti!.isNotEmpty)
          //   _buildDropdownField(
          //     label: Statics.getLabel('Vasti'),
          //     value: _linkedvastiValue,
          //     items: _linkedvasti!
          //         .map((bg) => DropdownMenuItem(
          //               value: bg.geoUnitID.toString(),
          //               child: Text(bg.name!),
          //             ))
          //         .toList(),
          //     onChanged: (value) {
          //       final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
          //       setState(() {
          //         _linkedvastiValue = value;
          //         _selectedGeoUnitId = value.toString();
          //         _selctedLevel = 'Vasti';
          //         _selctedLevelName = selectedItem.name ?? "";
          //         _linkedvastiName = selectedItem.name ?? "";
          //       });
          //     },
          //     isDisabled: false,
          //   ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    bool? ignoring,
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>>? items,
    required ValueChanged<String?>? onChanged,
    required bool isDisabled,
    void Function()? onTap,
  }) {
    return IgnorePointer(
      ignoring: ignoring ?? _isViewOnly,
      child: DropdownButtonFormField(
        decoration: InputDecoration(labelText: label),
        isExpanded: true,
        value: value == "" ? null : value,
        items: items,
        onTap: onTap,
        onChanged: onChanged,
      ),
    );
  }
}
