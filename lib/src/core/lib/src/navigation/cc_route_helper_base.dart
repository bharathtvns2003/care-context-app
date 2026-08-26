import 'package:flutter/material.dart';

abstract class CCRouteHelperBase {
  BuildContext get context;

  Future<dynamic> push(String routeName, {Object? args});

  Future<dynamic> pushReplacement(String routeName, {Object? args});

  Future<dynamic> pushAndPopUntil(
    String routeName, {
    String? popUntilRouteName,
    Object? args,
  });

  void pop({dynamic args});
  bool canPop();
  Future<void> maybePop();
  void popUntil(String routeName);

  Future<T?> openDialog<T>(
    Widget child, {
    bool isDismissible,
    Color barrierColor,
    String? routeName,
  });

  Future<T?> openModalSheet<T>(
    Widget child, {
    bool isDismissible,
    bool isScrollControlled,
    double? height,
    Color? barrierColor,
    String? routeName,
    RouteSettings? routeSettings,
  });

  Future<T?> openBaseModalSheet<T>(
    Widget child, {
    bool isFullScreen,
    String? routeName,
  });

  void syncUrl();
  void forceCleanup();
}
