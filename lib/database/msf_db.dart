import 'dart:io';

 import 'package:msf/config/constant.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../model/MasterDataModel.dart';

class DatabaseHelper {
  static const String MSF_DATABASE = "MSFDatabase.db",
      MSF_USERS_TABLE = "MSFUsersTable",
      UNI_DATA_TABLE = "MSFUniDataTable";

  /*Singleton DatabaseHelper*/
  static DatabaseHelper? _databaseHelper;

  /*Named constructor to create instance of databaseHelper*/
  DatabaseHelper._createInstance();

  /*Singleton database*/
  static Database? _database;

  static Future close() async => _database?.close();

  Future<Database?> get database async {
    _database ??= await open();
    return _database;
  }

  factory DatabaseHelper() {
    _databaseHelper = DatabaseHelper._createInstance();
    return _databaseHelper!;
    // return _databaseHelper;
  }

  static Future<String> initDb(String dbName) async {
    var databasePath = await getDatabasesPath();
    String path = p.join(databasePath, dbName);
    if (await Directory(p.dirname(path)).exists()) {
    } else {
      try {
        await Directory(p.dirname(path)).create(recursive: true);
      } catch (e) {
        //print(e);
      }
    }
    return path;
  }

  Future<Database> open() async {
    String path = await initDb(MSF_DATABASE);
    var bankDatabase =
    await openDatabase(path, version: 1, onCreate: _createDb);
    return bankDatabase;
  }

  /*create table of bank database*/
  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $MSF_USERS_TABLE('
        '${Constant.COL_ID} INTEGER PRIMARY KEY AUTOINCREMENT,'
        '${Constant.EMAIL_ID} TEXT,'
        '${Constant.PASSWORD} TEXT'
        ')');


    await db.execute('CREATE TABLE $UNI_DATA_TABLE('
        '${Constant.COL_ID} INTEGER PRIMARY KEY AUTOINCREMENT,'
        '${Constant.EMAIL_ID} TEXT,'
        '${Constant.PASSWORD} TEXT'
        ')');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    db.execute("DROP TABLE IF EXISTS $MSF_USERS_TABLE");
    db.execute("DROP TABLE IF EXISTS $UNI_DATA_TABLE");

    _createDb(db, newVersion);
  }

/*............................................................................*/

  /*Fetch Operation: Get all bank objects from database*/
  Future<List<Map<String, dynamic>>?> fetchMapList(
      String tableName,
      List<String> columns,
      String where,
      List<dynamic> whereArgs,
      String groupBy,
      String having,
      String orderBy,
      int limit,
      int offset) async {
    Database? db = await this.database;
    var result = await db?.query(tableName,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);
    return result;
  }

/*..........................................................................*/

/*Insert  Operation: Insert a record object to db*/
  Future<int?> insertDataInTableRecord(
      String tableName, Map<String, dynamic> mapData) async {
    Database? db = await this.database;
    var result = await db?.insert(tableName, mapData);

    return result;
  }

  /*..........................................................................*/
/*Update Operation: Update a Game Object and save it to db*/
  Future<int?> updateTableRow(
      String tableName, Map<String, dynamic> mapData, where, whereArg) async {
    var db = await this.database;
    var result =
    await db?.update(tableName, mapData, where: where, whereArgs: whereArg);
    return result;
  }

/*............................................................................*/

/*Get number of Note object in db*/
  Future<int?> getCount(String table) async {
    Database? db = await this.database;
    List<Map<String, Object?>>? x = await db?.rawQuery('SELECT COUNT (*) from '
        '$table');
    int? result = Sqflite.firstIntValue(x!);
    return result;
  }

/*............................................................................*/
/*Clear all data to table*/
  Future<int?> clearTable(String tableName) async {
    var db = await this.database;
    int? rowId = await db?.delete(tableName);

    return rowId;
  }

  /*Clear all data to table*/
  Future<int?> deleteRowTable(
      String tableName, String where, List<dynamic> whereArgs) async {
    var db = await this.database;
    int? rowId =
    await db?.delete(tableName, where: where, whereArgs: whereArgs);

    return rowId;
  }

  /*Clear all data to table*/
  Future<int?> deleteTable(String tableName) async {
    var db = await this.database;
    int? rowId = await db?.delete(tableName);

    return rowId;
  }

  /*banks Table Fetch function*/
  Future<List<MasterDataModel>> getInterest(String tableName) async {
    List<MasterDataModel> searchingList = [];

    switch (tableName) {
      case MSF_USERS_TABLE:
        List<Map<String, dynamic>>? dataModel =
        await fetchMapList(tableName, [], "", [], "", "", "", 0, 0);
        int? dataLength = dataModel?.length;
        if (dataLength! > 0) {
          for (int i = 0; i < dataLength; i++) {
            var modelData = MasterDataModel.fromMapObject(dataModel![i]);
            String emailID = modelData.emailid;
            String password = modelData.password;
            searchingList.add(MasterDataModel(i, emailID, password));
          }
        }
        break;
      case UNI_DATA_TABLE:
        List<Map<String, dynamic>>? dataModel =
        await fetchMapList(tableName, [], "", [], "", "", "", 0, 0);
        int? dataLength = dataModel?.length;
        if (dataLength! > 0) {
          for (int i = 0; i < dataLength; i++) {
            var modelData = MasterDataModel.fromMapObject(dataModel![i]);
            String emailID = modelData.emailid;
            String password = modelData.password;
            searchingList.add(MasterDataModel(i, emailID, password));
          }
        }
        break;
    }

    return searchingList;
  }

  /*Function is used for check database status for data entry*/
  Future<bool> checkDataBaseStatus() async {
    bool isDatabaseStatus = false;
    List<Map<String, dynamic>>? danceLevelList =
    await fetchMapList(MSF_USERS_TABLE, [], "", [], "", "", "", 0, 0);
    //List<Map<String, dynamic>> danceStyleList= await fetchMapList(INTRICATE_DANCE_STYLE_TABLE,null,null,null,null,null,null,null,null);
    if (danceLevelList!.isEmpty) {
      isDatabaseStatus = true;
    }

    return isDatabaseStatus;
  }

  /*Insert  Operation: Insert a Game object to db*/
  Future<int> insertDataInTableGame(
      String tableName, Map<String, dynamic> mapData) async {

    Database? db = await this.database;
    var result;
    await db?.transaction((txn) async {
      var batch = txn.batch();

      try{
        result= txn.insert(tableName, mapData);
        await txn.batch().commit();

      } catch (e){
        await txn.batch().commit(continueOnError: true);

      }

    });

/*    try {
      //do some insertions or whatever you need
      db.setTransactionSuccessful();
    } finally {
      db.endTransaction();
    }*/
    // var result = await db.insert(tableName, mapData);
    print("result....$result");
    return result;
  }


  Future<int> selectDataTable(
      String tableName, String where, List<dynamic> whereArgs) async {
    var db = await this.database;
    var rowId;
    if(tableName==DatabaseHelper.MSF_USERS_TABLE){
      List<Map<String, Object?>> rowIdStr = await db!.query(tableName, where: where , whereArgs: whereArgs);
      rowId=rowIdStr.length;
    }else{
      var rowIdStr;
      await db?.transaction((txn) async {
        var batch = txn.batch();

        try{
          rowIdStr= txn.rawQuery("SELECT * FROM $tableName WHERE name LIKE '%${whereArgs.last}%'");
          await txn.batch().commit();

        } catch (e){
          await txn.batch().commit(continueOnError: true);

        }

      });
      // var rowIdStr = await db
      //     .rawQuery("SELECT * FROM $tableName WHERE name LIKE '%${whereArgs.last}%'");
      rowId= rowIdStr.length;
    }
    print("rowId.length    ${rowId}");
    return rowId;
  }


  Future<int >deleteAndInsertRowsTopSearchTable(String name) async {
    int deleteRowId = -1;
    print("name    $name");

    deleteRowId = await deleteAndInsertRowTable(
        DatabaseHelper.MSF_USERS_TABLE,
        //  "${Constant.NAME}" ,
        "${Constant.EMAIL_ID} = ?  " ,
        /* "  ${Constant.SEARCH_TYPE} = ? ",*/
        [
          name,
/*
          searchType
*/
        ]);
    return deleteRowId;
    /*if (deleteRowId > 0) {
      await insertDataInTableGame(
          DatabaseHelper.TOP_SEARCH_TABLE, topSearchModel.toMap());
    }*/
  }

  Future<int> deleteAndInsertRowTable(
      String tableName, String where, List<dynamic> whereArgs) async {
    var db = await this.database;
    var rowId;
    await db?.transaction((txn) async {
      var batch = txn.batch();

      try{
        rowId= txn.rawDelete('DELETE FROM $tableName WHERE $where COLLATE NOCASE', whereArgs);
        await txn.batch().commit();

      } catch (e){
        await txn.batch().commit(continueOnError: true);

      }

    });
    // var rowId;
    //  rowId = await db.rawDelete('DELETE FROM $tableName WHERE $where COLLATE NOCASE', whereArgs);
    // rowId = await db
    //       .rawQuery("DELETE FROM $tableName WHERE $where LIKE '%${whereArgs.last}%'");

    // rowId = await db.delete(tableName, where: where, whereArgs: whereArgs);



    return rowId;
  }
  /*delete all data of all tables*/
  clearLocalDb() async {
    var db = await this.database;
    await db?.delete(MSF_USERS_TABLE);
    int? id = await db?.delete(MSF_USERS_TABLE);
    return id;
  }
}
