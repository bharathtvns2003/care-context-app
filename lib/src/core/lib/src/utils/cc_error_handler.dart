import 'dart:io';
import 'package:design/design.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../navigation/cc_route_helper.dart';

class CcErrorHandler {
  CcErrorHandler._();

  /// Displays an interactive Error Bottom Sheet for any exception or error.
  /// Automatically parses [DioException], [SocketException], or generic errors.
  /// If [context] is omitted, uses the global navigator context from [CcRouteHelper].
  static Future<T?> showErrorBottomSheet<T>(
    dynamic error, {
    BuildContext? context,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
    String? customTitle,
    String? customMessage,
    bool isDismissible = true,
  }) {
    final ctx = context ?? _tryGetContext();
    if (ctx == null) {
      debugPrint('CcErrorHandler: Navigator context unavailable to show bottom sheet.');
      return Future.value(null);
    }

    final model = parseErrorToModel(
      error,
      onRetry: onRetry,
      onDismiss: onDismiss,
      customTitle: customTitle,
      customMessage: customMessage,
    );

    return CcErrorBottomSheet.show<T>(
      ctx,
      errorModel: model,
      isDismissible: isDismissible,
    );
  }

  /// Parses any exception into a structured [CcErrorModel]
  static CcErrorModel parseErrorToModel(
    dynamic error, {
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
    String? customTitle,
    String? customMessage,
  }) {
    if (error is DioException) {
      return _parseDioException(
        error,
        onRetry: onRetry,
        onDismiss: onDismiss,
        customTitle: customTitle,
        customMessage: customMessage,
      );
    }

    if (error is SocketException) {
      return CcErrorModel.noInternet(
        title: customTitle,
        message: customMessage,
        technicalDetails: error.toString(),
        onRetry: onRetry,
        onDismiss: onDismiss,
      );
    }

    // Default Fallback Exception
    return CcErrorModel.general(
      title: customTitle,
      message: customMessage ?? (error is Exception ? error.toString().replaceAll('Exception: ', '') : null),
      technicalDetails: error.toString(),
      onRetry: onRetry,
      onDismiss: onDismiss,
    );
  }

  static CcErrorModel _parseDioException(
    DioException dioError, {
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
    String? customTitle,
    String? customMessage,
  }) {
    final statusCode = dioError.response?.statusCode;
    final serverMessage = _extractServerMessage(dioError.response?.data);
    final techDetails = 'Method: ${dioError.requestOptions.method}\n'
        'Path: ${dioError.requestOptions.path}\n'
        'StatusCode: ${statusCode ?? "N/A"}\n'
        'Response: ${dioError.response?.data}\n'
        'Error: ${dioError.message}';

    // 1. TIMEOUTS (Connection timeout, Send timeout, Receive timeout)
    if (dioError.type == DioExceptionType.connectionTimeout ||
        dioError.type == DioExceptionType.sendTimeout ||
        dioError.type == DioExceptionType.receiveTimeout) {
      return CcErrorModel.timeout(
        title: customTitle,
        message: customMessage ?? 'The server took too long to respond (${dioError.type.name}). Please check your connection and retry.',
        errorCode: 'TIMEOUT_${statusCode ?? "504"}',
        technicalDetails: techDetails,
        onRetry: onRetry,
        onCancel: onDismiss,
      );
    }

    // 2. NO INTERNET / CONNECTION ERROR
    if (dioError.type == DioExceptionType.connectionError ||
        dioError.error is SocketException) {
      return CcErrorModel.noInternet(
        title: customTitle,
        message: customMessage,
        errorCode: 'NET_OFFLINE',
        technicalDetails: techDetails,
        onRetry: onRetry,
        onDismiss: onDismiss,
      );
    }

    // 3. SERVER SIDE ISSUES (5xx)
    if (statusCode != null && statusCode >= 500) {
      return CcErrorModel.serverError(
        title: customTitle,
        message: customMessage ?? serverMessage ?? CcErrorType.serverError.defaultMessage,
        errorCode: 'HTTP_$statusCode',
        technicalDetails: techDetails,
        onRetry: onRetry,
        onClose: onDismiss,
      );
    }

    // 4. AUTHENTICATION FAILURE (401 / 403)
    if (statusCode == 401 || statusCode == 403) {
      return CcErrorModel.unauthorized(
        title: customTitle,
        message: customMessage ?? serverMessage ?? CcErrorType.unauthorized.defaultMessage,
        errorCode: 'AUTH_$statusCode',
        technicalDetails: techDetails,
        onLogIn: onRetry,
        onDismiss: onDismiss,
      );
    }

    // 5. API FAILURES (400, 404, BAD REQUEST)
    if (statusCode != null && statusCode >= 400 && statusCode < 500) {
      return CcErrorModel.apiFailure(
        title: customTitle ?? (statusCode == 404 ? 'Resource Not Found' : 'Invalid Request'),
        message: customMessage ?? serverMessage ?? CcErrorType.apiFailure.defaultMessage,
        errorCode: 'HTTP_$statusCode',
        technicalDetails: techDetails,
        onRetry: onRetry,
        onDismiss: onDismiss,
      );
    }

    // 6. GENERAL FALLBACK
    return CcErrorModel.general(
      title: customTitle,
      message: customMessage ?? serverMessage ?? dioError.message,
      errorCode: 'DIO_${dioError.type.name.toUpperCase()}',
      technicalDetails: techDetails,
      onRetry: onRetry,
      onDismiss: onDismiss,
    );
  }

  static String? _extractServerMessage(dynamic responseData) {
    if (responseData == null) return null;
    if (responseData is String && responseData.isNotEmpty) {
      return responseData.length > 200 ? responseData.substring(0, 200) : responseData;
    }
    if (responseData is Map<String, dynamic>) {
      final msg = responseData['message'] ??
          responseData['msg'] ??
          responseData['error'] ??
          responseData['detail'] ??
          responseData['description'];
      if (msg != null) return msg.toString();
    }
    return null;
  }

  /// Explicitly display an API Failure Bottom Sheet
  static Future<T?> showApiFailure<T>({
    BuildContext? context,
    String? title,
    String? message,
    String? errorCode,
    String? technicalDetails,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    final ctx = context ?? _tryGetContext();
    if (ctx == null) return Future.value(null);

    final model = CcErrorModel.apiFailure(
      title: title,
      message: message,
      errorCode: errorCode,
      technicalDetails: technicalDetails,
      onRetry: onRetry,
      onDismiss: onDismiss,
    );

    return CcErrorBottomSheet.show<T>(ctx, errorModel: model);
  }

  /// Explicitly display a Timeout Bottom Sheet (Page Timeout / Network Timeout)
  static Future<T?> showTimeout<T>({
    BuildContext? context,
    String? title,
    String? message,
    String? errorCode,
    String? technicalDetails,
    VoidCallback? onRetry,
    VoidCallback? onCancel,
  }) {
    final ctx = context ?? _tryGetContext();
    if (ctx == null) return Future.value(null);

    final model = CcErrorModel.timeout(
      title: title,
      message: message,
      errorCode: errorCode,
      technicalDetails: technicalDetails,
      onRetry: onRetry,
      onCancel: onCancel,
    );

    return CcErrorBottomSheet.show<T>(ctx, errorModel: model);
  }

  /// Explicitly display a Server Side Error Bottom Sheet (500 / 502 / 503)
  static Future<T?> showServerError<T>({
    BuildContext? context,
    String? title,
    String? message,
    String? errorCode,
    String? technicalDetails,
    VoidCallback? onRetry,
    VoidCallback? onClose,
  }) {
    final ctx = context ?? _tryGetContext();
    if (ctx == null) return Future.value(null);

    final model = CcErrorModel.serverError(
      title: title,
      message: message,
      errorCode: errorCode,
      technicalDetails: technicalDetails,
      onRetry: onRetry,
      onClose: onClose,
    );

    return CcErrorBottomSheet.show<T>(ctx, errorModel: model);
  }

  /// Explicitly display a No Internet / Network Error Bottom Sheet
  static Future<T?> showNoInternet<T>({
    BuildContext? context,
    String? title,
    String? message,
    String? errorCode,
    String? technicalDetails,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    final ctx = context ?? _tryGetContext();
    if (ctx == null) return Future.value(null);

    final model = CcErrorModel.noInternet(
      title: title,
      message: message,
      errorCode: errorCode,
      technicalDetails: technicalDetails,
      onRetry: onRetry,
      onDismiss: onDismiss,
    );

    return CcErrorBottomSheet.show<T>(ctx, errorModel: model);
  }

  /// Explicitly display an Unauthorized / Session Expired Bottom Sheet
  static Future<T?> showUnauthorized<T>({
    BuildContext? context,
    String? title,
    String? message,
    String? errorCode,
    String? technicalDetails,
    VoidCallback? onLogIn,
    VoidCallback? onDismiss,
  }) {
    final ctx = context ?? _tryGetContext();
    if (ctx == null) return Future.value(null);

    final model = CcErrorModel.unauthorized(
      title: title,
      message: message,
      errorCode: errorCode,
      technicalDetails: technicalDetails,
      onLogIn: onLogIn,
      onDismiss: onDismiss,
    );

    return CcErrorBottomSheet.show<T>(ctx, errorModel: model);
  }

  static BuildContext? _tryGetContext() {
    try {
      return CcRouteHelper.navigatorContext;
    } catch (_) {
      return null;
    }
  }
}
