import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Color(0xFF2E241E);
  static const Color white = Color(0xFFFFFEFC);
  static const Color blue = Color(0xFFFF6B2C);
  static const Color red = Color(0xFFFF8248);
  static const Color gray = Color(0xFFA98A72);
  static const Color green = Color(0xFFFFD7B8);
  static const Color surface = Color(0xFFFFF7F0);
  static const Color surfaceSoft = Color(0xFFFFF0E2);
  static const Color border = Color(0xFFF3D6BE);
  static const Color success = Color(0xFF2E9D62);
  static const Color warning = Color(0xFFF2A93B);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF7B36),
      Color(0xFFFFD56A),
    ],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B2C),
      Color(0xFFFFB347),
    ],
  );
}
