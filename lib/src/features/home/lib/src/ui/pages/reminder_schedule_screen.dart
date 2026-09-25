import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/home_bloc.dart';
import '../../repository/entity/home_entity.dart';
import '../../theme/app_colors.dart';
import 'add_medicine_screen.dart';

class ReminderScheduleScreen extends StatelessWidget {
  final List<Medicine> medicines;
  final String? prescriptionId;

  const ReminderScheduleScreen({
    super.key,
    required this.medicines,
    this.prescriptionId,
  });

  static Map<String, dynamic> get _schema =>
      RemoteConfigService.instance.getJson('reminder_ui_config');

  Map<String, dynamic> get _headerSchema =>
      _schema['header'] as Map<String, dynamic>;
  Map<String, dynamic> get _timeCardSchema =>
      _schema['timeCard'] as Map<String, dynamic>;
  Map<String, dynamic> get _featuresCardSchema =>
      _schema['featuresCard'] as Map<String, dynamic>;
  Map<String, dynamic> get _activateButtonSchema =>
      _schema['activateButton'] as Map<String, dynamic>;
  Map<String, dynamic> get _editButtonSchema =>
      _schema['editButton'] as Map<String, dynamic>;

  Map<String, List<Medicine>> _groupByTime() {
    final Map<String, List<Medicine>> grouped = {};
    for (final medicine in medicines) {
      for (final reminder in medicine.reminderTimes) {
        final time = reminder.time;
        if (!grouped.containsKey(time)) {
          grouped[time] = [];
        }
        grouped[time]!.add(medicine);
      }
    }
    final sortedKeys = grouped.keys.toList()..sort();
    return {for (var k in sortedKeys) k: grouped[k]!};
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is RemindersActivatedState) {
          context.read<HomeBloc>().add(LoadHomeDataEvent());
          CcRouteHelper.pushAndPopUntil(CcRouteConstants.homeScreen);
        } else if (state is HomeErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildBody(context)),
          ],
        ),
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
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
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
              const SizedBox(height: 18),
              Text(
                _headerSchema['title'] as String,
                style: GoogleFonts.sora(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _headerSchema['subtitle'] as String,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
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

  Widget _buildBody(BuildContext context) {
    final grouped = _groupByTime();

    return Container(
      width: double.infinity,
      color: const Color(0xFFF7FBFC),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...grouped.entries.map((entry) => Column(
                  children: [
                    _buildTimeCard(entry.key, entry.value),
                    const SizedBox(height: 10),
                  ],
                )),
            _buildFeaturesCard(),
            const SizedBox(height: 10),
            _buildActivateButton(context),
            const SizedBox(height: 10),
            _buildEditScheduleButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard(String time, List<Medicine> meds) {
    final countLabel = meds.length == 1
        ? _timeCardSchema['singularLabel'] as String
        : _timeCardSchema['pluralLabel'] as String;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
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
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF7FBFC),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE4EEF2), width: 0.7),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-0.7, -0.7),
                      end: Alignment(0.7, 0.7),
                      colors: [AppColors.accentTealDark, AppColors.primaryTeal],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.access_time,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: GoogleFonts.sora(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A2B35),
                      ),
                    ),
                    Text(
                      '${meds.length} $countLabel',
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
          ),
          ...meds.asMap().entries.map((entry) {
            final isLast = entry.key == meds.length - 1;
            return _buildMedicineItem(entry.value, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildMedicineItem(Medicine medicine, bool isLast) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Color(0xFFE4EEF2), width: 0.7),
              ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFE6FAF9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.medication_outlined,
              color: AppColors.primaryTeal,
              size: 13,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medicine.name,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A2B35),
                ),
              ),
              Text(
                medicine.dosage,
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

  Widget _buildFeaturesCard() {
    final features =
        List<String>.from(_featuresCardSchema['features'] as List);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6FAF9), width: 0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _featuresCardSchema['title'] as String,
            style: GoogleFonts.sora(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTeal,
            ),
          ),
          const SizedBox(height: 8),
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Text(
                      '•',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentTealDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      feature,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF3D5566),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildActivateButton(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final isLoading = state is HomeLoadingState;
        return Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment(-0.8, -0.8),
              end: Alignment(0.8, 0.8),
              colors: [AppColors.accentTealDark, AppColors.primaryTeal],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentTealDark.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : () => _onActivateReminders(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    _activateButtonSchema['text'] as String,
                    style: GoogleFonts.sora(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }

  void _onActivateReminders(BuildContext context) {
    String? pid = prescriptionId;
    if (pid == null || pid.isEmpty) {
      final state = context.read<HomeBloc>().state;
      if (state is PrescriptionUploadedState) {
        pid = state.prescriptionId;
      }
    }

    if (pid == null || pid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prescription ID is required to set reminders.'),
        ),
      );
      return;
    }

    final entities = medicines
        .map((m) => MedicineEntity(
              id: m.id,
              name: m.name,
              dosage: m.dosage,
              frequency: m.frequency,
              frequencyType: m.frequencyType,
              dayOfWeek: m.dayOfWeek,
              duration: m.duration,
              reminderTimes: m.reminderTimes
                  .map((r) => ReminderTimeEntity(
                        slotId: r.slotId,
                        time: r.time,
                        scheduledAt: r.scheduledAt,
                        status: r.status,
                      ))
                  .toList(),
            ))
        .toList();

    context.read<HomeBloc>().add(
          ActivateRemindersEvent(
            prescriptionId: pid,
            medicines: entities,
          ),
        );
  }

  Widget _buildEditScheduleButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4EEF2), width: 1.3),
      ),
      child: TextButton(
        onPressed: () {
          CcRouteHelper.pop();
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.edit_outlined, color: Color(0xFF3D5566), size: 14),
            const SizedBox(width: 8),
            Text(
              _editButtonSchema['text'] as String,
              style: GoogleFonts.sora(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF3D5566),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
