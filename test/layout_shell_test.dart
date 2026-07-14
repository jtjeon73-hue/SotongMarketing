import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sotong_marketing/app/app.dart';
import 'package:sotong_marketing/app/router.dart';
import 'package:sotong_marketing/shared/layout/app_footer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('푸터는 페이지 스크롤 흐름 안에 있고 bottomNavigationBar가 아니다', (tester) async {
    final router = createAppRouter();
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(1920, 1080)),
        child: SotongMarketingApp(router: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppFooter), findsOneWidget);

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    expect(scaffold.bottomNavigationBar, isNull);

    expect(find.textContaining('이야기로 만듭니다'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.textContaining('관련 공개 사이트'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('관련 공개 사이트'), findsOneWidget);
    expect(find.textContaining('sotongware@naver.com'), findsWidgets);
  });
}
