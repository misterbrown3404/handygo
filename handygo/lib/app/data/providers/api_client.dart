import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';
import 'package:handygo/app/routes/app_pages.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../core/constant/api_constants.dart';
import 'api_exceptions.dart';

class ApiClient extends getx.GetxService {
  late Dio _dio;
  final _storage = GetStorage();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // 1. Auth Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.read('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            _storage.remove('token');
            _storage.remove('user');
            getx.Get.offAllNamed(Routes.SIGN_IN);
          }
          return handler.next(e);
        },
      ),
    );

    // 2. Logger Interceptor (Development Only)
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  // Generic Request Wrapper with Error Handling
  Future<Response> request(Future<Response> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      final message = ApiExceptions.handle(e);
      throw message;
    } catch (e) {
      throw 'An unexpected error occurred.';
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return request(() => _dio.get(path, queryParameters: queryParameters));
  }

  Future<Response> post(String path, {dynamic data}) async {
    return request(() => _dio.post(path, data: data));
  }

  Future<Response> put(String path, {dynamic data}) async {
    return request(() => _dio.put(path, data: data));
  }

  Future<Response> delete(String path) async {
    return request(() => _dio.delete(path));
  }
}
