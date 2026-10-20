import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/database/app_database.dart';
import '../../../data/providers/app_providers.dart';
import '../../../domain/services/split_calculator.dart';

class AddSplitExpenseScreen extends ConsumerStatefulWidget {
  final String? initialTitle;
  final int? initialTotalPaise;
  final DateTime? initialDate;
  final int? initialCategoryId;

  const AddSplitExpenseScreen({
    super.key,
    this.initialTitle,
    this.initialTotalPaise,
    this.initialDate,
    this.initialCategoryId,
  });

  @override
  ConsumerState<AddSplitExpenseScreen> createState() => _AddSplitExpenseScreenState();
}

class _AddSplitExpenseScreenState extends ConsumerState<AddSplitExpenseScreen> {
  late TextEditingController _titleController;
  late TextEditingController _totalAmountController;
  late TextEditingController _groupController;
  late TextEditingController _noteController;

  late DateTime _selectedDate;
  int? _paidByPersonId; // null = 'Me'
  SplitType _splitType = SplitType.equal;
  bool _syncMyShareToExpenses = true;
  int? _categoryId;

  // Selected participant IDs (null = Me)
  final Set<int?> _selectedParticipantIds = {null};

  // Custom amounts controllers for exact / percentage / shares
  final Map<int?, TextEditingController> _customControllers = {};

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _totalAmountController = TextEditingController(
      text: widget.initialTotalPaise != null
          ? (widget.initialTotalPaise! / 100.0).toStringAsFixed(widget.initialTotalPaise! % 100 == 0 ? 0 : 2)
          : '',
    );
    _groupController = TextEditingController();
    _noteController = TextEditingController();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _categoryId = widget.initialCategoryId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _totalAmountController.dispose();
    _groupController.dispose();
    _noteController.dispose();
    for (final c in _customControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _getCustomController(int? id) {
    if (!_customControllers.containsKey(id)) {
      _customControllers[id] = TextEditingController();
    }
    return _customControllers[id]!;
  }

  SplitCalculationResult _calculatePreview(List<Person> allPersons) {
    final totalPaise = CurrencyFormatter.parseToPaise(_totalAmountController.text) ?? 0;
    if (totalPaise <= 0 || _selectedParticipantIds.isEmpty) {
      return SplitCalculationResult(
        isValid: false,
        shares: const [],
        totalAmountPaise: totalPaise,
        mySharePaise: 0,
        friendsSharePaise: 0,
      );
    }

    final personNameMap = {for (final p in allPersons) p.id: p.name};
    final List<SplitParticipant> participants = [];

    for (final id in _selectedParticipantIds) {
      final name = id == null ? 'Me' : (personNameMap[id] ?? 'Friend #$id');
      final customText = _customControllers[id]?.text.trim() ?? '';

      int? exactPaise;
      double? pct;
      int? shares;

      if (_splitType == SplitType.exact) {
        exactPaise = CurrencyFormatter.parseToPaise(customText);
      } else if (_splitType == SplitType.percentage) {
        pct = double.tryParse(customText);
      } else if (_splitType == SplitType.shares) {
        shares = int.tryParse(customText);
      }

      participants.add(SplitParticipant(
        personId: id,
        name: name,
        exactAmountPaise: exactPaise,
        percentage: pct,
        shareCount: shares,
      ));
    }

    return SplitCalculator.calculate(
      totalAmountPaise: totalPaise,
      splitType: _splitType,
      participants: participants,
    );
  }

  Future<void> _saveSplitExpense(SplitCalculationResult calcResult) async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title for this shared bill.')),
      );
      return;
    }

    if (!calcResult.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(calcResult.errorMessage ?? 'Please check the split amounts.')),
      );
      return;
    }

    final splitId = 'SPL-${const Uuid().v4().substring(0, 8).toUpperCase()}';
    final repo = ref.read(repositoryProvider);

    final expenseCompanion = SplitExpensesCompanion.insert(
      id: splitId,
      date: _selectedDate,
      title: title,
      groupName: drift.Value(_groupController.text.trim().isEmpty ? null : _groupController.text.trim()),
      totalAmountPaise: calcResult.totalAmountPaise,
      paidByPersonId: drift.Value(_paidByPersonId),
      splitType: _splitType.name,
      categoryId: drift.Value(_categoryId),
      note: drift.Value(_noteController.text.trim().isEmpty ? null : _noteController.text.trim()),
    );

    final List<SplitSharesCompanion> shares = calcResult.shares.map((s) {
      return SplitSharesCompanion.insert(
        splitExpenseId: splitId,
        personId: drift.Value(s.personId),
        shareAmountPaise: s.shareAmountPaise,
      );
    }).toList();

    await repo.insertSplitExpense(
      expense: expenseCompanion,
      shares: shares,
      syncMyShareToPersonalExpenses: _syncMyShareToExpenses,
      personalExpenseCategoryId: _categoryId,
    );

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Split expense saved and hisab updated! 🎉'),
          backgroundColor: Color(0xFF0D9488),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final personsAsync = ref.watch(activePersonsStreamProvider);
    final categoriesAsync = ref.watch(activeCategoriesStreamProvider);

    final persons = personsAsync.value ?? [];
    final categories = categoriesAsync.value ?? [];
    if (_categoryId == null && categories.isNotEmpty) {
      _categoryId = categories.first.id;
    }

    // Default: include all persons if not yet initialized
    if (_selectedParticipantIds.length == 1 && persons.isNotEmpty) {
      for (final p in persons) {
        _selectedParticipantIds.add(p.id);
      }
    }

    final calcResult = _calculatePreview(persons);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Split Bill with Friends'),
        backgroundColor: const Color(0xFFF6F7FB),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bill Title & Total Amount Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TOTAL BILL AMOUNT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text('₹', style: TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFF0D9488))),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _totalAmountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.w700),
                          decoration: const InputDecoration(hintText: '0.00', border: InputBorder.none),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title / Description',
                      hintText: 'e.g. Dominos Pizza, Goa Airbnb, Cab ride',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.receipt_long_outlined, color: Color(0xFF0D9488)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Who Paid Row
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
                  const Text('WHO PAID THE BILL?', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int?>(
                    initialValue: _paidByPersonId,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Me (I paid the full amount)')),
                      ...persons.map((p) => DropdownMenuItem(value: p.id, child: Text('${p.name} paid'))),
                    ],
                    onChanged: (val) => setState(() => _paidByPersonId = val),
                  ),
                  const SizedBox(height: 12),
                  // Group Name & Category Row
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _groupController,
                          decoration: InputDecoration(
                            labelText: 'Group / Tag (Optional)',
                            hintText: 'e.g. Goa Trip',
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: _categoryId,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          items: categories.map((c) => DropdownMenuItem(value: c.id, child: Text('${c.emoji} ${c.name}', overflow: TextOverflow.ellipsis))).toList(),
                          onChanged: (val) => setState(() => _categoryId = val),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Split Type Selector
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
                  const Text('SPLIT TYPE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildSplitTypeChip(SplitType.equal, 'Equal (=)'),
                      _buildSplitTypeChip(SplitType.exact, 'Exact (₹)'),
                      _buildSplitTypeChip(SplitType.percentage, 'Percentage (%)'),
                      _buildSplitTypeChip(SplitType.shares, 'Shares (Ratio)'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Participants List & Live Shares Preview
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('PARTICIPANTS & SHARES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                      Text('${_selectedParticipantIds.length} Selected', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0D9488))),
                    ],
                  ),
                  const Divider(height: 18),
                  // Participant Item: Me
                  _buildParticipantRow(null, 'Me (myself)', calcResult),
                  // Friends
                  ...persons.map((p) => _buildParticipantRow(p.id, p.name, calcResult)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Live Balance Impact Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2F6),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('My Personal Share (Counts in Budget):', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text(CurrencyFormatter.formatPaise(calcResult.mySharePaise), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF0D9488))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _paidByPersonId == null ? 'Friends Owe Me (Paid for others):' : 'I Owe Payer:',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                      Text(
                        _paidByPersonId == null ? CurrencyFormatter.formatPaise(calcResult.friendsSharePaise) : CurrencyFormatter.formatPaise(calcResult.mySharePaise),
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: _paidByPersonId == null ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Checkbox: Sync My Share to Personal Expenses
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _syncMyShareToExpenses,
              onChanged: (val) => setState(() => _syncMyShareToExpenses = val ?? true),
              title: const Text('Add only MY share to personal monthly expenses', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              subtitle: const Text('Protects your personal budget from friends\' shares', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              activeColor: const Color(0xFF0D9488),
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => _saveSplitExpense(calcResult),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Save Split & Update Hisab 🍕', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplitTypeChip(SplitType type, String label) {
    final isSelected = _splitType == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _splitType = type),
      selectedColor: const Color(0xFF0D9488),
      labelStyle: TextStyle(color: isSelected ? Colors.white : const Color(0xFF334155), fontSize: 12, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500),
      backgroundColor: const Color(0xFFF1F5F9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildParticipantRow(int? id, String name, SplitCalculationResult calcResult) {
    final isSelected = _selectedParticipantIds.contains(id);
    final calculatedShare = calcResult.shares.firstWhere(
      (s) => s.personId == id,
      orElse: () => CalculatedShare(personId: id, name: name, shareAmountPaise: 0),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            activeColor: const Color(0xFF0D9488),
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  _selectedParticipantIds.add(id);
                } else {
                  if (_selectedParticipantIds.length > 1) {
                    _selectedParticipantIds.remove(id);
                  }
                }
              });
            },
          ),
          Expanded(
            child: Text(
              name,
              style: TextStyle(fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, color: isSelected ? const Color(0xFF0F172A) : Colors.grey),
            ),
          ),
          if (_splitType != SplitType.equal && isSelected) ...[
            SizedBox(
              width: 80,
              height: 36,
              child: TextField(
                controller: _getCustomController(id),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: _splitType == SplitType.percentage ? '%' : (_splitType == SplitType.shares ? 'ratio' : '₹'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            isSelected ? CurrencyFormatter.formatPaise(calculatedShare.shareAmountPaise) : '₹0',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: isSelected ? const Color(0xFF0D9488) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
