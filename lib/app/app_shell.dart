import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_info.dart';
import '../shared/layout/app_sidebar.dart';
import '../shared/layout/content_header.dart';

/// 데스크톱: 사이드바 + 우측(헤더 고정 / 라우트 본문)
/// 모바일(<900): AppBar + Drawer + 본문
///
/// Footer는 [PageScaffoldBody] 스크롤 흐름 안에서 페이지 콘텐츠 다음에 둔다.
/// go_router ShellRoute의 Navigator child는 유한 높이가 필요하므로
/// 셸에서 child를 다시 스크롤로 감싸지 않는다.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const double desktopBreakpoint = 900;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _sidebarCollapsed = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppShell.desktopBreakpoint;

    if (isDesktop) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSidebar(
              collapsed: _sidebarCollapsed,
              onToggleCollapse: () {
                setState(() => _sidebarCollapsed = !_sidebarCollapsed);
              },
              currentLocation: location,
            ),
            Expanded(
              child: _ContentColumn(location: location, child: widget.child),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(AppInfo.serviceNameKo),
        leading: IconButton(
          tooltip: '메뉴 열기',
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: Drawer(
        width: AppSidebar.expandedWidth,
        child: AppSidebar(
          collapsed: false,
          onToggleCollapse: () => Navigator.of(context).maybePop(),
          currentLocation: location,
          onNavigate: (route) {
            Navigator.of(context).maybePop();
            context.go(route);
          },
        ),
      ),
      body: _ContentColumn(location: location, child: widget.child),
    );
  }
}

class _ContentColumn extends StatelessWidget {
  const _ContentColumn({required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ContentHeader(location: location),
        Expanded(
          child: ColoredBox(color: AppColors.bg, child: child),
        ),
      ],
    );
  }
}
