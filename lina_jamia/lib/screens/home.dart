import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../widgets/my_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MyButton(
          color: Colors.green,
          title: 'تسجيل الخروج',
          onPressed: () async {
            try {
              await _auth.signOut();
              if (mounted) {
                Navigator.pushNamed(context, '/login');
              }
            } on FirebaseAuthException catch (e) {
              EasyLoading.showError('حدث خطأ، الرجاء المحاولة مرة اخرى');
            }
          },
        ),
      ),
    );
  }
}
