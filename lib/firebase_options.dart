import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => android;

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBlGoVvz9FUK2otr8pe9ins_YX7SGHeJT4',
    appId: '1:731061753459:android:99630b3dc6d4292f5dbc06',
    messagingSenderId: '731061753459',
    projectId: 'salesman-74602',
    storageBucket: 'salesman-74602.firebasestorage.app',
  );
}
