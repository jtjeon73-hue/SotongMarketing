import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/content_block.dart';
import '../../core/services/content_repository.dart';
import '../../shared/widgets/cta_button.dart';
import '../../shared/widgets/empty_or_error.dart';
import '../../shared/widgets/info_card.dart';
import '../../shared/widgets/notice_banner.dart';
import '../../shared/widgets/page_scaffold_body.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/tag_chip.dart';

class CustomMarketingPage extends StatefulWidget {
  const CustomMarketingPage({super.key, this.repository});

  final ContentRepository? repository;

  @override
  State<CustomMarketingPage> createState() => _CustomMarketingPageState();
}

class _CustomMarketingPageState extends State<CustomMarketingPage> {
  late final ContentRepository _repo = widget.repository ?? ContentRepository();
  late Future<ContentBlocksCatalog> _future;

  static const _disclaimer = '실제 구현 가능 여부와 외부 서비스 정책에 따라 기능은 상담 후 확정됩니다.';

  @override
  void initState() {
    super.initState();
    _future = _repo.loadContentBlocks();
  }

  void _retry() {
    setState(() {
      _repo.clearCache();
      _future = _repo.loadContentBlocks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffoldBody(
      child: FutureBuilder<ContentBlocksCatalog>(
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
              message: '맞춤형 구성 정보를 가져오는 중 문제가 발생했습니다.',
              isError: true,
              onRetry: _retry,
            );
          }
          final catalog = snapshot.data;
          if (catalog == null ||
              (catalog.contentBlocks.isEmpty &&
                  catalog.featureBlocks.isEmpty)) {
            return const EmptyOrError(message: '표시할 구성 블록이 없습니다.');
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: '맞춤형 마케팅 구성',
                subtitle:
                    '콘텐츠 블록과 기능 블록을 조합해 목적에 맞는 홍보사이트를 만듭니다. 모든 항목을 넣을 필요는 없습니다.',
              ),
              const NoticeBanner(message: _disclaimer),
              const SizedBox(height: 28),
              if (catalog.contentBlocks.isNotEmpty) ...[
                const SectionHeader(
                  title: '콘텐츠 블록',
                  subtitle: '무엇을 보여 줄지 정하는 영역입니다. 목적에 맞는 것만 골라 조합합니다.',
                  padding: EdgeInsets.only(bottom: 16),
                ),
                _BlockGrid(
                  blocks: catalog.contentBlocks,
                  accent: AppColors.blue,
                ),
                const SizedBox(height: 32),
              ],
              if (catalog.featureBlocks.isNotEmpty) ...[
                const SectionHeader(
                  title: '기능 블록',
                  subtitle: '검색·공유·연락 등 방문자 행동을 돕는 기능입니다. 필요에 따라 붙입니다.',
                  padding: EdgeInsets.only(bottom: 16),
                ),
                _BlockGrid(
                  blocks: catalog.featureBlocks,
                  accent: AppColors.teal,
                ),
                const SizedBox(height: 28),
              ],
              InfoCard(
                title: '조합 예시 방향',
                accent: AppColors.purple,
                child: Text(
                  '예를 들어 ‘메인 메시지 + 제품 소개 + FAQ + 문의’처럼 핵심만 묶거나, ‘회사 소개 + 포트폴리오 + 검색·필터 + 공유’처럼 확장할 수 있습니다. 가짜 후기·과장 수치는 넣지 않습니다.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  CtaButton(
                    label: '상담으로 구성 잡기',
                    icon: Icons.chat_bubble_outline,
                    onPressed: () => context.go('/consultation'),
                  ),
                  CtaButton(
                    label: '제작 등급 보기',
                    variant: CtaVariant.secondary,
                    onPressed: () => context.go('/packages'),
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

class _BlockGrid extends StatelessWidget {
  const _BlockGrid({required this.blocks, required this.accent});

  final List<ContentBlock> blocks;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 900
            ? 3
            : width >= 560
            ? 2
            : 1;
        const gap = 12.0;
        final itemWidth = (width - gap * (crossAxisCount - 1)) / crossAxisCount;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final block in blocks)
              SizedBox(
                width: itemWidth,
                child: _BlockCard(block: block, accent: accent),
              ),
          ],
        );
      },
    );
  }
}

class _BlockCard extends StatelessWidget {
  const _BlockCard({required this.block, required this.accent});

  final ContentBlock block;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryLabel = block.category == ContentBlockCategory.feature
        ? '기능'
        : '콘텐츠';

    return InfoCard(
      accent: accent,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TagChip(label: categoryLabel, color: accent, selected: true),
          const SizedBox(height: 10),
          Text(block.label, style: theme.textTheme.titleSmall),
          if (block.description.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              block.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.muted,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
