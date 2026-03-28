import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/audio/audio_bloc.dart';
import '../blocs/audio/audio_state.dart';
import 'player_widget.dart';

class GlobalPlayer extends StatelessWidget {
  const GlobalPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, audioState) {
        if (audioState.player != null && !audioState.shouldHidePlayer) {
          return PlayerWidget(
            player: audioState.player!,
            currentAudio: audioState.currentAudio,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
