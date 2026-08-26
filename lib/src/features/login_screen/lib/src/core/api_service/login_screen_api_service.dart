import 'package:core/core.dart';
import '../../../login_screen.dart';

class LoginScreenApiService {
  final ApiService apiService = ApiService();

  Future<LoginScreenNetworkModel> getLoginScreensData() async {
    final rawResponse = LoginScreenMockContract.onboardingMockResponse;
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

  Future<void> completeProfile({
    required String name,
    required String age,
    required String gender,
    required String bloodType,
  }) async {
    return apiService.mock(
      method: 'POST',
      url: '/api/auth/complete-profile',
      requestBody: {'name': name, 'age': age, 'gender': gender, 'bloodType': bloodType},
      execute: () async {
        await Future.delayed(const Duration(milliseconds: 800));
        final mockResponse = LoginScreenMockContract.completeProfileMockResponse;
        if (mockResponse['success'] != true) {
          throw Exception('Failed to complete profile');
        }
      },
    );
  }

  Future<void> saveAuthToken(String token) async {
    await TokenManager.instance.saveToken(token);
  }
}
