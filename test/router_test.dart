import 'package:flutter_test/flutter_test.dart';
import 'package:sotong_marketing/app/app.dart';
import 'package:sotong_marketing/app/router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('/packages로 이동하면 제작 등급 안내가 보인다', (tester) async {
    final router = createAppRouter();
    await tester.pumpWidget(SotongMarketingApp(router: router));
    await tester.pumpAndSettle();

    router.go('/packages');
    await tester.pumpAndSettle();

    expect(router.state.uri.path, '/packages');
    expect(find.textContaining('제작 등급'), findsWidgets);
  });

  testWidgets('알 수 없는 경로는 404 안내를 보인다', (tester) async {
    final router = createAppRouter();
    await tester.pumpWidget(SotongMarketingApp(router: router));
    await tester.pumpAndSettle();

    router.go('/unknown-xyz');
    await tester.pumpAndSettle();

    expect(find.text('페이지를 찾을 수 없습니다'), findsOneWidget);
    expect(find.text('홈으로'), findsOneWidget);
  });

  testWidgets('404에서 홈으로 돌아갈 수 있다', (tester) async {
    final router = createAppRouter();
    await tester.pumpWidget(SotongMarketingApp(router: router));
    await tester.pumpAndSettle();

    router.go('/unknown-xyz');
    await tester.pumpAndSettle();

    await tester.tap(find.text('홈으로'));
    await tester.pumpAndSettle();

    expect(router.state.uri.path, '/');
  });
}
