import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phapthoai/blocs/theme/theme_bloc.dart';
import 'package:phapthoai/blocs/theme/theme_state.dart';
import '../blocs/audio/audio_bloc.dart';
import '../blocs/audio/audio_event.dart';
import '../blocs/audio/audio_state.dart';
import '../models/audio.dart';
import '../widgets/download_button.dart';
import '../widgets/glass_card.dart';

class PlaylistScreen extends StatelessWidget {
  final Collection collection;

  const PlaylistScreen({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (BuildContext context, ThemeState themeState) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  Theme.of(context).brightness == Brightness.dark
                      ? AssetImage('assets/bg2.jpeg')
                      : AssetImage('assets/bg1.jpeg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2),
                BlendMode.darken,
              ),
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              title: Text(collection.title),
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
            body: BlocBuilder<AudioBloc, AudioState>(
              builder: (context, state) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: collection.audios.length,
                  itemBuilder: (context, index) {
                    final audio = collection.audios[index];
                    // Check if this specific audio is matched by URL
                    final isPlaying = state.currentAudio?.title == audio.title;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GlassCard(
                        isDark: isDark,
                        borderRadius: 16,
                        onTap: () {
                          context.read<AudioBloc>().add(PlayAudio(audio));
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  isPlaying
                                      ? Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.2)
                                      : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPlaying
                                  ? Icons.music_note
                                  : Icons.play_arrow_rounded,
                              color:
                                  isPlaying
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).iconTheme.color,
                            ),
                          ),
                          title: Text(
                            audio.title,
                            style: TextStyle(
                              fontWeight:
                                  isPlaying
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          subtitle:
                              audio.date != null
                                  ? Text(
                                    audio.date!,
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                    ),
                                  )
                                  : null,
                          trailing: DownloadButton(url: audio.url),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
