import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/audio.dart';

class AudioState extends Equatable {
  final List<Collection> collections;
  final List<Audio> searchResults;
  final Audio? currentAudio;
  final bool isLoading;
  final bool isPlaying;
  final String searchQuery;
  final AudioPlayer? player;

  const AudioState({
    this.collections = const [],
    this.searchResults = const [],
    this.currentAudio,
    this.isLoading = true,
    this.isPlaying = false,
    this.searchQuery = '',
    this.player,
  });

  bool get isSearching => searchQuery.isNotEmpty;

  AudioState copyWith({
    List<Collection>? collections,
    List<Audio>? searchResults,
    Audio? currentAudio,
    bool? isLoading,
    bool? isPlaying,
    String? searchQuery,
    AudioPlayer? player,
  }) {
    return AudioState(
      collections: collections ?? this.collections,
      searchResults: searchResults ?? this.searchResults,
      currentAudio: currentAudio ?? this.currentAudio,
      isLoading: isLoading ?? this.isLoading,
      isPlaying: isPlaying ?? this.isPlaying,
      searchQuery: searchQuery ?? this.searchQuery,
      player: player ?? this.player,
    );
  }

  @override
  List<Object?> get props => [
        collections,
        searchResults,
        currentAudio,
        isLoading,
        isPlaying,
        searchQuery,
        player,
      ];
}
