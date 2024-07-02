import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static final instance = DatabaseHelper._();

  DatabaseHelper._();

  /// DataBase Table Name [msfDataTable], column names[colId], [colTitle], [colBatchNo], [colExpiry]
  static const String msfDataTable = 'msf_db';
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colBatchNo = 'batchNo';
  static const String colExpiry = 'expiry';

  /// It checked that the desired Database is present or not; if it present
  /// are table is also present then it will return that table otherwise
  /// it will create a new database and craete one table and then return it.
  static Future<sql.Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}notes.db';

    sql.Database msfDb = await sql.openDatabase(path, version: 1, onCreate: _createDb);
    return msfDb;
  }

  /// Create DataBase
  static Future<void> _createDb(sql.Database db, int version) async {
    await db.execute('CREATE TABLE $msfDataTable($colId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, $colTitle TEXT,'
        ' $colBatchNo TEXT, $colExpiry INTEGER)');
    log('Db created Succesfully', name: 'Db Check');
  }

  Future<sql.Database> getDataBase() async => await DatabaseHelper.initializeDatabase();

  Future<int> createItem(String title, String batchNo, String expiry) async {
    final db = await getDataBase();
    final data = {colTitle: title, colBatchNo: batchNo, colExpiry: expiry};
    final id = await db.insert(
      msfDataTable,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await getDataBase();
    List<Map<String, dynamic>> localResponse = await db.query(msfDataTable, orderBy: "id");
    log((localResponse.length).toString(), name: 'DB Records');
    log('(localResponse.length).toString()', name: 'DB Records 2');
    // for (int i = 0; i< 10; i++) {
    //   log(localResponse[i].toString(), name: 'Row $i');
    // }
    // return db.query(noteTable, orderBy: "id");
    return localResponse;
  }

  Future<bool> updateItem(int id, String title, String batchNo, String expiry) async {
    final db = await getDataBase();
    final data = {colTitle: title, colBatchNo: batchNo, colExpiry: expiry};
    int result = await db.update(msfDataTable, data, where: "id = ?", whereArgs: [id]);
    return result > 0;
  }
}
