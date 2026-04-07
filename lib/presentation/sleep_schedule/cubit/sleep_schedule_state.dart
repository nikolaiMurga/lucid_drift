import 'package:equatable/equatable.dart';
import '../../../domain/models/sleep_schedule_model.dart';

abstract class SleepScheduleState extends Equatable {
  const SleepScheduleState();

  @override
  List<Object?> get props => [];
}

class SleepScheduleInitial extends SleepScheduleState {}

class SleepScheduleUpdated extends SleepScheduleState {
  final SleepScheduleModel schedule;

  const SleepScheduleUpdated(this.schedule);

  @override
  List<Object?> get props => [schedule];
}
