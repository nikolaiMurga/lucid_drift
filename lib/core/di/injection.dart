import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';

import '../../data/models/content_item_model.dart';
import '../../data/models/night_playlist_model.dart';
import '../../data/models/sleep_schedule_model.dart';
import '../../data/models/sleep_session_model.dart';
import '../../data/repositories/content_item_repository_impl.dart';
import '../../data/repositories/playlist_repository_impl.dart';
import '../../data/repositories/sleep_schedule_repository_impl.dart';
import '../../data/repositories/sleep_session_repository_impl.dart';
import '../../domain/repositories/content_item_repository.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/usecases/content/content_usecases.dart';
import '../../domain/usecases/engine/engine_usecases.dart';
import '../../domain/usecases/playlist/playlist_usecases.dart';
import '../../domain/usecases/recorder/recorder_usecases.dart';
import '../../domain/usecases/schedule/schedule_usecases.dart';
import '../../services/background/rem_trigger_service.dart';
import '../../services/notifications/notification_service.dart';

final sl = GetIt.instance;

Future<void> setupDi() async {
  // ── Isar ─────────────────────────────────────────────────────────────────
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      ContentItemModelSchema,
      NightPlaylistModelSchema,
      SleepScheduleModelSchema,
      SleepSessionModelSchema,
    ],
    directory: dir.path,
    name: 'default',
  );
  sl.registerSingleton<Isar>(isar);

  // ── Repositories ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<ContentItemRepository>(
    () => ContentItemRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<PlaylistRepository>(
    () => PlaylistRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<SleepScheduleRepository>(
    () => SleepScheduleRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<SleepSessionRepository>(
    () => SleepSessionRepositoryImpl(sl()),
  );

  // ── Use Cases: Content ────────────────────────────────────────────────────
  sl.registerFactory(() => GetContentItemsUseCase(sl()));
  sl.registerFactory(() => SaveContentItemUseCase(sl()));
  sl.registerFactory(() => DeleteContentItemUseCase(sl()));
  sl.registerFactory(() => AttachAudioUseCase(sl()));

  // ── Use Cases: Playlist ───────────────────────────────────────────────────
  sl.registerFactory(() => WatchPlaylistUseCase(sl()));
  sl.registerFactory(() => GetPlaylistUseCase(sl()));
  sl.registerFactory(() => AddToPlaylistUseCase(sl()));
  sl.registerFactory(() => RemoveFromPlaylistUseCase(sl()));
  sl.registerFactory(() => ReorderPlaylistUseCase(sl()));
  sl.registerFactory(() => UpdatePlaylistSettingsUseCase(sl()));

  // ── Use Cases: Schedule ───────────────────────────────────────────────────
  sl.registerFactory(() => GetSleepScheduleUseCase(sl()));
  sl.registerFactory(() => SaveSleepScheduleUseCase(sl()));
  sl.registerFactory(() => DeleteSleepScheduleUseCase(sl()));
  sl.registerFactory(() => const CalculateRemTriggerUseCase());

  // ── Use Cases: Engine ─────────────────────────────────────────────────────
  sl.registerFactory(
    () => ActivateTriggerUseCase(sl(), sl()),
  );
  sl.registerFactory(() => const CancelTriggerUseCase());
  sl.registerFactory(() => GetTodaySessionUseCase(sl()));
  sl.registerFactory(() => SaveDebriefUseCase(sl()));
  sl.registerFactory(() => WatchSessionsUseCase(sl()));

  // ── Use Cases: Recorder ───────────────────────────────────────────────────
  sl.registerFactory(() => const PrepareRecordingPathUseCase());
  sl.registerFactory(() => const DeleteAudioFileUseCase());

  // ── Services ──────────────────────────────────────────────────────────────
  await NotificationService.init();
  await NotificationService.requestPermissions();

  await Workmanager().initialize(
    workManagerCallbackDispatcher,
    isInDebugMode: true,
  );
}
