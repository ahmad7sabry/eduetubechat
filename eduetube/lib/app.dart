import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/home/pages/home_page.dart';
import 'services/youtube_service.dart';
import 'services/firestore_service.dart';
import 'providers/app_state.dart';
import 'providers/course_provider.dart';
import 'providers/youtube_provider.dart';
import 'config/youtube_config.dart';

class EduTubeApp extends StatelessWidget {
  const EduTubeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        Provider<YouTubeService>(
          create: (_) => YouTubeService(YouTubeConfig.apiKey),
        ),
        ChangeNotifierProxyProvider<YouTubeService, YouTubeProvider>(
          create: (context) => YouTubeProvider(context.read<YouTubeService>()),
          update: (context, service, previous) =>
              previous ?? YouTubeProvider(service),
        ),
      ],
      child: MaterialApp(
        title: 'EduTube',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'Roboto',
        ),
        home: const HomePage(),
      ),
    );
  }
}
