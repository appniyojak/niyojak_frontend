import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import './static_data.dart' as Statics;

class DatabaseHelper {
  static final _dbName = 'NiyojakProd.db';
  static final _dbVersion = int.parse(Statics.dbVersion);

  static Database? _database;

  static Future<Database> get database async {
    if (_database == null) {
      print("database null");
      _database = await initDatabase();
    } else {
      // print("database not null");
    }
    return _database!;
  }

  static Future<Database> initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    var dataDir = "";
    if (Platform.isIOS) {
      var p = await getLibraryDirectory();
      dataDir = p.path;
    } else {
      dataDir = await getDatabasesPath();
    }
    print(dataDir);
    var dbPath = dataDir + '/' + _dbName;
    var database = await openDatabase(dbPath, version: _dbVersion, singleInstance: false, onUpgrade: (db, oldVersion, newVersion) {
      print('initDatabase - database upgraded, oldVersion:' + oldVersion.toString() + '; newVersion:' + newVersion.toString());
      // db.execute('DROP TABLE UserDataMaster');
      // db.execute('DROP TABLE IF EXISTS AbhiyaanVrutta');
      // db.execute('DROP TABLE IF EXISTS AbhiyaanParticipant');
      // db.execute('DROP TABLE IF EXISTS AbhiyaanAttendance');
      // db.execute('DROP TABLE IF EXISTS VisheshVyaktiMaster');
      // db.execute('DROP TABLE IF EXISTS TempDates');
      //
      // db.execute('DROP TABLE IF EXISTS HomeScreenData');
      db.execute('CREATE TABLE IF NOT EXISTS HomeScreenData(ShishuCount INT, BaalCount INT, TarunVidyaarthiCount INT,' +
          ' TarunVyavasayeeCount INT, ProudhaVyavasayeeCount INT, UnknownAgeCount INT, TrutiyaVarshaShikshitCount INT,' +
          ' DwitiyaVarshaShikshitCount INT, PrathamVarshaShikshitCount INT, PraathamikShikshitCount INT, NoShikshanCount INT, ' +
          ' ShaakhaaKaaryakartaaCount INT, VastiKaaryakartaaCount INT, GraamKaaryakartaaCount INT, MandalKaaryakartaaCount INT,' +
          ' NagarKaaryakartaaCount INT, ShaharKaaryakartaaCount INT, BhaagKaaryakartaaCount INT, VibhaagKaaryakartaaCount INT, ' +
          ' MahaanagarKaaryakartaaCount INT, PraantKaaryakartaaCount INT, KshetraKaaryakartaaCount INT,' +
          ' PravaseeKaaryakartaaCount INT, GatividhiKaaryakartaaCount INT, AayaamKaaryakartaaCount INT,' +
          ' SanghaPreritSansthaaKaaryakartaaCount INT,TotalKaaryakartaaCount INT,' +
          ' SocialOrganizationKaaryakartaaCount INT, PratidnyitCount INT, Notificationcount INT)');

      // db.execute('DROP TABLE IF EXISTS UserDataMaster');
      db.execute('CREATE TABLE IF NOT EXISTS UserDataMaster(SwayamsevakID INT, SwayamsevakDaayitvaID INT,PreferredLanguageID INT,' +
          ' PreferredLanguageCode VARCHAR(100),PraantID INT,MobileNumber VARCHAR(15),LinkedVastiName VARCHAR(100),' +
          ' LinkedVastiID INT,LinkedShaakhaaName VARCHAR(500),LinkedShaakhaaID INT,LinkedGraamName VARCHAR(100),' +
          ' LinkedGraamID INT,LevelName VARCHAR(100),LevelID INT,' +
          ' FullName VARCHAR(300),Email VARCHAR(500),DaayitvaStartYear INT,DaayitvaName VARCHAR(200),' +
          ' DaayitvaID INT,DaayitvaGeoUnitName VARCHAR(100),DaayitvaGeoUnitID INT,BirthDate VARCHAR(20), ' +
          ' LinkedGeoUnitHierarchy VARCHAR(100), IsFirstLogin BOOL, LastLoginTimeStamp VARCHAR(30), ' +
          ' IsLoggedIn VARCHAR(10), IsPravaasiKaaryakartaa BOOL)');
    }, onCreate: (db, version) {
      print('initDatabase - database created; version:' + version.toString());

      db.execute(' CREATE TABLE LevelMaster(LevelID INT, PraantID INT, LevelName VARCHAR(50), ' + ' Hierarchy INT)');

      db.execute(' CREATE TABLE StaticMaster(StaticID INT, PraantID INT, EntityType VARCHAR(100), Code VARCHAR(100), ' +
          '   CodeForDisplay VARCHAR(100), DisplaySequence INT, ViewOnly INT, showAnnualBaithak VARCHAR(5), myear VARCHAR(10))');

      db.execute(' CREATE TABLE GeoUnitMaster(GeoUnitID INT, PraantID INT, GeoUnitName VARCHAR(200),NameForDisplay VARCHAR(200),' +
          ' LevelID INT, DisplaySequence INT, ' +
          '   HasGraaminKshetra BOOL, ParentKshetraID INT, ParentPraantID INT, ParentMahaanagarID INT, ' +
          '   ParentVibhaagID INT, ParentBhaagID INT, ParentNagarID INT, ParentShaharID INT, ' +
          '   ParentMandalID INT, ParentVastiID INT, ParentGraamID INT, ParentUpaNagarID INT)');

      db.execute(' CREATE TABLE SwayamsevakMaster(SwayamsevakID INT, FullName VARCHAR(50), ' + '   MobileNumber VARCHAR(10), LinkedGeoUnitID INT, AppPassword VARCHAR(20), PreferredLanguageID INT)');
      db.execute(' CREATE TABLE DaayitvaMaster(DaayitvaID INT, PraantID INT, DaayitvaName VARCHAR(50), DaayitvaForID INT, ' + '   IsPravaasiDaayitva BIT)');
      db.execute(' CREATE TABLE StateMaster(StateID INT, GSTStateCode VARCHAR(5), Code VARCHAR(10), StateName VARCHAR(50))');
      db.execute(' CREATE TABLE GatividhiMaster(GatividhiID INT, PraantID INT, GatividhiName VARCHAR(200))');
      db.execute(' CREATE TABLE AayaamMaster(AayaamID INT, PraantID INT, AayaamName VARCHAR(200))');

      db.execute(' CREATE TABLE UserDataMaster(SwayamsevakID INT, SwayamsevakDaayitvaID INT,PreferredLanguageID INT,' +
          ' PreferredLanguageCode VARCHAR(100),PraantID INT,MobileNumber VARCHAR(15),LinkedVastiName VARCHAR(100),' +
          ' LinkedVastiID INT,LinkedShaakhaaName VARCHAR(500),LinkedShaakhaaID INT,LinkedGraamName VARCHAR(100),' +
          ' LinkedGraamID INT,LevelName VARCHAR(100),LevelID INT,' +
          ' FullName VARCHAR(300),Email VARCHAR(500),DaayitvaStartYear INT,DaayitvaName VARCHAR(200),' +
          ' DaayitvaID INT,DaayitvaGeoUnitName VARCHAR(100),DaayitvaGeoUnitID INT,BirthDate VARCHAR(20), ' +
          ' LinkedGeoUnitHierarchy VARCHAR(100), IsFirstLogin BOOL, LastLoginTimeStamp VARCHAR(30), ' +
          ' IsLoggedIn VARCHAR(10), IsPravaasiKaaryakartaa BOOL)');

      db.execute(''' CREATE TABLE AbhiyanSwayamsevakData (
          AbhiyaDaayitvaID INT, AbhiyanSwayamsevakID INT, DaayityaName VARCHAR(256), Email VARCHAR(256), FullName VARCHAR(256),
      GeoUnitID INT, GeoUnitName VARCHAR(256), LevelName VARCHAR(256), MobileNumber VARCHAR(256), ParentBhaagID INT,
      ParentMahaanagarID INT, ParentMandalID INT, ParentNagarID INT, ParentVibhaagID INT, PreferredLanguageCode VARCHAR(256),
      PreferredLanguageID INT)''');

      db.execute('CREATE TABLE IF NOT EXISTS HomeScreenData(ShishuCount INT, BaalCount INT, TarunVidyaarthiCount INT,' +
          ' TarunVyavasayeeCount INT, ProudhaVyavasayeeCount INT, UnknownAgeCount INT, TrutiyaVarshaShikshitCount INT,' +
          ' DwitiyaVarshaShikshitCount INT, PrathamVarshaShikshitCount INT, PraathamikShikshitCount INT, NoShikshanCount INT, ' +
          ' ShaakhaaKaaryakartaaCount INT, VastiKaaryakartaaCount INT, GraamKaaryakartaaCount INT, MandalKaaryakartaaCount INT,' +
          ' NagarKaaryakartaaCount INT, ShaharKaaryakartaaCount INT, BhaagKaaryakartaaCount INT, VibhaagKaaryakartaaCount INT, ' +
          ' MahaanagarKaaryakartaaCount INT, PraantKaaryakartaaCount INT, KshetraKaaryakartaaCount INT,' +
          ' PravaseeKaaryakartaaCount INT, GatividhiKaaryakartaaCount INT, AayaamKaaryakartaaCount INT,' +
          ' SanghaPreritSansthaaKaaryakartaaCount INT, TotalKaaryakartaaCount INT,' +
          ' SocialOrganizationKaaryakartaaCount INT, PratidnyitCount INT, Notificationcount INT)');

      db.execute(' CREATE TABLE AbhiyaanGeoUnitMaster(GeoUnitID INT, PraantID INT, GeoUnitName VARCHAR(200),NameForDisplay VARCHAR(200),' +
          ' LevelID INT, DisplaySequence INT, ' +
          '   HasGraaminKshetra BOOL, ParentKshetraID INT, ParentPraantID INT, ParentMahaanagarID INT, ' +
          '   ParentVibhaagID INT, ParentBhaagID INT, ParentNagarID INT, ParentShaharID INT, ' +
          '   ParentMandalID INT, ParentVastiID INT, ParentGraamID INT, isAbhiyaan BOOL)');
    });
    return database;
  }

  static Future<void> executeQuery(String strQuery) async {
    Database db = await database;
    var result = await db.execute(strQuery);
    return result;
  }

  static Future<List<Map<String, dynamic>>> getData(String strQuery) async {
    Database db = await database;
    var result = await db.rawQuery(strQuery);
    return result;
  }

  // static Future<void> logoutUser() async {
  //   Database db = await database;
  //   String sqlStr = 'UPDATE UserDataMaster SET IsLoggedIn=\'false\';';
  //   String sqlStr2 = 'UPDATE UserDataMaster SET SwayamsevakID=0;';
  //   await db.execute(sqlStr);
  //   await db.execute(sqlStr2);
  // }
  // static Future<void> logoutUser() async {
  //   try {
  //     Statics.deleteUserToken();
  //     Database db = await database;
  //     String sqlStr = 'UPDATE UserDataMaster SET IsLoggedIn=\'false\';';
  //     String sqlStr2 = 'UPDATE UserDataMaster SET SwayamsevakID=0;';
  //
  //     await db.execute(sqlStr);
  //     await db.execute(sqlStr2);
  //     await db.rawDelete('DELETE FROM AayaamMaster');
  //     await db.rawDelete('DELETE FROM DaayitvaMaster');
  //     await db.rawDelete('DELETE FROM GatividhiMaster');
  //     await db.rawDelete('DELETE FROM GeoUnitMaster');
  //     await db.rawDelete('DELETE FROM HomeScreenData');
  //     await db.rawDelete('DELETE FROM LevelMaster');
  //     await db.rawDelete('DELETE FROM StateMaster');
  //     await db.rawDelete('DELETE FROM StaticMaster');
  //     await db.rawDelete('DELETE FROM SwayamsevakMaster');
  //     await db.rawDelete('DELETE FROM UserDataMaster');
  //     print("DatabaseHelper logoutUser executed");
  //
  //     // await db.execute('DROP TABLE IF EXISTS AayaamMaster');
  //     // await db.execute('DROP TABLE IF EXISTS DaayitvaMaster');
  //     // await db.execute('DROP TABLE IF EXISTS GatividhiMaster');
  //     // await db.execute('DROP TABLE IF EXISTS GeoUnitMaster');
  //     // await db.execute('DROP TABLE IF EXISTS HomeScreenData');
  //     // await db.execute('DROP TABLE IF EXISTS LevelMaster');
  //     // await db.execute('DROP TABLE IF EXISTS StateMaster');
  //     // await  db.execute('DROP TABLE IF EXISTS StaticMaster');
  //     // await db.execute('DROP TABLE IF EXISTS SwayamsevakMaster');
  //     // await  db.execute('DROP TABLE IF EXISTS UserDataMaster');
  //     _database = null;
  //   } catch (e) {
  //     print("Error in DatabaseHelper logoutUser: $e");
  //   }
  // }

  static Future<void> reCreate(String tableName, dynamic dataList) async {
    Database db = await database;
    // if (await Statics.checkForTableExists(tableName)) await db.execute('DELETE FROM ' + tableName);
    int cnt = 0;
    String sqlStr = '';
    try {
      if (tableName == 'LevelMaster') {
        for (var data in dataList) {
          cnt = cnt + 1;
          sqlStr = sqlStr +
              (cnt == 1 ? 'INSERT INTO LevelMaster (LevelID, PraantID, LevelName, Hierarchy) VALUES ' : ',') +
              '(' +
              data['LevelID'].toString() +
              ',' +
              data['PraantID'].toString() +
              ',\'' +
              data['LevelName'].toString() +
              '\',' +
              data['Hierarchy'].toString() +
              ')';
        }
      } else if (tableName == 'StaticMaster') {
        for (var data in dataList) {
          // print("StaticMaster =-=-> " +data['showAnnualBaithak'].toString() );
          // print("StaticMaster =-=-> " +data['myear'].toString() );
          cnt = cnt + 1;
          sqlStr = sqlStr +
              (cnt == 1 ? 'INSERT INTO StaticMaster(StaticID, PraantID, EntityType, Code, CodeForDisplay, DisplaySequence, ViewOnly, showAnnualBaithak, myear) VALUES ' : ',') +
              '(' +
              data['StaticID'].toString() +
              ',' +
              data['PraantID'].toString() +
              ',\'' +
              data['EntityType'].toString() +
              '\',\'' +
              data['Code'].toString() +
              '\',\'' +
              data['CodeForDisplay'].toString() +
              '\',' +
              data['DisplaySequence'].toString() +
              ',' +
              data['ViewOnly'].toString() +
              ',' +
              data['showAnnualBaithak'].toString() +
              ',' +
              (data['myear'] == null || data['myear'].toString().isEmpty ? '\'-\'' : '\'' + data['myear'].toString() + '\'') +
              ')';

          // log(sqlStr + "sqlStrsqlStr");
        }
      } else if (tableName == 'StateMaster') {
        for (var data in dataList) {
          cnt = cnt + 1;
          sqlStr = sqlStr +
              (cnt == 1 ? 'INSERT INTO StateMaster(StateID, Code , GSTStateCode , StateName) VALUES ' : ',') +
              '(' +
              data['StateID'].toString() +
              ',\'' +
              data['Code'].toString() +
              '\',\'' +
              data['GSTStateCode'].toString() +
              '\',\'' +
              data['StateName'].toString() +
              '\' )';
        }
      } else if (tableName == 'DaayitvaMaster') {
        for (var data in dataList) {
          cnt = cnt + 1;
          sqlStr = sqlStr +
              (cnt == 1 ? 'INSERT INTO DaayitvaMaster(DaayitvaID, PraantID , DaayitvaName , DaayitvaForID, IsPravaasiDaayitva) VALUES ' : ',') +
              '(' +
              data['DaayitvaID'].toString() +
              ',' +
              data['PraantID'].toString() +
              ',\'' +
              data['DaayitvaName'].toString() +
              '\',' +
              data['DaayitvaForID'].toString() +
              ',' +
              (data['IsPravaasiDaayitva'].toString() == 'true' ? '1' : '0') +
              ')';
        }
      } else if (tableName == 'AayaamMaster') {
        for (var data in dataList) {
          cnt = cnt + 1;
          sqlStr = sqlStr +
              (cnt == 1 ? 'INSERT INTO AayaamMaster(AayaamID,PraantID,AayaamName) VALUES ' : ',') +
              '(' +
              data['AayaamID'].toString() +
              ',' +
              data['PraantID'].toString() +
              ',\'' +
              data['AayaamName'].toString() +
              '\' )';
        }
      } else if (tableName == 'GatividhiMaster') {
        for (var data in dataList) {
          cnt = cnt + 1;
          sqlStr = sqlStr +
              (cnt == 1 ? 'INSERT INTO GatividhiMaster(GatividhiID,PraantID,GatividhiName) VALUES ' : ',') +
              '(' +
              data['GatividhiID'].toString() +
              ',' +
              data['PraantID'].toString() +
              ',\'' +
              data['GatividhiName'].toString() +
              '\' )';
        }
      } else if (tableName == 'GeoUnitMaster') {
        for (var data in dataList) {
          cnt = cnt + 1;
          sqlStr = sqlStr +
              (cnt == 1
                  ? 'INSERT INTO GeoUnitMaster(GeoUnitID, PraantID, GeoUnitName, LevelID, DisplaySequence, ' +
                      ' ParentKshetraID, ParentPraantID, ParentMahaanagarID, ParentVibhaagID, ParentBhaagID, ParentNagarID, ' +
                      ' ParentShaharID, ParentMandalID, ParentGraamID, ParentVastiID, HasGraaminKshetra, ParentUpaNagarID) VALUES '
                  : ',') +
              '(' +
              data['GeoUnitID'].toString() +
              ',' +
              data['PraantID'].toString() +
              ',\'' +
              data['GeoUnitName'].toString().replaceAll("'", "''") +
              '\',' +
              data['LevelID'].toString() +
              ',' +
              data['DisplaySequence'].toString() +
              ',' +
              data['ParentKshetraID'].toString() +
              ',' +
              data['ParentPraantID'].toString() +
              ',' +
              data['ParentMahaanagarID'].toString() +
              ',' +
              data['ParentVibhaagID'].toString() +
              ',' +
              data['ParentBhaagID'].toString() +
              ',' +
              data['ParentNagarID'].toString() +
              ',' +
              data['ParentShaharID'].toString() +
              ',' +
              data['ParentMandalID'].toString() +
              ',' +
              data['ParentGraamID'].toString() +
              ',' +
              data['ParentVastiID'].toString() +
              ',' +
              (data['HasGraaminKshetra'].toString() == 'true' ? '1' : '0') +
              ',' +
              (data['ParentUpaNagarID'].toString()) +
              ')';
        }
        cnt = cnt + 1;
      } else if (tableName == 'AbhiyaanGeoUnitMaster') {
        for (var data in dataList) {
          cnt = cnt + 1;
          sqlStr = sqlStr +
              (cnt == 1
                  ? 'INSERT INTO AbhiyaanGeoUnitMaster(GeoUnitID, PraantID, GeoUnitName, LevelID, DisplaySequence, ' +
                      ' ParentKshetraID, ParentPraantID, ParentMahaanagarID, ParentVibhaagID, ParentBhaagID, ParentNagarID, ' +
                      ' ParentShaharID, ParentMandalID, ParentGraamID, ParentVastiID, HasGraaminKshetra, isAbhiyaan) VALUES '
                  : ',') +
              '(' +
              data['GeoUnitID'].toString() +
              ',' +
              data['PraantID'].toString() +
              ',\'' +
              data['GeoUnitName'].toString().replaceAll("'", "''") +
              '\',' +
              data['LevelID'].toString() +
              ',' +
              data['DisplaySequence'].toString() +
              ',' +
              data['ParentKshetraID'].toString() +
              ',' +
              data['ParentPraantID'].toString() +
              ',' +
              data['ParentMahaanagarID'].toString() +
              ',' +
              data['ParentVibhaagID'].toString() +
              ',' +
              data['ParentBhaagID'].toString() +
              ',' +
              data['ParentNagarID'].toString() +
              ',' +
              data['ParentShaharID'].toString() +
              ',' +
              data['ParentMandalID'].toString() +
              ',' +
              data['ParentGraamID'].toString() +
              ',' +
              data['ParentVastiID'].toString() +
              ',' +
              (data['HasGraaminKshetra'].toString() == 'true' ? '1' : '0') +
              ',' +
              '1' +
              ')';
        }
        cnt = cnt + 1;
      } else if (tableName == 'UserDataMaster') {
        //for (var data in dataList) {
        try {
          cnt = cnt + 1;
          sqlStr = sqlStr +
              (cnt == 1
                  ? 'INSERT INTO UserDataMaster(SwayamsevakID, SwayamsevakDaayitvaID, PreferredLanguageID, ' +
                      ' PreferredLanguageCode, PraantID, MobileNumber,LinkedVastiName,LinkedVastiID, LinkedShaakhaaName,' +
                      ' LinkedShaakhaaID, LinkedGraamName, LinkedGraamID, LevelName, LevelID, FullName, ' +
                      ' Email, DaayitvaStartYear, DaayitvaName, DaayitvaID, DaayitvaGeoUnitName, DaayitvaGeoUnitID, ' +
                      ' BirthDate, LinkedGeoUnitHierarchy, IsFirstLogin, LastLoginTimeStamp, IsLoggedIn, IsPravaasiKaaryakartaa) VALUES '
                  : ',') +
              '(' +
              dataList['SwayamsevakID'].toString() +
              ',' +
              dataList['SwayamsevakDaayitvaID'].toString() +
              ',' +
              dataList['PreferredLanguageID'].toString() +
              ',\'' +
              dataList['PreferredLanguageCode'].toString() +
              '\'' +
              ',' +
              dataList['PraantID'].toString() +
              ',\'' +
              dataList['MobileNumber'].toString() +
              '\'' +
              ',\'' +
              dataList['LinkedVastiName'].toString() +
              '\',' +
              dataList['LinkedVastiID'].toString() +
              ',\'' +
              dataList['LinkedShaakhaaName'].toString() +
              '\',' +
              dataList['LinkedShaakhaaID'].toString() +
              ',\'' +
              dataList['LinkedGraamName'].toString() +
              '\',' +
              dataList['LinkedGraamID'].toString() +
              ',\'' +
              dataList['LevelName'].toString() +
              '\',' +
              dataList['LevelID'].toString() +
              ',\'' +
              dataList['FullName'].toString() +
              '\'' +
              ',\'' +
              dataList['Email'].toString() +
              '\',' +
              dataList['DaayitvaStartYear'].toString() +
              ',\'' +
              dataList['DaayitvaName'].toString() +
              '\',' +
              dataList['DaayitvaID'].toString() +
              ',\'' +
              dataList['DaayitvaGeoUnitName'].toString() +
              '\',' +
              dataList['DaayitvaGeoUnitID'].toString() +
              ',\'' +
              dataList['BirthDate'].toString() +
              '\',\'' +
              dataList['LinkedGeoUnitHierarchy'] +
              '\'' +
              ',' +
              ((dataList['IsFirstLogin'] == null || dataList['IsFirstLogin'] == false) ? '0' : '1') +
              ',\'' +
              //DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()) +
              dataList['LastLoginTimeStampStr'] +
              '\',\'true\', ' +
              ((dataList[' IsLoggedIn'] == null || dataList[' IsLoggedIn'] == false) ? '0' : '1') +
              ((dataList['IsPravaasiKaaryakartaa'] == null || dataList['IsPravaasiKaaryakartaa'] == false) ? '0' : '1') +
              ')';
        } catch (e) {
          print(" -- DB Exception -- ${e.toString()}");
        }
      } else if (tableName == 'AbhiyanSwayamsevakData') {
        //for (var data in dataList) {
        try {
          cnt = cnt + 1;
          sqlStr = sqlStr +
              (cnt == 1
                  ? 'INSERT INTO AbhiyanSwayamsevakData (AbhiyaDaayitvaID, AbhiyanSwayamsevakID, DaayityaName, Email, FullName,' +
                      'GeoUnitID, GeoUnitName, LevelName, MobileNumber, ParentBhaagID, ParentMahaanagarID, ParentMandalID,' +
                      'ParentNagarID, ParentVibhaagID, PreferredLanguageCode, PreferredLanguageID)  VALUES '
                  : ',') +
              '(' +
              dataList['AbhiyaDaayitvaID'] +
              ',' +
              dataList['AbhiyanSwayamsevakID'] +
              ',' +
              dataList['DaayityaName'].toString() +
              ',\'' +
              dataList['Email'].toString() +
              '\'' +
              ',' +
              dataList['FullName'].toString() +
              ',\'' +
              dataList['GeoUnitName'].toString() +
              '\'' +
              ',\'' +
              dataList['LevelName'].toString() +
              '\',' +
              dataList['MobileNumber'].toString() +
              ',\'' +
              dataList['ParentBhaagID'].toString() +
              '\',' +
              dataList['ParentMahaanagarID'].toString() +
              ',\'' +
              dataList['ParentMandalID'].toString() +
              '\',' +
              dataList['ParentNagarID'].toString() +
              ',\'' +
              dataList['ParentVibhaagID'].toString() +
              '\',' +
              dataList['PreferredLanguageCode'].toString() +
              ',\'' +
              dataList['PreferredLanguageID'].toString() +
              ')';
          log(sqlStr);
        } catch (e) {
          print(" -- DB Exception -- ${e.toString()}");
        }
      } else if (tableName == 'HomeScreenData') {
        //for (var data in dataList) {
        cnt = cnt + 1;
        sqlStr = sqlStr +
            (cnt == 1
                ? 'INSERT INTO HomeScreenData( ShishuCount, BaalCount,	TarunVidyaarthiCount,	TarunVyavasayeeCount,	' +
                    '	ProudhaVyavasayeeCount,	 UnknownAgeCount,	TrutiyaVarshaShikshitCount,	DwitiyaVarshaShikshitCount,	' +
                    '	PrathamVarshaShikshitCount,	PraathamikShikshitCount, NoShikshanCount,	ShaakhaaKaaryakartaaCount,	' +
                    ' VastiKaaryakartaaCount, GraamKaaryakartaaCount,	MandalKaaryakartaaCount, NagarKaaryakartaaCount, ' +
                    ' ShaharKaaryakartaaCount, BhaagKaaryakartaaCount, VibhaagKaaryakartaaCount, MahaanagarKaaryakartaaCount,	' +
                    ' PraantKaaryakartaaCount,	KshetraKaaryakartaaCount,	PravaseeKaaryakartaaCount,	' +
                    ' GatividhiKaaryakartaaCount, AayaamKaaryakartaaCount,  SanghaPreritSansthaaKaaryakartaaCount,' +
                    ' TotalKaaryakartaaCount , SocialOrganizationKaaryakartaaCount , PratidnyitCount, Notificationcount ) VALUES '
                : ',') +
            '(' +
            dataList['ShishuCount'].toString() +
            ',' +
            dataList['BaalCount'].toString() +
            ',' +
            dataList['TarunVidyaarthiCount'].toString() +
            ',' +
            dataList['TarunVyavasaayeeCount'].toString() +
            ',' +
            dataList['ProudhaVyavasaayeeCount'].toString() +
            ',' +
            dataList['UnknownAgeCount'].toString() +
            ',' +
            dataList['TrutiyaVarshaShikshitCount'].toString() +
            ',' +
            dataList['DwitiyaVarshaShikshitCount'].toString() +
            ',' +
            dataList['PrathamVarshaShikshitCount'].toString() +
            ',' +
            dataList['PraathamikShikshitCount'].toString() +
            ',' +
            dataList['NoShikshanCount'].toString() +
            ',' +
            dataList['ShaakhaaKaaryakartaaCount'].toString() +
            ',' +
            dataList['VastiKaaryakartaaCount'].toString() +
            ',' +
            dataList['GraamKaaryakartaaCount'].toString() +
            ',' +
            dataList['MandalKaaryakartaaCount'].toString() +
            ',' +
            dataList['NagarKaaryakartaaCount'].toString() +
            ',' +
            dataList['ShaharKaaryakartaaCount'].toString() +
            ',' +
            dataList['BhaagKaaryakartaaCount'].toString() +
            ',' +
            dataList['VibhaagKaaryakartaaCount'].toString() +
            ',' +
            dataList['MahaanagarKaaryakartaaCount'].toString() +
            ',' +
            dataList['PraantKaaryakartaaCount'].toString() +
            ',' +
            dataList['KshetraKaaryakartaaCount'].toString() +
            ',' +
            dataList['PravaaseeKaaryakartaaCount'].toString() +
            ',' +
            dataList['GatividhiKaaryakartaaCount'].toString() +
            ',' +
            dataList['AayaamKaaryakartaaCount'].toString() +
            ',' +
            dataList['SanghaPreritSansthaaKaaryakartaaCount'].toString() +
            ',' +
            dataList['TotalKaaryakartaaCount'].toString() +
            ',' +
            dataList['SocialOrganizationKaaryakartaaCount'].toString() +
            ',' +
            dataList['PratidnyitCount'].toString() +
            ',' +
            dataList['Notificationcount'].toString() +
            ')';
        //}
      }

      if (cnt > 0) sqlStr = sqlStr + ';';
      print("Shovan");
      // log(sqlStr);
      await db.execute(sqlStr);
    } catch (e) {
      print(" -- DB Exception -- ${e.toString()}");
    }
  }

  static Future<void> insertOrUpdateRecord(String tableName, dynamic data) async {
    Database db = await database;
    String sqlStr = '';
    if (tableName == 'LevelMaster') {
      sqlStr = 'SELECT 1 FROM LevelMaster WHERE LevelID=' + data['LevelID'].toString() + ';';
      var result = await db.rawQuery(sqlStr);
      if (result.length > 0) {
        // Record found, then update it
        sqlStr = 'UPDATE LevelMaster SET ' + ' LevelName=\'' + data['LevelName'].toString() + '\', Hierarchy=' + data['Hierarchy'].toString() + ' WHERE LevelID=' + data['LevelID'].toString() + ';';
      } else {
        // Record not found, then insert

        sqlStr = 'INSERT INTO LevelMaster (LevelID, PraantID, LevelName, Hierarchy) VALUES (' +
            data['LevelID'].toString() +
            ',' +
            data['PraantID'].toString() +
            ',\'' +
            data['LevelName'].toString() +
            '\',' +
            data['Hierarchy'].toString() +
            ');';
      }
    } else if (tableName == 'StaticMaster') {
      // sqlStr = 'SELECT 1 FROM StaticMaster WHERE StaticID=' + data['StaticID'].toString() + ';';
      // var result = await db.rawQuery(sqlStr);
      // if (result.length > 0) {
      //   sqlStr = 'UPDATE StaticMaster SET ' +
      //       ' EntityType=\'' +
      //       data['EntityType'].toString() +
      //       '\', Code=\'' +
      //       data['Code'].toString() +
      //       '\', CodeForDisplay=\'' +
      //       data['CodeForDisplay'].toString() +
      //       '\', DisplaySequence=' +
      //       data['DisplaySequence'].toString() +
      //       '\', ViewOnly=' +
      //       data['ViewOnly'].toString() +
      //       '\', showAnnualBaithak=' +
      //       data['showAnnualBaithak'].toString() +
      //       '\', myear=' +
      //       (data['myear'] == null || data['myear'].toString().isEmpty ? '-\'' : data['myear'].toString() + '\'') +
      //       ' WHERE StaticID=' +
      //       data['StaticID'].toString() +
      //       ';';
      // } else {
      print("StaticMaster22 =-=-> " + data['showAnnualBaithak'].toString());
      print("StaticMaster22 =-=-> " + data['myear'].toString());
      sqlStr = 'INSERT INTO StaticMaster(StaticID, PraantID, EntityType, Code, CodeForDisplay, DisplaySequence, ViewOnly, showAnnualBaithak, myear) VALUES (' +
          data['StaticID'].toString() +
          ',' +
          data['PraantID'].toString() +
          ',\'' +
          data['EntityType'].toString() +
          '\',\'' +
          data['Code'].toString() +
          '\',\'' +
          data['CodeForDisplay'].toString() +
          '\',' +
          data['DisplaySequence'].toString() +
          ',' +
          data['ViewOnly'].toString() +
          ',' +
          data['showAnnualBaithak'].toString() +
          ',' +
          (data['myear'] == null || data['myear'].toString().isEmpty ? '\'-\'' : '\'' + data['myear'].toString() + '\'') +
          ');';
      // log(sqlStr + "sqlStrsqlStr 2222");
      // }
    } else if (tableName == 'StateMaster') {
      // sqlStr = 'SELECT 1 FROM StateMaster WHERE StateID=' + data['StateID'].toString() + ';';
      // var result = await db.rawQuery(sqlStr);
      // if (result.length > 0) {
      //   // Record found, then update it
      //   sqlStr = 'UPDATE StateMaster SET ' +
      //       ' Code=\'' +
      //       data['Code'].toString() +
      //       '\', GSTStateCode=\'' +
      //       data['GSTStateCode'].toString() +
      //       '\', StateName=\'' +
      //       data['StateName'].toString() +
      //       '\' WHERE StateID=' +
      //       data['StateID'].toString() +
      //       ';';
      // } else {
      // Record not found, then insert
      sqlStr = 'INSERT INTO StateMaster(StateID, Code , GSTStateCode , StateName) VALUES (' +
          data['StateID'].toString() +
          ',\'' +
          data['Code'].toString() +
          '\',\'' +
          data['GSTStateCode'].toString() +
          '\',\'' +
          data['StateName'].toString() +
          '\' );';
      // }
    } else if (tableName == 'DaayitvaMaster') {
      // sqlStr = 'SELECT 1 FROM DaayitvaMaster WHERE DaayitvaID=' + data['DaayitvaID'].toString() + ';';
      // var result = await db.rawQuery(sqlStr);
      // if (result.length > 0) {
      //   // Record found, then update it
      //   sqlStr = 'UPDATE DaayitvaMaster SET ' +
      //       ' DaayitvaName=\'' +
      //       data['DaayitvaName'].toString() +
      //       '\', DaayitvaForID=' +
      //       data['DaayitvaForID'].toString() +
      //       ', IsPravaasiDaayitva=' +
      //       (data['IsPravaasiDaayitva'].toString() == 'true' ? '1' : '0') +
      //       ' WHERE DaayitvaID=' +
      //       data['DaayitvaID'].toString() +
      //       ';';
      // } else {
      // Record not found, then insert
      sqlStr = 'INSERT INTO DaayitvaMaster(DaayitvaID, PraantID , DaayitvaName , DaayitvaForID, IsPravaasiDaayitva) VALUES (' +
          data['DaayitvaID'].toString() +
          ',' +
          data['PraantID'].toString() +
          ',\'' +
          data['DaayitvaName'].toString() +
          '\',' +
          data['DaayitvaForID'].toString() +
          ',' +
          (data['IsPravaasiDaayitva'].toString() == 'true' ? '1' : '0') +
          ');';
      // }
    } else if (tableName == 'AayaamMaster') {
      // sqlStr = 'SELECT 1 FROM AayaamMaster WHERE AayaamID=' + data['AayaamID'].toString() + ';';
      // var result = await db.rawQuery(sqlStr);
      // if (result.length > 0) {
      //   // Record found, then update it
      //   sqlStr = 'UPDATE AayaamMaster SET ' + ' AayaamName=\'' + data['AayaamName'].toString() + '\' WHERE AayaamID=' + data['AayaamID'].toString() + ';';
      // } else {
      // Record not found, then insert
      sqlStr = 'INSERT INTO AayaamMaster(AayaamID,PraantID,AayaamName) VALUES (' + data['AayaamID'].toString() + ',' + data['PraantID'].toString() + ',\'' + data['AayaamName'].toString() + '\' );';
      // }
    } else if (tableName == 'GatividhiMaster') {
      sqlStr = 'SELECT 1 FROM GatividhiMaster WHERE GatividhiID=' + data['GatividhiID'].toString() + ';';
      var result = await db.rawQuery(sqlStr);
      if (result.length > 0) {
        // Record found, then update it
        sqlStr = 'UPDATE GatividhiMaster SET ' + ' GatividhiName=\'' + data['GatividhiName'].toString() + '\' WHERE GatividhiID=' + data['GatividhiID'].toString() + ';';
      } else {
        // Record not found, then insert
        sqlStr = 'INSERT INTO GatividhiMaster(GatividhiID,PraantID,GatividhiName) VALUES (' +
            data['GatividhiID'].toString() +
            ',' +
            data['PraantID'].toString() +
            ',\'' +
            data['GatividhiName'].toString() +
            '\' );';
      }
    } else if (tableName == 'GeoUnitMaster') {
      // sqlStr = 'SELECT 1 FROM GeoUnitMaster WHERE GeoUnitID=' + data['GeoUnitID'].toString() + ';';
      // var result = await db.rawQuery(sqlStr);
      // if (result.length > 0) {
      //   // Record found, then update it
      //   sqlStr = 'UPDATE GeoUnitMaster SET ' +
      //       ' GeoUnitName=\'' +
      //       data['GeoUnitName'].toString() +
      //       '\'' +
      //       ', LevelID=' +
      //       data['LevelID'].toString() +
      //       ', DisplaySequence=' +
      //       data['DisplaySequence'].toString() +
      //       ', ParentKshetraID=' +
      //       data['ParentKshetraID'].toString() +
      //       ', ParentPraantID=' +
      //       data['ParentPraantID'].toString() +
      //       ', ParentMahaanagarID=' +
      //       data['ParentMahaanagarID'].toString() +
      //       ', ParentVibhaagID=' +
      //       data['ParentVibhaagID'].toString() +
      //       ', ParentBhaagID=' +
      //       data['ParentBhaagID'].toString() +
      //       ', ParentShaharID=' +
      //       data['ParentShaharID'].toString() +
      //       ', ParentNagarID=' +
      //       data['ParentNagarID'].toString() +
      //       ', ParentMandalID=' +
      //       data['ParentMandalID'].toString() +
      //       ', ParentGraamID=' +
      //       data['ParentGraamID'].toString() +
      //       ', ParentVastiID=' +
      //       data['ParentVastiID'].toString() +
      //       ', HasGraaminKshetra=' +
      //       (data['HasGraaminKshetra'].toString() == 'true' ? '1' : '0') +
      //       ' WHERE GeoUnitID=' +
      //       data['GeoUnitID'].toString() +
      //       ';';
      // } else {
      // Record not found, then insert
      sqlStr = 'INSERT INTO GeoUnitMaster(GeoUnitID, PraantID, GeoUnitName, LevelID, DisplaySequence, ' +
          ' ParentKshetraID, ParentPraantID, ParentMahaanagarID, ParentVibhaagID, ParentBhaagID, ParentNagarID, ' +
          ' ParentShaharID, ParentMandalID, ParentGraamID, ParentVastiID, HasGraaminKshetra, ParentUpaNagarID) VALUES (' +
          data['GeoUnitID'].toString() +
          ',' +
          data['PraantID'].toString() +
          ',\'' +
          data['GeoUnitName'].toString().replaceAll("'", "''") +
          '\',' +
          data['LevelID'].toString() +
          ',' +
          data['DisplaySequence'].toString() +
          ',' +
          data['ParentKshetraID'].toString() +
          ',' +
          data['ParentPraantID'].toString() +
          ',' +
          data['ParentMahaanagarID'].toString() +
          ',' +
          data['ParentVibhaagID'].toString() +
          ',' +
          data['ParentBhaagID'].toString() +
          ',' +
          data['ParentNagarID'].toString() +
          ',' +
          data['ParentShaharID'].toString() +
          ',' +
          data['ParentMandalID'].toString() +
          ',' +
          data['ParentGraamID'].toString() +
          ',' +
          data['ParentVastiID'].toString() +
          ',' +
          (data['HasGraaminKshetra'].toString() == 'true' ? '1' : '0') +
          ',' +
          (data['ParentUpaNagarID'].toString()) +
          ');';
      // }
    } else if (tableName == 'AbhiyaanGeoUnitMaster') {
      sqlStr = 'INSERT INTO AbhiyaanGeoUnitMaster(GeoUnitID, PraantID, GeoUnitName, LevelID, DisplaySequence, ' +
          ' ParentKshetraID, ParentPraantID, ParentMahaanagarID, ParentVibhaagID, ParentBhaagID, ParentNagarID, ' +
          ' ParentShaharID, ParentMandalID, ParentGraamID, ParentVastiID, HasGraaminKshetra, isAbhiyaan) VALUES (' +
          data['GeoUnitID'].toString() +
          ',' +
          data['PraantID'].toString() +
          ',\'' +
          data['GeoUnitName'].toString().replaceAll("'", "''") +
          '\',' +
          data['LevelID'].toString() +
          ',' +
          data['DisplaySequence'].toString() +
          ',' +
          data['ParentKshetraID'].toString() +
          ',' +
          data['ParentPraantID'].toString() +
          ',' +
          data['ParentMahaanagarID'].toString() +
          ',' +
          data['ParentVibhaagID'].toString() +
          ',' +
          data['ParentBhaagID'].toString() +
          ',' +
          data['ParentNagarID'].toString() +
          ',' +
          data['ParentShaharID'].toString() +
          ',' +
          data['ParentMandalID'].toString() +
          ',' +
          data['ParentGraamID'].toString() +
          ',' +
          data['ParentVastiID'].toString() +
          ',' +
          (data['HasGraaminKshetra'].toString() == 'true' ? '1' : '0') +
          ',' +
          '1' +
          ');';
    } else if (tableName == 'UserDataMaster') {
      sqlStr = 'SELECT 1 FROM UserDataMaster WHERE SwayamsevakID=' + data['SwayamsevakID'].toString() + ';';
      var result = await db.rawQuery(sqlStr);
      if (result.length > 0) {
        // Record found, then update it
        sqlStr = 'UPDATE UserDataMaster SET ' +
            ' SwayamsevakDaayitvaID=' +
            data['SwayamsevakDaayitvaID'].toString() +
            ', PreferredLanguageID=' +
            data['PreferredLanguageID'].toString() +
            ', PreferredLanguageCode=\'' +
            data['PreferredLanguageCode'].toString() +
            '\'' +
            ', MobileNumber=\'' +
            data['MobileNumber'].toString() +
            '\'' +
            ', LinkedVastiName=\'' +
            data['LinkedVastiName'].toString() +
            '\'' +
            ', LinkedVastiID=' +
            data['LinkedVastiID'].toString() +
            ', LinkedShaakhaaName=\'' +
            data['LinkedShaakhaaName'].toString() +
            '\'' +
            ', LinkedShaakhaaID=' +
            data['LinkedShaakhaaID'].toString() +
            ', LinkedGraamName=\'' +
            data['LinkedGraamName'].toString() +
            '\'' +
            ', LinkedGraamID=' +
            data['LinkedGraamID'].toString() +
            ', LevelName=\'' +
            data['LevelName'].toString() +
            '\'' +
            ', LevelID=' +
            data['LevelID'].toString() +
            ', FullName=\'' +
            data['FullName'].toString() +
            '\'' +
            ', Email=\'' +
            data['Email'].toString() +
            '\'' +
            ', DaayitvaStartYear=' +
            data['DaayitvaStartYear'].toString() +
            ', DaayitvaName=\'' +
            data['DaayitvaName'].toString() +
            '\'' +
            ', DaayitvaID=' +
            data['DaayitvaID'].toString() +
            ', DaayitvaGeoUnitName=\'' +
            data['DaayitvaGeoUnitName'].toString() +
            '\'' +
            ', DaayitvaGeoUnitID=' +
            data['DaayitvaGeoUnitID'].toString() +
            ', BirthDate=\'' +
            data['BirthDate'].toString() +
            '\'' +
            ', LinkedGeoUnitHierarchy=\'' +
            data['LinkedGeoUnitHierarchy'].toString() +
            '\'' +
            ', IsFirstLogin=' +
            (data["IsFirstLogin"] == null || data["IsFirstLogin"] == false ? '0' : '1') +
            ', LastLoginTimeStamp=\'' +
            DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()) +
            '\'' +
            ', IsLoggedIn=\'true\' ' +
            ', IsPravaasiKaaryakartaa=' +
            (data["IsPravaasiKaaryakartaa"] == null || data["IsPravaasiKaaryakartaa"] == false ? '0' : '1') +
            ' WHERE SwayamsevakID=' +
            data['SwayamsevakID'].toString() +
            ';';
      } else {
        // Record not found, then insert
        sqlStr = 'INSERT INTO UserDataMaster(SwayamsevakID, SwayamsevakDaayitvaID, PreferredLanguageID, ' +
            ' PreferredLanguageCode, PraantID, MobileNumber,LinkedVastiName,LinkedVastiID, LinkedShaakhaaName,' +
            ' LinkedShaakhaaID, LinkedGraamName, LinkedGraamID, LevelName, LevelID, FullName, ' +
            ' Email, DaayitvaStartYear, DaayitvaName, DaayitvaID, DaayitvaGeoUnitName, DaayitvaGeoUnitID, ' +
            ' BirthDate, LinkedGeoUnitHierarchy, IsFirstLogin, LastLoginTimeStamp, IsLoggedIn, IsPravaasiKaaryakartaa) VALUES (' +
            data['SwayamsevakID'].toString() +
            ',' +
            data['SwayamsevakDaayitvaID'].toString() +
            ',' +
            data['PreferredLanguageID'].toString() +
            ',\'' +
            data['PreferredLanguageCode'].toString() +
            '\'' +
            ',' +
            data['PraantID'].toString() +
            ',\'' +
            data['MobileNumber'].toString() +
            '\'' +
            ',\'' +
            data['LinkedVastiName'].toString() +
            '\',' +
            data['LinkedVastiID'].toString() +
            ',\'' +
            data['LinkedShaakhaaName'].toString() +
            '\',' +
            data['LinkedShaakhaaID'].toString() +
            ',\'' +
            data['LinkedGraamName'].toString() +
            '\',' +
            data['LinkedGraamID'].toString() +
            ',\'' +
            data['LevelName'].toString() +
            '\',' +
            data['LevelID'].toString() +
            ',\'' +
            data['FullName'].toString() +
            '\'' +
            ',\'' +
            data['Email'].toString() +
            '\',' +
            data['DaayitvaStartYear'].toString() +
            ',\'' +
            data['DaayitvaName'].toString() +
            '\',' +
            data['DaayitvaID'].toString() +
            ',\'' +
            data['DaayitvaGeoUnitName'].toString() +
            '\',' +
            data['DaayitvaGeoUnitID'].toString() +
            ',\'' +
            data['BirthDate'].toString() +
            '\',\'' +
            data['LinkedGeoUnitHierarchy'] +
            '\'' +
            ',' +
            ((data['IsFirstLogin'] == null || data['IsFirstLogin'] == false) ? '0' : '1') +
            ',\'' +
            DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()) +
            '\',\'true\' ' +
            ',' +
            ((data[' IsLoggedIn'] == null || data[' IsLoggedIn'] == false) ? '0' : '1') +
            ((data['IsPravaasiKaaryakartaa'] == null || data['IsPravaasiKaaryakartaa'] == false) ? '0' : '1') +
            ' );';
      }
    } else if (tableName == 'AbhiyanSwayamsevakData') {
      // Record not found, then insert
      sqlStr = 'INSERT INTO AbhiyanSwayamsevakData (AbhiyaDaayitvaID, AbhiyanSwayamsevakID, DaayityaName, Email, FullName,' +
          'GeoUnitID, GeoUnitName, LevelName, MobileNumber, ParentBhaagID, ParentMahaanagarID, ParentMandalID,' +
          'ParentNagarID, ParentVibhaagID, PreferredLanguageCode, PreferredLanguageID)  VALUES (' +
          data['AbhiyaDaayitvaID'].toString() +
          ',' +
          data['AbhiyanSwayamsevakID'].toString() +
          ',\'' +
          data['DaayityaName'].toString() +
          '\'' +
          ',\'' +
          data['Email'].toString() +
          '\'' +
          ',\'' +
          data['FullName'].toString() +
          '\'' +
          ',' +
          data['GeoUnitID'].toString() +
          ',\'' +
          data['GeoUnitName'].toString() +
          '\',\'' +
          data['LevelName'].toString() +
          '\',\'' +
          data['MobileNumber'].toString() +
          '\',' +
          data['ParentBhaagID'].toString() +
          ',' +
          data['ParentMahaanagarID'].toString() +
          ',' +
          data['ParentMandalID'].toString() +
          ',' +
          data['ParentNagarID'].toString() +
          ',' +
          data['ParentVibhaagID'].toString() +
          ',\'' +
          data['PreferredLanguageCode'].toString() +
          '\'' +
          ',' +
          data['PreferredLanguageID'].toString() +
          ' );';

      // log(sqlStr);
    } else if (tableName == 'HomeScreenData') {
      // Record not found, then insert
      sqlStr = 'INSERT INTO HomeScreenData( ShishuCount, BaalCount,	TarunVidyaarthiCount,	TarunVyavasayeeCount,	' +
          '	ProudhaVyavasayeeCount,	 UnknownAgeCount,	TrutiyaVarshaShikshitCount,	DwitiyaVarshaShikshitCount,	' +
          '	PrathamVarshaShikshitCount,	PraathamikShikshitCount, NoShikshanCount,	ShaakhaaKaaryakartaaCount,	' +
          ' VastiKaaryakartaaCount, GraamKaaryakartaaCount,	MandalKaaryakartaaCount, NagarKaaryakartaaCount, ' +
          ' ShaharKaaryakartaaCount, BhaagKaaryakartaaCount, VibhaagKaaryakartaaCount, MahaanagarKaaryakartaaCount,	' +
          ' PraantKaaryakartaaCount,	KshetraKaaryakartaaCount,	PravaseeKaaryakartaaCount,	' +
          ' GatividhiKaaryakartaaCount, AayaamKaaryakartaaCount,  SanghaPreritSansthaaKaaryakartaaCount,' +
          ' TotalKaaryakartaaCount , SocialOrganizationKaaryakartaaCount , PratidnyitCount ,Notificationcount) VALUES (' +
          data['ShishuCount'].toString() +
          ',' +
          data['BaalCount'].toString() +
          ',' +
          data['TarunVidyaarthiCount'].toString() +
          ',' +
          data['TarunVyavasaayeeCount'].toString() +
          ',' +
          data['ProudhaVyavasaayeeCount'].toString() +
          ',' +
          data['UnknownAgeCount'].toString() +
          ',' +
          data['TrutiyaVarshaShikshitCount'].toString() +
          ',' +
          data['DwitiyaVarshaShikshitCount'].toString() +
          ',' +
          data['PrathamVarshaShikshitCount'].toString() +
          ',' +
          data['PraathamikShikshitCount'].toString() +
          ',' +
          data['NoShikshanCount'].toString() +
          ',' +
          data['ShaakhaaKaaryakartaaCount'].toString() +
          ',' +
          data['VastiKaaryakartaaCount'].toString() +
          ',' +
          data['GraamKaaryakartaaCount'].toString() +
          ',' +
          data['MandalKaaryakartaaCount'].toString() +
          ',' +
          data['NagarKaaryakartaaCount'].toString() +
          ',' +
          data['ShaharKaaryakartaaCount'].toString() +
          ',' +
          data['BhaagKaaryakartaaCount'].toString() +
          ',' +
          data['VibhaagKaaryakartaaCount'].toString() +
          ',' +
          data['MahaanagarKaaryakartaaCount'].toString() +
          ',' +
          data['PraantKaaryakartaaCount'].toString() +
          ',' +
          data['KshetraKaaryakartaaCount'].toString() +
          ',' +
          data['PravaaseeKaaryakartaaCount'].toString() +
          ',' +
          data['GatividhiKaaryakartaaCount'].toString() +
          ',' +
          data['AayaamKaaryakartaaCount'].toString() +
          ',' +
          data['SanghaPreritSansthaaKaaryakartaaCount'].toString() +
          ',' +
          data['TotalKaaryakartaaCount'].toString() +
          ',' +
          data['SocialOrganizationKaaryakartaaCount'].toString() +
          ',' +
          data['PratidnyitCount'].toString() +
          ',' +
          data['Notificationcount'].toString() +
          ');';
    }

    await db.execute(sqlStr);
  }

  static Future<void> dropCompleteDB() async {
    // Get the path to your database
    String dbPath = await getDatabasesPath();
    String path = '$dbPath/$_dbName';

    // Delete the database file
    await _database?.close();
    await deleteDatabase(path);
    print('Database deleted successfully!');

    _database = await initDatabase();
  }
}
