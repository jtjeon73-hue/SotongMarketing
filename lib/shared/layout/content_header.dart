import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/nav_items.dart';
import 'content_container.dart';

/// 현재 메뉴 제목. [ContentContainer]로 본문과 좌측 기준선을 맞춘다.
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

    return Material(
      color: AppColors.card,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: ContentContainer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (groupLabel != null)
                      Text(
                        groupLabel,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.muted,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
