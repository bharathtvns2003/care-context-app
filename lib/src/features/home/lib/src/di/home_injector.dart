import 'package:core/core.dart';
import '../../home.dart';

class HomeInjector {
  static void register() {
    getIt.registerLazySingleton<HomeApiService>(
      () => HomeApiService(),
    );
    getIt.registerLazySingleton<HomeRepository>(
      () => HomeRepository(
        apiService: getIt<HomeApiService>(),
        mapper: const HomeMapper(),
      ),
    );
    getIt.registerLazySingleton<HomeBloc>(
      () => HomeBloc(repository: getIt<HomeRepository>()),
    );
  }
}
