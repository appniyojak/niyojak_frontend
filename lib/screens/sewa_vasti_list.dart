import 'dart:convert';

import 'package:flutter/material.dart';

import '../helpers/static_data.dart' as Statics;
import '../models/response_model/dropdown_level_responsemodel.dart';
import '../providers/bals.dart';
import '../screens/edit_sewa_vasti.dart';
import '../utils/globals.dart';
import '../widgets/app_drawer.dart';
import '../widgets/sewa_vasti_card.dart';
import 'home_screen/home_screen.dart';

class SearchSewaVasti extends StatefulWidget {
  static const routeName = '/search-sewavasti-screen';

  @override
  _SearchSewaVastiState createState() => _SearchSewaVastiState();
}

class _SearchSewaVastiState extends State<SearchSewaVasti> {
  Future<List<dynamic>>? _sewaVastiList;
  bool _isSearching = false;
  bool _isExpanded = false;

  List<GeoUnitMasterBAL>? _bhaag;
  List<GeoUnitMasterBAL>? _shahar;
  List<GeoUnitMasterBAL>? _nagar;

  String? _bhaagValue = "";
  String? _shaharValue = "";
  String? _nagarValue = "";

  // int? geoUnitIDnew;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<GeoUnitMasterBAL>? _linkedupnagar;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";
  String? _linkedupnagarValue = '';
  String? type;
  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  String _selctedLevelNames = '';
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId;

  @override
  void initState() {
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    populateBhaagDropdown();
    _sewaVastiList = _getSewaVastiLst(-1, null, null, null, null, null, null, null);
  }

  void onSaveDetails() {
    var data = _getSewaVastiLst(
        (_linkedMahaanagarValue == null || _linkedMahaanagarValue == "" ? null : int.parse(_linkedMahaanagarValue!)),
        (_linkedVibhaagValue == null || _linkedVibhaagValue == "" ? null : int.parse(_linkedVibhaagValue!)),
        (_linkedbhaagValue == null || _linkedbhaagValue == "" ? null : int.parse(_linkedbhaagValue!)),
        (_linkednagarValue == null || _linkednagarValue == "" ? null : int.parse(_linkednagarValue!)),
        (_linkedvastiValue == null || _linkedvastiValue == "" ? null : int.parse(_linkedvastiValue!)),
        (_linkedgraamValue == null || _linkedgraamValue == "" ? null : int.parse(_linkedgraamValue!)),
        (_linkedmandalValue == null || _linkedmandalValue == "" ? null : int.parse(_linkedmandalValue!)),
        null);
    setState(() {
      _sewaVastiList = data;
    });
  }

  void populateBhaagDropdown() async {
    _shaharValue = _nagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), "", "", "");
    setState(() {
      _bhaag = data;
      _isSearching = false;
    });
  }

  void populateShaharDropdown(String bhaagIDStr) async {
    _shaharValue = null;
    _shahar = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _shahar = (shDD.length > 0 ? shDD : null);
    });
  }

  void populateNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _nagarValue = null;

    _nagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _nagar = (ngDD.length > 0 ? ngDD : null);
      });
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _nagar = (ngDD.length > 0 ? ngDD : null);
      });
    }
  }

  Future<List<dynamic>> _getSewaVastiLst(int? mahanagar, int? vibhag, int? bhag, int? nagar, int? vasti, int? gram, int? manadal, int? sewaVastiID) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
        "MahanagarID": mahanagar,
        "VibhaagID": vibhag,
        "BhaagID": bhag,
        "ShaharID": _shaharValue,
        "NagarID": nagar,
        "VastiID": vasti,
        "GraamID": gram,
        "MandalID": manadal,
        "SewaVastiID": sewaVastiID,
        "GeoUnitId": _selectedGeoUnitId
      });

      return Statics.getSewaVastiForApp(strInput);
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  Future<void> _search() async {
    setState(() {
      _isSearching = true;
    });

    int? mahanagar = _linkedMahaanagarValue == null || _linkedMahaanagarValue == "" ? null : int.parse(_linkedMahaanagarValue!);
    int? vibhag = _linkedVibhaagValue == null || _linkedVibhaagValue == "" ? null : int.parse(_linkedVibhaagValue!);
    int? bhag = _linkedbhaagValue == null || _linkedbhaagValue == "" ? null : int.parse(_linkedbhaagValue!);
    int? nagar = _linkednagarValue == null || _linkednagarValue == "" ? null : int.parse(_linkednagarValue!);
    int? vasti = _linkedvastiValue == null || _linkedvastiValue == "" ? null : int.parse(_linkedvastiValue!);
    int? gram = _linkedgraamValue == null || _linkedgraamValue == "" ? null : int.parse(_linkedgraamValue!);
    int? manadal = _linkedmandalValue == null || _linkedmandalValue == "" ? null : int.parse(_linkedmandalValue!);

    setState(() {
      _sewaVastiList = _getSewaVastiLst(mahanagar, vibhag, bhag, nagar, vasti, gram, manadal, null);
      _isSearching = false;
      _isExpanded = false;
    });
  }

  // Future<void> populateDropdown() async {
  //   setState(() {
  //     _linkedshaharValue = null;
  //     _linkednagarValue = null;
  //     _linkedmandalValue = null;
  //     _linkedgraamValue = null;
  //     _linkedvastiValue = null;
  //   });
  //   await populatelinkedMahaanagarDropdown();
  //   await populatelinkedVibhaagDropdown('');
  //
  //   setState(() {
  //     _linkedbhaagValue = null;
  //     _linkedshaharValue = null;
  //     _linkednagarValue = null;
  //     _linkedmandalValue = null;
  //     _linkedgraamValue = null;
  //     _linkedvastiValue = null;
  //   });
  // }

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
      // final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      // selctedLevelName = selectedItem.name;
    }

    // Step 2: Vibhaag
    await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
    _linkedVibhaagValue = (level == 8 ? (dm.geoUnitID ?? "").toString() : selection.vibhaag) ?? '';
    if (level == 8) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.vibhaag).toString();
      _selctedLevel = 'Vibhaag';
      // final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      // selctedLevelName = selectedItem.name;
    }

    // Step 3: Bhaag
    await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
    _linkedbhaagValue = (level == 7 ? (dm.geoUnitID ?? "").toString() : selection.bhaag) ?? '';
    if (level == 7) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.bhaag).toString();
      _selctedLevel = 'Bhaag';
      // final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      // selctedLevelName = selectedItem.name;
    }

    // Step 4: Nagar
    await populatelinkedNagarDropdown(_linkedbhaagValue, null);
    _linkednagarValue = (level == 6 ? (dm.geoUnitID ?? "").toString() : selection.nagar) ?? '';
    if (level == 6) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.nagar).toString();
      _selctedLevel = 'Nagar';
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
      // _getForm();
    }
    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty) _linkedbhaagName = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkednagar != null && _linkednagar!.isNotEmpty) _linkednagarName = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;

    setState(() {});
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    setState(() {
      _linkedMahaanagarValue = _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
      _linkedMahaanagar = _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedupnagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
      _selctedLevelName = _selectedGeoUnitId = null;
      _selctedLevel = "praant";
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
    if (fromClear || userLevelId == null || ddm == null) {
      print("object is null");
      return;
    }
    print("object is not null >>>>>>>>>>>>>>>>>>>>>>");
    await populateAllDropdowns(userLevelId!, ddm!);
    // var data = await Statics.getStaticLDB('AnnualBaithakType');
    // populatelinkedMahaanagarDropdown();
    // populatelinkedVibhaagDropdown('');
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '', isAbhiyaan: false);
    setState(() => _linkedMahaanagar = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedvastiValue = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar', '', isAbhiyaan: false);
    setState(() => _linkedVibhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedvastiValue = null;
    //_linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedbhaag = _linkednagar = _linkedvasti = [];
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '', isAbhiyaan: false);
    setState(() => _linkedbhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkednagarValue = _linkedvastiValue = null;
    //_linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkednagar = _linkedvasti = null;
    final parentID = shaharIDStr ?? bhaagIDStr!;
    final parentType = shaharIDStr != null ? 'Shahar' : 'Bhaag';
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), parentID, parentType, '', isAbhiyaan: false);
    setState(() => _linkednagar = data.isNotEmpty ? data : null);
    return data;
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

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String mandalIDStr) async {
    //setState(() => viewcontainer = false);
    // _linkedgraamValue = null;
    print("mandalIDStr mandalIDStr ==> $mandalIDStr");
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = data.isNotEmpty ? data : null;
    });
    return data;
  }

  // populatelinkedMahaanagarDropdown() async {
  //   _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
  //   setState(() {
  //     _linkedMahaanagar = data;
  //   });
  // }
  //
  // populatelinkedVibhaagDropdown(String? mahaanagarIDStr) async {
  //   _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr!, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
  //   setState(() {
  //     _linkedVibhaag = data;
  //   });
  // }
  //
  // void populatelinkedBhaagDropdown(String? vibhaagIDStr) async {
  //   _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr!, 'Vibhaag', '');
  //   setState(() {
  //     _linkedbhaag = data;
  //   });
  // }
  //
  //
  // void populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
  //   _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
  //   if (shaharIDStr != null) {
  //     var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
  //     setState(() {
  //       _linkednagar = (ngDD.length > 0 ? ngDD : null);
  //     });
  //   } else {
  //     var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
  //     setState(() {
  //       _linkednagar = (ngDD.length > 0 ? ngDD : null);
  //     });
  //   }
  // }
  //
  // void populatelinkedMandalDropdown(String? nagarIDStr) async {
  //   _linkedmandalValue = _linkedgraamValue = null;
  //   _linkedmandal = _linkedgraam = null;
  //   var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, 'Nagar', '');
  //   setState(() {
  //     _linkedmandal = (mnDD.length > 0 ? mnDD : null);
  //   });
  // }
  //
  // void populatelinkedGraamDropdown(String? mandalIDStr) async {
  //   _linkedgraamValue = null;
  //   var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '');
  //   setState(() {
  //     _linkedgraam = (gmDD.length > 0 ? gmDD : null);
  //   });
  // }
  //
  // void populatelinkedVastiDropdown(String? nagarIDStr) async {
  //   _linkedvastiValue = null;
  //   var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', '');
  //   setState(() {
  //     _linkedvasti = (vsDD.length > 0 ? vsDD : null);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.routeName);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('searchSewaVastiScreenLabel'),
            style: TextStyle(fontSize: 24),
          ),
          actions: <Widget>[
            // if ((Statics.userDetails['LevelName'] == 'Praant' ||
            //         Statics.userDetails['LevelName'] == 'Mahaanagar' ||
            //         Statics.userDetails['LevelName'] == 'Bhaag' ||
            //         Statics.userDetails['LevelName'] == 'Vibhaag' ||
            //         Statics.userDetails['LevelName'] == 'प्रांत' ||
            //         Statics.userDetails['LevelName'] == 'महानगर' ||
            //         Statics.userDetails['LevelName'] == 'भाग/जिल्हा' ||
            //         Statics.userDetails['LevelName'] == 'Nagar\/Taalukaa' ||
            //         Statics.userDetails['LevelName'] == 'Nagar' ||
            //         Statics.userDetails["LevelName"] == "नगर/तालुका" ||
            //         Statics.userDetails['LevelName'] == 'विभाग' ||
            //         Statics.userDetails["LevelName"] == "Bhaag" ||
            //         Statics.userDetails["LevelName"] == "भाग/जिला" ||
            //         Statics.userDetails["LevelName"] == "भाग/जिल्हा")
            //     // &&
            //     // (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
            //     //     Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "App Sanyojak" ||
            //     //     Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
            //     //     Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
            //     //     Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
            //     //     Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
            //     //     Statics.userDetails["DaayitvaName"] == "सह कार्यवाह" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Sewa Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "सेवा प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Saha-SewaPramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Sewa Vibhaag - Toli Sadasya" ||
            //     //     Statics.userDetails["DaayitvaName"] == "सेवा विभाग टोली सदस्य" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Sewa Saha-Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||
            //     //     Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' ||
            //     //     Statics.userDetails['DaayitvaName'] == 'कार्यालय प्रमुख' ||
            //     //     Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
            //     //     Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
            //     //     Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||
            //     //     Statics.userDetails['DaayitvaName'] == 'सह प्रचारक' ||
            //     //     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
            //     //     Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
            //     //     Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
            //     //     Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव")
            //     )
            if ((int.tryParse(Statics.userDetails["LevelID"]?.toString() ?? "0") ?? 0) > 1)
              IconButton(
                padding: EdgeInsets.all(8),
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditSewaVasti.routeName, arguments: Statics.ScreenArguments(0, Statics.getLabel('EditMenu')));
                },
              ),
          ],
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Text(
                  Statics.getLabel('searchSewaVastiScreenBanner'),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _isExpanded = isExpanded;
                    });
                  },
                  children: [
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(Statics.getLabel('Filters')),
                        );
                      },
                      body: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  if (_linkedMahaanagar != null)
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
                                        print(value);
                                        setState(() {
                                          _linkedMahaanagarValue = value.toString();
                                          _linkedVibhaagValue = null;

                                          _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
                                          _selectedGeoUnitId = value;
                                          type = "mahanagar";
                                        });
                                        populatelinkedVibhaagDropdown(value.toString());
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
                                      items: _linkedVibhaag!
                                          .map((bg) => DropdownMenuItem(
                                                value: bg.geoUnitID.toString(),
                                                child: Text(bg.name!),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkedVibhaagValue = value.toString();
                                          _selectedGeoUnitId = value;
                                          type = "vibhag";
                                        });
                                        populatelinkedBhaagDropdown(value.toString());
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
                                      value: _linkedbhaagValue,
                                      items: _linkedbhaag!
                                          .map((bg) => DropdownMenuItem(
                                                value: bg.geoUnitID.toString(),
                                                child: Text(bg.name!),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkedbhaagValue = value.toString();
                                          // populatelinkedShaharDropdown(value);
                                          _selectedGeoUnitId = value;
                                          type = "bhag";
                                        });
                                        populatelinkedNagarDropdown(value.toString(), null);
                                      },
                                    ),
                                  if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                                    SizedBox(
                                      height: 10,
                                    ),
                                  if (_linkednagar != null && _linkednagar!.length > 0)
                                    buildDropdownField(
                                      isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
                                      label: Statics.getLabel('Nagar'),
                                      value: _linkednagarValue,
                                      items: _linkednagar!
                                          .map((bg) => DropdownMenuItem(
                                                value: bg.geoUnitID.toString(),
                                                child: Text(bg.name!),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkednagarValue = value.toString();
                                          _selectedGeoUnitId = value;
                                          type = "nagar";
                                        });
                                        populatelinkedUpnagarDropdown(value.toString());
                                        populatelinkedMandalDropdown(false, value.toString());
                                        populatelinkedVastiDropdown(false, value.toString());
                                      },
                                    ),
                                  if (_linkednagar != null && _linkednagar!.length > 0)
                                    SizedBox(
                                      height: 10,
                                    ),
                                  if (_linkedupnagar != null && _linkedupnagar!.isNotEmpty)
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
                                          _selctedLevel = 'upnagarUpkhanda';
                                          _selctedLevelName = selectedItem.name ?? "";
                                          // populatelinkedNagarDropdown(null, value);
                                        });
                                        populatelinkedVastiDropdown(true, value!);
                                        populatelinkedMandalDropdown(true, value);
                                      },
                                    ),
                                  if (_linkedupnagar != null && _linkedupnagar!.isNotEmpty)
                                    SizedBox(
                                      height: 10,
                                    ),
                                  if (_linkedmandal != null && _linkedmandal!.length > 0)
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
                                        setState(() {
                                          _linkedmandalValue = value.toString();
                                          _selectedGeoUnitId = value;
                                          type = "mandal";
                                        });
                                        populatelinkedGraamDropdown(value.toString());
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
                                      value: _linkedgraamValue,
                                      items: _linkedgraam!
                                          .map((bg) => DropdownMenuItem(
                                                value: bg.geoUnitID.toString(),
                                                child: Text(bg.name!),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkedgraamValue = value.toString();
                                          _selectedGeoUnitId = value;
                                          type = "gram";
                                        });
                                      },
                                    ),
                                  if (_linkedvasti != null && _linkedvasti!.length > 0)
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
                                        setState(() {
                                          _linkedvastiValue = value.toString();
                                          _selectedGeoUnitId = value;
                                          type = "vasti";
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                            // if(_bhaag != null)
                            // DropdownButtonFormField(
                            //   decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                            //   isExpanded: true,
                            //   value: _bhaagValue == "" ? null : _bhaagValue,
                            //   items: _bhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            //   onChanged: (value) {
                            //     setState(() {
                            //       _bhaagValue = value;
                            //       populateShaharDropdown(value!);
                            //       populateNagarDropdown(value, null);
                            //     });
                            //   },
                            // ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // if (_shahar != null && _shahar!.length > 0)
                            //   DropdownButtonFormField(
                            //     decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                            //     isExpanded: true,
                            //     value: _shaharValue == "" ? null : _shaharValue,
                            //     items: _shahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            //     onChanged: (value) {
                            //       setState(() {
                            //         _shaharValue = value;
                            //         populateNagarDropdown(null, value);
                            //       });
                            //     },
                            //   ),
                            // if (_shahar != null && _shahar!.length > 0)
                            //   SizedBox(
                            //     height: 10,
                            //   ),
                            // if (_nagar != null && _nagar!.length > 0)
                            //   DropdownButtonFormField(
                            //     decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                            //     isExpanded: true,
                            //     value: _nagarValue == "" ? null : _nagarValue,
                            //     items: _nagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            //     onChanged: (value) {
                            //       setState(() {
                            //         _nagarValue = value;
                            //       });
                            //     },
                            //   ),
                            // if (_nagar != null && _nagar!.length > 0)
                            //   SizedBox(
                            //     height: 10,
                            //   ),
                          ],
                        ),
                      ),
                      isExpanded: _isExpanded,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (_isSearching)
                        CircularProgressIndicator()
                      else
                        Wrap(
                          children: [
                            MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              color: Theme.of(context).primaryColor,
                              textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                              onPressed: _search,
                              child: Text(
                                Statics.getLabel('Search'),
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    _linkedMahaanagarValue =
                                        _linkedVibhaagValue = _linkedbhaagValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = _bhaagValue = _shaharValue = _nagarValue = null;
                                    _linkedbhaag = _linkedmandal = _linkednagar = _linkedgraam = _linkedmandal = _linkedvasti = _bhaag = _shahar = _nagar = null;
                                    _sewaVastiList = Future.value(<dynamic>[]);
                                  });
                                  populateDropdown();
                                },
                                child: Text(Statics.getLabel('clear'))),
                          ],
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.75,
                  child: FutureBuilder<List<dynamic>>(
                    future: _sewaVastiList,
                    builder: (ctx, dataSnapshot) {
                      //print(dataSnapshot.connectionState.toString());
                      //print(dataSnapshot.hasData.toString());
                      //print(_isSearching.toString());

                      if (dataSnapshot.connectionState != ConnectionState.done) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (dataSnapshot.hasError) {
                        return Center(
                            child: Text(
                          'Server Error, Please Try Again Later',
                          style: TextStyle(color: Colors.red),
                        ));
                      }
                      return dataSnapshot.hasData && dataSnapshot.data!.length > 0
                          ? ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(height: 8),
                              itemCount: dataSnapshot.data!.length,
                              itemBuilder: (context, index) => SewaVastiCard(dataSnapshot.data![index], onSaveDetails),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 178.0),
                              child: Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch'))),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
