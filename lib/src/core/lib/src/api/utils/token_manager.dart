import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static TokenManager? _instance;

  TokenManager._();

  static TokenManager get instance {
    _instance ??= TokenManager._();
    return _instance!;
  }

  String? _cachedToken;
  String? _cachedRefreshToken;

  Future<void> saveToken(String token) async {
    _cachedToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _cachedToken = accessToken;
    _cachedRefreshToken = refreshToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_tokenKey);
    return _cachedToken;
  }

  Future<String?> getRefreshToken() async {
    if (_cachedRefreshToken != null) return _cachedRefreshToken;
    final prefs = await SharedPreferences.getInstance();
    _cachedRefreshToken = prefs.getString(_refreshTokenKey);
    return _cachedRefreshToken;
  }

  Future<void> clearToken() async {
    _cachedToken = null;
    _cachedRefreshToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  /// Clears all stored tokens and preferences on logout.
  Future<void> clearAll() async {
    _cachedToken = null;
    _cachedRefreshToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Alias to clear all session tokens and data on user logout.
  Future<void> clearAllOnLogout() async {
    await clearAll();
  }

  Future<bool> hasStoredSession() async {
    final access = await getToken();
    final refresh = await getRefreshToken();
    return (access != null && access.isNotEmpty) ||
        (refresh != null && refresh.isNotEmpty);
  }

  bool get hasToken =>
      (_cachedToken != null && _cachedToken!.isNotEmpty) ||
      (_cachedRefreshToken != null && _cachedRefreshToken!.isNotEmpty);
}
