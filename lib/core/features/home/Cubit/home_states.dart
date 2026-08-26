import 'package:mealdb_application/core/features/home/data/models/all_Ingredients_model.dart';
import 'package:mealdb_application/core/features/home/data/models/all_areas_model.dart';
import 'package:mealdb_application/core/features/home/data/models/all_categories_model.dart';

abstract class HomeStates {}

class HomeInitial extends HomeStates {}

class HomeLoading extends HomeStates {}

class IngredientsLoaded extends HomeStates {
  final List<AllIngredientsModel> ingredients;

  IngredientsLoaded(this.ingredients);
}

class AreasLoaded extends HomeStates {
  final List<AllAreasModel> areas;

  AreasLoaded(this.areas);
}

class CategoriesLoaded extends HomeStates {
  final List<AllCategoriesModel> categories;

  CategoriesLoaded(this.categories);
}

class HomeError extends HomeStates {
  final String message;
  HomeError(this.message);
}
