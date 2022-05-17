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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCl_LCjcDrx1d-u3sbFo7pPZ7VsJJaALtI',
    appId: '1:419404396644:web:d5fbfe4c1f8bd880838771',
    messagingSenderId: '419404396644',
    projectId: 'olaz-aebc9',
    authDomain: 'olaz-aebc9.firebaseapp.com',
    storageBucket: 'olaz-aebc9.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8XZqwwnsPT7FWsi9L4iudR1t_rN2LMoY',
    appId: '1:419404396644:android:d39eb321d09064aa838771',
    messagingSenderId: '419404396644',
    projectId: 'olaz-aebc9',
    storageBucket: 'olaz-aebc9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDAo55lVuSh7m82MaWmLPjfy0ILnpHDleQ',
    appId: '1:419404396644:ios:1c799c0243667113838771',
    messagingSenderId: '419404396644',
    projectId: 'olaz-aebc9',
    storageBucket: 'olaz-aebc9.appspot.com',
    iosClientId:
        '419404396644-pavtgqkngffph9aacaa9tg5561acrt0k.apps.googleusercontent.com',
    iosBundleId: 'com.example.olaz',
  );
}
