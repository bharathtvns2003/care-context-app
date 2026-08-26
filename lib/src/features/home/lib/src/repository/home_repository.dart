import '../core/api_service/home_api_service.dart';
import '../core/api_service/models/home_network_model.dart';
import 'entity/home_entity.dart';
import 'mapping/home_mapper.dart';

class HomeRepository {
  final HomeApiService apiService;
  final HomeMapper mapper;

  HomeRepository({required this.apiService, required this.mapper});

  Future<HomeEntity> getHomeData() async {
    final prescriptionsResponse = await apiService.getPrescriptions();
    final pageModel = PrescriptionsPageNetworkModel.fromJson(prescriptionsResponse);
    return mapper.fromPrescriptionsPage(pageModel);
  }

  Future<String> uploadPrescription(List<String> filePaths) async {
    final response = await apiService.uploadPrescription(filePaths);
    return response['prescriptionId'] as String? ??
        response['id'] as String? ??
        '';
  }

  Future<PrescriptionEntity> getPrescriptionInfo(String prescriptionId) async {
    final response = await apiService.getPrescriptionInfo(prescriptionId);
    final networkModel = PrescriptionNetworkModel.fromJson(response);
    return mapper.prescriptionFromNetwork(networkModel);
  }

  Future<List<MedicineEntity>> getMedicines(String prescriptionId) async {
    final response = await apiService.getMedicines(prescriptionId);
    return response
        .map((e) => MedicineNetworkModel.fromJson(e as Map<String, dynamic>))
        .map((m) => mapper.medicineFromNetwork(m))
        .toList();
  }

  Future<MedicineEntity> addMedicine({
    required String prescriptionId,
    required MedicineEntity medicine,
  }) async {
    final response = await apiService.addMedicine(
      prescriptionId: prescriptionId,
      medicineData: medicine.toApiJson(),
    );
    final networkModel = MedicineNetworkModel.fromJson(response);
    return mapper.medicineFromNetwork(networkModel);
  }

  Future<MedicineEntity> updateMedicine({
    required String prescriptionId,
    required String medicineId,
    required MedicineEntity medicine,
  }) async {
    final response = await apiService.updateMedicine(
      prescriptionId: prescriptionId,
      medicineId: medicineId,
      medicineData: medicine.toApiJson(),
    );
    final networkModel = MedicineNetworkModel.fromJson(response);
    return mapper.medicineFromNetwork(networkModel);
  }

  Future<void> deleteMedicine({
    required String prescriptionId,
    required String medicineId,
  }) async {
    await apiService.deleteMedicine(
      prescriptionId: prescriptionId,
      medicineId: medicineId,
    );
  }

  Future<List<PrescriptionEntity>> getPrescriptions({
    int page = 1,
    int size = 10,
  }) async {
    final response = await apiService.getPrescriptions(page: page, size: size);
    final pageModel = PrescriptionsPageNetworkModel.fromJson(response);
    return pageModel.content
        .map((p) => mapper.prescriptionFromNetwork(p))
        .toList();
  }

  Future<void> activateReminders(String prescriptionId) async {
    await apiService.activateReminders(prescriptionId);
  }

  Future<void> registerDevice({
    required String fcmToken,
    required String platform,
    String? deviceName,
  }) async {
    await apiService.registerDevice(
      fcmToken: fcmToken,
      platform: platform,
      deviceName: deviceName,
    );
  }
}
