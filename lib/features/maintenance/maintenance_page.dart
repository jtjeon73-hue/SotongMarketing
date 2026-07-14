import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../shared/widgets/cta_button.dart';
import '../../shared/widgets/info_card.dart';
import '../../shared/widgets/notice_banner.dart';
import '../../shared/widgets/page_scaffold_body.dart';
import '../../shared/widgets/section_header.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  static const _changes = <({String title, String detail})>[
    (title: '전화번호 변경', detail: '연락처·영업시간·문의 경로가 바뀌었을 때'),
    (title: '가격 변경', detail: '메뉴·요금·패키지 안내를 최신으로 맞출 때'),
    (title: '메뉴 변경', detail: '음식점·카페·서비스 메뉴 구성을 바꿀 때'),
    (title: '제품 추가', detail: '새 상품·라인업·옵션을 소개할 때'),
    (title: '사진 교체', detail: '매장·제품·현장 이미지를 새로 올릴 때'),
    (title: '새로운 사업 추가', detail: '사업 영역·브랜드가 늘어났을 때'),
    (title: '이벤트', detail: '할인·행사·프로모션 안내가 필요할 때'),
    (title: '계절 콘텐츠', detail: '시즌·수확기·관광 성수기에 맞춰 문구를 바꿀 때'),
    (title: '링크 변경', detail: '쇼핑몰·예약·SNS·지도 연결을 갱신할 때'),
  ];

  static const _scopeNote =
      '관리·보완 방식은 계약이나 제작 범위에 따라 다를 수 있습니다. 정확한 유지관리 범위는 상담 후 결정합니다.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PageScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: '제작 후 관리·보완',
            subtitle: '사이트는 만들어 놓고 끝나는 것이 아니라, 사업 변화에 따라 내용 수정이 필요할 수 있습니다.',
          ),
          InfoCard(
            accent: AppColors.blue,
            child: Text(
              '영업 정보가 바뀌면 소개 사이트도 함께 맞춰 두는 것이 좋습니다. 아래에서 자주 생기는 변경 유형을 확인해 보세요.',
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
            ),
          ),
          const SizedBox(height: 20),
          for (final item in _changes)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InfoCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: AppColors.blue,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: theme.textTheme.titleSmall),
                          const SizedBox(height: 4),
                          Text(
                            item.detail,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.muted,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          const NoticeBanner(message: _scopeNote),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              CtaButton(
                label: '상담으로 범위 확인하기',
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
