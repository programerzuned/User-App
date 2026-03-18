import 'package:flutter/material.dart';

class AppColors {

  // ================= LIGHT THEME =================
  static const Color primaryColor = Color(0xFF2563EB); // Rich Blue (better than 3B82F6)
  static const Color secondaryColor = Color(0xFF06B6D4); // Cyan
  static const Color accentColor = Color(0xFFF59E0B); // Softer Amber

  static const Color backgroundColor = Color(0xFFF1F5F9); // Slightly softer bg
  static const Color scaffoldBackgroundColor = Color(0xFFF1F5F9);
  static const Color cardColor = Color(0xFFFFFFFF);

  static const Color textColorPrimary = Color(0xFF0F172A); // Deep Dark
  static const Color textColorSecondary = Color(0xFF475569); // Better readability
  static const Color textColorHint = Color(0xFF94A3B8);

  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color dividerColor = Color(0xFFE2E8F0);

  // ================= DARK THEME =================
  static const Color darkPrimaryColor = Color(0xFF6366F1);// Lighter Blue (important for dark)
  static const Color darkSecondaryColor = Color(0xFF22D3EE); // Bright Cyan
  static const Color darkAccentColor = Color(0xFFFBBF24); // Softer Amber Glow

  static const Color darkBackgroundColor = Color(0xFF020617); // TRUE DARK (premium feel)
  static const Color darkScaffoldBackgroundColor = Color(0xFF020617);
  static const Color darkCardColor = Color(0xFF0F172A); // Elevated surface

  static const Color darkTextColorPrimary = Color(0xFFF8FAFC); // Pure readable white
  static const Color darkTextColorSecondary = Color(0xFFCBD5F5);
  static const Color darkTextColorHint = Color(0xFF64748B);

  static const Color darkBorderColor = Color(0xFF1E293B);
  static const Color darkDividerColor = Color(0xFF1E293B);

  // ================= STATUS COLORS =================
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF22C55E);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);
}