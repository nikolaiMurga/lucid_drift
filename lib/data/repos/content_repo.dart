import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/content_item_model.dart';

class ContentRepo {
  final SharedPreferences _prefs;
  static const _key = 'content_items';

  ContentRepo(this._prefs);

  Future<void> saveContentItem(ContentItemModel item) async {
    final items = await getContentItems();
    final updatedItems = [...items, item];
    await _prefs.setString(_key, jsonEncode(updatedItems.map((e) => e.toJson()).toList()));
  }

  Future<List<ContentItemModel>> getContentItems() async {
    final jsonString = _prefs.getString(_key);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => ContentItemModel.fromJson(e)).toList();
  }

  Future<void> deleteContentItem(String id) async {
    final items = await getContentItems();
    final updatedItems = items.where((e) => e.id != id).toList();
    await _prefs.setString(_key, jsonEncode(updatedItems.map((e) => e.toJson()).toList()));
  }
}
