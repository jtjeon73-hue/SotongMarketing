import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_info.dart';
import '../../core/constants/external_links.dart';
import '../../shared/widgets/cta_button.dart';
import '../../shared/widgets/info_card.dart';
import '../../shared/widgets/page_scaffold_body.dart';
import '../../shared/widgets/section_header.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const _fields = <String>[
    '홍보·마케팅 웹사이트 제작',
    'Flutter 앱 개발',
    'Windows·MFC 프로그램',
    '산업자동화',
    'PLC·센서·데이터 모니터링',
    'AI 활용',
    '콘텐츠 제작',
    '전자책',
    '농업·지역사회 디지털화',
  ];

  static const _strengths = <String>[
    '고객 목적 중심',
    '단계별 제작',
    '실제 화면 확인 후 보완',
    'PC·모바일 대응',
    'AI를 활용한 빠른 기획·개발',
    '사람이 최종 확인하고 보완',
    '다양한 분야의 기술 경험',
    '제작 후 확장 가능성 고려',
  ];

  Future<void> _openExternal(String url) async {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PageScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: '소통웨어 소개',
            subtitle: '기술과 사람을 연결하는 제작 파트너',
          ),
          InfoCard(
            accent: AppColors.navy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppInfo.brandKo, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  AppInfo.brandEn,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '소통웨어는 기술을 만드는 것에서 끝나지 않고, '
                  '사람이 이해하고 활용할 수 있도록 연결합니다.',
                  style: theme.textTheme.titleMedium?.copyWith(
                    height: 1.55,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${AppInfo.serviceNameKo}은 그 연결의 한 축으로, '
                  '사업·상품·서비스의 가치를 고객이 이해하기 쉬운 홍보 사이트로 정리합니다.',
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('전문 분야', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final field in _fields)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(field, style: theme.textTheme.bodyMedium),
                ),
            ],
          ),
          const SizedBox(height: 28),
          Text('소통웨어의 강점', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          for (final strength in _strengths)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: AppColors.teal,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      strength,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 28),
          Text('관련 공개 사이트', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            '통제센터 등 비공개 시스템은 연결하지 않습니다. 아래는 공개 프로모 사이트입니다.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          for (final link in ExternalLinks.all)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InfoCard(
                onTap: () => _openExternal(link.url),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(link.label, style: theme.textTheme.titleSmall),
                          const SizedBox(height: 4),
                          Text(
                            link.url,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.open_in_new,
                      size: 18,
                      color: AppColors.muted,
                    ),
                  ],
                ),
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
