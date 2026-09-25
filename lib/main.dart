import 'package:care_context_app/app.dart';
import 'package:care_context_app/routing/app_routes.dart';
import 'package:care_context_app/src/features/home/lib/home.dart';
import 'package:care_context_app/src/features/login_screen/lib/login_screen.dart';
import 'package:core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PushNotificationService.instance.initialize();
  await RemoteConfigService.instance.initialize();
  _registerDependencies();
  AppRoutes.registerAll();
  runApp(const CareContextApp());
}

void _registerDependencies() {
  LoginScreenInjector.register();
  HomeInjector.register();
}

class CareContextApp extends StatelessWidget {
  const CareContextApp({super.key});

  @override
  Widget build(BuildContext context) {
    return App();
  }
}
