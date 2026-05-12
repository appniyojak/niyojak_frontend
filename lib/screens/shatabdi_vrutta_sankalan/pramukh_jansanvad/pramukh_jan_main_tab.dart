import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../utils/globals.dart';
import '../../../widgets/app_drawer.dart';
import 'pramukh_jan_form.dart';
import 'pramukh_jan_report.dart';

class PramukhJansanvadMainTab extends StatefulWidget {
  static const routeName = '/pramukh-jansanvad-main-tab-screen';

  const PramukhJansanvadMainTab({super.key});

  @override
  State<PramukhJansanvadMainTab> createState() => _PramukhJansanvadMainTabState();
}

class _PramukhJansanvadMainTabState extends State<PramukhJansanvadMainTab> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    print("initState");
    getInitialData();
    _tabController = new TabController(length: 2, vsync: this);
    log("initState _PramukhJansanvadMainTabState runnn >>>>>>>>>>>>>> ");
    // WidgetsBinding.instance.addPostFrameCallback((t) => getAbhiyaanGeoUnitsFun());
  }

  getInitialData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
    });
    log("initState _PramukhJansanvadMainTabState runnn >>>>>>>>>>>>>> $userLevelId");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${Statics.getLabel('pramukhJansanvaad')}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          bottom: ((userLevelId ?? 0) < 6 || userLevelId == 13)
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
                            "${Statics.getLabel('Vruttaonly')}",
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
          child: ((userLevelId ?? 0) < 6 || userLevelId == 13)
              ? PramukhJansanvadFormTab()
              : TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    PramukhJansanvadFormTab(),
                    PramukhJansanvadReportTab(),
                  ],
                ),
        ),
      ),
    );
  }
}
