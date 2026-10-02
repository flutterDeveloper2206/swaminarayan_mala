import 'package:intl/intl.dart';

class NumberHelper {
  NumberHelper._();

  static String formatCount(int count, [String locale = 'en']) {
    return NumberFormat.decimalPattern(locale).format(count);
  }

  static String formatDuration(int totalSeconds) {
    if (totalSeconds < 60) {
      return '${totalSeconds}s';
    }
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    if (minutes > 0 && seconds > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${minutes}m';
  }

  static String formatPercent(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }
}
