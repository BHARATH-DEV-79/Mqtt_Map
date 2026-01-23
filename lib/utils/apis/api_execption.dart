import 'package:dio/dio.dart';
import 'package:product_api/utils/apis/api_error.dart';



class DioErrorHandler {
  static ApiError handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiError(message: "Connection timeout");

      case DioExceptionType.sendTimeout:
        return ApiError(message: "Request timeout");

      case DioExceptionType.receiveTimeout:
        return ApiError(message: "Response timeout");

      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        final message =
            error.response?.data?['message'] ??
            "Server error occurred";
        return ApiError(message: message, statusCode: status);

      case DioExceptionType.cancel:
        return ApiError(message: "Request cancelled");

      case DioExceptionType.connectionError:
        return ApiError(message: "No internet connection");

      default:
        return ApiError(message: "Something went wrong");
    }
  }
}