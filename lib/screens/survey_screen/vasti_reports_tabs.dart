import 'package:flutter/material.dart';
import 'package:niyojak_prod/screens/survey_screen/report_view/vasti_report_tab1.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';
import 'report_view/vasti_report_tab2.dart';
import '../../helpers/static_data.dart' as Statics;

class VastiSurveyReportScreen extends StatefulWidget {
  static const String routeName = '/vasti-survey-report-tab-view';

  @override
  _VastiSurveyReportScreenState createState() => _VastiSurveyReportScreenState();
}

class _VastiSurveyReportScreenState extends State<VastiSurveyReportScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('vastiSurveyReport'),
            style: TextStyle(fontSize: 24),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text:  Statics.getLabel('SampurnaReport'),),
              Tab(text:  Statics.getLabel('VastiReport'),),
            ],
          ),
        ),
        drawer: AppDrawer(),
        body: TabBarView(
          children: [
            CompleteSurveyReport(),
            VastiSurveyReportViewScreen(),

          ],
        ),
      ),
    );
  }
}
