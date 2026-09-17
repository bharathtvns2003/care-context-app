import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Override in app_routes.dart or main.dart to register feature-specific dependencies.
  // This file provides the global getIt instance and initialization hook.
}

void resetServiceLocator() {
  getIt.reset();
}
