import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/meal_model.dart';
import 'package:mealdb_application/core/features/favorites__Local/cubit/favorites_state.dart';
import 'package:mealdb_application/core/features/favorites__Local/data/repo/favorites_local_repo.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesLocalRepo _repo;

  FavoritesCubit({FavoritesLocalRepo? repo})
      : _repo = repo ?? FavoritesLocalRepo(),
        super(const FavoritesInitial());

  Future<void> loadFavorites(String userId) async {
    emit(const FavoritesLoading());
    try {
      final favorites = await _repo.getFavorites(userId);
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError('Failed to load favorites: $e'));
    }
  }

  Future<void> addFavorite(MealModel meal, String userId) async {
    try {
      await _repo.addFavorite(meal, userId);
      final favorites = await _repo.getFavorites(userId);
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError('Failed to add favorite: $e'));
    }
  }

  Future<void> removeFavorite(int mealId, String userId) async {
    try {
      await _repo.removeFavorite(mealId, userId);
      final favorites = await _repo.getFavorites(userId);
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError('Failed to remove favorite: $e'));
    }
  }

  Future<bool> checkFavorite(int mealId, String userId) async {
    try {
      return await _repo.isFavorite(mealId, userId);
    } catch (e) {
      return false;
    }
  }

  Future<void> toggleFavorite(MealModel meal, String userId) async {
    final mealId = int.tryParse(meal.id ?? '');
    if (mealId == null) {
      emit(const FavoritesError('Invalid meal ID'));
      return;
    }

    try {
      final isFav = await _repo.isFavorite(mealId, userId);
      if (isFav) {
        await _repo.removeFavorite(mealId, userId);
      } else {
        await _repo.addFavorite(meal, userId);
      }
      final favorites = await _repo.getFavorites(userId);
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError('Failed to toggle favorite: $e'));
    }
  }
}
