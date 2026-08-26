part of 'login_screen_bloc.dart';

abstract class LoginScreenEvent {}

class LoginScreenLoadEvent extends LoginScreenEvent {}

class SendOtpEvent extends LoginScreenEvent {
  final String phoneNumber;
  SendOtpEvent({required this.phoneNumber});
}

class VerifyOtpEvent extends LoginScreenEvent {
  final String phoneNumber;
  final String otp;
  VerifyOtpEvent({required this.phoneNumber, required this.otp});
}

class OtpAutoVerifiedEvent extends LoginScreenEvent {
  final PhoneAuthCredential credential;
  OtpAutoVerifiedEvent({required this.credential});
}

class OtpCodeSentEvent extends LoginScreenEvent {
  final String phoneNumber;
  OtpCodeSentEvent({required this.phoneNumber});
}

class OtpSendFailedEvent extends LoginScreenEvent {
  final String message;
  OtpSendFailedEvent({required this.message});
}

class ResendOtpEvent extends LoginScreenEvent {
  final String phoneNumber;
  ResendOtpEvent({required this.phoneNumber});
}

class CompleteProfileEvent extends LoginScreenEvent {
  final String name;
  final String age;
  final String gender;
  final String bloodType;
  CompleteProfileEvent({
    required this.name,
    required this.age,
    required this.gender,
    required this.bloodType,
  });
}
