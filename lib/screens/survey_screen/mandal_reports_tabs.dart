import 'package:flutter/material.dart';
import 'package:niyojak_prod/screens/survey_screen/report_view/mandal_report_tab1.dart';
import 'package:niyojak_prod/screens/survey_screen/report_view/mandal_report_tab2.dart';
import 'package:niyojak_prod/screens/survey_screen/report_view/mandal_report_tab3.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';

import '../../helpers/static_data.dart' as Statics;

class MandalSurveyReportScreen extends StatefulWidget {
  static const String routeName = '/mandal-survey-report';

  @override
  _MandalSurveyReportScreenState createState() =>
      _MandalSurveyReportScreenState();
}

class _MandalSurveyReportScreenState extends State<MandalSurveyReportScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('mandalSurveyReport'),
            style: TextStyle(fontSize: 24),
          ),
          bottom: TabBar(
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
