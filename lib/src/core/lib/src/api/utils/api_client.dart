import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../debug/api_log_store.dart';
import '../../debug/debug_interceptor.dart';
import '../../navigation/cc_route_constants.dart';
import '../../navigation/cc_route_helper.dart';
import 'api_constants.dart';
import 'token_manager.dart';

class ApiService {
  late Dio _dio;

  /// Shared across all [ApiService] instances so concurrent 401s only refresh once.
  static Future<String?>? _refreshInFlight;

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

  /// Restores a backend session on cold start.
  /// Returns true when a usable access token is available.
  static Future<bool> tryRestoreSession() async {
    final accessToken = await TokenManager.instance.getToken();
    final refreshToken = await TokenManager.instance.getRefreshToken();

    final hasAccess = accessToken != null && accessToken.isNotEmpty;
    final hasRefresh = refreshToken != null && refreshToken.isNotEmpty;

    if (!hasAccess && !hasRefresh) return false;

    if (hasAccess && !_isJwtExpired(accessToken)) {
      return true;
    }

    if (hasRefresh) {
      final refreshed = await _refreshAccessToken();
      return refreshed != null && refreshed.isNotEmpty;
    }

    // Access token expired and no refresh token — force re-login.
    await TokenManager.instance.clearToken();
    return false;
  }

  /// Exchanges a Firebase ID token for backend access/refresh tokens.
  static Future<bool> exchangeFirebaseSession({
    required String firebaseToken,
    required String phoneNumber,
  }) async {
    final formattedPhone = phoneNumber.startsWith('+')
        ? phoneNumber
        : '+91$phoneNumber';
    try {
      final response = await Dio(
        BaseOptions(baseUrl: ApiConstants.baseUrl),
      ).post(
        ApiConstants.authVerify,
        data: {
          'firebaseToken': firebaseToken,
          'phone': formattedPhone,
          'provider': 'firebase',
          'purpose': 'login',
        },
      );
      final resData = response.data;
      if (resData is! Map<String, dynamic>) return false;
      final dataMap = resData['data'] is Map<String, dynamic>
          ? resData['data'] as Map<String, dynamic>
          : resData;
      final accessToken =
          (dataMap['accessToken'] ?? dataMap['token']) as String?;
      final refreshToken = dataMap['refreshToken'] as String?;
      if (accessToken == null || accessToken.isEmpty) return false;
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await TokenManager.instance.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      } else {
        await TokenManager.instance.saveToken(accessToken);
      }
      return true;
    } catch (e) {
      developer.log('Failed to exchange Firebase session: $e');
      return false;
    }
  }

  /// Fetches profile status for the authenticated user from GET /user/me.
  static Future<Map<String, dynamic>?> getUserMe() async {
    try {
      final api = await ApiService.authenticated();
      final response = await api.get(ApiConstants.userMe);
      final resData = response.data;
      if (resData is Map<String, dynamic>) {
        final dataMap = resData['data'] is Map<String, dynamic>
            ? resData['data'] as Map<String, dynamic>
            : resData;
        return dataMap;
      }
    } catch (e) {
      developer.log('Failed to fetch user/me: $e');
    }
    return null;
  }

  static bool _isJwtExpired(String token, {int skewSeconds = 30}) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final normalized = base64Url.normalize(parts[1]);
      final payload =
          jsonDecode(utf8.decode(base64Url.decode(normalized)))
              as Map<String, dynamic>;
      final exp = payload['exp'];
      if (exp is! int) return true;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return now >= (exp - skewSeconds);
    } catch (_) {
      return true;
    }
  }

  static Future<String?> _refreshAccessToken() {
    return _refreshInFlight ??= _doRefresh().whenComplete(() {
      _refreshInFlight = null;
    });
  }

  static Future<String?> _doRefresh() async {
    final refreshToken = await TokenManager.instance.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

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
            ? resData['data'] as Map<String, dynamic>
            : resData;
        newAccessToken =
            (dataMap['accessToken'] ?? dataMap['token']) as String?;
        newRefreshToken = dataMap['refreshToken'] as String?;
      }

      if (newAccessToken == null || newAccessToken.isEmpty) {
        await TokenManager.instance.clearToken();
        CcRouteHelper.pushAndPopUntil(CcRouteConstants.phoneLogin);
        return null;
      }

      await TokenManager.instance.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken ?? refreshToken,
      );
      return newAccessToken;
    } catch (e) {
      developer.log('Failed to refresh token: $e');
      await TokenManager.instance.clearToken();
      CcRouteHelper.pushAndPopUntil(CcRouteConstants.phoneLogin);
      return null;
    }
  }

  void _initializeInterceptors() {
    if (kDebugMode) {
      _dio.interceptors.add(DebugInterceptor());
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenManager.instance.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
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

          // 1. Check for 403 PROFILE_INCOMPLETE -> navigate to Complete Profile without retry
          if (error.response?.statusCode == 403) {
            final resData = error.response?.data;
            if (resData is Map<String, dynamic> &&
                resData['message'] == 'PROFILE_INCOMPLETE') {
              CcRouteHelper.pushAndPopUntil(CcRouteConstants.completeProfile);
              return handler.next(error);
            }
          }

          // 2. Check for 401 Unauthorized
          if (error.response?.statusCode == 401) {
            // If /auth/token/refresh itself failed with 401
            if (error.requestOptions.path.contains('/auth/token/refresh') ||
                error.requestOptions.path.contains(ApiConstants.authRefresh)) {
              await TokenManager.instance.clearToken();
              CcRouteHelper.pushAndPopUntil(CcRouteConstants.phoneLogin);
              return handler.next(error);
            }

            final refreshToken =
                await TokenManager.instance.getRefreshToken();
            if (refreshToken != null && refreshToken.isNotEmpty) {
              final newAccessToken = await _refreshAccessToken();
              if (newAccessToken != null && newAccessToken.isNotEmpty) {
                final opts = error.requestOptions;
                opts.headers['Authorization'] = 'Bearer $newAccessToken';
                try {
                  final cloneReq = await _dio.fetch(opts);
                  return handler.resolve(cloneReq);
                } catch (e) {
                  return handler.next(
                    e is DioException
                        ? e
                        : DioException(requestOptions: opts, error: e),
                  );
                }
              } else {
                await TokenManager.instance.clearToken();
                CcRouteHelper.pushAndPopUntil(CcRouteConstants.phoneLogin);
              }
            } else {
              await TokenManager.instance.clearToken();
              CcRouteHelper.pushAndPopUntil(CcRouteConstants.phoneLogin);
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
