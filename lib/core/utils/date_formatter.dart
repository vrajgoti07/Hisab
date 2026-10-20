import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _dayMonthYear = DateFormat('dd MMM yyyy');
  static final DateFormat _shortDate = DateFormat('dd MMM');
  static final DateFormat _fullDate = DateFormat('EEEE, dd MMMM yyyy');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy');

  static String formatDate(DateTime date) => _dayMonthYear.format(date);
  static String formatShortDate(DateTime date) => _shortDate.format(date);
  static String formatFullDate(DateTime date) => _fullDate.format(date);
  static String formatMonthYear(int month, int year) {
    return _monthYear.format(DateTime(year, month, 1));
  }

  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static String getMonthName(int month) {
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }

  /// Calculates number of days in a given month and year
  static int getDaysInMonth(int year, int month) {
    final nextMonth = month == 12
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1)).day;
  }

  /// Calculates safe daily days remaining in current active month
  /// If today is in the active month, remaining days = totalDays - today.day + 1 (minimum 1)
  /// If active month is in the future, return total days in that month
  /// If active month is in the past, return 1 (to avoid divide by zero)
  static int getDaysRemaining(int year, int month, [DateTime? currentDate]) {
    final now = currentDate ?? DateTime.now();
    if (year == now.year && month == now.month) {
      final totalDays = getDaysInMonth(year, month);
      final remaining = totalDays - now.day + 1;
      return remaining > 0 ? remaining : 1;
    } else if (year > now.year || (year == now.year && month > now.month)) {
      return getDaysInMonth(year, month);
    } else {
      return 1;
    }
  }
}
