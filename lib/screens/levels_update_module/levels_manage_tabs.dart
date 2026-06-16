import 'package:flutter/material.dart';
import 'package:niyojak_prod/screens/levels_update_module/up_khanda_nagar_add_update_view.dart';
import 'package:niyojak_prod/screens/levels_update_module/update_master_data.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../widgets/app_drawer.dart';

class TabScreen extends StatefulWidget {
  static const routeName = '/level-tab-update-screen';

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(_handleTabChange);
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
        if (_tabController?.index == 1 || _tabController?.index == 2) {
          _tabController?.animateTo(0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('masterdataupdate'),
            style: TextStyle(fontSize: 24),
          ),
          bottom: TabBar(
            controller: _tabController,
            unselectedLabelStyle: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
            labelStyle: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
            tabs: [
              Tab(text: Statics.getLabel('addUpnagarUpkhanda')),
              Tab(text: Statics.getLabel('masterdataupdate')),
            ],
          ),
        ),
        drawer: AppDrawer(),
        body: TabBarView(
          controller: _tabController,
          children: [
            UpNagarkhandaAddUpdateView(),
            UpdateMasterDataScreen(),
          ],
        ),
      ),
    );
  }
}
