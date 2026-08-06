import 'package:flutter/material.dart';

abstract final class HorotecaTheme {
  static const navy = Color(0xFF071426);
  static const navySurface = Color(0xFF10233D);
  static const navySoft = Color(0xFF18314F);
  static const gold = Color(0xFFFFC533);
  static const goldSoft = Color(0xFFFFDD73);
  static const text = Color(0xFFF6F8FC);
  static const muted = Color(0xFF9EADC2);

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: gold,
      primary: gold,
      secondary: goldSoft,
      surface: navySurface,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: navy,
      appBarTheme: const AppBarTheme(
        backgroundColor: navySurface,
        foregroundColor: text,
        centerTitle: false,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: navySurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: navySoft),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: navySoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: gold),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: navySurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: gold.withValues(alpha: .28)),
        ),
      ),
    );
  }
}
