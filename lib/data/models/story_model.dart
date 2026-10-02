class StoryModel {
  StoryModel({
    required this.id,
    required this.titleEn,
    required this.titleHi,
    required this.category,
    required this.descriptionEn,
    required this.descriptionHi,
    required this.contentEn,
    required this.contentHi,
    this.thumbnail = '',
    this.isFavorite = false,
  });

  final String id;
  final String titleEn;
  final String titleHi;
  final String category;
  final String descriptionEn;
  final String descriptionHi;
  final String contentEn;
  final String contentHi;
  final String thumbnail;
  final bool isFavorite;

  String title(bool isHindi) => isHindi ? titleHi : titleEn;
  String description(bool isHindi) => isHindi ? descriptionHi : descriptionEn;
  String content(bool isHindi) => isHindi ? contentHi : contentEn;

  StoryModel copyWith({bool? isFavorite}) {
    return StoryModel(
      id: id,
      titleEn: titleEn,
      titleHi: titleHi,
      category: category,
      descriptionEn: descriptionEn,
      descriptionHi: descriptionHi,
      contentEn: contentEn,
      contentHi: contentHi,
      thumbnail: thumbnail,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'titleEn': titleEn,
        'titleHi': titleHi,
        'category': category,
        'descriptionEn': descriptionEn,
        'descriptionHi': descriptionHi,
        'contentEn': contentEn,
        'contentHi': contentHi,
        'thumbnail': thumbnail,
        'isFavorite': isFavorite,
      };

  factory StoryModel.fromMap(Map<dynamic, dynamic> map) {
    return StoryModel(
      id: map['id'] as String,
      titleEn: map['titleEn'] as String? ?? map['title'] as String? ?? '',
      titleHi: map['titleHi'] as String? ?? '',
      category: map['category'] as String? ?? 'bhakti',
      descriptionEn: map['descriptionEn'] as String? ?? map['description'] as String? ?? '',
      descriptionHi: map['descriptionHi'] as String? ?? '',
      contentEn: map['contentEn'] as String? ?? map['content'] as String? ?? '',
      contentHi: map['contentHi'] as String? ?? '',
      thumbnail: map['thumbnail'] as String? ?? '',
      isFavorite: map['isFavorite'] as bool? ?? false,
    );
  }
}
