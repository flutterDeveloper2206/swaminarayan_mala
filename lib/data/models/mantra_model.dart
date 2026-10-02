class MantraModel {
  MantraModel({
    required this.id,
    required this.name,
    required this.text,
    required this.transliteration,
    required this.deityId,
    this.target = 108,
    this.totalCount = 0,
    this.isFavorite = false,
    DateTime? createdAt,
    this.isCustom = false,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  final String name;
  final String text;
  final String transliteration;
  final String deityId;
  final int target;
  final int totalCount;
  final bool isFavorite;
  final DateTime createdAt;
  final bool isCustom;

  MantraModel copyWith({
    String? id,
    String? name,
    String? text,
    String? transliteration,
    String? deityId,
    int? target,
    int? totalCount,
    bool? isFavorite,
    DateTime? createdAt,
    bool? isCustom,
  }) {
    return MantraModel(
      id: id ?? this.id,
      name: name ?? this.name,
      text: text ?? this.text,
      transliteration: transliteration ?? this.transliteration,
      deityId: deityId ?? this.deityId,
      target: target ?? this.target,
      totalCount: totalCount ?? this.totalCount,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'text': text,
        'transliteration': transliteration,
        'deityId': deityId,
        'target': target,
        'totalCount': totalCount,
        'isFavorite': isFavorite,
        'createdAt': createdAt.toIso8601String(),
        'isCustom': isCustom,
      };

  factory MantraModel.fromMap(Map<dynamic, dynamic> map) {
    return MantraModel(
      id: map['id'] as String,
      name: map['name'] as String,
      text: map['text'] as String,
      transliteration: map['transliteration'] as String? ?? '',
      deityId: map['deityId'] as String? ?? 'swaminarayan',
      target: map['target'] as int? ?? 108,
      totalCount: map['totalCount'] as int? ?? 0,
      isFavorite: map['isFavorite'] as bool? ?? false,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      isCustom: map['isCustom'] as bool? ?? false,
    );
  }
}
