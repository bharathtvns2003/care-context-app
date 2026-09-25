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

class ReminderTimeEntity {
  final String? slotId;
  final String time;
  final String? scheduledAt;
  final String? status;

  const ReminderTimeEntity({
    this.slotId,
    required this.time,
    this.scheduledAt,
    this.status,
  });

  dynamic toApiJson() {
    if (slotId == null && scheduledAt == null && status == null) {
      return time;
    }
    return {
      if (slotId != null) 'slotId': slotId,
      'time': time,
      if (scheduledAt != null) 'scheduledAt': scheduledAt,
      if (status != null) 'status': status,
    };
  }
}

class MedicineEntity {
  final String? id;
  final String name;
  final String dosage;
  final String frequency;
  final String? frequencyType;
  final String? dayOfWeek;
  final String duration;
  final List<ReminderTimeEntity> reminderTimes;

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
      if (id != null && id!.isNotEmpty) 'medicineId': id,
      'medicineName': name,
      'dosage': dosage,
      'frequency': frequency,
      if (frequencyType != null) 'frequencyType': frequencyType,
      if (dayOfWeek != null) 'dayOfWeek': dayOfWeek,
      'duration': duration,
      'reminderTimes': reminderTimes.map((e) => e.toApiJson()).toList(),
    };
  }

  Map<String, dynamic> toActivateRemindersJson() {
    final map = <String, dynamic>{
      'medicineName': name,
      'dosage': dosage.isNotEmpty ? dosage : '1-0-0',
      'frequency': reminderTimes.length.toString(),
      'reminderTimes': reminderTimes.map((e) => e.time).toList(),
      'frequencyType': frequencyType ?? '1',
    };
    if (id != null && id!.isNotEmpty) {
      map['medicineId'] = id;
    }
    if (dayOfWeek != null && dayOfWeek!.isNotEmpty) {
      map['dayOfWeek'] = dayOfWeek;
    }
    return map;
  }
}

class PrescriptionEntity {
  final String id;
  final String? status;
  final String? uploadedAt;
  final String? doctorName;
  final String? title;
  final String? date;
  final int? medicationCount;
  final List<String>? imageUrls;
  final List<String>? thumbnailUrls;
  final List<MedicineEntity> medicines;

  const PrescriptionEntity({
    required this.id,
    this.status,
    this.uploadedAt,
    this.doctorName,
    this.title,
    this.date,
    this.medicationCount,
    this.imageUrls,
    this.thumbnailUrls,
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
