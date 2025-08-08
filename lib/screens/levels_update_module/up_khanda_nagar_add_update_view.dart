import 'dart:convert';

import 'package:flutter/material.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../models/response_model/vasti_up_data_model.dart';
import '../../providers/bals.dart';

class UpNagarkhandaAddUpdateView extends StatefulWidget {
  static const routeName = '/upNagarkhanda-data-update';

  @override
  _UpNagarkhandaAddUpdateViewState createState() =>
      _UpNagarkhandaAddUpdateViewState();
}

class _UpNagarkhandaAddUpdateViewState
    extends State<UpNagarkhandaAddUpdateView> {
  TextEditingController marathiNameController = TextEditingController();
  TextEditingController hindiNameController = TextEditingController();
  TextEditingController englishNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  void initState() {
    super.initState();
    populateDropdown();
  }

  bool viewcontainer = false;
  bool _isExpanded = true;
  bool showupnagarUpkhandaNewAdd = false;
  bool showupnagarUpkhandaLinked = false;
  bool showTextFieldEnterUpData = false;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedBhaag;
  List<GeoUnitMasterBAL>? _linkedShahar;
  List<GeoUnitMasterBAL>? _linkedNagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<StaticMasterBAL>? _baithakTypes;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedBhaagValue = '';
  String? _linkedNagarValue = '';
  String? _linkedgraamValue = '';
  String? _linkedMandalValue = '';
  String? _linkedvastiValue = '';
  String? mahanagarId = '';
  String? vibhagId = '';
  String? selctedLevel = 'praant';
  String? selctedLevelName = '';
  String? selctedLevelId = '';
  String? selctedLevelNameNew = '';
  String? upnagarLinkedValue = '';

  void populateDropdown() async {
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    populatelinkedMahaanagarDropdown();
    populatelinkedVibhaagDropdown('');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!
        .where((element) => element.showAnnualBaithakkey!.contains('1'))
        .toList();
    print("_baithakTypes :-- $_baithakTypes");
    setState(() {});
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(
      String vibhaagIDStr) async {
    _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(
      String mahaanagarIDStr) async {
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['VibhaagLevelID'].toString(),
        mahaanagarIDStr,
        (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'),
        '');
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(
      String bhaagIDStr) async {
    _linkedShahar = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _linkedShahar = (shDD.length > 0 ? shDD : null);
    });
    return shDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(
      String? bhaagIDStr, String? shaharIDStr) async {
    _linkedNagarValue = null;
    _linkedNagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(
          Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(
          Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(
      String nagarIDStr) async {
    _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(
      String mandalIDStr) async {
    _linkedgraamValue = null;
    print("mandalIDStr mandalIDStr ==> $mandalIDStr");
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(
      String nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
    return vsDD;
  }

  VastiUpDataListModel? vastiUpDataListModel;

  Future<void> getVastiUpDataList() async {
    var inputData = json.encode({
      "AppUserID": Statics.userDetails['userID'],
      "GeoUnitID": selctedLevelId,
    });

    print("_submitForm $inputData");

    vastiUpDataListModel = await Statics.getVastiUpdata(inputData);

    if (vastiUpDataListModel != null) {
      print("Data fetched successfully");
      setState(() {
        hideSelectedIds = vastiUpDataListModel!.vastimandallist!
            .where((item) =>
                item.linkedUpaNagarID.toString() == upnagarLinkedValue ||
                item.linkedUpaNagarID == 0)
            .map((item) => item.geoUnitID.toString())
            .join(',');

        print("selectedIdString getVastiUpDataList  --->>>   $hideSelectedIds");
      });
    } else {
      print("Failed to fetch data");
    }
  }

  int? selectedUpVastiNagarId;
  Future<void> submitUpkhandaForm() async {
    var inputData = json.encode({
      "AppUserID": Statics.userDetails['userID'],
      "GeoUnitID": selctedLevelId,
      "Upnagarid": upnagarLinkedValue ?? 0,
      "vastiids": selectedIdString,
      "GeoUnitName": englishNameController.text,
      "GeoUnitNameMarathi": marathiNameController.text,
      "GeoUnitNameHindi": hindiNameController.text,
    });
    print("_submitForm" + inputData);
    await Statics.saveUpNagarUpkhandadata(context, inputData);
    resetAll();
  }

  Future<void> resetAll() async {
    setState(() {
      upnagarLinkedValue = null;
      marathiNameController.clear();
      hindiNameController.clear();
      englishNameController.clear();
      showTextFieldEnterUpData = false;
      selectedIdString = '';
      // _linkedMahaanagarValue = _linkedVibhaagValue = _linkedBhaagValue =
      //     _linkedNagarValue = _linkedvastiValue = _linkedMandalValue = null;
      // _linkedMahaanagar =
      //     _linkedVibhaag = _linkedBhaag = _linkedNagar = _linkedvasti = null;
      viewcontainer = false;
      _isExpanded = true;
      showupnagarUpkhandaNewAdd = false;
      showupnagarUpkhandaLinked = false;
      showTextFieldEnterUpData = false;
    });

    // ✅ These must also return Future<void>
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                        title: Text(Statics.getLabel('selectBhaugolikSthar'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purpleAccent)),
                      );
                    },
                    body: Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          if (_linkedMahaanagar != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                  labelText: Statics.getLabel('Mahaanagar')),
                              isExpanded: true,
                              value: _linkedMahaanagarValue == ""
                                  ? null
                                  : _linkedMahaanagarValue,
                              items: _linkedMahaanagar!
                                  .map((bg) => DropdownMenuItem(
                                        value: bg.geoUnitID.toString(),
                                        child: Text(bg.name!),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedMahaanagar!
                                    .firstWhere((bg) =>
                                        bg.geoUnitID.toString() == value);
                                setState(() {
                                  _linkedMahaanagarValue = value;
                                  _linkedVibhaagValue = null;
                                  _linkedBhaagValue = null;
                                  _linkedNagarValue = null;
                                  populatelinkedVibhaagDropdown(value!);
                                  mahanagarId = value;
                                  selctedLevelId = value;
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Mahanagar';
                                });
                                print("Selected Id: $value");
                                print(
                                    "Selected Level Name: ${selectedItem.name}");
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_linkedVibhaag != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                  labelText: Statics.getLabel('Vibhaag')),
                              isExpanded: true,
                              value: _linkedVibhaagValue == ""
                                  ? null
                                  : _linkedVibhaagValue,
                              items: _linkedVibhaag!
                                  .map((bg) => DropdownMenuItem(
                                      value: bg.geoUnitID.toString(),
                                      child: Text(bg.name!)))
                                  .toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedVibhaag!.firstWhere(
                                    (bg) => bg.geoUnitID.toString() == value);
                                print(value);
                                setState(() {
                                  _linkedVibhaagValue = value;
                                  populatelinkedBhaagDropdown(value!);
                                  vibhagId = value;
                                  _linkedBhaagValue = _linkedNagarValue = null;
                                  _linkedBhaag = _linkedNagar = null;
                                  selctedLevelId = value;
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Vibhaag';
                                });
                                print("Selected Id: $value");
                                print(
                                    "Selected Level Name: ${selectedItem.name}");
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_linkedBhaag != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                  labelText: Statics.getLabel('Bhaag')),
                              isExpanded: true,
                              value: _linkedBhaagValue == ""
                                  ? null
                                  : _linkedBhaagValue,
                              items: _linkedBhaag!
                                  .map((bg) => DropdownMenuItem(
                                      value: bg.geoUnitID.toString(),
                                      child: Text(bg.name!)))
                                  .toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedBhaag!.firstWhere(
                                    (bg) => bg.geoUnitID.toString() == value);
                                setState(() {
                                  _linkedBhaagValue = value;
                                  populatelinkedNagarDropdown(value, null);
                                  selctedLevelId = value;
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Bhaag';
                                });
                                print("Selected Id: $value");
                                print(
                                    "Selected Level Name: ${selectedItem.name}");
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_linkedNagar != null && _linkedNagar!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                  labelText: Statics.getLabel('Nagar')),
                              isExpanded: true,
                              value: _linkedNagarValue == ""
                                  ? null
                                  : _linkedNagarValue,
                              items: _linkedNagar!
                                  .map((bg) => DropdownMenuItem(
                                      value: bg.geoUnitID.toString(),
                                      child: Text(bg.name!)))
                                  .toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedNagar!.firstWhere(
                                    (bg) => bg.geoUnitID.toString() == value);
                                setState(() {
                                  _linkedNagarValue = value;
                                  populatelinkedVastiDropdown(value!);
                                  populatelinkedMandalDropdown(value);
                                  selctedLevelId = value;
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Nagar';
                                });
                                print("Selected Id: $value");
                                print(
                                    "Selected Level Name: ${selectedItem.name}");
                              },
                            ),
                          // if (_linkedNagar != null && _linkedNagar!.length > 0)
                          //   SizedBox(
                          //     height: 10,
                          //   ),
                          // if (_linkedvasti != null && _linkedvasti!.length > 0)
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
                          //       final selectedItem = _linkedvasti!.firstWhere(
                          //           (bg) => bg.geoUnitID.toString() == value);
                          //       setState(() {
                          //         _linkedvastiValue = value;
                          //         selctedLevelId = value;
                          //         selctedLevelName = selectedItem.name ?? "";
                          //         selctedLevel = 'Vasti';
                          //       });
                          //       print("Selected Id: $value");
                          //       print(
                          //           "Selected Level Name: ${selectedItem.name}");
                          //     },
                          //   ),
                          // if (_linkedvasti != null && _linkedvasti!.length > 0)
                          //   SizedBox(
                          //     height: 10,
                          //   ),
                          // if (_linkedmandal != null &&
                          //     _linkedmandal!.length > 0)
                          //   DropdownButtonFormField(
                          //     decoration: InputDecoration(
                          //         labelText: Statics.getLabel('Mandal')),
                          //     isExpanded: true,
                          //     value: _linkedMandalValue == ""
                          //         ? null
                          //         : _linkedMandalValue,
                          //     items: _linkedmandal!
                          //         .map((bg) => DropdownMenuItem(
                          //             value: bg.geoUnitID.toString(),
                          //             child: Text(bg.name!)))
                          //         .toList(),
                          //     onChanged: (value) {
                          //       final selectedItem = _linkedmandal!.firstWhere(
                          //           (bg) => bg.geoUnitID.toString() == value);
                          //       setState(() {
                          //         _linkedMandalValue = value;
                          //         populatelinkedGraamDropdown(value!);
                          //         selctedLevelId = value;
                          //         selctedLevelName = selectedItem.name ?? "";
                          //         selctedLevel = 'Mandal';
                          //       });
                          //       print("Selected Id: $value");
                          //       print(
                          //           "Selected Level Name: ${selectedItem.name}");
                          //     },
                          //   ),
                          // if (_linkedmandal != null &&
                          //     _linkedmandal!.length > 0)
                          //   SizedBox(
                          //     height: 10,
                          //   ),
                          // if (_linkedgraam != null && _linkedgraam!.length > 0)
                          //   DropdownButtonFormField(
                          //     decoration: InputDecoration(
                          //         labelText: Statics.getLabel('Graam')),
                          //     isExpanded: true,
                          //     value: _linkedgraamValue == ""
                          //         ? null
                          //         : _linkedgraamValue,
                          //     items: _linkedgraam!
                          //         .map((bg) => DropdownMenuItem(
                          //               value: bg.geoUnitID.toString(),
                          //               child: Text(bg.name!),
                          //             ))
                          //         .toList(),
                          //     onChanged: (value) {
                          //       final selectedItem = _linkedgraam!.firstWhere(
                          //           (bg) => bg.geoUnitID.toString() == value);
                          //       setState(() {
                          //         _linkedgraamValue =
                          //             value; // D2 me bhi same value aayegi
                          //         selctedLevelId = value;
                          //         selctedLevelName = selectedItem.name ?? "";
                          //         selctedLevel = 'Graam';
                          //       });
                          //       print("D1 Selected Id: $value");
                          //       print(
                          //           "D1 Selected Level Name: ${selectedItem.name}");
                          //     },
                          //   ),
                          // if (_linkedgraam != null && _linkedgraam!.length > 0)
                          //   SizedBox(
                          //     height: 10,
                          //   ),
                          if (selctedLevel == 'Nagar')
                            Container(
                              margin: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 8,
                                    ),
                                    color: Theme.of(context).primaryColor,
                                    textColor: Theme.of(context)
                                        .primaryTextTheme
                                        .button!
                                        .color,
                                    onPressed: () async {
                                      await resetAll();

                                      setState(() {
                                        showupnagarUpkhandaNewAdd = true;
                                        _isExpanded = false;
                                        getVastiUpDataList();
                                      });
                                    },
                                    child: Text(
                                      Statics.getLabel('upnagarUpkhandaNewAdd'),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // MaterialButton(
                                  //   shape: RoundedRectangleBorder(
                                  //       borderRadius:
                                  //           BorderRadius.circular(30)),
                                  //   padding: EdgeInsets.symmetric(
                                  //     horizontal: 15,
                                  //     vertical: 8,
                                  //   ),
                                  //   color: Theme.of(context).primaryColor,
                                  //   textColor: Theme.of(context)
                                  //       .primaryTextTheme
                                  //       .button!
                                  //       .color,
                                  //   onPressed: () {
                                  //     setState(() {
                                  //       showupnagarUpkhandaNewAdd = false;
                                  //       showupnagarUpkhandaLinked = true;
                                  //       _isExpanded = false;
                                  //     });
                                  //   },
                                  //   child: Text(
                                  //     Statics.getLabel('upnagarUpkhandaLinked'),
                                  //     style: TextStyle(fontSize: 16),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  MaterialButton(
                                      onPressed: () {
                                        setState(() {
                                          _linkedMahaanagarValue =
                                              _linkedVibhaagValue =
                                                  _linkedBhaagValue =
                                                      _linkedNagarValue =
                                                          _linkedvastiValue =
                                                              _linkedMandalValue =
                                                                  null;
                                          _linkedMahaanagar = _linkedVibhaag =
                                              _linkedBhaag = _linkedNagar =
                                                  _linkedvasti = null;
                                          viewcontainer = false;
                                        });
                                        populatelinkedMahaanagarDropdown();
                                        populatelinkedVibhaagDropdown('');
                                      },
                                      child: Text(Statics.getLabel('clear'))),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    isExpanded: _isExpanded,
                  ),
                ],
              ),
              //======================================================   Show Upnagar add & Update VIEW ===============================================================
              SizedBox(
                height: 20,
              ),
              if (showupnagarUpkhandaNewAdd == true)
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.purpleAccent),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            Statics.getLabel('upnagarUpkhandaNewAdd'),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.purpleAccent),
                          ),
                        ),
                        SizedBox(height: 30),
                        // if (isVastiSearch == true)
                        Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.purpleAccent, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "$selctedLevel ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                if (selctedLevelName != "")
                                  Text(
                                    "  ->   $selctedLevelName",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                              ],
                            )),
                        SizedBox(height: 20),
                        // Row(
                        //   children: [
                        //     if (vastiUpDataListModel!.upnagarmandallist != null)
                        //       Expanded(
                        //         child: DropdownButtonFormField<String>(
                        //           focusColor: Colors.purpleAccent,
                        //           decoration: InputDecoration(
                        //             labelText:
                        //                 Statics.getLabel('upnagarUpkhanda'),
                        //             isDense: true,
                        //             contentPadding: EdgeInsets.symmetric(
                        //                 horizontal: 12, vertical: 10),
                        //             enabledBorder: OutlineInputBorder(
                        //               borderRadius:
                        //                   BorderRadius.all(Radius.circular(10)),
                        //               borderSide: BorderSide(
                        //                   color: Colors.purpleAccent),
                        //             ),
                        //             focusedBorder: OutlineInputBorder(
                        //               borderRadius:
                        //                   BorderRadius.all(Radius.circular(10)),
                        //               borderSide: BorderSide(
                        //                   color: Colors.purpleAccent, width: 2),
                        //             ),
                        //             border: OutlineInputBorder(
                        //               borderRadius:
                        //                   BorderRadius.all(Radius.circular(10)),
                        //             ),
                        //           ),
                        //           dropdownColor: Colors
                        //               .white, // Optional: set dropdown background color
                        //           isExpanded: true,
                        //           value: upnagarLinkedValue!.isEmpty
                        //               ? null
                        //               : upnagarLinkedValue,
                        //           items: vastiUpDataListModel!
                        //               .upnagarmandallist!
                        //               .map((bg) => DropdownMenuItem(
                        //                     value: bg.geoUnitID.toString(),
                        //                     child: Text(bg.geoUnitName ?? ""),
                        //                   ))
                        //               .toList(),
                        //           onChanged: (value) {
                        //             setState(() {
                        //               upnagarLinkedValue = value ?? "";
                        //             });
                        //           },
                        //         ),
                        //       ),
                        //     SizedBox(width: 10),
                        //     InkWell(
                        //       onTap: () {
                        //         showTextFieldEnterUpData = true;
                        //       },
                        //       child: Container(
                        //         width: 40,
                        //         height: 40,
                        //         decoration: BoxDecoration(
                        //           border: Border.all(
                        //             color: Colors.purpleAccent,
                        //             width: 2,
                        //           ),
                        //           borderRadius: BorderRadius.all(
                        //             Radius.circular(10),
                        //           ),
                        //         ),
                        //         child: Center(
                        //           child: Icon(
                        //             Icons.add,
                        //             color: Colors.purpleAccent,
                        //             size: 25,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // if (vastiUpDataListModel!.upnagarmandallist != [] ||
                        //     showTextFieldEnterUpData == true)
                        //   Column(
                        //     children: [
                        //       SizedBox(height: 20),
                        //       TextFormField(
                        //         controller: marathiNameController,
                        //         keyboardType: TextInputType.text,
                        //         textDirection: TextDirection.ltr,
                        //         decoration: InputDecoration(
                        //           border: OutlineInputBorder(),
                        //           hintText: "मराठीत नाव",
                        //           labelText: "मराठीत नाव",
                        //           contentPadding: EdgeInsets.symmetric(
                        //               vertical: 10, horizontal: 12),
                        //         ),
                        //         validator: (value) {
                        //           if (value == null || value.isEmpty) {
                        //             return "कृपया मराठी नाव प्रविष्ट करा";
                        //           }
                        //           return null;
                        //         },
                        //       ),
                        //       SizedBox(height: 20),
                        //       TextFormField(
                        //         controller: hindiNameController,
                        //         keyboardType: TextInputType.text,
                        //         textDirection: TextDirection.ltr,
                        //         decoration: InputDecoration(
                        //           border: OutlineInputBorder(),
                        //           hintText: "हिंदी में नाम",
                        //           labelText: "हिंदी में नाम",
                        //           contentPadding: EdgeInsets.symmetric(
                        //               vertical: 10, horizontal: 12),
                        //         ),
                        //         validator: (value) {
                        //           if (value == null || value.isEmpty) {
                        //             return "कृपया हिंदी नाम दर्ज करें";
                        //           }
                        //           return null;
                        //         },
                        //       ),
                        //       SizedBox(height: 20),
                        //       TextFormField(
                        //         controller: englishNameController,
                        //         keyboardType: TextInputType.text,
                        //         textDirection: TextDirection.ltr,
                        //         decoration: InputDecoration(
                        //           border: OutlineInputBorder(),
                        //           hintText: "Name in English",
                        //           labelText: "Name in English",
                        //           contentPadding: EdgeInsets.symmetric(
                        //               vertical: 10, horizontal: 12),
                        //         ),
                        //         validator: (value) {
                        //           if (value == null || value.isEmpty) {
                        //             return "Please enter the name in English";
                        //           }
                        //           return null;
                        //         },
                        //       ),
                        //       SizedBox(height: 20),
                        //     ],
                        //   ),

                        Row(
                          children: [
                            if (vastiUpDataListModel?.upnagarmandallist !=
                                    null &&
                                vastiUpDataListModel!
                                    .upnagarmandallist!.isNotEmpty) ...[
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  focusColor: Colors.purpleAccent,
                                  decoration: InputDecoration(
                                    labelText:
                                        Statics.getLabel('upnagarUpkhanda'),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Colors.purpleAccent),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Colors.purpleAccent, width: 2),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                  dropdownColor: Colors.white,
                                  isExpanded: true,
                                  value: upnagarLinkedValue == null ||
                                          upnagarLinkedValue == ""
                                      ? null
                                      : upnagarLinkedValue,
                                  items: vastiUpDataListModel!
                                      .upnagarmandallist!
                                      .map((bg) => DropdownMenuItem(
                                            value: bg.geoUnitID.toString(),
                                            child: Text(bg.geoUnitName ?? ""),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      upnagarLinkedValue = value ?? "";

                                      // Find selected item and populate controllers
                                      var selected = vastiUpDataListModel!
                                          .upnagarmandallist!
                                          .firstWhere((e) =>
                                              e.geoUnitID.toString() == value);

                                      marathiNameController.text =
                                          selected.geoUnitNameMarathi ?? "";
                                      hindiNameController.text =
                                          selected.geoUnitNameHindi ?? "";
                                      englishNameController.text =
                                          selected.geoUnitName ?? "";

                                      showTextFieldEnterUpData = true;

                                      // selectedIdString = vastiUpDataListModel!
                                      //     .upnagarmandallist!
                                      //     .where((item) =>
                                      //         item.linkedUpaNagarID == value ||
                                      //         item.linkedUpaNagarID == 0)
                                      //     .map((item) =>
                                      //         item.geoUnitID.toString())
                                      //     .join(',');
                                      // hideSelectedIds =
                                    });
                                    print(
                                        "selectedIdString in dropdown ---> $selectedIdString");
                                  },
                                ),
                              )
                            ] else ...[
                              Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                        color: Colors.purpleAccent,
                                      )),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(Statics.getLabel(
                                          'upnagarUpkhandaNewAdd')),
                                      Icon(Icons.arrow_right_alt)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  upnagarLinkedValue = null;
                                  marathiNameController.clear();
                                  hindiNameController.clear();
                                  englishNameController.clear();
                                  showTextFieldEnterUpData = true;
                                  selectedIdString = '';
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.purpleAccent,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                  child: Icon(Icons.add,
                                      color: Colors.purpleAccent, size: 25),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (showTextFieldEnterUpData)
                          Column(
                            children: [
                              SizedBox(height: 20),
                              TextFormField(
                                controller: marathiNameController,
                                keyboardType: TextInputType.text,
                                textDirection: TextDirection.ltr,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "मराठीत नाव",
                                  labelText: "मराठीत नाव",
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "कृपया मराठी नाव प्रविष्ट करा";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: hindiNameController,
                                keyboardType: TextInputType.text,
                                textDirection: TextDirection.ltr,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "हिंदी में नाम",
                                  labelText: "हिंदी में नाम",
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "कृपया हिंदी नाम दर्ज करें";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: englishNameController,
                                keyboardType: TextInputType.text,
                                textDirection: TextDirection.ltr,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Name in English",
                                  labelText: "Name in English",
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter the name in English";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            showGeoUnitMultiSelectPopup(
                              context,
                              initiallySelectedIds: selectedIdString,
                              hideSelectedIds: hideSelectedIds,
                            );
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            width: 200,
                            height: 30,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.purpleAccent.shade100),
                                color: Colors.purpleAccent.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 5),
                                  Text(
                                    "${Statics.getLabel('addVasti')}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              submitUpkhandaForm();
                            }
                          },
                          child: Text(Statics.getLabel('Submit'),
                              style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String? selectedIdString;
  String? hideSelectedIds;

  Future<void> showGeoUnitMultiSelectPopup(
    BuildContext context, {
    String? initiallySelectedIds,
    String? hideSelectedIds,
  }) async {
    print("selectedIdString ====?> $selectedIdString");

    final List<Upnagarmandallist> fullList =
        vastiUpDataListModel!.vastimandallist ?? [];

    final Set<String> allowedIds = (hideSelectedIds ?? "")
        .split(",")
        .where((id) => id.trim().isNotEmpty)
        .toSet();

    // ✅ Show only items whose IDs are in `allowedIds`
    final List<Upnagarmandallist> geoUnitList = fullList
        .where((item) => allowedIds.contains(item.geoUnitID.toString()))
        .toList();

    final Set<String> preSelected = (initiallySelectedIds ?? "")
        .split(",")
        .where((id) => id.trim().isNotEmpty)
        .toSet();

    Map<String, bool> selectedMap = {
      for (var item in geoUnitList)
        item.geoUnitID.toString():
            preSelected.contains(item.geoUnitID.toString())
    };

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Select Items"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: geoUnitList.map<Widget>((item) {
                    String id = item.geoUnitID.toString();
                    String name = item.preferedname ?? "";
                    return CheckboxListTile(
                      value: selectedMap[id],
                      title: Text(name),
                      onChanged: (val) {
                        setState(() {
                          selectedMap[id] = val ?? false;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                ElevatedButton(
                  child: Text("OK"),
                  onPressed: () {
                    List<String> selectedIds = selectedMap.entries
                        .where((e) => e.value)
                        .map((e) => e.key)
                        .toList();

                    selectedIdString = selectedIds.join(",");
                    print("Selected IDs: $selectedIdString");

                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
}
