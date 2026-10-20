import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppConstants {
  static const String appName = 'Hisab';
  static const String appTagline = 'Smart Budgeting & Group Expense Hisab';

  // Currency
  static const String currencySymbol = '₹';
  static const String currencyCode = 'INR';

  // Semantic Colors mapped from AppColors
  static const Color primaryEmerald = AppColors.emerald;
  static const Color primaryTeal = AppColors.teal;
  static const Color primaryBlue = AppColors.emerald; // backward compatibility
  static const Color accentIndigo = AppColors.accent;
  static const Color backgroundLight = AppColors.bgLight;
  static const Color surfaceLight = AppColors.surfaceLight;
  static const Color borderLight = AppColors.borderLight;

  // Status Colors
  static const Color statusSafeGreen = AppColors.safeGreen;
  static const Color statusWarningOrange = AppColors.warningAmber;
  static const Color statusDangerRed = AppColors.dangerRed;

  // Default Categories Seed Data (paise values: 100 paise = 1 INR)
  static const List<DefaultCategoryData> defaultCategories = [
    DefaultCategoryData(
      name: 'Food & Dining',
      emoji: '🍔',
      colorHex: '#F97316',
      defaultLimitPaise: 700000, // ₹7,000
    ),
    DefaultCategoryData(
      name: 'Travel & Commute',
      emoji: '🚌',
      colorHex: '#0EA5E9',
      defaultLimitPaise: 350000, // ₹3,500
    ),
    DefaultCategoryData(
      name: 'Books & Study',
      emoji: '📚',
      colorHex: '#8B5CF6',
      defaultLimitPaise: 250000, // ₹2,500
    ),
    DefaultCategoryData(
      name: 'Shopping & Personal',
      emoji: '🛍️',
      colorHex: '#EC4899',
      defaultLimitPaise: 300000, // ₹3,000
    ),
    DefaultCategoryData(
      name: 'Mobile & Subscriptions',
      emoji: '📱',
      colorHex: '#06B6D4',
      defaultLimitPaise: 120000, // ₹1,200
    ),
    DefaultCategoryData(
      name: 'Entertainment & Outings',
      emoji: '🍿',
      colorHex: '#F59E0B',
      defaultLimitPaise: 250000, // ₹2,500
    ),
    DefaultCategoryData(
      name: 'Health & Medical',
      emoji: '💊',
      colorHex: '#10B981',
      defaultLimitPaise: 150000, // ₹1,500
    ),
    DefaultCategoryData(
      name: 'Savings & SIP',
      emoji: '💰',
      colorHex: '#14B8A6',
      defaultLimitPaise: 300000, // ₹3,000
    ),
    DefaultCategoryData(
      name: 'Miscellaneous & Other',
      emoji: '📦',
      colorHex: '#64748B',
      defaultLimitPaise: 80000, // ₹800
    ),
  ];

  // Default Payment Modes
  static const List<String> defaultPaymentModes = [
    'UPI / GPay / PhonePe',
    'Cash',
    'Debit Card',
    'Credit Card',
    'Net Banking',
  ];
}

class DefaultCategoryData {
  final String name;
  final String emoji;
  final String colorHex;
  final int defaultLimitPaise;

  const DefaultCategoryData({
    required this.name,
    required this.emoji,
    required this.colorHex,
    required this.defaultLimitPaise,
  });
}
