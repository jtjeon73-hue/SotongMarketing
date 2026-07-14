import 'package:flutter/material.dart';

/// 페이지 본문: 패딩 + 최대 너비 + 스크롤.
class PageScaffoldBody extends StatelessWidget {
  const PageScaffoldBody({
    super.key,
    required this.child,
    this.maxWidth = 960,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
    this.controller,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      padding: padding,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
