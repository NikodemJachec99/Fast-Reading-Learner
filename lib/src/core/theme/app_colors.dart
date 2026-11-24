import 'package:flutter/material.dart';

/// Design tokens according to the presentation specification (Slide 13).
abstract final class AppColors {
  /// Paper background (#F7F5EE)
  static const Color paper = Color(0xFFF7F5EE);

  /// Ink primary text and dark accents (#163B34)
  static const Color ink = Color(0xFF163B34);

  /// Secondary ink for subtitles and captions (#5A726D)
  static const Color inkSecondary = Color(0xFF5A726D);

  /// Brand green for primary actions, passed tests, and active tabs (#16846C)
  static const Color green = Color(0xFF16846C);

  /// Soft green container for badges and trends (#E6F4EA)
  static const Color greenLight = Color(0xFFE6F4EA);

  /// Memory exercise category accent (#EDE8FA)
  static const Color memory = Color(0xFFEDE8FA);

  /// Comprehension exercise category accent (#FCECE6)
  static const Color comprehension = Color(0xFFFCECE6);

  /// White surface for cards (#FFFFFF)
  static const Color card = Color(0xFFFFFFFF);

  /// Subtle border color for cards and dividers (#E5E2D9)
  static const Color border = Color(0xFFE5E2D9);

  /// Muted amber for below-threshold (failed < 2/3) tests (#C27803)
  static const Color mutedAmber = Color(0xFFC27803);

  /// Soft amber container for below-threshold badges (#FEF3C7)
  static const Color mutedAmberLight = Color(0xFFFEF3C7);
}
