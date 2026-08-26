class HomeMockContract {
  const HomeMockContract._();

  static const Map<String, dynamic> homeDataMockResponse = {
    "user": {"name": "Akash", "abhaId": null, "abhaStatus": "not_linked"},
    "medicines": [
      {
        "name": "Paracetamol",
        "dosage": "500mg",
        "frequency": "Twice a day",
        "duration": "5 days",
        "reminderTimes": ["08:00", "20:00"],
      },
      {
        "name": "Vitamin D",
        "dosage": "1000 IU",
        "frequency": "Once daily",
        "duration": "30 days",
        "reminderTimes": ["09:00"],
      },
      {
        "name": "Amoxicillin",
        "dosage": "250mg",
        "frequency": "Three times a day",
        "duration": "7 days",
        "reminderTimes": ["08:00", "14:00", "20:00"],
      },
      {
        "name": "Metformin",
        "dosage": "500mg",
        "frequency": "Twice daily",
        "duration": "3 months",
        "reminderTimes": ["08:00", "20:00"],
      },
    ],
    "prescriptions": [
      {
        "date": "12 March 2025",
        "doctorName": "Dr. Rajesh Kumar",
        "clinic": "Apollo Clinic, Panaji",
        "isActive": true,
        "medicines": ["Metformin", "Amlodipine", "Vitamin D3"],
      },
      {
        "date": "28 January 2025",
        "doctorName": "Dr. Priya Sharma",
        "clinic": "Goa Medical College",
        "isActive": false,
        "medicines": ["Amoxicillin", "Paracetamol", "Pantoprazole"],
      },
      {
        "date": "15 December 2024",
        "doctorName": "Dr. Amit Verma",
        "clinic": "City Hospital, Margao",
        "isActive": false,
        "medicines": ["Cetirizine", "Montelukast"],
      },
    ],
    "insurance": {
      "hasInsurance": true,
      "providerName": "Star Health",
      "status": "active",
      "policyNumber": "SH-2024-789456",
      "sumInsured": "5,00,000",
      "coverage": [
        {"item": "Hospitalization", "covered": true},
        {"item": "Day care procedures", "covered": true},
        {"item": "Pre & post hospitalization", "covered": true},
        {"item": "Ambulance charges", "covered": true},
        {"item": "Dental coverage", "covered": false},
      ],
      "claims": [
        {
          "type": "Hospitalization",
          "date": "15 Mar 2026",
          "status": "approved",
        },
        {"type": "Lab Tests", "date": "28 Feb 2026", "status": "processing"},
      ],
    },
    "appointments": [
      {
        "doctorName": "Dr. S. Mehta",
        "speciality": "General Medicine",
        "date": "30 Jul 2026",
        "time": "10:30 AM",
        "clinic": "Apollo Clinic",
        "status": "confirmed",
      },
      {
        "doctorName": "Dr. A. Verma",
        "speciality": "Dermatology",
        "date": "02 Aug 2026",
        "time": "02:00 PM",
        "clinic": "Skin Care Centre",
        "status": "pending",
      },
    ],
  };

  static const Map<String, dynamic> medicineInfoMockResponse = {
    "Paracetamol": {
      "genericName": "Paracetamol (Acetaminophen)",
      "usedFor": [
        "Relieves mild to moderate pain",
        "Reduces fever",
        "Treats headaches and body aches",
      ],
      "warning": {
        "title": "Do not exceed dosage.",
        "description":
            "Taking more than the recommended dose can cause serious liver damage. Always follow prescribed limits.",
      },
      "sideEffects": [
        "Rare allergic reactions",
        "Nausea in some cases",
        "Skin rash (uncommon)",
      ],
      "instructions": [
        "Can be taken with or without food",
        "Do not mix with alcohol",
        "Wait 4-6 hours between doses",
      ],
    },
    "Amoxicillin": {
      "genericName": "Amoxicillin Trihydrate",
      "usedFor": [
        "Treats bacterial infections",
        "Fights respiratory tract infections",
        "Treats ear and skin infections",
      ],
      "warning": {
        "title": "Complete full course.",
        "description":
            "Stopping early can cause antibiotic resistance. Always finish the prescribed duration even if you feel better.",
      },
      "sideEffects": [
        "Diarrhoea or stomach upset",
        "Skin rash or itching",
        "Nausea or vomiting",
      ],
      "instructions": [
        "Take at evenly spaced intervals",
        "Can be taken with or without food",
        "Store away from moisture and heat",
      ],
    },
    "Vitamin D": {
      "genericName": "Cholecalciferol (Vitamin D3)",
      "usedFor": [
        "Maintains healthy bones and teeth",
        "Supports immune system function",
        "Helps absorb calcium",
      ],
      "warning": {
        "title": "Do not exceed recommended dose.",
        "description":
            "Too much Vitamin D can cause calcium buildup leading to nausea, weakness, and kidney problems.",
      },
      "sideEffects": [
        "Nausea if taken in excess",
        "Weakness or fatigue (rare)",
        "Headache (uncommon)",
      ],
      "instructions": [
        "Best taken with a meal containing fat",
        "Take consistently at the same time",
        "Get regular sun exposure for natural Vitamin D",
      ],
    },
    "Metformin": {
      "genericName": "Metformin Hydrochloride",
      "usedFor": [
        "Controls blood sugar in Type 2 Diabetes",
        "Improves insulin sensitivity",
        "May help with weight management",
      ],
      "warning": {
        "title": "Take with food.",
        "description":
            "Taking Metformin on an empty stomach can cause nausea. Always take after meals as prescribed.",
      },
      "sideEffects": [
        "Nausea or upset stomach (common, usually goes away)",
        "Diarrhoea in first few weeks",
        "Metallic taste in mouth",
      ],
      "instructions": [
        "Never skip doses - keep blood sugar stable",
        "Stay hydrated throughout the day",
        "Tell your doctor before any surgery",
      ],
    },
  };

  static const Map<String, dynamic> defaultMedicineInfo = {
    "genericName": "As prescribed",
    "usedFor": ["As prescribed by your doctor"],
    "warning": {
      "title": "Follow prescription.",
      "description":
          "Always take this medicine exactly as directed by your healthcare provider.",
    },
    "sideEffects": ["Consult your doctor for information"],
    "instructions": ["Take as prescribed by your doctor"],
  };

  static const Map<String, dynamic> uploadPrescriptionMockResponse = {
    "success": true,
    "prescriptionId": "rx_mock_001",
    "message": "Prescription uploaded successfully",
  };

  static const Map<String, dynamic> aiExtractionMockResponse = {
    "success": true,
    "header": {
      "title": "Extracted Medicines",
      "subtitle": "Review and edit the extracted information",
      "badgeSuffix": "found",
    },
    "medicines": [
      {
        "name": "Paracetamol",
        "dosage": "500mg",
        "frequency": "Twice a day",
        "duration": "5 days",
        "reminderTimes": ["08:00", "20:00"],
        "hasWarning": true,
        "warningDetail": "Paracetamol 500mg, twice a day (08:00 and 20:00)",
      },
      {
        "name": "Amoxicillin",
        "dosage": "250mg",
        "frequency": "Three times a day",
        "duration": "7 days",
        "reminderTimes": ["08:00", "14:00", "20:00"],
        "hasWarning": false,
        "warningDetail": null,
      },
      {
        "name": "Vitamin D",
        "dosage": "1000 IU",
        "frequency": "Once daily",
        "duration": "30 days",
        "reminderTimes": ["09:00"],
        "hasWarning": false,
        "warningDetail": null,
      },
    ],
    "medicineCard": {
      "labels": {
        "dosage": "Dosage:",
        "frequency": "Frequency:",
        "duration": "Duration:",
        "reminderTimes": "Reminder Times:",
      },
      "warning": {
        "title": "Existing Medicine Detected",
        "bodyPrefix": "You are currently taking ",
        "bodySuffix":
            ". Ensure this does not conflict with your existing schedule.",
      },
    },
    "deleteDialog": {
      "title": "Delete Medicine",
      "contentPrefix": "Are you sure you want to delete ",
      "contentSuffix": "?",
      "cancelText": "Cancel",
      "confirmText": "Delete",
    },
    "addButton": {"icon": "+", "text": "Add Missing Medicine"},
    "confirmButton": {"text": "Confirm & Set Reminders"},
    "reminderSchedule": {
      "header": {
        "title": "Reminder Schedule",
        "subtitle": "Auto-generated reminder times for your medicines",
      },
      "timeCard": {
        "singularLabel": "medicine",
        "pluralLabel": "medicines",
      },
      "featuresCard": {
        "title": "Reminder Features",
        "features": [
          "Push notifications at scheduled times",
          "Mark medicines as taken",
          "Track your adherence",
          "Get refill reminders",
        ],
      },
      "activateButton": {"text": "Activate Reminders"},
      "editButton": {"text": "Edit Schedule"},
    },
  };

  static const Map<String, dynamic> markMedicineTakenMockResponse = {
    "success": true,
    "message": "Medicine marked as taken",
  };

  static const Map<String, dynamic> setRemindersMockResponse = {
    "success": true,
    "message": "Reminders set successfully",
  };
}
