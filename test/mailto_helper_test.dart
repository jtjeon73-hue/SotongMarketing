import 'package:flutter_test/flutter_test.dart';
import 'package:sotong_marketing/core/utils/mailto_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MailtoHelper', () {
    test('기본 mailto URI를 생성한다', () {
      final uri = MailtoHelper.build(
        email: 'sotongware@naver.com',
        subject: '상담 문의',
        body: '본문입니다',
      );

      expect(uri.scheme, 'mailto');
      expect(uri.path, 'sotongware@naver.com');
      expect(uri.queryParameters['subject'], '상담 문의');
      expect(uri.queryParameters['body'], '본문입니다');
      expect(MailtoHelper.exceedsLimit(uri), isFalse);
    });

    test('본문이 길면 잘라서 한도 이하로 맞춘다', () {
      final longBody = List.generate(500, (i) => '긴본문$i ').join();
      final uri = MailtoHelper.build(
        email: 'sotongware@naver.com',
        subject: '제목',
        body: longBody,
        maxUriLength: 400,
      );

      expect(uri.toString().length, lessThanOrEqualTo(400));
      expect(uri.queryParameters['subject'], '제목');
      final body = uri.queryParameters['body'];
      expect(
        body == null || body.contains('생략') || body.length < longBody.length,
        isTrue,
      );
    });

    test('제목만 있어도 URI를 만든다', () {
      final uri = MailtoHelper.build(email: 'a@b.c', subject: '제목만');
      expect(uri.queryParameters['subject'], '제목만');
      expect(uri.queryParameters.containsKey('body'), isFalse);
    });

    test('exceedsLimit은 문자열 길이를 검사한다', () {
      final short = Uri.parse('mailto:a@b.c?subject=hi');
      expect(MailtoHelper.exceedsLimit(short, maxUriLength: 10), isTrue);
      expect(MailtoHelper.exceedsLimit(short, maxUriLength: 500), isFalse);
    });
  });
}
