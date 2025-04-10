import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edutube/services/firestore_service.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Eduetube', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestoreService.getVideos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final videos = snapshot.data ?? [];

          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return Card(
                margin: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      video['thumbnail'],
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    video['title'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(video['description']),
                  trailing: Icon(
                    Icons.play_circle_fill,
                    color: Colors.deepPurple,
                  ),
                  onTap: () {
                    // هنا نروح لصفحة الفيديو
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
