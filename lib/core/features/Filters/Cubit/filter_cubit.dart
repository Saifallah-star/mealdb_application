import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealdb_application/core/network/dio_exceptions.dart';
import 'package:mealdb_application/core/features/Filters/Cubit/filter_states.dart';
import 'package:mealdb_application/core/features/Filters/data/Repositories/filters_repo.dart';

class FilterCubit extends Cubit<FilterStates> {
  FilterCubit() : super(FilterInitial());

  Future<void> FilterByIngredient(String name) async {
    emit(FilterLoading());
    try {
      final response = await FiltersRepo().FilterByIngredient(name);
      if (response.isEmpty) {
        emit(FilterEmpty());
        return;
      }
      emit(FilterLoaded(response));
    } catch (e) {
      emit(FilterError(_getErrorMessage(e, 'ingredient')));
    }
  }

  Future<void> FilterByArea(String name) async {
    emit(FilterLoading());
    try {
      final response = await FiltersRepo().FilterByArea(name);
      if (response.isEmpty) {
        emit(FilterEmpty());
        return;
      }
      emit(FilterLoaded(response));
    } catch (e) {
      emit(FilterError(_getErrorMessage(e, 'area')));
    }
  }

  Future<void> FilterByCategory(String name) async {
    emit(FilterLoading());
    try {
      final response = await FiltersRepo().FilterByCategory(name);
      if (response.isEmpty) {
        emit(FilterEmpty());
        return;
      }
      emit(FilterLoaded(response));
    } catch (e) {
      emit(FilterError(_getErrorMessage(e, 'category')));
    }
  }

  String _getErrorMessage(Object error, String type) {
    if (error is DioException) {
      return ApiException.handleException(error).message ??
          'Failed to filter by $type';
    }
    return 'Failed to filter by $type';
  }
}
