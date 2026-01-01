import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../data/audio_repository.dart';
import '../models/audio.dart';

class AudioViewModel extends ChangeNotifier {
  final AudioRepository _repository;
  final AudioPlayer _player = AudioPlayer();
  
  List<Collection> _collections = [];
  List<Audio> _searchResults = [];
  Audio? _currentAudio;
  bool _isLoading = true;
  String _searchQuery = '';

  AudioViewModel(this._repository) {
    _loadData();
  }

  List<Collection> get collections => _collections;
  List<Audio> get searchResults => _searchResults;
  Audio? get currentAudio => _currentAudio;
  bool get isLoading => _isLoading;
  bool get isSearching => _searchQuery.isNotEmpty;
  AudioPlayer get player => _player;

  void search(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      _searchResults = [];
    } else {
      final allAudios = _collections.expand((c) => c.audios);
      _searchResults = allAudios.where((audio) {
        final title = audio.title.toLowerCase();
        final date = audio.date?.toLowerCase() ?? '';
        return title.contains(_searchQuery) || date.contains(_searchQuery);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> _loadData() async {
    try {
      _collections = await _repository.loadCollections();
    } catch (e) {
      debugPrint("Error loading data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> playAudio(Audio audio) async {
    _currentAudio = audio;
    notifyListeners();
    try {
      await _player.setUrl(audio.url);
      await _player.play();
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
