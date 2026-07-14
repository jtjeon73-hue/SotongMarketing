import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// 선택·태그용 칩.
class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.blue;
    final bg = selected ? accent.withValues(alpha: 0.12) : AppColors.bg;
    final border = selected ? accent : AppColors.border;
    final fg = selected ? accent : AppColors.body;

    final chip = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: fg,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );

    if (onTap == null) return chip;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: chip,
      ),
    );
  }
}
