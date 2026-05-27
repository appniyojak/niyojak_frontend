import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../models/response_model/vasti_up_data_model.dart';
import '../../providers/bals.dart';
import '../../utils/globals.dart';
import '../../utils/stable_geounit_class.dart';

class UpNagarkhandaAddUpdateView extends StatefulWidget {
  static const routeName = '/upNagarkhanda-data-update';

  @override
  _UpNagarkhandaAddUpdateViewState createState() => _UpNagarkhandaAddUpdateViewState();
}

class _UpNagarkhandaAddUpdateViewState extends State<UpNagarkhandaAddUpdateView> {
  TextEditingController marathiNameController = TextEditingController();
  TextEditingController hindiNameController = TextEditingController();
  TextEditingController englishNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  void initState() {
    super.initState();
    //getGeoUnitID();
    // getMyDetailsColumnsAndRows();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  int totalCount = 0;
  int remainingCount = 0;

  Upnagarmandallist? selectedUpnagar;

  bool viewcontainer = false;
  bool _isExpanded = true;
  bool _isLoading = false;
  bool showupnagarUpkhandaNewAdd = false;
  bool showupnagarUpkhandaTable = false;
  bool showNavinButton = false;
  bool showupnagarUpkhandaLinked = false;
  bool showTextFieldEnterUpData = false;

  List<StaticMasterBAL>? _baithakTypes;

  String? upnagarLinkedValue = '';

  // void populateDropdown() async {
  //   var data = await Statics.getStaticLDB('AnnualBaithakType');
  //   populatelinkedMahaanagarDropdown();
  //   populatelinkedVibhaagDropdown('');
  //   if (!mounted) return;
  //   _baithakTypes = data;
  //   _baithakTypes = _baithakTypes!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
  //   print("_baithakTypes :-- $_baithakTypes");
  //   setState(() {});
  // }
  Future<void> initData() async {
    final dm = await MyAppGlobals.getLevelLDB();

    final controller = context.read<GeoHierarchyController>();

    await controller.initialize(dm);

    await populateDropdown();
    setState(() {});
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    // populatelinkedMahaanagarDropdown();
    // populatelinkedVibhaagDropdown('');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
    print("_baithakTypes :-- $_baithakTypes");
    setState(() {});
  }

  VastiUpDataListModel? vastiUpDataListModel;

  Future<void> getVastiUpDataList(String? selectedGeoUnitId) async {
    setState(() {
      _isExpanded = false;
      _isLoading = true;
    });
    var inputData = json.encode({
      "AppUserID": Statics.userDetails['userID'],
      "GeoUnitID": selectedGeoUnitId,
      "isnagar": 6,
    });

    print("_submitForm $inputData");

    vastiUpDataListModel = await Statics.getVastiUpdata(inputData);

    setState(() {
      _isLoading = false;
    });

    if (vastiUpDataListModel != null) {
      print("Data fetched successfully");
      setState(() {
        _isExpanded = false;
        showupnagarUpkhandaTable = true;
        hideSelectedIds = vastiUpDataListModel!.vastimandallist!
            .where((item) => item.linkedUpaNagarID.toString() != upnagarLinkedValue && item.linkedUpaNagarID != 0)
            .map((item) => item.geoUnitID.toString())
            .join(',');

        print("selectedIdString getVastiUpDataList  --->>>   $hideSelectedIds");

        showNavinButton = true;
      });
      setState(() {
        totalCount =
            vastiUpDataListModel!.upnagarmandallist?.fold(0, (sum, m1) => (sum ?? 0) + (vastiUpDataListModel!.vastimandallist?.where((m2) => m2.linkedUpaNagarID == m1.geoUnitID).length ?? 0)) ?? 0;
        remainingCount = (vastiUpDataListModel!.vastimandallist?.length ?? 0) - totalCount;
      });
    } else {
      print("Failed to fetch data");
    }
  }

  Future<void> submitUpkhandaForm() async {
    var inputData = json.encode({
      "AppUserID": Statics.userDetails['userID'],
      "GeoUnitID": context.read<GeoHierarchyController>().deepestSelectedGeoUnitId,
      "Upnagarid": upnagarLinkedValue ?? 0,
      "vastiids": selectedIdString,
      "GeoUnitName": englishNameController.text,
      "GeoUnitNameMarathi": marathiNameController.text,
      "GeoUnitNameHindi": hindiNameController.text,
      "isnagar": 6,
    });
    print("_submitForm" + inputData);
    vastiUpDataListModel = await Statics.saveUpNagarUpkhandadata(context, inputData);
    setState(() {
      totalCount =
          vastiUpDataListModel!.upnagarmandallist?.fold(0, (sum, m1) => (sum ?? 0) + (vastiUpDataListModel!.vastimandallist?.where((m2) => m2.linkedUpaNagarID == m1.geoUnitID).length ?? 0)) ?? 0;
      remainingCount = (vastiUpDataListModel!.vastimandallist?.length ?? 0) - totalCount;
    });
    resetAll();
  }

  Future<void> resetAll() async {
    setState(() {
      upnagarLinkedValue = null;
      marathiNameController.clear();
      hindiNameController.clear();
      englishNameController.clear();
      showTextFieldEnterUpData = false;
      // selectedIdString = '';
      // _linkedMahaanagarValue = _linkedVibhaagValue = _linkedBhaagValue = _linkedNagarValue = _linkedvastiValue = _linkedMandalValue = null;
      // _linkedMahaanagar = _linkedVibhaag = _linkedBhaag = _linkedNagar = _linkedvasti = null;
      // selectedIdString = "";
      // hideSelectedIds = "";
      // viewcontainer = false;
      // _isExpanded = true;
      showupnagarUpkhandaNewAdd = false;
      // showupnagarUpkhandaTable = false;
      showupnagarUpkhandaLinked = false;
      showTextFieldEnterUpData = false;
      // vastiUpDataListModel = null;
      viewcontainer = false;
      // _isExpanded = true;
      showupnagarUpkhandaNewAdd = false;
      // showupnagarUpkhandaTable = false;
      showupnagarUpkhandaLinked = false;
      showTextFieldEnterUpData = false;
    });

    // await populatelinkedMahaanagarDropdown();
    // await populatelinkedVibhaagDropdown(_linkedMahaanagarValue.toString());
  }

  void showUpkhandaPopupDialog({
    VoidCallback? onYesTap,
    VoidCallback? onNoTap,
    String from = "new",
  }) {
    final _controller = context.read<GeoHierarchyController>();

    showDialog(
      context: context,
      builder: (ctx) {
        print("popup opened from >>>>>>> $from");
        print("popup opened >>>>>>> $upnagarLinkedValue");
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: StatefulBuilder(
            builder: (context, set) {
              return Container(
                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.purpleAccent), borderRadius: BorderRadius.all(Radius.circular(15))),
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          Statics.getLabel('upnagarUpkhandaNewAdd'),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                        ),
                      ),
                      SizedBox(height: 30),
                      // if (isVastiSearch == true)
                      Container(
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purpleAccent, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Statics.getLabel("NagarShahari"),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              if (_controller.deepestSelectedGeoUnitName != null && _controller.deepestSelectedGeoUnitName != "")
                                Text(
                                  "   ->   ${_controller.deepestSelectedGeoUnitName}",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
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

                      ///CHANGED
                      // if (from != "edit")
                      //   Row(
                      //     children: [
                      //       if (vastiUpDataListModel?.upnagarmandallist != null && vastiUpDataListModel!.upnagarmandallist!.isNotEmpty) ...[
                      //         Expanded(
                      //           child: DropdownButtonFormField<String>(
                      //               focusColor: Colors.purpleAccent,
                      //               decoration: InputDecoration(
                      //                 labelText: Statics.getLabel('upnagarUpkhanda'),
                      //                 isDense: true,
                      //                 contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      //                 enabledBorder: OutlineInputBorder(
                      //                   borderRadius: BorderRadius.all(Radius.circular(10)),
                      //                   borderSide: BorderSide(color: Colors.purpleAccent),
                      //                 ),
                      //                 focusedBorder: OutlineInputBorder(
                      //                   borderRadius: BorderRadius.all(Radius.circular(10)),
                      //                   borderSide: BorderSide(color: Colors.purpleAccent, width: 2),
                      //                 ),
                      //                 border: OutlineInputBorder(
                      //                   borderRadius: BorderRadius.all(Radius.circular(10)),
                      //                 ),
                      //               ),
                      //               dropdownColor: Colors.white,
                      //               isExpanded: true,
                      //               value: upnagarLinkedValue == null || upnagarLinkedValue == "" ? null : upnagarLinkedValue,
                      //               items: vastiUpDataListModel!.upnagarmandallist!
                      //                   .map((bg) => DropdownMenuItem(
                      //                         value: bg.geoUnitID.toString(),
                      //                         child: Text(bg.geoUnitName ?? ""),
                      //                       ))
                      //                   .toList(),
                      //               // onChanged: (value) {
                      //               //   setState(() {
                      //               //     upnagarLinkedValue = value ?? "";
                      //               //
                      //               //     // Find selected item and populate controllers
                      //               //     var selected = vastiUpDataListModel!
                      //               //         .upnagarmandallist!
                      //               //         .firstWhere((e) =>
                      //               //             e.geoUnitID.toString() == value);
                      //               //
                      //               //     marathiNameController.text =
                      //               //         selected.geoUnitNameMarathi ?? "";
                      //               //     hindiNameController.text =
                      //               //         selected.geoUnitNameHindi ?? "";
                      //               //     englishNameController.text =
                      //               //         selected.geoUnitName ?? "";
                      //               //
                      //               //     showTextFieldEnterUpData = true;
                      //               //
                      //               //     selectedIdString = vastiUpDataListModel!
                      //               //         .upnagarmandallist!
                      //               //         .where((item) =>
                      //               //             item.linkedUpaNagarID == value ||
                      //               //             item.linkedUpaNagarID == 0)
                      //               //         .map((item) =>
                      //               //             item.geoUnitID.toString())
                      //               //         .join(',');
                      //               //     hideSelectedIds = vastiUpDataListModel!
                      //               //         .upnagarmandallist!
                      //               //         .where((item) =>
                      //               //             item.linkedUpaNagarID == value ||
                      //               //             item.linkedUpaNagarID == 0)
                      //               //         .map((item) =>
                      //               //             item.geoUnitID.toString())
                      //               //         .join(',');
                      //               //   });
                      //               //   print(
                      //               //       "selectedIdString in dropdown ---> $selectedIdString");
                      //               // },
                      //               onChanged: (value) {
                      //                 set(() {
                      //                   upnagarLinkedValue = value ?? "";
                      //
                      //                   // Find selected item and populate controllers
                      //                   selectedUpnagar = vastiUpDataListModel!.upnagarmandallist!.firstWhere((e) => e.geoUnitID.toString() == value);
                      //
                      //                   marathiNameController.text = selectedUpnagar!.geoUnitNameMarathi ?? "";
                      //                   hindiNameController.text = selectedUpnagar!.geoUnitNameHindi ?? "";
                      //                   englishNameController.text = selectedUpnagar!.geoUnitName ?? "";
                      //
                      //                   showTextFieldEnterUpData = true;
                      //
                      //                   // 1. hideSelectedIds → jinke linkedUpaNagarID != value aur != 0
                      //                   hideSelectedIds = vastiUpDataListModel!.vastimandallist!
                      //                       .where((item) => item.linkedUpaNagarID.toString() != value && item.linkedUpaNagarID != 0)
                      //                       .map((item) => item.geoUnitID.toString())
                      //                       .join(',');
                      //
                      //                   // 2. selectedIdString → jinke linkedUpaNagarID == value (checked in popup)
                      //                   selectedIdString =
                      //                       vastiUpDataListModel!.vastimandallist!.where((item) => item.linkedUpaNagarID.toString() == value).map((item) => item.geoUnitID.toString()).join(',');
                      //
                      //                   // Debug print
                      //                   print("selectedIdString (checked) ---> $selectedIdString");
                      //                   print("hideSelectedIds (hidden) ---> $hideSelectedIds");
                      //                 });
                      //               }),
                      //         )
                      //       ] else ...[
                      //         Expanded(
                      //           child: Container(
                      //             height: 40,
                      //             decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.all(Radius.circular(10)),
                      //                 border: Border.all(
                      //                   color: Colors.purpleAccent,
                      //                 )),
                      //             child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //               children: [Text(Statics.getLabel('upnagarUpkhandaNewAdd')), Icon(Icons.arrow_right_alt)],
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //       SizedBox(width: 10),
                      //       InkWell(
                      //         onTap: () {
                      //           set(() {
                      //             upnagarLinkedValue = null;
                      //             marathiNameController.clear();
                      //             hindiNameController.clear();
                      //             englishNameController.clear();
                      //             showTextFieldEnterUpData = true;
                      //             hideSelectedIds = vastiUpDataListModel!.vastimandallist!
                      //                 .where((item) => item.linkedUpaNagarID.toString() != upnagarLinkedValue && item.linkedUpaNagarID != 0)
                      //                 .map((item) => item.geoUnitID.toString())
                      //                 .join(',');
                      //           });
                      //         },
                      //         child: Container(
                      //           width: 80,
                      //           height: 40,
                      //           decoration: BoxDecoration(
                      //             border: Border.all(
                      //               color: Colors.purpleAccent,
                      //             ),
                      //             borderRadius: BorderRadius.all(Radius.circular(10)),
                      //           ),
                      //           child: Center(
                      //             child: Icon(Icons.add, color: Colors.purpleAccent, size: 25),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
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
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                      SizedBox(height: 14),
                      Text(
                        "${Statics.getLabel('upnagarUpkhandaLinked')}",
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            showGeoUnitMultiSelectPopup(
                              context,
                              initiallySelectedIds: selectedIdString,
                              hideSelectedIds: hideSelectedIds,
                            );
                            set(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            width: 120,
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.purpleAccent.shade100),
                                // color:
                                //     Colors.purpleAccent.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                "${Statics.getLabel('addVasti')}",
                                style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(color: Colors.grey),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                if (onYesTap != null) onYesTap();
                                await submitUpkhandaForm();
                                Navigator.pop(ctx);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              width: 80,
                              height: 35,
                              decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 5),
                                    Text(
                                      "${Statics.getLabel('Submit')}",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              set(() {
                                upnagarLinkedValue = null;
                                selectedUpnagar = null;
                                marathiNameController.clear();
                                hindiNameController.clear();
                                englishNameController.clear();
                                showTextFieldEnterUpData = false;
                                hideSelectedIds = null;
                                selectedIdString = null;
                              });
                              if (onNoTap != null) onNoTap();
                              Navigator.pop(ctx);
                            },
                            child: Text(
                              Statics.getLabel('clear'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              vastiMandalDropdown(),
              //======================================================   Show Upnagar add & Update VIEW ===============================================================
              SizedBox(height: 20),
              if (showNavinButton)
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        upnagarLinkedValue = null;
                        marathiNameController.clear();
                        hindiNameController.clear();
                        englishNameController.clear();
                        showTextFieldEnterUpData = true;
                        hideSelectedIds = vastiUpDataListModel!.vastimandallist!
                            .where((item) => item.linkedUpaNagarID.toString() != upnagarLinkedValue && item.linkedUpaNagarID != 0)
                            .map((item) => item.geoUnitID.toString())
                            .join(',');
                      });
                      showUpkhandaPopupDialog();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      width: 100,
                      decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white, size: 15),
                            SizedBox(width: 5),
                            Text(
                              "${Statics.getLabel('AddButton')}",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // ElevatedButton.icon(
                  //   onPressed: () => setState(() {
                  //     showupnagarUpkhandaTable = false;
                  //     showupnagarUpkhandaNewAdd = true;
                  //   }),
                  //   icon: Icon(Icons.add, size: 18),
                  //   label: Text("${Statics.getLabel('AddButton')}"),
                  // ),
                ),
              SizedBox(height: 16),
              if (_isLoading) Center(child: CircularProgressIndicator()),
              if (showupnagarUpkhandaTable)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Table(
                          border: TableBorder.symmetric(inside: BorderSide(width: 0.4, color: Colors.grey.shade400)),
                          columnWidths: const {
                            0: FlexColumnWidth(0.9),
                            1: FlexColumnWidth(1.7),
                            2: FlexColumnWidth(0.9),
                          },
                          // border: TableBorder.symmetric(inside: BorderSide(width: 0.4, color: Colors.grey.shade400)),
                          // showCheckboxColumn: false,
                          // checkboxHorizontalMargin: 0,
                          // // columnSpacing: 0,
                          // headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                          // headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                          // columns: [
                          //   DataColumn(label: SizedBox()),
                          //   DataColumn(
                          //       label: Text(
                          //         "${Statics.getLabel('Name')}",
                          //       )),
                          //   DataColumn(
                          //       label: Text(
                          //         "${Statics.getLabel('Vasti')}/${Statics.getLabel('Mandal')}",
                          //       )),
                          //   // DataColumn(label: SizedBox()),
                          // ],
                          children: vastiUpDataListModel == null
                              ? []
                              : [
                                    // Header Row
                                    TableRow(
                                      decoration: BoxDecoration(color: Colors.purple.shade50),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.02,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("${Statics.getLabel('Name')}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text("${Statics.getLabel('Vasti')}/${Statics.getLabel('Mandal')}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                                        ),
                                      ],
                                    ),
                                  ] +
                                  vastiUpDataListModel!.upnagarmandallist!.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    var data = entry.value;
                                    return TableRow(children: [
                                      // DataCell(Text((index + 1).toString())),
                                      Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                // style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                                onTap: () {
                                                  setState(() {
                                                    // 1. hideSelectedIds → jinke linkedUpaNagarID != value aur != 0
                                                    hideSelectedIds = vastiUpDataListModel!.vastimandallist!
                                                        .where((item) => item.linkedUpaNagarID.toString() != data.geoUnitID.toString() && item.linkedUpaNagarID != 0)
                                                        .map((item) => item.geoUnitID.toString())
                                                        .join(',');

                                                    // 2. selectedIdString → jinke linkedUpaNagarID == value (checked in popup)
                                                    selectedIdString = vastiUpDataListModel!.vastimandallist!
                                                        .where((item) => item.linkedUpaNagarID.toString() == data.geoUnitID.toString())
                                                        .map((item) => item.geoUnitID.toString())
                                                        .join(',');
                                                  });
                                                  showGeoUnitVastiMandalCountPopup(
                                                    context,
                                                    title: data.preferedname,
                                                    initiallySelectedIds: selectedIdString,
                                                    hideSelectedIds: hideSelectedIds,
                                                  );
                                                  setState(() {});
                                                },
                                                child: Icon(Icons.remove_red_eye, size: 18, color: Colors.purpleAccent),
                                              ),
                                              SizedBox(width: 16),
                                              InkWell(
                                                // style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                                onTap: () {
                                                  setState(() {
                                                    showupnagarUpkhandaNewAdd = true;
                                                    upnagarLinkedValue = data.geoUnitID.toString() ?? "";

                                                    // Find selected item and populate controllers
                                                    selectedUpnagar = vastiUpDataListModel!.upnagarmandallist!.firstWhere((e) => e.geoUnitID.toString() == data.geoUnitID.toString());

                                                    marathiNameController.text = selectedUpnagar!.geoUnitNameMarathi ?? "";
                                                    hindiNameController.text = selectedUpnagar!.geoUnitNameHindi ?? "";
                                                    englishNameController.text = selectedUpnagar!.geoUnitName ?? "";

                                                    showTextFieldEnterUpData = true;

                                                    // 1. hideSelectedIds → jinke linkedUpaNagarID != value aur != 0
                                                    hideSelectedIds = vastiUpDataListModel!.vastimandallist!
                                                        .where((item) => item.linkedUpaNagarID.toString() != data.geoUnitID.toString() && item.linkedUpaNagarID != 0)
                                                        .map((item) => item.geoUnitID.toString())
                                                        .join(',');

                                                    // 2. selectedIdString → jinke linkedUpaNagarID == value (checked in popup)
                                                    selectedIdString = vastiUpDataListModel!.vastimandallist!
                                                        .where((item) => item.linkedUpaNagarID.toString() == data.geoUnitID.toString())
                                                        .map((item) => item.geoUnitID.toString())
                                                        .join(',');

                                                    // Debug print
                                                    print("selectedIdString (checked) ---> $selectedIdString");
                                                    print("hideSelectedIds (hidden) ---> $hideSelectedIds");
                                                  });
                                                  showUpkhandaPopupDialog(from: "edit");
                                                },
                                                child: Icon(Icons.edit, color: Colors.blue, size: 20),
                                              )
                                            ],
                                          )),
                                      Padding(padding: EdgeInsets.all(8), child: Text(data.preferedname ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true)),
                                      Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Center(child: Text(vastiUpDataListModel?.vastimandallist?.where((e) => e.linkedUpaNagarID == data.geoUnitID).length.toString() ?? '0'))),
                                    ]);
                                  }).toList() +
                                  [
                                    TableRow(decoration: BoxDecoration(color: Colors.amber.shade50), children: [
                                      Padding(padding: EdgeInsets.all(8), child: SizedBox()),
                                      Padding(padding: EdgeInsets.all(8), child: Text("${Statics.getLabel('Total')}", style: TextStyle(fontWeight: FontWeight.w600))),
                                      Padding(padding: EdgeInsets.all(8), child: Center(child: Text(totalCount.toString()))),
                                      // DataCell(SizedBox()),
                                    ]),
                                    if (remainingCount != 0)
                                      TableRow(decoration: BoxDecoration(color: Colors.lime.shade50), children: [
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: InkWell(
                                            // style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                            onTap: () {
                                              setState(() {
                                                // 1. hideSelectedIds → jinke linkedUpaNagarID != value aur != 0
                                                // hideSelectedIds = vastiUpDataListModel!.vastimandallist!
                                                //     .where((item) => item.linkedUpaNagarID.toString() != data.geoUnitID.toString() && item.linkedUpaNagarID != 0)
                                                //     .map((item) => item.geoUnitID.toString())
                                                //     .join(',');
                                                //
                                                // // 2. selectedIdString → jinke linkedUpaNagarID == value (checked in popup)
                                                // selectedIdString = vastiUpDataListModel!.vastimandallist!
                                                //     .where((item) => item.linkedUpaNagarID.toString() == data.geoUnitID.toString())
                                                //     .map((item) => item.geoUnitID.toString())
                                                //     .join(',');
                                              });
                                              showGeoUnitVastiMandalCountPopup(
                                                context,
                                                showUnselected: true,
                                                title: "${Statics.getLabel('remaining')}",
                                                initiallySelectedIds: hideSelectedIds,
                                                hideSelectedIds: selectedIdString,
                                              );
                                              setState(() {});
                                            },
                                            child: Icon(Icons.remove_red_eye, size: 18, color: Colors.purpleAccent),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.all(8), child: Text("${Statics.getLabel('remaining')}", style: TextStyle(fontWeight: FontWeight.w600))),
                                        Padding(padding: EdgeInsets.all(8), child: Center(child: Text(remainingCount.toString()))),
                                      ]),
                                    TableRow(decoration: BoxDecoration(color: Colors.amberAccent.shade100), children: [
                                      Padding(padding: EdgeInsets.all(8), child: SizedBox()),
                                      Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text("${Statics.getLabel('Total')} ${Statics.getLabel('Vasti')}/${Statics.getLabel('Mandal')}", style: TextStyle(fontWeight: FontWeight.w700))),
                                      Padding(padding: EdgeInsets.all(8), child: Center(child: Text(vastiUpDataListModel?.vastimandallist?.length.toString() ?? "0"))),
                                      // DataCell(SizedBox()),
                                    ]),
                                  ],
                        ),
                        // child: DataTable(
                        //   border: TableBorder.symmetric(inside: BorderSide(width: 0.4, color: Colors.grey.shade400)),
                        //   showCheckboxColumn: false,
                        //   checkboxHorizontalMargin: 0,
                        //   // columnSpacing: 0,
                        //   headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                        //   headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        //   columns: [
                        //     DataColumn(label: SizedBox()),
                        //     DataColumn(
                        //         label: Text(
                        //       "${Statics.getLabel('Name')}",
                        //     )),
                        //     DataColumn(
                        //         label: Text(
                        //       "${Statics.getLabel('Vasti')}/${Statics.getLabel('Mandal')}",
                        //     )),
                        //     // DataColumn(label: SizedBox()),
                        //   ],
                        //   rows: vastiUpDataListModel == null
                        //       ? []
                        //       : vastiUpDataListModel!.upnagarmandallist!.asMap().entries.map((entry) {
                        //             int index = entry.key;
                        //             var data = entry.value;
                        //             return DataRow(cells: [
                        //               // DataCell(Text((index + 1).toString())),
                        //               DataCell(SizedBox(
                        //                 width: MediaQuery.of(context).size.width * 0.07,
                        //                 child: Row(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   children: [
                        //                     InkWell(
                        //                       // style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        //                       onTap: () {
                        //                         setState(() {
                        //                           // 1. hideSelectedIds → jinke linkedUpaNagarID != value aur != 0
                        //                           hideSelectedIds = vastiUpDataListModel!.vastimandallist!
                        //                               .where((item) => item.linkedUpaNagarID.toString() != data.geoUnitID.toString() && item.linkedUpaNagarID != 0)
                        //                               .map((item) => item.geoUnitID.toString())
                        //                               .join(',');
                        //
                        //                           // 2. selectedIdString → jinke linkedUpaNagarID == value (checked in popup)
                        //                           selectedIdString = vastiUpDataListModel!.vastimandallist!
                        //                               .where((item) => item.linkedUpaNagarID.toString() == data.geoUnitID.toString())
                        //                               .map((item) => item.geoUnitID.toString())
                        //                               .join(',');
                        //                         });
                        //                         showGeoUnitVastiMandalCountPopup(
                        //                           context,
                        //                           title: data.preferedname,
                        //                           initiallySelectedIds: selectedIdString,
                        //                           hideSelectedIds: hideSelectedIds,
                        //                         );
                        //                         setState(() {});
                        //                       },
                        //                       child: Icon(Icons.remove_red_eye, size: 18, color: Colors.purpleAccent),
                        //                     ),
                        //                     SizedBox(width: 14),
                        //                     InkWell(
                        //                       // style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        //                       onTap: () {
                        //                         setState(() {
                        //                           showupnagarUpkhandaNewAdd = true;
                        //                           upnagarLinkedValue = data.geoUnitID.toString() ?? "";
                        //
                        //                           // Find selected item and populate controllers
                        //                           selectedUpnagar = vastiUpDataListModel!.upnagarmandallist!.firstWhere((e) => e.geoUnitID.toString() == data.geoUnitID.toString());
                        //
                        //                           marathiNameController.text = selectedUpnagar!.geoUnitNameMarathi ?? "";
                        //                           hindiNameController.text = selectedUpnagar!.geoUnitNameHindi ?? "";
                        //                           englishNameController.text = selectedUpnagar!.geoUnitName ?? "";
                        //
                        //                           showTextFieldEnterUpData = true;
                        //
                        //                           // 1. hideSelectedIds → jinke linkedUpaNagarID != value aur != 0
                        //                           hideSelectedIds = vastiUpDataListModel!.vastimandallist!
                        //                               .where((item) => item.linkedUpaNagarID.toString() != data.geoUnitID.toString() && item.linkedUpaNagarID != 0)
                        //                               .map((item) => item.geoUnitID.toString())
                        //                               .join(',');
                        //
                        //                           // 2. selectedIdString → jinke linkedUpaNagarID == value (checked in popup)
                        //                           selectedIdString = vastiUpDataListModel!.vastimandallist!
                        //                               .where((item) => item.linkedUpaNagarID.toString() == data.geoUnitID.toString())
                        //                               .map((item) => item.geoUnitID.toString())
                        //                               .join(',');
                        //
                        //                           // Debug print
                        //                           print("selectedIdString (checked) ---> $selectedIdString");
                        //                           print("hideSelectedIds (hidden) ---> $hideSelectedIds");
                        //                         });
                        //                         showUpkhandaPopupDialog();
                        //                       },
                        //                       child: Icon(Icons.edit, color: Colors.blue, size: 20),
                        //                     )
                        //                   ],
                        //                 ),
                        //               )),
                        //               DataCell(Text(data.preferedname ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true)),
                        //               DataCell(Center(child: Text(vastiUpDataListModel?.vastimandallist?.where((e) => e.linkedUpaNagarID == data.geoUnitID).length.toString() ?? '0'))),
                        //             ]);
                        //           }).toList() +
                        //           [
                        //             DataRow(color: MaterialStatePropertyAll(Colors.amber.shade50), cells: [
                        //               DataCell(SizedBox()),
                        //               DataCell(Text("${Statics.getLabel('Total')}", style: TextStyle(fontWeight: FontWeight.w600))),
                        //               DataCell(Center(child: Text(totalCount.toString()))),
                        //               // DataCell(SizedBox()),
                        //             ]),
                        //             if (remainingCount != 0)
                        //               DataRow(color: MaterialStatePropertyAll(Colors.lime.shade50), cells: [
                        //                 DataCell(
                        //                   InkWell(
                        //                     // style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        //                     onTap: () {
                        //                       setState(() {
                        //                         // 1. hideSelectedIds → jinke linkedUpaNagarID != value aur != 0
                        //                         // hideSelectedIds = vastiUpDataListModel!.vastimandallist!
                        //                         //     .where((item) => item.linkedUpaNagarID.toString() != data.geoUnitID.toString() && item.linkedUpaNagarID != 0)
                        //                         //     .map((item) => item.geoUnitID.toString())
                        //                         //     .join(',');
                        //                         //
                        //                         // // 2. selectedIdString → jinke linkedUpaNagarID == value (checked in popup)
                        //                         // selectedIdString = vastiUpDataListModel!.vastimandallist!
                        //                         //     .where((item) => item.linkedUpaNagarID.toString() == data.geoUnitID.toString())
                        //                         //     .map((item) => item.geoUnitID.toString())
                        //                         //     .join(',');
                        //                       });
                        //                       showGeoUnitVastiMandalCountPopup(
                        //                         context,
                        //                         showUnselected: true,
                        //                         title: "${Statics.getLabel('remaining')}",
                        //                         initiallySelectedIds: hideSelectedIds,
                        //                         hideSelectedIds: selectedIdString,
                        //                       );
                        //                       setState(() {});
                        //                     },
                        //                     child: Icon(Icons.remove_red_eye, size: 18, color: Colors.purpleAccent),
                        //                   ),
                        //                 ),
                        //                 DataCell(Text("${Statics.getLabel('remaining')}", style: TextStyle(fontWeight: FontWeight.w600))),
                        //                 DataCell(Center(child: Text(remainingCount.toString()))),
                        //               ]),
                        //             DataRow(color: MaterialStatePropertyAll(Colors.amberAccent.shade100), cells: [
                        //               DataCell(SizedBox()),
                        //               DataCell(Text("${Statics.getLabel('Total')} ${Statics.getLabel('Vasti')}/${Statics.getLabel('Mandal')}", style: TextStyle(fontWeight: FontWeight.w700))),
                        //               DataCell(Center(child: Text(vastiUpDataListModel?.vastimandallist?.length.toString() ?? "0"))),
                        //               // DataCell(SizedBox()),
                        //             ]),
                        //           ],
                        // ),
                      )),
                ),
              // if (showupnagarUpkhandaNewAdd)
              //   Container(
              //     margin: EdgeInsets.only(top: 16),
              //     decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent), borderRadius: BorderRadius.all(Radius.circular(15))),
              //     padding: EdgeInsets.all(20),
              //     child: Form(
              //       key: _formKey,
              //       child: Column(
              //         children: [
              //           Center(
              //             child: Text(
              //               Statics.getLabel('upnagarUpkhandaNewAdd'),
              //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
              //             ),
              //           ),
              //           SizedBox(height: 30),
              //           // if (isVastiSearch == true)
              //           Container(
              //               height: 40,
              //               width: double.infinity,
              //               decoration: BoxDecoration(
              //                 border: Border.all(color: Colors.purpleAccent, width: 1),
              //                 borderRadius: BorderRadius.all(Radius.circular(15)),
              //               ),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 children: [
              //                   Text(
              //                     "$selctedLevel ",
              //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              //                   ),
              //                   if (selctedLevelName != "")
              //                     Text(
              //                       "  ->   $selctedLevelName",
              //                       style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
              //                     ),
              //                 ],
              //               )),
              //           SizedBox(height: 20),
              //           // Row(
              //           //   children: [
              //           //     if (vastiUpDataListModel!.upnagarmandallist != null)
              //           //       Expanded(
              //           //         child: DropdownButtonFormField<String>(
              //           //           focusColor: Colors.purpleAccent,
              //           //           decoration: InputDecoration(
              //           //             labelText:
              //           //                 Statics.getLabel('upnagarUpkhanda'),
              //           //             isDense: true,
              //           //             contentPadding: EdgeInsets.symmetric(
              //           //                 horizontal: 12, vertical: 10),
              //           //             enabledBorder: OutlineInputBorder(
              //           //               borderRadius:
              //           //                   BorderRadius.all(Radius.circular(10)),
              //           //               borderSide: BorderSide(
              //           //                   color: Colors.purpleAccent),
              //           //             ),
              //           //             focusedBorder: OutlineInputBorder(
              //           //               borderRadius:
              //           //                   BorderRadius.all(Radius.circular(10)),
              //           //               borderSide: BorderSide(
              //           //                   color: Colors.purpleAccent, width: 2),
              //           //             ),
              //           //             border: OutlineInputBorder(
              //           //               borderRadius:
              //           //                   BorderRadius.all(Radius.circular(10)),
              //           //             ),
              //           //           ),
              //           //           dropdownColor: Colors
              //           //               .white, // Optional: set dropdown background color
              //           //           isExpanded: true,
              //           //           value: upnagarLinkedValue!.isEmpty
              //           //               ? null
              //           //               : upnagarLinkedValue,
              //           //           items: vastiUpDataListModel!
              //           //               .upnagarmandallist!
              //           //               .map((bg) => DropdownMenuItem(
              //           //                     value: bg.geoUnitID.toString(),
              //           //                     child: Text(bg.geoUnitName ?? ""),
              //           //                   ))
              //           //               .toList(),
              //           //           onChanged: (value) {
              //           //             setState(() {
              //           //               upnagarLinkedValue = value ?? "";
              //           //             });
              //           //           },
              //           //         ),
              //           //       ),
              //           //     SizedBox(width: 10),
              //           //     InkWell(
              //           //       onTap: () {
              //           //         showTextFieldEnterUpData = true;
              //           //       },
              //           //       child: Container(
              //           //         width: 40,
              //           //         height: 40,
              //           //         decoration: BoxDecoration(
              //           //           border: Border.all(
              //           //             color: Colors.purpleAccent,
              //           //             width: 2,
              //           //           ),
              //           //           borderRadius: BorderRadius.all(
              //           //             Radius.circular(10),
              //           //           ),
              //           //         ),
              //           //         child: Center(
              //           //           child: Icon(
              //           //             Icons.add,
              //           //             color: Colors.purpleAccent,
              //           //             size: 25,
              //           //           ),
              //           //         ),
              //           //       ),
              //           //     ),
              //           //   ],
              //           // ),
              //           // if (vastiUpDataListModel!.upnagarmandallist != [] ||
              //           //     showTextFieldEnterUpData == true)
              //           //   Column(
              //           //     children: [
              //           //       SizedBox(height: 20),
              //           //       TextFormField(
              //           //         controller: marathiNameController,
              //           //         keyboardType: TextInputType.text,
              //           //         textDirection: TextDirection.ltr,
              //           //         decoration: InputDecoration(
              //           //           border: OutlineInputBorder(),
              //           //           hintText: "मराठीत नाव",
              //           //           labelText: "मराठीत नाव",
              //           //           contentPadding: EdgeInsets.symmetric(
              //           //               vertical: 10, horizontal: 12),
              //           //         ),
              //           //         validator: (value) {
              //           //           if (value == null || value.isEmpty) {
              //           //             return "कृपया मराठी नाव प्रविष्ट करा";
              //           //           }
              //           //           return null;
              //           //         },
              //           //       ),
              //           //       SizedBox(height: 20),
              //           //       TextFormField(
              //           //         controller: hindiNameController,
              //           //         keyboardType: TextInputType.text,
              //           //         textDirection: TextDirection.ltr,
              //           //         decoration: InputDecoration(
              //           //           border: OutlineInputBorder(),
              //           //           hintText: "हिंदी में नाम",
              //           //           labelText: "हिंदी में नाम",
              //           //           contentPadding: EdgeInsets.symmetric(
              //           //               vertical: 10, horizontal: 12),
              //           //         ),
              //           //         validator: (value) {
              //           //           if (value == null || value.isEmpty) {
              //           //             return "कृपया हिंदी नाम दर्ज करें";
              //           //           }
              //           //           return null;
              //           //         },
              //           //       ),
              //           //       SizedBox(height: 20),
              //           //       TextFormField(
              //           //         controller: englishNameController,
              //           //         keyboardType: TextInputType.text,
              //           //         textDirection: TextDirection.ltr,
              //           //         decoration: InputDecoration(
              //           //           border: OutlineInputBorder(),
              //           //           hintText: "Name in English",
              //           //           labelText: "Name in English",
              //           //           contentPadding: EdgeInsets.symmetric(
              //           //               vertical: 10, horizontal: 12),
              //           //         ),
              //           //         validator: (value) {
              //           //           if (value == null || value.isEmpty) {
              //           //             return "Please enter the name in English";
              //           //           }
              //           //           return null;
              //           //         },
              //           //       ),
              //           //       SizedBox(height: 20),
              //           //     ],
              //           //   ),
              //
              //           Row(
              //             children: [
              //               if (vastiUpDataListModel?.upnagarmandallist != null && vastiUpDataListModel!.upnagarmandallist!.isNotEmpty) ...[
              //                 Expanded(
              //                   child: DropdownButtonFormField<String>(
              //                       focusColor: Colors.purpleAccent,
              //                       decoration: InputDecoration(
              //                         labelText: Statics.getLabel('upnagarUpkhanda'),
              //                         isDense: true,
              //                         contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              //                         enabledBorder: OutlineInputBorder(
              //                           borderRadius: BorderRadius.all(Radius.circular(10)),
              //                           borderSide: BorderSide(color: Colors.purpleAccent),
              //                         ),
              //                         focusedBorder: OutlineInputBorder(
              //                           borderRadius: BorderRadius.all(Radius.circular(10)),
              //                           borderSide: BorderSide(color: Colors.purpleAccent, width: 2),
              //                         ),
              //                         border: OutlineInputBorder(
              //                           borderRadius: BorderRadius.all(Radius.circular(10)),
              //                         ),
              //                       ),
              //                       dropdownColor: Colors.white,
              //                       isExpanded: true,
              //                       value: upnagarLinkedValue == null || upnagarLinkedValue == "" ? null : upnagarLinkedValue,
              //                       items: vastiUpDataListModel!.upnagarmandallist!
              //                           .map((bg) => DropdownMenuItem(
              //                                 value: bg.geoUnitID.toString(),
              //                                 child: Text(bg.geoUnitName ?? ""),
              //                               ))
              //                           .toList(),
              //                       // onChanged: (value) {
              //                       //   setState(() {
              //                       //     upnagarLinkedValue = value ?? "";
              //                       //
              //                       //     // Find selected item and populate controllers
              //                       //     var selected = vastiUpDataListModel!
              //                       //         .upnagarmandallist!
              //                       //         .firstWhere((e) =>
              //                       //             e.geoUnitID.toString() == value);
              //                       //
              //                       //     marathiNameController.text =
              //                       //         selected.geoUnitNameMarathi ?? "";
              //                       //     hindiNameController.text =
              //                       //         selected.geoUnitNameHindi ?? "";
              //                       //     englishNameController.text =
              //                       //         selected.geoUnitName ?? "";
              //                       //
              //                       //     showTextFieldEnterUpData = true;
              //                       //
              //                       //     selectedIdString = vastiUpDataListModel!
              //                       //         .upnagarmandallist!
              //                       //         .where((item) =>
              //                       //             item.linkedUpaNagarID == value ||
              //                       //             item.linkedUpaNagarID == 0)
              //                       //         .map((item) =>
              //                       //             item.geoUnitID.toString())
              //                       //         .join(',');
              //                       //     hideSelectedIds = vastiUpDataListModel!
              //                       //         .upnagarmandallist!
              //                       //         .where((item) =>
              //                       //             item.linkedUpaNagarID == value ||
              //                       //             item.linkedUpaNagarID == 0)
              //                       //         .map((item) =>
              //                       //             item.geoUnitID.toString())
              //                       //         .join(',');
              //                       //   });
              //                       //   print(
              //                       //       "selectedIdString in dropdown ---> $selectedIdString");
              //                       // },
              //                       onChanged: (value) {
              //                         setState(() {
              //                           upnagarLinkedValue = value ?? "";
              //
              //                           // Find selected item and populate controllers
              //                           selectedUpnagar = vastiUpDataListModel!.upnagarmandallist!.firstWhere((e) => e.geoUnitID.toString() == value);
              //
              //                           marathiNameController.text = selectedUpnagar!.geoUnitNameMarathi ?? "";
              //                           hindiNameController.text = selectedUpnagar!.geoUnitNameHindi ?? "";
              //                           englishNameController.text = selectedUpnagar!.geoUnitName ?? "";
              //
              //                           showTextFieldEnterUpData = true;
              //
              //                           // 1. hideSelectedIds → jinke linkedUpaNagarID != value aur != 0
              //                           hideSelectedIds = vastiUpDataListModel!.vastimandallist!
              //                               .where((item) => item.linkedUpaNagarID.toString() != value && item.linkedUpaNagarID != 0)
              //                               .map((item) => item.geoUnitID.toString())
              //                               .join(',');
              //
              //                           // 2. selectedIdString → jinke linkedUpaNagarID == value (checked in popup)
              //                           selectedIdString =
              //                               vastiUpDataListModel!.vastimandallist!.where((item) => item.linkedUpaNagarID.toString() == value).map((item) => item.geoUnitID.toString()).join(',');
              //
              //                           // Debug print
              //                           print("selectedIdString (checked) ---> $selectedIdString");
              //                           print("hideSelectedIds (hidden) ---> $hideSelectedIds");
              //                         });
              //                       }),
              //                 )
              //               ] else ...[
              //                 Expanded(
              //                   child: Container(
              //                     height: 40,
              //                     decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.all(Radius.circular(10)),
              //                         border: Border.all(
              //                           color: Colors.purpleAccent,
              //                         )),
              //                     child: Row(
              //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                       children: [Text(Statics.getLabel('upnagarUpkhandaNewAdd')), Icon(Icons.arrow_right_alt)],
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //               SizedBox(width: 10),
              //               InkWell(
              //                 onTap: () {
              //                   setState(() {
              //                     upnagarLinkedValue = null;
              //                     marathiNameController.clear();
              //                     hindiNameController.clear();
              //                     englishNameController.clear();
              //                     showTextFieldEnterUpData = true;
              //                     hideSelectedIds = vastiUpDataListModel!.vastimandallist!
              //                         .where((item) => item.linkedUpaNagarID.toString() != upnagarLinkedValue && item.linkedUpaNagarID != 0)
              //                         .map((item) => item.geoUnitID.toString())
              //                         .join(',');
              //                   });
              //                 },
              //                 child: Container(
              //                   width: 80,
              //                   height: 40,
              //                   decoration: BoxDecoration(
              //                     border: Border.all(
              //                       color: Colors.purpleAccent,
              //                     ),
              //                     borderRadius: BorderRadius.all(Radius.circular(10)),
              //                   ),
              //                   child: Center(
              //                     child: Icon(Icons.add, color: Colors.purpleAccent, size: 25),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //           if (showTextFieldEnterUpData)
              //             Column(
              //               children: [
              //                 SizedBox(height: 20),
              //                 TextFormField(
              //                   controller: marathiNameController,
              //                   keyboardType: TextInputType.text,
              //                   textDirection: TextDirection.ltr,
              //                   decoration: InputDecoration(
              //                     border: OutlineInputBorder(),
              //                     hintText: "मराठीत नाव",
              //                     labelText: "मराठीत नाव",
              //                     contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              //                   ),
              //                   validator: (value) {
              //                     if (value == null || value.isEmpty) {
              //                       return "कृपया मराठी नाव प्रविष्ट करा";
              //                     }
              //                     return null;
              //                   },
              //                 ),
              //                 SizedBox(height: 20),
              //                 TextFormField(
              //                   controller: hindiNameController,
              //                   keyboardType: TextInputType.text,
              //                   textDirection: TextDirection.ltr,
              //                   decoration: InputDecoration(
              //                     border: OutlineInputBorder(),
              //                     hintText: "हिंदी में नाम",
              //                     labelText: "हिंदी में नाम",
              //                     contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              //                   ),
              //                   validator: (value) {
              //                     if (value == null || value.isEmpty) {
              //                       return "कृपया हिंदी नाम दर्ज करें";
              //                     }
              //                     return null;
              //                   },
              //                 ),
              //                 SizedBox(height: 20),
              //                 TextFormField(
              //                   controller: englishNameController,
              //                   keyboardType: TextInputType.text,
              //                   textDirection: TextDirection.ltr,
              //                   decoration: InputDecoration(
              //                     border: OutlineInputBorder(),
              //                     hintText: "Name in English",
              //                     labelText: "Name in English",
              //                     contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              //                   ),
              //                   validator: (value) {
              //                     if (value == null || value.isEmpty) {
              //                       return "Please enter the name in English";
              //                     }
              //                     return null;
              //                   },
              //                 ),
              //                 SizedBox(height: 20),
              //               ],
              //             ),
              //           SizedBox(height: 10),
              //           Row(
              //             children: [
              //               Expanded(
              //                   child: Text(
              //                 "${Statics.getLabel('upnagarUpkhandaLinked')}",
              //                 style: TextStyle(color: Colors.red),
              //               )),
              //               Expanded(
              //                 child: InkWell(
              //                   onTap: () {
              //                     showGeoUnitMultiSelectPopup(
              //                       context,
              //                       initiallySelectedIds: selectedIdString,
              //                       hideSelectedIds: hideSelectedIds,
              //                     );
              //                     setState(() {});
              //                   },
              //                   child: Container(
              //                     padding: const EdgeInsets.symmetric(vertical: 5),
              //                     width: 120,
              //                     height: 35,
              //                     decoration: BoxDecoration(
              //                         border: Border.all(color: Colors.purpleAccent.shade100),
              //                         // color:
              //                         //     Colors.purpleAccent.withOpacity(0.7),
              //                         borderRadius: BorderRadius.circular(15)),
              //                     child: Center(
              //                       child: Row(
              //                         mainAxisAlignment: MainAxisAlignment.center,
              //                         children: [
              //                           SizedBox(width: 5),
              //                           Text(
              //                             "${Statics.getLabel('addVasti')}",
              //                             style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //           SizedBox(
              //             height: 10,
              //           ),
              //           Divider(
              //             color: Colors.grey,
              //           ),
              //           SizedBox(
              //             height: 10,
              //           ),
              //           InkWell(
              //             onTap: () {
              //               if (_formKey.currentState!.validate()) {
              //                 submitUpkhandaForm();
              //               }
              //             },
              //             child: Container(
              //               padding: const EdgeInsets.symmetric(vertical: 5),
              //               width: 80,
              //               height: 35,
              //               decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
              //               child: Center(
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     SizedBox(width: 5),
              //                     Text(
              //                       "${Statics.getLabel('Submit')}",
              //                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  Widget vastiMandalDropdown() {
    return Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
      return ExpansionPanelList(
        //elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (_, isExpanded) => setState(() => _isExpanded = isExpanded),
        children: [
          ExpansionPanel(
            // backgroundColor: Colors.transparent,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(Statics.getLabel('selectBhaugolikSthar'), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purpleAccent)),
              );
            },
            body: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  GeoDropdownWidget(
                    level: GeoLevel.Mahaanagar,
                    title: 'Mahaanagar',
                    controller: ctrl,
                  ),

                  // if (ctrl.hasItems(GeoLevel.vibhaag))
                  GeoDropdownWidget(
                    level: GeoLevel.Vibhaag,
                    title: 'Vibhaag',
                    controller: ctrl,
                  ),

                  if (ctrl.hasItems(GeoLevel.Bhaag))
                    GeoDropdownWidget(
                      level: GeoLevel.Bhaag,
                      title: 'Bhaag',
                      controller: ctrl,
                    ),

                  if (ctrl.hasItems(GeoLevel.Nagar))
                    GeoDropdownWidget(
                      level: GeoLevel.Nagar,
                      title: 'Nagar',
                      controller: ctrl,
                    ),
                  SizedBox(height: 12),
                  if (ctrl.deepestSelectedLevelId == 6)
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                            onPressed: () async {
                              // setState(() {
                              // showupnagarUpkhandaNewAdd = true;
                              await getVastiUpDataList(ctrl.deepestSelectedGeoUnitId);
                              // });
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
                                viewcontainer = false;
                                showNavinButton = false;
                                showupnagarUpkhandaTable = false;
                              });
                              populateDropdown();
                              ctrl.loadHierarchyForUser();
                            },
                            child: Text(
                              Statics.getLabel('clear'),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      );
    });
  }

  String? selectedIdString;
  String? hideSelectedIds;

  Future<void> showGeoUnitMultiSelectPopup(
    BuildContext context, {
    String? title,
    String? initiallySelectedIds,
    String? hideSelectedIds,
  }) async {
    print("selectedIdString ====?> $selectedIdString");

    final List<Upnagarmandallist> fullList = vastiUpDataListModel!.vastimandallist ?? [];

    final Set<String> allowedIds = (hideSelectedIds ?? "").split(",").where((id) => id.trim().isNotEmpty).toSet();

    final List<Upnagarmandallist> geoUnitList = fullList.where((item) => !allowedIds.contains(item.geoUnitID.toString())).toList();

    final Set<String> preSelected = (initiallySelectedIds ?? "").split(",").where((id) => id.trim().isNotEmpty).toSet();

    Map<String, bool> selectedMap = {for (var item in geoUnitList) item.geoUnitID.toString(): preSelected.contains(item.geoUnitID.toString())};

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title ?? Statics.getLabel("Selects")),
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
                  child: Text(Statics.getLabel("Submit")),
                  onPressed: () {
                    List<String> selectedIds = selectedMap.entries.where((e) => e.value).map((e) => e.key).toList();

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

  Future<void> showGeoUnitVastiMandalCountPopup(
    BuildContext context, {
    bool showUnselected = false,
    String? title,
    String? initiallySelectedIds,
    String? hideSelectedIds,
  }) async {
    print("selectedIdString ====?> $selectedIdString");

    final List<Upnagarmandallist> fullList = vastiUpDataListModel!.vastimandallist ?? [];

    final Set<String> allowedIds = (hideSelectedIds ?? "").split(",").where((id) => id.trim().isNotEmpty).toSet();

    final List<Upnagarmandallist> geoUnitList = fullList.where((item) => !allowedIds.contains(item.geoUnitID.toString())).toList();

    final Set<String> preSelected = (initiallySelectedIds ?? "").split(",").where((id) => id.trim().isNotEmpty).toSet();

    Map<String, bool> selectedMap = {for (var item in geoUnitList) item.geoUnitID.toString(): preSelected.contains(item.geoUnitID.toString())};

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, set) {
            return AlertDialog(
              // contentPadding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              title: Text(title ?? "Select Items", style: TextStyle(color: Colors.purple.shade400)),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: DataTable(
                    border: TableBorder.symmetric(inside: BorderSide(width: 0.4, color: Colors.grey.shade400)),
                    showCheckboxColumn: false,
                    headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                    headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                    columns: [
                      DataColumn(label: SizedBox()),
                      DataColumn(
                          label: Text(
                        "${Statics.getLabel('Name')}",
                      )),
                    ],
                    rows: geoUnitList.where((e) => showUnselected ? !preSelected.contains(e.geoUnitID.toString()) : preSelected.contains(e.geoUnitID.toString())).toList().asMap().entries.map((entry) {
                      int index = entry.key;
                      var data = entry.value;
                      return DataRow(cells: [
                        DataCell(Text((index + 1).toString())),
                        DataCell(Text(data.preferedname ?? "", maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true)),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  child: Text(Statics.getLabel("Submit")),
                  onPressed: () {
                    // List<String> selectedIds = selectedMap.entries.where((e) => e.value).map((e) => e.key).toList();
                    //
                    // selectedIdString = selectedIds.join(",");
                    // print("Selected IDs: $selectedIdString");

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
