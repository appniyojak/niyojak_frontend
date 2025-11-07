import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../helpers/static_data.dart';
import '../../../models/response_model/AbhiyaanListResponse.dart';
import '../../../models/response_model/AbhiyaanSwayamsevakListResponse.dart';
import '../../../providers/bals.dart';

class AddAbhiyaanKaryakartaScreen extends StatefulWidget {
  static const String routeName = '/add-abhiyaan-karyakarta-screen';

  const AddAbhiyaanKaryakartaScreen({super.key});

  @override
  State<AddAbhiyaanKaryakartaScreen> createState() => _AddAbhiyaanKaryakartaScreenState();
}

class _AddAbhiyaanKaryakartaScreenState extends State<AddAbhiyaanKaryakartaScreen> {
  String? from;

  AbhiyanSwayamsevakList? abhiyaanSwayamsevak;
  int? selectedGramVastiListRowIndex;
  List<SaveAbhiyanSwayamsevakMappingforGruh> selectedGramVastiList = [];

  late ScrollController _scrollController;

  String selectedAbhiyanValue = "";
  String selectedSansthaValue = "";
  String selectedDayitvValue = "";

  TextEditingController _anyaSansthaCntrl = TextEditingController();
  TextEditingController _sansthaNameCntrl = TextEditingController();
  TextEditingController _sansthaPadhCntrl = TextEditingController();
  TextEditingController _fullNameCntrl = TextEditingController();
  TextEditingController _emailCntrl = TextEditingController();
  TextEditingController _mobileCntrl = TextEditingController();

  List<LevelMasterBAL>? _level;
  List<GeoUnitMasterBAL>? _geoUnits;
  String _levelValue = "";
  String _geoUnitsValue = "";
  bool _isExpanded = false;

  List<String> strEmail = [];
  List<String> strMobile = [];
  bool _isSearching = false;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<GeoUnitMasterBAL?> _selectedVasti = [];
  List<GeoUnitMasterBAL?> _selectedGram = [];

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = "";
  String? _linkednagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";

  String? _linkedMahaanagarName = '';
  String? _linkedVibhaagName = '';
  String? _linkedbhaagName = "";
  String? _linkednagarName = "";
  String? _linkedmandalName = "";

  // String? _linkedgraamName = "";
  // String? _linkedvastiName = "";

  final _searchController = TextEditingController();
  List<MenuChoices> choices = [];

  // List newData = [];
  bool showFields = false;

  List<AbhiyaanList> abhiyaanDataList = [
    AbhiyaanList.fromJson({
      "AbhiyaanID": 2,
      "AbhiyaanName": Statics.getLabel('gruhSamparkAbhiyan') + " (${Statics.getLabel('shatabdiVarsha')})",
      "EndDate": null,
      "EndDateStr": null,
      "PraantID": 1,
      "Remark": "C1-10 Rs, C2-100 Rs, C3-1000 Rs",
      "StartDate": null,
      "StartDateStr": null
    })
  ];

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

  Future<void> _search(String strType) async {
    setState(() {
      _isSearching = true;
    });
    await _getSwList(strType);
    setState(() {
      showFields = true;
      _isSearching = false;
    });
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    setState(() {
      _linkedbhaagValue = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    });
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedbhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    setState(() {
      _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    });
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  // Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(String bhaagIDStr) async {
  //   _linkedshaharValue = _linkedshahar = null;
  //   var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
  //   setState(() {
  //     _linkedshahar = (shDD.length > 0 ? shDD : null);
  //   });
  //   return shDD;
  // }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    setState(() {
      _linkednagarValue = null;
      _linkedvasti = _linkedgraam = _linkedmandal = _linkednagar = null;
    });
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

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(String nagarIDStr) async {
    setState(() {
      _linkedgraamValue = null;
      _linkedmandal = _linkedgraam = null;
    });
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String mandalIDStr) async {
    setState(() {
      _linkedgraamValue = null;
    });
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String nagarIDStr) async {
    setState(() {
      _linkedvastiValue = null;
    });
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
    return vsDD;
  }

  Future<void> _getSwList(String strType) async {
    print("calling");
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      var inputData = {
        "AppUserID": Statics.userDetails["userID"],
        // "AppUserID": "5693",
        "SearchCriteria": _searchController.text.trim(),
      };
      print(jsonEncode(inputData));
      abhiyaanSwayamsevak = await Statics.getSwayamsevakForGruhAbhiyaan(inputData);
      setState(() {});
      if (abhiyaanSwayamsevak != null) {
        if (!abhiyaanSwayamsevak!.isPresentInAsSewak && !abhiyaanSwayamsevak!.isPresentInAbhiyaan) {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(getLabel('AskConfirmation')),
              content: Text("स्वयंसेवक उपस्थित नाहीत, या अभियानासाठी नवीन अभियान स्वयंसेवक जोडायचा आहे का ?"),
              actions: <Widget>[
                TextButton(
                  child: Text(getLabel('ConfirmationNo')),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pop();
                  },
                ),
                TextButton(
                  child: Text(getLabel('ConfirmationYes')),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    setState(() {
                      _mobileCntrl.text = _searchController.text;
                    });
                    // Navigator.pushReplacementNamed(context, AbhiyanAddSwayamsevakScreen.routeName);
                  },
                ),
              ],
            ),
          );
          return;
        }
        setState(() {
          _fullNameCntrl.text = abhiyaanSwayamsevak?.participantName ?? "";
          _emailCntrl.text = abhiyaanSwayamsevak?.email ?? "";
          _mobileCntrl.text = abhiyaanSwayamsevak?.participantNumber ?? "";
          _sansthaNameCntrl.text = abhiyaanSwayamsevak?.sansthaName ?? "";
          _sansthaPadhCntrl.text = abhiyaanSwayamsevak?.sansthaPadh ?? "";
          selectedSansthaValue = abhiyaanSwayamsevak?.sansthaType ?? "";
          // _anyaSansthaCntrl.text = "";

          selectedGramVastiList = abhiyaanSwayamsevak?.mappingforGruhs ?? [];
        });

        _levelValue = abhiyaanSwayamsevak?.levelID.toString() ?? "";
        if (_levelValue.isNotEmpty && _levelValue != "null") {
          await populateGeoUnits(_levelValue);
        }
        _geoUnitsValue = abhiyaanSwayamsevak?.geoUnitID.toString() ?? "";
        selectedDayitvValue = abhiyaanSwayamsevak?.daayityaName ?? "";
        setState(() {});
      }
    }
  }

  Future<void> editSelectedVastiGraamFun(SaveAbhiyanSwayamsevakMappingforGruh _data) async {
    // final _data = selectedGramVastiList[selectedGramVastiListRowIndex!];
    final List<int> _requiredVastiIds = _data.vastiIDs!.split(',').where((s) => s.isNotEmpty).map((s) => int.tryParse(s.trim())).where((id) => id != null).cast<int>().toList();
    final List<int> _requiredGraamIds = _data.gramIDs!.split(',').where((s) => s.isNotEmpty).map((s) => int.tryParse(s.trim())).where((id) => id != null).cast<int>().toList();
    setState(() {
      _linkedMahaanagarValue = _data.mahanagarID == 0 ? "" : _data.mahanagarID.toString();
      _linkedMahaanagarName = _data.mahanagarName;
    });
    await populatelinkedMahaanagarDropdown();
    setState(() {
      _linkedVibhaagValue = _data.vibhaagID.toString();
      _linkedVibhaagName = _data.vibhaagName;
    });
    await populatelinkedVibhaagDropdown(_data.mahanagarID == 0 ? "" : _data.mahanagarID.toString());
    await populatelinkedBhaagDropdown(_data.vibhaagID.toString());
    setState(() {
      _linkedbhaagValue = _data.bhaagID.toString();
      _linkedbhaagName = _data.bhaagName;
    });
    await populatelinkedNagarDropdown(_data.bhaagID.toString(), null);
    setState(() {
      _linkednagarValue = _data.nagarID.toString();
      _linkednagarName = _data.nagarName;
    });
    if (_data.mandalName != null && _data.mandalName != "") {
      await populatelinkedMandalDropdown(_data.nagarID.toString());
      setState(() {
        _linkedmandalValue = _data.mandalID == 0 ? "" : _data.mandalID.toString();
        _linkedmandalName = _data.mandalName;
      });
      await populatelinkedGraamDropdown(_data.mandalID.toString());
      setState(() {
        _selectedGram = _linkedgraam!.where((e) => _requiredGraamIds.contains(e.geoUnitID)).toList();
      });
    }
    if (_data.vastiIDs != null && _data.vastiIDs != "") {
      await populatelinkedVastiDropdown(_data.nagarID.toString());
      setState(() {
        _selectedVasti = _linkedvasti!.where((e) => _requiredVastiIds.contains(e.geoUnitID)).toList();
      });
    }

    setState(() {
      if (selectedGramVastiListRowIndex != null) {
        selectedGramVastiList.removeAt(selectedGramVastiListRowIndex!);
      } else {
        selectedGramVastiList.remove(_data);
      }
      _isExpanded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    // from = ModalRoute.of(context)!.settings.arguments as String;
    _scrollController = ScrollController();
    // await getAbhiyaanListData();
    Future.delayed(Duration.zero, () async {
      selectedAbhiyanValue = abhiyaanDataList.first.abhiyaanID.toString();
    });
    populatelinkedMahaanagarDropdown();
    populatelinkedVibhaagDropdown('');
    _level = await Statics.getLevelLDB();
    setState(() {
      _level = _level!.where((element) => element.levelName == "Vasti" || element.levelName == "Graam").toList();
      // _search("Search");
    });
  }

  // getAbhiyaanListData() async {
  //   try {
  //     bool isConnected = await Statics.isInternetConnected();
  //     if (isConnected) {
  //       setState(() {
  //         _isSearching = true;
  //       });
  //       var result = await SwayamsevakProvider().getAbhiyanList();
  //       if (result.status == "200") {
  //         print("succeed");
  //         abhiyaanDataList = result.abhiyaanList!;
  //         selectedAbhiyanValue = abhiyaanDataList.first.abhiyaanID.toString();
  //         setState(() {
  //           _isSearching = false;
  //         });
  //       } else {
  //         setState(() {
  //           _isSearching = false;
  //         });
  //         Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
  //       }
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _isSearching = false;
  //     });
  //     Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
  //   }
  // }

  saveAbhiyaanSwayamsevakCall() async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        var data = {
          "AbhiyanSwayamsevakID": abhiyaanSwayamsevak?.abhiyanSwayamsevakID ?? 0,
          "AbhiyaanID": 2,
          "SwayamsevakID": abhiyaanSwayamsevak?.swayamsevakID ?? 0,
          "MobileNo": _mobileCntrl.text,
          "full_name": _fullNameCntrl.text,
          "Email": _emailCntrl.text,
          "samajik_sanstha": selectedSansthaValue,
          "sanstha_name": _sansthaNameCntrl.text,
          "SansthaPadh": _sansthaPadhCntrl.text,
          "DaayitvaName": selectedDayitvValue,
          "LevelID": _levelValue,
          "LevelName": _geoUnitsValue,
          "AbhiyanDaayitvaID": abhiyaanSwayamsevak?.abhiyaDaayitvaID ?? 0,
          "mappingforGruhs": selectedGramVastiList.map((e) {
            return e.toJson();
          }).toList(),
        };

        log(jsonEncode(data));

        var result = await Statics.saveSwayamsevakForGruhAbhiyaan(data, context: context);
        if (result) {
          print("succeed");
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(getLabel('AskConfirmation')),
              content: Text("तुम्हाला आणखी एक स्वयंसेवक जोडायचा आहे का?"),
              actions: <Widget>[
                TextButton(
                  child: Text(getLabel('ConfirmationNo')),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pop();
                  },
                ),
                TextButton(
                  child: Text(getLabel('ConfirmationYes')),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    setState(() {
                      _searchController.clear();

                      _levelValue = "";
                      _geoUnitsValue = "";
                      selectedDayitvValue = "";

                      abhiyaanSwayamsevak = null;
                      _anyaSansthaCntrl.clear();
                      _sansthaNameCntrl.clear();
                      _sansthaPadhCntrl.clear();
                      _fullNameCntrl.clear();
                      _emailCntrl.clear();
                      _mobileCntrl.clear();
                      showFields = false;

                      selectedGramVastiList = [];
                    });
                    // Navigator.pushReplacementNamed(context, AbhiyanAddSwayamsevakScreen.routeName);
                  },
                ),
              ],
            ),
          );
        } else {
          Statics.showToast(Statics.getLabel('unableToSaveData'));
        }
      }
    } catch (e) {
      Statics.showToast(Statics.getLabel('unableToSaveData'));
      log(e.toString());
    }
  }

  Future<void> populateGeoUnits(String? levelID) async {
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    from = ModalRoute.of(context)!.settings.arguments as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(from == "swayamsevak" ? Statics.getLabel("AddSwayamsevak") : "अभियान कार्यकर्ता जोडा"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isSearching,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      "${Statics.getLabel('Abhiyaan')}",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black38),
                  ),
                  child: Text(abhiyaanDataList.first.abhiyaanName.toString(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "${Statics.getLabel('Search')} ",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        ":",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(fontSize: 16),
                        autofocus: false,
                        onChanged: (v) {
                          if (v.isEmpty) {
                            _levelValue = "";
                            _geoUnitsValue = "";
                            selectedDayitvValue = "";

                            abhiyaanSwayamsevak = null;
                            _anyaSansthaCntrl.clear();
                            _sansthaNameCntrl.clear();
                            _sansthaPadhCntrl.clear();
                            _fullNameCntrl.clear();
                            _emailCntrl.clear();
                            _mobileCntrl.clear();
                            showFields = false;

                            selectedGramVastiList = [];
                          }
                          setState(() {});
                        },
                        inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          // suffixIcon: InkWell(
                          //   onTap: () async {
                          //     FocusScope.of(context).unfocus();
                          //     if (_searchController.text.length < 10) {
                          //       Statics.showToast(Statics.getLabel('MobileValidationMessage'));
                          //       return null;
                          //     }
                          //     await _search("Search");
                          //     setState(() {});
                          //   },
                          //   borderRadius: BorderRadius.circular(30),
                          //   child: Icon(
                          //     Icons.search,
                          //     size: 25,
                          //   ),
                          // ),
                          border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                // if (newData.isNotEmpty && _searchController.text.isNotEmpty)
                //   Container(
                //     height: MediaQuery.of(context).size.height * 0.2,
                //     width: MediaQuery.of(context).size.width,
                //     padding: const EdgeInsets.all(5.0),
                //     child: ListView.builder(
                //       shrinkWrap: true,
                //       itemCount: newData.length,
                //       itemBuilder: (BuildContext context, int index) {
                //         return AbhiyanSwayamsevakCard(newData[index], _search);
                //       },
                //     ),
                //   ),
                // if (_isSearching)
                // Container(
                //     height: MediaQuery.of(context).size.height * 0.2,
                //     width: MediaQuery.of(context).size.width,
                //     padding: const EdgeInsets.all(5.0),
                //     child: Center(
                //       child: CircularProgressIndicator(),
                //     )),
                if (_searchController.text.isNotEmpty) SizedBox(height: 15),
                if (showFields)
                  Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _fullNameCntrl,
                        decoration: InputDecoration(
                          labelText: Statics.getLabel('FullName'),
                          isDense: true,
                          border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) return (Statics.getLabel('FullNameValidationMessage'));
                          return null;
                        },
                        onSaved: (value) {
                          // swDetails.fullName = value.trim();
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _mobileCntrl,
                        decoration: InputDecoration(
                          labelText: Statics.getLabel('Mobile'),
                          isDense: true,
                          border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                        validator: (value) {
                          if (value!.isEmpty || value!.trim().length < 10) return (Statics.getLabel('MobileValidationMessage'));
                          return null;
                        },
                        onSaved: (value) {
                          // swDetails.mobileNumber = value.trim();
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _emailCntrl,
                        decoration: InputDecoration(
                          labelText: Statics.getLabel('Email'),
                          isDense: true,
                          border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) return (Statics.getLabel('ValidEmailBodyValidationMessage'));
                          return null;
                        },
                        onSaved: (value) {
                          // swDetails.fullName = value.trim();
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      if (selectedGramVastiList.isEmpty)
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(width: 0.7, color: Colors.grey.shade700)),
                          child: Column(
                            children: [
                              ExpansionPanelList(
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
                                        title: Text(Statics.getLabel('SelectGeoUnit')),
                                      );
                                    },
                                    body: Container(
                                      margin: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          if (_linkedMahaanagar != null)
                                            DropdownButtonFormField(
                                              decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                                              isExpanded: true,
                                              value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                                              items: _linkedMahaanagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                              onChanged: (value) {
                                                final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                                print(value);
                                                setState(() {
                                                  _linkedMahaanagarValue = value;
                                                  _linkedVibhaagValue = null;
                                                  _linkedbhaagValue = null;

                                                  _linkednagarValue = null;
                                                  //
                                                  _linkedMahaanagarName = selectedItem.name ?? "";
                                                  _linkedVibhaagName = null;
                                                  _linkedbhaagName = null;

                                                  _linkednagarName = null;
                                                  //
                                                  populatelinkedVibhaagDropdown(value!);
                                                  // mahanagarId = value;
                                                  // selctedLevelName = selectedItem.name ?? "";
                                                  // selctedLevel = 'Mahanagar';
                                                  // selctedLevelId = value;
                                                });
                                              },
                                            ),
                                          SizedBox(height: 10),
                                          if (_linkedVibhaag != null)
                                            DropdownButtonFormField(
                                              decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                                              isExpanded: true,
                                              value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                                              items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                              onChanged: (value) {
                                                final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                                print(value);
                                                setState(() {
                                                  _selectedVasti = [];
                                                  _selectedGram = [];
                                                  _linkedVibhaagValue = value;
                                                  populatelinkedBhaagDropdown(value!);
                                                  // vibhagId = value;
                                                  _linkedbhaagValue = _linkednagarValue = null;
                                                  _linkedbhaag = _linkednagar = null;
                                                  _linkedVibhaagName = selectedItem.name ?? "";
                                                  _linkedbhaagName = _linkednagarName = null;
                                                  // _selctedlevel = 'Vibhaag';
                                                  // _selctedLevelId = value;
                                                });
                                              },
                                            ),
                                          SizedBox(height: 10),
                                          if (_linkedbhaag != null)
                                            DropdownButtonFormField(
                                              decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                                              isExpanded: true,
                                              value: _linkedbhaagValue == "" ? null : _linkedbhaagValue,
                                              items: _linkedbhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                              onChanged: (value) {
                                                final selectedItem = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                                print(value);
                                                setState(() {
                                                  _selectedVasti = [];
                                                  _selectedGram = [];
                                                  _linkedbhaagValue = value;
                                                  _linkedbhaagName = selectedItem.name ?? "";
                                                  _linkednagarName = null;
                                                  // populatelinkedShaharDropdown(value!);
                                                  populatelinkedNagarDropdown(value, null);
                                                });
                                              },
                                            ),
                                          SizedBox(height: 10),
                                          // if (_linkedshahar != null && _linkedshahar!.length > 0)
                                          //   DropdownButtonFormField(
                                          //     decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                                          //     isExpanded: true,
                                          //     value: _linkedshaharValue == "" ? null : _linkedshaharValue,
                                          //     items: _linkedshahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                          //     onChanged: (value) {
                                          //       setState(() {
                                          //         _selectedVasti = [];
                                          //         _selectedGram = [];
                                          //         _linkedshaharValue = value;
                                          //         populatelinkedNagarDropdown(null, value);
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
                                              onChanged: (value) {
                                                final selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                                print(value);
                                                setState(() {
                                                  _selectedVasti = [];
                                                  _selectedGram = [];
                                                  _linkednagarValue = value;
                                                  //
                                                  _linkednagarName = selectedItem.name ?? "";
                                                  _linkedmandalName = null;
                                                  _linkedmandalValue = null;
                                                  populatelinkedMandalDropdown(value!);
                                                  populatelinkedVastiDropdown(value);
                                                });
                                              },
                                            ),
                                          if (_linkednagar != null && _linkednagar!.length > 0) SizedBox(height: 10),
                                          if (_linkedmandal != null && _linkedmandal!.length > 0)
                                            DropdownButtonFormField(
                                              decoration: InputDecoration(labelText: Statics.getLabel('Mandal')),
                                              isExpanded: true,
                                              value: _linkedmandalValue == "" ? null : _linkedmandalValue,
                                              items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                              onChanged: (value) {
                                                final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                                print(value);
                                                setState(() {
                                                  _selectedVasti = [];
                                                  _selectedGram = [];
                                                  _linkedmandalValue = value;
                                                  _linkedmandalName = selectedItem.name ?? "";
                                                  populatelinkedGraamDropdown(value!);
                                                });
                                              },
                                            ),
                                          if (_linkedmandal != null && _linkedmandal!.length > 0) SizedBox(height: 10),
                                          if (_linkedgraam != null && _linkedgraam!.length > 0)
                                            MultiSelectDialogField(
                                              title: Text(Statics.getLabel('Graam')),
                                              buttonText: Text(Statics.getLabel('Graam')),
                                              buttonIcon: Icon(Icons.arrow_drop_down),
                                              decoration: BoxDecoration(
                                                // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                border: Border(bottom: _selectedGram.isEmpty ? BorderSide(color: Colors.grey) : BorderSide.none),
                                              ),
                                              confirmText: Text(
                                                Statics.getLabel('Submit'),
                                                style: const TextStyle(color: Colors.purple),
                                              ),
                                              cancelText: Text(
                                                Statics.getLabel('clear'),
                                                style: const TextStyle(color: Colors.purple),
                                              ),
                                              searchable: false,
                                              listType: MultiSelectListType.LIST,
                                              items: _linkedgraam!.map((bg) => MultiSelectItem(bg, bg.name.toString())).toList(),
                                              initialValue: _selectedGram,
                                              chipDisplay: MultiSelectChipDisplay(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.purple, width: 0.7),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  // icon: Icon(Icons.done, color: Colors.purple, size: 16),
                                                  chipColor: Colors.white,
                                                  textStyle: TextStyle(fontSize: 12, color: Colors.purple, fontWeight: FontWeight.w500)),
                                              // onSaved: (newValue) {},
                                              onConfirm: (values) {
                                                _selectedVasti = [];
                                                // _selectedVasti = values;
                                                _selectedGram = values.map((e) {
                                                  if (e is GeoUnitMasterBAL) {
                                                    return e;
                                                  }
                                                  return null;
                                                }).toList();
                                                setState(() {});
                                                print("valueeeeeeeesssss >>>>>>>>>>>>>>> $values");
                                                // // if (selectedUpnagarList.contains(values)) {
                                                // selctedLevel = 'upnagarUpkhanda';
                                                // selctedLevelName = _linkedUpnagar!.where((upnagar) => selectedUpnagarList.contains(upnagar.geoUnitID)).map((upnagar) => upnagar.preferedname).toList().join(",");
                                                // //   selectedUpnagarList.add(bg);
                                                // // } else {
                                                // //   selectedUpnagarList.remove(bg);
                                                // // }
                                                // setState(() {});
                                                //
                                                // // print("selctedLevelId >>>>>>>>>>>>>>>>> $selctedLevelId");
                                                // print("valueeeeeeeesssss >>>>>>>>>>>>>>> ${_selectedVasti.join(",")}");
                                              },
                                            ),
                                          // DropdownButtonFormField(
                                          //   decoration: InputDecoration(labelText: Statics.getLabel('Graam')),
                                          //   isExpanded: true,
                                          //   value: _linkedgraamValue == "" ? null : _linkedgraamValue,
                                          //   items: _linkedgraam!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                          //   onChanged: (value) {
                                          //     setState(() {
                                          //       _selectedVasti = [];
                                          //       _linkedgraamValue = value;
                                          //     });
                                          //   },
                                          // ),
                                          if (_linkedvasti != null && _linkedvasti!.length > 0)
                                            MultiSelectDialogField(
                                              title: Text(Statics.getLabel('Vasti')),
                                              buttonText: Text(Statics.getLabel('Vasti')),
                                              buttonIcon: Icon(Icons.arrow_drop_down),
                                              decoration: BoxDecoration(
                                                // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                border: Border(bottom: _selectedVasti.isEmpty ? BorderSide(color: Colors.grey) : BorderSide.none),
                                              ),
                                              confirmText: Text(
                                                Statics.getLabel('Submit'),
                                                style: const TextStyle(color: Colors.purple),
                                              ),
                                              cancelText: Text(
                                                Statics.getLabel('clear'),
                                                style: const TextStyle(color: Colors.purple),
                                              ),
                                              searchable: false,
                                              listType: MultiSelectListType.LIST,
                                              items: _linkedvasti!.map((bg) => MultiSelectItem(bg, bg.name!)).toList(),
                                              initialValue: _selectedVasti,
                                              chipDisplay: MultiSelectChipDisplay(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.purple, width: 0.7),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  // icon: Icon(Icons.done, color: Colors.purple, size: 16),
                                                  chipColor: Colors.white,
                                                  textStyle: TextStyle(fontSize: 12, color: Colors.purple, fontWeight: FontWeight.w500)),
                                              // onSaved: (newValue) {},
                                              onConfirm: (values) {
                                                // _selectedVasti = values;
                                                _selectedGram = [];
                                                _selectedVasti = values.map((e) {
                                                  if (e is GeoUnitMasterBAL) {
                                                    return e;
                                                  }
                                                  return null;
                                                }).toList();
                                                setState(() {});
                                                print("valueeeeeeeesssss >>>>>>>>>>>>>>> $values");
                                                // // if (selectedUpnagarList.contains(values)) {
                                                // selctedLevel = 'upnagarUpkhanda';
                                                // selctedLevelName = _linkedUpnagar!.where((upnagar) => selectedUpnagarList.contains(upnagar.geoUnitID)).map((upnagar) => upnagar.preferedname).toList().join(",");
                                                // //   selectedUpnagarList.add(bg);
                                                // // } else {
                                                // //   selectedUpnagarList.remove(bg);
                                                // // }
                                                // setState(() {});
                                                //
                                                // // print("selctedLevelId >>>>>>>>>>>>>>>>> $selctedLevelId");
                                                // print("valueeeeeeeesssss >>>>>>>>>>>>>>> ${_selectedVasti.join(",")}");
                                              },
                                            )
                                          // DropdownButtonFormField(
                                          //   decoration: InputDecoration(labelText: Statics.getLabel('Vasti')),
                                          //   isExpanded: true,
                                          //   value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                                          //   items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                          //   onChanged: (value) {
                                          //     setState(() {
                                          //    _selectedGram = [];
                                          //       _linkedvastiValue = value;
                                          //     });
                                          //   },
                                          // ),
                                        ],
                                      ),
                                    ),
                                    isExpanded: _isExpanded,
                                  ),
                                ],
                              ),
                              if (_selectedVasti.isNotEmpty || _selectedGram.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        textStyle: const TextStyle(fontSize: 14, color: Colors.purple),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      ),
                                      onPressed: () async {
                                        final bool isPresent = selectedGramVastiList.any((unit) => unit.nagarID.toString() == _linkednagarValue.toString());

                                        if (isPresent) {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text(Statics.getLabel('AskConfirmation')),
                                              content: Text("नगर आधीच निवडले आहे, तुम्हाला त्यात बादल करायचे आहे का??"),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text(Statics.getLabel('change')),
                                                  onPressed: () {},
                                                ),
                                                TextButton(
                                                  child: Text(Statics.getLabel('ConfirmationYes')),
                                                  onPressed: () async {
                                                    Navigator.of(ctx).pop();
                                                    setState(() {
                                                      selectedGramVastiListRowIndex = null;
                                                    });

                                                    final _data = selectedGramVastiList.firstWhere((unit) => unit.nagarID.toString() == _linkednagarValue.toString());
                                                    await editSelectedVastiGraamFun(_data);
                                                    // Navigator.pushReplacementNamed(context, AbhiyanAddSwayamsevakScreen.routeName);
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                          return;
                                        }
                                        setState(() {
                                          selectedGramVastiList.add(SaveAbhiyanSwayamsevakMappingforGruh(
                                            mahanagarID: int.tryParse(_linkedMahaanagarValue ?? "0") ?? 0,
                                            mahanagarName: _linkedMahaanagarName,
                                            vibhaagID: int.tryParse(_linkedVibhaagValue ?? "0") ?? 0,
                                            vibhaagName: _linkedVibhaagName,
                                            bhaagID: int.tryParse(_linkedbhaagValue ?? "0") ?? 0,
                                            bhaagName: _linkedbhaagName,
                                            nagarID: int.tryParse(_linkednagarValue ?? "0") ?? 0,
                                            nagarName: _linkednagarName,
                                            mandalID: int.tryParse(_linkedmandalValue ?? "0") ?? 0,
                                            mandalName: _linkedmandalName,
                                            vastiIDs: _selectedVasti.map((item) => item?.geoUnitID.toString()).join(','),
                                            vastiNames: _selectedVasti.map((item) => item?.name.toString()).join(', '),
                                            gramIDs: _selectedGram.map((item) => item?.geoUnitID.toString()).join(','),
                                            gramNames: _selectedGram.map((item) => item?.name.toString()).join(', '),
                                          ));
                                        });
                                        Future.delayed(
                                          Duration(milliseconds: 100),
                                          () {
                                            setState(() {
                                              _linkedMahaanagarValue = null;
                                              _linkedMahaanagarName = null;
                                              _linkedVibhaagValue = null;
                                              _linkedVibhaagName = null;
                                              _linkedbhaagValue = null;
                                              _linkedbhaagName = null;
                                              _linkednagarValue = null;
                                              _linkednagarName = null;
                                              _linkedmandalValue = null;
                                              _linkedmandalName = null;
                                              _selectedVasti = [];
                                              _selectedGram = [];
                                            });
                                          },
                                        );
                                        await populatelinkedMahaanagarDropdown();
                                        await populatelinkedVibhaagDropdown('');
                                        // populatelinkedBhaagDropdown('');
                                      },
                                      child: Text("+ ${Statics.getLabel("Add")}"),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                      // Align(
                      //   alignment: Alignment.center,
                      //   child: ElevatedButton(
                      //     style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                      //     onPressed: () async {
                      //       await getReportDataFun();
                      //       setState(() {
                      //         _isExpanded = false;
                      //         // isVastiSearch = true;
                      //       });
                      //     },
                      //     child: Text("${Statics.getLabel('Filters')}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      //   ),
                      // ),
                      SizedBox(height: 10),
                      //
                      if (selectedGramVastiList.isNotEmpty) selectedVastiGramTable(),
                      if (selectedGramVastiList.isNotEmpty) SizedBox(height: 18),

                      ///
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 9.0),
                            child: Text(
                              "${Statics.getLabel('sanstha')} :",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.58,
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
                                if (selectedSansthaValue == "अन्य")
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: TextFormField(
                                      autofocus: true,
                                      textInputAction: TextInputAction.done,
                                      controller: _anyaSansthaCntrl,
                                      decoration: InputDecoration(
                                        hintText: "संस्था कुठल्या विषयात काम करते",
                                      ),
                                      keyboardType: TextInputType.text,
                                      onSaved: (value) {
                                        // swDetails.fullName = value.trim();
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _sansthaNameCntrl,
                        decoration: InputDecoration(
                          labelText: "${Statics.getLabel('OrganizationName')}",
                          isDense: true,
                          border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        ),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          // swDetails.fullName = value.trim();
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _sansthaPadhCntrl,
                        decoration: InputDecoration(
                          labelText: "${Statics.getLabel('sansthetKuthalaPadavar')}",
                          isDense: true,
                          border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        ),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          // swDetails.fullName = value.trim();
                        },
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "${Statics.getLabel('SelectLevel')}",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (_level != null)
                            Expanded(
                              flex: 4,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  isDense: true,
                                  iconSize: 30,
                                  underline: SizedBox(),
                                  value: _levelValue == "" ? null : _levelValue,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedDayitvValue = "";
                                      _levelValue = newValue!;
                                      _geoUnitsValue = "";
                                      print(newValue);
                                    });
                                    populateGeoUnits(newValue);
                                  },
                                  items: _level!.map((bg) => DropdownMenuItem(value: bg.levelID.toString(), child: Text(Statics.getLabel(bg.levelName!)))).toList(),
                                ),
                              ),
                            )
                          else
                            Expanded(flex: 4, child: SizedBox()),
                        ],
                      ),
                      if (_levelValue != "") SizedBox(height: 15),
                      if (_levelValue != "")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "${Statics.getLabel('SelectLevelName')}",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                ":",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (_geoUnits != null)
                              Expanded(
                                flex: 4,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    isDense: true,
                                    iconSize: 30,
                                    underline: SizedBox(),
                                    value: _geoUnitsValue == "" ? null : _geoUnitsValue,
                                    onChanged: (String? newValue) {
                                      selectedDayitvValue = "";
                                      _geoUnitsValue = newValue!;
                                      print(newValue);
                                      setState(() {});
                                    },
                                    items: _geoUnits!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                  ),
                                ),
                              )
                            else
                              Expanded(flex: 4, child: SizedBox()),
                          ],
                        ),
                      SizedBox(height: 15),
                      if (_levelValue != "" && _geoUnitsValue != "")
                        // _levelValue == "2" || _levelValue == "3" ?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                Statics.getLabel("SelectDaayitva"),
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                ":",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  isDense: true,
                                  iconSize: 30,
                                  underline: SizedBox(),
                                  value: selectedDayitvValue == "" ? null : selectedDayitvValue,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedDayitvValue = newValue!;
                                    });
                                  },
                                  items: <String>["अभियान प्रमुख", "अभियान कार्यकर्ता"].map<DropdownMenuItem<String>>((String value) {
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
                    ],
                  ),
                // : Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         "दायित्व             :",
                //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                //       ),
                //       Container(
                //         width: MediaQuery.of(context).size.width * 0.6,
                //         alignment: Alignment.center,
                //         padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                //         child: DropdownButton<String>(
                //           isExpanded: true,
                //           isDense: true,
                //           iconSize: 30,
                //           underline: SizedBox(),
                //           value: selectedDayitvValue == "" ? null : selectedDayitvValue,
                //           onChanged: (String? newValue) {
                //             setState(() {
                //               selectedDayitvValue = newValue!;
                //             });
                //           },
                //           items: <String>["अभियान प्रमुख", "अभियान सह प्रमुख"].map<DropdownMenuItem<String>>((String value) {
                //             return DropdownMenuItem<String>(
                //               value: value,
                //               child: Padding(
                //                 padding: const EdgeInsets.only(top: 3.0),
                //                 child: Text(value),
                //               ),
                //             );
                //           }).toList(),
                //         ),
                //       ),
                //     ],
                //   ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                // if (selectedDayitvValue.isNotEmpty)
                showFields
                    ? MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                        onPressed: () async {
                          if (selectedAbhiyanValue.isEmpty) {
                            print("अभियान निवडा");
                            Statics.showToast("अभियान निवडा");
                            return null;
                          } else if (showFields && _fullNameCntrl.text.isEmpty) {
                            print("पूर्ण नाव प्रविष्ट करा");
                            Statics.showToast("पूर्ण नाव प्रविष्ट करा");
                            return null;
                          } else if (showFields && _mobileCntrl.text.isEmpty) {
                            print("मोबाइल क्रमांक प्रविष्ट करा");
                            Statics.showToast("मोबाइल क्रमांक प्रविष्ट करा");
                            return null;
                            // } else if (showFields && _linkedvastiValue == null && _linkedgraamValue == null) {
                            //   print("निवास स्थान निवडा");
                            //   Statics.showToast("निवास स्थान निवडा");
                            //   return null;
                          } else if (showFields && selectedSansthaValue == "अन्य" && _anyaSansthaCntrl.text.isEmpty) {
                            print("अन्य संस्था प्रविष्ट करा");
                            Statics.showToast("अन्य संस्था प्रविष्ट करा");
                            return null;
                          } else if (showFields && selectedSansthaValue != "" && _sansthaNameCntrl.text.isEmpty) {
                            print("संस्थेचे नाव प्रविष्ट करा");
                            Statics.showToast("संस्थेचे नाव प्रविष्ट करा");
                            return null;
                          } else if (showFields && selectedSansthaValue != "" && _sansthaPadhCntrl.text.isEmpty) {
                            print("संस्थेमध्ये पद प्रविष्ट करा");
                            Statics.showToast("संस्थेमध्ये पद प्रविष्ट करा");
                            return null;
                          } else if (_levelValue.isEmpty) {
                            print("${Statics.getLabel('selectStar')}");
                            Statics.showToast("${Statics.getLabel('selectStar')}");
                            return null;
                          } else if (_geoUnitsValue.isEmpty) {
                            print("स्तराचे नाव निवडा");
                            Statics.showToast("स्तराचे नाव निवडा");
                            return null;
                          } else if (selectedDayitvValue.isEmpty) {
                            print("दायित्व निवडा");
                            Statics.showToast("दायित्व निवडा");
                            return null;
                          } else {
                            if (!showFields) {
                              Statics.showToast("मोबाइल क्रमांक प्रविष्ट करा");
                              return null;
                            }
                            print("saving data");
                            await saveAbhiyaanSwayamsevakCall();
                          }
                          // _submit(context);
                        },
                        child: Text(
                          Statics.getLabel('Submit'),
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();

                          if (from == "swayamsevak") {
                            Fluttertoast.showToast(
                              msg: Statics.getLabel("workInProgress"),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                            return;
                          }
                          if (_searchController.text.length < 10) {
                            Statics.showToast(Statics.getLabel('MobileValidationMessage'));
                            return null;
                          }
                          await _search("Search");
                          setState(() {});
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.search), SizedBox(width: 6), Text(Statics.getLabel("search"))],
                        ),
                      ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget selectedVastiGramTable() {
    bool showMahaanagar = selectedGramVastiList.any((item) => item.mahanagarName != null && item.mahanagarName!.isNotEmpty);
    bool showVibhaag = selectedGramVastiList.any((item) => item.vibhaagName != null && item.vibhaagName!.isNotEmpty);
    bool showBhaag = selectedGramVastiList.any((item) => item.bhaagName != null && item.bhaagName!.isNotEmpty);
    // bool showShahar = selectedGramVastiList.any((item) => item.shaharName != null && item.mahanagarName!.isNotEmpty);
    bool showNagar = selectedGramVastiList.any((item) => item.nagarName != null && item.nagarName!.isNotEmpty);
    bool showMandal = selectedGramVastiList.any((item) => item.mandalName != null && item.mandalName!.isNotEmpty);
    bool showGram = selectedGramVastiList.any((item) => item.gramNames != null && item.gramNames!.isNotEmpty);
    bool showVasti = selectedGramVastiList.any((item) => item.vastiNames != null && item.vastiNames!.isNotEmpty);

    final List<String> headers = [
      Statics.getLabel('serialNo'),
      if (showMahaanagar) Statics.getLabel('Mahaanagar'),
      if (showVibhaag) Statics.getLabel('Vibhaag'),
      if (showBhaag) Statics.getLabel('Bhaag'),
      // Statics.getLabel('Shahar'),
      if (showNagar) Statics.getLabel('Nagar'),
      if (showVasti) Statics.getLabel('Vasti'),
      if (showMandal) Statics.getLabel('Mandal'),
      if (showGram) Statics.getLabel('Graam'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                rows: selectedGramVastiList.asMap().entries.map((entry) {
                  int index = entry.key;
                  var data = entry.value;
                  bool isSelected = selectedGramVastiListRowIndex == index;
                  return DataRow(
                      selected: isSelected,
                      color: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (isSelected) return Colors.yellow.shade100;
                          return null;
                        },
                      ),
                      onSelectChanged: (bool? selected) {
                        if (selected != null && selected) {
                          setState(() {
                            selectedGramVastiListRowIndex = index;
                          });
                        } else {
                          setState(() {
                            selectedGramVastiListRowIndex = null;
                          });
                        }
                      },
                      cells: [
                        DataCell(Text((index + 1).toString())),
                        if (showMahaanagar) DataCell(Text(data.mahanagarName == "" ? "--" : (data.mahanagarName ?? "--"))),
                        if (showVibhaag) DataCell(Text(data.vibhaagName == "" ? "--" : (data.vibhaagName ?? "--"))),
                        if (showBhaag) DataCell(Text(data.bhaagName == "" ? "--" : (data.bhaagName ?? "--"))),
                        if (showNagar) DataCell(Text(data.nagarName == "" ? "--" : (data.nagarName ?? "--"))),
                        if (showVasti) DataCell(Text(data.vastiNames == "" ? "--" : (data.vastiNames ?? "--"))),
                        if (showMandal) DataCell(Text(data.mandalName == "" ? "--" : (data.mandalName ?? "--"))),
                        if (showGram) DataCell(Text(data.gramNames == "" ? "--" : (data.gramNames ?? "--"))),
                      ]);
                }).toList(),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        if (selectedGramVastiListRowIndex != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () async {
                  final _data = selectedGramVastiList[selectedGramVastiListRowIndex!];
                  await editSelectedVastiGraamFun(_data);
                },
                child: Icon(Icons.edit, color: Colors.blue, size: 20),
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedGramVastiList.removeAt(selectedGramVastiListRowIndex!);
                  });
                  setState(() {
                    selectedGramVastiListRowIndex = null;
                  });
                },
                child: Icon(Icons.delete, color: Colors.red, size: 20),
              ),
            ],
          ),
      ],
    );

    // return Scrollbar(
    //   controller: _scrollController,
    //   thumbVisibility: true,
    //   interactive: true,
    //   thickness: 5,
    //   radius: Radius.circular(10),
    //   child: SingleChildScrollView(
    //     controller: _scrollController,
    //     scrollDirection: Axis.horizontal,
    //     child: DataTable(
    //       columnSpacing: 14,
    //       horizontalMargin: 12,
    //       headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
    //       border: TableBorder(verticalInside: BorderSide(width: 0.7, color: Colors.grey.shade200)),
    //       columns: headers
    //           .map((header) => DataColumn(
    //                 label: Container(
    //                   constraints: BoxConstraints(minWidth: 40, maxWidth: 200),
    //                   // constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.2),
    //                   child: Text(header, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
    //                 ),
    //               ))
    //           .toList(),
    //       rows: selectedGramVastiList.asMap().entries.map((entry) {
    //         int index = entry.key;
    //         var data = entry.value;
    //             return DataRow(cells: [
    //               DataCell(Center(
    //                   child: Row(
    //                 mainAxisAlignment: (level.karykakramcount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
    //                 children: [
    //                   if (level.karykakramcount != 0) SizedBox(width: 1),
    //                   Container(margin: EdgeInsets.only(right: level.karykakramcount != 0 ? 0 : 10), child: Text(level.karykakramcount.toString())),
    //                   if (level.karykakramcount != 0)
    //                     InkWell(
    //                       borderRadius: BorderRadius.circular(50),
    //                       onTap: () {
    //                         showInfoDialogBox(names: level.karykakramcountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable1"));
    //                       },
    //                       child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
    //                     ),
    //                 ],
    //               ))),
    //               DataCell(Center(
    //                   child: Row(
    //                 mainAxisAlignment: (level.karyakramnirdharitvedhvarcount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
    //                 children: [
    //                   if (level.karyakramnirdharitvedhvarcount != 0) SizedBox(width: 1),
    //                   Container(margin: EdgeInsets.only(right: level.karyakramnirdharitvedhvarcount != 0 ? 0 : 10), child: Text(level.karyakramnirdharitvedhvarcount.toString())),
    //                   if (level.karyakramnirdharitvedhvarcount != 0)
    //                     InkWell(
    //                       borderRadius: BorderRadius.circular(50),
    //                       onTap: () {
    //                         showInfoDialogBox(names: level.karyakramnirdharitvedhvarcountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable3"));
    //                       },
    //                       child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
    //                     ),
    //                 ],
    //               ))),
    //               DataCell(Center(
    //                   child: Row(
    //                 mainAxisAlignment: (level.vyaktigeetkhantastakcount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
    //                 children: [
    //                   if (level.vyaktigeetkhantastakcount != 0) SizedBox(width: 1),
    //                   Container(margin: EdgeInsets.only(right: level.vyaktigeetkhantastakcount != 0 ? 0 : 10), child: Text(level.vyaktigeetkhantastakcount.toString())),
    //                   if (level.vyaktigeetkhantastakcount != 0)
    //                     InkWell(
    //                       borderRadius: BorderRadius.circular(50),
    //                       onTap: () {
    //                         showInfoDialogBox(names: level.vyaktigeetkhantastakcountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable4"));
    //                       },
    //                       child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
    //                     ),
    //                 ],
    //               ))),
    //               DataCell(Center(
    //                   child: Row(
    //                 mainAxisAlignment: (level.skaraykramhisob24tasapurnacount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
    //                 children: [
    //                   if (level.skaraykramhisob24tasapurnacount != 0) SizedBox(width: 1),
    //                   Container(margin: EdgeInsets.only(right: level.skaraykramhisob24tasapurnacount != 0 ? 0 : 10), child: Text(level.skaraykramhisob24tasapurnacount.toString())),
    //                   if (level.skaraykramhisob24tasapurnacount != 0)
    //                     InkWell(
    //                       borderRadius: BorderRadius.circular(50),
    //                       onTap: () {
    //                         showInfoDialogBox(names: level.skaraykramhisob24tasapurnacountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable6"));
    //                       },
    //                       child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
    //                     ),
    //                 ],
    //               ))),
    //
    //               //sanchalan
    //               DataCell(Center(
    //                   child: Row(
    //                 mainAxisAlignment: (level.shanchalancount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
    //                 children: [
    //                   if (level.shanchalancount != 0) SizedBox(width: 1),
    //                   Container(margin: EdgeInsets.only(right: level.shanchalancount != 0 ? 0 : 10), child: Text(level.shanchalancount.toString())),
    //                   if (level.shanchalancount != 0)
    //                     InkWell(
    //                       borderRadius: BorderRadius.circular(50),
    //                       onTap: () {
    //                         showInfoDialogBox(names: level.shanchalancountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable2"));
    //                       },
    //                       child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
    //                     ),
    //                 ],
    //               ))),
    //               DataCell(Center(
    //                   child: Row(
    //                 mainAxisAlignment: (level.shanchalanghosvandancount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
    //                 children: [
    //                   if (level.shanchalanghosvandancount != 0) SizedBox(width: 1),
    //                   Container(margin: EdgeInsets.only(right: level.shanchalanghosvandancount != 0 ? 0 : 10), child: Text(level.shanchalanghosvandancount.toString())),
    //                   if (level.shanchalanghosvandancount != 0)
    //                     InkWell(
    //                       borderRadius: BorderRadius.circular(50),
    //                       onTap: () {
    //                         showInfoDialogBox(names: level.shanchalanghosvandancountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable5"));
    //                       },
    //                       child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
    //                     ),
    //                 ],
    //               ))),
    //               DataCell(Center(
    //                   child: Row(
    //                 mainAxisAlignment: (level.shanchalansadandacount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
    //                 children: [
    //                   if (level.shanchalansadandacount != 0) SizedBox(width: 1),
    //                   Container(margin: EdgeInsets.only(right: level.shanchalansadandacount != 0 ? 0 : 10), child: Text(level.shanchalansadandacount.toString())),
    //                   if (level.shanchalansadandacount != 0)
    //                     InkWell(
    //                       borderRadius: BorderRadius.circular(50),
    //                       onTap: () {
    //                         showInfoDialogBox(names: level.shanchalansadandacountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable7"));
    //                       },
    //                       child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
    //                     ),
    //                 ],
    //               ))),
    //             ]);
    //           }).toList() +
    //           [
    //             DataRow(color: MaterialStatePropertyAll(Colors.yellow.shade100), cells: [
    //               DataCell(Center(
    //                   child: Text(
    //                 data.fold(0, (sum, item) => sum + (item.karykakramcount ?? 0)).toString(),
    //                 style: TextStyle(fontWeight: FontWeight.w700),
    //               ))),
    //               DataCell(Center(
    //                   child: Text(
    //                 data.fold(0, (sum, item) => sum + (item.karyakramnirdharitvedhvarcount ?? 0)).toString(),
    //                 style: TextStyle(fontWeight: FontWeight.w700),
    //               ))),
    //               DataCell(Center(
    //                   child: Text(
    //                 data.fold(0, (sum, item) => sum + (item.vyaktigeetkhantastakcount ?? 0)).toString(),
    //                 style: TextStyle(fontWeight: FontWeight.w700),
    //               ))),
    //               DataCell(Center(
    //                   child: Text(
    //                 data.fold(0, (sum, item) => sum + (item.skaraykramhisob24tasapurnacount ?? 0)).toString(),
    //                 style: TextStyle(fontWeight: FontWeight.w700),
    //               ))),
    //
    //               //sanchalan
    //               DataCell(Center(
    //                   child: Text(
    //                 data.fold(0, (sum, item) => sum + (item.shanchalancount ?? 0)).toString(),
    //                 style: TextStyle(fontWeight: FontWeight.w700),
    //               ))),
    //               DataCell(Center(
    //                   child: Text(
    //                 data.fold(0, (sum, item) => sum + (item.shanchalanghosvandancount ?? 0)).toString(),
    //                 style: TextStyle(fontWeight: FontWeight.w700),
    //               ))),
    //               DataCell(Center(
    //                   child: Text(
    //                 data.fold(0, (sum, item) => sum + (item.shanchalansadandacount ?? 0)).toString(),
    //                 style: TextStyle(fontWeight: FontWeight.w700),
    //               ))),
    //             ])
    //           ],
    //     ),
    //   ),
    // );
  }
}
