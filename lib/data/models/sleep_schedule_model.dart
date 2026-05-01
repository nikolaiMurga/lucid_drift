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
  late int playbackModeIndex;
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
        playbackMode: SchedulePlaybackMode.values[playbackModeIndex.clamp(0, SchedulePlaybackMode.values.length - 1)],
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
        ..playbackModeIndex = s.playbackMode.index
        ..isActive = s.isActive
        ..activeDays = s.activeDays
        ..wbtbMode = s.wbtbMode
        ..wbtbAwakeMins = s.wbtbAwakeMins;
}
