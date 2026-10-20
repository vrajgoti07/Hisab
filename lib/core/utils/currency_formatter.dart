import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _indianFormatWithDecimals = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final NumberFormat _indianFormatCompact = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  /// Converts paise (integer) to rupees (double)
  static double paiseToRupees(int paise) {
    return paise / 100.0;
  }

  /// Converts rupees (double or int) to paise (integer)
  static int rupeesToPaise(num rupees) {
    return (rupees * 100).round();
  }

  /// Formats paise into Indian Rupee format, e.g. 12500000 -> ₹1,25,000
  /// If [showDecimals] is true, shows 2 decimal digits: e.g. ₹1,25,000.50
  static String formatPaise(int paise, {bool showDecimals = false}) {
    final isNegative = paise < 0;
    final absPaise = paise.abs();
    final rupees = absPaise / 100.0;

    String formatted;
    if (showDecimals || (absPaise % 100 != 0)) {
      formatted = _indianFormatWithDecimals.format(rupees);
    } else {
      formatted = _indianFormatCompact.format(rupees);
    }

    return isNegative ? '-$formatted' : formatted;
  }

  /// Formats paise without symbol, e.g. 12500000 -> 1,25,000
  static String formatPaisePlain(int paise, {bool showDecimals = false}) {
    final formatted = formatPaise(paise, showDecimals: showDecimals);
    return formatted.replaceAll('₹', '').trim();
  }

  /// Parses a user-entered text (like "1250" or "1,250.50") into paise
  static int? parseToPaise(String input) {
    if (input.trim().isEmpty) return null;
    final clean = input.replaceAll('₹', '').replaceAll(',', '').trim();
    final parsed = double.tryParse(clean);
    if (parsed == null) return null;
    return (parsed * 100).round();
  }
}
