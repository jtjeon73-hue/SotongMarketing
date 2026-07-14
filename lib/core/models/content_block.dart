/// 맞춤형 마케팅 콘텐츠/기능 블록.
class ContentBlock {
  const ContentBlock({
    required this.id,
    required this.label,
    this.description = '',
    this.category = ContentBlockCategory.content,
  });

  final String id;
  final String label;
  final String description;
  final ContentBlockCategory category;

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    final cat = json['category'] as String?;
    return ContentBlock(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: cat == 'feature'
          ? ContentBlockCategory.feature
          : ContentBlockCategory.content,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'description': description,
    'category': category == ContentBlockCategory.feature
        ? 'feature'
        : 'content',
  };
}

enum ContentBlockCategory { content, feature }

/// content_blocks.json 전체 로드 결과.
class ContentBlocksCatalog {
  const ContentBlocksCatalog({
    required this.contentBlocks,
    required this.featureBlocks,
  });

  final List<ContentBlock> contentBlocks;
  final List<ContentBlock> featureBlocks;

  factory ContentBlocksCatalog.fromJson(Map<String, dynamic> json) {
    List<ContentBlock> parseList(dynamic raw, ContentBlockCategory fallback) {
      final list = raw as List<dynamic>? ?? const [];
      return list.map((e) {
        if (e is String) {
          return ContentBlock(id: e, label: e, category: fallback);
        }
        final map = Map<String, dynamic>.from(e as Map);
        map.putIfAbsent(
          'category',
          () =>
              fallback == ContentBlockCategory.feature ? 'feature' : 'content',
        );
        return ContentBlock.fromJson(map);
      }).toList();
    }

    return ContentBlocksCatalog(
      contentBlocks: parseList(
        json['contentBlocks'],
        ContentBlockCategory.content,
      ),
      featureBlocks: parseList(
        json['featureBlocks'],
        ContentBlockCategory.feature,
      ),
    );
  }
}
