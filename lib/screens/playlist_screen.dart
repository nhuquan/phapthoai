import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/audio.dart';
import '../models/audio_view_model.dart';

class PlaylistScreen extends StatelessWidget {
  final Collection collection;

  const PlaylistScreen({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(collection.title),
      ),
      body: Consumer<AudioViewModel>(
        builder: (context, viewModel, child) {
          return ListView.builder(
            itemCount: collection.audios.length,
            itemBuilder: (context, index) {
              final audio = collection.audios[index];
              final isPlaying = viewModel.currentAudio?.url == audio.url;
              
              return ListTile(
                leading: Icon(
                  isPlaying ? Icons.music_note : Icons.play_circle_outline,
                  color: isPlaying ? Theme.of(context).primaryColor : null,
                ),
                title: Text(
                  audio.title,
                  style: TextStyle(
                    fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
                    color: isPlaying ? Theme.of(context).primaryColor : null,
                  ),
                ),
                onTap: () {
                  viewModel.playAudio(audio);
                },
              );
            },
          );
        },
      ),
    );
  }
}
