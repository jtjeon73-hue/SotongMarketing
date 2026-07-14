import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/site_example.dart';
import '../../core/services/content_repository.dart';
import '../../shared/widgets/cta_button.dart';
import '../../shared/widgets/empty_or_error.dart';
import '../../shared/widgets/info_card.dart';
import '../../shared/widgets/notice_banner.dart';
import '../../shared/widgets/page_scaffold_body.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/tag_chip.dart';

class ExamplesPage extends StatefulWidget {
  const ExamplesPage({super.key, this.repository});

  final ContentRepository? repository;

  @override
  State<ExamplesPage> createState() => _ExamplesPageState();
}

class _ExamplesPageState extends State<ExamplesPage> {
  late final ContentRepository _repo = widget.repository ?? ContentRepository();
  late Future<List<SiteExample>> _future;

  static const _bannerMessage =
      '가능한 사이트 구성 예시이며, 실제 제작 결과가 아닙니다. 가짜 포트폴리오가 아닌 샘플 시나리오입니다.';

  @override
  void initState() {
    super.initState();
    _future = _repo.loadSiteExamples();
  }

  void _retry() {
    setState(() {
      _repo.clearCache();
      _future = _repo.loadSiteExamples();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffoldBody(
      child: FutureBuilder<List<SiteExample>>(
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
              message: '사이트 구성 예시를 가져오는 중 문제가 발생했습니다.',
              isError: true,
              onRetry: _retry,
            );
          }
          final examples = snapshot.data ?? const [];
          if (examples.isEmpty) {
            return const EmptyOrError(message: '표시할 구성 예시가 없습니다.');
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: '사이트 구성 예시',
                subtitle: '실제 고객 프로젝트가 아니며, 목적에 따라 어떻게 구성할 수 있는지 보여주는 데모입니다.',
              ),
              const NoticeBanner(
                message: _bannerMessage,
                icon: Icons.info_outline,
              ),
              const SizedBox(height: 24),
              for (var i = 0; i < examples.length; i++) ...[
                if (i > 0) const SizedBox(height: 16),
                _ExampleCard(example: examples[i], index: i + 1),
              ],
              const SizedBox(height: 28),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  CtaButton(
                    label: '업종별 방향 보기',
                    variant: CtaVariant.secondary,
                    onPressed: () => context.go('/industries'),
                  ),
                  CtaButton(
                    label: '상담 준비하기',
                    icon: Icons.chat_bubble_outline,
                    onPressed: () => context.go('/consultation'),
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

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.example, required this.index});

  final SiteExample example;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InfoCard(
      accent: AppColors.teal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '예시 $index · ${example.title}',
                style: theme.textTheme.titleLarge,
              ),
              TagChip(
                label: example.label.isEmpty ? '가능한 사이트 구성 예시' : example.label,
                selected: true,
                color: AppColors.teal,
              ),
              TagChip(
                label: example.scenarioType.isEmpty
                    ? '샘플 시나리오'
                    : example.scenarioType,
                selected: true,
                color: AppColors.purple,
              ),
            ],
          ),
          if (example.subtitle.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              example.subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.muted,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 18),
          Text(
            '구성 섹션',
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < example.sections.length; i++)
            _SectionRow(index: i + 1, section: example.sections[i]),
          if (example.suitablePackageHint.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                example.suitablePackageHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.muted,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({required this.index, required this.section});

  final int index;
  final SiteExampleSection section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$index',
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.blue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(section.title, style: theme.textTheme.titleSmall),
                if (section.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    section.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.muted,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
