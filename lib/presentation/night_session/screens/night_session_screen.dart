import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../content/cubit/content_cubit.dart';
import '../../content/cubit/content_state.dart';
import '../../sleep_schedule/cubit/sleep_schedule_cubit.dart';
import '../../sleep_schedule/cubit/sleep_schedule_state.dart';
import '../cubit/night_session_cubit.dart';
import '../cubit/night_session_state.dart';

class NightSessionScreen extends StatelessWidget {
  const NightSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sleep Session',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.only(top: 16)),
          BlocBuilder<NightSessionCubit, NightSessionState>(
            builder: (context, sessionState) {
              if (sessionState is NightSessionActive) {
                return _ActiveSessionView(state: sessionState);
              }
              return _StartSessionView();
            },
          ),
        ],
      ),
    );
  }
}

class _ActiveSessionView extends StatelessWidget {
  final NightSessionActive state;
  const _ActiveSessionView({required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.nightlight_round, size: 64, color: Colors.indigoAccent),
            const Padding(padding: EdgeInsets.only(top: 16)),
            const Text('Night Mode Active', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Padding(padding: EdgeInsets.only(top: 8)),
            Text('Next REM Window: ${DateFormat('HH:mm').format(state.nextRemWindow)}'),
            const Padding(padding: EdgeInsets.only(top: 24)),
            ElevatedButton(
              onPressed: () => context.read<NightSessionCubit>().stopSession(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              child: const Text('Stop Session'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StartSessionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Ready for sleep? Start your session to trigger REM affirmations.'),
        const Padding(padding: EdgeInsets.only(top: 24)),
        ElevatedButton(
          onPressed: () {
            final contentState = context.read<ContentCubit>().state;
            final scheduleState = context.read<SleepScheduleCubit>().state;

            if (contentState is ContentLoaded && scheduleState is SleepScheduleUpdated) {
              if (contentState.items.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please record some tracks first')));
                return;
              }
              context.read<NightSessionCubit>().startSession(contentState.items, scheduleState.schedule);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please set your sleep schedule first')));
            }
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text('Start Night Session', style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }
}
