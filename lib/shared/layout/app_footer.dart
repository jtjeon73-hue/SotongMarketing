import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_info.dart';
import '../../core/constants/external_links.dart';
import '../../core/utils/mailto_helper.dart';

/// 페이지 하단 푸터. 통제센터 링크 없음.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: const BoxDecoration(color: AppColors.navy),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppInfo.serviceNameKo,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${AppInfo.brandKo} · ${AppInfo.brandEn}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final uri = MailtoHelper.build(
                    email: AppInfo.contactEmail,
                    subject: '[소통마케팅 문의]',
                  );
                  await launchUrl(uri);
                },
                child: Text(
                  AppInfo.contactEmail,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.gold,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.gold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '관련 공개 사이트',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  for (final link in ExternalLinks.all)
                    TextButton(
                      onPressed: () => launchUrl(
                        Uri.parse(link.url),
                        mode: LaunchMode.externalApplication,
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(44, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(link.label),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                '© ${DateTime.now().year} ${AppInfo.brandKo}. '
                '제작 범위와 비용은 상담 후 결정됩니다.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
