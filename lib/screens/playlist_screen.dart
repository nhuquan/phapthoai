import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phapthoailangmai/blocs/theme/theme_bloc.dart';
import 'package:phapthoailangmai/blocs/theme/theme_state.dart';
import '../blocs/audio/audio_bloc.dart';
import '../blocs/audio/audio_event.dart';
import '../blocs/audio/audio_state.dart';
import '../models/audio.dart';
import '../utils/download_helper.dart';

class PlaylistScreen extends StatelessWidget {
  final Collection collection;

  const PlaylistScreen({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState> (
      builder: (BuildContext context, ThemeState themeState) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: themeState.isDarkMode ? AssetImage('assets/bg2.jpeg')
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
                return ListView.builder(
                  itemCount: collection.audios.length,
                  itemBuilder: (context, index) {
                    final audio = collection.audios[index];
                    // Check if this specific audio is matched by URL
                    final isPlaying = state.currentAudio?.title == audio.title;

                    return ListTile(
                      leading: Icon(
                        isPlaying ? Icons.music_note : Icons
                            .play_circle_outline,
                        color:  Theme
                            .of(context)
                            .iconTheme
                            .color,
                      ),
                      title: Text(
                        audio.title,
                        style: TextStyle(
                          fontWeight: isPlaying ? FontWeight.bold : FontWeight
                              .normal,
                          color:Theme
                              .of(context)
                              .colorScheme
                              .onSurface,
                        ),
                      ),
                      subtitle: audio.date != null ? Text(
                        audio.date!,
                        style: TextStyle(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                      ) : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () {
                          DownloadHelper.downloadAudio(audio.url);
                        },
                      ),
                      onTap: () {
                        context.read<AudioBloc>().add(PlayAudio(audio));
                      },
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
