import 'package:flutter/material.dart';
import 'package:sprint/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'inviteFriends.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'invite friends', //
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: inviteFriends(),
    );
  }
}
