import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _courses = [];
  bool _isLoading = false;
  String? _selectedCourseId;

  List<Map<String, dynamic>> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get selectedCourseId => _selectedCourseId;

  Future<void> fetchCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore.collection('courses').get();
      _courses = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'] ?? '',
          'description': data['description'] ?? '',
          'thumbnail': data['thumbnail'] ?? '',
          'instructor': data['instructor'] ?? '',
        };
      }).toList();
    } catch (e) {
      print('Error fetching courses: $e');
      _courses = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectCourse(String courseId) {
    _selectedCourseId = courseId;
    notifyListeners();
  }

  Future<void> addCourse({
    required String title,
    required String description,
    required String thumbnail,
    required String instructor,
  }) async {
    try {
      await _firestore.collection('courses').add({
        'title': title,
        'description': description,
        'thumbnail': thumbnail,
        'instructor': instructor,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await fetchCourses(); // Refresh the courses list
    } catch (e) {
      print('Error adding course: $e');
      throw e;
    }
  }
}
