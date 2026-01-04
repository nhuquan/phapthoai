import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/audio_repository.dart';
import 'audio_event.dart';
import 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioRepository _repository;
  final AudioPlayer _player;

  AudioBloc(this._repository)
    : _player = AudioPlayer(),
      super(const AudioState()) {
    on<LoadCollections>(_onLoadCollections);
    on<SearchAudio>(_onSearchAudio);
    on<PlayAudio>(_onPlayAudio);

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

      // Sort collections by year extracted from title
      collections.sort((a, b) {
        final yearA = _extractYear(a.title);
        final yearB = _extractYear(b.title);
        return yearA.compareTo(yearB);
      });

      emit(state.copyWith(collections: collections, isLoading: false));
    } catch (e) {
      debugPrint("Error loading data: $e");
      emit(state.copyWith(isLoading: false));
    }
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
      await _player.setUrl(audio.url);
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
    return 9999; // Put collections without year at the end
  }
}
