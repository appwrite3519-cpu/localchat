import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushService {
  Future<void> registerToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseMessaging.instance.requestPermission();
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
      {
        'fcmToken': token,
        'fcmUpdatedAt': DateTime.now().toIso8601String(),
      },
      SetOptions(merge: true),
    );
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
