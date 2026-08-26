import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealdb_application/core/features/home/Cubit/Ingredients/ingredients_states.dart';
import 'package:mealdb_application/core/features/home/data/Repository/home_repo.dart';

class IngredientsCubit extends Cubit<IngredientsStates> {
  IngredientsCubit() : super(IngredientsInitial());

  Future<void> loadIngredients() async {
    emit(IngredientsLoading());
    try {
      final ingredients = await HomeRepo().getIngredients();
      emit(IngredientsLoaded(ingredients));
    } catch (e) {
      emit(IngredientsError('Failed to load ingredients'));
    }
  }
}
