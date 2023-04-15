import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/supervisor.dart';
import '../utils/database_constants.dart';

class SupervisorDB {
  SupervisorDB.privateConst();

  static final SupervisorDB instance =
  SupervisorDB.privateConst();

  static const String tableName = "supervisor";
  static const String dbName = "supervisor3.db";

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
        ${SupervisorDBConstants.id} TEXT NOT NULL,
        ${SupervisorDBConstants.supervisorName} TEXT,
        ${SupervisorDBConstants.numberOfStudents} TEXT
        )
        ''');
      },
    );
  }

  Future<Supervisor> insert(
      Supervisor supervisor) async {
    Database db = await instance.database;

    try {
      await db.transaction((txn) async {
        await txn.insert(tableName, supervisor.toMap());
      });
    } catch (e) {
      // Handle error
    }

    // await _removeDuplicatesFromDB();

    return supervisor;
  }

  Future<Supervisor> getOneSupervisor(
      String id) async {
    Database db = await instance.database;
    List<Map> supervisorList = await db.query(tableName,
        where:
        '${SupervisorDBConstants.id} = ?',
        whereArgs: [id]);

    if (supervisorList.isNotEmpty) {
      return Supervisor.fromMap(supervisorList.first);
    } else {
      return Future.value(Supervisor());
    }
  }

  Future<List<Supervisor>> getAllSupervisors() async {
    List<Supervisor> listOfSupervisors = [];
    Database db = await instance.database;
    List<Map> supervisors = await db.query(tableName);
    for (var supervisor in supervisors) {
      listOfSupervisors.add(Supervisor.fromMap(supervisor));
    }

    return listOfSupervisors;
  }

  Future<int> updateSupervisor(
      Supervisor supervisor, String id) async {
    Database db = await instance.database;

    try {
      return await db.transaction((txn) async {
        return await txn.update(tableName, supervisor.toMap(),
            where:
            '${SupervisorDBConstants.id} = ?',
            whereArgs: [id]);
      });
    } catch (e) {
      // Handle error
      return Future.value(1);
    }
  }

  Future<int> deleteSupervisor(
      String id) async {
    Database db = await instance.database;

    try {
      return await db.transaction((txn) async {
        return await txn.delete(tableName,
            where:
            '${SupervisorDBConstants.id} = ?',
            whereArgs: [id]);
      });
    } catch (e) {
      // Handle error
      return Future.value(1);
    }
  }

  Future<int> clearSupervisorRecords() async {
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
