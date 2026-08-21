import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://www.themealdb.com/api/json/v1/1/'),
  );

  Dio get dio => _dio;
}
