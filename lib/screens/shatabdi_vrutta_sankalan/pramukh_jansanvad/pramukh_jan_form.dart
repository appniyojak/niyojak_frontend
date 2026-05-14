import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../models/response_model/sadbhav_baithak_resp_model.dart';
import '../../../models/response_model/sadbhav_baithak_vrutta_resp_model.dart';
import '../../../models/response_model/vijayaDashamiInitModel.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';
import 'add_sajjan_anya_pramukh_jan_screen.dart';
import 'all_sanvaad_screen.dart';
import 'karyakram_creation_screen.dart';

class PramukhJansanvadFormTab extends StatefulWidget {
  // static const String routeName = '/pramukh_jansanvad-form-view';

  const PramukhJansanvadFormTab({super.key});

  @override
  State<PramukhJansanvadFormTab> createState() => _PramukhJansanvadFormTabState();
}

class _PramukhJansanvadFormTabState extends State<PramukhJansanvadFormTab> with AutomaticKeepAliveClientMixin {
// This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<FormState> _formKey = GlobalKey();
  SadbhavBaithakVruttaRespModel? vruttaData;

  bool _searched = false;
  bool _isExpanded = true;

  var kendraController = ExpansionTileController();
  var baithakController = ExpansionTileController();

  TextEditingController dateController = TextEditingController();
  TextEditingController txtGivenGroupNameController = TextEditingController();
  TextEditingController txtPramukhNameController = TextEditingController();
  TextEditingController txtPramukhMobileController = TextEditingController();
  TextEditingController txtCentreNameController = TextEditingController();

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
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId;
  List<String> _selectedNagarIds = [];

  // int? baithakId;
  bool _isViewOnly = false;
  int? _selectedKaryakramLevelId;

  // int? _selectedKendraId;

  List<Nagardata> nagarList = [];
  List<SadbhavKendraMasterdata> kendraList = [];
  List<Bhaitakdata> kendraBaithakList = [];
  SadbhavKendraMasterdata? selectedKendra;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => populateDropdown());
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getKendraListData());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
      _selectedKaryakramLevelId = dm.levelID == 7
          ? 1
          : dm.levelID == 6
              ? 5
              : dm.levelID == 13
                  ? 6
                  : dm.levelID == 4
                      ? 7
                      : null;
      karyakramLevelsList = getFilteredKaryakramLevels(dm.levelID ?? 0);
    });
    await populateDropdown();
    getKendraListData();
  }

  Future<void> populateAllDropdowns(int level, DropDownModel dm) async {
    setState(() {
      _selectedGeoUnitId = _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
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
    await populatelinkedNagarDropdown(_linkedbhaagValue);
    _linkednagarValue = (level == 6 ? (dm.geoUnitID ?? 0).toString() : selection.nagar) ?? _linkednagarValue;
    if (level == 6) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.nagar).toString();
      _selctedLevel = 'Nagar';
    }

    // Step 5: Upnagar (conditional)
    await populatelinkedUpnagarDropdown(_linkednagarValue);
    if (selection.upnagar != null && selection.upnagar!.isNotEmpty) {
      _linkedupnagarValue = (level == 13 ? (dm.geoUnitID ?? 0).toString() : selection.upnagar) ?? _linkedupnagarValue;
      if (level == 13) {
        _selectedGeoUnitId = (dm.geoUnitID ?? selection.upnagar).toString();
        _selctedLevel = 'Upnagar';
      }
    }

    // Step 6: Mandal
    await populatelinkedMandalDropdown(
      selection.upnagar != null ? "Nagar" : "Upnagar",
      selection.upnagar != null ? _linkednagarValue : _linkedupnagarValue,
    );
    _linkedmandalValue = (level == 4 ? (dm.geoUnitID ?? 0).toString() : selection.mandal) ?? _linkedmandalValue;
    if (level == 4) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.mandal).toString();
      _selctedLevel = 'Mandal';
    }
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

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  //   _isViewOnly = args?["viewOnly"] ?? false;
  //   baithakId = args?["id"] ?? 0;
  //   // getData();
  //   // viewType = args!.viewType;
  // }

  getKendraListData() async {
    var formData = {
      "levelid": _selectedKaryakramLevelId ?? 0,
      "geounitid": int.tryParse(_selectedGeoUnitId ?? "0") ?? 0,
      "appuserid": int.parse(Statics.userDetails['userID']),
    };

    final _baithak = await Statics.GetPramukhJanListData(context: context, inputJson: formData, showLoader: true);
    print("getData api HiTttttt >>>>>>>>>>>>>>>>>");

    kendraList = _baithak ?? [];
    kendraBaithakList = [];
    selectedKendra = null;

    setState(() {
      _searched = true;
      _isExpanded = false;
    });
  }

  getBaithakListData(int kendraId) async {
    var formData = {
      "ids": selectedKendra?.pkid ?? kendraId,
      "GeoUnitID": int.tryParse(_selectedGeoUnitId ?? "0") ?? 0,
      "AppUserID": int.parse(Statics.userDetails['userID']),
    };

    final _baithak = await Statics.GetPramukhJanListByIdData(context: context, inputJson: formData, showLoader: true);
    print("getData api HiTttttt >>>>>>>>>>>>>>>>>");

    kendraBaithakList = _baithak?.bhaitakdata ?? [];
    // selectedKendra = _baithak?.masterdata?.first ?? selectedKendra ?? null;

    setState(() {
      _searched = true;
      _isExpanded = false;
    });
  }

  createSadbhavBaithakFun() async {
    Map<String, dynamic> formData = {
      "id": selectedKendra?.pkid ?? 0,
      "date": dateController.text,
      "appuserid": int.parse(Statics.userDetails['userID']),
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    final _res = await Statics.CreatePramukhJanData(context: context, inputJson: formData, showLoader: true);
    if (_res) {
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
      Navigator.pop(context);
      await getBaithakListData(selectedKendra?.pkid ?? 0);
    }
    // getFormData();
  }

  String? selectedSajjanshaktiItemsIds;
  String? selectedAnyaprabhaviItemsIds;
  List<Vastisarsajjanshakti> selectedSajjanshaktiItems = [];
  List<Vastisanyaprabhavi> selectedAnyaprabhaviItems = [];

  _getForm(pkId) async {
    var formData = {
      "ids": pkId,
      "AppUserID": int.parse(Statics.userDetails['userID']),
    };
    vruttaData = await Statics.GetPramukhJanVruttaData(context: context, inputJson: formData);
    setState(() {});
    if (vruttaData != null) {
      selectedSajjanshaktiItemsIds = vruttaData?.vastisarsajjanshakti?.where((e) => e.isVisheshdefault == 1).map((e) => e.pkid).join(',');
      selectedSajjanshaktiItems = vruttaData?.vastisarsajjanshakti?.where((e) => e.isVisheshdefault == 1).toList() ?? [];
      selectedAnyaprabhaviItemsIds = vruttaData?.vastisanyaprabhavi?.where((e) => e.isVisheshdefault == 1).map((e) => e.pkId).join(',');
      selectedAnyaprabhaviItems = vruttaData?.vastisanyaprabhavi?.where((e) => e.isVisheshdefault == 1).toList() ?? [];

      // vaktaList = vruttaData?.namesList ?? [];
      // _selectedGeoUnitId = vruttaData?.geounitid.toString();
    }
  }

  Future<void> submitForm(pkId, ct, {bool fromPopup = false, bool showLoader = true}) async {
    int givenCount = int.tryParse(txtGivenGroupNameController.text) ?? 0;

    int presentCount = selectedSajjanshaktiItems.length + selectedAnyaprabhaviItems.length;

    if (givenCount > presentCount) {
      Statics.showToast(Statics.getLabel("jnyatiValidationMessage"));
      return;
    }

    if ((selectedSajjanshaktiItemsIds == null || selectedSajjanshaktiItemsIds!.isEmpty) &&
        (selectedAnyaprabhaviItemsIds == null || selectedAnyaprabhaviItemsIds!.isEmpty) &&
        (txtGivenGroupNameController.text == "0" || txtGivenGroupNameController.text.isEmpty)) {
      if (!fromPopup) Statics.showToast(Statics.getLabel("submitValidation"));
      return;
    }

    Map<String, dynamic> formData = {
      "pkid": pkId,
      "date": dateController.text.trim(),
      "sajjanids": selectedSajjanshaktiItemsIds ?? "",
      "annyaids": selectedAnyaprabhaviItemsIds ?? "",
      "peoplecount": 0 ?? int.tryParse(txtGivenGroupNameController.text) ?? 0,
      "geounitid": _selectedGeoUnitId,
      "appuserid": int.parse(Statics.userDetails['userID']),
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");

    final _data = await Statics.SavePramukhJanVruttaData(context: context, inputJson: formData, showLoader: showLoader);
    if (_data != null) {
      Navigator.pop(ct);
      setState(() {
        kendraBaithakList = _data;
      });
    }
  }

  clearForm() async {
    setState(() {
      _searched = false;
      _selectedGeoUnitId = null;
      nagarList = [];
      kendraBaithakList = [];
      selectedKendra = null;
      _selectedKaryakramLevelId = null;
      dateController.clear();
      txtGivenGroupNameController.clear();
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
      _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
    });
    // clearForm();
    await initData();
    await getKendraListData();
  }

  //////////////////////////////////////////////////////////////////////////////////////

  Future<void> populateDropdown({bool fromClear = false}) async {
    setState(() {
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
      _linkedMahaanagar = _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedupnagar = _linkedmandal = null;
      _selctedLevelName = _selectedGeoUnitId = null;
      nagarList = [];
      _selctedLevel = "praant";
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');

    if (fromClear || userLevelId == null || ddm == null) {
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
    super.build(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "${Statics.getLabel('selectKaryakramLevel')}",
      //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => Navigator.of(context).pushNamed(SadbhavCenterCreationScreen.routeName),
      //   backgroundColor: Colors.green.shade400,
      //   label: Icon(Icons.add),
      // ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 12),
                stharDropdown(),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Text(
                //       "*Dummy Data",
                //       style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                //     )
                //   ],
                // ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: OutlinedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () => Navigator.of(context).pushNamed(AllSanvaadScreen.routeName),
                      child: Text(Statics.getLabel("allSanvaadData")),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: BorderSide(color: Colors.purple, width: 0.7)),
                      onPressed: () => Navigator.of(context).pushNamed(KaryakramCreationScreen.routeName).then(
                            (value) => getKendraListData(),
                          ),
                      child: Text("+  " + Statics.getLabel("addKaryakram")),
                    )
                  ],
                ),
                SizedBox(height: 24),
                myAreaReport(),
                SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "* " + Statics.getLabel('Note') + " : ",
                      style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600, decoration: TextDecoration.underline, decorationColor: Colors.red, fontStyle: FontStyle.italic),
                    ),
                    Expanded(
                      child: Text(
                        Statics.getLabel('sanvaadTip'),
                        style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                otherAreaReport(),
                SizedBox(height: 90),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget stharDropdown() {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 0.7, color: Colors.grey.shade700),
      ),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            backgroundColor: Colors.transparent,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  "${Statics.getLabel('selectStar')}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              );
            },
            body: Container(
              margin: EdgeInsets.all(16),
              child: Column(
                children: [
                  buildDropdownField(
                    label: Statics.getLabel('selectStar'),
                    value: _selectedKaryakramLevelId == null ? null : _selectedKaryakramLevelId.toString(),
                    items: karyakramLevelsList
                        .map((bg) => DropdownMenuItem(
                              value: bg.values.first.toString(),
                              child: Text(bg.keys.first),
                            ))
                        .toList(),
                    // onTap: dateController.text.isEmpty ? null : () {},
                    onChanged: (value) async {
                      await populateDropdown();
                      _searched = false;
                      // dateController.clear();
                      setState(() => _selectedKaryakramLevelId = int.tryParse(value.toString()));
                      nagarList = [];
                      // print("baithakId >>>>>>>>>>>>>>>> ${baithakId}");
                      await getKendraListData();
                      await populateDropdown();
                    },
                  ),
                  SizedBox(height: 18),
                  nagarDropdown(),
                  SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_selectedGeoUnitId != null && _selectedGeoUnitId!.isNotEmpty)
                        MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          padding: EdgeInsets.symmetric(
                            horizontal: 35,
                            vertical: 5,
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                          onPressed: getKendraListData,
                          child: Text(
                            Statics.getLabel('search'),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      MaterialButton(onPressed: clearForm, child: Text(Statics.getLabel('clear'))),
                    ],
                  ),
                ],
              ),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }

  Widget myAreaReport() {
    return ExpansionTile(
      initiallyExpanded: true,
      controller: kendraController,
      onExpansionChanged: (value) {
        print("Expanded: $value");
      },
      backgroundColor: Colors.purple.shade50,
      collapsedBackgroundColor: Colors.purple.shade50,
      collapsedTextColor: Colors.blueAccent.shade700,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        Statics.getLabel('sanvaadData'),
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.45),
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: false,
                headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                columnSpacing: 16,
                horizontalMargin: 12,
                border: TableBorder.all(color: Colors.black26),
                columns: [
                  DataColumn(
                    label: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      constraints: const BoxConstraints(minWidth: 30, maxWidth: 130),
                      child: Text(
                        Statics.getLabel('serialNo'),
                        softWrap: true,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      constraints: const BoxConstraints(minWidth: 30, maxWidth: 130),
                      child: Text(
                        Statics.getLabel('SelectLevelName'),
                        softWrap: true,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      constraints: const BoxConstraints(minWidth: 30, maxWidth: 130),
                      child: Text(
                        Statics.getLabel('sanvaadKaryakram'),
                        softWrap: true,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(label: SizedBox()),
                ],
                rows: kendraList.asMap().entries.map(
                  (e) {
                    final index = e.key;
                    final data = e.value;
                    bool isSelected = selectedKendra == data;
                    return DataRow(
                      selected: isSelected,
                      color: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (isSelected) {
                            return Colors.yellow.shade100;
                          }
                          return null;
                        },
                      ),
                      onSelectChanged: (value) async {
                        if (isSelected) {
                          setState(() {
                            selectedKendra = null;
                            kendraBaithakList = [];
                          });
                          return;
                        }
                        if (mounted) kendraController.collapse();
                        if (mounted) baithakController.expand();
                        setState(() {
                          selectedKendra = data;
                        });
                        await getBaithakListData(data.pkid ?? 0);
                      },
                      cells: [
                        DataCell(Center(child: Text((index + 1).toString()))),
                        DataCell(Center(child: Text(Statics.getLabel(data.stharname ?? "--", returnKey: true)))),
                        DataCell(Center(child: Text(data.geoname ?? data.kendraname ?? "--"))),
                        DataCell(PopupMenuButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          onSelected: (value) async {
                            if (value == "Delete") {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(Statics.getLabel('AskConfirmation')),
                                  content: Text(Statics.getLabel('AreyouSureYouWantToDeleteKendra')),
                                  actions: <Widget>[
                                    MaterialButton(
                                      child: Text(Statics.getLabel('ConfirmationYes')),
                                      onPressed: () async {
                                        Navigator.of(ctx).pop();
                                        var _res = await Statics.DeletePramukhJanData(context: context, inputJson: {"id": data.pkid, "type": "kendra"});
                                        if (_res) {
                                          Statics.showToast(Statics.getLabel('KendraDeletedSuccessfully'));
                                          kendraList.remove(data);
                                          setState(() {});
                                        } else {
                                          Statics.showToast(Statics.getLabel('errorOccurred'));
                                        }
                                        clearForm();
                                        if (mounted) kendraController.expand();
                                        if (mounted) baithakController.collapse();
                                        // await getKendraListData();
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
                            } else if (value == "EditMenu") {
                              print("EDIT >>>>>>>>>>>>>>");
                              // await _getForm(2);
                              // showBaithakDetailPopup();
                              Navigator.of(context).pushNamed(KaryakramCreationScreen.routeName,
                                  arguments: {"id": data.pkid, "levelId": data.shatapdistharlevelid, "viewOnly": false}).then((value) => getKendraListData());
                              // } else if (value == "baithak") {
                              //   setState(() {
                              //     selectedKendra = data;
                              //   });
                              //   await getBaithakListData(data.pkid ?? 0);
                            } else {
                              Navigator.of(context).pushNamed(KaryakramCreationScreen.routeName, arguments: {"id": data.pkid, "viewOnly": true}); //.then((value) => getKendraListData());
                              // Navigator.of(context).pushNamed(SadbhavCenterListScreen.routeName); //, arguments: {"id": data.pkid, "viewOnly": true});
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              // Statics.MenuItem(Statics.getLabel('addinSoochi'), Icons.list, 'AddinSoochi'),
                              // if (showEditMenu == true)
                              // Statics.MenuItem(Statics.getLabel('EditMenu'), FontAwesomeIcons.edit, 'EditMenu'),
                              Statics.MenuItem(Statics.getLabel('ViewMenu'), FontAwesomeIcons.eye, 'ViewMenu'),
                              // if (showDeleteMenu == true)
                              Statics.MenuItem(Statics.getLabel('Delete'), Icons.delete, 'Delete'),
                              // Statics.MenuItem(Statics.getLabel('baithak'), Icons.edit_note_rounded, 'baithak'),
                            ].map((Statics.MenuItem menuItem) {
                              return PopupMenuItem(
                                value: menuItem.menuKey,
                                child: ListTile(
                                  // tileColor: Colors.white,
                                  leading: Icon(
                                    menuItem.iconVal,
                                    color: Colors.purple,
                                  ),
                                  title: Text(menuItem.menuVal),
                                ),
                              );
                            }).toList();
                          },
                        )),
                        // DataCell(OutlinedButton(
                        //   style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: BorderSide(color: Colors.purple, width: 0.7)),
                        //   onPressed: () {
                        //     // sadbhavProvider.updateSadbhavVal(SadbhavCenter(centername: "पार्ले", geounitname: "पार्ले", sthartype: Statics.getLabel("railwayStation")));
                        //   },
                        //   child: Text("+  " + Statics.getLabel("baithak")),
                        // )),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget otherAreaReport() {
    final headers = ["serialNo", "sanvaadVrutta", "date2", "anya_upastiti_male", "anya_upastiti_matrushakti", "Total", ""];

    return ExpansionTile(
      // initiallyExpanded: true,
      controller: baithakController,
      backgroundColor: Colors.purple.shade50,
      collapsedBackgroundColor: Colors.purple.shade50,
      collapsedTextColor: Colors.blueAccent.shade700,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      childrenPadding: EdgeInsets.only(left: 12, right: 12, bottom: 10, top: 16),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      title: Text(
        Statics.getLabel('sanvaadKaryakramData'),
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${Statics.getLabel('LevelName')} :  ${selectedKendra?.stharname ?? "--"}",
                    style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${Statics.getLabel('sanvaadKaryakram')}  : ${selectedKendra?.kendraname ?? selectedKendra?.geoname ?? "--"}",
                    style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // IconButton(
            //   onPressed: () => setState(() => sadbhavProvider.setSadbhav = null),
            //   icon: Icon(Icons.cancel, color: Colors.red),
            // )
          ],
        ),
        SizedBox(height: 12),
        if (selectedKendra != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: BorderSide(color: Colors.purple, width: 0.7)),
                onPressed: () {
                  dateController.clear();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, set) {
                        return AlertDialog(
                          insetPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 24),
                          title: Text(Statics.getLabel("addDate")),
                          content: SizedBox(
                            width: double.infinity,
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
                                  set(() {});
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
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // if ((_linkedgraamValue != "" && _linkedgraamValue != null) || (_linkedvastiValue != "" && _linkedvastiValue != null))
                                MaterialButton(
                                  minWidth: MediaQuery.sizeOf(context).width * 0.4,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  disabledColor: Colors.grey,
                                  textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                                  onPressed: dateController.text.trim().isEmpty ? null : createSadbhavBaithakFun,
                                  child: Text(
                                    Statics.getLabel('Submit'),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                MaterialButton(onPressed: () => Navigator.pop(context), child: Text(Statics.getLabel('clear'))),
                              ],
                            ),
                          ],
                        );
                      });
                    },
                  );
                },
                child: Text("+  " + Statics.getLabel("addDate")),
              ),
            ],
          ),
        SizedBox(height: 12),
        if (kendraBaithakList.isNotEmpty && selectedKendra != null)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
              columnSpacing: 18,
              horizontalMargin: 12,
              border: TableBorder.all(color: Colors.black26),
              columns: headers
                  .map((header) => DataColumn(
                        label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          constraints: const BoxConstraints(minWidth: 30, maxWidth: 130),
                          child: Text(
                            Statics.getLabel(header),
                            softWrap: true,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ))
                  .toList(),
              rows: kendraBaithakList.asMap().entries.map((e) {
                final index = e.key;
                final data = e.value;
                return DataRow(
                  cells: [
                    DataCell(Center(child: Text((index + 1).toString()))),
                    DataCell(Center(
                        child: IconButton(
                            onPressed: () async {
                              DateTime programDate = DateFormat("dd/MM/yyyy").parse(data.programdate.toString());
                              DateTime now = DateTime.now();
                              DateTime today = DateTime(now.year, now.month, now.day);

                              bool enableForm = today.isAtSameMomentAs(programDate) || today.isAfter(programDate);

                              if (!enableForm) {
                                Statics.showToast(Statics.getLabel("enableVruttaValidationMessage").replaceAll("{date}", data.programdate.toString()));
                                return;
                              }

                              print("EDIT >>>>>>>>>>>>>>");
                              await _getForm(data.pkid);
                              showBaithakDetailPopup(data);
                            },
                            icon: Icon(FontAwesomeIcons.edit)))),
                    DataCell(Center(child: Text(data.programdate ?? "--"))),
                    DataCell(Center(child: Text((data.male ?? 0).toString()))),
                    DataCell(Center(child: Text((data.female ?? 0).toString()))),
                    DataCell(Center(child: Text((data.totmalefemale ?? 0).toString()))),
                    // DataCell(Center(child: Text((data.peoplecount ?? 0).toString()))),
                    DataCell(PopupMenuButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onSelected: (value) async {
                        if (value == "Delete") {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(Statics.getLabel('AskConfirmation')),
                              content: Text(Statics.getLabel('AreyouSureYouWantToDeleteBaithak')),
                              actions: <Widget>[
                                MaterialButton(
                                  child: Text(Statics.getLabel('ConfirmationYes')),
                                  onPressed: () async {
                                    Navigator.of(ctx).pop();
                                    var _res = await Statics.DeletePramukhJanData(context: context, inputJson: {"id": data.pkid, "type": "vrutta"});
                                    if (_res) {
                                      Statics.showToast(Statics.getLabel('BaithakDeletedSuccessfully'));
                                      kendraBaithakList.remove(data);
                                      setState(() {});
                                    } else {
                                      Statics.showToast(Statics.getLabel('errorOccurred'));
                                    }
                                    // clearForm();
                                    // await getBaithakListData(selectedKendra?.pkid ?? 0);
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
                        } else if (value == "EditMenu") {
                          // Navigator.of(context).pushNamed(SadbhavCenterCreationScreen.routeName, arguments: {"id": 0, "viewOnly": true});
                          // } else if (value == "baithak") {
                          // sadbhavProvider.updateSadbhavVal(SadbhavCenter(centername: "नवीन केंद्र", geounitname: "कोळीवाडा", sthartype: Statics.getLabel("railwayStation")));

                          // Navigator.of(context).pushNamed(SadbhavFormTab.routeName); //, arguments: {"id": data.pkid});
                        } else {
                          showBaithakDetailPopup(data, viewOnly: true);
                          // Navigator.of(context).pushNamed(SadbhavCenterCreationScreen.routeName, arguments: {"id": 0, "viewOnly": true});
                          // Navigator.of(context).pushNamed(SadbhavCenterListScreen.routeName); //, arguments: {"id": data.pkid, "viewOnly": true});
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          // Statics.MenuItem(Statics.getLabel('addinSoochi'), Icons.list, 'AddinSoochi'),
                          // if (showEditMenu == true)
                          // Statics.MenuItem(Statics.getLabel('baithakVrutta'), FontAwesomeIcons.edit, 'EditMenu'),
                          Statics.MenuItem(Statics.getLabel('ViewMenu'), FontAwesomeIcons.eye, 'ViewMenu'),
                          // if (showDeleteMenu == true)
                          Statics.MenuItem(Statics.getLabel('Delete'), Icons.delete, 'Delete'),
                          // Statics.MenuItem(Statics.getLabel('baithak'), Icons.edit_note_rounded, 'baithak'),
                        ].map((Statics.MenuItem menuItem) {
                          return PopupMenuItem(
                            value: menuItem.menuKey,
                            child: ListTile(
                              // tileColor: Colors.white,
                              leading: Icon(
                                menuItem.iconVal,
                                color: Colors.purple,
                              ),
                              title: Text(menuItem.menuVal),
                            ),
                          );
                        }).toList();
                      },
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );

    // return ExpansionPanelList(
    //   expansionCallback: (panelIndex, isExpanded) => setState(() => _isExpanded = !_isExpanded),
    //   children: [
    //     ExpansionPanel(
    //       isExpanded: _isExpanded,
    //       headerBuilder: (BuildContext context, bool isExpanded) {
    //         return ListTile(
    //           title: Text(Statics.getLabel('MyGeoUnitDetails')),
    //         );
    //       },
    //       body: otherAreaExpandableTable(),
    //     ),
    //   ],
    // );
  }

  void showBaithakDetailPopup(Bhaitakdata baithak, {bool viewOnly = false}) {
    txtGivenGroupNameController.text = (vruttaData?.peoplecount ?? 0).toString();
    dateController.text = (baithak.programdate ?? "").toString();
    final sarsajjanshaktiList = (vruttaData?.vastisarsajjanshakti ?? []).toList();
    final sanyaprabhaviList = (vruttaData?.vastisanyaprabhavi ?? []).toList();

    showDialog(
      context: context,
      useSafeArea: true,
      builder: (ct) => StatefulBuilder(
        builder: (ctx, set) => Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                        Statics.getLabel("vruttaTitle"),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(ct),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
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
                              onTap: viewOnly
                                  ? null
                                  : () async {
                                      DateTime? date = await showDatePicker(
                                        context: context,
                                        initialDate: dateController.text.isEmpty ? DateTime.now() : DateFormat("dd/MM/yyyy").parse(dateController.text),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (date != null) {
                                        dateController.text = DateFormat("dd/MM/yyyy").format(date);
                                        set(() {});
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
                      // IgnorePointer(ignoring: viewOnly, child: customTextFields(title: Statics.getLabel("sadbhavReportTable2") + ": ", controller: txtGivenGroupNameController)),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              if (!viewOnly)
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
                                    onPressed: () async {
                                      await submitForm(vruttaData?.pkid, context, fromPopup: true);
                                      Navigator.of(context).pushNamed(
                                        AddSajjanAnyaPrakukhJanScreen.routeName,
                                        arguments: {'geoUnitId': (vruttaData?.geounitid ?? 0).toString()},
                                      ).then(
                                        (value) async {
                                          await _getForm(baithak.pkid);
                                          setState(() {});
                                        },
                                      );
                                    },
                                    child: Text(
                                      Statics.getLabel('addNewSajjAnyaBtn'),
                                      style: const TextStyle(color: Colors.purpleAccent),
                                    ),
                                  ),
                                ),

                              /// Content
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Statics.getLabel('SajjanShakti'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                              Container(
                                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.27),
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
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(Statics.getLabel("shreni", returnKey: true), style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                      ...sarsajjanshaktiList.map((item) {
                                        return TableRow(
                                          children: [
                                            IgnorePointer(
                                              ignoring: viewOnly,
                                              child: Center(
                                                  child: Checkbox(
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                value: selectedSajjanshaktiItems.any((x) => x.pkid == item.pkid),
                                                onChanged: (val) {
                                                  set(() {
                                                    if (val == true) {
                                                      selectedSajjanshaktiItems.add(item);
                                                    } else {
                                                      selectedSajjanshaktiItems.removeWhere((x) => x.pkid == item.pkid);
                                                    }
                                                  });
                                                  selectedSajjanshaktiItemsIds = selectedSajjanshaktiItems.map((e) => e.pkid.toString()).join(",");
                                                  // String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
                                                  log(selectedSajjanshaktiItemsIds.toString());
                                                  log("-----------------------------");
                                                  // log(anyaIds);

                                                  // onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                                                  set(() {});
                                                },
                                              )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(item.name ?? "Unknown"),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(item.shreneedhiName ?? "----"),
                                            ),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              /// Anya Prabhavi Lok
                              Row(
                                children: [
                                  Text(
                                    Statics.getLabel('anyaPrabhaviLok'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                              Container(
                                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.27),
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
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(Statics.getLabel("shreni", returnKey: true), style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                      ...sanyaprabhaviList.map((item) {
                                        return TableRow(
                                          children: [
                                            IgnorePointer(
                                              ignoring: viewOnly,
                                              child: Center(
                                                  child: Checkbox(
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                value: selectedAnyaprabhaviItems.any((x) => x.pkId == item.pkId),
                                                onChanged: (val) {
                                                  set(() {
                                                    if (val == true) {
                                                      selectedAnyaprabhaviItems.add(item);
                                                    } else {
                                                      selectedAnyaprabhaviItems.removeWhere((x) => x.pkId == item.pkId);
                                                    }
                                                  });
                                                  // String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                                                  selectedAnyaprabhaviItemsIds = selectedAnyaprabhaviItems.map((e) => e.pkId.toString()).join(",");

                                                  // onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                                                  // log(sajIds);
                                                  log(selectedAnyaprabhaviItemsIds.toString());
                                                  set(() {});
                                                },
                                              )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(item.name ?? "Unknown"),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(item.shreneeName ?? "----"),
                                            ),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 21),
                      if (!viewOnly)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              minWidth: MediaQuery.sizeOf(context).width * 0.4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              color: Theme.of(context).primaryColor,
                              textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                              // onPressed: () {
                              //   Statics.showToast(Statics.getLabel("workInProgress"));
                              // },
                              onPressed: () async {
                                submitForm(vruttaData?.pkid, context);
                              },
                              child: Text(
                                Statics.getLabel('Submit'),
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            // if (_isEditing)
                            MaterialButton(
                              minWidth: MediaQuery.sizeOf(context).width * 0.35,
                              onPressed: () async {
                                // setState(() {
                                //   _isEditing = false;
                                //   _isEditingForPramukh = false;
                                //   dateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
                                //   // samparkitGhareController.clear();
                                //   vitritKarpatrakController.clear();
                                //   pustakVikriController.clear();
                                //   createdUserId = null;
                                //   selectedSajjanshaktiItems = [];
                                //   selectedAnyaprabhaviItems = [];
                                //   selectedVisitedSwayamsevak = [];
                                //   // _selctedLevelNameList = [];
                                // });
                                Navigator.pop(ct);
                                // await _getSwList();
                                // await populateDropdown(isClear: true);
                              },
                              child: Text(
                                Statics.getLabel('clear'),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  customTextFields({required String title, bool isRequired = false, required TextEditingController controller, String? hintText, bool readOnly = false, void Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                if (isRequired)
                  Text(
                    " *",
                    style: TextStyle(fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                // TextSpan(
                //  text: " : ",
                //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          ),
          // Text(
          //   " : ",
          //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          // ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controller,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
              style: TextStyle(fontSize: 14),
              autofocus: false,
              onTap: onTap,
              readOnly: readOnly,
              enabled: !readOnly,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  // isDense: true,
                  hintText: hintText ?? "0",
                  contentPadding: EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
            ),
          ),
        ],
      ),
    );
  }

  // UI Helper for Header Cells
  ExpandableTableCell _buildHeaderCell(String text) {
    return ExpandableTableCell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(color: Colors.purple.shade100, border: Border.all(color: Colors.grey.shade700, width: 0.7)),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // UI Helper for Body Cells
  ExpandableTableCell _buildCell(String text, {Color? color, bool showBorder = true, Widget? child, FontWeight? fontWeight}) {
    return ExpandableTableCell(
      builder: (context, details) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(color: color ?? Colors.white, border: showBorder ? Border.all(color: Colors.grey.shade700, width: 0.7) : null),
        alignment: child != null ? null : Alignment.center,
        child: child ??
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (details.row?.children != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedRotation(
                      duration: const Duration(milliseconds: 500),
                      turns: details.row?.childrenExpanded == true ? 0.25 : 0,
                      child: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black,
                      ),
                    ),
                  ),
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: fontWeight ?? FontWeight.w600),
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget textControllerField2(
      {required String name,
      required TextEditingController controller,
      double height = 50.0,
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
            readOnly: isEdit || !_searched,
            maxLength: maxInput,
            buildCounter: (context, {int? currentLength, int? maxLength, bool? isFocused}) => null,
            validator: validator,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget nagarDropdown() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          if (![6, 7].contains(_selectedKaryakramLevelId) && _linkedMahaanagar != null)
            buildDropdownField(
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
                  _selectedGeoUnitId = value;
                  // _linkedMahaanagarName = selectedItem.name ?? "";
                  // _resetLinkedValues();
                });
                populatelinkedVibhaagDropdown(value!);
                populatelinkedBhaagDropdown("");
              },
              isDisabled: ((userLevelId ?? 0) < 9 || userLevelId == 13),
            ),
          if (_linkedVibhaag != null)
            buildDropdownField(
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
                  _selectedGeoUnitId = value;
                  // _linkedVibhaagName = selectedItem.name ?? "";
                });
                populatelinkedBhaagDropdown(value!);
              },
              isDisabled: ((userLevelId ?? 0) < 8 || userLevelId == 13),
            ),
          if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty)
            buildDropdownField(
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
                  _selectedGeoUnitId = value;
                  populatelinkedShaharDropdown(value!);
                  populatelinkedNagarDropdown(value);
                });
              },
              isDisabled: ((userLevelId ?? 0) < 7 || userLevelId == 13),
            ),
          if ([5, 6, 7].contains(_selectedKaryakramLevelId) && _linkednagar != null && _linkednagar!.isNotEmpty)
            buildDropdownField(
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
                  _selectedGeoUnitId = value;
                  _selctedLevel = Statics.getLabel('Nagar');
                  _selctedLevelName = selectedItem.name ?? "";
                  _linkednagarName = selectedItem.name ?? "";
                  populatelinkedUpnagarDropdown(value);
                  populatelinkedMandalDropdown('Nagar', value);
                  // populatelinkedVastiDropdown('Nagar', value);
                });
              },
              isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
            ),
          if ([6, 7].contains(_selectedKaryakramLevelId) && _linkedupnagar != null && _linkedupnagar!.isNotEmpty)
            buildDropdownField(
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
                  _selctedLevel = Statics.getLabel('upnagarUpkhanda');
                  _selctedLevelName = selectedItem.name ?? "";
                  _linkedupnagarName = selectedItem.name ?? "";
                  populatelinkedMandalDropdown('Upnagar', value);
                  // populatelinkedVastiDropdown('Upnagar', value);
                });
              },
              isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
            ),
          if ([7].contains(_selectedKaryakramLevelId) && _linkedmandal != null && _linkedmandal!.isNotEmpty)
            buildDropdownField(
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
                  _selctedLevel = Statics.getLabel('Mandal');
                  _selctedLevelName = selectedItem.name ?? "";
                  _linkedmandalName = selectedItem.name ?? "";
                  // populatelinkedGraamDropdown(value);
                });
              },
              isDisabled: ((userLevelId ?? 0) < 4),
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
}
