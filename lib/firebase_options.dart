import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCF-Zp45ZYd-kJTfGogIXg-0yLcTRfcblo',
    appId: '1:301348760105:web:db72abaa7b5dab9b978a38',
    messagingSenderId: '301348760105',
    projectId: 'mindly-461bb',
    authDomain: 'mindly-461bb.firebaseapp.com',
    storageBucket: 'mindly-461bb.firebasestorage.app',
    measurementId: 'G-6VCKN4Q2DP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZlJFTjYFgakzUVYTcUrNJ3GviJkvyibU',
    appId: '1:301348760105:android:b03aaa9566891ae1978a38',
    messagingSenderId: '301348760105',
    projectId: 'mindly-461bb',
    storageBucket: 'mindly-461bb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZlJFTjYFgakzUVYTcUrNJ3GviJkvyibU',
    appId: '1:301348760105:ios:your_ios_app_id', // Replace with iOS App ID if needed
    messagingSenderId: '301348760105',
    projectId: 'mindly-461bb',
    storageBucket: 'mindly-461bb.firebasestorage.app',
    iosBundleId: 'com.example.mindly',
  );
}
