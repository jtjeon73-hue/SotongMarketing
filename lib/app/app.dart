import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_info.dart';
import '../shared/theme/app_theme.dart';
import 'router.dart';

class SotongMarketingApp extends StatelessWidget {
  SotongMarketingApp({super.key, GoRouter? router})
    : _router = router ?? createAppRouter();

  final GoRouter _router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppInfo.seoTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
