class DailyProgressModel {
  DailyProgressModel({
    required this.dateKey,
    this.mantraId = '',
    this.totalCount = 0,
    this.malaCount = 0,
    this.sessionCount = 0,
    this.totalDurationSeconds = 0,
    this.target = 108,
    this.targetCompleted = false,
    this.firstSessionAt,
    this.lastSessionAt,
  });

  final String dateKey;
  final String mantraId;
  final int totalCount;
  final int malaCount;
  final int sessionCount;
  final int totalDurationSeconds;
  final int target;
  final bool targetCompleted;
  final DateTime? firstSessionAt;
  final DateTime? lastSessionAt;

  /// Storage key: YYYY-MM-DD|mantraId
  String get storageKey => mantraId.isEmpty ? dateKey : '$dateKey|$mantraId';

  static String keyFor(String dateKey, String mantraId) => '$dateKey|$mantraId';

  double get progressPercent {
    if (target <= 0) return 0;
    return (totalCount / target).clamp(0.0, 1.0);
  }

  DailyProgressModel copyWith({
    String? dateKey,
    String? mantraId,
    int? totalCount,
    int? malaCount,
    int? sessionCount,
    int? totalDurationSeconds,
    int? target,
    bool? targetCompleted,
    DateTime? firstSessionAt,
    DateTime? lastSessionAt,
  }) {
    return DailyProgressModel(
      dateKey: dateKey ?? this.dateKey,
      mantraId: mantraId ?? this.mantraId,
      totalCount: totalCount ?? this.totalCount,
      malaCount: malaCount ?? this.malaCount,
      sessionCount: sessionCount ?? this.sessionCount,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      target: target ?? this.target,
      targetCompleted: targetCompleted ?? this.targetCompleted,
      firstSessionAt: firstSessionAt ?? this.firstSessionAt,
      lastSessionAt: lastSessionAt ?? this.lastSessionAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'dateKey': dateKey,
        'mantraId': mantraId,
        'totalCount': totalCount,
        'malaCount': malaCount,
        'sessionCount': sessionCount,
        'totalDurationSeconds': totalDurationSeconds,
        'target': target,
        'targetCompleted': targetCompleted,
        'firstSessionAt': firstSessionAt?.toIso8601String(),
        'lastSessionAt': lastSessionAt?.toIso8601String(),
      };

  factory DailyProgressModel.fromMap(Map<dynamic, dynamic> map) {
    return DailyProgressModel(
      dateKey: map['dateKey'] as String,
      mantraId: map['mantraId'] as String? ?? '',
      totalCount: map['totalCount'] as int? ?? 0,
      malaCount: map['malaCount'] as int? ?? 0,
      sessionCount: map['sessionCount'] as int? ?? 0,
      totalDurationSeconds: map['totalDurationSeconds'] as int? ?? 0,
      target: map['target'] as int? ?? 108,
      targetCompleted: map['targetCompleted'] as bool? ?? false,
      firstSessionAt: map['firstSessionAt'] != null
          ? DateTime.tryParse(map['firstSessionAt'] as String)
          : null,
      lastSessionAt: map['lastSessionAt'] != null
          ? DateTime.tryParse(map['lastSessionAt'] as String)
          : null,
    );
  }

  /// Merge multiple mantra records for the same calendar day (analytics).
  factory DailyProgressModel.aggregate(String dateKey, List<DailyProgressModel> parts) {
    if (parts.isEmpty) {
      return DailyProgressModel(dateKey: dateKey);
    }
    var total = 0;
    var mala = 0;
    var sessions = 0;
    var duration = 0;
    var target = parts.first.target;
    var completed = false;
    DateTime? first;
    DateTime? last;
    for (final p in parts) {
      total += p.totalCount;
      mala += p.malaCount;
      sessions += p.sessionCount;
      duration += p.totalDurationSeconds;
      if (p.target > target) target = p.target;
      completed = completed || p.targetCompleted;
      if (p.firstSessionAt != null &&
          (first == null || p.firstSessionAt!.isBefore(first))) {
        first = p.firstSessionAt;
      }
      if (p.lastSessionAt != null &&
          (last == null || p.lastSessionAt!.isAfter(last))) {
        last = p.lastSessionAt;
      }
    }
    return DailyProgressModel(
      dateKey: dateKey,
      totalCount: total,
      malaCount: mala,
      sessionCount: sessions,
      totalDurationSeconds: duration,
      target: target,
      targetCompleted: completed,
      firstSessionAt: first,
      lastSessionAt: last,
    );
  }
}
