// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA6euWve9S-b2RMCffTi8ekXC6DAIgI0ec',
    appId: '1:696117339005:web:4c6a75210f59877a082214',
    messagingSenderId: '696117339005',
    projectId: 'instagramclone-59eda',
    authDomain: 'instagramclone-59eda.firebaseapp.com',
    storageBucket: 'instagramclone-59eda.appspot.com',
    measurementId: 'G-Q9HQMKT9DT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyARP8mtnYgkRZge_qzeqpcqizor6huXpmM',
    appId: '1:696117339005:android:13e63a86c0a7258e082214',
    messagingSenderId: '696117339005',
    projectId: 'instagramclone-59eda',
    storageBucket: 'instagramclone-59eda.appspot.com',
  );
}