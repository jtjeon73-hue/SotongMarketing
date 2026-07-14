import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/process_step.dart';
import '../../core/services/content_repository.dart';
import '../../shared/widgets/cta_button.dart';
import '../../shared/widgets/empty_or_error.dart';
import '../../shared/widgets/page_scaffold_body.dart';
import '../../shared/widgets/section_header.dart';

class ProcessPage extends StatefulWidget {
  const ProcessPage({super.key, this.repository});

  final ContentRepository? repository;

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  late final ContentRepository _repo = widget.repository ?? ContentRepository();
  late Future<List<ProcessStep>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.loadProcessSteps();
  }

  void _retry() {
    setState(() {
      _repo.clearCache();
      _future = _repo.loadProcessSteps();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffoldBody(
      child: FutureBuilder<List<ProcessStep>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 64),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return EmptyOrError(
              title: '불러오지 못했습니다',
              message: '제작 과정 정보를 가져오는 중 문제가 발생했습니다.',
              isError: true,
              onRetry: _retry,
            );
          }
          final steps = List<ProcessStep>.from(snapshot.data ?? const [])
            ..sort((a, b) => a.step.compareTo(b.step));
          if (steps.isEmpty) {
            return const EmptyOrError(message: '표시할 제작 단계가 없습니다.');
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: '단계별 제작 과정',
                subtitle: '상담부터 배포·활용까지, 고객과 소통웨어가 각각 하는 일을 구분해서 보여 드립니다.',
              ),
              ...[
                for (var i = 0; i < steps.length; i++)
                  _TimelineStep(step: steps[i], isLast: i == steps.length - 1),
              ],
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  CtaButton(
                    label: '상담 시작하기',
                    icon: Icons.chat_bubble_outline,
                    onPressed: () => context.go('/consultation'),
                  ),
                  CtaButton(
                    label: '준비 자료 보기',
                    variant: CtaVariant.secondary,
                    onPressed: () => context.go('/prepare'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({required this.step, required this.isLast});

  static const double _mobileBreakpoint = 600;

  final ProcessStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _mobileBreakpoint) {
          return _MobileProcessStep(step: step, isLast: isLast);
        }
        return _DesktopProcessStep(step: step, isLast: isLast);
      },
    );
  }
}

class _MobileProcessStep extends StatelessWidget {
  const _MobileProcessStep({required this.step, required this.isLast});

  final ProcessStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _StepNumber(number: step.step, compact: true),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    step.title,
                    style: theme.textTheme.titleMedium?.copyWith(height: 1.35),
                  ),
                ),
              ],
            ),
            if (step.description.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                step.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.muted,
                  height: 1.55,
                ),
              ),
            ],
            const SizedBox(height: 16),
            _RolePanel(
              label: '고객이 하는 일',
              body: step.customerDoes,
              color: AppColors.teal,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 10),
            _RolePanel(
              label: '소통웨어가 하는 일',
              body: step.sotongwareDoes,
              color: AppColors.blue,
              icon: Icons.handshake_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopProcessStep extends StatelessWidget {
  const _DesktopProcessStep({required this.step, required this.isLast});

  final ProcessStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepNumber(number: step.step),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: theme.textTheme.titleMedium?.copyWith(height: 1.35),
                  ),
                  if (step.description.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      step.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.muted,
                        height: 1.5,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final stackRoles = constraints.maxWidth < 720;
                      final customer = _RolePanel(
                        label: '고객이 하는 일',
                        body: step.customerDoes,
                        color: AppColors.teal,
                        icon: Icons.person_outline,
                      );
                      final sotong = _RolePanel(
                        label: '소통웨어가 하는 일',
                        body: step.sotongwareDoes,
                        color: AppColors.blue,
                        icon: Icons.handshake_outlined,
                      );

                      if (stackRoles) {
                        return Column(
                          children: [
                            customer,
                            const SizedBox(height: 12),
                            sotong,
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: customer),
                          const SizedBox(width: 12),
                          Expanded(child: sotong),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepNumber extends StatelessWidget {
  const _StepNumber({required this.number, this.compact = false});

  final int number;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 34.0 : 40.0;
    return Semantics(
      label: '$number단계',
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.blue,
          shape: BoxShape.circle,
        ),
        child: Text(
          '$number',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _RolePanel extends StatelessWidget {
  const _RolePanel({
    required this.label,
    required this.body,
    required this.color,
    required this.icon,
  });

  final String label;
  final String body;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            softWrap: true,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
          ),
        ],
      ),
    );
  }
}
