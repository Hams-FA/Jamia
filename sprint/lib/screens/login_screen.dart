import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
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
                  height: 300,
                ),
                const Text(
                  " مرحباً بك في تطبيق جمعية",
                  style: TextStyle(
                      fontSize: 35,
                      color: Color(0xFF393737),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
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
                const SizedBox(height: 4),
                MyButton(
                  color: Colors.green,
                  title: 'تسجيل الدخول',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      EasyLoading.show(status: 'يتم تسجيل دخولك');
                      var allowed = true;
                      var data = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(email)
                          .get();
                      if (data.data()?['status'] == 1) {
                        allowed = false;
                      }
                      if (allowed) {
                        try {
                          final credential =
                              await _auth.signInWithEmailAndPassword(
                                  email: email, password: password);
                          if (mounted) {
                            Navigator.pushNamed(context, '/NewHome');
                          }
                          EasyLoading.dismiss();
                        } on FirebaseAuthException catch (e) {
                          //we're not listing the errors to the user with an exact
                          //and detailed message, because an attacker could take an
                          //advantage and may succeed to impersonate the user.
                          //it's a security best practice to give the user a general
                          //message.
                          print(e);
                          print(e.toString());
                          if (e.code == 'user-not-found') {
                            EasyLoading.showError('الحساب غير موجود');
                          } else {
                            EasyLoading.showError(
                                'اسم المستخدم/كملة المرور خاطئة');
                          }
                        }
                      } else {
                        EasyLoading.showSuccess(
                            'تم ايقاف حسابك الرجاء التواصل معنا');
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: const Text(
                        'تواصل معنا ',
                        style: TextStyle(fontSize: 15, color: Colors.green),
                      ),
                      onPressed: () async {
                        String email = "Admin2022@gmail.com";
                        String subject = "استفسار عن عملية تسجيل الدخول";
                        String body = "تفضل اكتب استفسارك هنا !!";

                        String? encodeQueryParameters(
                            Map<String, String> params) {
                          return params.entries
                              .map((MapEntry<String, String> e) =>
                                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                              .join('&');
                        }

                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: email,
                          query: encodeQueryParameters(<String, String>{
                            'subject': subject,
                            'body': body
                          }),
                        );
                        if (await canLaunch(emailLaunchUri.toString())) {
                          launchUrl(emailLaunchUri);
                        } else {
                          print("The action is not support NO Email App!");
                        }
                      },
                    ),
                    const Text('هل واجهتك مشكلة في عملية تسجيل الدخول؟'),
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
