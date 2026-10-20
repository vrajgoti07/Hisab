import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/database/app_database.dart';
import '../../../domain/services/balance_calculator.dart';
import '../../../domain/services/budget_status_calculator.dart';

class PdfExportService {
  /// Generates a parent-friendly, print-ready A4 PDF report
  static Future<Uint8List> generateMonthlyReportPdf({
    required String studentName,
    required int year,
    required int month,
    required MonthBudgetSummary summary,
    required List<CategoryBudgetSummary> categories,
    required List<Expense> expenses,
    required OverallBalancesResult friendsBalances,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.interRegular();
    final fontBold = await PdfGoogleFonts.interBold();
    final fontHeading = await PdfGoogleFonts.poppinsBold();

    final monthName = DateFormatter.getMonthName(month);
    final reportTitle = 'Student Monthly Budget & Expense Audit Report';
    final generatedDate = DateFormatter.formatDate(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        header: (context) => _buildHeader(fontHeading, reportTitle, studentName, monthName, year, generatedDate),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          pw.SizedBox(height: 16),
          // 1. Executive Summary Box
          _buildSummaryBox(summary),
          pw.SizedBox(height: 18),

          // 2. Category Breakdown Table
          pw.Text('Category-Wise Limit vs Actual Spending', style: pw.TextStyle(font: fontHeading, fontSize: 13, color: PdfColors.blue900)),
          pw.SizedBox(height: 6),
          _buildCategoryTable(categories),
          pw.SizedBox(height: 18),

          // 3. Friends & Shared Hisab Transparency Section
          pw.Text('Friends & Shared Splits (Separated from Personal Expenses)', style: pw.TextStyle(font: fontHeading, fontSize: 13, color: PdfColors.teal900)),
          pw.SizedBox(height: 6),
          _buildFriendsSection(friendsBalances),
          pw.SizedBox(height: 18),

          // 4. Detailed Expense Log Table
          pw.Text('Itemised Expense Transaction Log ($monthName $year)', style: pw.TextStyle(font: fontHeading, fontSize: 13, color: PdfColors.blue900)),
          pw.SizedBox(height: 6),
          _buildExpensesTable(expenses),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(pw.Font fontHeading, String title, String name, String month, int year, String genDate) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue900, width: 2)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('POCKETPLAN', style: pw.TextStyle(font: fontHeading, fontSize: 18, color: PdfColors.blue900)),
              pw.Text(title, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('Student: $name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.Text('Period: $month $year  |  Date: $genDate', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryBox(MonthBudgetSummary summary) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _summaryCardItem('Pocket Money / Budget', CurrencyFormatter.formatPaise(summary.totalBudgetAvailablePaise), PdfColors.blue900),
          _summaryCardItem('Total Spent', CurrencyFormatter.formatPaise(summary.totalPersonalSpentPaise), PdfColors.red800),
          _summaryCardItem('Saved / Remaining', CurrencyFormatter.formatPaise(summary.remainingBalancePaise), PdfColors.green800),
          _summaryCardItem('% Utilised', '${(summary.percentageUsed * 100).toStringAsFixed(1)}%', PdfColors.indigo900),
        ],
      ),
    );
  }

  static pw.Widget _summaryCardItem(String label, String value, PdfColor valueColor) {
    return pw.Column(
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
        pw.SizedBox(height: 3),
        pw.Text(value, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: valueColor)),
      ],
    );
  }

  static pw.Widget _buildCategoryTable(List<CategoryBudgetSummary> categories) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
      cellStyle: const pw.TextStyle(fontSize: 8),
      cellHeight: 18,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
      },
      headers: ['Category', 'Allocated Limit', 'Actual Spent', 'Remaining', '% Used', 'Status'],
      data: categories.map((cat) {
        final statusText = cat.status == CategoryStatus.ok
            ? 'OK'
            : (cat.status == CategoryStatus.nearLimit ? 'Near Limit' : 'Over Limit');
        return [
          '${cat.emoji} ${cat.categoryName}',
          CurrencyFormatter.formatPaise(cat.limitPaise),
          CurrencyFormatter.formatPaise(cat.spentPaise),
          CurrencyFormatter.formatPaise(cat.remainingPaise),
          '${(cat.percentageUsed * 100).toStringAsFixed(1)}%',
          statusText,
        ];
      }).toList(),
    );
  }

  static pw.Widget _buildFriendsSection(OverallBalancesResult friendsBalances) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.teal50,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.teal200),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          pw.Column(
            children: [
              pw.Text('Money Friends Owe Me (To Receive)', style: const pw.TextStyle(fontSize: 8, color: PdfColors.teal900)),
              pw.SizedBox(height: 2),
              pw.Text(CurrencyFormatter.formatPaise(friendsBalances.totalToReceivePaise), style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.teal800)),
            ],
          ),
          pw.Column(
            children: [
              pw.Text('My Pending Dues to Friends (To Pay)', style: const pw.TextStyle(fontSize: 8, color: PdfColors.teal900)),
              pw.SizedBox(height: 2),
              pw.Text(CurrencyFormatter.formatPaise(friendsBalances.totalToPayPaise), style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.red800)),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildExpensesTable(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text('No expenses recorded for this month.', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
      );
    }

    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
      cellStyle: const pw.TextStyle(fontSize: 8),
      cellHeight: 18,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.center,
        4: pw.Alignment.centerLeft,
      },
      headers: ['Date', 'Where Spent / Description', 'Amount', 'Payment Mode', 'Notes'],
      data: expenses.map((e) => [
            DateFormatter.formatDate(e.date),
            e.whereSpent,
            CurrencyFormatter.formatPaise(e.amountPaise),
            e.paymentMode,
            e.note ?? '-',
          ]).toList(),
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Text(
        'Page ${context.pageNumber} of ${context.pagesCount}',
        style: const pw.TextStyle(color: PdfColors.grey600, fontSize: 8),
      ),
    );
  }

  /// Exports and triggers direct print or PDF share sheet
  static Future<void> printOrShareMonthlyReport({
    required String studentName,
    required int year,
    required int month,
    required MonthBudgetSummary summary,
    required List<CategoryBudgetSummary> categories,
    required List<Expense> expenses,
    required OverallBalancesResult friendsBalances,
  }) async {
    final pdfBytes = await generateMonthlyReportPdf(
      studentName: studentName,
      year: year,
      month: month,
      summary: summary,
      categories: categories,
      expenses: expenses,
      friendsBalances: friendsBalances,
    );

    final fileName = 'PocketPlan_Report_${DateFormatter.getMonthName(month)}_$year.pdf';
    await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
  }

  /// Exports an individual Hisab Statement PDF for a friend
  static Future<void> exportFriendHisabPdf({
    required String friendName,
    required PersonBalanceResult balance,
    required List<SplitExpense> sharedExpenses,
    required List<Settlement> settlements,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.interRegular();
    final fontBold = await PdfGoogleFonts.interBold();
    final fontHeading = await PdfGoogleFonts.poppinsBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        build: (context) => [
          pw.Text('FRIEND HISAB STATEMENT', style: pw.TextStyle(font: fontHeading, fontSize: 18, color: PdfColors.blue900)),
          pw.Text('Shared Account with $friendName', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
          pw.Divider(thickness: 1, color: PdfColors.blue900),
          pw.SizedBox(height: 12),

          // Net Balance Box
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: balance.theyOweMe ? PdfColors.green50 : (balance.iOweThem ? PdfColors.red50 : PdfColors.grey100),
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: balance.theyOweMe ? PdfColors.green300 : (balance.iOweThem ? PdfColors.red300 : PdfColors.grey300)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  balance.theyOweMe
                      ? '$friendName owes you: ${CurrencyFormatter.formatPaise(balance.netBalancePaise)}'
                      : (balance.iOweThem
                          ? 'You owe $friendName: ${CurrencyFormatter.formatPaise(-balance.netBalancePaise)}'
                          : 'All Settled Up! 🎉'),
                  style: pw.TextStyle(font: fontBold, fontSize: 14, color: balance.theyOweMe ? PdfColors.green900 : (balance.iOweThem ? PdfColors.red900 : PdfColors.grey800)),
                ),
                pw.Text('Audited via PocketPlan', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
              ],
            ),
          ),
        ],
      ),
    );

    final bytes = await pdf.save();
    final fileName = 'Hisab_Statement_${friendName.replaceAll(' ', '_')}.pdf';
    await Printing.sharePdf(bytes: bytes, filename: fileName);
  }
}
