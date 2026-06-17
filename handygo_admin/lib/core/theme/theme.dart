import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handygo_admin/core/colors/admin_colors.dart';

ThemeData adminTheme() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AdminColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AdminColors.primary,
      brightness: Brightness.light,
      primary: AdminColors.primary,
      onPrimary: AdminColors.surface,
      secondary: AdminColors.accent,
      onSecondary: AdminColors.surface,
      error: AdminColors.error,
      onError: AdminColors.surface,
      surface: AdminColors.surface,
      onSurface: AdminColors.textPrimary,
    ),
    textTheme: _buildTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: AdminColors.surface,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AdminColors.textPrimary,
      ),
      iconTheme: IconThemeData(
        color: AdminColors.textSecondary,
        size: 22,
      ),
    ),
    cardTheme: CardThemeData(
      color: AdminColors.surface,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AdminColors.neutral50,
      hintStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: AdminColors.neutral400,
      ),
      labelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: AdminColors.neutral600,
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: AdminColors.borderDark),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AdminColors.borderDark),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AdminColors.primary, width: 2),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AdminColors.danger),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    ),
    dataTableTheme: const DataTableThemeData(
      headingRowColor: WidgetStatePropertyAll(AdminColors.neutral100),
      headingTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AdminColors.textSecondary,
        letterSpacing: 0.5,
      ),
      dataTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        color: AdminColors.textPrimary,
      ),
      horizontalMargin: 24,
      columnSpacing: 28,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AdminColors.primary,
        foregroundColor: AdminColors.surface,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: AdminColors.textSecondary,
      size: 22,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AdminColors.surface,
      selectedItemColor: AdminColors.primary,
      unselectedItemColor: AdminColors.textSecondary,
      type: BottomNavigationBarType.fixed,
    ),
  );
}

TextTheme _buildTextTheme() {
  final base = GoogleFonts.interTextTheme();
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      color: AdminColors.textPrimary,
    ),
    headlineLarge: base.headlineLarge?.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AdminColors.textPrimary,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AdminColors.textPrimary,
    ),
    bodyLarge: base.bodyLarge?.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AdminColors.textPrimary,
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AdminColors.textPrimary,
    ),
    labelMedium: base.labelMedium?.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AdminColors.textPrimary,
    ),
  ).apply(
    bodyColor: AdminColors.textPrimary,
    displayColor: AdminColors.textPrimary,
  );
}

/// Glass theme helper (kept for backward compatibility).
ThemeData glassTheme() {
  return adminTheme().copyWith(
    scaffoldBackgroundColor: AdminColors.neutral50.withValues(alpha: 0.6),
    cardTheme: CardThemeData(
      color: AdminColors.surface,
      elevation: 0,
      shadowColor: Colors.transparent,
    ),
  );
}
