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

  // TODO: Replace with real auth flow (Firebase token → backend JWT exchange)
  static Future<ApiService> authenticated() async {
    const token =
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwNjc3YTZkMy1lNTBjLTRhYjgtOGJlMy1jZjhkYzA5M2IyMWMiLCJpYXQiOjE3ODgxMTMyOTYsImV4cCI6NDc4ODExMzI5NiwianRpIjoiMGMyYTE1YmItZjFhYi00Mjc1LWExMDEtODBhZWRjY2M5MTQ5Iiwicm9sZSI6IlBBVElFTlQiLCJwaG9uZSI6Iis5MTkzOTg3MTI5NTcifQ.Qnth8ukuV0TIhmNN90xQWSeHl8x3K15wsa0a-MOSjZc';
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
        onError: (error, handler) {
          developer.log('ERROR: ${error.response?.statusCode}');
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
