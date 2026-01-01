import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/audio.dart';

class PlayerWidget extends StatelessWidget {
  final AudioPlayer player;
  final Audio? currentAudio;

  const PlayerWidget({
    super.key,
    required this.player,
    this.currentAudio,
  });

  @override
  Widget build(BuildContext context) {
    if (currentAudio == null) return const SizedBox.shrink();

    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentAudio!.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                StreamBuilder<PlayerState>(
                  stream: player.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        width: 48.0,
                        height: 48.0,
                        child: const CircularProgressIndicator(),
                      );
                    } else if (playing != true) {
                      return GestureDetector(
                        onTap: player.play,
                        child: const Icon(Icons.play_arrow, size: 48.0),
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return GestureDetector(
                        onTap: player.pause,
                        child: const Icon(Icons.pause, size: 48.0),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () => player.seek(Duration.zero),
                        child: const Icon(Icons.replay, size: 48.0),
                      );
                    }
                  },
                ),
                Expanded(
                  child: StreamBuilder<Duration>(
                    stream: player.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      return StreamBuilder<Duration?>(
                        stream: player.durationStream,
                        builder: (context, snapshot) {
                          final duration = snapshot.data ?? Duration.zero;
                          final max = duration.inMilliseconds.toDouble();
                          final value = position.inMilliseconds.toDouble();
                          final percentage = max == 0 ? 0.0 : (value / max).clamp(0.0, 1.0);

                          return LayoutBuilder(
                            builder: (context, constraints) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTapDown: (details) {
                                  final renderBox = context.findRenderObject() as RenderBox;
                                  final localPos = renderBox.globalToLocal(details.globalPosition);
                                  final seekPct = localPos.dx / constraints.maxWidth;
                                  player.seek(Duration(milliseconds: (seekPct * max).toInt()));
                                },
                                onHorizontalDragUpdate: (details) {
                                  final renderBox = context.findRenderObject() as RenderBox;
                                  final localPos = renderBox.globalToLocal(details.globalPosition);
                                  final seekPct = localPos.dx / constraints.maxWidth;
                                  player.seek(Duration(milliseconds: (seekPct * max).toInt()));
                                },
                                child: Container(
                                  height: 30.0,
                                  alignment: Alignment.center,
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        height: 4.0,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(2.0),
                                        ),
                                      ),
                                      Container(
                                        height: 4.0,
                                        width: constraints.maxWidth * percentage,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.primary,
                                          borderRadius: BorderRadius.circular(2.0),
                                        ),
                                      ),
                                      Positioned(
                                        left: (constraints.maxWidth * percentage) - 6.0,
                                        child: Container(
                                          width: 12.0,
                                          height: 12.0,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
