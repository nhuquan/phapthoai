import 'package:equatable/equatable.dart';
import '../../models/audio.dart';

abstract class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object> get props => [];
}

class LoadCollections extends AudioEvent {}

class SearchAudio extends AudioEvent {
  final String query;

  const SearchAudio(this.query);

  @override
  List<Object> get props => [query];
}

class SetSearchFocus extends AudioEvent {
  final bool isFocused;

  const SetSearchFocus(this.isFocused);

  @override
  List<Object> get props => [isFocused];
}

class PlayAudio extends AudioEvent {
  final Audio audio;

  const PlayAudio(this.audio);

  @override
  List<Object> get props => [audio];
}

class StopAudio extends AudioEvent {}

class ToggleDownloadedFilter extends AudioEvent {}

class ToggleFavorite extends AudioEvent {
  final Collection collection;

  const ToggleFavorite(this.collection);

  @override
  List<Object> get props => [collection];
}

class DeleteDownloadedAudio extends AudioEvent {
  final Audio audio;

  const DeleteDownloadedAudio(this.audio);

  @override
  List<Object> get props => [audio];
}
