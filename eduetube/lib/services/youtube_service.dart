import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  final String _apiKey;
  final String _baseUrl = 'https://www.googleapis.com/youtube/v3';

  YouTubeService(this._apiKey);

  Future<Map<String, dynamic>> getVideoDetails(String videoId) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/videos?part=snippet,contentDetails&id=$videoId&key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load video details');
    }
  }

  Future<Map<String, dynamic>> searchVideos(String query,
      {String? pageToken}) async {
    final url =
        '$_baseUrl/search?part=snippet&q=$query&type=video&maxResults=10'
        '&key=$_apiKey${pageToken != null ? '&pageToken=$pageToken' : ''}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to search videos');
    }
  }

  Future<Map<String, dynamic>> getPlaylistItems(String playlistId,
      {String? pageToken}) async {
    final url = '$_baseUrl/playlistItems?part=snippet&playlistId=$playlistId'
        '&maxResults=10&key=$_apiKey${pageToken != null ? '&pageToken=$pageToken' : ''}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load playlist items');
    }
  }

  String getVideoThumbnail(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
  }
}
