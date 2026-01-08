import 'package:flutter/material.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

class OfflinePlayerScreen extends StatelessWidget {
  final String mediaId;
  final String title;

  const OfflinePlayerScreen({
    Key? key,
    required this.mediaId,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final embedInfo = EmbedInfo.offline(mediaId: mediaId);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: VdoPlayer(
        embedInfo: embedInfo,
        // Required parameter – we must provide it
        onPlayerCreated: (controller) {
          // You can add custom controls here if needed later
          // For now, just leave it empty – it's required by the SDK
        },
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Playback error: ${error.message}'),
              backgroundColor: Colors.red,
            ),
          );
        },
        onFullscreenChange: (isFullscreen) {
          // Optional: handle fullscreen/orientation changes if needed
        },
      ),
    );
  }
}