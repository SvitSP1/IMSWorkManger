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
    apiKey: 'AIzaSyC2avdImgYjTlCcoqsFdQ651fQ4OQ3piD8',
    appId: '1:1026107424905:web:236b5f90ab278ec0b90658',
    messagingSenderId: '1026107424905',
    projectId: 'workmanager-bf739',
    authDomain: 'workmanager-bf739.firebaseapp.com',
    databaseURL: 'https://workmanager-bf739-default-rtdb.firebaseio.com',
    storageBucket: 'workmanager-bf739.appspot.com',
    measurementId: 'G-5WGSCME9R6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD3U5_6A_pW4YDo1BMFdog3RmYvJUat9IM',
    appId: '1:1026107424905:android:3902d7fa3737586eb90658',
    messagingSenderId: '1026107424905',
    projectId: 'workmanager-bf739',
    databaseURL: 'https://workmanager-bf739-default-rtdb.firebaseio.com',
    storageBucket: 'workmanager-bf739.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDD8gVytA_jf-J8F0pTCcVOE2OxX2wcuDM',
    appId: '1:1026107424905:ios:c2a466c4fd5df61bb90658',
    messagingSenderId: '1026107424905',
    projectId: 'workmanager-bf739',
    databaseURL: 'https://workmanager-bf739-default-rtdb.firebaseio.com',
    storageBucket: 'workmanager-bf739.appspot.com',
    iosClientId: '1026107424905-8sbgqf6rbp2hj0vk72k4bdi082c0tnn8.apps.googleusercontent.com',
    iosBundleId: 'si.ecas.svit.samardzija.pavletic',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDD8gVytA_jf-J8F0pTCcVOE2OxX2wcuDM',
    appId: '1:1026107424905:ios:6750059cf86725c7b90658',
    messagingSenderId: '1026107424905',
    projectId: 'workmanager-bf739',
    databaseURL: 'https://workmanager-bf739-default-rtdb.firebaseio.com',
    storageBucket: 'workmanager-bf739.appspot.com',
    iosClientId: '1026107424905-3vbrh4jamfh07rsi2g24oqf511u0021e.apps.googleusercontent.com',
    iosBundleId: 'com.example.app.RunnerTests',
  );
}