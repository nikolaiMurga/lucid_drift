import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/sleep_schedule.dart';
import '../../../domain/usecases/schedule/schedule_usecases.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final GetSleepScheduleUseCase _get;
  final SaveSleepScheduleUseCase _save;
  final DeleteSleepScheduleUseCase _delete;
  final CalculateRemTriggerUseCase _calculate;

  StreamSubscription<SleepSchedule?>? _sub;

  ScheduleCubit({
    required GetSleepScheduleUseCase get,
    required SaveSleepScheduleUseCase save,
    required DeleteSleepScheduleUseCase delete,
    required CalculateRemTriggerUseCase calculate,
  })  : _get = get,
        _save = save,
        _delete = delete,
        _calculate = calculate,
        super(const ScheduleLoading());

  void init() {
    _sub = _get().listen(
      (schedule) {
        if (schedule == null) {
          emit(const ScheduleEmpty());
          return;
        }
        _emitLoaded(schedule);
      },
      onError: (e) => emit(ScheduleError(e.toString())),
    );
  }

  /// Создаёт расписание по умолчанию и открывает форму редактирования
  Future<SleepSchedule> createDefault() async {
    final schedule = SleepSchedule(
      id: const Uuid().v4(),
      bedTime: const TimeOfDay(hour: 23, minute: 0),
      wakeTime: const TimeOfDay(hour: 7, minute: 0),
      activeDays: [1, 2, 3, 4, 5], // пн–пт
    );
    await _save(schedule);
    return schedule;
  }

  Future<void> updateBedTime(TimeOfDay time) async {
    final s = state;
    if (s is! ScheduleLoaded) return;
    final updated = _rebuild(s.schedule, bedTime: time);
    await _save(updated);
  }

  Future<void> updateWakeTime(TimeOfDay time) async {
    final s = state;
    if (s is! ScheduleLoaded) return;
    final updated = _rebuild(s.schedule, wakeTime: time);
    await _save(updated);
  }

  Future<void> updateTargetCycle(RemCycle cycle) async {
    final s = state;
    if (s is! ScheduleLoaded) return;
    final updated = _rebuild(s.schedule, targetCycle: cycle);
    await _save(updated);
  }

  Future<void> toggleDay(int weekday) async {
    final s = state;
    if (s is! ScheduleLoaded) return;
    final days = List<int>.from(s.schedule.activeDays);
    days.contains(weekday) ? days.remove(weekday) : days.add(weekday);
    final updated = _rebuild(s.schedule, activeDays: days..sort());
    await _save(updated);
  }

  Future<void> toggleActive() async {
    final s = state;
    if (s is! ScheduleLoaded) return;
    final updated = _rebuild(s.schedule, isActive: !s.schedule.isActive);
    await _save(updated);
  }

  Future<void> toggleWbtb() async {
    final s = state;
    if (s is! ScheduleLoaded) return;
    final updated = _rebuild(s.schedule, wbtbMode: !s.schedule.wbtbMode);
    await _save(updated);
  }

  Future<void> updateWbtbMins(int mins) async {
    final s = state;
    if (s is! ScheduleLoaded) return;
    final updated = _rebuild(s.schedule, wbtbAwakeMins: mins);
    await _save(updated);
  }

  Future<void> deleteSchedule() async {
    await _delete();
    emit(const ScheduleEmpty());
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  SleepSchedule _rebuild(
    SleepSchedule s, {
    TimeOfDay? bedTime,
    TimeOfDay? wakeTime,
    RemCycle? targetCycle,
    bool? isActive,
    List<int>? activeDays,
    bool? wbtbMode,
    int? wbtbAwakeMins,
  }) =>
      SleepSchedule(
        id: s.id,
        bedTime: bedTime ?? s.bedTime,
        wakeTime: wakeTime ?? s.wakeTime,
        targetCycle: targetCycle ?? s.targetCycle,
        isActive: isActive ?? s.isActive,
        activeDays: activeDays ?? s.activeDays,
        wbtbMode: wbtbMode ?? s.wbtbMode,
        wbtbAwakeMins: wbtbAwakeMins ?? s.wbtbAwakeMins,
      );

  void _emitLoaded(SleepSchedule schedule) {
    final windows = _calculate.allWindows(schedule);
    final trigger = _calculate(schedule);
    emit(ScheduleLoaded(
      schedule: schedule,
      remWindows: windows,
      triggerAt: trigger,
    ));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
