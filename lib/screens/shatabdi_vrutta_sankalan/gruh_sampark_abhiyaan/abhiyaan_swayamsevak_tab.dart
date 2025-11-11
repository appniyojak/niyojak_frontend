import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/AbhiyaanListResponse.dart';
import '../../../models/response_model/AbhiyaanLoginDataResponse.dart';
import '../../../models/response_model/AbhiyaanSwayamsevakListResponse.dart';
import '../../../models/response_model/gruh_abhiyaan_vrutta_data_model.dart';
import '../../../models/response_model/vasti_up_data_model.dart';
import '../../../models/response_model/vijayaDashamiInitModel.dart';
import '../../../providers/bals.dart';
import '../vijayadashami/add_vishesh_vyakti.dart';
import 'add_abhiyaan_karyakarta_screen.dart';

class AbhiyaanSwayamsevakTab extends StatefulWidget {
  final AbhiyanSwayamsevakdata? initialData;
  final bool isDaayitva;

  const AbhiyaanSwayamsevakTab({super.key, this.initialData, this.isDaayitva = false});

  @override
  State<AbhiyaanSwayamsevakTab> createState() => _AbhiyaanSwayamsevakTabState();
}

class _AbhiyaanSwayamsevakTabState extends State<AbhiyaanSwayamsevakTab> {
  // List<MenuChoices> choices = [
  //   MenuChoices("EditMenu", Icons.add, "सहभागी कार्यकर्ता जोडा")
  // ];
  late ScrollController _scrollController;

  GruhAbhiyaanVruttaDataModel? gruhAbhiyaanVruttaData;
  List<AbhiyanSwayamsevakList> abhiyaanSwayamsevakDataList = [];
  List<AbhiyanSwayamsevakList> abhiyaanKaryakartaDataList = [];
  List<AbhiyanSwayamsevakList> selectedKaryakartaList = [];

  // List<AbhiyanSwayamsevakList> selectedAbhiyaanSwayamsevakList = [];
  String? selectedSwayamAbhiyanValue = "";
  bool? _isSearching = false;
  String? selectedDayitvValue = "";
  bool _searched = false;
  TextEditingController dateController = TextEditingController();
  TextEditingController samparkitGhareController = TextEditingController();
  TextEditingController vitritKarpatrakController = TextEditingController();
  TextEditingController pustakVikriController = TextEditingController();
  TextEditingController samparkaSahabhagiController = TextEditingController();
  TextEditingController samparkaToliController = TextEditingController();
  List<AbhiyaanList> abhiyaanDataList = [
    AbhiyaanList.fromJson({
      "AbhiyaanID": 1,
      "AbhiyaanName": Statics.getLabel('gruhSamparkAbhiyan') + " (${Statics.getLabel('shatabdiVarsha')})",
      "EndDate": null,
      "EndDateStr": null,
      "PraantID": 1,
      "Remark": "C1-10 Rs, C2-100 Rs, C3-1000 Rs",
      "StartDate": null,
      "StartDateStr": null
    })
  ];
  Future<List<dynamic>>? _swList;
  List<String> strEmail = [];
  List<String> strMobile = [];
  List<LevelMasterBAL>? _level;
  List<GeoUnitMasterBAL>? _geoUnits;

  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  String? _selectedGeoUnitId = '';
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
  String? type;

  String? _linkedNagarValuePopup = '';

  List<Vastisanyaprabhavi> selectedAnyaprabhaviItems = [];
  List<Vastisarsajjanshakti> selectedSajjanshaktiItems = [];

  List<int?> selectedUpnagarList = [];

  Vastisarsajjanshakti? selectedPerson;
  Vastisanyaprabhavi? selectedPrabhavi;

  // AbhiyanSwayamsevakdata? initialData;

  GetVijayadashamiInitModel? data;

  VastiUpDataListModel? vastiUpDataListModel;

  Future<void> getVastiUpDataList() async {
    var inputData = json.encode({
      "AppUserID": Statics.userDetails['userID'],
      "GeoUnitID": int.parse(_linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!),
      "isnagar": int.parse(_linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? "2" : "3"),
    });

    print("_submitForm $inputData");

    vastiUpDataListModel = await Statics.getVastiUpdata(inputData);

    ///

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

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    _scrollController = ScrollController();

    await populateDropdown();
    setState(() {});
    // await _getSwList();
  }

  Future<void> _getSwList() async {
    print("calling");
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      var inputData = {
        "AppUserID": Statics.userDetails["userID"],
        "GeoUnitID": int.parse(_linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!),
        "AbhiyaanDate": DateFormat("dd-MM-yyyy").format(DateFormat("dd/MM/yyyy").parse(dateController.text)).toString(),
      };
      print(jsonEncode(inputData));
      gruhAbhiyaanVruttaData = await Statics.getDataforGruhAbhiyaan(inputData, context: context);
      setState(() {});
      if (gruhAbhiyaanVruttaData?.abhiyaandata != null && gruhAbhiyaanVruttaData?.abhiyaanmodels != null) {
        setState(() {
          samparkitGhareController.text = (gruhAbhiyaanVruttaData?.abhiyaandata?.samparkitghar ?? "").toString();
          vitritKarpatrakController.text = (gruhAbhiyaanVruttaData?.abhiyaandata?.vitaritkarpatra ?? "").toString();
          pustakVikriController.text = (gruhAbhiyaanVruttaData?.abhiyaandata?.pustakvikrisankhya ?? "").toString();
          samparkaSahabhagiController.text = (gruhAbhiyaanVruttaData?.abhiyaandata?.samparkhetusahbhagisankhya ?? "").toString();
          samparkaToliController.text = (gruhAbhiyaanVruttaData?.abhiyaandata?.samparkhetutolisankhya ?? "").toString();

          abhiyaanSwayamsevakDataList = gruhAbhiyaanVruttaData?.abhiyaanmodels ?? [];
          abhiyaanKaryakartaDataList = gruhAbhiyaanVruttaData?.abhiyaanmodels ?? [];
        });

        if (data != null) {
          setState(() {
            selectedSajjanshaktiItems = data!.vastisarsajjanshakti!
                .where(
                  (e) => gruhAbhiyaanVruttaData!.abhiyaandata!.visititAtithiSajjanShaktiids!.split(",").contains(e.pkid.toString()),
                )
                .toList();
            selectedAnyaprabhaviItems = data!.vastisanyaprabhavi!
                .where(
                  (e) => gruhAbhiyaanVruttaData!.abhiyaandata!.visititAtithiAnyaprabhaViLokamids!.split(",").contains(e.pkId.toString()),
                )
                .toList();
          });
        }
      }
    }
  }

  saveGruhAbhiyaanDataFun() async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        var _data = {
          "AbhiyaanDate": DateFormat("dd-MM-yyyy").format(DateFormat("dd/MM/yyyy").parse(dateController.text)).toString(), // e.g. "22-10-2025"
          "GeoUnitID": int.parse(_linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!),
          "SamparkitGhar": int.tryParse(samparkitGhareController.text.isNotEmpty ? samparkitGhareController.text : "0"),
          "VitaritKarpatra": int.tryParse(vitritKarpatrakController.text.isNotEmpty ? vitritKarpatrakController.text : "0"),
          "PustakVikriSankhya": int.tryParse(pustakVikriController.text.isNotEmpty ? pustakVikriController.text : "0"),
          "SamparkhetuSahbhagiSankhya": int.tryParse(samparkaSahabhagiController.text.isNotEmpty ? samparkaSahabhagiController.text : "0"),
          "SamparkhetuToliSankhya": int.tryParse(samparkaToliController.text.isNotEmpty ? samparkaToliController.text : "0"),
          "VisititAtithiSajjanShaktiIDs": selectedSajjanshaktiItems.map((e) => e.pkid).join(","), // comma-separated IDs
          "VisititAtithiAnyaPrabhaviLokamIDs": selectedAnyaprabhaviItems.map((e) => e.pkId).join(","), // comma-separated IDs
          "AppUserID": Statics.userDetails["userID"],
          "AbhiyanSwayamsevakIDs": abhiyaanSwayamsevakDataList.where((e) => e.isSelected).map((item) => item.abhiyanSwayamsevakID.toString()).join(','), // comma-separated IDs
        };

        log(jsonEncode(_data));

        var result = await Statics.saveDataforGruhAbhiyaan(_data, context: context);
        if (result) {
          print("succeed");
        } else {
          Statics.showToast(Statics.getLabel('unableToSaveData'));
        }
      }
    } catch (e) {
      Statics.showToast(Statics.getLabel('unableToSaveData'));
      log(e.toString());
    }
  }

  bool _isSelectAll = false;

  void onCheckCard(var emailID, var mobileNum) {
    if (!strEmail.contains(emailID)) {
      strEmail.add(emailID);
    }
    if (!strMobile.contains(mobileNum)) {
      strMobile.add(mobileNum);
    }
  }

  void onUnCheckCard(var emailID, var mobileNum) {
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
          onCheckCard(data["Email"], data["MobileNumber"]);
        else
          onUnCheckCard(data["Email"], data["MobileNumber"]);
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

  // void onMenuSelected(MenuChoices choice) async {
  //   print(choice.menuType);
  //   if (choice.menuType == "EditMenu") {
  //     Navigator.of(context)
  //         .pushNamed(AbhiyanAddSwayamsevakScreen.routeName)
  //         .then((value) {
  //       if (abhiyaanSwayamsevakDataList.isNotEmpty) {
  //         getAbhiyaanSwayamsevakListData();
  //       }
  //     });
  //   } else if (choice.menuType == "AddGruha") {
  //     Navigator.of(context).pushNamed(AddGruhaSamparkScreen.routeName);
  //   }
  // }

  // getInitialData() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   var data = pref.getString("AbhiyanSwayamsevakData");
  //   print(data);
  //   if (data != null) {
  //     initialData = AbhiyanSwayamsevakdata.fromJson(jsonDecode(data));
  //     setState(() {});
  //   }
  // }

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
    if (widget.initialData != null) {
      setState(() {
        // if (widget.initialData!.parentMahaanagarID != null) {
        //   _isExpanded = true;
        //   _linkedMahaanagarDisable = true;
        //   _linkedMahaanagarValue = widget.initialData!.parentMahaanagarID.toString();
        // }
        // if (widget.initialData!.parentVibhaagID != null) {
        //   populatelinkedVibhaagDropdown('');
        //   _isExpanded = true;
        //   _linkedVibhaagDisable = true;
        //   _linkedVibhaagValue = widget.initialData!.parentVibhaagID.toString();
        // }
        // if (widget.initialData!.parentBhaagID != null) {
        //   _isExpanded = true;
        //   _linkedbhaagDisable = true;
        //   _linkedbhaagValue = widget.initialData!.parentBhaagID.toString();
        //   populatelinkedNagarDropdown(_linkedbhaagValue, null);
        // }
        // if (widget.initialData!.parentNagarID != null) {
        //   _isExpanded = true;
        //   _linkednagarDisable = true;
        //   _linkednagarValue = widget.initialData!.parentNagarID.toString();
        //   populatelinkedMandalDropdown(_linkednagarValue);
        //   populatelinkedVastiDropdown(_linkednagarValue);
        // }
        // if (widget.initialData!.parentMandalID != null) {
        //   _isExpanded = true;
        //   _linkedmandalDisable = true;
        //   _linkedmandalValue = widget.initialData!.parentMandalID.toString();
        //   populatelinkedGraamDropdown(_linkedmandalValue);
        // }
        // if (widget.initialData!.levelName == "Vasti" &&
        //     widget.initialData!.geoUnitID != null) {
        //   _isExpanded = true;
        //   _linkedvastiDisable = true;
        //   _linkedvastiValue = widget.initialData!.geoUnitID.toString();
        // } else if (widget.initialData!.levelName == "Graam" &&
        //     widget.initialData!.geoUnitID != null) {
        //   _isExpanded = true;
        //   _linkedgraamDisable = true;
        //   _linkedgraamValue = widget.initialData!.geoUnitID.toString();
        // } else if (widget.initialData!.levelName == "Mandal" &&
        //     widget.initialData!.geoUnitID != null) {
        //   _isExpanded = true;
        //   _linkedmandalDisable = true;
        //   _linkedmandalValue = widget.initialData!.geoUnitID.toString();
        //   populatelinkedGraamDropdown(_linkedmandalValue);
        // } else if (widget.initialData!.levelName == "Nagar" &&
        //     widget.initialData!.geoUnitID != null) {
        //   _isExpanded = true;
        //   _linkednagarDisable = true;
        //   _linkednagarValue = widget.initialData!.geoUnitID.toString();
        //   populatelinkedMandalDropdown(_linkednagarValue);
        //   populatelinkedVastiDropdown(_linkednagarValue);
        // } else if (widget.initialData!.levelName == "Bhaag" &&
        //     widget.initialData!.geoUnitID != null) {
        //   _isExpanded = true;
        //   _linkedbhaagDisable = true;
        //   _linkedbhaagValue = widget.initialData!.geoUnitID.toString();
        //   populatelinkedNagarDropdown(_linkedbhaagValue, null);
        // } else {
        _isExpanded = true;
        // _linkedgraamDisable = true;
        _linkedbhaagValue = null;
        _linkedshaharValue = null;
        _linkednagarValue = null;
        _linkedmandalValue = null;
        _linkedgraamValue = null;
        _linkedvastiValue = null;
        // }
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

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String? nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
    return vsDD;
  }

  // getAbhiyaanSwayamsevakListData() async {
  //   try {
  //     bool isConnected = await Statics.isInternetConnected();
  //     if (isConnected) {
  //       setState(() {
  //         _isSearching = true;
  //       });
  //
  //       var data = {
  //         "Abhiyaanid": selectedSwayamAbhiyanValue!.isNotEmpty
  //             ? int.parse(selectedSwayamAbhiyanValue!)
  //             : 0,
  //         "Userid": widget.initialData!.abhiyanSwayamsevakID,
  //         // "geounitid": _geoUnitsValue.isNotEmpty ? int.parse(_geoUnitsValue) : 0,
  //         // "levelid": _levelValue.isNotEmpty ? int.parse(_levelValue) : 0,
  //
  //         "Mahanagar": _linkedMahaanagarValue != null &&
  //             _linkedMahaanagarValue!.isNotEmpty
  //             ? int.parse(_linkedMahaanagarValue!)
  //             : 0,
  //         "Vibhag":
  //         _linkedVibhaagValue != null && _linkedVibhaagValue!.isNotEmpty
  //             ? int.parse(_linkedVibhaagValue!)
  //             : 0,
  //         "BhaagID": _linkedbhaagValue != null && _linkedbhaagValue!.isNotEmpty
  //             ? int.parse(_linkedbhaagValue!)
  //             : 0,
  //         "NagarID": _linkednagarValue != null && _linkednagarValue!.isNotEmpty
  //             ? int.parse(_linkednagarValue!)
  //             : 0,
  //         "MandalID":
  //         _linkedmandalValue != null && _linkedmandalValue!.isNotEmpty
  //             ? int.parse(_linkedmandalValue!)
  //             : 0,
  //         "VastiID": _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty
  //             ? int.parse(_linkedvastiValue!)
  //             : 0,
  //         "GramID": _linkedgraamValue != null && _linkedgraamValue!.isNotEmpty
  //             ? int.parse(_linkedgraamValue!)
  //             : 0,
  //         "Daayitva": selectedDayitvValue,
  //         "MobileNo": mobileNoCOntroller.text
  //       };
  //
  //       var result = await SwayamsevakProvider()
  //           .getAbhiyanSwayamsevakList(jsonEncode(data));
  //       if (result.status == "200") {
  //         print("succeed");
  //         if (result.abhiyanSwayamsevakList!.isEmpty) {
  //           Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch')
  //               .split(",")
  //               .first);
  //         } else {
  //           _isExpanded = false;
  //           setState(() {});
  //         }
  //         abhiyaanSwayamsevakDataList =
  //             result.abhiyanSwayamsevakList!.reversed.toList();
  //         setState(() {
  //           _isSearching = false;
  //         });
  //       } else {
  //         setState(() {
  //           _isSearching = false;
  //         });
  //         Statics.showToast(result.message);
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
  //     setState(() {
  //       _isSearching = false;
  //     });
  //     Statics.showToast(
  //         Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
  //   }
  // }

  // ,String? Vibhag,String? Bhaag,String? Nagar,String? Shahar,String? Mandal,String? Graam,String? Vasti
  Future<List<dynamic>> getMahanagarLeveldata(String? Mahanagar) async {
    List dataList = await Statics.getGeoUnitsByLevelAndParent(Mahanagar.toString(), '', '', '');
    return dataList;
  }

  /////////////////////////////////////////// DUMMY DATA /////////////////////////////////////////////
  showDummyList() {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (ct) => StatefulBuilder(
        builder: (ctx, set) => Dialog(
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          // contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          insetPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          // titlePadding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          Statics.getLabel('selectSwayamsevak'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.redAccent),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onPressed: () async {
                          await saveGruhAbhiyaanDataFun();
                          Navigator.pop(ct);
                          Navigator.of(context).pushNamed(AddAbhiyaanKaryakartaScreen.routeName, arguments: "abhiyaanKaryakarta").then((value) async {
                            data = await Statics.getSajjanAndAnyaGuestData(
                                context,
                                Statics.userDetails["userID"],
                                _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!,
                                _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? "2" : "3");
                            setState(() {});
                            // if(Statics.userDetails[])
                            await _getSwList();
                          });
                          // Fluttertoast.showToast(
                          //   msg: Statics.getLabel("workInProgress"),
                          //   toastLength: Toast.LENGTH_SHORT,
                          //   gravity: ToastGravity.BOTTOM,
                          // );
                        },
                        child: Text(
                          Statics.getLabel('addSahabhagiKaryakarta'),
                          style: const TextStyle(color: Colors.purpleAccent),
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onPressed: () async {
                          await saveGruhAbhiyaanDataFun();
                          Navigator.pop(ct);
                          Navigator.of(context).pushNamed(AddAbhiyaanKaryakartaScreen.routeName, arguments: "swayamsevak").then((value) async {
                            data = await Statics.getSajjanAndAnyaGuestData(
                                context,
                                Statics.userDetails["userID"],
                                _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!,
                                _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? "2" : "3");
                            setState(() {});
                            // if(Statics.userDetails[])
                            await _getSwList();
                          });
                          // Navigator.of(context).pushNamed(EditSwayamsevakScreen.routeName, arguments: Statics.ScreenArgumentsNew(0, Statics.getLabel('EditMenu')));
                        },
                        child: Text(
                          Statics.getLabel('AddSwayamsevak'),
                          style: const TextStyle(color: Colors.purpleAccent),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  selectedKaryakartaTable(set),
                  SizedBox(height: 12),
                  swayamsevakAndKaryakartaTable(set),
                  // Flexible(
                  //   child: Container(
                  //     constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.58),
                  //     child: ListView.builder(
                  //       shrinkWrap: true,
                  //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  //       itemCount: abhiyaanSwayamsevakDataList.length,
                  //       itemBuilder: (context, index) {
                  //         final swItem = abhiyaanSwayamsevakDataList[index];
                  //         return Card(
                  //           margin: EdgeInsets.all(5),
                  //           elevation: 5,
                  //           child: CheckboxListTile(
                  //             onChanged: (value) => set(() {
                  //               swItem.isSelected = !swItem.isSelected;
                  //             }),
                  //             value: swItem.isSelected,
                  //             contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  //             title: Text(swItem.participantName.toString()),
                  //             subtitle: Container(
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   SizedBox(
                  //                     height: 5,
                  //                   ),
                  //                   Text(swItem.daayityaName.toString()),
                  //                   SizedBox(
                  //                     height: 5,
                  //                   ),
                  //                   Wrap(direction: Axis.vertical, spacing: 5, children: [
                  //                     RichText(
                  //                       text: TextSpan(
                  //                         text: 'M: ${swItem.participantNumber.toString()}${swItem.email.toString().isNotEmpty ? ',' : ''}',
                  //                         style: TextStyle(color: Colors.blue),
                  //                         recognizer: TapGestureRecognizer()
                  //                           ..onTap = () {
                  //                             UrlLauncher.launch("tel://" + swItem.participantNumber.toString());
                  //                           },
                  //                       ),
                  //                     ),
                  //                     if (swItem.email != null && swItem.email!.isNotEmpty)
                  //                       RichText(
                  //                         text: TextSpan(
                  //                           text: 'E: ${swItem.email.toString()}',
                  //                           style: TextStyle(color: Colors.blue),
                  //                           recognizer: TapGestureRecognizer()
                  //                             ..onTap = () {
                  //                               UrlLauncher.launch("mailto:" + swItem.email.toString());
                  //                             },
                  //                         ),
                  //                       ),
                  //                   ]),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 8),
                  if (abhiyaanSwayamsevakDataList.isNotEmpty)
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
                              Navigator.pop(context);
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget selectedKaryakartaTable(void Function(void Function()) set) {
    final List<String> headers = [
      "",
      Statics.getLabel('Name'),
      Statics.getLabel('daayitvaName'),
      Statics.getLabel('Mobile'),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Statics.getLabel("selectedList"), softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            interactive: true,
            thickness: 5,
            radius: Radius.circular(10),
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: false,
                headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                columnSpacing: 30,
                headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                columns: headers
                    .map((header) => DataColumn(
                          label: Container(
                            constraints: BoxConstraints(minWidth: 30, maxWidth: header == headers.first ? 80 : 200),
                            // constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.2),
                            child: Text(header, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ))
                    .toList(),
                rows: selectedKaryakartaList.asMap().entries.map((entry) {
                  int index = entry.key;
                  var data = entry.value;
                  // bool isSelected = selectedGramVastiListRowIndex == index;
                  return DataRow(
                      selected: data.isSelected,
                      color: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (data.isSelected) return Colors.yellow.shade100;
                          return null;
                        },
                      ),
                      cells: [
                        DataCell(
                          InkWell(
                            onTap: () {
                              set(() {
                                selectedKaryakartaList.remove(data);
                              });
                            },
                            child: Icon(Icons.delete_forever_outlined, color: Colors.red, size: 21),
                          ),
                        ),
                        DataCell(Text(data.participantName == "" ? "--" : (data.participantName ?? "--"))),
                        DataCell(Text(data.daayityaName == "" ? "--" : (data.daayityaName ?? "--"))),
                        DataCell(Text(data.participantNumber == "" ? "--" : (data.participantNumber ?? "--"))),
                      ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget swayamsevakAndKaryakartaTable(void Function(void Function()) set) {
    final List<String> headers = [
      "",
      Statics.getLabel('Name'),
      Statics.getLabel('daayitvaName'),
      Statics.getLabel('Mobile'),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Statics.getLabel("SwayamsevaksList"), softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              interactive: true,
              thickness: 5,
              radius: Radius.circular(10),
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: false,
                  headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                  columnSpacing: 30,
                  headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  columns: headers
                      .map((header) => DataColumn(
                            label: Container(
                              constraints: BoxConstraints(minWidth: 30, maxWidth: header == headers.first ? 80 : 200),
                              // constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.2),
                              child: Text(header, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ))
                      .toList(),
                  rows: abhiyaanSwayamsevakDataList.asMap().entries.map((entry) {
                    int index = entry.key;
                    var data = entry.value;
                    bool isSelected = selectedKaryakartaList.contains(data);
                    return DataRow(
                        selected: isSelected,
                        color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (isSelected) return Colors.yellow.shade100;
                            return null;
                          },
                        ),
                        onSelectChanged: (bool? selected) {
                          if (!isSelected) {
                            set(() {
                              selectedKaryakartaList.add(data);
                            });
                          }
                        },
                        cells: [
                          DataCell(Icon(isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, color: Colors.yellow.shade800, size: 18)),
                          DataCell(Text(data.participantName == "" ? "--" : (data.participantName ?? "--"))),
                          DataCell(Text(data.daayityaName == "" ? "--" : (data.daayityaName ?? "--"))),
                          DataCell(Text(data.participantNumber == "" ? "--" : (data.participantNumber ?? "--"))),
                        ]);
                  }).toList(),
                ),
              ),
            ),
          ),
          SizedBox(height: 18),
          Text(Statics.getLabel("KaaryakartaaList"), softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              interactive: true,
              thickness: 5,
              radius: Radius.circular(10),
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: false,
                  headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                  columnSpacing: 30,
                  headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  columns: headers
                      .map((header) => DataColumn(
                            label: Container(
                              constraints: BoxConstraints(minWidth: 30, maxWidth: header == headers.first ? 80 : 200),
                              // constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.2),
                              child: Text(header, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ))
                      .toList(),
                  rows: abhiyaanKaryakartaDataList.asMap().entries.map((entry) {
                    int index = entry.key;
                    var data = entry.value;
                    bool isSelected = selectedKaryakartaList.contains(data);
                    return DataRow(
                        selected: isSelected,
                        color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (isSelected) return Colors.yellow.shade100;
                            return null;
                          },
                        ),
                        onSelectChanged: (bool? selected) {
                          if (!isSelected) {
                            set(() {
                              selectedKaryakartaList.add(data);
                            });
                          }
                        },
                        cells: [
                          DataCell(Icon(isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, color: Colors.yellow.shade900, size: 18)),
                          DataCell(Text(data.participantName == "" ? "--" : (data.participantName ?? "--"))),
                          DataCell(Text(data.daayityaName == "" ? "--" : (data.daayityaName ?? "--"))),
                          DataCell(Text(data.participantNumber == "" ? "--" : (data.participantNumber ?? "--"))),
                        ]);
                  }).toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /////////////////////////////////////////// DUMMY DATA /////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isSearching!,
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              // Row(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
              //       child: Text(
              //         "${Statics.getLabel('Abhiyaan')}",
              //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //   ],
              // ),
              // // SizedBox(height: 10),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.9,
              //   alignment: Alignment.centerLeft,
              //   padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(5),
              //     border: Border.all(color: Colors.black38),
              //   ),
              //   child: Text(abhiyaanDataList.first.abhiyaanName.toString(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: _buildDropdown(
              //     value: selectedSwayamAbhiyanValue,
              //     items: abhiyaanDataList.map((value) {
              //       return DropdownMenuItem(
              //         value: value.abhiyaanID.toString(),
              //         child: Text(value.abhiyaanName!),
              //       );
              //     }).toList(),
              //     onChanged: (newValue) {
              //       setState(() {
              //         selectedSwayamAbhiyanValue = newValue;
              //       });
              //     },
              //   ),
              // ),
              // SizedBox(height: 13),
              // customTextFields(
              //   isRequired: true,
              //   title: "${Statics.getLabel('date2')} : ",
              //   readOnly: true,
              //   onTap: () async {
              //     DateTime? date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now());
              //     if (date != null) dateController.text = DateFormat("dd/MM/yyyy").format(date);
              //     setState(() {});
              //   },
              //   controller: dateController,
              //   hintText: "DD/MM/YYYY",
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${Statics.getLabel('date2')} : ",
                          style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
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
                    // Text(
                    //   " : ",
                    //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    // ),
                    SizedBox(width: 12),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.4,
                      child: TextField(
                        controller: dateController,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                        style: TextStyle(fontSize: 14),
                        autofocus: false,
                        onTap: () async {
                          DateTime? date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now());
                          if (date != null) dateController.text = DateFormat("dd/MM/yyyy").format(date);
                          setState(() {});
                        },
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
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
              ),
              SizedBox(height: 13),
              _buildExpansionPanel(),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if ((_linkedgraamValue != "" && _linkedgraamValue != null) || (_linkedvastiValue != "" && _linkedvastiValue != null))
                    MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 5,
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                      onPressed: () async {
                        if (dateController.text.isEmpty) {
                          Statics.showToast(Statics.getLabel("selectDate"));
                          return;
                        }

                        data = await Statics.getSajjanAndAnyaGuestData(
                            context,
                            Statics.userDetails["userID"],
                            _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!,
                            _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? "2" : "3");
                        setState(() {});
                        // if(Statics.userDetails[])
                        await _getSwList();

                        setState(() {
                          _searched = true;
                          _isExpanded = false;
                        });
                      },
                      child: Text(
                        "${Statics.getLabel('search')}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  MaterialButton(
                      onPressed: () {
                        setState(() {
                          _searched = false;
                          _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                          _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                          type = "praant";
                        });
                      },
                      child: Text(Statics.getLabel('clear'))),
                ],
              ),
              SizedBox(height: 24),

              // if (_selctedLevel != "" && _selctedLevelName != "")
              //   Container(
              //       height: 40,
              //       width: double.infinity,
              //       margin: EdgeInsets.symmetric(horizontal: 16),
              //       decoration: BoxDecoration(
              //         border: Border.all(color: Colors.purpleAccent, width: 1),
              //         borderRadius: BorderRadius.all(Radius.circular(15)),
              //       ),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Text(
              //             "${Statics.getLabel(_selctedLevel ?? "Mahaanagar")}  ->  ",
              //             style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
              //           ),
              //           Text(
              //             " $_selctedLevelName",
              //             style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
              //           ),
              //         ],
              //       )),

              if (_searched) ...[
                Container(
                    height: 40,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purpleAccent, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${Statics.getLabel(_selctedLevel ?? "Mahaanagar")}  ->  ",
                          style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          " $_selctedLevelName",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ],
                    )),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                customTextFields(title: "संपर्कित घरे : ", controller: samparkitGhareController),
                customTextFields(title: "वितरित करपत्रक : ", controller: vitritKarpatrakController),
                customTextFields(title: "पुस्तक विक्री संख्या : ", controller: pustakVikriController),

                //
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "विशेष व्यक्ती संपर्क : ",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
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
                                    // if (_isSearching == false) {
                                    //   Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");

                                    // Fluttertoast.showToast(
                                    //   msg: Statics.getLabel("workInProgress"),
                                    //   toastLength: Toast.LENGTH_SHORT,
                                    //   gravity: ToastGravity.BOTTOM,
                                    // );
                                    // return;
                                    // }
                                    await showVisheshAtithiSelectionPopup(
                                      context,
                                      onAdd: () {
                                        saveGruhAbhiyaanDataFun();
                                        Navigator.of(context).pushReplacementNamed(
                                          AddVishisthaAtithi.routeName,
                                          arguments: {'geoUnitId': _selectedGeoUnitId},
                                        ).then(
                                          (value) async {
                                            data = await Statics.getSajjanAndAnyaGuestData(
                                                context,
                                                Statics.userDetails["userID"],
                                                _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!,
                                                _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? "2" : "3");
                                            setState(() {});
                                            // if(Statics.userDetails[])
                                            await _getSwList();
                                            setState(() {});
                                          },
                                        );
                                      },
                                    );
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
                      // Container(
                      //   // height: 30,
                      //   width: MediaQuery.of(context).size.width * 0.45,
                      //   child: TextField(
                      //     controller: vitritKarpatrakController,
                      //     inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                      //     style: TextStyle(
                      //       fontSize: 14,
                      //     ),
                      //     autofocus: false,
                      //     keyboardType: TextInputType.number,
                      //     textInputAction: TextInputAction.done,
                      //     decoration: InputDecoration(
                      //         isDense: true,
                      //         hintText: "0",
                      //         contentPadding: EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(5),
                      //         )),
                      //   ),
                      // ),
                    ],
                  ),
                ),
//
                if (widget.isDaayitva) customTextFields(title: "संपर्क हेतू सहभागी संख्या : ", controller: samparkaSahabhagiController),

                if (widget.isDaayitva) customTextFields(title: "संपर्क हेतू टोळी संख्या : ", controller: samparkaToliController),
                SizedBox(
                  height: 10,
                ),
                if (widget.isDaayitva)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                        onPressed: showDummyList,
                        child: Text(
                          // "${Statics.getLabel('SwayamsevaksList')}",
                          "अभियान कार्यकर्ता सुची",
                          style: TextStyle(fontSize: 14.5),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 30),
                MaterialButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                  onPressed: () async {
                    if (dateController.text.isEmpty || samparkitGhareController.text.isEmpty || vitritKarpatrakController.text.isEmpty || pustakVikriController.text.isEmpty) {
                      Statics.showToast(Statics.getLabel("impInfoRequired"));
                      return null;
                      // } else if (!(abhiyaanSwayamsevakDataList.any((e) => e.isSelected))) {
                      //   print("स्तराचे नाव निवडा");
                      //   Statics.showToast("किमान एक अभियान कार्यकर्ता जोडावे");
                      //   return null;
                    } else {
                      print("saving data");
                      await saveGruhAbhiyaanDataFun();
                    }
                    // _submit(context);
                  },
                  child: Text(
                    Statics.getLabel('Submit'),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 80),
              ],
            ],
          ),
        ),
      ),
    );
  }

  customTextFields({required String title, bool isRequired = false, required TextEditingController controller, String? hintText, bool readOnly = false, void Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
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
            child: TextField(
              controller: controller,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
              style: TextStyle(fontSize: 14),
              autofocus: false,
              onTap: onTap,
              readOnly: readOnly,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  isDense: true,
                  hintText: hintText ?? "0",
                  contentPadding: EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  String? selectedSajjanshaktiItemsIds;
  String? selectedAnyaprabhaviItemsIds;

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

  Future<void> showVisheshAtithiSelectionPopup(
    BuildContext context, {
    required VoidCallback onAdd,
  }) async {
    print("showVisheshAtithiSelectionPopup onTap >>>>>>>>>>>>>>> ");
    final _sarsajjanshaktiList = data?.vastisarsajjanshakti ?? [];
    final _sanyaprabhaviList = data?.vastisanyaprabhavi ?? [];

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        if (data == null) {
          return Center(child: CircularProgressIndicator());
        }
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

                    Flexible(
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
                                  ..._sarsajjanshaktiList.map((item) {
                                    return TableRow(
                                      children: [
                                        Center(
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
                                  ..._sanyaprabhaviList.map((item) {
                                    return TableRow(
                                      children: [
                                        Center(
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

  Widget _buildDropdown({
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
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
      width: MediaQuery.of(context).size.width * 0.9,
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
                  "${Statics.getLabel('vastiGramNivda')}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                        final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedMahaanagarValue = value;
                          _linkedVibhaagValue = null;
                          _selctedLevel = 'Mahanagar';
                          _selctedLevelName = selectedItem.name ?? "";
                          // _resetLinkedValues();
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
                        final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedVibhaagValue = value;
                          _selctedLevel = 'Vibhaag';
                          _selctedLevelName = selectedItem.name ?? "";
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
                        final selectedItem = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedbhaagValue = value;
                          _selctedLevel = 'Bhaag';
                          _selctedLevelName = selectedItem.name ?? "";
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
                        final selectedItem = _linkedshahar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedshaharValue = value;
                          _selectedGeoUnitId = value.toString();
                          _selctedLevel = 'Shahar';
                          _selctedLevelName = selectedItem.name ?? "";
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
                        final selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkednagarValue = value;
                          _selectedGeoUnitId = value.toString();
                          _selctedLevel = 'Nagar';
                          _selctedLevelName = selectedItem.name ?? "";
                          populatelinkedMandalDropdown(value);
                          populatelinkedVastiDropdown(value);
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
                        final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedmandalValue = value;
                          _selectedGeoUnitId = value.toString();
                          _selctedLevel = 'Mandal';
                          _selctedLevelName = selectedItem.name ?? "";
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
                        final selectedItem = _linkedgraam!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedgraamValue = value;
                          _selectedGeoUnitId = value.toString();
                          _selctedLevel = 'Graam';
                          _selctedLevelName = selectedItem.name ?? "";
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
                        final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedvastiValue = value;
                          _selectedGeoUnitId = value.toString();
                          _selctedLevel = 'Vasti';
                          _selctedLevelName = selectedItem.name ?? "";
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
}
