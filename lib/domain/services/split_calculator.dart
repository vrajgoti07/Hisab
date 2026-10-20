enum SplitType { equal, exact, percentage, shares }

class SplitParticipant {
  final int? personId; // null = 'Me'
  final String name;
  final int? exactAmountPaise; // For exact split
  final double? percentage; // For percentage split (e.g. 25.0)
  final int? shareCount; // For shares/ratio split (e.g. 2 shares)

  const SplitParticipant({
    required this.personId,
    required this.name,
    this.exactAmountPaise,
    this.percentage,
    this.shareCount,
  });

  bool get isMe => personId == null;
}

class CalculatedShare {
  final int? personId;
  final String name;
  final int shareAmountPaise;

  const CalculatedShare({
    required this.personId,
    required this.name,
    required this.shareAmountPaise,
  });

  bool get isMe => personId == null;
}

class SplitCalculationResult {
  final bool isValid;
  final String? errorMessage;
  final List<CalculatedShare> shares;
  final int totalAmountPaise;
  final int mySharePaise;
  final int friendsSharePaise;

  const SplitCalculationResult({
    required this.isValid,
    this.errorMessage,
    required this.shares,
    required this.totalAmountPaise,
    required this.mySharePaise,
    required this.friendsSharePaise,
  });
}

class SplitCalculator {
  /// Calculates each participant's share based on total amount and split type.
  /// Automatically resolves paise rounding so sum(shares) == totalAmountPaise exactly.
  static SplitCalculationResult calculate({
    required int totalAmountPaise,
    required SplitType splitType,
    required List<SplitParticipant> participants,
  }) {
    if (totalAmountPaise <= 0) {
      return SplitCalculationResult(
        isValid: false,
        errorMessage: 'Total bill amount must be greater than zero.',
        shares: const [],
        totalAmountPaise: totalAmountPaise,
        mySharePaise: 0,
        friendsSharePaise: 0,
      );
    }

    if (participants.isEmpty) {
      return SplitCalculationResult(
        isValid: false,
        errorMessage: 'Select at least one participant for the split.',
        shares: const [],
        totalAmountPaise: totalAmountPaise,
        mySharePaise: 0,
        friendsSharePaise: 0,
      );
    }

    final n = participants.length;
    final List<CalculatedShare> calculated = [];

    switch (splitType) {
      case SplitType.equal:
        final baseShare = totalAmountPaise ~/ n;
        final remainder = totalAmountPaise % n;

        // Distribute base share, and give 1 extra paise to first `remainder` participants
        for (int i = 0; i < n; i++) {
          final share = baseShare + (i < remainder ? 1 : 0);
          calculated.add(
            CalculatedShare(
              personId: participants[i].personId,
              name: participants[i].name,
              shareAmountPaise: share,
            ),
          );
        }
        break;

      case SplitType.exact:
        int runningSum = 0;
        for (int i = 0; i < n; i++) {
          final amt = participants[i].exactAmountPaise ?? 0;
          if (amt < 0) {
            return SplitCalculationResult(
              isValid: false,
              errorMessage: 'Individual exact shares cannot be negative.',
              shares: const [],
              totalAmountPaise: totalAmountPaise,
              mySharePaise: 0,
              friendsSharePaise: 0,
            );
          }
          runningSum += amt;
          calculated.add(
            CalculatedShare(
              personId: participants[i].personId,
              name: participants[i].name,
              shareAmountPaise: amt,
            ),
          );
        }

        if (runningSum != totalAmountPaise) {
          final diff = totalAmountPaise - runningSum;
          final diffMsg = diff > 0
              ? 'Short by ${(diff / 100).toStringAsFixed(2)} INR'
              : 'Over by ${((-diff) / 100).toStringAsFixed(2)} INR';
          return SplitCalculationResult(
            isValid: false,
            errorMessage:
                'Sum of exact shares must equal total bill ($diffMsg).',
            shares: calculated,
            totalAmountPaise: totalAmountPaise,
            mySharePaise: 0,
            friendsSharePaise: 0,
          );
        }
        break;

      case SplitType.percentage:
        double totalPct = 0.0;
        for (final p in participants) {
          totalPct += (p.percentage ?? 0.0);
        }

        if ((totalPct - 100.0).abs() > 0.05) {
          return SplitCalculationResult(
            isValid: false,
            errorMessage:
                'Percentages must sum to 100% (currently ${totalPct.toStringAsFixed(1)}%).',
            shares: const [],
            totalAmountPaise: totalAmountPaise,
            mySharePaise: 0,
            friendsSharePaise: 0,
          );
        }

        int distributed = 0;
        for (int i = 0; i < n; i++) {
          if (i == n - 1) {
            // Adjust last person to ensure exact penny match
            final lastShare = totalAmountPaise - distributed;
            calculated.add(
              CalculatedShare(
                personId: participants[i].personId,
                name: participants[i].name,
                shareAmountPaise: lastShare,
              ),
            );
          } else {
            final pct = participants[i].percentage ?? 0.0;
            final share = (totalAmountPaise * (pct / 100.0)).round();
            distributed += share;
            calculated.add(
              CalculatedShare(
                personId: participants[i].personId,
                name: participants[i].name,
                shareAmountPaise: share,
              ),
            );
          }
        }
        break;

      case SplitType.shares:
        int totalShares = 0;
        for (final p in participants) {
          final count = p.shareCount ?? 1;
          if (count <= 0) {
            return SplitCalculationResult(
              isValid: false,
              errorMessage: 'Ratio/shares count must be at least 1.',
              shares: const [],
              totalAmountPaise: totalAmountPaise,
              mySharePaise: 0,
              friendsSharePaise: 0,
            );
          }
          totalShares += count;
        }

        int distributed = 0;
        for (int i = 0; i < n; i++) {
          if (i == n - 1) {
            final lastShare = totalAmountPaise - distributed;
            calculated.add(
              CalculatedShare(
                personId: participants[i].personId,
                name: participants[i].name,
                shareAmountPaise: lastShare,
              ),
            );
          } else {
            final count = participants[i].shareCount ?? 1;
            final share = (totalAmountPaise * count ~/ totalShares);
            distributed += share;
            calculated.add(
              CalculatedShare(
                personId: participants[i].personId,
                name: participants[i].name,
                shareAmountPaise: share,
              ),
            );
          }
        }
        break;
    }

    // Determine mySharePaise and friendsSharePaise
    int myShare = 0;
    int friendsShare = 0;
    for (final s in calculated) {
      if (s.isMe) {
        myShare += s.shareAmountPaise;
      } else {
        friendsShare += s.shareAmountPaise;
      }
    }

    return SplitCalculationResult(
      isValid: true,
      shares: calculated,
      totalAmountPaise: totalAmountPaise,
      mySharePaise: myShare,
      friendsSharePaise: friendsShare,
    );
  }
}
