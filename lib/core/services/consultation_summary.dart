import '../constants/app_info.dart';
import '../models/consultation_draft.dart';
import '../utils/mailto_helper.dart';

/// ConsultationDraft → 요약 문구·메일 제목·mailto URI.
abstract final class ConsultationSummary {
  static String displayName(ConsultationDraft draft) {
    final name = draft.projectName.trim();
    if (name.isNotEmpty) return name;
    final contact = draft.contactName.trim();
    if (contact.isNotEmpty) return contact;
    return '프로젝트';
  }

  static String emailSubject(ConsultationDraft draft) {
    return '[소통마케팅 제작 상담] ${displayName(draft)}';
  }

  static String buildSummaryText(ConsultationDraft draft) {
    final buf = StringBuffer()
      ..writeln('■ 소통마케팅 제작 상담 요약')
      ..writeln()
      ..writeln('1. 홍보 대상: ${_orDash(draft.whatToPromote)}')
      ..writeln('2. 업체·프로젝트명: ${_orDash(draft.projectName)}')
      ..writeln('3. 주요 고객: ${_joinOrDash(draft.mainCustomers)}')
      ..writeln('4. 홍보 목적: ${_orDash(draft.mainPurpose)}')
      ..writeln('5. 강조하고 싶은 내용: ${_orDash(draft.highlights)}')
      ..writeln('6. 보유 자료: ${_joinOrDash(draft.availableMaterials)}')
      ..writeln('7. 필요한 기능: ${_joinOrDash(draft.neededFeatures)}')
      ..writeln('8. 원하는 제작 수준: ${_orDash(draft.desiredLevel)}')
      ..writeln('9. 참고 사이트: ${_orDash(draft.referenceSites)}')
      ..writeln('10. 기타 요청사항: ${_orDash(draft.otherRequests)}');

    if (draft.contactName.isNotEmpty ||
        draft.contactEmail.isNotEmpty ||
        draft.contactPhone.isNotEmpty) {
      buf
        ..writeln()
        ..writeln('— 연락 정보 (선택) —')
        ..writeln('이름: ${_orDash(draft.contactName)}')
        ..writeln('이메일: ${_orDash(draft.contactEmail)}')
        ..writeln('전화: ${_orDash(draft.contactPhone)}');
    }

    buf
      ..writeln()
      ..writeln(
        '※ 이 내용은 브라우저에서 상담 정리를 위해 작성된 것이며, '
        '자동으로 서버에 저장되지 않습니다.',
      );

    return buf.toString().trimRight();
  }

  /// mailto URI. [includeBody]가 true여도 길이 제한 시 본문이 잘릴 수 있다.
  static Uri buildMailtoUri(
    ConsultationDraft draft, {
    bool includeBody = true,
  }) {
    final subject = emailSubject(draft);
    final body = includeBody ? buildSummaryText(draft) : null;
    return MailtoHelper.build(
      email: AppInfo.contactEmail,
      subject: subject,
      body: body,
    );
  }

  static String _orDash(String value) {
    final v = value.trim();
    return v.isEmpty ? '(미입력)' : v;
  }

  static String _joinOrDash(List<String> values) {
    final cleaned = values
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (cleaned.isEmpty) return '(미입력)';
    return cleaned.join(', ');
  }
}
