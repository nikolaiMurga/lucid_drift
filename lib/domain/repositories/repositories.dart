import '../entities/night_playlist.dart';
import '../entities/sleep_schedule.dart';
import '../entities/sleep_session.dart';

abstract interface class PlaylistRepository {
  Future<NightPlaylist?> getActive();
  Future<List<NightPlaylist>> getAll();
  Future<void> save(NightPlaylist playlist);
  Future<void> setActive(String id);
  Future<void> delete(String id);
  Stream<NightPlaylist?> watchActive();
}

abstract interface class SleepScheduleRepository {
  Future<SleepSchedule?> get();
  Future<void> save(SleepSchedule schedule);
  Future<void> delete();
  Stream<SleepSchedule?> watch();
}

abstract interface class SleepSessionRepository {
  Future<List<SleepSession>> getAll();
  Future<SleepSession?> getByDate(DateTime date);
  Future<void> save(SleepSession session);
  Stream<List<SleepSession>> watchAll();
}
