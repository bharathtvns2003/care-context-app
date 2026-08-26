import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../login_screen.dart';

part 'login_screen_event.dart';
part 'login_screen_state.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  final LoginScreenRepository repository;

  LoginScreenBloc({required this.repository})
    : super(LoginScreenInitialState()) {
    on<LoginScreenLoadEvent>(_onLoadData);
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<OtpAutoVerifiedEvent>(_onAutoVerified);
    on<OtpCodeSentEvent>(_onCodeSent);
    on<OtpSendFailedEvent>(_onSendFailed);
    on<CompleteProfileEvent>(_onCompleteProfile);
    on<ResendOtpEvent>(_onResendOtp);
  }

  Future<void> _onLoadData(
    LoginScreenLoadEvent event,
    Emitter<LoginScreenState> emit,
  ) async {
    try {
      emit(LoginScreenLoadingState());
      final result = await repository.getLoginScreenData();
      emit(LoginScreenDataLoadedState(loginScreenEntity: result));
    } catch (e) {
      emit(LoginScreenErrorState(message: e.toString()));
    }
  }

  Future<void> _onSendOtp(
    SendOtpEvent event,
    Emitter<LoginScreenState> emit,
  ) async {
    emit(LoginScreenLoadingState());
    await repository.sendOtp(
      event.phoneNumber,
      onCodeSent: (verificationId) {
        add(OtpCodeSentEvent(phoneNumber: event.phoneNumber));
      },
      onError: (error) {
        add(OtpSendFailedEvent(message: error));
      },
      onAutoVerified: (credential) {
        add(OtpAutoVerifiedEvent(credential: credential));
      },
    );
  }

  void _onCodeSent(
    OtpCodeSentEvent event,
    Emitter<LoginScreenState> emit,
  ) {
    emit(OtpSentState(phoneNumber: event.phoneNumber));
  }

  void _onSendFailed(
    OtpSendFailedEvent event,
    Emitter<LoginScreenState> emit,
  ) {
    emit(LoginScreenErrorState(message: event.message));
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<LoginScreenState> emit,
  ) async {
    try {
      emit(LoginScreenLoadingState());
      final userCredential = await repository.verifyOtp(event.otp);
      final token = await userCredential.user?.getIdToken() ?? '';
      if (token.isNotEmpty) {
        await repository.saveAuthToken(token);
      }
      emit(OtpVerifiedState(token: token));
    } catch (e) {
      String message = 'Verification failed';
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-verification-code') {
          message = 'Invalid OTP. Please try again.';
        } else {
          message = e.message ?? message;
        }
      }
      emit(LoginScreenErrorState(message: message));
    }
  }

  Future<void> _onAutoVerified(
    OtpAutoVerifiedEvent event,
    Emitter<LoginScreenState> emit,
  ) async {
    try {
      emit(LoginScreenLoadingState());
      final userCredential = await repository.signInWithCredential(
        event.credential,
      );
      final token = await userCredential.user?.getIdToken() ?? '';
      if (token.isNotEmpty) {
        await repository.saveAuthToken(token);
      }
      emit(OtpVerifiedState(token: token));
    } catch (e) {
      emit(LoginScreenErrorState(message: 'Auto-verification failed'));
    }
  }

  Future<void> _onCompleteProfile(
    CompleteProfileEvent event,
    Emitter<LoginScreenState> emit,
  ) async {
    try {
      emit(LoginScreenLoadingState());
      await repository.completeProfile(
        name: event.name,
        age: event.age,
        gender: event.gender,
        bloodType: event.bloodType,
      );
      emit(ProfileCompletedState());
    } catch (e) {
      emit(LoginScreenErrorState(message: e.toString()));
    }
  }

  Future<void> _onResendOtp(
    ResendOtpEvent event,
    Emitter<LoginScreenState> emit,
  ) async {
    await repository.sendOtp(
      event.phoneNumber,
      onCodeSent: (verificationId) {
        add(OtpCodeSentEvent(phoneNumber: event.phoneNumber));
      },
      onError: (error) {
        add(OtpSendFailedEvent(message: error));
      },
      onAutoVerified: (credential) {
        add(OtpAutoVerifiedEvent(credential: credential));
      },
    );
  }
}
