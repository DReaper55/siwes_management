import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/placement.dart';
import '../utils/database_constants.dart';

class PlacementDB {
  PlacementDB.privateConst();

  static final PlacementDB instance =
  PlacementDB.privateConst();

  static const String tableName = "placement";
  static const String dbName = "placement2.db";

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
        ${PlacementDBConstants.id} TEXT NOT NULL,
        ${PlacementDBConstants.numberOfStudents} TEXT,
        ${PlacementDBConstants.companyName} TEXT
        )
        ''');
      },
    );
  }

  Future<Placement> insert(
      Placement placement) async {
    Database db = await instance.database;

    try {
      await db.transaction((txn) async {
        await txn.insert(tableName, placement.toMap());
      });
    } catch (e) {
      // Handle error
    }

    // await _removeDuplicatesFromDB();

    return placement;
  }

  Future<Placement> getOnePlacement(
      String id) async {
    Database db = await instance.database;
    List<Map> placementList = await db.query(tableName,
        where:
        '${PlacementDBConstants.id} = ?',
        whereArgs: [id]);

    if (placementList.isNotEmpty) {
      return Placement.fromMap(placementList.first);
    } else {
      return Future.value(Placement());
    }
  }

  Future<List<Placement>> getAllPlacements() async {
    List<Placement> listOfPlacements = [];
    Database db = await instance.database;
    List<Map> placements = await db.query(tableName);
    for (var placement in placements) {
      listOfPlacements.add(Placement.fromMap(placement));
    }

    return listOfPlacements;
  }

  Future<int> updatePlacement(
      Placement placement, String id) async {
    Database db = await instance.database;

    try {
      return await db.transaction((txn) async {
        return await txn.update(tableName, placement.toMap(),
            where:
            '${PlacementDBConstants.id} = ?',
            whereArgs: [
              id
            ]);
      });
    } catch (e) {
      // Handle error
      return Future.value(1);
    }
  }

  Future<int> deletePlacement(
      String id) async {
    Database db = await instance.database;

    try {
      return await db.transaction((txn) async {
        return await txn.delete(tableName,
            where:
            '${PlacementDBConstants.id} = ?',
            whereArgs: [id]);
      });
    } catch (e) {
      // Handle error
      return Future.value(1);
    }
  }

  Future<int> clearPlacementRecords() async {
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
