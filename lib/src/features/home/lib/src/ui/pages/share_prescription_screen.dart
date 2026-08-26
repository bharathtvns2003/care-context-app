import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../theme/app_colors.dart';

class SharePrescriptionScreen extends StatelessWidget {
  final String patientName;
  final String doctorName;
  final String clinic;
  final String date;
  final List<MedicationItem> medications;

  const SharePrescriptionScreen({
    super.key,
    required this.patientName,
    required this.doctorName,
    required this.clinic,
    required this.date,
    required this.medications,
  });

  String _generateShareText() {
    final medicationsList = medications
        .asMap()
        .entries
        .map((e) => '${e.key + 1}. ${e.value.name} - ${e.value.dosage}')
        .join('\n');

    return '''
📋 *Prescription Summary*
━━━━━━━━━━━━━━━━━━

👤 *Patient:* $patientName
👨‍⚕️ *Doctor:* $doctorName
🏥 *Clinic:* $clinic
📅 *Date:* $date

💊 *Medications:*
$medicationsList

━━━━━━━━━━━━━━━━━━
🛡 Verified by CareContext
''';
  }

  Future<void> _exportAsPdf() async {
    await Share.share(
      _generateShareText(),
      subject: 'Prescription Summary - $patientName',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFC),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE4EEF2), width: 0.67),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => CcRouteHelper.pop(),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FBFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFF3D5566),
                    size: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Prescription Summary',
                style: GoogleFonts.sora(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A2B35),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPrescriptionCard(),
          const SizedBox(height: 14),
          _buildShareButton(
            label: '📄 Export as PDF',
            backgroundColor: const Color(0xFFE4EEF2),
            textColor: const Color(0xFF3D5566),
            onTap: _exportAsPdf,
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4EEF2), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1F2D).withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            _buildCardHeader(),
            _buildMedicationsList(),
            _buildCardFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.8, -0.8),
          end: Alignment(0.8, 0.8),
          colors: [Color(0xFF0D1F2D), Color(0xFF055F58)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('💊', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Care',
                          style: GoogleFonts.sora(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.white,
                          ),
                        ),
                        TextSpan(
                          text: 'Context',
                          style: GoogleFonts.sora(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF94EDE7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'ABHA-7842-3910 · Verified',
                    style: GoogleFonts.dmSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Prescription Summary',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            patientName,
            style: GoogleFonts.sora(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$doctorName · $clinic · $date',
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationsList() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: medications.asMap().entries.map((entry) {
          final index = entry.key;
          final medication = entry.value;
          final isLast = index == medications.length - 1;
          return _buildMedicationItem(index + 1, medication, isLast);
        }).toList(),
      ),
    );
  }

  Widget _buildMedicationItem(int number, MedicationItem medication, bool isLast) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Color(0xFFE4EEF2), width: 0.67),
              ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFFE6FAF9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '$number',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF055F58),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medication.name,
                style: GoogleFonts.sora(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A2B35),
                ),
              ),
              Text(
                medication.dosage,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7A96A4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF7FBFC),
        border: Border(
          top: BorderSide(color: Color(0xFFE4EEF2), width: 0.67),
        ),
      ),
      child: Center(
        child: Text(
          '🛡 Verified by CareContext · Generated $date',
          style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF7A96A4),
          ),
        ),
      ),
    );
  }

  Widget _buildShareButton({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 51,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.sora(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class MedicationItem {
  final String name;
  final String dosage;

  MedicationItem({required this.name, required this.dosage});
}
