/// 사이드바 메뉴 그룹 (A–D).
enum NavGroupId { explore, production, result, consult }

class NavItem {
  const NavItem({
    required this.id,
    required this.label,
    required this.route,
    required this.icon,
    required this.group,
  });

  final String id;
  final String label;
  final String route;
  final String icon;
  final NavGroupId group;
}

class NavGroup {
  const NavGroup({required this.id, required this.label, required this.items});

  final NavGroupId id;
  final String label;
  final List<NavItem> items;
}

abstract final class NavItems {
  static const home = NavItem(
    id: 'home',
    label: '소통마케팅 홈',
    route: '/',
    icon: 'home',
    group: NavGroupId.explore,
  );
  static const needs = NavItem(
    id: 'needs',
    label: '어떤 홍보가 필요할까요?',
    route: '/needs',
    icon: 'search',
    group: NavGroupId.explore,
  );
  static const prepare = NavItem(
    id: 'prepare',
    label: '고객 준비자료',
    route: '/prepare',
    icon: 'folder',
    group: NavGroupId.explore,
  );

  static const services = NavItem(
    id: 'services',
    label: '홍보사이트 제작',
    route: '/services',
    icon: 'web',
    group: NavGroupId.production,
  );
  static const packages = NavItem(
    id: 'packages',
    label: '제작 등급 안내',
    route: '/packages',
    icon: 'layers',
    group: NavGroupId.production,
  );
  static const process = NavItem(
    id: 'process',
    label: '단계별 제작 과정',
    route: '/process',
    icon: 'timeline',
    group: NavGroupId.production,
  );
  static const custom = NavItem(
    id: 'custom',
    label: '맞춤형 마케팅 구성',
    route: '/custom',
    icon: 'tune',
    group: NavGroupId.production,
  );
  static const industries = NavItem(
    id: 'industries',
    label: '업종별 제작 방향',
    route: '/industries',
    icon: 'business',
    group: NavGroupId.production,
  );

  static const examples = NavItem(
    id: 'examples',
    label: '사이트 구성 예시',
    route: '/examples',
    icon: 'dashboard',
    group: NavGroupId.result,
  );
  static const utilization = NavItem(
    id: 'utilization',
    label: '홍보 활용 방법',
    route: '/utilization',
    icon: 'share',
    group: NavGroupId.result,
  );
  static const maintenance = NavItem(
    id: 'maintenance',
    label: '제작 후 관리·보완',
    route: '/maintenance',
    icon: 'build',
    group: NavGroupId.result,
  );
  static const faq = NavItem(
    id: 'faq',
    label: '자주 묻는 질문',
    route: '/faq',
    icon: 'help',
    group: NavGroupId.result,
  );

  static const consultation = NavItem(
    id: 'consultation',
    label: '상담 준비하기',
    route: '/consultation',
    icon: 'edit',
    group: NavGroupId.consult,
  );
  static const requestProcess = NavItem(
    id: 'request-process',
    label: '제작 의뢰 절차',
    route: '/request-process',
    icon: 'assignment',
    group: NavGroupId.consult,
  );
  static const about = NavItem(
    id: 'about',
    label: '소통웨어 소개',
    route: '/about',
    icon: 'info',
    group: NavGroupId.consult,
  );
  static const contact = NavItem(
    id: 'contact',
    label: '문의하기',
    route: '/contact',
    icon: 'mail',
    group: NavGroupId.consult,
  );

  static const List<NavItem> all = [
    home,
    needs,
    prepare,
    services,
    packages,
    process,
    custom,
    industries,
    examples,
    utilization,
    maintenance,
    faq,
    consultation,
    requestProcess,
    about,
    contact,
  ];

  static const List<NavGroup> groups = [
    NavGroup(
      id: NavGroupId.explore,
      label: 'A. 시작하기',
      items: [home, needs, prepare],
    ),
    NavGroup(
      id: NavGroupId.production,
      label: 'B. 제작 서비스',
      items: [services, packages, process, custom, industries],
    ),
    NavGroup(
      id: NavGroupId.result,
      label: 'C. 결과와 활용',
      items: [examples, utilization, maintenance, faq],
    ),
    NavGroup(
      id: NavGroupId.consult,
      label: 'D. 상담',
      items: [consultation, requestProcess, about, contact],
    ),
  ];

  static NavItem? byRoute(String location) {
    final path = Uri.parse(location).path;
    for (final item in all) {
      if (item.route == path) return item;
    }
    return null;
  }

  static String titleFor(String location) {
    return byRoute(location)?.label ?? '페이지를 찾을 수 없습니다';
  }
}
