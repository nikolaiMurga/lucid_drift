import 'package:equatable/equatable.dart';

class SleepScheduleModel extends Equatable {
  final DateTime bedTime;
  final DateTime wakeUpTime;
  final bool isRemTrackingEnabled;
  final List<DateTime> calculatedRemWindows;

  const SleepScheduleModel({
    required this.bedTime,
    required this.wakeUpTime,
    this.isRemTrackingEnabled = false,
    this.calculatedRemWindows = const [],
  });

  factory SleepScheduleModel.fromJson(Map<String, dynamic> json) {
    return SleepScheduleModel(
      bedTime: DateTime.parse(json['bedTime'] as String),
      wakeUpTime: DateTime.parse(json['wakeUpTime'] as String),
      isRemTrackingEnabled: json['isRemTrackingEnabled'] as bool,
      calculatedRemWindows: (json['calculatedRemWindows'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bedTime': bedTime.toIso8601String(),
      'wakeUpTime': wakeUpTime.toIso8601String(),
      'isRemTrackingEnabled': isRemTrackingEnabled,
      'calculatedRemWindows':
          calculatedRemWindows.map((e) => e.toIso8601String()).toList(),
    };
  }

  @override
  List<Object?> get props =>
      [bedTime, wakeUpTime, isRemTrackingEnabled, calculatedRemWindows];
}
