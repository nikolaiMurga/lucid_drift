import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection.dart';
import 'presentation/content/cubit/content_cubit.dart';
import 'presentation/sleep_schedule/cubit/sleep_schedule_cubit.dart';
import 'presentation/night_session/cubit/night_session_cubit.dart';
import 'presentation/home/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection();
  runApp(const LucidDriftApp());
}

class LucidDriftApp extends StatelessWidget {
  const LucidDriftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ContentCubit>()..loadContent(),
        ),
        BlocProvider(
          create: (context) => sl<SleepScheduleCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<NightSessionCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'LucidDrift',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          cardTheme: CardThemeData(
            color: const Color(0xFF1E1E1E),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
