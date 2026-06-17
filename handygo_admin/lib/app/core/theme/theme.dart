import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handygo_admin/core/colors/admin_colors.dart';

ThemeData adminTheme() {
  final base = ThemeData.light(useMaterial3: true);

  return base.copyWith(
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
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: AdminColors.surface,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: AdminColors.textSecondary,
          size: 22,
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AdminColors.textPrimary,
        ),
      ));
}

ThemeData glassTheme() {
  return adminTheme().copyWith(
    scaffoldBackgroundColor:
        AdminColors.neutral50.withValues(alpha: 0.6),
  );
}
