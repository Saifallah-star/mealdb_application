import 'package:dio/dio.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/filter_model.dart';
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
}
