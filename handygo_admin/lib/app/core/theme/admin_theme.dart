import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';

ThemeData adminTheme() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AdminColors.background,
    primaryColor: AdminColors.primary,
    cardColor: AdminColors.cardDark,
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: AdminColors.surface,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AdminColors.textPrimary),
      titleTextStyle: TextStyle(
        color: AdminColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AdminColors.primary,
      secondary: AdminColors.accent,
      surface: AdminColors.surface,
    ),
  );
}
