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
import '../helpers/media_downloader/media_downloader_service.dart';
import '../helpers/static_data.dart' as Statics;
import '../models/response_model/AbhiyaanLoginDataResponse.dart';
import '../providers/bals.dart';
import '../providers/swayamsevak_provider.dart';
import '../screens/swayamsevak_module/edit_module/edit_swayamsevak_screen.dart';
import '../utils/hard_loader.dart';

class LogIn {
  Future<int> isAutorized() async {
    List<UserDataBAL> user = await Statics.getUserDataLDB();
    String otpUser = '';
    SharedPreferences pref = await SharedPreferences.getInstance();
    otpUser = pref.getString("otpuser") ?? '';
    print("otpUser ==> $otpUser");

    if (user.isNotEmpty && user.length > 0 && otpUser == "false") {
      late SwayamsevakBAL userBasicInfo;
      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        userBasicInfo = await SwayamsevakProvider().getSwayamSevakByID(user[0].swayamsevakID.toString(), "BasicInfo");
      } else {
        final _data = await DatabaseHelper.getAllOfflineData<SwayamsevakBAL>(
          tableName: 'UserDataMaster',
          fromMap: SwayamsevakBAL.fromJson,
          where: 'SwayamsevakID = ? ',
          whereArgs: [user[0].swayamsevakID.toString()],
        );

        if (_data.isEmpty) {
          return 2;
        }

        userBasicInfo = _data.first;
        userBasicInfo!.canUseApp = true;
      }

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
    return Statics.userDetails['isAuthorized'] == true ? 1 : 0;
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

    log(json.encode({"MobileNumber": mobileNumber, "Password": password, "LastSyncTimeStamp": "", "otplogin": otplogin, "token": token}));

    var response = await http.post(Uri.parse(Statics.urlValidateUser),
        headers: jHeaders, body: json.encode({"MobileNumber": mobileNumber, "Password": password, "LastSyncTimeStamp": "", "otplogin": otplogin, "token": token}));

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
      List<Map<String, dynamic>> levelList = (body['LogInData']['LevelMasterList'] as List).map((item) => item as Map<String, dynamic>).toList();
      if (levelList.length > 0) {
        print("usrLogIn 10");

// 2. Bulk upsert into the table
        final result = await DatabaseHelper.bulkUpsert<Map<String, dynamic>>(
          tableName: 'LevelMaster',
          items: levelList,
          toMap: (item) => item,
          keyColumns: ['LevelID'],
          hasUniqueConstraint: true, // pkid is your PRIMARY KEY
        );
      }
      print("usrLogIn 11");

      List<Map<String, dynamic>> dataList = (body['LogInData']['StaticMasterList'] as List).map((item) => item as Map<String, dynamic>).toList();
      if (dataList.length > 0) {
        print("usrLogIn 12");

// 2. Bulk upsert into the table
        final result = await DatabaseHelper.bulkUpsert<Map<String, dynamic>>(
          tableName: 'StaticMaster',
          items: dataList,
          toMap: (item) => item,
          keyColumns: ['StaticID'],
          hasUniqueConstraint: true, // pkid is your PRIMARY KEY
        );
      }
      dataList = [];

      List<Map<String, dynamic>> abhiyanSwayamsevakData = (body['LogInData']['AbhiyanSwayamsevakData'] as List).map((item) => item as Map<String, dynamic>).toList();
      if (abhiyanSwayamsevakData.length > 0) {
        print("usrLogIn 12.5");

        Statics.abhiyaanUserDetails['AbhiyanSwayamsevakID'] = abhiyanSwayamsevakData.first["AbhiyanSwayamsevakID"];
        Statics.abhiyaanUserDetails['DaayityaName'] = abhiyanSwayamsevakData.first["DaayityaName"];

        final _res = await DatabaseHelper.upsertOne<Map<String, dynamic>>(
          tableName: 'AbhiyanSwayamsevakData',
          item: abhiyanSwayamsevakData.first,
          toMap: (item) => item,
          keyColumns: ['AbhiyaDaayitvaID', 'AbhiyanSwayamsevakID'],
          hasUniqueConstraint: false,
        );
      }

      // var geoUnitData = body['LogInData']['GeoUnitList'];
      // if (geoUnitData.length > 0) {
      List<Map<String, dynamic>> geoUnitData = (body['LogInData']['GeoUnitList'] as List).map((item) => item as Map<String, dynamic>).toList();
      if (geoUnitData.length > 0) {
        print("usrLogIn 13");

// 2. Bulk upsert into the table
        final result = await DatabaseHelper.bulkUpsert<Map<String, dynamic>>(
          tableName: 'GeoUnitMaster',
          items: geoUnitData,
          toMap: (item) => item,
          keyColumns: ['GeoUnitID'],
          hasUniqueConstraint: true, // pkid is your PRIMARY KEY
        );

        // //await dbh.DatabaseHelper.reCreate('GeoUnitMaster', geoUnitData);
        // for (var data in geoUnitData) {
        //   await dbh.DatabaseHelper.insertOrUpdateRecord('GeoUnitMaster', data);
        // }

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

      dataList = (body['LogInData']['StateMasterList'] as List).map((item) => item as Map<String, dynamic>).toList();
      if (dataList.length > 0) {
        print("usrLogIn 14");

// 2. Bulk upsert into the table
        final result = await DatabaseHelper.bulkUpsert<Map<String, dynamic>>(
          tableName: 'StateMaster',
          items: levelList,
          toMap: (item) => item,
          keyColumns: ['StateID'],
          hasUniqueConstraint: true, // pkid is your PRIMARY KEY
        );
      }

      dataList = (body['LogInData']['DaayitvaMasterList'] as List).map((item) => item as Map<String, dynamic>).toList();
      if (dataList.length > 0) {
        print("usrLogIn 15");

// 2. Bulk upsert into the table
        final result = await DatabaseHelper.bulkUpsert<Map<String, dynamic>>(
          tableName: 'DaayitvaMaster',
          items: dataList,
          toMap: (item) => item,
          keyColumns: ['DaayitvaID'],
          hasUniqueConstraint: true, // pkid is your PRIMARY KEY
        );
      }
      dataList = [];

      dataList = (body['LogInData']['AayaamMasterList'] as List).map((item) => item as Map<String, dynamic>).toList();
      if (dataList.length > 0) {
        print("usrLogIn 16");

// 2. Bulk upsert into the table
        final result = await DatabaseHelper.bulkUpsert<Map<String, dynamic>>(
          tableName: 'AayaamMaster',
          items: dataList,
          toMap: (item) => item,
          keyColumns: ['AayaamID'],
          hasUniqueConstraint: true, // pkid is your PRIMARY KEY
        );
      }
      dataList = [];

      var _dataList = body['LogInData']['ddldata'];
      if (_dataList != null) {
        print("usrLogIn 16.5");

        //await dbh.DatabaseHelper.insertOrUpdateRecord('UserDataMaster', userData);
        final _res = await DatabaseHelper.upsertOne<Map<String, dynamic>>(
          tableName: 'DropdownLevelMaster',
          item: _dataList,
          toMap: (item) => item,
          keyColumns: ['GeoUnitID'],
          hasUniqueConstraint: false,
        );
      }

      dataList = (body['LogInData']['GatividhiMasterList'] as List).map((item) => item as Map<String, dynamic>).toList();
      if (dataList.length > 0) {
        print("usrLogIn 17");

// 2. Bulk upsert into the table
        final result = await DatabaseHelper.bulkUpsert<Map<String, dynamic>>(
          tableName: 'GatividhiMaster',
          items: dataList,
          toMap: (item) => item,
          keyColumns: ['GatividhiID'],
          hasUniqueConstraint: true, // pkid is your PRIMARY KEY
        );
      }

      dataList = [];

      dataList = (body['LogInData']['offlineconfiglist'] as List).map((item) => item as Map<String, dynamic>).toList();
      if (dataList.length > 0) {
        print("usrLogIn 17.1");

        //await dbh.DatabaseHelper.insertOrUpdateRecord('UserDataMaster', userData);
        final result = await DatabaseHelper.bulkUpsert<Map<String, dynamic>>(
          tableName: 'OfflineConfigList',
          items: dataList,
          toMap: (item) => item,
          keyColumns: ['apiname'],
          hasUniqueConstraint: true, // pkid is your PRIMARY KEY
        );
      }

      List<Map<String, dynamic>> dataList3 = (body['LogInData']['list'] as List).map((item) => item as Map<String, dynamic>).toList();
      if (dataList3.length > 0) {
        debugPrint("usrLogIn 17.2");

        // 1. Parse raw JSON into model instances

// 2. Bulk upsert into the table
        final result = await DatabaseHelper.bulkUpsert<Map<String, dynamic>>(
          tableName: 'OfflineShaakhaPustika',
          items: dataList3,
          toMap: (item) => item,
          keyColumns: ['pkid'],
          hasUniqueConstraint: true, // pkid is your PRIMARY KEY
        );
      }

      List<Map<String, dynamic>> dataList4 = (body['LogInData']['vistarlist'] as List).map((item) => item as Map<String, dynamic>).toList();
      if (dataList4.length > 0) {
        print("usrLogIn 17.3");
        print("dataList4.length >>>  ${dataList4.length}");

// 2. Bulk upsert into the table
        final result = await DatabaseHelper.bulkUpsert<Map<String, dynamic>>(
          tableName: 'VistarShaakhaListMaster',
          items: dataList4,
          toMap: (item) => item,
          keyColumns: ['ShaakhaaID', 'GeoUnitID'],
          hasUniqueConstraint: false, // pkid is your PRIMARY KEY
        );
      }

      List<Map<String, dynamic>> dataList5 = (body['LogInData']['shaakhalist'] as List).map((item) => item as Map<String, dynamic>).toList();
      if (dataList5.length > 0) {
        print("usrLogIn 17.4");

// 2. Bulk upsert into the table
        final result = await DatabaseHelper.bulkUpsert<Map<String, dynamic>>(
          tableName: 'ShaakhaListMaster',
          items: dataList5,
          toMap: (item) => item,
          keyColumns: ['ShaakhaaID'],
          hasUniqueConstraint: false, // pkid is your PRIMARY KEY
        );
      }

      List<Map<String, dynamic>> dataList6 = (body['LogInData']['vistarvruttalist'] as List).map((item) => item as Map<String, dynamic>).toList();
      if (dataList6.length > 0) {
        print("usrLogIn 17.5");

// 2. Bulk upsert into the table
        final result = await DatabaseHelper.bulkUpsert<Map<String, dynamic>>(
          tableName: 'VistarShaakhaVruttaMaster',
          items: dataList6,
          toMap: (item) => item,
          keyColumns: ['pkid'],
          hasUniqueConstraint: true, // pkid is your PRIMARY KEY
        );
      }

      List<Map<String, dynamic>> dataList7 = (body['LogInData']['shaakhavruttalist'] as List).map((item) => item as Map<String, dynamic>).toList();
      if (dataList7.length > 0) {
        print("usrLogIn 17.6");

// 2. Bulk upsert into the table
        final result = await DatabaseHelper.bulkUpsert<Map<String, dynamic>>(
          tableName: 'ShaakhaVruttaMaster',
          items: dataList7,
          toMap: (item) => item,
          keyColumns: ['pkid'],
          hasUniqueConstraint: true, // pkid is your PRIMARY KEY
        );
      }

      List<Map<String, dynamic>> dataList8 = (body['LogInData']['Data'] as List).map((item) => item as Map<String, dynamic>).toList();
      if (dataList8.length > 0) {
        print("usrLogIn 17.7");

// 2. Bulk upsert into the table
        final result = await DatabaseHelper.bulkUpsert<Map<String, dynamic>>(
          tableName: 'SewaSanskarData',
          items: dataList8,
          toMap: (item) => item,
          keyColumns: ['StaticID'],
          hasUniqueConstraint: false, // pkid is your PRIMARY KEY
        );
      }

      List<Map<String, dynamic>> dataList9 = (body['LogInData']['mediaList'] as List).map((item) => item as Map<String, dynamic>).toList();
      if (dataList9.length > 0) {
        print("usrLogIn 17.8");

        await MediaDownloadService.instance.enqueueFromApiMediaList(dataList9);
      }
      Map<String, dynamic> userData = body['LogInData']['UserData'];
      print("swayamsevak Id - " + userData['SwayamsevakID'].toString());
      await pref.setString("DaayitvaNameforshow", "${body['LogInData']['UserData']['DaayitvaNameforshow']}");
      if (userData['SwayamsevakID'].toString() != "0") {
        print("usrLogIn 18");
        print("Saving to Db");

        final _udata = UserDataBAL.fromMap(userData);
        //await dbh.DatabaseHelper.insertOrUpdateRecord('UserDataMaster', userData);
        final _res = await DatabaseHelper.upsertOne<UserDataBAL>(
          tableName: 'UserDataMaster',
          item: _udata,
          toMap: (item) => _udata.toJson(),
          keyColumns: ['SwayamsevakID'],
          hasUniqueConstraint: false,
        );
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
      await Statics.deleteUserToken();
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
      if (Platform.isIOS) await DatabaseHelper.forcePurgeDatabase();

      print("logOut Done");
      // Clear mobile cache
      // Safely clear directories by iterating through contents
      final cacheDir = await getTemporaryDirectory();
      await _clearDirectoryContents(cacheDir);

      final appDir = await getApplicationSupportDirectory();
      await _clearDirectoryContents(appDir);

      Statics.levelId = 0;
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

  /// Helper function to safely delete contents without deleting the root folder
  Future<void> _clearDirectoryContents(Directory dir) async {
    if (dir.existsSync()) {
      try {
        final List<FileSystemEntity> items = dir.listSync();
        for (final FileSystemEntity item in items) {
          // Delete each file/sub-directory individually
          item.deleteSync(recursive: true);
        }
      } catch (e) {
        print("Failed to clear directory ${dir.path}: $e");
      }
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
    if (await Statics.checkForTableExists("OfflineConfigList")) await dbh.DatabaseHelper.executeQuery('DELETE FROM OfflineConfigList');
    if (await Statics.checkForTableExists("OfflineShaakhaPustika")) await dbh.DatabaseHelper.executeQuery('DELETE FROM OfflineConfigList');
    if (await Statics.checkForTableExists("ShaakhaListMaster")) await dbh.DatabaseHelper.executeQuery('DELETE FROM OfflineConfigList');
    if (await Statics.checkForTableExists("VistarShaakhaListMaster")) await dbh.DatabaseHelper.executeQuery('DELETE FROM OfflineConfigList');
    if (await Statics.checkForTableExists("ShaakhaVruttaMaster")) await dbh.DatabaseHelper.executeQuery('DELETE FROM OfflineConfigList');
    if (await Statics.checkForTableExists("VistarShaakhaVruttaMaster")) await dbh.DatabaseHelper.executeQuery('DELETE FROM OfflineConfigList');
    if (await Statics.checkForTableExists("MediaMaster")) await dbh.DatabaseHelper.executeQuery('DELETE FROM OfflineConfigList');
    if (await Statics.checkForTableExists("MediaDownloadQueue")) await dbh.DatabaseHelper.executeQuery('DELETE FROM OfflineConfigList');
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
