import 'package:flutter/material.dart';
import '../utils/download_helper.dart';

class DownloadButton extends StatefulWidget {
  final String url;

  const DownloadButton({super.key, required this.url});

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool _isDownloaded = false;
  bool _isDownloading = false;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final downloaded = await DownloadHelper.isDownloaded(widget.url);
    if (mounted) {
      setState(() {
        _isDownloaded = downloaded;
      });
    }
  }

  Future<void> _startDownload() async {
    if (_isDownloading || _isDownloaded) return;

    setState(() {
      _isDownloading = true;
      _progress = 0;
    });

    try {
      await DownloadHelper.downloadAudio(
        widget.url,
        onProgress: (received, total) {
          if (total != -1 && mounted) {
            setState(() {
              _progress = received / total;
            });
          }
        },
      );
      if (mounted) {
        setState(() {
          _progress = 1.0; // Force 100% UI
          _isDownloaded = true;
          _isDownloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Download completed')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDownloaded) {
      return IconButton(
        icon: const Icon(Icons.check_circle, color: Colors.green),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File is already downloaded')),
          );
        },
      );
    }

    if (_isDownloading) {
      return SizedBox(
        width: 48,
        height: 48,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircularProgressIndicator(
            value: _progress > 0 ? _progress : null,
            strokeWidth: 2,
          ),
        ),
      );
    }

    return IconButton(
      icon: const Icon(Icons.download_rounded),
      onPressed: _startDownload,
    );
  }
}
