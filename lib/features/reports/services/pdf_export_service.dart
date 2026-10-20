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
  static const _emeraldPrimary = PdfColor.fromInt(0xFF0F5132);
  static const _tealAccent = PdfColor.fromInt(0xFF0D9488);
  static const _slateDark = PdfColor.fromInt(0xFF1E293B);
  static const _mintBackground = PdfColor.fromInt(0xFFF1F8F5);
  static const _mintBorder = PdfColor.fromInt(0xFFC7E2D6);

  static Future<({pw.Font font, pw.Font fontBold, pw.Font fontHeading})>
  _loadFonts() async {
    try {
      final font = await PdfGoogleFonts.interRegular();
      final fontBold = await PdfGoogleFonts.interBold();
      final fontHeading = await PdfGoogleFonts.poppinsBold();
      return (font: font, fontBold: fontBold, fontHeading: fontHeading);
    } catch (_) {
      return (
        font: pw.Font.helvetica(),
        fontBold: pw.Font.helveticaBold(),
        fontHeading: pw.Font.helveticaBold(),
      );
    }
  }

  // =========================================================================
  // 1. HISAB EXPENSE STATEMENT (BEST HISAB FORMAT)
  // =========================================================================

  /// Generates a clean, comprehensive Hisab Expense Statement PDF
  static Future<Uint8List> generateItemizedHisabPdf({
    required String studentName,
    required int year,
    required int month,
    required MonthBudgetSummary summary,
    required List<CategoryBudgetSummary> categories,
    required List<Expense> expenses,
    required OverallBalancesResult friendsBalances,
  }) async {
    final pdf = pw.Document();
    final fonts = await _loadFonts();
    final monthName = DateFormatter.getMonthName(month);
    final generatedDate = DateFormatter.formatDate(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        theme: pw.ThemeData.withFont(base: fonts.font, bold: fonts.fontBold),
        header: (context) => _buildHisabHeader(
          fonts.fontHeading,
          'OFFICIAL EXPENSE STATEMENT',
          studentName,
          monthName,
          year,
          generatedDate,
        ),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          pw.SizedBox(height: 14),

          // Financial KPI Banner
          _buildHisabKpiBanner(summary, expenses.length),
          pw.SizedBox(height: 16),

          // Category Spending Breakdown
          pw.Text(
            'Category Spending Distribution',
            style: pw.TextStyle(
              font: fonts.fontHeading,
              fontSize: 12,
              color: _emeraldPrimary,
            ),
          ),
          pw.SizedBox(height: 6),
          _buildHisabCategoryTable(categories),
          pw.SizedBox(height: 16),

          // Itemised Transaction Ledger
          pw.Text(
            'Itemised Daily Expense Ledger ($monthName $year)',
            style: pw.TextStyle(
              font: fonts.fontHeading,
              fontSize: 12,
              color: _emeraldPrimary,
            ),
          ),
          pw.SizedBox(height: 6),
          _buildItemizedLedgerTable(
            expenses,
            summary.totalPersonalSpentPaise,
            fonts.fontBold,
          ),
          pw.SizedBox(height: 16),

          // Shared Friends Summary (if active)
          if (friendsBalances.totalToReceivePaise > 0 ||
              friendsBalances.totalToPayPaise > 0) ...[
            pw.Text(
              'Shared Friends & Split Account Balance',
              style: pw.TextStyle(
                font: fonts.fontHeading,
                fontSize: 12,
                color: _tealAccent,
              ),
            ),
            pw.SizedBox(height: 6),
            _buildFriendsSection(friendsBalances),
            pw.SizedBox(height: 16),
          ],

          // Official Hisab Stamp & Declaration
          _buildHisabStamp(studentName, monthName, year),
        ],
      ),
    );

    return pdf.save();
  }

  // =========================================================================
  // 2. PARENT AUDIT REPORT (A4 REPORT FOR PARENTS)
  // =========================================================================

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
    final fonts = await _loadFonts();
    final monthName = DateFormatter.getMonthName(month);
    final reportTitle = 'Monthly Budget & Parent Audit Report';
    final generatedDate = DateFormatter.formatDate(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: fonts.font, bold: fonts.fontBold),
        header: (context) => _buildHisabHeader(
          fonts.fontHeading,
          reportTitle,
          studentName,
          monthName,
          year,
          generatedDate,
        ),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          pw.SizedBox(height: 16),
          // 1. Executive Summary Box
          _buildSummaryBox(summary),
          pw.SizedBox(height: 18),

          // 2. Category Breakdown Table
          pw.Text(
            'Category-Wise Limit vs Actual Spending',
            style: pw.TextStyle(
              font: fonts.fontHeading,
              fontSize: 13,
              color: _emeraldPrimary,
            ),
          ),
          pw.SizedBox(height: 6),
          _buildCategoryTable(categories),
          pw.SizedBox(height: 18),

          // 3. Friends & Shared Hisab Transparency Section
          pw.Text(
            'Friends & Shared Splits (Separated from Personal Expenses)',
            style: pw.TextStyle(
              font: fonts.fontHeading,
              fontSize: 13,
              color: _tealAccent,
            ),
          ),
          pw.SizedBox(height: 6),
          _buildFriendsSection(friendsBalances),
          pw.SizedBox(height: 18),

          // 4. Detailed Expense Log Table
          pw.Text(
            'Itemised Expense Transaction Log ($monthName $year)',
            style: pw.TextStyle(
              font: fonts.fontHeading,
              fontSize: 13,
              color: _emeraldPrimary,
            ),
          ),
          pw.SizedBox(height: 6),
          _buildExpensesTable(expenses),
          pw.SizedBox(height: 18),

          // 5. Parent Sign-off Section
          _buildParentSignoffSection(studentName, monthName, year),
        ],
      ),
    );

    return pdf.save();
  }

  // =========================================================================
  // SHARED HEADER AND FOOTER
  // =========================================================================

  static pw.Widget _buildHisabHeader(
    pw.Font fontHeading,
    String subtitle,
    String name,
    String month,
    int year,
    String genDate,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: _emeraldPrimary, width: 2.5),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'HISAB',
                    style: pw.TextStyle(
                      font: fontHeading,
                      fontSize: 22,
                      color: _emeraldPrimary,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: pw.BoxDecoration(
                      color: _mintBackground,
                      borderRadius: pw.BorderRadius.circular(4),
                      border: pw.Border.all(color: _mintBorder),
                    ),
                    child: pw.Text(
                      'VERIFIED',
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                        color: _emeraldPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                subtitle,
                style: const pw.TextStyle(fontSize: 10, color: _slateDark),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Account: $name',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                  color: _slateDark,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'Period: $month $year  |  Generated: $genDate',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildHisabKpiBanner(
    MonthBudgetSummary summary,
    int transactionCount,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: _mintBackground,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: _mintBorder),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _summaryCardItem(
            'Total Expenses',
            CurrencyFormatter.formatPaise(summary.totalPersonalSpentPaise),
            PdfColors.red800,
          ),
          _summaryCardItem(
            'Monthly Budget',
            CurrencyFormatter.formatPaise(summary.totalBudgetAvailablePaise),
            _emeraldPrimary,
          ),
          _summaryCardItem(
            'Unspent Balance',
            CurrencyFormatter.formatPaise(summary.remainingBalancePaise),
            PdfColors.green800,
          ),
          _summaryCardItem(
            'Budget Used',
            '${(summary.percentageUsed * 100).toStringAsFixed(1)}%',
            _slateDark,
          ),
          _summaryCardItem(
            'Total Entries',
            '$transactionCount Items',
            _tealAccent,
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
          _summaryCardItem(
            'Monthly Budget',
            CurrencyFormatter.formatPaise(summary.totalBudgetAvailablePaise),
            _emeraldPrimary,
          ),
          _summaryCardItem(
            'Total Spent',
            CurrencyFormatter.formatPaise(summary.totalPersonalSpentPaise),
            PdfColors.red800,
          ),
          _summaryCardItem(
            'Saved / Remaining',
            CurrencyFormatter.formatPaise(summary.remainingBalancePaise),
            PdfColors.green800,
          ),
          _summaryCardItem(
            '% Utilised',
            '${(summary.percentageUsed * 100).toStringAsFixed(1)}%',
            _slateDark,
          ),
        ],
      ),
    );
  }

  static pw.Widget _summaryCardItem(
    String label,
    String value,
    PdfColor valueColor,
  ) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildHisabCategoryTable(
    List<CategoryBudgetSummary> categories,
  ) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 8,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: _emeraldPrimary),
      cellStyle: const pw.TextStyle(fontSize: 8),
      cellHeight: 18,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.center,
      },
      headers: [
        'Category Name',
        'Allocated Limit',
        'Amount Spent',
        'Remaining Balance',
        'Utilisation %',
      ],
      data: categories.map((cat) {
        return [
          cat.categoryName,
          CurrencyFormatter.formatPaise(cat.limitPaise),
          CurrencyFormatter.formatPaise(cat.spentPaise),
          CurrencyFormatter.formatPaise(cat.remainingPaise),
          '${(cat.percentageUsed * 100).toStringAsFixed(1)}%',
        ];
      }).toList(),
    );
  }

  static pw.Widget _buildCategoryTable(List<CategoryBudgetSummary> categories) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 8,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: _emeraldPrimary),
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
      headers: [
        'Category',
        'Allocated Limit',
        'Actual Spent',
        'Remaining',
        '% Used',
        'Status',
      ],
      data: categories.map((cat) {
        final statusText = cat.status == CategoryStatus.ok
            ? 'OK'
            : (cat.status == CategoryStatus.nearLimit
                  ? 'Near Limit'
                  : 'Over Limit');
        return [
          cat.categoryName,
          CurrencyFormatter.formatPaise(cat.limitPaise),
          CurrencyFormatter.formatPaise(cat.spentPaise),
          CurrencyFormatter.formatPaise(cat.remainingPaise),
          '${(cat.percentageUsed * 100).toStringAsFixed(1)}%',
          statusText,
        ];
      }).toList(),
    );
  }

  static pw.Widget _buildItemizedLedgerTable(
    List<Expense> expenses,
    int totalPaise,
    pw.Font fontBold,
  ) {
    if (expenses.isEmpty) {
      return pw.Padding(
        padding: const pw.EdgeInsets.all(12),
        child: pw.Center(
          child: pw.Text(
            'No expenses recorded for this month.',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ),
      );
    }

    final rows = <pw.TableRow>[
      // Header
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: _slateDark),
        children: [
          _cell('Date', isHeader: true, align: pw.Alignment.centerLeft),
          _cell(
            'Particulars / Where Spent',
            isHeader: true,
            align: pw.Alignment.centerLeft,
          ),
          _cell('Payment Mode', isHeader: true, align: pw.Alignment.center),
          _cell('Notes / Memo', isHeader: true, align: pw.Alignment.centerLeft),
          _cell(
            'Debit Amount',
            isHeader: true,
            align: pw.Alignment.centerRight,
          ),
        ],
      ),
    ];

    for (int i = 0; i < expenses.length; i++) {
      final e = expenses[i];
      final isEven = i % 2 == 0;
      rows.add(
        pw.TableRow(
          decoration: pw.BoxDecoration(
            color: isEven ? PdfColors.white : PdfColors.grey50,
          ),
          children: [
            _cell(
              DateFormatter.formatDate(e.date),
              align: pw.Alignment.centerLeft,
            ),
            _cell(e.whereSpent, align: pw.Alignment.centerLeft),
            _cell(e.paymentMode, align: pw.Alignment.center),
            _cell(e.note ?? '-', align: pw.Alignment.centerLeft),
            _cell(
              CurrencyFormatter.formatPaise(e.amountPaise),
              align: pw.Alignment.centerRight,
              isBold: true,
            ),
          ],
        ),
      );
    }

    // Grand Total Footer Row
    rows.add(
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: _mintBackground),
        children: [
          _cell('Total Expenditure', isBold: true),
          _cell(''),
          _cell(''),
          _cell(''),
          _cell(
            CurrencyFormatter.formatPaise(totalPaise),
            align: pw.Alignment.centerRight,
            isBold: true,
            color: _emeraldPrimary,
          ),
        ],
      ),
    );

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      children: rows,
    );
  }

  static pw.Widget _cell(
    String text, {
    bool isHeader = false,
    bool isBold = false,
    pw.Alignment align = pw.Alignment.centerLeft,
    PdfColor? color,
  }) {
    return pw.Container(
      alignment: align,
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 8 : 8,
          fontWeight: (isHeader || isBold)
              ? pw.FontWeight.bold
              : pw.FontWeight.normal,
          color: isHeader ? PdfColors.white : (color ?? _slateDark),
        ),
      ),
    );
  }

  static pw.Widget _buildExpensesTable(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(
          'No expenses recorded for this month.',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
      );
    }

    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 8,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: _slateDark),
      cellStyle: const pw.TextStyle(fontSize: 8),
      cellHeight: 18,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.center,
        4: pw.Alignment.centerLeft,
      },
      headers: [
        'Date',
        'Where Spent / Description',
        'Amount',
        'Payment Mode',
        'Notes',
      ],
      data: expenses
          .map(
            (e) => [
              DateFormatter.formatDate(e.date),
              e.whereSpent,
              CurrencyFormatter.formatPaise(e.amountPaise),
              e.paymentMode,
              e.note ?? '-',
            ],
          )
          .toList(),
    );
  }

  static pw.Widget _buildFriendsSection(OverallBalancesResult friendsBalances) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: _mintBackground,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: _mintBorder),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          pw.Column(
            children: [
              pw.Text(
                'Money Friends Owe Me (To Receive)',
                style: const pw.TextStyle(fontSize: 8, color: _emeraldPrimary),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                CurrencyFormatter.formatPaise(
                  friendsBalances.totalToReceivePaise,
                ),
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: _emeraldPrimary,
                ),
              ),
            ],
          ),
          pw.Column(
            children: [
              pw.Text(
                'My Pending Dues to Friends (To Pay)',
                style: const pw.TextStyle(fontSize: 8, color: _slateDark),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                CurrencyFormatter.formatPaise(friendsBalances.totalToPayPaise),
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildHisabStamp(String name, String month, int year) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'HISAB VERIFIED FINANCIAL RECORD',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  color: _emeraldPrimary,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'This audited statement reflects verified transactions for $name ($month $year).',
                style: const pw.TextStyle(
                  fontSize: 7,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
          pw.Text(
            'Precision: Integer Paise (₹)',
            style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildParentSignoffSection(
    String studentName,
    String month,
    int year,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Parent / Guardian Monthly Review & Acknowledgment',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: _slateDark,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'I have reviewed the monthly budget utilisation, spending categories, and friend dues for $studentName for the period of $month $year.',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(width: 140, height: 1, color: PdfColors.grey500),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Student Signature',
                    style: const pw.TextStyle(
                      fontSize: 7,
                      color: PdfColors.grey600,
                    ),
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(width: 140, height: 1, color: PdfColors.grey500),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Parent / Guardian Signature',
                    style: const pw.TextStyle(
                      fontSize: 7,
                      color: PdfColors.grey600,
                    ),
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(width: 100, height: 1, color: PdfColors.grey500),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Date',
                    style: const pw.TextStyle(
                      fontSize: 7,
                      color: PdfColors.grey600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Hisab • Personal Finance Management',
            style: const pw.TextStyle(color: PdfColors.grey600, fontSize: 8),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(color: PdfColors.grey600, fontSize: 8),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // EXPORT / PRINT / SHARE METHODS
  // =========================================================================

  /// Direct print or preview for Itemised Hisab Statement
  static Future<void> layoutItemizedHisab({
    required String studentName,
    required int year,
    required int month,
    required MonthBudgetSummary summary,
    required List<CategoryBudgetSummary> categories,
    required List<Expense> expenses,
    required OverallBalancesResult friendsBalances,
  }) async {
    final fileName =
        'Hisab_Statement_${DateFormatter.getMonthName(month)}_$year.pdf';
    await Printing.layoutPdf(
      name: fileName,
      onLayout: (format) => generateItemizedHisabPdf(
        studentName: studentName,
        year: year,
        month: month,
        summary: summary,
        categories: categories,
        expenses: expenses,
        friendsBalances: friendsBalances,
      ),
    );
  }

  /// Exports and triggers direct PDF share or file download
  static Future<void> printOrShareItemizedHisab({
    required String studentName,
    required int year,
    required int month,
    required MonthBudgetSummary summary,
    required List<CategoryBudgetSummary> categories,
    required List<Expense> expenses,
    required OverallBalancesResult friendsBalances,
  }) async {
    final pdfBytes = await generateItemizedHisabPdf(
      studentName: studentName,
      year: year,
      month: month,
      summary: summary,
      categories: categories,
      expenses: expenses,
      friendsBalances: friendsBalances,
    );

    final fileName =
        'Hisab_Statement_${DateFormatter.getMonthName(month)}_$year.pdf';
    await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
  }

  /// Exports and triggers direct print or PDF share sheet for Parent Audit
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

    final fileName =
        'Hisab_Parent_Report_${DateFormatter.getMonthName(month)}_$year.pdf';
    await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
  }

  /// Direct print / preview for Parent Audit Report
  static Future<void> layoutMonthlyReport({
    required String studentName,
    required int year,
    required int month,
    required MonthBudgetSummary summary,
    required List<CategoryBudgetSummary> categories,
    required List<Expense> expenses,
    required OverallBalancesResult friendsBalances,
  }) async {
    final fileName =
        'Hisab_Parent_Report_${DateFormatter.getMonthName(month)}_$year.pdf';
    await Printing.layoutPdf(
      name: fileName,
      onLayout: (format) => generateMonthlyReportPdf(
        studentName: studentName,
        year: year,
        month: month,
        summary: summary,
        categories: categories,
        expenses: expenses,
        friendsBalances: friendsBalances,
      ),
    );
  }

  /// Exports an individual Hisab Statement PDF for a friend
  static Future<void> exportFriendHisabPdf({
    required String friendName,
    required PersonBalanceResult balance,
    required List<SplitExpense> sharedExpenses,
    required List<Settlement> settlements,
  }) async {
    final pdf = pw.Document();
    final fonts = await _loadFonts();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: fonts.font, bold: fonts.fontBold),
        build: (context) => [
          pw.Text(
            'FRIEND HISAB STATEMENT',
            style: pw.TextStyle(
              font: fonts.fontHeading,
              fontSize: 18,
              color: _emeraldPrimary,
            ),
          ),
          pw.Text(
            'Shared Account with $friendName',
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.Divider(thickness: 1.5, color: _emeraldPrimary),
          pw.SizedBox(height: 12),

          // Net Balance Box
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: balance.theyOweMe
                  ? PdfColors.green50
                  : (balance.iOweThem ? PdfColors.red50 : PdfColors.grey100),
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(
                color: balance.theyOweMe
                    ? PdfColors.green300
                    : (balance.iOweThem ? PdfColors.red300 : PdfColors.grey300),
              ),
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
                  style: pw.TextStyle(
                    font: fonts.fontBold,
                    fontSize: 14,
                    color: balance.theyOweMe
                        ? PdfColors.green900
                        : (balance.iOweThem
                              ? PdfColors.red900
                              : PdfColors.grey800),
                  ),
                ),
                pw.Text(
                  'Audited via Hisab',
                  style: const pw.TextStyle(
                    fontSize: 8,
                    color: PdfColors.grey600,
                  ),
                ),
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
