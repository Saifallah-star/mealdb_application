import 'package:dio/dio.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/Ingredient_model.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/area_model.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/category_model.dart';
import 'package:mealdb_application/core/network/dio_error.dart';
import 'package:mealdb_application/core/network/dio_exceptions.dart';
import 'package:mealdb_application/core/network/dio_service.dart';

class FiltersRepo {
  Future<List<IngredientModel>> FilterByIngredient(String name) async {
    try {
      final response = await DioService().get('filter.php?i=$name');
      if (response['meals'] == null) {
        return [];
      }
      return (response['meals'] as List)
          .map((e) => IngredientModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: '(FiltersRepo) Failed to load data: $e');
    }
  }

  Future<List<AreaModel>> FilterByArea(String name) async {
    try {
      final response = await DioService().get('filter.php?a=$name');
      if (response['meals'] == null && response['meals'] is! List<AreaModel>) {
        return [];
      }
      return (response['meals'] as List)
          .map((e) => AreaModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: '(FiltersRepo) Failed to load data: $e');
    }
  }

  Future<List<CategoryModel>> FilterByCategory(String name) async {
    try {
      final response = await DioService().get('filter.php?c=$name');
      if (response['meals'] == null) {
        return [];
      }
      return (response['meals'] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: '(FiltersRepo) Failed to load data: $e');
    }
  }
}
