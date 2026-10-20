class PersonBalanceResult {
  final int personId;
  final String personName;
  final int totalTheyOweMePaise;
  final int totalIOweThemPaise;
  final int netBalancePaise;

  const PersonBalanceResult({
    required this.personId,
    required this.personName,
    required this.totalTheyOweMePaise,
    required this.totalIOweThemPaise,
    required this.netBalancePaise,
  });

  bool get theyOweMe => netBalancePaise > 0;
  bool get iOweThem => netBalancePaise < 0;
  bool get isSettled => netBalancePaise == 0;
}

class OverallBalancesResult {
  final List<PersonBalanceResult> personBalances;
  final int totalToReceivePaise;
  final int totalToPayPaise;

  const OverallBalancesResult({
    required this.personBalances,
    required this.totalToReceivePaise,
    required this.totalToPayPaise,
  });

  int get netPositionPaise => totalToReceivePaise - totalToPayPaise;
}

class RawSplitItem {
  final int? paidByPersonId; // null = 'Me'
  final int? sharePersonId; // null = 'Me'
  final int shareAmountPaise;

  const RawSplitItem({
    required this.paidByPersonId,
    required this.sharePersonId,
    required this.shareAmountPaise,
  });
}

class RawSettlementItem {
  final int? fromPersonId; // null = 'Me'
  final int? toPersonId; // null = 'Me'
  final int amountPaise;

  const RawSettlementItem({
    required this.fromPersonId,
    required this.toPersonId,
    required this.amountPaise,
  });
}

class BalanceCalculator {
  /// Computes balances for all people given the raw split shares and settlements
  static OverallBalancesResult compute({
    required Map<int, String> people, // id -> name
    required List<RawSplitItem> splitItems,
    required List<RawSettlementItem> settlements,
  }) {
    final Map<int, int> theyOweMeMap = {};
    final Map<int, int> iOweThemMap = {};

    for (final personId in people.keys) {
      theyOweMeMap[personId] = 0;
      iOweThemMap[personId] = 0;
    }

    // 1. Process Split items
    for (final item in splitItems) {
      // Case A: "Me" paid, and a friend had a share -> friend owes Me
      if (item.paidByPersonId == null && item.sharePersonId != null) {
        final friendId = item.sharePersonId!;
        if (theyOweMeMap.containsKey(friendId)) {
          theyOweMeMap[friendId] = theyOweMeMap[friendId]! + item.shareAmountPaise;
        }
      }
      // Case B: A friend paid, and "Me" had a share -> I owe that friend
      else if (item.paidByPersonId != null && item.sharePersonId == null) {
        final payerFriendId = item.paidByPersonId!;
        if (iOweThemMap.containsKey(payerFriendId)) {
          iOweThemMap[payerFriendId] = iOweThemMap[payerFriendId]! + item.shareAmountPaise;
        }
      }
    }

    // 2. Process Settlements
    for (final s in settlements) {
      // Case A: Friend paid Me -> reduces what they owe Me
      if (s.fromPersonId != null && s.toPersonId == null) {
        final friendId = s.fromPersonId!;
        if (theyOweMeMap.containsKey(friendId)) {
          theyOweMeMap[friendId] = theyOweMeMap[friendId]! - s.amountPaise;
        }
      }
      // Case B: I paid Friend -> reduces what I owe them
      else if (s.fromPersonId == null && s.toPersonId != null) {
        final friendId = s.toPersonId!;
        if (iOweThemMap.containsKey(friendId)) {
          iOweThemMap[friendId] = iOweThemMap[friendId]! - s.amountPaise;
        }
      }
    }

    // 3. Assemble PersonBalanceResult list
    final List<PersonBalanceResult> results = [];
    int toReceive = 0;
    int toPay = 0;

    for (final entry in people.entries) {
      final pId = entry.key;
      final name = entry.value;

      final theyOwe = theyOweMeMap[pId] ?? 0;
      final iOwe = iOweThemMap[pId] ?? 0;
      final net = theyOwe - iOwe;

      if (net > 0) {
        toReceive += net;
      } else if (net < 0) {
        toPay += (-net);
      }

      results.add(PersonBalanceResult(
        personId: pId,
        personName: name,
        totalTheyOweMePaise: theyOwe,
        totalIOweThemPaise: iOwe,
        netBalancePaise: net,
      ));
    }

    return OverallBalancesResult(
      personBalances: results,
      totalToReceivePaise: toReceive,
      totalToPayPaise: toPay,
    );
  }
}
