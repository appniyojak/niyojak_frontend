import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../dialogs/levelwise_dropdown.dart';
import '../helpers/static_data.dart' as Statics;
import '../providers/bals.dart';
import '../screens/edit_shaakhaa.dart';
import '../screens/maps_display.dart';
import '../widgets/app_drawer.dart';
import '../widgets/shaakhaa_card.dart';

class SearchShaakhaaScreen extends StatefulWidget {
  static const routeName = '/search-shaakhaa-screen';

  @override
  _SearchSShaakhaaScreenState createState() => _SearchSShaakhaaScreenState();
}

class _SearchSShaakhaaScreenState extends State<SearchShaakhaaScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;

  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";

  List<StaticMasterBAL>? _vayogat;
  List<StaticMasterBAL>? _frequency;
  List shakhaSapMasSanghList = [];

  String? _vayogatValue;
  String? _frequencyValue;
  String? geoUnitIDnew;

  bool _isExpanded = false;

  Future<List<dynamic>>? _shaakhaaList;
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
    populateDropdown();

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
      _shaakhaaList = _getshaakhaaList(-1, "get nothing", null, null);
    }
  }

  void populateDropdown() async {
    var data = await Statics.getStaticLDB('ShaakhaaVayogat');
    var data1 = await Statics.getStaticLDB('ShaakhaaFrequency');
    populatelinkedBhaagDropdown();
    if (!mounted) return;
    setState(() {
      _vayogat = data;
      _frequency = data1;
    });
  }

  // void populatelinkedBhaagDropdown() async {
  //   _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), "", "", "");
  //   setState(() {
  //     _linkedbhaag = data;
  //   });
  // }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown() async {
    _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), "", "", "");
    setState(() {
      _linkedbhaag = data;
    });
    return data;
  }

  void populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedshaharValue = _linkedvastiValue = _linkedshahar = _linkedvasti = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _linkedshahar = (shDD.length > 0 ? shDD : null);
    });
  }

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

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
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

  // void populatelinkedMandalDropdown(String nagarIDStr) async {
  //   _linkedmandalValue = _linkedgraamValue = null;
  //   _linkedmandal = _linkedgraam = null;
  //   var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
  //   setState(() {
  //     _linkedmandal = (mnDD.length > 0 ? mnDD : null);
  //   });
  // }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(String nagarIDStr) async {
    _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  // void populatelinkedGraamDropdown(String mandalIDStr) async {
  //   _linkedgraamValue = null;
  //   var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
  //   setState(() {
  //     _linkedgraam = (gmDD.length > 0 ? gmDD : null);
  //   });
  // }
  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  // void populatelinkedVastiDropdown(String nagarIDStr) async {
  //   _linkedvastiValue = null;
  //   var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
  //   setState(() {
  //     _linkedvasti = (vsDD.length > 0 ? vsDD : null);
  //   });
  //   print(vsDD);
  // }
  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
    return vsDD;
  }

  Future<void> _search(String strType, var ctx) async {
    setState(() {
      _isSearching = true;
    });

    int? bhaagVal = _linkedbhaagValue == null || _linkedbhaagValue == "" ? null : int.parse(_linkedbhaagValue!);
    int? shaharVal = _linkedshaharValue == null || _linkedshaharValue == "" ? null : int.parse(_linkedshaharValue!);
    int? nagarVal = _linkednagarValue == null || _linkednagarValue == "" ? null : int.parse(_linkednagarValue!);

    int? mandalVal = _linkedmandalValue == null || _linkedmandalValue == "" ? null : int.parse(_linkedmandalValue!);

    int? graamVal = _linkedgraamValue == null || _linkedgraamValue == "" ? null : int.parse(_linkedgraamValue!);

    int? vastiVal = _linkedvastiValue == null || _linkedvastiValue == "" ? null : int.parse(_linkedvastiValue!);

    int? frequencyVal = _frequencyValue == null || _frequencyValue == "" ? null : int.parse(_frequencyValue!);

    int? vayogatVal = _vayogatValue == null || _vayogatValue == "" ? null : int.parse(_vayogatValue!);

    int? geoUnitID;
    geoUnitID = vastiVal != null
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

    if (strType == "Search") {
      if (mandalVal == null && graamVal == null && vastiVal == null) {
        print("Search :-  ${geoUnitIDnew}");
      } else {
        print("mandalVal :-  ${mandalVal}");
        print("graamVal :-  ${graamVal}");
        print("vastiVal :-  ${vastiVal}");
      }

      setState(() {
        if (mandalVal == null && graamVal == null && vastiVal == null) {
          print("Search :-  ${geoUnitIDnew}");
          _shaakhaaList = _getshaakhaaList(int.parse(geoUnitIDnew!), _searchController.text, frequencyVal, vayogatVal);
        } else {
          _shaakhaaList = _getshaakhaaList(geoUnitID, _searchController.text, frequencyVal, vayogatVal);
          print("mandalVal :-  ${mandalVal}");
          print("graamVal :-  ${graamVal}");
          print("vastiVal :-  ${vastiVal}");
        }
        // _shaakhaaList = _getshaakhaaList(
        //     geoUnitID, _searchController.text, frequencyVal, vayogatVal);
        _isSearching = false;
        _isExpanded = false;
        print(_shaakhaaList);
      });
    } else {
      print("ViewLocation :-  $geoUnitID");
      var dataList = await _getshaakhaaList(geoUnitID, _searchController.text, frequencyVal, vayogatVal);
      print("dataList $dataList");
      if (dataList.isEmpty) {
        Statics.showErrorDialog(context, Statics.getLabel("noDataFoundTryAnotherSearch"));
        setState(() {
          _isSearching = false;
        });
        return;
      }
      setState(() {
        _isSearching = false;
        _isExpanded = false;
      });
      viewLocation(dataList, ctx);
    }
  }

  void _getCsv() async {
    // setState(() {
    //   _isfetingData = true;
    // });

    // Await the future resolution to get the actual list
    List<dynamic> dataList = await _shaakhaaList!;

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
      List<GeoUnitMasterBAL> bhagList = await populatelinkedBhaagDropdown() ?? [];
      List<GeoUnitMasterBAL> nagarList = await populatelinkedNagarDropdown(data["ParentBhaagID"].toString(), null);
      List<GeoUnitMasterBAL> mandalList = await populatelinkedMandalDropdown(data["ParentNagarID"].toString()) ?? [];
      List<GeoUnitMasterBAL> gramList = await populatelinkedGraamDropdown(data["ParentMandalID"].toString()) ?? [];
      List<GeoUnitMasterBAL> vastiList = await populatelinkedVastiDropdown(data["ParentNagarID"].toString()) ?? [];
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
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('searchShaakhaaScreenLabel'),
            style: TextStyle(fontSize: 24),
          ),
          actions: <Widget>[
            if (((Statics.userDetails['LevelName'] == 'Praant' ||
                        Statics.userDetails['LevelName'] == 'Mahaanagar' ||
                        Statics.userDetails['LevelName'] == 'Bhaag' ||
                        Statics.userDetails['LevelName'] == 'Vibhaag' ||
                        Statics.userDetails['LevelName'] == 'प्रांत' ||
                        Statics.userDetails['LevelName'] == 'महानगर' ||
                        Statics.userDetails['LevelName'] == 'भाग/जिल्हा' ||
                        Statics.userDetails['LevelName'] == 'विभाग' ||
                        Statics.userDetails['LevelName'] == 'Praant' ||
                        Statics.userDetails['LevelName'] == 'विभाग' ||
                        Statics.userDetails['LevelName'] == 'प्रांत' ||
                        Statics.userDetails['LevelName'] == 'Bhaag' ||
                        Statics.userDetails['LevelName'] == 'भाग/जिल्हा' ||
                        Statics.userDetails['LevelName'] == 'Nagar/Taalukaa' ||
                        Statics.userDetails['LevelName'] == 'Nagar' ||
                        Statics.userDetails['LevelName'] == 'Nagar/Taalukaa' ||
                        Statics.userDetails['LevelName'] == 'नगर/तालुका') &&
                    (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
                        Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
                        Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
                        Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
                        Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' ||
                        Statics.userDetails['DaayitvaName'] == 'कार्यवाह' ||
                        Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
                        Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
                        Statics.userDetails['DaayitvaName'] == 'Saha-Kaaryavaah' ||
                        Statics.userDetails['DaayitvaName'] == 'सह कार्यवाह' ||
                        Statics.userDetails['DaayitvaName'] == 'Baal Vidyaarthi Pramukh' ||
                        Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'Mahaavidyaalayeen Vidyaarthi Pramukh' ||
                        Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Pramukh' ||
                        Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Saha-Pramukh' ||
                        Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Pramukh' ||
                        Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Pramukh' ||
                        Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Sah Pramukh' ||
                        Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Sah Pramukh' ||
                        Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'Bal Vidyarthi Sah Pramukh' ||
                        Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'Mahavidyaleen Vidyarthi Sah Pramukh' ||
                        Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
                        Statics.userDetails['DaayitvaName'] == 'App Sanyojak' ||
                        Statics.userDetails['DaayitvaName'] == 'एप संयोजक' ||
                        Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' ||
                        Statics.userDetails['DaayitvaName'] == 'कार्यालय प्रमुख')) ||
                (Statics.userDetails['LevelName'] == 'Praant' ||
                    Statics.userDetails['LevelName'] == 'प्रांत' && Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
                    Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
                    Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
                    Statics.userDetails['DaayitvaName'] == 'Baal Vidyaarthi Pramukh' ||
                    Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'Mahaavidyaalayeen Vidyaarthi Pramukh' ||
                    Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Pramukh' ||
                    Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Saha-Pramukh' ||
                    Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Pramukh' ||
                    Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Pramukh' ||
                    Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Sah Pramukh' ||
                    Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Sah Pramukh' ||
                    Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'Bal Vidyarthi Sah Pramukh' ||
                    Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'Mahavidyaleen Vidyarthi Sah Pramukh' ||
                    Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'App Sanyojak' ||
                    Statics.userDetails['DaayitvaName'] == 'एप संयोजक') ||
                (Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
                    Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
                    Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||
                    Statics.userDetails['DaayitvaName'] == 'सह प्रचारक'))
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.all(8),
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).pushNamed(EditShaakhaaScreen.routeName, arguments: Statics.ScreenArguments(0, Statics.getLabel('EditMenu')));
                    },
                  ),
                ],
              ),
          ],
        ),
        drawer: AppDrawer(),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
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

                              // if(_linkedbhaag != null)
                              // DropdownButtonFormField(
                              //   decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                              //   isExpanded: true,
                              //   value: _linkedbhaagValue == "" ? null : _linkedbhaagValue,
                              //   items: _linkedbhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              //   onChanged: (value) {
                              //     setState(() {
                              //       _linkedbhaagValue = value;
                              //       populatelinkedShaharDropdown(value!);
                              //       populatelinkedNagarDropdown(value, null);
                              //     });
                              //   },
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // if (_linkedshahar != null && _linkedshahar!.length > 0)
                              //   DropdownButtonFormField(
                              //     decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                              //     isExpanded: true,
                              //     value: _linkedshaharValue == "" ? null : _linkedshaharValue,
                              //     items: _linkedshahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              //     onChanged: (value) {
                              //       setState(() {
                              //         _linkedshaharValue = value;
                              //         populatelinkedNagarDropdown(null, value);
                              //       });
                              //     },
                              //   ),
                              // if (_linkedshahar != null && _linkedshahar!.length > 0)
                              //   SizedBox(
                              //     height: 10,
                              //   ),
                              // if (_linkednagar != null && _linkednagar!.length > 0)
                              //   DropdownButtonFormField(
                              //     decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                              //     isExpanded: true,
                              //     value: _linkednagarValue == "" ? null : _linkednagarValue,
                              //     items: _linkednagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              //     onChanged: (value) {
                              //       setState(() {
                              //         _linkednagarValue = value;
                              //         populatelinkedMandalDropdown(value!);
                              //         populatelinkedVastiDropdown(value);
                              //       });
                              //     },
                              //   ),
                              LevelWiseDropdown(
                                onFinalSelection: (String level, String? geoUnitID) {
                                  print("geoUnitID :- $geoUnitID");
                                  setState(() {
                                    geoUnitIDnew = geoUnitID;
                                    populatelinkedMandalDropdown(geoUnitID!);
                                    populatelinkedVastiDropdown(geoUnitID);
                                  });
                                },
                              ),
                              // if (_linkednagar != null &&
                              //     _linkednagar!.length > 0)
                              //   SizedBox(
                              //     height: 10,
                              //   ),
                              // if (_linkedmandal != null &&
                              //     _linkedmandal!.length > 0)
                              //   DropdownButtonFormField(
                              //     decoration: InputDecoration(
                              //         labelText: Statics.getLabel('Mandal')),
                              //     isExpanded: true,
                              //     value: _linkedmandalValue == ""
                              //         ? null
                              //         : _linkedmandalValue,
                              //     items: _linkedmandal!
                              //         .map((bg) => DropdownMenuItem(
                              //             value: bg.geoUnitID.toString(),
                              //             child: Text(bg.name!)))
                              //         .toList(),
                              //     onChanged: (value) {
                              //       setState(() {
                              //         _linkedmandalValue = value;
                              //         populatelinkedGraamDropdown(value!);
                              //       });
                              //     },
                              //   ),
                              // if (_linkedmandal != null &&
                              //     _linkedmandal!.length > 0)
                              //   SizedBox(
                              //     height: 10,
                              //   ),
                              // if (_linkedgraam != null &&
                              //     _linkedgraam!.length > 0)
                              //   DropdownButtonFormField(
                              //     decoration: InputDecoration(
                              //         labelText: Statics.getLabel('Graam')),
                              //     isExpanded: true,
                              //     value: _linkedgraamValue == ""
                              //         ? null
                              //         : _linkedgraamValue,
                              //     items: _linkedgraam!
                              //         .map((bg) => DropdownMenuItem(
                              //             value: bg.geoUnitID.toString(),
                              //             child: Text(bg.name!)))
                              //         .toList(),
                              //     onChanged: (value) {
                              //       setState(() {
                              //         _linkedgraamValue = value;
                              //       });
                              //     },
                              //   ),
                              // if (_linkedvasti != null &&
                              //     _linkedvasti!.length > 0)
                              //   DropdownButtonFormField(
                              //     decoration: InputDecoration(
                              //         labelText: Statics.getLabel('Vasti')),
                              //     isExpanded: true,
                              //     value: _linkedvastiValue == ""
                              //         ? null
                              //         : _linkedvastiValue,
                              //     items: _linkedvasti!
                              //         .map((bg) => DropdownMenuItem(
                              //             value: bg.geoUnitID.toString(),
                              //             child: Text(bg.name!)))
                              //         .toList(),
                              //     onChanged: (value) {
                              //       setState(() {
                              //         _linkedvastiValue = value;
                              //       });
                              //     },
                              //   ),

//======================================================================================================================
                              if (_frequency != null)
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
                              ),
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
                    child: Column(
                      children: [
                        if (_isSearching == true)
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
                              // Text(
                              //     "${Statics.userDetails['LevelID']} ---${Statics.userDetails['LevelName']} --- $geoUnitIDnew"),
                              MaterialButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 8,
                                ),
                                color: Theme.of(context).primaryColor,
                                textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                                onPressed: () {
                                  _search("ViewLocation", context);
                                },
                                child: Wrap(
                                  children: [
                                    Icon(
                                      Icons.location_pin,
                                      color: Theme.of(context).primaryTextTheme.labelMedium?.color,
                                    ),
                                    Text(
                                      Statics.getLabel("MapView"),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        MaterialButton(
                            onPressed: () {
                              print("clear button pressed");
                              setState(() {
                                _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                                _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                                _searchController.text = "";
                                geoUnitIDnew = "";
                                _isSearching = false;
                              });
                              _frequencyValue = null;
                              _vayogatValue = null;
                              _shaakhaaList = _getshaakhaaList(-1, "get nothing", null, null);
                              populatelinkedBhaagDropdown();
                              _isExpanded = false;
                            },
                            child: Text(Statics.getLabel('clear'))),
                      ],
                    ),
                  ),
                FutureBuilder<List<dynamic>>(
                  future: _shaakhaaList,
                  builder: (ctx, dataSnapshot) {
                    if (dataSnapshot.connectionState != ConnectionState.done) {
                      return _isSearching == true ? CircularProgressIndicator() : Container();
                    }
                    if (dataSnapshot.hasError) {
                      print("  dataSnapshot  ${dataSnapshot}  ");
                      return Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
                    }
                    return dataSnapshot.hasData && dataSnapshot.data!.length > 0
                        ? Column(
                            children: dataSnapshot.data!.map((shaakhaa) => ShaakhaaCard(shaakhaa, shaakhaa['IsSankalpit'], _search)).toList(),
                          )
                        : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton:
            // tulnatmakBaithakResponse != null ?
            FloatingActionButton(
          mini: true,
          tooltip: Statics.getLabel("ExportToExcel"),
          onPressed: () async {
            _getCsv();
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CSV file saved successfully')));
          },
          child: Icon(Icons.download_sharp),
          backgroundColor: Colors.green,
        )
        // :Container(),
        );
  }
}
