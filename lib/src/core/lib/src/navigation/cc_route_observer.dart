import 'package:flutter/material.dart';

class CCRouteObserver extends RouteObserver<ModalRoute<dynamic>> {
  CCRouteObserver({required this.onRouteChanged});
  final Function(String? screenName) onRouteChanged;

  void _setRouteName(PageRoute<dynamic> route) {
    final String? screenName = route.settings.name;
    onRouteChanged(screenName);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _setRouteName(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _setRouteName(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _setRouteName(previousRoute);
    } else if (previousRoute is PageRoute) {
      _setRouteName(previousRoute);
    }
  }
}
