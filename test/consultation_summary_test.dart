import 'package:flutter_test/flutter_test.dart';
import 'package:sotong_marketing/core/constants/app_info.dart';
import 'package:sotong_marketing/core/models/consultation_draft.dart';
import 'package:sotong_marketing/core/services/consultation_summary.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ConsultationSummary', () {
    test('displayName은 프로젝트명을 우선한다', () {
      const draft = ConsultationDraft(projectName: '햇살농장', contactName: '김상담');
      expect(ConsultationSummary.displayName(draft), '햇살농장');
    });

    test('프로젝트명이 없으면 연락처 이름, 둘 다 없으면 기본값', () {
      expect(
        ConsultationSummary.displayName(
          const ConsultationDraft(contactName: '이문의'),
        ),
        '이문의',
      );
      expect(
        ConsultationSummary.displayName(const ConsultationDraft()),
        '프로젝트',
      );
    });

    test('emailSubject에 서비스명과 표시명을 포함한다', () {
      const draft = ConsultationDraft(projectName: '테스트몰');
      expect(ConsultationSummary.emailSubject(draft), '[소통마케팅 제작 상담] 테스트몰');
    });

    test('buildSummaryText에 입력값과 서버미저장 안내가 들어간다', () {
      const draft = ConsultationDraft(
        whatToPromote: '농산물',
        projectName: '햇살농장',
        mainCustomers: ['지역 고객', '단체'],
        mainPurpose: '주문 문의',
        highlights: '신선함',
        availableMaterials: ['사진'],
        neededFeatures: ['문의 폼'],
        desiredLevel: '비즈니스',
        referenceSites: 'https://example.com',
        otherRequests: '모바일 우선',
        contactName: '홍길동',
        contactEmail: 'a@b.c',
        contactPhone: '010',
      );

      final text = ConsultationSummary.buildSummaryText(draft);
      expect(text, contains('농산물'));
      expect(text, contains('햇살농장'));
      expect(text, contains('지역 고객, 단체'));
      expect(text, contains('서버에 저장되지'));
      expect(text, contains('홍길동'));
    });

    test('미입력 항목은 (미입력)으로 표시한다', () {
      final text = ConsultationSummary.buildSummaryText(
        const ConsultationDraft(projectName: '테스트'),
      );
      expect(text, contains('(미입력)'));
    });

    test('buildMailtoUri는 상담 메일 주소와 제목을 포함한다', () {
      const draft = ConsultationDraft(projectName: '테스트몰');
      final uri = ConsultationSummary.buildMailtoUri(draft);

      expect(uri.scheme, 'mailto');
      expect(uri.path, AppInfo.contactEmail);
      expect(uri.queryParameters['subject'], contains('테스트몰'));
      expect(uri.queryParameters['body'], isNotNull);
    });
  });
}
