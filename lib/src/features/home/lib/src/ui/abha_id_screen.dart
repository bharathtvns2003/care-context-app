import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class AbhaIdScreen extends StatelessWidget {
  const AbhaIdScreen({super.key});

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
        gradient: LinearGradient(
          begin: Alignment(-0.8, -0.8),
          end: Alignment(0.8, 0.8),
          colors: [Color(0xFF1B2A4A), Color(0xFF243B6A)],
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
              GestureDetector(
                onTap: () => CcRouteHelper.pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back, color: AppColors.white, size: 18),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'ABHA ID',
                style: GoogleFonts.sora(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Link your Ayushman Bharat Health Account',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.6),
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
        children: [
          _buildInfoCard(),
          const SizedBox(height: 20),
          _buildBenefitsCard(),
          const SizedBox(height: 20),
          _buildLinkButton(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4EEF2), width: 1.3),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE6FAF9),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Icon(Icons.verified_user, color: AppColors.primaryTeal, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            'What is ABHA?',
            style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF1A2B35)),
          ),
          const SizedBox(height: 8),
          Text(
            'ABHA (Ayushman Bharat Health Account) is a unique health ID that links all your health records digitally across hospitals and clinics.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(fontSize: 13, color: const Color(0xFF7A96A4), height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsCard() {
    final benefits = [
      'Access health records from any hospital',
      'Share records with doctors instantly',
      'Paperless healthcare experience',
      'Government-backed secure system',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFC),
        borderRadius: BorderRadius.circular(18),
        border: const Border(left: BorderSide(color: AppColors.accentTealDark, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Benefits', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryTeal)),
          const SizedBox(height: 12),
          ...benefits.map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 16, color: AppColors.primaryTeal),
                const SizedBox(width: 10),
                Expanded(child: Text(b, style: GoogleFonts.dmSans(fontSize: 13, color: const Color(0xFF1A2B35)))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildLinkButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1B2A4A), Color(0xFF243B6A)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text('Link ABHA ID', style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.white)),
      ),
    );
  }
}
