// lib/src/api/api_client.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/endpoints.dart';

/// Singleton Dio-based API client with secure-token handling.
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  final Dio dio;
  final FlutterSecureStorage _storage;

  ApiClient._internal()
      : _storage = const FlutterSecureStorage(),
        dio = Dio(BaseOptions(
          baseUrl: Endpoints.apiUrl,
          connectTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 3),
        )) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final req = error.requestOptions;

          // 1) If this was our refresh call, don’t try to refresh again
          if (req.path == Endpoints.refreshToken) {
            return handler.next(error);
          }

          // 2) Only for 401s, attempt a single refresh-and-retry
          if (error.response?.statusCode == 401) {
            try {
              // perform the refresh (this uses the same dio instance,
              // but we’ve already skipped retrying on the refresh path)
              await _refreshToken();

              final newToken = await _storage.read(key: 'access_token');
              if (newToken != null) {
                // clone and retry the original request
                final opts = error.requestOptions;
                final cloneReq = await dio.request(
                  opts.path,
                  options: Options(
                    method: opts.method,
                    headers: opts.headers..['Authorization'] = 'Bearer $newToken',
                    contentType: opts.contentType,
                  ),
                  data: opts.data,
                  queryParameters: opts.queryParameters,
                );
                return handler.resolve(cloneReq);
              }
            } catch (_) {
              // refresh failed: fall through to original 401
            }
          }

          handler.next(error);
        },
      ),
    );
  }

  Future<void> _refreshToken() async {
    final refresh = await _storage.read(key: 'refresh_token');
    if (refresh == null) {
      throw Exception('No refresh token available.');
    }
    final response = await dio.post(
      Endpoints.refreshToken,
      data: {'refreshToken': refresh},
    );
    final data = response.data as Map<String, dynamic>;
    await _storage.write(key: 'access_token', value: data['accessToken'] as String);
    await _storage.write(key: 'refresh_token', value: data['refreshToken'] as String);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.get<T>(
      path,
      queryParameters: queryParameters,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
  }) {
    return dio.post<T>(
      path,
      data: data,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
  }) {
    return dio.put<T>(
      path,
      data: data,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
  }) {
    return dio.patch<T>(
      path,
      data: data,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
  }) {
    return dio.delete<T>(
      path,
      data: data,
    );
  }
}