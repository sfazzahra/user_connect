import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryDark = Color(0xFF5B21B6);
  static const Color primarySoft = Color(0xFFF5F0FF);

  static const Color accent = Color(0xFFF59E0B);
  static const Color accentDark = Color(0xFFD97706);

  static const Color success = Color(0xFF16A34A);
  static const Color successSoft = Color(0xFFDCFCE7);
  static const Color danger = Color(0xFFE11D48);
  static const Color dangerSoft = Color(0xFFFFE4E6);
  static const Color warning = Color(0xFFF59E0B);

  static const Color background = Color(0xFFFAF9F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF27272A);
  static const Color textSecondary = Color(0xFF71717A);
  static const Color border = Color(0xFFE9E7E4);
  static const Color shimmerBase = Color(0xFFE9E7E4);
  static const Color shimmerHighlight = Color(0xFFF5F4F2);

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: textPrimary.withOpacity(0.05),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.danger,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          height: 1.4,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.primarySoft.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}