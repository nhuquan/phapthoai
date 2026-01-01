import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/audio_view_model.dart';
import '../models/theme_view_model.dart';
import 'playlist_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pháp Thoại Làng Mai'),
        centerTitle: true,
        actions: [
          Consumer<ThemeViewModel>(
            builder: (context, themeViewModel, _) {
              return IconButton(
                icon: Icon(themeViewModel.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  themeViewModel.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), 
              BlendMode.darken,
            ),
          ),
        ),
        child: Consumer<AudioViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SearchBar(
                    hintText: 'Search by title or date...',
                    leading: const Icon(Icons.search),
                    onChanged: (query) {
                      viewModel.search(query);
                    },
                  ),
                ),
                Expanded(
                  child: _buildBody(context, viewModel),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AudioViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.isSearching) {
      if (viewModel.searchResults.isEmpty) {
        return const Center(child: Text('No results found'));
      }
      return ListView.builder(
        itemCount: viewModel.searchResults.length,
        itemBuilder: (context, index) {
          final audio = viewModel.searchResults[index];
          return ListTile(
            title: Text(audio.title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            subtitle: audio.date != null ? Text(audio.date!, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)) : null,
            onTap: () {
              viewModel.playAudio(audio);
            },
          );
        },
      );
    }

    if (viewModel.collections.isEmpty) {
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
      itemCount: viewModel.collections.length,
      itemBuilder: (context, index) {
        final collection = viewModel.collections[index];
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
