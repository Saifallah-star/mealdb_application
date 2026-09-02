import 'package:flutter/material.dart';
import 'package:mealdb_application/core/Database/app_database.dart';
import 'package:mealdb_application/core/Database/database_constants.dart';
import 'package:mealdb_application/core/features/auth/data/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  final AppDatabase _appDatabase; // take access to the database instance

  UserDao({AppDatabase? appDatabase})
    : _appDatabase = appDatabase ?? AppDatabase.instance;

  Future<UserModel?> insertUser(UserModel user) async {
    String email = user.email.toString();

    final db = await _appDatabase.database;

    await db.insert(
      DBConstants.usersTable,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _debugUsersTable();
    return await getUserByEmail(email);
  }

  Future<UserModel?> getUserById(String id) async {
    final db = await _appDatabase.database;

    final List<Map<String, dynamic>> maps = await db.query(
      DBConstants.usersTable,
      where: '${DBConstants.idColumn} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      await _debugUsersTable();
      return UserModel.fromMap(maps.first);
    }
    await _debugUsersTable();
    return null; // Return null if no user is found
  }

  Future<UserModel?> getUserByEmail(String email) async {
    debugPrint('getting user by email: $email');

    final db = await _appDatabase.database;

    final List<Map<String, dynamic>> maps = await db.query(
      DBConstants.usersTable,
      where: '${DBConstants.emailColumn} = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      await _debugUsersTable();
      return UserModel.fromMap(maps.first);
    }
    await _debugUsersTable();
    return null; // Return null if no user is found
  }

  // update the user and then pass it to the database using this method
  Future<void> updateUser(UserModel user) async {
    final db = await _appDatabase.database;

    await db.update(
      DBConstants.usersTable,
      user.toMap(),
      where: '${DBConstants.idColumn} = ?',
      whereArgs: [user.id],
    );
    await _debugUsersTable();
  }

  Future<void> updateProfileImage(String id, String? path) async {
    final db = await _appDatabase.database;
    await db.update(
      DBConstants.usersTable,
      {DBConstants.columnProfileImage: path},
      where: '${DBConstants.idColumn} = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateUserInfo(String id, String name, String email) async {
    final db = await _appDatabase.database;
    await db.update(
      DBConstants.usersTable,
      {DBConstants.nameColumn: name, DBConstants.emailColumn: email},
      where: '${DBConstants.idColumn} = ?',
      whereArgs: [id],
    );
  }

  Future<void> _debugUsersTable() async {
    final db = await _appDatabase.database;

    final users = await db.query(DBConstants.usersTable);

    debugPrint('========== USERS TABLE ==========');
    debugPrint('Rows: ${users.length}');

    for (final user in users) {
      debugPrint(user.toString());
    }

    debugPrint('=================================');
  }
}
