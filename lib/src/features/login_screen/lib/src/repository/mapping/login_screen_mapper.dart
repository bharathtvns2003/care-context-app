import '../../../login_screen.dart';

class LoginScreenMapper {
  const LoginScreenMapper();

  LoginScreenEntity fromLoginScreenNetworkModel(LoginScreenNetworkModel model) {
    return LoginScreenEntity(
      enterPhone: fromLoginScreenEnterPhoneNetworkModel(model.enterPhone),
      verifyOtp: fromLoginScreenVerifyOtpNetworkModel(model.verifyOtp),
      completeProfile: fromLoginScreenCompleteProfileNetworkModel(
        model.completeProfile,
      ),
    );
  }

  LoginScreenEnterPhoneEntity fromLoginScreenEnterPhoneNetworkModel(
    LoginScreenEnterPhoneNetworkModel model,
  ) {
    return LoginScreenEnterPhoneEntity(
      title: model.title,
      subtitle: model.subtitle,
      iconUrl: model.iconUrl,
      input: fromLoginScreenInputFieldNetworkModel(model.input),
      disclaimer: fromLoginScreenDisclaimerNetworkModel(model.disclaimer),
      ctaText: model.ctaText,
    );
  }

  LoginScreenVerifyOtpEntity fromLoginScreenVerifyOtpNetworkModel(
    LoginScreenVerifyOtpNetworkModel model,
  ) {
    return LoginScreenVerifyOtpEntity(
      title: model.title,
      subtitle: model.subtitle,
      iconUrl: model.iconUrl,
      otp: fromLoginScreenOtpConfigNetworkModel(model.otp),
      disclaimer: fromLoginScreenDisclaimerNetworkModel(model.disclaimer),
      ctaText: model.ctaText,
      secondaryAction: model.secondaryAction,
      secondaryActionText: model.secondaryActionText,
    );
  }

  LoginScreenCompleteProfileEntity fromLoginScreenCompleteProfileNetworkModel(
    LoginScreenCompleteProfileNetworkModel model,
  ) {
    return LoginScreenCompleteProfileEntity(
      title: model.title,
      subtitle: model.subtitle,
      fields: model.fields
          .map((e) => fromLoginScreenInputFieldNetworkModel(e))
          .toList(),
      selection: model.selection
          .map((e) => fromLoginScreenSelectionNetworkModel(e))
          .toList(),
      disclaimer: fromLoginScreenDisclaimerNetworkModel(model.disclaimer),
      ctaText: model.ctaText,
    );
  }

  LoginScreenInputFieldEntity fromLoginScreenInputFieldNetworkModel(
    LoginScreenInputFieldNetworkModel model,
  ) {
    return LoginScreenInputFieldEntity(
      label: model.label,
      placeholder: model.placeholder,
    );
  }

  LoginScreenSelectionEntity fromLoginScreenSelectionNetworkModel(
    LoginScreenSelectionNetworkModel model,
  ) {
    return LoginScreenSelectionEntity(
      label: model.label,
      options: model.options,
    );
  }

  LoginScreenDisclaimerEntity fromLoginScreenDisclaimerNetworkModel(
    LoginScreenDisclaimerNetworkModel model,
  ) {
    return LoginScreenDisclaimerEntity(
      iconUrl: model.iconUrl,
      text: model.text,
    );
  }

  LoginScreenOtpConfigEntity fromLoginScreenOtpConfigNetworkModel(
    LoginScreenOtpConfigNetworkModel model,
  ) {
    return LoginScreenOtpConfigEntity(length: model.length);
  }
}
