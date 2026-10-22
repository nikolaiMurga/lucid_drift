import 'package:isar/isar.dart';
import '../../domain/entities/sleep_session.dart';

part 'sleep_session_model.g.dart';

enum LucidityLevelEnum { none, partial, lucid }

@collection
class SleepSessionModel {
  Id get isarId => fastHash(id);

  late String id;
  late DateTime date;
  DateTime? triggeredAt;
  late int affirmationsPlayedCount;
  late int triggersPlayedCount;
  late int totalPlaybackMs;

  @enumerated
  late LucidityLevelEnum lucidityLevel;

  String? notes;

  SleepSession toDomain() => SleepSession(
        id: id,
        date: date,
        triggeredAt: triggeredAt,
        affirmationsPlayedCount: affirmationsPlayedCount,
        triggersPlayedCount: triggersPlayedCount,
        totalPlaybackDuration: Duration(milliseconds: totalPlaybackMs),
        lucidityLevel: LucidityLevel.values[lucidityLevel.index],
        notes: notes,
      );

  static SleepSessionModel fromDomain(SleepSession s) =>
      SleepSessionModel()
        ..id = s.id
        ..date = s.date
        ..triggeredAt = s.triggeredAt
        ..affirmationsPlayedCount = s.affirmationsPlayedCount
        ..triggersPlayedCount = s.triggersPlayedCount
        ..totalPlaybackMs = s.totalPlaybackDuration.inMilliseconds
        ..lucidityLevel = LucidityLevelEnum.values[s.lucidityLevel.index]
        ..notes = s.notes;
}

int fastHash(String string) {
  var hash = 0xcbf29ce484222325;
  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }
  return hash;
}
