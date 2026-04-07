import 'package:equatable/equatable.dart';

enum ContentType { affirmation, trigger }

enum AudioSourceType { ownRecording, aiGenerated }

class ContentItemModel extends Equatable {
  final String id;
  final String text;
  final ContentType type;
  final AudioSourceType sourceType;
  final String audioPath;
  final DateTime createdAt;

  const ContentItemModel({
    required this.id,
    required this.text,
    required this.type,
    required this.sourceType,
    required this.audioPath,
    required this.createdAt,
  });

  factory ContentItemModel.fromJson(Map<String, dynamic> json) {
    return ContentItemModel(
      id: json['id'] as String,
      text: json['text'] as String,
      type: ContentType.values.firstWhere((e) => e.name == json['type']),
      sourceType: AudioSourceType.values.firstWhere((e) => e.name == json['sourceType']),
      audioPath: json['audioPath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.name,
      'sourceType': sourceType.name,
      'audioPath': audioPath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, text, type, sourceType, audioPath, createdAt];
}
