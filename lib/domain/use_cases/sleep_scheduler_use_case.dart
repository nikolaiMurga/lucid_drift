import '../models/sleep_schedule_model.dart';

class SleepSchedulerUseCase {
  List<DateTime> calculateRemWindows(DateTime bedTime, DateTime wakeUpTime) {
    List<DateTime> remWindows = [];
    DateTime currentRem = bedTime.add(const Duration(hours: 4, minutes: 30)); // First strong REM

    while (currentRem.isBefore(wakeUpTime)) {
      remWindows.add(currentRem);
      currentRem = currentRem.add(const Duration(minutes: 90));
    }

    return remWindows;
  }

  SleepScheduleModel createSleepSchedule(DateTime bedTime, DateTime wakeUpTime) {
    final remWindows = calculateRemWindows(bedTime, wakeUpTime);
    return SleepScheduleModel(
      bedTime: bedTime,
      wakeUpTime: wakeUpTime,
      calculatedRemWindows: remWindows,
      isRemTrackingEnabled: true,
    );
  }
}
