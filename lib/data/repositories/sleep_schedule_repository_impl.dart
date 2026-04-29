import 'package:isar/isar.dart';
import '../../domain/entities/sleep_schedule.dart';
import '../../domain/repositories/repositories.dart';
import '../models/sleep_schedule_model.dart';

class SleepScheduleRepositoryImpl implements SleepScheduleRepository {
  final Isar _isar;
  const SleepScheduleRepositoryImpl(this._isar);

  static const _isarId = 1; // синглтон

  @override
  Future<SleepSchedule?> get() async {
    final model = await _isar.sleepScheduleModels.get(_isarId);
    return model?.toDomain();
  }

  @override
  Future<void> save(SleepSchedule schedule) async {
    await _isar.writeTxn(() async {
      await _isar.sleepScheduleModels.put(
        SleepScheduleModel.fromDomain(schedule),
      );
    });
  }

  @override
  Future<void> delete() async {
    await _isar.writeTxn(() async {
      await _isar.sleepScheduleModels.delete(_isarId);
    });
  }

  @override
  Stream<SleepSchedule?> watch() {
    return _isar.sleepScheduleModels
        .watchObject(_isarId, fireImmediately: true)
        .map((model) => model?.toDomain());
  }
}
