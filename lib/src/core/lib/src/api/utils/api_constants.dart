class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://backend-ut4e.onrender.com';

  static const String prescriptionsUpload = '/api/prescriptions/upload';
  static const String prescriptions = '/api/prescriptions';
  static const String deviceTokens = '/api/device-tokens';
  static const String slotsRespond = '/api/slots/respond';
  static String slotRespond(String slotId) => '/api/slots/$slotId/respond';

  static const String authVerify = '/auth/verify';
  static const String authRefresh = '/auth/token/refresh';
  static const String userProfile = '/user/profile';
  static const String userConsents = '/user/consents';

  static String prescriptionById(String id) => '/api/prescriptions/$id';
  static String prescriptionMedicines(String prescriptionId) =>
      '/api/prescriptions/$prescriptionId/medicines';
  static String prescriptionMedicineById(
    String prescriptionId,
    String medicineId,
  ) => '/api/prescriptions/$prescriptionId/medicines/$medicineId';
  static String activateReminders(String prescriptionId) =>
      '/api/prescriptions/$prescriptionId/activate-reminders';
}
