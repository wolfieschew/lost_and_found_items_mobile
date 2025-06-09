import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static bool isLoggingOut = false;

  static const String baseUrl = 'http://127.0.0.1:8000/api/v1/';

  ApiClient() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 3);
    _dio.options.receiveTimeout = const Duration(seconds: 5);

    _dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // Interceptor untuk menambahkan token ke header
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Cek flag global
          if (ApiClient.isLoggingOut && options.path != '/logout') {
            print("API call prevented during logout: ${options.path}");
            return handler.reject(
              DioException(
                requestOptions: options,
                error: "User logging out, API calls not allowed",
              ),
            );
          }

          final token = await _storage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Handle error 401 (Unauthorized)
          if (e.response?.statusCode == 401) {
            print("Token tidak valid atau kedaluwarsa");
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.put(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.delete(path, queryParameters: queryParameters);
  }
}
