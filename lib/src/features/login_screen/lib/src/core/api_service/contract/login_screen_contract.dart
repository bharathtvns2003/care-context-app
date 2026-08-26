class LoginScreenMockContract {
  const LoginScreenMockContract._();

  static const Map<String, dynamic> onboardingMockResponse = {
    "enterPhone": {
      "title": "Welcome to Care Context",
      "subtitle": "Enter your phone number to get started",
      "iconUrl": "example.com",
      "input": {
        "label": "Phone Number",
        "placeholder": "Enter your phone number",
      },
      "disclaimer": {
        "iconUrl": "example.com",
        "text":
            "We'll send a 6-digit OTP to verify your number. Your data is fully encrypted and private.",
      },
      "ctaText": "Continue",
    },
    "verifyOtp": {
      "title": "Verify OTP",
      "subtitle": "Enter the 6-digit code sent to",
      "iconUrl": "example.com",
      "otp": {"length": 6},
      "disclaimer": {
        "iconUrl": "example.com",
        "text":
            "Auto-reading SMS... If OTP is received via SMS it will be filled automatically.",
      },
      "ctaText": "Verify & Continue",
      "secondaryAction": "Resend OTP",
      "secondaryActionText": "Didn't receive?",
    },
    "completeProfile": {
      "title": "Complete Your Profile",
      "subtitle": "This helps us personalize your experience",
      "fields": [
        {"label": "Full Name", "placeholder": "Enter your name"},
        {"label": "Age", "placeholder": "Enter your age"},
      ],
      "selection": [
        {
          "label": "Gender",
          "options": ["Male", "Female", "Other"],
        },
        {
          "label": "Blood Type",
          "options": ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"],
        },
      ],
      "disclaimer": {
        "iconUrl": "example.com",
        "text":
            "Your health data is encrypted and never shared without your permission.",
      },
      "ctaText": "Continue",
    },
  };

  static const Map<String, dynamic> sendOtpMockResponse = {
    "success": true,
    "message": "OTP sent successfully",
  };

  static const Map<String, dynamic> verifyOtpMockResponse = {
    "success": true,
    "token": "mock_jwt_token_abc123",
    "isNewUser": true,
  };

  static const Map<String, dynamic> completeProfileMockResponse = {
    "success": true,
    "message": "Profile completed successfully",
  };
}
