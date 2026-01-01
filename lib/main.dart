import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data/audio_repository.dart';
import 'models/audio_view_model.dart';
import 'models/theme_view_model.dart';
import 'screens/home_screen.dart';
import 'widgets/player_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AudioViewModel(AudioRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeViewModel(),
        ),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          return MaterialApp(
            title: 'Pháp Thoại Làng Mai',
            debugShowCheckedModeBanner: false,
            themeMode: themeViewModel.themeMode,
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
              textTheme: GoogleFonts.merriweatherTextTheme(ThemeData.dark().textTheme),
            ),
            home: const HomeScreen(),
            builder: (context, child) {
              return Material(
                child: Column(
                  children: [
                    Expanded(child: child!),
                    Consumer<AudioViewModel>(
                      builder: (context, viewModel, _) {
                        return PlayerWidget(
                          player: viewModel.player,
                          currentAudio: viewModel.currentAudio,
                        );
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
