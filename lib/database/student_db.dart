import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/student.dart';
import '../utils/database_constants.dart';

class StudentDB {
  StudentDB.privateConst();

  static final StudentDB instance =
  StudentDB.privateConst();

  static const String tableName = "student";
  static const String dbName = "student1.db";

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
        ${StudentDBConstants.faculty} TEXT,
        ${StudentDBConstants.department} TEXT,
        ${StudentDBConstants.matricNumber} TEXT NOT NULL,
        ${StudentDBConstants.fullName} TEXT,
        ${StudentDBConstants.password} TEXT NOT NULL,
        ${StudentDBConstants.displayImagePath} TEXT
        )
        ''');
      },
    );
  }

  Future<Student> insert(
      Student student) async {
    Database db = await instance.database;

    try {
      await db.transaction((txn) async {
        await txn.insert(tableName, student.toMap());
      });
    } catch (e) {
      // Handle error
    }

    // await _removeDuplicatesFromDB();

    return student;
  }

  Future<Student> getOneStudent(
      String matricNumber) async {
    Database db = await instance.database;
    List<Map> studentList = await db.query(tableName,
        where:
        '${StudentDBConstants.matricNumber} = ?',
        whereArgs: [matricNumber]);

    if (studentList.isNotEmpty) {
      return Student.fromMap(studentList.first);
    } else {
      return Future.value(Student());
    }
  }

  Future<List<Student>> getAllStudents() async {
    List<Student> listOfStudents = [];
    Database db = await instance.database;
    List<Map> students = await db.query(tableName);
    for (var student in students) {
      listOfStudents.add(Student.fromMap(student));
    }

    return listOfStudents;
  }

  Future<bool> authenticateUser(String matric, String password) async {
    Database db = await instance.database;
    List<Map> studentList = await db.query(tableName,
        where:
        '${StudentDBConstants.matricNumber} = ? AND ${StudentDBConstants.password} = ?',
        whereArgs: [matric, password]);

    if (studentList.isNotEmpty) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  Future<int> updateStudent(
      Student student, String matricNumber) async {
    Database db = await instance.database;

    try {
      return await db.transaction((txn) async {
        return await txn.update(tableName, student.toMap(),
            where:
            '${StudentDBConstants.matricNumber} = ?',
            whereArgs: [
              matricNumber
            ]);
      });
    } catch (e) {
      // Handle error
      return Future.value(1);
    }
  }

  Future<int> deleteStudent(
      String matricNumber) async {
    Database db = await instance.database;

    try {
      return await db.transaction((txn) async {
        return await txn.delete(tableName,
            where:
            '${StudentDBConstants.matricNumber} = ?',
            whereArgs: [matricNumber]);
      });
    } catch (e) {
      // Handle error
      return Future.value(1);
    }
  }

  Future<int> clearStudentRecords() async {
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
