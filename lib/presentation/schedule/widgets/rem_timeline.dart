import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/sleep_schedule.dart';
import '../../../domain/usecases/schedule/schedule_usecases.dart';

class RemTimeline extends StatelessWidget {
  final SleepSchedule schedule;
  final List<RemWindow> remWindows;

  const RemTimeline({
    super.key,
    required this.schedule,
    required this.remWindows,
  });

  @override
  Widget build(BuildContext context) {
    final bed = DateTime.now().copyWith(
      hour: schedule.bedTime.hour,
      minute: schedule.bedTime.minute,
      second: 0,
    );
    final wake = DateTime.now().copyWith(
      hour: schedule.wakeTime.hour,
      minute: schedule.wakeTime.minute,
      second: 0,
    );
    final totalMins = wake.difference(bed).inMinutes.abs();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.nightlight, size: 14, color: AppColors.dream),
              const SizedBox(width: 6),
              Text(
                'Таймлайн сна',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiary,
                      letterSpacing: 0.5,
                    ),
              ),
              const Spacer(),
              Text(
                '${schedule.bedTime.format()} → ${schedule.wakeTime.format()}',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Визуальная полоска
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              return SizedBox(
                height: 48,
                child: Stack(
                  children: [
                    // Базовая серая полоска (NREM)
                    Positioned(
                      left: 0, right: 0,
                      top: 16, height: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    // REM-блоки
                    ...remWindows.map((w) {
                      final startMins = w.start.difference(bed).inMinutes;
                      final endMins = w.end.difference(bed).inMinutes;
                      final left = (startMins / totalMins * width).clamp(0.0, width);
                      final right = width - (endMins / totalMins * width).clamp(0.0, width);

                      final matchingCycle = schedule.targetCycles
                          .where((c) => c.index + 1 == w.cycle)
                          .firstOrNull;
                      final isSelected = matchingCycle != null;
                      final isAffirmation = matchingCycle?.isAffirmationPhase ?? false;

                      final Color blockColor = isSelected
                          ? (isAffirmation
                              ? AppColors.dream.withValues(alpha: 0.85)
                              : AppColors.lucid.withValues(alpha: 0.85))
                          : AppColors.textTertiary.withValues(alpha: 0.3);

                      return Positioned(
                        left: left,
                        right: right.clamp(0.0, width),
                        top: 12,
                        height: 24,
                        child: Container(
                          decoration: BoxDecoration(
                            color: blockColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      );
                    }),

                    // Подписи: засыпание / пробуждение
                    Positioned(
                      left: 0, bottom: 0,
                      child: Text(schedule.bedTime.format(),
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textTertiary)),
                    ),
                    Positioned(
                      right: 0, bottom: 0,
                      child: Text(schedule.wakeTime.format(),
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textTertiary)),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // Легенда
          Row(
            children: [
              _LegendItem(color: AppColors.textTertiary.withValues(alpha: 0.3), label: 'REM'),
              const SizedBox(width: 12),
              const _LegendItem(color: AppColors.dream, label: 'Аффирмации'),
              const SizedBox(width: 12),
              const _LegendItem(color: AppColors.lucid, label: 'Триггеры'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10, height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textTertiary)),
      ],
    );
  }
}
