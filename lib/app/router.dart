import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../features/about/about_page.dart';
import '../features/consultation/consultation_page.dart';
import '../features/contact/contact_page.dart';
import '../features/customer_preparation/customer_preparation_page.dart';
import '../features/custom_marketing/custom_marketing_page.dart';
import '../features/examples/examples_page.dart';
import '../features/faq/faq_page.dart';
import '../features/home/home_page.dart';
import '../features/industries/industries_page.dart';
import '../features/maintenance/maintenance_page.dart';
import '../features/needs/needs_page.dart';
import '../features/packages/packages_page.dart';
import '../features/process/process_page.dart';
import '../features/request_process/request_process_page.dart';
import '../features/services/services_page.dart';
import '../features/utilization/utilization_page.dart';
import '../shared/widgets/cta_button.dart';
import '../shared/widgets/page_scaffold_body.dart';
import 'app_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/needs',
            name: 'needs',
            builder: (context, state) => const NeedsPage(),
          ),
          GoRoute(
            path: '/prepare',
            name: 'prepare',
            builder: (context, state) => const CustomerPreparationPage(),
          ),
          GoRoute(
            path: '/services',
            name: 'services',
            builder: (context, state) => const ServicesPage(),
          ),
          GoRoute(
            path: '/packages',
            name: 'packages',
            builder: (context, state) => const PackagesPage(),
          ),
          GoRoute(
            path: '/process',
            name: 'process',
            builder: (context, state) => const ProcessPage(),
          ),
          GoRoute(
            path: '/custom',
            name: 'custom',
            builder: (context, state) => const CustomMarketingPage(),
          ),
          GoRoute(
            path: '/industries',
            name: 'industries',
            builder: (context, state) => const IndustriesPage(),
          ),
          GoRoute(
            path: '/examples',
            name: 'examples',
            builder: (context, state) => const ExamplesPage(),
          ),
          GoRoute(
            path: '/utilization',
            name: 'utilization',
            builder: (context, state) => const UtilizationPage(),
          ),
          GoRoute(
            path: '/maintenance',
            name: 'maintenance',
            builder: (context, state) => const MaintenancePage(),
          ),
          GoRoute(
            path: '/faq',
            name: 'faq',
            builder: (context, state) => const FaqPage(),
          ),
          GoRoute(
            path: '/consultation',
            name: 'consultation',
            builder: (context, state) => const ConsultationPage(),
          ),
          GoRoute(
            path: '/request-process',
            name: 'request-process',
            builder: (context, state) => const RequestProcessPage(),
          ),
          GoRoute(
            path: '/about',
            name: 'about',
            builder: (context, state) => const AboutPage(),
          ),
          GoRoute(
            path: '/contact',
            name: 'contact',
            builder: (context, state) => const ContactPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const _NotFoundPage(),
  );
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: PageScaffoldBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '페이지를 찾을 수 없습니다',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              '요청하신 주소를 확인하거나 홈으로 돌아가 주세요.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 24),
            CtaButton(label: '홈으로', onPressed: () => context.go('/')),
          ],
        ),
      ),
    );
  }
}
