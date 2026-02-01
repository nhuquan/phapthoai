import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/audio/audio_bloc.dart';
import '../blocs/audio/audio_event.dart';
import '../models/audio.dart';

class PlayerWidget extends StatelessWidget {
  final AudioPlayer player;
  final Audio? currentAudio;

  const PlayerWidget({super.key, required this.player, this.currentAudio});

  String _formatDuration(Duration? duration) {
    if (duration == null) return '--:--';
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${duration.inHours > 0 ? '${duration.inHours}:' : ''}$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (currentAudio == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      currentAudio!.title,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: -8,
                  child: IconButton(
                    onPressed: () {
                      context.read<AudioBloc>().add(StopAudio());
                    },
                    icon: const Icon(Icons.close_rounded),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StreamBuilder<Duration>(
              stream: player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration?>(
                  stream: player.durationStream,
                  builder: (context, snapshot) {
                    final duration = snapshot.data ?? Duration.zero;
                    final max = duration.inMilliseconds.toDouble();
                    final value = position.inMilliseconds.toDouble();
                    final percentage =
                        max == 0 ? 0.0 : (value / max).clamp(0.0, 1.0);

                    // LayoutBuilder needs a constrained width to work correctly.
                    // The Column's stretch alignment ensures this.
                    return Column(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapDown: (details) {
                                final renderBox =
                                    context.findRenderObject() as RenderBox;
                                final localPos = renderBox.globalToLocal(
                                  details.globalPosition,
                                );
                                if (constraints.maxWidth > 0) {
                                  final seekPct =
                                      localPos.dx / constraints.maxWidth;
                                  player.seek(
                                    Duration(
                                      milliseconds: (seekPct * max).toInt(),
                                    ),
                                  );
                                }
                              },
                              onHorizontalDragUpdate: (details) {
                                final renderBox =
                                    context.findRenderObject() as RenderBox;
                                final localPos = renderBox.globalToLocal(
                                  details.globalPosition,
                                );
                                if (constraints.maxWidth > 0) {
                                  final seekPct =
                                      localPos.dx / constraints.maxWidth;
                                  player.seek(
                                    Duration(
                                      milliseconds: (seekPct * max).toInt(),
                                    ),
                                  );
                                }
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
                                        borderRadius: BorderRadius.circular(
                                          2.0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 4.0,
                                      width: constraints.maxWidth * percentage,
                                      decoration: BoxDecoration(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(
                                          2.0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left:
                                          (constraints.maxWidth * percentage) -
                                          6.0,
                                      child: Container(
                                        width: 12.0,
                                        height: 12.0,
                                        decoration: BoxDecoration(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(position),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                _formatDuration(duration),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => player.seek(Duration.zero),
                  icon: const Icon(Icons.skip_previous_rounded),
                  iconSize: 32,
                ),
                IconButton(
                  onPressed: () {
                    final position = player.position;
                    // Ensure we don't seek to negative values
                    final newMilliseconds = position.inMilliseconds - 10000;
                    final newPosition = Duration(
                      milliseconds:
                          newMilliseconds < 0 ? 0 : newMilliseconds,
                    );
                    player.seek(newPosition);
                  },
                  icon: const Icon(Icons.replay_10),
                  iconSize: 32,
                ),
                StreamBuilder<PlayerState>(
                  stream: player.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return const SizedBox(
                        width: 64.0,
                        height: 64.0,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (playing != true) {
                      return IconButton(
                        onPressed: player.play,
                        icon: const Icon(Icons.play_circle_fill),
                        iconSize: 64.0,
                        color: Theme.of(context).colorScheme.primary,
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return IconButton(
                        onPressed: player.pause,
                        icon: const Icon(Icons.pause_circle_filled),
                        iconSize: 64.0,
                        color: Theme.of(context).colorScheme.primary,
                      );
                    } else {
                      return IconButton(
                        onPressed: () => player.seek(Duration.zero),
                        icon: const Icon(Icons.replay_circle_filled),
                        iconSize: 64.0,
                        color: Theme.of(context).colorScheme.primary,
                      );
                    }
                  },
                ),
                IconButton(
                  onPressed: () {
                    final position = player.position;
                    // Seek forward 10s
                    final newPosition = position + const Duration(seconds: 10);
                    player.seek(newPosition);
                  },
                  icon: const Icon(Icons.forward_10),
                  iconSize: 32,
                ),
                StreamBuilder<LoopMode>(
                  stream: player.loopModeStream,
                  builder: (context, snapshot) {
                    final loopMode = snapshot.data ?? LoopMode.off;
                    const icons = [
                      Icon(Icons.repeat, color: Colors.grey),
                      Icon(Icons.repeat, color: Colors.orange), // all
                      Icon(Icons.repeat_one, color: Colors.orange), // one
                    ];
                    final cycleModes = [
                      LoopMode.off,
                      LoopMode.all,
                      LoopMode.one,
                    ];
                    final index = cycleModes.indexOf(loopMode);
                    return IconButton(
                      icon: icons[index],
                      onPressed: () {
                        player.setLoopMode(
                            cycleModes[(index + 1) % cycleModes.length]);
                      },
                      iconSize: 32,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
