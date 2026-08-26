class ApiResponse<T> {
  final T? data;
  final String? code;
  final bool success;
  final Error? error;

  ApiResponse({this.data, this.code, required this.success, this.error});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponse(
      data: fromJsonT(json['data']),
      code: json['code'],
      success: json['success'] ?? true,
      error: Error.fromJson(json['error']),
    );
  }
}

class Error {
  final String? message;
  final String? code;

  Error({this.message, this.code});

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(message: json['message'], code: json['code']);
  }
}
