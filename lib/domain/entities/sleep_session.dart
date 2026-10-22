import 'package:equatable/equatable.dart';

enum LucidityLevel {
  none,       // обычный сон
  partial,    // помню сон, не осознавал
  lucid,      // полностью осознанный сон
}

class SleepSession extends Equatable {
  final String id;
  final DateTime date;
  final DateTime? triggeredAt;         // когда сработал триггер
  final int affirmationsPlayedCount;
  final int triggersPlayedCount;
  final Duration totalPlaybackDuration;
  final LucidityLevel lucidityLevel;
  final String? notes;

  const SleepSession({
    required this.id,
    required this.date,
    required this.lucidityLevel,
    this.triggeredAt,
    this.affirmationsPlayedCount = 0,
    this.triggersPlayedCount = 0,
    this.totalPlaybackDuration = Duration.zero,
    this.notes,
  });

  bool get wasTriggered => triggeredAt != null;

  @override
  List<Object?> get props => [id, date, triggeredAt, lucidityLevel];
}
