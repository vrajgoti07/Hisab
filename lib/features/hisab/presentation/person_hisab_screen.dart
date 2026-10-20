import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/database/app_database.dart';
import '../../../data/providers/app_providers.dart';
import '../../../domain/services/balance_calculator.dart';
import '../../reports/services/pdf_export_service.dart';
import '../../settlements/presentation/record_settlement_dialog.dart';

class PersonHisabScreen extends ConsumerStatefulWidget {
  final int personId;
  final String personName;
  final String? phone;

  const PersonHisabScreen({
    super.key,
    required this.personId,
    required this.personName,
    this.phone,
  });

  @override
  ConsumerState<PersonHisabScreen> createState() => _PersonHisabScreenState();
}

class _PersonHisabScreenState extends ConsumerState<PersonHisabScreen> {
  String _selectedGroupFilter = 'All';

  Future<void> _sendWhatsAppReminder(int netBalancePaise) async {
    final cleanPhone = (widget.phone ?? '').replaceAll(RegExp(r'[^0-9]'), '');
    final phoneFormatted = cleanPhone.length == 10
        ? '91$cleanPhone'
        : cleanPhone;

    final balanceText = netBalancePaise > 0
        ? 'your pending balance is ${CurrencyFormatter.formatPaise(netBalancePaise)}'
        : 'our shared hisab is all settled';

    final message = Uri.encodeComponent(
      'Hi ${widget.personName}, hope you are doing well! Just reviewing our shared hisab on Hisab: $balanceText. Please check whenever you get a moment. Thanks!',
    );

    final urlString = phoneFormatted.isNotEmpty
        ? 'https://wa.me/$phoneFormatted?text=$message'
        : 'https://wa.me/?text=$message';

    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp.')),
        );
      }
    }
  }

  void _showRecordSettlementDialog([int? defaultAmt]) {
    showDialog(
      context: context,
      builder: (_) => RecordSettlementDialog(
        defaultSenderPersonId: widget.personId,
        defaultReceiverPersonId: null, // Me
        defaultAmountPaise: defaultAmt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final overallBalancesAsync = ref.watch(overallBalancesProvider);
    final splitExpensesAsync = ref.watch(splitExpensesStreamProvider);
    final splitSharesAsync = ref.watch(splitSharesStreamProvider);
    final settlementsAsync = ref.watch(settlementsStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final balances = overallBalancesAsync.value;
    final personBalance = balances?.personBalances.firstWhere(
      (b) => b.personId == widget.personId,
      orElse: () => PersonBalanceResult(
        personId: widget.personId,
        personName: widget.personName,
        totalTheyOweMePaise: 0,
        totalIOweThemPaise: 0,
        netBalancePaise: 0,
      ),
    );

    final netPaise = personBalance?.netBalancePaise ?? 0;

    // Filter relevant splits involving this person
    final allSplits = splitExpensesAsync.value ?? [];
    final allShares = splitSharesAsync.value ?? [];
    final allSettlements = settlementsAsync.value ?? [];

    final relevantSplitIds = <String>{};
    for (final s in allShares) {
      if (s.personId == widget.personId) {
        relevantSplitIds.add(s.splitExpenseId);
      }
    }
    for (final exp in allSplits) {
      if (exp.paidByPersonId == widget.personId) {
        relevantSplitIds.add(exp.id);
      }
    }

    final filteredSplits = allSplits
        .where((e) => relevantSplitIds.contains(e.id))
        .toList();

    // Available groups for filter
    final groupsSet = <String>{'All'};
    for (final s in filteredSplits) {
      if (s.groupName != null && s.groupName!.trim().isNotEmpty) {
        groupsSet.add(s.groupName!.trim());
      }
    }

    // Filter by group
    final displayedSplits = _selectedGroupFilter == 'All'
        ? filteredSplits
        : filteredSplits
              .where((s) => s.groupName == _selectedGroupFilter)
              .toList();

    // Relevant settlements
    final relevantSettlements = allSettlements.where((s) {
      return (s.fromPersonId == widget.personId && s.toPersonId == null) ||
          (s.fromPersonId == null && s.toPersonId == widget.personId);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.personName),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.fileText, size: 20),
            tooltip: 'Export Hisab PDF',
            onPressed: () {
              if (personBalance != null) {
                PdfExportService.exportFriendHisabPdf(
                  friendName: widget.personName,
                  balance: personBalance,
                  sharedExpenses: filteredSplits,
                  settlements: relevantSettlements,
                );
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Net Balance Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: netPaise > 0
                      ? [const Color(0xFF047857), const Color(0xFF10B981)]
                      : (netPaise < 0
                            ? [const Color(0xFFB91C1C), const Color(0xFFEF4444)]
                            : [
                                const Color(0xFF334155),
                                const Color(0xFF64748B),
                              ]),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color:
                        (netPaise > 0
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444))
                            .withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    netPaise > 0
                        ? '${widget.personName} owes you'
                        : (netPaise < 0
                              ? 'You owe ${widget.personName}'
                              : 'All settled up with ${widget.personName}'),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    CurrencyFormatter.formatPaise(netPaise.abs()),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _balanceMiniTag(
                        'They Owe Me',
                        CurrencyFormatter.formatPaise(
                          personBalance?.totalTheyOweMePaise ?? 0,
                        ),
                      ),
                      const SizedBox(width: 16),
                      _balanceMiniTag(
                        'I Owe Them',
                        CurrencyFormatter.formatPaise(
                          personBalance?.totalIOweThemPaise ?? 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons Row (WhatsApp, Record Settlement, Settle All)
            Row(
              children: [
                // WhatsApp Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _sendWhatsAppReminder(netPaise),
                    icon: const Icon(
                      LucideIcons.messageSquare,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'WhatsApp',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Record Settlement
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showRecordSettlementDialog(),
                    icon: const Icon(
                      LucideIcons.handCoins,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Record Pay',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emerald,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Settle All
                if (netPaise != 0)
                  IconButton(
                    tooltip: 'Settle Full Balance',
                    icon: const Icon(
                      LucideIcons.checkCheck,
                      color: AppColors.emerald,
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: isDark
                          ? AppColors.cardDark
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight,
                        ),
                      ),
                    ),
                    onPressed: () =>
                        _showRecordSettlementDialog(netPaise.abs()),
                  ),
              ],
            ),
            const SizedBox(height: 22),

            // Group / Event Filter Chips (if any groups exist)
            if (groupsSet.length > 1) ...[
              const Text(
                'FILTER BY EVENT',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutralSlate,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: groupsSet.map((g) {
                    final isSel = _selectedGroupFilter == g;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(g),
                        selected: isSel,
                        onSelected: (_) =>
                            setState(() => _selectedGroupFilter = g),
                        selectedColor: AppColors.emerald,
                        labelStyle: TextStyle(
                          color: isSel
                              ? Colors.white
                              : (isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textSecondaryLight),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: isDark
                            ? AppColors.cardDark
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),
            ],

            // Shared Transactions Timeline Title
            const Text(
              'SHARED TRANSACTIONS TIMELINE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.neutralSlate,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),

            // Timeline Items
            if (displayedSplits.isEmpty && relevantSettlements.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(
                      LucideIcons.receiptText,
                      size: 40,
                      color: AppColors.neutralSlate,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No shared transactions recorded with this friend yet.',
                      style: TextStyle(
                        color: AppColors.neutralSlate,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...displayedSplits.map((split) {
                final isPayerMe = split.paidByPersonId == null;
                final myShare = allShares.firstWhere(
                  (s) => s.splitExpenseId == split.id && s.personId == null,
                  orElse: () => const SplitShare(
                    id: 0,
                    splitExpenseId: '',
                    personId: null,
                    shareAmountPaise: 0,
                  ),
                );
                final friendShare = allShares.firstWhere(
                  (s) =>
                      s.splitExpenseId == split.id &&
                      s.personId == widget.personId,
                  orElse: () => const SplitShare(
                    id: 0,
                    splitExpenseId: '',
                    personId: null,
                    shareAmountPaise: 0,
                  ),
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: isPayerMe
                          ? AppColors.safeGreen.withValues(alpha: 0.15)
                          : AppColors.dangerRed.withValues(alpha: 0.15),
                      child: Icon(
                        isPayerMe
                            ? LucideIcons.arrowDownLeft
                            : LucideIcons.arrowUpRight,
                        color: isPayerMe
                            ? AppColors.safeGreen
                            : AppColors.dangerRed,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      split.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      '${DateFormatter.formatShortDate(split.date)} • ${isPayerMe ? "You paid ₹${(split.totalAmountPaise / 100).toStringAsFixed(0)}" : "${widget.personName} paid"}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.neutralSlate,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isPayerMe
                              ? '+${CurrencyFormatter.formatPaise(friendShare.shareAmountPaise)}'
                              : '-${CurrencyFormatter.formatPaise(myShare.shareAmountPaise)}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: isPayerMe
                                ? AppColors.safeGreen
                                : AppColors.dangerRed,
                          ),
                        ),
                        Text(
                          isPayerMe ? 'they owe' : 'you owe',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.neutralSlate,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

            // Settlements Sub-list
            if (relevantSettlements.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Text(
                'SETTLEMENTS & PAYMENTS RECORDED',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutralSlate,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              ...relevantSettlements.map((s) {
                final friendPaidMe = s.fromPersonId == widget.personId;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    dense: true,
                    leading: const Icon(
                      LucideIcons.circleCheck,
                      color: AppColors.emerald,
                      size: 20,
                    ),
                    title: Text(
                      friendPaidMe
                          ? '${widget.personName} paid you'
                          : 'You paid ${widget.personName}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${DateFormatter.formatShortDate(s.date)} via ${s.mode}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      CurrencyFormatter.formatPaise(s.amountPaise),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        color: AppColors.emerald,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _balanceMiniTag(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
