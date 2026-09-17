import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_colors.dart';

class UploadPrescriptionScreen extends StatelessWidget {
  const UploadPrescriptionScreen({super.key});

  static Future<void> pickAndReview(
    BuildContext context,
    ImageSource source,
  ) async {
    final picker = ImagePicker();
    final List<String> paths = [];

    if (source == ImageSource.gallery) {
      final images = await picker.pickMultiImage(imageQuality: 85);
      paths.addAll(images.map((e) => e.path));
    } else {
      final image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (image != null) paths.add(image.path);
    }

    if (!context.mounted || paths.isEmpty) return;

    CcRouteHelper.push(
      CcRouteConstants.reviewImages,
      args: paths,
    );
  }

  static void showPickOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4EEF2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Upload Prescription',
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A2B35),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined,
                      color: AppColors.primaryTeal),
                  title: Text(
                    'Choose from Gallery',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A2B35),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    pickAndReview(context, ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined,
                      color: AppColors.primaryTeal),
                  title: Text(
                    'Take Photo',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A2B35),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    pickAndReview(context, ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody(context)),
        ],
      ),
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
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add your prescription\nto get started',
                style: GoogleFonts.sora(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'AI will extract all medicines automatically in seconds',
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
    return Container(
      width: double.infinity,
      color: const Color(0xFFF7FBFC),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildEmptyState(context),
            const SizedBox(height: 20),
            _buildAiInfoBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 37),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4EEF2), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1F2D).withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFF7FBFC),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Center(
              child: Icon(
                Icons.description_outlined,
                size: 32,
                color: Color(0xFF7A96A4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No Prescriptions Yet',
            style: GoogleFonts.sora(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A2B35),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Upload your first prescription to get started',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF7A96A4),
            ),
          ),
          const SizedBox(height: 16),
          _buildUploadButton(context),
        ],
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return Container(
      width: 202,
      height: 47,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.8, -0.8),
          end: Alignment(0.8, 0.8),
          colors: [AppColors.accentTealDark, AppColors.primaryTeal],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentTealDark.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => showPickOptions(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          'Upload Prescription',
          style: GoogleFonts.sora(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAiInfoBox() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFC),
        borderRadius: BorderRadius.circular(14),
        border: const Border(
          left: BorderSide(color: AppColors.accentTealDark, width: 2.7),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🤖 AI Powered Extraction',
              style: GoogleFonts.sora(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTeal,
              ),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('Ensure the prescription is well lit'),
            const SizedBox(height: 4),
            _buildBulletPoint('Avoid shadows and glare'),
            const SizedBox(height: 4),
            _buildBulletPoint('Keep the image in focus'),
            const SizedBox(height: 4),
            _buildBulletPoint('Include the complete document'),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•  ',
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppColors.primaryTeal,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryTeal,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
