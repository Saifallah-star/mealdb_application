import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealdb_application/core/features/home/Cubit/Categories/categories_states.dart';
import 'package:mealdb_application/core/features/home/data/Repository/home_remote_repo.dart';

class CategoriesCubit extends Cubit<CategoriesStates> {
  CategoriesCubit() : super(CategoriesInitial());

  Future<void> loadCategories() async {
    emit(CategoriesLoading());
    try {
      final categories = await HomeRepo().getAllCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoriesError('Failed to load categories'));
    }
  }
}
