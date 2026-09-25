import 'package:flutter/foundation.dart';
import 'cc_error_type.dart';

class CcErrorModel {
  final CcErrorType type;
  final String title;
  final String message;
  final String? errorCode;
  final String? technicalDetails;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final bool showCloseButton;

  const CcErrorModel({
    required this.type,
    required this.title,
    required this.message,
    this.errorCode,
    this.technicalDetails,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.showCloseButton = true,
  });

  factory CcErrorModel.apiFailure({
    String? title,
    String? message,
    String? errorCode,
    String? technicalDetails,
    String? primaryButtonText = 'Try Again',
    String? secondaryButtonText = 'Dismiss',
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    const errType = CcErrorType.apiFailure;
    return CcErrorModel(
      type: errType,
      title: title ?? errType.defaultTitle,
      message: message ?? errType.defaultMessage,
      errorCode: errorCode ?? 'API_FAILURE',
      technicalDetails: technicalDetails,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onRetry,
      onSecondaryPressed: onDismiss,
    );
  }

  factory CcErrorModel.timeout({
    String? title,
    String? message,
    String? errorCode,
    String? technicalDetails,
    String? primaryButtonText = 'Retry Request',
    String? secondaryButtonText = 'Cancel',
    VoidCallback? onRetry,
    VoidCallback? onCancel,
  }) {
    const errType = CcErrorType.timeout;
    return CcErrorModel(
      type: errType,
      title: title ?? errType.defaultTitle,
      message: message ?? errType.defaultMessage,
      errorCode: errorCode ?? 'REQ_TIMEOUT',
      technicalDetails: technicalDetails,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onRetry,
      onSecondaryPressed: onCancel,
    );
  }

  factory CcErrorModel.serverError({
    String? title,
    String? message,
    String? errorCode,
    String? technicalDetails,
    String? primaryButtonText = 'Try Again Later',
    String? secondaryButtonText = 'Close',
    VoidCallback? onRetry,
    VoidCallback? onClose,
  }) {
    const errType = CcErrorType.serverError;
    return CcErrorModel(
      type: errType,
      title: title ?? errType.defaultTitle,
      message: message ?? errType.defaultMessage,
      errorCode: errorCode ?? 'HTTP_500',
      technicalDetails: technicalDetails,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onRetry,
      onSecondaryPressed: onClose,
    );
  }

  factory CcErrorModel.noInternet({
    String? title,
    String? message,
    String? errorCode,
    String? technicalDetails,
    String? primaryButtonText = 'Check & Retry',
    String? secondaryButtonText = 'Dismiss',
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    const errType = CcErrorType.noInternet;
    return CcErrorModel(
      type: errType,
      title: title ?? errType.defaultTitle,
      message: message ?? errType.defaultMessage,
      errorCode: errorCode ?? 'NO_INTERNET',
      technicalDetails: technicalDetails,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onRetry,
      onSecondaryPressed: onDismiss,
    );
  }

  factory CcErrorModel.unauthorized({
    String? title,
    String? message,
    String? errorCode,
    String? technicalDetails,
    String? primaryButtonText = 'Log In Again',
    String? secondaryButtonText = 'Dismiss',
    VoidCallback? onLogIn,
    VoidCallback? onDismiss,
  }) {
    const errType = CcErrorType.unauthorized;
    return CcErrorModel(
      type: errType,
      title: title ?? errType.defaultTitle,
      message: message ?? errType.defaultMessage,
      errorCode: errorCode ?? 'AUTH_401',
      technicalDetails: technicalDetails,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onLogIn,
      onSecondaryPressed: onDismiss,
    );
  }

  factory CcErrorModel.general({
    String? title,
    String? message,
    String? errorCode,
    String? technicalDetails,
    String? primaryButtonText = 'Try Again',
    String? secondaryButtonText = 'Dismiss',
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    const errType = CcErrorType.general;
    return CcErrorModel(
      type: errType,
      title: title ?? errType.defaultTitle,
      message: message ?? errType.defaultMessage,
      errorCode: errorCode ?? 'ERR_GENERIC',
      technicalDetails: technicalDetails,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onRetry,
      onSecondaryPressed: onDismiss,
    );
  }
}
