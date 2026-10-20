import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'PocketPlan';
  static const String appTagline = 'Smart Budgeting & Friends Hisab';

  // Currency
  static const String currencySymbol = '₹';
  static const String currencyCode = 'INR';

  // Semantic Colors
  static const Color primaryBlue = Color(0xFF1A365D); // Deep Slate Blue
  static const Color primaryTeal = Color(0xFF0D9488); // Modern Teal
  static const Color accentIndigo = Color(0xFF4F46E5);
  static const Color backgroundLight = Color(0xFFF6F7FB);
  static const Color surfaceLight = Colors.white;
  static const Color borderLight = Color(0xFFE2E8F0);

  // Status Colors
  static const Color statusSafeGreen = Color(0xFF10B981);
  static const Color statusWarningOrange = Color(0xFFF59E0B);
  static const Color statusDangerRed = Color(0xFFEF4444);

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
