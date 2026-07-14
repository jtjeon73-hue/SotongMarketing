/// 업종별 제작 방향 (예시·샘플 시나리오).
class Industry {
  const Industry({
    required this.id,
    required this.name,
    required this.curiosities,
    required this.recommendedStructure,
    required this.neededPhotos,
    required this.importantCta,
    required this.caution,
    this.isExample = true,
  });

  final String id;
  final String name;
  final List<String> curiosities;
  final List<String> recommendedStructure;
  final List<String> neededPhotos;
  final String importantCta;
  final String caution;
  final bool isExample;

  factory Industry.fromJson(Map<String, dynamic> json) {
    return Industry(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      curiosities:
          (json['curiosities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      recommendedStructure:
          (json['recommendedStructure'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      neededPhotos:
          (json['neededPhotos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      importantCta: json['importantCta'] as String? ?? '',
      caution: json['caution'] as String? ?? '',
      isExample: json['isExample'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'curiosities': curiosities,
    'recommendedStructure': recommendedStructure,
    'neededPhotos': neededPhotos,
    'importantCta': importantCta,
    'caution': caution,
    'isExample': isExample,
  };
}
