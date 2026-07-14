import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/content_repository.dart';
import '../../shared/widgets/cta_button.dart';
import '../../shared/widgets/empty_or_error.dart';
import '../../shared/widgets/info_card.dart';
import '../../shared/widgets/notice_banner.dart';
import '../../shared/widgets/page_scaffold_body.dart';
import '../../shared/widgets/section_header.dart';

class UtilizationPage extends StatefulWidget {
  const UtilizationPage({super.key, this.repository});

  final ContentRepository? repository;

  @override
  State<UtilizationPage> createState() => _UtilizationPageState();
}

class _UtilizationPageState extends State<UtilizationPage> {
  late final ContentRepository _repo = widget.repository ?? ContentRepository();
  late Future<Map<String, dynamic>> _future;

  static const _fallbackCore =
      '하나의 링크에 사업의 핵심 정보를 정리하면 고객에게 반복해서 설명해야 하는 부담을 줄일 수 있습니다.';
  static const _fallbackSeo =
      '검색 노출이나 순위를 보장하지 않습니다. SEO는 검색엔진이 이해하기 좋은 제목·설명·구조·메타정보를 마련하는 기반 작업입니다.';

  @override
  void initState() {
    super.initState();
    _future = _repo.loadUtilizationMethods();
  }

  void _retry() {
    setState(() {
      _repo.clearCache();
      _future = _repo.loadUtilizationMethods();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffoldBody(
      child: FutureBuilder<Map<String, dynamic>>(
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
              message: '활용 방법 정보를 가져오는 중 문제가 발생했습니다.',
              isError: true,
              onRetry: _retry,
            );
          }

          final data = snapshot.data ?? const <String, dynamic>{};
          final coreMessage =
              (data['coreMessage'] as String?)?.trim().isNotEmpty == true
              ? data['coreMessage'] as String
              : _fallbackCore;
          final seoNote =
              (data['seoNote'] as String?)?.trim().isNotEmpty == true
              ? data['seoNote'] as String
              : _fallbackSeo;
          final rawMethods = data['methods'] as List<dynamic>? ?? const [];
          final methods = rawMethods
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();

          if (methods.isEmpty) {
            return const EmptyOrError(message: '표시할 활용 방법이 없습니다.');
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: '홍보 활용 방법',
                subtitle: '사이트를 만든 뒤 카카오톡·명함·SNS 등에서 어떻게 쓸 수 있는지 안내합니다.',
              ),
              InfoCard(
                accent: AppColors.teal,
                child: Text(
                  coreMessage,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    height: 1.55,
                    color: AppColors.navy,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              NoticeBanner(message: seoNote),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 720;
                  final crossAxisCount = wide ? 2 : 1;
                  const gap = 12.0;
                  final itemWidth =
                      (constraints.maxWidth - gap * (crossAxisCount - 1)) /
                      crossAxisCount;

                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (final method in methods)
                        SizedBox(
                          width: itemWidth,
                          child: _MethodCard(method: method),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  CtaButton(
                    label: '제작 후 관리 보기',
                    variant: CtaVariant.secondary,
                    onPressed: () => context.go('/maintenance'),
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

class _MethodCard extends StatelessWidget {
  const _MethodCard({required this.method});

  final Map<String, dynamic> method;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = method['name'] as String? ?? '';
    final description = method['description'] as String? ?? '';
    final tip = method['tip'] as String? ?? '';

    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: theme.textTheme.titleMedium),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
          if (tip.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              tip,
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
