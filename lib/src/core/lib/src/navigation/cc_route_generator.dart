import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:core/src/navigation/cc_route_constants.dart';
import 'package:core/src/utils/app_platform.dart';

typedef CcRouteBuilder = Widget Function(RouteSettings settings);

class RouteGenerator {
  static final Map<String, CcRouteBuilder> _featureRoutes = {};

  static void registerFeatureRoutes(Map<String, CcRouteBuilder> routes) {
    _featureRoutes.addAll(routes);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String? routeName = settings.name?.split('?')[0];

    final builder = _featureRoutes[routeName];
    if (builder != null) {
      final widget = builder(settings);
      return _buildPageRoute(routeName, widget, settings);
    }

    final widget = _buildPageNotFound(routeName ?? 'unknown');
    return _buildPageRoute(routeName, widget, settings);
  }

  static T? getArgs<T>(RouteSettings settings) {
    return settings.arguments as T?;
  }

  static T getArgsOr<T>(RouteSettings settings, T defaultValue) {
    return (settings.arguments as T?) ?? defaultValue;
  }

  static Route<dynamic> _buildPageRoute(
    String? routeName,
    Widget child,
    RouteSettings settings,
  ) {
    if (AppPlatform.isWeb) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        settings: settings,
      );
    }

    if (_noAnimationRoutes.contains(routeName)) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        settings: RouteSettings(name: routeName, arguments: settings.arguments),
        transitionDuration: Duration.zero,
      );
    }

    return CupertinoPageRoute(
      builder: (_) => child,
      settings: RouteSettings(name: routeName, arguments: settings.arguments),
    );
  }

  static const _noAnimationRoutes = <String>{
    CcRouteConstants.splashScreen,
    '/',
  };

  static Widget _buildPageNotFound(String routeName) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Route not found: $routeName',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
