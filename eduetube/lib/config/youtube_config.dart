class YouTubeConfig {
  // TODO: Replace with your actual YouTube API key
  static const String apiKey = 'YOUR_YOUTUBE_API_KEY';

  // YouTube API configuration
  static const int maxResults = 10;
  static const String region = 'US';
  static const String relevanceLanguage = 'en';

  // Cache configuration
  static const Duration cacheDuration = Duration(hours: 24);

  // Other YouTube specific configurations can be added here
  static const Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
  };
}
