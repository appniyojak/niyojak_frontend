import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:niyojak_prod/helpers/database_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/database_helper.dart' as dbh;
import '../helpers/static_data.dart' as Statics;
import '../models/response_model/AbhiyaanLoginDataResponse.dart';
import '../providers/bals.dart';
import '../providers/swayamsevak_provider.dart';
import '../screens/swayamsevak_module/edit_module/edit_swayamsevak_screen.dart';
import '../utils/hard_loader.dart';

class LogIn {
  Future<bool> isAutorized() async {
    List<UserDataBAL> user = await Statics.getUserDataLDB();
    String otpUser = '';
    SharedPreferences pref = await SharedPreferences.getInstance();
    otpUser = pref.getString("otpuser") ?? '';
    print("otpUser ==> $otpUser");

    if (user.isNotEmpty && user.length > 0 && otpUser == "false") {
      SwayamsevakBAL userBasicInfo = await SwayamsevakProvider().getSwayamSevakByID(user[0].swayamsevakID.toString(), "BasicInfo");

      await Statics.populateUserDetailsMap();
      await Statics.populateUserAbhiyaanDetailsMap();
      await Statics.populateDashboardDetailsMap();
      print("================");
      print(user[0].isLoggedIn);
      print(userBasicInfo.canUseApp);
      print("================");
      Statics.userDetails['isAuthorized'] = ((user[0].isLoggedIn == 'true' && userBasicInfo.canUseApp == true) ? true : false);
      Statics.userDetails['isLoggedIn'] = user[0].isLoggedIn;
      Statics.userDetails['LastLoginTimeStamp'] = user[0].lastLoginTimeStamp;
    } else {
      Statics.userDetails['isAuthorized'] = false;
      Statics.userDetails['isLoggedIn'] = 'false';
      Statics.userDetails['LastLoginTimeStamp'] = '';
    }
    return Statics.userDetails['isAuthorized'];
  }

  // checkLoginDate() async {
  //   try {
  //     Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  //     // var response = await http.get(Uri.parse(Statics.urlCheckLoginDate),
  //     //     headers: jHeaders);
  //     var response = await http.post(Uri.parse(Statics.urlCheckLoginDate), headers: jHeaders, body: json.encode({"swayamsevakid": Statics.userDetails["userID"]}));
  //     print(response.request!.url);
  //     print(response.body);
  //     var body = json.decode(response.body);
  //     DateTime? newDate = DateTime.tryParse(body['ForceLogout']) ?? null;
  //     print("newDate --> $newDate");
  //     if (newDate != null) {
  //       SharedPreferences pref = await SharedPreferences.getInstance();
  //       await pref.setString("loginDate", body['ForceLogout'].toString());
  //     }
  //     return body['ForceLogout'].toString();
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  Future<void> usrLogIn(BuildContext ctx, String mobileNumber, String? password, String otplogin) async {
    await DatabaseHelper.dropCompleteDB();
    Database _db = await DatabaseHelper.database;

    print(otplogin);
    print("usrLogIn 1");
    String lastLoginTimeStamp = Statics.userDetails['LastLoginTimeStamp'];
    if (Statics.userDetails['MobileNumber'] != mobileNumber) {
      print("usrLogIn 2");

      lastLoginTimeStamp = '';
      // await clearData();
    }
    if (lastLoginTimeStamp.isEmpty) {
      print("usrLogIn 3");

      lastLoginTimeStamp = '20-Jul-2020';
    }

    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    print(Uri.parse(Statics.urlValidateUser));
    String? token;
    if (Platform.isAndroid) {
      print("usrLogIn 4");

      token = await messaging.getToken();
    } else if (Platform.isIOS) {
      token = await messaging.getAPNSToken();
    }

    if (token != null) {
      print("usrLogIn 5 ");

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("deviceToken", token);
      print("Device Token (${Platform.operatingSystem}): $token");
    } else {
      print("Failed to retrieve device token");
    }

    log(json.encode({"MobileNumber": mobileNumber, "Password": password, "LastSyncTimeStamp": lastLoginTimeStamp, "otplogin": otplogin, "token": token}));

    var response = await http.post(Uri.parse(Statics.urlValidateUser),
        headers: jHeaders, body: json.encode({"MobileNumber": mobileNumber, "Password": password, "LastSyncTimeStamp": lastLoginTimeStamp, "otplogin": otplogin, "token": token}));

    // log(response.body);
    print("usrLogIn 6");

    var body = json.decode(response.body);

    if (body != null) {
      // try {
      var abhiyaanDataList = body['LogInData']['AbhiyanSwayamsevakData'];
      // print(jsonEncode(abhiyaanDataList));
      print(Statics.userDetails);
      print("usrLogIn 7");

      print("redirection not Done");

      // await checkLoginDate();
      if (abhiyaanDataList != null && abhiyaanDataList.isNotEmpty) {
        print("usrLogIn 8");

        AbhiyanSwayamsevakResponse response = AbhiyanSwayamsevakResponse(abhiyanSwayamsevakData: [AbhiyanSwayamsevakdata.fromJson(jsonDecode(jsonEncode(abhiyaanDataList[0])))]);
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("loggedIn", "true");
        print("setString(loggedIn, true); Sucess");
        await pref.setString("AbhiyanSwayamsevakData", jsonEncode(response.abhiyanSwayamsevakData!.first).toString());
      }
      print("usrLogIn 9");

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("loggedIn", "true");
      var levelList = body['LogInData']['LevelMasterList'];
      if (levelList.length > 0) {
        print("usrLogIn 10");

        await dbh.DatabaseHelper.reCreate('LevelMaster', levelList);
        // for (var data in levelList) {
        //   await dbh.DatabaseHelper.insertOrUpdateRecord('LevelMaster', data);
        // }
      }
      print("usrLogIn 11");

      var dataList = body['LogInData']['StaticMasterList'];
      if (dataList.length > 0) {
        print("usrLogIn 12");

        await dbh.DatabaseHelper.reCreate('StaticMaster', dataList);
        // for (var data in dataList) {
        //   await dbh.DatabaseHelper.insertOrUpdateRecord('StaticMaster', data);
        // }
      }

      var abhiyanSwayamsevakData = body['LogInData']['AbhiyanSwayamsevakData'];
      if (abhiyanSwayamsevakData.length > 0) {
        print("usrLogIn 12.5");

        Statics.abhiyaanUserDetails['AbhiyanSwayamsevakID'] = abhiyanSwayamsevakData.first["AbhiyanSwayamsevakID"];
        Statics.abhiyaanUserDetails['DaayityaName'] = abhiyanSwayamsevakData.first["DaayityaName"];

        await dbh.DatabaseHelper.insertOrUpdateRecord('AbhiyanSwayamsevakData', abhiyanSwayamsevakData.first);
        // for (var data in abhiyanSwayamsevakData) {
        //   await dbh.DatabaseHelper.insertOrUpdateRecord('AbhiyanSwayamsevakData', data);
        // }
      }

      var geoUnitData = body['LogInData']['GeoUnitList'];
      if (geoUnitData.length > 0) {
        print("usrLogIn 13");

        //await dbh.DatabaseHelper.reCreate('GeoUnitMaster', geoUnitData);
        for (var data in geoUnitData) {
          await dbh.DatabaseHelper.insertOrUpdateRecord('GeoUnitMaster', data);
        }

        print("usrLogIn 13.5");
        await _db.transaction((txn) async {
          await txn.execute('''
          INSERT INTO AbhiyaanGeoUnitMaster (GeoUnitID , PraantID , GeoUnitName ,NameForDisplay ,LevelID , DisplaySequence , 
                              HasGraaminKshetra , ParentKshetraID , ParentPraantID , ParentMahaanagarID , 
                              ParentVibhaagID , ParentBhaagID , ParentNagarID , ParentShaharID , 
                              ParentMandalID , ParentVastiID , ParentGraamID, isAbhiyaan)
        Select GeoUnitID , PraantID , GeoUnitName ,NameForDisplay , LevelID , DisplaySequence , 
                    HasGraaminKshetra , ParentKshetraID , ParentPraantID , ParentMahaanagarID , 
                    ParentVibhaagID , ParentBhaagID , ParentNagarID , ParentShaharID , 
                    ParentMandalID , ParentVastiID , ParentGraamID, 0
        from GeoUnitMaster
        ''');
        });
      }

      // var abhiyaanGeoUnitMaster = body['LogInData']['GeoUnitListforAbhiyaan'];
      // if (abhiyaanGeoUnitMaster.length > 0) {
      //   print("usrLogIn 13.5");
      //
      //   //await dbh.DatabaseHelper.reCreate('GeoUnitMaster', geoUnitData);
      //   for (var data in abhiyaanGeoUnitMaster) {
      //     await dbh.DatabaseHelper.insertOrUpdateRecord('AbhiyaanGeoUnitMaster', data);
      //   }
      // }

      dataList = body['LogInData']['StateMasterList'];
      if (dataList.length > 0) {
        print("usrLogIn 14");

        await dbh.DatabaseHelper.reCreate('StateMaster', dataList);
        // for (var data in dataList) {
        //   await dbh.DatabaseHelper.insertOrUpdateRecord('StateMaster', data);
        // }
      }

      dataList = body['LogInData']['DaayitvaMasterList'];
      if (dataList.length > 0) {
        print("usrLogIn 15");

        await dbh.DatabaseHelper.reCreate('DaayitvaMaster', dataList);
        // for (var data in dataList) {
        //   await dbh.DatabaseHelper.insertOrUpdateRecord('DaayitvaMaster', data);
        // }
      }

      dataList = body['LogInData']['AayaamMasterList'];
      if (dataList.length > 0) {
        print("usrLogIn 16");

        await dbh.DatabaseHelper.reCreate('AayaamMaster', dataList);
        // for (var data in dataList) {
        //   await dbh.DatabaseHelper.insertOrUpdateRecord('AayaamMaster', data);
        // }
      }

      dataList = body['LogInData']['ddldata'];
      if (dataList != null) {
        print("usrLogIn 16.5");

        await dbh.DatabaseHelper.reCreate('DaayitwaLevelMaster', dataList);
      }

      dataList = body['LogInData']['GatividhiMasterList'];
      if (dataList.length > 0) {
        print("usrLogIn 17");

        await dbh.DatabaseHelper.reCreate('GatividhiMaster', dataList);
        // for (var data in dataList) {
        //   await dbh.DatabaseHelper.insertOrUpdateRecord(
        //       'GatividhiMaster', data);
        // }
      }
      var userData = body['LogInData']['UserData'];
      print("swayamsevak Id - " + userData['SwayamsevakID'].toString());
      await pref.setString("DaayitvaNameforshow", "${body['LogInData']['UserData']['DaayitvaNameforshow']}");
      if (userData['SwayamsevakID'].toString() != "0") {
        print("usrLogIn 18");
        print("Saving to Db");
        //await dbh.DatabaseHelper.insertOrUpdateRecord('UserDataMaster', userData);
        await dbh.DatabaseHelper.reCreate('UserDataMaster', userData);
        await Statics.populateUserDetailsMap();
        await Statics.populateUserAbhiyaanDetailsMap();
        await Statics.refreshDashboardData(Statics.userDetails["userID"], null);
        await Statics.getNotificationDataList(Statics.userDetails["userID"]);
        await Statics.populateDashboardDetailsMap();
      }
      Statics.userDetails['isAuthorized'] = true;
      print("API END");
      print(Statics.userDetails);
      if (body['LogInData']['UserData']['otpuser'] == true) {
        print("redirection Done");
        print("usrLogIn 19");
        if (body['LogInData']['UserData']['can_edit'] == true) {
          print("usrLogIn 20");
          print("usrLogIn ${userData['SwayamsevakID']} --  ${Statics.getLabel('EditMenu')}");
          Navigator.of(ctx)
              .pushReplacementNamed(EditSwayamsevakScreen.routeName, arguments: Statics.ScreenArgumentsNew(userData['SwayamsevakID'], Statics.getLabel('EditMenu'), email: "", mobile: "", name: ""));
          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString("otpuser", "true");
          await pref.setString("can_edit", body['LogInData']['UserData']['can_edit'].toString());
        } else {
          print("usrLogIn 21");
          LoaderUtils.toggleLoader(ctx, false);
          Statics.showErrorDialog(ctx, Statics.getLabel('connetKaryavah'));
        }
        print("usrLogIn 22");
      }
      if (body['LogInData']['UserData']['otpuser'] == false) {
        print("usrLogIn 23");
        await pref.setString("otpuser", "false");
      }
      print("usrLogIn 24");
      // } catch (e){
      //   print(e);
      // }
    } else {
      print("usrLogIn 25");
      print("Failed");
      Statics.userDetails['isAuthorized'] = false;
      await clearData();
    }
  }

  // Future<void> logOut() async {
  //   print("logOut running");
  //   Statics.userDetails['isAuthorized'] = false;
  //   Statics.userDetails['isLoggedIn'] = 'false';
  //   Statics.userDetails['userID'] = '0';
  //   Database db = await DatabaseHelper.database;
  //   String sqlStr1 = 'UPDATE UserDataMaster SET PreferredLanguageCode=\'Marathi\';';
  //   await db.execute(sqlStr1);
  //   Statics.userDetails['languagePreference'] = 'Marathi';
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   await pref.clear();
  //   await pref.reload();
  //   await dbh.DatabaseHelper.logoutUser();
  //   await clearData();
  //   print("logOut Done");
  // }
  Future<void> logOut({bool isUpdate = false}) async {
    try {
      print("logOut running");

      // Update user details
      Statics.userDetails['isAuthorized'] = false;
      Statics.userDetails['isLoggedIn'] = 'false';
      Statics.userDetails['userID'] = '0';

      // Update database
      Database db = await DatabaseHelper.database;
      // String sqlStr1 = 'UPDATE UserDataMaster SET PreferredLanguageCode=\'Marathi\';';
      // await db.execute(sqlStr1);
      // print("Database updated with PreferredLanguageCode");

      Statics.userDetails['languagePreference'] = 'Marathi';

      // Clear SharedPreferences
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.clear();
      print("SharedPreferences cleared");
      await pref.reload();
      print("SharedPreferences reloaded");

      // Call logoutUser function
      // await DatabaseHelper.logoutUser();
      // print("DatabaseHelper logoutUser called");

      // Clear other data if necessary
      // await clearData();
      // print("clearData called");

      await DatabaseHelper.dropCompleteDB();

      print("logOut Done");
      // Clear mobile cache
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
      }
      // Clear mobile app storage
      final appDir = await getApplicationSupportDirectory();
      if (appDir.existsSync()) {
        appDir.deleteSync(recursive: true);
      }
      Statics.userDetails = {
        'userID': '',
        'MobileNumber': '',
        'languagePreference': 'Marathi',
        'isAuthorized': false,
        'isFirstLogin': false,
        'DaayitvaGeoUnitID': '',
        'DaayitvaGeoUnitName': '',
        'DaayitvaName': '',
        'LevelID': '',
        'LevelName': '',
        //'LevelNameForDisplay': '',
        'FullName': '',
        'isUpdatedVersion': false,
        'LinkedVastiID': '',
        'LinkedVastiName': '',
        'LinkedGraamID': '',
        'LinkedGraamName': '',
        'LinkedShaakhaaID': '',
        'LinkedShaakhaaName': '',
        'LinkedGeoUnitHierarchy': '',
        'LastLoginTimeStamp': '',
        'isLoggedIn': 'false',
        'IsPravaasiKaaryakartaa': false,
        'can_edit': '',
        'DaayitvaNameforshow': '',
        'DaayitvaId': '',
      };
      await pref.setBool("isRead", isUpdate ? false : true);
      // await pref.setString("appVer", Statics.packageInfo['versionNumber']);
    } catch (e) {
      print("Error during logOut: $e");
    }
  }

  Future<void> clearData() async {
    if (await Statics.checkForTableExists("LevelMaster")) await dbh.DatabaseHelper.executeQuery('DELETE FROM LevelMaster');
    if (await Statics.checkForTableExists("SwayamsevakMaster")) await dbh.DatabaseHelper.executeQuery('DELETE FROM SwayamsevakMaster');
    if (await Statics.checkForTableExists("GeoUnitMaster")) await dbh.DatabaseHelper.executeQuery('DELETE FROM GeoUnitMaster');
    if (await Statics.checkForTableExists("StaticMaster")) await dbh.DatabaseHelper.executeQuery('DELETE FROM StaticMaster');
    if (await Statics.checkForTableExists("DaayitvaMaster")) await dbh.DatabaseHelper.executeQuery('DELETE FROM DaayitvaMaster');
    if (await Statics.checkForTableExists("StateMaster")) await dbh.DatabaseHelper.executeQuery('DELETE FROM StateMaster');
    if (await Statics.checkForTableExists("GatividhiMaster")) await dbh.DatabaseHelper.executeQuery('DELETE FROM GatividhiMaster');
    if (await Statics.checkForTableExists("AayaamMaster")) await dbh.DatabaseHelper.executeQuery('DELETE FROM AayaamMaster');
    if (await Statics.checkForTableExists("UserDataMaster")) await dbh.DatabaseHelper.executeQuery('DELETE FROM UserDataMaster');
    if (await Statics.checkForTableExists("HomeScreenData")) await dbh.DatabaseHelper.executeQuery('DELETE FROM HomeScreenData');
    // if (await Statics.checkForTableExists("AbhiyaanVrutta"))
    //   await dbh.DatabaseHelper.executeQuery('DELETE FROM AbhiyaanVrutta');
    // if (await Statics.checkForTableExists("VisheshVyaktiMaster"))
    //   await dbh.DatabaseHelper.executeQuery('DELETE FROM VisheshVyaktiMaster');
    // /*if (await Statics.checkForTableExists("AbhiyaanParticipantCount"))
    //   await dbh.DatabaseHelper.executeQuery(
    //       'DELETE FROM AbhiyaanParticipantCount');*/
    // if (await Statics.checkForTableExists("AbhiyaanParticipant"))
    //   await dbh.DatabaseHelper.executeQuery('DELETE FROM AbhiyaanParticipant');
    // if (await Statics.checkForTableExists("AbhiyaanAttendance"))
    //   await dbh.DatabaseHelper.executeQuery('DELETE FROM AbhiyaanAttendance');
  }
}
