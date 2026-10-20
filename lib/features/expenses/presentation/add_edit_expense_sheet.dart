import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/database/app_database.dart';
import '../../../data/providers/app_providers.dart';
import '../../split/presentation/add_split_expense_screen.dart';

class AddEditExpenseSheet extends ConsumerStatefulWidget {
  final Expense? existingExpense;

  const AddEditExpenseSheet({super.key, this.existingExpense});

  @override
  ConsumerState<AddEditExpenseSheet> createState() =>
      _AddEditExpenseSheetState();
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
      text: e != null
          ? (e.amountPaise / 100.0).toStringAsFixed(
              e.amountPaise % 100 == 0 ? 0 : 2,
            )
          : '',
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
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String? _getCategoryLimitWarning(
    List<Category> categories,
    DashboardState? dashState,
  ) {
    if (_selectedCategoryId == null || dashState == null) return null;
    final enteredPaise =
        CurrencyFormatter.parseToPaise(_amountController.text) ?? 0;
    if (enteredPaise <= 0) return null;

    final catSummary = dashState.categorySummaries.firstWhere(
      (c) => c.categoryId == _selectedCategoryId,
      orElse: () => dashState.categorySummaries.first,
    );

    final projectedSpent = catSummary.spentPaise + enteredPaise;
    if (projectedSpent > catSummary.limitPaise) {
      final overBy = projectedSpent - catSummary.limitPaise;
      return 'Warning: This will exceed ${catSummary.categoryName} monthly limit by ${CurrencyFormatter.formatPaise(overBy)}!';
    }
    return null;
  }

  Future<void> _saveExpense() async {
    final amountPaise = CurrencyFormatter.parseToPaise(_amountController.text);
    if (amountPaise == null || amountPaise <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount greater than ₹0.'),
        ),
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
          note: drift.Value(
            _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
          ),
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
          note: drift.Value(
            _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
          ),
        ),
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.existingExpense != null
                ? 'Expense updated!'
                : 'Expense saved successfully!',
          ),
          backgroundColor: AppColors.emerald,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(activeCategoriesStreamProvider);
    final dashStateAsync = ref.watch(dashboardStateProvider);
    final whereSpentSuggestionsAsync = ref.watch(distinctWhereSpentProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categories = categoriesAsync.value ?? [];
    if (_selectedCategoryId == null && categories.isNotEmpty) {
      _selectedCategoryId = categories.first.id;
    }

    final warningMessage = _getCategoryLimitWarning(
      categories,
      dashStateAsync.value,
    );

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
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
                  color: isDark
                      ? AppColors.borderDark
                      : const Color(0xFFCBD5E1),
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
                  widget.existingExpense != null
                      ? 'Edit Expense'
                      : 'Log Daily Expense',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Amount Input Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    '₹',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.emerald,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: const InputDecoration(
                        hintText: '0.00',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        fillColor: Colors.transparent,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warningAmber.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.warningAmber.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.triangleAlert,
                      color: AppColors.warningAmber,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        warningMessage,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warningAmber,
                        ),
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
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.neutralSlate,
                letterSpacing: 0.8,
              ),
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
                    selectedColor: AppColors.emerald,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textSecondaryLight),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      fontSize: 12,
                    ),
                    backgroundColor: isDark
                        ? AppColors.cardDark
                        : const Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.emerald
                            : (isDark
                                  ? AppColors.borderDark
                                  : AppColors.borderLight),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Where Spent (Autocomplete)
            const Text(
              'WHERE SPENT / DESCRIPTION',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.neutralSlate,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 6),
            RawAutocomplete<String>(
              textEditingController: _whereSpentController,
              focusNode: FocusNode(),
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                final list = whereSpentSuggestionsAsync.value ?? [];
                return list.where((option) {
                  return option.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  );
                });
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        hintText:
                            'e.g. Canteen Lunch, Metro Recharge, Decathlon',
                        prefixIcon: Icon(LucideIcons.store, size: 18),
                      ),
                    );
                  },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    color: isDark ? AppColors.cardDark : Colors.white,
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
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutralSlate,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.cardDark
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.borderDark
                                  : AppColors.borderLight,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                LucideIcons.calendar,
                                size: 18,
                                color: AppColors.emerald,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  DateFormatter.formatShortDate(_selectedDate),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
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
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutralSlate,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.cardDark
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedPaymentMode,
                            dropdownColor: isDark
                                ? AppColors.cardDark
                                : Colors.white,
                            items: AppConstants.defaultPaymentModes.map((mode) {
                              return DropdownMenuItem(
                                value: mode,
                                child: Text(
                                  mode,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedPaymentMode = val);
                              }
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
              decoration: const InputDecoration(
                hintText: 'Notes (e.g. Canteen treat, urgent stationery)',
                prefixIcon: Icon(LucideIcons.stickyNote, size: 18),
              ),
            ),
            const SizedBox(height: 14),

            // Toggle Split with Friends
            if (widget.existingExpense == null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.cardDark
                      : AppColors.teal.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.teal.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.users,
                      color: AppColors.teal,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Split this with friends?',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: AppColors.teal,
                            ),
                          ),
                          Text(
                            'Divide the bill and track who owes you',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.neutralSlate,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _splitWithFriends,
                      activeThumbColor: AppColors.teal,
                      onChanged: (val) =>
                          setState(() => _splitWithFriends = val),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _splitWithFriends
                      ? AppColors.teal
                      : AppColors.emerald,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _splitWithFriends ? 'Continue to Split Bill' : 'Save Expense',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
