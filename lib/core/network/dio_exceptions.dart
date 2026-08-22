import 'package:dio/dio.dart';
import 'package:mealdb_application/core/network/dio_error.dart';

class ApiException {
  static ApiError handleException(dynamic error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiError(message: 'Connection timeout');
      case DioExceptionType.sendTimeout:
        return ApiError(message: 'Send timeout');
      case DioExceptionType.receiveTimeout:
        return ApiError(message: 'Receive timeout');
      case DioExceptionType.badResponse:
        return ApiError(message: 'Bad response: ${error.response?.statusCode}');
      case DioExceptionType.cancel:
        return ApiError(message: 'Request cancelled');
      case DioExceptionType.unknown:
        return ApiError(message: 'Unknown error: ${error.message}');
      default:
        return ApiError(message: 'Unexpected error occurred');
    }
  }
}
