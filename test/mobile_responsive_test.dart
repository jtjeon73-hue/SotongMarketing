import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sotong_marketing/app/app.dart';
import 'package:sotong_marketing/app/router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    int maxPumps = 50,
  }) async {
    for (var i = 0; i < maxPumps; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (finder.evaluate().isNotEmpty) return;
    }
  }

  const processTitles = <String>[
    '상담',
    '자료 확인',
    '목적 정리',
    '사이트 구성 기획',
    '1차 제작',
    '고객 확인',
    '보완 수정',
    '최종 검수',
    '웹 배포',
    '공유·활용',
    '추가 보완',
  ];

  testWidgets('단계별 제작 과정은 모든 기준 폭에서 overflow가 없다', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = createAppRouter();
    addTearDown(router.dispose);
    router.go('/process');
    await tester.pumpWidget(SotongMarketingApp(router: router));
    await pumpUntilFound(tester, find.text('상담'));

    for (final width in <double>[360, 390, 430, 768, 1440]) {
      tester.view.physicalSize = Size(width, width < 600 ? 800 : 900);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
      expect(find.text('단계별 제작 과정'), findsWidgets);
      for (final title in processTitles) {
        expect(find.text(title), findsWidgets);
      }

      expect(find.text('고객이 하는 일'), findsNWidgets(processTitles.length));
      expect(find.text('소통웨어가 하는 일'), findsNWidgets(processTitles.length));
    }
  });

  testWidgets('360px 주요 페이지에서 RenderFlex overflow가 없다', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = createAppRouter();
    addTearDown(router.dispose);
    await tester.pumpWidget(SotongMarketingApp(router: router));
    await tester.pump();

    for (final route in <String>[
      '/',
      '/services',
      '/packages',
      '/process',
      '/consultation',
      '/contact',
    ]) {
      router.go(route);
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull, reason: '$route 모바일 레이아웃 오류');
    }
  });
}
