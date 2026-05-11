import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handygo_admin/app/core/constant/color.dart';

ThemeData adminTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: GoogleFonts.interTextTheme(), // Inter for a more professional feel
    primaryColor: AppColors.adminPrimary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.adminPrimary,
      secondary: AppColors.primaryColor,
      surface: AppColors.surfaceColor,
      error: AppColors.errorColor,
    ),
    scaffoldBackgroundColor: AppColors.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.adminPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );
}
