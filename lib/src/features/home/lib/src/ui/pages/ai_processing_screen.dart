import 'dart:async';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class AiProcessingScreen extends StatefulWidget {
  const AiProcessingScreen({super.key});

  @override
  State<AiProcessingScreen> createState() => _AiProcessingScreenState();
}

class _AiProcessingScreenState extends State<AiProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  int _currentStep = 0;
  final List<String> _steps = [
    'Scanning prescription...',
    'Identifying medicines...',
    'Reading dosage & frequency',
    'Preparing your reminders...',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.3, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.addListener(() {
      final progress = _animationController.value;
      final newStep = (progress * _steps.length).floor().clamp(
        0,
        _steps.length - 1,
      );
      if (newStep != _currentStep) {
        setState(() => _currentStep = newStep);
      }
    });

    _animationController.forward();

    Timer(const Duration(seconds: 8), () {
      if (mounted) {
        CcRouteHelper.pushReplacement(CcRouteConstants.extractedMedicines);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
              const SizedBox(height: 16),
              Text(
                'AI Processing',
                style: GoogleFonts.sora(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A2B35),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Analysing your prescription…',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7A96A4),
                ),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Column(
          children: [
            _buildAnimatedIcon(),
            const SizedBox(height: 24),
            _buildStatusText(),
            const SizedBox(height: 24),
            _buildProgressBar(),
            const SizedBox(height: 24),
            _buildDisclaimer(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return SizedBox(
          width: 110,
          height: 110,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accentTealDark.withValues(
                      alpha: _pulseAnimation.value * 0.3,
                    ),
                    width: 2.5,
                  ),
                ),
              ),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(-0.7, -0.7),
                    end: Alignment(0.7, 0.7),
                    colors: [AppColors.accentTealDark, AppColors.primaryTeal],
                  ),
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentTealDark.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: AppColors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusText() {
    return Column(
      children: [
        Text(
          _steps[_currentStep],
          style: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A2B35),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Please wait, this only takes a moment',
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF7A96A4),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Container(
          width: 297,
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFFE4EEF2),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 297 * _progressAnimation.value,
              height: 6,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accentTealDark, AppColors.accentTeal],
                ),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      width: 297,
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6FAF9), width: 0.7),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryTeal,
              height: 1.6,
            ),
            children: [
              TextSpan(
                text: 'Disclaimer: ',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTeal,
                ),
              ),
              const TextSpan(
                text:
                    'AI Extraction can be sometimes wrong please check the tablets and set reminders thouroughly.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
