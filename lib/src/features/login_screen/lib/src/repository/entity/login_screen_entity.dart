class LoginScreenEntity {
  final LoginScreenEnterPhoneEntity enterPhone;
  final LoginScreenVerifyOtpEntity verifyOtp;
  final LoginScreenCompleteProfileEntity completeProfile;

  const LoginScreenEntity({
    required this.enterPhone,
    required this.verifyOtp,
    required this.completeProfile,
  });
}

class LoginScreenEnterPhoneEntity {
  final String title;
  final String subtitle;
  final String iconUrl;
  final LoginScreenInputFieldEntity input;
  final LoginScreenDisclaimerEntity disclaimer;
  final String ctaText;

  const LoginScreenEnterPhoneEntity({
    required this.title,
    required this.subtitle,
    required this.iconUrl,
    required this.input,
    required this.disclaimer,
    required this.ctaText,
  });
}

class LoginScreenVerifyOtpEntity {
  final String title;
  final String subtitle;
  final String iconUrl;
  final LoginScreenOtpConfigEntity otp;
  final LoginScreenDisclaimerEntity disclaimer;
  final String ctaText;
  final String secondaryAction;
  final String secondaryActionText;

  const LoginScreenVerifyOtpEntity({
    required this.title,
    required this.subtitle,
    required this.iconUrl,
    required this.otp,
    required this.disclaimer,
    required this.ctaText,
    required this.secondaryAction,
    required this.secondaryActionText,
  });
}

class LoginScreenCompleteProfileEntity {
  final String title;
  final String subtitle;
  final List<LoginScreenInputFieldEntity> fields;
  final List<LoginScreenSelectionEntity> selection;
  final LoginScreenDisclaimerEntity disclaimer;
  final String ctaText;

  const LoginScreenCompleteProfileEntity({
    required this.title,
    required this.subtitle,
    required this.fields,
    required this.selection,
    required this.disclaimer,
    required this.ctaText,
  });
}

class LoginScreenInputFieldEntity {
  final String label;
  final String placeholder;

  const LoginScreenInputFieldEntity({
    required this.label,
    required this.placeholder,
  });
}

class LoginScreenSelectionEntity {
  final String label;
  final List<String> options;

  const LoginScreenSelectionEntity({
    required this.label,
    required this.options,
  });
}

class LoginScreenDisclaimerEntity {
  final String iconUrl;
  final String text;

  const LoginScreenDisclaimerEntity({
    required this.iconUrl,
    required this.text,
  });
}

class LoginScreenOtpConfigEntity {
  final int length;

  const LoginScreenOtpConfigEntity({required this.length});
}
