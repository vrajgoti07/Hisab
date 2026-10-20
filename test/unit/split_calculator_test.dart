import 'package:flutter_test/flutter_test.dart';
import 'package:pocketplan/domain/services/split_calculator.dart';

void main() {
  group('SplitCalculator Tests', () {
    test('Equal split with exact division', () {
      final participants = [
        const SplitParticipant(personId: null, name: 'Me'),
        const SplitParticipant(personId: 1, name: 'Rahul'),
        const SplitParticipant(personId: 2, name: 'Priya'),
        const SplitParticipant(personId: 3, name: 'Amit'),
      ];

      // ₹1,200 (120000 paise) split 4 ways -> 30000 paise (₹300) each
      final result = SplitCalculator.calculate(
        totalAmountPaise: 120000,
        splitType: SplitType.equal,
        participants: participants,
      );

      expect(result.isValid, isTrue);
      expect(result.shares.length, 4);
      expect(result.mySharePaise, 30000);
      expect(result.friendsSharePaise, 90000);
      expect(
        result.shares.fold<int>(0, (sum, s) => sum + s.shareAmountPaise),
        120000,
      );
      for (final s in result.shares) {
        expect(s.shareAmountPaise, 30000);
      }
    });

    test('Equal split with odd paise remainder handles rounding correctly', () {
      final participants = [
        const SplitParticipant(personId: null, name: 'Me'),
        const SplitParticipant(personId: 1, name: 'Rahul'),
        const SplitParticipant(personId: 2, name: 'Priya'),
      ];

      // 100 paise (₹1) split 3 ways -> 34, 33, 33 paise = exactly 100 paise
      final result = SplitCalculator.calculate(
        totalAmountPaise: 100,
        splitType: SplitType.equal,
        participants: participants,
      );

      expect(result.isValid, isTrue);
      expect(result.shares.length, 3);
      final totalSum = result.shares.fold<int>(
        0,
        (sum, s) => sum + s.shareAmountPaise,
      );
      expect(totalSum, 100);
      expect(result.shares[0].shareAmountPaise, 34);
      expect(result.shares[1].shareAmountPaise, 33);
      expect(result.shares[2].shareAmountPaise, 33);
    });

    test('Exact split validates that sum matches total bill', () {
      final participants = [
        const SplitParticipant(
          personId: null,
          name: 'Me',
          exactAmountPaise: 40000,
        ),
        const SplitParticipant(
          personId: 1,
          name: 'Rahul',
          exactAmountPaise: 60000,
        ),
      ];

      final validResult = SplitCalculator.calculate(
        totalAmountPaise: 100000,
        splitType: SplitType.exact,
        participants: participants,
      );
      expect(validResult.isValid, isTrue);
      expect(validResult.mySharePaise, 40000);
      expect(validResult.friendsSharePaise, 60000);

      // Mismatched sum fails validation
      final invalidResult = SplitCalculator.calculate(
        totalAmountPaise: 120000,
        splitType: SplitType.exact,
        participants: participants,
      );
      expect(invalidResult.isValid, isFalse);
      expect(invalidResult.errorMessage, contains('must equal total bill'));
    });

    test(
      'Percentage split distributes accurately and adjusts rounding on last person',
      () {
        final participants = [
          const SplitParticipant(personId: null, name: 'Me', percentage: 50.0),
          const SplitParticipant(personId: 1, name: 'Rahul', percentage: 25.0),
          const SplitParticipant(personId: 2, name: 'Priya', percentage: 25.0),
        ];

        final result = SplitCalculator.calculate(
          totalAmountPaise: 100000,
          splitType: SplitType.percentage,
          participants: participants,
        );

        expect(result.isValid, isTrue);
        expect(result.shares[0].shareAmountPaise, 50000);
        expect(result.shares[1].shareAmountPaise, 25000);
        expect(result.shares[2].shareAmountPaise, 25000);
        expect(
          result.shares.fold<int>(0, (sum, s) => sum + s.shareAmountPaise),
          100000,
        );
      },
    );

    test('Shares ratio split calculates correct proportional shares', () {
      final participants = [
        const SplitParticipant(personId: null, name: 'Me', shareCount: 1),
        const SplitParticipant(
          personId: 1,
          name: 'Rahul',
          shareCount: 2,
        ), // Rahul pays double share
      ];

      // 30000 paise split 1:2 -> Me: 10000, Rahul: 20000
      final result = SplitCalculator.calculate(
        totalAmountPaise: 30000,
        splitType: SplitType.shares,
        participants: participants,
      );

      expect(result.isValid, isTrue);
      expect(result.shares[0].shareAmountPaise, 10000);
      expect(result.shares[1].shareAmountPaise, 20000);
      expect(
        result.shares.fold<int>(0, (sum, s) => sum + s.shareAmountPaise),
        30000,
      );
    });
  });
}
