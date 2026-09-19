import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home.dart';
import '../../theme/app_colors.dart';
import 'share_prescription_screen.dart';

class PrescriptionHistoryScreen extends StatefulWidget {
  const PrescriptionHistoryScreen({super.key});

  @override
  State<PrescriptionHistoryScreen> createState() => _PrescriptionHistoryScreenState();
}

class _PrescriptionHistoryScreenState extends State<PrescriptionHistoryScreen> {
  @override
  void initState() {
    super.initState();
    getIt<HomeBloc>().add(LoadPrescriptionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFC),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        int total = 0;
        int active = 0;
        if (state is PrescriptionsLoadedState) {
          total = state.prescriptions.length;
          active = state.prescriptions.where((p) => p.isActive).length;
        }
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.8, -0.8),
              end: Alignment(0.8, 0.8),
              colors: [Color(0xFF0D1F2D), Color(0xFF055F58)],
              stops: [0.085, 0.915],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => CcRouteHelper.pop(),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'My Prescriptions',
                        style: GoogleFonts.sora(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _buildStatItem('$total', 'Total'),
                      const SizedBox(width: 20),
                      _buildStatItem('$active', 'Active'),
                      const SizedBox(width: 20),
                      _buildStatItem('87%', 'Adherence'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.sora(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF94EDE7),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryTeal,
            ),
          );
        }
        if (state is HomeErrorState) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => getIt<HomeBloc>().add(LoadPrescriptionsEvent()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (state is PrescriptionsLoadedState) {
          final prescriptions = state.prescriptions.map((entity) => Prescription(
            date: entity.date ?? entity.uploadedAt ?? '',
            doctorName: entity.doctorName ?? entity.title ?? 'Prescription',
            clinic: '',
            isActive: entity.isActive,
            medicines: entity.medicines.isNotEmpty
                ? entity.medicines.map((m) => m.name).toList()
                : List.generate(entity.medicationCount ?? 0, (_) => 'Medicine'),
          )).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 16),
                ...prescriptions.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildPrescriptionCard(context, p),
                    )),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4EEF2), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1F2D).withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Color(0xFF7A96A4),
            size: 16,
          ),
          const SizedBox(width: 10),
          Text(
            'Search prescriptions...',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF7A96A4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard(BuildContext context, Prescription prescription) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4EEF2), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1F2D).withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prescription.date,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF7A96A4),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    prescription.doctorName,
                    style: GoogleFonts.sora(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A2B35),
                    ),
                  ),
                  Text(
                    prescription.clinic,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF7A96A4),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: prescription.isActive
                      ? const Color(0xFFE6FAF9)
                      : const Color(0xFFFFF1EA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  prescription.isActive ? 'Active' : 'Completed',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: prescription.isActive
                        ? const Color(0xFF055F58)
                        : const Color(0xFFC05621),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFE4EEF2), width: 0.67),
              ),
            ),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: prescription.medicines
                  .map((m) => _buildMedicineChip(m))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          // TODO: change the medicine dosage
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: '📤 Share',
                  backgroundColor: const Color(0xFFE6FAF9),
                  textColor: const Color(0xFF055F58),
                  onTap: () {
                    CcRouteHelper.push(
                      CcRouteConstants.sharePrescription,
                      args: {
                        'patientName': 'Akash Mandla',
                        'doctorName': prescription.doctorName,
                        'clinic': prescription.clinic,
                        'date': prescription.date,
                        'medications': prescription.medicines.map((m) => MedicationItem(
                          name: m,
                          dosage: _getMedicationDosage(m),
                        )).toList(),
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  label: '👁 View',
                  backgroundColor: const Color(0xFFE4EEF2),
                  textColor: const Color(0xFF3D5566),
                  onTap: () {
                    CcRouteHelper.push(
                      CcRouteConstants.prescriptionDetail,
                      args: {
                        'title': prescription.isActive ? 'Current Treatment' : 'Past Treatment',
                        'doctorName': prescription.doctorName,
                        'date': prescription.date,
                        'medicines': prescription.medicines.map((m) => '$m — Take as prescribed').toList(),
                        'notes': prescription.isActive
                            ? 'Continue medication as prescribed. Follow up if symptoms persist.'
                            : 'Treatment completed successfully.',
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMedicationDosage(String medicine) {
    final dosages = {
      'Metformin': 'Twice daily · After meals · 3 months',
      'Amlodipine': 'Once daily · Morning · Ongoing',
      'Vitamin D3': 'Once weekly · After lunch · 12 weeks',
      'Amoxicillin': 'Three times daily · After meals · 7 days',
      'Paracetamol': 'As needed · Max 4 times daily',
      'Pantoprazole': 'Once daily · Before breakfast · 2 weeks',
      'Cetirizine': 'Once daily · Morning · As needed',
      'Montelukast': 'Once daily · Evening · Ongoing',
    };
    return dosages[medicine] ?? 'Take as prescribed';
  }

  Widget _buildMedicineChip(String medicine) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FBFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE4EEF2), width: 0.67),
      ),
      child: Text(
        medicine,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF3D5566),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class Prescription {
  final String date;
  final String doctorName;
  final String clinic;
  final bool isActive;
  final List<String> medicines;

  Prescription({
    required this.date,
    required this.doctorName,
    required this.clinic,
    required this.isActive,
    required this.medicines,
  });
}
