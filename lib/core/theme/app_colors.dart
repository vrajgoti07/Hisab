import 'package:flutter/material.dart';

/// Centralized semantic color tokens for Hisab
class AppColors {
  // Brand Colors - Deep Emerald & Teal
  static const Color emerald = Color(0xFF047857); // Deep Emerald
  static const Color emeraldDark = Color(0xFF064E3B);
  static const Color emeraldLight = Color(0xFF10B981);
  static const Color teal = Color(0xFF0D9488); // Modern Teal
  static const Color tealLight = Color(0xFF2DD4BF);
  static const Color tealDark = Color(0xFF115E59);

  // Primary brand alias
  static const Color primary = emerald;
  static const Color secondary = teal;
  static const Color accent = Color(0xFF0284C7);

  // Surfaces & Backgrounds - Light
  static const Color bgLight = Color(0xFFF8F9FA); // Warm off-white
  static const Color surfaceLight = Colors.white;
  static const Color cardLight = Colors.white;
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color dividerLight = Color(0xFFEDF2F7);

  // Surfaces & Backgrounds - Dark
  static const Color bgDark = Color(0xFF0B131E); // Deep midnight slate
  static const Color surfaceDark = Color(0xFF16202E);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color borderDark = Color(0xFF2E3E52);
  static const Color dividerDark = Color(0xFF1E293B);

  // Financial Status Colors
  static const Color safeGreen = Color(
    0xFF059669,
  ); // Under budget, receivable, settled
  static const Color warningAmber = Color(0xFFD97706); // Near budget limit
  static const Color dangerRed = Color(0xFFDC2626); // Over budget, payable
  static const Color infoBlue = Color(0xFF2563EB); // General informative
  static const Color neutralSlate = Color(0xFF64748B);

  // Typography Colors
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textMutedLight = Color(0xFF94A3B8);

  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textMutedDark = Color(0xFF64748B);

  // Gradients
  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [Color(0xFF065F46), Color(0xFF0D9488)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardHeaderGradient = LinearGradient(
    colors: [Color(0xFF047857), Color(0xFF0F766E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
