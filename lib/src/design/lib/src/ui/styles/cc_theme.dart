import 'package:design/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CCTheme {
  static ThemeData get darkTheme => ThemeData(
        cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
          primaryColor: CcColors.textPrimary,
        ),
        fontFamily: CCFonts.inter,
        scaffoldBackgroundColor: CcColors.background,
        canvasColor: CcColors.background,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: CcColors.background,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: CcColors.background,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          centerTitle: false,
        ),
        colorScheme: const ColorScheme.dark(
          surface: CcColors.background,
          primary: CcColors.background,
          secondary: CcColors.primary,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: CcColors.primary25,
          selectionHandleColor: CcColors.primary,
        ),
        dividerColor: CcColors.border,
      );

  /// New Dezerv theme
  static ThemeData get newDarkTheme => ThemeData(
        cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
          primaryColor: CcColors.textInverse,
        ),
        fontFamily: CCFonts.inter,
        scaffoldBackgroundColor: CcColors.primary,
        canvasColor: CcColors.primary,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: CcColors.primary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: CcColors.primary,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          centerTitle: false,
        ),
        colorScheme: const ColorScheme.dark(
          surface: CcColors.primary,
          primary: CcColors.primary,
          secondary: CcColors.textInverse,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: CcColors.white25,
          selectionHandleColor: CcColors.textInverse,
        ),
        dividerColor: CcColors.primaryDark,
      );
}
