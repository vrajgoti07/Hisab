import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/providers/app_providers.dart';
import '../../../domain/services/budget_status_calculator.dart';
import '../../../widgets/app_animated_ring.dart';
import '../../expenses/presentation/add_edit_expense_sheet.dart';
import '../../who_owes_whom/presentation/who_owes_whom_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _showAddExpenseModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddEditExpenseSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeMY = ref.watch(activeMonthYearProvider);
    final dashStateAsync = ref.watch(dashboardStateProvider);
    final overallBalancesAsync = ref.watch(overallBalancesProvider);
    final savingsGoalsAsync = ref.watch(savingsGoalsStreamProvider);

    final dashState = dashStateAsync.value;
    final balances = overallBalancesAsync.value;
    final goals = savingsGoalsAsync.value ?? [];

    final toReceive = balances?.totalToReceivePaise ?? 0;
    final toPay = balances?.totalToPayPaise ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Row(
          children: [
            const Text('PocketPlan', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w800, color: Color(0xFF1A365D))),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: const Color(0xFF0D9488).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
              child: const Text('PRO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0D9488))),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFF6F7FB),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Setup Month Budget',
            onPressed: () {
              // Nav to budget setup
              _showBudgetEditDialog(context, ref, activeMY.year, activeMY.month, dashState?.monthSummary.budgetPaise ?? 2500000);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardStateProvider);
          ref.invalidate(overallBalancesProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Month Switcher Bar
              _buildMonthSwitcher(context, ref, activeMY),
              const SizedBox(height: 16),

              // 2. Hero Gradient Budget Card
              if (dashState != null)
                _buildHeroBudgetCard(dashState.monthSummary)
              else
                _buildLoadingCard(),
              const SizedBox(height: 16),

              // 3. KPI Chips Row (Safe Daily Spend, Friends To Receive, etc.)
              if (dashState != null)
                _buildKpiChipsGrid(dashState.monthSummary, toReceive, toPay, dashState.daysUnderSafeDailySpendCount, context),
              const SizedBox(height: 22),

              // 4. Category Limits & Breakdown Section
              if (dashState != null && dashState.categorySummaries.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'CATEGORY LIMITS & STATUS',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.8),
                    ),
                    Text('${dashState.categorySummaries.length} Categories', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
                const SizedBox(height: 10),
                ...dashState.categorySummaries.map((cat) => _buildCategoryCard(cat)),
                const SizedBox(height: 22),
              ],

              // 5. Visual Charts (Donut + Daily Trend)
              if (dashState != null && dashState.categorySummaries.any((c) => c.spentPaise > 0)) ...[
                const Text(
                  'SPENDING INSIGHTS',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.8),
                ),
                const SizedBox(height: 10),
                _buildCategoryDonutChart(dashState.categorySummaries),
                const SizedBox(height: 22),
              ],

              // 6. Savings Goal Card
              if (goals.isNotEmpty) ...[
                const Text(
                  'SAVINGS GOALS MILESTONES',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.8),
                ),
                const SizedBox(height: 10),
                _buildSavingsGoalCard(goals.first),
                const SizedBox(height: 22),
              ],

              // 7. Top 5 Biggest Expenses
              if (dashState != null && dashState.top5Expenses.isNotEmpty) ...[
                const Text(
                  'TOP BIGGEST EXPENSES THIS MONTH 🔥',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.8),
                ),
                const SizedBox(height: 10),
                ...dashState.top5Expenses.map((exp) => _buildTopExpenseTile(exp)),
                const SizedBox(height: 22),
              ],

              // 8. Recent Transactions
              if (dashState != null && dashState.recentExpenses.isNotEmpty) ...[
                const Text(
                  'RECENT TRANSACTIONS',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.8),
                ),
                const SizedBox(height: 10),
                ...dashState.recentExpenses.take(5).map((exp) => _buildRecentExpenseTile(exp)),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseModal(context),
        backgroundColor: AppConstants.primaryBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Expense', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // WIDGET BUILDERS
  // --------------------------------------------------------------------------

  Widget _buildMonthSwitcher(BuildContext context, WidgetRef ref, ActiveMonthYear activeMY) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF1E293B)),
            onPressed: () {
              ref.read(activeMonthYearProvider.notifier).state = activeMY.previousMonth();
            },
          ),
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF0D9488)),
              const SizedBox(width: 8),
              Text(
                activeMY.displayName,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded, color: Color(0xFF1E293B)),
            onPressed: () {
              ref.read(activeMonthYearProvider.notifier).state = activeMY.nextMonth();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBudgetCard(MonthBudgetSummary summary) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A365D), Color(0xFF0D9488)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D9488).withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Column: Remaining & Spent
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'REMAINING BALANCE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.8),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CurrencyFormatter.formatPaise(summary.remainingBalancePaise),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _miniMetric('Budget', CurrencyFormatter.formatPaise(summary.totalBudgetAvailablePaise)),
                        const SizedBox(width: 16),
                        _miniMetric('Spent', CurrencyFormatter.formatPaise(summary.totalPersonalSpentPaise)),
                      ],
                    ),
                  ],
                ),
              ),

              // Right: Animated Circular Progress Ring
              AnimatedProgressRing(
                percentage: summary.percentageUsed,
                size: 96,
                strokeWidth: 9,
                centerWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(summary.percentageUsed * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'used',
                      style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.75))),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
      ],
    );
  }

  Widget _buildKpiChipsGrid(MonthBudgetSummary summary, int toReceive, int toPay, int streakDays, BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _kpiCard(
                'SAFE DAILY SPEND',
                CurrencyFormatter.formatPaise(summary.safeDailySpendPaise),
                '${summary.daysLeftInMonth} days left',
                const Color(0xFF0D9488),
                Icons.security_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _kpiCard(
                'AVG DAILY SPEND',
                CurrencyFormatter.formatPaise(summary.averageDailySpendPaise),
                '${summary.daysElapsedInMonth} days elapsed',
                const Color(0xFF3B82F6),
                Icons.trending_up_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WhoOwesWhomScreen())),
                borderRadius: BorderRadius.circular(18),
                child: _kpiCard(
                  'FRIENDS OWE ME',
                  CurrencyFormatter.formatPaise(toReceive),
                  'Tap for hisab',
                  const Color(0xFF10B981),
                  Icons.arrow_downward_rounded,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WhoOwesWhomScreen())),
                borderRadius: BorderRadius.circular(18),
                child: _kpiCard(
                  'I NEED TO PAY',
                  CurrencyFormatter.formatPaise(toPay),
                  'Pending debts',
                  const Color(0xFFEF4444),
                  Icons.arrow_upward_rounded,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _kpiCard(String label, String value, String sub, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
              Icon(icon, size: 14, color: color),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w800, color: color),
          ),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(CategoryBudgetSummary cat) {
    Color statusColor;
    String statusText;
    if (cat.status == CategoryStatus.ok) {
      statusColor = const Color(0xFF10B981);
      statusText = 'OK';
    } else if (cat.status == CategoryStatus.nearLimit) {
      statusColor = const Color(0xFFF59E0B);
      statusText = 'NEAR LIMIT';
    } else {
      statusColor = const Color(0xFFEF4444);
      statusText = 'OVER LIMIT';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Text(cat.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cat.categoryName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text(
                        'Limit: ${CurrencyFormatter.formatPaise(cat.limitPaise)}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CurrencyFormatter.formatPaise(cat.spentPaise),
                      style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: statusColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: cat.percentageUsed.clamp(0.0, 1.0),
                backgroundColor: const Color(0xFFF1F5F9),
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDonutChart(List<CategoryBudgetSummary> categories) {
    final activeCategories = categories.where((c) => c.spentPaise > 0).toList();
    if (activeCategories.isEmpty) return const SizedBox.shrink();

    final totalSpent = activeCategories.fold<int>(0, (sum, c) => sum + c.spentPaise);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 46,
                sections: activeCategories.map((c) {
                  final pct = (c.spentPaise / totalSpent) * 100;
                  final color = Color(int.parse(c.colorHex.replaceFirst('#', '0xFF')));
                  return PieChartSectionData(
                    color: color,
                    value: c.spentPaise.toDouble(),
                    title: '${pct.toStringAsFixed(0)}%',
                    radius: 32,
                    titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: activeCategories.map((c) {
              final color = Color(int.parse(c.colorHex.replaceFirst('#', '0xFF')));
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(radius: 4, backgroundColor: color),
                  const SizedBox(width: 4),
                  Text('${c.emoji} ${c.categoryName}', style: const TextStyle(fontSize: 10, color: Color(0xFF475569))),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsGoalCard(dynamic goal) {
    final target = goal.targetPaise as int;
    final saved = goal.savedPaise as int;
    final progress = target > 0 ? (saved / target).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF5FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9D5FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(goal.emoji.toString(), style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(goal.name.toString(), style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF6B21A8))),
                ],
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}% Saved',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF9333EA)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFF3E8FF),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF9333EA)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Saved: ${CurrencyFormatter.formatPaise(saved)}', style: const TextStyle(fontSize: 11, color: Color(0xFF6B21A8))),
              Text('Target: ${CurrencyFormatter.formatPaise(target)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF6B21A8))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopExpenseTile(dynamic exp) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        dense: true,
        leading: const Icon(Icons.local_fire_department_rounded, color: Color(0xFFF97316)),
        title: Text(exp.whereSpent.toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(DateFormatter.formatDate(exp.date)),
        trailing: Text(
          CurrencyFormatter.formatPaise(exp.amountPaise),
          style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, color: Color(0xFFEF4444)),
        ),
      ),
    );
  }

  Widget _buildRecentExpenseTile(dynamic exp) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        dense: true,
        title: Text(exp.whereSpent.toString(), style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text('${DateFormatter.formatShortDate(exp.date)} • ${exp.paymentMode}'),
        trailing: Text(
          CurrencyFormatter.formatPaise(exp.amountPaise),
          style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  void _showBudgetEditDialog(BuildContext context, WidgetRef ref, int year, int month, int currentBudgetPaise) {
    final controller = TextEditingController(text: (currentBudgetPaise / 100.0).toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Edit ${DateFormatter.getMonthName(month)} Budget'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Pocket Money / Salary (₹)',
              prefixText: '₹ ',
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final amt = CurrencyFormatter.parseToPaise(controller.text);
                if (amt != null && amt > 0) {
                  final repo = ref.read(repositoryProvider);
                  await repo.setMonthlyBudget(year: year, month: month, amountPaise: amt);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
