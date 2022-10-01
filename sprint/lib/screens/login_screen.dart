import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../widgets/my_button.dart';
import '../widgets/validations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    Validations validations = Validations();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Image.asset('images/logo.jpg'),
                  width: 350,
                  height: 350,
                ),
                const Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                      fontSize: 35,
                      color: Color(0xFF393737),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => validations.validate(1, value!),
                    onChanged: (value) {
                      email = value.toLowerCase();
                    },
                    decoration: const InputDecoration(
                      hintText: 'ادخل بريدك الالكتروني',
                      prefixIcon: Icon(Icons.email),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    // The validator receives the text that the user has entered.
                    validator: (value) => validations.validate(8, value!),
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'ادخل كلمة المرور',
                      prefixIcon: Icon(Icons.lock),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text(
                        'نسيت كلمة المرور؟',
                        style: TextStyle(fontSize: 15, color: Colors.green),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgotPassword');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                MyButton(
                  color: Colors.green,
                  title: 'تسجيل الدخول',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      EasyLoading.show(status: 'يتم تسجيل دخولك');
                      try {
                        final credential =
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                        if (mounted) {
                          Navigator.pushNamed(context, '/home');
                        }
                        EasyLoading.dismiss();
                      } on FirebaseAuthException catch (e) {
                        //we're not listing the errors to the user with an exact
                        //and detailed message, because an attacker could take an
                        //advantage and may succeed to impersonate the user.
                        //it's a security best practice to give the user a general
                        //message.
                        EasyLoading.showError('اسم المستخدم/كملة المرور خاطئة');
                        //in case you need detailed/firebase error messages
                        //uncomment the below code line-162 and comment line 159
                        // EasyLoading.showError(e.toString());
                      }
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: const Text(
                        'سجل معنا الان',
                        style: TextStyle(fontSize: 15, color: Colors.green),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/registration');
                      },
                    ),
                    const Text('مستخدم جديد؟'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
