import 'package:core/src/navigation/navigation.dart';
import 'package:core/src/utils/device_utils.dart';
import 'package:flutter/material.dart';

class MobileRouteHelper implements CCRouteHelperBase {
  final GlobalKey<NavigatorState> _navigatorKey;

  MobileRouteHelper(this._navigatorKey);

  @override
  BuildContext get context => _navigatorKey.currentContext!;

  @override
  Future<dynamic> push(String routeName, {Object? args}) {
    return Navigator.of(context).pushNamed(routeName, arguments: args);
  }

  @override
  Future<dynamic> pushReplacement(String routeName, {Object? args}) {
    return Navigator.of(
      context,
    ).pushReplacementNamed(routeName, arguments: args);
  }

  @override
  Future<dynamic> pushAndPopUntil(
    String routeName, {
    String? popUntilRouteName,
    Object? args,
  }) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      popUntilRouteName != null
          ? ModalRoute.withName(popUntilRouteName)
          : (_) => false,
      arguments: args,
    );
  }

  @override
  void pop({args}) => Navigator.of(context).pop(args);

  @override
  bool canPop() => Navigator.of(context).canPop();

  @override
  Future<void> maybePop() => Navigator.of(context).maybePop();

  @override
  void popUntil(String routeName) {
    Navigator.of(context).popUntil(ModalRoute.withName(routeName));
  }

  @override
  Future<T?> openDialog<T>(
    Widget child, {
    bool isDismissible = true,
    Color barrierColor = Colors.black54,
    String? routeName,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      barrierColor: barrierColor,
      builder: (_) => child,
    );
  }

  @override
  Future<T?> openModalSheet<T>(
    Widget child, {
    bool isDismissible = true,
    bool isScrollControlled = true,
    double? height,
    Color? barrierColor,
    String? routeName,
    RouteSettings? routeSettings,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      enableDrag: isDismissible,
      barrierColor: barrierColor,
      elevation: 4,
      constraints: BoxConstraints(
        maxHeight: height ?? DeviceUtils.deviceHeight * 0.95,
      ),
      routeSettings: routeSettings ?? RouteSettings(name: routeName),
      builder: (_) =>
          isDismissible ? child : PopScope(canPop: false, child: child),
    );
  }

  @override
  Future<T?> openBaseModalSheet<T>(
    Widget child, {
    bool isFullScreen = false,
    String? routeName,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black54,
      constraints: BoxConstraints(
        maxHeight: isFullScreen
            ? DeviceUtils.deviceHeight
            : DeviceUtils.deviceHeight - (DeviceUtils.statusBarHeight + 10),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      routeSettings: RouteSettings(name: routeName),
      builder: (_) => child,
    );
  }

  @override
  void syncUrl() {} // No-op for mobile

  @override
  void forceCleanup() {} // No-op for mobile
}
