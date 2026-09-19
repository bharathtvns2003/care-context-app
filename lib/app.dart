import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen/splash_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    CcRouteHelper.init(_navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Care Context',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0AB5A8),
          primary: const Color(0xFF0AB5A8),
          secondary: const Color(0xFF055F58),
          surface: Colors.white,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFF0AB5A8),
        ),
      ),
      navigatorKey: _navigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: const SplashScreenPage(),
      builder: (context, child) => DebugOverlay(
        navigatorKey: _navigatorKey,
        child: child!,
      ),
    );
  }
}
