import 'package:flutter_test/flutter_test.dart';
import 'package:pocketplan/domain/services/debt_simplifier.dart';

void main() {
  group('DebtSimplifier Tests', () {
    test('Simplifies 3-party cyclical debt into minimum payments', () {
      // Rahul owes Me ₹1,000 (+1000 for Me, -1000 for Rahul)
      // I owe Amit ₹1,000 (-1000 for Me, +1000 for Amit)
      // Net balances: Me: 0, Rahul: -1000, Amit: +1000
      // Debt simplification: Rahul pays Amit ₹1,000 directly! (1 transaction instead of 2)
      final participants = <int?, String>{null: 'Me', 1: 'Rahul', 2: 'Amit'};

      final netBalances = <int?, int>{null: 0, 1: -100000, 2: 100000};

      final simplified = DebtSimplifier.simplify(
        participants: participants,
        netBalancesPaise: netBalances,
      );

      expect(simplified.length, 1);
      expect(simplified.first.fromName, 'Rahul');
      expect(simplified.first.toName, 'Amit');
      expect(simplified.first.amountPaise, 100000);
    });

    test('All settled returns empty list of payments', () {
      final participants = <int?, String>{null: 'Me', 1: 'Rahul'};
      final netBalances = <int?, int>{null: 0, 1: 0};

      final simplified = DebtSimplifier.simplify(
        participants: participants,
        netBalancesPaise: netBalances,
      );

      expect(simplified, isEmpty);
    });

    test('Complex 4-party balance resolves in at most N-1 transactions', () {
      final participants = <int?, String>{
        null: 'Me',
        1: 'Rahul',
        2: 'Priya',
        3: 'Amit',
      };

      final netBalances = <int?, int>{
        null: 150000, // Me receives 1,500
        1: -50000, // Rahul owes 500
        2: -100000, // Priya owes 1,000
        3: 0, // Amit settled
      };

      final simplified = DebtSimplifier.simplify(
        participants: participants,
        netBalancesPaise: netBalances,
      );

      expect(simplified.length, 2);
      final totalSettled = simplified.fold<int>(
        0,
        (sum, p) => sum + p.amountPaise,
      );
      expect(totalSettled, 150000);
      for (final p in simplified) {
        expect(p.toName, 'Me');
      }
    });
  });
}
