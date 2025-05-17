import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary theme color
  static const Color primaryColor = Color(0xFF0077B5); // LinkedIn blue
  static const Color secondaryColor = Color(0xFF00A0DC);
  static const Color accentColor = Color(0xFF0073B1);

  // Light theme colors
  static const Color lightBackgroundColor = Color(0xFFF3F2EF);
  static const Color lightSurfaceColor = Colors.white;
  static const Color lightTextColor = Color(0xFF1D1D1D);

  // Dark theme colors
  static const Color darkBackgroundColor = Color(0xFF1D2226);
  static const Color darkSurfaceColor = Color(0xFF283339);
  static const Color darkTextColor = Color(0xFFE7E9EA);

  // Button style
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  // Light theme
  static ThemeData get lightTheme {
    final FlexColorScheme colorScheme = FlexColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      background: lightBackgroundColor,
      surface: lightSurfaceColor,
      appBarBackground: primaryColor,
    );

    return colorScheme.toTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  // Dark theme
  static ThemeData get darkTheme {
    final FlexColorScheme colorScheme = FlexColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      background: darkBackgroundColor,
      surface: darkSurfaceColor,
      appBarBackground: darkSurfaceColor,
    );

    return colorScheme.toTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
