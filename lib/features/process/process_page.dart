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

  final ProcessStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${step.step}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: AppColors.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(step.title, style: theme.textTheme.titleMedium),
                    if (step.description.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        step.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.muted,
                          height: 1.45,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final stack = constraints.maxWidth < 520;
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

                        if (stack) {
                          return Column(
                            children: [
                              customer,
                              const SizedBox(height: 10),
                              sotong,
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: customer),
                            const SizedBox(width: 10),
                            Expanded(child: sotong),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(body, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}
