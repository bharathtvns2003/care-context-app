import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class ReviewImagesScreen extends StatefulWidget {
  const ReviewImagesScreen({super.key});

  @override
  State<ReviewImagesScreen> createState() => _ReviewImagesScreenState();
}

class _ReviewImagesScreenState extends State<ReviewImagesScreen> {
  int _currentPage = 0;
  final int _totalPages = 3;
  String _selectedDocumentType = 'My Prescriptions';
  final List<String> _documentTypes = [
    'My Prescriptions',
    'Lab Reports',
    'Vaccination Records',
  ];

  bool get _hasPreviousPage => _currentPage > 0;
  bool get _hasNextPage => _currentPage < _totalPages - 1;

  void _goToPreviousPage() {
    if (!_hasPreviousPage) return;

    setState(() {
      _currentPage--;
    });
  }

  void _goToNextPage() {
    if (!_hasNextPage) return;

    setState(() {
      _currentPage++;
    });
  }

  void _handlePreviewSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity;
    if (velocity == null) return;

    if (velocity < -200) {
      _goToNextPage();
    } else if (velocity > 200) {
      _goToPreviousPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => CcRouteHelper.pop(),
                child: Container(
                  width: 35,
                  height: 35,
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
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Review Images',
                        style: GoogleFonts.sora(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A2B35),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '$_totalPages photos selected',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF7A96A4),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6FAF9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_currentPage + 1} / $_totalPages',
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
      child: Column(
        children: [
          _buildDocumentTypeDropdown(),
          Expanded(child: _buildPreviewArea()),
          _buildPageIndicators(),
          _buildThumbnails(),
          _buildFileInfo(),
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildDocumentTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE4EEF2), width: 1.3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D1F2D).withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedDocumentType,
            isExpanded: true,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF7A96A4),
            ),
            style: GoogleFonts.sora(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A2B35),
            ),
            items: _documentTypes.map((type) {
              IconData icon;
              switch (type) {
                case 'My Prescriptions':
                  icon = Icons.description_outlined;
                  break;
                case 'Lab Reports':
                  icon = Icons.science_outlined;
                  break;
                case 'Vaccination Records':
                  icon = Icons.vaccines_outlined;
                  break;
                default:
                  icon = Icons.folder_outlined;
              }
              return DropdownMenuItem<String>(
                value: type,
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6FAF9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: AppColors.primaryTeal, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      type,
                      style: GoogleFonts.sora(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A2B35),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedDocumentType = value;
                });
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewArea() {
    return GestureDetector(
      onHorizontalDragEnd: _handlePreviewSwipe,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.5, -0.5),
                end: Alignment(0.5, 0.5),
                colors: [Color(0xFFE8EEF4), Color(0xFFDDE6ED)],
              ),
            ),
            child: Center(
              child: Container(
                width: 235,
                margin: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D1F2D).withValues(alpha: 0.14),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPrescriptionHeader(),
                      const SizedBox(height: 14),
                      _buildPageInfo(),
                      const SizedBox(height: 14),
                      _buildMedicineRow('Paracetamol', '500mg · BD'),
                      const SizedBox(height: 14),
                      _buildMedicineRow('Amoxicillin', '250mg · TDS'),
                      const SizedBox(height: 14),
                      _buildMedicineRow('Vitamin D', '1000IU · OD'),
                      const SizedBox(height: 16),
                      _buildDateInfo(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              width: 31,
              height: 31,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.close, color: AppColors.white, size: 13),
            ),
          ),
          Positioned(
            left: 12,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: _hasPreviousPage ? _goToPreviousPage : null,
                child: Container(
                  width: 37,
                  height: 37,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0D1F2D).withValues(alpha: 0.15),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    color: _hasPreviousPage
                        ? const Color(0xFF7A96A4)
                        : const Color(0xFFE4EEF2),
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: _hasNextPage ? _goToNextPage : null,
                child: Container(
                  width: 37,
                  height: 37,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0D1F2D).withValues(alpha: 0.15),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: _hasNextPage
                        ? const Color(0xFF7A96A4)
                        : const Color(0xFFE4EEF2),
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionHeader() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE4EEF2), width: 0.7),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DR. S. MEHTA',
                style: GoogleFonts.dmSans(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTeal,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'MBBS, MD · Reg. 12345',
                style: GoogleFonts.dmSans(
                  fontSize: 8,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7A96A4),
                ),
              ),
            ],
          ),
          Container(
            width: 23,
            height: 23,
            decoration: BoxDecoration(
              color: const Color(0xFFE6FAF9),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.primaryTeal,
              size: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageInfo() {
    return Text(
      'Page ${_currentPage + 1} of $_totalPages',
      style: GoogleFonts.dmSans(
        fontSize: 8,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF7A96A4),
      ),
    );
  }

  Widget _buildMedicineRow(String name, String dosage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: GoogleFonts.dmSans(
            fontSize: 8,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A2B35),
          ),
        ),
        Text(
          dosage,
          style: GoogleFonts.dmSans(
            fontSize: 8,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF7A96A4),
          ),
        ),
      ],
    );
  }

  Widget _buildDateInfo() {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE4EEF2), width: 0.7)),
      ),
      child: Text(
        'Date: 11 Jun 2026',
        style: GoogleFonts.dmSans(
          fontSize: 8,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF7A96A4),
        ),
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_totalPages, (index) {
          final isActive = index == _currentPage;
          return Container(
            width: isActive ? 20 : 7,
            height: 7,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.accentTealDark
                  : const Color(0xFFE4EEF2),
              borderRadius: BorderRadius.circular(100),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildThumbnails() {
    return Container(
      height: 108,
      padding: const EdgeInsets.fromLTRB(18, 31, 18, 0),
      child: Row(
        children: [
          _buildThumbnail(0, 'Page 1', isSelected: _currentPage == 0),
          const SizedBox(width: 10),
          _buildThumbnail(1, 'Page 2', isSelected: _currentPage == 1),
          const SizedBox(width: 10),
          _buildThumbnail(2, 'Page 3', isSelected: _currentPage == 2),
          const SizedBox(width: 10),
          _buildAddThumbnail(),
        ],
      ),
    );
  }

  Widget _buildThumbnail(int index, String label, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () => setState(() => _currentPage = index),
      child: Container(
        width: 66,
        height: 82,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(-0.5, -0.5),
            end: Alignment(0.5, 0.5),
            colors: [Color(0xFFE8EEF4), Color(0xFFDDE6ED)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.accentTealDark
                : const Color(0xFFE4EEF2),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 18,
              color: isSelected
                  ? AppColors.primaryTeal
                  : const Color(0xFF7A96A4),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.primaryTeal
                    : const Color(0xFF7A96A4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddThumbnail() {
    return Container(
      width: 66,
      height: 82,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accentTealDark,
          width: 2,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: CustomPaint(
        painter: DashedBorderPainter(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 20, color: AppColors.accentTealDark),
            const SizedBox(height: 4),
            Text(
              'Add',
              style: GoogleFonts.dmSans(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: AppColors.accentTealDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'prescription_p1.jpg · 2.4 MB',
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF7A96A4),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
      child: Container(
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
              color: AppColors.accentTealDark.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            CcRouteHelper.push(CcRouteConstants.aiProcessing);
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
              Text(
                'Continue',
                style: GoogleFonts.sora(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, color: AppColors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentTealDark
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(12),
        ),
      );

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double distance = 0.0;

    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final segment = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
