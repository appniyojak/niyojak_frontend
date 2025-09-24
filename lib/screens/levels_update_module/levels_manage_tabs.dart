import 'package:flutter/material.dart';
import 'package:niyojak_prod/screens/levels_update_module/up_khanda_nagar_add_update_view.dart';
import 'package:niyojak_prod/screens/levels_update_module/update_master_data.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../widgets/app_drawer.dart';

class TabScreen extends StatelessWidget {
  static const routeName = '/level-tab-update-screen';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 2 tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('masterdataupdate'),
            style: TextStyle(fontSize: 24),
          ),
          bottom: TabBar(
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
          children: [
            UpNagarkhandaAddUpdateView(),
            UpdateMasterDataScreen(),
          ],
        ),
      ),
    );
  }
}
