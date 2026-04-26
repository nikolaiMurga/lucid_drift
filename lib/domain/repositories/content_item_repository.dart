import '../entities/content_item.dart';
import '../entities/content_type.dart';

abstract interface class ContentItemRepository {
  Future<List<ContentItem>> getAll();
  Future<List<ContentItem>> getByType(ContentType type);
  Future<ContentItem?> getById(String id);
  Future<void> save(ContentItem item);
  Future<void> delete(String id);
  Stream<List<ContentItem>> watchAll();
  Stream<List<ContentItem>> watchByType(ContentType type);
}
