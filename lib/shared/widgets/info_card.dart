import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// 흰 배경 카드. [accent]가 있으면 왼쪽 포인트 바.
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.child,
    this.title,
    this.accent,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
  });

  final Widget child;
  final String? title;
  final Color? accent;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title!, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
        ],
        child,
      ],
    );

    final card = Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (accent != null) Container(width: 4, color: accent),
            Expanded(
              child: Padding(padding: padding, child: content),
            ),
          ],
        ),
      ),
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: card,
      ),
    );
  }
}
