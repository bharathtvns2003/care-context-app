import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../core/api_service/contract/home_mock_contract.dart';
import 'add_medicine_screen.dart';

class ExtractedMedicinesScreen extends StatefulWidget {
  const ExtractedMedicinesScreen({super.key});

  @override
  State<ExtractedMedicinesScreen> createState() =>
      _ExtractedMedicinesScreenState();
}

class _ExtractedMedicinesScreenState extends State<ExtractedMedicinesScreen> {
  late List<Medicine> _medicines;
  final Map<String, dynamic> _response =
      HomeMockContract.aiExtractionMockResponse;

  Map<String, dynamic> get _headerSchema =>
      _response['header'] as Map<String, dynamic>;
  Map<String, dynamic> get _cardSchema =>
      _response['medicineCard'] as Map<String, dynamic>;
  Map<String, dynamic> get _cardLabels =>
      _cardSchema['labels'] as Map<String, dynamic>;
  Map<String, dynamic> get _warningSchema =>
      _cardSchema['warning'] as Map<String, dynamic>;
  Map<String, dynamic> get _deleteDialogSchema =>
      _response['deleteDialog'] as Map<String, dynamic>;
  Map<String, dynamic> get _addButtonSchema =>
      _response['addButton'] as Map<String, dynamic>;
  Map<String, dynamic> get _confirmButtonSchema =>
      _response['confirmButton'] as Map<String, dynamic>;

  @override
  void initState() {
    super.initState();
    final mockMedicines = _response['medicines'] as List<dynamic>;
    _medicines = mockMedicines.map((m) {
      final map = m as Map<String, dynamic>;
      return Medicine(
        name: map['name'] as String,
        dosage: map['dosage'] as String,
        frequency: map['frequency'] as String,
        duration: map['duration'] as String,
        reminderTimes: List<String>.from(map['reminderTimes'] as List),
        hasWarning: map['hasWarning'] as bool? ?? false,
        warningDetail: map['warningDetail'] as String?,
      );
    }).toList();
  }

  void _editMedicine(int index) async {
    final result = await CcRouteHelper.push(
      CcRouteConstants.addMedicine,
      args: _medicines[index],
    );
    if (result != null && result is Medicine) {
      setState(() {
        _medicines[index] = result;
      });
    }
  }

  void _addMedicine() async {
    final result = await CcRouteHelper.push(CcRouteConstants.addMedicine);
    if (result != null && result is Medicine) {
      setState(() {
        _medicines.add(result);
      });
    }
  }

  void _deleteMedicine(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _deleteDialogSchema['title'] as String,
          style: GoogleFonts.sora(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          '${_deleteDialogSchema['contentPrefix']}${_medicines[index].name}${_deleteDialogSchema['contentSuffix']}',
          style: GoogleFonts.dmSans(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              _deleteDialogSchema['cancelText'] as String,
              style: GoogleFonts.dmSans(
                color: const Color(0xFF7A96A4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _medicines.removeAt(index);
              });
            },
            child: Text(
              _deleteDialogSchema['confirmText'] as String,
              style: GoogleFonts.dmSans(
                color: const Color(0xFFBE123C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
          bottom: BorderSide(color: Color(0xFFE4EEF2), width: 0.7),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => CcRouteHelper.pop(),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6FAF9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.primaryTeal,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _headerSchema['title'] as String,
                          style: GoogleFonts.sora(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A2B35),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _headerSchema['subtitle'] as String,
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF7A96A4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.accentTealDark.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: const Color(0xFFE6FAF9), width: 0.7),
                    ),
                    child: Text(
                      '${_medicines.length} ${_headerSchema['badgeSuffix']}',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF7FBFC),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...List.generate(_medicines.length, (index) {
              final medicine = _medicines[index];
              return Column(
                children: [
                  _buildMedicineCard(
                    index: index,
                    name: medicine.name,
                    dosage: medicine.dosage,
                    frequency: medicine.frequency,
                    duration: medicine.duration,
                    reminderTimes: medicine.reminderTimes,
                    hasWarning: medicine.hasWarning,
                    warningDetail: medicine.warningDetail,
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }),
            _buildAddMedicineButton(),
            const SizedBox(height: 10),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineCard({
    required int index,
    required String name,
    required String dosage,
    required String frequency,
    required String duration,
    required List<String> reminderTimes,
    bool hasWarning = false,
    String? warningDetail,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasWarning ? const Color(0xFFFECDD3) : const Color(0xFFE4EEF2),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1F2D).withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: GoogleFonts.sora(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A2B35),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _editMedicine(index),
                      child: _buildIconButton(Icons.edit_outlined,
                          const Color(0xFFE6FAF9), AppColors.primaryTeal),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _deleteMedicine(index),
                      child: _buildIconButton(Icons.delete_outline,
                          const Color(0xFFFFF1F2), const Color(0xFFBE123C)),
                    ),
                  ],
                ),
              ],
            ),
            if (hasWarning && warningDetail != null) ...[
              const SizedBox(height: 8),
              _buildWarningBox(warningDetail),
            ],
            const SizedBox(height: 10),
            _buildInfoRow(_cardLabels['dosage'] as String, dosage),
            _buildInfoRow(_cardLabels['frequency'] as String, frequency),
            _buildInfoRow(_cardLabels['duration'] as String, duration),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE4EEF2), width: 0.7),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _cardLabels['reminderTimes'] as String,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF7A96A4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children:
                        reminderTimes.map((time) => _buildTimeChip(time)).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color bgColor, Color iconColor) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 14, color: iconColor),
    );
  }

  Widget _buildWarningBox(String detail) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFECDD3), width: 1.3),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _warningSchema['title'] as String,
                  style: GoogleFonts.sora(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFBE123C),
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9F1239),
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: _warningSchema['bodyPrefix'] as String),
                      TextSpan(
                        text: detail,
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF9F1239),
                        ),
                      ),
                      TextSpan(text: _warningSchema['bodySuffix'] as String),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A2B35),
                height: 1.8,
              ),
            ),
            TextSpan(
              text: value,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF3D5566),
                height: 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChip(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6FAF9), width: 0.7),
      ),
      child: Text(
        time,
        style: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTeal,
        ),
      ),
    );
  }

  Widget _buildAddMedicineButton() {
    return GestureDetector(
      onTap: _addMedicine,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.accentTealDark,
            width: 1.3,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _addButtonSchema['icon'] as String,
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentTealDark,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _addButtonSchema['text'] as String,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentTealDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
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
        onPressed: () {
          CcRouteHelper.push(
            CcRouteConstants.reminderSchedule,
            args: _medicines,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline,
                color: AppColors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              _confirmButtonSchema['text'] as String,
              style: GoogleFonts.sora(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
