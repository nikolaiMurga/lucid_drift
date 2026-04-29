import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/models/content_item_model.dart';
import '../../data/models/night_playlist_model.dart';
import '../../data/repositories/content_item_repository_impl.dart';
import '../../data/repositories/playlist_repository_impl.dart';
import '../../domain/repositories/content_item_repository.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/usecases/content/content_usecases.dart';
import '../../domain/usecases/playlist/playlist_usecases.dart';
import '../../domain/usecases/recorder/recorder_usecases.dart';
import '../../domain/usecases/schedule/schedule_usecases.dart';

final sl = GetIt.instance;

Future<void> setupDi() async {
  // --- Isar ---
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [ContentItemModelSchema, NightPlaylistModelSchema],
    directory: dir.path,
  );
  sl.registerSingleton<Isar>(isar);

  // --- Repositories ---
  sl.registerLazySingleton<ContentItemRepository>(
    () => ContentItemRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<PlaylistRepository>(
    () => PlaylistRepositoryImpl(sl()),
  );

  // --- Use Cases: Content ---
  sl.registerFactory(() => GetContentItemsUseCase(sl()));
  sl.registerFactory(() => SaveContentItemUseCase(sl()));
  sl.registerFactory(() => DeleteContentItemUseCase(sl()));
  sl.registerFactory(() => AttachAudioUseCase(sl()));

  // --- Use Cases: Playlist ---
  sl.registerFactory(() => WatchPlaylistUseCase(sl()));
  sl.registerFactory(() => GetPlaylistUseCase(sl()));
  sl.registerFactory(() => AddToPlaylistUseCase(sl()));
  sl.registerFactory(() => RemoveFromPlaylistUseCase(sl()));
  sl.registerFactory(() => ReorderPlaylistUseCase(sl()));
  sl.registerFactory(() => UpdatePlaylistSettingsUseCase(sl()));

  // --- Use Cases: Recorder ---
  sl.registerFactory(() => const PrepareRecordingPathUseCase());
  sl.registerFactory(() => const DeleteAudioFileUseCase());

  // --- Use Cases: Schedule ---
  sl.registerFactory(() => const CalculateRemTriggerUseCase());
}
