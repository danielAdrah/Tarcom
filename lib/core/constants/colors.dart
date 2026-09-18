import 'package:flutter/material.dart';

/// Tarcom Design System - Color Palette
///
/// Primary brand colors are based on the Tarcom logo:
/// Blue  : #075AA2
/// Orange: #F7822A
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // Brand Colors
  // ---------------------------------------------------------------------------

  static const Color primary = Color(0xFF075AA2);
  static const Color secondary = Color(0xFFF7822A);

  // ---------------------------------------------------------------------------
  // Blue Palette
  // ---------------------------------------------------------------------------

  static const Color blue900 = Color(0xFF053B79);
  static const Color blue700 = Color(0xFF075AA2);
  static const Color blue500 = Color(0xFF0F76C5);
  static const Color blue100 = Color(0xFFDCEEFF);
  static const Color blue50 = Color(0xFFF1F8FF);

  // ---------------------------------------------------------------------------
  // Orange Palette
  // ---------------------------------------------------------------------------

  static const Color orange800 = Color(0xFFD65D0B);
  static const Color orange600 = Color(0xFFF7822A);
  static const Color orange400 = Color(0xFFFF9B4D);
  static const Color orange100 = Color(0xFFFFE5D2);
  static const Color orange50 = Color(0xFFFFF7F1);

  // ---------------------------------------------------------------------------
  // Neutral Colors
  // ---------------------------------------------------------------------------

  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xffe5f2fd);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F4F8);

  static const Color textPrimary = Color.fromARGB(255, 38, 117, 207);
  static const Color textSecondary = Color(0xFF667085);
  static const Color textDisabled = Color(0xFF98A2B3);

  static const Color border = Color(0xFFE4E7EC);
  static const Color divider = Color(0xFFEAECF0);

  static const Color black = Color(0xFF000000);

  // ---------------------------------------------------------------------------
  // Inventory / Product States
  // ---------------------------------------------------------------------------

  static const Color available = Color(0xFF16A34A);
  static const Color lowStock = Color(0xFFF59E0B);
  static const Color outOfStock = Color(0xFFDC2626);
  static const Color reserved = Color(0xFF7C3AED);
  static const Color discontinued = Color(0xFF667085);

  // ---------------------------------------------------------------------------
  // Semantic Colors
  // ---------------------------------------------------------------------------

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF0F76C5);
}
