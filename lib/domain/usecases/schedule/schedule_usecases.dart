import '../../entities/sleep_schedule.dart';
import '../../repositories/repositories.dart';

class CalculateRemTriggerUseCase {
  const CalculateRemTriggerUseCase();

  /// Возвращает DateTime когда нужно запустить плейлист
  DateTime call(SleepSchedule schedule, {DateTime? forDate}) {
    return schedule.triggerDateTime(forDate ?? DateTime.now());
  }

  /// Возвращает описание всех REM-окон для визуального таймлайна
  List<RemWindow> allWindows(SleepSchedule schedule, {DateTime? forDate}) {
    final date = forDate ?? DateTime.now();
    final bedDateTime = DateTime(
      date.year, date.month, date.day,
      schedule.bedTime.hour, schedule.bedTime.minute,
    );

    return List.generate(5, (i) {
      final cycle = i + 1;
      final start = bedDateTime.add(Duration(minutes: 90 * cycle - 20));
      final end = bedDateTime.add(Duration(minutes: 90 * cycle + 20));
      return RemWindow(cycle: cycle, start: start, end: end);
    });
  }
}

class RemWindow {
  final int cycle;
  final DateTime start;
  final DateTime end;
  const RemWindow({required this.cycle, required this.start, required this.end});
}

class SaveSleepScheduleUseCase {
  final SleepScheduleRepository _repo;
  const SaveSleepScheduleUseCase(this._repo);

  Future<void> call(SleepSchedule schedule) => _repo.save(schedule);
}

class GetSleepScheduleUseCase {
  final SleepScheduleRepository _repo;
  const GetSleepScheduleUseCase(this._repo);

  Stream<SleepSchedule?> call() => _repo.watch();
}
