import 'package:isar/isar.dart';
import '../../domain/entities/content_item.dart';
import '../../domain/entities/content_type.dart';
import '../../domain/repositories/content_item_repository.dart';
import '../models/content_item_model.dart';

class ContentItemRepositoryImpl implements ContentItemRepository {
  final Isar _isar;
  const ContentItemRepositoryImpl(this._isar);

  @override
  Future<List<ContentItem>> getAll() async {
    final models = await _isar.contentItemModels.where().findAll();
    return models.map((m) => m.toDomain()).toList();
  }

  @override
  Future<List<ContentItem>> getByType(ContentType type) async {
    final typeEnum = type is AffirmationContent
        ? ContentTypeEnum.affirmation
        : ContentTypeEnum.lucidTrigger;

    final models = await _isar.contentItemModels
        .filter()
        .contentTypeEqualTo(typeEnum)
        .findAll();

    return models.map((m) => m.toDomain()).toList();
  }

  @override
  Future<ContentItem?> getById(String id) async {
    final model = await _isar.contentItemModels.get(fastHash(id));
    return model?.toDomain();
  }

  @override
  Future<void> save(ContentItem item) async {
    await _isar.writeTxn(() async {
      await _isar.contentItemModels.put(ContentItemModel.fromDomain(item));
    });
  }

  @override
  Future<void> delete(String id) async {
    await _isar.writeTxn(() async {
      await _isar.contentItemModels.delete(fastHash(id));
    });
  }

  @override
  Stream<List<ContentItem>> watchAll() {
    return _isar.contentItemModels
        .where()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toDomain()).toList());
  }

  @override
  Stream<List<ContentItem>> watchByType(ContentType type) {
    final typeEnum = type is AffirmationContent
        ? ContentTypeEnum.affirmation
        : ContentTypeEnum.lucidTrigger;

    return _isar.contentItemModels
        .filter()
        .contentTypeEqualTo(typeEnum)
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toDomain()).toList());
  }
}
