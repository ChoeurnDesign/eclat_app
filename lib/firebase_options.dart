import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform. android:
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
    apiKey: 'AIzaSyDcJy0HcrmCwKFphnuL3qZ-SNvZrw8ZdUk',  // ✅ Your new project
    authDomain: 'e-commerce-store-1d35c.firebaseapp.com',
    projectId: 'e-commerce-store-1d35c',  // ✅ This determines which database
    storageBucket: 'e-commerce-store-1d35c.firebasestorage.app',
    messagingSenderId: '18381925114',
    appId: '1:18381925114:web:07a7a626662f6292c43743',
    measurementId: 'G-FLX9N6KW2D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDcJy0HcrmCwKFphnuL3qZ-SNvZrw8ZdUk',
    appId: '1:18381925114:android: ANDROID_APP_ID',  // Update when you add Android app
    messagingSenderId: '18381925114',
    projectId: 'e-commerce-store-1d35c',
    storageBucket: 'e-commerce-store-1d35c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey:  'AIzaSyDcJy0HcrmCwKFphnuL3qZ-SNvZrw8ZdUk',
    appId: '1:18381925114:ios:IOS_APP_ID',  // Update when you add iOS app
    messagingSenderId: '18381925114',
    projectId: 'e-commerce-store-1d35c',
    storageBucket: 'e-commerce-store-1d35c.firebasestorage.app',
    iosBundleId: 'com.eclat.app',
  );
}