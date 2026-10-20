import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/database/app_database.dart';
import '../../../domain/services/balance_calculator.dart';
import '../../../domain/services/budget_status_calculator.dart';

class ExcelExportService {
  /// Generates a multi-sheet .xlsx workbook for the month and shares it
  static Future<void> exportMonthlyExcel({
    required String studentName,
    required int year,
    required int month,
    required MonthBudgetSummary summary,
    required List<CategoryBudgetSummary> categories,
    required List<Expense> expenses,
    required OverallBalancesResult friendsBalances,
  }) async {
    final excel = Excel.createExcel();
    final monthName = DateFormatter.getMonthName(month);

    // 1. Summary Sheet
    final sheetSummary = excel['Summary'];
    excel.setDefaultSheet('Summary');
    sheetSummary.appendRow([TextCellValue('POCKETPLAN - MONTHLY AUDIT REPORT')]);
    sheetSummary.appendRow([TextCellValue('Student: $studentName | Period: $monthName $year')]);
    sheetSummary.appendRow([TextCellValue('')]);
    sheetSummary.appendRow([TextCellValue('Metric'), TextCellValue('Amount (INR)')]);
    sheetSummary.appendRow([TextCellValue('Total Monthly Budget'), DoubleCellValue(CurrencyFormatter.paiseToRupees(summary.totalBudgetAvailablePaise))]);
    sheetSummary.appendRow([TextCellValue('Total Personal Spent'), DoubleCellValue(CurrencyFormatter.paiseToRupees(summary.totalPersonalSpentPaise))]);
    sheetSummary.appendRow([TextCellValue('Remaining Unspent Balance'), DoubleCellValue(CurrencyFormatter.paiseToRupees(summary.remainingBalancePaise))]);
    sheetSummary.appendRow([TextCellValue('Budget Utilisation %'), TextCellValue('${(summary.percentageUsed * 100).toStringAsFixed(1)}%')]);
    sheetSummary.appendRow([TextCellValue('Safe Daily Spend'), DoubleCellValue(CurrencyFormatter.paiseToRupees(summary.safeDailySpendPaise))]);
    sheetSummary.appendRow([TextCellValue('Friends to Receive'), DoubleCellValue(CurrencyFormatter.paiseToRupees(friendsBalances.totalToReceivePaise))]);
    sheetSummary.appendRow([TextCellValue('My Dues to Friends'), DoubleCellValue(CurrencyFormatter.paiseToRupees(friendsBalances.totalToPayPaise))]);

    // 2. Expenses Sheet
    final sheetExpenses = excel['Expenses'];
    sheetExpenses.appendRow([
      TextCellValue('Date'),
      TextCellValue('Description / Where Spent'),
      TextCellValue('Amount (INR)'),
      TextCellValue('Payment Mode'),
      TextCellValue('Notes'),
    ]);
    for (final exp in expenses) {
      sheetExpenses.appendRow([
        TextCellValue(DateFormatter.formatDate(exp.date)),
        TextCellValue(exp.whereSpent),
        DoubleCellValue(CurrencyFormatter.paiseToRupees(exp.amountPaise)),
        TextCellValue(exp.paymentMode),
        TextCellValue(exp.note ?? ''),
      ]);
    }

    // 3. Category Breakdown Sheet
    final sheetCategories = excel['Category Report'];
    sheetCategories.appendRow([
      TextCellValue('Category'),
      TextCellValue('Allocated Limit (INR)'),
      TextCellValue('Actual Spent (INR)'),
      TextCellValue('Remaining (INR)'),
      TextCellValue('% Used'),
      TextCellValue('Status'),
    ]);
    for (final cat in categories) {
      sheetCategories.appendRow([
        TextCellValue('${cat.emoji} ${cat.categoryName}'),
        DoubleCellValue(CurrencyFormatter.paiseToRupees(cat.limitPaise)),
        DoubleCellValue(CurrencyFormatter.paiseToRupees(cat.spentPaise)),
        DoubleCellValue(CurrencyFormatter.paiseToRupees(cat.remainingPaise)),
        TextCellValue('${(cat.percentageUsed * 100).toStringAsFixed(1)}%'),
        TextCellValue(cat.status.name.toUpperCase()),
      ]);
    }

    // 4. Friends Hisab Sheet
    final sheetHisab = excel['Friends Hisab'];
    sheetHisab.appendRow([
      TextCellValue('Friend Name'),
      TextCellValue('They Owe Me (INR)'),
      TextCellValue('I Owe Them (INR)'),
      TextCellValue('Net Balance (INR)'),
      TextCellValue('Status'),
    ]);
    for (final pb in friendsBalances.personBalances) {
      sheetHisab.appendRow([
        TextCellValue(pb.personName),
        DoubleCellValue(CurrencyFormatter.paiseToRupees(pb.totalTheyOweMePaise)),
        DoubleCellValue(CurrencyFormatter.paiseToRupees(pb.totalIOweThemPaise)),
        DoubleCellValue(CurrencyFormatter.paiseToRupees(pb.netBalancePaise)),
        TextCellValue(pb.theyOweMe ? 'Owes Me' : (pb.iOweThem ? 'I Owe' : 'Settled')),
      ]);
    }

    // Remove default Sheet1
    excel.delete('Sheet1');

    // Save and Share
    final fileBytes = excel.save();
    if (fileBytes != null) {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/PocketPlan_${monthName}_$year.xlsx');
      await file.writeAsBytes(fileBytes);
      await Share.shareXFiles([XFile(file.path)], text: 'PocketPlan Monthly Excel Report ($monthName $year)');
    }
  }
}
