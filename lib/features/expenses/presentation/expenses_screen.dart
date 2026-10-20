import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
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
            textColor: Colors.amber,
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
      if (_selectedCategoryFilter != null && e.categoryId != _selectedCategoryFilter) {
        return false;
      }
      if (_selectedPaymentModeFilter != null && e.paymentMode != _selectedPaymentModeFilter) {
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

    final totalFilteredSpent = filteredExpenses.fold<int>(0, (sum, e) => sum + e.amountPaise);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text('Expenses (${activeMY.displayName})'),
        backgroundColor: const Color(0xFFF6F7FB),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            tooltip: 'Change Month',
            onPressed: () {
              // Month Switcher popup
              _showMonthPicker(context);
            },
          ),
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
                hintText: 'Search expenses by name or note...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF94A3B8)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
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

          // Horizontal Filter Chips (Categories & Payment Modes)
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              children: [
                FilterChip(
                  label: const Text('All Categories'),
                  selected: _selectedCategoryFilter == null,
                  onSelected: (_) => setState(() => _selectedCategoryFilter = null),
                  selectedColor: AppConstants.primaryBlue,
                  labelStyle: TextStyle(
                    color: _selectedCategoryFilter == null ? Colors.white : const Color(0xFF334155),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(width: 6),
                ...categories.map((cat) {
                  final isSel = _selectedCategoryFilter == cat.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text('${cat.emoji} ${cat.name}'),
                      selected: isSel,
                      onSelected: (_) => setState(() => _selectedCategoryFilter = isSel ? null : cat.id),
                      selectedColor: AppConstants.primaryBlue,
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : const Color(0xFF334155),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                Text('${filteredExpenses.length} Transactions', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                Text(
                  'Total: ${CurrencyFormatter.formatPaise(totalFilteredSpent)}',
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                ),
              ],
            ),
          ),
          const Divider(height: 12),

          // Grouped Expense List
          Expanded(
            child: filteredExpenses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.receipt_long_outlined, size: 54, color: Color(0xFF94A3B8)),
                        const SizedBox(height: 10),
                        const Text('No expenses found', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text('Tap "+" to log your first expense of the month.', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _showAddExpenseModal(context),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text('Add Expense', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(backgroundColor: AppConstants.primaryBlue),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    itemCount: grouped.length,
                    itemBuilder: (context, groupIndex) {
                      final dateKey = grouped.keys.elementAt(groupIndex);
                      final dayExpenses = grouped[dateKey]!;
                      final dayTotal = dayExpenses.fold<int>(0, (sum, e) => sum + e.amountPaise);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Header with Day Total
                          Padding(
                            padding: const EdgeInsets.only(left: 4, top: 12, bottom: 6, right: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dateKey,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5),
                                ),
                                Text(
                                  CurrencyFormatter.formatPaise(dayTotal),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
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
                                  color: const Color(0xFFEF4444),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                              ),
                              onDismissed: (_) => _deleteExpenseWithUndo(expense),
                              child: Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: cat != null
                                        ? Color(int.parse(cat.colorHex.replaceFirst('#', '0xFF'))).withValues(alpha: 0.15)
                                        : const Color(0xFFF1F5F9),
                                    child: Text(cat?.emoji ?? '💸', style: const TextStyle(fontSize: 18)),
                                  ),
                                  title: Text(expense.whereSpent, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                  subtitle: Text(
                                    '${cat?.name ?? "General"} • ${expense.paymentMode}${expense.note != null && expense.note!.isNotEmpty ? " • ${expense.note}" : ""}',
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                  ),
                                  trailing: Text(
                                    CurrencyFormatter.formatPaise(expense.amountPaise),
                                    style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF0F172A)),
                                  ),
                                  onTap: () => _showAddExpenseModal(context, expense),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseModal(context),
        backgroundColor: AppConstants.primaryBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Expense', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
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
              const Text('Select Active Month', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700)),
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
