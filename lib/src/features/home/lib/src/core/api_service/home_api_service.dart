import 'package:core/core.dart';

class HomeApiService {
  Future<ApiService> get _api => ApiService.authenticated();

  Future<Map<String, dynamic>> uploadPrescription(List<String> filePaths) async {
    final api = await _api;
    final response = await api.uploadMultipart(
      ApiConstants.prescriptionsUpload,
      filePaths: filePaths,
      fieldName: 'files',
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPrescriptionInfo(String prescriptionId) async {
    final api = await _api;
    final response = await api.get(ApiConstants.prescriptionById(prescriptionId));
    return response.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getMedicines(String prescriptionId) async {
    final api = await _api;
    final response = await api.get(ApiConstants.prescriptionMedicines(prescriptionId));
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> addMedicine({
    required String prescriptionId,
    required Map<String, dynamic> medicineData,
  }) async {
    final api = await _api;
    final response = await api.post(
      ApiConstants.prescriptionMedicines(prescriptionId),
      data: medicineData,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateMedicine({
    required String prescriptionId,
    required String medicineId,
    required Map<String, dynamic> medicineData,
  }) async {
    final api = await _api;
    final response = await api.put(
      ApiConstants.prescriptionMedicineById(prescriptionId, medicineId),
      data: medicineData,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteMedicine({
    required String prescriptionId,
    required String medicineId,
  }) async {
    final api = await _api;
    await api.delete(
      ApiConstants.prescriptionMedicineById(prescriptionId, medicineId),
    );
  }

  Future<Map<String, dynamic>> getPrescriptions({
    int page = 1,
    int size = 10,
  }) async {
    final api = await _api;
    final response = await api.get(
      ApiConstants.prescriptions,
      queryParams: {'page': page, 'size': size},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> activateReminders(String prescriptionId) async {
    final api = await _api;
    await api.post(
      ApiConstants.activateReminders(prescriptionId),
      data: {},
    );
  }

  Future<Map<String, dynamic>> registerDevice({
    required String fcmToken,
    required String platform,
    String? deviceName,
  }) async {
    final api = await _api;
    final data = <String, dynamic>{
      'fcmToken': fcmToken,
      'platform': platform,
    };
    if (deviceName != null) data['deviceName'] = deviceName;
    final response = await api.post(
      ApiConstants.deviceTokens,
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }
}
