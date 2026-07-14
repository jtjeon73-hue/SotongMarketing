import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_info.dart';
import '../../core/utils/mailto_helper.dart';
import '../../shared/widgets/cta_button.dart';
import '../../shared/widgets/info_card.dart';
import '../../shared/widgets/page_scaffold_body.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/tag_chip.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _topics = <_TopicCard>[
    _TopicCard('회사·사업체', Icons.apartment_outlined, '/needs'),
    _TopicCard('제품·상품', Icons.inventory_2_outlined, '/needs'),
    _TopicCard('서비스', Icons.handshake_outlined, '/needs'),
    _TopicCard('음식점·카페', Icons.restaurant_outlined, '/industries'),
    _TopicCard('농산물·농장', Icons.eco_outlined, '/industries'),
    _TopicCard('숙박·관광', Icons.travel_explore_outlined, '/industries'),
    _TopicCard('전문가·개인 브랜드', Icons.person_outline, '/needs'),
    _TopicCard('지역·단체', Icons.location_city_outlined, '/industries'),
    _TopicCard('앱·소프트웨어', Icons.devices_outlined, '/needs'),
    _TopicCard('새로운 아이디어', Icons.lightbulb_outline, '/needs'),
  ];

  static const _flowSteps = <String>[
    '고객의 이야기',
    '목적 정리',
    '콘텐츠 기획',
    '디자인',
    '제작',
    '확인',
    '보완',
    '배포',
    '공유·활용',
  ];

  static const _packages = <_PackagePreview>[
    _PackagePreview('스타트', '빠르게 온라인 소개 링크가 필요할 때', AppColors.teal),
    _PackagePreview('비즈니스', '사업·서비스를 전문적으로 소개할 때', AppColors.blue),
    _PackagePreview('프리미엄', '브랜드 이미지와 전문성을 강조할 때', AppColors.purple),
    _PackagePreview('맞춤 프로젝트', '복잡한 요구와 장기 운영이 필요할 때', AppColors.gold),
  ];

  static const _prepareItems = <String>[
    '기본 정보',
    '사진',
    '홍보 목적',
    '주요 고객',
    '연락 방법',
    '특별히 강조할 내용',
  ];

  static const _sotongwareDoes = <String>[
    '내용 정리',
    '구조 기획',
    '디자인',
    '모바일 대응',
    '웹 제작',
    'Firebase Hosting 등 웹 배포',
    '공유 가능한 링크',
    '보완 수정',
    '필요 시 확장 상담',
  ];

  Future<void> _openEmail() async {
    final uri = MailtoHelper.build(
      email: AppInfo.contactEmail,
      subject: '[소통마케팅 문의]',
    );
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PageScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroSection(onEmail: _openEmail),
          const SizedBox(height: 48),
          const SectionHeader(
            title: '무엇을 홍보하고 싶으신가요?',
            subtitle: '관심 있는 유형을 고르면 맞는 안내 페이지로 이동합니다.',
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width >= 900
                  ? 5
                  : width >= 560
                  ? 3
                  : 2;
              final gap = 12.0;
              final cardWidth =
                  (width - gap * (crossAxisCount - 1)) / crossAxisCount;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final topic in _topics)
                    SizedBox(
                      width: cardWidth,
                      child: InfoCard(
                        accent: AppColors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 16,
                        ),
                        onTap: () => context.go(topic.route),
                        child: Row(
                          children: [
                            Icon(topic.icon, size: 22, color: AppColors.blue),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                topic.label,
                                style: theme.textTheme.titleSmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 48),
          const SectionHeader(
            title: '소통웨어 제작 방식',
            subtitle: '이야기부터 공유까지, 한 흐름으로 정리합니다.',
          ),
          InfoCard(
            child: Wrap(
              spacing: 8,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (var i = 0; i < _flowSteps.length; i++) ...[
                  if (i > 0)
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppColors.muted.withValues(alpha: 0.7),
                    ),
                  TagChip(label: _flowSteps[i]),
                ],
              ],
            ),
          ),
          const SizedBox(height: 48),
          SectionHeader(
            title: '제작 등급 미리보기',
            subtitle: '목적에 맞는 범위가 다릅니다. 자세한 안내는 등급 페이지에서 확인하세요.',
            padding: const EdgeInsets.only(bottom: 12),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => context.go('/packages'),
              child: const Text('전체 등급 안내 보기 →'),
            ),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width >= 800
                  ? 4
                  : width >= 520
                  ? 2
                  : 1;
              final gap = 12.0;
              final cardWidth =
                  (width - gap * (crossAxisCount - 1)) / crossAxisCount;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final pkg in _packages)
                    SizedBox(
                      width: cardWidth,
                      child: InfoCard(
                        title: pkg.name,
                        accent: pkg.accent,
                        onTap: () => context.go('/packages'),
                        child: Text(
                          pkg.subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.muted,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 48),
          const SectionHeader(
            title: '고객이 준비할 것',
            subtitle: '완벽한 자료가 없어도 괜찮습니다. 핵심만 준비되면 시작할 수 있습니다.',
          ),
          InfoCard(
            onTap: () => context.go('/prepare'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final item in _prepareItems) TagChip(label: item),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '준비자료 자세히 보기 →',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.blue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          const SectionHeader(
            title: '소통웨어가 하는 일',
            subtitle: '고객의 이야기를 정리하고, 사이트로 만들어 공유할 수 있게 돕습니다.',
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width >= 800
                  ? 3
                  : width >= 500
                  ? 2
                  : 1;
              final gap = 12.0;
              final cardWidth =
                  (width - gap * (crossAxisCount - 1)) / crossAxisCount;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (var i = 0; i < _sotongwareDoes.length; i++)
                    SizedBox(
                      width: cardWidth,
                      child: InfoCard(
                        accent: i.isEven ? AppColors.teal : AppColors.purple,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              '${i + 1}'.padLeft(2, '0'),
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: AppColors.muted,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _sotongwareDoes[i],
                                style: theme.textTheme.titleSmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 56),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.blue.withValues(alpha: 0.08),
                  AppColors.teal.withValues(alpha: 0.06),
                  AppColors.card,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '무엇을 어떻게 준비해야 할지 몰라도 괜찮습니다.\n'
                  '현재 가지고 있는 자료부터 함께 정리할 수 있습니다.',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.navy,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 20),
                CtaButton(
                  label: '상담 준비 시작하기',
                  icon: Icons.edit_note_outlined,
                  onPressed: () => context.go('/consultation'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.onEmail});

  final VoidCallback onEmail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 36, 28, 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF0F5FF), Color(0xFFE8F7F5)],
        ),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppInfo.serviceNameKo,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.blue,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '당신의 사업과 가치를\n고객이 이해할 수 있는 이야기로 만듭니다',
            style: theme.textTheme.headlineMedium?.copyWith(
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              '제품, 서비스, 가게, 회사, 농산물, 지역, 관광, '
              '전문기술과 새로운 아이디어까지.\n\n'
              '고객이 알기 쉽고, 공유하기 쉽고, 상담으로 이어질 수 있는 '
              '맞춤형 홍보·마케팅 사이트를 제작합니다.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.muted,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              CtaButton(
                label: '내게 맞는 홍보 찾기',
                onPressed: () => context.go('/needs'),
              ),
              CtaButton(
                label: '제작 등급 살펴보기',
                variant: CtaVariant.secondary,
                onPressed: () => context.go('/packages'),
              ),
              CtaButton(
                label: '상담 준비하기',
                variant: CtaVariant.secondary,
                onPressed: () => context.go('/consultation'),
              ),
              CtaButton(
                label: '이메일 문의',
                variant: CtaVariant.secondary,
                icon: Icons.mail_outline,
                onPressed: onEmail,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopicCard {
  const _TopicCard(this.label, this.icon, this.route);

  final String label;
  final IconData icon;
  final String route;
}

class _PackagePreview {
  const _PackagePreview(this.name, this.subtitle, this.accent);

  final String name;
  final String subtitle;
  final Color accent;
}
