import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/repos/content_repo.dart';
import '../domain/use_cases/content_use_case.dart';
import '../domain/use_cases/sleep_scheduler_use_case.dart';

import '../presentation/content/cubit/content_cubit.dart';

import '../presentation/night_session/cubit/night_session_cubit.dart';
import '../presentation/sleep_schedule/cubit/sleep_schedule_cubit.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // Repositories
  sl.registerLazySingleton(() => ContentRepo(sl()));

  // Use Cases
  sl.registerLazySingleton(() => ContentUseCase(sl()));
  sl.registerLazySingleton(() => SleepSchedulerUseCase());

  // Cubits
  sl.registerFactory(() => ContentCubit(sl()));
  sl.registerFactory(() => SleepScheduleCubit(sl()));
  sl.registerFactory(() => NightSessionCubit());
}
