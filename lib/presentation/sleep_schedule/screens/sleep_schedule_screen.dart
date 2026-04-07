import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/sleep_schedule_cubit.dart';
import '../cubit/sleep_schedule_state.dart';

class SleepScheduleScreen extends StatefulWidget {
  const SleepScheduleScreen({super.key});

  @override
  State<SleepScheduleScreen> createState() => _SleepScheduleScreenState();
}

class _SleepScheduleScreenState extends State<SleepScheduleScreen> {
  TimeOfDay _bedTime = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _wakeUpTime = const TimeOfDay(hour: 7, minute: 0);

  DateTime _toDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  void _updateSchedule() {
    context.read<SleepScheduleCubit>().setSchedule(
      _toDateTime(_bedTime),
      _toDateTime(_wakeUpTime),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sleep Schedule',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.only(top: 16)),
          ListTile(
            title: const Text('Bed Time'),
            trailing: Text(_bedTime.format(context)),
            onTap: () async {
              final time = await showTimePicker(context: context, initialTime: _bedTime);
              if (time != null) {
                setState(() => _bedTime = time);
                _updateSchedule();
              }
            },
          ),
          ListTile(
            title: const Text('Wake Up Time'),
            trailing: Text(_wakeUpTime.format(context)),
            onTap: () async {
              final time = await showTimePicker(context: context, initialTime: _wakeUpTime);
              if (time != null) {
                setState(() => _wakeUpTime = time);
                _updateSchedule();
              }
            },
          ),
          const Padding(padding: EdgeInsets.only(top: 24)),
          const Text(
            'Calculated REM Windows',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Padding(padding: EdgeInsets.only(top: 8)),
          Expanded(
            child: BlocBuilder<SleepScheduleCubit, SleepScheduleState>(
              builder: (context, state) {
                if (state is SleepScheduleUpdated) {
                  return ListView.builder(
                    itemCount: state.schedule.calculatedRemWindows.length,
                    itemBuilder: (context, index) {
                      final window = state.schedule.calculatedRemWindows[index];
                      return ListTile(
                        leading: const Icon(Icons.waves, color: Colors.blueAccent),
                        title: Text('REM Window ${index + 1}'),
                        subtitle: Text(DateFormat('HH:mm').format(window)),
                      );
                    },
                  );
                }
                return const Center(child: Text('Set your sleep times to see REM windows'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
