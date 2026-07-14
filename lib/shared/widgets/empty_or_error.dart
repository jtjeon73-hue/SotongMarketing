import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'cta_button.dart';

/// 빈 상태 또는 오류 안내.
class EmptyOrError extends StatelessWidget {
  const EmptyOrError({
    super.key,
    required this.message,
    this.title,
    this.isError = false,
    this.onRetry,
    this.retryLabel = '다시 시도',
  });

  final String message;
  final String? title;
  final bool isError;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.inbox_outlined,
              size: 48,
              color: isError ? AppColors.coral : AppColors.muted,
            ),
            const SizedBox(height: 16),
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.muted,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              CtaButton(
                label: retryLabel,
                onPressed: onRetry,
                variant: CtaVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
