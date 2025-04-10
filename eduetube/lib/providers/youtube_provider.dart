import 'package:flutter/material.dart';
import '../services/youtube_service.dart';

class YouTubeProvider extends ChangeNotifier {
  final YouTubeService _youTubeService;
  Map<String, dynamic>? _currentVideo;
  List<Map<String, dynamic>> _searchResults = [];
  String? _nextPageToken;
  bool _isLoading = false;
  String _lastSearchQuery = '';

  YouTubeProvider(this._youTubeService);

  Map<String, dynamic>? get currentVideo => _currentVideo;
  List<Map<String, dynamic>> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get hasMoreResults => _nextPageToken != null;

  Future<void> searchVideos(String query, {bool reset = true}) async {
    if (reset) {
      _searchResults = [];
      _nextPageToken = null;
    }

    if (query.isEmpty) return;

    _isLoading = true;
    _lastSearchQuery = query;
    notifyListeners();

    try {
      final result = await _youTubeService.searchVideos(
        query,
        pageToken: reset ? null : _nextPageToken,
      );

      final items = result['items'] as List;
      _nextPageToken = result['nextPageToken'];

      if (reset) {
        _searchResults =
            items.map((item) => item as Map<String, dynamic>).toList();
      } else {
        _searchResults
            .addAll(items.map((item) => item as Map<String, dynamic>));
      }
    } catch (e) {
      print('Error searching videos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreResults() async {
    if (!_isLoading && _nextPageToken != null) {
      await searchVideos(_lastSearchQuery, reset: false);
    }
  }

  Future<void> getVideoDetails(String videoId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentVideo = await _youTubeService.getVideoDetails(videoId);
    } catch (e) {
      print('Error getting video details: $e');
      _currentVideo = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  String getVideoThumbnail(String videoId) {
    return _youTubeService.getVideoThumbnail(videoId);
  }
}
