import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/providers/app_providers.dart';
import '../../../domain/services/budget_status_calculator.dart';
import '../../../widgets/app_animated_ring.dart';
import '../../budget/presentation/budget_setup_screen.dart';
import '../../expenses/presentation/add_edit_expense_sheet.dart';
import '../../split/presentation/add_split_expense_screen.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dashState = dashStateAsync.value;
    final balances = overallBalancesAsync.value;

    final toReceive = balances?.totalToReceivePaise ?? 0;
    final toPay = balances?.totalToPayPaise ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.emerald.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                LucideIcons.wallet,
                size: 20,
                color: AppColors.emerald,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Hisab',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.emeraldDark,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.slidersHorizontal, size: 20),
            tooltip: 'Configure Budget & Limits',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BudgetSetupScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.emerald,
        onRefresh: () async {
          ref.invalidate(dashboardStateProvider);
          ref.invalidate(overallBalancesProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 4,
            bottom: 90,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Month Switcher Bar
              _buildMonthSwitcher(context, ref, activeMY, isDark),
              const SizedBox(height: 16),

              // 2. Hero Budget Card
              if (dashState != null)
                _buildHeroBudgetCard(dashState.monthSummary, isDark)
              else if (dashStateAsync.isLoading)
                _buildLoadingCard(isDark)
              else
                _buildErrorCard(
                  context,
                  ref,
                  dashStateAsync.error?.toString(),
                  isDark,
                ),
              const SizedBox(height: 16),

              // 3. Quick Actions Row
              _buildQuickActionsRow(context, isDark),
              const SizedBox(height: 18),

              // 4. Financial KPI Chips Grid
              if (dashState != null)
                _buildKpiChipsGrid(
                  dashState.monthSummary,
                  toReceive,
                  toPay,
                  context,
                  isDark,
                ),
              const SizedBox(height: 24),

              // 5. Category Limits & Status
              if (dashState != null &&
                  dashState.categorySummaries.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'CATEGORY LIMITS & STATUS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.neutralSlate,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      '${dashState.categorySummaries.length} Categories',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.neutralSlate,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...dashState.categorySummaries.map(
                  (cat) => _buildCategoryCard(cat, isDark),
                ),
                const SizedBox(height: 24),
              ],

              // 6. Visual Spending Donut Chart
              if (dashState != null &&
                  dashState.categorySummaries.any((c) => c.spentPaise > 0)) ...[
                const Text(
                  'CATEGORY SPEND BREAKDOWN',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutralSlate,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),
                _buildCategoryDonutChart(dashState.categorySummaries, isDark),
                const SizedBox(height: 24),
              ],

              // 7. Top 5 Expenses
              if (dashState != null && dashState.top5Expenses.isNotEmpty) ...[
                const Text(
                  'TOP EXPENSES THIS MONTH 🔥',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutralSlate,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),
                ...dashState.top5Expenses.map(
                  (exp) => _buildTopExpenseTile(exp, isDark),
                ),
                const SizedBox(height: 24),
              ],

              // 8. Recent Transactions
              if (dashState != null && dashState.recentExpenses.isNotEmpty) ...[
                const Text(
                  'RECENT TRANSACTIONS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutralSlate,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),
                ...dashState.recentExpenses
                    .take(5)
                    .map((exp) => _buildRecentExpenseTile(exp, isDark)),
              ] else if (dashState != null &&
                  dashState.recentExpenses.isEmpty) ...[
                _buildEmptyExpensesState(context, isDark),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // WIDGET BUILDERS
  // --------------------------------------------------------------------------

  Widget _buildMonthSwitcher(
    BuildContext context,
    WidgetRef ref,
    ActiveMonthYear activeMY,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            tooltip: 'Previous month',
            icon: const Icon(LucideIcons.chevronLeft, size: 20),
            onPressed: () {
              ref.read(activeMonthYearProvider.notifier).state = activeMY
                  .previousMonth();
            },
          ),
          Row(
            children: [
              const Icon(
                LucideIcons.calendar,
                size: 16,
                color: AppColors.emerald,
              ),
              const SizedBox(width: 8),
              Text(
                activeMY.displayName,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          IconButton(
            tooltip: 'Next month',
            icon: const Icon(LucideIcons.chevronRight, size: 20),
            onPressed: () {
              ref.read(activeMonthYearProvider.notifier).state = activeMY
                  .nextMonth();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBudgetCard(MonthBudgetSummary summary, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.emeraldGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.emerald.withValues(alpha: 0.28),
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
              // Left: Remaining Balance
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
                      CurrencyFormatter.formatPaise(
                        summary.remainingBalancePaise,
                      ),
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
                        _miniMetric(
                          'Total Budget',
                          CurrencyFormatter.formatPaise(
                            summary.totalBudgetAvailablePaise,
                          ),
                        ),
                        const SizedBox(width: 16),
                        _miniMetric(
                          'Spent',
                          CurrencyFormatter.formatPaise(
                            summary.totalPersonalSpentPaise,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Right: Animated Progress Ring
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
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
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
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
        const SizedBox(height: 2),
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

  Widget _buildQuickActionsRow(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _quickActionButton(
            label: 'Add Expense',
            icon: LucideIcons.plus,
            color: AppColors.emerald,
            isDark: isDark,
            onTap: () => _showAddExpenseModal(context),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _quickActionButton(
            label: 'Split Bill',
            icon: LucideIcons.split,
            color: AppColors.teal,
            isDark: isDark,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AddSplitExpenseScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _quickActionButton(
            label: 'Who Owes',
            icon: LucideIcons.users,
            color: AppColors.accent,
            isDark: isDark,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WhoOwesWhomScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _quickActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiChipsGrid(
    MonthBudgetSummary summary,
    int toReceive,
    int toPay,
    BuildContext context,
    bool isDark,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _kpiCard(
                'SAFE DAILY SPEND',
                CurrencyFormatter.formatPaise(summary.safeDailySpendPaise),
                '${summary.daysLeftInMonth} days left',
                AppColors.emerald,
                LucideIcons.shieldCheck,
                isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _kpiCard(
                'AVG DAILY SPEND',
                CurrencyFormatter.formatPaise(summary.averageDailySpendPaise),
                '${summary.daysElapsedInMonth} days elapsed',
                AppColors.accent,
                LucideIcons.trendingDown,
                isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const WhoOwesWhomScreen()),
                ),
                borderRadius: BorderRadius.circular(18),
                child: _kpiCard(
                  'FRIENDS OWE ME',
                  CurrencyFormatter.formatPaise(toReceive),
                  'Tap for hisab',
                  AppColors.safeGreen,
                  LucideIcons.arrowDownLeft,
                  isDark,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const WhoOwesWhomScreen()),
                ),
                borderRadius: BorderRadius.circular(18),
                child: _kpiCard(
                  'I NEED TO PAY',
                  CurrencyFormatter.formatPaise(toPay),
                  'Pending debts',
                  AppColors.dangerRed,
                  LucideIcons.arrowUpRight,
                  isDark,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _kpiCard(
    String label,
    String value,
    String sub,
    Color color,
    IconData icon,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutralSlate,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Icon(icon, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: TextStyle(
              fontSize: 10,
              color: isDark
                  ? AppColors.textMutedDark
                  : AppColors.textMutedLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(CategoryBudgetSummary cat, bool isDark) {
    Color statusColor;
    String statusText;
    if (cat.status == CategoryStatus.ok) {
      statusColor = AppColors.safeGreen;
      statusText = 'OK';
    } else if (cat.status == CategoryStatus.nearLimit) {
      statusColor = AppColors.warningAmber;
      statusText = 'NEAR LIMIT';
    } else {
      statusColor = AppColors.dangerRed;
      statusText = 'OVER LIMIT';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
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
                      Text(
                        cat.categoryName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Limit: ${CurrencyFormatter.formatPaise(cat.limitPaise)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.neutralSlate,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CurrencyFormatter.formatPaise(cat.spentPaise),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
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
                backgroundColor: isDark
                    ? AppColors.surfaceDark
                    : const Color(0xFFF1F5F9),
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDonutChart(
    List<CategoryBudgetSummary> categories,
    bool isDark,
  ) {
    final activeCategories = categories.where((c) => c.spentPaise > 0).toList();
    if (activeCategories.isEmpty) return const SizedBox.shrink();

    final totalSpent = activeCategories.fold<int>(
      0,
      (sum, c) => sum + c.spentPaise,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 44,
                sections: activeCategories.map((c) {
                  final pct = (c.spentPaise / totalSpent) * 100;
                  final color = Color(
                    int.parse(c.colorHex.replaceFirst('#', '0xFF')),
                  );
                  return PieChartSectionData(
                    color: color,
                    value: c.spentPaise.toDouble(),
                    title: '${pct.toStringAsFixed(0)}%',
                    radius: 30,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
              final color = Color(
                int.parse(c.colorHex.replaceFirst('#', '0xFF')),
              );
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(radius: 4, backgroundColor: color),
                  const SizedBox(width: 4),
                  Text(
                    '${c.emoji} ${c.categoryName}',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopExpenseTile(dynamic exp, bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        dense: true,
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.warningAmber.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            LucideIcons.flame,
            size: 16,
            color: AppColors.warningAmber,
          ),
        ),
        title: Text(
          exp.whereSpent.toString(),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(DateFormatter.formatDate(exp.date)),
        trailing: Text(
          CurrencyFormatter.formatPaise(exp.amountPaise),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            color: AppColors.dangerRed,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentExpenseTile(dynamic exp, bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        dense: true,
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.emerald.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            LucideIcons.receipt,
            size: 16,
            color: AppColors.emerald,
          ),
        ),
        title: Text(
          exp.whereSpent.toString(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '${DateFormatter.formatShortDate(exp.date)} • ${exp.paymentMode}',
        ),
        trailing: Text(
          CurrencyFormatter.formatPaise(exp.amountPaise),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyExpensesState(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.emerald.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.receiptText,
              size: 32,
              color: AppColors.emerald,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'No Expenses Logged Yet',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Keep your budget intact by logging what you spend daily.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.neutralSlate),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showAddExpenseModal(context),
            icon: const Icon(LucideIcons.plus, size: 16),
            label: const Text('Log First Expense'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(bool isDark) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.emerald),
      ),
    );
  }

  Widget _buildErrorCard(
    BuildContext context,
    WidgetRef ref,
    String? error,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.dangerRed.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.circleAlert, color: AppColors.dangerRed),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Unable to load dashboard data:\n${error ?? 'Unknown error'}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          TextButton(
            onPressed: () => ref.invalidate(dashboardStateProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
