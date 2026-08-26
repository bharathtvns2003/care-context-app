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
