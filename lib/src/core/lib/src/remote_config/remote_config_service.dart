import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static RemoteConfigService? _instance;
  late final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService._();

  static RemoteConfigService get instance {
    _instance ??= RemoteConfigService._();
    return _instance!;
  }

  Future<void> initialize() async {
    _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await _remoteConfig.setDefaults(_defaults);
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (_) {}
  }

  String getString(String key) => _remoteConfig.getString(key);

  Map<String, dynamic> getJson(String key) {
    final value = _remoteConfig.getString(key);
    if (value.isEmpty) return {};
    return jsonDecode(value) as Map<String, dynamic>;
  }

  static const Map<String, dynamic> _defaults = {
    'login_screen_config': _loginScreenConfig,
    'extraction_ui_config': _extractionUiConfig,
    'reminder_ui_config': _reminderUiConfig,
  };

  static const String _loginScreenConfig = '{'
      '"enterPhone":{"title":"Welcome to Care Context","subtitle":"Enter your phone number to get started","input":{"label":"Phone Number","placeholder":"Enter your phone number"},"disclaimer":{"text":"We\'ll send a 6-digit OTP to verify your number. Your data is fully encrypted and private."},"ctaText":"Continue"},'
      '"verifyOtp":{"title":"Verify OTP","subtitle":"Enter the 6-digit code sent to","otp":{"length":6},"disclaimer":{"text":"Auto-reading SMS... If OTP is received via SMS it will be filled automatically."},"ctaText":"Verify & Continue","secondaryAction":"Resend OTP","secondaryActionText":"Didn\'t receive?"},'
      '"completeProfile":{"title":"Complete Your Profile","subtitle":"This helps us personalize your experience","fields":[{"label":"Full Name","placeholder":"Enter your name"},{"label":"Age","placeholder":"Enter your age"}],"selection":[{"label":"Gender","options":["Male","Female","Other"]},{"label":"Blood Type","options":["A+","A-","B+","B-","AB+","AB-","O+","O-"]}],"disclaimer":{"text":"Your health data is encrypted and never shared without your permission."},"ctaText":"Continue"}'
      '}';

  static const String _extractionUiConfig = '{'
      '"header":{"title":"Extracted Medicines","subtitle":"Review and edit the extracted information","badgeSuffix":"found"},'
      '"medicineCard":{"labels":{"dosage":"Dosage:","frequency":"Frequency:","duration":"Duration:","reminderTimes":"Reminder Times:"},"warning":{"title":"Existing Medicine Detected","bodyPrefix":"You are currently taking ","bodySuffix":". Ensure this does not conflict with your existing schedule."}},'
      '"deleteDialog":{"title":"Delete Medicine","contentPrefix":"Are you sure you want to delete ","contentSuffix":"?","cancelText":"Cancel","confirmText":"Delete"},'
      '"addButton":{"icon":"+","text":"Add Missing Medicine"},'
      '"confirmButton":{"text":"Confirm & Set Reminders"},'
      '"emptyState":{"message":"No medicines found"}'
      '}';

  static const String _reminderUiConfig = '{'
      '"header":{"title":"Reminder Schedule","subtitle":"Auto-generated reminder times for your medicines"},'
      '"timeCard":{"singularLabel":"medicine","pluralLabel":"medicines"},'
      '"featuresCard":{"title":"Reminder Features","features":["Push notifications at scheduled times","Mark medicines as taken","Track your adherence","Get refill reminders"]},'
      '"activateButton":{"text":"Activate Reminders"},'
      '"editButton":{"text":"Edit Schedule"}'
      '}';
}
