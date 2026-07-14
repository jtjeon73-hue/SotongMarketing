import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/consultation_draft.dart';
import '../../core/services/consultation_summary.dart';
import '../../core/services/content_repository.dart';
import '../../shared/widgets/cta_button.dart';
import '../../shared/widgets/empty_or_error.dart';
import '../../shared/widgets/info_card.dart';
import '../../shared/widgets/notice_banner.dart';
import '../../shared/widgets/page_scaffold_body.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/tag_chip.dart';

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({super.key, this.repository});

  final ContentRepository? repository;

  @override
  State<ConsultationPage> createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  static const _prefsKey = 'consultation_draft_v1';

  late final ContentRepository _repo = widget.repository ?? ContentRepository();
  late Future<Map<String, dynamic>> _future;

  ConsultationDraft _draft = const ConsultationDraft();
  int _stepIndex = 0;
  bool _showSummary = false;
  bool _prefsReady = false;

  final _projectNameCtrl = TextEditingController();
  final _highlightsExtraCtrl = TextEditingController();
  final _referenceCtrl = TextEditingController();
  final _otherCtrl = TextEditingController();
  final _contactNameCtrl = TextEditingController();
  final _contactEmailCtrl = TextEditingController();
  final _contactPhoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _future = _repo.loadConsultationOptions();
    _restoreDraft();
  }

  @override
  void dispose() {
    _projectNameCtrl.dispose();
    _highlightsExtraCtrl.dispose();
    _referenceCtrl.dispose();
    _otherCtrl.dispose();
    _contactNameCtrl.dispose();
    _contactEmailCtrl.dispose();
    _contactPhoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _restoreDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw != null && raw.isNotEmpty) {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        final draft = ConsultationDraft.fromJson(map);
        if (!mounted) return;
        setState(() {
          _draft = draft;
          _syncControllers(draft);
          _prefsReady = true;
        });
        return;
      }
    } catch (_) {
      // 로컬 복원 실패 시 빈 초안으로 진행
    }
    if (!mounted) return;
    setState(() => _prefsReady = true);
  }

  void _syncControllers(ConsultationDraft draft) {
    _projectNameCtrl.text = draft.projectName;
    _referenceCtrl.text = draft.referenceSites;
    _otherCtrl.text = draft.otherRequests;
    _contactNameCtrl.text = draft.contactName;
    _contactEmailCtrl.text = draft.contactEmail;
    _contactPhoneCtrl.text = draft.contactPhone;
  }

  Future<void> _persistDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, jsonEncode(_draft.toJson()));
    } catch (_) {
      // 브라우저 저장 실패해도 메모리 초안은 유지
    }
  }

  void _updateDraft(ConsultationDraft draft) {
    setState(() => _draft = draft);
    _persistDraft();
  }

  Future<void> _clearDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefsKey);
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _draft = const ConsultationDraft();
      _stepIndex = 0;
      _showSummary = false;
      _syncControllers(const ConsultationDraft());
      _highlightsExtraCtrl.clear();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('작성 내용을 모두 지웠습니다.')));
  }

  void _retry() {
    setState(() {
      _repo.clearCache();
      _future = _repo.loadConsultationOptions();
    });
  }

  List<Map<String, String>> _options(Map<String, dynamic> data, String key) {
    final raw = data[key] as List<dynamic>? ?? const [];
    return raw
        .whereType<Map>()
        .map((e) {
          final m = Map<String, dynamic>.from(e);
          return {
            'id': m['id']?.toString() ?? '',
            'label': m['label']?.toString() ?? '',
          };
        })
        .where((e) => e['label']!.isNotEmpty)
        .toList();
  }

  String _privacyNotice(Map<String, dynamic> data) {
    final fromJson = data['privacyNotice'] as String?;
    if (fromJson != null && fromJson.trim().isNotEmpty) return fromJson;
    return '작성한 내용은 현재 브라우저에서 상담 내용을 정리하기 위한 용도로 사용되며, '
        '자동으로 서버에 저장되지 않습니다.';
  }

  void _goNext(int totalSteps) {
    if (_stepIndex >= totalSteps - 1) {
      setState(() => _showSummary = true);
      return;
    }
    setState(() => _stepIndex += 1);
  }

  void _goBack() {
    if (_showSummary) {
      setState(() => _showSummary = false);
      return;
    }
    if (_stepIndex > 0) {
      setState(() => _stepIndex -= 1);
    }
  }

  Future<void> _copySummary() async {
    final text = ConsultationSummary.buildSummaryText(_draft);
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('상담 요약을 복사했습니다.')));
  }

  Future<void> _sendEmail() async {
    final uri = ConsultationSummary.buildMailtoUri(_draft);
    final launched = await launchUrl(uri);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('메일 앱을 열 수 없습니다. 「내용 복사」로 붙여 넣어 주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffoldBody(
      child: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              !_prefsReady) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 64),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return EmptyOrError(
              title: '불러오지 못했습니다',
              message: '상담 선택 항목을 가져오는 중 문제가 발생했습니다.',
              isError: true,
              onRetry: _retry,
            );
          }

          final options = snapshot.data ?? const <String, dynamic>{};
          final steps = (options['steps'] as List<dynamic>? ?? const [])
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
          final totalSteps = steps.isEmpty ? 10 : steps.length;
          final privacy = _privacyNotice(options);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: '상담 준비하기',
                subtitle: '브라우저에서 상담 내용을 정리하는 도우미입니다. 서버에 자동 저장되지 않습니다.',
              ),
              NoticeBanner(message: privacy),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed:
                      _draft.hasAnyContent ||
                          _draft.contactName.isNotEmpty ||
                          _draft.contactEmail.isNotEmpty ||
                          _draft.contactPhone.isNotEmpty
                      ? _clearDraft
                      : null,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('작성 내용 지우기'),
                ),
              ),
              const SizedBox(height: 8),
              _ProgressBar(
                current: _showSummary ? totalSteps : _stepIndex + 1,
                total: totalSteps,
                showingSummary: _showSummary,
              ),
              const SizedBox(height: 20),
              if (_showSummary)
                _SummaryView(
                  draft: _draft,
                  nameCtrl: _contactNameCtrl,
                  emailCtrl: _contactEmailCtrl,
                  phoneCtrl: _contactPhoneCtrl,
                  onContactChanged: () {
                    _updateDraft(
                      _draft.copyWith(
                        contactName: _contactNameCtrl.text,
                        contactEmail: _contactEmailCtrl.text,
                        contactPhone: _contactPhoneCtrl.text,
                      ),
                    );
                  },
                  onCopy: _copySummary,
                  onEmail: _sendEmail,
                  onBack: _goBack,
                )
              else
                _StepPanel(
                  step: steps.isEmpty
                      ? {'id': _stepIndex + 1, 'title': '상담 항목'}
                      : steps[_stepIndex.clamp(0, steps.length - 1)],
                  draft: _draft,
                  options: options,
                  projectNameCtrl: _projectNameCtrl,
                  highlightsExtraCtrl: _highlightsExtraCtrl,
                  referenceCtrl: _referenceCtrl,
                  otherCtrl: _otherCtrl,
                  optionList: _options,
                  onDraftChanged: _updateDraft,
                  onBack: _stepIndex > 0 ? _goBack : null,
                  onNext: () => _goNext(totalSteps),
                  isLast: _stepIndex >= totalSteps - 1,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.current,
    required this.total,
    required this.showingSummary,
  });

  final int current;
  final int total;
  final bool showingSummary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = showingSummary ? 1.0 : current / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              showingSummary ? '상담 요약' : '$current / $total 단계',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.navy,
              ),
            ),
            const Spacer(),
            Text(
              '${(progress * 100).round()}%',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.border,
            color: AppColors.blue,
          ),
        ),
      ],
    );
  }
}

class _StepPanel extends StatelessWidget {
  const _StepPanel({
    required this.step,
    required this.draft,
    required this.options,
    required this.projectNameCtrl,
    required this.highlightsExtraCtrl,
    required this.referenceCtrl,
    required this.otherCtrl,
    required this.optionList,
    required this.onDraftChanged,
    required this.onNext,
    required this.isLast,
    this.onBack,
  });

  final Map<String, dynamic> step;
  final ConsultationDraft draft;
  final Map<String, dynamic> options;
  final TextEditingController projectNameCtrl;
  final TextEditingController highlightsExtraCtrl;
  final TextEditingController referenceCtrl;
  final TextEditingController otherCtrl;
  final List<Map<String, String>> Function(Map<String, dynamic>, String)
  optionList;
  final ValueChanged<ConsultationDraft> onDraftChanged;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final key = step['key']?.toString() ?? '';
    final title = step['title']?.toString() ?? '상담 항목';
    final stepId = step['id']?.toString() ?? '';

    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STEP $stepId',
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.blue,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          _buildFields(context, key),
          const SizedBox(height: 24),
          Row(
            children: [
              if (onBack != null)
                CtaButton(
                  label: '이전',
                  variant: CtaVariant.secondary,
                  onPressed: onBack,
                ),
              const Spacer(),
              CtaButton(label: isLast ? '요약 보기' : '다음', onPressed: onNext),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFields(BuildContext context, String key) {
    switch (key) {
      case 'whatToPromote':
        return _SingleSelectChips(
          items: optionList(options, 'whatToPromote'),
          selected: draft.whatToPromote,
          onSelected: (label) =>
              onDraftChanged(draft.copyWith(whatToPromote: label)),
        );
      case 'projectName':
        return TextField(
          controller: projectNameCtrl,
          decoration: const InputDecoration(
            hintText: '업체명 또는 프로젝트명을 입력해 주세요',
            labelText: '업체·프로젝트 이름',
          ),
          onChanged: (v) => onDraftChanged(draft.copyWith(projectName: v)),
        );
      case 'customers':
        return _MultiSelectChips(
          items: optionList(options, 'customers'),
          selected: draft.mainCustomers,
          onChanged: (list) =>
              onDraftChanged(draft.copyWith(mainCustomers: list)),
        );
      case 'purposes':
        return _SingleSelectChips(
          items: optionList(options, 'purposes'),
          selected: draft.mainPurpose,
          onSelected: (label) =>
              onDraftChanged(draft.copyWith(mainPurpose: label)),
        );
      case 'highlights':
        final knownLabels = optionList(
          options,
          'highlights',
        ).map((e) => e['label']!).toSet();
        final selectedChips = _splitHighlights(
          draft.highlights,
        ).where(knownLabels.contains).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MultiSelectChips(
              items: optionList(options, 'highlights'),
              selected: selectedChips,
              onChanged: (list) {
                final extra = highlightsExtraCtrl.text.trim();
                final merged = [...list, if (extra.isNotEmpty) extra];
                onDraftChanged(draft.copyWith(highlights: merged.join(', ')));
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: highlightsExtraCtrl,
              decoration: const InputDecoration(
                labelText: '추가로 강조하고 싶은 내용 (선택)',
                hintText: '자유롭게 적어 주세요',
              ),
              maxLines: 3,
              onChanged: (v) {
                final chips = _splitHighlights(
                  draft.highlights,
                ).where(knownLabels.contains).toList();
                final merged = [...chips, if (v.trim().isNotEmpty) v.trim()];
                onDraftChanged(draft.copyWith(highlights: merged.join(', ')));
              },
            ),
          ],
        );
      case 'materials':
        return _MultiSelectChips(
          items: optionList(options, 'materials'),
          selected: draft.availableMaterials,
          onChanged: (list) =>
              onDraftChanged(draft.copyWith(availableMaterials: list)),
        );
      case 'features':
        return _MultiSelectChips(
          items: optionList(options, 'features'),
          selected: draft.neededFeatures,
          onChanged: (list) =>
              onDraftChanged(draft.copyWith(neededFeatures: list)),
        );
      case 'levels':
        return _SingleSelectChips(
          items: optionList(options, 'levels'),
          selected: draft.desiredLevel,
          onSelected: (label) =>
              onDraftChanged(draft.copyWith(desiredLevel: label)),
        );
      case 'referenceSites':
        return TextField(
          controller: referenceCtrl,
          decoration: const InputDecoration(
            labelText: '참고 사이트 (선택)',
            hintText: '주소나 이름이 있으면 적어 주세요. 없어도 괜찮습니다.',
          ),
          maxLines: 3,
          onChanged: (v) => onDraftChanged(draft.copyWith(referenceSites: v)),
        );
      case 'otherRequests':
        return TextField(
          controller: otherCtrl,
          decoration: const InputDecoration(
            labelText: '기타 요청사항 (선택)',
            hintText: '일정·범위·특별히 바라는 점이 있으면 적어 주세요.',
          ),
          maxLines: 4,
          onChanged: (v) => onDraftChanged(draft.copyWith(otherRequests: v)),
        );
      default:
        return Text(
          '이 단계의 입력을 준비 중입니다.',
          style: Theme.of(context).textTheme.bodyMedium,
        );
    }
  }

  static List<String> _splitHighlights(String value) {
    return value
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
}

class _SingleSelectChips extends StatelessWidget {
  const _SingleSelectChips({
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final List<Map<String, String>> items;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in items)
          TagChip(
            label: item['label']!,
            selected: selected == item['label'],
            onTap: () => onSelected(item['label']!),
          ),
      ],
    );
  }
}

class _MultiSelectChips extends StatelessWidget {
  const _MultiSelectChips({
    required this.items,
    required this.selected,
    required this.onChanged,
  });

  final List<Map<String, String>> items;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in items)
          TagChip(
            label: item['label']!,
            selected: selected.contains(item['label']),
            onTap: () {
              final next = List<String>.from(selected);
              final label = item['label']!;
              if (next.contains(label)) {
                next.remove(label);
              } else {
                next.add(label);
              }
              onChanged(next);
            },
          ),
      ],
    );
  }
}

class _SummaryView extends StatelessWidget {
  const _SummaryView({
    required this.draft,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.onContactChanged,
    required this.onCopy,
    required this.onEmail,
    required this.onBack,
  });

  final ConsultationDraft draft;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final VoidCallback onContactChanged;
  final VoidCallback onCopy;
  final VoidCallback onEmail;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = ConsultationSummary.buildSummaryText(draft);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoCard(
          title: '연락 정보 (선택)',
          accent: AppColors.blue,
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: '이름'),
                onChanged: (_) => onContactChanged(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: '이메일'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => onContactChanged(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: '전화'),
                keyboardType: TextInputType.phone,
                onChanged: (_) => onContactChanged(),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '주민등록번호·카드번호 등 민감 정보는 적지 마세요. 연락 정보는 필수가 아닙니다.',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        InfoCard(
          title: '상담 요청 요약',
          child: SelectableText(
            summary,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.55,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            CtaButton(
              label: '내용 복사',
              icon: Icons.copy_outlined,
              onPressed: onCopy,
            ),
            CtaButton(
              label: '이메일 문의하기',
              icon: Icons.mail_outline,
              onPressed: onEmail,
            ),
            CtaButton(
              label: '이전 단계',
              variant: CtaVariant.secondary,
              onPressed: onBack,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '메일 앱이 제한되면 「내용 복사」 후 sotongware@naver.com 으로 붙여 넣어 주세요.',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
