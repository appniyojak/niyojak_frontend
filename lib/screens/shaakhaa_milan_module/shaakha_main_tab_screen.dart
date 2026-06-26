import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../models/response_model/dropdown_level_responsemodel.dart';
import '../../utils/globals.dart';
import '../../widgets/app_drawer.dart';
import 'search_shaakhaa.dart';
import 'shaakhaa_report_tab.dart';
import 'shaakhaa_tulnatmak_report_tab.dart';

class ShaakhaMainTabScreen extends StatefulWidget {
  static const routeName = '/shaakhaa-main-screen';

  const ShaakhaMainTabScreen({super.key});

  @override
  State<ShaakhaMainTabScreen> createState() => _ShaakhaMainTabScreenState();
}

class _ShaakhaMainTabScreenState extends State<ShaakhaMainTabScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    print("initState");
    getInitialData();
    _tabController = new TabController(length: 3, vsync: this);
    log("initState _PramukhJansanvadMainTabState runnn >>>>>>>>>>>>>> ");
    _tabController?.addListener(_handleTabChange);
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
  void dispose() {
    _tabController?.removeListener(_handleTabChange);
    super.dispose();
  }

  void _handleTabChange() {
    if (mounted) {
      setState(() {}); // Rebuilds to update the PopScope's allowed status
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Define your single screen condition
    final bool isSingleTab = (userLevelId ?? 0) < 6 || userLevelId == 13;

    // 2. Determine if the system back button is allowed to close/pop the screen.
    // It should pop normally if it's a single screen OR if the user is already on the first tab (index 0).
    final bool canPopScreen = isSingleTab || _tabController?.index == 0;

    return PopScope(
      canPop: canPopScreen,
      onPopInvokedWithResult: (didPop, result) {
        // If the system already handled the pop (canPop was true), do nothing.
        if (didPop) return;

        // If canPop was false, it means we are on the multi-tab layout and on the second tab (index 1).
        // Move back to the first tab instead of exiting.
        if (_tabController?.index == 1 || _tabController?.index == 2) {
          _tabController?.animateTo(0);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "${Statics.getLabel('searchShaakhaaScreenBanner')}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            bottom: TabBar(
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
                Tab(
                  child: Row(
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.balance_rounded),
                      Text(
                        "${Statics.getLabel('tulnamtmakonly')}",
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
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                SearchShaakhaaScreen(),
                ShaakhaaReportTabScreen(),
                ShaakhaaTulnatmakReportTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
