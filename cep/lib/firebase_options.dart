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
    apiKey: 'AIzaSyBPm0e0xeWD0xIeCEk-ebkPkzgmb1VgBm8',
    appId: '1:391449773374:web:c76e366ebb1759aae7d86f',
    messagingSenderId: '391449773374',
    projectId: 'health-278cd',
    authDomain: 'health-278cd.firebaseapp.com',
    storageBucket: 'health-278cd.appspot.com',
    measurementId: 'G-Y2S9L82MTQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVt9WNCGkihZzS2utvrNw2jPvDL3nkNN8',
    appId: '1:391449773374:android:afff36d9f7686f12e7d86f',
    messagingSenderId: '391449773374',
    projectId: 'health-278cd',
    storageBucket: 'health-278cd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCTfdPM_5qHWI-CPIhg9ZToSCkziWzcb5o',
    appId: '1:391449773374:ios:e972f64ead2915c3e7d86f',
    messagingSenderId: '391449773374',
    projectId: 'health-278cd',
    storageBucket: 'health-278cd.appspot.com',
    iosBundleId: 'com.example.cep',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCTfdPM_5qHWI-CPIhg9ZToSCkziWzcb5o',
    appId: '1:391449773374:ios:e972f64ead2915c3e7d86f',
    messagingSenderId: '391449773374',
    projectId: 'health-278cd',
    storageBucket: 'health-278cd.appspot.com',
    iosBundleId: 'com.example.cep',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBPm0e0xeWD0xIeCEk-ebkPkzgmb1VgBm8',
    appId: '1:391449773374:web:bcd695f9a45433a7e7d86f',
    messagingSenderId: '391449773374',
    projectId: 'health-278cd',
    authDomain: 'health-278cd.firebaseapp.com',
    storageBucket: 'health-278cd.appspot.com',
    measurementId: 'G-TFVZZ0LGZQ',
  );
}
