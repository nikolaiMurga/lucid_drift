import 'package:equatable/equatable.dart';

sealed class RecorderState extends Equatable {
  const RecorderState();
  @override List<Object?> get props => [];
}

class RecorderIdle extends RecorderState {
  const RecorderIdle();
}

class RecorderReady extends RecorderState {
  // Разрешения получены, готов к записи
  const RecorderReady();
}

class RecorderRecording extends RecorderState {
  final Duration elapsed;
  final double amplitude; // 0.0–1.0 для waveform
  const RecorderRecording({required this.elapsed, required this.amplitude});
  @override List<Object?> get props => [elapsed, amplitude];
}

class RecorderStopped extends RecorderState {
  final String filePath;
  final Duration duration;
  const RecorderStopped({required this.filePath, required this.duration});
  @override List<Object?> get props => [filePath, duration];
}

class RecorderPlaying extends RecorderState {
  final String filePath;
  final Duration position;
  final Duration total;
  const RecorderPlaying({required this.filePath, required this.position, required this.total});

  double get progress => total.inMilliseconds == 0 ? 0 : position.inMilliseconds / total.inMilliseconds;
  @override List<Object?> get props => [filePath, position];
}

class RecorderSaving extends RecorderState {
  const RecorderSaving();
}

class RecorderSaved extends RecorderState {
  final String itemId;
  const RecorderSaved({required this.itemId});
  @override List<Object?> get props => [itemId];
}

class RecorderError extends RecorderState {
  final String message;
  const RecorderError(this.message);
  @override List<Object?> get props => [message];
}
