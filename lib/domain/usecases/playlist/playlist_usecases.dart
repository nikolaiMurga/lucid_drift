import '../../entities/night_playlist.dart';
import '../../repositories/repositories.dart';

class WatchPlaylistUseCase {
  final PlaylistRepository _repo;
  const WatchPlaylistUseCase(this._repo);

  Stream<NightPlaylist?> call() => _repo.watchActive();
}

class GetPlaylistUseCase {
  final PlaylistRepository _repo;
  const GetPlaylistUseCase(this._repo);

  Future<NightPlaylist?> call() => _repo.getActive();
}

class AddToPlaylistUseCase {
  final PlaylistRepository _repo;
  const AddToPlaylistUseCase(this._repo);

  Future<void> call(String contentItemId) async {
    final playlist = await _repo.getActive();
    if (playlist == null) return;

    // Не добавляем дубликаты
    if (playlist.entries.any((e) => e.contentItemId == contentItemId)) return;

    final nextOrder = playlist.entries.isEmpty
        ? 0
        : playlist.entries.map((e) => e.order).reduce((a, b) => a > b ? a : b) + 1;

    final updated = playlist.copyWith(
      entries: [
        ...playlist.entries,
        PlaylistEntry(contentItemId: contentItemId, order: nextOrder),
      ],
    );
    await _repo.save(updated);
  }
}

class RemoveFromPlaylistUseCase {
  final PlaylistRepository _repo;
  const RemoveFromPlaylistUseCase(this._repo);

  Future<void> call(String contentItemId) async {
    final playlist = await _repo.getActive();
    if (playlist == null) return;

    final updated = playlist.copyWith(
      entries: playlist.entries
          .where((e) => e.contentItemId != contentItemId)
          .toList(),
    );
    await _repo.save(updated);
  }
}

class ReorderPlaylistUseCase {
  final PlaylistRepository _repo;
  const ReorderPlaylistUseCase(this._repo);

  Future<void> call(List<String> orderedItemIds) async {
    final playlist = await _repo.getActive();
    if (playlist == null) return;

    final reordered = orderedItemIds.asMap().entries.map((e) {
      return PlaylistEntry(contentItemId: e.value, order: e.key);
    }).toList();

    await _repo.save(playlist.copyWith(entries: reordered));
  }
}

class UpdatePlaylistSettingsUseCase {
  final PlaylistRepository _repo;
  const UpdatePlaylistSettingsUseCase(this._repo);

  Future<void> call({
    int? pauseBetweenSeconds,
    double? affirmationVolume,
    double? triggerVolume,
    bool? loop,
    PlaybackMode? playbackMode,
  }) async {
    final playlist = await _repo.getActive();
    if (playlist == null) return;

    await _repo.save(playlist.copyWith(
      pauseBetweenSeconds: pauseBetweenSeconds,
      affirmationVolume: affirmationVolume,
      triggerVolume: triggerVolume,
      loop: loop,
      playbackMode: playbackMode,
    ));
  }
}
