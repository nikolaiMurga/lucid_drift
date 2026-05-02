import 'package:equatable/equatable.dart';

/// Цикл сна: 5 циклов по ~90 мин. Первые три — фаза аффирмаций, 4–5 — триггеры.
enum SleepCycle {
  first,   // ~1.5ч — аффирмации
  second,  // ~3ч   — аффирмации
  third,   // ~4.5ч — аффирмации (граница)
  fourth,  // ~6ч   — триггеры (оптимально)
  fifth,   // ~7.5ч — триггеры
}

extension SleepCycleExt on SleepCycle {
  /// Фаза подходит для аффирмаций (длинный NREM, мозг лучше усваивает)
  bool get isAffirmationPhase => index <= 2;

  /// Фаза подходит для триггеров осознанности (длинный REM, мозг близок к пробуждению)
  bool get isTriggerPhase => index >= 3;

  /// Минут от засыпания до начала REM-окна этого цикла
  int get minutesFromBed => (index + 1) * 90;

  /// Научная длительность REM в этом цикле
  int get remDurationMinutes => switch (this) {
    SleepCycle.first  => 5,
    SleepCycle.second => 10,
    SleepCycle.third  => 20,
    SleepCycle.fourth => 35,
    SleepCycle.fifth  => 45,
  };
}

/// Режим воспроизведения плейлиста во время REM-окна.
enum SchedulePlaybackMode {
  fullPhase,   // вся фаза ±10 мин: тихий фон, подходит для аффирмаций
  midPhase3x,  // середина фазы, 3 прохода: точечный сигнал, подходит для триггеров
}

class SleepSchedule extends Equatable {
  final String id;
  final TimeOfDay bedTime;
  final TimeOfDay wakeTime;
  final List<SleepCycle> targetCycles;
  /// Режим для фаз 1–3 (аффирмации): фон на всё REM-окно.
  final SchedulePlaybackMode affirmationPlaybackMode;
  /// Режим для фаз 4–5 (триггеры): точечный сигнал в пик REM.
  final SchedulePlaybackMode triggerPlaybackMode;
  final bool isActive;
  final List<int> activeDays; // 1=пн, 7=вс
  final bool wbtbMode;        // Wake Back To Bed
  final int wbtbAwakeMins;    // сколько бодрствовать при WBTB

  const SleepSchedule({
    required this.id,
    required this.bedTime,
    required this.wakeTime,
    required this.activeDays,
    this.targetCycles = const [SleepCycle.fourth],
    this.affirmationPlaybackMode = SchedulePlaybackMode.fullPhase,
    this.triggerPlaybackMode = SchedulePlaybackMode.midPhase3x,
    this.isActive = true,
    this.wbtbMode = false,
    this.wbtbAwakeMins = 30,
  });

  /// Возвращает режим воспроизведения для заданного цикла.
  SchedulePlaybackMode modeForCycle(SleepCycle cycle) =>
      cycle.isAffirmationPhase ? affirmationPlaybackMode : triggerPlaybackMode;

  /// Рассчитывает DateTime первого (ближайшего) триггера для заданной даты.
  /// Используется для отображения в UI.
  DateTime triggerDateTime(DateTime sleepDate) {
    final earliest = targetCycles.reduce((a, b) => a.index < b.index ? a : b);
    final offset = switch (modeForCycle(earliest)) {
      SchedulePlaybackMode.fullPhase  => -10,
      SchedulePlaybackMode.midPhase3x => 0,
    };
    return DateTime(
      sleepDate.year,
      sleepDate.month,
      sleepDate.day,
      bedTime.hour,
      bedTime.minute,
    ).add(Duration(minutes: earliest.minutesFromBed + offset));
  }

  /// Возвращает все DateTime триггеров для каждого выбранного цикла.
  /// Каждый цикл использует свой режим (аффирмации vs триггеры).
  List<DateTime> triggerDateTimes(DateTime sleepDate) {
    final bed = DateTime(
      sleepDate.year, sleepDate.month, sleepDate.day,
      bedTime.hour, bedTime.minute,
    );
    return targetCycles.map((c) {
      final offset = switch (modeForCycle(c)) {
        SchedulePlaybackMode.fullPhase  => -10,
        SchedulePlaybackMode.midPhase3x => 0,
      };
      return bed.add(Duration(minutes: c.minutesFromBed + offset));
    }).toList();
  }

  bool get isActiveToday {
    final weekday = DateTime.now().weekday;
    return isActive && activeDays.contains(weekday);
  }

  @override
  List<Object?> get props => [
    id, bedTime, wakeTime, targetCycles,
    affirmationPlaybackMode, triggerPlaybackMode,
    isActive, activeDays, wbtbMode,
  ];
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
