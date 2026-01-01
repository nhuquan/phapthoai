import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

class DownloadHelper {
  static Future<void> downloadAudio(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      // Launch in external application to trigger browser download or native handling
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }
}
