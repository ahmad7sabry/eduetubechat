import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:provider/provider.dart';
import '../../../providers/youtube_provider.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoId;

  const VideoPlayerPage({Key? key, required this.videoId}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        setState(() {
          _isFullScreen = true;
        });
      },
      onExitFullScreen: () {
        setState(() {
          _isFullScreen = false;
        });
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.deepPurple,
        progressColors: const ProgressBarColors(
          playedColor: Colors.deepPurple,
          handleColor: Colors.deepPurpleAccent,
        ),
        onReady: () {
          _controller.addListener(() {
            if (_controller.value.isReady) {
              // You can add additional video ready logic here
            }
          });
        },
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: _isFullScreen
              ? null
              : AppBar(
                  backgroundColor: Colors.deepPurple,
                  title: const Text('Video Player'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.fullscreen),
                      onPressed: () {
                        _controller.toggleFullScreenMode();
                      },
                    ),
                  ],
                ),
          body: Column(
            children: [
              player,
              if (!_isFullScreen) ...[
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Consumer<YouTubeProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final videoDetails = provider.currentVideo;
                        if (videoDetails == null) {
                          return const Center(
                            child: Text('No video details available'),
                          );
                        }

                        final snippet = videoDetails['items']?[0]?['snippet'];
                        if (snippet == null) {
                          return const Center(
                            child: Text('Video information not available'),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snippet['title'] ?? 'Untitled',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              snippet['description'] ??
                                  'No description available',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
