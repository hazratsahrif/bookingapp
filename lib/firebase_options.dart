// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBnGfGpbykRg-5zXxQnAWAb7zPfiBrblxo',
    appId: '1:646101671159:android:d3a73afae7d807ffa287f2',
    messagingSenderId: '646101671159',
    projectId: 'tutu-3a269',
    databaseURL: 'https://tutu-3a269-default-rtdb.firebaseio.com',
    storageBucket: 'tutu-3a269.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBzjqgwSpXp0lfgAoPbrd-AFBwY4DgdJls',
    appId: '1:646101671159:ios:f6939fb300449ba3a287f2',
    messagingSenderId: '646101671159',
    projectId: 'tutu-3a269',
    databaseURL: 'https://tutu-3a269-default-rtdb.firebaseio.com',
    storageBucket: 'tutu-3a269.appspot.com',
    androidClientId: '646101671159-7slq9ikcsa689e2gt20ru26qvaedkkdq.apps.googleusercontent.com',
    iosClientId: '646101671159-bguepp66p64md9h67j9v45eu9vphcdgl.apps.googleusercontent.com',
    iosBundleId: 'com.codearix.t2',
  );
}
