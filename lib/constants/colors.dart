import 'package:flutter/material.dart';

class AppColors {
  // Futuristic Gradient Colors - Vinu Bhaisahab's Premium Theme 🚀
  static const Color gradientStart = Color(
    0xFF228FEE,
  ); // Perfect Blue #228fee as requested by Vinu bhaisahab
  static const Color gradientMiddle = Color(0xFF7D30F5); // Cosmic Purple
  static const Color gradientEnd = Color(
    0xFFD91A72,
  ); // Darker Pink as requested

  // Premium Dark Theme Colors - JioHotstar inspired
  static const Color primaryBlack = Color(0xFF0A0E1A); // Rich dark blue-black
  static const Color darkBackground = Color(0xFF0F1419); // Deep background
  static const Color cardBackground = Color(0xFF1A1F2E); // Card background
  static const Color surfaceColor = Color(0xFF252A3A); // Surface elements

  // Premium Text Colors
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFFB8BCC8); // Softer secondary
  static const Color accentText = Color(0xFF00BCD4); // Cyan accent
  static const Color mutedText = Color(0xFF606060); // Muted Gray
  static const Color hintText = Color(0xFF404040); // Hint Gray

  // Extended Dark Theme Colors - Vinu Bhaisahab's Premium Palette 🚀
  static const Color darkSurface = Color(
    0xFF0F0F0F,
  ); // Slightly lighter than primary black
  static const Color darkCard = Color(0xFF1A1A1A); // Card background
  static const Color darkBorder = Color(0xFF2A2A2A); // Border color
  static const Color darkDivider = Color(0xFF1F1F1F); // Divider color

  // Status Colors for Dark Theme
  static const Color successDark = Color(0xFF4CAF50); // Success Green
  static const Color errorDark = Color(0xFFE53E3E); // Error Red
  static const Color warningDark = Color(0xFFFF9800); // Warning Orange
  static const Color infoDark = Color(0xFF2196F3); // Info Blue

  // Interactive Colors for Dark Theme
  static const Color buttonPrimary = gradientMiddle; // Primary button
  static const Color buttonSecondary = Color(0xFF2A2A2A); // Secondary button
  static const Color buttonDisabled = Color(0xFF1A1A1A); // Disabled button

  // Input Colors for Dark Theme
  static const Color inputBackground = Color(0xFF1A1A1A); // Input background
  static const Color inputBorder = Color(0xFF2A2A2A); // Input border
  static const Color inputFocused = gradientStart; // Focused input border

  // Premium Accent Colors
  static const Color premiumGold = Color(0xFFFFD700); // Gold accent
  static const Color premiumCyan = Color(0xFF00E5FF); // Bright cyan
  static const Color premiumIndigo = Color(0xFF3F51B5); // Premium indigo

  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 0.45, 1.0],
    colors: [gradientStart, gradientMiddle, gradientEnd],
  );

  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.45, 1.0],
    colors: [Color(0x332134FF), Color(0x339144FC), Color(0x33FF8CD5)],
  );

  // Button Gradients
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [gradientStart, gradientMiddle, gradientEnd],
  );

  // Border Gradients
  static const LinearGradient borderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientMiddle, gradientEnd],
  );
}

// Gradient Text Style Helper
class GradientTextStyle {
  static TextStyle getGradientStyle({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      foreground: Paint()
        ..shader = AppColors.primaryGradient.createShader(
          const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
        ),
    );
  }
}
