import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import './static_data.dart' as Statics;
import 'db_helper_ops.dart';

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
    // WidgetsFlutterBinding.ensureInitialized();
    var dataDir = "";
    if (Platform.isIOS) {
      var p = await getLibraryDirectory();
      dataDir = p.path;
    } else {
      dataDir = await getDatabasesPath();
    }
    print(dataDir);
    var dbPath = dataDir + '/' + _dbName;
    var database = await openDatabase(dbPath, version: _dbVersion, singleInstance: false, onUpgrade: (db, oldVersion, newVersion) async {
      log('initDatabase - database upgraded, oldVersion:' + oldVersion.toString() + '; newVersion:' + newVersion.toString());
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
          ' IsLoggedIn VARCHAR(10), IsPravaasiKaaryakartaa BOOL,ShowShakhaSaptaha INT,ShowPustika INT)');

      // db.execute('DROP TABLE IF EXISTS UserDataMaster');
      db.execute('CREATE TABLE IF NOT EXISTS OfflineConfigList(tablename VARCHAR(100),apiname VARCHAR(100),SyncVersion INT)');

      db.execute('''
  CREATE TABLE IF NOT EXISTS OfflineShaakhaPustika (
    pkid INT PRIMARY KEY, yearno INT, monthno INT, canupdate INT, karyakramname TEXT, vayogatname TEXT,
    subjecttext TEXT, filepath TEXT, karyakramid INT, urllink TEXT, vayogatid TEXT,
    mdate TEXT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS ShaakhaListMaster (
    ShaakhaaID INT , PraantID INT, GeoUnitID INT, GeoUnitName TEXT, FrequencyID INT, FrequencyCode TEXT, VayogatID INT,
    VayogatCode TEXT, IsSankalpit INT, ParentVastiID INT, ParentGraamID INT, ParentMandalID INT, ParentNagarID INT,
    ParentUpaNagarID INT, ParentBhaagID INT, DayNamesOfWeek TEXT, ModifiedDate TEXT,
    DaysOfWeek TEXT, DayOfMonth TEXT, Location TEXT, StartTimeStr TEXT, EndTimeStr TEXT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS VistarShaakhaListMaster (
    pkid INT, isnew INT, IsAnya INT, trail TEXT,
    ShaakhaaID INT , PraantID INT, GeoUnitID INT, GeoUnitName TEXT, FrequencyID INT, FrequencyCode TEXT, VayogatID INT,
    VayogatCode TEXT, IsSankalpit INT, ParentVastiID INT, ParentGraamID INT, ParentMandalID INT, ParentNagarID INT,
    ParentUpaNagarID INT, ParentBhaagID INT, DayNamesOfWeek TEXT, ModifiedDate TEXT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS ShaakhaVruttaMaster (
    pkid INT, ShaakhaaID INT, VruttaDate TEXT, ShishuCount INT, NewShishuCount INT, BaalVidyaarthiCount INT,
    NewBaalVidyaarthiCount INT, TarunVidyaarthiCount INT, NewTarunVidyaarthiCount INT, TarunVyavasaayeeCount INT,
    NewTarunVyavasaayeeCount INT, ProudhaVyavasaayeeCount INT, NewProudhaVyavasaayeeCount INT, matruskatiCount INT,
    newmatruskatiCount INT, totalCount INT, newtotalCount INT, AbhyaagatCount INT, IsOptionalShaaririk INT, IsOptionalOther INT,
    Remark TEXT, IsDoneDeepBreathing INT, IsDoneDandaPrahaar INT, IsDoneSooryaNamaskaar INT, IsDoneSanchalanAbhyaas INT,
    IsDoneSaanghikGeet INT, IsDoneAmrutaVachan INT, IsDoneSubhaashit INT, BoudhikDaysId INT, SewaDaysId TEXT, IsDoneUrdhvapad INT,
    IsDoneBoodhKatha INT, IsDoneBoudhikDays INT, IsDoneSewaDays INT, AnyaBoudhikDays TEXT, PravasiKaryakartaCount INT,
    AnyaPravasiKaryakartaCount INT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS VistarShaakhaVruttaMaster (
    pkid INT, ShaakhaaID INT, VruttaDate TEXT, ShishuCount INT, NewShishuCount INT, BaalVidyaarthiCount INT,
    NewBaalVidyaarthiCount INT, TarunVidyaarthiCount INT, NewTarunVidyaarthiCount INT, TarunVyavasaayeeCount INT,
    NewTarunVyavasaayeeCount INT, ProudhaVyavasaayeeCount INT, NewProudhaVyavasaayeeCount INT, matruskatiCount INT,
    newmatruskatiCount INT, totalCount INT, newtotalCount INT, AbhyaagatCount INT, IsOptionalShaaririk INT, IsOptionalOther INT,
    Remark TEXT, IsDoneDeepBreathing INT, IsDoneDandaPrahaar INT, IsDoneSooryaNamaskaar INT, IsDoneSanchalanAbhyaas INT,
    IsDoneSaanghikGeet INT, IsDoneAmrutaVachan INT, IsDoneSubhaashit INT, BoudhikDaysId INT, SewaDaysId TEXT, IsDoneUrdhvapad INT,
    IsDoneBoodhKatha INT, IsDoneBoudhikDays INT, IsDoneSewaDays INT, AnyaBoudhikDays TEXT, PravasiKaryakartaCount INT,
    AnyaPravasiKaryakartaCount INT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS MediaMaster (
    pkid INT, filepath TEXT, tablename TEXT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS MediaDownloadQueue (
  id INTEGER PRIMARY KEY AUTOINCREMENT, pkid INTEGER NOT NULL, tablename TEXT NOT NULL, remoteFilepath TEXT NOT NULL, localFilepath TEXT,
  taskId TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'pending', progress INTEGER NOT NULL DEFAULT 0, retryCount INTEGER NOT NULL DEFAULT 0,
  errorMessage TEXT, createdAt TEXT NOT NULL, updatedAt TEXT,
  UNIQUE(pkid, tablename)
);
''');

      if (oldVersion < 5) {
        await _ensureColumn(db, 'GeoUnitMaster', 'issankalpit', 'INT');
      }
    }, onCreate: (db, version) {
      print('initDatabase - database created; version:' + version.toString());

      db.execute(' CREATE TABLE LevelMaster(LevelID INT, PraantID INT, LevelName VARCHAR(50), ' + ' Hierarchy INT)');

      db.execute(' CREATE TABLE StaticMaster(StaticID INT, PraantID INT, EntityType VARCHAR(100), Code VARCHAR(100), ' +
          '   CodeForDisplay VARCHAR(100), DisplaySequence INT, ViewOnly INT, showAnnualBaithak VARCHAR(5), myear VARCHAR(10))');

      db.execute(' CREATE TABLE GeoUnitMaster(GeoUnitID INT, PraantID INT, GeoUnitName VARCHAR(200),NameForDisplay VARCHAR(200),' +
          ' LevelID INT, DisplaySequence INT, ' +
          '   HasGraaminKshetra BOOL, ParentKshetraID INT, ParentPraantID INT, ParentMahaanagarID INT, ' +
          '   ParentVibhaagID INT, ParentBhaagID INT, ParentNagarID INT, ParentShaharID INT, ' +
          '   ParentMandalID INT, ParentVastiID INT, ParentGraamID INT, ParentUpaNagarID INT, issankalpit INT)');

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
          ' IsLoggedIn VARCHAR(10), IsPravaasiKaaryakartaa BOOL,ShowShakhaSaptaha INT,ShowPustika INT)');

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

      db.execute('CREATE TABLE DropdownLevelMaster(LevelID INT,GeoUnitID INT,ParentMahaanagarID INT,ParentVibhaagID INT,ParentBhaagID INT,' +
          'ParentNagarID INT,ParentUpaNagarID INT,ParentMandalID INT,ParentGraamID INT,ParentVastiID INT,isvasti INT,ismandal INT)');

      db.execute('CREATE TABLE IF NOT EXISTS OfflineConfigList(tablename VARCHAR(100),apiname VARCHAR(100),SyncVersion INT)');

      db.execute('''
  CREATE TABLE IF NOT EXISTS OfflineShaakhaPustika (
    pkid INT PRIMARY KEY, yearno INT, monthno INT, canupdate INT, karyakramname TEXT, vayogatname TEXT,
    subjecttext TEXT, filepath TEXT, karyakramid INT, urllink TEXT, vayogatid TEXT,
    mdate TEXT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS ShaakhaListMaster (
    ShaakhaaID INT , PraantID INT, GeoUnitID INT, GeoUnitName TEXT, FrequencyID INT, FrequencyCode TEXT, VayogatID INT,
    VayogatCode TEXT, IsSankalpit INT, ParentVastiID INT, ParentGraamID INT, ParentMandalID INT, ParentNagarID INT,
    ParentUpaNagarID INT, ParentBhaagID INT, DayNamesOfWeek TEXT, ModifiedDate TEXT,
    DaysOfWeek TEXT, DayOfMonth TEXT, Location TEXT, StartTimeStr TEXT, EndTimeStr TEXT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS VistarShaakhaListMaster (
    pkid INT, isnew INT, IsAnya INT, trail TEXT,
    ShaakhaaID INT , PraantID INT, GeoUnitID INT, GeoUnitName TEXT, FrequencyID INT, FrequencyCode TEXT, VayogatID INT,
    VayogatCode TEXT, IsSankalpit INT, ParentVastiID INT, ParentGraamID INT, ParentMandalID INT, ParentNagarID INT,
    ParentUpaNagarID INT, ParentBhaagID INT, DayNamesOfWeek TEXT, ModifiedDate TEXT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS ShaakhaVruttaMaster (
    pkid INT, ShaakhaaID INT, VruttaDate TEXT, ShishuCount INT, NewShishuCount INT, BaalVidyaarthiCount INT,
    NewBaalVidyaarthiCount INT, TarunVidyaarthiCount INT, NewTarunVidyaarthiCount INT, TarunVyavasaayeeCount INT,
    NewTarunVyavasaayeeCount INT, ProudhaVyavasaayeeCount INT, NewProudhaVyavasaayeeCount INT, matruskatiCount INT,
    newmatruskatiCount INT, totalCount INT, newtotalCount INT, AbhyaagatCount INT, IsOptionalShaaririk INT, IsOptionalOther INT,
    Remark TEXT, IsDoneDeepBreathing INT, IsDoneDandaPrahaar INT, IsDoneSooryaNamaskaar INT, IsDoneSanchalanAbhyaas INT,
    IsDoneSaanghikGeet INT, IsDoneAmrutaVachan INT, IsDoneSubhaashit INT, BoudhikDaysId INT, SewaDaysId TEXT, IsDoneUrdhvapad INT,
    IsDoneBoodhKatha INT, IsDoneBoudhikDays INT, IsDoneSewaDays INT, AnyaBoudhikDays TEXT, PravasiKaryakartaCount INT,
    AnyaPravasiKaryakartaCount INT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS VistarShaakhaVruttaMaster (
    pkid INT, ShaakhaaID INT, VruttaDate TEXT, ShishuCount INT, NewShishuCount INT, BaalVidyaarthiCount INT,
    NewBaalVidyaarthiCount INT, TarunVidyaarthiCount INT, NewTarunVidyaarthiCount INT, TarunVyavasaayeeCount INT,
    NewTarunVyavasaayeeCount INT, ProudhaVyavasaayeeCount INT, NewProudhaVyavasaayeeCount INT, matruskatiCount INT,
    newmatruskatiCount INT, totalCount INT, newtotalCount INT, AbhyaagatCount INT, IsOptionalShaaririk INT, IsOptionalOther INT,
    Remark TEXT, IsDoneDeepBreathing INT, IsDoneDandaPrahaar INT, IsDoneSooryaNamaskaar INT, IsDoneSanchalanAbhyaas INT,
    IsDoneSaanghikGeet INT, IsDoneAmrutaVachan INT, IsDoneSubhaashit INT, BoudhikDaysId INT, SewaDaysId TEXT, IsDoneUrdhvapad INT,
    IsDoneBoodhKatha INT, IsDoneBoudhikDays INT, IsDoneSewaDays INT, AnyaBoudhikDays TEXT, PravasiKaryakartaCount INT,
    AnyaPravasiKaryakartaCount INT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS MediaMaster (
    pkid INT, filepath TEXT, tablename TEXT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS MediaDownloadQueue (
  id INTEGER PRIMARY KEY AUTOINCREMENT, pkid INTEGER NOT NULL, tablename TEXT NOT NULL, remoteFilepath TEXT NOT NULL, localFilepath TEXT,
  taskId TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'pending', progress INTEGER NOT NULL DEFAULT 0, retryCount INTEGER NOT NULL DEFAULT 0,
  errorMessage TEXT, createdAt TEXT NOT NULL, updatedAt TEXT,
  UNIQUE(pkid, tablename)
);
''');
    });
    return database;
  }

  static Future<void> _ensureColumn(
    Database db,
    String table,
    String column,
    String type,
  ) async {
    final info = await db.rawQuery('PRAGMA table_info($table)');
    final exists = info.any((c) => c['name'] == column);
    if (!exists) {
      await db.execute('ALTER TABLE $table ADD COLUMN $column $type');
      print('Patched $table.$column');
    }
  }

  static Future<void> _ensureTable(Database db, String createSql) async {
    // Extract table name defensively isn't reliable from raw SQL,
    // so just always use CREATE TABLE IF NOT EXISTS for full-table creation —
    // this part IS safe, it's only column-level changes that need ALTER TABLE.
    await db.execute(createSql);
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
      } else if (tableName == 'OfflineConfigList') {
        for (var data in dataList) {
          cnt = cnt + 1;
          sqlStr = sqlStr +
              (cnt == 1 ? 'INSERT INTO OfflineConfigList(tablename, apiname, SyncVersion) VALUES ' : ',') +
              '(' +
              '\'' +
              data['tablename'].toString() +
              '\',\'' +
              data['apiname'].toString() +
              '\',' +
              data['SyncVersion'].toString() +
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
                      ' ParentShaharID, ParentMandalID, ParentGraamID, ParentVastiID, HasGraaminKshetra, ParentUpaNagarID, issankalpit) VALUES '
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
              ',' +
              (data['issankalpit'].toString()) +
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
                      ' BirthDate, LinkedGeoUnitHierarchy, IsFirstLogin, LastLoginTimeStamp, IsLoggedIn, IsPravaasiKaaryakartaa, ShowShakhaSaptaha, ShowPustika) VALUES '
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
              ',' +
              dataList['isvistaruser'].toString() +
              ',' +
              dataList['showpustika'].toString() +
              ')';
          log("sqlString:$sqlStr");
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
      } else if (tableName == 'DropdownLevelMaster') {
        // Record not found, then insert
        try {
          cnt = cnt + 1;
          sqlStr = sqlStr +
              (cnt == 1
                  ? 'INSERT INTO DropdownLevelMaster( LevelID, GeoUnitID,	ParentMahaanagarID,	ParentVibhaagID,	' +
                      '	ParentBhaagID,	 ParentNagarID,	ParentUpaNagarID,	ParentMandalID,	' +
                      '	ParentGraamID,	ParentVastiID,	isvasti,	ismandal) VALUES  '
                  : ',') +
              '(' +
              dataList['LevelID'].toString() +
              ',' +
              dataList['GeoUnitID'].toString() +
              ',' +
              dataList['ParentMahaanagarID'].toString() +
              ',' +
              dataList['ParentVibhaagID'].toString() +
              ',' +
              dataList['ParentBhaagID'].toString() +
              ',' +
              dataList['ParentNagarID'].toString() +
              ',' +
              dataList['ParentUpaNagarID'].toString() +
              ',' +
              dataList['ParentMandalID'].toString() +
              ',' +
              dataList['ParentGraamID'].toString() +
              ',' +
              dataList['ParentVastiID'].toString() +
              ',' +
              dataList['isvasti'].toString() +
              ',' +
              dataList['ismandal'].toString() +
              ');';
        } on Exception catch (e) {
          print(" -- DB Exception --  $e");
        }
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
    } else if (tableName == 'OfflineConfigList') {
      sqlStr = 'INSERT INTO OfflineConfigList(tablename, apiname, SyncVersion) VALUES (' +
          '\'' +
          data['tablename'].toString() +
          '\',\'' +
          data['apiname'].toString() +
          '\',' +
          data['SyncVersion'].toString() +
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
          ' ParentShaharID, ParentMandalID, ParentGraamID, ParentVastiID, HasGraaminKshetra, ParentUpaNagarID, issankalpit) VALUES (' +
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
          ',' +
          (data['issankalpit'].toString()) +
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
        print("checking");
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
            ', ShowShakhaSaptaha=' +
            data['isvistaruser'].toString() +
            ', ShowPustika=' +
            data['showpustika'].toString() +
            ' WHERE SwayamsevakID=' +
            data['SwayamsevakID'].toString() +
            ';';
      } else {
        // Record not found, then insert
        sqlStr = 'INSERT INTO UserDataMaster(SwayamsevakID, SwayamsevakDaayitvaID, PreferredLanguageID, ' +
            ' PreferredLanguageCode, PraantID, MobileNumber,LinkedVastiName,LinkedVastiID, LinkedShaakhaaName,' +
            ' LinkedShaakhaaID, LinkedGraamName, LinkedGraamID, LevelName, LevelID, FullName, ' +
            ' Email, DaayitvaStartYear, DaayitvaName, DaayitvaID, DaayitvaGeoUnitName, DaayitvaGeoUnitID, ' +
            ' BirthDate, LinkedGeoUnitHierarchy, IsFirstLogin, LastLoginTimeStamp, IsLoggedIn, IsPravaasiKaaryakartaa,ShowShakhaSaptaha,ShowPustika) VALUES (' +
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
            ',' +
            data['isvistaruser'].toString() +
            ',' +
            data['showpustika'].toString() +
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
    } else if (tableName == 'DropdownLevelMaster') {
      // Record not found, then insert
      try {
        sqlStr = 'INSERT INTO DropdownLevelMaster( LevelID, GeoUnitID,	ParentMahaanagarID,	ParentVibhaagID,	' +
            '	ParentBhaagID,	 ParentNagarID,	ParentUpaNagarID,	ParentMandalID,	' +
            '	ParentGraamID,	ParentVastiID,	isvasti,	ismandal) VALUES (' +
            data['LevelID'].toString() +
            ',' +
            data['GeoUnitID'].toString() +
            ',' +
            data['ParentMahaanagarID'].toString() +
            ',' +
            data['ParentVibhaagID'].toString() +
            ',' +
            data['ParentBhaagID'].toString() +
            ',' +
            data['ParentNagarID'].toString() +
            ',' +
            data['ParentUpaNagarID'].toString() +
            ',' +
            data['ParentMandalID'].toString() +
            ',' +
            data['ParentGraamID'].toString() +
            ',' +
            data['ParentVastiID'].toString() +
            ',' +
            data['isvasti'].toString() +
            ',' +
            data['ismandal'].toString() +
            ');';
      } on Exception catch (e) {
        print("exception$e");
      }
    }

    await db.execute(sqlStr);
  }

  static Future<T?> getOneOfflineData<T>({
    required String tableName,
    required T Function(Map<String, dynamic> map) fromMap,
    required String where,
    required List<Object?> whereArgs,
  }) async {
    Database db = await database;
    final rows = await db.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return fromMap(rows.first);
  }

  static Future<List<T>> getAllOfflineData<T>({
    required String tableName,
    required T Function(Map<String, dynamic> map) fromMap,
    String? orderBy,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    Database db = await database;
    final rows = await db.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
    return rows.map((row) => fromMap(row)).toList();
  }

  static Future<void> upsertByWhere<T>({
    required String tableName,
    required T item,
    required Map<String, dynamic> Function(T item) toMap,
    required String where,
    required List<Object?> whereArgs,
  }) async {
    Database db = await database;
    final map = toMap(item);

    final existing = await db.query(tableName, where: where, whereArgs: whereArgs, limit: 1);

    if (existing.isNotEmpty) {
      await db.update(tableName, map, where: where, whereArgs: whereArgs);
    } else {
      await db.insert(tableName, map);
    }
  }

  static Future<void> bulkUpsertPrimaryId<T>({
    required String tableName,
    required List<T> items,
    required Map<String, dynamic> Function(T item) toMap,
  }) async {
    Database db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final item in items) {
        batch.insert(
          tableName,
          toMap(item),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    });
  }

  static Future<void> bulkUpsertNonPrimaryId<T>({
    required String tableName,
    required List<T> items,
    required Map<String, dynamic> Function(T item) toMap,
    required List<String> keyColumns,
  }) async {
    Database db = await database;

    final tableColumns = await _getTableColumns(db, tableName);

    // Fail fast if the key columns you rely on for matching don't even exist.
    for (final key in keyColumns) {
      if (!tableColumns.contains(key)) {
        // throw ArgumentError('Key column "$key" not found in table "$tableName".');
        log('Key column "$key" not found in table "$tableName".');
      }
    }

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final item in items) {
        final map = _filterToTableColumns(toMap(item), tableColumns);

        // Validate keys
        for (final key in keyColumns) {
          if (!map.containsKey(key) || map[key] == null) {
            throw Exception(
              '$key is required for table $tableName',
            );
          }
        }

        // Build WHERE dynamically
        final where = keyColumns.map((key) => '$key = ?').join(' AND ');

        final whereArgs = keyColumns.map((key) => map[key]).toList();

        // Check if record exists
        final existing = await txn.query(
          tableName,
          columns: keyColumns,
          where: where,
          whereArgs: whereArgs,
          limit: 1,
        );

        if (existing.isNotEmpty) {
          // UPDATE
          batch.update(
            tableName,
            map,
            where: where,
            whereArgs: whereArgs,
          );
        } else {
          // INSERT
          batch.insert(
            tableName,
            map,
          );
        }
      }

      await batch.commit(noResult: true);
    });
  }

  static Future<int> updateSyncVersion({
    required String tableName,
    required int syncVersion,
  }) async {
    Database db = await database;
    return await db.update(
      'OfflineConfigList',
      {
        'SyncVersion': syncVersion,
      },
      where: 'tablename = ?',
      whereArgs: [tableName],
    );
  }

  static Future<int> getLocalSyncVersion(String tableName) async {
    final db = await database;

    final result = await db.query(
      'OfflineConfigList',
      columns: ['SyncVersion'],
      where: 'tablename = ?',
      whereArgs: [tableName],
      limit: 1,
    );

    if (result.isEmpty) {
      return 0;
    }

    return (result.first['SyncVersion'] as int?) ?? 0;
  }

  static Future<void> dropCompleteDB() async {
    String dbPath = await getDatabasesPath();
    String path = '$dbPath/$_dbName';

    // 1. Ensure the database is closed safely
    if (_database != null && _database!.isOpen) {
      await _database!.close();
    }

    // 2. Nullify the reference so no background processes can use it
    _database = null;

    // 3. Delete the file
    await deleteDatabase(path);
    print('Database deleted successfully!');

    // 4. Re-initialize
    _database = await initDatabase();
  }

  static Future<void> forcePurgeDatabase() async {
    try {
      final String dataDir = Platform.isIOS ? (await getLibraryDirectory()).path : await getDatabasesPath();
      final String path = '$dataDir/$_dbName';

      // Close every connection we can reach. With singleInstance:false in play
      // historically, there may be more than one native handle open — but
      // going forward we should only ever have one (see step 2).
      try {
        final db = await openDatabase(path);
        await db.close();
      } catch (_) {}

      // sqflite's official delete — closes its own cached instance too.
      await databaseFactory.deleteDatabase(path);

      // iOS WAL residue cleanup — this is the piece that was almost certainly
      // missing before and is why old data kept resurfacing.
      for (final suffix in ['-wal', '-shm', '-journal']) {
        final f = File('$path$suffix');
        if (await f.exists()) await f.delete();
      }

      print('Database file + WAL residue deleted cleanly.');
    } catch (e) {
      print('Error while force-deleting database: $e');
    }
  }

  /// NEW FUNCTIONS
  // ── internal helpers ─────────────────────────────────────────────────

  static final Map<String, Set<String>> _tableColumnsCache = {};

  static Future<Set<String>> _getTableColumns(Database db, String tableName) async {
    final cached = _tableColumnsCache[tableName];
    if (cached != null) return cached;

    final rows = await db.rawQuery('PRAGMA table_info($tableName)');

    final columns = rows.map((r) => r['name'] as String).toSet();
    _tableColumnsCache[tableName] = columns;
    return columns;
  }

  static Map<String, dynamic> _filterToTableColumns(
    Map<String, dynamic> map,
    Set<String> tableColumns,
  ) {
    final filtered = <String, dynamic>{};
    for (final entry in map.entries) {
      if (!tableColumns.contains(entry.key)) continue;
      filtered[entry.key] = _coerceValue(entry.value);
    }
    // else: silently drop (or log if you want visibility into backend drift)
    return filtered;
  }

  static dynamic _coerceValue(dynamic value) {
    if (value is bool) return value ? 1 : 0;
    return value; // int, String, null pass through unchanged
  }

  static void _validateKeys(Map<String, dynamic> map, List<String> keyColumns, String tableName) {
    for (final key in keyColumns) {
      if (!map.containsKey(key) || map[key] == null) {
        throw ArgumentError('Missing/null key "$key" for table "$tableName"');
      }
    }
  }

  static String _buildWhere(List<String> keyColumns) => keyColumns.map((k) => '$k = ?').join(' AND ');

  static List<Object?> _buildWhereArgs(Map<String, dynamic> map, List<String> keyColumns) => keyColumns.map((k) => map[k]).toList();

  // ── SINGLE ROW OPS ──────────────────────────────────────────────────

  /// Strict create. Throws (via sqflite) if a row with the same key(s)
  /// already exists and `hasUniqueConstraint` is true. If
  /// `hasUniqueConstraint` is false, this checks manually first and
  /// throws a [StateError] on duplicate, since there's no DB-level
  /// constraint to enforce it.
  static Future<DbOperationResult> insertOne<T>({
    required String tableName,
    required T item,
    required Map<String, dynamic> Function(T item) toMap,
    required List<String> keyColumns,
    required bool hasUniqueConstraint,
  }) async {
    final db = await database;

    final tableColumns = await _getTableColumns(db, tableName);

    // Fail fast if the key columns you rely on for matching don't even exist.
    for (final key in keyColumns) {
      if (!tableColumns.contains(key)) {
        // throw ArgumentError('Key column "$key" not found in table "$tableName".');
        log('Key column "$key" not found in table "$tableName".');
      }
    }

    final map = _filterToTableColumns(toMap(item), tableColumns);
    _validateKeys(map, keyColumns, tableName);

    if (hasUniqueConstraint) {
      await db.insert(tableName, map, conflictAlgorithm: ConflictAlgorithm.fail);
      return const DbOperationResult(inserted: 1);
    }

    final where = _buildWhere(keyColumns);
    final whereArgs = _buildWhereArgs(map, keyColumns);
    final existing = await db.query(tableName, columns: keyColumns, where: where, whereArgs: whereArgs, limit: 1);
    if (existing.isNotEmpty) {
      throw StateError('Row already exists in $tableName for keys $keyColumns = $whereArgs');
    }
    await db.insert(tableName, map);
    return const DbOperationResult(inserted: 1);
  }

  /// Insert only if not already present; no-op (skipped) if it exists.
  /// Never overwrites existing data.
  static Future<DbOperationResult> insertOrSkipOne<T>({
    required String tableName,
    required T item,
    required Map<String, dynamic> Function(T item) toMap,
    required List<String> keyColumns,
    required bool hasUniqueConstraint,
  }) async {
    final db = await database;

    final tableColumns = await _getTableColumns(db, tableName);

    // Fail fast if the key columns you rely on for matching don't even exist.
    for (final key in keyColumns) {
      if (!tableColumns.contains(key)) {
        // throw ArgumentError('Key column "$key" not found in table "$tableName".');
        log('Key column "$key" not found in table "$tableName".');
      }
    }

    final map = _filterToTableColumns(toMap(item), tableColumns);
    _validateKeys(map, keyColumns, tableName);

    if (hasUniqueConstraint) {
      final rowId = await db.insert(tableName, map, conflictAlgorithm: ConflictAlgorithm.ignore);
      // sqflite returns 0 (or the pre-existing rowid on some platforms)
      // when ConflictAlgorithm.ignore skips a row — treat non-positive
      // as "skipped" to be safe across platform differences.
      return rowId > 0 ? const DbOperationResult(inserted: 1) : const DbOperationResult(skipped: 1);
    }

    final where = _buildWhere(keyColumns);
    final whereArgs = _buildWhereArgs(map, keyColumns);
    final existing = await db.query(tableName, columns: keyColumns, where: where, whereArgs: whereArgs, limit: 1);
    if (existing.isNotEmpty) {
      return const DbOperationResult(skipped: 1);
    }
    await db.insert(tableName, map);
    return const DbOperationResult(inserted: 1);
  }

  /// Update only if the row exists; no-op (skipped) if it doesn't.
  /// Never creates a new row.
  static Future<DbOperationResult> updateOne<T>({
    required String tableName,
    required T item,
    required Map<String, dynamic> Function(T item) toMap,
    required List<String> keyColumns,
  }) async {
    final db = await database;

    final tableColumns = await _getTableColumns(db, tableName);

    // Fail fast if the key columns you rely on for matching don't even exist.
    for (final key in keyColumns) {
      if (!tableColumns.contains(key)) {
        // throw ArgumentError('Key column "$key" not found in table "$tableName".');
        log('Key column "$key" not found in table "$tableName".');
      }
    }

    final map = _filterToTableColumns(toMap(item), tableColumns);
    _validateKeys(map, keyColumns, tableName);

    final where = _buildWhere(keyColumns);
    final whereArgs = _buildWhereArgs(map, keyColumns);
    final rowsAffected = await db.update(tableName, map, where: where, whereArgs: whereArgs);
    return rowsAffected > 0 ? DbOperationResult(updated: rowsAffected) : const DbOperationResult(skipped: 1);
  }

  /// True upsert: insert if new, update if it already exists.
  /// Works for both PK-backed and non-PK-backed (keyColumns-only) tables.
  static Future<DbOperationResult> upsertOne<T>({
    required String tableName,
    required T item,
    required Map<String, dynamic> Function(T item) toMap,
    required List<String> keyColumns,
    required bool hasUniqueConstraint,
  }) async {
    final db = await database;

    final tableColumns = await _getTableColumns(db, tableName);

    // Fail fast if the key columns you rely on for matching don't even exist.
    for (final key in keyColumns) {
      if (!tableColumns.contains(key)) {
        // throw ArgumentError('Key column "$key" not found in table "$tableName".');
        log('Key column "$key" not found in table "$tableName".');
      }
    }

    final map = _filterToTableColumns(toMap(item), tableColumns);
    _validateKeys(map, keyColumns, tableName);

    if (hasUniqueConstraint) {
      // Fast path — can't distinguish insert vs update without an extra
      // query, so both are reported as `inserted` (agreed trade-off).
      await db.insert(tableName, map, conflictAlgorithm: ConflictAlgorithm.replace);
      return const DbOperationResult(inserted: 1);
    }

    final where = _buildWhere(keyColumns);
    final whereArgs = _buildWhereArgs(map, keyColumns);
    final existing = await db.query(tableName, columns: keyColumns, where: where, whereArgs: whereArgs, limit: 1);

    if (existing.isNotEmpty) {
      await db.update(tableName, map, where: where, whereArgs: whereArgs);
      return const DbOperationResult(updated: 1);
    }
    await db.insert(tableName, map);
    return const DbOperationResult(inserted: 1);
  }

  /// Delete a single row by its key column(s).
  static Future<DbOperationResult> deleteOne({
    required String tableName,
    required List<String> keyColumns,
    required List<Object?> keyValues,
  }) async {
    if (keyColumns.length != keyValues.length) {
      throw ArgumentError('keyColumns and keyValues must be the same length for table $tableName');
    }
    final db = await database;
    final where = _buildWhere(keyColumns);
    final rowsAffected = await db.delete(tableName, where: where, whereArgs: keyValues);
    return rowsAffected > 0 ? DbOperationResult(deleted: rowsAffected) : const DbOperationResult(skipped: 1);
  }

  // ── BULK OPS ─────────────────────────────────────────────────────────
  //
  // All bulk ops:
  // - run inside one db.transaction
  // - use Batch for the fast (hasUniqueConstraint = true) path
  // - catch per-item errors and count them in `failed` rather than
  //   aborting the whole transaction

  /// Bulk insert-or-skip. Never overwrites existing rows.
  static Future<DbOperationResult> bulkInsertOrSkip<T>({
    required String tableName,
    required List<T> items,
    required Map<String, dynamic> Function(T item) toMap,
    required List<String> keyColumns,
    required bool hasUniqueConstraint,
  }) async {
    final db = await database;
    var result = const DbOperationResult();

    final tableColumns = await _getTableColumns(db, tableName);

    // Fail fast if the key columns you rely on for matching don't even exist.
    for (final key in keyColumns) {
      if (!tableColumns.contains(key)) {
        // throw ArgumentError('Key column "$key" not found in table "$tableName".');
        log('Key column "$key" not found in table "$tableName".');
      }
    }

    await db.transaction((txn) async {
      if (hasUniqueConstraint) {
        final batch = txn.batch();
        var validCount = 0;
        for (final item in items) {
          try {
            final map = _filterToTableColumns(toMap(item), tableColumns);
            _validateKeys(map, keyColumns, tableName);
            batch.insert(tableName, map, conflictAlgorithm: ConflictAlgorithm.ignore);
            validCount++;
          } catch (_) {
            result += const DbOperationResult(failed: 1);
          }
        }
        if (validCount > 0) {
          final results = await batch.commit();
          // Each result is the rowid inserted, or 0 when ignored (skip).
          for (final r in results) {
            final rowId = r as int? ?? 0;
            result += rowId > 0 ? const DbOperationResult(inserted: 1) : const DbOperationResult(skipped: 1);
          }
        }
        return;
      }

      // Manual path — no unique constraint to lean on.
      for (final item in items) {
        try {
          final map = _filterToTableColumns(toMap(item), tableColumns);
          _validateKeys(map, keyColumns, tableName);
          final where = _buildWhere(keyColumns);
          final whereArgs = _buildWhereArgs(map, keyColumns);
          final existing = await txn.query(tableName, columns: keyColumns, where: where, whereArgs: whereArgs, limit: 1);
          if (existing.isNotEmpty) {
            result += const DbOperationResult(skipped: 1);
          } else {
            await txn.insert(tableName, map);
            result += const DbOperationResult(inserted: 1);
          }
        } catch (_) {
          result += const DbOperationResult(failed: 1);
        }
      }
    });

    return result;
  }

  /// Bulk update. Rows that don't already exist are skipped, not created.
  static Future<DbOperationResult> bulkUpdate<T>({
    required String tableName,
    required List<T> items,
    required Map<String, dynamic> Function(T item) toMap,
    required List<String> keyColumns,
  }) async {
    final db = await database;
    var result = const DbOperationResult();

    final tableColumns = await _getTableColumns(db, tableName);

    // Fail fast if the key columns you rely on for matching don't even exist.
    for (final key in keyColumns) {
      if (!tableColumns.contains(key)) {
        // throw ArgumentError('Key column "$key" not found in table "$tableName".');
        log('Key column "$key" not found in table "$tableName".');
      }
    }

    await db.transaction((txn) async {
      final batch = txn.batch();
      final validItems = <Map<String, dynamic>>[];

      for (final item in items) {
        try {
          final map = _filterToTableColumns(toMap(item), tableColumns);
          _validateKeys(map, keyColumns, tableName);
          validItems.add(map);
        } catch (_) {
          result += const DbOperationResult(failed: 1);
        }
      }

      for (final map in validItems) {
        final where = _buildWhere(keyColumns);
        final whereArgs = _buildWhereArgs(map, keyColumns);
        batch.update(tableName, map, where: where, whereArgs: whereArgs);
      }

      if (validItems.isNotEmpty) {
        final results = await batch.commit();
        for (final r in results) {
          final rowsAffected = r as int? ?? 0;
          result += rowsAffected > 0 ? DbOperationResult(updated: rowsAffected) : const DbOperationResult(skipped: 1);
        }
      }
    });

    return result;
  }

  /// Bulk true upsert. Works for both PK-backed and non-PK-backed tables.
  /// See file header for the accuracy/speed trade-off between the two.
  static Future<DbOperationResult> bulkUpsert<T>({
    required String tableName,
    required List<T> items,
    required Map<String, dynamic> Function(T item) toMap,
    required List<String> keyColumns,
    required bool hasUniqueConstraint,
  }) async {
    final db = await database;
    var result = const DbOperationResult();

    final tableColumns = await _getTableColumns(db, tableName);

    // Fail fast if the key columns you rely on for matching don't even exist.
    for (final key in keyColumns) {
      if (!tableColumns.contains(key)) {
        // throw ArgumentError('Key column "$key" not found in table "$tableName".');
        log('Key column "$key" not found in table "$tableName".');
      }
    }

    await db.transaction((txn) async {
      if (hasUniqueConstraint) {
        final batch = txn.batch();
        var queuedCount = 0;
        for (final item in items) {
          try {
            final map = _filterToTableColumns(toMap(item), tableColumns);
            _validateKeys(map, keyColumns, tableName);
            batch.insert(tableName, map, conflictAlgorithm: ConflictAlgorithm.replace);
            queuedCount++;
          } catch (_) {
            result += const DbOperationResult(failed: 1);
          }
        }
        if (queuedCount > 0) {
          await batch.commit(noResult: true);
          // Fast path cannot distinguish insert vs update per row.
          result += DbOperationResult(inserted: queuedCount);
        }
        return;
      }

      // Manual path — accurate inserted/updated split.
      for (final item in items) {
        try {
          final map = _filterToTableColumns(toMap(item), tableColumns);
          _validateKeys(map, keyColumns, tableName);
          final where = _buildWhere(keyColumns);
          final whereArgs = _buildWhereArgs(map, keyColumns);
          final existing = await txn.query(tableName, columns: keyColumns, where: where, whereArgs: whereArgs, limit: 1);
          if (existing.isNotEmpty) {
            await txn.update(tableName, map, where: where, whereArgs: whereArgs);
            result += const DbOperationResult(updated: 1);
          } else {
            await txn.insert(tableName, map);
            result += const DbOperationResult(inserted: 1);
          }
        } catch (_) {
          result += const DbOperationResult(failed: 1);
        }
      }
    });

    return result;
  }

  // ── DELETE / TRUNCATE ────────────────────────────────────────────────

  /// Delete rows matching an arbitrary condition.
  static Future<DbOperationResult> deleteWhere({
    required String tableName,
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final db = await database;
    final rowsAffected = await db.delete(tableName, where: where, whereArgs: whereArgs);
    return DbOperationResult(deleted: rowsAffected);
  }

  /// Delete all rows in a table. Does NOT reset AUTOINCREMENT sequence
  /// (matches SQLite's own DELETE FROM semantics — SQLite has no TRUNCATE
  /// statement; DELETE FROM without WHERE is the standard equivalent).
  static Future<DbOperationResult> truncateTable({required String tableName}) async {
    final db = await database;
    final rowsAffected = await db.delete(tableName);
    return DbOperationResult(deleted: rowsAffected);
  }

  /// Wipe the table and reload it from `items`, atomically. If the insert
  /// half fails partway, the transaction rolls back entirely — you will
  /// NOT end up with an empty table. This is the one operation in this
  /// file where a failure aborts everything rather than being skipped,
  /// because a partial reload (some old data deleted, only some new data
  /// inserted) is worse than no reload at all.
  static Future<DbOperationResult> replaceAllData<T>({
    required String tableName,
    required List<T> items,
    required Map<String, dynamic> Function(T item) toMap,
  }) async {
    final db = await database;
    var deletedCount = 0;
    var insertedCount = 0;

    await db.transaction((txn) async {
      deletedCount = await txn.delete(tableName);

      final batch = txn.batch();
      for (final item in items) {
        batch.insert(tableName, toMap(item));
      }
      if (items.isNotEmpty) {
        await batch.commit(noResult: true);
      }
      insertedCount = items.length;
    });
    // If anything above throws, db.transaction rolls back automatically
    // and the exception propagates to the caller — intentionally NOT
    // caught here, per the all-or-nothing requirement for this op.

    return DbOperationResult(deleted: deletedCount, inserted: insertedCount);
  }
}
