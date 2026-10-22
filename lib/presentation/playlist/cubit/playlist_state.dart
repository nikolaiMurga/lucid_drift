import 'package:equatable/equatable.dart';
import '../../../domain/entities/night_playlist.dart';
import '../../../domain/entities/content_item.dart';

sealed class PlaylistState extends Equatable {
  const PlaylistState();
  @override
  List<Object?> get props => [];
}

class PlaylistLoading extends PlaylistState {
  const PlaylistLoading();
}

class PlaylistLoaded extends PlaylistState {
  final NightPlaylist playlist;

  /// ContentItem-ы в порядке entries — для отображения
  final List<ContentItem> resolvedItems;

  /// id трека который сейчас играет (preview)
  final String? playingItemId;

  const PlaylistLoaded({
    required this.playlist,
    required this.resolvedItems,
    this.playingItemId,
  });

  bool isInPlaylist(String contentItemId) =>
      playlist.entries.any((e) => e.contentItemId == contentItemId);

  @override
  List<Object?> get props => [playlist, resolvedItems, playingItemId];
}

class PlaylistError extends PlaylistState {
  final String message;
  const PlaylistError(this.message);
  @override
  List<Object?> get props => [message];
}
