import 'package:flutter/material.dart';
import 'colors.dart';

/// Outstanding Dark Background Configurations
/// Vinu Bhaisahab's Premium App Theme 🚀
class AppBackgrounds {
  // Private constructor to prevent instantiation
  AppBackgrounds._();

  /// Primary Dark Background - Used throughout the app
  static const Color darkBackground = AppColors.primaryBlack;

  /// Dark Background Gradient - For special screens
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.primaryBlack,
      AppColors.primaryBlack,
    ],
  );

  /// Dark Background with Subtle Gradient - For cards and containers
  static const LinearGradient subtleDarkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A0A0A), // Slightly lighter black
      AppColors.primaryBlack,
      Color(0xFF050505), // Slightly darker black
    ],
  );

  /// Glass Morphism Dark Background - For overlays
  static BoxDecoration glassMorphismDark = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withValues(alpha: 0.05),
        Colors.white.withValues(alpha: 0.02),
        Colors.black.withValues(alpha: 0.1),
      ],
    ),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.1),
      width: 1,
    ),
    borderRadius: BorderRadius.circular(20),
  );

  /// Card Background - For product cards and containers
  static BoxDecoration cardBackground = BoxDecoration(
    color: AppColors.primaryBlack,
    borderRadius: BorderRadius.circular(15),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.05),
      width: 1,
    ),
  );

  /// Bottom Navigation Background
  static BoxDecoration bottomNavBackground = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.primaryBlack.withValues(alpha: 0.95),
        AppColors.primaryBlack,
      ],
    ),
    border: Border(
      top: BorderSide(
        color: Colors.white.withValues(alpha: 0.1),
        width: 0.5,
      ),
    ),
  );

  /// Search Bar Background
  static BoxDecoration searchBarBackground = BoxDecoration(
    color: Colors.white.withValues(alpha: 0.05),
    borderRadius: BorderRadius.circular(25),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.1),
      width: 1,
    ),
  );

  /// Button Background - Primary
  static BoxDecoration primaryButtonBackground = BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: AppColors.gradientStart.withValues(alpha: 0.3),
        blurRadius: 15,
        offset: const Offset(0, 5),
      ),
    ],
  );

  /// Button Background - Secondary
  static BoxDecoration secondaryButtonBackground = BoxDecoration(
    color: Colors.white.withValues(alpha: 0.05),
    borderRadius: BorderRadius.circular(15),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.2),
      width: 1,
    ),
  );

  /// Modal Background - For dialogs and bottom sheets
  static BoxDecoration modalBackground = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.primaryBlack.withValues(alpha: 0.95),
        AppColors.primaryBlack,
      ],
    ),
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(25),
      topRight: Radius.circular(25),
    ),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.1),
      width: 1,
    ),
  );

  /// Scaffold Background Decoration
  static BoxDecoration scaffoldBackground = const BoxDecoration(
    color: AppColors.primaryBlack,
  );

  /// App Bar Background
  static BoxDecoration appBarBackground = BoxDecoration(
    color: AppColors.primaryBlack.withValues(alpha: 0.95),
    border: Border(
      bottom: BorderSide(
        color: Colors.white.withValues(alpha: 0.1),
        width: 0.5,
      ),
    ),
  );
}
