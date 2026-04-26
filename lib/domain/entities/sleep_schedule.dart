import 'package:equatable/equatable.dart';

enum RemCycle {
  second,  // ~3ч после засыпания
  third,   // ~4.5ч
  fourth,  // ~6ч  — оптимально (самый длинный REM)
  fifth,   // ~7.5ч
}

class SleepSchedule extends Equatable {
  final String id;
  final TimeOfDay bedTime;
  final TimeOfDay wakeTime;
  final RemCycle targetCycle;
  final bool isActive;
  final List<int> activeDays; // 1=пн, 7=вс
  final bool wbtbMode;        // Wake Back To Bed
  final int wbtbAwakeMins;    // сколько бодрствовать при WBTB

  const SleepSchedule({
    required this.id,
    required this.bedTime,
    required this.wakeTime,
    required this.activeDays,
    this.targetCycle = RemCycle.fourth,
    this.isActive = true,
    this.wbtbMode = false,
    this.wbtbAwakeMins = 30,
  });

  /// Рассчитывает DateTime триггера для заданной даты
  DateTime triggerDateTime(DateTime sleepDate) {
    final cycleMinutes = switch (targetCycle) {
      RemCycle.second => 180,
      RemCycle.third  => 270,
      RemCycle.fourth => 360,
      RemCycle.fifth  => 450,
    };

    return DateTime(
      sleepDate.year,
      sleepDate.month,
      sleepDate.day,
      bedTime.hour,
      bedTime.minute,
    ).add(Duration(minutes: cycleMinutes - 10)); // запуск чуть раньше REM
  }

  bool get isActiveToday {
    final weekday = DateTime.now().weekday;
    return isActive && activeDays.contains(weekday);
  }

  @override
  List<Object?> get props => [id, bedTime, wakeTime, targetCycle, isActive, activeDays, wbtbMode];
}

// Простой value object чтобы не тащить material в domain
class TimeOfDay extends Equatable {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  String format() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  List<Object?> get props => [hour, minute];
}
