import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Centralized Lucide Icon constants and semantics for Hisab
class AppIcons {
  // Navigation
  static const IconData navDashboard = LucideIcons.layoutDashboard;
  static const IconData navExpenses = LucideIcons.receiptText;
  static const IconData navPeople = LucideIcons.users;
  static const IconData navReports = LucideIcons.chartColumnBig;
  static const IconData navSettings = LucideIcons.settings;

  // Actions
  static const IconData add = LucideIcons.plus;
  static const IconData edit = LucideIcons.pencil;
  static const IconData delete = LucideIcons.trash2;
  static const IconData share = LucideIcons.share2;
  static const IconData filter = LucideIcons.filter;
  static const IconData search = LucideIcons.search;
  static const IconData close = LucideIcons.x;
  static const IconData check = LucideIcons.check;
  static const IconData back = LucideIcons.arrowLeft;
  static const IconData forward = LucideIcons.arrowRight;
  static const IconData chevronLeft = LucideIcons.chevronLeft;
  static const IconData chevronRight = LucideIcons.chevronRight;
  static const IconData calendar = LucideIcons.calendar;

  // Financial & Split Semantics
  static const IconData wallet = LucideIcons.wallet;
  static const IconData moneySend =
      LucideIcons.arrowUpRight; // money going out / expense / I owe
  static const IconData moneyReceive =
      LucideIcons.arrowDownLeft; // money coming in / they owe me
  static const IconData settlement = LucideIcons.handCoins;
  static const IconData split = LucideIcons.split;
  static const IconData debtSummary = LucideIcons.arrowLeftRight;
  static const IconData budget = LucideIcons.calculator;
  static const IconData safeDaily = LucideIcons.shieldCheck;
  static const IconData trendingUp = LucideIcons.trendingUp;
  static const IconData trendingDown = LucideIcons.trendingDown;

  // Friends & Users
  static const IconData user = LucideIcons.user;
  static const IconData addUser = LucideIcons.userPlus;
  static const IconData phone = LucideIcons.phone;
  static const IconData message = LucideIcons.messageSquare;

  // Status & Feedback
  static const IconData success = LucideIcons.circleCheck;
  static const IconData warning = LucideIcons.triangleAlert;
  static const IconData error = LucideIcons.circleAlert;
  static const IconData info = LucideIcons.info;
  static const IconData sparkles = LucideIcons.sparkles;

  // Files & Export
  static const IconData pdf = LucideIcons.fileText;
  static const IconData excel = LucideIcons.fileSpreadsheet;
  static const IconData csv = LucideIcons.fileCode;

  // Appearance
  static const IconData themeLight = LucideIcons.sun;
  static const IconData themeDark = LucideIcons.moon;
  static const IconData refresh = LucideIcons.rotateCw;

  // Standard sizes
  static const double sizeSm = 16.0;
  static const double sizeMd = 20.0;
  static const double sizeLg = 24.0;
  static const double sizeXl = 32.0;
}
