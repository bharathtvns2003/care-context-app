import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../../../login_screen.dart';

class LoginScreenPage extends StatelessWidget {
  const LoginScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginScreenBloc(
        repository: LoginScreenRepository(
          apiService: LoginScreenApiService(),
          mapper: const LoginScreenMapper(),
          firebaseAuthService: FirebaseAuthService(),
        ),
      ),
      child: const PhoneLoginScreen(),
    );
  }
}
