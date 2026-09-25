// File generated from google-services.json for project: kukulaapp
// This is the equivalent of what `flutterfire configure` would generate.
// DO NOT edit manually — regenerate with: flutterfire configure --project=kukulaapp

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS — '
          'add an iOS app in the Firebase Console and re-run flutterfire configure.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macOS.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  /// Android configuration — values from android/app/google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJ3fb0ew0X-hvPk8SjekqUcaGCPpyf6F8',
    appId: '1:250799045357:android:53f5ea75154d896186aae4',
    messagingSenderId: '250799045357',
    projectId: 'kukulaapp',
    storageBucket: 'kukulaapp.firebasestorage.app',
  );

  /// Web configuration — used for Flutter Web builds
  /// (requires adding a Web app in Firebase Console and copying its config here)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDJ3fb0ew0X-hvPk8SjekqUcaGCPpyf6F8',
    appId: '1:250799045357:android:53f5ea75154d896186aae4', // update with web appId from Firebase Console
    messagingSenderId: '250799045357',
    projectId: 'kukulaapp',
    storageBucket: 'kukulaapp.firebasestorage.app',
    // authDomain: 'kukulaapp.firebaseapp.com', // uncomment when web app is added
  );
}
