import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

import './static_data.dart' as Statics;
import 'db_helper_ops.dart';

class DatabaseHelper {
  static final _dbName = 'NiyojakProd.db';
  static final _dbVersion = int.parse(Statics.dbVersion);

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static final _lock = Lock();

  static Future<T> runExclusive<T>(Future<T> Function() action) {
    return _lock.synchronized(action);
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
    var database = await openDatabase(dbPath, version: _dbVersion, singleInstance: false, onConfigure: (db) async {
      await db.rawQuery('PRAGMA busy_timeout = 3000'); // wait up to 3s
    }, onUpgrade: (db, oldVersion, newVersion) async {
      log('initDatabase - database upgraded, oldVersion:' + oldVersion.toString() + '; newVersion:' + newVersion.toString());

      db.execute('CREATE TABLE IF NOT EXISTS HomeScreenData(ShishuCount INT, BaalCount INT, TarunVidyaarthiCount INT,' +
          ' TarunVyavasayeeCount INT, ProudhaVyavasayeeCount INT, UnknownAgeCount INT, TrutiyaVarshaShikshitCount INT,' +
          ' DwitiyaVarshaShikshitCount INT, PrathamVarshaShikshitCount INT, PraathamikShikshitCount INT, NoShikshanCount INT, ' +
          ' ShaakhaaKaaryakartaaCount INT, VastiKaaryakartaaCount INT, GraamKaaryakartaaCount INT, MandalKaaryakartaaCount INT,' +
          ' NagarKaaryakartaaCount INT, ShaharKaaryakartaaCount INT, BhaagKaaryakartaaCount INT, VibhaagKaaryakartaaCount INT, ' +
          ' MahaanagarKaaryakartaaCount INT, PraantKaaryakartaaCount INT, KshetraKaaryakartaaCount INT,' +
          ' PravaseeKaaryakartaaCount INT, GatividhiKaaryakartaaCount INT, AayaamKaaryakartaaCount INT,' +
          ' SanghaPreritSansthaaKaaryakartaaCount INT,TotalKaaryakartaaCount INT,' +
          ' SocialOrganizationKaaryakartaaCount INT, PratidnyitCount INT, Notificationcount INT)');

      db.execute('CREATE TABLE IF NOT EXISTS UserDataMaster(SwayamsevakID INT, SwayamsevakDaayitvaID INT,PreferredLanguageID INT,' +
          ' PreferredLanguageCode VARCHAR(100),PraantID INT,MobileNumber VARCHAR(15),LinkedVastiName VARCHAR(100),' +
          ' LinkedVastiID INT,LinkedShaakhaaName VARCHAR(500),LinkedShaakhaaID INT,LinkedGraamName VARCHAR(100),' +
          ' LinkedGraamID INT,LevelName VARCHAR(100),LevelID INT,' +
          ' FullName VARCHAR(300),Email VARCHAR(500),DaayitvaStartYear INT,DaayitvaName VARCHAR(200),' +
          ' DaayitvaID INT,DaayitvaGeoUnitName VARCHAR(100),DaayitvaGeoUnitID INT,BirthDate VARCHAR(20), ' +
          ' LinkedGeoUnitHierarchy VARCHAR(100), IsFirstLogin BOOL, LastLoginTimeStamp VARCHAR(30), ' +
          ' IsLoggedIn VARCHAR(10), IsPravaasiKaaryakartaa BOOL,ShowShakhaSaptaha INT,ShowPustika INT,isvistaruser INT)');

      db.execute('CREATE TABLE IF NOT EXISTS OfflineConfigList(tablename VARCHAR(100),apiname VARCHAR(100),SyncVersion INT)');

      db.execute('''
  CREATE TABLE IF NOT EXISTS OfflineShaakhaPustika (
    pkid INT PRIMARY KEY, yearno INT, monthno INT, canupdate INT, karyakramname TEXT, vayogatname TEXT,
    subjecttext TEXT, filepath TEXT, karyakramid INT, urllink TEXT, vayogatid TEXT,
    mdate TEXT, anyapath TEXT
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
    ParentUpaNagarID INT, ParentBhaagID INT, DayNamesOfWeek TEXT, ModifiedDate TEXT, mapShaakhaaID INT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS ShaakhaVruttaMaster (
    pkid INT PRIMARY KEY, ShaakhaaID INT, VruttaDate TEXT, ShishuCount INT, NewShishuCount INT, BaalVidyaarthiCount INT,
    NewBaalVidyaarthiCount INT, TarunVidyaarthiCount INT, NewTarunVidyaarthiCount INT, TarunVyavasaayeeCount INT,
    NewTarunVyavasaayeeCount INT, ProudhaVyavasaayeeCount INT, NewProudhaVyavasaayeeCount INT, matruskatiCount INT,
    newmatruskatiCount INT, totalCount INT, newtotalCount INT, AbhyaagatCount INT, IsOptionalShaaririk INT, IsOptionalOther INT,
    Remark TEXT, IsDoneDeepBreathing INT, IsDoneDandaPrahaar INT, IsDoneSooryaNamaskaar INT, IsDoneSanchalanAbhyaas INT,
    IsDoneSaanghikGeet INT, IsDoneAmrutaVachan INT, IsDoneSubhaashit INT, BoudhikDaysId INT, SewaDaysId TEXT, IsDoneUrdhvapad INT,
    IsDoneBoodhKatha INT, IsDoneBoudhikDays INT, IsDoneSewaDays INT, AnyaBoudhikDays TEXT, PravasiKaryakartaCount INT,
    AnyaPravasiKaryakartaCount INT, FrequencyID INT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS VistarShaakhaVruttaMaster (
    pkid INT PRIMARY KEY, ShaakhaaID INT, VruttaDate TEXT, ShishuCount INT, NewShishuCount INT, BaalVidyaarthiCount INT,
    NewBaalVidyaarthiCount INT, TarunVidyaarthiCount INT, NewTarunVidyaarthiCount INT, TarunVyavasaayeeCount INT,
    NewTarunVyavasaayeeCount INT, ProudhaVyavasaayeeCount INT, NewProudhaVyavasaayeeCount INT, matruskatiCount INT,
    newmatruskatiCount INT, totalCount INT, newtotalCount INT, AbhyaagatCount INT, IsOptionalShaaririk INT, IsOptionalOther INT,
    Remark TEXT, IsDoneDeepBreathing INT, IsDoneDandaPrahaar INT, IsDoneSooryaNamaskaar INT, IsDoneSanchalanAbhyaas INT,
    IsDoneSaanghikGeet INT, IsDoneAmrutaVachan INT, IsDoneSubhaashit INT, BoudhikDaysId INT, SewaDaysId TEXT, IsDoneUrdhvapad INT,
    IsDoneBoodhKatha INT, IsDoneBoudhikDays INT, IsDoneSewaDays INT, AnyaBoudhikDays TEXT, PravasiKaryakartaCount INT,
    AnyaPravasiKaryakartaCount INT, FrequencyID INT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS MediaMaster (
    pkid INT, filepath TEXT, tablename TEXT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS SewaSanskarData (
    GroupId INT, StaticID INT, name TEXT
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

      db.execute('''
  CREATE TABLE IF NOT EXISTS VruttaDraftMaster (
    UniqueKey INTEGER PRIMARY KEY AUTOINCREMENT, PraantID INT, ShaakhaaID INT, pkid INT, VruttaDate TEXT, ShishuCount INT,
    NewShishuCount INT, BaalVidyaarthiCount INT, NewBaalVidyaarthiCount INT, TarunVidyaarthiCount INT, NewTarunVidyaarthiCount INT,
    TarunVyavasaayeeCount INT, NewTarunVyavasaayeeCount INT, ProudhaVyavasaayeeCount INT, NewProudhaVyavasaayeeCount INT,
    matruskatiCount INT, newmatruskatiCount INT, totalCount INT, newtotalCount INT, AbhyaagatCount INT, IsDoneDeepBreathing INT, 
    IsDoneDandaPrahaar INT, IsDoneSooryaNamaskaar INT, IsDoneSanchalanAbhyaas INT, IsDoneSaanghikGeet INT, IsDoneAmrutaVachan INT, 
    IsDoneSubhaashit INT, IsOptionalShaaririk INT, IsOptionalOther INT, Remark TEXT, ModifiedBy INT, PravasiKaryakartaCount INT, 
    AnyaPravasiKaryakartaCount INT, BoudhikDaysId INT, SewaDaysId TEXT, AnyaBoudhikDays TEXT, IsDoneUrdhvapad INT, IsDoneBoodhKatha INT, 
    IsDoneBoudhikDays INT, IsDoneSewaDays INT, tablename TEXT NOT NULL, isdraft INTEGER NOT NULL DEFAULT 1
    ,UNIQUE(ShaakhaaID, VruttaDate, tablename)
);
''');

      if (oldVersion < 7) {
        await _ensureColumn(db, 'GeoUnitMaster', 'issankalpit', 'INT');
        await _ensureColumn(db, 'GeoUnitMaster', 'canEdit', 'INT');
        await _ensureColumn(db, 'GeoUnitMaster', 'GeoUnitNameEnglish', 'TEXT');
        await _ensureColumn(db, 'GeoUnitMaster', 'GeoUnitNameMarathi', 'TEXT');
        await _ensureColumn(db, 'GeoUnitMaster', 'GeoUnitNameHindi', 'TEXT');
        await _ensureColumn(db, 'UserDataMaster', 'isvistaruser', 'INT');
        await _ensureColumn(db, 'UserDataMaster', 'vayogatid', 'INT');
        await _ensureColumn(db, 'UserDataMaster', 'vayogatname', 'TEXT');
        await _ensureColumn(db, 'VistarShaakhaListMaster', 'mapShaakhaaID', 'INT');
      }
    }, onCreate: (db, version) {
      print('initDatabase - database created; version:' + version.toString());

      db.execute(' CREATE TABLE LevelMaster(LevelID INTEGER PRIMARY KEY, PraantID INT, LevelName VARCHAR(50), ' + ' Hierarchy INT)');

      db.execute(' CREATE TABLE StaticMaster(StaticID INTEGER PRIMARY KEY, PraantID INT, EntityType VARCHAR(100), Code VARCHAR(100), ' +
          '   CodeForDisplay VARCHAR(100), DisplaySequence INT, ViewOnly INT, showAnnualBaithak VARCHAR(5), myear VARCHAR(10))');

      db.execute(' CREATE TABLE GeoUnitMaster(GeoUnitID INTEGER PRIMARY KEY, PraantID INT, GeoUnitName VARCHAR(200),NameForDisplay VARCHAR(200),' +
          ' LevelID INT, DisplaySequence INT, ' +
          '   HasGraaminKshetra BOOL, ParentKshetraID INT, ParentPraantID INT, ParentMahaanagarID INT, ' +
          '   ParentVibhaagID INT, ParentBhaagID INT, ParentNagarID INT, ParentShaharID INT, ' +
          '   ParentMandalID INT, ParentVastiID INT, ParentGraamID INT, ParentUpaNagarID INT, issankalpit INT, ' +
          '   canEdit INT, GeoUnitNameEnglish TEXT, GeoUnitNameMarathi TEXT, GeoUnitNameHindi TEXT)');

      db.execute(' CREATE TABLE SwayamsevakMaster(SwayamsevakID INT, FullName VARCHAR(50), MobileNumber VARCHAR(10), LinkedGeoUnitID INT, AppPassword VARCHAR(20), PreferredLanguageID INT)');
      db.execute(' CREATE TABLE DaayitvaMaster(DaayitvaID INTEGER PRIMARY KEY, PraantID INT, DaayitvaName VARCHAR(50), DaayitvaForID INT, ' + '   IsPravaasiDaayitva BIT)');
      db.execute(' CREATE TABLE StateMaster(StateID INTEGER PRIMARY KEY, GSTStateCode VARCHAR(5), Code VARCHAR(10), StateName VARCHAR(50))');
      db.execute(' CREATE TABLE GatividhiMaster(GatividhiID INTEGER PRIMARY KEY, PraantID INT, GatividhiName VARCHAR(200))');
      db.execute(' CREATE TABLE AayaamMaster(AayaamID INTEGER PRIMARY KEY, PraantID INT, AayaamName VARCHAR(200))');

      db.execute(' CREATE TABLE UserDataMaster(SwayamsevakID INT, SwayamsevakDaayitvaID INT,PreferredLanguageID INT,' +
          ' PreferredLanguageCode VARCHAR(100),PraantID INT,MobileNumber VARCHAR(15),LinkedVastiName VARCHAR(100),' +
          ' LinkedVastiID INT,LinkedShaakhaaName VARCHAR(500),LinkedShaakhaaID INT,LinkedGraamName VARCHAR(100),' +
          ' LinkedGraamID INT,LevelName VARCHAR(100),LevelID INT,' +
          ' FullName VARCHAR(300),Email VARCHAR(500),DaayitvaStartYear INT,DaayitvaName VARCHAR(200),' +
          ' DaayitvaID INT,DaayitvaGeoUnitName VARCHAR(100),DaayitvaGeoUnitID INT,BirthDate VARCHAR(20), ' +
          ' LinkedGeoUnitHierarchy VARCHAR(100), IsFirstLogin BOOL, LastLoginTimeStamp VARCHAR(30), ' +
          ' IsLoggedIn VARCHAR(10), IsPravaasiKaaryakartaa BOOL,ShowShakhaSaptaha INT,ShowPustika INT,isvistaruser INT,vayogatid INT,vayogatname TEXT)');

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

      db.execute(' CREATE TABLE AbhiyaanGeoUnitMaster(GeoUnitID INTEGER PRIMARY KEY, PraantID INT, GeoUnitName VARCHAR(200),NameForDisplay VARCHAR(200),' +
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
    mdate TEXT, anyapath TEXT
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
    ParentUpaNagarID INT, ParentBhaagID INT, DayNamesOfWeek TEXT, ModifiedDate TEXT, mapShaakhaaID INT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS ShaakhaVruttaMaster (
    pkid INT PRIMARY KEY, ShaakhaaID INT, VruttaDate TEXT, ShishuCount INT, NewShishuCount INT, BaalVidyaarthiCount INT,
    NewBaalVidyaarthiCount INT, TarunVidyaarthiCount INT, NewTarunVidyaarthiCount INT, TarunVyavasaayeeCount INT,
    NewTarunVyavasaayeeCount INT, ProudhaVyavasaayeeCount INT, NewProudhaVyavasaayeeCount INT, matruskatiCount INT,
    newmatruskatiCount INT, totalCount INT, newtotalCount INT, AbhyaagatCount INT, IsOptionalShaaririk INT, IsOptionalOther INT,
    Remark TEXT, IsDoneDeepBreathing INT, IsDoneDandaPrahaar INT, IsDoneSooryaNamaskaar INT, IsDoneSanchalanAbhyaas INT,
    IsDoneSaanghikGeet INT, IsDoneAmrutaVachan INT, IsDoneSubhaashit INT, BoudhikDaysId INT, SewaDaysId TEXT, IsDoneUrdhvapad INT,
    IsDoneBoodhKatha INT, IsDoneBoudhikDays INT, IsDoneSewaDays INT, AnyaBoudhikDays TEXT, PravasiKaryakartaCount INT,
    AnyaPravasiKaryakartaCount INT, FrequencyID INT
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
    AnyaPravasiKaryakartaCount INT, FrequencyID INT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS MediaMaster (
    pkid INT, filepath TEXT, tablename TEXT
  )
''');

      db.execute('''
  CREATE TABLE IF NOT EXISTS SewaSanskarData (
    GroupId INT, StaticID INT, name TEXT
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

      db.execute('''
  CREATE TABLE IF NOT EXISTS VruttaDraftMaster (
    UniqueKey INTEGER PRIMARY KEY AUTOINCREMENT, PraantID INT, ShaakhaaID INT, pkid INT, VruttaDate TEXT, ShishuCount INT,
    NewShishuCount INT, BaalVidyaarthiCount INT, NewBaalVidyaarthiCount INT, TarunVidyaarthiCount INT, NewTarunVidyaarthiCount INT,
    TarunVyavasaayeeCount INT, NewTarunVyavasaayeeCount INT, ProudhaVyavasaayeeCount INT, NewProudhaVyavasaayeeCount INT,
    matruskatiCount INT, newmatruskatiCount INT, totalCount INT, newtotalCount INT, AbhyaagatCount INT, IsDoneDeepBreathing INT, 
    IsDoneDandaPrahaar INT, IsDoneSooryaNamaskaar INT, IsDoneSanchalanAbhyaas INT, IsDoneSaanghikGeet INT, IsDoneAmrutaVachan INT, 
    IsDoneSubhaashit INT, IsOptionalShaaririk INT, IsOptionalOther INT, Remark TEXT, ModifiedBy INT, PravasiKaryakartaCount INT, 
    AnyaPravasiKaryakartaCount INT, BoudhikDaysId INT, SewaDaysId TEXT, AnyaBoudhikDays TEXT, IsDoneUrdhvapad INT, IsDoneBoodhKatha INT, 
    IsDoneBoudhikDays INT, IsDoneSewaDays INT, tablename TEXT NOT NULL, isdraft INTEGER NOT NULL DEFAULT 1
    ,UNIQUE(ShaakhaaID, VruttaDate, tablename)
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

  static Future<T?> getOneOfflineData<T>({
    required String tableName,
    required T Function(Map<String, dynamic> map) fromMap,
    required String? where,
    required List<Object?>? whereArgs,
  }) async {
    Database db = await database;
    log("getOneOfflineData >> calling from the table >>>>>> $tableName");
    if (where != null) log("getOneOfflineData >> with following conditions >>>>>>> $where");
    if (whereArgs != null) log("getOneOfflineData >> with following args >>>>>>> $whereArgs");
    final rows = await db.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
      limit: 1,
    );

    log("getOneOfflineData >> rows.firstOrNull >>>>> ${rows.firstOrNull}");

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
    log("calling from the table >>>>>> $tableName");
    if (where != null) log("with following conditions >>>>>>> $where");
    if (whereArgs != null) log("with following args >>>>>>> $whereArgs");
    final rows = await db.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
    log("rows.firstOrNull >>>>> ${rows.firstOrNull}");
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

    await runExclusive(() async {
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
    log(rowsAffected.toString());
    return DbOperationResult(deleted: rowsAffected);
  }

  /// Bulk delete — for the common case of one key column with a list of
  /// values (e.g. delete these 40 pkids). One query via `IN (...)`, not a
  /// loop — the efficient choice whenever your rows all key off a single
  /// column.
  static Future<DbOperationResult> deleteBulkByKeyIn({
    required String tableName,
    required String keyColumn,
    required List<Object?> keyValues,
  }) async {
    if (keyValues.isEmpty) return const DbOperationResult();
    final db = await database;
    final placeholders = List.filled(keyValues.length, '?').join(',');
    final rowsAffected = await db.delete(
      tableName,
      where: '$keyColumn IN ($placeholders)',
      whereArgs: keyValues,
    );
    log(rowsAffected.toString());
    return DbOperationResult(deleted: rowsAffected);
  }

  /*/// Bulk delete — for a list of ITEMS where each one's identity may span
  /// multiple key columns (composite keys), mirroring how bulkUpsert/
  /// bulkUpdate take `items` + `keyColumns`. Runs as one batched transaction
  /// rather than N sequential awaited deletes. Per-item failures are
  /// counted in `failed`, consistent with the other bulk ops — the whole
  /// transaction does not abort on one bad item.
  static Future<DbOperationResult> bulkDelete<T>({
    required String tableName,
    required List<T> items,
    required Map<String, dynamic> Function(T item) toMap,
    required List<String> keyColumns,
  }) async {
    final db = await database;
    var result = const DbOperationResult();

    await db.transaction((txn) async {
      final batch = txn.batch();
      var queuedCount = 0;

      for (final item in items) {
        try {
          final map = toMap(item);
          _validateKeys(map, keyColumns, tableName);
          final where = _buildWhere(keyColumns);
          final whereArgs = _buildWhereArgs(map, keyColumns);
          batch.delete(tableName, where: where, whereArgs: whereArgs);
          queuedCount++;
        } catch (_) {
          result += const DbOperationResult(failed: 1);
        }
      }

      if (queuedCount > 0) {
        final results = await batch.commit();
        for (final r in results) {
          final rowsAffected = r as int? ?? 0;
          result += rowsAffected > 0 ? DbOperationResult(deleted: rowsAffected) : const DbOperationResult(skipped: 1);
        }
      }
    });

    return result;
  }*/

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
