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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBNdHMRllTjYSob0s6VCmIkkK-F0AlCmVs',
    appId: '1:262730909398:web:8dcc0dff4f6eb459882b77',
    messagingSenderId: '262730909398',
    projectId: 'contact--application',
    authDomain: 'contact--application.firebaseapp.com',
    storageBucket: 'contact--application.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrAFIKib5fNaCpsIhpWYb5ge8TXWcwxiE',
    appId: '1:262730909398:android:4212c932f67c5c18882b77',
    messagingSenderId: '262730909398',
    projectId: 'contact--application',
    storageBucket: 'contact--application.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBG5bfllWtDoGUi108KVcgm8GVBoD1I0WM',
    appId: '1:262730909398:ios:cca30d84af8da7db882b77',
    messagingSenderId: '262730909398',
    projectId: 'contact--application',
    storageBucket: 'contact--application.firebasestorage.app',
    iosBundleId: 'com.example.contactApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBG5bfllWtDoGUi108KVcgm8GVBoD1I0WM',
    appId: '1:262730909398:ios:cca30d84af8da7db882b77',
    messagingSenderId: '262730909398',
    projectId: 'contact--application',
    storageBucket: 'contact--application.firebasestorage.app',
    iosBundleId: 'com.example.contactApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBNdHMRllTjYSob0s6VCmIkkK-F0AlCmVs',
    appId: '1:262730909398:web:220526b77ff6520e882b77',
    messagingSenderId: '262730909398',
    projectId: 'contact--application',
    authDomain: 'contact--application.firebaseapp.com',
    storageBucket: 'contact--application.firebasestorage.app',
  );
}
