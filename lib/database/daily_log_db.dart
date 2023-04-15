import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/daily_log.dart';
import '../utils/database_constants.dart';

class DailyLogDB {
  DailyLogDB.privateConst();

  static final DailyLogDB instance =
  DailyLogDB.privateConst();

  static const String tableName = "daily_log";
  static const String dbName = "daily_log0.db";

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
        ${DailyLogDBConstants.logId} TEXT NOT NULL,
        ${DailyLogDBConstants.dateTime} TEXT,
        ${DailyLogDBConstants.weekId} INTEGER,
        ${DailyLogDBConstants.entry} TEXT
        )
        ''');
      },
    );
  }

  Future<DailyLog> insert(
      DailyLog dailyLog) async {
    Database db = await instance.database;

    try {
      await db.transaction((txn) async {
        await txn.insert(tableName, dailyLog.toMap());
      });
    } catch (e) {
      // Handle error
    }

    // await _removeDuplicatesFromDB();

    return dailyLog;
  }

  Future<DailyLog> getOneDailyLog(
      String logId) async {
    Database db = await instance.database;
    List<Map> dailyLogList = await db.query(tableName,
        where:
        '${DailyLogDBConstants.logId} = ?',
        whereArgs: [logId]);

    if (dailyLogList.isNotEmpty) {
      return DailyLog.fromMap(dailyLogList.first);
    } else {
      return Future.value(DailyLog());
    }
  }

  Future<List<DailyLog>> getAllDailyLogs() async {
    List<DailyLog> listOfDailyLogs = [];
    Database db = await instance.database;
    List<Map> dailyLogs = await db.query(tableName);
    for (var dailyLog in dailyLogs) {
      listOfDailyLogs.add(DailyLog.fromMap(dailyLog));
    }

    return listOfDailyLogs;
  }

  Future<List<DailyLog>> getSomeDailyLogs(int weekId) async {
    List<DailyLog> listOfDailyLogs = [];
    Database db = await instance.database;
    List<Map> dailyLogs = await db.query(tableName, where:
    '${DailyLogDBConstants.weekId} = ?',
        whereArgs: [weekId]);

    for (var dailyLog in dailyLogs) {
      listOfDailyLogs.add(DailyLog.fromMap(dailyLog));
    }

    return listOfDailyLogs;
  }

  Future<int> updateDailyLog(
      DailyLog dailyLog, String logId) async {
    Database db = await instance.database;

    try {
      return await db.transaction((txn) async {
        return await txn.update(tableName, dailyLog.toMap(),
            where:
            '${DailyLogDBConstants.logId} = ?',
            whereArgs: [
              logId
            ]);
      });
    } catch (e) {
      // Handle error
      return Future.value(1);
    }
  }

  Future<int> deleteDailyLog(
      String logId) async {
    Database db = await instance.database;

    try {
      return await db.transaction((txn) async {
        return await txn.delete(tableName,
            where:
            '${DailyLogDBConstants.logId} = ?',
            whereArgs: [logId]);
      });
    } catch (e) {
      // Handle error
      return Future.value(1);
    }
  }

  Future<int> clearDailyLogRecords() async {
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
