import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/service_type.dart';
import '../../core/services/content_repository.dart';
import '../../shared/widgets/cta_button.dart';
import '../../shared/widgets/empty_or_error.dart';
import '../../shared/widgets/page_scaffold_body.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/tag_chip.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key, this.repository});

  final ContentRepository? repository;

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late final ContentRepository _repo = widget.repository ?? ContentRepository();
  late Future<List<ServiceType>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.loadServiceTypes();
  }

  void _retry() {
    setState(() {
      _repo.clearCache();
      _future = _repo.loadServiceTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffoldBody(
      child: FutureBuilder<List<ServiceType>>(
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
              message: '서비스 유형 정보를 가져오는 중 문제가 발생했습니다.',
              isError: true,
              onRetry: _retry,
            );
          }
          final types = snapshot.data ?? const [];
          if (types.isEmpty) {
            return const EmptyOrError(message: '표시할 서비스 유형이 없습니다.');
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: '홍보사이트 제작',
                subtitle:
                    '목적과 업종에 맞는 사이트 유형을 고릅니다. 아래에서 적합 고객·구성·필요 자료를 확인해 보세요.',
              ),
              ...types.map(
                (type) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ServiceTypeTile(type: type),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  CtaButton(
                    label: '상담으로 유형 정하기',
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

class _ServiceTypeTile extends StatelessWidget {
  const _ServiceTypeTile({required this.type});

  final ServiceType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(type.name, style: theme.textTheme.titleMedium),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              type.mainPurpose,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.muted,
                height: 1.45,
              ),
            ),
          ),
          children: [
            _FieldBlock(
              label: '이런 분께 적합합니다',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: type.suitableCustomers
                    .map((c) => TagChip(label: c))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _FieldBlock(
              label: '주요 목적',
              child: Text(
                type.mainPurpose,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ),
            const SizedBox(height: 16),
            _FieldBlock(
              label: '추천 구성',
              child: _BulletList(items: type.recommendedStructure),
            ),
            const SizedBox(height: 16),
            _FieldBlock(
              label: '준비하면 좋은 자료',
              child: _BulletList(items: type.neededMaterials),
            ),
            if (type.expandableFeatures.isNotEmpty) ...[
              const SizedBox(height: 16),
              _FieldBlock(
                label: '확장 가능한 기능',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: type.expandableFeatures
                      .map((f) => TagChip(label: f, color: AppColors.teal))
                      .toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FieldBlock extends StatelessWidget {
  const _FieldBlock({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
