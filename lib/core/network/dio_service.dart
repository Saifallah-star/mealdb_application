import 'package:dio/dio.dart';
import 'package:mealdb_application/core/network/dio_client.dart';
import 'package:mealdb_application/core/network/dio_error.dart';
import 'package:mealdb_application/core/network/dio_exceptions.dart';

class DioService {
  DioClient dioClient = DioClient();

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await dioClient.dio.get(endpoint);
      return response.data;
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: '(DioService) Failed to load data: $e');
    }
  }

  Future<dynamic> post(String endpoint, dynamic data) async {
    try {
      final response = await dioClient.dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: 'Failed to load data: $e');
    }
  }

  Future<dynamic> put(String endpoint, dynamic data) async {
    try {
      final response = await dioClient.dio.put(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: 'Failed to load data: $e');
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await dioClient.dio.delete(endpoint);
      return response.data;
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: 'Failed to load data: $e');
    }
  }
}
