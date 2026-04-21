import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  static const cream = Color(0xFFF8F1EA);
  static const cinnamon = Color(0xFFA84E2B);
  static const peach = Color(0xFFFFDC91);
  static const lavender = Color(0xFF8B80A3);
  static const purple = Color(0xFF413176);
  static const ink = Color(0xFF382E2A);
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.cinnamon,
      surface: Colors.white,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.cream,
    textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.cinnamon,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.cream,
      foregroundColor: AppColors.ink,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
  );
}
