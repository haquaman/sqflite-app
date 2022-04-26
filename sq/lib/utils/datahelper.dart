// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/car.dart';

class DatabaseHelper {
  static const _databaseName = "cardb.db";
  static const _databaseVersion = 1;
  static const table = 'cars_table';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnMiles = 'miles';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static late Database _database;

  Future<Database> get database async {
    return _database = await _initDatabase();
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT NOT NULL,
      $columnMiles INTEGER NOT NULL
    )

    ''');
  }

  Future<int> insert(Car car) async {
    Database db = await instance.database;
    return await db.insert(table, car.toMap());
  }

  Future<int> update(Car car) async {
    Database db = await instance.database;
    return await db.update(table, car.toMap(),
        where: '$columnId = ?', whereArgs: [car.id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnName LIKE '%$name'");
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }
}
