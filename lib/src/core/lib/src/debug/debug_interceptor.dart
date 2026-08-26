import 'package:dio/dio.dart';

import 'api_log_store.dart';

class DebugInterceptor extends Interceptor {
  final Map<RequestOptions, DateTime> _requestTimestamps = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _requestTimestamps[options] = DateTime.now();
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = _requestTimestamps.remove(response.requestOptions);
    final duration = startTime != null ? DateTime.now().difference(startTime) : null;

    ApiLogStore.instance.addLog(ApiLogEntry(
      timestamp: DateTime.now(),
      method: response.requestOptions.method,
      url: response.requestOptions.uri.toString(),
      requestHeaders: response.requestOptions.headers.cast<String, dynamic>(),
      requestBody: response.requestOptions.data,
      statusCode: response.statusCode,
      responseBody: response.data,
      responseHeaders: response.headers.map.cast<String, dynamic>(),
      duration: duration,
    ));

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = _requestTimestamps.remove(err.requestOptions);
    final duration = startTime != null ? DateTime.now().difference(startTime) : null;

    ApiLogStore.instance.addLog(ApiLogEntry(
      timestamp: DateTime.now(),
      method: err.requestOptions.method,
      url: err.requestOptions.uri.toString(),
      requestHeaders: err.requestOptions.headers.cast<String, dynamic>(),
      requestBody: err.requestOptions.data,
      statusCode: err.response?.statusCode,
      responseBody: err.response?.data,
      error: err.message ?? err.type.name,
      duration: duration,
    ));

    handler.next(err);
  }
}
