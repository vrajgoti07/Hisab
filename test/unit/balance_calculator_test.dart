import 'package:flutter_test/flutter_test.dart';
import 'package:pocketplan/domain/services/balance_calculator.dart';

void main() {
  group('BalanceCalculator Tests', () {
    test('Calculates simple bill where Me paid and Rahul owes his share', () {
      final people = {1: 'Rahul Sharma'};
      // Me paid full bill of ₹1,000, Rahul share is ₹500
      final splitItems = [
        const RawSplitItem(
          paidByPersonId: null, // Me paid
          sharePersonId: 1, // Rahul's share
          shareAmountPaise: 50000,
        ),
      ];
      final settlements = <RawSettlementItem>[];

      final result = BalanceCalculator.compute(
        people: people,
        splitItems: splitItems,
        settlements: settlements,
      );

      expect(result.totalToReceivePaise, 50000);
      expect(result.totalToPayPaise, 0);
      final rahul = result.personBalances.firstWhere((p) => p.personId == 1);
      expect(rahul.totalTheyOweMePaise, 50000);
      expect(rahul.totalIOweThemPaise, 0);
      expect(rahul.netBalancePaise, 50000);
      expect(rahul.theyOweMe, isTrue);
      expect(rahul.isSettled, isFalse);
    });

    test('Partial repayment reduces pending balance', () {
      final people = {1: 'Rahul Sharma'};
      // Rahul owed ₹500, paid back ₹300
      final splitItems = [
        const RawSplitItem(
          paidByPersonId: null,
          sharePersonId: 1,
          shareAmountPaise: 50000,
        ),
      ];
      final settlements = [
        const RawSettlementItem(
          fromPersonId: 1, // Rahul
          toPersonId: null, // Me
          amountPaise: 30000, // ₹300
        ),
      ];

      final result = BalanceCalculator.compute(
        people: people,
        splitItems: splitItems,
        settlements: settlements,
      );

      final rahul = result.personBalances.firstWhere((p) => p.personId == 1);
      expect(rahul.netBalancePaise, 20000); // ₹200 left
      expect(result.totalToReceivePaise, 20000);
    });

    test('Friend paid full bill where Me owed share and I owe them', () {
      final people = {2: 'Priya Patel'};
      // Priya paid, My share was ₹400
      final splitItems = [
        const RawSplitItem(
          paidByPersonId: 2, // Priya paid
          sharePersonId: null, // My share
          shareAmountPaise: 40000,
        ),
      ];
      final settlements = <RawSettlementItem>[];

      final result = BalanceCalculator.compute(
        people: people,
        splitItems: splitItems,
        settlements: settlements,
      );

      expect(result.totalToReceivePaise, 0);
      expect(result.totalToPayPaise, 40000);
      final priya = result.personBalances.firstWhere((p) => p.personId == 2);
      expect(priya.totalIOweThemPaise, 40000);
      expect(priya.netBalancePaise, -40000);
      expect(priya.iOweThem, isTrue);
    });
  });
}
