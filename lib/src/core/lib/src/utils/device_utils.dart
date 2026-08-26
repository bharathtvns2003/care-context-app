import 'dart:math';
import 'package:core/src/utils/app_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceUtils {
  static late MediaQueryData _mediaQueryData;
  static Size get size => _mediaQueryData.size;
  static bool get isPhone => size.shortestSide < 600;
  // static double get sidePadding => isPhone ? 0 : 0.20;
  // Dynamic aspect ratio: portrait = 9:19.5, landscape = 11:19.5
  static double get _aspectRatio =>
      _mediaQueryData.orientation == Orientation.portrait
      ? 9 / 19.5
      : 11 / 19.5;
  static double get deviceHeight => size.height;
  static double get deviceWidth => isPhone
      ? size.width
      : min(max(size.width, size.width * _aspectRatio), 548);

  static bool get hasIphoneBottomNotch =>
      AppPlatform.isIOS && _mediaQueryData.viewPadding.bottom > 0;
  static double get statusBarHeight => _mediaQueryData.padding.top;
  static double get navBarHeight => _mediaQueryData.padding.bottom;

  DeviceUtils(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
  }

  static double fixedBottomScrollPadding({
    BuildContext? context,
    double addOnHeight = 60,
  }) =>
      addOnHeight +
      (context != null ? MediaQuery.of(context) : _mediaQueryData)
          .padding
          .bottom;

  static Future hideKeyboard() {
    if (AppPlatform.isWeb) {
      removeFocus();
    }
    return SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static void removeFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void reFocus(FocusNode focusNode) {
    removeFocus();
    Future.delayed(const Duration(milliseconds: 50), () {
      focusNode.requestFocus();
    });
  }
}
