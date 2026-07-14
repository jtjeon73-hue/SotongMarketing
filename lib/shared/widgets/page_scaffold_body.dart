import 'package:flutter/material.dart';

import '../layout/app_footer.dart';
import '../layout/content_container.dart';

/// 페이지 본문: 공통 폭·패딩 + 스크롤 + 콘텐츠 흐름 끝의 Footer.
///
/// Footer는 Stack/bottomNavigationBar가 아니라 스크롤 콘텐츠의 마지막이다.
class PageScaffoldBody extends StatelessWidget {
  const PageScaffoldBody({
    super.key,
    required this.child,
    this.maxWidth = ContentContainer.defaultMaxWidth,
    this.padding,
    this.controller,
    this.showFooter = true,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final bool showFooter;

  static const EdgeInsets _vertical = EdgeInsets.symmetric(vertical: 28);

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController.none(
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ContentContainer(
              maxWidth: maxWidth,
              padding: padding,
              child: padding == null
                  ? Padding(padding: _vertical, child: child)
                  : child,
            ),
            if (showFooter) const AppFooter(),
          ],
        ),
      ),
    );
  }
}
