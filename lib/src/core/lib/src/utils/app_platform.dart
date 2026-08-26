import 'dart:io';

import 'package:flutter/foundation.dart';

/// [AppPlatform] is created to overcome current Platform.io issue
/// and have a standard to flow
/// As on web Platform.io is not available it crashes there
/// To avoid this we initially checking for [kIsWeb].
///
/// [kIsWeb] is constant from flutter which can used on any OS
/// helps to first check and avoid Platform.io crash on web
class AppPlatform {
  const AppPlatform._();

  /// Returns true if this is mobile os Android, iOS even iPAD OS
  static bool get isMobile {
    if (kIsWeb) {
      return false;
    } else if (Platform.isAndroid) {
      return true;
    } else if (Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }

  /// Return true is it is running on web (browser)
  static bool get isWeb {
    if (kIsWeb) {
      return true;
    } else {
      return false;
    }
  }

  /// Returns true if it's Android only
  /// isMobile is required to check as on web it can crash
  static bool get isAndroid {
    return isMobile && Platform.isAndroid;
  }

  /// Returns true if it's iOS only
  /// isMobile is required to check as on web it can crash
  static bool get isIOS {
    return isMobile && Platform.isIOS;
  }

  /// Used to detect OS on Web
  /// Returns true is it's running on apple machine
  /// it can be iPhone, iPad and even Mac
  static bool get isApple {
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  /// Checks if OS is Android,
  /// This is helpful specially in case when we running Flutter Web on Android OS
  static bool get isAndroidOS {
    return defaultTargetPlatform == TargetPlatform.android;
  }

  /// Checks if OS is Apple,
  /// This is helpful specially in case when we running Flutter Web on iOS or Mac OS
  static bool get isAppleOS {
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  /// Checks if OS is iOS,
  /// This is helpful specially in case when we running Flutter Web on iOS
  static bool get isIOSWeb {
    return isWeb && isApple;
  }

  /// Checks if it is running in SDK
  static bool _isSDK = false;
  static void setIsSDK(bool isSDK) {
    _isSDK = isSDK;
  }

  static bool get isSDK => _isSDK;
}
