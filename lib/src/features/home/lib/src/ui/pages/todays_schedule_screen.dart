import 'dart:math';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../bloc/home_bloc.dart';
import '../../theme/app_colors.dart';
import 'add_medicine_screen.dart';

class TodaysScheduleScreen extends StatefulWidget {
  final List<Medicine> medicines;

  const TodaysScheduleScreen({super.key, required this.medicines});

  @override
  State<TodaysScheduleScreen> createState() => _TodaysScheduleScreenState();
}

class _TodaysScheduleScreenState extends State<TodaysScheduleScreen> {
  late List<ScheduledDose> _doses;

  @override
  void initState() {
    super.initState();
    _doses = _generateDoses();
  }

  List<ScheduledDose> _generateDoses() {
    final List<ScheduledDose> doses = [];
    for (final medicine in widget.medicines) {
      for (final reminder in medicine.reminderTimes) {
        final isTaken = reminder.status == 'TAKEN' ||
            (reminder.status == null && _isTimePassed(reminder.time));
        doses.add(
          ScheduledDose(
            medicine: medicine,
            time: reminder.time,
            slotId: reminder.slotId,
            status: reminder.status,
            isTaken: isTaken,
          ),
        );
      }
    }
    doses.sort((a, b) => a.time.compareTo(b.time));
    return doses;
  }

  bool _isTimePassed(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final now = TimeOfDay.now();
    if (hour < now.hour) return true;
    if (hour == now.hour && minute <= now.minute) return true;
    return false;
  }

  String _formatTimeShort(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour $period';
  }

  String _getTimeOfDay(String time) {
    final hour = int.parse(time.split(':')[0]);
    if (hour >= 5 && hour < 12) return 'Morning';
    if (hour >= 12 && hour < 17) return 'Afternoon';
    return 'Evening';
  }

  Map<String, List<ScheduledDose>> _groupByTimeOfDay() {
    final Map<String, List<ScheduledDose>> grouped = {
      'Morning': [],
      'Afternoon': [],
      'Evening': [],
    };
    for (final dose in _doses) {
      final period = _getTimeOfDay(dose.time);
      grouped[period]!.add(dose);
    }
    return grouped;
  }

  int get _takenCount => _doses.where((d) => d.isTaken).length;
  int get _totalCount => _doses.length;
  double get _adherencePercent =>
      _totalCount > 0 ? (_takenCount / _totalCount) * 100 : 0;

  Color _getTimeChipBgColor(String time, bool isTaken) {
    if (isTaken) return const Color(0xFFDCFCE7);
    final hour = int.parse(time.split(':')[0]);
    if (hour >= 5 && hour < 12) return const Color(0xFFE6FAF9);
    if (hour >= 12 && hour < 17) return const Color(0xFFE6FAF9);
    return const Color(0xFFFFF1EA);
  }

  Color _getTimeChipTextColor(String time, bool isTaken) {
    if (isTaken) return const Color(0xFF16A34A);
    final hour = int.parse(time.split(':')[0]);
    if (hour >= 5 && hour < 12) return const Color(0xFF055F58);
    if (hour >= 12 && hour < 17) return const Color(0xFF055F58);
    return const Color(0xFFC05621);
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
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, d MMMM yyyy');

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
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Today's Schedule",
                style: GoogleFonts.sora(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateFormat.format(now),
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 14),
              _buildAdherenceCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdherenceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 0.67,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: Stack(
              children: [
                CustomPaint(
                  size: const Size(52, 52),
                  painter: CircularProgressPainter(
                    progress: _adherencePercent / 100,
                    strokeWidth: 5,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    progressColor: const Color(0xFF94EDE7),
                  ),
                ),
                Center(
                  child: Text(
                    '${_adherencePercent.round()}%',
                    style: GoogleFonts.sora(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF94EDE7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _adherencePercent >= 70
                    ? 'Great adherence! 🎉'
                    : 'Keep going! 💪',
                style: GoogleFonts.sora(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$_takenCount of $_totalCount doses taken this week',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final grouped = _groupByTimeOfDay();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (grouped['Morning']!.isNotEmpty) ...[
            _buildSectionHeader('Morning'),
            const SizedBox(height: 10),
            ...grouped['Morning']!.map((dose) => _buildDoseCard(dose)),
          ],
          if (grouped['Afternoon']!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSectionHeader('Afternoon'),
            const SizedBox(height: 10),
            ...grouped['Afternoon']!.map((dose) => _buildDoseCard(dose)),
          ],
          if (grouped['Evening']!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSectionHeader('Evening'),
            const SizedBox(height: 10),
            ...grouped['Evening']!.map((dose) => _buildDoseCard(dose)),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.sora(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF7A96A4),
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildDoseCard(ScheduledDose dose) {
    final index = _doses.indexOf(dose);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: dose.isTaken
                ? const Color(0xFF0AB5A8)
                : const Color(0xFFE4EEF2),
            width: 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D1F2D).withValues(alpha: 0.05),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Opacity(
          opacity: dose.isTaken ? 0.75 : 1.0,
          child: Row(
            children: [
              Container(
                width: 54,
                height: 36,
                decoration: BoxDecoration(
                  color: _getTimeChipBgColor(dose.time, dose.isTaken),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    _formatTimeShort(dose.time),
                    style: GoogleFonts.sora(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _getTimeChipTextColor(dose.time, dose.isTaken),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${dose.medicine.name} ${dose.medicine.dosage}',
                      style: GoogleFonts.sora(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A2B35),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tablet · ${_getMealInstruction(dose.time)}',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7A96A4),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (!dose.isTaken) {
                    setState(() {
                      _doses[index] = ScheduledDose(
                        medicine: dose.medicine,
                        time: dose.time,
                        slotId: dose.slotId,
                        status: 'TAKEN',
                        isTaken: true,
                      );
                    });
                    context.read<HomeBloc>().add(
                      RespondSlotEvent(
                        slotId: dose.slotId ?? '',
                        action: 'taken',
                      ),
                    );
                  }
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: dose.isTaken
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFE4EEF2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: dose.isTaken
                      ? const Icon(
                          Icons.check,
                          color: Color(0xFF16A34A),
                          size: 14,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMealInstruction(String time) {
    final hour = int.parse(time.split(':')[0]);
    if (hour >= 6 && hour < 10) return 'After breakfast';
    if (hour >= 12 && hour < 15) return 'After lunch';
    if (hour >= 18 && hour < 22) return 'After dinner';
    return 'As prescribed';
  }
}

class ScheduledDose {
  final Medicine medicine;
  final String time;
  final String? slotId;
  final String? status;
  final bool isTaken;

  ScheduledDose({
    required this.medicine,
    required this.time,
    this.slotId,
    this.status,
    required this.isTaken,
  });
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
