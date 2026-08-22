import 'package:dio/dio.dart';
import 'package:mealdb_application/core/features/home/data/models/Area_model.dart';
import 'package:mealdb_application/core/features/home/data/models/Ingredient_model.dart';
import 'package:mealdb_application/core/features/home/data/models/category_model.dart';
import 'package:mealdb_application/core/network/dio_error.dart';
import 'package:mealdb_application/core/network/dio_exceptions.dart';
import 'package:mealdb_application/core/network/dio_service.dart';

class HomeRepo {
  Future<List<IngredientModel>> getIngredients() async {
    try {
      final response = await DioService().get('list.php?i=list');
      return (response['meals'] as List)
          .map((e) => IngredientModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      // throw ApiException.handleException(e);
      throw ApiError(message: '(HomeRepo) Failed to load data: $e');
    }
  }

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await DioService().get('list.php?c=list');
      return (response['meals'] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: '(HomeRepo) Failed to load data: $e');
    }
  }

  Future<List<AreaModel>> getAllAreas() async {
    try {
      final response = await DioService().get('list.php?a=list');
      return (response['meals'] as List)
          .map((e) => AreaModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: '(HomeRepo) Failed to load data: $e');
    }
  }
}
