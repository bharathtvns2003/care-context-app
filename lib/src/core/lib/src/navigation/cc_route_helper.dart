import 'package:core/src/navigation/navigation.dart';
import 'package:core/src/utils/app_platform.dart';
import 'package:flutter/material.dart';

class CcRouteHelper {
  static late final CCRouteHelperBase _delegate;

  static late final GlobalKey<NavigatorState> _navigatorKey;
  static BuildContext get navigatorContext => _navigatorKey.currentContext!;

  static void init(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
    if (AppPlatform.isMobile) {
      _delegate = MobileRouteHelper(navigatorKey);
    } else {}
  }

  static Future<dynamic> push(String routeName, {Object? args}) =>
      _delegate.push(routeName, args: args);

  static Future<dynamic> pushReplacement(String routeName, {Object? args}) =>
      _delegate.pushReplacement(routeName, args: args);

  static Future<dynamic> pushAndPopUntil(
    String routeName, {
    String? popUntilRouteName,
    Object? args,
  }) => _delegate.pushAndPopUntil(
    routeName,
    popUntilRouteName: popUntilRouteName,
    args: args,
  );

  static void pop({dynamic args}) => _delegate.pop(args: args);

  static bool canPop() => _delegate.canPop();

  static Future<void> maybePop() => _delegate.maybePop();

  static void popUntil(String routeName) => _delegate.popUntil(routeName);

  static Future<T?> openDialog<T>(
    Widget child, {
    bool isDismissible = true,
    Color barrierColor = Colors.black54,
    String? routeName,
  }) => _delegate.openDialog(
    child,
    isDismissible: isDismissible,
    barrierColor: barrierColor,
    routeName: routeName,
  );

  static Future<T?> openModalSheet<T>(
    Widget child, {
    bool isDismissible = true,
    bool isScrollControlled = true,
    double? height,
    Color? barrierColor,
    String? routeName,
    RouteSettings? routeSettings,
  }) => _delegate.openModalSheet(
    child,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    height: height,
    barrierColor: barrierColor,
    routeName: routeName,
    routeSettings: routeSettings,
  );

  static Future<T?> openBaseModalSheet<T>(
    Widget child, {
    bool isFullScreen = false,
    String? routeName,
  }) => _delegate.openBaseModalSheet(
    child,
    isFullScreen: isFullScreen,
    routeName: routeName,
  );

  static void syncUrl() => _delegate.syncUrl();

  static void forceCleanup() => _delegate.forceCleanup();
}
