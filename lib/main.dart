import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/db/local_store.dart';
import 'core/messaging/chat_service.dart';
import 'core/notifications/push_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await LocalStore.instance.init();

  final chat = ChatService(
    LocalStore.instance,
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );
  chat.startWorkers();

  runApp(
    ProviderScope(
      overrides: [
        chatServiceProvider.overrideWithValue(chat),
      ],
      child: const LocalChatApp(),
    ),
  );
}
