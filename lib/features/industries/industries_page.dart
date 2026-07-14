import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/industry.dart';
import '../../core/services/content_repository.dart';
import '../../shared/widgets/cta_button.dart';
import '../../shared/widgets/empty_or_error.dart';
import '../../shared/widgets/info_card.dart';
import '../../shared/widgets/notice_banner.dart';
import '../../shared/widgets/page_scaffold_body.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/tag_chip.dart';

class IndustriesPage extends StatefulWidget {
  const IndustriesPage({super.key, this.repository});

  final ContentRepository? repository;

  @override
  State<IndustriesPage> createState() => _IndustriesPageState();
}

class _IndustriesPageState extends State<IndustriesPage> {
  late final ContentRepository _repo = widget.repository ?? ContentRepository();
  late Future<List<Industry>> _future;
  String? _selectedId;

  static const _disclaimer =
      '아래 내용은 실제 고객 사례나 제작 실적이 아닙니다. 「예시 구성」과 「샘플 시나리오」로 읽어 주세요.';

  @override
  void initState() {
    super.initState();
    _future = _repo.loadIndustries();
  }

  void _retry() {
    setState(() {
      _repo.clearCache();
      _future = _repo.loadIndustries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffoldBody(
      child: FutureBuilder<List<Industry>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 64),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return EmptyOrError(
              title: '불러오지 못했습니다',
              message: '업종별 예시 정보를 가져오는 중 문제가 발생했습니다.',
              isError: true,
              onRetry: _retry,
            );
          }
          final industries = snapshot.data ?? const [];
          if (industries.isEmpty) {
            return const EmptyOrError(message: '표시할 업종 예시가 없습니다.');
          }

          final selectedId = _selectedId ?? industries.first.id;
          final selected = industries.firstWhere((e) => e.id == selectedId);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: '업종별 제작 방향',
                subtitle:
                    '업종마다 고객이 궁금해하는 정보와 화면 구성이 다릅니다. 아래는 참고용 예시이며, 실제 제작 범위는 상담에서 정합니다.',
              ),
              const NoticeBanner(message: _disclaimer),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final industry in industries)
                    TagChip(
                      label: industry.name,
                      selected: industry.id == selected.id,
                      onTap: () => setState(() => _selectedId = industry.id),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              _IndustryDetail(industry: selected),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  CtaButton(
                    label: '상담 준비하기',
                    icon: Icons.chat_bubble_outline,
                    onPressed: () => context.go('/consultation'),
                  ),
                  CtaButton(
                    label: '사이트 구성 예시 보기',
                    variant: CtaVariant.secondary,
                    onPressed: () => context.go('/examples'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _IndustryDetail extends StatelessWidget {
  const _IndustryDetail({required this.industry});

  final Industry industry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InfoCard(
      accent: AppColors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(industry.name, style: theme.textTheme.titleLarge),
              TagChip(label: '예시 구성', selected: true, color: AppColors.teal),
              TagChip(
                label: '샘플 시나리오',
                selected: true,
                color: AppColors.purple,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _LabeledList(label: '고객이 궁금해하는 정보', items: industry.curiosities),
          const SizedBox(height: 18),
          _LabeledList(
            label: '추천 화면 구성 (예시)',
            items: industry.recommendedStructure,
          ),
          const SizedBox(height: 18),
          _LabeledList(label: '필요한 사진 예시', items: industry.neededPhotos),
          const SizedBox(height: 18),
          Text(
            '중요 CTA',
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            industry.importantCta,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.noticeBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.noticeBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '주의할 점',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  industry.caution,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.navy,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledList extends StatelessWidget {
  const _LabeledList({required this.label, required this.items});

  final String label;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(height: 1.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('·  ', style: style?.copyWith(color: AppColors.blue)),
                Expanded(child: Text(item, style: style)),
              ],
            ),
          ),
      ],
    );
  }
}
