import 'package:flutter/material.dart';
import 'package:mealdb_application/core/Database/database_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  /// A singleton instance
  static final AppDatabase instance = AppDatabase._init();
  AppDatabase._init();
  static Database? _database;

  Future<Database> get database async {
    // debugPrint(await getDatabasesPath());
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database?> _initDatabase() async {
    debugPrint('Database path is : ${await getDatabasesPath()}');
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, DBConstants.databaseName);
    return await openDatabase(
      path,
      version: DBConstants.databaseVersion,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('''
             CREATE TABLE ${DBConstants.mealsTable}(
            ${DBConstants.mealIdColumn} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            ${DBConstants.mealNameColumn} TEXT NOT NULL,
            ${DBConstants.mealImageColumn} TEXT NOT NULL,
             ${DBConstants.mealAreaColumn} TEXT NOT NULL,
              ${DBConstants.mealCountryColumn} TEXT NOT NULL,
            ${DBConstants.userIdColumn} INTEGER NOT NULL,
            FOREIGN KEY (${DBConstants.userIdColumn}) REFERENCES ${DBConstants.usersTable}(${DBConstants.idColumn}) ON DELETE CASCADE
          )
          ''');
        }
        if (oldVersion < 4) {
          var res = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='${DBConstants.mealsTable}'");
          if (res.isNotEmpty) {
            await db.execute('ALTER TABLE ${DBConstants.mealsTable} RENAME TO ${DBConstants.mealsTable}_old');
          }
          await db.execute('''
            CREATE TABLE IF NOT EXISTS ${DBConstants.mealsTable}(
              ${DBConstants.mealIdColumn} INTEGER PRIMARY KEY NOT NULL,
              ${DBConstants.mealNameColumn} TEXT NOT NULL,
              ${DBConstants.mealImageColumn} TEXT NOT NULL,
              ${DBConstants.mealAreaColumn} TEXT NOT NULL,
              ${DBConstants.mealCountryColumn} TEXT NOT NULL,
              ${DBConstants.userIdColumn} TEXT NOT NULL,
              FOREIGN KEY (${DBConstants.userIdColumn})
                REFERENCES ${DBConstants.usersTable}(${DBConstants.idColumn})
                ON DELETE CASCADE
            )
          ''');
          if (res.isNotEmpty) {
            await db.execute('''
              INSERT INTO ${DBConstants.mealsTable} (${DBConstants.mealIdColumn}, ${DBConstants.mealNameColumn}, ${DBConstants.mealImageColumn}, ${DBConstants.mealAreaColumn}, ${DBConstants.mealCountryColumn}, ${DBConstants.userIdColumn})
              SELECT ${DBConstants.mealIdColumn}, ${DBConstants.mealNameColumn}, ${DBConstants.mealImageColumn}, ${DBConstants.mealAreaColumn}, ${DBConstants.mealCountryColumn}, CAST(${DBConstants.userIdColumn} AS TEXT)
              FROM ${DBConstants.mealsTable}_old
            ''');
            await db.execute('DROP TABLE ${DBConstants.mealsTable}_old');
          }
        }
      },
      onConfigure: (db) async {
        // Enable foreign key constraints
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${DBConstants.usersTable}(
            ${DBConstants.idColumn} TEXT PRIMARY KEY NOT NULL,
            ${DBConstants.nameColumn} TEXT NOT NULL,
            ${DBConstants.emailColumn} TEXT NOT NULL,
            ${DBConstants.passwordColumn} TEXT NOT NULL,
            ${DBConstants.columnProfileImage} TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE ${DBConstants.mealsTable}(
            ${DBConstants.mealIdColumn} INTEGER PRIMARY KEY NOT NULL,
            ${DBConstants.mealNameColumn} TEXT NOT NULL,
            ${DBConstants.mealImageColumn} TEXT NOT NULL,
            ${DBConstants.mealAreaColumn} TEXT NOT NULL,
            ${DBConstants.mealCountryColumn} TEXT NOT NULL,
            ${DBConstants.userIdColumn} TEXT NOT NULL,
            FOREIGN KEY (${DBConstants.userIdColumn}) REFERENCES ${DBConstants.usersTable}(${DBConstants.idColumn}) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
