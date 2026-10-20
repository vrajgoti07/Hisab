import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/database/app_database.dart';
import '../../../data/providers/app_providers.dart';
import '../services/excel_export_service.dart';
import '../services/pdf_export_service.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeMY = ref.watch(activeMonthYearProvider);
    final dashStateAsync = ref.watch(dashboardStateProvider);
    final overallBalancesAsync = ref.watch(overallBalancesProvider);
    final expensesAsync = ref.watch(activeMonthlyExpensesStreamProvider);
    final appSettingsAsync = ref.watch(appSettingsStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dashState = dashStateAsync.value;
    final balances = overallBalancesAsync.value;
    final expenses = expensesAsync.value ?? [];
    final studentName = appSettingsAsync.value?.userName ?? 'Student';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Audit'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.emerald,
          labelColor: isDark ? AppColors.tealLight : AppColors.emerald,
          unselectedLabelColor: AppColors.neutralSlate,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: 'Monthly Parent Audit'),
            Tab(text: 'Yearly Overview (12-Mo)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: Monthly Parent Audit
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month Selector
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.fileText,
                            size: 18,
                            color: AppColors.emerald,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Report for: ${activeMY.displayName}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        icon: const Icon(LucideIcons.calendar, size: 16),
                        label: const Text('Change'),
                        onPressed: () => _showMonthPicker(context, isDark),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Report Preview Card
                if (dashState != null && balances != null)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'MONTHLY AUDIT SUMMARY',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.emeraldDark,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.safeGreen.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'AUDITED',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.safeGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 20,
                          color: isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight,
                        ),
                        _previewRow('Student Name:', studentName),
                        _previewRow(
                          'Total Monthly Budget:',
                          CurrencyFormatter.formatPaise(
                            dashState.monthSummary.totalBudgetAvailablePaise,
                          ),
                        ),
                        _previewRow(
                          'Total Expenses Logged:',
                          CurrencyFormatter.formatPaise(
                            dashState.monthSummary.totalPersonalSpentPaise,
                          ),
                          isRed: true,
                        ),
                        _previewRow(
                          'Unspent Savings:',
                          CurrencyFormatter.formatPaise(
                            dashState.monthSummary.remainingBalancePaise,
                          ),
                          isGreen: true,
                        ),
                        _previewRow(
                          'Budget Consumption:',
                          '${(dashState.monthSummary.percentageUsed * 100).toStringAsFixed(1)}%',
                        ),
                        _previewRow(
                          'Pending from Friends:',
                          CurrencyFormatter.formatPaise(
                            balances.totalToReceivePaise,
                          ),
                        ),
                        _previewRow(
                          'Total Transactions:',
                          '${expenses.length} entries',
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),

                // Export Actions Grid
                const Text(
                  'EXPORT & SHARING OPTIONS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutralSlate,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),

                // 1. Primary Hero: Hisab Statement PDF (The Best Format)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (dashState != null && balances != null) {
                        _exportHisabStatementPdf(
                          context,
                          studentName,
                          activeMY,
                          dashState,
                          balances,
                          expenses,
                        );
                      }
                    },
                    icon: const Icon(
                      LucideIcons.receiptText,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Export Hisab Statement (PDF)',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emerald,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    // Parent Audit Report (PDF)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (dashState != null && balances != null) {
                            _exportParentAuditPdf(
                              context,
                              studentName,
                              activeMY,
                              dashState,
                              balances,
                              expenses,
                            );
                          }
                        },
                        icon: const Icon(
                          LucideIcons.fileCheck2,
                          size: 18,
                          color: AppColors.teal,
                        ),
                        label: const Text(
                          'Parent Report (PDF)',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.teal,
                            fontSize: 12,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Print / Direct Preview (PDF)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (dashState != null && balances != null) {
                            _shareHisabPdf(
                              context,
                              studentName,
                              activeMY,
                              dashState,
                              balances,
                              expenses,
                            );
                          }
                        },
                        icon: const Icon(
                          LucideIcons.share2,
                          size: 18,
                          color: AppColors.safeGreen,
                        ),
                        label: const Text(
                          'Share / Save (PDF)',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.safeGreen,
                            fontSize: 12,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Excel (.xlsx) option
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (dashState != null && balances != null) {
                        _exportExcel(
                          context,
                          studentName,
                          activeMY,
                          dashState,
                          balances,
                          expenses,
                        );
                      }
                    },
                    icon: const Icon(
                      LucideIcons.fileSpreadsheet,
                      size: 18,
                      color: AppColors.neutralSlate,
                    ),
                    label: const Text(
                      'Download Excel Spreadsheet (.xlsx)',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutralSlate,
                        fontSize: 12,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // TAB 2: Yearly Overview (12 Months Comparison)
          _buildYearlyOverviewTab(ref, activeMY.year, isDark),
        ],
      ),
    );
  }

  Widget _previewRow(
    String label,
    String value, {
    bool isRed = false,
    bool isGreen = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.neutralSlate),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: isRed
                  ? AppColors.dangerRed
                  : (isGreen ? AppColors.safeGreen : null),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearlyOverviewTab(WidgetRef ref, int year, bool isDark) {
    final repo = ref.watch(repositoryProvider);

    return FutureBuilder<List<MonthlyBudget>>(
      future: repo.getYearlyBudgets(year),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.emerald),
          );
        }

        final budgets = snapshot.data ?? [];
        final budgetMap = {for (final b in budgets) b.month: b.amountPaise};

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: 12,
          itemBuilder: (context, index) {
            final month = index + 1;
            final mName = DateFormatter.getMonthName(month);
            final budget = budgetMap[month] ?? 2500000;

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(
                  mName,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  'Budget: ${CurrencyFormatter.formatPaise(budget)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.neutralSlate,
                  ),
                ),
                trailing: const Icon(LucideIcons.chevronRight, size: 18),
                onTap: () {
                  ref.read(activeMonthYearProvider.notifier).state =
                      ActiveMonthYear(year: year, month: month);
                  _tabController.animateTo(0);
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showMonthPicker(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Month for Audit Report',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(12, (index) {
                  final m = index + 1;
                  final currentMY = ref.read(activeMonthYearProvider);
                  final isSel = currentMY.month == m;
                  return ChoiceChip(
                    label: Text(DateFormatter.getMonthName(m)),
                    selected: isSel,
                    onSelected: (_) {
                      ref.read(activeMonthYearProvider.notifier).state =
                          currentMY.copyWith(month: m);
                      Navigator.of(context).pop();
                    },
                    selectedColor: AppColors.emerald,
                    labelStyle: TextStyle(
                      color: isSel
                          ? Colors.white
                          : (isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textSecondaryLight),
                      fontSize: 12,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _exportHisabStatementPdf(
    BuildContext context,
    String studentName,
    ActiveMonthYear activeMY,
    dynamic dashState,
    dynamic balances,
    List<Expense> expenses,
  ) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preparing Hisab Statement PDF...'),
          duration: Duration(seconds: 1),
        ),
      );
      await PdfExportService.layoutItemizedHisab(
        studentName: studentName,
        year: activeMY.year,
        month: activeMY.month,
        summary: dashState.monthSummary,
        categories: dashState.categorySummaries,
        expenses: expenses,
        friendsBalances: balances,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not generate Hisab PDF: $e'),
            backgroundColor: AppColors.dangerRed,
          ),
        );
      }
    }
  }

  Future<void> _exportParentAuditPdf(
    BuildContext context,
    String studentName,
    ActiveMonthYear activeMY,
    dynamic dashState,
    dynamic balances,
    List<Expense> expenses,
  ) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preparing Parent Audit PDF...'),
          duration: Duration(seconds: 1),
        ),
      );
      await PdfExportService.layoutMonthlyReport(
        studentName: studentName,
        year: activeMY.year,
        month: activeMY.month,
        summary: dashState.monthSummary,
        categories: dashState.categorySummaries,
        expenses: expenses,
        friendsBalances: balances,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not generate Parent PDF: $e'),
            backgroundColor: AppColors.dangerRed,
          ),
        );
      }
    }
  }

  Future<void> _shareHisabPdf(
    BuildContext context,
    String studentName,
    ActiveMonthYear activeMY,
    dynamic dashState,
    dynamic balances,
    List<Expense> expenses,
  ) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preparing Hisab Statement to share...'),
          duration: Duration(seconds: 1),
        ),
      );
      await PdfExportService.printOrShareItemizedHisab(
        studentName: studentName,
        year: activeMY.year,
        month: activeMY.month,
        summary: dashState.monthSummary,
        categories: dashState.categorySummaries,
        expenses: expenses,
        friendsBalances: balances,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not share Hisab Statement: $e'),
            backgroundColor: AppColors.dangerRed,
          ),
        );
      }
    }
  }

  Future<void> _exportExcel(
    BuildContext context,
    String studentName,
    ActiveMonthYear activeMY,
    dynamic dashState,
    dynamic balances,
    List<Expense> expenses,
  ) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Generating Excel workbook...'),
          duration: Duration(seconds: 1),
        ),
      );
      await ExcelExportService.exportMonthlyExcel(
        studentName: studentName,
        year: activeMY.year,
        month: activeMY.month,
        summary: dashState.monthSummary,
        categories: dashState.categorySummaries,
        expenses: expenses,
        friendsBalances: balances,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not export Excel: $e'),
            backgroundColor: AppColors.dangerRed,
          ),
        );
      }
    }
  }
}
