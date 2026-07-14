import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_info.dart';
import '../../core/constants/nav_items.dart';

/// 접이식 사이드바 (펼침 280 / 접힘 76). 그룹 메뉴·독립 스크롤.
class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.collapsed,
    required this.onToggleCollapse,
    required this.currentLocation,
    this.onNavigate,
  });

  final bool collapsed;
  final VoidCallback onToggleCollapse;
  final String currentLocation;
  final ValueChanged<String>? onNavigate;

  static const double expandedWidth = 280;
  static const double collapsedWidth = 76;

  @override
  Widget build(BuildContext context) {
    final width = collapsed ? collapsedWidth : expandedWidth;
    final currentPath = Uri.parse(currentLocation).path;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      width: width,
      color: AppColors.sidebarBg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BrandHeader(collapsed: collapsed, onToggle: onToggleCollapse),
            const Divider(color: Color(0x33FFFFFF), height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                children: [
                  for (final group in NavItems.groups) ...[
                    if (!collapsed)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                        child: Text(
                          group.label,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.white54,
                                letterSpacing: 0.4,
                              ),
                        ),
                      ),
                    for (final item in group.items)
                      _NavTile(
                        item: item,
                        collapsed: collapsed,
                        selected: item.route == currentPath,
                        onTap: () {
                          if (onNavigate != null) {
                            onNavigate!(item.route);
                          } else {
                            context.go(item.route);
                          }
                        },
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.collapsed, required this.onToggle});

  final bool collapsed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(collapsed ? 8 : 16, 16, 8, 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.blue, AppColors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Text(
              'S',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
          if (!collapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppInfo.serviceNameKo,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    AppInfo.brandKo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
          Tooltip(
            message: collapsed ? '메뉴 펼치기' : '메뉴 접기',
            child: IconButton(
              onPressed: onToggle,
              icon: Icon(
                collapsed ? Icons.chevron_right : Icons.chevron_left,
                color: Colors.white70,
              ),
              iconSize: 22,
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.collapsed,
    required this.selected,
    required this.onTap,
  });

  final NavItem item;
  final bool collapsed;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = _iconFor(item.icon);
    final bg = selected ? AppColors.sidebarActive : Colors.transparent;

    final tile = Material(
      color: bg,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        hoverColor: AppColors.sidebarHover,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: collapsed ? 0 : 12,
            vertical: 10,
          ),
          child: collapsed
              ? Center(child: Icon(icon, color: Colors.white, size: 22))
              : Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );

    if (!collapsed) {
      return Padding(padding: const EdgeInsets.only(bottom: 4), child: tile);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Tooltip(message: item.label, child: tile),
    );
  }

  static IconData _iconFor(String key) {
    return switch (key) {
      'home' => Icons.home_outlined,
      'search' => Icons.search,
      'folder' => Icons.folder_outlined,
      'web' => Icons.language,
      'layers' => Icons.layers_outlined,
      'timeline' => Icons.timeline,
      'tune' => Icons.tune,
      'business' => Icons.business_outlined,
      'dashboard' => Icons.dashboard_outlined,
      'share' => Icons.share_outlined,
      'build' => Icons.build_outlined,
      'help' => Icons.help_outline,
      'edit' => Icons.edit_note_outlined,
      'assignment' => Icons.assignment_outlined,
      'info' => Icons.info_outline,
      'mail' => Icons.mail_outline,
      _ => Icons.circle_outlined,
    };
  }
}
