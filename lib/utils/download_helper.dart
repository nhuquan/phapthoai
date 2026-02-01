import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadHelper {
  static final Dio _dio = Dio();

  static Future<String?> getLocalPath(String url) async {
    if (kIsWeb) return null;
    final directory = await getApplicationDocumentsDirectory();
    final fileName = _getFileName(url);
    return p.join(directory.path, 'downloads', fileName);
  }

  static String _getFileName(String url) {
    // Basic filename extraction, could be improved with hashing if URLs have no clear filename
    // and ensuring valid filename characters
    final base = url.split('/').last.split('?').first;
    // Replace non-alphanumeric (except . and -) with _
    return base.replaceAll(RegExp(r'[^a-zA-Z0-9\.\-]'), '_');
  }

  static Future<bool> isDownloaded(String url) async {
    if (kIsWeb) return false;
    final path = await getLocalPath(url);
    if (path == null) return false;
    return File(path).exists();
  }

  static Future<void> downloadAudio(String url, {Function(int, int)? onProgress}) async {
    if (kIsWeb) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $url');
      }
      return;
    }

    try {
      final path = await getLocalPath(url);
      if (path == null) return;
      final file = File(path);

      if (await file.exists()) {
        debugPrint('File already downloaded at $path');
        return;
      }

      // Ensure directory exists
      await Directory(p.dirname(path)).create(recursive: true);

      await _dio.download(
        url,
        path,
        options: Options(
          headers: {
            "Accept-Encoding": "identity", // Disables compression
          },
        ),
        onReceiveProgress: (received, total) {
          if (onProgress != null) {
            onProgress(received, total);
          }
        },
      );
      debugPrint('Downloaded to $path');
    } catch (e) {
      debugPrint('Download error: $e');
      rethrow;
    }
  }

  static Future<String> getAudioSource(String url) async {
    if (kIsWeb) return url;
    final path = await getLocalPath(url);
    if (path != null && await File(path).exists()) {
      return path;
    }
    return url;
  }
}
