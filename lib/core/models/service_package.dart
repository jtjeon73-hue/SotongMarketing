/// 제작 등급(패키지) 모델.
class ServicePackage {
  const ServicePackage({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.target,
    required this.features,
    required this.note,
  });

  final String id;
  final String name;
  final String subtitle;
  final String target;
  final List<String> features;
  final String note;

  factory ServicePackage.fromJson(Map<String, dynamic> json) {
    return ServicePackage(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      target: json['target'] as String? ?? '',
      features:
          (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      note: json['note'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'subtitle': subtitle,
    'target': target,
    'features': features,
    'note': note,
  };
}
