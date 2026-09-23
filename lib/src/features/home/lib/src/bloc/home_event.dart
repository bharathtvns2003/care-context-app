part of 'home_bloc.dart';

abstract class HomeEvent {}

class LoadHomeDataEvent extends HomeEvent {}

class UploadPrescriptionEvent extends HomeEvent {
  final List<String> imagePaths;
  UploadPrescriptionEvent({required this.imagePaths});
}

class GetMedicinesEvent extends HomeEvent {
  final String prescriptionId;
  GetMedicinesEvent({required this.prescriptionId});
}

class AddMedicineEvent extends HomeEvent {
  final String prescriptionId;
  final MedicineEntity medicine;
  AddMedicineEvent({required this.prescriptionId, required this.medicine});
}

class UpdateMedicineEvent extends HomeEvent {
  final String prescriptionId;
  final String medicineId;
  final MedicineEntity medicine;
  UpdateMedicineEvent({
    required this.prescriptionId,
    required this.medicineId,
    required this.medicine,
  });
}

class DeleteMedicineEvent extends HomeEvent {
  final String prescriptionId;
  final String medicineId;
  DeleteMedicineEvent({required this.prescriptionId, required this.medicineId});
}

class ActivateRemindersEvent extends HomeEvent {
  final String prescriptionId;
  ActivateRemindersEvent({required this.prescriptionId});
}

class LoadPrescriptionsEvent extends HomeEvent {
  final int page;
  final int size;
  LoadPrescriptionsEvent({this.page = 1, this.size = 10});
}

class RegisterDeviceEvent extends HomeEvent {
  final String fcmToken;
  final String platform;
  final String? deviceName;
  RegisterDeviceEvent({
    required this.fcmToken,
    required this.platform,
    this.deviceName,
  });
}

class RespondSlotEvent extends HomeEvent {
  final String action;
  RespondSlotEvent({this.action = 'taken'});
}
