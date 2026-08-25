import 'package:dio/dio.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/filter_model.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/meal_model.dart';
import 'package:mealdb_application/core/network/dio_error.dart';
import 'package:mealdb_application/core/network/dio_exceptions.dart';
import 'package:mealdb_application/core/network/dio_service.dart';

class FiltersRepo {
  Future<List<FilterModel>> FilterByIngredient(String name) async {
    try {
      final response = await DioService().get('filter.php?i=$name');
      if (response['meals'] == null) {
        return [];
      }
      return (response['meals'] as List)
          .map((e) => FilterModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: '(FiltersRepo) Failed to load data: $e');
    }
  }

  Future<List<FilterModel>> FilterByArea(String name) async {
    try {
      final response = await DioService().get('filter.php?a=$name');
      if (response['meals'] == null) {
        return [];
      }
      return (response['meals'] as List)
          .map((e) => FilterModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: '(FiltersRepo) Failed to load data: $e');
    }
  }

  Future<List<FilterModel>> FilterByCategory(String name) async {
    try {
      final response = await DioService().get('filter.php?c=$name');
      if (response['meals'] == null) {
        return [];
      }
      return (response['meals'] as List)
          .map((e) => FilterModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: '(FiltersRepo) Failed to load data: $e');
    }
  }

  Future<MealModel> getMealDetails(String id) async {
    try {
      final response = await DioService().get('lookup.php?i=$id');
      if (response['meals'] == null || response['meals'].isEmpty) {
        throw ApiError(message: 'No meal details found for id: $id');
      }
      return MealModel.fromJson(response['meals'][0]);
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: '(FiltersRepo) Failed to load meal details: $e');
    }
  }
}
