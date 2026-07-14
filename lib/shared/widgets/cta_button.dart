import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

enum CtaVariant { primary, secondary }

/// 주요/보조 CTA 버튼.
class CtaButton extends StatelessWidget {
  const CtaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = CtaVariant.primary,
    this.icon,
    this.expanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final CtaVariant variant;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Text(label),
            ],
          );

    final button = switch (variant) {
      CtaVariant.primary => ElevatedButton(onPressed: onPressed, child: child),
      CtaVariant.secondary => OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          side: const BorderSide(color: AppColors.border),
        ),
        child: child,
      ),
    };

    if (!expanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
