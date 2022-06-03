import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'memoDateModel.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'enrolledDate.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE enrolledDate(
      id INTEGER PRIMARY KEY,
      enrolledDate TEXT
    )
    ''');
  }

  Future<int> add(memoDateModel mDate) async {
    Database db = await instance.database;
    return await db.insert('enrolledDate', mDate.toMap());
  }

  Future<List<memoDateModel>> getmemoDate() async {
    Database db = await instance.database;
    var mDate = await db.query('enrolledDate');
    List<memoDateModel> mDateList = mDate.isNotEmpty
        ? mDate.map((c) => memoDateModel.fromMap(c)).toList()
        : [];
    return mDateList;
  }

  Future<int> update(memoDateModel mDate) async {
    Database db = await instance.database;
    return await db.update('enrolledDate', mDate.toMap(),
        where: 'id = ?', whereArgs: [mDate.id]);
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('enrolledDate', where: 'id = ?', whereArgs: [id]);
  }
}
