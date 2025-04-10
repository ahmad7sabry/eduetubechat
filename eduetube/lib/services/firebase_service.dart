import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // حفظ الفيديو
  Future<void> saveVideo(
    String title,
    String description,
    String thumbnailUrl,
  ) async {
    try {
      await _db.collection('videos').add({
        'title': title,
        'description': description,
        'thumbnail': thumbnailUrl,
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving video: $e");
    }
  }

  // استرجاع الفيديوهات
  Stream<List<Map<String, dynamic>>> getVideos() {
    return _db
        .collection('videos')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => {
                      'title': doc['title'],
                      'description': doc['description'],
                      'thumbnail': doc['thumbnail'],
                    },
                  )
                  .toList(),
        );
  }
}
