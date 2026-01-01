import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data/audio_repository.dart';
import 'models/audio_view_model.dart';
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
      ],
      child: MaterialApp(
        title: 'Pháp Thoại Làng Mai',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
          useMaterial3: true,
          textTheme: GoogleFonts.merriweatherTextTheme(),
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
      ),
    );
  }
}
