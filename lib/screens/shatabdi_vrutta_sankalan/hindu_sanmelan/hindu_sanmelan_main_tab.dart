import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../helpers/static_data.dart' as Statics;
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

  bool _isSearching = false;

  @override
  void initState() {
    print("initState");
    // getInitialData();
    _tabController = new TabController(length: 2, vsync: this);
    log("initState _HinduSanmelanMainTabState runnn >>>>>>>>>>>>>> ");
    // WidgetsBinding.instance.addPostFrameCallback((t) => getAbhiyaanGeoUnitsFun());
    super.initState();
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
          bottom:
              // (Statics.abhiyaanUserDetails["isEmpty"] && int.parse(Statics.userDetails["LevelID"].toString()) < 6)
              //     ? null
              //     : new
              TabBar(
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
          child:
              // (Statics.abhiyaanUserDetails["isEmpty"] && int.parse(Statics.userDetails["LevelID"].toString()) < 6)
              //     ? GruhSamparkaReportTab(
              //         initialData: initialData,
              //       )
              //     :
              TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              HinduSanmelanForm(),
              HinduSanmelanReport(),
            ],
          ),
        ),
      ),
    );
  }
}
