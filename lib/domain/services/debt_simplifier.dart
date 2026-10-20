import 'dart:math';

class SimplifiedPayment {
  final int? fromPersonId; // null = 'Me'
  final String fromName;
  final int? toPersonId; // null = 'Me'
  final String toName;
  final int amountPaise;

  const SimplifiedPayment({
    required this.fromPersonId,
    required this.fromName,
    required this.toPersonId,
    required this.toName,
    required this.amountPaise,
  });

  bool get fromMe => fromPersonId == null;
  bool get toMe => toPersonId == null;
}

class _PartyBalance {
  final int? id;
  final String name;
  int amountPaise;

  _PartyBalance({
    required this.id,
    required this.name,
    required this.amountPaise,
  });
}

class DebtSimplifier {
  /// Simplifies debts among participants using the greedy Min-Cash-Flow algorithm.
  /// Guarantees the minimum number of transactions to clear all balances.
  static List<SimplifiedPayment> simplify({
    required Map<int?, String> participants, // id -> name (null id = 'Me')
    required Map<int?, int> netBalancesPaise, // positive = to receive, negative = owes
  }) {
    final List<_PartyBalance> debtors = [];
    final List<_PartyBalance> creditors = [];

    for (final entry in netBalancesPaise.entries) {
      final id = entry.key;
      final balance = entry.value;
      final name = participants[id] ?? (id == null ? 'Me' : 'Person #$id');

      if (balance < 0) {
        debtors.add(_PartyBalance(id: id, name: name, amountPaise: -balance));
      } else if (balance > 0) {
        creditors.add(_PartyBalance(id: id, name: name, amountPaise: balance));
      }
    }

    final List<SimplifiedPayment> payments = [];

    // Greedily match maximum debtor with maximum creditor
    while (debtors.isNotEmpty && creditors.isNotEmpty) {
      debtors.sort((a, b) => b.amountPaise.compareTo(a.amountPaise));
      creditors.sort((a, b) => b.amountPaise.compareTo(a.amountPaise));

      final maxDebtor = debtors.first;
      final maxCreditor = creditors.first;

      final settledAmount = min(maxDebtor.amountPaise, maxCreditor.amountPaise);

      if (settledAmount > 0) {
        payments.add(SimplifiedPayment(
          fromPersonId: maxDebtor.id,
          fromName: maxDebtor.name,
          toPersonId: maxCreditor.id,
          toName: maxCreditor.name,
          amountPaise: settledAmount,
        ));
      }

      maxDebtor.amountPaise -= settledAmount;
      maxCreditor.amountPaise -= settledAmount;

      if (maxDebtor.amountPaise == 0) {
        debtors.removeAt(0);
      }
      if (maxCreditor.amountPaise == 0) {
        creditors.removeAt(0);
      }
    }

    return payments;
  }
}
