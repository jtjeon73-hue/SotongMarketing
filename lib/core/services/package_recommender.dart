import '../models/needs_selection.dart';

/// 패키지 추천 결과. 가격·견적은 포함하지 않는다.
class PackageRecommendation {
  const PackageRecommendation({
    required this.message,
    required this.suggestedPackageIds,
    required this.rationale,
  });

  /// 예: "비즈니스형 또는 프리미엄형이 적합합니다."
  final String message;

  /// 추천 등급 id (start, business, premium, custom 등)
  final List<String> suggestedPackageIds;

  final String rationale;
}

/// NeedsSelection 기반 순수 추천 로직. 견적을 확정하지 않는다.
abstract final class PackageRecommender {
  static PackageRecommendation recommend(NeedsSelection selection) {
    if (!selection.isComplete) {
      return const PackageRecommendation(
        message: '네 가지 질문에 모두 답하시면 적합한 제작 유형을 안내해 드립니다.',
        suggestedPackageIds: [],
        rationale: '선택이 아직 완료되지 않았습니다.',
      );
    }

    final score = _score(selection);
    final levelHint = selection.level;

    // 수준 직접 힌트 우선
    if (_matchesAny(levelHint, const ['간단', '간단한 소개'])) {
      return const PackageRecommendation(
        message: '현재 선택 내용으로는 스타트형이 적합합니다.',
        suggestedPackageIds: ['start'],
        rationale:
            '간단한 소개·핵심 링크 중심으로 빠르게 시작할 수 있는 범위입니다. '
            '정확한 제작 범위와 비용은 상담 후 결정됩니다.',
      );
    }

    if (_matchesAny(levelHint, const ['지속', '보완', '아직 잘 모르겠'])) {
      return const PackageRecommendation(
        message: '현재 선택 내용으로는 비즈니스형부터 상담해 보시는 것을 권합니다.',
        suggestedPackageIds: ['business', 'premium'],
        rationale:
            '목적과 콘텐츠 양이 정리되면 등급을 조정할 수 있습니다. '
            '정확한 제작 범위와 비용은 상담 후 결정됩니다.',
      );
    }

    if (score >= 8 ||
        _matchesAny(levelHint, const ['고급', '브랜드']) ||
        (_matchesAny(selection.purpose, const ['포트폴리오']) &&
            _matchesAny(selection.showcase, const ['스토리', '브랜드', '과정']))) {
      if (score >= 10 ||
          _matchesAny(selection.what, const ['기술', '앱']) &&
              _matchesAny(levelHint, const ['고급', '많은 콘텐츠'])) {
        return const PackageRecommendation(
          message: '현재 선택 내용으로는 프리미엄형 또는 맞춤 프로젝트가 적합합니다.',
          suggestedPackageIds: ['premium', 'custom'],
          rationale:
              '콘텐츠·브랜드 표현·기능 요구가 넓은 편입니다. '
              '정확한 제작 범위와 비용은 상담 후 결정됩니다.',
        );
      }
      return const PackageRecommendation(
        message: '현재 선택 내용으로는 비즈니스형 또는 프리미엄형이 적합합니다.',
        suggestedPackageIds: ['business', 'premium'],
        rationale:
            '전문적인 소개와 콘텐츠 구성이 함께 필요한 편입니다. '
            '정확한 제작 범위와 비용은 상담 후 결정됩니다.',
      );
    }

    if (score >= 5 || _matchesAny(levelHint, const ['전문', '많은 콘텐츠'])) {
      return const PackageRecommendation(
        message: '현재 선택 내용으로는 비즈니스형이 적합합니다.',
        suggestedPackageIds: ['business'],
        rationale:
            '사업·서비스 소개와 문의 유도에 맞는 중간 범위로 보입니다. '
            '정확한 제작 범위와 비용은 상담 후 결정됩니다.',
      );
    }

    return const PackageRecommendation(
      message: '현재 선택 내용으로는 스타트형 또는 비즈니스형이 적합합니다.',
      suggestedPackageIds: ['start', 'business'],
      rationale:
          '핵심 소개부터 시작해 필요한 만큼 확장하는 방식이 자연스럽습니다. '
          '정확한 제작 범위와 비용은 상담 후 결정됩니다.',
    );
  }

  static int _score(NeedsSelection s) {
    var score = 0;

    if (_matchesAny(s.what, const ['회사', '기술', '앱', '관광', '숙박'])) {
      score += 2;
    } else if (_matchesAny(s.what, const ['상품', '서비스', '매장'])) {
      score += 1;
    }

    if (_matchesAny(s.purpose, const ['구매', '문의', '포트폴리오', '검색', '여러 정보'])) {
      score += 2;
    } else if (_matchesAny(s.purpose, const ['소개', '신뢰', '공유'])) {
      score += 1;
    }

    if (_matchesAny(s.showcase, const ['기술력', '과정', '비교', '스토리', '후기'])) {
      score += 2;
    } else if (_matchesAny(s.showcase, const ['특징', '사진'])) {
      score += 1;
    }

    if (_matchesAny(s.level, const ['고급', '브랜드', '많은 콘텐츠'])) {
      score += 3;
    } else if (_matchesAny(s.level, const ['전문'])) {
      score += 2;
    } else if (_matchesAny(s.level, const ['지속', '보완'])) {
      score += 1;
    }

    return score;
  }

  static bool _matchesAny(String value, List<String> keywords) {
    final v = value.trim();
    if (v.isEmpty) return false;
    for (final k in keywords) {
      if (v.contains(k)) return true;
    }
    return false;
  }
}
