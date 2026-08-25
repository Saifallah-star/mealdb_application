import 'package:dio/dio.dart';
import 'package:mealdb_application/core/features/home/data/models/all_areas_model.dart';
import 'package:mealdb_application/core/features/home/data/models/all_Ingredients_model.dart';
import 'package:mealdb_application/core/features/home/data/models/all_categories_model.dart';
import 'package:mealdb_application/core/network/dio_error.dart';
import 'package:mealdb_application/core/network/dio_exceptions.dart';
import 'package:mealdb_application/core/network/dio_service.dart';

class HomeRepo {
  Future<List<AllIngredientsModel>> getIngredients() async {
    try {
      final response = await DioService().get('list.php?i=list');
      return (response['meals'] as List)
          .map((e) => AllIngredientsModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      // throw ApiException.handleException(e);
      throw ApiError(message: '(HomeRepo) Failed to load data: $e');
    }
  }

  Future<List<AllCategoriesModel>> getAllCategories() async {
    try {
      final response = await DioService().get('list.php?c=list');
      return (response['meals'] as List)
          .map((e) => AllCategoriesModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: '(HomeRepo) Failed to load data: $e');
    }
  }

  Future<List<AllAreasModel>> getAllAreas() async {
    try {
      final response = await DioService().get('list.php?a=list');
      return (response['meals'] as List)
          .map((e) => AllAreasModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: '(HomeRepo) Failed to load data: $e');
    }
  }
}
