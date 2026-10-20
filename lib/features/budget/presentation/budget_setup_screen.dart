import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/database/app_database.dart';
import '../../../data/providers/app_providers.dart';

class BudgetSetupScreen extends ConsumerStatefulWidget {
  const BudgetSetupScreen({super.key});

  @override
  ConsumerState<BudgetSetupScreen> createState() => _BudgetSetupScreenState();
}

class _BudgetSetupScreenState extends ConsumerState<BudgetSetupScreen> {
  late TextEditingController _budgetController;
  bool _carryForward = true;

  @override
  void initState() {
    super.initState();
    _budgetController = TextEditingController();
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _showEditCategoryDialog(BuildContext context, Category cat) {
    final limitController = TextEditingController(
      text: (cat.monthlyLimitPaise / 100.0).toStringAsFixed(0),
    );
    final nameController = TextEditingController(text: cat.name);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Edit ${cat.emoji} ${cat.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: limitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly Limit (₹)',
                  prefixText: '₹ ',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newLimit = CurrencyFormatter.parseToPaise(
                  limitController.text,
                );
                if (newLimit != null && newLimit > 0) {
                  final repo = ref.read(repositoryProvider);
                  await repo.updateCategory(
                    cat.copyWith(
                      name: nameController.text.trim(),
                      monthlyLimitPaise: newLimit,
                    ),
                  );
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

  @override
  Widget build(BuildContext context) {
    final activeMY = ref.watch(activeMonthYearProvider);
    final budgetAsync = ref.watch(activeMonthlyBudgetStreamProvider);
    final categoriesAsync = ref.watch(activeCategoriesStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final budget = budgetAsync.value;
    final categories = categoriesAsync.value ?? [];

    if (_budgetController.text.isEmpty && budget != null) {
      _budgetController.text = (budget.amountPaise / 100.0).toStringAsFixed(0);
      _carryForward = budget.carryForward;
    } else if (_budgetController.text.isEmpty && budget == null) {
      _budgetController.text = '25000';
    }

    final totalLimitsPaise = categories.fold<int>(
      0,
      (sum, c) => sum + c.monthlyLimitPaise,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Budget & Category Setup')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Selector Header
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'POCKET MONEY / SALARY FOR ${activeMY.displayName.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutralSlate,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
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
                          controller: _budgetController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            fillColor: Colors.transparent,
                            filled: false,
                            contentPadding: EdgeInsets.zero,
                            hintText: '25,000',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final amt = CurrencyFormatter.parseToPaise(
                            _budgetController.text,
                          );
                          if (amt != null && amt > 0) {
                            final repo = ref.read(repositoryProvider);
                            await repo.setMonthlyBudget(
                              year: activeMY.year,
                              month: activeMY.month,
                              amountPaise: amt,
                              carryForward: _carryForward,
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Monthly budget updated! 💼'),
                                  backgroundColor: AppColors.emerald,
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emerald,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                  Divider(
                    height: 20,
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                  Material(
                    type: MaterialType.transparency,
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _carryForward,
                      onChanged: (val) => setState(() => _carryForward = val),
                      title: const Text(
                        'Carry forward unspent balance to next month',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      activeThumbColor: AppColors.emerald,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Category Limits Summary Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CATEGORY ALLOCATIONS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutralSlate,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  'Total: ${CurrencyFormatter.formatPaise(totalLimitsPaise)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.emerald,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Category Limit Cards
            ...categories.map((cat) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Text(
                    cat.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    cat.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Monthly Limit: ${CurrencyFormatter.formatPaise(cat.monthlyLimitPaise)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.neutralSlate,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      LucideIcons.pencil,
                      size: 18,
                      color: AppColors.emerald,
                    ),
                    tooltip: 'Edit category limit',
                    onPressed: () => _showEditCategoryDialog(context, cat),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
