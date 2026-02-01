import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/audio_repository.dart';
import '../../models/audio.dart';
import '../../utils/download_helper.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'audio_event.dart';
import 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioRepository _repository;
  final AudioPlayer _player;

  AudioBloc(this._repository)
    : _player = AudioPlayer(),
      super(const AudioState()) {
    _initSession();
    on<LoadCollections>(_onLoadCollections);
    on<SearchAudio>(_onSearchAudio);
    on<PlayAudio>(_onPlayAudio);
    on<ToggleFavorite>(_onToggleFavorite);

    // Initialize player and load data
    add(LoadCollections());
  }

  Future<void> _onLoadCollections(
    LoadCollections event,
    Emitter<AudioState> emit,
  ) async {
    // Ensure player is available in state
    emit(state.copyWith(isLoading: true, player: _player));
    try {
      final collections = await _repository.loadCollections();
      
      List<String> favorites = [];
      try {
        final prefs = await SharedPreferences.getInstance();
        favorites = prefs.getStringList('favorites') ?? [];
      } catch (e) {
        debugPrint("Error loading preferences: $e");
      }

      // Update collections with favorite status
      final updatedCollections =
          collections.map((c) {
            return c.copyWith(isFavorite: favorites.contains(c.title));
          }).toList();

      _sortCollections(updatedCollections);

      emit(state.copyWith(collections: updatedCollections, isLoading: false));
    } catch (e) {
      debugPrint("Error loading data: $e");
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<AudioState> emit,
  ) async {
    final collection = event.collection;
    final updatedCollection = collection.copyWith(
      isFavorite: !collection.isFavorite,
    );

    final updatedCollections =
        state.collections.map((c) {
          if (c.title == collection.title) {
            return updatedCollection;
          }
          return c;
        }).toList();

    _sortCollections(updatedCollections);

    emit(state.copyWith(collections: updatedCollections));

    // Persist changes
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('favorites') ?? [];
      if (updatedCollection.isFavorite) {
        if (!favorites.contains(updatedCollection.title)) {
          favorites.add(updatedCollection.title);
        }
      } else {
        favorites.remove(updatedCollection.title);
      }
      await prefs.setStringList('favorites', favorites);
    } catch (e) {
      debugPrint("Error saving favorites: $e");
    }
  }

  void _sortCollections(List<Collection> collections) {
    collections.sort((Collection a, Collection b) {
      // First sort by favorite status
      if (a.isFavorite != b.isFavorite) {
        return a.isFavorite ? -1 : 1;
      }
      // Then sort by year
      final yearA = _extractYear(a.title);
      final yearB = _extractYear(b.title);
      return yearB.compareTo(yearA); // Descending order for year
    });
  }

  void _onSearchAudio(SearchAudio event, Emitter<AudioState> emit) {
    final query = event.query.toLowerCase();
    if (query.isEmpty) {
      emit(state.copyWith(searchQuery: query, searchResults: []));
    } else {
      final allAudios = state.collections.expand((c) => c.audios);
      final results =
          allAudios.where((audio) {
            final title = audio.title.toLowerCase();
            final date = audio.date?.toLowerCase() ?? '';
            return title.contains(query) || date.contains(query);
          }).toList();
      emit(state.copyWith(searchQuery: query, searchResults: results));
    }
  }

  Future<void> _onPlayAudio(PlayAudio event, Emitter<AudioState> emit) async {
    final audio = event.audio;

    // Optimistic update
    emit(state.copyWith(currentAudio: audio, isPlaying: true));

    try {
      if (_player.playing) {
        await _player.stop();
      }
      
      final source = await DownloadHelper.getAudioSource(audio.url);
      
      final mediaItem = MediaItem(
        id: audio.url,
        album: audio.collectionName ?? "Pháp Thoại",
        title: audio.title,
        artist: "Sư Ông Làng Mai",
        artUri: Uri.parse("https://langmai.org/wp-content/uploads/2022/01/hi%CC%80nh-ca%CC%81o-pho%CC%81-su%CC%9B-o%CC%82ng-1028x1536.jpeg"),
      );

      if (source.startsWith('http')) {
        await _player.setAudioSource(
          AudioSource.uri(Uri.parse(source), tag: mediaItem),
        );
      } else {
        await _player.setAudioSource(
          AudioSource.file(source, tag: mediaItem),
        );
      }
      
      await _player.play();
    } catch (e) {
      debugPrint("Error playing audio: $e");
      emit(state.copyWith(isPlaying: false));
    }
  }

  @override
  Future<void> close() {
    _player.dispose();
    return super.close();
  }

  int _extractYear(String title) {
    final regex = RegExp(r'\b(19|20)\d{2}\b');
    final match = regex.firstMatch(title);
    if (match != null) {
      return int.parse(match.group(0)!);
    }
    return 0; // Put collections without year at the end
  }

  Future<void> _initSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }
}
