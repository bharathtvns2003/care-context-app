import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home.dart';
import '../../theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Medicine> _medicines = [];
  List<MedicineReminder> _reminders = [];
  List<PrescriptionEntity> _prescriptions = [];

  @override
  void initState() {
    super.initState();
    _reloadHomeData();
    PushNotificationService.instance.requestPermissionAndRegister();
  }

  void _reloadHomeData() {
    getIt<HomeBloc>().add(LoadHomeDataEvent());
  }

  void _ensureHomeDataLoaded(HomeState state) {
    if (_hasPrescriptions) return;
    if (state is HomeLoadingState ||
        state is HomeLoadedState ||
        state is HomeErrorState) {
      return;
    }
    // Returning via back with a transient bloc state (e.g. MedicinesLoaded).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _hasPrescriptions) return;
      final current = getIt<HomeBloc>().state;
      if (current is HomeLoadingState || current is HomeLoadedState) return;
      _reloadHomeData();
    });
  }

  void _updateFromHomeData(HomeEntity homeData) {
    _prescriptions = homeData.prescriptions;
    _medicines = homeData.medicines.map((e) => Medicine(
      name: e.name,
      dosage: e.dosage,
      frequency: e.frequency,
      duration: e.duration,
      reminderTimes: e.reminderTimes
          .map((r) => ReminderTime(
                slotId: r.slotId,
                time: r.time,
                scheduledAt: r.scheduledAt,
                status: r.status,
              ))
          .toList(),
    )).toList();
    _reminders = _generateReminders();

    if (_medicines.isEmpty && _prescriptions.isNotEmpty) {
      for (final p in _prescriptions) {
        getIt<HomeBloc>().add(GetMedicinesEvent(prescriptionId: p.id));
      }
    }
  }

  void _updateMedicines(List<MedicineEntity> entities) {
    final newMeds = entities.map((e) => Medicine(
      name: e.name,
      dosage: e.dosage,
      frequency: e.frequency,
      duration: e.duration,
      reminderTimes: e.reminderTimes
          .map((r) => ReminderTime(
                slotId: r.slotId,
                time: r.time,
                scheduledAt: r.scheduledAt,
                status: r.status,
              ))
          .toList(),
    )).toList();

    final existingNames = _medicines.map((m) => m.name).toSet();
    for (final medicine in newMeds) {
      if (!existingNames.contains(medicine.name)) {
        _medicines.add(medicine);
        existingNames.add(medicine.name);
      }
    }
    _reminders = _generateReminders();
  }

  bool get _hasPrescriptions => _prescriptions.isNotEmpty || _medicines.isNotEmpty;

  List<MedicineReminder> _generateReminders() {
    final List<MedicineReminder> reminders = [];
    for (final medicine in _medicines) {
      for (final reminder in medicine.reminderTimes) {
        final isTaken = reminder.status == 'TAKEN' ||
            (reminder.status == null && _isTimePassed(reminder.time));
        reminders.add(
          MedicineReminder(
            medicine: medicine,
            time: reminder.time,
            slotId: reminder.slotId,
            status: reminder.status,
            isTaken: isTaken,
          ),
        );
      }
    }
    reminders.sort((a, b) => a.time.compareTo(b.time));
    return reminders;
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

  String _formatTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  int get _takenCount => _reminders.where((r) => r.isTaken).length;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoadedState) {
          setState(() {
            _updateFromHomeData(state.homeData);
          });
        } else if (state is MedicinesLoadedState) {
          setState(() {
            _updateMedicines(state.medicines);
          });
        }
      },
      builder: (context, state) {
        _ensureHomeDataLoaded(state);

        // Keep showing home content during secondary loads (e.g. get medicines).
        if (!_hasPrescriptions) {
          if (state is HomeErrorState) {
            return Scaffold(
              backgroundColor: const Color(0xFFF7FBFC),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _reloadHomeData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Initial app load — show spinner until first home response.
          if (state is HomeLoadingState || state is HomeInitialState) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryTeal,
                ),
              ),
            );
          }

          // Only show empty upload UI after a successful home load with no data.
          if (state is HomeLoadedState) {
            return const UploadPrescriptionScreen();
          }

          // Transient states (upload/medicines) — keep empty upload UI, not a second loader.
          return const UploadPrescriptionScreen();
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF7FBFC),
          body: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildBody()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
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
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        'User',
                        style: GoogleFonts.sora(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  _buildHeaderIcon(Icons.notifications_outlined),
                ],
              ),
              const SizedBox(height: 18),
              _buildTodaysMedicinesCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: AppColors.white, size: 20),
    );
  }

  Widget _buildTodaysMedicinesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.favorite_outline,
              color: AppColors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Medicines",
                  style: GoogleFonts.sora(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$_takenCount of ${_reminders.length} taken today',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              CcRouteHelper.push(
                CcRouteConstants.todaysSchedule,
                args: _medicines,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Check',
                style: GoogleFonts.sora(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF055F58),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildAbhaIdCard(),
          const SizedBox(height: 16),
          _buildUploadPrescriptionCard(),
          const SizedBox(height: 16),
          _buildTodaysMedicinesList(),
          const SizedBox(height: 16),
          _buildQuickActionsRow(),
        ],
      ),
    );
  }

  Widget _buildAbhaIdCard() {
    return GestureDetector(
      onTap: () {
        CcRouteHelper.push(CcRouteConstants.abhaId);
      },
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B2A4A), Color(0xFF243B6A)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1B2A4A).withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Tricolor strip at top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        color: const Color(0xFFFF9933),
                      ),
                    ),
                    Expanded(
                      child: Container(height: 4, color: AppColors.white),
                    ),
                    Expanded(
                      child: Container(
                        height: 4,
                        color: const Color(0xFF138808),
                      ),
                    ),
                  ],
                ),
              ),
              // Subtle Ashoka Chakra watermark
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  Icons.blur_circular,
                  size: 120,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
              // Card content
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.verified_user,
                            color: Color(0xFF94EDE7),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ABHA',
                              style: GoogleFonts.sora(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              'Ayushman Bharat Health Account',
                              style: GoogleFonts.dmSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFFF9933,
                            ).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(
                                0xFFFF9933,
                              ).withValues(alpha: 0.4),
                              width: 0.7,
                            ),
                          ),
                          child: Text(
                            'Link Now',
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFFB366),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      'XXXX  XXXX  XXXX  XXXX',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.5),
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CARD HOLDER',
                              style: GoogleFonts.dmSans(
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.4),
                                letterSpacing: 0.8,
                              ),
                            ),
                            Text(
                              'Akash Mandla',
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'STATUS',
                              style: GoogleFonts.dmSans(
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.4),
                                letterSpacing: 0.8,
                              ),
                            ),
                            Text(
                              'Not Linked',
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFFF9933),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildUploadPrescriptionCard() {
    return GestureDetector(
      onTap: () => UploadPrescriptionScreen.showPickOptions(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE4EEF2), width: 1.3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D1F2D).withValues(alpha: 0.07),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE6FAF9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: AppColors.primaryTeal,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload Prescription',
                  style: GoogleFonts.sora(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A2B35),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Upload your prescription',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7A96A4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysMedicinesList() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4EEF2), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1F2D).withValues(alpha: 0.07),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Medicines",
                style: GoogleFonts.sora(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A2B35),
                ),
              ),
              Text(
                '$_takenCount/${_reminders.length}',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7A96A4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(_reminders.length, (index) {
            final reminder = _reminders[index];
            return Column(
              children: [
                _buildMedicineItem(reminder, index),
                if (index < _reminders.length - 1) const SizedBox(height: 8),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMedicineItem(MedicineReminder reminder, int index) {
    return GestureDetector(
      onTap: () {
        CcRouteHelper.push(
          CcRouteConstants.medicineInfo,
          args: reminder.medicine,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FBFC),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (!reminder.isTaken) {
                  setState(() {
                    _reminders[index] = MedicineReminder(
                      medicine: reminder.medicine,
                      time: reminder.time,
                      slotId: reminder.slotId,
                      status: 'TAKEN',
                      isTaken: true,
                    );
                  });
                  if (reminder.slotId != null && reminder.slotId!.isNotEmpty) {
                    context.read<HomeBloc>().add(
                      RespondSlotEvent(
                        slotId: reminder.slotId!,
                        action: 'taken',
                      ),
                    );
                  }
                }
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: reminder.isTaken
                      ? const Color(0xFF0AB5A8).withValues(alpha: 0.18)
                      : const Color(0xFFE6FAF9),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Icon(
                  reminder.isTaken
                      ? Icons.check_circle
                      : Icons.favorite_outline,
                  color: reminder.isTaken
                      ? const Color(0xFF0AB5A8)
                      : AppColors.primaryTeal,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.medicine.name,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1A2B35),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    reminder.medicine.dosage,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF7A96A4),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(reminder.time),
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF1A2B35),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  reminder.isTaken ? 'Taken' : 'Pending',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: reminder.isTaken
                        ? const Color(0xFF0AB5A8)
                        : const Color(0xFF7A96A4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.history,
            title: 'History',
            subtitle: '7 prescriptions',
            onTap: () {
              CcRouteHelper.push(CcRouteConstants.prescriptionHistory);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.edit_calendar_outlined,
            title: 'Edit',
            subtitle: 'Edit Medicines',
            onTap: () {
              final prescriptionId = _prescriptions.isNotEmpty
                  ? _prescriptions.first.id
                  : null;
              CcRouteHelper.push(
                CcRouteConstants.extractedMedicines,
                args: prescriptionId,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 21),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE4EEF2), width: 1.3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D1F2D).withValues(alpha: 0.07),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE6FAF9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primaryTeal, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.sora(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A2B35),
              ),
            ),
            const SizedBox(height: 0),
            Text(
              subtitle,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF7A96A4),
              ),
            ),
          ],
        ),
      ),
    );
  }

}


class MedicineReminder {
  final Medicine medicine;
  final String time;
  final String? slotId;
  final String? status;
  final bool isTaken;

  MedicineReminder({
    required this.medicine,
    required this.time,
    this.slotId,
    this.status,
    required this.isTaken,
  });
}
