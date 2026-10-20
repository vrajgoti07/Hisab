import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/database/app_database.dart';
import '../../../data/providers/app_providers.dart';
import '../services/csv_export_service.dart';
import '../services/excel_export_service.dart';
import '../services/pdf_export_service.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> with SingleTickerProviderStateMixin {
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
    final categoriesAsync = ref.watch(activeCategoriesStreamProvider);
    final appSettingsAsync = ref.watch(appSettingsStreamProvider);

    final dashState = dashStateAsync.value;
    final balances = overallBalancesAsync.value;
    final expenses = expensesAsync.value ?? [];
    final categories = categoriesAsync.value ?? [];
    final studentName = appSettingsAsync.value?.userName ?? 'Student';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Reports & Audit'),
        backgroundColor: const Color(0xFFF6F7FB),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppConstants.primaryBlue,
          labelColor: AppConstants.primaryBlue,
          unselectedLabelColor: const Color(0xFF64748B),
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month Selector
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.description_outlined, color: Color(0xFF0D9488)),
                          const SizedBox(width: 8),
                          Text(
                            'Report for: ${activeMY.displayName}',
                            style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.tune, size: 16),
                        label: const Text('Change Month'),
                        onPressed: () => _showMonthPicker(context),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('MONTHLY SUMMARY', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A365D))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(8)),
                              child: const Text('AUDITED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        _previewRow('Student Name:', studentName),
                        _previewRow('Total Pocket Money:', CurrencyFormatter.formatPaise(dashState.monthSummary.totalBudgetAvailablePaise)),
                        _previewRow('Total Expenses Logged:', CurrencyFormatter.formatPaise(dashState.monthSummary.totalPersonalSpentPaise), isRed: true),
                        _previewRow('Unspent Savings:', CurrencyFormatter.formatPaise(dashState.monthSummary.remainingBalancePaise), isGreen: true),
                        _previewRow('Budget Consumption:', '${(dashState.monthSummary.percentageUsed * 100).toStringAsFixed(1)}%'),
                        _previewRow('Pending from Friends:', CurrencyFormatter.formatPaise(balances.totalToReceivePaise)),
                        _previewRow('Total Transactions:', '${expenses.length} entries'),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),

                // Export Actions Grid
                const Text('EXPORT & SHARING OPTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                const SizedBox(height: 10),

                // PDF Button (Hero)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (dashState != null && balances != null) {
                        PdfExportService.printOrShareMonthlyReport(
                          studentName: studentName,
                          year: activeMY.year,
                          month: activeMY.month,
                          summary: dashState.monthSummary,
                          categories: dashState.categorySummaries,
                          expenses: expenses,
                          friendsBalances: balances,
                        );
                      }
                    },
                    icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
                    label: const Text('Export Official PDF (A4 Parent Report)', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A365D),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    // Excel (.xlsx)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (dashState != null && balances != null) {
                            ExcelExportService.exportMonthlyExcel(
                              studentName: studentName,
                              year: activeMY.year,
                              month: activeMY.month,
                              summary: dashState.monthSummary,
                              categories: dashState.categorySummaries,
                              expenses: expenses,
                              friendsBalances: balances,
                            );
                          }
                        },
                        icon: const Icon(Icons.table_view_rounded, size: 18, color: Color(0xFF15803D)),
                        label: const Text('Excel (.xlsx)', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF15803D), fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          side: const BorderSide(color: Color(0xFF86EFAC)),
                          backgroundColor: const Color(0xFFF0FDF4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // CSV
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          CsvExportService.exportExpensesCsv(
                            year: activeMY.year,
                            month: activeMY.month,
                            expenses: expenses,
                            categories: categories,
                          );
                        },
                        icon: const Icon(Icons.file_download_outlined, size: 18, color: Color(0xFF0D9488)),
                        label: const Text('CSV Export', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0D9488), fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          side: const BorderSide(color: Color(0xFF99F6E4)),
                          backgroundColor: const Color(0xFFF0FDFA),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // TAB 2: Yearly Overview (12 Months Comparison)
          _buildYearlyOverviewTab(ref, activeMY.year),
        ],
      ),
    );
  }

  Widget _previewRow(String label, String value, {bool isRed = false, bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: isRed ? const Color(0xFFEF4444) : (isGreen ? const Color(0xFF10B981) : const Color(0xFF0F172A)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearlyOverviewTab(WidgetRef ref, int year) {
    final repo = ref.watch(repositoryProvider);

    return FutureBuilder<List<MonthlyBudget>>(
      future: repo.getYearlyBudgets(year),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
                title: Text(mName, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text('Budget: ${CurrencyFormatter.formatPaise(budget)}'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  ref.read(activeMonthYearProvider.notifier).state = ActiveMonthYear(year: year, month: month);
                  _tabController.animateTo(0);
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showMonthPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select Month for Audit Report', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
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
                      ref.read(activeMonthYearProvider.notifier).state = currentMY.copyWith(month: m);
                      Navigator.of(context).pop();
                    },
                    selectedColor: AppConstants.primaryBlue,
                    labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF334155), fontSize: 12),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
