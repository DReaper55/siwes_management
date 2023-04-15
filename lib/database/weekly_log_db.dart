import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/weekly_log.dart';
import '../utils/database_constants.dart';

class WeeklyLogDB {
  WeeklyLogDB.privateConst();

  static final WeeklyLogDB instance =
  WeeklyLogDB.privateConst();

  static const String tableName = "weekly_log";
  static const String dbName = "weekly_log0.db";

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
        ${WeeklyLogDBConstants.weeklyLogId} INTEGER NOT NULL,
        ${WeeklyLogDBConstants.dailyLogId} TEXT,
        ${WeeklyLogDBConstants.numberOfEntries} INTEGER,
        ${WeeklyLogDBConstants.fileAttachmentPath} TEXT
        )
        ''');
      },
    );
  }

  Future<WeeklyLog> insert(
      WeeklyLog weeklyLog) async {
    Database db = await instance.database;

    try {
      await db.transaction((txn) async {
        await txn.insert(tableName, weeklyLog.toMap());
      });
    } catch (e) {
      // Handle error
    }

    // await _removeDuplicatesFromDB();

    return weeklyLog;
  }

  Future<WeeklyLog> getOneWeeklyLog(
      int weeklyLogId) async {
    Database db = await instance.database;
    List<Map> weeklyLogList = await db.query(tableName,
        where:
        '${WeeklyLogDBConstants.weeklyLogId} = ?',
        whereArgs: [weeklyLogId]);

    if (weeklyLogList.isNotEmpty) {
      return WeeklyLog.fromMap(weeklyLogList.first);
    } else {
      return Future.value(WeeklyLog());
    }
  }

  Future<List<WeeklyLog>> getAllWeeklyLogs() async {
    List<WeeklyLog> listOfWeeklyLogs = [];
    Database db = await instance.database;
    List<Map> weeklyLogs = await db.query(tableName);
    for (var weeklyLog in weeklyLogs) {
      listOfWeeklyLogs.add(WeeklyLog.fromMap(weeklyLog));
    }

    return listOfWeeklyLogs;
  }

  Future<int> updateWeeklyLog(
      WeeklyLog weeklyLog, String weeklyLogId) async {
    Database db = await instance.database;

    try {
      return await db.transaction((txn) async {
        return await txn.update(tableName, weeklyLog.toMap(),
            where:
            '${WeeklyLogDBConstants.weeklyLogId} = ?',
            whereArgs: [
              weeklyLogId
            ]);
      });
    } catch (e) {
      // Handle error
      return Future.value(1);
    }
  }

  Future<int> deleteWeeklyLog(
      String weeklyLogId) async {
    Database db = await instance.database;

    try {
      return await db.transaction((txn) async {
        return await txn.delete(tableName,
            where:
            '${WeeklyLogDBConstants.weeklyLogId} = ?',
            whereArgs: [weeklyLogId]);
      });
    } catch (e) {
      // Handle error
      return Future.value(1);
    }
  }

  Future<int> clearWeeklyLogRecords() async {
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
