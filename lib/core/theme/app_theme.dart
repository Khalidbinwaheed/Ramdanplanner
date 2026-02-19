import 'package:flutter/material.dart';

class AppColors {
  // Light Theme (Warm Beige)
  static const Color primaryLight = Color(0xFF8D6E63); // Brown 400
  static const Color secondaryLight = Color(0xFFD7CCC8); // Brown 100
  static const Color backgroundLight = Color(0xFFF5F5DC); // Beige
  static const Color surfaceLight = Colors.white;
  static const Color accentLight = Color(0xFF4CAF50); // green for progress

  // Dark Theme (Midnight Blue & Brown)
  static const Color primaryDark = Color(0xFFA1887F); // Brown 300
  static const Color secondaryDark = Color(0xFF151A2C); // Dark Card Background
  static const Color backgroundDark = Color(
    0xFF0B1221,
  ); // Dark Scaffold Background
  static const Color surfaceDark = Color(0xFF151A2C); // Dark Card Surface
  static const Color accentDark = Color(0xFFA1887F);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryLight,
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        surface: AppColors.backgroundLight,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryDark,
        primary: AppColors.primaryDark,
        secondary: AppColors.secondaryDark,
        surface: AppColors.backgroundDark,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      primaryColor: AppColors.primaryDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      // Ensure icons and inputs use the primary color
      iconTheme: const IconThemeData(color: AppColors.primaryDark),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryDark),
        ),
      ),
    );
  }
}
