import 'package:isar/isar.dart';
import '../../domain/entities/night_playlist.dart';

part 'night_playlist_model.g.dart';

@collection
class NightPlaylistModel {
  Id get isarId => fastHash(id);

  late String id;
  late String name;

  // entries сериализуем как два parallel-листа
  late List<String> entryItemIds;
  late List<int> entryOrders;

  late int playbackModeIndex;
  late int pauseBetweenSeconds;
  late double affirmationVolume;
  late double triggerVolume;
  late bool loop;
  late bool isActive;
  late DateTime updatedAt;

  // ---- mapping ----

  NightPlaylist toDomain() {
    final entries = List.generate(
      entryItemIds.length,
      (i) => PlaylistEntry(
        contentItemId: entryItemIds[i],
        order: entryOrders[i],
      ),
    )..sort((a, b) => a.order.compareTo(b.order));

    return NightPlaylist(
      id: id,
      name: name,
      entries: entries,
      playbackMode: PlaybackMode.values[playbackModeIndex],
      pauseBetweenSeconds: pauseBetweenSeconds,
      affirmationVolume: affirmationVolume,
      triggerVolume: triggerVolume,
      loop: loop,
      updatedAt: updatedAt,
    );
  }

  static NightPlaylistModel fromDomain(NightPlaylist p, {bool isActive = false}) {
    return NightPlaylistModel()
      ..id = p.id
      ..name = p.name
      ..entryItemIds = p.entries.map((e) => e.contentItemId).toList()
      ..entryOrders = p.entries.map((e) => e.order).toList()
      ..playbackModeIndex = p.playbackMode.index
      ..pauseBetweenSeconds = p.pauseBetweenSeconds
      ..affirmationVolume = p.affirmationVolume
      ..triggerVolume = p.triggerVolume
      ..loop = p.loop
      ..isActive = isActive
      ..updatedAt = p.updatedAt;
  }
}

int fastHash(String string) {
  var hash = 0xcbf29ce484222325;
  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }
  return hash;
}
