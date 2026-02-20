import 'package:flutter/material.dart';

class AppColors {
  // 🎨 Primary Colors
  static const Color primaryPurple = Color(0xFF4B1D6A);
  static const Color secondaryPurple = Color(0xFF6B2F8A);
  static const Color goldAccent = Color(0xFFF4C430);

  // Backward Compatibility Aliases (Do not remove without refactoring all files)
  static const Color primary = goldAccent;
  static const Color secondary = secondaryPurple;

  // 🌙 Dark Mode Palette
  static const Color darkBackground = Color(
    0xFF0E0B1F,
  ); // Unified dark background
  static const Color darkCard = Color(0xFF1F122B);
  static const Color darkSection = Color(0xFF2A1838);
  static const Color darkTextPrimary = Color(0xFFF3E8FF);
  static const Color darkTextSecondary = Color(0xFFCDBBE5);
  static const Color darkBorder = Color(0xFF3A2450);

  // 🔮 Onboarding / Premium Colors
  static const Color onboardingPurple = Color(0xFF1A1033);
  static const Color onboardingDarkPurple = Color(0xFF0E0B1F);
  static const Color onboardingBlack = Color(0xFF05040A);
  static const Color onboardingRadialCenter = Color(0xFF2E0F45);

  // 🌞 Light Mode Palette
  static const Color lightBackground = Color(0xFFF8F5FB);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightSection = Color(0xFFEFE6F5);
  static const Color lightTextPrimary = Color(0xFF2B123F);
  static const Color lightTextSecondary = Color(0xFF6B5A75);
  static const Color lightBorder = Color(0xFFE2D8EC);

  // 🌌 Gradients
  static const List<Color> primaryGradient = [
    Color(0xFF4B1D6A),
    Color(0xFF6B2F8A),
    Color(0xFFF4C430),
  ];

  static const List<Color> darkGradient = [
    onboardingPurple,
    onboardingDarkPurple,
    onboardingBlack,
  ];

  static const List<Color> goldGradient = [
    Color(0xFFF4C430),
    Color(0xFFB8860B),
  ];

  static const List<Color> radialDarkGradient = [
    onboardingRadialCenter,
    onboardingDarkPurple,
    onboardingBlack,
  ];
}
