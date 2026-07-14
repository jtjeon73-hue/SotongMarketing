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

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _openMailto() async {
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
          const SectionHeader(
            title: '문의하기',
            subtitle: '부담 없이 현재 상황을 편하게 알려 주세요. 제작을 바로 결정하지 않아도 됩니다.',
          ),
          InfoCard(
            accent: AppColors.blue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '이메일',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  AppInfo.contactEmail,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '무엇을 홍보하고 싶은지, 지금 가지고 있는 자료, 궁금한 점을 함께 적어 주시면 '
                  '상담을 이어가기 좋습니다. 자료가 완벽하지 않아도 괜찮습니다.',
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('이렇게 시작해 보세요', style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                Text(
                  '1. 상담 준비 도우미에서 내용을 정리하거나\n'
                  '2. 이메일로 현재 상황을 간단히 보내 주세요.',
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              CtaButton(
                label: '이메일 문의하기',
                icon: Icons.mail_outline,
                onPressed: _openMailto,
              ),
              CtaButton(
                label: '상담 준비하기',
                variant: CtaVariant.secondary,
                icon: Icons.chat_bubble_outline,
                onPressed: () => context.go('/consultation'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '급한 압박이나 보장성 약속 없이, 목적과 범위부터 차분히 확인합니다.',
            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
