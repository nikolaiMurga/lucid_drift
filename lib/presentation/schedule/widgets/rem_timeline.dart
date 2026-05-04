import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart' hide TimeOfDay;
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/sleep_schedule.dart';

// ─── Модель модуля таймлайна ──────────────────────────────────────────────────

enum RemModuleType { trigger, affirmation }

class RemModule {
  final RemModuleType type;

  /// Пауза перед воспроизведением этого модуля, в секундах.
  final int delaySeconds;

  const RemModule({required this.type, this.delaySeconds = 0});

  RemModule copyWith({RemModuleType? type, int? delaySeconds}) => RemModule(
    type: type ?? this.type,
    delaySeconds: delaySeconds ?? this.delaySeconds,
  );
}

// ─── Стартовая задержка цикла ─────────────────────────────────────────────────

class _CycleConfig {
  /// Задержка от старта REM-фазы до первого модуля, в минутах (0–30, шаг 5).
  final int startOffsetMins;
  final List<RemModule> modules;

  const _CycleConfig({this.startOffsetMins = 0, this.modules = const []});

  _CycleConfig copyWith({int? startOffsetMins, List<RemModule>? modules}) =>
      _CycleConfig(
        startOffsetMins: startOffsetMins ?? this.startOffsetMins,
        modules: modules ?? this.modules,
      );
}

// ─── CycleSelector ───────────────────────────────────────────────────────────

/// Ряд из 5 чипов REM-циклов. Первые два — только отображение (NREM).
/// Циклы 3–5 работают как свич: нажал — активировал, нажал снова — деактивировал.
/// При активации открывается [RemTimeline] для этого цикла.
class CycleSelector extends StatefulWidget {
  final TimeOfDay bedTime;

  const CycleSelector({super.key, required this.bedTime});

  @override
  State<CycleSelector> createState() => _CycleSelectorState();
}

class _CycleSelectorState extends State<CycleSelector> {
  /// Множество активных индексов (0-based). Каждый чип — независимый свич.
  final Set<int> _activeIndices = {};

  /// Конфигурация каждого из 5 циклов.
  final List<_CycleConfig> _configs = List.generate(5, (_) => const _CycleConfig());

  String _chipTime(int i) {
    final totalMins = widget.bedTime.hour * 60 + widget.bedTime.minute + _cycleMinutesFromBed(i);
    final h = (totalMins ~/ 60) % 24;
    final m = totalMins % 60;
    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Подсказка ──────────────────────────────────────────────────────
        Text(
          _activeIndices.isNotEmpty
              ? 'Нажмите на цикл повторно чтобы выключить'
              : 'Нажмите на цикл 3–5 чтобы активировать триггеры',
          style: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
        ),
        const SizedBox(height: 10),

        // ── Ряд чипов ─────────────────────────────────────────────────────
        Row(
          children: List.generate(5, (i) {
            final cycleNum = i + 1;
            final selectable = i >= 2;
            final isActive = _activeIndices.contains(i);
            final timeLabel = _chipTime(i);

            return Expanded(
              child: GestureDetector(
                onTap: selectable
                    ? () => setState(() {
                  isActive ? _activeIndices.remove(i) : _activeIndices.add(i);
                })
                    : null,
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: !selectable
                        ? AppColors.surface.withValues(alpha: 0.5)
                        : isActive
                        ? AppColors.lucid.withValues(alpha: 0.12)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: !selectable
                          ? AppColors.border.withValues(alpha: 0.4)
                          : isActive
                          ? AppColors.lucid
                          : AppColors.border,
                      width: isActive ? 1.5 : 0.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$cycleNum',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: material.FontWeight.w400,
                          color: !selectable
                              ? AppColors.textTertiary.withValues(alpha: 0.5)
                              : isActive
                              ? AppColors.lucid
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        timeLabel,
                        style: TextStyle(
                          fontSize: 9,
                          color: !selectable
                              ? AppColors.textTertiary.withValues(alpha: 0.4)
                              : isActive
                              ? AppColors.lucid
                              : AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      _ChipBadge(
                        label: !selectable ? 'NREM' : isActive ? 'активен' : 'REM',
                        active: isActive,
                        selectable: selectable,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),

        // ── RemTimeline под каждым активным циклом ─────────────────────
        for (final i in [2, 3, 4]) ...[
          if (_activeIndices.contains(i)) ...[
            const SizedBox(height: 12),
            RemTimeline(
              cycleIndex: i,
              bedTime: widget.bedTime,
              config: _configs[i],
              onConfigChanged: (updated) => setState(() => _configs[i] = updated),
            ),
          ],
        ],
      ],
    );
  }

  /// Примерное количество минут от отбоя до старта i-го REM-цикла.
  static int _cycleMinutesFromBed(int index) {
    const offsets = [90, 180, 270, 360, 450];
    return offsets[index];
  }
}

class _ChipBadge extends StatelessWidget {
  final String label;
  final bool active;
  final bool selectable;

  const _ChipBadge({required this.label, required this.active, required this.selectable});

  @override
  Widget build(BuildContext context) {
    final Color bg = !selectable
        ? AppColors.surface
        : active
        ? AppColors.lucid.withValues(alpha: 0.18)
        : AppColors.surface;
    final Color fg = !selectable
        ? AppColors.textTertiary.withValues(alpha: 0.4)
        : active
        ? AppColors.lucid
        : AppColors.textTertiary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(label, style: TextStyle(fontSize: 9, color: fg)),
    );
  }
}

// ─── RemTimeline ─────────────────────────────────────────────────────────────

/// Вертикальный таймлайн фазы REM с модулями триггеров и аффирмаций.
class RemTimeline extends StatelessWidget {
  final int cycleIndex;
  final TimeOfDay bedTime;
  final _CycleConfig config;
  final ValueChanged<_CycleConfig> onConfigChanged;

  const RemTimeline({
    super.key,
    required this.cycleIndex,
    required this.bedTime,
    required this.config,
    required this.onConfigChanged,
  });

  // Время старта цикла в минутах от полуночи
  int get _cycleStartMins {
    const offsets = [90, 180, 270, 360, 450];
    return bedTime.hour * 60 + bedTime.minute + offsets[cycleIndex];
  }

  String _fmtTime(int totalMins) {
    final h = (totalMins ~/ 60) % 24;
    final m = totalMins % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  String _fmtSec(int s) {
    if (s == 0) return '0с';
    return s < 60 ? '$sс' : '${(s / 60).round()}м';
  }

  @override
  Widget build(BuildContext context) {
    final cycleTime = _fmtTime(_cycleStartMins);
    final hasModules = config.modules.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Заголовок ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.lucid,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Цикл ${cycleIndex + 1} · таймлайн',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: material.FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      hasModules
                          ? '$cycleTime · старт +${config.startOffsetMins}м'
                          : '$cycleTime · нет модулей',
                      style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.lucid.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'активен',
                    style: TextStyle(fontSize: 11, color: AppColors.lucid),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 0, thickness: 0.5, color: AppColors.border),

          // ── Пустое состояние ──────────────────────────────────────────
          if (!hasModules) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Column(
                children: [
                  const Text(
                    'Добавьте триггер или аффирмацию',
                    style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
                    textAlign: material.TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _AddButton(
                          type: RemModuleType.trigger,
                          onTap: () => _addModule(RemModuleType.trigger),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _AddButton(
                          type: RemModuleType.affirmation,
                          onTap: () => _addModule(RemModuleType.affirmation),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            // ── Тело таймлайна ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Column(
                children: [
                  // Плашка "Старт через"
                  _StartOffsetRow(
                    cycleTime: cycleTime,
                    offsetMins: config.startOffsetMins,
                    onChanged: (v) => onConfigChanged(config.copyWith(startOffsetMins: v)),
                    hasNext: true,
                  ),

                  // Модули
                  ...List.generate(config.modules.length, (i) {
                    final mod = config.modules[i];
                    final isLast = i == config.modules.length - 1;

                    // Вычисляем время этого модуля
                    int elapsed = _cycleStartMins + config.startOffsetMins;
                    for (int j = 0; j < i; j++) {
                      elapsed += (config.modules[j].delaySeconds ~/ 60);
                      elapsed += 1; // ~30с воспроизведения ≈ 1 мин
                    }
                    elapsed += mod.delaySeconds ~/ 60;

                    return _ModuleRow(
                      timeLabel: _fmtTime(elapsed),
                      module: mod,
                      isLast: isLast,
                      delayLabel: _fmtSec(mod.delaySeconds),
                      onDelayChanged: (v) {
                        final updated = List<RemModule>.from(config.modules);
                        updated[i] = mod.copyWith(delaySeconds: v);
                        onConfigChanged(config.copyWith(modules: updated));
                      },
                      onDelete: () {
                        final updated = List<RemModule>.from(config.modules)..removeAt(i);
                        onConfigChanged(config.copyWith(modules: updated));
                      },
                    );
                  }),
                ],
              ),
            ),

            // ── Кнопки добавления ────────────────────────────────────
            const Divider(height: 16, thickness: 0.5, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: _AddButton(
                      type: RemModuleType.trigger,
                      compact: true,
                      onTap: () => _addModule(RemModuleType.trigger),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _AddButton(
                      type: RemModuleType.affirmation,
                      compact: true,
                      onTap: () => _addModule(RemModuleType.affirmation),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _addModule(RemModuleType type) {
    final updated = List<RemModule>.from(config.modules)
      ..add(RemModule(type: type, delaySeconds: 30));
    onConfigChanged(config.copyWith(modules: updated));
  }
}

// ─── Строка "Старт через" ─────────────────────────────────────────────────────

class _StartOffsetRow extends StatelessWidget {
  final String cycleTime;
  final int offsetMins;
  final ValueChanged<int> onChanged;
  final bool hasNext;

  const _StartOffsetRow({
    required this.cycleTime,
    required this.offsetMins,
    required this.onChanged,
    required this.hasNext,
  });

  @override
  Widget build(BuildContext context) {
    return _TlRow(
      timeLabel: cycleTime,
      dotColor: AppColors.warm,
      hasLine: hasNext,
      child: _Pill(
        color: AppColors.warm,
        icon: Icons.play_arrow_rounded,
        label: 'Старт через',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 80,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                  activeTrackColor: AppColors.warm,
                  inactiveTrackColor: AppColors.border,
                  thumbColor: AppColors.warm,
                  overlayColor: AppColors.warm.withValues(alpha: 0.15),
                ),
                child: Slider(
                  value: offsetMins.toDouble(),
                  min: 0,
                  max: 30,
                  divisions: 6,
                  onChanged: (v) => onChanged(v.round()),
                ),
              ),
            ),
            SizedBox(
              width: 28,
              child: Text(
                offsetMins == 0 ? '0' : '$offsetMinsм',
                textAlign: material.TextAlign.right,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: material.FontWeight.w500,
                  color: AppColors.warm,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Строка модуля ────────────────────────────────────────────────────────────

class _ModuleRow extends StatelessWidget {
  final String timeLabel;
  final RemModule module;
  final bool isLast;
  final String delayLabel;
  final ValueChanged<int> onDelayChanged;
  final VoidCallback onDelete;

  const _ModuleRow({
    required this.timeLabel,
    required this.module,
    required this.isLast,
    required this.delayLabel,
    required this.onDelayChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isTrigger = module.type == RemModuleType.trigger;
    final dotColor = isTrigger ? AppColors.lucid : AppColors.dream;

    return Column(
      children: [
        // Слайдер паузы
        _PauseSlider(
          value: module.delaySeconds,
          label: delayLabel,
          onChanged: onDelayChanged,
        ),

        // Плашка модуля
        _TlRow(
          timeLabel: timeLabel,
          dotColor: dotColor,
          hasLine: !isLast,
          child: _ModulePill(
            module: module,
            onDelete: onDelete,
          ),
        ),
      ],
    );
  }
}

// ─── Слайдер паузы ────────────────────────────────────────────────────────────

class _PauseSlider extends StatelessWidget {
  final int value;
  final String label;
  final ValueChanged<int> onChanged;

  const _PauseSlider({required this.value, required this.label, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 48, bottom: 2),
      child: Row(
        children: [
          const Text('пауза', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
          const SizedBox(width: 6),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                activeTrackColor: AppColors.border,
                inactiveTrackColor: AppColors.border,
                thumbColor: AppColors.textTertiary,
                overlayColor: AppColors.textTertiary.withValues(alpha: 0.1),
              ),
              child: Slider(
                value: value.toDouble(),
                min: 0,
                max: 120,
                divisions: 24,
                onChanged: (v) => onChanged(v.round()),
              ),
            ),
          ),
          SizedBox(
            width: 28,
            child: Text(
              label,
              textAlign: material.TextAlign.right,
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Базовая строка таймлайна ─────────────────────────────────────────────────

class _TlRow extends StatelessWidget {
  final String timeLabel;
  final Color dotColor;
  final bool hasLine;
  final Widget child;

  const _TlRow({
    required this.timeLabel,
    required this.dotColor,
    required this.hasLine,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Время
          SizedBox(
            width: 36,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                timeLabel,
                textAlign: material.TextAlign.right,
                style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Линия + точка
          SizedBox(
            width: 12,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                ),
                if (hasLine)
                  Expanded(
                    child: Container(width: 1, color: AppColors.border),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Контент
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Плашка модуля ────────────────────────────────────────────────────────────

class _ModulePill extends StatelessWidget {
  final RemModule module;
  final VoidCallback onDelete;

  const _ModulePill({required this.module, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isTrigger = module.type == RemModuleType.trigger;
    final bg = isTrigger
        ? AppColors.lucid.withValues(alpha: 0.1)
        : AppColors.dream.withValues(alpha: 0.1);
    final border = isTrigger
        ? AppColors.lucid.withValues(alpha: 0.35)
        : AppColors.dream.withValues(alpha: 0.35);
    final iconBg = isTrigger
        ? AppColors.lucid.withValues(alpha: 0.2)
        : AppColors.dream.withValues(alpha: 0.2);
    final textColor = isTrigger ? AppColors.lucid : AppColors.dream;
    final label = isTrigger ? 'Триггер' : 'Аффирмация';
    final icon = isTrigger ? Icons.psychology_outlined : Icons.star_outline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(5)),
            child: Icon(icon, size: 12, color: textColor),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: material.FontWeight.w500,
              color: textColor,
            ),
          ),
          const Spacer(),
          const Text('30с', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.close, size: 16, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

// ─── Плашка с произвольным trailing ──────────────────────────────────────────

class _Pill extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final Widget trailing;

  const _Pill({
    required this.color,
    required this.icon,
    required this.label,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(icon, size: 12, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: material.FontWeight.w500,
              color: color,
            ),
          ),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}

// ─── Кнопка добавления ────────────────────────────────────────────────────────

class _AddButton extends StatelessWidget {
  final RemModuleType type;
  final bool compact;
  final VoidCallback onTap;

  const _AddButton({required this.type, this.compact = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isTrigger = type == RemModuleType.trigger;
    final color = isTrigger ? AppColors.lucid : AppColors.dream;
    final label = isTrigger ? 'Триггер' : 'Аффирмация';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: compact ? 8 : 12,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.border,
            width: 0.5,
            // dashed не поддерживается нативно — используем обычную границу
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: compact ? 16 : 18,
              height: compact ? 16 : 18,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(Icons.add, size: compact ? 11 : 13, color: color),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: compact ? 11 : 12,
                fontWeight: material.FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}