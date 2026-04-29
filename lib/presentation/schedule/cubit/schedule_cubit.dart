import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/sleep_schedule.dart';
import '../../../domain/entities/sleep_session.dart';
import '../../../domain/usecases/schedule/schedule_usecases.dart';
import '../../../domain/usecases/engine/engine_usecases.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final GetSleepScheduleUseCase _get;
  final SaveSleepScheduleUseCase _save;
  final DeleteSleepScheduleUseCase _delete;
  final CalculateRemTriggerUseCase _calculate;
  final ActivateTriggerUseCase _activate;
  final CancelTriggerUseCase _cancelTrigger;
  final GetTodaySessionUseCase _getTodaySession;
  final SaveDebriefUseCase _saveDebrief;

  StreamSubscription<SleepSchedule?>? _sub;

  ScheduleCubit({
    required GetSleepScheduleUseCase get,
    required SaveSleepScheduleUseCase save,
    required DeleteSleepScheduleUseCase delete,
    required CalculateRemTriggerUseCase calculate,
    required ActivateTriggerUseCase activate,
    required CancelTriggerUseCase cancelTrigger,
    required GetTodaySessionUseCase getTodaySession,
    required SaveDebriefUseCase saveDebrief,
  })  : _get = get,
        _save = save,
        _delete = delete,
        _calculate = calculate,
        _activate = activate,
        _cancelTrigger = cancelTrigger,
        _getTodaySession = getTodaySession,
        _saveDebrief = saveDebrief,
        super(const ScheduleLoading());

  void init() {
    _sub = _get().listen(
      (schedule) async {
        if (schedule == null) {
          emit(const ScheduleEmpty());
          return;
        }
        await _emitLoaded(schedule);
      },
      onError: (e) => emit(ScheduleError(e.toString())),
    );
  }

  // ── Создание ──────────────────────────────────────────────────────────────

  Future<SleepSchedule> createDefault() async {
    final schedule = SleepSchedule(
      id: const Uuid().v4(),
      bedTime: const TimeOfDay(hour: 23, minute: 0),
      wakeTime: const TimeOfDay(hour: 7, minute: 0),
      activeDays: const [1, 2, 3, 4, 5],
    );
    await _save(schedule);
    return schedule;
  }

  // ── Редактирование ────────────────────────────────────────────────────────

  Future<void> updateBedTime(TimeOfDay time) =>
      _update((s) => _rebuild(s, bedTime: time));

  Future<void> updateWakeTime(TimeOfDay time) =>
      _update((s) => _rebuild(s, wakeTime: time));

  Future<void> updateTargetCycle(RemCycle cycle) =>
      _update((s) => _rebuild(s, targetCycle: cycle));

  Future<void> toggleDay(int weekday) => _update((s) {
        final days = List<int>.from(s.activeDays);
        days.contains(weekday) ? days.remove(weekday) : days.add(weekday);
        return _rebuild(s, activeDays: days..sort());
      });

  Future<void> toggleActive() =>
      _update((s) => _rebuild(s, isActive: !s.isActive));

  Future<void> toggleWbtb() =>
      _update((s) => _rebuild(s, wbtbMode: !s.wbtbMode));

  Future<void> updateWbtbMins(int mins) =>
      _update((s) => _rebuild(s, wbtbAwakeMins: mins));

  Future<void> deleteSchedule() async {
    await _cancelTrigger();
    await _delete();
    emit(const ScheduleEmpty());
  }

  // ── Триггер ───────────────────────────────────────────────────────────────

  Future<void> activateTrigger() async {
    final s = state;
    if (s is! ScheduleLoaded) return;

    emit(s.copyWith(triggerStatus: TriggerStatus.activating));

    final result = await _activate();

    if (result.isSuccess) {
      emit(s.copyWith(
        triggerStatus: TriggerStatus.active,
        scheduledTriggerAt: result.triggerAt,
      ));
    } else {
      emit(s.copyWith(triggerStatus: TriggerStatus.idle));
    }
  }

  Future<void> cancelTrigger() async {
    final s = state;
    if (s is! ScheduleLoaded) return;

    emit(s.copyWith(triggerStatus: TriggerStatus.cancelling));
    await _cancelTrigger();
    emit(s.copyWith(
      triggerStatus: TriggerStatus.idle,
      clearScheduled: true,
    ));
  }

  // ── Дебриф ────────────────────────────────────────────────────────────────

  Future<void> saveDebrief({
    required String sessionId,
    required LucidityLevel lucidity,
    String? notes,
  }) async {
    final s = state;
    if (s is! ScheduleLoaded) return;

    final session = s.todaySession;
    if (session == null) return;

    final updated = SleepSession(
      id: session.id,
      date: session.date,
      triggeredAt: session.triggeredAt,
      affirmationsPlayedCount: session.affirmationsPlayedCount,
      triggersPlayedCount: session.triggersPlayedCount,
      totalPlaybackDuration: session.totalPlaybackDuration,
      lucidityLevel: lucidity,
      notes: notes,
    );

    await _saveDebrief(updated);
    emit(s.copyWith(todaySession: updated));
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<void> _update(SleepSchedule Function(SleepSchedule) transform) async {
    final s = state;
    if (s is! ScheduleLoaded) return;
    final updated = transform(s.schedule);
    await _save(updated);
  }

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

  Future<void> _emitLoaded(SleepSchedule schedule) async {
    final windows = _calculate.allWindows(schedule);
    final trigger = _calculate(schedule);
    final todaySession = await _getTodaySession();

    final current = state;
    final prevStatus = current is ScheduleLoaded
        ? current.triggerStatus
        : TriggerStatus.idle;
    final prevScheduled = current is ScheduleLoaded
        ? current.scheduledTriggerAt
        : null;

    emit(ScheduleLoaded(
      schedule: schedule,
      remWindows: windows,
      triggerAt: trigger,
      triggerStatus: prevStatus,
      scheduledTriggerAt: prevScheduled,
      todaySession: todaySession,
    ));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
