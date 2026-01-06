import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:http/http.dart' as http;
import '../models/audio.dart';

class AudioRepository {
  Future<List<Collection>> loadCollections() async {
    try {
      final String response = await rootBundle.loadString('assets/data.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Collection.fromJson(json)).toList();
    } catch (e) {
      if (kIsWeb) {
        // Fallback for Web: try fetching from possible paths due to build artifact structure
        // The build/web/assets directory often nests assets, e.g. assets/assets/data.json
        try {
          // Try the doubled path first which we found to exist
          final response = await http.get(Uri.parse('assets/assets/data.json'));
          if (response.statusCode == 200) {
            final List<dynamic> data = json.decode(response.body);
            return data.map((json) => Collection.fromJson(json)).toList();
          }
           
           // Try the standard path just in case
           final responseStandard = await http.get(Uri.parse('assets/data.json'));
           if (responseStandard.statusCode == 200) {
             final List<dynamic> data = json.decode(responseStandard.body);
             return data.map((json) => Collection.fromJson(json)).toList();
           }

        } catch (webError) {
          debugPrint('Web fallback failed: $webError');
        }
      }
      rethrow;
    }
  }
}
