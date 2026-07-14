import 'package:flutter_test/flutter_test.dart';
import 'package:sotong_marketing/core/models/needs_selection.dart';
import 'package:sotong_marketing/core/services/package_recommender.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PackageRecommender', () {
    test('선택이 미완료면 빈 추천과 안내 메시지를 반환한다', () {
      const selection = NeedsSelection(what: '상품');
      final result = PackageRecommender.recommend(selection);

      expect(result.suggestedPackageIds, isEmpty);
      expect(result.message, contains('네 가지'));
      expect(result.rationale, contains('완료되지'));
    });

    test('간단 소개 수준이면 스타트형을 추천한다', () {
      const selection = NeedsSelection(
        what: '상품',
        purpose: '소개',
        showcase: '사진',
        level: '간단한 소개',
      );
      final result = PackageRecommender.recommend(selection);

      expect(result.suggestedPackageIds, ['start']);
      expect(result.message, contains('스타트'));
    });

    test('전문·많은 콘텐츠면 비즈니스형을 추천한다', () {
      const selection = NeedsSelection(
        what: '서비스',
        purpose: '문의',
        showcase: '특징',
        level: '전문적인 소개',
      );
      final result = PackageRecommender.recommend(selection);

      expect(result.suggestedPackageIds, contains('business'));
      expect(result.message, contains('비즈니스'));
    });

    test('고급·브랜드면 프리미엄/비즈니스 계열을 추천한다', () {
      const selection = NeedsSelection(
        what: '회사',
        purpose: '포트폴리오',
        showcase: '브랜드 스토리',
        level: '고급·브랜드',
      );
      final result = PackageRecommender.recommend(selection);

      expect(
        result.suggestedPackageIds,
        anyOf(equals(['premium', 'custom']), equals(['business', 'premium'])),
      );
    });

    test('잘 모르겠음 수준이면 비즈니스·프리미엄 상담을 권한다', () {
      const selection = NeedsSelection(
        what: '관광',
        purpose: '공유',
        showcase: '사진',
        level: '아직 잘 모르겠음',
      );
      final result = PackageRecommender.recommend(selection);

      expect(result.suggestedPackageIds, ['business', 'premium']);
    });
  });
}
