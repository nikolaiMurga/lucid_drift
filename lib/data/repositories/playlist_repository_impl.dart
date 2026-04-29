import 'package:isar/isar.dart';
import '../../domain/entities/night_playlist.dart';
import '../../domain/repositories/repositories.dart';
import '../models/night_playlist_model.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final Isar _isar;

  const PlaylistRepositoryImpl(this._isar);

  static const _singletonId = 'main_playlist';

  /// MVP: один плейлист с фиксированным id
  Future<NightPlaylistModel> _getOrCreate() async {
    final hash = fastHash(_singletonId);
    final existing = await _isar.nightPlaylistModels.get(hash);
    if (existing != null) return existing;

    final model = NightPlaylistModel.fromDomain(
      NightPlaylist(
        id: _singletonId,
        name: 'Ночной плейлист',
        entries: const [],
        updatedAt: DateTime.now(),
      ),
      isActive: true,
    );
    await _isar.writeTxn(() => _isar.nightPlaylistModels.put(model));
    return model;
  }

  @override
  Future<NightPlaylist?> getActive() async {
    final model = await _getOrCreate();
    return model.toDomain();
  }

  @override
  Future<List<NightPlaylist>> getAll() async {
    final models = await _isar.nightPlaylistModels.where().findAll();
    return models.map((m) => m.toDomain()).toList();
  }

  @override
  Future<void> save(NightPlaylist playlist) async {
    final isActive = playlist.id == _singletonId;
    final model = NightPlaylistModel.fromDomain(playlist, isActive: isActive);
    await _isar.writeTxn(() => _isar.nightPlaylistModels.put(model));
  }

  @override
  Future<void> setActive(String id) async {
    // MVP: только один плейлист, нет смысла переключать
  }

  @override
  Future<void> delete(String id) async {
    await _isar.writeTxn(
      () => _isar.nightPlaylistModels.delete(fastHash(id)),
    );
  }

  @override
  Stream<NightPlaylist?> watchActive() {
    return _isar.nightPlaylistModels
        .where()
        .watch(fireImmediately: true)
        .asyncMap((_) => getActive());
  }
}
