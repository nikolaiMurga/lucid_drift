import '../../entities/content_item.dart';
import '../../entities/content_type.dart';
import '../../entities/audio_source.dart';
import '../../repositories/content_item_repository.dart';

class GetContentItemsUseCase {
  final ContentItemRepository _repo;
  const GetContentItemsUseCase(this._repo);

  Stream<List<ContentItem>> call({ContentType? filterType}) {
    if (filterType != null) return _repo.watchByType(filterType);
    return _repo.watchAll();
  }
}

class SaveContentItemUseCase {
  final ContentItemRepository _repo;
  const SaveContentItemUseCase(this._repo);

  Future<void> call(ContentItem item) => _repo.save(item);
}

class DeleteContentItemUseCase {
  final ContentItemRepository _repo;
  const DeleteContentItemUseCase(this._repo);

  Future<void> call(String id) => _repo.delete(id);
}

class AttachAudioUseCase {
  final ContentItemRepository _repo;
  const AttachAudioUseCase(this._repo);

  Future<void> call({
    required String itemId,
    required AudioSource source,
    required Duration duration,
  }) async {
    final item = await _repo.getById(itemId);
    if (item == null) return;
    await _repo.save(item.copyWith(
      audioSource: source,
      audioDuration: duration,
    ));
  }
}
