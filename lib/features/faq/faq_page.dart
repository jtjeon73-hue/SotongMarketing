import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/faq_item.dart';
import '../../core/services/content_repository.dart';
import '../../shared/widgets/cta_button.dart';
import '../../shared/widgets/empty_or_error.dart';
import '../../shared/widgets/page_scaffold_body.dart';
import '../../shared/widgets/section_header.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key, this.repository});

  final ContentRepository? repository;

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  late final ContentRepository _repo = widget.repository ?? ContentRepository();
  late Future<List<FaqItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.loadFaqs();
  }

  void _retry() {
    setState(() {
      _repo.clearCache();
      _future = _repo.loadFaqs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffoldBody(
      child: FutureBuilder<List<FaqItem>>(
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
              message: '자주 묻는 질문을 가져오는 중 문제가 발생했습니다.',
              isError: true,
              onRetry: _retry,
            );
          }
          final faqs = snapshot.data ?? const [];
          if (faqs.isEmpty) {
            return const EmptyOrError(message: '등록된 질문이 없습니다.');
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: '자주 묻는 질문',
                subtitle:
                    '가격·기간·수정·공유 등 자주 궁금해하시는 내용을 모았습니다. 세부 범위는 상담에서 확인합니다.',
              ),
              for (final faq in faqs)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _FaqTile(item: faq),
                ),
              const SizedBox(height: 20),
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
                    label: '문의하기',
                    variant: CtaVariant.secondary,
                    onPressed: () => context.go('/contact'),
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

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.item});

  final FaqItem item;

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
          title: Text(item.question, style: theme.textTheme.titleSmall),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.answer,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.55,
                  color: AppColors.body,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
