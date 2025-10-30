import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../helpers/static_data.dart';
import '../../../models/response_model/AbhiyaanListResponse.dart';
import '../../../providers/bals.dart';
import '../../../providers/swayamsevak_provider.dart';
import '../../../widgets/swayamsevak_card.dart';

class AddAbhiyaanKaryakartaScreen extends StatefulWidget {
  static const String routeName = '/add-abhiyaan-karyakarta-screen';

  const AddAbhiyaanKaryakartaScreen({super.key});

  @override
  State<AddAbhiyaanKaryakartaScreen> createState() => _AddAbhiyaanKaryakartaScreenState();
}

class _AddAbhiyaanKaryakartaScreenState extends State<AddAbhiyaanKaryakartaScreen> {
  Statics.ScreenArguments? args;

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

  bool _isSelectAll = false;

  List<dynamic>? _swList;
  List<String> strEmail = [];
  List<String> strMobile = [];
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

  String? _sanghaShikshaVarsha = "";
  String? _vehicleValue = "";

  bool? _isTrainedInMukhyaDanda = false;
  bool? _isTrainedInMukhyaNiyuddha = false;
  bool? _isTrainedInMukhyaPadavinyas = false;
  bool? _isTrainedInMukhyaYogaasan = false;
  bool? _isTrainedInMukhyaYogachaap = false;
  bool? _isTrainedInMukhyaDandaYuddha = false;
  bool? _isTrainedInAnyaDanda = false;
  bool? _isTrainedInAnyaNiyuddha = false;
  bool? _isTrainedInAnyaPadavinyas = false;
  bool? _isTrainedInAnyaYogaasan = false;
  bool? _isTrainedInAnyaYogachaap = false;
  bool? _isTrainedInAnyaDandaYuddha = false;

  StaticMasterBAL? _daayitvaForValue;

  String _daayitvaValue = "";

  bool? _isGanveshComplete = false;
  bool? _noCap = false;
  bool? _noShirt = false;
  bool? _noPant = false;
  bool? _noBelt = false;
  bool? _noShoes = false;
  bool? _noSocks = false;
  bool? _noDanda = false;

  bool? _isPratidnyit = null;

  StaticMasterBAL? _standardValue;

  bool? _isTrainedInPrathamVanshi = false;
  bool? _isTrainedInPrathamVenu = false;
  bool? _isTrainedInPrathamAanak = false;
  bool? _isTrainedInPrathamShankha = false;
  bool? _isTrainedInPrathamNaagaanga = false;
  bool? _isTrainedInPrathamTurya = false;
  bool? _isTrainedInPrathamSwarad = false;
  bool? _isTrainedInPrathamGomukha = false;

  bool? _isTrainedInDwitiyaVanshi = false;
  bool? _isTrainedInDwitiyaVenu = false;
  bool? _isTrainedInDwitiyaAanak = false;
  bool? _isTrainedInDwitiyaShankha = false;
  bool? _isTrainedInDwitiyaNaagaanga = false;
  bool? _isTrainedInDwitiyaTurya = false;
  bool? _isTrainedInDwitiyaSwarad = false;
  bool? _isTrainedInDwitiyaGomukha = false;

  bool? _isTrainedInTrutiyaVanshi = false;
  bool? _isTrainedInTrutiyaVenu = false;
  bool? _isTrainedInTrutiyaAanak = false;
  bool? _isTrainedInTrutiyaShankha = false;
  bool? _isTrainedInTrutiyaNaagaanga = false;
  bool? _isTrainedInTrutiyaTurya = false;
  bool? _isTrainedInTrutiyaSwarad = false;
  bool? _isTrainedInTrutiyaGomukha = false;

  bool? _isTrainedInAnyaVanshi = false;
  bool? _isTrainedInAnyaVenu = false;
  bool? _isTrainedInAnyaAanak = false;
  bool? _isTrainedInAnyaShankha = false;
  bool? _isTrainedInAnyaNaagaanga = false;
  bool? _isTrainedInAnyaTurya = false;
  bool? _isTrainedInAnyaSwarad = false;
  bool? _isTrainedInAnyaGomukha = false;

  bool? _isPrathamLipi = null;
  bool? _isDwitiyaLipi = null;
  bool? _isTrutiyaLipi = null;
  bool? _isAnyaLipi = null;

  String? _preritSansthaValue = "";
  var _othOrgNameCtrl = TextEditingController();
  String? _sortingOnValue = "Name";
  bool? _isMon = null;
  bool? _isTue = null;
  bool? _isWed = null;
  bool? _isThu = null;
  bool? _isFri = null;
  bool? _isSat = null;
  bool? _isSun = null;

  bool? _hasVehicleDriver = false;
  bool? _hasBeenShikshak = null;
  bool? _noDaayitva = null;
  bool? _pravaasi = null;

  final _searchController = TextEditingController();
  var _shikshaFromYearCntrl = TextEditingController();
  var _shikshaToYearCntrl = TextEditingController();

  var _schoolNameCntrl = TextEditingController();

  String? _bldGrpvalue = "";
  String? _mthrTngvalue = "";
  String? _shaakhaSanchalanvalue = "";

  int? _educationUniversityID = null;
  var _pratidnyaYearCtrl = TextEditingController();
  var _educationUniversityNameCntrl = TextEditingController();
  var _educationOthrUniversityNameCntrl = TextEditingController();
  int? _collegeID = null;
  var _collegeOthrNameCntrl = TextEditingController();
  var _educationStandardNameCntrl = TextEditingController();
  var _educationOthrStandardNameCntrl = TextEditingController();
  int? _educationProgramID = null;
  var _educationProgramName = TextEditingController();
  var _educationOthrProgramName = TextEditingController();
  int? _educationCourseID = null;
  var _educationCourseName = TextEditingController();
  var _educationOthrCourseName = TextEditingController();
  List<MenuChoices> choices = [];
  var _rachanaaCountPrathamCntrl = TextEditingController();
  var _rachanaaCountDwitiyaCntrl = TextEditingController();
  var _rachanaaCountTrutiyaCntrl = TextEditingController();
  var _rachanaaCountAnyaCntrl = TextEditingController();

  var _govtDeptCtrl = TextEditingController();
  var _organizationNameCtrl = TextEditingController();
  var _industrialVerticalCtrl = TextEditingController();
  var _officeLocationCtrl = TextEditingController();
  var _organizationAtRetirementCtrl = TextEditingController();
  var _desgAtRetirementCtrl = TextEditingController();
  var _deptAtRetirementCtrl = TextEditingController();
  Map<String, bool> _values = {
    'Danda': false,
    'Niyuddha': false,
    'Yogaasan': false,
    'yogachap': false,
    'padvinyas': false,
    'danda-yuddha': false,
    'yog': false,
  };

  StaticMasterBAL? _categoryValue;

  List newData = [];
  bool showFields = false;

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
      _isSearching = false;
    });
  }

  void populatelinkedBhaagDropdown() async {
    print("bhaag called");
    _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), "", "", "");
    setState(() {
      _linkedbhaag = data;
    });
    print(_linkedbhaag);
    print("bhaag end");
  }

  void populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedshaharValue = _linkedvastiValue = _linkedshahar = _linkedvasti = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _linkedshahar = (shDD.length > 0 ? shDD : null);
    });
  }

  void populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    }
  }

  void populatelinkedMandalDropdown(String? nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
  }

  void populatelinkedGraamDropdown(String? mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
  }

  void populatelinkedVastiDropdown(String? nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
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
      await getSwayamsevakForGruhAbhiyaan(inputData);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    // await getAbhiyaanListData();
    Future.delayed(Duration.zero, () async {
      selectedAbhiyanValue = abhiyaanDataList.first.abhiyaanID.toString();
    });
    populatelinkedBhaagDropdown();
    _level = await Statics.getLevelLDB();
    setState(() {
      _level = _level!.where((element) => element.levelName == "Vasti" || element.levelName == "Graam").toList();
      // _search("Search");
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

  saveAbhiyaanSwayamsevakCall() async {
    try {
      List<UserDataBAL> user = await Statics.getUserDataLDB();

      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        var data = {
          "AbhiyanSwayamsevakID": 0,
          "AbhiyaanID": selectedAbhiyanValue,
          "SwayamsevakID": newData.isNotEmpty ? newData.first['SwayamsevakID'] : "",
          "MobileNo": _mobileCntrl.text.isEmpty
              ? newData.isNotEmpty
                  ? newData.first['MobileNumber']
                  : ""
              : _mobileCntrl.text,
          "full_name": _fullNameCntrl.text,
          "Email": _emailCntrl.text,
          "samajik_sanstha": selectedSansthaValue,
          "sanstha_name": _sansthaNameCntrl.text,
          "SansthaPadh": _sansthaPadhCntrl.text,
          "DaayitvaName": selectedDayitvValue,
          "bhaag_id": _linkedbhaagValue,
          "nagar_id": _linkednagarValue,
          "vasti_id": _linkedvastiValue,
          "mandal_id": _linkedmandalValue,
          "gram_id": _linkedgraamValue,
          "LevelID": _levelValue,
          "LevelName": _geoUnitsValue,
          "AbhiyanDaayitvaID": 0,
          "Mahangarid": 0,
          "Vibhagid": 0,
        };

        var result = await SwayamsevakProvider().saveAbhiyanSwayamsevak(jsonEncode(data));
        if (result.status == "200") {
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
                  },
                ),
                TextButton(
                  child: Text(getLabel('ConfirmationYes')),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    // Navigator.pushReplacementNamed(context, AbhiyanAddSwayamsevakScreen.routeName);
                  },
                ),
              ],
            ),
          );
        } else {
          Statics.showToast(result.message);
        }
      }
    } catch (e) {
      Statics.showToast(Statics.getLabel('unableToSaveData'));
    }
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // args = ModalRoute.of(context)!.settings.arguments as Statics.ScreenArguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("अभियान कार्यकर्ता जोडा"),
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
                      child: Container(
                        // width: MediaQuery.of(context).size.width * 0.6,
                        // margin: EdgeInsets.only(right: 5),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(fontSize: 16),
                          autofocus: false,
                          onChanged: (v) {
                            if (v.isEmpty) {
                              showFields = false;
                            }
                            setState(() {});
                          },
                          inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 15),
                            suffixIcon: InkWell(
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                if (_searchController.text.length < 10) {
                                  Statics.showToast(Statics.getLabel('MobileValidationMessage'));
                                  return null;
                                }
                                await _search("Search");
                                setState(() {});
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: Icon(
                                Icons.search,
                                size: 25,
                              ),
                            ),
                            border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                if (newData.isNotEmpty && _searchController.text.isNotEmpty)
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(5.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: newData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AbhiyanSwayamsevakCard(newData[index], _search);
                      },
                    ),
                  ),
                // if (_isSearching)
                // Container(
                //     height: MediaQuery.of(context).size.height * 0.2,
                //     width: MediaQuery.of(context).size.width,
                //     padding: const EdgeInsets.all(5.0),
                //     child: Center(
                //       child: CircularProgressIndicator(),
                //     )),
                if (newData.isNotEmpty && _searchController.text.isNotEmpty)
                  SizedBox(
                    height: 15,
                  ),
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
                      Container(
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
                                  title: Text(Statics.getLabel('SelectGeoUnit')),
                                );
                              },
                              body: Container(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    if (_linkedbhaag != null)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                                        isExpanded: true,
                                        value: _linkedbhaagValue == "" ? null : _linkedbhaagValue,
                                        items: _linkedbhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedbhaagValue = value;
                                            populatelinkedShaharDropdown(value!);
                                            populatelinkedNagarDropdown(value, null);
                                          });
                                        },
                                      ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    if (_linkedshahar != null && _linkedshahar!.length > 0)
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
                                      ),
                                    if (_linkedshahar != null && _linkedshahar!.length > 0)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    if (_linkednagar != null && _linkednagar!.length > 0)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                                        isExpanded: true,
                                        value: _linkednagarValue == "" ? null : _linkednagarValue,
                                        items: _linkednagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkednagarValue = value;
                                            populatelinkedMandalDropdown(value);
                                            populatelinkedVastiDropdown(value);
                                          });
                                        },
                                      ),
                                    if (_linkednagar != null && _linkednagar!.length > 0)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    if (_linkedmandal != null && _linkedmandal!.length > 0)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Mandal')),
                                        isExpanded: true,
                                        value: _linkedmandalValue == "" ? null : _linkedmandalValue,
                                        items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedmandalValue = value;
                                            populatelinkedGraamDropdown(value);
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
                                        value: _linkedgraamValue == "" ? null : _linkedgraamValue,
                                        items: _linkedgraam!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedgraamValue = value;
                                          });
                                        },
                                      ),
                                    if (_linkedvasti != null && _linkedvasti!.length > 0)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Vasti')),
                                        isExpanded: true,
                                        value: _linkedvastiValue == "" ? null : _linkedvastiValue,
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
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 9.0),
                            child: Text(
                              "${Statics.getLabel('Vasti')} :",
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
                      SizedBox(
                        height: 15,
                      ),
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
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
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
                if (_levelValue != "")
                  SizedBox(
                    height: 15,
                  ),
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
                SizedBox(
                  height: 15,
                ),
                if (_levelValue != "" && _geoUnitsValue != "")
                  // _levelValue == "2" || _levelValue == "3" ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "दायित्व",
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
                MaterialButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.button!.color,
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
                    } else if (showFields && _linkedvastiValue == null && _linkedgraamValue == null) {
                      print("निवास स्थान निवडा");
                      Statics.showToast("निवास स्थान निवडा");
                      return null;
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
                      if (!showFields && newData.isEmpty) {
                        Statics.showToast("मोबाइल क्रमांक प्रविष्ट करा");
                        return null;
                      }
                      print("saving data");
                      // await saveAbhiyaanSwayamsevakCall();
                    }
                    // _submit(context);
                  },
                  child: Text(
                    Statics.getLabel('Submit'),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                Text(
                  "आम्ही मोबाईल आणि नावाने शोधण्यासाठी पर्याय देऊ.",
                  style: TextStyle(fontSize: 11),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
