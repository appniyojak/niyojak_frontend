import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../utils/globals.dart';
import '../../../widgets/app_drawer.dart';
import 'shakhaa_saptah_form_screen.dart';
import 'shakhaa_saptah_list_tab.dart';
import 'shakhaa_saptah_report_tab.dart';

class ShakhaSaptahMainTab extends StatefulWidget {
  static const routeName = '/shakhaa-vistar-main-tab-screen';

  const ShakhaSaptahMainTab({super.key});

  @override
  State<ShakhaSaptahMainTab> createState() => _ShakhaSaptahMainTabState();
}

class _ShakhaSaptahMainTabState extends State<ShakhaSaptahMainTab> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  int selectedId = 0;
  bool _fromYest = false;
  String _viewType = "EditVrutta";

  bool _isSearching = false;

  @override
  void initState() {
    print("initState");
    getInitialData();
    _tabController = new TabController(length: 2, vsync: this);
    // WidgetsBinding.instance.addPostFrameCallback((t) => getInitialData());
    _tabController?.addListener(_handleTabChange);
    super.initState();
  }

  getInitialData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    if (dm.levelID == 1) selectedId = dm.geoUnitID ?? 0;
    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
    });
    log("initState _HinduSanmelanMainTabState runnn >>>>>>>>>>>>>> $userLevelId");
  }

  void onIdSelected(int id, bool fromYes, String viewType) {
    setState(() {
      selectedId = id;
      _fromYest = fromYes;
      _viewType = viewType;
    });

    // switch to first tab
    _tabController?.animateTo(1);
  }

  final GlobalKey<ShakhaaSaptahReportTabState> _reportTabKey = GlobalKey<ShakhaaSaptahReportTabState>();

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
    // 2. Determine if the system back button is allowed to close/pop the screen.
    // It should pop normally if it's a single screen OR if the user is already on the first tab (index 0).
    final bool canPopScreen = _tabController?.index == 0;

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
              "${Statics.getLabel('shakhaVistaar')}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              physics: NeverScrollableScrollPhysics(),
              onTap: (index) {
                if (index == 0 && userLevelId == 1) {
                  // This safely calls the refresh method inside your tab
                  _reportTabKey.currentState?.getReportDataFun(_reportTabKey.currentState?.selectedshaakhaa?.geoUnitID ?? _reportTabKey.currentState?.controller.deepestSelectedGeoUnitId);
                } else if (index == 0 && [2, 3].contains(userLevelId)) {
                  // This safely calls the refresh method inside your tab
                  _reportTabKey.currentState?.populatelinkedShaakhaDropdown(
                      (_reportTabKey.currentState?.selectedshaakhaa?.geoUnitID ?? _reportTabKey.currentState?.controller.deepestSelectedGeoUnitId).toString(), userLevelId == 1);
                }
              },
              tabs: <Widget>[
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
                      Icon(
                        Icons.search,
                        size: 18,
                      ),
                      Text(
                        "${Statics.getLabel('fillVrutta')}",
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
                ShakhaaSaptahReportTab(key: _reportTabKey, onIdTap: onIdSelected),
                userLevelId == 1
                    ? ShakhaaSaptahFormScreen(key: ValueKey('$selectedId-$_fromYest-$_viewType'), showAppBar: false, shaakhaaId: selectedId, fromYesterday: _fromYest, viewType: _viewType)
                    : ShakhaaSaptahListTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
