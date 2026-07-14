/// 사이트 구성 예시의 한 섹션.
class SiteExampleSection {
  const SiteExampleSection({
    required this.title,
    this.id = '',
    this.description = '',
  });

  final String id;
  final String title;
  final String description;

  factory SiteExampleSection.fromJson(dynamic raw) {
    if (raw is String) {
      return SiteExampleSection(title: raw);
    }
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      return SiteExampleSection(
        id: map['id'] as String? ?? '',
        title: map['title'] as String? ?? map['name'] as String? ?? '',
        description: map['description'] as String? ?? '',
      );
    }
    return SiteExampleSection(title: raw.toString());
  }

  Map<String, dynamic> toJson() => {
    if (id.isNotEmpty) 'id': id,
    'title': title,
    if (description.isNotEmpty) 'description': description,
  };
}

/// 사이트 구성 예시 (데모·샘플 — 실제 포트폴리오 아님).
class SiteExample {
  const SiteExample({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.sections,
    this.disclaimer = '가능한 사이트 구성 예시이며, 실제 제작 결과가 아닙니다.',
    this.label = '가능한 사이트 구성 예시',
    this.scenarioType = '샘플 시나리오',
    this.suitablePackageHint = '',
  });

  final String id;
  final String title;
  final String subtitle;
  final List<SiteExampleSection> sections;
  final String disclaimer;
  final String label;
  final String scenarioType;
  final String suitablePackageHint;

  factory SiteExample.fromJson(Map<String, dynamic> json) {
    final rawSections = json['sections'] as List<dynamic>? ?? const [];
    return SiteExample(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? json['name'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? json['summary'] as String? ?? '',
      sections: rawSections.map(SiteExampleSection.fromJson).toList(),
      disclaimer:
          json['disclaimer'] as String? ?? '가능한 사이트 구성 예시이며, 실제 제작 결과가 아닙니다.',
      label: json['label'] as String? ?? '가능한 사이트 구성 예시',
      scenarioType: json['scenarioType'] as String? ?? '샘플 시나리오',
      suitablePackageHint: json['suitablePackageHint'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'sections': sections.map((e) => e.toJson()).toList(),
    'disclaimer': disclaimer,
    'label': label,
    'scenarioType': scenarioType,
    if (suitablePackageHint.isNotEmpty)
      'suitablePackageHint': suitablePackageHint,
  };
}
