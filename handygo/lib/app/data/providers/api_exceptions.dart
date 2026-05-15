import 'package:dio/dio.dart';

class ApiExceptions {
  static String handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet.';
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode, error.response?.data);
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  static String _handleStatusCode(int? statusCode, dynamic data) {
    switch (statusCode) {
      case 400:
        return data?['message'] ?? 'Bad request';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'You do not have permission to perform this action.';
      case 404:
        return 'Resource not found.';
      case 422:
        // Handle Laravel validation errors
        if (data?['errors'] != null) {
          final Map<String, dynamic> errors = data['errors'];
          return errors.values.first.first.toString();
        }
        return data?['message'] ?? 'Validation error';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Unexpected error occurred.';
    }
  }
}
