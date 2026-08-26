import 'dart:collection';

class ApiLogEntry {
  final DateTime timestamp;
  final String method;
  final String url;
  final Map<String, dynamic>? requestHeaders;
  final dynamic requestBody;
  final int? statusCode;
  final dynamic responseBody;
  final Map<String, dynamic>? responseHeaders;
  final String? error;
  final Duration? duration;

  ApiLogEntry({
    required this.timestamp,
    required this.method,
    required this.url,
    this.requestHeaders,
    this.requestBody,
    this.statusCode,
    this.responseBody,
    this.responseHeaders,
    this.error,
    this.duration,
  });

  bool get isError =>
      error != null || (statusCode != null && statusCode! >= 400);

  String get summary {
    final status = statusCode != null ? '[$statusCode]' : '[PENDING]';
    final dur = duration != null ? '${duration!.inMilliseconds}ms' : '';
    return '$method $status $url $dur';
  }
}

class ApiLogStore {
  ApiLogStore._();
  static final ApiLogStore instance = ApiLogStore._();

  final List<ApiLogEntry> _logs = [];
  static const int _maxLogs = 200;

  UnmodifiableListView<ApiLogEntry> get logs => UnmodifiableListView(_logs);

  final List<void Function()> _listeners = [];

  void addListener(void Function() listener) => _listeners.add(listener);
  void removeListener(void Function() listener) => _listeners.remove(listener);

  void _notify() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void addLog(ApiLogEntry entry) {
    _logs.insert(0, entry);
    if (_logs.length > _maxLogs) {
      _logs.removeLast();
    }
    _notify();
  }

  void logMock({
    required String method,
    required String url,
    dynamic requestBody,
    int statusCode = 200,
    dynamic responseBody,
    Duration? duration,
  }) {
    addLog(
      ApiLogEntry(
        timestamp: DateTime.now(),
        method: method,
        url: url,
        requestBody: requestBody,
        statusCode: statusCode,
        responseBody: responseBody,
        requestHeaders: {'X-Mock': 'true'},
        duration: duration,
      ),
    );
  }

  void clear() {
    _logs.clear();
    _notify();
  }
}
