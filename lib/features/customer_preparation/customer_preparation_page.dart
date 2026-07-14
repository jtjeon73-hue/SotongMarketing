import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/content_repository.dart';
import '../../shared/widgets/cta_button.dart';
import '../../shared/widgets/empty_or_error.dart';
import '../../shared/widgets/info_card.dart';
import '../../shared/widgets/notice_banner.dart';
import '../../shared/widgets/page_scaffold_body.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/tag_chip.dart';

class CustomerPreparationPage extends StatefulWidget {
  const CustomerPreparationPage({super.key});

  @override
  State<CustomerPreparationPage> createState() =>
      _CustomerPreparationPageState();
}

class _CustomerPreparationPageState extends State<CustomerPreparationPage> {
  late Future<_PrepContent> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_PrepContent> _load() async {
    try {
      final raw = await ContentRepository().loadPreparationMaterials();
      return _PrepContent.fromJson(raw);
    } catch (_) {
      return _PrepContent.fallback();
    }
  }

  void _retry() {
    setState(() => _future = _load());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_PrepContent>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const PageScaffoldBody(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return PageScaffoldBody(
            child: EmptyOrError(
              isError: true,
              title: '준비자료를 불러오지 못했습니다',
              message: '잠시 후 다시 시도해 주세요.',
              onRetry: _retry,
            ),
          );
        }

        return _PrepBody(content: snapshot.data!);
      },
    );
  }
}

class _PrepBody extends StatelessWidget {
  const _PrepBody({required this.content});

  final _PrepContent content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PageScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: '고객 준비자료',
            subtitle: '제작 전에 무엇을 준비하면 좋은지 쉽게 정리했습니다.',
          ),
          NoticeBanner(message: content.encouragement),
          const SizedBox(height: 28),
          SectionHeader(
            title: content.basicTitle,
            subtitle: content.basicDescription,
          ),
          ...[
            for (final item in content.basicItems)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InfoCard(
                  accent: AppColors.blue,
                  title: item.name,
                  child: (item.note != null && item.note!.trim().isNotEmpty)
                      ? Text(
                          item.note!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.muted,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
          ],
          const SizedBox(height: 16),
          SectionHeader(
            title: content.contactTitle,
            subtitle: content.contactDescription,
          ),
          InfoCard(
            accent: AppColors.teal,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final item in content.contactItems)
                  TagChip(label: item.name, color: AppColors.teal),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SectionHeader(
            title: content.photosTitle,
            subtitle: content.photosDescription,
          ),
          InfoCard(
            accent: AppColors.purple,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final item in content.photoItems)
                  TagChip(label: item.name, color: AppColors.purple),
              ],
            ),
          ),
          if (content.whenPhotosLimited.isNotEmpty) ...[
            const SizedBox(height: 16),
            InfoCard(
              title: '사진이 부족한 경우',
              accent: AppColors.gold,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final tip in content.whenPhotosLimited)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: AppColors.gold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(tip, style: theme.textTheme.bodyMedium),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 32),
          SectionHeader(
            title: content.optionalTitle,
            subtitle: content.optionalDescription,
          ),
          InfoCard(
            accent: AppColors.coral,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final item in content.optionalItems)
                      TagChip(label: item.name, color: AppColors.coral),
                  ],
                ),
                if (content.reviewsCaution != null &&
                    content.reviewsCaution!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    content.reviewsCaution!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.muted,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.noticeBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.noticeBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.encouragement,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.navy,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                CtaButton(
                  label: '상담 준비하기',
                  icon: Icons.edit_note_outlined,
                  onPressed: () => context.go('/consultation'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _PrepItem {
  const _PrepItem({required this.name, this.note});

  final String name;
  final String? note;

  factory _PrepItem.fromJson(Map<String, dynamic> json) {
    return _PrepItem(
      name: json['name'] as String? ?? '',
      note: json['note'] as String?,
    );
  }
}

class _PrepContent {
  const _PrepContent({
    required this.encouragement,
    required this.basicTitle,
    required this.basicDescription,
    required this.basicItems,
    required this.contactTitle,
    required this.contactDescription,
    required this.contactItems,
    required this.photosTitle,
    required this.photosDescription,
    required this.photoItems,
    required this.whenPhotosLimited,
    required this.optionalTitle,
    required this.optionalDescription,
    required this.optionalItems,
    this.reviewsCaution,
  });

  final String encouragement;
  final String basicTitle;
  final String basicDescription;
  final List<_PrepItem> basicItems;
  final String contactTitle;
  final String contactDescription;
  final List<_PrepItem> contactItems;
  final String photosTitle;
  final String photosDescription;
  final List<_PrepItem> photoItems;
  final List<String> whenPhotosLimited;
  final String optionalTitle;
  final String optionalDescription;
  final List<_PrepItem> optionalItems;
  final String? reviewsCaution;

  factory _PrepContent.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> section(String key) {
      final v = json[key];
      if (v is Map) return Map<String, dynamic>.from(v);
      return const {};
    }

    List<_PrepItem> itemsOf(Map<String, dynamic> section) {
      final raw = section['items'];
      if (raw is! List) return const [];
      return raw
          .whereType<Map>()
          .map((e) => _PrepItem.fromJson(Map<String, dynamic>.from(e)))
          .where((e) => e.name.isNotEmpty)
          .toList();
    }

    final basic = section('basic');
    final contact = section('contactMethods');
    final photos = section('photos');
    final optional = section('optional');

    final whenLimited = photos['whenLimited'];
    final limited = whenLimited is List
        ? whenLimited.map((e) => e.toString()).toList()
        : <String>[];

    final encouragement =
        json['encouragement'] as String? ??
        '자료가 완벽하지 않아도 시작할 수 있습니다. '
            '현재 가지고 있는 내용부터 함께 정리합니다.';

    return _PrepContent(
      encouragement: encouragement,
      basicTitle: basic['title'] as String? ?? '필수에 가까운 기본 자료',
      basicDescription: basic['description'] as String? ?? '',
      basicItems: itemsOf(basic),
      contactTitle: contact['title'] as String? ?? '연락 방법',
      contactDescription: contact['description'] as String? ?? '',
      contactItems: itemsOf(contact),
      photosTitle: photos['title'] as String? ?? '사진',
      photosDescription: photos['description'] as String? ?? '',
      photoItems: itemsOf(photos),
      whenPhotosLimited: limited,
      optionalTitle: optional['title'] as String? ?? '선택 자료',
      optionalDescription: optional['description'] as String? ?? '',
      optionalItems: itemsOf(optional),
      reviewsCaution: optional['reviewsCaution'] as String?,
    );
  }

  factory _PrepContent.fallback() {
    return const _PrepContent(
      encouragement: '자료가 완벽하지 않아도 시작할 수 있습니다. 현재 가지고 있는 내용부터 함께 정리합니다.',
      basicTitle: '필수에 가까운 기본 자료',
      basicDescription: '아래가 있으면 상담과 제작을 시작하기 좋습니다. 모두 완벽하지 않아도 됩니다.',
      basicItems: [
        _PrepItem(name: '업체명 또는 프로젝트명', note: '사이트에 표시될 이름입니다.'),
        _PrepItem(
          name: '무엇을 홍보하는지',
          note: '회사, 상품, 서비스, 농산물, 숙박 등 한 문장으로도 충분합니다.',
        ),
        _PrepItem(name: '주요 고객', note: '누구에게 보여 주고 싶은지 알려 주세요.'),
        _PrepItem(
          name: '가장 강조하고 싶은 점',
          note: '품질, 위치, 기술, 스토리, 가격 등 우선순위를 알려 주세요.',
        ),
        _PrepItem(name: '연락 방법', note: '방문자가 문의할 수단이 필요합니다.'),
      ],
      contactTitle: '연락 방법',
      contactDescription: '사용 중인 연락 수단을 골라 주시면 사이트에 맞게 배치합니다.',
      contactItems: [
        _PrepItem(name: '전화'),
        _PrepItem(name: '이메일'),
        _PrepItem(name: '카카오톡'),
        _PrepItem(name: '네이버'),
        _PrepItem(name: 'SNS'),
        _PrepItem(name: '예약 링크'),
        _PrepItem(name: '기타'),
      ],
      photosTitle: '사진',
      photosDescription: '있으면 도움이 되는 사진입니다. 없어도 기존 자료로 시작할 수 있습니다.',
      photoItems: [
        _PrepItem(name: '대표 사진'),
        _PrepItem(name: '제품 사진'),
        _PrepItem(name: '매장 사진'),
        _PrepItem(name: '작업 현장'),
        _PrepItem(name: '시설'),
        _PrepItem(name: '서비스 과정'),
        _PrepItem(name: '대표자'),
        _PrepItem(name: '로고'),
      ],
      whenPhotosLimited: [
        '기존 사진으로 시작 가능',
        '추가 사진 촬영 권장사항을 안내할 수 있음',
        '이미지 제작 또는 보완 가능 여부는 상담',
      ],
      optionalTitle: '선택 자료',
      optionalDescription: '있으면 더 빠르고 풍성하게 구성할 수 있는 자료입니다.',
      optionalItems: [
        _PrepItem(name: '회사 소개서'),
        _PrepItem(name: 'PDF'),
        _PrepItem(name: '기존 홈페이지'),
        _PrepItem(name: '블로그'),
        _PrepItem(name: 'SNS'),
        _PrepItem(name: '메뉴판'),
        _PrepItem(name: '상품 설명'),
        _PrepItem(name: '고객 후기'),
        _PrepItem(name: '인증서'),
        _PrepItem(name: '특허'),
        _PrepItem(name: '수상내역'),
        _PrepItem(name: '지도 위치'),
      ],
      reviewsCaution: '고객 후기는 실제로 받은 내용만 사용합니다. 없는 후기를 만들어 넣지 않습니다.',
    );
  }
}
