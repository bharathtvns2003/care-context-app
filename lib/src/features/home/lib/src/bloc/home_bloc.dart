import 'package:core/core.dart';
import '../repository/entity/home_entity.dart';
import '../repository/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc({required this.repository}) : super(HomeInitialState()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<UploadPrescriptionEvent>(_onUploadPrescription);
    on<GetMedicinesEvent>(_onGetMedicines);
    on<AddMedicineEvent>(_onAddMedicine);
    on<UpdateMedicineEvent>(_onUpdateMedicine);
    on<DeleteMedicineEvent>(_onDeleteMedicine);
    on<ActivateRemindersEvent>(_onActivateReminders);
    on<LoadPrescriptionsEvent>(_onLoadPrescriptions);
    on<RegisterDeviceEvent>(_onRegisterDevice);
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(HomeLoadingState());
      final homeData = await repository.getHomeData();
      emit(HomeLoadedState(homeData: homeData));
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  Future<void> _onUploadPrescription(
    UploadPrescriptionEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // Clear any previous state when starting a new upload
      emit(HomeInitialState());
      final prescriptionId = await repository.uploadPrescription(event.imagePaths);
      emit(PrescriptionUploadedState(prescriptionId: prescriptionId));
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  Future<void> _onGetMedicines(
    GetMedicinesEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final medicines = await repository.getMedicines(event.prescriptionId);
      emit(MedicinesLoadedState(
        prescriptionId: event.prescriptionId,
        medicines: medicines,
      ));
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  Future<void> _onAddMedicine(
    AddMedicineEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(HomeLoadingState());
      final medicine = await repository.addMedicine(
        prescriptionId: event.prescriptionId,
        medicine: event.medicine,
      );
      emit(MedicineAddedState(medicine: medicine));
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  Future<void> _onUpdateMedicine(
    UpdateMedicineEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(HomeLoadingState());
      final medicine = await repository.updateMedicine(
        prescriptionId: event.prescriptionId,
        medicineId: event.medicineId,
        medicine: event.medicine,
      );
      emit(MedicineUpdatedState(medicine: medicine));
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  Future<void> _onDeleteMedicine(
    DeleteMedicineEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(HomeLoadingState());
      await repository.deleteMedicine(
        prescriptionId: event.prescriptionId,
        medicineId: event.medicineId,
      );
      emit(MedicineDeletedState());
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  Future<void> _onActivateReminders(
    ActivateRemindersEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(HomeLoadingState());
      await repository.activateReminders(event.prescriptionId);
      emit(RemindersActivatedState());
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadPrescriptions(
    LoadPrescriptionsEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(HomeLoadingState());
      final prescriptions = await repository.getPrescriptions(
        page: event.page,
        size: event.size,
      );
      emit(PrescriptionsLoadedState(prescriptions: prescriptions));
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  Future<void> _onRegisterDevice(
    RegisterDeviceEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await repository.registerDevice(
        fcmToken: event.fcmToken,
        platform: event.platform,
        deviceName: event.deviceName,
      );
      emit(DeviceRegisteredState());
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }
}
