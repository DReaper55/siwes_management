import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/lecturer.dart';
import '../utils/database_constants.dart';

class LecturerDB {
  LecturerDB.privateConst();

  static final LecturerDB instance =
  LecturerDB.privateConst();

  static const String tableName = "lecturer";
  static const String dbName = "lecturer1.db";

  static late Database _database;

  Future<Database> get database async {
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);

    return await open(path);
  }

  Future open(String path) async {
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $tableName (
        ${LecturerDBConstants.faculty} TEXT,
        ${LecturerDBConstants.department} TEXT,
        ${LecturerDBConstants.staffId} TEXT NOT NULL,
        ${LecturerDBConstants.fullName} TEXT,
        ${LecturerDBConstants.password} TEXT NOT NULL,
        ${LecturerDBConstants.displayImagePath} TEXT
        )
        ''');
      },
    );
  }

  Future<Lecturer> insert(
      Lecturer lecturer) async {
    Database db = await instance.database;

    try {
      await db.transaction((txn) async {
        await txn.insert(tableName, lecturer.toMap());
      });
    } catch (e) {
      // Handle error
    }

    // await _removeDuplicatesFromDB();

    return lecturer;
  }

  Future<Lecturer> getOneLecturer(
      String staffId) async {
    Database db = await instance.database;
    List<Map> lecturerList = await db.query(tableName,
        where:
        '${LecturerDBConstants.staffId} = ?',
        whereArgs: [staffId]);

    if (lecturerList.isNotEmpty) {
      return Lecturer.fromMap(lecturerList.first);
    } else {
      return Future.value(Lecturer());
    }
  }

  Future<List<Lecturer>> getAllCustomers() async {
    List<Lecturer> listOfLecturers = [];
    Database db = await instance.database;
    List<Map> lecturers = await db.query(tableName);
    for (var lecturer in lecturers) {
      listOfLecturers.add(Lecturer.fromMap(lecturer));
    }

    return listOfLecturers;
  }

  Future<bool> authenticateUser(String staffId, String password) async {
    Database db = await instance.database;
    List<Map> studentList = await db.query(tableName,
        where:
        '${LecturerDBConstants.staffId} = ? AND ${StudentDBConstants.password} = ?',
        whereArgs: [staffId, password]);

    if (studentList.isNotEmpty) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }


  Future<int> updateLecturer(
      Lecturer lecturer, String staffId) async {
    Database db = await instance.database;

    try {
      return await db.transaction((txn) async {
        return await txn.update(tableName, lecturer.toMap(),
            where:
            '${LecturerDBConstants.staffId} = ?',
            whereArgs: [
              staffId
            ]);
      });
    } catch (e) {
      // Handle error
      return Future.value(1);
    }
  }

  Future<int> deleteLecturer(
      String staffId) async {
    Database db = await instance.database;

    try {
      return await db.transaction((txn) async {
        return await txn.delete(tableName,
            where:
            '${LecturerDBConstants.staffId} = ?',
            whereArgs: [staffId]);
      });
    } catch (e) {
      // Handle error
      return Future.value(1);
    }
  }

  Future<int> clearLecturerRecords() async {
    Database db = await instance.database;

    try {
      return await db.transaction((txn) async {
        return await txn.delete(tableName);
      });
    } catch (e) {
      // Handle error
      return Future.value(1);
    }
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableName'))!;
  }

  Future close() async => await instance.close();
}
