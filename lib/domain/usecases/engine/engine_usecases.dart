import '../../entities/sleep_session.dart';
import '../../repositories/repositories.dart';
import '../../../services/background/trigger_scheduler.dart';

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
