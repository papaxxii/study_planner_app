import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized color palette for the app.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF4B39EF); // indigo-purple
  static const Color primaryContainer = Color(0xFFF3E5F5);
  static const Color secondary = Color(0xFF7C4DFF); // purple accent
  static const Color background = Color(0xFFF7F9FC);
  static const Color surface = Colors.white;
  static const Color onPrimary = Colors.white;
  static const Color onBackground = Color(0xFF0B1020);
  static const Color disabled = Color(0xFF9AA4B2);
  static const Color error = Color(0xFFB00020);
}

/// Builds a TextTheme using two Google fonts:
/// - Poppins for headings / display
/// - Inter for body text and small labels
TextTheme _buildAppTextTheme(TextTheme base) {
  return base.copyWith(
    displayLarge: GoogleFonts.poppins(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      height: 1.1,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      height: 1.1,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      height: 1.08,
    ),
    headlineLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600),
    titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
    titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.3,
    ),
    labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
    labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
  );
}

final ColorScheme _lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  primaryContainer: AppColors.primaryContainer,
  secondary: AppColors.secondary,
  onSecondary: Colors.white,
  error: AppColors.error,
  onError: Colors.white,
  surface: AppColors.surface,
  onSurface: AppColors.onBackground,
);

final ColorScheme _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF7C4DFF),
  onPrimary: Colors.black,
  primaryContainer: Color(0xFF4A2F68),
  secondary: Color(0xFFCE93D8),
  onSecondary: Colors.black,
  error: AppColors.error,
  onError: Colors.white,
  surface: Color(0xFF111319),
  onSurface: Colors.white,
);

/// AppTheme exposes themed ThemeData instances for light and dark modes.
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ThemeData.light();
    final textTheme = _buildAppTextTheme(base.textTheme);
    final theme = ThemeData.from(
      colorScheme: _lightColorScheme,
      textTheme: textTheme,
    );

    return theme.copyWith(
      colorScheme: _lightColorScheme,
      scaffoldBackgroundColor: _lightColorScheme.surface,
      textTheme: textTheme,
      primaryTextTheme: _buildAppTextTheme(base.primaryTextTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: _lightColorScheme.primary,
        foregroundColor: _lightColorScheme.onPrimary,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: _lightColorScheme.onPrimary,
        ),
        toolbarTextStyle: textTheme.titleMedium?.copyWith(
          color: _lightColorScheme.onPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightColorScheme.primary,
          foregroundColor: _lightColorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightColorScheme.primary,
          side: BorderSide(color: _lightColorScheme.primary, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _lightColorScheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
        labelStyle: GoogleFonts.inter(color: AppColors.onBackground),
        hintStyle: GoogleFonts.inter(color: AppColors.disabled),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _lightColorScheme.onPrimary,
        contentTextStyle: GoogleFonts.inter(color: _lightColorScheme.primary),
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark();
    final textTheme = _buildAppTextTheme(base.textTheme);
    final theme = ThemeData.from(
      colorScheme: _darkColorScheme,
      textTheme: textTheme,
    );

    return theme.copyWith(
      colorScheme: _darkColorScheme,
      scaffoldBackgroundColor: _darkColorScheme.surface,
      textTheme: textTheme,
      primaryTextTheme: _buildAppTextTheme(base.primaryTextTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: _darkColorScheme.surface,
        foregroundColor: _darkColorScheme.onSurface,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: _darkColorScheme.onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkColorScheme.primary,
          foregroundColor: _darkColorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF111319),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _darkColorScheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
        labelStyle: GoogleFonts.inter(color: Colors.white70),
        hintStyle: GoogleFonts.inter(color: Colors.white38),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF111319),
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}

/// Usage:
/// In `main.dart` set `theme: AppTheme.light()` and optionally `darkTheme: AppTheme.dark()`.
