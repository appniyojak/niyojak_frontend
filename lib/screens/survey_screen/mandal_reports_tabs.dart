import 'package:flutter/material.dart';
import 'package:niyojak_prod/screens/survey_screen/report_view/mandal_report_tab1.dart';
import 'package:niyojak_prod/screens/survey_screen/report_view/mandal_report_tab2.dart';
import 'package:niyojak_prod/screens/survey_screen/report_view/mandal_report_tab3.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';

import '../../helpers/static_data.dart' as Statics;
import 'vasti_sarvekshan_screen.dart';

class MandalSurveyReportScreen extends StatefulWidget {
  static const String routeName = '/mandal-survey-report';

  @override
  _MandalSurveyReportScreenState createState() => _MandalSurveyReportScreenState();
}

class _MandalSurveyReportScreenState extends State<MandalSurveyReportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
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
        if (_tabController?.index == 1 || _tabController?.index == 2) {
          _tabController?.animateTo(0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('mandalSurveyReport'),
            style: TextStyle(fontSize: 24),
          ),
          actions: [IconButton(onPressed: () => Navigator.of(context).pushNamed(VastiSarvekshanScreen.routeName), icon: Icon(Icons.download, color: Colors.white)), SizedBox(width: 8)],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                text: Statics.getLabel('SampurnaReportMandal'),
              ),
              Tab(
                text: Statics.getLabel('mandalReport'),
              ),
              Tab(
                text: Statics.getLabel('GraamAhaval'),
              ),
            ],
          ),
        ),
        drawer: AppDrawer(),
        body: TabBarView(
          controller: _tabController,
          children: [
            MandalSurveyReportViewScreen1(),
            MandalSurveyReportViewScreen2(),
            MandalSurveyReportViewScreen3(),
          ],
        ),
      ),
    );
  }
}
