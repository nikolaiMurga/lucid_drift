import '../../entities/sleep_schedule.dart';
import '../../entities/sleep_session.dart';
import '../../repositories/repositories.dart';
import '../../../services/background/trigger_scheduler.dart';
import '../schedule/schedule_usecases.dart';

/// Активирует триггер на эту ночь
class ActivateTriggerUseCase {
  final SleepScheduleRepository _scheduleRepo;
  final CalculateRemTriggerUseCase _calculate;

  const ActivateTriggerUseCase(this._scheduleRepo, this._calculate);

  Future<ActivationResult> call() async {
    final schedule = await _scheduleRepo.get();
    if (schedule == null) {
      return ActivationResult.noSchedule;
    }
    if (!schedule.isActive) {
      return ActivationResult.scheduleDisabled;
    }

    final triggerAt = _calculate(schedule);
    final wakeTime = DateTime.now().copyWith(
      hour: schedule.wakeTime.hour,
      minute: schedule.wakeTime.minute,
      second: 0,
      millisecond: 0,
    );

    // Если триггер уже прошёл — рассчитываем на следующий день
    final effectiveTrigger = triggerAt.isBefore(DateTime.now())
        ? triggerAt.add(const Duration(days: 1))
        : triggerAt;

    await TriggerScheduler.schedule(
      triggerAt: effectiveTrigger,
      wakeTime: wakeTime.isBefore(DateTime.now())
          ? wakeTime.add(const Duration(days: 1))
          : wakeTime,
    );

    return ActivationResult.success(effectiveTrigger);
  }
}

enum _ActivationStatus { success, noSchedule, scheduleDisabled }

class ActivationResult {
  final _ActivationStatus _status;
  final DateTime? triggerAt;

  const ActivationResult._({required _ActivationStatus status, this.triggerAt})
      : _status = status;

  static const noSchedule =
      ActivationResult._(status: _ActivationStatus.noSchedule);
  static const scheduleDisabled =
      ActivationResult._(status: _ActivationStatus.scheduleDisabled);
  static ActivationResult success(DateTime at) =>
      ActivationResult._(status: _ActivationStatus.success, triggerAt: at);

  bool get isSuccess => _status == _ActivationStatus.success;
  bool get isNoSchedule => _status == _ActivationStatus.noSchedule;
  bool get isDisabled => _status == _ActivationStatus.scheduleDisabled;
}

/// Отменяет запланированный триггер
class CancelTriggerUseCase {
  const CancelTriggerUseCase();
  Future<void> call() => TriggerScheduler.cancel();
}

/// Сохраняет оценку сна пользователем (утром)
class SaveDebriefUseCase {
  final SleepSessionRepository _repo;
  const SaveDebriefUseCase(this._repo);

  Future<void> call(SleepSession session) => _repo.save(session);
}

/// Получает сессию за сегодня (для утреннего дебрифа)
class GetTodaySessionUseCase {
  final SleepSessionRepository _repo;
  const GetTodaySessionUseCase(this._repo);

  Future<SleepSession?> call() => _repo.getByDate(DateTime.now());
}

/// Следит за всеми сессиями (история)
class WatchSessionsUseCase {
  final SleepSessionRepository _repo;
  const WatchSessionsUseCase(this._repo);

  Stream<List<SleepSession>> call() => _repo.watchAll();
}
