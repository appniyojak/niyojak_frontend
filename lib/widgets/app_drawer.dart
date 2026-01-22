import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanLoginDataResponse.dart';
import 'package:niyojak_prod/providers/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/static_data.dart' as Statics;
import '../screens/annual_baithak_ekatrit_vrutta.dart';
import '../screens/help_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search_annual_baithak_vrutta.dart';
import '../screens/search_shaakhaa.dart';
import '../screens/search_swayamsevak_transfer.dart';
import '../screens/sewa_vasti_list.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  AbhiyanSwayamsevakdata? initialData;

  List<String> deniedLevels = ["Shakha", "Saptahik Milan", "शाखा", "साप्ताहिक मिलन"];

  List<String> allowedLevels = [
    "Praant",
    "Mahaanagar",
    "Vibhaag",
    "Bhaag",
    "Shahar",
    "Nagar",
    "Nagar/Taalukaa",
    "Upnagar/Upkhanda",
    "Vasti",
    "Mandal",
    "Gram",
    "प्रांत",
    "महानगर",
    "विभाग",
    "भाग",
    "भाग/जिल्हा",
    "भाग/जिला",
    "शहर",
    "नगर/तालुका",
    "उपनगर/उपखंड",
    "वस्ती",
    "मंडल",
    "ग्राम",
    "गाव",
  ];

  // List<String> allowedDayitva = [
  //   "Praudh Vyavsayee Pramukh",
  //   "प्रौढ व्यवसायी प्रमुख",
  //   "Tarun Vyavsayee Sah Pramukh",
  //   "तरुण व्यवसायी सह प्रमुख",
  //   "Mahavidyaleen Vidyarthi Sah Pramukh",
  //   "महाविद्यालयीन विद्यार्थी सह प्रमुख",
  //   "App Sanyojak",
  //   "एप संयोजक",
  //   "Join RSS Sanyojak",
  //   "जॉयन आर.एस.एस. संयोजक",
  //   "Join RSS Pramukh",
  //   "जॉयन आर.एस.एस. प्रमुख",
  //   "Baal Vidyaarthi Pramukh",
  //   "बाल विद्यार्थी प्रमुख",
  //   "Vyavasaayee Pramukh",
  //   "व्यवसायी प्रमुख",
  //   "Vyavasaayee Saha-Pramukh",
  //   "व्यवसायी सह प्रमुख",
  //   "Tarun Vyavsayee Pramukh",
  //   "तरुण व्यवसायी प्रमुख",
  //   "Kaaryavaah",
  //   "कार्यवाह",
  //   "Saha-Kaaryavaah",
  //   "सह कार्यवाह",
  //   "Prachaarak",
  //   "प्रचारक",
  //   "Saha-Prachaarak",
  //   "सह प्रचारक",
  //   "Praudh Vyavsayee Saha -Pramukh",
  //   "प्रौढ़ व्यवसायी सह प्रमुख",
  //   "Mahaavidyaalayeen Vidyaarthi Pramukh",
  //   "महाविद्यालयीन विद्यार्थी प्रमुख",
  //   "Mahaavidyaalayeen Pramukh",
  //   "महाविद्यालयीन प्रमुख",
  //   "Baal Vidyaarthi Saha Pramukh",
  //   "बाल विद्यार्थी सह प्रमुख",
  //   "Prachaar Pramukh",
  //   "प्रचार प्रमुख",
  //   "Kaaryaalay Pramukh",
  //   "कार्यालय प्रमुख"
  // ];

  bool shouldShowListTile(String userLevel, String userDayitva) {
    // print("userLevel --> $userLevel  === userDayitva --> $userDayitva");
    // print(allowedLevels.contains(userLevel) && allowedDayitva.contains(userDayitva));
    ///
    return !deniedLevels.contains(userLevel);

    ///
    // return allowedLevels.contains(userLevel); // && allowedDayitva.contains(userDayitva);
  }

  //================================================================================================================================================
  List<String> allowedLevelsforGeounitCHange = ["Praant", "प्रांत", "Mahaanagar", "महानगर", "Vibhaag", "विभाग", "Bhaag", "भाग", "भाग/जिल्हा", "भाग/जिला", "Nagar", "Nagar/Taalukaa", "नगर/तालुका"];

  List<String> allowedDayitvaforGeounitCHange = [
    "Kaaryavaah",
    "कार्यवाह",
    "Saha-Kaaryavaah",
    "सह कार्यवाह",
    "Prachaarak",
    "प्रचारक",
    "Vyavasthaa Pramukh",
    "व्यवस्था प्रमुख",
    "karyalay sachiv",
    "कार्यालय सचिव",
    "App Sanyojak",
    "एप संयोजक",
    "Saha-Prachaarak",
    "सह प्रचारक",
    "Vyavasaayee Saha-Pramukh",
    "व्यवसायी सह प्रमुख",
    "Kaaryaalay Pramukh",
    "कार्यालय प्रमुख",
    "Saha-kaaryaalay Pramukh",
    "सह कार्यालय प्रमुख",
  ];

  bool shouldShowListTileforGeounitCHange(String userLevel, String userDayitva) {
    // print("userLevel --> $userLevel  === userDayitva --> $userDayitva");
    // print(allowedLevels.contains(userLevel) && allowedDayitva.contains(userDayitva));
    return allowedLevelsforGeounitCHange.contains(userLevel) && allowedDayitvaforGeounitCHange.contains(userDayitva);
  }

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var data = pref.getString("AbhiyanSwayamsevakData");
      // print(data);
      if (data != null) {
        initialData = AbhiyanSwayamsevakdata.fromJson(jsonDecode(data));
        setState(() {});
      }
    });
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text(Statics.getLabel('appDrawerHeader')),
              automaticallyImplyLeading: false,
            ),
            Divider(),
            ListTile(
              dense: true,
              leading: Icon(Icons.home),
              title: Text(
                Statics.getLabel('homeScreenLabel'),
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
              },
            ),
            // Divider(),
            // ExpansionTile(
            //   leading: Icon(Icons.location_searching, size: 20),
            //   tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            //   title: Text(
            //     Statics.getLabel('Survey'),
            //     style: TextStyle(fontSize: 18),
            //   ),
            //   onExpansionChanged: (expanded) {
            //     setState(() {
            //       _isExpanded = expanded;
            //     });
            //   },
            //   children: [
            //     ListTile(
            //       leading: Icon(Icons.share_location, size: 20),
            //       title: Text(
            //         Statics.getLabel('vastiSurvey'),
            //         style: TextStyle(fontSize: 18),
            //       ),
            //       onTap: () {
            //         Navigator.of(context).pushNamed(VastiSurveyFormScreen.routeName);
            //       },
            //     ),
            //     ListTile(
            //       leading: Icon(Icons.share_location, size: 20),
            //       title: Text(
            //         Statics.getLabel('mandalSurvey'),
            //         style: TextStyle(fontSize: 18),
            //       ),
            //       onTap: () {
            //         Navigator.of(context).pushNamed(MandalSurveyFormScreen.routeName);
            //       },
            //     ),
            //   ],
            // ),
            // Divider(),
            // ExpansionTile(
            //   leading: Icon(Icons.document_scanner_outlined, size: 20),
            //   tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            //   title: Text(
            //     Statics.getLabel('Report'),
            //     style: TextStyle(fontSize: 18),
            //   ),
            //   onExpansionChanged: (expanded) {
            //     setState(() {
            //       _isExpanded = expanded;
            //     });
            //   },
            //   children: [
            //     ListTile(
            //       leading: Icon(Icons.document_scanner, size: 20),
            //       title: Text(
            //         Statics.getLabel('vastiSurveyReport'),
            //         style: TextStyle(fontSize: 18),
            //       ),
            //       onTap: () {
            //         Navigator.of(context).pushNamed(VastiSurveyReportScreen.routeName);
            //       },
            //     ),
            //     // ListTile(
            //     //   leading: Icon(Icons.document_scanner, size: 20),
            //     //   title:Text(
            //     //     Statics.getLabel('SampurnaReport'),
            //     //     style: TextStyle(fontSize: 18),
            //     //   ),
            //     //   onTap: () {
            //     //     Navigator.of(context).pushReplacementNamed(CompleteSurveyReport.routeName);
            //     //   },
            //     // ),
            //     ListTile(
            //       leading: Icon(Icons.document_scanner, size: 20),
            //       title: Text(
            //         Statics.getLabel('mandalSurveyReport'),
            //         style: TextStyle(fontSize: 18),
            //       ),
            //       onTap: () {
            //         Navigator.of(context).pushNamed(MandalSurveyReportScreen.routeName);
            //       },
            //     ),
            //   ],
            // ),
            // Divider(),
            // ListTile(
            //   dense: true,
            //   leading: Icon(Icons.location_searching),
            //   title: Text(
            //     Statics.getLabel('vastiSurvey'),
            //     style: TextStyle(fontSize: 18),
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacementNamed(VastiSurveyFormScreen.routeName);
            //   },
            // ),
            // Divider(),
            // ListTile(
            //   dense: true,
            //   leading: Icon(Icons.document_scanner_outlined),
            //   title: Text(
            //     Statics.getLabel('vastiSurveyReport'),
            //     style: TextStyle(fontSize: 18),
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacementNamed(VastiSurveyReportViewScreen.routeName);
            //   },
            // ),
            // Divider(),
            // ListTile(
            //   dense: true,
            //   leading: Icon(Icons.location_searching),
            //   title: Text(
            //     Statics.getLabel('mandalSurvey'),
            //     style: TextStyle(fontSize: 18),
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacementNamed(MandalSurveyFormScreen.routeName);
            //   },
            // ),
            // if (initialData != null)
            // Divider(),//
            // if (initialData != null)
            // ListTile(
            //   dense: true,
            //   leading: Icon(Icons.api),
            //   title: Text(
            //     "${Statics.getLabel('Abhiyaan')}",
            //     style: TextStyle(fontSize: 18),
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacementNamed(AbhiyanScreen.routeName);
            //   },
            // ),
            // Divider(),
            // ExpansionTile(
            //   leading: Icon(Icons.newspaper_outlined, size: 20),
            //   tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            //   title: Text(
            //     Statics.getLabel('shatabdiVarshaVruttaSankalan'),
            //     style: TextStyle(fontSize: 18),
            //   ),
            //   onExpansionChanged: (expanded) {
            //     setState(() {
            //       _isExpanded = expanded;
            //     });
            //   },
            //   children: [
            //     ListTile(
            //       dense: true,
            //       leading: Icon(Icons.app_registration),
            //       title: Text(
            //         "${Statics.getLabel('vijayaDashamiUtsav')}",
            //         style: TextStyle(fontSize: 18),
            //       ),
            //       onTap: () {
            //         Navigator.of(context).pushReplacementNamed(VijayadashamiFormView.routeName);
            //       },
            //     ),
            //     // ListTile(
            //     //   dense: true,
            //     //   leading: Icon(Icons.add_home_work_outlined),
            //     //   title: Text(
            //     //     "${Statics.getLabel('gruhSamparkAbhiyaan')}",
            //     //     style: TextStyle(fontSize: 18),
            //     //   ),
            //     //   onTap: () {
            //     //     Navigator.of(context).pushReplacementNamed(GruhSamparkAbhiyanView.routeName);
            //     //   },
            //     // ),
            //   ],
            // ),
            // Divider(),
            // ListTile(
            //   dense: true,
            //   leading: Icon(Icons.people),
            //   title: Text(
            //     Statics.getLabel('searchSwayamsevakScreenLabel'),
            //     style: TextStyle(fontSize: 18),
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacementNamed(SwayamSevakSearch.routeName);
            //   },
            // ),
            // if (((Statics.userDetails["LevelName"] == "Praant" ||
            //                 Statics.userDetails["LevelName"] == "प्रांत" ||
            //                 Statics.userDetails["LevelName"] == "Mahaanagar" ||
            //                 Statics.userDetails["LevelName"] == "महानगर" ||
            //                 Statics.userDetails["LevelName"] == "Vibhaag" ||
            //                 Statics.userDetails["LevelName"] == "विभाग" ||
            //                 Statics.userDetails["LevelName"] == "Bhaag" ||
            //                 Statics.userDetails["LevelName"] == "भाग/जिला" ||
            //                 Statics.userDetails["LevelName"] == "भाग/जिल्हा" ||
            //                 Statics.userDetails["LevelName"] == "Shahar" ||
            //                 Statics.userDetails["LevelName"] == "शहर" ||
            //                 Statics.userDetails['LevelName'] == 'Nagar/Taalukaa' ||
            //                 Statics.userDetails['LevelName'] == 'Nagar' ||
            //                 Statics.userDetails["LevelName"] == "नगर/तालुका") &&
            //             Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" ||
            //         Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" ||
            //         Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" ||
            //         Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" ||
            //         Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" ||
            //         Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] ==
            //             "App Sanyojak" || //     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||//     Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah")
            //         (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
            //             Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
            //             Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "App Sanyojak" ||
            //             Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
            //             Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
            //             Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
            //             Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
            //             Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
            //             Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
            //             Statics.userDetails["DaayitvaName"] == "सह कार्यवाह")) ||
            //     (Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
            //         Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
            //         Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||
            //         Statics.userDetails['DaayitvaName'] == 'सह प्रचारक'))
            // Divider(),
//             if (
//                   (
//                       (Statics.userDetails["LevelName"] == "Praant" ||Statics.userDetails["LevelName"] == "प्रांत" ||
//                         Statics.userDetails["LevelName"] == "Mahaanagar" ||Statics.userDetails["LevelName"] == "महानगर" ||
//                         Statics.userDetails["LevelName"] == "Vibhaag" ||Statics.userDetails["LevelName"] == "विभाग" ||
//                         Statics.userDetails["LevelName"] == "Bhaag" ||Statics.userDetails["LevelName"] == "भाग/जिला" ||Statics.userDetails["LevelName"] == "भाग/जिल्हा" ||
//                         Statics.userDetails["LevelName"] == "Shahar" ||Statics.userDetails["LevelName"] == "शहर" ||
//                         Statics.userDetails['LevelName'] == 'Nagar/Taalukaa'  || Statics.userDetails['LevelName'] == 'Nagar' || Statics.userDetails["LevelName"] == "नगर/तालुका")
//                         &&
//                          Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
//                         Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
//                         Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
//                         Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
//                         Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
//                         Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||
//                         (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
//                         Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
//                         Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
//                         Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
//                         Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
//                         Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
//                         Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
//                         Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
//                         Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
//                         Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
//                         Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
//                         Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah"  || Statics.userDetails["DaayitvaName"] == "सह कार्यवाह")
//             ) ||
//                 (Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails['DaayitvaName'] == 'Prachaarak' || Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||
//                     Statics.userDetails['DaayitvaName'] == 'प्रचारक' || Statics.userDetails['DaayitvaName'] == 'सह प्रचारक'))
// // isme condition add kro ki agar 'Statics.userDetails['LevelName'] == 'Shaakhaa'  || Statics.userDetails["LevelName"] == "शाखा" &&
// //  Statics.userDetails['LevelName'] == 'Kaaryavaah'  || Statics.userDetails["LevelName"] == "कार्यवाह" ' aisa ho toh niche wali ListTile mhi dikhegi
//               ListTile(
//                 dense: true,
//                 leading: Icon(Icons.app_registration),
//                 title: Text(
//                   Statics.getLabel('searchJoinRSSScreenLabel'),
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 onTap: () {
//                   Navigator.of(context).pushReplacementNamed(SearchJoinRss.routeName);
//                 },
//               ),
//========================================================================================= COmment onnn 13-3-2025 =========================================================================================
//             if (
//             !((Statics.userDetails['LevelName'] == 'Shaakhaa' || Statics.userDetails["LevelName"] == "शाखा") &&
//                 (Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' || Statics.userDetails["DaayitvaName"] == "कार्यवाह")) &&
//                 (
//                     (
//                         (Statics.userDetails["LevelName"] == "Praant" || Statics.userDetails["LevelName"] == "प्रांत" ||
//                             Statics.userDetails["LevelName"] == "Mahaanagar" || Statics.userDetails["LevelName"] == "महानगर" ||
//                             Statics.userDetails["LevelName"] == "Vibhaag" || Statics.userDetails["LevelName"] == "विभाग" ||
//                             Statics.userDetails["LevelName"] == "Bhaag" || Statics.userDetails["LevelName"] == "भाग/जिला" || Statics.userDetails["LevelName"] == "भाग/जिल्हा" ||
//                             Statics.userDetails["LevelName"] == "Shahar" || Statics.userDetails["LevelName"] == "शहर" ||
//                             Statics.userDetails['LevelName'] == 'Nagar/Taalukaa' || Statics.userDetails['LevelName'] == 'Nagar' || Statics.userDetails["LevelName"] == "नगर/तालुका") &&
//                             (
//                                 Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
//                                     Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
//                                     Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
//                                     Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
//                                     Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
//                                     Statics.userDetails["DaayitvaName"] == "App Sanyojak" || Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
//                                     Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
//                                     Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
//                                     Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
//                                     Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh" || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
//                                     Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh" || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
//                                     Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
//                                     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" || Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
//                                     Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" || Statics.userDetails["DaayitvaName"] == "सह कार्यवाह" ||
//                                     Statics.userDetails["DaayitvaName"] == "Prachaar Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रचार प्रमुख" ||
//                                     Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
//                                     Statics.userDetails["DaayitvaName"] == "Prachaarak" || Statics.userDetails["DaayitvaName"] == "प्रचारक" ||
//                                     Statics.userDetails["DaayitvaName"] == "Saha-Prachaarak" || Statics.userDetails["DaayitvaName"] == "सह प्रचारक"
//                             )
//                     )
//                 )
//             )
//=================================================================================================================================================================================
//               if (shouldShowListTile(Statics.userDetails['LevelName'], Statics.userDetails["DaayitvaName"]) == true)
            // ListTile(
            //   dense: true,
            //   leading: Icon(Icons.app_registration),
            //   title: Text(
            //     Statics.getLabel('searchJoinRSSScreenLabel'),
            //     style: TextStyle(fontSize: 18),
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacementNamed(SearchJoinRss.routeName);
            //   },
            // ),
            if (!((Statics.userDetails['LevelName'] == 'Shaakhaa' || Statics.userDetails["LevelName"] == "शाखा") &&
                    (Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' || Statics.userDetails["DaayitvaName"] == "कार्यवाह")) &&
                (((Statics.userDetails["LevelName"] == "Praant" ||
                            Statics.userDetails["LevelName"] == "प्रांत" ||
                            Statics.userDetails["LevelName"] == "Mahaanagar" ||
                            Statics.userDetails["LevelName"] == "महानगर" ||
                            Statics.userDetails["LevelName"] == "Vibhaag" ||
                            Statics.userDetails["LevelName"] == "विभाग" ||
                            Statics.userDetails["LevelName"] == "Bhaag" ||
                            Statics.userDetails["LevelName"] == "भाग/जिला" ||
                            Statics.userDetails["LevelName"] == "भाग/जिल्हा" ||
                            Statics.userDetails["LevelName"] == "Shahar" ||
                            Statics.userDetails["LevelName"] == "शहर" ||
                            Statics.userDetails['LevelName'] == 'Nagar/Taalukaa' ||
                            Statics.userDetails['LevelName'] == 'Nagar' ||
                            Statics.userDetails["LevelName"] == "नगर/तालुका") &&
                        (Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "App Sanyojak" ||
                            Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
                            Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
                            Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
                            Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
                            Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
                            Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
                            Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
                            Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
                            Statics.userDetails["DaayitvaName"] == "सह कार्यवाह")) ||
                    (Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" ||
                        Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
                        Statics.userDetails["DaayitvaName"] == "Prachaarak" ||
                        Statics.userDetails["DaayitvaName"] == "प्रचारक" ||
                        Statics.userDetails["DaayitvaName"] == "Saha-Prachaarak" ||
                        Statics.userDetails["DaayitvaName"] == "सह प्रचारक")))
              Divider(),
            if (int.parse(Statics.userDetails["LevelID"]) >= 6 &&
                (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
                    Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
                    Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "App Sanyojak" ||
                    Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
                    Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
                    Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
                    Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
                    Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
                    Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
                    Statics.userDetails["DaayitvaName"] == "सह कार्यवाह" ||
                    Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' ||
                    Statics.userDetails['DaayitvaName'] == 'कार्यालय प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
                    Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
                    Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||
                    Statics.userDetails['DaayitvaName'] == 'सह प्रचारक' ||
                    Statics.userDetails["DaayitvaName"] == "Sewa Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "सेवा प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Sewa Saha-Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Vyavasthaa Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "व्यवस्था प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "व्यवस्था प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Vyavasthaa Saha-Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "व्यवस्था प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "व्यवस्था प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Sewa Vibhaag - Toli Sadasya" ||
                    Statics.userDetails["DaayitvaName"] == "सेवा विभाग टोली सदस्य"))
              // if (Statics.userDetails["MobileNumber"] == "7738167968")
              ListTile(
                dense: true,
                leading: Icon(Icons.storage),
                title: Text(
                  Statics.getLabel('AnnualBaithakVrutta'),
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(SearchAnnualBaithakVrutta.routeName);
                },
              ),
            if (int.parse(Statics.userDetails["LevelID"]) >= 6 &&
                (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
                    Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
                    Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "App Sanyojak" ||
                    Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
                    Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
                    Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
                    Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
                    Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
                    Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
                    Statics.userDetails["DaayitvaName"] == "सह कार्यवाह" ||
                    Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' ||
                    Statics.userDetails['DaayitvaName'] == 'कार्यालय प्रमुख' ||
                    Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
                    Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
                    Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||
                    Statics.userDetails['DaayitvaName'] == 'सह प्रचारक' ||
                    Statics.userDetails["DaayitvaName"] == "Sewa Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "सेवा प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Sewa Saha-Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Vyavasthaa Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "व्यवस्था प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "व्यवस्था प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Vyavasthaa Saha-Pramukh" ||
                    Statics.userDetails["DaayitvaName"] == "व्यवस्था प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "व्यवस्था प्रमुख" ||
                    Statics.userDetails["DaayitvaName"] == "Sewa Vibhaag - Toli Sadasya" ||
                    Statics.userDetails["DaayitvaName"] == "सेवा विभाग टोली सदस्य"))
              // if (Statics.userDetails["MobileNumber"] == "7738167968")
              Divider(),
            if (int.parse(Statics.userDetails["LevelID"]) >= 6)
              // if (Statics.userDetails["MobileNumber"] == "7738167968")
              ListTile(
                dense: true,
                leading: Icon(Icons.report),
                title: Text(
                  Statics.getLabel('annualBaithakEkatritVrutta'),
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(AnnualBaithakEkatritVrutta.routeName);
                },
              ),
            if (int.parse(Statics.userDetails["LevelID"]) >= 6) Divider(),
            ListTile(
              dense: true,
              leading: Icon(FontAwesomeIcons.university),
              title: Text(
                Statics.getLabel('searchShaakhaaScreenLabel'),
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(SearchShaakhaaScreen.routeName);
              },
            ),
            Divider(),
            // if (shouldShowListTileforGeounitCHange(Statics.userDetails['LevelName'], Statics.userDetails["DaayitvaName"]) == true)
            //   ListTile(
            //     dense: true,
            //     leading: Icon(Icons.security_update_good_outlined),
            //     title: Text(
            //       Statics.getLabel('masterdataupdate'),
            //       style: TextStyle(fontSize: 18),
            //     ),
            //     onTap: () {
            //       Navigator.of(context).pushReplacementNamed(TabScreen.routeName);
            //     },
            //   ),
            // if (shouldShowListTileforGeounitCHange(Statics.userDetails['LevelName'], Statics.userDetails["DaayitvaName"]) == true) Divider(),
            // Divider(),
            // ListTile(
            //   dense: true,
            //   leading: Icon(Icons.notification_add_sharp),
            //   title: Text(
            //     Statics.getLabel('createNotification'),
            //     style: TextStyle(fontSize: 18),
            //   ),
            //   onTap: () {
            //     Navigator.of(context)
            //         .pushReplacementNamed(CreateNotificationView.routeName);
            //   },
            // ),
            // ListTile(
            //   dense: true,
            //   leading: Icon(Icons.list),
            //   title: Text(
            //     Statics.getLabel('searchSoochiScreenLabel'),
            //     style: TextStyle(fontSize: 18),
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacementNamed(SearchSoochiScreen.routeName);
            //   },
            // ),
            // Divider(),
            // ListTile(
            //   dense: true,
            //   leading: Icon(Icons.event),
            //   title: Text(
            //     Statics.getLabel('searchEventsScreenLabel'),
            //     style: TextStyle(fontSize: 18),
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacementNamed(SearchEvent.routeName);
            //   },
            // ),
            // Divider(),
            // ListTile(
            //   dense: true,
            //   leading: Icon(Icons.calendar_today),
            //   title: Text(
            //     Statics.getLabel('EventCalender'),
            //     style: TextStyle(fontSize: 18),
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacementNamed(EventCalender.routeName);
            //   },
            // ),
            // if (Statics.userDetails["LevelName"] == "Praant" ||
            //     Statics.userDetails["LevelName"] == "Vibhaag" ||
            //     Statics.userDetails["LevelName"] == "Bhaag" ||
            //     Statics.userDetails["LevelName"] == "Shahar" ||
            //     Statics.userDetails["LevelName"] == "Nagar")
            // if  (Statics.userDetails["LevelName"] == "Praant" ||Statics.userDetails["LevelName"] == "प्रांत" ||
            //     Statics.userDetails["LevelName"] == "Vibhaag" ||Statics.userDetails["LevelName"] == "विभाग" ||
            //     Statics.userDetails["LevelName"] == "Bhaag" ||Statics.userDetails["LevelName"] == "भाग/जिला" ||Statics.userDetails["LevelName"] == "भाग/जिल्हा" ||
            //     Statics.userDetails["LevelName"] == "Shahar" ||Statics.userDetails["LevelName"] == "शहर" ||
            //     Statics.userDetails['LevelName'] == 'Nagar/Taalukaa'  || Statics.userDetails['LevelName'] == 'Nagar' ||| Statics.userDetails["LevelName"] == "नगर/तालुका")
            // if (((Statics.userDetails["LevelName"] == "Praant" ||Statics.userDetails["LevelName"] == "प्रांत" ||
            //         Statics.userDetails["LevelName"] == "Mahaanagar" ||Statics.userDetails["LevelName"] == "महानगर" ||
            //         Statics.userDetails["LevelName"] == "Vibhaag" ||Statics.userDetails["LevelName"] == "विभाग" ||
            //         Statics.userDetails["LevelName"] == "Bhaag" ||Statics.userDetails["LevelName"] == "भाग/जिला" ||Statics.userDetails["LevelName"] == "भाग/जिल्हा" ||
            //         Statics.userDetails["LevelName"] == "Shahar" ||Statics.userDetails["LevelName"] == "शहर" ||
            //         Statics.userDetails['LevelName'] == 'Nagar/Taalukaa'  || Statics.userDetails['LevelName'] == 'Nagar' || Statics.userDetails["LevelName"] == "नगर/तालुका")
            //         &&
            //         (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
            //             Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||
            //             Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||
            //             Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||
            //             Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  ||
            //             Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
            //             Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
            //             Statics.userDetails["DaayitvaName"] == "Sewa Pramukh" ||Statics.userDetails["DaayitvaName"] == "सेवा प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Sewa Vibhaag - Toli Sadasya" ||Statics.userDetails["DaayitvaName"] == "सेवा विभाग टोली सदस्य" ||
            //             Statics.userDetails["DaayitvaName"] == "Sewa Saha-Pramukh" ||Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah"  || Statics.userDetails["DaayitvaName"] == "सह कार्यवाह")) ||
            //     (Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||
            //         Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
            //         Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||Statics.userDetails['DaayitvaName'] == 'सह प्रचारक'||
            //         Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||Statics.userDetails["DaayitvaName"] == "कार्यवाह"))
            //   // Divider(),
            //   ListTile(
            //     dense: true,
            //     leading: Icon(Icons.home_work),
            //     title: Text(
            //       Statics.getLabel('searchSewaVastiScreenLabel'),
            //       style: TextStyle(fontSize: 18),
            //     ),
            //     onTap: () {
            //       Navigator.of(context).pushReplacementNamed(SearchSewaVasti.routeName);
            //     },
            //   ),
            if (!((Statics.userDetails['LevelName'] == 'Shaakhaa' || Statics.userDetails["LevelName"] == "शाखा") &&
                    (Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' || Statics.userDetails["DaayitvaName"] == "कार्यवाह")) &&
                (((Statics.userDetails["LevelName"] == "Praant" ||
                            Statics.userDetails["LevelName"] == "प्रांत" ||
                            Statics.userDetails["LevelName"] == "Mahaanagar" ||
                            Statics.userDetails["LevelName"] == "महानगर" ||
                            Statics.userDetails["LevelName"] == "Vibhaag" ||
                            Statics.userDetails["LevelName"] == "विभाग" ||
                            Statics.userDetails["LevelName"] == "Bhaag" ||
                            Statics.userDetails["LevelName"] == "भाग/जिला" ||
                            Statics.userDetails["LevelName"] == "भाग/जिल्हा" ||
                            Statics.userDetails["LevelName"] == "Shahar" ||
                            Statics.userDetails["LevelName"] == "शहर" ||
                            Statics.userDetails['LevelName'] == 'Nagar/Taalukaa' ||
                            Statics.userDetails['LevelName'] == 'Nagar' ||
                            Statics.userDetails["LevelName"] == "नगर/तालुका") &&
                        (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
                            Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
                            Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "App Sanyojak" ||
                            Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
                            Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
                            Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
                            Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
                            Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
                            Statics.userDetails["DaayitvaName"] == "Sewa Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "सेवा प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Sewa Vibhaag - Toli Sadasya" ||
                            Statics.userDetails["DaayitvaName"] == "सेवा विभाग टोली सदस्य" ||
                            Statics.userDetails["DaayitvaName"] == "Sewa Saha-Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
                            Statics.userDetails["DaayitvaName"] == "सह कार्यवाह")) ||
                    (Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" ||
                        Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
                        Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
                        Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
                        Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||
                        Statics.userDetails['DaayitvaName'] == 'सह प्रचारक' ||
                        Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
                        Statics.userDetails["DaayitvaName"] == "कार्यवाह")))
              ListTile(
                dense: true,
                leading: Icon(Icons.home_work),
                title: Text(
                  Statics.getLabel('searchSewaVastiScreenLabel'),
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(SearchSewaVasti.routeName);
                },
              ),
            if (!((Statics.userDetails['LevelName'] == 'Shaakhaa' || Statics.userDetails["LevelName"] == "शाखा") &&
                    (Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' || Statics.userDetails["DaayitvaName"] == "कार्यवाह")) &&
                (((Statics.userDetails["LevelName"] == "Praant" ||
                            Statics.userDetails["LevelName"] == "प्रांत" ||
                            Statics.userDetails["LevelName"] == "Mahaanagar" ||
                            Statics.userDetails["LevelName"] == "महानगर" ||
                            Statics.userDetails["LevelName"] == "Vibhaag" ||
                            Statics.userDetails["LevelName"] == "विभाग" ||
                            Statics.userDetails["LevelName"] == "Bhaag" ||
                            Statics.userDetails["LevelName"] == "भाग/जिला" ||
                            Statics.userDetails["LevelName"] == "भाग/जिल्हा" ||
                            Statics.userDetails["LevelName"] == "Shahar" ||
                            Statics.userDetails["LevelName"] == "शहर" ||
                            Statics.userDetails['LevelName'] == 'Nagar/Taalukaa' ||
                            Statics.userDetails['LevelName'] == 'Nagar' ||
                            Statics.userDetails["LevelName"] == "नगर/तालुका") &&
                        (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
                            Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
                            Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "App Sanyojak" ||
                            Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
                            Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
                            Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
                            Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
                            Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
                            Statics.userDetails["DaayitvaName"] == "Sewa Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "सेवा प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Sewa Vibhaag - Toli Sadasya" ||
                            Statics.userDetails["DaayitvaName"] == "सेवा विभाग टोली सदस्य" ||
                            Statics.userDetails["DaayitvaName"] == "Sewa Saha-Pramukh" ||
                            Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
                            Statics.userDetails["DaayitvaName"] == "सह कार्यवाह")) ||
                    (Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" ||
                        Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
                        Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
                        Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
                        Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||
                        Statics.userDetails['DaayitvaName'] == 'सह प्रचारक' ||
                        Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
                        Statics.userDetails["DaayitvaName"] == "कार्यवाह")))
              Divider(),
            if (!((Statics.userDetails['LevelName'] == 'Shaakhaa' || Statics.userDetails["LevelName"] == "शाखा") &&
                (Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' || Statics.userDetails["DaayitvaName"] == "कार्यवाह")))
              ListTile(
                dense: true,
                leading: Icon(Icons.transfer_within_a_station),
                title: Text(
                  Statics.getLabel('searchSwayamsevakTransferLabel'),
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(SearchSwayamsevakTransfer.routeName);
                },
              ),
            Divider(),
            ListTile(
              dense: true,
              leading: Icon(Icons.help),
              title: Text(
                Statics.getLabel('helpScreenTitle'),
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(HelpScreen.routeName);
              },
            ),

            if (!((Statics.userDetails['LevelName'] == 'Shaakhaa' || Statics.userDetails["LevelName"] == "शाखा") &&
                (Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' || Statics.userDetails["DaayitvaName"] == "कार्यवाह")))
              // if (
              // // (Statics.userDetails["LevelName"] == "Praant" ||
              // //         Statics.userDetails["LevelName"] == "Mahaanagar" ||
              // //         Statics.userDetails["LevelName"] == "Vibhaag" ||
              // //         Statics.userDetails["LevelName"] == "Bhaag" ||
              // //         Statics.userDetails["LevelName"] == "Shahar" ||
              // //         Statics.userDetails['LevelName'] == 'Nagar/Taalukaa'  || Statics.userDetails['LevelName'] == 'Nagar' |||
              // //         Statics.userDetails["LevelName"] == "Graam" ||
              // //         Statics.userDetails["LevelName"] == "Vasti")
              // (Statics.userDetails["LevelName"] == "Praant" ||Statics.userDetails["LevelName"] == "प्रांत" ||
              //     Statics.userDetails["LevelName"] == "Mahaanagar" ||Statics.userDetails["LevelName"] == "महानगर" ||
              //     Statics.userDetails["LevelName"] == "Vibhaag" ||Statics.userDetails["LevelName"] == "विभाग" ||
              //     Statics.userDetails["LevelName"] == "Bhaag" ||Statics.userDetails["LevelName"] == "भाग/जिला" ||Statics.userDetails["LevelName"] == "भाग/जिल्हा" ||
              //     Statics.userDetails["LevelName"] == "Shahar" ||Statics.userDetails["LevelName"] == "शहर" ||
              //     Statics.userDetails['LevelName'] == 'Nagar/Taalukaa'  || Statics.userDetails['LevelName'] == 'Nagar' || Statics.userDetails["LevelName"] == "नगर/तालुका" ||
              //     Statics.userDetails["LevelName"] == "Graam" ||Statics.userDetails["LevelName"] == "ग्राम" ||
              //     Statics.userDetails["LevelName"] == "Vasti" ||Statics.userDetails["LevelName"] == "वस्ती")
              //     &&
              //     // (Statics.userDetails["DaayitvaName"] == "Kaaryaalay Pramukh" ||
              //     //     Statics.userDetails["DaayitvaName"] == "Prachaarak" ||
              //     //     Statics.userDetails["DaayitvaName"] == "Saha-Prachaarak" ||
              //     //     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
              //     //     Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
              //     //     Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
              //     Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
              //     Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
              //     Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
              //     Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
              //     Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
              //     Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||
              //     //     Statics.userDetails["DaayitvaName"] == "Pramukh")
              //     (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
              //         Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
              //         Statics.userDetails["DaayitvaName"] == "Kaaryaalay Pramukh" ||Statics.userDetails["DaayitvaName"] == "कार्यालय प्रमुख" ||
              //         Statics.userDetails["DaayitvaName"] == "Prachaarak" ||Statics.userDetails["DaayitvaName"] == "प्रचारक" ||
              //         Statics.userDetails["DaayitvaName"] == "Saha-Prachaarak" ||Statics.userDetails["DaayitvaName"] == "सह प्रचारक" ||
              //         Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
              //         Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||Statics.userDetails["DaayitvaName"] == "सह कार्यवाह" ||
              //         Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
              //         Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
              //         Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
              //         Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
              //         Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
              //         Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
              //         Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
              //         Statics.userDetails["DaayitvaName"] == "Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रमुख")
              // )
              Divider(),
            // if (
            //     // (Statics.userDetails["LevelName"] == "Praant" ||
            //     //         Statics.userDetails["LevelName"] == "Mahaanagar" ||
            //     //         Statics.userDetails["LevelName"] == "Vibhaag" ||
            //     //         Statics.userDetails["LevelName"] == "Bhaag" ||
            //     //         Statics.userDetails["LevelName"] == "Shahar" ||
            //     //         Statics.userDetails['LevelName'] == 'Nagar/Taalukaa'  || Statics.userDetails['LevelName'] == 'Nagar' |||
            //     //         Statics.userDetails["LevelName"] == "Graam" ||
            //     //         Statics.userDetails["LevelName"] == "Vasti")
            //     (Statics.userDetails["LevelName"] == "Praant" ||
            //                 Statics.userDetails["LevelName"] == "प्रांत" ||
            //                 Statics.userDetails["LevelName"] == "Mahaanagar" ||
            //                 Statics.userDetails["LevelName"] == "महानगर" ||
            //                 Statics.userDetails["LevelName"] == "Vibhaag" ||
            //                 Statics.userDetails["LevelName"] == "विभाग" ||
            //                 Statics.userDetails["LevelName"] == "Bhaag" ||
            //                 Statics.userDetails["LevelName"] == "भाग/जिला" ||
            //                 Statics.userDetails["LevelName"] == "भाग/जिल्हा" ||
            //                 Statics.userDetails["LevelName"] == "Shahar" ||
            //                 Statics.userDetails["LevelName"] == "शहर" ||
            //                 Statics.userDetails['LevelName'] == 'Nagar/Taalukaa' ||
            //                 Statics.userDetails['LevelName'] == 'Nagar' ||
            //                 Statics.userDetails["LevelName"] == "नगर/तालुका" ||
            //                 Statics.userDetails["LevelName"] == "Graam" ||
            //                 Statics.userDetails["LevelName"] == "ग्राम" ||
            //                 Statics.userDetails["LevelName"] == "Vasti" ||
            //                 Statics.userDetails["LevelName"] == "वस्ती") &&
            //             // (Statics.userDetails["DaayitvaName"] == "Kaaryaalay Pramukh" ||
            //             //     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
            //             //     Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
            //             //     Statics.userDetails["DaayitvaName"] == "Prachaarak" ||
            //             //     Statics.userDetails["DaayitvaName"] == "Saha-Prachaarak" ||
            //             //     Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" ||
            //         Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" ||
            //         Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" ||
            //         Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" ||
            //         Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" ||
            //         Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
            //         Statics.userDetails["DaayitvaName"] == "App Sanyojak" ||
            //         //     Statics.userDetails["DaayitvaName"] == "Pramukh")
            //         (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
            //             Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
            //             Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Kaaryaalay Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "कार्यालय प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
            //             Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
            //             Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
            //             Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
            //             Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
            //             Statics.userDetails["DaayitvaName"] == "सह कार्यवाह" ||
            //             Statics.userDetails["DaayitvaName"] == "Prachaarak" ||
            //             Statics.userDetails["DaayitvaName"] == "प्रचारक" ||
            //             Statics.userDetails["DaayitvaName"] == "Saha-Prachaarak" ||
            //             Statics.userDetails["DaayitvaName"] == "सह प्रचारक" ||
            //             Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
            //             Statics.userDetails["DaayitvaName"] == "App Sanyojak" ||
            //             Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
            //             Statics.userDetails["DaayitvaName"] == "Pramukh" ||
            //             Statics.userDetails["DaayitvaName"] == "प्रमुख"))
            //   ListTile(
            //     dense: true,
            //     leading: Icon(Icons.money),
            //     title: Text(
            //       Statics.getLabel('searchRamJanmabhoomiNidhiSankalanVrutta'),
            //       style: TextStyle(fontSize: 18),
            //     ),
            //     onTap: () {
            //       Navigator.of(context).pushReplacementNamed(SearchRamJanmaBhoomiNidhiSankalan.routeName);
            //     },
            //   ),

            // ListTile(
            //   dense: true,
            //   leading: Icon(Icons.home_work),
            //   title: Text(
            //     Statics.getLabel('sankalpaLabel'),
            //     style: TextStyle(fontSize: 18),
            //   ),
            //   onTap: () {
            //     Navigator.of(context)
            //         .pushReplacementNamed(SearchSankalpScreen.routeName);
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

// class AppDrawer extends StatelessWidget {
//   AbhiyanSwayamsevakdata initialData;
//   AppDrawer(this.initialData);
//
//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(Duration.zero,() async {
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       var data = pref.getString("AbhiyanSwayamsevakData");
//       print(data);
//       if (data != null) {
//         initialData = AbhiyanSwayamsevakdata.fromJson(jsonDecode(data));
//         setState(() {});
//       }
//     });
//     return Drawer(
//       child: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             AppBar(
//               title: Text(Statics.getLabel('appDrawerHeader')),
//               automaticallyImplyLeading: false,
//             ),
//             Divider(),
//             ListTile(
//               dense: true,
//               leading: Icon(Icons.home),
//               title: Text(
//                 Statics.getLabel('homeScreenLabel'),
//                 style: TextStyle(fontSize: 18),
//               ),
//               onTap: () {
//                 Navigator.of(context)
//                     .pushReplacementNamed(HomeScreen.routeName);
//               },
//             ),
//
//             if(initialData != null)
//             Divider(),
//             if(initialData != null)
//             ListTile(
//               dense: true,
//               leading: Icon(Icons.api),
//               title: Text(
//                 "${Statics.getLabel('Abhiyaan')}",
//                 style: TextStyle(fontSize: 18),
//               ),
//               onTap: () {
//                 Navigator.of(context)
//                     .pushReplacementNamed(AbhiyanScreen.routeName);
//               },
//             ),
//             Divider(),
//             ListTile(
//               dense: true,
//               leading: Icon(Icons.people),
//               title: Text(
//                 Statics.getLabel('searchSwayamsevakScreenLabel'),
//                 style: TextStyle(fontSize: 18),
//               ),
//               onTap: () {
//                 Navigator.of(context)
//                     .pushReplacementNamed(SwayamSevakSearch.routeName);
//               },
//             ),
//             if (((Statics.userDetails["LevelName"] == "Praant" ||
//                         Statics.userDetails["LevelName"] == "Mahaanagar" ||
//                         Statics.userDetails["LevelName"] == "Vibhaag" ||
//                         Statics.userDetails["LevelName"] == "Bhaag" ||
//                         Statics.userDetails["LevelName"] == "Shahar" ||
//                         Statics.userDetails["LevelName"] == "Nagar") &&
//                     (Statics.userDetails["DaayitvaName"] ==
//                             "Join RSS Sanyojak" ||
//                         Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||
//                         Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
//                         Statics.userDetails["DaayitvaName"] ==
//                             "Saha-Kaaryavaah")) ||
//                 (Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
//                     Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak'))
//               Divider(),
//             if (((Statics.userDetails["LevelName"] == "Praant" ||
//                         Statics.userDetails["LevelName"] == "Mahaanagar" ||
//                         Statics.userDetails["LevelName"] == "Vibhaag" ||
//                         Statics.userDetails["LevelName"] == "Bhaag" ||
//                         Statics.userDetails["LevelName"] == "Shahar" ||
//                         Statics.userDetails["LevelName"] == "Nagar") &&
//                     (Statics.userDetails["DaayitvaName"] ==
//                             "Join RSS Sanyojak" ||
//                         Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||
//                         Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
//                         Statics.userDetails["DaayitvaName"] ==
//                             "Saha-Kaaryavaah")) ||
//                 (Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
//                     Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak'))
//               ListTile(
//                 dense: true,
//                 leading: Icon(Icons.app_registration),
//                 title: Text(
//                   Statics.getLabel('searchJoinRSSScreenLabel'),
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 onTap: () {
//                   Navigator.of(context)
//                       .pushReplacementNamed(SearchJoinRss.routeName);
//                 },
//               ),
//             Divider(),
//             ListTile(
//               dense: true,
//               leading: Icon(FontAwesomeIcons.university),
//               title: Text(
//                 Statics.getLabel('searchShaakhaaScreenLabel'),
//                 style: TextStyle(fontSize: 18),
//               ),
//               onTap: () {
//                 Navigator.of(context)
//                     .pushReplacementNamed(SearchShaakhaaScreen.routeName);
//               },
//             ),
//             // Divider(),
//             // ListTile(
//             //   dense: true,
//             //   leading: Icon(Icons.event),
//             //   title: Text(
//             //     Statics.getLabel('searchEventScreenLabel'),
//             //     style: TextStyle(fontSize: 18),
//             //   ),
//             //   onTap: () {
//             //     Navigator.of(context)
//             //         .pushReplacementNamed(SearchEventScreen.routeName);
//             //   },
//             // ),
//             Divider(),
//             ListTile(
//               dense: true,
//               leading: Icon(Icons.list),
//               title: Text(
//                 Statics.getLabel('searchSoochiScreenLabel'),
//                 style: TextStyle(fontSize: 18),
//               ),
//               onTap: () {
//                 Navigator.of(context)
//                     .pushReplacementNamed(SearchSoochiScreen.routeName);
//               },
//             ),
//             Divider(),
//             ListTile(
//               dense: true,
//               leading: Icon(Icons.event),
//               title: Text(
//                 Statics.getLabel('searchEventsScreenLabel'),
//                 style: TextStyle(fontSize: 18),
//               ),
//               onTap: () {
//                 Navigator.of(context)
//                     .pushReplacementNamed(SearchEvent.routeName);
//               },
//             ),
//             Divider(),
//             ListTile(
//               dense: true,
//               leading: Icon(Icons.calendar_today),
//               title: Text(
//                 Statics.getLabel('EventCalender'),
//                 style: TextStyle(fontSize: 18),
//               ),
//               onTap: () {
//                 Navigator.of(context)
//                     .pushReplacementNamed(EventCalender.routeName);
//               },
//             ),
//             if (Statics.userDetails["LevelName"] == "Praant" ||
//                 Statics.userDetails["LevelName"] == "Vibhaag" ||
//                 Statics.userDetails["LevelName"] == "Bhaag" ||
//                 Statics.userDetails["LevelName"] == "Shahar" ||
//                 Statics.userDetails["LevelName"] == "Nagar")
//               Divider(),
//             if (Statics.userDetails["LevelName"] == "Praant" ||
//                 Statics.userDetails["LevelName"] == "Vibhaag" ||
//                 Statics.userDetails["LevelName"] == "Bhaag" ||
//                 Statics.userDetails["LevelName"] == "Shahar" ||
//                 Statics.userDetails["LevelName"] == "Nagar")
//               ListTile(
//                 dense: true,
//                 leading: Icon(Icons.home_work),
//                 title: Text(
//                   Statics.getLabel('searchSewaVastiScreenLabel'),
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 onTap: () {
//                   Navigator.of(context)
//                       .pushReplacementNamed(SearchSewaVasti.routeName);
//                 },
//               ),
//             Divider(),
//             ListTile(
//               dense: true,
//               leading: Icon(Icons.transfer_within_a_station ),
//               title: Text(
//                 Statics.getLabel('searchSwayamsevakTransferLabel'),
//                 style: TextStyle(fontSize: 18),
//               ),
//               onTap: () {
//                 Navigator.of(context)
//                     .pushReplacementNamed(SearchSwayamsevakTransfer.routeName);
//               },
//             ),
//             if ((Statics.userDetails["LevelName"] == "Praant" ||
//                     Statics.userDetails["LevelName"] == "Mahaanagar" ||
//                     Statics.userDetails["LevelName"] == "Vibhaag" ||
//                     Statics.userDetails["LevelName"] == "Bhaag" ||
//                     Statics.userDetails["LevelName"] == "Shahar" ||
//                     Statics.userDetails['LevelName'] == 'Nagar/Taalukaa'  || Statics.userDetails['LevelName'] == 'Nagar' |||
//                     Statics.userDetails["LevelName"] == "Graam" ||
//                     Statics.userDetails["LevelName"] == "Vasti") &&
//                 (Statics.userDetails["DaayitvaName"] == "Kaaryaalay Pramukh" ||
//                     Statics.userDetails["DaayitvaName"] == "Prachaarak" ||
//                     Statics.userDetails["DaayitvaName"] == "Saha-Prachaarak" ||
//                     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
//                     Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
//                     Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||
//                     Statics.userDetails["DaayitvaName"] == "Pramukh"))
//               Divider(),
//             if ((Statics.userDetails["LevelName"] == "Praant" ||
//                     Statics.userDetails["LevelName"] == "Mahaanagar" ||
//                     Statics.userDetails["LevelName"] == "Vibhaag" ||
//                     Statics.userDetails["LevelName"] == "Bhaag" ||
//                     Statics.userDetails["LevelName"] == "Shahar" ||
//                     Statics.userDetails['LevelName'] == 'Nagar/Taalukaa'  || Statics.userDetails['LevelName'] == 'Nagar' |||
//                     Statics.userDetails["LevelName"] == "Graam" ||
//                     Statics.userDetails["LevelName"] == "Vasti") &&
//                 (Statics.userDetails["DaayitvaName"] == "Kaaryaalay Pramukh" ||
//                     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
//                     Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
//                     Statics.userDetails["DaayitvaName"] == "Prachaarak" ||
//                     Statics.userDetails["DaayitvaName"] == "Saha-Prachaarak" ||
//                     Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||
//                     Statics.userDetails["DaayitvaName"] == "Pramukh"))
//               ListTile(
//                 dense: true,
//                 leading: Icon(Icons.money),
//                 title: Text(
//                   Statics.getLabel('searchRamJanmabhoomiNidhiSankalanVrutta'),
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 onTap: () {
//                   Navigator.of(context).pushReplacementNamed(
//                       SearchRamJanmaBhoomiNidhiSankalan.routeName);
//                 },
//               ),
//             Divider(),
//             ListTile(
//               dense: true,
//               leading: Icon(Icons.help),
//               title: Text(
//                 Statics.getLabel('helpScreenTitle'),
//                 style: TextStyle(fontSize: 18),
//               ),
//               onTap: () {
//                 Navigator.of(context).pushReplacementNamed(
//                     HelpScreen.routeName);
//               },
//             ),
//             // ListTile(
//             //   dense: true,
//             //   leading: Icon(Icons.home_work),
//             //   title: Text(
//             //     Statics.getLabel('sankalpaLabel'),
//             //     style: TextStyle(fontSize: 18),
//             //   ),
//             //   onTap: () {
//             //     Navigator.of(context)
//             //         .pushReplacementNamed(SearchSankalpScreen.routeName);
//             //   },
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class AppAbhiyanDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text(Statics.getLabel('logInBanner')),
              automaticallyImplyLeading: false,
            ),
            Divider(),
            ListTile(
              dense: true,
              leading: Icon(Icons.logout),
              title: Text(
                Statics.getLabel('logOutLabel'),
                style: TextStyle(fontSize: 18),
              ),
              onTap: () async {
                bool isConnected = await Statics.isInternetConnected();
                if (!isConnected) {
                  Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
                } else {
                  await LogIn().logOut();
                  BackgroundFetch.stop().then((int status) {
                    print('[BackgroundFetch] stop success: $status');
                  });
                  Navigator.of(context).pushReplacementNamed('/');
                }
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
