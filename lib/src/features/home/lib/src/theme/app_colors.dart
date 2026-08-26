import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryTeal = Color(0xFF0AB5A8);
  static const Color accentTealDark = Color(0xFF055F58);
  static const Color accentTeal = Color(0xFF94EDE7);
  static const Color white = Color(0xFFFFFFFF);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D1F2D), Color(0xFF055F58)],
  );
}
