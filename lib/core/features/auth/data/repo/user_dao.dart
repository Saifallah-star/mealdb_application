import 'package:mealdb_application/core/Database/app_database.dart';
import 'package:mealdb_application/core/Database/database_constants.dart';
import 'package:mealdb_application/core/features/auth/data/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  final AppDatabase _appDatabase; // take access to the database instance

  UserDao({AppDatabase? appDatabase})
    : _appDatabase = appDatabase ?? AppDatabase.instance;

  Future<void> insertUser(UserModel user) async {
    final db = await _appDatabase.database;
    await db.insert(
      DBConstants.usersTable,
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> getUserById(String id) async {
    final db = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DBConstants.usersTable,
      where: '${DBConstants.idColumn} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    }
    return null; // Return null if no user is found
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DBConstants.usersTable,
      where: '${DBConstants.emailColumn} = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    }
    return null; // Return null if no user is found
  }

  // update the user and then pass it to the database using this method
  Future<void> updateUser(UserModel user) async {
    final db = await _appDatabase.database;
    await db.update(
      DBConstants.usersTable,
      user.toJson(),
      where: '${DBConstants.idColumn} = ?',
      whereArgs: [user.id],
    );
  }
}
