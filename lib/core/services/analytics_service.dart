import '../../data/local/local_database.dart';
import '../../data/models/daily_progress_model.dart';
import '../../data/models/jap_session_model.dart';
import '../constants/app_constants.dart';
import '../helpers/date_helper.dart';

class PeriodStats {
  PeriodStats({
    required this.totalNaam,
    required this.totalMala,
    required this.totalSessions,
    required this.totalDurationSeconds,
    required this.activeDays,
    required this.targetCompletedDays,
    required this.dailyAverage,
    this.bestDayCount = 0,
    this.bestDayKey,
    required this.dailyCounts,
  });

  final int totalNaam;
  final int totalMala;
  final int totalSessions;
  final int totalDurationSeconds;
  final int activeDays;
  final int targetCompletedDays;
  final double dailyAverage;
  final int bestDayCount;
  final String? bestDayKey;
  final Map<String, int> dailyCounts;
}

class LifetimeStats {
  LifetimeStats({
    required this.totalNaam,
    required this.totalMala,
    required this.totalSessions,
    required this.totalDurationSeconds,
    required this.longestStreak,
    required this.activeDays,
    required this.currentStreak,
  });

  final int totalNaam;
  final int totalMala;
  final int totalSessions;
  final int totalDurationSeconds;
  final int longestStreak;
  final int activeDays;
  final int currentStreak;
}

class AnalyticsInsight {
  AnalyticsInsight({required this.type, required this.count, this.extra});

  final String type; // monthly | consistency | bestDay
  final int count;
  final int? extra;
}

class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  final _db = LocalDatabase.instance;

  DailyProgressModel today() => _db.getDayAggregate(DateHelper.todayKey());

  PeriodStats weekStats() {
    final keys = DateHelper.lastNDaysKeys(7);
    return _periodFromKeys(keys);
  }

  PeriodStats monthStats({DateTime? month}) {
    final m = month ?? DateTime.now();
    final keys = DateHelper.monthKeys(m.year, m.month);
    // Only up to today for current month
    final today = DateHelper.todayKey();
    final filtered = keys.where((k) => k.compareTo(today) <= 0).toList();
    return _periodFromKeys(filtered.isEmpty ? keys : filtered);
  }

  PeriodStats yearStats({int? year}) {
    final y = year ?? DateTime.now().year;
    final now = DateTime.now();
    final endMonth = (y == now.year) ? now.month : 12;
    final keys = <String>[];
    for (var m = 1; m <= endMonth; m++) {
      keys.addAll(DateHelper.monthKeys(y, m));
    }
    final today = DateHelper.todayKey();
    final filtered = keys.where((k) => k.compareTo(today) <= 0).toList();
    return _periodFromKeys(filtered);
  }

  Map<String, int> yearlyMonthlyTotals({int? year}) {
    final y = year ?? DateTime.now().year;
    final result = <String, int>{};
    for (var m = 1; m <= 12; m++) {
      final keys = DateHelper.monthKeys(y, m);
      var sum = 0;
      for (final k in keys) {
        sum += _db.getDayAggregate(k).totalCount;
      }
      result['$m'] = sum;
    }
    return result;
  }

  LifetimeStats lifetime() {
    final all = _db.getAllProgress();
    final active = all.where((p) => p.totalCount > 0).length;
    return LifetimeStats(
      totalNaam: _db.getSetting(AppConstants.keyLifetimeCount, defaultValue: 0),
      totalMala: _db.getSetting(AppConstants.keyLifetimeMala, defaultValue: 0),
      totalSessions: _db.getSetting(AppConstants.keyLifetimeSessions, defaultValue: 0),
      totalDurationSeconds:
          _db.getSetting(AppConstants.keyLifetimeDuration, defaultValue: 0),
      longestStreak: _db.getLongestStreak(),
      activeDays: active,
      currentStreak: _db.getCurrentStreak(),
    );
  }

  List<AnalyticsInsight> insights() {
    final list = <AnalyticsInsight>[];
    final month = monthStats();
    if (month.totalNaam >= 108) {
      list.add(AnalyticsInsight(type: 'monthly', count: month.totalNaam));
    }
    final last30 = DateHelper.lastNDaysKeys(30);
    final practiced = last30.where((k) => _db.getDayAggregate(k).totalCount > 0).length;
    if (practiced >= 3) {
      list.add(AnalyticsInsight(type: 'consistency', count: practiced, extra: 30));
    }
    if (month.bestDayCount >= 108) {
      list.add(AnalyticsInsight(type: 'bestDay', count: month.bestDayCount));
    }
    return list;
  }

  /// Approximate preferred start hour from sessions.
  int? preferredStartHour() {
    final sessions = _db.getAllSessions();
    if (sessions.length < 5) return null;
    final hours = <int, int>{};
    for (final s in sessions) {
      final h = s.startedAt.hour;
      hours[h] = (hours[h] ?? 0) + 1;
    }
    var best = hours.entries.first;
    for (final e in hours.entries) {
      if (e.value > best.value) best = e;
    }
    return best.key;
  }

  List<JapSessionModel> todaySessions() =>
      _db.getSessionsForDate(DateHelper.todayKey());

  PeriodStats _periodFromKeys(List<String> keys) {
    var totalNaam = 0;
    var totalMala = 0;
    var totalSessions = 0;
    var totalDuration = 0;
    var activeDays = 0;
    var targetDays = 0;
    var best = 0;
    String? bestKey;
    final daily = <String, int>{};

    for (final k in keys) {
      final p = _db.getDayAggregate(k);
      daily[k] = p.totalCount;
      totalNaam += p.totalCount;
      totalMala += p.malaCount;
      totalSessions += p.sessionCount;
      totalDuration += p.totalDurationSeconds;
      if (p.totalCount > 0) activeDays++;
      if (p.targetCompleted) targetDays++;
      if (p.totalCount > best) {
        best = p.totalCount;
        bestKey = k;
      }
    }

    return PeriodStats(
      totalNaam: totalNaam,
      totalMala: totalMala,
      totalSessions: totalSessions,
      totalDurationSeconds: totalDuration,
      activeDays: activeDays,
      targetCompletedDays: targetDays,
      dailyAverage: keys.isEmpty ? 0 : totalNaam / keys.length,
      bestDayCount: best,
      bestDayKey: bestKey,
      dailyCounts: daily,
    );
  }
}
