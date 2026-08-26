import 'package:mealdb_application/core/features/home/data/models/all_Ingredients_model.dart';

abstract class IngredientsStates {}

class IngredientsInitial extends IngredientsStates {}

class IngredientsLoading extends IngredientsStates {}

class IngredientsLoaded extends IngredientsStates {
  final List<AllIngredientsModel> ingredients;

  IngredientsLoaded(this.ingredients);
}

class IngredientsError extends IngredientsStates {
  final String message;
  IngredientsError(this.message);
}
