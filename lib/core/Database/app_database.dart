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
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database?> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'app_database.db');

    return await openDatabase(
      path,
      version: DBConstants.databaseVersion,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          // await db.execute('''
          //   {}
          // ''');
        }
      },

      onConfigure: (db) async {
        // Enable foreign key constraints
        await db.execute('PRAGMA foreign_keys = ON');
      },

      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${DBConstants.usersTable}(
            ${DBConstants.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            ${DBConstants.nameColumn} TEXT NOT NULL,
            ${DBConstants.emailColumn} TEXT NOT NULL,
            ${DBConstants.passwordColumn} TEXT NOT NULL
          )
        ''');

        // await db.execute('''
        //   CREATE TABLE ${DBConstants.mealsTable}(
        //     ${DBConstants.mealIdColumn} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        //     ${DBConstants.mealNameColumn} TEXT NOT NULL,
        //     ${DBConstants.mealCategoryColumn} TEXT NOT NULL,
        //     ${DBConstants.mealAreaColumn} TEXT NOT NULL,
        //     ${DBConstants.mealInstructionsColumn} TEXT NOT NULL,
        //     ${DBConstants.mealImageColumn} TEXT NOT NULL,
        //     ${DBConstants.mealYoutubeColumn} TEXT NOT NULL,
        //     ${DBConstants.mealIngredientColumn} TEXT NOT NULL,
        //     ${DBConstants.mealMeasureColumn} TEXT NOT NULL,
        //     ${DBConstants.userIdColumn} INTEGER NOT NULL,
        //     FOREIGN KEY (${DBConstants.userIdColumn}) REFERENCES ${DBConstants.usersTable}(${DBConstants.idColumn}) ON DELETE CASCADE
        //   )
        // ''');
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
