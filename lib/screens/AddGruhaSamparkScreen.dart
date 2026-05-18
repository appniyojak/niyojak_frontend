import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanListResponse.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanLoginDataResponse.dart';
import 'package:niyojak_prod/models/response_model/VishishtaVyaktiModel.dart';
import 'package:niyojak_prod/providers/bals.dart';
import 'package:niyojak_prod/providers/swayamsevak_provider.dart';
import 'package:niyojak_prod/screens/AddEditVisheshVyaktiScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/static_data.dart' as Statics;
import '../models/response_model/dropdown_level_responsemodel.dart';
import '../utils/globals.dart';

class AddGruhaSamparkScreen extends StatefulWidget {
  static const routeName = '/gruha-sampark';

  @override
  State<AddGruhaSamparkScreen> createState() => _AddGruhaSamparkScreenState();
}

class _AddGruhaSamparkScreenState extends State<AddGruhaSamparkScreen> {
  TextEditingController dateController = TextEditingController(text: DateFormat("dd/MM/yyyy").format(DateTime.now()));
  TextEditingController countController = TextEditingController();
  TextEditingController baithakCountController = TextEditingController();
  TextEditingController baithakmenCountController = TextEditingController();
  TextEditingController baithakwomenCountController = TextEditingController();
  List<VishishtaVyaktiModel> vishishtaList = [];

  String selectedAbhiyanValue = "";

  List<LevelMasterBAL>? _level;
  List<GeoUnitMasterBAL>? _geoUnits;
  String _levelValue = "";
  String _geoUnitsValue = "";
  bool _isSearching = false;
  String selectedDayitvValue = "";

  List<AbhiyaanList> abhiyaanDataList = [];

  bool _isExpanded = false;

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
  bool _smallBaithakDone = false;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedupnagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";

  String? _selctedLevel = "";
  String? _selectedGeoUnitId = "";

  AbhiyanSwayamsevakdata? initialData;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getInitialData();
      await getAbhiyaanListData();
    });

    // populatelinkedBhaagDropdown();
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
    await populatelinkedVibhaagDropdown();
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
      (selection.upnagar != null && selection.upnagar!.isNotEmpty) ? (_linkedupnagarValue) : _linkednagarValue,
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

  Future<void> populatelinkedMahaanagarDropdown() async {
    _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
  }

  Future<void> populatelinkedVibhaagDropdown() async {
    _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaag = _linkednagar = _linkedupnagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), '', '', '');
    setState(() {
      _linkedVibhaag = data;
    });
  }

  Future<void> populatelinkedBhaagDropdown(String? vibhaagIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaag = _linkednagar = _linkedupnagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
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

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagar = _linkedupnagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    final parentID = shaharIDStr ?? bhaagIDStr!;
    final parentType = shaharIDStr != null ? 'Shahar' : 'Bhaag';
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), parentID, parentType, '', isAbhiyaan: false);
    setState(() => _linkednagar = data.isNotEmpty ? data : null);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedUpnagarDropdown(String? nagarIDStr) async {
    _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = null;
    _linkedupnagar = _linkedmandal = _linkedgraam = null;
    var mnDD;

    mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');

    setState(() {
      _linkedupnagar = (mnDD.length > 0 ? mnDD : null);
      //_linkedupnagarValue = (userparentUpanagarid ?? userGeoUnitId).toString();
    });

    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(bool haveParentUp, String? nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD;
    if (haveParentUp) {
      print("i am in parents upnagar");
      mnDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, "Upnagar", '');
      print("${mnDD}");
    } else {
      mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, "Nagar", '');
    }

    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });

    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String mandalIDStr) async {
    _linkedgraamValue = null;
    print("mandalIDStr mandalIDStr ==> $mandalIDStr");
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    // log("_linkedgraam_linkedgraam --> $_linkedgraam");
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(bool haveParentUp, String? nagarIDStr) async {
    _linkedvastiValue = null;
    var data;
    if (haveParentUp) {
      print("i am in parents upnagar vasti");
      data = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, "Upnagar", '');
      // print("${mnDD}");
    } else {
      data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, "Nagar", '');
    }
    setState(() => _linkedvasti = data.isNotEmpty ? data : null);
    return data;
  }

  void populateGeoUnits(String? levelID) async {
    var data4;
    if (levelID == "") {
      data4 = await Statics.getGeoUnitsByLevel(Statics.levels['MahaanagarLevelID']);
    } else
      data4 = await Statics.getGeoUnitsByLevel(levelID!);
    if (!mounted) return;
    setState(() {
      _geoUnits = data4;
    });
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
          selectedAbhiyanValue = abhiyaanDataList.first.abhiyaanID.toString();
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
      Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
    }
  }

  saveGruhaSamparkCall() async {
    setState(() {
      _isSearching = true;
    });
    try {
      List<UserDataBAL> user = await Statics.getUserDataLDB();

      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        var data = {
          "AbhiyanID": int.parse(selectedAbhiyanValue),
          "AbhiyanDate": DateFormat("MM/dd/yyyy").format(DateFormat("dd/MM/yyyy").parse(dateController.text)).toString(),
          "GruhasamparkCount": countController.text,
          "vasti_id": _linkedvastiValue == null ? 0 : int.tryParse(_selectedGeoUnitId ?? _linkedvastiValue ?? "0") ?? 0,
          "gram_id": _linkedgraamValue == null ? 0 : int.tryParse(_selectedGeoUnitId ?? _linkedgraamValue ?? "0") ?? 0,
          "CreatedByID": initialData!.abhiyanSwayamsevakID!,
          "SmallBaithak": _smallBaithakDone == true ? "1" : '0',
          "SmallBaithakCount": baithakCountController.text,
          "SmallBaithakMenCount": baithakmenCountController.text,
          "SmallBaithakWomenCount": baithakwomenCountController.text,
          "VisheshVyakti": vishishtaList.isNotEmpty ? jsonDecode(jsonEncode(vishishtaList)) : "",
        };

        print("saveGruhaSamparkCall ---->  ${jsonEncode(data)}");

        var result = await SwayamsevakProvider().saveAbhiyanGruhaSampark(jsonEncode(data));
        if (result.status == "200") {
          print("succeed");
          Statics.showToast(result.message);
          setState(() {});
          // Navigator.pop(context);
        } else {
          print("Not Succeed");
          Statics.showToast(result.message);
        }
      }
    } catch (e) {
      print(e);
      Statics.showToast(Statics.getLabel('unableToSaveData'));
    }
    setState(() {
      _isSearching = false;
    });
  }

  getInitialData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = pref.getString("AbhiyanSwayamsevakData");
    if (data != null) {
      initialData = AbhiyanSwayamsevakdata.fromJson(jsonDecode(data));
    }
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    var data2 = await Statics.getLevelLDB();
    data2.removeWhere((element) => element.levelName == "Shaakhaa");
    data2.removeWhere((element) => element.levelName == "Shahar");
    data2.removeWhere((element) => element.levelName == "Kshetra");
    data2.removeWhere((element) => element.levelName == "Akhil Bhaaratiya");

    setState(() {
      _level = data2;
    });
    // populatelinkedMahaanagarDropdown();
    populatelinkedVibhaagDropdown();
    if (initialData != null) {
      setState(() {
        if (initialData!.parentVibhaagID != null) {
          populatelinkedVibhaagDropdown();
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
          populatelinkedMandalDropdown(false, _linkednagarValue);
          populatelinkedVastiDropdown(false, _linkednagarValue);
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
          populatelinkedMandalDropdown(false, _linkednagarValue);
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

    if (fromClear || userLevelId == null || ddm == null) {
      return;
    }
    setState(() {
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    await populateAllDropdowns(userLevelId!, ddm!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "${Statics.getLabel('addGruhaSampark')}",
              style: TextStyle(fontSize: 21),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          body: ModalProgressHUD(
            inAsyncCall: _isSearching,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        "${Statics.getLabel('Abhiyaan')}",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.88,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 5, right: 0, top: 5, bottom: 5),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                        child: DropdownButton(
                          isExpanded: true,
                          isDense: true,
                          iconSize: 30,
                          underline: SizedBox(),
                          value: selectedAbhiyanValue == "" ? null : selectedAbhiyanValue,
                          onChanged: (newValue) {
                            print(newValue);
                            setState(() {
                              selectedAbhiyanValue = newValue!;
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
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${Statics.getLabel('date')}             : ",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        // height: 30,
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: TextField(
                          readOnly: true,
                          onTap: () async {
                            DateTime? date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now());
                            dateController.text = DateFormat("dd/MM/yyyy").format(date!);
                            setState(() {});
                          },
                          controller: dateController,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          autofocus: false,
                          keyboardType: TextInputType.datetime,
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
                  SizedBox(
                    height: 15,
                  ),
                  _vastiGraamDropdown(),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${Statics.getLabel('gruhSamparkcount')}              :",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        // height: 30,
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: TextField(
                          controller: countController,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          autofocus: false,
                          inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () async {
                              Object? result = await Navigator.of(context).pushNamed(AddEditVisheshVyaktiScreen.routeName);
                              var item = VishishtaVyaktiModel.fromJson(jsonDecode(jsonEncode(result)));
                              vishishtaList.add(item);
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                children: [
                                  Container(
                                    height: 25,
                                    width: 25,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.add,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${Statics.getLabel('addVishishtVyakti')}",
                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      // Checkbox for Small Baithak
                      CheckboxListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          Statics.getLabel('smallBaithak'),
                          style: TextStyle(fontSize: 15),
                        ),
                        checkColor: Colors.white,
                        activeColor: Colors.purple,
                        value: _smallBaithakDone ?? false,
                        onChanged: (value) {
                          setState(() {
                            _smallBaithakDone = value!;
                          });
                        },
                      ),
                      if (_smallBaithakDone == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            children: [
                              // Baithak Held Count
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: baithakCountController,
                                decoration: InputDecoration(
                                  labelText: Statics.getLabel('baithakHeldCount'),
                                ),
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return Statics.getLabel('validationMessage');
                                  }
                                  return null;
                                },
                              ),
                              // Men Count
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: baithakmenCountController,
                                decoration: InputDecoration(
                                  labelText: Statics.getLabel('menCount'),
                                ),
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return Statics.getLabel('validationMessage');
                                  }
                                  return null;
                                },
                              ),
                              // Women Count
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: baithakwomenCountController,
                                decoration: InputDecoration(
                                  labelText: Statics.getLabel('womenCount'),
                                ),
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return Statics.getLabel('validationMessage');
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (vishishtaList.isNotEmpty)
                    for (int i = 0; i < vishishtaList.length; i++)
                      Card(
                        elevation: 5,
                        child: ListTile(
                          minLeadingWidth: 20,
                          contentPadding: EdgeInsets.only(left: 20, top: 3, bottom: 3),
                          dense: true,
                          leading: Text(
                            (i + 1).toString() + ")",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          title: Text(
                            vishishtaList[i].name!,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            vishishtaList[i].mobile!,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                          trailing: PopupMenuButton(
                            padding: EdgeInsets.zero,
                            tooltip: "",
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            onSelected: (item) async {
                              if (item == "Edit") {
                                await Navigator.of(context).pushNamed(AddEditVisheshVyaktiScreen.routeName, arguments: vishishtaList[i]).then((result) {
                                  setState(() {});
                                });
                              } else if (item == "Remove") {
                                vishishtaList.removeAt(i);
                              }
                              setState(() {});
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                              PopupMenuItem(
                                height: 45,
                                value: 'Edit',
                                child: Row(
                                  children: [
                                    Container(width: 50, child: Icon(Icons.edit, size: 25)),
                                    Text('सुधारणे',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        )),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                height: 45,
                                value: 'Remove',
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(width: 50, child: Icon(Icons.delete, size: 25)),
                                    Text('काढा',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                  SizedBox(
                    height: 40,
                  ),
                  MaterialButton(
                    color: Theme.of(context).primaryColor,
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    onPressed: () async {
                      // Navigator.pop(context);
                      if (selectedAbhiyanValue.isEmpty) {
                        Statics.showToast("अभियान निवडा");
                        return null;
                      } else if (_linkedvastiValue == null && _linkedgraamValue == null) {
                        Statics.showToast("निवास स्थान निवडा");
                        return null;
                      } else if (countController.text.isEmpty) {
                        Statics.showToast("गृह संपर्क संख्या प्रविष्ट करा");
                        return null;
                      } else if (_smallBaithakDone == true && baithakCountController.text.isEmpty) {
                        Statics.showToast(" ${Statics.getLabel('baithakHeldCount')} संख्या प्रविष्ट करा");
                        return null;
                      } else if (_smallBaithakDone == true && baithakmenCountController.text.isEmpty) {
                        Statics.showToast(" ${Statics.getLabel('menCount')} संख्या प्रविष्ट करा");
                        return null;
                      } else if (_smallBaithakDone == true && baithakwomenCountController.text.isEmpty) {
                        Statics.showToast(" ${Statics.getLabel('womenCount')} संख्या प्रविष्ट करा");
                        return null;
                      } else {
                        print("else");
                        await saveGruhaSamparkCall();
                      }
                    },
                    child: Text(
                      Statics.getLabel('Submit'),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _vastiGraamDropdown() {
    return Container(
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
                spacing: 10,
                children: [
                  // IgnorePointer(
                  //   ignoring: _linkedVibhaagDisable,
                  //   child: DropdownButtonFormField(
                  //     decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                  //     isExpanded: true,
                  //     value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                  //     items: _linkedMahaanagar != null ? _linkedMahaanagar.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList() : [],
                  //     onChanged: (value) {
                  //       print(value);
                  //       setState(() {
                  //         _linkedMahaanagarValue = value;
                  //         _linkedVibhaagValue = null;
                  //         populatelinkedVibhaagDropdown(value);
                  //       });
                  //     },
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  if (_linkedVibhaag != null && _linkedVibhaag!.length > 0)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 8 || userLevelId == 13),
                      label: Statics.getLabel('Vibhaag'),
                      value: _linkedVibhaagValue,
                      items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        setState(() {
                          _linkedVibhaagValue = value;
                        });
                        populatelinkedBhaagDropdown(value);
                      },
                    ),
                  if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 7 || userLevelId == 13),
                      label: Statics.getLabel('Bhaag'),
                      value: _linkedbhaagValue,
                      items: _linkedbhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        setState(() {
                          _linkedbhaagValue = value;
                        });
                        populatelinkedShaharDropdown(value);
                        populatelinkedNagarDropdown(value, null);
                      },
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
                        });
                      },
                    ), */
                  if (_linkednagar != null && _linkednagar!.length > 0)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
                      label: Statics.getLabel('Nagar'),
                      value: _linkednagarValue,
                      items: _linkednagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        setState(() {
                          _linkednagarValue = value;
                        });
                        populatelinkedUpnagarDropdown(value);
                        populatelinkedMandalDropdown(false, value);
                        populatelinkedVastiDropdown(false, value);
                      },
                    ),
                  if (_linkedupnagar != null && _linkedupnagar!.length > 0)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
                      label: Statics.getLabel('upnagarUpkhanda'),
                      value: _linkedupnagarValue,
                      items: _linkedupnagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        setState(() {
                          _linkedupnagarValue = value;
                        });
                        populatelinkedMandalDropdown(true, value);
                        populatelinkedVastiDropdown(true, value);
                      },
                    ),
                  if (_linkedmandal != null && _linkedmandal!.length > 0)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 4),
                      label: Statics.getLabel('Mandal'),
                      value: _linkedmandalValue,
                      items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        setState(() {
                          _linkedmandalValue = value;
                        });
                        populatelinkedGraamDropdown(value!);
                      },
                    ),
                  if (_linkedgraam != null && _linkedgraam!.length > 0)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 3),
                      label: Statics.getLabel('Graam'),
                      value: _linkedgraamValue,
                      items: _linkedgraam!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        setState(() {
                          _linkedgraamValue = value;
                        });
                      },
                    ),
                  if (_linkedvasti != null && _linkedvasti!.length > 0)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 2),
                      label: Statics.getLabel('Vasti'),
                      value: _linkedvastiValue,
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
    );
  }
}
