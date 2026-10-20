import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/database/app_database.dart';
import '../../../data/providers/app_providers.dart';
import '../../split/presentation/add_split_expense_screen.dart';

class AddEditExpenseSheet extends ConsumerStatefulWidget {
  final Expense? existingExpense;

  const AddEditExpenseSheet({super.key, this.existingExpense});

  @override
  ConsumerState<AddEditExpenseSheet> createState() => _AddEditExpenseSheetState();
}

class _AddEditExpenseSheetState extends ConsumerState<AddEditExpenseSheet> {
  late TextEditingController _amountController;
  late TextEditingController _whereSpentController;
  late TextEditingController _noteController;

  late DateTime _selectedDate;
  int? _selectedCategoryId;
  String _selectedPaymentMode = 'UPI / GPay / PhonePe';
  bool _splitWithFriends = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existingExpense;
    _amountController = TextEditingController(
      text: e != null ? (e.amountPaise / 100.0).toStringAsFixed(e.amountPaise % 100 == 0 ? 0 : 2) : '',
    );
    _whereSpentController = TextEditingController(text: e?.whereSpent ?? '');
    _noteController = TextEditingController(text: e?.note ?? '');
    _selectedDate = e?.date ?? DateTime.now();
    _selectedCategoryId = e?.categoryId;
    _selectedPaymentMode = e?.paymentMode ?? 'UPI / GPay / PhonePe';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _whereSpentController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onCategorySelected(int categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppConstants.primaryBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: const Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String? _getCategoryLimitWarning(List<Category> categories, DashboardState? dashState) {
    if (_selectedCategoryId == null || dashState == null) return null;
    final enteredPaise = CurrencyFormatter.parseToPaise(_amountController.text) ?? 0;
    if (enteredPaise <= 0) return null;

    final catSummary = dashState.categorySummaries.firstWhere(
      (c) => c.categoryId == _selectedCategoryId,
      orElse: () => dashState.categorySummaries.first,
    );

    final projectedSpent = catSummary.spentPaise + enteredPaise;
    if (projectedSpent > catSummary.limitPaise) {
      final overBy = projectedSpent - catSummary.limitPaise;
      return '⚠️ Warning: This will exceed ${catSummary.categoryName} monthly limit by ${CurrencyFormatter.formatPaise(overBy)}!';
    }
    return null;
  }

  Future<void> _saveExpense() async {
    final amountPaise = CurrencyFormatter.parseToPaise(_amountController.text);
    if (amountPaise == null || amountPaise <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount greater than ₹0.')),
      );
      return;
    }

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category.')),
      );
      return;
    }

    final whereSpent = _whereSpentController.text.trim();
    if (whereSpent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter where this was spent.')),
      );
      return;
    }

    // If split with friends toggle is enabled, switch to AddSplitExpenseScreen
    if (_splitWithFriends) {
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AddSplitExpenseScreen(
            initialTitle: whereSpent,
            initialTotalPaise: amountPaise,
            initialDate: _selectedDate,
            initialCategoryId: _selectedCategoryId,
          ),
        ),
      );
      return;
    }

    final repo = ref.read(repositoryProvider);
    if (widget.existingExpense != null) {
      await repo.updateExpense(
        widget.existingExpense!.copyWith(
          date: _selectedDate,
          categoryId: _selectedCategoryId!,
          whereSpent: whereSpent,
          amountPaise: amountPaise,
          paymentMode: _selectedPaymentMode,
          note: drift.Value(_noteController.text.trim().isEmpty ? null : _noteController.text.trim()),
        ),
      );
    } else {
      await repo.insertExpense(
        ExpensesCompanion.insert(
          date: _selectedDate,
          categoryId: _selectedCategoryId!,
          whereSpent: whereSpent,
          amountPaise: amountPaise,
          paymentMode: _selectedPaymentMode,
          note: drift.Value(_noteController.text.trim().isEmpty ? null : _noteController.text.trim()),
        ),
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.existingExpense != null ? 'Expense updated!' : 'Expense saved successfully!'),
          backgroundColor: const Color(0xFF0D9488),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(activeCategoriesStreamProvider);
    final dashStateAsync = ref.watch(dashboardStateProvider);
    final whereSpentSuggestionsAsync = ref.watch(distinctWhereSpentProvider);

    final categories = categoriesAsync.value ?? [];
    if (_selectedCategoryId == null && categories.isNotEmpty) {
      _selectedCategoryId = categories.first.id;
    }

    final warningMessage = _getCategoryLimitWarning(categories, dashStateAsync.value);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.existingExpense != null ? 'Edit Expense' : 'Log Daily Expense',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Amount Input Card with Hero Rupee feel
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Text(
                    '₹',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A365D),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                      decoration: const InputDecoration(
                        hintText: '0.00',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
            ),

            // Instant Limit Warning Box
            if (warningMessage != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFCD34D)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Color(0xFFB45309), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        warningMessage,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF92400E)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Category Chips (Horizontal Scrolling)
            const Text(
              'CATEGORY',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.8),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = _selectedCategoryId == cat.id;
                  return ChoiceChip(
                    label: Text('${cat.emoji} ${cat.name}'),
                    selected: isSelected,
                    onSelected: (_) => _onCategorySelected(cat.id),
                    selectedColor: AppConstants.primaryBlue,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF334155),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 12,
                    ),
                    backgroundColor: const Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(
                      color: isSelected ? AppConstants.primaryBlue : const Color(0xFFE2E8F0),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Where Spent (Autocomplete)
            const Text(
              'WHERE SPENT / DESCRIPTION',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.8),
            ),
            const SizedBox(height: 6),
            RawAutocomplete<String>(
              textEditingController: _whereSpentController,
              focusNode: FocusNode(),
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
                final list = whereSpentSuggestionsAsync.value ?? [];
                return list.where((option) {
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'e.g. Canteen Lunch, Metro Recharge, Decathlon',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    prefixIcon: const Icon(Icons.storefront_outlined, size: 20, color: Color(0xFF64748B)),
                  ),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return ListTile(
                            dense: true,
                            title: Text(option),
                            onTap: () => onSelected(option),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Date and Payment Mode Row
            Row(
              children: [
                // Date Picker Button
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DATE',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded, size: 18, color: Color(0xFF0D9488)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  DateFormatter.formatShortDate(_selectedDate),
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Payment Mode Dropdown
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PAYMENT MODE',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedPaymentMode,
                            items: AppConstants.defaultPaymentModes.map((mode) {
                              return DropdownMenuItem(
                                value: mode,
                                child: Text(mode, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedPaymentMode = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Note (Optional)
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Notes (e.g. Treat for friends, urgent)',
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                prefixIcon: const Icon(Icons.sticky_note_2_outlined, size: 18, color: Color(0xFF64748B)),
              ),
            ),
            const SizedBox(height: 14),

            // Toggle Split with Friends
            if (widget.existingExpense == null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.people_outline, color: Color(0xFF16A34A)),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Split this with friends?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF15803D))),
                          Text('Divide the bill and track who owes you', style: TextStyle(fontSize: 11, color: Color(0xFF166534))),
                        ],
                      ),
                    ),
                    Switch(
                      value: _splitWithFriends,
                      activeThumbColor: const Color(0xFF16A34A),
                      onChanged: (val) => setState(() => _splitWithFriends = val),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 18),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _splitWithFriends ? const Color(0xFF0D9488) : AppConstants.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  _splitWithFriends ? 'Continue to Split Friends 👥' : 'Save Expense 💾',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
