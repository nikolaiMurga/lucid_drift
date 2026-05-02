import 'package:isar/isar.dart';
import '../../domain/entities/sleep_schedule.dart';

part 'sleep_schedule_model.g.dart';

@collection
class SleepScheduleModel {
  Id get isarId => 1; // синглтон — всегда один объект

  late int bedTimeHour;
  late int bedTimeMinute;
  late int wakeTimeHour;
  late int wakeTimeMinute;
  late List<int> targetCycleIndices;
  /// Индекс SchedulePlaybackMode для аффирмаций (фазы 1–3).
  late int affirmationPlaybackModeIndex;
  /// Индекс SchedulePlaybackMode для триггеров (фазы 4–5). По умолчанию midPhase3x (1).
  late int triggerPlaybackModeIndex;
  late bool isActive;
  late List<int> activeDays;
  late bool wbtbMode;
  late int wbtbAwakeMins;
  late String id;

  /// Преобразует Isar-запись в доменную сущность.
  SleepSchedule toDomain() => SleepSchedule(
        id: id,
        bedTime: TimeOfDay(hour: bedTimeHour, minute: bedTimeMinute),
        wakeTime: TimeOfDay(hour: wakeTimeHour, minute: wakeTimeMinute),
        targetCycles: () {
          final cycles = targetCycleIndices
              .map((i) => SleepCycle.values[i.clamp(0, SleepCycle.values.length - 1)])
              .toList();
          return cycles.isEmpty ? [SleepCycle.fourth] : cycles;
        }(),
        affirmationPlaybackMode: SchedulePlaybackMode.values[affirmationPlaybackModeIndex.clamp(0, SchedulePlaybackMode.values.length - 1)],
        triggerPlaybackMode: SchedulePlaybackMode.values[triggerPlaybackModeIndex.clamp(0, SchedulePlaybackMode.values.length - 1)],
        isActive: isActive,
        activeDays: activeDays,
        wbtbMode: wbtbMode,
        wbtbAwakeMins: wbtbAwakeMins,
      );

  /// Создаёт Isar-запись из доменной сущности.
  static SleepScheduleModel fromDomain(SleepSchedule s) =>
      SleepScheduleModel()
        ..id = s.id
        ..bedTimeHour = s.bedTime.hour
        ..bedTimeMinute = s.bedTime.minute
        ..wakeTimeHour = s.wakeTime.hour
        ..wakeTimeMinute = s.wakeTime.minute
        ..targetCycleIndices = s.targetCycles.map((c) => c.index).toList()
        ..affirmationPlaybackModeIndex = s.affirmationPlaybackMode.index
        ..triggerPlaybackModeIndex = s.triggerPlaybackMode.index
        ..isActive = s.isActive
        ..activeDays = s.activeDays
        ..wbtbMode = s.wbtbMode
        ..wbtbAwakeMins = s.wbtbAwakeMins;
}
