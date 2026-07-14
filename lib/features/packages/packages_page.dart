import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/service_package.dart';
import '../../core/services/content_repository.dart';
import '../../shared/widgets/cta_button.dart';
import '../../shared/widgets/empty_or_error.dart';
import '../../shared/widgets/info_card.dart';
import '../../shared/widgets/notice_banner.dart';
import '../../shared/widgets/page_scaffold_body.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/tag_chip.dart';

class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key, this.repository});

  final ContentRepository? repository;

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  late final ContentRepository _repo = widget.repository ?? ContentRepository();
  late Future<List<ServicePackage>> _future;

  static const _costNote =
      '정확한 제작 범위와 비용은 콘텐츠 양, 기능, 디자인 수준, 자료 준비 상태, 추가 수정 범위에 따라 상담 후 결정됩니다.';

  static const _accents = <String, Color>{
    'start': AppColors.teal,
    'business': AppColors.blue,
    'premium': AppColors.purple,
    'custom': AppColors.coral,
  };

  @override
  void initState() {
    super.initState();
    _future = _repo.loadPackages();
  }

  void _retry() {
    setState(() {
      _repo.clearCache();
      _future = _repo.loadPackages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffoldBody(
      child: FutureBuilder<List<ServicePackage>>(
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
              message: '제작 등급 정보를 가져오는 중 문제가 발생했습니다.',
              isError: true,
              onRetry: _retry,
            );
          }
          final packages = snapshot.data ?? const [];
          if (packages.isEmpty) {
            return const EmptyOrError(message: '표시할 제작 등급이 없습니다.');
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: '제작 등급 안내',
                subtitle:
                    '등급은 가격표를 나열하기 위한 것이 아니라, 목적·콘텐츠 양·디자인 깊이에 따른 출발점입니다. 어떤 등급이 항상 더 좋지는 않습니다.',
              ),
              const NoticeBanner(message: _costNote),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 720;
                  final crossAxisCount = wide ? 2 : 1;
                  final gap = 16.0;
                  final itemWidth =
                      (constraints.maxWidth - gap * (crossAxisCount - 1)) /
                      crossAxisCount;

                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (final pkg in packages)
                        SizedBox(
                          width: itemWidth,
                          child: _PackageCard(
                            package: pkg,
                            accent: _accents[pkg.id] ?? AppColors.blue,
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              InfoCard(
                title: '등급 선택 전에',
                accent: AppColors.blue,
                child: Text(
                  '목적·대상·콘텐츠 양을 먼저 정리하면, 불필요하게 높은 등급을 고르지 않고도 맞는 구성을 찾을 수 있습니다. 제작 범위는 상담에서 함께 확정합니다.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: AppColors.body,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  CtaButton(
                    label: '상담으로 범위 정하기',
                    icon: Icons.chat_bubble_outline,
                    onPressed: () => context.go('/consultation'),
                  ),
                  CtaButton(
                    label: '제작 과정 보기',
                    variant: CtaVariant.secondary,
                    onPressed: () => context.go('/process'),
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

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package, required this.accent});

  final ServicePackage package;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InfoCard(
      accent: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TagChip(label: package.name, selected: true, color: accent),
          const SizedBox(height: 12),
          Text(package.subtitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            package.target,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.muted,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '포함되는 구성 예시',
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          for (final feature in package.features)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check, size: 16, color: accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
          if (package.note.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                package.note,
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
