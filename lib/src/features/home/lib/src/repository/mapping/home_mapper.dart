import '../entity/home_entity.dart';
import '../../core/api_service/models/home_network_model.dart';

class HomeMapper {
  const HomeMapper();

  HomeEntity fromNetworkModel(HomeNetworkModel model) {
    return HomeEntity(
      user: _mapUser(model.user),
      medicines: model.medicines.map(medicineFromNetwork).toList(),
      prescriptions: model.prescriptions.map(prescriptionFromNetwork).toList(),
      insurance: _mapInsurance(model.insurance),
      appointments: model.appointments.map(_mapAppointment).toList(),
    );
  }

  HomeEntity fromPrescriptionsPage(PrescriptionsPageNetworkModel page) {
    final allMedicines = <MedicineEntity>[];
    final prescriptions = <PrescriptionEntity>[];

    for (final p in page.content) {
      final prescription = prescriptionFromNetwork(p);
      prescriptions.add(prescription);
      allMedicines.addAll(prescription.medicines);
    }

    return HomeEntity(
      user: const UserEntity(name: '', abhaId: null, abhaStatus: 'not_linked'),
      medicines: allMedicines,
      prescriptions: prescriptions,
      insurance: const InsuranceEntity(
        hasInsurance: false,
        providerName: '',
        status: '',
        policyNumber: '',
      ),
      appointments: const [],
    );
  }

  MedicineEntity medicineFromNetwork(MedicineNetworkModel model) {
    return MedicineEntity(
      id: model.id,
      name: model.name,
      dosage: model.dosage,
      frequency: model.frequency,
      frequencyType: model.frequencyType,
      dayOfWeek: model.dayOfWeek,
      duration: model.duration,
      reminderTimes: model.reminderTimes,
    );
  }

  PrescriptionEntity prescriptionFromNetwork(PrescriptionNetworkModel model) {
    return PrescriptionEntity(
      id: model.id,
      status: model.status,
      uploadedAt: model.uploadedAt,
      imageUrls: model.imageUrls,
      medicines: model.medicines.map(medicineFromNetwork).toList(),
    );
  }

  UserEntity _mapUser(UserNetworkModel model) {
    return UserEntity(
      name: model.name,
      abhaId: model.abhaId,
      abhaStatus: model.abhaStatus,
    );
  }

  InsuranceEntity _mapInsurance(InsuranceNetworkModel model) {
    return InsuranceEntity(
      hasInsurance: model.hasInsurance,
      providerName: model.providerName,
      status: model.status,
      policyNumber: model.policyNumber,
    );
  }

  AppointmentEntity _mapAppointment(AppointmentNetworkModel model) {
    return AppointmentEntity(
      doctorName: model.doctorName,
      speciality: model.speciality,
      date: model.date,
      time: model.time,
      clinic: model.clinic,
      status: model.status,
    );
  }
}
