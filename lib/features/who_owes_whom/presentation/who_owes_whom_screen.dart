import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/providers/app_providers.dart';
import '../../hisab/presentation/person_hisab_screen.dart';

class WhoOwesWhomScreen extends ConsumerWidget {
  const WhoOwesWhomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overallBalancesAsync = ref.watch(overallBalancesProvider);
    final simplifiedPaymentsAsync = ref.watch(debtSimplificationProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final balances = overallBalancesAsync.value;
    final simplifiedPayments = simplifiedPaymentsAsync.value ?? [];

    final toReceive = balances?.totalToReceivePaise ?? 0;
    final toPay = balances?.totalToPayPaise ?? 0;
    final personBalances = balances?.personBalances ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Who Owes Whom')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Summaries Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.cardDark
                          : AppColors.safeGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.safeGreen.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TO RECEIVE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.safeGreen,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Icon(
                              LucideIcons.arrowDownLeft,
                              size: 16,
                              color: AppColors.safeGreen,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          CurrencyFormatter.formatPaise(toReceive),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.safeGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.cardDark
                          : AppColors.dangerRed.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.dangerRed.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'I NEED TO PAY',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.dangerRed,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Icon(
                              LucideIcons.arrowUpRight,
                              size: 16,
                              color: AppColors.dangerRed,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          CurrencyFormatter.formatPaise(toPay),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.dangerRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Bar Chart of Balances (if people exist and have non-zero balance)
            if (personBalances.isNotEmpty &&
                personBalances.any((p) => p.netBalancePaise != 0)) ...[
              const Text(
                'PENDING BALANCES PER FRIEND',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutralSlate,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 180,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY:
                        (personBalances
                                .map((e) => e.netBalancePaise.abs().toDouble())
                                .reduce((a, b) => a > b ? a : b) /
                            100.0) *
                        1.2,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final p = personBalances[group.x.toInt()];
                          final amount = CurrencyFormatter.formatPaise(
                            p.netBalancePaise.abs(),
                          );
                          final status = p.theyOweMe
                              ? 'Owes You'
                              : (p.iOweThem ? 'You Owe' : 'Settled');
                          return BarTooltipItem(
                            '${p.personName}\n$amount ($status)',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx < 0 || idx >= personBalances.length) {
                              return const SizedBox.shrink();
                            }
                            final name = personBalances[idx].personName
                                .split(' ')
                                .first;
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textMutedDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: personBalances.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final p = entry.value;
                      final rupees = (p.netBalancePaise.abs() / 100.0);
                      final isGreen = p.theyOweMe;
                      return BarChartGroupData(
                        x: idx,
                        barRods: [
                          BarChartRodData(
                            toY: rupees,
                            color: isGreen
                                ? AppColors.safeGreen
                                : (p.iOweThem
                                      ? AppColors.dangerRed
                                      : AppColors.neutralSlate),
                            width: 16,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Simplified Settlement Suggestions Box
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.cardDark
                    : AppColors.teal.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark
                      ? AppColors.borderDark
                      : AppColors.teal.withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.sparkles,
                        color: AppColors.teal,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Simplified Settlement Plan (Debt Netting)',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.tealLight
                              : AppColors.tealDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Hisab automatically calculates the minimum number of payments needed to clear all group debts with zero money lost.',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  Divider(
                    height: 20,
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.teal.withValues(alpha: 0.2),
                  ),
                  if (simplifiedPayments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.circleCheck,
                            size: 18,
                            color: AppColors.safeGreen,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'All balances are currently settled! 🎉',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.safeGreen
                                  : AppColors.emeraldDark,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...simplifiedPayments.map((p) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            const Icon(
                              LucideIcons.arrowRight,
                              size: 16,
                              color: AppColors.teal,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: p.fromName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(text: ' pays '),
                                    TextSpan(
                                      text: p.toName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              CurrencyFormatter.formatPaise(p.amountPaise),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: AppColors.teal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Friend List
            const Text(
              'ALL FRIENDS BALANCES',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.neutralSlate,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),
            ...personBalances.map((p) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    p.personName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    p.theyOweMe
                        ? 'Owes you ${CurrencyFormatter.formatPaise(p.netBalancePaise)}'
                        : (p.iOweThem
                              ? 'You owe ${CurrencyFormatter.formatPaise(p.netBalancePaise.abs())}'
                              : 'All Settled'),
                    style: TextStyle(
                      color: p.theyOweMe
                          ? AppColors.safeGreen
                          : (p.iOweThem
                                ? AppColors.dangerRed
                                : AppColors.neutralSlate),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  trailing: const Icon(LucideIcons.chevronRight, size: 18),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PersonHisabScreen(
                          personId: p.personId,
                          personName: p.personName,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
