import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette inspired by 123.html
  static const Color darkBg = Color(0xFF0F172A); // --dark
  static const Color darkBg2 = Color(0xFF172033); // --dark2
  static const Color cardBg = Color(0xE00F172A);
  static const Color blueAccent = Color(0xFF2563EB); // --blue
  static const Color cyanAccent = Color(0xFF22D3EE); // --cyan
  static const Color greenAccent = Color(0xFF22C55E); // --green
  static const Color redAccent = Color(0xFFEF4444); // --red
  static const Color yellowAccent = Color(0xFFFACC15); // --yellow
  static const Color purpleAccent = Color(0xFF8B5CF6); // --purple
  static const Color mutedText = Color(0xFF94A3B8); // --muted

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF070B13),
      primaryColor: blueAccent,
      colorScheme: const ColorScheme.dark(
        primary: blueAccent,
        secondary: cyanAccent,
        surface: darkBg2,
        error: redAccent,
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.white10),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: blueAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cyanAccent, width: 2),
        ),
      ),
    );
  }

  static BoxDecoration mainScreenBackground() {
    return const BoxDecoration(
      gradient: RadialGradient(
        center: Alignment(0, -0.6),
        radius: 1.2,
        colors: [
          Color(0xFF243B67),
          Color(0xFF101827),
          Color(0xFF070B13),
        ],
        stops: [0.0, 0.45, 1.0],
      ),
    );
  }
}
