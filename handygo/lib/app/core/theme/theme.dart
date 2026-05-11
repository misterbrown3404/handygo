import 'package:flutter/material.dart';
import 'package:handygo/app/core/constant/color.dart';

ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: AppColors.backgroundColor,
    primaryColor: AppColors.primaryColor,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      surface: AppColors.surfaceColor,
      error: AppColors.errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textColor,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: -0.25),
      displayMedium: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textColor),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textColor),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondaryColor),
      labelLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.25),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        side: const BorderSide(color: AppColors.primaryColor, width: 1.5),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(8),
    ),
  );
}