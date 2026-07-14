/// 공개 프로모 사이트 링크 (통제센터 제외).
class ExternalLink {
  const ExternalLink({
    required this.id,
    required this.label,
    required this.url,
  });

  final String id;
  final String label;
  final String url;
}

abstract final class ExternalLinks {
  static const automation = ExternalLink(
    id: 'automation',
    label: '산업자동화',
    url: 'https://sotong-automation-promo.web.app',
  );

  static const apps = ExternalLink(
    id: 'apps',
    label: '앱·소프트웨어',
    url: 'https://sotongware-apps-promo.web.app',
  );

  static const ebook = ExternalLink(
    id: 'ebook',
    label: '전자책',
    url: 'https://sotongware-ebook-promo.web.app',
  );

  static const contents = ExternalLink(
    id: 'contents',
    label: '콘텐츠',
    url: 'https://sotongware-contents-promo.web.app',
  );

  static const aiStory = ExternalLink(
    id: 'aiStory',
    label: 'AI 스토리',
    url: 'https://sotongware-ai-story.web.app',
  );

  static const List<ExternalLink> all = [
    automation,
    apps,
    ebook,
    contents,
    aiStory,
  ];
}
