class HomeNetworkModel {
  final UserNetworkModel user;
  final List<MedicineNetworkModel> medicines;
  final List<PrescriptionNetworkModel> prescriptions;
  final InsuranceNetworkModel insurance;
  final List<AppointmentNetworkModel> appointments;

  const HomeNetworkModel({
    required this.user,
    required this.medicines,
    required this.prescriptions,
    required this.insurance,
    required this.appointments,
  });

  factory HomeNetworkModel.fromJson(Map<String, dynamic> json) {
    return HomeNetworkModel(
      user: UserNetworkModel.fromJson(json['user'] as Map<String, dynamic>),
      medicines: (json['medicines'] as List<dynamic>)
          .map((e) => MedicineNetworkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      prescriptions: (json['prescriptions'] as List<dynamic>)
          .map((e) => PrescriptionNetworkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      insurance: InsuranceNetworkModel.fromJson(json['insurance'] as Map<String, dynamic>),
      appointments: (json['appointments'] as List<dynamic>)
          .map((e) => AppointmentNetworkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class UserNetworkModel {
  final String name;
  final String? abhaId;
  final String abhaStatus;

  const UserNetworkModel({
    required this.name,
    required this.abhaId,
    required this.abhaStatus,
  });

  factory UserNetworkModel.fromJson(Map<String, dynamic> json) {
    return UserNetworkModel(
      name: json['name'] ?? '',
      abhaId: json['abhaId'] as String?,
      abhaStatus: json['abhaStatus'] ?? 'not_linked',
    );
  }
}

class MedicineNetworkModel {
  final String? id;
  final String name;
  final String dosage;
  final String frequency;
  final String? frequencyType;
  final String? dayOfWeek;
  final String duration;
  final List<String> reminderTimes;

  const MedicineNetworkModel({
    this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    this.frequencyType,
    this.dayOfWeek,
    required this.duration,
    required this.reminderTimes,
  });

  factory MedicineNetworkModel.fromJson(Map<String, dynamic> json) {
    return MedicineNetworkModel(
      id: json['id'] as String?,
      name: json['medicineName'] ?? json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      frequencyType: json['frequencyType'] as String?,
      dayOfWeek: json['dayOfWeek'] as String?,
      duration: json['duration'] ?? '',
      reminderTimes: List<String>.from(json['reminderTimes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
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

class PrescriptionNetworkModel {
  final String id;
  final String? status;
  final String? uploadedAt;
  final List<String>? imageUrls;
  final List<MedicineNetworkModel> medicines;

  const PrescriptionNetworkModel({
    required this.id,
    this.status,
    this.uploadedAt,
    this.imageUrls,
    this.medicines = const [],
  });

  factory PrescriptionNetworkModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionNetworkModel(
      id: json['id'] ?? json['prescriptionId'] ?? '',
      status: json['status'] as String?,
      uploadedAt: json['uploadedAt'] as String?,
      imageUrls: json['imageUrls'] != null
          ? List<String>.from(json['imageUrls'])
          : null,
      medicines: json['medicines'] != null
          ? (json['medicines'] as List<dynamic>)
              .map((e) => MedicineNetworkModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}

class PrescriptionsPageNetworkModel {
  final List<PrescriptionNetworkModel> content;
  final int totalElements;
  final int totalPages;
  final int currentPage;

  const PrescriptionsPageNetworkModel({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.currentPage,
  });

  factory PrescriptionsPageNetworkModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionsPageNetworkModel(
      content: (json['content'] as List<dynamic>? ?? [])
          .map((e) => PrescriptionNetworkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['number'] ?? json['currentPage'] ?? 0,
    );
  }
}

class InsuranceNetworkModel {
  final bool hasInsurance;
  final String providerName;
  final String status;
  final String policyNumber;

  const InsuranceNetworkModel({
    required this.hasInsurance,
    required this.providerName,
    required this.status,
    required this.policyNumber,
  });

  factory InsuranceNetworkModel.fromJson(Map<String, dynamic> json) {
    return InsuranceNetworkModel(
      hasInsurance: json['hasInsurance'] ?? false,
      providerName: json['providerName'] ?? '',
      status: json['status'] ?? '',
      policyNumber: json['policyNumber'] ?? '',
    );
  }
}

class AppointmentNetworkModel {
  final String doctorName;
  final String speciality;
  final String date;
  final String time;
  final String clinic;
  final String status;

  const AppointmentNetworkModel({
    required this.doctorName,
    required this.speciality,
    required this.date,
    required this.time,
    required this.clinic,
    required this.status,
  });

  factory AppointmentNetworkModel.fromJson(Map<String, dynamic> json) {
    return AppointmentNetworkModel(
      doctorName: json['doctorName'] ?? '',
      speciality: json['speciality'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      clinic: json['clinic'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
