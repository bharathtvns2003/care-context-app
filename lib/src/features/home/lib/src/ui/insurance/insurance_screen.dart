import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../core/api_service/contract/home_mock_contract.dart';

class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({super.key});

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
              Text('Health Insurance', style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.white)),
              const SizedBox(height: 6),
              Text('Manage your health coverage', style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white.withValues(alpha: 0.6))),
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
          _buildActivePolicyCard(),
          const SizedBox(height: 16),
          _buildCoverageDetails(),
          const SizedBox(height: 16),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildActivePolicyCard() {
    final insurance = HomeMockContract.homeDataMockResponse['insurance'] as Map<String, dynamic>;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0D1F2D), Color(0xFF055F58)]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(insurance['providerName'] as String, style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.white)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  (insurance['status'] as String) == 'active' ? 'Active' : 'Inactive',
                  style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF4ADE80)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Policy: ${insurance['policyNumber']}', style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
          const SizedBox(height: 4),
          Text('Sum Insured: ${insurance['sumInsured']}', style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
        ],
      ),
    );
  }

  Widget _buildCoverageDetails() {
    final insurance = HomeMockContract.homeDataMockResponse['insurance'] as Map<String, dynamic>;
    final coverageList = insurance['coverage'] as List<dynamic>;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4EEF2), width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Coverage Includes', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF1A2B35))),
          const SizedBox(height: 12),
          ...coverageList.map((c) {
            final map = c as Map<String, dynamic>;
            return _buildCoverageItem(map['item'] as String, map['covered'] as bool);
          }),
        ],
      ),
    );
  }

  Widget _buildCoverageItem(String label, bool isCovered) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isCovered ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isCovered ? AppColors.primaryTeal : const Color(0xFFBE123C),
          ),
          const SizedBox(width: 10),
          Text(label, style: GoogleFonts.dmSans(fontSize: 13, color: const Color(0xFF1A2B35))),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFE6FAF9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                const Icon(Icons.download_outlined, color: AppColors.primaryTeal),
                const SizedBox(height: 6),
                Text('Download Card', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryTeal)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFE6FAF9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                const Icon(Icons.phone_outlined, color: AppColors.primaryTeal),
                const SizedBox(height: 6),
                Text('Contact Support', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryTeal)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
