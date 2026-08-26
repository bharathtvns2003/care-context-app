class LoginScreenNetworkModel {
  final LoginScreenEnterPhoneNetworkModel enterPhone;
  final LoginScreenVerifyOtpNetworkModel verifyOtp;
  final LoginScreenCompleteProfileNetworkModel completeProfile;

  const LoginScreenNetworkModel({
    required this.enterPhone,
    required this.verifyOtp,
    required this.completeProfile,
  });

  factory LoginScreenNetworkModel.fromJson(Map<String, dynamic> json) {
    return LoginScreenNetworkModel(
      enterPhone: LoginScreenEnterPhoneNetworkModel.fromJson(
        json['enterPhone'] as Map<String, dynamic>,
      ),
      verifyOtp: LoginScreenVerifyOtpNetworkModel.fromJson(
        json['verifyOtp'] as Map<String, dynamic>,
      ),
      completeProfile: LoginScreenCompleteProfileNetworkModel.fromJson(
        json['completeProfile'] as Map<String, dynamic>,
      ),
    );
  }
}

class LoginScreenEnterPhoneNetworkModel {
  final String title;
  final String subtitle;
  final String iconUrl;
  final LoginScreenInputFieldNetworkModel input;
  final LoginScreenDisclaimerNetworkModel disclaimer;
  final String ctaText;

  const LoginScreenEnterPhoneNetworkModel({
    required this.title,
    required this.subtitle,
    required this.iconUrl,
    required this.input,
    required this.disclaimer,
    required this.ctaText,
  });

  factory LoginScreenEnterPhoneNetworkModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginScreenEnterPhoneNetworkModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
      input: LoginScreenInputFieldNetworkModel.fromJson(
        json['input'] as Map<String, dynamic>,
      ),
      disclaimer: LoginScreenDisclaimerNetworkModel.fromJson(
        json['disclaimer'] as Map<String, dynamic>,
      ),
      ctaText: json['ctaText'] ?? '',
    );
  }
}

class LoginScreenVerifyOtpNetworkModel {
  final String title;
  final String subtitle;
  final String iconUrl;
  final LoginScreenOtpConfigNetworkModel otp;
  final LoginScreenDisclaimerNetworkModel disclaimer;
  final String ctaText;
  final String secondaryAction;
  final String secondaryActionText;

  const LoginScreenVerifyOtpNetworkModel({
    required this.title,
    required this.subtitle,
    required this.iconUrl,
    required this.otp,
    required this.disclaimer,
    required this.ctaText,
    required this.secondaryAction,
    required this.secondaryActionText,
  });

  factory LoginScreenVerifyOtpNetworkModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginScreenVerifyOtpNetworkModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
      otp: LoginScreenOtpConfigNetworkModel.fromJson(
        json['otp'] as Map<String, dynamic>,
      ),
      disclaimer: LoginScreenDisclaimerNetworkModel.fromJson(
        json['disclaimer'] as Map<String, dynamic>,
      ),
      ctaText: json['ctaText'] ?? '',
      secondaryAction: json['secondaryAction'] ?? '',
      secondaryActionText: json['secondaryActionText'] ?? '',
    );
  }
}

class LoginScreenCompleteProfileNetworkModel {
  final String title;
  final String subtitle;
  final List<LoginScreenInputFieldNetworkModel> fields;
  final List<LoginScreenSelectionNetworkModel> selection;
  final LoginScreenDisclaimerNetworkModel disclaimer;
  final String ctaText;

  const LoginScreenCompleteProfileNetworkModel({
    required this.title,
    required this.subtitle,
    required this.fields,
    required this.selection,
    required this.disclaimer,
    required this.ctaText,
  });

  factory LoginScreenCompleteProfileNetworkModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginScreenCompleteProfileNetworkModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      fields: (json['fields'] as List<dynamic>? ?? [])
          .map(
            (e) => LoginScreenInputFieldNetworkModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      selection: (json['selection'] as List<dynamic>? ?? [])
          .map(
            (e) => LoginScreenSelectionNetworkModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      disclaimer: LoginScreenDisclaimerNetworkModel.fromJson(
        json['disclaimer'] as Map<String, dynamic>,
      ),
      ctaText: json['ctaText'] ?? '',
    );
  }
}

class LoginScreenInputFieldNetworkModel {
  final String label;
  final String placeholder;

  const LoginScreenInputFieldNetworkModel({
    required this.label,
    required this.placeholder,
  });

  factory LoginScreenInputFieldNetworkModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginScreenInputFieldNetworkModel(
      label: json['label'] ?? '',
      placeholder: json['placeholder'] ?? '',
    );
  }
}

class LoginScreenSelectionNetworkModel {
  final String label;
  final List<String> options;

  const LoginScreenSelectionNetworkModel({
    required this.label,
    required this.options,
  });

  factory LoginScreenSelectionNetworkModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginScreenSelectionNetworkModel(
      label: json['label'] ?? '',
      options: List<String>.from(json['options'] ?? const []),
    );
  }
}

class LoginScreenDisclaimerNetworkModel {
  final String iconUrl;
  final String text;

  const LoginScreenDisclaimerNetworkModel({
    required this.iconUrl,
    required this.text,
  });

  factory LoginScreenDisclaimerNetworkModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginScreenDisclaimerNetworkModel(
      iconUrl: json['iconUrl'] ?? '',
      text: json['text'] ?? '',
    );
  }
}

class LoginScreenOtpConfigNetworkModel {
  final int length;

  const LoginScreenOtpConfigNetworkModel({
    required this.length,
  });

  factory LoginScreenOtpConfigNetworkModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginScreenOtpConfigNetworkModel(
      length: json['length'] ?? 6,
    );
  }
}