import 'package:flutter/material.dart';

abstract final class HorotecaTheme {
  static const _ink = Color(0xFF13231E);
  static const _bronze = Color(0xFFA7793D);
  static const _paper = Color(0xFFF5F1E8);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: _ink,
      primary: _ink,
      secondary: _bronze,
      surface: _paper,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: _paper,
      appBarTheme: const AppBarTheme(
        backgroundColor: _paper,
        foregroundColor: _ink,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.72),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white.withValues(alpha: 0.78),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
