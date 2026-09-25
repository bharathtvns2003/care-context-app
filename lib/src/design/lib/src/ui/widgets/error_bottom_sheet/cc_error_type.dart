import 'package:flutter/material.dart';
import '../../styles/cc_colors.dart';

enum CcErrorType {
  apiFailure,
  timeout,
  serverError,
  noInternet,
  unauthorized,
  general;

  String get defaultTitle {
    switch (this) {
      case CcErrorType.apiFailure:
        return 'Request Failed';
      case CcErrorType.timeout:
        return 'Connection Timed Out';
      case CcErrorType.serverError:
        return 'Server Error Occurred';
      case CcErrorType.noInternet:
        return 'No Internet Connection';
      case CcErrorType.unauthorized:
        return 'Session Expired';
      case CcErrorType.general:
        return 'Something Went Wrong';
    }
  }

  String get defaultMessage {
    switch (this) {
      case CcErrorType.apiFailure:
        return 'We could not process your request at this moment. Please verify the information and try again.';
      case CcErrorType.timeout:
        return 'The page or request took too long to respond. Please check your network stability and try again.';
      case CcErrorType.serverError:
        return 'Our servers are experiencing technical issues right now. Our engineering team has been notified. Please try again shortly.';
      case CcErrorType.noInternet:
        return 'Please check your Wi-Fi or mobile data connection and retry.';
      case CcErrorType.unauthorized:
        return 'Your login session has expired. Please re-authenticate to continue safely.';
      case CcErrorType.general:
        return 'An unexpected issue occurred while processing your request. Please try again.';
    }
  }

  IconData get icon {
    switch (this) {
      case CcErrorType.apiFailure:
        return Icons.cloud_off_rounded;
      case CcErrorType.timeout:
        return Icons.timer_off_outlined;
      case CcErrorType.serverError:
        return Icons.dns_rounded;
      case CcErrorType.noInternet:
        return Icons.wifi_off_rounded;
      case CcErrorType.unauthorized:
        return Icons.lock_clock_outlined;
      case CcErrorType.general:
        return Icons.error_outline_rounded;
    }
  }

  Color get accentColor {
    switch (this) {
      case CcErrorType.apiFailure:
        return const Color(0xFFE11D48); // Rose Red
      case CcErrorType.timeout:
        return const Color(0xFFF59E0B); // Amber / Orange
      case CcErrorType.serverError:
        return const Color(0xFFDC2626); // Crimson
      case CcErrorType.noInternet:
        return const Color(0xFF6366F1); // Indigo
      case CcErrorType.unauthorized:
        return const Color(0xFF8B5CF6); // Purple
      case CcErrorType.general:
        return CcColors.error;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case CcErrorType.apiFailure:
        return const Color(0xFFFFF1F2);
      case CcErrorType.timeout:
        return const Color(0xFFFFFBEB);
      case CcErrorType.serverError:
        return const Color(0xFFFEF2F2);
      case CcErrorType.noInternet:
        return const Color(0xFFEEF2FF);
      case CcErrorType.unauthorized:
        return const Color(0xFFF5F3FF);
      case CcErrorType.general:
        return CcColors.errorBackground;
    }
  }
}
