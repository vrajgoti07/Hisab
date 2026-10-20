import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/database/app_database.dart';
import '../../../data/providers/app_providers.dart';

class RecordSettlementDialog extends ConsumerStatefulWidget {
  final int? defaultSenderPersonId;
  final int? defaultReceiverPersonId;
  final int? defaultAmountPaise;

  const RecordSettlementDialog({
    super.key,
    this.defaultSenderPersonId,
    this.defaultReceiverPersonId,
    this.defaultAmountPaise,
  });

  @override
  ConsumerState<RecordSettlementDialog> createState() =>
      _RecordSettlementDialogState();
}

class _RecordSettlementDialogState
    extends ConsumerState<RecordSettlementDialog> {
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late DateTime _selectedDate;
  int? _fromPersonId; // null = 'Me'
  int? _toPersonId; // null = 'Me'
  String _mode = 'UPI / GPay / PhonePe';

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.defaultAmountPaise != null
          ? (widget.defaultAmountPaise! / 100.0).toStringAsFixed(
              widget.defaultAmountPaise! % 100 == 0 ? 0 : 2,
            )
          : '',
    );
    _noteController = TextEditingController();
    _selectedDate = DateTime.now();
    _fromPersonId = widget.defaultSenderPersonId;
    _toPersonId = widget.defaultReceiverPersonId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveSettlement() async {
    final amountPaise = CurrencyFormatter.parseToPaise(_amountController.text);
    if (amountPaise == null || amountPaise <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid repayment amount.')),
      );
      return;
    }

    if (_fromPersonId == _toPersonId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sender and receiver cannot be the same person.'),
        ),
      );
      return;
    }

    final repo = ref.read(repositoryProvider);
    await repo.insertSettlement(
      SettlementsCompanion.insert(
        date: _selectedDate,
        fromPersonId: drift.Value(_fromPersonId),
        toPersonId: drift.Value(_toPersonId),
        amountPaise: amountPaise,
        mode: drift.Value(_mode),
        note: drift.Value(
          _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        ),
      ),
    );

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Settlement of ${CurrencyFormatter.formatPaise(amountPaise)} recorded! 🎉',
          ),
          backgroundColor: AppColors.emerald,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final personsAsync = ref.watch(activePersonsStreamProvider);
    final persons = personsAsync.value ?? [];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_fromPersonId == null && _toPersonId == null && persons.isNotEmpty) {
      _fromPersonId = persons.first.id;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.emerald.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.handCoins,
                          size: 18,
                          color: AppColors.emerald,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Record Settlement',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Amount Input
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      '₹',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 28,
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
                          fontSize: 26,
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
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Sender (Who Paid)
              const Text(
                'WHO PAID? (SENDER)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutralSlate,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<int?>(
                initialValue: _fromPersonId,
                dropdownColor: isDark ? AppColors.cardDark : Colors.white,
                items: [
                  const DropdownMenuItem(value: null, child: Text('Me')),
                  ...persons.map(
                    (p) => DropdownMenuItem(value: p.id, child: Text(p.name)),
                  ),
                ],
                onChanged: (val) => setState(() => _fromPersonId = val),
              ),
              const SizedBox(height: 12),

              // Receiver (Paid To)
              const Text(
                'PAID TO? (RECEIVER)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutralSlate,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<int?>(
                initialValue: _toPersonId,
                dropdownColor: isDark ? AppColors.cardDark : Colors.white,
                items: [
                  const DropdownMenuItem(value: null, child: Text('Me')),
                  ...persons.map(
                    (p) => DropdownMenuItem(value: p.id, child: Text(p.name)),
                  ),
                ],
                onChanged: (val) => setState(() => _toPersonId = val),
              ),
              const SizedBox(height: 12),

              // Payment Mode
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
              DropdownButtonFormField<String>(
                initialValue: _mode,
                dropdownColor: isDark ? AppColors.cardDark : Colors.white,
                items: ['UPI / GPay / PhonePe', 'Cash', 'Bank Transfer'].map((
                  m,
                ) {
                  return DropdownMenuItem(value: m, child: Text(m));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _mode = val);
                },
              ),
              const SizedBox(height: 12),

              // Note
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: 'Notes (e.g. Cleared GPay for dinner)',
                  prefixIcon: Icon(LucideIcons.stickyNote, size: 18),
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveSettlement,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Record Settlement',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
