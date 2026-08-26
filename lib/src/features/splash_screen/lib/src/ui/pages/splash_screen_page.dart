import 'package:core/core.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.fromLTRB(28, 48, 28, 40),
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
            const SizedBox(height: 36),
            const Row(
              children: [
                Expanded(
                  child: _StatCard(value: '78Cr+', label: 'ABHA IDs'),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatCard(value: '₹0', label: 'Always Free'),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatCard(value: '3 AI', label: 'Agents'),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      CcRouteHelper.push(CcRouteConstants.loginScreen);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: CcColors.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Get Started — It's Free",
                      style: CCTextStyle.buttonLarge.style.copyWith(
                        color: CcColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: BorderSide(color: CcColors.white25, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'I already have an account',
                      style: CCTextStyle.bodyLarge.style.copyWith(
                        color: CcColors.white80,
                      ),
                    ),
                  ),
                ),
              ],
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

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: CcColors.primary12,
        border: Border.all(color: CcColors.primary25),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: CCTextStyle.headingMedium.style.copyWith(
              color: CcColors.accent,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: CCTextStyle.captionSmall.style.copyWith(
              color: CcColors.white50,
            ),
          ),
        ],
      ),
    );
  }
}
