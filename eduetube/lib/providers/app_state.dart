import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _userId;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setAuthenticated(bool value, {String? userId}) {
    _isAuthenticated = value;
    _userId = userId;
    notifyListeners();
  }
}
