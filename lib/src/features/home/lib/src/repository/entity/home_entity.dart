class HomeEntity {
  final UserEntity user;
  final List<MedicineEntity> medicines;
  final List<PrescriptionEntity> prescriptions;
  final InsuranceEntity insurance;
  final List<AppointmentEntity> appointments;

  const HomeEntity({
    required this.user,
    required this.medicines,
    required this.prescriptions,
    required this.insurance,
    required this.appointments,
  });
}

class UserEntity {
  final String name;
  final String? abhaId;
  final String abhaStatus;

  const UserEntity({
    required this.name,
    required this.abhaId,
    required this.abhaStatus,
  });

  bool get isAbhaLinked => abhaStatus == 'linked';
}

class MedicineEntity {
  final String? id;
  final String name;
  final String dosage;
  final String frequency;
  final String? frequencyType;
  final String? dayOfWeek;
  final String duration;
  final List<String> reminderTimes;

  const MedicineEntity({
    this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    this.frequencyType,
    this.dayOfWeek,
    required this.duration,
    required this.reminderTimes,
  });

  Map<String, dynamic> toApiJson() {
    return {
      'medicineName': name,
      'dosage': dosage,
      'frequency': frequency,
      if (frequencyType != null) 'frequencyType': frequencyType,
      if (dayOfWeek != null) 'dayOfWeek': dayOfWeek,
      'duration': duration,
      'reminderTimes': reminderTimes,
    };
  }
}

class PrescriptionEntity {
  final String id;
  final String? status;
  final String? uploadedAt;
  final List<String>? imageUrls;
  final List<MedicineEntity> medicines;

  const PrescriptionEntity({
    required this.id,
    this.status,
    this.uploadedAt,
    this.imageUrls,
    this.medicines = const [],
  });

  bool get isActive => status == 'ACTIVE' || status == 'PROCESSING';
}

class InsuranceEntity {
  final bool hasInsurance;
  final String providerName;
  final String status;
  final String policyNumber;

  const InsuranceEntity({
    required this.hasInsurance,
    required this.providerName,
    required this.status,
    required this.policyNumber,
  });

  bool get isActive => status == 'active';
}

class AppointmentEntity {
  final String doctorName;
  final String speciality;
  final String date;
  final String time;
  final String clinic;
  final String status;

  const AppointmentEntity({
    required this.doctorName,
    required this.speciality,
    required this.date,
    required this.time,
    required this.clinic,
    required this.status,
  });

  bool get isConfirmed => status == 'confirmed';
}
