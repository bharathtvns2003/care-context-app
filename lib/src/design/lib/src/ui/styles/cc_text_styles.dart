import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/utils.dart';
import 'cc_colors.dart';

const String soraFontFamily = 'Sora';
const String dmSansFontFamily = 'DM Sans';

class CCTextStyle {
  const CCTextStyle(this.style, {this.fontWeights});

  final TextStyle style;
  final List<String>? fontWeights;

  CCTextStyle copyWith({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    TextDecoration? textDecoration,
    double? letterSpacing,
    double? height,
  }) {
    return CCTextStyle(
      style.copyWith(
        fontSize: fontSize,
        color: color,
        fontWeight: resolveFontWeight(this, fontWeight),
        decoration: textDecoration,
        letterSpacing: letterSpacing,
        height: height,
      ),
      fontWeights: fontWeights,
    );
  }

  CCTextStyle withFontFamily(String fontFamily) {
    return CCTextStyle(
      GoogleFonts.getFont(fontFamily, textStyle: style),
      fontWeights: fontWeights,
    );
  }

  // DISPLAY

  static const CCTextStyle displayLarge = CCTextStyle(
    TextStyle(
      fontFamily: soraFontFamily,
      fontSize: 28,
      fontWeight: FontWeight.w800,
      color: CcColors.textPrimary,
      height: 1.2,
    ),
  );

  static const CCTextStyle displayMedium = CCTextStyle(
    TextStyle(
      fontFamily: soraFontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: CcColors.textPrimary,
      height: 1.2,
    ),
  );

  static const CCTextStyle displaySmall = CCTextStyle(
    TextStyle(
      fontFamily: soraFontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w800,
      color: CcColors.textPrimary,
      height: 1.2,
    ),
  );

  // HEADINGS

  static const CCTextStyle headingLarge = CCTextStyle(
    TextStyle(
      fontFamily: soraFontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w800,
      color: CcColors.textPrimary,
      height: 1.3,
    ),
  );

  static const CCTextStyle headingMedium = CCTextStyle(
    TextStyle(
      fontFamily: soraFontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: CcColors.textPrimary,
      height: 1.3,
    ),
  );

  static const CCTextStyle headingSmall = CCTextStyle(
    TextStyle(
      fontFamily: soraFontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: CcColors.textPrimary,
      height: 1.3,
    ),
  );

  // TITLES

  static const CCTextStyle titleLarge = CCTextStyle(
    TextStyle(
      fontFamily: soraFontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: CcColors.textPrimary,
    ),
  );

  static const CCTextStyle titleMedium = CCTextStyle(
    TextStyle(
      fontFamily: soraFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: CcColors.textPrimary,
    ),
  );

  static const CCTextStyle titleSmall = CCTextStyle(
    TextStyle(
      fontFamily: soraFontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: CcColors.textPrimary,
    ),
  );

  // BODY

  static const CCTextStyle bodyLarge = CCTextStyle(
    TextStyle(
      fontFamily: dmSansFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: CcColors.textSecondary,
      height: 1.5,
    ),
  );

  static const CCTextStyle bodyMedium = CCTextStyle(
    TextStyle(
      fontFamily: dmSansFontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: CcColors.textSecondary,
      height: 1.5,
    ),
  );

  static const CCTextStyle bodySmall = CCTextStyle(
    TextStyle(
      fontFamily: dmSansFontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: CcColors.textSecondary,
      height: 1.5,
    ),
  );

  // CAPTIONS

  static const CCTextStyle captionLarge = CCTextStyle(
    TextStyle(
      fontFamily: dmSansFontFamily,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: CcColors.textTertiary,
      height: 1.4,
    ),
  );

  static const CCTextStyle captionSmall = CCTextStyle(
    TextStyle(
      fontFamily: dmSansFontFamily,
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: CcColors.textTertiary,
      height: 1.4,
    ),
  );

  // BUTTONS

  static const CCTextStyle buttonLarge = CCTextStyle(
    TextStyle(
      fontFamily: soraFontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: CcColors.textInverse,
    ),
  );

  static const CCTextStyle buttonMedium = CCTextStyle(
    TextStyle(
      fontFamily: soraFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: CcColors.textInverse,
    ),
  );

  static const CCTextStyle buttonSmall = CCTextStyle(
    TextStyle(
      fontFamily: soraFontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: CcColors.textInverse,
    ),
  );

  // LABELS

  static const CCTextStyle label = CCTextStyle(
    TextStyle(
      fontFamily: soraFontFamily,
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: CcColors.textTertiary,
      letterSpacing: 0.5,
    ),
  );

  static const CCTextStyle overline = CCTextStyle(
    TextStyle(
      fontFamily: soraFontFamily,
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: CcColors.textTertiary,
      letterSpacing: 1,
    ),
  );
}

extension TextStyleToCCTextStyle on TextStyle {
  CCTextStyle toCCTextStyle() {
    return CCTextStyle(
      TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        height: height,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
