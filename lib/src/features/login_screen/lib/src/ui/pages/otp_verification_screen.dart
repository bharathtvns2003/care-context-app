import 'dart:async';
import 'package:core/core.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../login_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _currentIndex = 0;
  int _resendSeconds = 38;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() {
          _resendSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _maskedPhone {
    final phone = widget.phoneNumber.replaceAll(' ', '');
    if (phone.length >= 5) {
      return '+91 ${phone.substring(0, 5)} ${phone.substring(5, phone.length - 2)}XX';
    }
    return '+91 $phone';
  }

  String get _otpValue {
    return _controllers.map((c) => c.text).join();
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
        setState(() {
          _currentIndex = index + 1;
        });
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  void _onKeyPressed(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
        setState(() {
          _currentIndex = index - 1;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginScreenBloc, LoginScreenState>(
      listenWhen: (previous, current) =>
          current is OtpVerifiedState ||
          current is OtpSentState ||
          current is LoginScreenErrorState,
      listener: (context, state) {
        if (state is OtpVerifiedState) {
          if (state.isNewUser) {
            CcRouteHelper.push(CcRouteConstants.completeProfile);
          } else {
            CcRouteHelper.pushAndPopUntil(CcRouteConstants.homeScreen);
          }
        } else if (state is OtpSentState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP resent successfully')),
          );
          setState(() {
            _resendSeconds = 38;
          });
          _timer?.cancel();
          _startResendTimer();
        } else if (state is LoginScreenErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
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
          colors: [CcColors.navy, CcColors.primaryDarker],
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
                'Verify your\nnumber',
                style: GoogleFonts.sora(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'OTP sent to $_maskedPhone',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: CcColors.white60,
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
      color: CcColors.background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOtpInput(),
            const SizedBox(height: 22),
            _buildResendText(),
            const SizedBox(height: 22),
            _buildVerifyButton(),
            const SizedBox(height: 22),
            _buildInfoBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ENTER 6-DIGIT OTP',
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: CcColors.textTertiary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: List.generate(6, (index) {
            final isFilled = _controllers[index].text.isNotEmpty;
            final isCurrent = index == _currentIndex;
            final isPast = index < _currentIndex || isFilled;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < 5 ? 9 : 0),
                child: KeyboardListener(
                  focusNode: FocusNode(),
                  onKeyEvent: (event) => _onKeyPressed(event, index),
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: isPast ? CcColors.surfaceSecondary : CcColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isCurrent || isPast
                            ? CcColors.primaryDarker
                            : CcColors.border,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: CcColors.shadowLight,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      onChanged: (value) => _onOtpChanged(value, index),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: GoogleFonts.sora(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: CcColors.primary,
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildResendText() {
    return Center(
      child: GestureDetector(
        onTap: _resendSeconds <= 0
            ? () {
                getIt<LoginScreenBloc>().add(
                      ResendOtpEvent(phoneNumber: widget.phoneNumber),
                    );
              }
            : null,
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: CcColors.textTertiary,
            ),
            children: [
              const TextSpan(text: "Didn't receive? "),
              TextSpan(
                text: _resendSeconds > 0
                    ? 'Resend in 0:${_resendSeconds.toString().padLeft(2, '0')}'
                    : 'Resend OTP',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _resendSeconds > 0
                      ? CcColors.textTertiary
                      : CcColors.primaryDarker,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return BlocBuilder<LoginScreenBloc, LoginScreenState>(
      builder: (context, state) {
        final isLoading = state is LoginScreenLoadingState;
        return Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment(-0.8, -0.8),
              end: Alignment(0.8, 0.8),
              colors: [CcColors.primaryDarker, CcColors.primary],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: CcColors.primaryDarker.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    final otp = _otpValue;
                    if (otp.length == 6) {
                      getIt<LoginScreenBloc>().add(
                            VerifyOtpEvent(
                              phoneNumber: widget.phoneNumber,
                              otp: otp,
                            ),
                          );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Verify & Continue',
                    style: GoogleFonts.sora(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildInfoBox() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: CcColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: CcColors.primaryDarker, width: 2.7),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
        child: Text(
          "Auto-reading SMS... If OTP is received via SMS it will be filled automatically.",
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: CcColors.primary,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
