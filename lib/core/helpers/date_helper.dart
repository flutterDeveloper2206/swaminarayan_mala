import 'package:intl/intl.dart';

class DateHelper {
  DateHelper._();

  /// Local calendar date key: YYYY-MM-DD
  static String dateKey([DateTime? date]) {
    final d = date ?? DateTime.now();
    final local = DateTime(d.year, d.month, d.day);
    return '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }

  static DateTime parseDateKey(String key) {
    final parts = key.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  static String todayKey() => dateKey();

  static String yesterdayKey() {
    final y = DateTime.now().subtract(const Duration(days: 1));
    return dateKey(y);
  }

  static List<String> lastNDaysKeys(int n) {
    final now = DateTime.now();
    return List.generate(n, (i) {
      final d = now.subtract(Duration(days: n - 1 - i));
      return dateKey(d);
    });
  }

  static List<String> monthKeys(int year, int month) {
    final days = DateTime(year, month + 1, 0).day;
    return List.generate(days, (i) => dateKey(DateTime(year, month, i + 1)));
  }

  static String formatLocalized(DateTime date, String locale) {
    return DateFormat.yMMMEd(locale).format(date);
  }

  static String formatTime(DateTime date, String locale) {
    return DateFormat.jm(locale).format(date);
  }

  static int daysBetween(String fromKey, String toKey) {
    return parseDateKey(toKey).difference(parseDateKey(fromKey)).inDays;
  }
}
