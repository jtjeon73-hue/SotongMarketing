/// 제작 과정 단계.
class ProcessStep {
  const ProcessStep({
    required this.step,
    required this.title,
    required this.customerDoes,
    required this.sotongwareDoes,
    required this.description,
  });

  final int step;
  final String title;
  final String customerDoes;
  final String sotongwareDoes;
  final String description;

  factory ProcessStep.fromJson(Map<String, dynamic> json) {
    return ProcessStep(
      step: (json['step'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      customerDoes: json['customerDoes'] as String? ?? '',
      sotongwareDoes: json['sotongwareDoes'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'step': step,
    'title': title,
    'customerDoes': customerDoes,
    'sotongwareDoes': sotongwareDoes,
    'description': description,
  };
}
