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
    apiKey: 'AIzaSyDaeZcUZkuRwuL0bb6fjS6O8a-hOwN4Ce4',
    appId: '1:559144906386:web:e6fa4e6f7c19a09917804b',
    messagingSenderId: '559144906386',
    projectId: 'fine-web-383717',
    authDomain: 'fine-web-383717.firebaseapp.com',
    storageBucket: 'fine-web-383717.appspot.com',
    measurementId: 'G-K1Z9N66JRT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCipYoHlR3GQ4ElkLCvZZygYYttzgYbFko',
    appId: '1:559144906386:android:8f3376d4cf042c0817804b',
    messagingSenderId: '559144906386',
    projectId: 'fine-web-383717',
    storageBucket: 'fine-web-383717.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA55ieyebMlKU0X-z3koJsnkXLS1FQ8HEw',
    appId: '1:559144906386:ios:1d1fecb1fb8bd10e17804b',
    messagingSenderId: '559144906386',
    projectId: 'fine-web-383717',
    storageBucket: 'fine-web-383717.appspot.com',
    iosBundleId: 'com.example.firebasechatapplatest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA55ieyebMlKU0X-z3koJsnkXLS1FQ8HEw',
    appId: '1:559144906386:ios:1d1fecb1fb8bd10e17804b',
    messagingSenderId: '559144906386',
    projectId: 'fine-web-383717',
    storageBucket: 'fine-web-383717.appspot.com',
    iosBundleId: 'com.example.firebasechatapplatest',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDaeZcUZkuRwuL0bb6fjS6O8a-hOwN4Ce4',
    appId: '1:559144906386:web:8a015c60e35041b817804b',
    messagingSenderId: '559144906386',
    projectId: 'fine-web-383717',
    authDomain: 'fine-web-383717.firebaseapp.com',
    storageBucket: 'fine-web-383717.appspot.com',
    measurementId: 'G-K0D09JG8ZG',
  );
}
