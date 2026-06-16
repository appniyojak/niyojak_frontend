import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../utils/globals.dart';
import '../../../widgets/app_drawer.dart';
import 'sadbhav_centers_list_screen.dart';
import 'sadbhav_report.dart';

class SadbhavBaithakMainTab extends StatefulWidget {
  static const routeName = '/sadbhav-baithak-main-tab-screen';

  const SadbhavBaithakMainTab({super.key});

  @override
  State<SadbhavBaithakMainTab> createState() => _SadbhavBaithakMainTabState();
}

class _SadbhavBaithakMainTabState extends State<SadbhavBaithakMainTab> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  bool _isSearching = false;

  @override
  void initState() {
    print("initState");
    getInitialData();
    _tabController = new TabController(length: 2, vsync: this);
    log("initState SadbhavBaithakMainTab runnn >>>>>>>>>>>>>> ");
    // WidgetsBinding.instance.addPostFrameCallback((t) => getAbhiyaanGeoUnitsFun());
    _tabController?.addListener(_handleTabChange);
    super.initState();
  }

  getInitialData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
    });
    log("initState _SadbhavBaithakMainTabState runnn >>>>>>>>>>>>>> $userLevelId");
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
        if (_tabController?.index == 1) {
          _tabController?.animateTo(0);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "${Statics.getLabel('sadbhavBaithak')} ${Statics.getLabel('Vrutta')}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            // actions: [IconButton(onPressed: () => Navigator.of(context).pushNamed(SadbhavCreationScreen.routeName), icon: Icon(Icons.add)), SizedBox(width: 12)],
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
                              FontAwesomeIcons.fileCirclePlus,
                              size: 18,
                            ),
                            Text(
                              "${Statics.getLabel('kendra')}",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      // Tab(
                      //   child: Row(
                      //     spacing: 16,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Icon(
                      //         FontAwesomeIcons.fileCircleQuestion,
                      //         size: 18,
                      //       ),
                      //       Text(
                      //         "${Statics.getLabel('baithak')}",
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(fontSize: 15),
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
                ? SadbhavCenterListScreen()
                : TabBarView(
                    controller: _tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      SadbhavCenterListScreen(),
                      // SadbhavSearchVruttaTab(),
                      SadbhavReportTab(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
