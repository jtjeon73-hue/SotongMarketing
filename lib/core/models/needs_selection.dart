/// 「어떤 홍보가 필요할까요?」 선택 결과.
class NeedsSelection {
  const NeedsSelection({
    this.what = '',
    this.purpose = '',
    this.showcase = '',
    this.level = '',
  });

  /// 무엇을 홍보하시나요?
  final String what;

  /// 가장 중요한 목적
  final String purpose;

  /// 가장 보여주고 싶은 것
  final String showcase;

  /// 필요한 수준
  final String level;

  bool get isComplete =>
      what.isNotEmpty &&
      purpose.isNotEmpty &&
      showcase.isNotEmpty &&
      level.isNotEmpty;

  NeedsSelection copyWith({
    String? what,
    String? purpose,
    String? showcase,
    String? level,
  }) {
    return NeedsSelection(
      what: what ?? this.what,
      purpose: purpose ?? this.purpose,
      showcase: showcase ?? this.showcase,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toJson() => {
    'what': what,
    'purpose': purpose,
    'showcase': showcase,
    'level': level,
  };

  factory NeedsSelection.fromJson(Map<String, dynamic> json) {
    return NeedsSelection(
      what: json['what'] as String? ?? '',
      purpose: json['purpose'] as String? ?? '',
      showcase: json['showcase'] as String? ?? '',
      level: json['level'] as String? ?? '',
    );
  }
}
