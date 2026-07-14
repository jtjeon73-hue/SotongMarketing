import 'package:flutter/material.dart';

/// 사이드바를 제외한 오른쪽 콘텐츠 영역의 공통 폭·패딩.
///
/// Header / Main / Footer가 같은 좌측 기준선을 쓰도록 한다.
/// [heightFactor]로 스크롤 뷰 안에서도 viewport 높이에 가두지 않는다.
class ContentContainer extends StatelessWidget {
  const ContentContainer({
    super.key,
    required this.child,
    this.maxWidth = ContentContainer.defaultMaxWidth,
    this.padding,
  });

  static const double defaultMaxWidth = 1440;

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  static EdgeInsets horizontalPaddingFor(double contentAreaWidth) {
    if (contentAreaWidth >= 1400) {
      return const EdgeInsets.symmetric(horizontal: 40);
    }
    if (contentAreaWidth >= 1100) {
      return const EdgeInsets.symmetric(horizontal: 32);
    }
    if (contentAreaWidth >= 700) {
      return const EdgeInsets.symmetric(horizontal: 24);
    }
    return const EdgeInsets.symmetric(horizontal: 16);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final areaWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        final resolvedPadding = padding ?? horizontalPaddingFor(areaWidth);

        return Padding(
          padding: resolvedPadding,
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
