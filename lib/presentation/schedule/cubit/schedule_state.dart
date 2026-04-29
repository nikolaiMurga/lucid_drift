import 'package:equatable/equatable.dart';
import '../../../domain/entities/sleep_schedule.dart';
import '../../../domain/entities/sleep_session.dart';
import '../../../domain/usecases/schedule/schedule_usecases.dart';

enum TriggerStatus { idle, activating, active, cancelling }

sealed class ScheduleState extends Equatable {
  const ScheduleState();
  @override
  List<Object?> get props => [];
}

class ScheduleLoading extends ScheduleState {
  const ScheduleLoading();
}

class ScheduleEmpty extends ScheduleState {
  const ScheduleEmpty();
}

class ScheduleLoaded extends ScheduleState {
  final SleepSchedule schedule;
  final List<RemWindow> remWindows;
  final DateTime triggerAt;
  final TriggerStatus triggerStatus;
  final DateTime? scheduledTriggerAt; // когда запланировано (после активации)
  final SleepSession? todaySession;   // сессия за сегодня (для дебрифа)

  const ScheduleLoaded({
    required this.schedule,
    required this.remWindows,
    required this.triggerAt,
    this.triggerStatus = TriggerStatus.idle,
    this.scheduledTriggerAt,
    this.todaySession,
  });

  bool get isActive => triggerStatus == TriggerStatus.active;
  bool get isBusy =>
      triggerStatus == TriggerStatus.activating ||
      triggerStatus == TriggerStatus.cancelling;

  ScheduleLoaded copyWith({
    TriggerStatus? triggerStatus,
    DateTime? scheduledTriggerAt,
    bool clearScheduled = false,
    SleepSession? todaySession,
    bool clearSession = false,
  }) =>
      ScheduleLoaded(
        schedule: schedule,
        remWindows: remWindows,
        triggerAt: triggerAt,
        triggerStatus: triggerStatus ?? this.triggerStatus,
        scheduledTriggerAt: clearScheduled
            ? null
            : (scheduledTriggerAt ?? this.scheduledTriggerAt),
        todaySession:
            clearSession ? null : (todaySession ?? this.todaySession),
      );

  @override
  List<Object?> get props => [
        schedule,
        remWindows,
        triggerAt,
        triggerStatus,
        scheduledTriggerAt,
        todaySession,
      ];
}

class ScheduleError extends ScheduleState {
  final String message;
  const ScheduleError(this.message);
  @override
  List<Object?> get props => [message];
}
