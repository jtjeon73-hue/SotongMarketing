import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_info.dart';
import '../../core/constants/external_links.dart';
import '../../core/utils/mailto_helper.dart';
import 'content_container.dart';

/// 페이지 콘텐츠 흐름의 마지막에 표시되는 푸터.
/// Stack/bottomNavigationBar/화면 높이 고정을 사용하지 않는다.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  Future<void> _openMail() async {
    final uri = MailtoHelper.build(
      email: AppInfo.contactEmail,
      subject: '[소통마케팅 문의]',
    );
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: AppColors.navy,
      child: ContentContainer(
        padding: null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 720;
              final brand = _BrandBlock(theme: theme);
              final contact = _ContactBlock(theme: theme, onMail: _openMail);
              final links = _LinksBlock(theme: theme);
              final copy = Text(
                '© ${DateTime.now().year} ${AppInfo.brandEn}. '
                '제작 범위와 비용은 상담 후 결정됩니다.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              );

              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    brand,
                    const SizedBox(height: 24),
                    contact,
                    const SizedBox(height: 24),
                    links,
                    const SizedBox(height: 28),
                    copy,
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: brand),
                      const SizedBox(width: 32),
                      Expanded(flex: 2, child: contact),
                      const SizedBox(width: 32),
                      Expanded(flex: 3, child: links),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Divider(color: Color(0x33FFFFFF), height: 1),
                  const SizedBox(height: 20),
                  copy,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BrandBlock extends StatelessWidget {
  const _BrandBlock({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppInfo.serviceNameKo,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${AppInfo.brandKo} · ${AppInfo.brandEn}',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 10),
        Text(
          '맞춤형 홍보·마케팅 사이트 제작',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white54,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _ContactBlock extends StatelessWidget {
  const _ContactBlock({required this.theme, required this.onMail});

  final ThemeData theme;
  final VoidCallback onMail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '문의',
          style: theme.textTheme.labelMedium?.copyWith(color: Colors.white60),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onMail,
          child: Text(
            AppInfo.contactEmail,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.gold,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.gold,
            ),
          ),
        ),
      ],
    );
  }
}

class _LinksBlock extends StatelessWidget {
  const _LinksBlock({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '관련 공개 사이트',
          style: theme.textTheme.labelMedium?.copyWith(color: Colors.white60),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final link in ExternalLinks.all)
              TextButton(
                onPressed: () => launchUrl(
                  Uri.parse(link.url),
                  mode: LaunchMode.externalApplication,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  minimumSize: const Size(44, 36),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(link.label),
              ),
          ],
        ),
      ],
    );
  }
}
