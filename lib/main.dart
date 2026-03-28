import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data/audio_repository.dart';
import 'blocs/audio/audio_bloc.dart';
import 'blocs/theme/theme_bloc.dart';
import 'blocs/theme/theme_state.dart';
import 'screens/main_screen.dart';
import 'widgets/player_widget.dart';
import 'blocs/audio/audio_state.dart';

import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'dev.livana.phapthoai.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AudioBloc(AudioRepository())),
        BlocProvider(create: (_) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Pháp Thoại Sư Ông',
            debugShowCheckedModeBanner: false,
            themeMode: themeState.themeMode,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.brown,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              textTheme: GoogleFonts.merriweatherTextTheme(),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.brown,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              textTheme: GoogleFonts.merriweatherTextTheme(
                ThemeData.dark().textTheme,
              ),
            ),
            home: const MainScreen(),
            builder: (context, child) {
              return child!;
            },
          );
        },
      ),
    );
  }
}
