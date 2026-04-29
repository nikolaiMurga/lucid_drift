import 'package:equatable/equatable.dart';
import '../../../domain/entities/sleep_schedule.dart';
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
  final bool isSaving;

  const ScheduleLoaded({
    required this.schedule,
    required this.remWindows,
    required this.triggerAt,
    this.isSaving = false,
  });

  ScheduleLoaded copyWith({bool? isSaving}) => ScheduleLoaded(
        schedule: schedule,
        remWindows: remWindows,
        triggerAt: triggerAt,
        isSaving: isSaving ?? this.isSaving,
      );

  @override
  List<Object?> get props => [schedule, remWindows, triggerAt, isSaving];
}

class ScheduleError extends ScheduleState {
  final String message;
  const ScheduleError(this.message);
  @override
  List<Object?> get props => [message];
}
