import 'package:isar/isar.dart';
import '../../domain/entities/sleep_session.dart';
import '../../domain/repositories/repositories.dart';
import '../models/sleep_session_model.dart';

class SleepSessionRepositoryImpl implements SleepSessionRepository {
  final Isar _isar;
  const SleepSessionRepositoryImpl(this._isar);

  @override
  Future<List<SleepSession>> getAll() async {
    final models = await _isar.sleepSessionModels
        .where()
        .sortByDateDesc()
        .findAll();
    return models.map((m) => m.toDomain()).toList();
  }

  @override
  Future<SleepSession?> getByDate(DateTime date) async {
    // Ищем сессию за этот день (без учёта времени)
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final model = await _isar.sleepSessionModels
        .filter()
        .dateGreaterThan(start, include: true)
        .findFirst();
    if (model == null) return null;
    if (model.date.isBefore(end)) return model.toDomain();
    return null;
  }

  @override
  Future<void> save(SleepSession session) async {
    await _isar.writeTxn(() async {
      await _isar.sleepSessionModels.put(
        SleepSessionModel.fromDomain(session),
      );
    });
  }

  @override
  Stream<List<SleepSession>> watchAll() {
    return _isar.sleepSessionModels
        .where()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toDomain()).toList());
  }
}
