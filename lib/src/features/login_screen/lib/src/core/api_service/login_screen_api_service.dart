import 'package:core/core.dart';
import '../../../login_screen.dart';

class LoginScreenApiService {
  final ApiService apiService = ApiService();

  Future<LoginScreenNetworkModel> getLoginScreensData() async {
    final rawResponse = RemoteConfigService.instance.getJson('login_screen_config');
    return apiService.mock(
      method: 'GET',
      url: '/api/login/config',
      rawResponse: rawResponse,
      execute: () async {
        return LoginScreenNetworkModel.fromJson(rawResponse);
      },
    );
  }

  Future<void> sendOtp(String phoneNumber) async {
    return apiService.mock(
      method: 'POST',
      url: '/api/auth/send-otp',
      requestBody: {'phone': phoneNumber},
      execute: () async {
        await Future.delayed(const Duration(milliseconds: 800));
        final mockResponse = LoginScreenMockContract.sendOtpMockResponse;
        if (mockResponse['success'] != true) {
          throw Exception('Failed to send OTP');
        }
      },
    );
  }

  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    return apiService.mock(
      method: 'POST',
      url: '/api/auth/verify-otp',
      requestBody: {'phone': phoneNumber, 'otp': otp},
      execute: () async {
        await Future.delayed(const Duration(milliseconds: 800));
        return LoginScreenMockContract.verifyOtpMockResponse;
      },
    );
  }

  Future<Map<String, dynamic>> verifyAuthWithBackend({
    required String firebaseToken,
    required String phoneNumber,
  }) async {
    final formattedPhone = phoneNumber.startsWith('+')
        ? phoneNumber
        : '+91$phoneNumber';
    final response = await apiService.post(
      ApiConstants.authVerify,
      data: {
        'firebaseToken': firebaseToken,
        'phone': formattedPhone,
        'provider': 'firebase',
        'purpose': 'login',
      },
    );
    final resData = response.data;
    if (resData is Map<String, dynamic>) {
      final dataMap = resData['data'] is Map<String, dynamic>
          ? resData['data'] as Map<String, dynamic>
          : resData;
      final accessToken = (dataMap['accessToken'] ?? dataMap['token']) as String?;
      final refreshToken = dataMap['refreshToken'] as String?;
      if (accessToken != null && accessToken.isNotEmpty) {
        await TokenManager.instance.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken ?? '',
        );
      }
      return dataMap;
    }
    return {};
  }

  Future<void> submitConsent() async {
    final api = await ApiService.authenticated();
    await api.post(
      ApiConstants.userConsents,
      data: {
        'type': 'health_data_policy',
        'action': 'granted',
        'version': '2026-v1',
      },
    );
  }

  Future<void> updateUserProfile({
    required String fullName,
    required String dateOfBirth,
    required String gender,
  }) async {
    final api = await ApiService.authenticated();
    await api.patch(
      ApiConstants.userProfile,
      data: {
        'fullName': fullName,
        'dateOfBirth': dateOfBirth,
        'gender': gender.toLowerCase(),
      },
    );
  }

  Future<void> refreshAuthToken(String refreshToken) async {
    final response = await apiService.post(
      ApiConstants.authRefresh,
      data: {'refreshToken': refreshToken},
    );
    final resData = response.data;
    if (resData is Map<String, dynamic>) {
      final dataMap = resData['data'] is Map<String, dynamic>
          ? resData['data'] as Map<String, dynamic>
          : resData;
      final accessToken = (dataMap['accessToken'] ?? dataMap['token']) as String?;
      final newRefreshToken = dataMap['refreshToken'] as String?;
      if (accessToken != null && accessToken.isNotEmpty) {
        await TokenManager.instance.saveTokens(
          accessToken: accessToken,
          refreshToken: newRefreshToken ?? refreshToken,
        );
      }
    }
  }

  Future<void> completeProfile({
    required String name,
    required String age,
    required String gender,
    required String bloodType,
  }) async {
    int parsedAge = int.tryParse(age) ?? 25;
    final birthYear = DateTime.now().year - parsedAge;
    final dob = '$birthYear-01-01';

    await updateUserProfile(
      fullName: name,
      dateOfBirth: dob,
      gender: gender,
    );
  }

  Future<void> saveAuthToken(String token) async {
    await TokenManager.instance.saveToken(token);
  }
}
