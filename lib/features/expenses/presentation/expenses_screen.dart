import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/database/app_database.dart';
import '../../../data/providers/app_providers.dart';
import 'add_edit_expense_sheet.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  final _searchController = TextEditingController();
  int? _selectedCategoryFilter;
  String? _selectedPaymentModeFilter;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddExpenseModal(BuildContext context, [Expense? existing]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditExpenseSheet(existingExpense: existing),
    );
  }

  Future<void> _deleteExpenseWithUndo(Expense expense) async {
    final repo = ref.read(repositoryProvider);
    await repo.deleteExpense(expense.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted "${expense.whereSpent}"'),
          action: SnackBarAction(
            label: 'UNDO',
            textColor: AppColors.tealLight,
            onPressed: () async {
              await repo.insertExpense(expense.toCompanion(false));
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeMY = ref.watch(activeMonthYearProvider);
    final expensesAsync = ref.watch(activeMonthlyExpensesStreamProvider);
    final categoriesAsync = ref.watch(activeCategoriesStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final allExpenses = expensesAsync.value ?? [];
    final categories = categoriesAsync.value ?? [];
    final catMap = {for (final c in categories) c.id: c};

    // Filter expenses
    final filteredExpenses = allExpenses.where((e) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchWhere = e.whereSpent.toLowerCase().contains(query);
        final matchNote = (e.note ?? '').toLowerCase().contains(query);
        if (!matchWhere && !matchNote) return false;
      }
      if (_selectedCategoryFilter != null &&
          e.categoryId != _selectedCategoryFilter) {
        return false;
      }
      if (_selectedPaymentModeFilter != null &&
          e.paymentMode != _selectedPaymentModeFilter) {
        return false;
      }
      return true;
    }).toList();

    // Group expenses by Date
    final Map<String, List<Expense>> grouped = {};
    for (final exp in filteredExpenses) {
      final dateKey = DateFormatter.formatFullDate(exp.date);
      grouped.putIfAbsent(dateKey, () => []).add(exp);
    }

    final totalFilteredSpent = filteredExpenses.fold<int>(
      0,
      (sum, e) => sum + e.amountPaise,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses (${activeMY.displayName})'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.calendar, size: 20),
            tooltip: 'Select Month',
            onPressed: () => _showMonthPicker(context, isDark),
          ),
          IconButton(
            icon: const Icon(LucideIcons.plus, size: 20),
            tooltip: 'Log Expense',
            onPressed: () => _showAddExpenseModal(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search expenses by description or note...',
                prefixIcon: const Icon(LucideIcons.search, size: 18),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(LucideIcons.x, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
            ),
          ),

          // Horizontal Filter Chips
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              children: [
                FilterChip(
                  label: const Text('All Categories'),
                  selected: _selectedCategoryFilter == null,
                  onSelected: (_) =>
                      setState(() => _selectedCategoryFilter = null),
                  selectedColor: AppColors.emerald,
                  labelStyle: TextStyle(
                    color: _selectedCategoryFilter == null
                        ? Colors.white
                        : (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textSecondaryLight),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ...categories.map((cat) {
                  final isSel = _selectedCategoryFilter == cat.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text('${cat.emoji} ${cat.name}'),
                      selected: isSel,
                      onSelected: (_) => setState(
                        () => _selectedCategoryFilter = isSel ? null : cat.id,
                      ),
                      selectedColor: AppColors.emerald,
                      labelStyle: TextStyle(
                        color: isSel
                            ? Colors.white
                            : (isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textSecondaryLight),
                        fontSize: 12,
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
                }),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Total Filtered Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredExpenses.length} Transactions',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutralSlate,
                  ),
                ),
                Text(
                  'Total: ${CurrencyFormatter.formatPaise(totalFilteredSpent)}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 12,
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),

          // Grouped Expense List
          Expanded(
            child: filteredExpenses.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.emerald.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.receiptText,
                              size: 44,
                              color: AppColors.emerald,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'No Expenses Found',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'No expenses logged matching the current filter.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.neutralSlate,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton.icon(
                            onPressed: () => _showAddExpenseModal(context),
                            icon: const Icon(LucideIcons.plus, size: 16),
                            label: const Text('Log Expense'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    itemCount: grouped.length,
                    itemBuilder: (context, groupIndex) {
                      final dateKey = grouped.keys.elementAt(groupIndex);
                      final dayExpenses = grouped[dateKey]!;
                      final dayTotal = dayExpenses.fold<int>(
                        0,
                        (sum, e) => sum + e.amountPaise,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Header with Day Total
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 4,
                              top: 12,
                              bottom: 6,
                              right: 4,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dateKey,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.neutralSlate,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  CurrencyFormatter.formatPaise(dayTotal),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Expense Items in this Day
                          ...dayExpenses.map((expense) {
                            final cat = catMap[expense.categoryId];
                            return Dismissible(
                              key: ValueKey('exp_${expense.id}'),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: AppColors.dangerRed,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  LucideIcons.trash2,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              onDismissed: (_) =>
                                  _deleteExpenseWithUndo(expense),
                              child: Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 4,
                                  ),
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: cat != null
                                        ? Color(
                                            int.parse(
                                              cat.colorHex.replaceFirst(
                                                '#',
                                                '0xFF',
                                              ),
                                            ),
                                          ).withValues(alpha: 0.15)
                                        : const Color(0xFFF1F5F9),
                                    child: Text(
                                      cat?.emoji ?? '💸',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  title: Text(
                                    expense.whereSpent,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${cat?.name ?? "General"} • ${expense.paymentMode}${expense.note != null && expense.note!.isNotEmpty ? " • ${expense.note}" : ""}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.neutralSlate,
                                    ),
                                  ),
                                  trailing: Text(
                                    CurrencyFormatter.formatPaise(
                                      expense.amountPaise,
                                    ),
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () =>
                                      _showAddExpenseModal(context, expense),
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
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
                'Select Active Month',
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
}
