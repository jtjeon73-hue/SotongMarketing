/// 상담 준비 도우미 10단계 입력 값 (서버 미저장).
class ConsultationDraft {
  const ConsultationDraft({
    this.whatToPromote = '',
    this.projectName = '',
    this.mainCustomers = const [],
    this.mainPurpose = '',
    this.highlights = '',
    this.availableMaterials = const [],
    this.neededFeatures = const [],
    this.desiredLevel = '',
    this.referenceSites = '',
    this.otherRequests = '',
    this.contactName = '',
    this.contactEmail = '',
    this.contactPhone = '',
  });

  /// 1. 무엇을 홍보하시나요?
  final String whatToPromote;

  /// 2. 업체·프로젝트 이름
  final String projectName;

  /// 3. 주요 고객
  final List<String> mainCustomers;

  /// 4. 가장 중요한 홍보 목적
  final String mainPurpose;

  /// 5. 강조하고 싶은 내용
  final String highlights;

  /// 6. 현재 가지고 있는 자료
  final List<String> availableMaterials;

  /// 7. 필요한 기능
  final List<String> neededFeatures;

  /// 8. 원하는 제작 수준
  final String desiredLevel;

  /// 9. 참고 사이트
  final String referenceSites;

  /// 10. 기타 요청사항
  final String otherRequests;

  /// 선택적 연락 정보 (필수는 아님)
  final String contactName;
  final String contactEmail;
  final String contactPhone;

  ConsultationDraft copyWith({
    String? whatToPromote,
    String? projectName,
    List<String>? mainCustomers,
    String? mainPurpose,
    String? highlights,
    List<String>? availableMaterials,
    List<String>? neededFeatures,
    String? desiredLevel,
    String? referenceSites,
    String? otherRequests,
    String? contactName,
    String? contactEmail,
    String? contactPhone,
  }) {
    return ConsultationDraft(
      whatToPromote: whatToPromote ?? this.whatToPromote,
      projectName: projectName ?? this.projectName,
      mainCustomers: mainCustomers ?? this.mainCustomers,
      mainPurpose: mainPurpose ?? this.mainPurpose,
      highlights: highlights ?? this.highlights,
      availableMaterials: availableMaterials ?? this.availableMaterials,
      neededFeatures: neededFeatures ?? this.neededFeatures,
      desiredLevel: desiredLevel ?? this.desiredLevel,
      referenceSites: referenceSites ?? this.referenceSites,
      otherRequests: otherRequests ?? this.otherRequests,
      contactName: contactName ?? this.contactName,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
    );
  }

  bool get hasAnyContent =>
      whatToPromote.isNotEmpty ||
      projectName.isNotEmpty ||
      mainCustomers.isNotEmpty ||
      mainPurpose.isNotEmpty ||
      highlights.isNotEmpty ||
      availableMaterials.isNotEmpty ||
      neededFeatures.isNotEmpty ||
      desiredLevel.isNotEmpty ||
      referenceSites.isNotEmpty ||
      otherRequests.isNotEmpty;

  Map<String, dynamic> toJson() => {
    'whatToPromote': whatToPromote,
    'projectName': projectName,
    'mainCustomers': mainCustomers,
    'mainPurpose': mainPurpose,
    'highlights': highlights,
    'availableMaterials': availableMaterials,
    'neededFeatures': neededFeatures,
    'desiredLevel': desiredLevel,
    'referenceSites': referenceSites,
    'otherRequests': otherRequests,
    'contactName': contactName,
    'contactEmail': contactEmail,
    'contactPhone': contactPhone,
  };

  factory ConsultationDraft.fromJson(Map<String, dynamic> json) {
    List<String> listOf(dynamic v) =>
        (v as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [];

    return ConsultationDraft(
      whatToPromote: json['whatToPromote'] as String? ?? '',
      projectName: json['projectName'] as String? ?? '',
      mainCustomers: listOf(json['mainCustomers']),
      mainPurpose: json['mainPurpose'] as String? ?? '',
      highlights: json['highlights'] as String? ?? '',
      availableMaterials: listOf(json['availableMaterials']),
      neededFeatures: listOf(json['neededFeatures']),
      desiredLevel: json['desiredLevel'] as String? ?? '',
      referenceSites: json['referenceSites'] as String? ?? '',
      otherRequests: json['otherRequests'] as String? ?? '',
      contactName: json['contactName'] as String? ?? '',
      contactEmail: json['contactEmail'] as String? ?? '',
      contactPhone: json['contactPhone'] as String? ?? '',
    );
  }
}
