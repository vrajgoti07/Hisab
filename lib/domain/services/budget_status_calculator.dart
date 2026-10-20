import 'dart:math';

enum BudgetStatus {
  safe, // < 70% used
  nearLimit, // 70% - 90% used
  overLimit, // > 90% used
}

enum CategoryStatus {
  ok, // < 85% used
  nearLimit, // 85% - 99.9% used
  overLimit, // >= 100% used
}

class MonthBudgetSummary {
  final int budgetPaise;
  final int carriedAmountPaise;
  final int totalBudgetAvailablePaise;
  final int totalPersonalSpentPaise;
  final int remainingBalancePaise;
  final double percentageUsed; // 0.0 to 1.0+
  final int averageDailySpendPaise;
  final int safeDailySpendPaise;
  final int daysLeftInMonth;
  final int daysElapsedInMonth;
  final BudgetStatus status;

  const MonthBudgetSummary({
    required this.budgetPaise,
    required this.carriedAmountPaise,
    required this.totalBudgetAvailablePaise,
    required this.totalPersonalSpentPaise,
    required this.remainingBalancePaise,
    required this.percentageUsed,
    required this.averageDailySpendPaise,
    required this.safeDailySpendPaise,
    required this.daysLeftInMonth,
    required this.daysElapsedInMonth,
    required this.status,
  });
}

class CategoryBudgetSummary {
  final int categoryId;
  final String categoryName;
  final String emoji;
  final String colorHex;
  final int limitPaise;
  final int spentPaise;
  final int remainingPaise;
  final double percentageUsed;
  final CategoryStatus status;

  const CategoryBudgetSummary({
    required this.categoryId,
    required this.categoryName,
    required this.emoji,
    required this.colorHex,
    required this.limitPaise,
    required this.spentPaise,
    required this.remainingPaise,
    required this.percentageUsed,
    required this.status,
  });
}

class BudgetStatusCalculator {
  /// Computes the comprehensive monthly budget summary
  static MonthBudgetSummary computeMonthlySummary({
    required int budgetPaise,
    required int carriedAmountPaise,
    required int totalPersonalSpentPaise,
    required int daysInMonth,
    required int daysLeftInMonth,
    required int daysElapsedInMonth,
  }) {
    final totalAvailable = budgetPaise + carriedAmountPaise;
    final remaining = totalAvailable - totalPersonalSpentPaise;
    final pctUsed = totalAvailable > 0 ? (totalPersonalSpentPaise / totalAvailable) : 0.0;

    final safeDays = max(1, daysLeftInMonth);
    final elapsedDays = max(1, daysElapsedInMonth);

    final safeDailySpend = remaining > 0 ? (remaining ~/ safeDays) : 0;
    final avgDailySpend = totalPersonalSpentPaise ~/ elapsedDays;

    BudgetStatus status;
    if (pctUsed < 0.70) {
      status = BudgetStatus.safe;
    } else if (pctUsed <= 0.90) {
      status = BudgetStatus.nearLimit;
    } else {
      status = BudgetStatus.overLimit;
    }

    return MonthBudgetSummary(
      budgetPaise: budgetPaise,
      carriedAmountPaise: carriedAmountPaise,
      totalBudgetAvailablePaise: totalAvailable,
      totalPersonalSpentPaise: totalPersonalSpentPaise,
      remainingBalancePaise: remaining,
      percentageUsed: pctUsed,
      averageDailySpendPaise: avgDailySpend,
      safeDailySpendPaise: safeDailySpend,
      daysLeftInMonth: daysLeftInMonth,
      daysElapsedInMonth: daysElapsedInMonth,
      status: status,
    );
  }

  /// Computes category status
  static CategoryBudgetSummary computeCategorySummary({
    required int categoryId,
    required String categoryName,
    required String emoji,
    required String colorHex,
    required int limitPaise,
    required int spentPaise,
  }) {
    final remaining = limitPaise - spentPaise;
    final pct = limitPaise > 0 ? (spentPaise / limitPaise) : 0.0;

    CategoryStatus status;
    if (pct < 0.85) {
      status = CategoryStatus.ok;
    } else if (pct < 1.0) {
      status = CategoryStatus.nearLimit;
    } else {
      status = CategoryStatus.overLimit;
    }

    return CategoryBudgetSummary(
      categoryId: categoryId,
      categoryName: categoryName,
      emoji: emoji,
      colorHex: colorHex,
      limitPaise: limitPaise,
      spentPaise: spentPaise,
      remainingPaise: remaining,
      percentageUsed: pct,
      status: status,
    );
  }
}
