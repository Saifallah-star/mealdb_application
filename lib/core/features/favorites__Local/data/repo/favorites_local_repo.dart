import 'package:mealdb_application/core/features/Filters/data/Models/meal_model.dart';
import 'package:mealdb_application/core/features/favorites__Local/data/repo/favorites_local_dao.dart';

class FavoritesLocalRepo {
  final FavoritesLocalDAO _dao;

  FavoritesLocalRepo({FavoritesLocalDAO? dao}) : _dao = dao ?? FavoritesLocalDAO();

  Future<void> addFavorite(MealModel meal, String userId) async {
    await _dao.addFavorite(meal, userId);
  }

  Future<void> removeFavorite(int mealId, String userId) async {
    await _dao.removeFavorite(mealId, userId);
  }

  Future<List<MealModel>> getFavorites(String userId) async {
    return await _dao.getFavorites(userId);
  }

  Future<bool> isFavorite(int mealId, String userId) async {
    return await _dao.isFavorite(mealId, userId);
  }
}
