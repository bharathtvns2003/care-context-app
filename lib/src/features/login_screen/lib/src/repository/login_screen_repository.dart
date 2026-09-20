import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../../login_screen.dart';

class LoginScreenRepository {
  final LoginScreenApiService apiService;
  final LoginScreenMapper mapper;
  final FirebaseAuthService firebaseAuthService;

  LoginScreenRepository({
    required this.apiService,
    required this.mapper,
    required this.firebaseAuthService,
  });

  Future<LoginScreenEntity> getLoginScreenData() async {
    final response = await apiService.getLoginScreensData();
    return mapper.fromLoginScreenNetworkModel(response);
  }

  Future<void> sendOtp(
    String phoneNumber, {
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
    required void Function(PhoneAuthCredential credential) onAutoVerified,
  }) async {
    await firebaseAuthService.sendOtp(
      phoneNumber,
      onCodeSent: onCodeSent,
      onError: onError,
      onAutoVerified: onAutoVerified,
    );
  }

  Future<UserCredential> verifyOtp(String otp) async {
    return await firebaseAuthService.verifyOtp(otp);
  }

  Future<UserCredential> signInWithCredential(
    PhoneAuthCredential credential,
  ) async {
    return await firebaseAuthService.signInWithCredential(credential);
  }

  Future<void> completeProfile({
    required String name,
    required String age,
    required String gender,
    required String bloodType,
  }) async {
    await apiService.completeProfile(
      name: name,
      age: age,
      gender: gender,
      bloodType: bloodType,
    );
  }

  Future<Map<String, dynamic>> verifyAuthWithBackend({
    required String firebaseToken,
    required String phoneNumber,
  }) async {
    return await apiService.verifyAuthWithBackend(
      firebaseToken: firebaseToken,
      phoneNumber: phoneNumber,
    );
  }

  Future<void> submitConsent() async {
    await apiService.submitConsent();
  }

  Future<void> saveAuthToken(String token) async {
    await apiService.saveAuthToken(token);
  }
}
