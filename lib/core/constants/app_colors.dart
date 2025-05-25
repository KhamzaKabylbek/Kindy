import 'package:flutter/material.dart';

class AppColors {
  // Main brand colors
  static const Color primary = Color(0xFF009867); // Figma green
  static const Color secondary = Color(0xFF5BA8A0); // Teal
  static const Color tertiary = Color(0xFFA9D8B8); // Light mint
  static const Color accent = Color(0xFFFFBE86); // Soft orange

  // Figma design colors
  static const Color figmaGreen = Color(0xFF009867); // Main green from Figma
  static const Color figmaInputBackground = Color(
    0xFFF5F5F5,
  ); // Input field background
  static const Color figmaTextSecondary = Color(
    0xFF84898D,
  ); // Secondary text color

  // Gradient colors
  static const List<Color> mainGradient = [
    Color(0xFFA9D8B8), // Light mint
    Color(0xFF5BA8A0), // Teal
    Color(0xFF69B578), // Soft green
  ];

  // Figma pastel gradient (from the background)
  static const List<Color> figmaPastelGradient = [
    Color(0xFFFFE1E1), // Light pink
    Color(0xFFE1F4FF), // Light blue
    Color(0xFFFFF8E1), // Light yellow
    Color(0xFFE8F5E8), // Light green
  ];

  // Text colors
  static const Color textPrimary = Color(0xFF333333); // Dark gray
  static const Color textSecondary = Colors.white;
  static const Color textTertiary = Color(0x99FFFFFF); // White with opacity 60%

  // Background colors
  static const Color backgroundPrimary = Colors.white;
  static const Color backgroundSecondary = Color(0xFFF7F9F7); // Very light mint

  // Other utility colors
  static const Color success = Color(0xFF009867); // Figma green
  static const Color error = Color(0xFFE57373); // Soft red
  static const Color warning = Color(0xFFFFBE86); // Same as accent
  static const Color info = Color(0xFF5BA8A0); // Same as secondary

  // Shadow color
  static Color shadowColor = Colors.black.withAlpha(20);
  static Color cardShadow = Colors.black.withAlpha(15);
}
