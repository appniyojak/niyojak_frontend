import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:niyojak_prod/widgets/nidhi_sankalan_card.dart';

import '../helpers/static_data.dart' as Statics;
import '../models/response_model/dropdown_level_responsemodel.dart';
import '../providers/bals.dart';
import '../utils/globals.dart';
import '../widgets/app_drawer.dart';

class SearchRamJanmaBhoomiNidhiSankalan extends StatefulWidget {
  static const routeName = '/search-ramjanmabhoomisankalan-screen';

  @override
  _SearchRamJanmaBhoomiNidhiSankalanState createState() => _SearchRamJanmaBhoomiNidhiSankalanState();
}

class _SearchRamJanmaBhoomiNidhiSankalanState extends State<SearchRamJanmaBhoomiNidhiSankalan> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<GeoUnitMasterBAL>? _linkedupnagar;

  String? _linkedVibhaagValue = "";
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";
  String? _linkedupnagarValue = '';

  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  String _selctedLevelNames = '';
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId;

  bool _isSahabhaagiOrVishesh = false;
  bool _isExpanded = false;

  Future<List<dynamic>>? _sankalanList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sankalanList = _getSankalanVruttaList(-1, "", "get nothing");
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

  Future<void> populateAllDropdowns(int level, DropDownModel dm) async {
    setState(() {
      _selectedGeoUnitId = _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedvastiValue = _linkedupnagarValue = _linkedgraamValue = _linkedmandalValue = null;
    });
    final selection = prepareSelection(dm);

    // Step 2: Vibhaag
    await populatelinkedVibhaagDropdown('');
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
    if (selection.upnagar != null && selection.upnagar!.isNotEmpty) {
      await populatelinkedUpnagarDropdown(_linkednagarValue);
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
    // Step 6: mandal (conditional)
    if (selection.mandal != null && selection.mandal!.isNotEmpty) {
      await populatelinkedMandalDropdown(
          (selection.upnagar != null && selection.upnagar!.isNotEmpty), (selection.upnagar != null && selection.upnagar!.isNotEmpty) ? _linkedupnagarValue! : _linkednagarValue!);
      _selectedGeoUnitId = _linkedmandalValue = (level == 4 ? (dm.geoUnitID ?? "").toString() : selection.mandal) ?? '';
    }
    // Step 7: Graam
    if (selection.graam != null && selection.graam!.isNotEmpty) {
      await populatelinkedGraamDropdown(_linkedmandalValue!);
      _selectedGeoUnitId = _linkedgraamValue = (level == 3 ? (dm.geoUnitID ?? "").toString() : selection.graam) ?? '';
    }
    // Step 8: Vasti
    await populatelinkedVastiDropdown(
        (selection.upnagar != null && selection.upnagar!.isNotEmpty), (selection.upnagar != null && selection.upnagar!.isNotEmpty) ? _linkedupnagarValue! : _linkednagarValue!);
    _selectedGeoUnitId = _linkedvastiValue = (level == 2 ? (dm.geoUnitID ?? "").toString() : selection.vasti) ?? '';

    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedBhaag != null && _linkedBhaag!.isNotEmpty) _linkedbhaagName = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedNagar != null && _linkedNagar!.isNotEmpty) _linkednagarName = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;

    setState(() {});
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    setState(() {
      _linkedbhaagValue = _linkednagarValue = _linkedvastiValue = null;
      _linkedVibhaag = _linkedbhaag = _linkednagar = _linkednagar = null;
      _selctedLevelName = _selectedGeoUnitId = null;
      _selctedLevel = "praant";
    });
    await populatelinkedVibhaagDropdown('');
    if (fromClear || userLevelId == null || ddm == null) {
      print("object is null");
      return;
    }
    print("object is not null >>>>>>>>>>>>>>>>>>>>>>");
    await populateAllDropdowns(userLevelId!, ddm!);
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
    // _linkedvastiName = null;
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

  // void populatelinkedVibhaagDropdown() async {
  //   _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), "", "", "");
  //   setState(() {
  //     _linkedVibhaag = data;
  //   });
  // }
  //
  // void populatelinkedBhaagDropdown(String VibhaagIDStr) async {
  //   _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), VibhaagIDStr, "Vibhaag", "");
  //   setState(() {
  //     _linkedbhaag = data;
  //   });
  // }
  //
  // void populatelinkedShaharDropdown(String bhaagIDStr) async {
  //   _linkedshaharValue = _linkedvastiValue = _linkedshahar = _linkedvasti = null;
  //   var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
  //   setState(() {
  //     _linkedshahar = (shDD.length > 0 ? shDD : null);
  //   });
  // }
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
  // void populatelinkedMandalDropdown(String nagarIDStr) async {
  //   _linkedmandalValue = _linkedgraamValue = null;
  //   _linkedmandal = _linkedgraam = null;
  //   var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
  //   setState(() {
  //     _linkedmandal = (mnDD.length > 0 ? mnDD : null);
  //   });
  // }
  //
  // void populatelinkedGraamDropdown(String mandalIDStr) async {
  //   _linkedgraamValue = null;
  //   var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
  //   setState(() {
  //     _linkedgraam = (gmDD.length > 0 ? gmDD : null);
  //   });
  // }
  //
  // void populatelinkedVastiDropdown(String nagarIDStr) async {
  //   _linkedvastiValue = null;
  //   var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
  //   setState(() {
  //     _linkedvasti = (vsDD.length > 0 ? vsDD : null);
  //   });
  // }

  Future<void> _search(String strType, var ctx) async {
    setState(() {
      _isSearching = true;
    });
    int? vibhaagVal = (_linkedVibhaagValue != null && _linkedVibhaagValue != "") ? int.parse(_linkedVibhaagValue!) : null;
    int? bhaagVal = (_linkedbhaagValue != null && _linkedbhaagValue != "") ? int.parse(_linkedbhaagValue!) : null;
    int? shaharVal = (_linkedshaharValue != null && _linkedshaharValue != "") ? int.parse(_linkedshaharValue!) : null;
    int? nagarVal = (_linkednagarValue != null && _linkednagarValue != "") ? int.parse(_linkednagarValue!) : null;
    int? mandalVal = (_linkedmandalValue != null && _linkedmandalValue != "") ? int.parse(_linkedmandalValue!) : null;
    int? graamVal = (_linkedgraamValue != null && _linkedgraamValue != "") ? int.parse(_linkedgraamValue!) : null;
    int? vastiVal = (_linkedvastiValue != null && _linkedvastiValue != "") ? int.parse(_linkedvastiValue!) : null;

    int? geoUnitID;
    geoUnitID = vibhaagVal != null
        ? vibhaagVal
        : vastiVal != null
            ? vastiVal
            : graamVal != null
                ? graamVal
                : mandalVal != null
                    ? mandalVal
                    : nagarVal != null
                        ? nagarVal
                        : shaharVal != null
                            ? shaharVal
                            : bhaagVal != null
                                ? bhaagVal
                                : null;

    if (strType == 'Search') {
      setState(() {
        _sankalanList = _getSankalanVruttaList(geoUnitID, _isSahabhaagiOrVishesh == true ? "VisheshVyakti" : "Participant", _searchController.text);
        _isSearching = false;
        _isExpanded = false;
      });
    } else {
      var datalist = await _getSankalanVruttaList(geoUnitID!, _isSahabhaagiOrVishesh == true ? "VisheshVyakti" : "Participant", _searchController.text);
      _getCsv(datalist);
      setState(() {
        _isSearching = false;
        _isExpanded = false;
      });
    }
  }

  Future<List<dynamic>> _getSankalanVruttaList(int? geoUnitID, String strType, String searchString) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({"GeoUnitID": geoUnitID == null ? -1 : geoUnitID, "ParticipantOrVisheshVyakti": strType, "SearchString": searchString});
      print("strInput:----  $strInput");
      return Statics.getNidhiSankalanVruttaForApp(strInput);
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  void _getCsv(dataList) {
    setState(() {
      _isSearching = true;
    });
    if (dataList == null || dataList.length == 0) {
      Statics.showMessageDialog(context, Statics.getLabel('noDataFoundTryAnotherSearch'));

      setState(() {
        _isSearching = false;
      });
      return;
    }
    List<List<dynamic>> rows = [];
    List<dynamic> header = [];
    header.add("GeoUnit Name");
    header.add("Name");
    header.add("Mobile");
    if (_isSahabhaagiOrVishesh == true) {
      header.add("Category");
      header.add("Remark");
      header.add("Created By");
    } else {
      header.add("Gender");
    }

    rows.add(header);
    for (int i = 0; i < dataList.length; i++) {
      var data = dataList[i];

      //row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = [];
      row.add(data["GeoUnitName"].toString());
      row.add(data["PersonName"].toString());
      row.add(data["MobileNumber"].toString());
      if (_isSahabhaagiOrVishesh == true) {
        row.add(data["CategoryCode"].toString());
        row.add(data["Remark"].toString());
        row.add(data["CreatedByName"].toString());
      } else {
        row.add(data["GenderCode"].toString());
      }

      rows.add(row);
    }

    if (rows.length > 1) {
      Statics.convertToCsv(rows, (_isSahabhaagiOrVishesh == true ? "VisheshVyakti" : "SahabhaagiKaaryakartaa") + "_" + DateFormat('ddmmyyyyHHmmss').format(DateTime.now()), context);
    }
    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('searchRamJanmabhoomiNidhiSankalanVrutta'),
            style: TextStyle(fontSize: 24),
          ),
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
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
                          if (_linkedVibhaag != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                              isExpanded: true,
                              value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                              items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: MyAppGlobals.isDropdownDisabled('Vibhaag')
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _linkedVibhaagValue = value.toString();
                                        populatelinkedBhaagDropdown(value.toString());
                                      });
                                    },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                              isExpanded: true,
                              value: _linkedbhaagValue == "" ? null : _linkedbhaagValue,
                              items: _linkedbhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: MyAppGlobals.isDropdownDisabled('Bhaag')
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _linkedbhaagValue = value.toString();

                                        populatelinkedNagarDropdown(value.toString(), null);
                                      });
                                    },
                            ),
                          if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          // if (_linkedshahar != null && _linkedshahar!.length > 0)
                          //   DropdownButtonFormField(
                          //     decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                          //     isExpanded: true,
                          //     value: _linkedshaharValue == "" ? null : _linkedshaharValue,
                          //     items: _linkedshahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                          //     onChanged: (value) {
                          //       setState(() {
                          //         _linkedshaharValue = value;
                          //         populatelinkedNagarDropdown(null, value!);
                          //       });
                          //     },
                          //   ),
                          // if (_linkedshahar != null && _linkedshahar!.length > 0)
                          //   SizedBox(
                          //     height: 10,
                          //   ),
                          if (_linkednagar != null && _linkednagar!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                              isExpanded: true,
                              value: _linkednagarValue == "" ? null : _linkednagarValue,
                              items: _linkednagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: MyAppGlobals.isDropdownDisabled('Nagar')
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _linkednagarValue = value.toString();
                                        populatelinkedMandalDropdown(false, value.toString());
                                        populatelinkedVastiDropdown(false, value.toString());
                                        populatelinkedUpnagarDropdown(value.toString());
                                      });
                                    },
                            ),
                          if (_linkednagar != null && _linkednagar!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          if (_linkedupnagar != null && _linkedupnagar!.isNotEmpty)
                            buildDropdownField(
                              isDisabled: false,
                              label: Statics.getLabel('upnagarUpkhanda'),
                              value: _linkedupnagarValue,
                              items: _linkedupnagar!
                                  .map((bg) => DropdownMenuItem(
                                        value: bg.geoUnitID.toString(),
                                        child: Text(bg.name!),
                                      ))
                                  .toList(),
                              onChanged: MyAppGlobals.isDropdownDisabled('upnagarUpkhanda')
                                  ? null
                                  : (value) {
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
                          if (_linkedupnagar != null && _linkedupnagar!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          if (_linkedmandal != null && _linkedmandal!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Mandal')),
                              isExpanded: true,
                              value: _linkedmandalValue == "" ? null : _linkedmandalValue,
                              items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: MyAppGlobals.isDropdownDisabled('Mandal')
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _linkedmandalValue = value.toString();
                                        populatelinkedGraamDropdown(value.toString());
                                      });
                                    },
                            ),
                          if (_linkedmandal != null && _linkedmandal!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          if (_linkedgraam != null && _linkedgraam!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Graam')),
                              isExpanded: true,
                              value: _linkedgraamValue,
                              items: _linkedgraam!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: MyAppGlobals.isDropdownDisabled('Graam')
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _linkedgraamValue = value.toString();
                                      });
                                    },
                            ),
                          if (_linkedvasti != null && _linkedvasti!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Vasti')),
                              isExpanded: true,
                              value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                              items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: MyAppGlobals.isDropdownDisabled('Vasti')
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _linkedvastiValue = value.toString();
                                      });
                                    },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  (_isSahabhaagiOrVishesh == false ? Statics.getLabel('SahabhaagiKaaryakartaa') : Statics.getLabel('VisheshVyakti')),
                                ),
                              ),
                              FlutterSwitch(
                                activeText: Statics.getLabel('VisheshVyakti'),
                                inactiveText: Statics.getLabel('SahabhaagiKaaryakartaa'),
                                value: _isSahabhaagiOrVishesh,
                                activeToggleColor: Color(0xFF6E40C9),
                                inactiveToggleColor: Color(0xFFffffff),
                                activeColor: Color(0xFFffffff),
                                inactiveColor: Color(0xFF6E40C9),
                                activeTextColor: Color(0xFF6E40C9),
                                inactiveTextColor: Color(0xFFffffff),
                                switchBorder: Border.all(
                                  color: Color(0xFF6E40C9),
                                ),
                                valueFontSize: 10.0,
                                width: 110,
                                borderRadius: 30.0,
                                showOnOff: true,
                                onToggle: (val) {
                                  setState(() {
                                    _isSahabhaagiOrVishesh = val;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _searchController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(labelText: Statics.getLabel('searchRJBSVNameMobileLabel')),
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
                            onPressed: () {
                              _search("Search", context);
                            },
                            child: Text(
                              Statics.getLabel('Search'),
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                            onPressed: () {
                              _search("ExportToExcel", context);
                            },
                            child: Wrap(
                              children: [
                                Text(
                                  Statics.getLabel("ExportToExcel"),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          MaterialButton(
                              onPressed: () {
                                setState(() {
                                  _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                                  _linkedbhaag = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                                  _searchController.text = "";
                                });
                                populatelinkedVibhaagDropdown('');
                              },
                              child: Text(Statics.getLabel('clear'))),
                        ],
                      ),
                  ],
                ),
              ),
              FutureBuilder<List<dynamic>>(
                future: _sankalanList,
                builder: (ctx, dataSnapshot) {
                  print(dataSnapshot.connectionState.toString());
                  print(dataSnapshot.hasData.toString());
                  print(_isSearching.toString());
                  if (dataSnapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (dataSnapshot.hasError) {
                    print(dataSnapshot.error);
                    return Center(
                        child: Text(
                      'Server Error, Please Try Again Later',
                      style: TextStyle(color: Colors.red),
                    ));
                  }
                  return dataSnapshot.hasData && dataSnapshot.data!.length > 0
                      ? Column(
                          children: dataSnapshot.data!.map((sankalan) => NidhiSankalanCard(sankalan, (_isSahabhaagiOrVishesh == false ? 'SahabhaagiKaaryakartaa' : 'VisheshVyakti'), _search)).toList(),
                        )
                      : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
                },
              ),
            ],
          ),
        ));
  }
}
