import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/sleep_scheduler_use_case.dart';
import 'sleep_schedule_state.dart';

class SleepScheduleCubit extends Cubit<SleepScheduleState> {
  final SleepSchedulerUseCase _useCase;

  SleepScheduleCubit(this._useCase) : super(SleepScheduleInitial());

  void setSchedule(DateTime bedTime, DateTime wakeUpTime) {
    final schedule = _useCase.createSleepSchedule(bedTime, wakeUpTime);
    emit(SleepScheduleUpdated(schedule));
  }
}
