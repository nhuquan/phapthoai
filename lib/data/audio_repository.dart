import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/audio.dart';

class AudioRepository {
  Future<List<Collection>> loadCollections() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Collection.fromJson(json)).toList();
  }
}
