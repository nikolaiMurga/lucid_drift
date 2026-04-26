import 'package:equatable/equatable.dart';
import 'audio_source.dart';
import 'content_type.dart';

class ContentItem extends Equatable {
  final String id;
  final String title;
  final String text;
  final ContentType type;
  final AudioSource? audioSource; // null — аудио ещё не записано
  final Duration? audioDuration;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ContentItem({
    required this.id,
    required this.title,
    required this.text,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.audioSource,
    this.audioDuration,
  });

  bool get hasAudio => audioSource != null;

  bool get isAffirmation => type is AffirmationContent;
  bool get isLucidTrigger => type is LucidTriggerContent;

  ContentItem copyWith({
    String? title,
    String? text,
    ContentType? type,
    AudioSource? audioSource,
    Duration? audioDuration,
    DateTime? updatedAt,
  }) {
    return ContentItem(
      id: id,
      title: title ?? this.title,
      text: text ?? this.text,
      type: type ?? this.type,
      audioSource: audioSource ?? this.audioSource,
      audioDuration: audioDuration ?? this.audioDuration,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, title, text, type, audioSource, audioDuration, createdAt];
}
