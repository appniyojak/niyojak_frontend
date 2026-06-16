import 'package:flutter/material.dart';
import 'package:niyojak_prod/screens/survey_screen/report_view/vasti_report_tab1.dart';
import 'package:niyojak_prod/screens/survey_screen/report_view/vasti_report_tab2.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';

import '../../helpers/static_data.dart' as Statics;
import 'vasti_sarvekshan_screen.dart';

class VastiSurveyReportScreen extends StatefulWidget {
  static const String routeName = '/vasti-survey-report-tab-view';

  @override
  _VastiSurveyReportScreenState createState() => _VastiSurveyReportScreenState();
}

class _VastiSurveyReportScreenState extends State<VastiSurveyReportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(_handleTabChange);
    super.initState();
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
        if (_tabController?.index == 1) {
          _tabController?.animateTo(0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('vastiSurveyReport'),
            style: TextStyle(fontSize: 24),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                text: Statics.getLabel('SampurnaReport'),
              ),
              Tab(
                text: Statics.getLabel('VastiReport'),
              ),
            ],
          ),
          actions: [
            IconButton(onPressed: () => Navigator.of(context).pushNamed(VastiSarvekshanScreen.routeName, arguments: true), icon: Icon(Icons.download, color: Colors.white)),
            SizedBox(width: 8)
          ],
        ),
        drawer: AppDrawer(),
        body: TabBarView(
          controller: _tabController,
          children: [
            VastiSurveyReportTab1(),
            VastiSurveyReportTab2(),
          ],
        ),
      ),
    );
  }
}
