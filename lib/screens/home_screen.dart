import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/audio/audio_bloc.dart';
import '../blocs/audio/audio_event.dart';
import '../blocs/audio/audio_state.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../blocs/theme/theme_state.dart';
import 'dart:ui';
import '../widgets/download_button.dart';
import '../widgets/glass_card.dart';
import '../widgets/timeline_item.dart';
import 'playlist_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String? _extractYear(String title) {
    final regex = RegExp(r'\b(19|20)\d{2}\b');
    final match = regex.firstMatch(title);
    return match?.group(0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  Theme.of(context).brightness == Brightness.dark
                      ? const AssetImage('assets/bg2.jpeg')
                      : const AssetImage('assets/bg1.jpeg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.2),
                BlendMode.darken,
              ),
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              leadingWidth: 100, // Make logo area wider
              leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'assets/langmai_2.png'
                      : 'assets/langmai_1.png',
                  fit: BoxFit.cover,
                ),
              ),
              title: const Text('Pháp Thoại Sư Ông'),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                  icon: Icon(
                    Theme.of(context).brightness == Brightness.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: () {
                    context.read<ThemeBloc>().add(ToggleTheme());
                  },
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            body: BlocBuilder<AudioBloc, AudioState>(
              builder: (context, audioState) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                      child: GlassCard(
                        isDark: isDark,
                        borderRadius: 30,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search by title or date...',
                              icon: Icon(
                                Icons.search,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    audioState.showOnlyDownloaded
                                        ? Icons.download_done_rounded
                                        : Icons.download_for_offline_outlined,
                                    color:
                                        audioState.showOnlyDownloaded
                                            ? Theme.of(context).colorScheme.primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.6),
                                  ),
                                  onPressed: () {
                                    context.read<AudioBloc>().add(
                                      ToggleDownloadedFilter(),
                                    );
                                  },
                                  tooltip: 'Show only downloaded',
                                ),
                              ),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            onChanged: (query) {
                              context.read<AudioBloc>().add(SearchAudio(query));
                            },
                          ),
                        ),
                      ),
                    ),

                    Expanded(child: _buildBody(context, audioState)),

                    if (!audioState.isSearching && !audioState.isPlaying)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text(
                            "For more content, try out the official app",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                        
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          GestureDetector(
                            onTap:
                                () => launchUrl(
                              Uri.parse(
                                'https://apps.apple.com/vn/app/plum-village-zen-meditation/id1273719339?l=vi',
                              ),
                              mode: LaunchMode.externalApplication,
                            ),
                            child: Text(
                              'iOS',
                              style: TextStyle(
                                color:
                                Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              '•',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap:
                                () => launchUrl(
                              Uri.parse(
                                'https://play.google.com/store/apps/details?id=org.plumvillageapp&hl=vi',
                              ),
                              mode: LaunchMode.externalApplication,
                            ),
                            child: Text(
                              'Android',
                              style: TextStyle(
                                color:
                                Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                            ]),
                        ],
                      ),

                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AudioState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state.isSearching) {
      if (state.searchResults.isEmpty) {
        return const Center(child: Text('No results found'));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: state.searchResults.length,
        itemBuilder: (context, index) {
          final audio = state.searchResults[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GlassCard(
              isDark: isDark,
              borderRadius: 12,
              onTap: () {
                context.read<AudioBloc>().add(PlayAudio(audio));
              },
              child: ListTile(
                title: Text(
                  audio.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                subtitle:
                    audio.date != null
                        ? Text(
                          audio.date!,
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        )
                        : null,
                trailing: Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(
                      Icons.play_arrow_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    if (state.collections.isEmpty) {
      return const Center(child: Text('No collections found'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile View - Timeline List
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            itemCount: state.collections.length,
            itemBuilder: (context, index) {
              final collection = state.collections[index];
              return TimelineItem(
                isFirst: index == 0,
                isLast: index == state.collections.length - 1,
                isDark: isDark,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: GlassCard(
                    isDark: isDark,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  PlaylistScreen(collection: collection),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Builder(
                              builder: (context) {
                                final year = _extractYear(collection.title);
                                if (year != null) {
                                  return Text(
                                    year,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  );
                                }
                                return Icon(
                                  Icons.folder_open_rounded,
                                  size: 24.0,
                                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  collection.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${collection.audios.length} audios",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<AudioBloc>().add(
                                ToggleFavorite(collection),
                              );
                            },
                            icon: Icon(
                              collection.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  collection.isFavorite
                                      ? Colors.red
                                      : Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }

        int crossAxisCount;
        if (constraints.maxWidth < 1200) {
          crossAxisCount = 4; // Tablet
        } else {
          crossAxisCount = 6; // Desktop
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.0,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: state.collections.length,
          itemBuilder: (context, index) {
            final collection = state.collections[index];

            return GlassCard(
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PlaylistScreen(collection: collection),
                  ),
                );
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? Colors.greenAccent.withValues(alpha: 0.2)
                                    : Colors.green.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    isDark
                                        ? Colors.greenAccent.withValues(alpha: 0.1)
                                        : Colors.green.withValues(alpha: 0.1),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.folder_open_rounded,
                            size: 40.0,
                            color: isDark ? Colors.greenAccent : Colors.green,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Flexible(
                          child: Text(
                            collection.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: () {
                        context.read<AudioBloc>().add(
                          ToggleFavorite(collection),
                        );
                      },
                      icon: Icon(
                        collection.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            collection.isFavorite
                                ? Colors.red
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
