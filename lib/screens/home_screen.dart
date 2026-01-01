import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/audio/audio_bloc.dart';
import '../blocs/audio/audio_event.dart';
import '../blocs/audio/audio_state.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../blocs/theme/theme_state.dart';
import 'playlist_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pháp Thoại Làng Mai'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  context.read<ThemeBloc>().add(ToggleTheme());
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (BuildContext context, ThemeState themeState) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    themeState.isDarkMode
                        ? const AssetImage('assets/bg2.jpeg')
                        : const AssetImage('assets/bg1.jpeg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2),
                  BlendMode.darken,
                ),
              ),
            ),
            child: BlocBuilder<AudioBloc, AudioState>(
              builder: (context, audioState) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SearchBar(
                        hintText: 'Search by title or date...',
                        leading: const Icon(Icons.search),
                        onChanged: (query) {
                          context.read<AudioBloc>().add(SearchAudio(query));
                        },
                      ),
                    ),
                    Expanded(child: _buildBody(context, audioState)),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, AudioState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.isSearching) {
      if (state.searchResults.isEmpty) {
        return const Center(child: Text('No results found'));
      }
      return ListView.builder(
        itemCount: state.searchResults.length,
        itemBuilder: (context, index) {
          final audio = state.searchResults[index];
          return ListTile(
            title: Text(
              audio.title,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            subtitle:
                audio.date != null
                    ? Text(
                      audio.date!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    )
                    : null,
            onTap: () {
               context.read<AudioBloc>().add(PlayAudio(audio));
            },
          );
        },
      );
    }

    if (state.collections.isEmpty) {
      return const Center(child: Text('No collections found'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: state.collections.length,
      itemBuilder: (context, index) {
        final collection = state.collections[index];
        return Card(
          elevation: 4.0,
          color: Theme.of(context).cardColor.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
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
                  const Icon(Icons.folder, size: 48.0, color: Colors.blueGrey),
                  const SizedBox(height: 12.0),
                  Text(
                    collection.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
