import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../../domain/models/content_item_model.dart';
import '../../../domain/models/sleep_schedule_model.dart';
import 'night_session_state.dart';

class NightSessionCubit extends Cubit<NightSessionState> {
  final AudioPlayer _player = AudioPlayer();
  Timer? _timer;

  NightSessionCubit() : super(NightSessionInitial());

  void startSession(List<ContentItemModel> playlist, SleepScheduleModel schedule) {
    if (schedule.calculatedRemWindows.isEmpty) return;

    final nextRem = schedule.calculatedRemWindows.first;
    emit(NightSessionActive(playlist: playlist, isPlaying: false, nextRemWindow: nextRem));

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      final now = DateTime.now();
      if (now.isAfter(nextRem)) {
        _playTracks(playlist);
        // Find next REM window after current one
        final next = schedule.calculatedRemWindows.firstWhere(
          (w) => w.isAfter(now),
          orElse: () => DateTime.now().add(const Duration(hours: 10)),
        );
        emit(NightSessionActive(playlist: playlist, isPlaying: true, nextRemWindow: next));
      }
    });
  }

  Future<void> _playTracks(List<ContentItemModel> playlist) async {
    final affirmations = playlist.where((i) => i.type == ContentType.affirmation).toList();
    final triggers = playlist.where((i) => i.type == ContentType.trigger).toList();

    // Play affirmations first
    for (final item in affirmations) {
      await _player.setFilePath(item.audioPath);
      await _player.play();
      await _player.playerStateStream.firstWhere((s) => s.processingState == ProcessingState.completed);
    }

    // Then play a few triggers
    for (final item in triggers.take(3)) {
      await _player.setFilePath(item.audioPath);
      await _player.play();
      await _player.playerStateStream.firstWhere((s) => s.processingState == ProcessingState.completed);
    }
  }

  void stopSession() {
    _timer?.cancel();
    _player.stop();
    emit(NightSessionInitial());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _player.dispose();
    return super.close();
  }
}
