import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../debug/api_log_store.dart';
import '../../debug/debug_interceptor.dart';
import 'api_constants.dart';
import 'token_manager.dart';

class ApiService {
  late Dio _dio;

  ApiService({String? token}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );

    _initializeInterceptors();
  }

  static Future<ApiService> authenticated() async {
    final token = await TokenManager.instance.getToken();
    return ApiService(token: token);
  }

  void _initializeInterceptors() {
    if (kDebugMode) {
      _dio.interceptors.add(DebugInterceptor());
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          developer.log('REQUEST: ${options.method} ${options.uri}');
          developer.log('AUTH: ${options.headers['Authorization']}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          developer.log('RESPONSE: ${response.statusCode}');
          handler.next(response);
        },
        onError: (error, handler) async {
          developer.log('ERROR: ${error.response?.statusCode}');
          if (error.response?.statusCode == 401 &&
              !error.requestOptions.path.contains('/auth/')) {
            final refreshToken = await TokenManager.instance.getRefreshToken();
            if (refreshToken != null && refreshToken.isNotEmpty) {
              try {
                final refreshResponse = await Dio(
                  BaseOptions(baseUrl: ApiConstants.baseUrl),
                ).post(
                  ApiConstants.authRefresh,
                  data: {'refreshToken': refreshToken},
                );
                final resData = refreshResponse.data;
                String? newAccessToken;
                String? newRefreshToken;
                if (resData is Map<String, dynamic>) {
                  final dataMap = resData['data'] is Map<String, dynamic>
                      ? resData['data']
                      : resData;
                  newAccessToken = dataMap['accessToken'] ?? dataMap['token'];
                  newRefreshToken = dataMap['refreshToken'];
                }
                if (newAccessToken != null && newAccessToken.isNotEmpty) {
                  await TokenManager.instance.saveTokens(
                    accessToken: newAccessToken,
                    refreshToken: newRefreshToken ?? refreshToken,
                  );
                  final opts = error.requestOptions;
                  opts.headers['Authorization'] = 'Bearer $newAccessToken';
                  final cloneReq = await _dio.fetch(opts);
                  return handler.resolve(cloneReq);
                }
              } catch (e) {
                developer.log('Failed to refresh token: $e');
              }
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  // ✅ GET
  Future<Response> get(String url, {Map<String, dynamic>? queryParams}) async {
    return await _dio.get(url, queryParameters: queryParams);
  }

  // ✅ POST
  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) async {
    return await _dio.post(url, data: data, queryParameters: queryParams);
  }

  // ✅ PUT
  Future<Response> put(String url, {dynamic data}) async {
    return await _dio.put(url, data: data);
  }

  // ✅ PATCH
  Future<Response> patch(String url, {dynamic data}) async {
    return await _dio.patch(url, data: data);
  }

  // ✅ DELETE
  Future<Response> delete(String url, {dynamic data}) async {
    return await _dio.delete(url, data: data);
  }

  // ✅ MULTIPART UPLOAD
  Future<Response> uploadMultipart(
    String url, {
    required List<String> filePaths,
    String fieldName = 'files',
  }) async {
    final formData = FormData();
    for (final path in filePaths) {
      formData.files.add(
        MapEntry(fieldName, await MultipartFile.fromFile(path)),
      );
    }
    return await _dio.post(
      url,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  Future<T> mock<T>({
    required String method,
    required String url,
    dynamic requestBody,
    dynamic rawResponse,
    required Future<T> Function() execute,
  }) async {
    if (!kDebugMode) return execute();

    final stopwatch = Stopwatch()..start();
    try {
      final result = await execute();
      stopwatch.stop();
      ApiLogStore.instance.logMock(
        method: method,
        url: url,
        requestBody: requestBody,
        statusCode: 200,
        responseBody: rawResponse ?? result,
        duration: stopwatch.elapsed,
      );
      return result;
    } catch (e) {
      stopwatch.stop();
      ApiLogStore.instance.logMock(
        method: method,
        url: url,
        requestBody: requestBody,
        statusCode: 500,
        responseBody: e.toString(),
        duration: stopwatch.elapsed,
      );
      rethrow;
    }
  }
}
