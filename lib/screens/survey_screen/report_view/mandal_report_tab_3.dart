import 'package:flutter/material.dart';

class MandalSurveyReportViewScreen3 extends StatefulWidget {
  static const String routeName = '/mandal-survey-report-tab3';

  const MandalSurveyReportViewScreen3({super.key});

  @override
  State<MandalSurveyReportViewScreen3> createState() => _MandalSurveyReportViewScreen3State();
}

class _MandalSurveyReportViewScreen3State extends State<MandalSurveyReportViewScreen3> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        child: Center(
         child: Text(
            "माहिती उपलब्ध नाही."
          )
        ),
      ),
    );
  }
}
