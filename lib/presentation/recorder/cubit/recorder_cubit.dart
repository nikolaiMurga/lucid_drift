import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart' hide AudioSource;
import 'package:uuid/uuid.dart';
import '../../../domain/entities/content_item.dart';
import '../../../domain/entities/content_type.dart';
import '../../../domain/entities/audio_source.dart';
import '../../../domain/usecases/content/content_usecases.dart';
import '../../../domain/usecases/recorder/recorder_usecases.dart';
import 'recorder_state.dart';

class RecorderCubit extends Cubit<RecorderState> {
  final AudioRecorder _recorder;
  final AudioPlayer _player;
  final SaveContentItemUseCase _saveItem;
  final AttachAudioUseCase _attachAudio;
  final PrepareRecordingPathUseCase _preparePath;
  final DeleteAudioFileUseCase _deleteAudio;

  Timer? _recordingTimer;
  StreamSubscription? _amplitudeSub;
  String? _currentPath;
  Duration _elapsed = Duration.zero;
  double _amplitude = 0.0;

  RecorderCubit({
    required AudioRecorder recorder,
    required AudioPlayer player,
    required SaveContentItemUseCase saveItem,
    required AttachAudioUseCase attachAudio,
    required PrepareRecordingPathUseCase preparePath,
    required DeleteAudioFileUseCase deleteAudio,
  })  : _recorder = recorder,
        _player = player,
        _saveItem = saveItem,
        _attachAudio = attachAudio,
        _preparePath = preparePath,
        _deleteAudio = deleteAudio,
        super(const RecorderIdle());

  Future<void> init() async {
    final hasPermission = await _recorder.hasPermission();
    if (hasPermission) {
      emit(const RecorderReady());
    } else {
      emit(const RecorderError('Нет доступа к микрофону'));
    }
  }

  Future<void> startRecording() async {
    if (state is! RecorderReady && state is! RecorderStopped) return;

    // Если была предыдущая запись — удаляем файл
    if (_currentPath != null) {
      await _deleteAudio(_currentPath!);
      _currentPath = null;
    }

    final path = await _preparePath();
    _currentPath = path;
    _elapsed = Duration.zero;

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000),
      path: path,
    );

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed += const Duration(seconds: 1);
      emit(RecorderRecording(elapsed: _elapsed, amplitude: _amplitude));
    });

    _amplitudeSub = _recorder.onAmplitudeChanged(const Duration(milliseconds: 100)).listen((amp) {
      // amp.current диапазон -160 до 0 дБ, нормализуем
      _amplitude = ((amp.current + 60) / 60).clamp(0.0, 1.0);
    });

    emit(RecorderRecording(elapsed: _elapsed, amplitude: _amplitude));
  }

  Future<void> stopRecording() async {
    if (state is! RecorderRecording) return;

    _recordingTimer?.cancel();
    await _amplitudeSub?.cancel();
    await _recorder.stop();

    if (_currentPath != null) {
      emit(RecorderStopped(filePath: _currentPath!, duration: _elapsed));
    }
  }

  Future<void> playback() async {
    final s = state;
    if (s is! RecorderStopped) return;

    await _player.setFilePath(s.filePath);
    final total = _player.duration ?? Duration.zero;
    await _player.play();

    _player.positionStream.listen((pos) {
      if (state is RecorderPlaying) {
        emit(RecorderPlaying(filePath: s.filePath, position: pos, total: total));
      }
    });

    _player.playerStateStream.listen((ps) {
      if (ps.processingState == ProcessingState.completed) {
        emit(RecorderStopped(filePath: s.filePath, duration: s.duration));
      }
    });

    emit(RecorderPlaying(filePath: s.filePath, position: Duration.zero, total: total));
  }

  Future<void> stopPlayback() async {
    await _player.stop();
    final s = state;
    if (s is RecorderPlaying) {
      emit(RecorderStopped(filePath: s.filePath, duration: s.total));
    }
  }

  /// Сохраняет запись: создаёт ContentItem (если новый) или обновляет аудио существующего
  Future<void> save({
    required String title,
    required String text,
    required ContentType type,
    String? existingItemId,
  }) async {
    final s = state;
    if (s is! RecorderStopped) return;

    emit(const RecorderSaving());

    try {
      final source = AudioSource.ownRecording(localPath: s.filePath);

      if (existingItemId != null) {
        await _attachAudio(
          itemId: existingItemId,
          source: source,
          duration: s.duration,
        );
        emit(RecorderSaved(itemId: existingItemId));
      } else {
        final id = const Uuid().v4();
        final now = DateTime.now();
        final item = ContentItem(
          id: id,
          title: title,
          text: text,
          type: type,
          audioSource: source,
          audioDuration: s.duration,
          createdAt: now,
          updatedAt: now,
        );
        await _saveItem(item);
        emit(RecorderSaved(itemId: id));
      }
    } catch (e) {
      emit(RecorderError(e.toString()));
    }
  }

  void reset() {
    _currentPath = null;
    _elapsed = Duration.zero;
    emit(const RecorderReady());
  }

  @override
  Future<void> close() async {
    _recordingTimer?.cancel();
    await _amplitudeSub?.cancel();
    await _recorder.dispose();
    await _player.dispose();
    return super.close();
  }
}
