import 'package:sqflite/sqflite.dart';
import 'package:mealdb_application/core/Database/app_database.dart';
import 'package:mealdb_application/core/Database/database_constants.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/meal_model.dart';

class FavoritesLocalDAO {
  Future<Database> get db async => await AppDatabase.instance.database;

  Future<void> addFavorite(MealModel meal, String userId) async {
    final database = await db;
    
    // Remote MealDB ID comes as String. Convert to int for local SQLite INTEGER PRIMARY KEY.
    int? mealId = int.tryParse(meal.id ?? '');
    if (mealId == null) return; // Cannot insert if ID is invalid

    await database.insert(
      DBConstants.mealsTable,
      {
        DBConstants.mealIdColumn: mealId,
        DBConstants.mealNameColumn: meal.name ?? 'Unknown',
        DBConstants.mealImageColumn: meal.imageUrl ?? '',
        DBConstants.mealAreaColumn: meal.Area ?? 'N/A',
        DBConstants.mealCountryColumn: meal.Country ?? 'N/A',
        DBConstants.userIdColumn: userId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(int mealId, String userId) async {
    final database = await db;
    await database.delete(
      DBConstants.mealsTable,
      where: '${DBConstants.mealIdColumn} = ? AND ${DBConstants.userIdColumn} = ?',
      whereArgs: [mealId, userId],
    );
  }

  Future<List<MealModel>> getFavorites(String userId) async {
    final database = await db;
    final List<Map<String, dynamic>> maps = await database.query(
      DBConstants.mealsTable,
      where: '${DBConstants.userIdColumn} = ?',
      whereArgs: [userId],
    );

    return maps.map((map) => MealModel(
      id: map[DBConstants.mealIdColumn].toString(),
      name: map[DBConstants.mealNameColumn] as String,
      imageUrl: map[DBConstants.mealImageColumn] as String,
      Area: map[DBConstants.mealAreaColumn] as String,
      Country: map[DBConstants.mealCountryColumn] as String,
      // Ingredients and other fields not stored in this table
    )).toList();
  }

  Future<bool> isFavorite(int mealId, String userId) async {
    final database = await db;
    final List<Map<String, dynamic>> maps = await database.query(
      DBConstants.mealsTable,
      where: '${DBConstants.mealIdColumn} = ? AND ${DBConstants.userIdColumn} = ?',
      whereArgs: [mealId, userId],
    );
    return maps.isNotEmpty;
  }
}
