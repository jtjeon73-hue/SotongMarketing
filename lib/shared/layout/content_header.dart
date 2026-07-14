import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/nav_items.dart';

/// 현재 메뉴 제목을 보여주는 콘텐츠 헤더.
class ContentHeader extends StatelessWidget {
  const ContentHeader({super.key, required this.location, this.trailing});

  final String location;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final item = NavItems.byRoute(location);
    final title = item?.label ?? NavItems.titleFor(location);
    final groupLabel = item == null
        ? null
        : NavItems.groups
              .where((g) => g.id == item.group)
              .map((g) => g.label)
              .firstOrNull;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (groupLabel != null)
                  Text(
                    groupLabel,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: AppColors.muted),
                  ),
                const SizedBox(height: 4),
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
