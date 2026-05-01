import 'dart:async';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/sleep_schedule.dart';
import '../../../domain/entities/sleep_session.dart';
import '../../../domain/usecases/schedule/schedule_usecases.dart';
import '../../../domain/usecases/engine/engine_usecases.dart';
import '../../../services/background/rem_trigger_service.dart';
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
  final WatchSessionsUseCase _watchSessions;

  StreamSubscription<SleepSchedule?>? _scheduleSub;
  StreamSubscription<List<SleepSession>>? _sessionSub;

  ScheduleCubit({
    required GetSleepScheduleUseCase get,
    required SaveSleepScheduleUseCase save,
    required DeleteSleepScheduleUseCase delete,
    required CalculateRemTriggerUseCase calculate,
    required ActivateTriggerUseCase activate,
    required CancelTriggerUseCase cancelTrigger,
    required GetTodaySessionUseCase getTodaySession,
    required SaveDebriefUseCase saveDebrief,
    required WatchSessionsUseCase watchSessions,
  })  : _get = get,
        _save = save,
        _delete = delete,
        _calculate = calculate,
        _activate = activate,
        _cancelTrigger = cancelTrigger,
        _getTodaySession = getTodaySession,
        _saveDebrief = saveDebrief,
        _watchSessions = watchSessions,
        super(const ScheduleLoading());

  void init() {
    _scheduleSub = _get().listen(
      (schedule) async {
        if (schedule == null) {
          emit(const ScheduleEmpty());
          return;
        }
        await _emitLoaded(schedule);
      },
      onError: (e) => emit(ScheduleError(e.toString())),
    );

    // Синхронизируем состояние REM-движка при старте приложения
    _syncServiceStateOnStart();

    // Обновляем UI когда сервис сохраняет сессию в другом изоляте
    _sessionSub = _watchSessions().listen((sessions) {
      final s = state;
      if (s is! ScheduleLoaded) return;

      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      final today = sessions
          .where((sess) =>
              !sess.date.isBefore(todayStart) && sess.date.isBefore(todayEnd))
          .firstOrNull;

      if (today == s.todaySession) return;

      final newStatus = (today?.wasTriggered == true)
          ? TriggerStatus.idle
          : s.triggerStatus;

      if (!isClosed) {
        emit(s.copyWith(
          todaySession: today,
          triggerStatus: newStatus,
          clearScheduled: today?.wasTriggered == true,
        ));
      }
    });
  }

  /// Проверяем состояние сервиса при старте: если расписание активно
  /// и сервис не запущен — запускаем. Если расписание выключено — останавливаем.
  Future<void> _syncServiceStateOnStart() async {
    final schedule = await _get().first;
    if (schedule == null) return;

    final isRunning = await RemTriggerService.isRunning();

    if (schedule.isActive && !isRunning) {
      debugPrint('[ScheduleCubit] Start-up sync: запуск REM Engine.');
      await RemTriggerService.start();
    } else if (!schedule.isActive && isRunning) {
      debugPrint('[ScheduleCubit] Start-up sync: остановка REM Engine.');
      RemTriggerService.stop();
    }
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

  /// Добавляет или убирает цикл из списка целевых (минимум 1 всегда остаётся).
  Future<void> toggleTargetCycle(SleepCycle cycle) => _update((s) {
        final cycles = List<SleepCycle>.from(s.targetCycles);
        if (cycles.contains(cycle)) {
          if (cycles.length > 1) cycles.remove(cycle);
        } else {
          cycles.add(cycle);
          cycles.sort((a, b) => a.index.compareTo(b.index));
        }
        return _rebuild(s, targetCycles: cycles);
      });

  /// Обновляет режим воспроизведения (вся фаза / середина ×3).
  Future<void> updatePlaybackMode(SchedulePlaybackMode mode) =>
      _update((s) => _rebuild(s, playbackMode: mode));

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

    try {
      final result = await _activate();

      if (result.isSuccess) {
        final triggerAt = result.triggerAt!;
        debugPrint('[ScheduleCubit] Триггер активирован на $triggerAt');
        if (!isClosed) {
          emit(s.copyWith(
            triggerStatus: TriggerStatus.active,
            scheduledTriggerAt: triggerAt,
          ));
        }
      } else {
        if (!isClosed) emit(s.copyWith(triggerStatus: TriggerStatus.idle));
      }
    } catch (e) {
      debugPrint('[ScheduleCubit] activateTrigger error: $e');
      if (!isClosed) emit(s.copyWith(triggerStatus: TriggerStatus.idle));
    }
  }

  /// Немедленно запускает триггер для тестирования (минуя проверку расписания).
  Future<void> testTriggerNow() async {
    final isRunning = await RemTriggerService.isRunning();
    if (!isRunning) await RemTriggerService.start();
    // Небольшая пауза чтобы изолят успел инициализировать Isar
    await Future.delayed(const Duration(seconds: 2));
    RemTriggerService.testTrigger();
    debugPrint('[ScheduleCubit] testTriggerNow вызван.');
  }

  Future<void> cancelTrigger() async {
    final s = state;
    if (s is! ScheduleLoaded) return;

    emit(s.copyWith(triggerStatus: TriggerStatus.cancelling));
    await _cancelTrigger();
    if (!isClosed) {
      emit(s.copyWith(
        triggerStatus: TriggerStatus.idle,
        clearScheduled: true,
      ));
    }
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
    if (!isClosed) emit(s.copyWith(todaySession: updated));
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<void> _update(SleepSchedule Function(SleepSchedule) transform) async {
    final s = state;
    if (s is! ScheduleLoaded) return;
    final updated = transform(s.schedule);
    await _save(updated);

    // Синхронизируем сервис при изменении isActive
    final wasActive = s.schedule.isActive;
    final nowActive = updated.isActive;
    if (wasActive != nowActive) {
      if (nowActive) {
        debugPrint('[ScheduleCubit] isActive → true: запуск REM Engine.');
        await RemTriggerService.start();
      } else {
        debugPrint('[ScheduleCubit] isActive → false: остановка REM Engine.');
        RemTriggerService.stop();
      }
    }
  }

  SleepSchedule _rebuild(
    SleepSchedule s, {
    TimeOfDay? bedTime,
    TimeOfDay? wakeTime,
    List<SleepCycle>? targetCycles,
    SchedulePlaybackMode? playbackMode,
    bool? isActive,
    List<int>? activeDays,
    bool? wbtbMode,
    int? wbtbAwakeMins,
  }) =>
      SleepSchedule(
        id: s.id,
        bedTime: bedTime ?? s.bedTime,
        wakeTime: wakeTime ?? s.wakeTime,
        targetCycles: targetCycles ?? s.targetCycles,
        playbackMode: playbackMode ?? s.playbackMode,
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
    final prevScheduled =
        current is ScheduleLoaded ? current.scheduledTriggerAt : null;

    if (!isClosed) {
      emit(ScheduleLoaded(
        schedule: schedule,
        remWindows: windows,
        triggerAt: trigger,
        triggerStatus: prevStatus,
        scheduledTriggerAt: prevScheduled,
        todaySession: todaySession,
      ));
    }
  }

  @override
  Future<void> close() {
    _scheduleSub?.cancel();
    _sessionSub?.cancel();
    return super.close();
  }
}
