import 'package:mealdb_application/core/features/home/data/models/all_categories_model.dart';

sealed class CategoriesStates {}

class CategoriesInitial extends CategoriesStates {}

class CategoriesLoaded extends CategoriesStates {
  final List<AllCategoriesModel> categories;
  CategoriesLoaded(this.categories);
}

class CategoriesError extends CategoriesStates {
  final String message;
  CategoriesError(this.message);
}

class CategoriesLoading extends CategoriesStates {}
