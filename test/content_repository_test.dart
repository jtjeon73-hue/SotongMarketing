import 'package:flutter_test/flutter_test.dart';
import 'package:sotong_marketing/core/services/content_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ContentRepository', () {
    late ContentRepository repo;

    setUp(() {
      repo = ContentRepository();
    });

    test('service_packages.json을 로드하고 id/name을 파싱한다', () async {
      final packages = await repo.loadPackages();

      expect(packages, isNotEmpty);
      expect(packages.map((p) => p.id), containsAll(['start', 'business']));
      expect(packages.first.name, isNotEmpty);
      expect(packages.first.features, isNotEmpty);
    });

    test('동일 데이터는 캐시되어 같은 인스턴스를 반환한다', () async {
      final first = await repo.loadPackages();
      final second = await repo.loadPackages();
      expect(identical(first, second), isTrue);
    });

    test('clearCache 후 다시 로드할 수 있다', () async {
      await repo.loadPackages();
      repo.clearCache();
      final again = await repo.loadPackages();
      expect(again, isNotEmpty);
    });
  });
}
