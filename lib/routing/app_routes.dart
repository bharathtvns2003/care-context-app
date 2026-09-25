import 'package:care_context_app/src/features/home/lib/home.dart';
import 'package:care_context_app/src/features/login_screen/lib/login_screen.dart';
import 'package:core/core.dart';
import 'package:splash_screen/splash_screen.dart';

class AppRoutes {
  static void registerAll() {
    RouteGenerator.registerFeatureRoutes({
      '/': (_) => const SplashScreenPage(),
      CcRouteConstants.splashScreen: (_) => const SplashScreenPage(),

      // Login flow
      CcRouteConstants.loginScreen: (_) => BlocProvider.value(
            value: getIt<LoginScreenBloc>(),
            child: const PhoneLoginScreen(),
          ),
      CcRouteConstants.phoneLogin: (_) => BlocProvider.value(
            value: getIt<LoginScreenBloc>(),
            child: const PhoneLoginScreen(),
          ),
      CcRouteConstants.otpVerification: (settings) => BlocProvider.value(
            value: getIt<LoginScreenBloc>(),
            child: OtpVerificationScreen(
              phoneNumber: RouteGenerator.getArgsOr<String>(settings, ''),
            ),
          ),
      CcRouteConstants.completeProfile: (_) => BlocProvider.value(
            value: getIt<LoginScreenBloc>(),
            child: const CompleteProfileScreen(),
          ),

      // Home flow
      CcRouteConstants.homeScreen: (_) => BlocProvider.value(
            value: getIt<HomeBloc>(),
            child: const HomeScreen(),
          ),
      CcRouteConstants.uploadPrescription: (_) => BlocProvider.value(
            value: getIt<HomeBloc>(),
            child: const UploadPrescriptionScreen(),
          ),
      CcRouteConstants.reviewImages: (settings) {
        final args = settings.arguments;
        final imagePaths = args is List
            ? args.map((e) => e.toString()).toList()
            : <String>[];
        return BlocProvider.value(
          value: getIt<HomeBloc>(),
          child: ReviewImagesScreen(imagePaths: imagePaths),
        );
      },
      CcRouteConstants.aiProcessing: (_) => BlocProvider.value(
            value: getIt<HomeBloc>(),
            child: const AiProcessingScreen(),
          ),
      CcRouteConstants.extractedMedicines: (settings) => BlocProvider.value(
            value: getIt<HomeBloc>(),
            child: ExtractedMedicinesScreen(
              prescriptionId: RouteGenerator.getArgs<String>(settings),
            ),
          ),
      CcRouteConstants.addMedicine: (settings) => AddMedicineScreen(
            medicine: RouteGenerator.getArgs<Medicine>(settings),
            isEditing: RouteGenerator.getArgs<Medicine>(settings) != null,
          ),
      CcRouteConstants.reminderSchedule: (settings) {
        final args = settings.arguments;
        List<Medicine> medicines = [];
        String? prescriptionId;
        if (args is List<Medicine>) {
          medicines = args;
        } else if (args is Map<String, dynamic>) {
          medicines = (args['medicines'] as List<dynamic>?)?.cast<Medicine>() ?? [];
          prescriptionId = args['prescriptionId'] as String?;
        }
        return BlocProvider.value(
          value: getIt<HomeBloc>(),
          child: ReminderScheduleScreen(
            medicines: medicines,
            prescriptionId: prescriptionId,
          ),
        );
      },
      CcRouteConstants.todaysSchedule: (settings) => BlocProvider.value(
            value: getIt<HomeBloc>(),
            child: TodaysScheduleScreen(
              medicines: RouteGenerator.getArgsOr<List<Medicine>>(settings, []),
            ),
          ),
      CcRouteConstants.medicineInfo: (settings) => MedicineInfoScreen(
            medicine: RouteGenerator.getArgs<Medicine>(settings)!,
          ),
      CcRouteConstants.prescriptionHistory: (_) => BlocProvider.value(
            value: getIt<HomeBloc>(),
            child: const PrescriptionHistoryScreen(),
          ),
      CcRouteConstants.prescriptionDetail: (settings) {
        final args = RouteGenerator.getArgs<Map<String, dynamic>>(settings) ?? {};
        return PrescriptionDetailScreen(
          title: args['title'] as String? ?? '',
          doctorName: args['doctorName'] as String? ?? '',
          date: args['date'] as String? ?? '',
          medicines: (args['medicines'] as List<String>?) ?? [],
          notes: args['notes'] as String?,
        );
      },
      CcRouteConstants.sharePrescription: (settings) {
        final args = RouteGenerator.getArgs<Map<String, dynamic>>(settings) ?? {};
        return SharePrescriptionScreen(
          patientName: args['patientName'] as String? ?? '',
          doctorName: args['doctorName'] as String? ?? '',
          clinic: args['clinic'] as String? ?? '',
          date: args['date'] as String? ?? '',
          medications: (args['medications'] as List<MedicationItem>?) ?? [],
        );
      },
      CcRouteConstants.abhaId: (_) => const AbhaIdScreen(),
      CcRouteConstants.myBookings: (_) => const MyBookingsScreen(),
      CcRouteConstants.insurance: (_) => const InsuranceScreen(),
      CcRouteConstants.insuranceClaims: (_) => const InsuranceClaimsScreen(),
    });
  }
}
