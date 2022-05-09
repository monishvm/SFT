import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sft/modal/vehicle.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _dbName = 'database.db';
  static final _dbVersion = 1;
  static final tablename = 'vehicles';

  static final id = 'id';
  static final name = 'name';
  static final mileage = 'mileage';
  static final capacity = 'capacity';
  static final remaining_fuel = 'remaining_fuel';
  static final estimated_distance = 'estimated_distance';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initiateDatabase();
    return _database!;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tablename (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $name TEXT NOT NULL,
      $mileage REAL NOT NULL,
      $capacity REAL NOT NULL,
      $remaining_fuel REAL NOT NULL,
      $estimated_distance REAL NOT NULL
    )
    ''');
  }

  Future close() async {
    Database db = await DatabaseHelper.instance.database;
    db.close();
  }

  static Future insert(Vehicle vehicle) async {
    Database db = await DatabaseHelper.instance.database;
    int id = await db.insert(tablename, vehicle.toJson());
    return id;
  }

  static Future<List<Vehicle>> getAllvehicle() async {
    Database db = await DatabaseHelper.instance.database;
    return (await db.query(tablename)).map((e) => Vehicle.fromJson(e)).toList();
  }

  static Future<int> updateRemainingFuelAndEstimatedDistance(
      Vehicle vehicle) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.update(
      tablename,
      vehicle.toJson(),
      where: '$id = ?',
      whereArgs: [vehicle.id],
    );
  }

  static Future<Vehicle> getvehicleById(int id) async {
    Database db = await DatabaseHelper.instance.database;
    return Vehicle.fromJson((await db.rawQuery(
            'SELECT * FROM $tablename WHERE ${DatabaseHelper.id} = $id'))
        .first);
  }

  static Future<int> deletevehicleById(int id) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.delete(
      tablename,
      where: '${DatabaseHelper.id} = ?',
      whereArgs: [id],
    );
  }
}
