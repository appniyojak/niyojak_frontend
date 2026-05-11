import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanListResponse.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanLoginDataResponse.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanSwayamsevakListResponse.dart';
import 'package:niyojak_prod/providers/bals.dart';
import 'package:niyojak_prod/providers/swayamsevak_provider.dart';
import 'package:niyojak_prod/widgets/swayamsevak_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/static_data.dart' as Statics;
import 'AbhiyanAddSwayamsevak.dart';
import 'AddGruhaSamparkScreen.dart';

class AbhiyaanSwayamsevak extends StatefulWidget {
  static const routeName = '/abhiyan-swayamsevak';

  const AbhiyaanSwayamsevak({Key? key}) : super(key: key);

  @override
  State<AbhiyaanSwayamsevak> createState() => _AbhiyaanSwayamsevakState();
}

class _AbhiyaanSwayamsevakState extends State<AbhiyaanSwayamsevak> {
  List<MenuChoices> choices = [MenuChoices("EditMenu", Icons.add, "सहभागी कार्यकर्ता जोडा")];
  List<AbhiyanSwayamsevakList> abhiyaanSwayamsevakDataList = [];
  String? selectedSwayamAbhiyanValue = "";
  bool? _isSearching = false;
  String? selectedDayitvValue = "";
  List<AbhiyaanList> abhiyaanDataList = [];
  Future<List<dynamic>>? _swList;
  List<String> strEmail = [];
  List<String> strMobile = [];
  List<LevelMasterBAL>? _level;
  List<GeoUnitMasterBAL>? _geoUnits;

  TextEditingController mobileNoCOntroller = TextEditingController();
  String? _levelValue = "";
  String? _geoUnitsValue = "";

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
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
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";
  bool _isExpanded = false;

  AbhiyanSwayamsevakdata? initialData;

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
          selectedSwayamAbhiyanValue = abhiyaanDataList.first.abhiyaanID.toString();

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

  bool _isSelectAll = false;

  void onCheckCard(var emailID, var mobileNum, var val) {
    if (!strEmail.contains(emailID)) {
      strEmail.add(emailID);
    }
    if (!strMobile.contains(mobileNum)) {
      strMobile.add(mobileNum);
    }
  }

  void onUnCheckCard(var emailID, var mobileNum, var val) {
    if (strEmail.contains(emailID)) {
      strEmail.remove(emailID);
    }
    if (strMobile.contains(mobileNum)) {
      strMobile.remove(mobileNum);
    }
  }

  void onSelectAll(value) {
    _swList!.then((dataList) {
      for (var data in dataList) {
        if (value == true)
          onCheckCard(data["Email"], data["MobileNumber"], "");
        else
          onUnCheckCard(data["Email"], data["MobileNumber"], "");
      }
    });
    setState(() {
      _isSelectAll = value;
    });
  }

  void populateGeoUnits(String levelID) async {
    var data4;
    if (levelID == "") {
      data4 = await Statics.getGeoUnitsByLevel(Statics.levels['MahaanagarLevelID']);
    } else
      data4 = await Statics.getGeoUnitsByLevel(levelID);
    if (!mounted) return;
    setState(() {
      _geoUnits = data4;
    });
  }

  void onMenuSelected(MenuChoices choice) async {
    print(choice.menuType);
    if (choice.menuType == "EditMenu") {
      Navigator.of(context).pushNamed(AbhiyanAddSwayamsevakScreen.routeName).then((value) {
        if (abhiyaanSwayamsevakDataList.isNotEmpty) {
          getAbhiyaanSwayamsevakListData();
        }
      });
    } else if (choice.menuType == "AddGruha") {
      Navigator.of(context).pushNamed(AddGruhaSamparkScreen.routeName);
    }
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

  Future<void> populateDropdown() async {
    // var data2 = await Statics.getLevelLDB();
    // data2.removeWhere((element) => element.levelName == "Shaakhaa");
    // data2.removeWhere((element) => element.levelName == "Shahar");
    // data2.removeWhere((element) => element.levelName == "Kshetra");
    // data2.removeWhere((element) => element.levelName == "Akhil Bhaaratiya");
    // setState(() {
    //   _level = data2;
    // });
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
        // if (initialData!.parentMahaanagarID != null) {
        //   _isExpanded = true;
        //   _linkedMahaanagarDisable = true;
        //   _linkedMahaanagarValue = initialData!.parentMahaanagarID.toString();
        // }
        if (initialData!.parentVibhaagID != null) {
          populatelinkedVibhaagDropdown('');
          _isExpanded = true;
          _linkedVibhaagDisable = true;
          _linkedVibhaagValue = initialData!.parentVibhaagID.toString();
        }
        if (initialData!.parentBhaagID != null) {
          _isExpanded = true;
          _linkedbhaagDisable = true;
          _linkedbhaagValue = initialData!.parentBhaagID.toString();
          populatelinkedNagarDropdown(_linkedbhaagValue, null);
        }
        if (initialData!.parentNagarID != null) {
          _isExpanded = true;
          _linkednagarDisable = true;
          _linkednagarValue = initialData!.parentNagarID.toString();
          populatelinkedMandalDropdown(_linkednagarValue);
          populatelinkedVastiDropdown(false, _linkednagarValue);
        }
        if (initialData!.parentMandalID != null) {
          _isExpanded = true;
          _linkedmandalDisable = true;
          _linkedmandalValue = initialData!.parentMandalID.toString();
          populatelinkedGraamDropdown(_linkedmandalValue);
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
          populatelinkedGraamDropdown(_linkedmandalValue);
        } else if (initialData!.levelName == "Nagar" && initialData!.geoUnitID != null) {
          _isExpanded = true;
          _linkednagarDisable = true;
          _linkednagarValue = initialData!.geoUnitID.toString();
          populatelinkedMandalDropdown(_linkednagarValue);
          populatelinkedVastiDropdown(false, _linkednagarValue);
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
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    List<GeoUnitMasterBAL> data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    print("populatelinkedVibhaagDropdown $mahaanagarIDStr");
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
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
// print("populatelinkedNagarDropdown ${bhaagIDStr} == ${shaharIDStr}  ");
    _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    print("shaharIDStr shaharIDStr $shaharIDStr");
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr!, 'Shahar', '');
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

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(String? nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String? mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(bool haveParentUp, String? nagarIDStr) async {
    _linkedvastiValue = null;
    // _linkedvastiName = null;
    var vsDD;
    if (haveParentUp) {
      print("i am in parents upnagar");
      vsDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, "Upnagar", '');
      // print("${mnDD}");
    } else {
      vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, "Nagar", '');
    }
    setState(() => _linkedvasti = vsDD.length > 0 ? vsDD : null);
    return vsDD;
  }

  getAbhiyaanSwayamsevakListData() async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        setState(() {
          _isSearching = true;
        });

        var data = {
          "Abhiyaanid": selectedSwayamAbhiyanValue!.isNotEmpty ? int.parse(selectedSwayamAbhiyanValue!) : 0,
          "Userid": initialData!.abhiyanSwayamsevakID,
          // "geounitid": _geoUnitsValue.isNotEmpty ? int.parse(_geoUnitsValue) : 0,
          // "levelid": _levelValue.isNotEmpty ? int.parse(_levelValue) : 0,

          "Mahanagar": _linkedMahaanagarValue != null && _linkedMahaanagarValue!.isNotEmpty ? int.parse(_linkedMahaanagarValue!) : 0,
          "Vibhag": _linkedVibhaagValue != null && _linkedVibhaagValue!.isNotEmpty ? int.parse(_linkedVibhaagValue!) : 0,
          "BhaagID": _linkedbhaagValue != null && _linkedbhaagValue!.isNotEmpty ? int.parse(_linkedbhaagValue!) : 0,
          "NagarID": _linkednagarValue != null && _linkednagarValue!.isNotEmpty ? int.parse(_linkednagarValue!) : 0,
          "MandalID": _linkedmandalValue != null && _linkedmandalValue!.isNotEmpty ? int.parse(_linkedmandalValue!) : 0,
          "VastiID": _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? int.parse(_linkedvastiValue!) : 0,
          "GramID": _linkedgraamValue != null && _linkedgraamValue!.isNotEmpty ? int.parse(_linkedgraamValue!) : 0,
          "Daayitva": selectedDayitvValue,
          "MobileNo": mobileNoCOntroller.text
        };

        var result = await SwayamsevakProvider().getAbhiyanSwayamsevakList(jsonEncode(data));
        if (result.status == "200") {
          print("succeed");
          if (result.abhiyanSwayamsevakList!.isEmpty) {
            Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
          } else {
            _isExpanded = false;
            setState(() {});
          }
          abhiyaanSwayamsevakDataList = result.abhiyanSwayamsevakList!.reversed.toList();
          setState(() {
            _isSearching = false;
          });
        } else {
          setState(() {
            _isSearching = false;
          });
          Statics.showToast(result.message);
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

  Future<void> _getCsv() async {
    if (abhiyaanSwayamsevakDataList.isEmpty) {
      Statics.showToast("No data available");
      return null;
    }

    setState(() {
      _isSearching = true;
    });

    List<List<dynamic>> rows = [];
    List<dynamic> header = [];

    header.add('Abhiyan'); //1
    // header.add('Abhiyan Swayamsevak ID');
    // header.add("Swayamsevak ID");
    header.add('Full Name'); //2
    header.add("Mobile Number"); //3
    header.add("E-mail"); //4
    header.add("Daayitva Name"); //5
    // header.add("Level ID");
    // header.add("GeoUnit ID");
    header.add("Sanstha Name"); //6
    header.add("Sanstha Padh"); //7
    header.add("Sanstha Type"); //8
    // header.add("bhaag ID");
    // header.add("nagar ID");
    // header.add("mandal ID");
    // header.add("graam ID");
    // header.add("vasti ID");
    header.add("Mahanagar"); //9
    header.add("Vibhag"); //10
    header.add("Bhaag"); //11
    header.add("Nagar"); //12
    // header.add("Shahar");//13
    header.add("Mandal"); //14
    header.add("Graam"); //15
    header.add("Vasti"); //16

    rows.add(header);

    for (int i = 0; i < abhiyaanSwayamsevakDataList.length; i++) {
      var data = abhiyaanSwayamsevakDataList[i];
      List<dynamic> row = [];

      row.add(abhiyaanDataList.firstWhere((element) => element.abhiyaanID.toString() == selectedSwayamAbhiyanValue).abhiyaanName); //1
      row.add(data.participantName ?? "-"); //2
      row.add(data.participantNumber ?? "-"); //3
      row.add(data.email ?? "-"); //4
      row.add(data.daayityaName ?? "-"); //5
      row.add(data.sansthaName ?? "-"); //6
      row.add(data.sansthaPadh ?? "-"); //7
      row.add(data.sansthaType ?? "-"); //8
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
      List<GeoUnitMasterBAL> mandalList = await populatelinkedMandalDropdown(data.parentNagarID.toString()) ?? [];
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
      Statics.convertToCsv(rows, "AbhiyaanSwayamSevaks" + "_" + DateFormat('ddmmyyyyHHmmss').format(DateTime.now()), context);
    }
    setState(() {
      _isSearching = false;
    });
  }

  // ,String? Vibhag,String? Bhaag,String? Nagar,String? Shahar,String? Mandal,String? Graam,String? Vasti
  Future<List<dynamic>> getMahanagarLeveldata(String? Mahanagar) async {
    List dataList = await Statics.getGeoUnitsByLevelAndParent(Mahanagar.toString(), '', '', '');
    return dataList;
  }

  @override
  void initState() {
    super.initState();
    getInitialData();
    Future.delayed(Duration.zero, () async {
      await getAbhiyaanListData();
    });
    populateDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        mini: true,
        tooltip: Statics.getLabel("ExportToExcel"),
        onPressed: _getCsv,
        child: Icon(Icons.download_sharp),
        backgroundColor: Colors.green,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isSearching!,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "${Statics.getLabel('Abhiyaan')}",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildDropdown(
                        value: selectedSwayamAbhiyanValue,
                        items: abhiyaanDataList.map((value) {
                          return DropdownMenuItem(
                            value: value.abhiyaanID.toString(),
                            child: Text(value.abhiyaanName!),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedSwayamAbhiyanValue = newValue;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 13),
                    _buildExpansionPanel(),
                    SizedBox(height: 13),
                    _buildDayitvaDropdown(),
                    SizedBox(height: 22),
                    _buildActionButtons(),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ];
          },
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (abhiyaanSwayamsevakDataList.isNotEmpty) _buildSummary(),
              if (abhiyaanSwayamsevakDataList.isNotEmpty)
                Expanded(
                  child: _buildSwayamsevakListView(),
                ),
              if (abhiyaanSwayamsevakDataList.isEmpty) SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.88,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black38),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        isDense: true,
        iconSize: 30,
        underline: SizedBox(),
        value: value == "" ? null : value,
        onChanged: onChanged,
        items: items,
      ),
    );
  }

  Widget _buildExpansionPanel() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.88,
      margin: EdgeInsets.symmetric(horizontal: 20),
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
                    _buildDropdownField(
                      label: Statics.getLabel('Mahaanagar'),
                      value: _linkedMahaanagarValue,
                      items: _linkedMahaanagar!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _linkedMahaanagarValue = value;
                          _linkedVibhaagValue = null;
                          _resetLinkedValues();
                          populatelinkedVibhaagDropdown(value!);
                        });
                      },
                      isDisabled: false,
                    ),
                  if (_linkedVibhaag != null)
                    _buildDropdownField(
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
                          _linkedVibhaagValue = value;
                          populatelinkedBhaagDropdown(value!);
                        });
                      },
                      isDisabled: false,
                    ),
                  if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty)
                    _buildDropdownField(
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
                          _linkedbhaagValue = value;
                          populatelinkedShaharDropdown(value!);
                          populatelinkedNagarDropdown(value, null);
                        });
                      },
                      isDisabled: false,
                    ),
                  if (_linkedshahar != null && _linkedshahar!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Shahar'),
                      value: _linkedshaharValue,
                      items: _linkedshahar!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _linkedshaharValue = value;
                          populatelinkedNagarDropdown(null, value);
                        });
                      },
                      isDisabled: false,
                    ),
                  if (_linkednagar != null && _linkednagar!.isNotEmpty)
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
                        setState(() {
                          _linkednagarValue = value;
                          populatelinkedMandalDropdown(value);
                          populatelinkedVastiDropdown(false, value);
                        });
                      },
                      isDisabled: false,
                    ),
                  if (_linkedmandal != null && _linkedmandal!.isNotEmpty)
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
                        setState(() {
                          _linkedmandalValue = value;
                          populatelinkedGraamDropdown(value);
                        });
                      },
                      isDisabled: false,
                    ),
                  if (_linkedgraam != null && _linkedgraam!.isNotEmpty)
                    _buildDropdownField(
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
                          _linkedgraamValue = value;
                        });
                      },
                      isDisabled: false,
                    ),
                  if (_linkedvasti != null && _linkedvasti!.isNotEmpty)
                    _buildDropdownField(
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
                          _linkedvastiValue = value;
                        });
                      },
                      isDisabled: false,
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

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    required bool isDisabled,
  }) {
    return IgnorePointer(
      ignoring: isDisabled,
      child: DropdownButtonFormField(
        decoration: InputDecoration(labelText: label),
        isExpanded: true,
        value: value == "" ? null : value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDayitvaDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('SelectDaayitva')}",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 5),
                padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black38),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  isDense: true,
                  iconSize: 30,
                  underline: SizedBox(),
                  value: selectedDayitvValue == "" ? null : selectedDayitvValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDayitvValue = newValue;
                    });
                  },
                  items: <String>["अभियान प्रमुख", "अभियान सह प्रमुख", "अभियान टोळी सदस्य"].map<DropdownMenuItem<String>>((String value) {
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
            ],
          ),
          SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('mobileNumberLabel')}",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.05,
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 5),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black38),
                ),
                child: TextFormField(
                  controller: mobileNoCOntroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                    contentPadding: EdgeInsets.only(bottom: 12),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          onPressed: () async {
            await getAbhiyaanSwayamsevakListData();
          },
          child: Text(
            "${Statics.getLabel('search')}",
            style: TextStyle(fontSize: 22),
          ),
        ),
        MaterialButton(
          onPressed: () {
            setState(() {
              _resetAllDropdowns();
              _isExpanded = false;
            });
          },
          child: Text(Statics.getLabel('clear')),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Theme.of(context).primaryColor),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "एकुण सहभागी कार्यकर्ते संख्या   :  ${abhiyaanSwayamsevakDataList.length}",
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "सहभागी सज्जन शक्ति संख्या       :  ${abhiyaanSwayamsevakDataList.where((element) => element.swayamsevakID == 0).length}",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Divider(color: Theme.of(context).primaryColor),
      ],
    );
  }

  Widget _buildSwayamsevakListView() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      itemCount: abhiyaanSwayamsevakDataList.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwayamsevakHomeAbhiyanCard(
              swItem: abhiyaanSwayamsevakDataList[index],
              onCheckCard: onCheckCard,
              onUnCheckCard: onUnCheckCard,
              isChecked: _isSelectAll,
              getAbhiyaanSwayamsevakListData: getAbhiyaanSwayamsevakListData,
            ),
            if (index == abhiyaanSwayamsevakDataList.length - 1) SizedBox(height: 60),
          ],
        );
      },
    );
  }

  Future<void> _resetAllDropdowns() async {
    await populatelinkedVibhaagDropdown('');
    _linkedMahaanagarValue = _linkedVibhaagValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
    _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
    mobileNoCOntroller.clear();
    selectedDayitvValue = "";
  }

  void _resetLinkedValues() {
    // _linkedMahaanagarDisable = false;
    // _linkedVibhaagDisable = false;
    _linkedbhaagDisable = false;
    _linkedshaharDisable = false;
    _linkednagarDisable = false;
    _linkedmandalDisable = false;
    _linkedgraamDisable = false;
    _linkedvastiDisable = false;

    _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
  }
}
