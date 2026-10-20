import 'package:flutter_test/flutter_test.dart';
import 'package:pocketplan/core/utils/currency_formatter.dart';
import 'package:pocketplan/core/utils/date_formatter.dart';

void main() {
  group('CurrencyFormatter Tests', () {
    test('converts paise to rupees accurately', () {
      expect(CurrencyFormatter.paiseToRupees(100), 1.0);
      expect(CurrencyFormatter.paiseToRupees(150), 1.5);
      expect(CurrencyFormatter.paiseToRupees(2500000), 25000.0);
    });

    test('converts rupees to paise accurately', () {
      expect(CurrencyFormatter.rupeesToPaise(1), 100);
      expect(CurrencyFormatter.rupeesToPaise(1.5), 150);
      expect(CurrencyFormatter.rupeesToPaise(25000), 2500000);
    });

    test('formats paise to Indian currency string', () {
      final formatted = CurrencyFormatter.formatPaise(12500000);
      expect(formatted, contains('1,25,000'));
      expect(formatted, contains('₹'));

      // Negative paise
      final negativeFormatted = CurrencyFormatter.formatPaise(-50000);
      expect(negativeFormatted, startsWith('-'));
      expect(negativeFormatted, contains('500'));
    });

    test('parses user input string to paise accurately', () {
      expect(CurrencyFormatter.parseToPaise('1250'), 125000);
      expect(CurrencyFormatter.parseToPaise('₹ 1,250'), 125000);
      expect(CurrencyFormatter.parseToPaise('1250.50'), 125050);
      expect(CurrencyFormatter.parseToPaise(''), isNull);
      expect(CurrencyFormatter.parseToPaise('invalid'), isNull);
    });
  });

  group('DateFormatter Tests', () {
    test('calculates correct days in month', () {
      // Leap year Feb 2024
      expect(DateFormatter.getDaysInMonth(2024, 2), 29);
      // Non-leap year Feb 2023
      expect(DateFormatter.getDaysInMonth(2023, 2), 28);
      // 31-day months
      expect(DateFormatter.getDaysInMonth(2026, 1), 31);
      expect(DateFormatter.getDaysInMonth(2026, 10), 31);
      // 30-day months
      expect(DateFormatter.getDaysInMonth(2026, 4), 30);
    });

    test('calculates correct days remaining in active month', () {
      final now = DateTime(2026, 10, 20);
      // October has 31 days. Day 20 leaves (31 - 20 + 1) = 12 days remaining
      expect(DateFormatter.getDaysRemaining(2026, 10, now), 12);
    });

    test('gets correct month names', () {
      expect(DateFormatter.getMonthName(1), 'January');
      expect(DateFormatter.getMonthName(10), 'October');
      expect(DateFormatter.getMonthName(12), 'December');
      expect(DateFormatter.getMonthName(13), '');
    });
  });
}
