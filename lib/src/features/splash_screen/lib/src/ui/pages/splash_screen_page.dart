import 'dart:async';

import 'package:core/core.dart';
import 'package:design/design.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Keep the brand splash visible briefly while we restore session.
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final restored = await ApiService.tryRestoreSession();
    if (!mounted) return;

    if (restored) {
      CcRouteHelper.pushAndPopUntil(CcRouteConstants.homeScreen);
      return;
    }

    final firebaseRestored = await _tryRestoreFromFirebase();
    if (!mounted) return;

    if (firebaseRestored) {
      CcRouteHelper.pushAndPopUntil(CcRouteConstants.homeScreen);
      return;
    }

    CcRouteHelper.pushAndPopUntil(CcRouteConstants.phoneLogin);
  }

  Future<bool> _tryRestoreFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final firebaseToken = await user.getIdToken();
    final phone = user.phoneNumber;
    if (firebaseToken == null ||
        firebaseToken.isEmpty ||
        phone == null ||
        phone.isEmpty) {
      return false;
    }

    return ApiService.exchangeFirebaseSession(
      firebaseToken: firebaseToken,
      phoneNumber: phone,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [CcColors.navy, CcColors.navyLight, CcColors.primaryDarker],
            stops: [0, 0.4, 1],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Care',
                    style: CCTextStyle.displayLarge.style.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: 'Context',
                    style: CCTextStyle.displayLarge.style.copyWith(
                      color: CcColors.accent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your complete health companion.\nOne record. Every doctor. Always with you.',
              textAlign: TextAlign.center,
              style: CCTextStyle.bodySmall.style.copyWith(
                color: CcColors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: CcColors.white12,
        border: Border.all(color: CcColors.white20, width: 1.5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: CcColors.accent, width: 2.5),
            ),
          ),
          Positioned(
            child: Container(width: 2.5, height: 8, color: Colors.white),
          ),
          Positioned(
            top: 32,
            right: 29,
            child: Transform.rotate(
              angle: 0.5,
              child: Container(width: 8, height: 2.5, color: Colors.white),
            ),
          ),
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: CcColors.secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
