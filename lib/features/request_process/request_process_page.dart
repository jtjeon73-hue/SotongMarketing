import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../shared/widgets/cta_button.dart';
import '../../shared/widgets/info_card.dart';
import '../../shared/widgets/notice_banner.dart';
import '../../shared/widgets/page_scaffold_body.dart';
import '../../shared/widgets/section_header.dart';

class RequestProcessPage extends StatelessWidget {
  const RequestProcessPage({super.key});

  static const _steps = <String>[
    '상담 요청',
    '기본 내용 확인',
    '필요한 자료 협의',
    '제작 범위 협의',
    '견적 및 일정 협의',
    '제작 시작',
    '1차 확인',
    '보완',
    '최종 확인',
    '배포',
  ];

  static const _note =
      '계약·결제 방식은 프로젝트와 협의 내용에 따라 달라질 수 있습니다. 이 화면에서는 임의의 계약 조건을 확정하지 않습니다.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PageScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: '제작 의뢰 절차',
            subtitle: '상담 요청부터 배포까지, 일반적인 진행 흐름을 안내합니다.',
          ),
          const NoticeBanner(message: _note),
          const SizedBox(height: 24),
          InfoCard(
            accent: AppColors.blue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < _steps.length; i++) ...[
                  if (i > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 19, bottom: 4),
                      child: Container(
                        width: 2,
                        height: 16,
                        color: AppColors.border,
                      ),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.blue.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.blue),
                        ),
                        child: Text(
                          '${i + 1}',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: AppColors.blue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          _steps[i],
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '각 단계의 세부 일정과 산출물은 상담에서 목적·자료·범위에 맞춰 함께 정합니다.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.muted,
              height: 1.5,
            ),
          ),
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
                label: '문의하기',
                variant: CtaVariant.secondary,
                onPressed: () => context.go('/contact'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
