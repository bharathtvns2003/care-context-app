part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final HomeEntity homeData;
  HomeLoadedState({required this.homeData});
}

class PrescriptionUploadedState extends HomeState {
  final String prescriptionId;
  PrescriptionUploadedState({required this.prescriptionId});
}

class MedicinesLoadedState extends HomeState {
  final String prescriptionId;
  final List<MedicineEntity> medicines;
  MedicinesLoadedState({
    required this.prescriptionId,
    required this.medicines,
  });
}

class MedicineAddedState extends HomeState {
  final MedicineEntity medicine;
  MedicineAddedState({required this.medicine});
}

class MedicineUpdatedState extends HomeState {
  final MedicineEntity medicine;
  MedicineUpdatedState({required this.medicine});
}

class MedicineDeletedState extends HomeState {}

class RemindersActivatedState extends HomeState {}

class PrescriptionsLoadedState extends HomeState {
  final List<PrescriptionEntity> prescriptions;
  PrescriptionsLoadedState({required this.prescriptions});
}

class DeviceRegisteredState extends HomeState {}

class SlotRespondedState extends HomeState {}

class HomeErrorState extends HomeState {
  final String message;
  HomeErrorState({this.message = 'Something went wrong'});
}
