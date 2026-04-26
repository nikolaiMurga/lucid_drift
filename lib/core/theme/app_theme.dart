import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background   = Color(0xFF0E0B1A);
  static const surface      = Color(0xFF1A1628);
  static const surfaceHigh  = Color(0xFF241E38);
  static const border       = Color(0xFF2E2748);

  static const dream        = Color(0xFF7C5CBF);
  static const dreamLight   = Color(0xFFB8A0E8);
  static const teal         = Color(0xFF2EC4A0);
  static const warm         = Color(0xFFF5A06E);

  static const textPrimary   = Color(0xFFEEEAF8);
  static const textSecondary = Color(0xFF9B95B8);
  static const textTertiary  = Color(0xFF5C5578);

  // content type colors
  static const affirmation  = Color(0xFF7C5CBF);
  static const lucid        = Color(0xFF2EC4A0);
}

final appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: const ColorScheme.dark(
    primary:    AppColors.dream,
    secondary:  AppColors.teal,
    surface:    AppColors.surface,
    onPrimary:  AppColors.textPrimary,
    onSurface:  AppColors.textPrimary,
  ),
  cardTheme: CardThemeData(
    color: AppColors.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    elevation: 0,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
    centerTitle: false,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.surface,
    indicatorColor: AppColors.dream.withValues(alpha: 0.2),
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(fontSize: 11, color: AppColors.textSecondary),
    ),
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    titleLarge:     TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
    titleMedium:    TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
    bodyMedium:     TextStyle(fontSize: 14, color: AppColors.textSecondary),
    labelSmall:     TextStyle(fontSize: 11, color: AppColors.textTertiary),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceHigh,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.dream),
    ),
    labelStyle: const TextStyle(color: AppColors.textTertiary),
    hintStyle: const TextStyle(color: AppColors.textTertiary),
  ),
);
