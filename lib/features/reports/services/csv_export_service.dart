import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/database/app_database.dart';

class CsvExportService {
  /// Exports monthly expenses as a CSV file and opens the share sheet
  static Future<void> exportExpensesCsv({
    required int year,
    required int month,
    required List<Expense> expenses,
    required List<Category> categories,
  }) async {
    final catMap = {for (final c in categories) c.id: c.name};

    final List<List<dynamic>> rows = [
      [
        'Date',
        'Category',
        'Description',
        'Amount (INR)',
        'Payment Mode',
        'Notes',
      ],
    ];

    for (final e in expenses) {
      rows.add([
        DateFormatter.formatDate(e.date),
        catMap[e.categoryId] ?? 'General',
        e.whereSpent,
        CurrencyFormatter.paiseToRupees(e.amountPaise),
        e.paymentMode,
        e.note ?? '',
      ]);
    }

    final csvString = const ListToCsvConverter().convert(rows);
    final dir = await getTemporaryDirectory();
    final monthName = DateFormatter.getMonthName(month);
    final file = File('${dir.path}/PocketPlan_Expenses_${monthName}_$year.csv');
    await file.writeAsString(csvString);
    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'PocketPlan Expenses CSV ($monthName $year)');
  }
}
