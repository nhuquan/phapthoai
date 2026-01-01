import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/audio/audio_bloc.dart';
import '../blocs/audio/audio_event.dart';
import '../blocs/audio/audio_state.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../blocs/theme/theme_state.dart';
import 'dart:ui';
import '../widgets/glass_card.dart';
import 'playlist_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Theme.of(context).brightness == Brightness.dark
                    ? const AssetImage('assets/bg2.jpeg')
                    : const AssetImage('assets/bg1.jpeg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Pháp Thoại Làng Mai'),
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
                  )
                ]
            ),
            backgroundColor: Colors.transparent,
            body: BlocBuilder<AudioBloc, AudioState>(
              builder: (context, audioState) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GlassCard(
                        isDark: isDark,
                        borderRadius: 30,
                        child: Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
                           child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search by title or date...',
                              icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface),
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                            ),
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            onChanged: (query) {
                              context.read<AudioBloc>().add(SearchAudio(query));
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: _buildBody(context, audioState)),
                  ],
                );
              },
            ),
          ));
    });
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
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
                subtitle: audio.date != null
                    ? Text(
                        audio.date!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant),
                      )
                    : null,
                trailing: Icon(Icons.play_arrow_rounded, color: Theme.of(context).colorScheme.primary),
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
        int crossAxisCount;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 2; // Mobile
        } else if (constraints.maxWidth < 1200) {
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
                    builder: (context) => PlaylistScreen(collection: collection),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark 
                            ? Colors.greenAccent.withOpacity(0.2)
                            : Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                           BoxShadow(
                             color: isDark ? Colors.greenAccent.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                             blurRadius: 12,
                             spreadRadius: 2,
                           )
                        ]
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
            );
          },
        );
      },
    );
  }
}
