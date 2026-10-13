import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFF3FAF7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFE4F3EC);
  static const Color border = Color(0xFFD1E8DC);
  static const Color primary = Color(0xFF0D9488);
  static const Color primaryDark = Color(0xFF0F766E);
  static const Color accent = Color(0xFFF59E0B);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);
  static const Color textPrimary = Color(0xFF0B1F1A);
  static const Color textSecondary = Color(0xFF5B7A70);
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Color red = primary;
  static const Color redDark = primaryDark;
}