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
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";

  AbhiyanSwayamsevakdata? initialData;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getInitialData();
      await getAbhiyaanListData();
    });

    // populatelinkedBhaagDropdown();
    populateDropdown();
    super.initState();
  }

  void populatelinkedMahaanagarDropdown() async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
  }

  void populatelinkedVibhaagDropdown() async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), '', '', '');
    setState(() {
      _linkedVibhaag = data;
    });
  }

  void populatelinkedBhaagDropdown(String? vibhaagIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr!, 'Vibhaag', '');
    setState(() {
      _linkedbhaag = data;
    });
  }

  void populatelinkedShaharDropdown(String? bhaagIDStr) async {
    _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
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
          "vasti_id": _linkedvastiValue == null ? 0 : int.parse(_linkedvastiValue!),
          "gram_id": _linkedgraamValue == null ? 0 : int.parse(_linkedgraamValue!),
          "CreatedByID": initialData!.abhiyanSwayamsevakID!,
          "SmallBaithak": _smallBaithakDone == true ? "1":'0',
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

  Future<void> populateDropdown() async {
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
          populatelinkedMandalDropdown(_linkednagarValue);
          populatelinkedVastiDropdown(_linkednagarValue);
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
          populatelinkedVastiDropdown(_linkednagarValue);
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
                            DateTime? date = await showDatePicker(
                                context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now());
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
                  Container(
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
                                  IgnorePointer(
                                    ignoring: _linkedVibhaagDisable,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                                      isExpanded: true,
                                      value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                                      items: _linkedVibhaag!
                                          .map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!)))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkedVibhaagValue = value;
                                          populatelinkedBhaagDropdown(value);
                                        });
                                      },
                                    ),
                                  ),
                                if (_linkedVibhaag != null && _linkedVibhaag!.length > 0)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                                  IgnorePointer(
                                    ignoring: _linkedbhaagDisable,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                                      isExpanded: true,
                                      value: _linkedbhaagValue == "" ? null : _linkedbhaagValue,
                                      items:
                                          _linkedbhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkedbhaagValue = value;
                                          populatelinkedShaharDropdown(value);
                                          populatelinkedNagarDropdown(value, null);
                                        });
                                      },
                                    ),
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (_linkedshahar != null && _linkedshahar!.length > 0)
                                  IgnorePointer(
                                    ignoring: _linkedshaharDisable,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                                      isExpanded: true,
                                      value: _linkedshaharValue == "" ? null : _linkedshaharValue,
                                      items: _linkedshahar!
                                          .map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!)))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkedshaharValue = value;
                                          populatelinkedNagarDropdown(null, value);
                                        });
                                      },
                                    ),
                                  ),
                                if (_linkedshahar != null && _linkedshahar!.length > 0)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (_linkednagar != null && _linkednagar!.length > 0)
                                  IgnorePointer(
                                    ignoring: _linkednagarDisable,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                                      isExpanded: true,
                                      value: _linkednagarValue == "" ? null : _linkednagarValue,
                                      items:
                                          _linkednagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkednagarValue = value;
                                          populatelinkedMandalDropdown(value);
                                          populatelinkedVastiDropdown(value);
                                        });
                                      },
                                    ),
                                  ),
                                if (_linkednagar != null && _linkednagar!.length > 0)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (_linkedmandal != null && _linkedmandal!.length > 0)
                                  IgnorePointer(
                                    ignoring: _linkedmandalDisable,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: Statics.getLabel('Mandal')),
                                      isExpanded: true,
                                      value: _linkedmandalValue == "" ? null : _linkedmandalValue,
                                      items: _linkedmandal!
                                          .map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!)))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkedmandalValue = value;
                                          populatelinkedGraamDropdown(value);
                                        });
                                      },
                                    ),
                                  ),
                                if (_linkedmandal != null && _linkedmandal!.length > 0)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (_linkedgraam != null && _linkedgraam!.length > 0)
                                  IgnorePointer(
                                    ignoring: _linkedgraamDisable,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: Statics.getLabel('Graam')),
                                      isExpanded: true,
                                      value: _linkedgraamValue == "" ? null : _linkedgraamValue,
                                      items:
                                          _linkedgraam!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkedgraamValue = value;
                                        });
                                      },
                                    ),
                                  ),
                                if (_linkedvasti != null && _linkedvasti!.length > 0)
                                  IgnorePointer(
                                    ignoring: _linkedvastiDisable,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: Statics.getLabel('Vasti')),
                                      isExpanded: true,
                                      value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                                      items:
                                          _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkedvastiValue = value;
                                        });
                                      },
                                    ),
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
                                await Navigator.of(context)
                                    .pushNamed(AddEditVisheshVyaktiScreen.routeName, arguments: vishishtaList[i])
                                    .then((result) {
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
                      } else if ( _smallBaithakDone == true && baithakCountController.text.isEmpty) {
                        Statics.showToast(" ${Statics.getLabel('baithakHeldCount')} संख्या प्रविष्ट करा");
                        return null;
                      } else if ( _smallBaithakDone == true && baithakmenCountController.text.isEmpty) {
                        Statics.showToast(" ${Statics.getLabel('menCount')} संख्या प्रविष्ट करा");
                        return null;
                      }else if (_smallBaithakDone == true && baithakwomenCountController.text.isEmpty) {
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
}
