import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data/audio_repository.dart';
import 'blocs/audio/audio_bloc.dart';
import 'blocs/theme/theme_bloc.dart';
import 'blocs/theme/theme_state.dart';
import 'screens/home_screen.dart';
import 'widgets/player_widget.dart';
import 'blocs/audio/audio_state.dart';

void main() {
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
            home: const HomeScreen(),
            builder: (context, child) {
              return Material(
                child: Column(
                  children: [
                    Expanded(child: child!),
                    BlocBuilder<AudioBloc, AudioState>(
                      builder: (context, audioState) {
                        if (audioState.player != null && !audioState.isSearching) {
                          return PlayerWidget(
                            player: audioState.player!,
                            currentAudio: audioState.currentAudio,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
