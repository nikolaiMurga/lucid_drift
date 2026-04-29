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
  late int targetCycleIndex;
  late bool isActive;
  late List<int> activeDays;
  late bool wbtbMode;
  late int wbtbAwakeMins;
  late String id;

  SleepSchedule toDomain() => SleepSchedule(
        id: id,
        bedTime: TimeOfDay(hour: bedTimeHour, minute: bedTimeMinute),
        wakeTime: TimeOfDay(hour: wakeTimeHour, minute: wakeTimeMinute),
        targetCycle: RemCycle.values[targetCycleIndex],
        isActive: isActive,
        activeDays: activeDays,
        wbtbMode: wbtbMode,
        wbtbAwakeMins: wbtbAwakeMins,
      );

  static SleepScheduleModel fromDomain(SleepSchedule s) =>
      SleepScheduleModel()
        ..id = s.id
        ..bedTimeHour = s.bedTime.hour
        ..bedTimeMinute = s.bedTime.minute
        ..wakeTimeHour = s.wakeTime.hour
        ..wakeTimeMinute = s.wakeTime.minute
        ..targetCycleIndex = s.targetCycle.index
        ..isActive = s.isActive
        ..activeDays = s.activeDays
        ..wbtbMode = s.wbtbMode
        ..wbtbAwakeMins = s.wbtbAwakeMins;
}
