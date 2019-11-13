import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:wanandroid/model/common_websit_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  final String tableName = "table_common_web";

  final String columnId = "id";
  final String columnName = "name";
  final String columnlink = "link";
  final String columnIcon = "icon";
  final String columnOrder = "web_order";
  final String columnVisible = "visible";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "wanandroid.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "create table $tableName($columnId integer primary key,$columnIcon text not null, $columnlink text not null,$columnName text not null , $columnVisible integer not null , $columnOrder integer not null)");
    print("Table is created");
  }

  Future<int> saveItem(DataListBean item) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", item.toMap());
    print(res.toString());
    return res;
  }

  Future<List> getTotalList() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName ");
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future<DataListBean> getItem(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName WHERE id = $id");
    if (result.length == 0) return null;
    return DataListBean.fromMap(result.first);
  }

  Future<int> clear() async {
    var dbClient = await db;
    return await dbClient.delete(tableName);
  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> updateItem(DataListBean item) async {
    var dbClient = await db;
    return await dbClient.update("$tableName", item.toMap(), where: "$columnId = ?", whereArgs: [item.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
