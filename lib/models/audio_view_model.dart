import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../data/audio_repository.dart';
import '../models/audio.dart';

class AudioViewModel extends ChangeNotifier {
  final AudioRepository _repository;
  final AudioPlayer _player = AudioPlayer();
  
  List<Collection> _collections = [];
  Audio? _currentAudio;
  bool _isLoading = true;

  AudioViewModel(this._repository) {
    _loadData();
  }

  List<Collection> get collections => _collections;
  Audio? get currentAudio => _currentAudio;
  bool get isLoading => _isLoading;
  AudioPlayer get player => _player;

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
