
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:product_api/routes/api_points.dart';

import '../../storage/app_storage.dart';
import '../apis/api_execption.dart';


class DioClient {
  static Dio? _dio;

  static Dio get instance {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          // baseUrl: "https://api.yourdomain.com", // 👈 change
          baseUrl: ApiEndPoints.baseurl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.acceptHeader: "application/json",
          },
        ),
      );

      _dio!.interceptors.add(_authInterceptor());
      _dio!.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
    return _dio!;
  }

  /// 🔐 Attach token automatically
  static InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await AppStorage().getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    );
  }
}



class ApiService {
  static Future<T> get<T>({
    required String path,
    required T Function(dynamic data) fromJson,
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await DioClient.instance.get(
        path,
        queryParameters: query,
      );

      final dynamic data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      return fromJson(data);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  static Future<T> post<T>({
    required String path,
    required dynamic body,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await DioClient.instance.post(
        path,
        data: body,
      );

      final dynamic data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      return fromJson(data);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  static Future<T> put<T>({
    required String path,
    required dynamic body,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await DioClient.instance.put(
        path,
        data: body,
      );

      final dynamic data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      return fromJson(data);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  static Future<T> delete<T>({
    required String path,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await DioClient.instance.delete(path);

      final dynamic data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      return fromJson(data);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}