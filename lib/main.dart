import 'package:care_context_app/app.dart';
import 'package:care_context_app/routing/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AppRoutes.registerAll();
  runApp(const CareContextApp());
}

class CareContextApp extends StatelessWidget {
  const CareContextApp({super.key});

  @override
  Widget build(BuildContext context) {
    return App();
  }
}
