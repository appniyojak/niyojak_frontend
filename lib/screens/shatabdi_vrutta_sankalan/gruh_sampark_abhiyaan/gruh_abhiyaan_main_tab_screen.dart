import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/AbhiyaanLoginDataResponse.dart';
import '../../../providers/bals.dart';
import '../../../widgets/app_drawer.dart';
import '../../home_screen.dart';
import 'abhiyaan_swayamsevak_tab.dart';
import 'gruh_samparka_tab.dart';

class GruhAbhiyaanMainTabScreen extends StatefulWidget {
  static const routeName = '/gruh-abhiyaan-main-tab-screen';

  const GruhAbhiyaanMainTabScreen({super.key});

  @override
  State<GruhAbhiyaanMainTabScreen> createState() => _GruhAbhiyaanMainTabScreenState();
}

class _GruhAbhiyaanMainTabScreenState extends State<GruhAbhiyaanMainTabScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  TextEditingController searchPhoneController = TextEditingController();
  TextEditingController searchPhoneDialogController = TextEditingController();

  bool _isSearching = false;

  List<LevelMasterBAL>? _level;
  List<GeoUnitMasterBAL>? _geoUnits;
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
  String? type;
  List<MenuChoices> choices = [];
  String? selectedDayitvValue = "";

  bool _isExpanded = false;
  AbhiyanSwayamsevakdata? initialData;

  // AbhiyanGruhasamparkData? abhiyaanGruhaSamparkDataList;

  @override
  void initState() {
    print("initState");
    getInitialData();
    _tabController = new TabController(length: 2, vsync: this);
    // Future.delayed(Duration.zero, () async {
    //   await getAbhiyaanListData();
    // });
    // populateDropdown();
    populateChoice();
    super.initState();
  }

  getInitialData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = pref.getString("AbhiyanSwayamsevakData");
    print(data);
    if (data != null) {
      initialData = AbhiyanSwayamsevakdata.fromJson(jsonDecode(data));
      type = initialData!.levelName!.toLowerCase();
      print("initialData!  ---> ${json.encode(initialData)}");
      print("initialData!.levelName  ---> ${type}");
      setState(() {});
    }
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
  //         selectedGruhaAbhiyanValue = abhiyaanDataList.first.abhiyaanID.toString();
  //
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
  //     print(e);
  //     setState(() {
  //       _isSearching = false;
  //     });
  //     Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
  //   }
  // }

  // getAbhiyaanGruhaSamparkListData() async {
  //   try {
  //     bool isConnected = await Statics.isInternetConnected();
  //     if (isConnected) {
  //       setState(() {
  //         _isSearching = true;
  //       });
  //
  //       // if(_linkedMahaanagarValue == null || _linkedMahaanagarValue == "" &&
  //       //     _linkedVibhaagValue == null || _linkedVibhaagValue == "" &&
  //       //     _linkedbhaagValue == null || _linkedbhaagValue == "" &&
  //       //     _linkednagarValue == null || _linkednagarValue == "" &&
  //       //     _linkedmandalValue == null || _linkedmandalValue == "" &&
  //       //     _linkedvastiValue == null || _linkedvastiValue == "" &&
  //       //     _linkedgraamValue == null || _linkedgraamValue == "" ){
  //       //   type = "prant";
  //       // }else if(_linkedMahaanagarValue != null || _linkedMahaanagarValue != "" &&
  //       //     _linkedVibhaagValue == null || _linkedVibhaagValue == "" &&
  //       //     _linkedbhaagValue == null || _linkedbhaagValue == "" &&
  //       //     _linkednagarValue == null || _linkednagarValue == "" &&
  //       //     _linkedmandalValue == null || _linkedmandalValue == "" &&
  //       //     _linkedvastiValue == null || _linkedvastiValue == "" &&
  //       //     _linkedgraamValue == null || _linkedgraamValue == "" ){
  //       //   type = "mahanagar";
  //       // }else if(_linkedMahaanagarValue != null || _linkedMahaanagarValue != "" &&
  //       //     _linkedVibhaagValue != null || _linkedVibhaagValue != "" &&
  //       //     _linkedbhaagValue == null || _linkedbhaagValue == "" &&
  //       //     _linkednagarValue == null || _linkednagarValue == "" &&
  //       //     _linkedmandalValue == null || _linkedmandalValue == "" &&
  //       //     _linkedvastiValue == null || _linkedvastiValue == "" &&
  //       //     _linkedgraamValue == null || _linkedgraamValue == "" ){
  //       //   type = "vibhag";
  //       // }else if(_linkedMahaanagarValue != null || _linkedMahaanagarValue != "" &&
  //       //     _linkedVibhaagValue != null || _linkedVibhaagValue != "" &&
  //       //     _linkedbhaagValue != null || _linkedbhaagValue != "" &&
  //       //     _linkednagarValue == null || _linkednagarValue == "" &&
  //       //     _linkedmandalValue == null || _linkedmandalValue == "" &&
  //       //     _linkedvastiValue == null || _linkedvastiValue == "" &&
  //       //     _linkedgraamValue == null || _linkedgraamValue == "" ){
  //       //   type = "bhag";
  //       // }else if(_linkedMahaanagarValue != null || _linkedMahaanagarValue != "" &&
  //       //     _linkedVibhaagValue != null || _linkedVibhaagValue != "" &&
  //       //     _linkedbhaagValue != null || _linkedbhaagValue != "" &&
  //       //     _linkednagarValue != null || _linkednagarValue != "" &&
  //       //     _linkedmandalValue == null || _linkedmandalValue == ""&&
  //       //     _linkedvastiValue == null || _linkedvastiValue == "" &&
  //       //     _linkedgraamValue == null || _linkedgraamValue == "" ){
  //       //   type = "nagar";
  //       // }else if(_linkedMahaanagarValue != null || _linkedMahaanagarValue != "" &&
  //       //     _linkedVibhaagValue != null || _linkedVibhaagValue != "" &&
  //       //     _linkedbhaagValue != null || _linkedbhaagValue != "" &&
  //       //     _linkednagarValue != null || _linkednagarValue != "" &&
  //       //     _linkedvastiValue != null || _linkedvastiValue != "" &&
  //       //     _linkedmandalValue == null || _linkedmandalValue == ""&&
  //       //     _linkedgraamValue == null || _linkedgraamValue == "" ){
  //       //   type = "vasti";
  //       // }else if(_linkedMahaanagarValue != null || _linkedMahaanagarValue != "" &&
  //       //     _linkedVibhaagValue != null || _linkedVibhaagValue != "" &&
  //       //     _linkedbhaagValue != null || _linkedbhaagValue != "" &&
  //       //     _linkednagarValue != null || _linkednagarValue != "" &&
  //       //     _linkedvastiValue == null || _linkedvastiValue == "" &&
  //       //     _linkedmandalValue != null || _linkedmandalValue != ""&&
  //       //     _linkedgraamValue == null || _linkedgraamValue == "" ){
  //       //   type = "mandal";
  //       // }else if(_linkedMahaanagarValue != null || _linkedMahaanagarValue != "" &&
  //       //     _linkedVibhaagValue != null || _linkedVibhaagValue != "" &&
  //       //     _linkedbhaagValue != null || _linkedbhaagValue != "" &&
  //       //     _linkednagarValue != null || _linkednagarValue != "" &&
  //       //     _linkedvastiValue == null || _linkedvastiValue == "" &&
  //       //     _linkedmandalValue != null || _linkedmandalValue != ""&&
  //       //     _linkedgraamValue != null || _linkedgraamValue != "" ){
  //       //   type = "gram";
  //       // }
  //
  //       var data = {
  //         "CreatedByID": initialData!.abhiyanSwayamsevakID!,
  //         "AbhiyaanID": int.parse(selectedGruhaAbhiyanValue!),
  //         "Mahanagar": _linkedMahaanagarValue == null || _linkedMahaanagarValue == "" ? 0 : int.parse(_linkedMahaanagarValue!),
  //         "Vibhag": _linkedVibhaagValue == null || _linkedVibhaagValue == "" ? 0 : int.parse(_linkedVibhaagValue!),
  //         "BhaagID": _linkedbhaagValue == null || _linkedbhaagValue == "" ? 0 : int.parse(_linkedbhaagValue!),
  //         "NagarID": _linkednagarValue == null || _linkednagarValue == "" ? 0 : int.parse(_linkednagarValue!),
  //         "MandalID": _linkedmandalValue == null || _linkedmandalValue == "" ? 0 : int.parse(_linkedmandalValue!),
  //         "VastiID": _linkedvastiValue == null || _linkedvastiValue == "" ? 0 : int.parse(_linkedvastiValue!),
  //         "GramID": _linkedgraamValue == null || _linkedgraamValue == "" ? 0 : int.parse(_linkedgraamValue!),
  //         "type": type
  //       };
  //
  //       print(data);
  //
  //       var result = await SwayamsevakProvider().getAbhiyaGruhaSamparkList(jsonEncode(data));
  //       if (result.status == "200") {
  //         print("succeed");
  //         abhiyaanGruhaSamparkDataList = result.abhiyanGruhasamparkData;
  //
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
  //     print(e);
  //     Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
  //   }
  // }

  void populateChoice() {
    setState(() {
      choices = _tabController!.index != 1
          ? [
              new MenuChoices("AddGruha", Icons.add, "${Statics.getLabel('addGruhaSampark')}"),
              new MenuChoices("visheshVyakti", Icons.perm_contact_cal_outlined, "${Statics.getLabel('searchVisheshVyaktiScreenBanner')}"),
            ]
          : [
              new MenuChoices("EditMenu", Icons.add, "${Statics.getLabel('addSahabhagiKaryakarta')}"),
              // new MenuChoices("AbhiyaanSwayam", Icons.perm_contact_cal_outlined,
              //     "सहभागी कार्यकर्ता"),
            ];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void onMenuSelected(MenuChoices choice) async {
  //   print(choice.menuType);
  //   if (choice.menuType == "AddGruha") {
  //     Navigator.of(context).pushNamed(AddGruhaSamparkScreen.routeName);
  //   } else if (choice.menuType == "AbhiyaanSwayam") {
  //     Navigator.of(context).pushNamed(AbhiyaanSwayamsevak.routeName);
  //   } else if (choice.menuType == "visheshVyakti") {
  //     Navigator.of(context).pushNamed(VisheshVyaktiShodhScreen.routeName);
  //   } else if (choice.menuType == "EditMenu") {
  //     Navigator.of(context).pushNamed(AbhiyanAddSwayamsevakScreen.routeName);
  //   }
  // }

  late Size size = MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.routeName);
        return true;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "${Statics.getLabel('gruhSamparkAbhiyan')}",
              style: TextStyle(fontSize: 24),
            ),
            // actions: <Widget>[
            //   if (_tabController!.index == 1)
            //     PopupMenuButton<MenuChoices>(
            //       onSelected: onMenuSelected,
            //       icon: Icon(FontAwesomeIcons.ellipsisV),
            //       itemBuilder: (BuildContext context) {
            //         return choices.map((MenuChoices choice) {
            //           return PopupMenuItem<MenuChoices>(
            //             value: choice,
            //             child: ListTile(leading: Icon(choice.icon), title: Text(choice.menuText!)),
            //           );
            //         }).toList();
            //       },
            //     )
            //   else
            //     PopupMenuButton<MenuChoices>(
            //       onSelected: onMenuSelected,
            //       icon: Icon(FontAwesomeIcons.ellipsisV),
            //       itemBuilder: (BuildContext context) {
            //         return choices.map((MenuChoices choice) {
            //           return PopupMenuItem<MenuChoices>(
            //             value: choice,
            //             child: ListTile(leading: Icon(choice.icon), title: Text(choice.menuText!)),
            //           );
            //         }).toList();
            //       },
            //     ),
            // ],
            bottom: new TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              onTap: (v) {
                _levelValue = "";
                _geoUnitsValue = "";
                setState(() {});
                populateChoice();
                Future.delayed(Duration(milliseconds: 800), () {
                  setState(() {});
                });
              },
              physics: NeverScrollableScrollPhysics(),
              tabs: <Widget>[
                Tab(
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        FontAwesomeIcons.fileArrowUp,
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: size.width * 0.31,
                        alignment: Alignment.center,
                        child: Text(
                          "${Statics.getLabel('addGruhaSampark')}",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      Icon(Icons.people),
                      SizedBox(width: 5),
                      Expanded(
                        child: Center(
                          // width: size.width*0.31,
                          child: Text(
                            "${Statics.getLabel('Reportonly')}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          drawer: (Statics.userDetails['userID'].toString().isEmpty || Statics.userDetails['userID'] == "0") ? AppAbhiyanDrawer() : AppDrawer(),
          body: ModalProgressHUD(
            inAsyncCall: _isSearching,
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                AbhiyaanSwayamsevakTab(
                  initialData: initialData,
                ),
                GruhSamparkaTab(
                  initialData: initialData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
