class JapSessionModel {
  JapSessionModel({
    required this.id,
    required this.mantraId,
    required this.startedAt,
    this.endedAt,
    this.count = 0,
    this.durationSeconds = 0,
    this.mode = JapMode.normal,
    this.target = 108,
  });

  final String id;
  final String mantraId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int count;
  final int durationSeconds;
  final String mode;
  final int target;

  bool get isKids => mode == JapMode.kids;

  JapSessionModel copyWith({
    String? id,
    String? mantraId,
    DateTime? startedAt,
    DateTime? endedAt,
    int? count,
    int? durationSeconds,
    String? mode,
    int? target,
  }) {
    return JapSessionModel(
      id: id ?? this.id,
      mantraId: mantraId ?? this.mantraId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      count: count ?? this.count,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      mode: mode ?? this.mode,
      target: target ?? this.target,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'mantraId': mantraId,
        'startedAt': startedAt.toIso8601String(),
        'endedAt': endedAt?.toIso8601String(),
        'count': count,
        'durationSeconds': durationSeconds,
        'mode': mode,
        'target': target,
      };

  factory JapSessionModel.fromMap(Map<dynamic, dynamic> map) {
    return JapSessionModel(
      id: map['id'] as String,
      mantraId: map['mantraId'] as String,
      startedAt: DateTime.tryParse(map['startedAt'] as String? ?? '') ?? DateTime.now(),
      endedAt: map['endedAt'] != null
          ? DateTime.tryParse(map['endedAt'] as String)
          : null,
      count: map['count'] as int? ?? 0,
      durationSeconds: map['durationSeconds'] as int? ?? 0,
      mode: map['mode'] as String? ?? JapMode.normal,
      target: map['target'] as int? ?? 108,
    );
  }
}

class JapMode {
  JapMode._();
  static const String normal = 'normal';
  static const String kids = 'kids';
}
