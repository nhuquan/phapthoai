import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/audio.dart';
import '../models/audio_view_model.dart';
import '../utils/download_helper.dart';

class PlaylistScreen extends StatelessWidget {
  final Collection collection;

  const PlaylistScreen({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(collection.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), 
              BlendMode.darken,
            ),
          ),
        ),
        child: Consumer<AudioViewModel>(
          builder: (context, viewModel, child) {
            return ListView.builder(
              itemCount: collection.audios.length,
              itemBuilder: (context, index) {
                final audio = collection.audios[index];
                final isPlaying = viewModel.currentAudio?.url == audio.url;
                
                return ListTile(
                  leading: Icon(
                    isPlaying ? Icons.music_note : Icons.play_circle_outline,
                    color: isPlaying ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    audio.title,
                    style: TextStyle(
                      fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
                      color: isPlaying 
                          ? Theme.of(context).primaryColor 
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: audio.date != null ? Text(
                    audio.date!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ) : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {
                      DownloadHelper.downloadAudio(audio.url);
                    },
                  ),
                  onTap: () {
                    viewModel.playAudio(audio);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
