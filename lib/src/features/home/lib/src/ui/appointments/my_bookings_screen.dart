import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../core/api_service/contract/home_mock_contract.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

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
              Text(
                'My Bookings',
                style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.white),
              ),
              const SizedBox(height: 6),
              Text(
                'Your upcoming appointments',
                style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final mockAppointments = HomeMockContract.homeDataMockResponse['appointments'] as List<dynamic>;
    final appointments = mockAppointments.map((a) {
      final map = a as Map<String, dynamic>;
      return _AppointmentData(
        doctorName: map['doctorName'] as String,
        speciality: map['speciality'] as String,
        date: map['date'] as String,
        time: map['time'] as String,
        clinic: map['clinic'] as String,
        isConfirmed: map['status'] == 'confirmed',
      );
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: appointments.map((a) => _buildAppointmentCard(a)).toList(),
      ),
    );
  }

  Widget _buildAppointmentCard(_AppointmentData appointment) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4EEF2), width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  appointment.doctorName,
                  style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF1A2B35)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: appointment.isConfirmed ? const Color(0xFFE6FAF9) : const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  appointment.isConfirmed ? 'Confirmed' : 'Pending',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: appointment.isConfirmed ? AppColors.primaryTeal : const Color(0xFFD97706),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            appointment.speciality,
            style: GoogleFonts.dmSans(fontSize: 12, color: const Color(0xFF7A96A4)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF7A96A4)),
              const SizedBox(width: 6),
              Text(appointment.date, style: GoogleFonts.dmSans(fontSize: 12, color: const Color(0xFF1A2B35))),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 14, color: Color(0xFF7A96A4)),
              const SizedBox(width: 6),
              Text(appointment.time, style: GoogleFonts.dmSans(fontSize: 12, color: const Color(0xFF1A2B35))),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF7A96A4)),
              const SizedBox(width: 6),
              Text(appointment.clinic, style: GoogleFonts.dmSans(fontSize: 12, color: const Color(0xFF7A96A4))),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppointmentData {
  final String doctorName;
  final String speciality;
  final String date;
  final String time;
  final String clinic;
  final bool isConfirmed;

  _AppointmentData({
    required this.doctorName,
    required this.speciality,
    required this.date,
    required this.time,
    required this.clinic,
    required this.isConfirmed,
  });
}
