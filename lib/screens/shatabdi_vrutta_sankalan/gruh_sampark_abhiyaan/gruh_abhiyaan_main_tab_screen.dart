import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/AbhiyaanLoginDataResponse.dart';
import '../../../providers/bals.dart';
import '../../../widgets/app_drawer.dart';
import 'gruh_samparka_report_tab.dart';
import 'gruh_vrutta_form_tab.dart';

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

  bool _isDaiytva = false;

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
    super.initState();
  }

  getInitialData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = pref.getString("AbhiyanSwayamsevakData");
    log(data.toString());
    if (data != null) {
      initialData = AbhiyanSwayamsevakdata.fromJson(jsonDecode(data));
      type = initialData!.levelName!.toLowerCase();
      log("initialData!  ---> ${json.encode(initialData)}");
      log("initialData!.levelName  ---> ${type}");
      setState(() {});
    }
  }

  late Size size = MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${Statics.getLabel('gruhSamparkAbhiyan')} (${Statics.getLabel('shatabdiVarsha')})",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
          bottom: (Statics.abhiyaanUserDetails["isEmpty"] && int.parse(Statics.userDetails["LevelID"].toString()) < 6)
              ? null
              : new TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  onTap: (v) {
                    _levelValue = "";
                    _geoUnitsValue = "";
                    setState(() {});
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
          child: (Statics.abhiyaanUserDetails["isEmpty"] && int.parse(Statics.userDetails["LevelID"].toString()) < 6)
              ? GruhSamparkaReportTab(
                  initialData: initialData,
                )
              : TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    GruhVruttaTab(
                      initialData: initialData,
                      isDaayitva: _isDaiytva,
                    ),
                    GruhSamparkaReportTab(
                      initialData: initialData,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
