import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/services/storage_service.dart';
import 'package:handygo_worker/app/routes/app_routes.dart';
import '../../core/constant/api_constants.dart';

class ApiClient {
  late final dio.Dio _dio;
  final StorageService _storage;

  ApiClient(this._storage) {
    _init();
  }

  void _init() {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.read('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (dio.DioException e, handler) {
          if (e.response?.statusCode == 401) {
            _storage.remove('token');
            _storage.remove('user');
            Get.offAllNamed(Routes.LOGIN);
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<dio.Response<dynamic>> request(Future<dio.Response<dynamic>> Function() call) async {
    try {
      return await call();
    } on dio.DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred.';
    }
  }

  String _handleError(dio.DioException e) {
    if (e.response?.data != null && e.response?.data['message'] != null) {
      return e.response!.data['message'];
    }
    if (e.response?.statusCode == 500) {
      return 'Server error. Please try again.';
    }
    if (e.response?.statusCode == 404) {
      return 'Resource not found.';
    }
    return 'Network error. Please check your connection.';
  }

  Future<dio.Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return request(() => _dio.get(path, queryParameters: queryParameters));
  }

  Future<dio.Response<dynamic>> post(String path, {dynamic data}) async {
    return request(() => _dio.post(path, data: data));
  }

  Future<dio.Response<dynamic>> put(String path, {dynamic data}) async {
    return request(() => _dio.put(path, data: data));
  }

  Future<dio.Response<dynamic>> delete(String path, {dynamic data}) async {
    return request(() => _dio.delete(path, data: data));
  }
}
