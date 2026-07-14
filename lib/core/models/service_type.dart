/// 홍보사이트 제작 서비스 유형.
class ServiceType {
  const ServiceType({
    required this.id,
    required this.name,
    required this.suitableCustomers,
    required this.mainPurpose,
    required this.recommendedStructure,
    required this.neededMaterials,
    required this.expandableFeatures,
  });

  final String id;
  final String name;
  final List<String> suitableCustomers;
  final String mainPurpose;
  final List<String> recommendedStructure;
  final List<String> neededMaterials;
  final List<String> expandableFeatures;

  factory ServiceType.fromJson(Map<String, dynamic> json) {
    List<String> listOf(dynamic v) =>
        (v as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [];

    return ServiceType(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      suitableCustomers: listOf(json['suitableCustomers']),
      mainPurpose: json['mainPurpose'] as String? ?? '',
      recommendedStructure: listOf(json['recommendedStructure']),
      neededMaterials: listOf(json['neededMaterials']),
      expandableFeatures: listOf(json['expandableFeatures']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'suitableCustomers': suitableCustomers,
    'mainPurpose': mainPurpose,
    'recommendedStructure': recommendedStructure,
    'neededMaterials': neededMaterials,
    'expandableFeatures': expandableFeatures,
  };
}
