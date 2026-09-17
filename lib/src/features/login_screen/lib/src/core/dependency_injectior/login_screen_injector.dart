import 'package:core/core.dart';
import '../../../login_screen.dart';

class LoginScreenInjector {
  static void register() {
    getIt.registerLazySingleton<FirebaseAuthService>(
      () => FirebaseAuthService(),
    );
    getIt.registerLazySingleton<LoginScreenApiService>(
      () => LoginScreenApiService(),
    );
    getIt.registerLazySingleton<LoginScreenRepository>(
      () => LoginScreenRepository(
        apiService: getIt<LoginScreenApiService>(),
        mapper: const LoginScreenMapper(),
        firebaseAuthService: getIt<FirebaseAuthService>(),
      ),
    );
    getIt.registerLazySingleton<LoginScreenBloc>(
      () => LoginScreenBloc(repository: getIt<LoginScreenRepository>()),
    );
  }
}
