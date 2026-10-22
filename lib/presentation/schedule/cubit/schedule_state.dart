import 'package:equatable/equatable.dart';
import '../../../domain/entities/sleep_schedule.dart';
import '../../../domain/entities/sleep_session.dart';
import '../../../domain/usecases/schedule/schedule_usecases.dart';

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
  final SleepSession? todaySession;
  final bool showDebrief; // true только если пользователь тапнул уведомление

  const ScheduleLoaded({
    required this.schedule,
    required this.remWindows,
    required this.triggerAt,
    this.todaySession,
    this.showDebrief = false,
  });

  ScheduleLoaded copyWith({
    SleepSession? todaySession,
    bool? showDebrief,
  }) =>
      ScheduleLoaded(
        schedule: schedule,
        remWindows: remWindows,
        triggerAt: triggerAt,
        todaySession: todaySession ?? this.todaySession,
        showDebrief: showDebrief ?? this.showDebrief,
      );

  @override
  List<Object?> get props => [schedule, remWindows, triggerAt, todaySession, showDebrief];
}

class ScheduleError extends ScheduleState {
  final String message;
  const ScheduleError(this.message);
  @override
  List<Object?> get props => [message];
}
