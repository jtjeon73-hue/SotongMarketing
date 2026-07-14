import 'package:flutter_test/flutter_test.dart';
import 'package:sotong_marketing/app/app.dart';
import 'package:sotong_marketing/core/constants/app_info.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('앱이 홈 화면을 렌더링한다', (tester) async {
    await tester.pumpWidget(SotongMarketingApp());
    await tester.pumpAndSettle();

    expect(find.textContaining(AppInfo.serviceNameKo), findsWidgets);
  });
}
