import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/needs_selection.dart';
import '../../core/services/package_recommender.dart';
import '../../shared/widgets/cta_button.dart';
import '../../shared/widgets/info_card.dart';
import '../../shared/widgets/notice_banner.dart';
import '../../shared/widgets/page_scaffold_body.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/tag_chip.dart';

class NeedsPage extends StatefulWidget {
  const NeedsPage({super.key});

  @override
  State<NeedsPage> createState() => _NeedsPageState();
}

class _NeedsPageState extends State<NeedsPage> {
  NeedsSelection _selection = const NeedsSelection();

  static const _whatOptions = <String>[
    '회사',
    '매장',
    '상품',
    '서비스',
    '농산물',
    '관광·숙박',
    '기술',
    '앱',
    '개인 브랜드',
    '행사',
    '기타',
  ];

  static const _purposeOptions = <String>[
    '회사 소개',
    '상품 소개',
    '문의 증가',
    '방문 유도',
    '구매 연결',
    '신뢰도 향상',
    '포트폴리오',
    '카카오톡 공유',
    '검색 노출 기반 마련',
    '여러 정보를 하나의 링크로 정리',
  ];

  static const _showcaseOptions = <String>[
    '사진',
    '기술력',
    '가격',
    '특징',
    '후기',
    '위치',
    '제작 과정',
    '제품 비교',
    '대표자의 이야기',
    '브랜드 스토리',
  ];

  static const _levelOptions = <String>[
    '간단한 소개',
    '전문적인 소개 홍보',
    '많은 콘텐츠',
    '고급 브랜드 이미지',
    '지속적인 보완',
    '아직 잘 모르겠음',
  ];

  void _selectWhat(String value) {
    setState(() => _selection = _selection.copyWith(what: value));
  }

  void _selectPurpose(String value) {
    setState(() => _selection = _selection.copyWith(purpose: value));
  }

  void _selectShowcase(String value) {
    setState(() => _selection = _selection.copyWith(showcase: value));
  }

  void _selectLevel(String value) {
    setState(() => _selection = _selection.copyWith(level: value));
  }

  void _reset() {
    setState(() => _selection = const NeedsSelection());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recommendation = PackageRecommender.recommend(_selection);
    final answered = [
      _selection.what,
      _selection.purpose,
      _selection.showcase,
      _selection.level,
    ].where((e) => e.isNotEmpty).length;

    return PageScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: '어떤 홍보가 필요할까요?',
            subtitle:
                '네 가지 질문에 답하면, 브라우저에서만 적합한 제작 유형을 안내합니다. '
                '서버로 전송되지 않으며 자동 견적은 하지 않습니다.',
          ),
          const NoticeBanner(
            message:
                '추천은 선택 내용을 바탕으로 한 안내입니다. '
                '정확한 제작 범위와 비용은 상담 후 결정됩니다.',
          ),
          const SizedBox(height: 16),
          Text(
            '진행 $answered / 4',
            style: theme.textTheme.labelLarge?.copyWith(color: AppColors.blue),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: answered / 4,
              minHeight: 6,
              backgroundColor: AppColors.border,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(height: 28),
          _QuestionCard(
            step: 1,
            title: '무엇을 홍보하시나요?',
            options: _whatOptions,
            selected: _selection.what,
            onSelected: _selectWhat,
            accent: AppColors.blue,
          ),
          const SizedBox(height: 16),
          _QuestionCard(
            step: 2,
            title: '가장 중요한 목적은 무엇인가요?',
            options: _purposeOptions,
            selected: _selection.purpose,
            onSelected: _selectPurpose,
            accent: AppColors.teal,
          ),
          const SizedBox(height: 16),
          _QuestionCard(
            step: 3,
            title: '고객에게 가장 보여주고 싶은 것은?',
            options: _showcaseOptions,
            selected: _selection.showcase,
            onSelected: _selectShowcase,
            accent: AppColors.purple,
          ),
          const SizedBox(height: 16),
          _QuestionCard(
            step: 4,
            title: '필요한 수준은?',
            options: _levelOptions,
            selected: _selection.level,
            onSelected: _selectLevel,
            accent: AppColors.coral,
          ),
          const SizedBox(height: 32),
          InfoCard(
            title: _selection.isComplete ? '추천 제작 유형' : '선택을 완료해 주세요',
            accent: _selection.isComplete ? AppColors.blue : AppColors.muted,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation.message,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.navy,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  recommendation.rationale,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.muted,
                    height: 1.55,
                  ),
                ),
                if (_selection.isComplete &&
                    recommendation.suggestedPackageIds.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final id in recommendation.suggestedPackageIds)
                        TagChip(
                          label: _packageLabel(id),
                          selected: true,
                          color: AppColors.blue,
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    CtaButton(
                      label: '제작 등급 살펴보기',
                      onPressed: () => context.go('/packages'),
                    ),
                    CtaButton(
                      label: '상담 준비하기',
                      variant: CtaVariant.secondary,
                      onPressed: () => context.go('/consultation'),
                    ),
                    if (answered > 0)
                      CtaButton(
                        label: '다시 선택',
                        variant: CtaVariant.secondary,
                        onPressed: _reset,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static String _packageLabel(String id) {
    return switch (id) {
      'start' => '스타트',
      'business' => '비즈니스',
      'premium' => '프리미엄',
      'custom' => '맞춤 프로젝트',
      _ => id,
    };
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.step,
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.accent,
  });

  final int step;
  final String title;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InfoCard(
      accent: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '질문 $step',
            style: theme.textTheme.labelLarge?.copyWith(color: accent),
          ),
          const SizedBox(height: 6),
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in options)
                TagChip(
                  label: option,
                  selected: selected == option,
                  color: accent,
                  onTap: () => onSelected(option),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
