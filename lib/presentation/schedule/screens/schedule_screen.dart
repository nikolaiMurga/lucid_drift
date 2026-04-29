import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/sleep_schedule.dart';
import '../../../domain/entities/sleep_session.dart';
import '../cubit/schedule_cubit.dart';
import '../cubit/schedule_state.dart';
import '../widgets/rem_timeline.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScheduleCubit(
        get: sl(),
        save: sl(),
        delete: sl(),
        calculate: sl(),
        activate: sl(),
        cancelTrigger: sl(),
        getTodaySession: sl(),
        saveDebrief: sl(),
        watchSessions: sl(),
      )..init(),
      child: const _ScheduleView(),
    );
  }
}

class _ScheduleView extends StatelessWidget {
  const _ScheduleView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Расписание сна'),
            actions: [
              if (state is ScheduleLoaded)
                Switch(
                  value: state.schedule.isActive,
                  activeThumbColor: AppColors.teal,
                  onChanged: (_) => context.read<ScheduleCubit>().toggleActive(),
                ),
            ],
          ),
          body: switch (state) {
            ScheduleLoading() => const Center(child: CircularProgressIndicator()),
            ScheduleEmpty() => _EmptySchedule(onCreate: () => context.read<ScheduleCubit>().createDefault()),
            ScheduleError(:final message) => Center(
              child: Text(message, style: const TextStyle(color: Colors.red)),
            ),
            ScheduleLoaded() => _ScheduleBody(state: state),
          },
        );
      },
    );
  }
}

// ─── Empty ────────────────────────────────────────────────────────────────────

class _EmptySchedule extends StatelessWidget {
  final Future<SleepSchedule> Function() onCreate;

  const _EmptySchedule({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.nightlight_outlined, size: 56, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text('Расписание не настроено', style: material.Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Задай время сна и подъёма —\nприложение рассчитает REM-окно',
              textAlign: material.TextAlign.center,
              style: material.Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dream,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              onPressed: onCreate,
              icon: const Icon(Icons.add, color: AppColors.textPrimary),
              label: const Text('Настроить расписание', style: TextStyle(color: AppColors.textPrimary)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Loaded body ──────────────────────────────────────────────────────────────

class _ScheduleBody extends StatelessWidget {
  final ScheduleLoaded state;

  const _ScheduleBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final s = state.schedule;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        // Баннер паузы
        if (!s.isActive) _PausedBanner(),

        // Утренний дебриф (если триггер сработал ночью)
        // TODO: раскомментировать когда дебриф готов
        // if (state.todaySession?.wasTriggered == true && state.todaySession?.lucidityLevel == LucidityLevel.none)
        //   _DebriefCard(session: state.todaySession!),

        // ── Кнопка активации ──────────────────────────────────────────────
        _TriggerActivationCard(state: state),
        const SizedBox(height: 20),

        // ── Время ─────────────────────────────────────────────────────────
        const _SectionLabel('Время сна'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _TimeCard(
                label: 'Засыпание',
                time: s.bedTime,
                icon: Icons.bedtime_outlined,
                color: AppColors.dream,
                onTap: () => _pickTime(context, s.bedTime, isBed: true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _TimeCard(
                label: 'Подъём',
                time: s.wakeTime,
                icon: Icons.wb_sunny_outlined,
                color: AppColors.warm,
                onTap: () => _pickTime(context, s.wakeTime, isBed: false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ── Таймлайн ──────────────────────────────────────────────────────
        const _SectionLabel('Фазы сна'),
        const SizedBox(height: 8),
        RemTimeline(schedule: s, remWindows: state.remWindows, triggerAt: state.triggerAt),
        const SizedBox(height: 20),

        // ── Цикл ──────────────────────────────────────────────────────────
        const _SectionLabel('Целевой REM-цикл'),
        const SizedBox(height: 4),
        Text('Триггер: ${_fmtDt(state.triggerAt)}', style: const TextStyle(fontSize: 12, color: AppColors.teal)),
        const SizedBox(height: 10),
        _CycleSelector(selected: s.targetCycle, bedTime: s.bedTime, onChanged: (c) => context.read<ScheduleCubit>().updateTargetCycle(c)),
        const SizedBox(height: 20),

        // ── Дни ───────────────────────────────────────────────────────────
        const _SectionLabel('Активные дни'),
        const SizedBox(height: 8),
        _DaySelector(activeDays: s.activeDays, onToggle: (d) => context.read<ScheduleCubit>().toggleDay(d)),
        const SizedBox(height: 20),

        // ── WBTB ──────────────────────────────────────────────────────────
        _WbtbSection(schedule: s),
        const SizedBox(height: 24),

        // ── Удалить ───────────────────────────────────────────────────────
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red),
            foregroundColor: Colors.red,
          ),
          onPressed: () => _confirmDelete(context),
          icon: const Icon(Icons.delete_outline),
          label: const Text('Удалить расписание'),
        ),
      ],
    );
  }

  Future<void> _pickTime(BuildContext context, TimeOfDay current, {required bool isBed}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: material.TimeOfDay(hour: current.hour, minute: current.minute),
      builder: (ctx, child) => material.Theme(
        data: material.Theme.of(ctx).copyWith(colorScheme: const ColorScheme.dark(primary: AppColors.dream)),
        child: child!,
      ),
    );
    if (picked == null || !context.mounted) return;
    final tod = TimeOfDay(hour: picked.hour, minute: picked.minute);
    if (isBed) {
      context.read<ScheduleCubit>().updateBedTime(tod);
    } else {
      context.read<ScheduleCubit>().updateWakeTime(tod);
    }
  }

  void _confirmDelete(BuildContext context) {
    final cubit = context.read<ScheduleCubit>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceHigh,
        title: const Text('Удалить расписание?'),
        content: const Text('Настройки будут сброшены.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              cubit.deleteSchedule();
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _fmtDt(DateTime dt) => '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

// ─── Trigger activation card ──────────────────────────────────────────────────

class _TriggerActivationCard extends StatelessWidget {
  final ScheduleLoaded state;

  const _TriggerActivationCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final isActive = state.isActive;
    final isBusy = state.isBusy;
    final scheduledAt = state.scheduledTriggerAt;

    final Color cardColor = isActive ? AppColors.dream.withValues(alpha: 0.08) : AppColors.surface;
    final Color borderColor = isActive ? AppColors.dream.withValues(alpha: 0.4) : AppColors.border;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isActive ? Icons.bedtime : Icons.bedtime_outlined, size: 20, color: isActive ? AppColors.dream : AppColors.textTertiary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isActive ? 'Триггер запланирован' : 'Активировать на эту ночь',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: material.FontWeight.w500,
                        color: isActive ? AppColors.dream : AppColors.textPrimary,
                      ),
                    ),
                    if (isActive && scheduledAt != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Сработает в ${scheduledAt.hour.toString().padLeft(2, '0')}:${scheduledAt.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ] else
                      const Text('Аффирмации начнут играть автоматически', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (isBusy)
            const Center(
              child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.dream)),
            )
          else if (isActive)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.dream),
                  foregroundColor: AppColors.dream,
                ),
                onPressed: () => context.read<ScheduleCubit>().cancelTrigger(),
                icon: const Icon(Icons.cancel_outlined, size: 18),
                label: const Text('Отменить'),
              ),
            )
          else ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.dream, padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: state.schedule.isActive ? () => context.read<ScheduleCubit>().activateTrigger() : null,
                icon: const Icon(Icons.play_arrow, color: AppColors.textPrimary),
                label: const Text('Активировать', style: TextStyle(color: AppColors.textPrimary)),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.textSecondary),
                  foregroundColor: AppColors.textSecondary,
                ),
                onPressed: () => context.read<ScheduleCubit>().testTriggerNow(),
                icon: const Icon(Icons.science_outlined, size: 18),
                label: const Text('Тест триггера сейчас'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Morning debrief card ─────────────────────────────────────────────────────

class _DebriefCard extends StatefulWidget {
  final SleepSession session;

  const _DebriefCard({required this.session});

  @override
  State<_DebriefCard> createState() => _DebriefCardState();
}

class _DebriefCardState extends State<_DebriefCard> {
  LucidityLevel _selected = LucidityLevel.none;
  final _notesCtrl = TextEditingController();
  bool _saved = false;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_saved) return const SizedBox.shrink();

    final triggeredAt = widget.session.triggeredAt!;
    final h = triggeredAt.hour.toString().padLeft(2, '0');
    final m = triggeredAt.minute.toString().padLeft(2, '0');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warm.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warm.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wb_twilight, size: 16, color: AppColors.warm),
              const SizedBox(width: 8),
              Text(
                'Триггер сработал в $h:$m',
                style: const TextStyle(fontSize: 13, fontWeight: material.FontWeight.w500, color: AppColors.warm),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Аффирмаций: ${widget.session.affirmationsPlayedCount}  ·  '
            'Триггеров: ${widget.session.triggersPlayedCount}',
            style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 14),
          Text('Как прошёл сон?', style: material.Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Row(
            children: LucidityLevel.values.map((level) {
              final label = switch (level) {
                LucidityLevel.none => 'Обычный',
                LucidityLevel.partial => 'Частично',
                LucidityLevel.lucid => '✨ Осознанный',
              };
              final isSelected = _selected == level;
              final color = switch (level) {
                LucidityLevel.none => AppColors.textTertiary,
                LucidityLevel.partial => AppColors.dream,
                LucidityLevel.lucid => AppColors.teal,
              };
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selected = level),
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isSelected ? color : AppColors.border),
                    ),
                    child: Text(
                      label,
                      textAlign: material.TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected ? color : AppColors.textTertiary,
                        fontWeight: isSelected ? material.FontWeight.w600 : material.FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _notesCtrl,
            decoration: const InputDecoration(labelText: 'Заметки о сне (опционально)', hintText: 'Что помнишь из сна?'),
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal),
              onPressed: () {
                context.read<ScheduleCubit>().saveDebrief(
                  sessionId: widget.session.id,
                  lucidity: _selected,
                  notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
                );
                setState(() => _saved = true);
              },
              child: const Text('Сохранить', style: TextStyle(color: AppColors.textPrimary)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable widgets ─────────────────────────────────────────────────────────

class _PausedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warm.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.warm.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.pause_circle_outline, size: 16, color: AppColors.warm),
          SizedBox(width: 8),
          Text('Расписание приостановлено', style: TextStyle(fontSize: 13, color: AppColors.warm)),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(fontSize: 11, letterSpacing: 0.6, color: AppColors.textTertiary, fontWeight: material.FontWeight.w500),
    );
  }
}

class _TimeCard extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _TimeCard({required this.label, required this.time, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 6),
                Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                const Spacer(),
                const Icon(Icons.edit_outlined, size: 14, color: AppColors.textTertiary),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              time.format(),
              style: TextStyle(fontSize: 28, fontWeight: material.FontWeight.w200, color: color, letterSpacing: 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _CycleSelector extends StatelessWidget {
  final RemCycle selected;
  final TimeOfDay bedTime;
  final ValueChanged<RemCycle> onChanged;

  const _CycleSelector({required this.selected, required this.bedTime, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: RemCycle.values.map((cycle) {
        final mins = switch (cycle) {
          RemCycle.second => 180,
          RemCycle.third => 270,
          RemCycle.fourth => 360,
          RemCycle.fifth => 450,
        };
        final totalMins = bedTime.hour * 60 + bedTime.minute + mins;
        final h = (totalMins ~/ 60) % 24;
        final m = totalMins % 60;
        final timeLabel = '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
        final cycleNum = cycle.index + 2;
        final isSelected = selected == cycle;

        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(cycle),
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.dream.withValues(alpha: 0.15) : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isSelected ? AppColors.dream : AppColors.border),
              ),
              child: Column(
                children: [
                  Text(
                    '$cycleNum',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: material.FontWeight.w300,
                      color: isSelected ? AppColors.dream : AppColors.textSecondary,
                    ),
                  ),
                  Text(timeLabel, style: TextStyle(fontSize: 10, color: isSelected ? AppColors.dream : AppColors.textTertiary)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DaySelector extends StatelessWidget {
  final List<int> activeDays;
  final ValueChanged<int> onToggle;
  static const _labels = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

  const _DaySelector({required this.activeDays, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (i) {
        final weekday = i + 1;
        final isActive = activeDays.contains(weekday);
        final isWeekend = weekday >= 6;
        return Expanded(
          child: GestureDetector(
            onTap: () => onToggle(weekday),
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isActive
                    ? (isWeekend ? AppColors.warm.withValues(alpha: 0.15) : AppColors.dream.withValues(alpha: 0.15))
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isActive ? (isWeekend ? AppColors.warm : AppColors.dream) : AppColors.border),
              ),
              child: Text(
                _labels[i],
                textAlign: material.TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? material.FontWeight.w600 : material.FontWeight.w400,
                  color: isActive ? (isWeekend ? AppColors.warm : AppColors.dream) : AppColors.textTertiary,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _WbtbSection extends StatelessWidget {
  final SleepSchedule schedule;

  const _WbtbSection({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WBTB режим',
                    style: TextStyle(fontSize: 14, fontWeight: material.FontWeight.w500, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 2),
                  Text('Wake Back To Bed', style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                ],
              ),
              const Spacer(),
              Switch(value: schedule.wbtbMode, activeThumbColor: AppColors.teal, onChanged: (_) => context.read<ScheduleCubit>().toggleWbtb()),
            ],
          ),
          if (schedule.wbtbMode) ...[
            const SizedBox(height: 8),
            Text(
              'Проснись через 5ч, побудь ${schedule.wbtbAwakeMins} мин и снова засни.',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Бодрствовать:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const Spacer(),
                Text(
                  '${schedule.wbtbAwakeMins} мин',
                  style: const TextStyle(fontSize: 13, color: AppColors.teal, fontWeight: material.FontWeight.w500),
                ),
              ],
            ),
            Slider(
              value: schedule.wbtbAwakeMins.toDouble(),
              min: 10,
              max: 60,
              divisions: 10,
              activeColor: AppColors.teal,
              onChanged: (v) => context.read<ScheduleCubit>().updateWbtbMins(v.round()),
            ),
          ],
        ],
      ),
    );
  }
}
