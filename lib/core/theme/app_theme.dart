import 'package:flutter/material.dart';

/// Dark car-navigation-inspired theme optimized for high-contrast glanceability.
class AppTheme {
  const AppTheme._();

  static const Color bgDark = Color(0xFF0B0F17);
  static const Color surfaceDark = Color(0xFF131B29);
  static const Color surfaceElevated = Color(0xFF1B263B);
  static const Color borderSubtle = Color(0xFF283548);

  static const Color accentCyan = Color(0xFF38BDF8);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentCrimson = Color(0xFFEF4444);
  static const Color accentEmerald = Color(0xFF10B981);
  static const Color accentPurple = Color(0xFFA855F7);

  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: accentCyan,
      secondary: accentAmber,
      error: accentCrimson,
      surface: surfaceDark,
      onPrimary: Color(0xFF06131F),
      onSecondary: Color(0xFF1A1100),
      onSurface: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: bgDark,
      cardColor: surfaceDark,
      dividerColor: borderSubtle,
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderSubtle),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentCyan, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentCyan,
          foregroundColor: const Color(0xFF06131F),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceDark,
        indicatorColor: accentCyan.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? accentCyan : textSecondary,
          );
        }),
      ),
    );
  }
}
