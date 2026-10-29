import 'package:flutter/material.dart';

/// Sakin, düşük kontrastlı koyu palet (göz yormaz).
class C {
  static const bg = Color(0xFF0E1419);
  static const card = Color(0xFF172029);
  static const accent = Color(0xFF6FB7A8);
  static const accent2 = Color(0xFF8E9DE0);
  static const text = Color(0xFFE4EAF0);
  static const muted = Color(0xFF8A98A6);
}

ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: C.bg,
      colorScheme: const ColorScheme.dark(primary: C.accent, secondary: C.accent2, surface: C.card),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: C.card,
        indicatorColor: C.accent.withOpacity(.2),
      ),
    );
