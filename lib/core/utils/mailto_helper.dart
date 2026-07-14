/// mailto URI 생성 및 길이 제한 대응.
abstract final class MailtoHelper {
  /// 일반적인 mailto 안전 길이 (브라우저·OS별 편차 고려).
  static const int defaultMaxUriLength = 1800;

  static Uri build({
    required String email,
    String? subject,
    String? body,
    int maxUriLength = defaultMaxUriLength,
  }) {
    final query = <String, String>{};
    if (subject != null && subject.trim().isNotEmpty) {
      query['subject'] = subject.trim();
    }
    if (body != null && body.trim().isNotEmpty) {
      query['body'] = body.trim();
    }

    var uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: query.isEmpty ? null : query,
    );

    if (uri.toString().length <= maxUriLength) {
      return uri;
    }

    // 본문을 줄여가며 맞춤
    if (query.containsKey('body')) {
      var truncated = query['body']!;
      const footer =
          '\n\n(본문이 길어 일부가 생략되었습니다. '
          '화면에서 「내용 복사」 후 붙여 넣어 주세요.)';

      while (truncated.length > 80) {
        truncated = truncated.substring(0, truncated.length ~/ 2).trimRight();
        final candidateBody = '$truncated…$footer';
        final candidate = Uri(
          scheme: 'mailto',
          path: email,
          queryParameters: {
            if (query['subject'] != null) 'subject': query['subject']!,
            'body': candidateBody,
          },
        );
        if (candidate.toString().length <= maxUriLength) {
          return candidate;
        }
      }

      // 본문 없이 제목만
      uri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: query['subject'] != null
            ? {'subject': query['subject']!}
            : null,
      );
    }

    return uri;
  }

  /// URI 문자열이 한도를 넘으면 true.
  static bool exceedsLimit(Uri uri, {int maxUriLength = defaultMaxUriLength}) {
    return uri.toString().length > maxUriLength;
  }
}
