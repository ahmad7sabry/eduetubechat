import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getVideos() {
    return _firestore.collection('videos').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'] ?? '',
          'description': data['description'] ?? '',
          'thumbnail': data['thumbnail'] ?? '',
          'videoUrl': data['videoUrl'] ?? '',
          'courseId': data['courseId'] ?? '',
        };
      }).toList();
    });
  }

  Future<void> addVideo({
    required String title,
    required String description,
    required String thumbnail,
    required String videoUrl,
    required String courseId,
  }) async {
    await _firestore.collection('videos').add({
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'videoUrl': videoUrl,
      'courseId': courseId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
