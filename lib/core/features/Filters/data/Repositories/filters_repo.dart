import 'package:dio/dio.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/Ingredient_model.dart';
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
}
