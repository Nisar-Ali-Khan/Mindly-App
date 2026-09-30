import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.deepPlum,
        primary: AppColors.deepPlum,
        secondary: AppColors.lavender,
        tertiary: AppColors.sage,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _textTheme(Colors.black87),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.amber,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.publicSans(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const darkBackground = Color(0xFF1E162B);
    const darkSurface = Color(0xFF2A1F3B);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: AppColors.lavender,
        primary: AppColors.lavender,
        secondary: AppColors.sage,
        tertiary: AppColors.amber,
        surface: darkSurface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: darkBackground,
      textTheme: _textTheme(Colors.white.withValues(alpha: 0.9)),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.amber,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.publicSans(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  static TextTheme _textTheme(Color baseColor) {
    return TextTheme(
      displayLarge: GoogleFonts.fraunces(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: baseColor,
      ),
      displayMedium: GoogleFonts.fraunces(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: baseColor,
      ),
      displaySmall: GoogleFonts.fraunces(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: baseColor,
      ),
      titleLarge: GoogleFonts.fraunces(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      titleMedium: GoogleFonts.publicSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      bodyLarge: GoogleFonts.publicSans(
        fontSize: 16,
        color: baseColor,
      ),
      bodyMedium: GoogleFonts.publicSans(
        fontSize: 14,
        color: baseColor,
      ),
      labelLarge: GoogleFonts.ibmPlexMono(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: baseColor.withValues(alpha: 0.7),
      ),
    );
  }
}
