import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../core/api_service/contract/home_mock_contract.dart';

class InsuranceClaimsScreen extends StatelessWidget {
  const InsuranceClaimsScreen({super.key});

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
              Text('File a Claim', style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.white)),
              const SizedBox(height: 6),
              Text('Submit your insurance claim', style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white.withValues(alpha: 0.6))),
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
          _buildClaimTypeSelector(),
          const SizedBox(height: 20),
          _buildUploadSection(),
          const SizedBox(height: 20),
          _buildRecentClaims(),
          const SizedBox(height: 20),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildClaimTypeSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4EEF2), width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Claim Type', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF1A2B35))),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildClaimChip('Cashless', true),
              const SizedBox(width: 10),
              _buildClaimChip('Reimbursement', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClaimChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE6FAF9) : AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? AppColors.primaryTeal : const Color(0xFFE4EEF2),
          width: 1.3,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColors.primaryTeal : const Color(0xFF7A96A4),
        ),
      ),
    );
  }

  Widget _buildUploadSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4EEF2), width: 1.3),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_upload_outlined, size: 40, color: Color(0xFF7A96A4)),
          const SizedBox(height: 12),
          Text('Upload Bills & Documents', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1A2B35))),
          const SizedBox(height: 4),
          Text('PDF, JPG, PNG (max 10MB)', style: GoogleFonts.dmSans(fontSize: 12, color: const Color(0xFF7A96A4))),
        ],
      ),
    );
  }

  Widget _buildRecentClaims() {
    final insurance = HomeMockContract.homeDataMockResponse['insurance'] as Map<String, dynamic>;
    final claims = insurance['claims'] as List<dynamic>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Claims', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF1A2B35))),
        const SizedBox(height: 12),
        ...claims.map((c) {
          final map = c as Map<String, dynamic>;
          final isApproved = (map['status'] as String) == 'approved';
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildClaimItem(
              map['type'] as String,
              map['date'] as String,
              isApproved ? 'Approved' : 'Processing',
              isApproved,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildClaimItem(String type, String date, String status, bool isApproved) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4EEF2), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(type, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1A2B35))),
              Text(date, style: GoogleFonts.dmSans(fontSize: 11, color: const Color(0xFF7A96A4))),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isApproved ? const Color(0xFFE6FAF9) : const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isApproved ? AppColors.primaryTeal : const Color(0xFFD97706),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.accentTealDark, AppColors.primaryTeal]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text('Submit Claim', style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.white)),
      ),
    );
  }
}
