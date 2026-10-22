import 'package:equatable/equatable.dart';

enum PlaybackMode {
  affirmationsFirst,  // аффирмации → триггеры
  triggersFirst,      // триггеры → аффирмации
  interleaved,        // перемежать
}

class PlaylistEntry extends Equatable {
  final String contentItemId;
  final int order;

  const PlaylistEntry({
    required this.contentItemId,
    required this.order,
  });

  @override
  List<Object?> get props => [contentItemId, order];
}

class NightPlaylist extends Equatable {
  final String id;
  final String name;
  final List<PlaylistEntry> entries;
  final PlaybackMode playbackMode;
  final int pauseBetweenSeconds;   // пауза между дорожками
  final double affirmationVolume;  // 0.0–1.0
  final double triggerVolume;      // чуть выше для чёткости
  final bool loop;
  final DateTime updatedAt;

  const NightPlaylist({
    required this.id,
    required this.name,
    required this.entries,
    required this.updatedAt,
    this.playbackMode = PlaybackMode.affirmationsFirst,
    this.pauseBetweenSeconds = 10,
    this.affirmationVolume = 0.3,
    this.triggerVolume = 0.45,
    this.loop = false,
  });

  NightPlaylist copyWith({
    String? name,
    List<PlaylistEntry>? entries,
    PlaybackMode? playbackMode,
    int? pauseBetweenSeconds,
    double? affirmationVolume,
    double? triggerVolume,
    bool? loop,
  }) {
    return NightPlaylist(
      id: id,
      name: name ?? this.name,
      entries: entries ?? this.entries,
      playbackMode: playbackMode ?? this.playbackMode,
      pauseBetweenSeconds: pauseBetweenSeconds ?? this.pauseBetweenSeconds,
      affirmationVolume: affirmationVolume ?? this.affirmationVolume,
      triggerVolume: triggerVolume ?? this.triggerVolume,
      loop: loop ?? this.loop,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, entries, playbackMode, pauseBetweenSeconds];
}
