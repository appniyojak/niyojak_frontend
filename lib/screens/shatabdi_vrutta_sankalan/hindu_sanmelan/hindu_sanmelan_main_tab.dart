import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../utils/globals.dart';
import '../../../widgets/app_drawer.dart';
import 'hindu_sanmelan_form.dart';
import 'hindu_sanmelan_report.dart';

class HinduSanmelanMainTab extends StatefulWidget {
  static const routeName = '/hindu-sanmelan-main-tab-screen';

  const HinduSanmelanMainTab({super.key});

  @override
  State<HinduSanmelanMainTab> createState() => _HinduSanmelanMainTabState();
}

class _HinduSanmelanMainTabState extends State<HinduSanmelanMainTab> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  String? selectedId;

  bool _isSearching = false;

  @override
  void initState() {
    print("initState");
    getInitialData();
    _tabController = new TabController(length: 2, vsync: this);
    // WidgetsBinding.instance.addPostFrameCallback((t) => getInitialData());
    super.initState();
  }

  getInitialData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
    });
    log("initState _HinduSanmelanMainTabState runnn >>>>>>>>>>>>>> $userLevelId");
  }

  void onIdSelected(String id) {
    setState(() {
      selectedId = id;
    });

    // switch to first tab
    _tabController?.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${Statics.getLabel('hinduSammelan')} ${Statics.getLabel('Vrutta')}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          bottom: (userLevelId ?? 0) < 4
              ? null
              : TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  physics: NeverScrollableScrollPhysics(),
                  tabs: <Widget>[
                    Tab(
                      child: Row(
                        spacing: 16,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.fileArrowUp,
                            size: 18,
                          ),
                          Text(
                            "${Statics.getLabel('addGruhaSampark')}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        spacing: 16,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people),
                          Text(
                            "${Statics.getLabel('Reportonly')}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        drawer: AppDrawer(),
        body: ModalProgressHUD(
          inAsyncCall: _isSearching,
          child: (userLevelId ?? 0) < 4
              ? HinduSanmelanForm(id: selectedId)
              : TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    HinduSanmelanForm(id: selectedId),
                    HinduSanmelanReport(onIdTap: onIdSelected),
                  ],
                ),
        ),
      ),
    );
  }
}
