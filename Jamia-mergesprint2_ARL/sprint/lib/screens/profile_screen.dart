import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../widgets/my_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
