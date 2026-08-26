import 'package:care_context_app/src/features/home/lib/home.dart';
import 'package:care_context_app/src/features/login_screen/lib/login_screen.dart';
import 'package:core/core.dart';
import 'package:splash_screen/splash_screen.dart';

class AppRoutes {
  static LoginScreenBloc? _loginBloc;
  static HomeBloc? _homeBloc;

  static LoginScreenBloc get loginBloc {
    _loginBloc ??= LoginScreenBloc(
      repository: LoginScreenRepository(
        apiService: LoginScreenApiService(),
        mapper: const LoginScreenMapper(),
        firebaseAuthService: FirebaseAuthService(),
      ),
    );
    return _loginBloc!;
  }

  static HomeBloc get homeBloc {
    _homeBloc ??= HomeBloc(
      repository: HomeRepository(
        apiService: HomeApiService(),
        mapper: const HomeMapper(),
      ),
    );
    return _homeBloc!;
  }

  static void registerAll() {
    RouteGenerator.registerFeatureRoutes({
      '/': (_) => const SplashScreenPage(),
      CcRouteConstants.splashScreen: (_) => const SplashScreenPage(),

      // Login flow
      CcRouteConstants.loginScreen: (_) => BlocProvider.value(
            value: loginBloc,
            child: const PhoneLoginScreen(),
          ),
      CcRouteConstants.phoneLogin: (_) => BlocProvider.value(
            value: loginBloc,
            child: const PhoneLoginScreen(),
          ),
      CcRouteConstants.otpVerification: (settings) => BlocProvider.value(
            value: loginBloc,
            child: OtpVerificationScreen(
              phoneNumber: RouteGenerator.getArgsOr<String>(settings, ''),
            ),
          ),
      CcRouteConstants.completeProfile: (_) => BlocProvider.value(
            value: loginBloc,
            child: const CompleteProfileScreen(),
          ),

      // Home flow
      CcRouteConstants.homeScreen: (_) => BlocProvider.value(
            value: homeBloc,
            child: HomeScreen(medicines: MockData.medicines),
          ),
      CcRouteConstants.uploadPrescription: (_) => BlocProvider.value(
            value: homeBloc,
            child: const UploadPrescriptionScreen(),
          ),
      CcRouteConstants.reviewImages: (_) => BlocProvider.value(
            value: homeBloc,
            child: const ReviewImagesScreen(),
          ),
      CcRouteConstants.aiProcessing: (_) => BlocProvider.value(
            value: homeBloc,
            child: const AiProcessingScreen(),
          ),
      CcRouteConstants.extractedMedicines: (_) => BlocProvider.value(
            value: homeBloc,
            child: const ExtractedMedicinesScreen(),
          ),
      CcRouteConstants.addMedicine: (settings) => AddMedicineScreen(
            medicine: RouteGenerator.getArgs<Medicine>(settings),
            isEditing: RouteGenerator.getArgs<Medicine>(settings) != null,
          ),
      CcRouteConstants.reminderSchedule: (settings) => BlocProvider.value(
            value: homeBloc,
            child: ReminderScheduleScreen(
              medicines: RouteGenerator.getArgsOr<List<Medicine>>(settings, []),
            ),
          ),
      CcRouteConstants.todaysSchedule: (settings) => TodaysScheduleScreen(
            medicines: RouteGenerator.getArgsOr<List<Medicine>>(settings, []),
          ),
      CcRouteConstants.medicineInfo: (settings) => MedicineInfoScreen(
            medicine: RouteGenerator.getArgs<Medicine>(settings)!,
          ),
      CcRouteConstants.prescriptionHistory: (_) => const PrescriptionHistoryScreen(),
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
