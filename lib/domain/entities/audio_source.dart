import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_source.freezed.dart';
part 'audio_source.g.dart';

@freezed
sealed class AudioSource with _$AudioSource {
  /// Записан пользователем через микрофон
  const factory AudioSource.ownRecording({
    required String localPath, // абсолютный путь к m4a
  }) = OwnRecording;

  /// Будет добавлено в Этапе 2 (AI TTS)
  // const factory AudioSource.aiGenerated({...}) = AiGenerated;

  factory AudioSource.fromJson(Map<String, dynamic> json) =>
      _$AudioSourceFromJson(json);
}
