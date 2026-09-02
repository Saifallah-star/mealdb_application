import 'package:mealdb_application/core/features/Filters/data/Models/meal_model.dart';

sealed class FavoritesState {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<MealModel> favorites;
  const FavoritesLoaded(this.favorites);
}

class FavoriteOperationSuccess extends FavoritesState {
  final String message;
  const FavoriteOperationSuccess(this.message);
}

class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);
}
