import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.purple,
      scaffoldBackgroundColor: AppColors.primaryBlack,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryBlack,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryText),
      ),

      // Premium Text Theme with Custom Poppins
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          color: AppColors.primaryText,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.poppins(
          color: AppColors.primaryText,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        displaySmall: GoogleFonts.poppins(
          color: AppColors.primaryText,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        headlineLarge: GoogleFonts.poppins(
          color: AppColors.primaryText,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.1,
        ),
        headlineMedium: GoogleFonts.poppins(
          color: AppColors.primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        headlineSmall: GoogleFonts.poppins(
          color: AppColors.primaryText,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: GoogleFonts.poppins(
          color: AppColors.primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.poppins(
          color: AppColors.primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: GoogleFonts.poppins(
          color: AppColors.secondaryText,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: AppColors.primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: AppColors.primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: GoogleFonts.poppins(
          color: AppColors.secondaryText,
          fontSize: 12,
          fontWeight: FontWeight.w300,
        ),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: AppColors.cardBackground,
        elevation: 8,
        shadowColor: Color(0x4D7E1FFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkBackground,
        selectedItemColor: AppColors.gradientMiddle,
        unselectedItemColor: AppColors.secondaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 20,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.gradientMiddle,
            width: 2,
          ),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.secondaryText,
          fontSize: 14,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gradientMiddle,
          foregroundColor: AppColors.primaryText,
          elevation: 8,
          shadowColor: AppColors.gradientMiddle.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: AppColors.primaryText, size: 24),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.surfaceColor,
        thickness: 1,
      ),
    );
  }
}
