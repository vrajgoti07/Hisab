import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
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
                decoration: const InputDecoration(labelText: 'Monthly Limit (₹)', prefixText: '₹ '),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final newLimit = CurrencyFormatter.parseToPaise(limitController.text);
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

    final budget = budgetAsync.value;
    final categories = categoriesAsync.value ?? [];

    if (_budgetController.text.isEmpty && budget != null) {
      _budgetController.text = (budget.amountPaise / 100.0).toStringAsFixed(0);
      _carryForward = budget.carryForward;
    } else if (_budgetController.text.isEmpty && budget == null) {
      _budgetController.text = '25000';
    }

    final totalLimitsPaise = categories.fold<int>(0, (sum, c) => sum + c.monthlyLimitPaise);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Budget & Category Setup'),
        backgroundColor: const Color(0xFFF6F7FB),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Selector Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'POCKET MONEY / SALARY FOR ${activeMY.displayName.toUpperCase()}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('₹', style: TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFF1A365D))),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _budgetController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 30, fontWeight: FontWeight.w700),
                          decoration: const InputDecoration(border: InputBorder.none, hintText: '25,000'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final amt = CurrencyFormatter.parseToPaise(_budgetController.text);
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
                                const SnackBar(content: Text('Monthly budget updated! 💼'), backgroundColor: Color(0xFF0D9488)),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppConstants.primaryBlue),
                        child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _carryForward,
                    onChanged: (val) => setState(() => _carryForward = val),
                    title: const Text('Carry forward unspent balance to next month', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    activeThumbColor: const Color(0xFF0D9488),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Category Limits Summary Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('CATEGORY ALLOCATIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.8)),
                Text('Total: ${CurrencyFormatter.formatPaise(totalLimitsPaise)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0D9488))),
              ],
            ),
            const SizedBox(height: 10),

            // Category Limit Cards
            ...categories.map((cat) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: ListTile(
                  leading: Text(cat.emoji, style: const TextStyle(fontSize: 24)),
                  title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Monthly Limit: ${CurrencyFormatter.formatPaise(cat.monthlyLimitPaise)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20, color: Color(0xFF0D9488)),
                    onPressed: () => _showEditCategoryDialog(context, cat),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
