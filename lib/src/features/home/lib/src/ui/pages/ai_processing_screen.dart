import 'dart:async';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home.dart';
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

  StreamSubscription<HomeState>? _blocSub;
  Timer? _pollTimer;
  String? _prescriptionId;
  DateTime? _pollStartedAt;
  bool _navigated = false;

  static const Duration _pollInterval = Duration(seconds: 5);
  static const Duration _pollTimeout = Duration(minutes: 2);

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
    _listenForUploadAndExtraction();

    // Handle case where upload already finished before this screen mounted.
    final current = getIt<HomeBloc>().state;
    if (current is PrescriptionUploadedState) {
      _prescriptionId = current.prescriptionId;
      _pollStartedAt = DateTime.now();
      _fetchMedicines();
    } else if (current is MedicinesLoadedState &&
        _prescriptionId != null &&
        current.prescriptionId == _prescriptionId &&
        current.medicines.isNotEmpty) {
      _goToExtractedMedicines();
    }
  }

  void _listenForUploadAndExtraction() {
    final bloc = getIt<HomeBloc>();
    _blocSub = bloc.stream.listen((state) {
      if (!mounted || _navigated) return;

      if (state is PrescriptionUploadedState) {
        _prescriptionId = state.prescriptionId;
        _pollStartedAt = DateTime.now();
        _fetchMedicines();
      } else if (state is MedicinesLoadedState) {
        // Only react to medicines matching the uploaded prescription
        if (_prescriptionId == null || state.prescriptionId != _prescriptionId) return;
        if (state.medicines.isNotEmpty) {
          _goToExtractedMedicines();
        } else if (_hasPollTimedOut) {
          _goToExtractedMedicines();
        } else {
          _scheduleNextPoll();
        }
      } else if (state is HomeErrorState) {
        _pollTimer?.cancel();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${state.message}')),
        );
        CcRouteHelper.pop();
      }
    });
  }

  void _fetchMedicines() {
    if (_prescriptionId == null || _prescriptionId!.isEmpty) return;
    getIt<HomeBloc>().add(GetMedicinesEvent(prescriptionId: _prescriptionId!));
  }

  void _scheduleNextPoll() {
    _pollTimer?.cancel();
    _pollTimer = Timer(_pollInterval, () {
      if (mounted && !_navigated) _fetchMedicines();
    });
  }

  bool get _hasPollTimedOut {
    if (_pollStartedAt == null) return false;
    return DateTime.now().difference(_pollStartedAt!) >= _pollTimeout;
  }

  void _goToExtractedMedicines() {
    if (_navigated || !mounted) return;
    _navigated = true;
    _pollTimer?.cancel();
    // Defer navigation so we never push during build/initState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      CcRouteHelper.pushReplacement(
        CcRouteConstants.extractedMedicines,
        args: _prescriptionId,
      );
    });
  }

  @override
  void dispose() {
    _blocSub?.cancel();
    _pollTimer?.cancel();
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
        // Hold at ~95% while still waiting for extraction results.
        final visualProgress = _navigated
            ? 1.0
            : (_progressAnimation.value * 0.95).clamp(0.0, 0.95);
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
              width: 297 * visualProgress,
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
