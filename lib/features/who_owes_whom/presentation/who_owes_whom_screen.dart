import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/providers/app_providers.dart';
import '../../hisab/presentation/person_hisab_screen.dart';

class WhoOwesWhomScreen extends ConsumerWidget {
  const WhoOwesWhomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overallBalancesAsync = ref.watch(overallBalancesProvider);
    final simplifiedPaymentsAsync = ref.watch(debtSimplificationProvider);

    final balances = overallBalancesAsync.value;
    final simplifiedPayments = simplifiedPaymentsAsync.value ?? [];

    final toReceive = balances?.totalToReceivePaise ?? 0;
    final toPay = balances?.totalToPayPaise ?? 0;
    final personBalances = balances?.personBalances ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Who Owes Whom'),
        backgroundColor: const Color(0xFFF6F7FB),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TO RECEIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF15803D))),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.formatPaise(toReceive),
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF15803D)),
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
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFFECACA)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('I NEED TO PAY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFB91C1C))),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.formatPaise(toPay),
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFFB91C1C)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Bar Chart of Balances (if people exist)
            if (personBalances.isNotEmpty) ...[
              const Text('PENDING BALANCES PER FRIEND', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
              const SizedBox(height: 10),
              Container(
                height: 180,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: (personBalances.map((e) => e.netBalancePaise.abs().toDouble()).reduce((a, b) => a > b ? a : b) / 100.0) * 1.2,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final p = personBalances[group.x.toInt()];
                          final amount = CurrencyFormatter.formatPaise(p.netBalancePaise.abs());
                          final status = p.theyOweMe ? 'Owes Me' : (p.iOweThem ? 'I Owe' : 'Settled');
                          return BarTooltipItem(
                            '${p.personName}\n$amount ($status)',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx < 0 || idx >= personBalances.length) return const SizedBox.shrink();
                            final name = personBalances[idx].personName.split(' ').first;
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
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
                            color: isGreen ? const Color(0xFF10B981) : (p.iOweThem ? const Color(0xFFEF4444) : const Color(0xFF94A3B8)),
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
                color: const Color(0xFFF0FDFA),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFCCFBF1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome_rounded, color: Color(0xFF0D9488), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Simplified Settlement Plan (Debt Netting)',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F766E)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'PocketPlan calculates the minimum number of transactions needed to clear all group balances efficiently.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF115E59)),
                  ),
                  const Divider(height: 20, color: Color(0xFFCCFBF1)),
                  if (simplifiedPayments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('🎉 All balances are currently settled! No payments required.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F766E))),
                    )
                  else
                    ...simplifiedPayments.map((p) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_right_alt_rounded, color: Color(0xFF0D9488)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                                  children: [
                                    TextSpan(text: p.fromName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const TextSpan(text: ' pays '),
                                    TextSpan(text: p.toName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              CurrencyFormatter.formatPaise(p.amountPaise),
                              style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF0D9488)),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Friend List Navigation
            const Text('ALL FRIENDS BALANCES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
            const SizedBox(height: 8),
            ...personBalances.map((p) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(p.personName, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    p.theyOweMe
                        ? 'Owes you ${CurrencyFormatter.formatPaise(p.netBalancePaise)}'
                        : (p.iOweThem ? 'You owe ${CurrencyFormatter.formatPaise(p.netBalancePaise.abs())}' : 'Settled'),
                    style: TextStyle(
                      color: p.theyOweMe ? const Color(0xFF10B981) : (p.iOweThem ? const Color(0xFFEF4444) : Colors.grey),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PersonHisabScreen(personId: p.personId, personName: p.personName),
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
