import 'package:flutter_test/flutter_test.dart';
import 'package:pocketplan/domain/services/budget_status_calculator.dart';

void main() {
  group('BudgetStatusCalculator Tests', () {
    test('Calculates safe daily spend and remaining budget accurately', () {
      // Monthly Budget ₹25,000, 0 carry forward, Spent ₹5,000, 20 days left in month
      final summary = BudgetStatusCalculator.computeMonthlySummary(
        budgetPaise: 2500000,
        carriedAmountPaise: 0,
        totalPersonalSpentPaise: 500000,
        daysInMonth: 30,
        daysLeftInMonth: 20,
        daysElapsedInMonth: 10,
      );

      expect(summary.totalBudgetAvailablePaise, 2500000);
      expect(summary.remainingBalancePaise, 2000000); // ₹20,000 remaining
      expect(summary.percentageUsed, 0.20); // 20%
      expect(summary.safeDailySpendPaise, 100000); // ₹20,000 / 20 = ₹1,000/day
      expect(summary.averageDailySpendPaise, 50000); // ₹5,000 / 10 = ₹500/day
      expect(summary.status, BudgetStatus.safe);
    });

    test('Identifies nearLimit and overLimit statuses', () {
      // 80% spent -> nearLimit
      final near = BudgetStatusCalculator.computeMonthlySummary(
        budgetPaise: 1000000,
        carriedAmountPaise: 0,
        totalPersonalSpentPaise: 800000,
        daysInMonth: 30,
        daysLeftInMonth: 5,
        daysElapsedInMonth: 25,
      );
      expect(near.status, BudgetStatus.nearLimit);

      // 95% spent -> overLimit
      final over = BudgetStatusCalculator.computeMonthlySummary(
        budgetPaise: 1000000,
        carriedAmountPaise: 0,
        totalPersonalSpentPaise: 950000,
        daysInMonth: 30,
        daysLeftInMonth: 2,
        daysElapsedInMonth: 28,
      );
      expect(over.status, BudgetStatus.overLimit);
    });

    test('Computes category summaries and threshold triggers', () {
      // Limit ₹7,000, Spent ₹6,000 (85.7% -> nearLimit)
      final catNear = BudgetStatusCalculator.computeCategorySummary(
        categoryId: 1,
        categoryName: 'Food & Dining',
        emoji: '🍔',
        colorHex: '#F97316',
        limitPaise: 700000,
        spentPaise: 600000,
      );
      expect(catNear.status, CategoryStatus.nearLimit);
      expect(catNear.remainingPaise, 100000);

      // Limit ₹7,000, Spent ₹7,200 (102.8% -> overLimit)
      final catOver = BudgetStatusCalculator.computeCategorySummary(
        categoryId: 1,
        categoryName: 'Food & Dining',
        emoji: '🍔',
        colorHex: '#F97316',
        limitPaise: 700000,
        spentPaise: 720000,
      );
      expect(catOver.status, CategoryStatus.overLimit);
      expect(catOver.remainingPaise, -20000);
    });
  });
}
