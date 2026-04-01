import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/waterdrop_header.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';
import 'package:niyojak_prod/helpers/database_helper.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanLoginDataResponse.dart';
import 'package:package_info_plus/package_info_plus.dart';

// import 'package:package_info/package_info.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/static_data.dart' as Statics;
import '../providers/login.dart';
import '../screens/change_password.dart';
import 'home_screen/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/update_version.dart';
import 'AbhiyanScreen.dart';
import 'shatabdi_vrutta_sankalan/gruh_sampark_abhiyaan/gruh_abhiyaan_main_tab_screen.dart';
import 'swayamsevak_module/edit_module/edit_swayamsevak_screen.dart';

class SplashScreenCheck extends StatefulWidget {
  static const routeName = '/splash-screen';

  @override
  _SplashScreenCheckState createState() => _SplashScreenCheckState();
}

class _SplashScreenCheckState extends State<SplashScreenCheck> {
  var isCompatible;
  var isAuthorized;
  var isInternetAvl;
  var isDataSyncRequired;
  RefreshController _refreshController = RefreshController(initialRefresh: true);
  AbhiyanSwayamsevakdata? initialData;

  @override
  void initState() {
    super.initState();
    _setDefaultLanguage();
  }

  void _setDefaultLanguage() async {
    print("_setDefaultLanguage");
    SharedPreferences pref = await SharedPreferences.getInstance();
    var languagePreference = pref.getString("languagePreference");
    if (languagePreference == null) {
      await pref.setString("languagePreference", "Marathi");
      Statics.userDetails['languagePreference'] = 'Marathi';
      await _updateDatabaseLanguagePreference();
    }
  }

  Future<void> _updateDatabaseLanguagePreference() async {
    Database db = await DatabaseHelper.database;
    String sqlStr = 'UPDATE UserDataMaster SET PreferredLanguageID=6;';
    String sqlStr1 = 'UPDATE UserDataMaster SET PreferredLanguageCode=\'Marathi\';';
    await db.execute(sqlStr);
    await db.execute(sqlStr1);
  }

  void switchScreens(contx) async {
    await Future.delayed(Duration(seconds: 2));
    PackageInfo info = await PackageInfo.fromPlatform();
    Statics.packageInfo['versionNumber'] = info.version;
    print("App version >> " + info.version);
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("appVer", Statics.packageInfo['versionNumber']);
    var data = pref.getString("AbhiyanSwayamsevakData");
    var loggedIn = pref.getString("loggedIn");
    var otpuser = pref.getString("otpuser");

    if (data != null) {
      initialData = AbhiyanSwayamsevakdata.fromJson(jsonDecode(data));
    }
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(contx, Statics.getLabel('internetNotConnected'));
      setState(() {
        isInternetAvl = false;
      });
      _refreshController.refreshCompleted();
      return;
    }
    await isAuthorizedUser();
    print("user id >> " + Statics.userDetails['userID']);
    // if (Statics.userDetails['userID'].toString().isNotEmpty) {
    await checkVersion();
    // }
    var landingPage;
    if (isCompatible == false) {
      landingPage = UpdateVersion();
    } else {
      // if (Statics.userDetails['isAuthorized']) {
      if (loggedIn != null) {
        await Statics.populateUserDetailsMap();
        await Statics.populateUserAbhiyaanDetailsMap();
        // check if data is in sync
        if (isDataSyncRequired == true) {
          landingPage = LogInScreen();
        } else if (Statics.userDetails['isFirstLogin']) {
          landingPage = ChangePassword();
        } else if (Statics.userDetails['userID'].toString().isEmpty && initialData != null) {
          Database db = await DatabaseHelper.database;
          String sqlStr = 'UPDATE UserDataMaster SET PreferredLanguageID=6;';
          String sqlStr1 = 'UPDATE UserDataMaster SET PreferredLanguageCode=\'Marathi\';';
          await db.execute(sqlStr);
          await db.execute(sqlStr1);
          Statics.userDetails['languagePreference'] = 'Marathi';
          if (otpuser != null && otpuser == "true") {
            landingPage = EditSwayamsevakScreen();
          } else {
            landingPage = AbhiyanScreen();
          }
        } else {
          if (otpuser != null && otpuser == "true") {
            landingPage = EditSwayamsevakScreen();
          } else {
            print("test ?????????????????????????????????????????????????");
            print(Statics.userDetails['LevelID']);
            print(Statics.userDetails['LevelID'] == null);
            // print(Statics.userDetails['LevelID'].toString().isEmpty);
            // print((Statics.userDetails['LevelID'] == null || Statics.userDetails['LevelID'].toString().isEmpty));
            if (Statics.userDetails['LevelID'] == null || Statics.userDetails['LevelID'] == "null") {
              landingPage = GruhAbhiyaanMainTabScreen();
            } else {
              landingPage = HomeScreen();
            }
          }
        }
      } else {
        print(Statics.userDetails['isAuthorized']);
        landingPage = LogInScreen();
      }
    }
    _refreshController.refreshCompleted();
    if (landingPage.toString() == "EditSwayamsevakScreen") {
      if (Statics.userDetails['userID'] != null) {
        Navigator.of(contx).pushReplacementNamed(EditSwayamsevakScreen.routeName, arguments: Statics.ScreenArgumentsNew(int.parse(Statics.userDetails['userID']), Statics.getLabel('EditMenu')));
      }
    } else {
      Navigator.of(contx).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => landingPage));
    }
  }

  Future<void> isAuthorizedUser() async {
    var data = await LogIn().isAutorized();
    if (!mounted) return;
    setState(() {
      Statics.userDetails["isAuthorized"] = data;
    });
  }

  Future<void> checkVersion() async {
    //PackageInfo info = await PackageInfo.fromPlatform();
    //String version = info.version;
    //String buildNumber = info.buildNumber;
    var inputData = json.encode({
      "AppUserID": (Statics.userDetails['userID'] == '' ? null : Statics.userDetails['userID']),
      "ClientAppVersionNumber": Statics.packageInfo['versionNumber'],
      "devicetype": Platform.isAndroid ? 1 : 0,
    });
    print({
      "AppUserID": (Statics.userDetails['userID'] == '' ? null : Statics.userDetails['userID']),
      "ClientAppVersionNumber": Statics.packageInfo['versionNumber'],
      "devicetype": Platform.isAndroid ? 1 : 0,
    });
    //Statics.userDetails["isUpdatedVersion"] = await Statics.isCompatibleVersion(inputData);
    var resBody = await Statics.isCompatibleVersion(inputData);
    print(jsonEncode(resBody));
    Statics.userDetails['isUpdatedVersion'] = resBody['IsVersionCompatible'];
    if (!mounted) return;
    setState(() {
      //isCompatible = Statics.userDetails["isUpdatedVersion"];
      isCompatible = resBody['IsVersionCompatible'];
      isDataSyncRequired = resBody['IsDataSyncRequired'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SmartRefresher(
        controller: _refreshController,
        header: WaterDropHeader(),
        onRefresh: () {
          switchScreens(context);
        },
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 100, 10, 50),
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/images/loader1.gif'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 60.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepOrange.shade900,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      Statics.getLabel('logInBanner'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontFamily: 'Anton',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    Statics.getLabel('versionLabel') + ' - ${Statics.packageInfo['versionNumber']}${Statics.patchSuffix}',
                    style: TextStyle(fontSize: 24),
                  ),
                  if (isInternetAvl != null)
                    if (!isInternetAvl)
                      Text(
                        'Pull down to Refresh',
                        style: TextStyle(fontSize: 18),
                      ),
                  SizedBox(
                    height: 50,
                  ),
                  if (Statics.isDevelopment)
                    Text(
                      "Development Pointed APK",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
