import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';
import '../../../widgets/shaakhaa_card.dart';
import '../../edit_shaakhaa_vrutta.dart';
import '../../home_screen/home_screen.dart';
import '../../maps_display.dart';

class ShakhaaSaptahListTab extends StatefulWidget {
  const ShakhaaSaptahListTab({super.key});

  @override
  State<ShakhaaSaptahListTab> createState() => _ShakhaaSaptahListTabState();
}

class _ShakhaaSaptahListTabState extends State<ShakhaaSaptahListTab> {
  // static const String routeName = '/vijayadashami-form-view';
  final _searchController = TextEditingController();
  bool _isSearching = false;
  bool _searched = false;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;

  String? _linkedMahaanagarValue = "";
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";

  List<StaticMasterBAL>? _vayogat;

  // List<StaticMasterBAL>? _frequency;
  List shakhaSapMasSanghList = [];
  List<GeoUnitMasterBAL>? _linkedupnagar;

  String? _vayogatValue;

  // String? _frequencyValue;

  // String? geoUnitIDnew;
  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  String _selctedLevelNames = '';
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId;
  String? _linkedupnagarValue = '';
  String? _linkedbhaagName = '';
  String? _linkednagarName = '';
  String? _linkedvastiName = '';
  bool _isExpanded = false;

  List<dynamic>? _shaakhaaList = [];
  List<dynamic> _sankalpitShaakhaaList = [];
  List<dynamic> _newShaakhaaList = [];
  List<Statics.cLatLong> _latLng = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());

    print("_shaakhaaList_shaakhaaList  --->>> $_shaakhaaList");

    // if(int.parse(Statics.userDetails['LevelID']) <= 2){
    //   _shaakhaaList = _getshaakhaaList(-1, "get nothing", null, null);
    //   print("_shaakhaaList_shaakhaaList  --->>> $_shaakhaaList");
    // }
    if ((int.parse(Statics.userDetails['LevelID']) > 1)) {
      // &&
      //   !(Statics.userDetails['DaayitvaName'] == 'Mukhya Shikshak' ||
      //       Statics.userDetails['DaayitvaName'] == 'मुख्य शिक्षक' ||
      //       Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' ||
      //       Statics.userDetails['DaayitvaName'] == 'कार्यवाह')) {
      print("jfhdjkfh asjkhjkfhd sjkahjkhk f shkjshfk f");
    } else {
      // _shaakhaaList = await _getshaakhaaList(-1, "get nothing", null, null);
      // _shaakhaaList = await _getshaakhaaList(-1, "get nothing", null, null);
    }
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

  // void populateDropdown() async {
  //   var data = await Statics.getStaticLDB('ShaakhaaVayogat');
  //   var data1 = await Statics.getStaticLDB('ShaakhaaFrequency');
  //   populatelinkedBhaagDropdown();
  //   if (!mounted) return;
  //   setState(() {
  //     _vayogat = data;
  //     _frequency = data1;
  //   });
  // }

  Future<void> populateAllDropdowns(int level, DropDownModel dm) async {
    setState(() {
      _selectedGeoUnitId = _linkedMahaanagarValue = _linkedbhaagValue = _linkednagarValue = _linkedvastiValue = null;
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
      _linkedupnagarValue = (level == 13 ? (dm.geoUnitID ?? 0).toString() : selection.upnagar) ?? _linkedupnagarValue;
      if (level == 13) {
        _selectedGeoUnitId = (dm.geoUnitID ?? selection.upnagar).toString();
        _selctedLevel = 'Upnagar';
      }
    }

    // Step 6: Mandal
    // await populatelinkedMandalDropdown(
    //   selection.upnagar != null ? "Nagar" : "Upnagar",
    //   selection.upnagar != null ? _linkednagarValue : _linkedupnagarValue,
    // );
    // _linkedmandalValue = (level == 4 ? (dm.geoUnitID ?? 0).toString() : selection.mandal) ?? _linkedmandalValue;
    // if (level == 4) {
    //   _selectedGeoUnitId = (dm.geoUnitID ?? selection.mandal).toString();
    //   _selctedLevel = 'Mandal';
    // }

    // Step 6: Mandal
    await populatelinkedMandalDropdown(
      (selection.upnagar != null && selection.upnagar!.isNotEmpty),
      (selection.upnagar != null && selection.upnagar!.isNotEmpty) ? _linkedupnagarValue! : _linkednagarValue!,
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
      (selection.upnagar != null && selection.upnagar!.isNotEmpty) ? (_linkedupnagarValue) : _linkednagarValue,
    );
    _linkedvastiValue = (level == 2 ? (dm.geoUnitID ?? "").toString() : selection.vasti) ?? '';
    if (level == 2) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.vasti).toString();
      _selctedLevel = 'Vasti';
    }
    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedBhaag != null && _linkedBhaag!.isNotEmpty) _linkedbhaagName = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedNagar != null && _linkedNagar!.isNotEmpty) _linkednagarName = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;

    setState(() {});
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    setState(() {
      _linkedMahaanagarValue = _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedvastiValue = null;
      _linkedMahaanagar = _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedupnagar = _linkednagar = null;
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
    var data = await Statics.getStaticLDB('ShaakhaaVayogat');
    var data1 = await Statics.getStaticLDB('ShaakhaaFrequency');
    if (!mounted) return;
    setState(() {
      _vayogat = data;
      // _frequency = data1;
    });
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    _linkedMahaanagarValue = _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedvastiValue = _linkedmandalValue = _linkedgraamValue = null;
    _linkedMahaanagar = _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedupnagar = _linkedvasti = _linkedmandal = _linkedgraam = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '', isAbhiyaan: false);
    setState(() => _linkedMahaanagar = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedvastiValue = _linkedmandalValue = _linkedgraamValue = null;
    _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedupnagar = _linkedvasti = _linkedmandal = _linkedgraam = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar', '', isAbhiyaan: false);
    setState(() => _linkedVibhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedvastiValue = _linkedmandalValue = _linkedgraamValue = null;
    _linkedbhaag = _linkednagar = _linkedupnagar = _linkedvasti = _linkedmandal = _linkedgraam = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '', isAbhiyaan: false);
    setState(() => _linkedbhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkednagarValue = _linkedupnagarValue = _linkedvastiValue = _linkedmandalValue = _linkedgraamValue = null;
    _linkednagar = _linkedupnagar = _linkedvasti = _linkedmandal = _linkedgraam = null;
    final parentID = shaharIDStr ?? bhaagIDStr!;
    final parentType = shaharIDStr != null ? 'Shahar' : 'Bhaag';
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), parentID, parentType, '', isAbhiyaan: false);
    setState(() => _linkednagar = data.isNotEmpty ? data : null);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedUpnagarDropdown(String? nagarIDStr) async {
    _linkedupnagarValue = _linkedvastiValue = _linkedmandalValue = _linkedgraamValue = null;
    //_linkedupnagarName = _linkedmandalName = _linkedgraamName = null;
    _linkedupnagar = _linkedvasti = _linkedmandal = _linkedgraam = null;
    var mnDD;

    mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');

    setState(() {
      _linkedupnagar = (mnDD.length > 0 ? mnDD : null);
      //_linkedupnagarValue = (userparentUpanagarid ?? userGeoUnitId).toString();
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(bool haveParentUp, String? nagarIDStr) async {
    _linkedvastiValue = _linkedmandalValue = _linkedgraamValue = null;
    _linkedvastiName = _linkedvasti = _linkedmandal = _linkedgraam = null;
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

  // void populatelinkedBhaagDropdown() async {
  //   _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), "", "", "");
  //   setState(() {
  //     _linkedbhaag = data;
  //   });
  // }

  // Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown() async {
  //   _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), "", "", "");
  //   setState(() {
  //     _linkedbhaag = data;
  //   });
  //   return data;
  // }
  //
  // void populatelinkedShaharDropdown(String bhaagIDStr) async {
  //   _linkedshaharValue = _linkedvastiValue = _linkedshahar = _linkedvasti = null;
  //   var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
  //   setState(() {
  //     _linkedshahar = (shDD.length > 0 ? shDD : null);
  //   });
  // }

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

  // Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
  //   _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
  //   if (shaharIDStr != null) {
  //     var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
  //     setState(() {
  //       _linkednagar = (ngDD.length > 0 ? ngDD : null);
  //     });
  //     return ngDD;
  //   } else {
  //     var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
  //     setState(() {
  //       _linkednagar = (ngDD.length > 0 ? ngDD : null);
  //     });
  //     return ngDD;
  //   }
  // }

  // void populatelinkedMandalDropdown(String nagarIDStr) async {
  //   _linkedmandalValue = _linkedgraamValue = null;
  //   _linkedmandal = _linkedgraam = null;
  //   var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
  //   setState(() {
  //     _linkedmandal = (mnDD.length > 0 ? mnDD : null);
  //   });
  // }

  // Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(String nagarIDStr) async {
  //   _linkedgraamValue = null;
  //   _linkedmandal = _linkedgraam = null;
  //   var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
  //   setState(() {
  //     _linkedmandal = (mnDD.length > 0 ? mnDD : null);
  //   });
  //   return mnDD;
  // }

  // void populatelinkedGraamDropdown(String mandalIDStr) async {
  //   _linkedgraamValue = null;
  //   var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
  //   setState(() {
  //     _linkedgraam = (gmDD.length > 0 ? gmDD : null);
  //   });
  // }
  // Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String mandalIDStr) async {
  //   _linkedgraamValue = null;
  //   var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
  //   setState(() {
  //     _linkedgraam = (gmDD.length > 0 ? gmDD : null);
  //   });
  //   return gmDD;
  // }

  // void populatelinkedVastiDropdown(String nagarIDStr) async {
  //   _linkedvastiValue = null;
  //   var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
  //   setState(() {
  //     _linkedvasti = (vsDD.length > 0 ? vsDD : null);
  //   });
  //   print(vsDD);
  // }
  // Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String nagarIDStr) async {
  //   _linkedvastiValue = null;
  //   var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
  //   setState(() {
  //     _linkedvasti = (vsDD.length > 0 ? vsDD : null);
  //   });
  //   return vsDD;
  // }

  Future<void> _search(String strType, var ctx) async {
    setState(() {
      _shaakhaaList = _sankalpitShaakhaaList = _newShaakhaaList = [];
      _isSearching = true;
    });

    // int? frequencyVal = _frequencyValue == null || _frequencyValue == "" ? null : int.parse(_frequencyValue!);

    int? vayogatVal = _vayogatValue == null || _vayogatValue == "" ? null : int.parse(_vayogatValue!);

    print("Search :-  ${_selectedGeoUnitId}");

    print("Search :-  ${_selectedGeoUnitId}");
    final _list = await _getshaakhaaList(int.parse(_selectedGeoUnitId ?? "0"), _searchController.text, 34, vayogatVal);

    // _shaakhaaList = _getshaakhaaList(
    //     geoUnitID, _searchController.text, frequencyVal, vayogatVal);

    final _isSankalpitList = _list.where((e) => e["IsSankalpit"] == true);
    final _isNotSankalpitList = _list.where((e) => e["IsSankalpit"] == false);

    _shaakhaaList = _isNotSankalpitList.toList();
    _sankalpitShaakhaaList = _isSankalpitList.toList();
    _newShaakhaaList = _isNotSankalpitList.toList();

    // _shaakhaaList?.removeWhere((e) => e["IsSankalpit"] == true);
    setState(() {
      _shaakhaaList;
      _sankalpitShaakhaaList;
      _newShaakhaaList;
      _isSearching = false;
      _searched = true;
      _isExpanded = false;
    });
    print(_shaakhaaList?.length);
    print(_sankalpitShaakhaaList.length);
    print(_newShaakhaaList.length);
  }

  void _getCsv() async {
    // setState(() {
    //   _isfetingData = true;
    // });

    // Await the future resolution to get the actual list
    List<dynamic> dataList = _shaakhaaList!;

    // Prepare the CSV headers
    List<List<dynamic>> rows = [];
    List<dynamic> header = [];
    header.add(Statics.getLabel('SelectShaakhaa'));
    header.add(Statics.getLabel('Vayogat'));
    header.add(Statics.getLabel('IsSankalpit'));
    header.add(Statics.getLabel('FrequencyCode'));
    // header.add(Statics.getLabel('Location'));
    header.add(Statics.getLabel('FromTime'));
    header.add(Statics.getLabel('ToTime'));
    header.add(Statics.getLabel('HasToli'));
    header.add(Statics.getLabel('HasPaalak'));
    header.add(Statics.getLabel('OptionalShaaririkVishay'));
    header.add(Statics.getLabel('OtherOptionalVishay'));
    // header.add(Statics.getLabel('OtherInfo'));
    header.add(Statics.getLabel('Bhaag'));
    header.add(Statics.getLabel('Graam'));
    header.add(Statics.getLabel('Mandal'));
    header.add(Statics.getLabel('Nagar'));
    header.add(Statics.getLabel('Shahar'));
    header.add(Statics.getLabel('Vasti'));

    rows.add(header);

    // Loop through the data list
    for (var data in dataList) {
      // List<GeoUnitMasterBAL> mahanagarList = await populatelinkedMahaanagarDropdown() ;
      // List<GeoUnitMasterBAL>  vibhagList = await populatelinkedVibhaagDropdown(data.parentMahaanagarID.toString()== "0"?"":data.parentMahaanagarID.toString());
      List<GeoUnitMasterBAL> bhagList = await populatelinkedBhaagDropdown(data["ParentVibhaagID"].toString()) ?? [];
      List<GeoUnitMasterBAL> nagarList = await populatelinkedNagarDropdown(data["ParentBhaagID"].toString(), null);
      List<GeoUnitMasterBAL> mandalList = await populatelinkedMandalDropdown(false, data["ParentNagarID"].toString()) ?? [];
      List<GeoUnitMasterBAL> gramList = await populatelinkedGraamDropdown(data["ParentMandalID"].toString()) ?? [];
      List<GeoUnitMasterBAL> vastiList = await populatelinkedVastiDropdown(false, data["ParentNagarID"].toString()) ?? [];
      // print("vibhagListvibhagList  ${jsonEncode(vibhagList)}");

      List<dynamic> row = [];
      row.add(data["GeoUnitName"].toString());
      row.add(data["VayogatCode"].toString());
      row.add(data["IsSankalpit"].toString());
      row.add(data["FrequencyCode"].toString());
      // row.add(data["ParentShaharID"].toString());
      row.add(data["StartTimeStr"].toString());
      row.add(data["EndTimeStr"].toString());
      row.add(data["HasToli"].toString());
      row.add(data["HasPaalak"].toString());
      row.add(data["OptionalShaaririkVishayCode"].toString());
      row.add(data["OtherOptionalVishay"].toString());
      // row.add(data["DaayitvaLevelName"].toString());
      // row.add(data["DaayitvaName"].toString());
      row.add("${bhagList.where((element) => element.geoUnitID == data["ParentBhaagID"]).isNotEmpty ? bhagList.firstWhere((element) => element.geoUnitID == data["ParentBhaagID"]).name : "-"}");
      row.add("${gramList.where((element) => element.geoUnitID == data["ParentGraamID"]).isNotEmpty ? gramList.firstWhere((element) => element.geoUnitID == data["ParentGraamID"]).name : "-"}");
      row.add("${mandalList.where((element) => element.geoUnitID == data["ParentMandalID"]).isNotEmpty ? mandalList.firstWhere((element) => element.geoUnitID == data["ParentMandalID"]).name : "-"}");
      row.add("${nagarList.where((element) => element.geoUnitID == data["ParentNagarID"]).isNotEmpty ? nagarList.firstWhere((element) => element.geoUnitID == data["ParentNagarID"]).name : "-"}");
      row.add("${vastiList.where((element) => element.geoUnitID == data["ParentShaharID"]).isNotEmpty ? vastiList.firstWhere((element) => element.geoUnitID == data["ParentShaharID"]).name : "-"}");
      row.add("${vastiList.where((element) => element.geoUnitID == data["ParentVastiID"]).isNotEmpty ? vastiList.firstWhere((element) => element.geoUnitID == data["ParentVastiID"]).name : "-"}");

      // Mahanagar //9
      //   "${mahanagarList.where((element) =>  element.geoUnitID == data.parentMahaanagarID).isNotEmpty ? mahanagarList.firstWhere((element) => element.geoUnitID == data.parentMahaanagarID).name  : "-" }",
      // "${vibhagList.where((element) =>  element.geoUnitID == data.parentVibhaagID).isNotEmpty ? vibhagList.firstWhere((element) => element.geoUnitID == data.parentVibhaagID).name  : "-" }",

      rows.add(row);
    }

    if (rows.length > 1) {
      Statics.convertToCsv(rows, "SoochiMembersList" + "_" + DateFormat('ddMMyyyyHHmmss').format(DateTime.now()), context);
    }

    setState(() {
      // _isfetingData = false;
    });
  }

  void viewLocation(var dataList, var ctx) async {
    _latLng = [];
    for (var shaakhaaItem in dataList) {
      if (shaakhaaItem["ShaakhaaLatitude"] != null && shaakhaaItem["ShaakhaaLatitude"].toString() != "") {
        _latLng.add(Statics.cLatLong(
            shaakhaaItem["ShaakhaaID"], shaakhaaItem["GeoUnitName"].toString(), shaakhaaItem["FrequencyCode"].toString(), LatLng(shaakhaaItem["ShaakhaaLatitude"], shaakhaaItem["ShaakhaaLongitude"])));
      }
    }
    print("viewLocation -> dataList -> _latLng :- $_latLng");
    if (_latLng.length > 0) {
      Navigator.of(ctx).pushNamed(MapDisplay.routeName, arguments: _latLng);
    } else
      Statics.showErrorDialog(ctx, Statics.getLabel("LocationNotAvailableForSearch"));
  }

  Future<List<dynamic>> _getshaakhaaList(int? geoUnitID, String searchString, int? frequencyID, int? vayogatID) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({"AppUserID": Statics.userDetails['userID'], "GeoUnitID": geoUnitID, "FrequencyID": frequencyID, "VayogatID": vayogatID});
      print("strInput:- $strInput");
      return Statics.getShaakhaaList(strInput);
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  // Future<List<dynamic>> _getshaakhaaList(int? geoUnitID, String searchString, int? frequencyID, int? vayogatID) async {
  //   bool isConnected = await Statics.isInternetConnected();
  //   if (isConnected) {
  //     String strInput = json.encode({
  //       "AppUserID": Statics.userDetails['userID'],
  //       "GeoUnitID": geoUnitID,
  //       "FrequencyID": frequencyID,
  //       "VayogatID": vayogatID,
  //     });
  //     print("strInput:- $strInput");
  //
  //     // Show the popup with the strInput value
  //     _showPopup(context, strInput);
  //
  //     return Statics.getShaakhaaList(strInput);
  //   } else {
  //     Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
  //     return [];
  //   }
  // }
  Future<void> _showPopup(BuildContext context, String strInput) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Input Value'),
          content: Text(strInput),
          actions: <Widget>[
            TextButton(
              child: Text('bandKara'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) {
        if (didpop) return;
        Navigator.pushNamedAndRemoveUntil(context, Navigator.of(context).pushNamed(HomeScreen.routeName).toString(), (route) => false);
      },
      child: DefaultTabController(
        length: 3,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Text(
                Statics.getLabel('searchShaakhaaScreenBanner'),
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
                  if ((int.parse(Statics.userDetails['LevelID']) > 1))
                    // &&
                    // !(Statics.userDetails['DaayitvaName'] == 'Mukhya Shikshak' ||
                    //     Statics.userDetails['DaayitvaName'] == 'मुख्य शिक्षक' ||
                    //     Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' ||
                    //     Statics.userDetails['DaayitvaName'] == 'कार्यवाह'))
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
                            //======================================================================================================================
                            if (_linkedMahaanagar != null)
                              buildDropdownField(
                                isDisabled: ((userLevelId ?? 0) < 9 || (userLevelId ?? 0) == 13),
                                label: Statics.getLabel('Mahaanagar'),
                                value: _linkedMahaanagarValue,
                                items: _linkedMahaanagar!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                                onChanged: (value) async {
                                  final item = _linkedMahaanagar!.firstWhere((g) => g.geoUnitID.toString() == value);
                                  setState(() {
                                    _linkedMahaanagarValue = value;
                                    _linkedVibhaagValue = null;
                                    _selctedLevel = 'Mahanagar';
                                    _selctedLevelName = item.name ?? "";
                                    _selectedGeoUnitId = value;
                                  });
                                  populatelinkedVibhaagDropdown(value!);
                                  populatelinkedBhaagDropdown("");
                                },
                              ),
                            if (_linkedVibhaag != null)
                              buildDropdownField(
                                isDisabled: ((userLevelId ?? 0) < 8 || (userLevelId ?? 0) == 13),
                                label: Statics.getLabel('Vibhaag'),
                                value: _linkedVibhaagValue,
                                items: _linkedVibhaag!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                                onChanged: (value) {
                                  final item = _linkedVibhaag!.firstWhere((g) => g.geoUnitID.toString() == value);
                                  setState(() {
                                    _linkedVibhaagValue = value;
                                    _selctedLevel = 'Vibhaag';
                                    _selctedLevelName = item.name ?? "";
                                    _selectedGeoUnitId = value;
                                  });
                                  populatelinkedBhaagDropdown(value!);
                                },
                              ),
                            if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty)
                              buildDropdownField(
                                isDisabled: ((userLevelId ?? 0) < 7 || (userLevelId ?? 0) == 13),
                                label: Statics.getLabel('Bhaag'),
                                value: _linkedbhaagValue,
                                items: _linkedbhaag!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                                onChanged: (value) {
                                  final item = _linkedbhaag!.firstWhere((g) => g.geoUnitID.toString() == value);
                                  setState(() {
                                    _linkedbhaagValue = value;
                                    _selctedLevel = 'Bhaag';
                                    _selctedLevelName = item.name ?? "";
                                    _linkedbhaagName = item.name ?? "";
                                    _selectedGeoUnitId = value;
                                    populatelinkedNagarDropdown(value, null);
                                  });
                                },
                              ),
                            if (_linkednagar != null && _linkednagar!.isNotEmpty)
                              buildDropdownField(
                                isDisabled: ((userLevelId ?? 0) < 6 || (userLevelId ?? 0) == 13),
                                label: Statics.getLabel('Nagar'),
                                value: _linkednagarValue,
                                items: _linkednagar!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                                onChanged: (value) {
                                  final item = _linkednagar!.firstWhere((g) => g.geoUnitID.toString() == value);
                                  setState(() {
                                    _linkednagarValue = value;
                                    _selectedGeoUnitId = value;
                                    _selctedLevel = 'Nagar';
                                    _selctedLevelName = item.name ?? "";
                                    _linkednagarName = item.name ?? "";
                                    populatelinkedVastiDropdown(false, value!);
                                    populatelinkedMandalDropdown(false, value);
                                    populatelinkedUpnagarDropdown(value);
                                  });
                                },
                              ),
                            if (_linkedupnagar != null && _linkedupnagar!.isNotEmpty)
                              buildDropdownField(
                                isDisabled: ((userLevelId ?? 0) < 6 || (userLevelId ?? 0) == 13),
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
                                    populatelinkedVastiDropdown(true, value!);
                                    populatelinkedMandalDropdown(true, value);
                                    // populatelinkedNagarDropdown(null, value);
                                  });
                                },
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
                                  final item = _linkedmandal!.firstWhere((g) => g.geoUnitID.toString() == value);
                                  setState(() {
                                    _linkedmandalValue = value;
                                    _selectedGeoUnitId = value.toString();
                                    _selctedLevel = 'Mandal';
                                    _selctedLevelName = item.name ?? "";
                                    //type = "mandal";
                                  });
                                  populatelinkedGraamDropdown(value!);
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
                                  final item = _linkedgraam!.firstWhere((g) => g.geoUnitID.toString() == value);
                                  setState(() {
                                    _linkedgraamValue = value;
                                    _selectedGeoUnitId = value.toString();
                                    _selctedLevel = 'Graam';
                                    _selctedLevelName = item.name ?? "";
                                  });
                                },
                              ),
                            if (_linkedvasti != null && _linkedvasti!.isNotEmpty)
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
                                  final item = _linkedvasti!.firstWhere((g) => g.geoUnitID.toString() == value);
                                  setState(() {
                                    _linkedvastiValue = value;
                                    _selectedGeoUnitId = value.toString();
                                    _selctedLevel = 'Vasti';
                                    _selctedLevelName = item.name ?? "";
                                    _linkedvastiName = item.name ?? "";
                                  });
                                },
                              ),

                            //======================================================================================================================
                            /*if (_frequency != null)
                              DropdownButtonFormField<StaticMasterBAL>(
                                decoration: InputDecoration(labelText: Statics.getLabel('SelectFrequency')),
                                isExpanded: true,
                                value: _frequencyValue == null
                                    ? null
                                    : _frequency == null
                                        ? null
                                        : _frequency![_frequency!.indexWhere((p) => p.staticID.toString() == _frequencyValue.toString())],
                                items: _frequency!.map((bg) => DropdownMenuItem(value: bg, child: Text(bg.codeForDisplay!))).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _frequencyValue = value!.staticID.toString();
                                  });
                                },
                              ),
                            SizedBox(
                              height: 10,
                            ),*/
                            if (_vayogat != null)
                              DropdownButtonFormField(
                                decoration: InputDecoration(labelText: Statics.getLabel('Vayogat')),
                                isExpanded: true,
                                value: _vayogatValue == "" ? null : _vayogatValue,
                                items: _vayogat!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _vayogatValue = value;
                                  });
                                },
                              ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      isExpanded: _isExpanded,
                    ),
                ],
              ),
              if ((int.parse(Statics.userDetails['LevelID']) > 1))
                // &&
                //   !(Statics.userDetails['DaayitvaName'] == 'Mukhya Shikshak' ||
                //       Statics.userDetails['DaayitvaName'] == 'मुख्य शिक्षक' ||
                //       Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' ||
                //       Statics.userDetails['DaayitvaName'] == 'कार्यवाह'))
                Container(
                  margin: EdgeInsets.all(20),
                  child: _isSearching == true
                      ? CircularProgressIndicator()
                      : Wrap(
                          spacing: 10,
                          children: [
                            MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              color: Theme.of(context).primaryColor,
                              textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                              onPressed: () {
                                _search("Search", context);
                              },
                              child: Text(
                                Statics.getLabel('Search'),
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            MaterialButton(
                                onPressed: () {
                                  print("clear button pressed");
                                  setState(() {
                                    _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                                    _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                                    _searchController.text = "";
                                    _selectedGeoUnitId = "";
                                    _isSearching = _searched = false;
                                  });
                                  // _frequencyValue = null;
                                  _vayogatValue = null;
                                  // _shaakhaaList = _getshaakhaaList(-1, "get nothing", null, null);
                                  populatelinkedBhaagDropdown(_linkedVibhaagValue!);
                                  _isExpanded = false;
                                  _shaakhaaList = [];
                                  populateDropdown();
                                },
                                child: Text(Statics.getLabel('clear'))),
                          ],
                        ),
                ),
              if (_searched) ...[
                TabBar(labelColor: Colors.purple, unselectedLabelColor: Colors.grey, tabs: [
                  Tab(
                      child: Text(
                    Statics.getLabel("Shaakhaa"),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  )),
                  Tab(
                      child: Text(
                    Statics.getLabel("Consolidated"),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  )),
                  Tab(
                      child: Text(
                    Statics.getLabel("new"),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  )),
                ]),
                Flexible(
                  child: TabBarView(children: [
                    ListView.separated(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => SizedBox(height: 8),
                      itemCount: _shaakhaaList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return ShaakhaaCard(_shaakhaaList?[index], _shaakhaaList?[index]['IsSankalpit'], _search,
                            traillingIcon: IconButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditShaakhaaVrutta(
                                              shaakhaaID: _shaakhaaList?[index]["ShaakhaaID"].toString(),
                                              vruttaID: _shaakhaaList?[index]["ShaakhaaVruttaID"].toString(),
                                              onSaveDetails: null,
                                              viewType: "EditVrutta",
                                            ))),
                                icon: Icon(Icons.edit)));
                      },
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => SizedBox(height: 8),
                      itemCount: _sankalpitShaakhaaList.length ?? 0,
                      itemBuilder: (context, index) {
                        return ShaakhaaCard(_sankalpitShaakhaaList[index], _sankalpitShaakhaaList[index]['IsSankalpit'], _search,
                            traillingIcon: IconButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditShaakhaaVrutta(
                                              shaakhaaID: _sankalpitShaakhaaList?[index]["ShaakhaaID"].toString(),
                                              vruttaID: _sankalpitShaakhaaList?[index]["ShaakhaaVruttaID"].toString(),
                                              onSaveDetails: null,
                                              viewType: "EditVrutta",
                                            ))),
                                icon: Icon(Icons.edit)));
                      },
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => SizedBox(height: 8),
                      itemCount: _newShaakhaaList.length ?? 0,
                      itemBuilder: (context, index) {
                        return ShaakhaaCard(_newShaakhaaList[index], _newShaakhaaList[index]['IsSankalpit'], _search,
                            IsNew: true,
                            traillingIcon: IconButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditShaakhaaVrutta(
                                              shaakhaaID: _newShaakhaaList?[index]["ShaakhaaID"].toString(),
                                              vruttaID: _newShaakhaaList?[index]["ShaakhaaVruttaID"].toString(),
                                              onSaveDetails: null,
                                              viewType: "EditVrutta",
                                            ))),
                                icon: Icon(Icons.edit)));
                      },
                    ),
                  ]),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}
