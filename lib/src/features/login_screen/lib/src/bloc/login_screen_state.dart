part of 'login_screen_bloc.dart';

abstract class LoginScreenState {}

class LoginScreenInitialState extends LoginScreenState {}

class LoginScreenLoadingState extends LoginScreenState {}

class LoginScreenDataLoadedState extends LoginScreenState {
  final LoginScreenEntity loginScreenEntity;
  LoginScreenDataLoadedState({required this.loginScreenEntity});
}

class OtpSentState extends LoginScreenState {
  final String phoneNumber;
  OtpSentState({required this.phoneNumber});
}

class OtpVerifiedState extends LoginScreenState {
  final String token;
  final bool isNewUser;
  OtpVerifiedState({required this.token, required this.isNewUser});
}

class ProfileCompletedState extends LoginScreenState {}

class LoginScreenErrorState extends LoginScreenState {
  final String message;
  LoginScreenErrorState({this.message = 'Something went wrong'});
}
