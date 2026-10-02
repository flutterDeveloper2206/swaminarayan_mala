class FavoriteModel {
  FavoriteModel({
    required this.id,
    required this.type,
    required this.itemId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  final String type; // mantra | story
  final String itemId;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'itemId': itemId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory FavoriteModel.fromMap(Map<dynamic, dynamic> map) {
    return FavoriteModel(
      id: map['id'] as String,
      type: map['type'] as String,
      itemId: map['itemId'] as String,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
