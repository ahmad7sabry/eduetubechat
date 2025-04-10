import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/constants/firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with configuration
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: DefaultFirebaseOptions.firebaseConfig['apiKey']!,
      appId: DefaultFirebaseOptions.firebaseConfig['appId']!,
      messagingSenderId:
          DefaultFirebaseOptions.firebaseConfig['messagingSenderId']!,
      projectId: DefaultFirebaseOptions.firebaseConfig['projectId']!,
      authDomain: DefaultFirebaseOptions.firebaseConfig['authDomain'],
      storageBucket: DefaultFirebaseOptions.firebaseConfig['storageBucket'],
    ),
  );

  runApp(const EduTubeApp());
}
