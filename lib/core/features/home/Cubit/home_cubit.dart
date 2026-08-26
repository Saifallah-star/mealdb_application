import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealdb_application/core/features/home/Cubit/home_states.dart';
import 'package:mealdb_application/core/features/home/data/Repository/home_repo.dart';
import 'package:mealdb_application/core/features/home/data/models/all_Ingredients_model.dart';
import 'package:mealdb_application/core/features/home/data/models/all_areas_model.dart';
import 'package:mealdb_application/core/features/home/data/models/all_categories_model.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitial());

  Future<List<AllIngredientsModel>> loadIngredients() async {
    emit(HomeLoading());
    try {
      final ingredients = await HomeRepo().getIngredients();
      emit(IngredientsLoaded(ingredients));
      return ingredients;
    } catch (e) {
      emit(HomeError('Failed to load ingredients'));
      return [];
    }
  }

  Future<List<AllCategoriesModel>> loadCategories() async {
    emit(HomeLoading());
    try {
      final categories = await HomeRepo().getAllCategories();
      emit(CategoriesLoaded(categories));
      return categories;
    } catch (e) {
      emit(HomeError('Failed to load categories'));
      return [];
    }
  }

  Future<List<AllAreasModel>> loadAreas() async {
    emit(HomeLoading());
    try {
      final areas = await HomeRepo().getAllAreas();
      emit(AreasLoaded(areas));
      return areas;
    } catch (e) {
      emit(HomeError('Failed to load areas'));
      return [];
    }
  }

  //I'll use it when i add refresh to the home page
  Future<void> refreshData() async {
    emit(HomeLoading());
    try {
      await Future.wait([loadIngredients(), loadCategories(), loadAreas()]);
      emit(HomeInitial());
    } catch (e) {
      emit(HomeError('Failed to refresh data'));
    }
  }
}
