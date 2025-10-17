import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/AbhiyaanListResponse.dart';
import '../../../models/response_model/AbhiyaanLoginDataResponse.dart';
import '../../../models/response_model/AbhiyaanSwayamsevakListResponse.dart';
import '../../../providers/bals.dart';
import '../../../providers/swayamsevak_provider.dart';
import '../../edit_swayamsevak_screen.dart';

class AbhiyaanSwayamsevakTab extends StatefulWidget {
  final AbhiyanSwayamsevakdata? initialData;

  const AbhiyaanSwayamsevakTab({super.key, this.initialData});

  @override
  State<AbhiyaanSwayamsevakTab> createState() => _AbhiyaanSwayamsevakTabState();
}

class _AbhiyaanSwayamsevakTabState extends State<AbhiyaanSwayamsevakTab> {
  // List<MenuChoices> choices = [
  //   MenuChoices("EditMenu", Icons.add, "सहभागी कार्यकर्ता जोडा")
  // ];
  List<AbhiyanSwayamsevakList> abhiyaanSwayamsevakDataList = [];
  String? selectedSwayamAbhiyanValue = "";
  bool? _isSearching = false;
  String? selectedDayitvValue = "";
  bool _searched = false;
  List<AbhiyaanList> abhiyaanDataList = [
    AbhiyaanList.fromJson({
      "AbhiyaanID": 1,
      "AbhiyaanName": Statics.getLabel('gruhSamparkAbhiyan') + " (Static Data)",
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
  String? type;

  // AbhiyanSwayamsevakdata? initialData;

  @override
  void initState() {
    super.initState();
    populateDropdown();
    abhiyaanSwayamsevakDataList = [
      AbhiyanSwayamsevakList(
        abhiyanSwayamsevakID: 1,
        daayityaName: "राम शर्मा",
        participantName: "RS - Niyojak",
        participantNumber: "9876543210",
      ),
      AbhiyanSwayamsevakList(
        abhiyanSwayamsevakID: 2,
        daayityaName: "राम शर्मा",
        participantName: "Dev - Niyojak",
        participantNumber: "9876543210",
      ),
      AbhiyanSwayamsevakList(
        abhiyanSwayamsevakID: 3,
        daayityaName: "राम शर्मा",
        participantName: "Rao - Niyojak",
        participantNumber: "9876543210",
      ),
      AbhiyanSwayamsevakList(
        abhiyanSwayamsevakID: 4,
        daayityaName: "राम शर्मा",
        participantName: "Yash - Niyojak",
        participantNumber: "9876543210",
      ),
    ];
    Future.delayed(Duration.zero, () async {
      // await getAbhiyaanListData();
      selectedSwayamAbhiyanValue = abhiyaanDataList.first.abhiyaanID.toString();
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
      builder: (context) => StatefulBuilder(
        builder: (context, set) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          // contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          insetPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          // titlePadding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        Statics.getLabel('selectMukhyaAtithi') + " (Dummy Data)",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      icon: const Icon(Icons.close, color: Colors.redAccent),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(EditSwayamsevakScreen.routeName, arguments: Statics.ScreenArgumentsNew(0, Statics.getLabel('EditMenu')));
                      },
                      child: Text(
                        Statics.getLabel('fillNewRecord'),
                        style: const TextStyle(color: Colors.purpleAccent),
                      ),
                    )),
                SizedBox(height: 16),
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.58),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      itemCount: abhiyaanSwayamsevakDataList.length,
                      itemBuilder: (context, index) {
                        final swItem = abhiyaanSwayamsevakDataList[index];
                        return Card(
                          margin: EdgeInsets.all(5),
                          elevation: 5,
                          child: CheckboxListTile(
                            onChanged: (value) => set(() {
                              swItem.isSelected = !swItem.isSelected;
                            }),
                            value: swItem.isSelected,
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            title: Text(swItem.participantName!),
                            subtitle: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(swItem.daayityaName!),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Wrap(direction: Axis.vertical, spacing: 5, children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'M: ${swItem.participantNumber.toString()}${swItem.email.toString().isNotEmpty ? ',' : ''}',
                                        style: TextStyle(color: Colors.blue),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            UrlLauncher.launch("tel://" + swItem.participantNumber.toString());
                                          },
                                      ),
                                    ),
                                    if (swItem.email != null && swItem.email!.isNotEmpty)
                                      RichText(
                                        text: TextSpan(
                                          text: 'E: ${swItem.email.toString()}',
                                          style: TextStyle(color: Colors.blue),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              UrlLauncher.launch("mailto:" + swItem.email.toString());
                                            },
                                        ),
                                      ),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 8),
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
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "${Statics.getLabel('Abhiyaan')}",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
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
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 5,
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button!.color,
                    onPressed: () async {
                      setState(() {
                        _searched = true;
                      });
                      // if(Statics.userDetails[])
                      // await getAbhiyaanGruhaSamparkListData();
                    },
                    child: Text(
                      "${Statics.getLabel('search')}",
                      style: TextStyle(fontSize: 22),
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),

              if (_searched)
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
                      textColor: Theme.of(context).primaryTextTheme.button!.color,
                      onPressed: showDummyList,
                      child: Text(
                        "${Statics.getLabel('SwayamsevaksList')}",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                )
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
}
