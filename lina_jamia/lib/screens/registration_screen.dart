import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../widgets/my_button.dart';
import '../widgets/validations.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  late String nid;
  late String name;
  late String userName;
  late String bd;
  late String phone;
  late String email;
  late String password;
  late String conpassword;

  //bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    Validations validations = Validations();
    return Scaffold(
      /*appBar: AppBar(
        title: const Text('جـمـعـيـة '),
        centerTitle: true,
        backgroundColor: Colors.grey,
        leading: Image.asset('images/logo.png'),
      ),*/
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30),
                const Text(
                  "حياك في  ",
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 84, 87, 86),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                const Text(
                  "جـمـعـيـة  ",
                  style: TextStyle(
                      fontSize: 35,
                      color: Color(0xFF393737),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "تفضل بإنشاء حساب جديد لك",
                  style: TextStyle(
                      fontSize: 25,
                      color: Color(0xFF393737),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),

//1-National ID:
                TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,

                  // The validator receives the text that the user has entered.
                  validator: (value) => validations.validate(5, value!),
                  onChanged: (value) {
                    nid = value;
                  },
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.fingerprint),
                    hintText: 'ادخل رقم هويتك الوطنية',
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
                SizedBox(height: 8),
//2-Full Name:
                TextFormField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.right,

                  // The validator receives the text that the user has entered.
                  validator: (value) => validations.validate(3, value!),
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.person),
                    hintText: 'ادخل اسمك الكامل',
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
                SizedBox(height: 8),
//3-user name:
                TextFormField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.right,

                  // The validator receives the text that the user has entered.
                  validator: (value) => validations.validate(7, value!),
                  onChanged: (value) {
                    userName = value;
                  },
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.person_outline),
                    hintText: 'ادخل اسم المستخدم',
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
                        color: Color.fromARGB(255, 26, 110, 29),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
//4-birth date:
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  textAlign: TextAlign.right,
                  //readOnly: true,
                  // The validator receives the text that the user has entered.
                  /* onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            1900), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2040));
                    final DateFormat formatter = DateFormat("dd/MM/YYYY");
                    bd = formatter.format(pickedDate!).toString();
                  },*/
                  validator: (value) => validations.validate(0, value!),
                  onChanged: (value) {
                    bd = value;
                  },
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.calendar_month),
                    hintText: 'ادخل تاريخ ميلادك',
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
                SizedBox(height: 8),
//5-phone number:
                TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,

                  // The validator receives the text that the user has entered.
                  validator: (value) => validations.validate(4, value!),
                  onChanged: (value) {
                    phone = value;
                  },
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.phone),
                    hintText: 'ادخل رقم جوالك',
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
                SizedBox(height: 8),
//6-Email
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.right,

                  // The validator receives the text that the user has entered.
                  validator: (value) => validations.validate(1, value!),
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.email),
                    hintText: 'ادخل بريدك الالكتروني',
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
                SizedBox(height: 8),

//7-password
                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  textAlign: TextAlign.right,
                  // The validator receives the text that the user has entered.
                  validator: (value) => validations.validate(2, value!),
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: const InputDecoration(
                    //labelText: "كلمة المرور" ,
                    hintText: 'ادخل كلمة المرور',
                    suffixIcon: Icon(Icons.lock),
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
                SizedBox(height: 8),
//7-confirm password
                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  textAlign: TextAlign.right,
                  // The validator receives the text that the user has entered.
                  validator: (value) => validations.validate(6, value!),
                  onChanged: (value) {
                    conpassword = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'اعد ادخال كلمة المرور للتاكيد',
                    suffixIcon: Icon(Icons.lock_reset),
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

                SizedBox(height: 10),

                MyButton(
                  color: Colors.green,
                  title: 'الـتـسـجـيـل',
                  onPressed: () async {
                    EasyLoading.show(status: 'تحميل ...');
                    String _message = '';
                    if (_formKey.currentState!.validate()) {
                      try {
                        await _auth
                            .createUserWithEmailAndPassword(
                                email: email, password: password)
                            .then(
                          (userCred) async {
                            /// SUCCESS : now get the uid of the user and add user detail in firestore
                            /// status - 0=un-blocked- 1=blocked
                            String? _fcmToken =
                                await FirebaseMessaging.instance.getToken();
                            await _firestore.collection('users').doc(userName)
                                //.doc(userCred.user!.uid)
                                .set({
                              'NID': nid,
                              'Name': name,
                              'userName': userName,
                              'birthDate': bd,
                              'PhoneNO': phone,
                              'Email': email,
                              'Password': password,
                              'rate': "5",
                              'photo': "",
                              'status': 0,
                              'doc': DateTime.now(),
                            });
                            EasyLoading.dismiss();
                            //await getUserInfo(userCred.user!);
                          },
                        );
                        //move the auth user to the home page(our App) and we should have import for it.
                        Navigator.pushNamed(context, '/home');
                      } on FirebaseAuthException catch (e) {
                        switch (e.code) {
                          case "email-already-in-use":
                            _message = 'البريد الإلكتروني مستخدم مسبقًا';
                            break;
                          case "invalid-email":
                            _message = 'البريد الإلكتروني غير صالح';
                            break;
                          case "too-many-requests":
                            _message =
                                'يجب على المستخدم إعادة المصادقة قبل تنفيذ هذه العملية';
                            break;
                          case "operation-not-allowed":
                            _message =
                                'يجب على المستخدم إعادة المصادقة قبل تنفيذ هذه العملية';
                            break;
                          case "network-request-failed":
                            _message =
                                'يجب على المستخدم إعادة الاتصال بالشبكة قبل تنفيذ هذه العملية';
                            break;
                          case "credential-already-in-use":
                            _message =
                                'بيانات الاعتماد هذه مرتبطة بالفعل بحساب مستخدم مختلف';
                            break;
                          default:
                            _message = 'حدث خطأ ما ، أعد المحاولة من فضلك';
                            break;
                        }
                        EasyLoading.dismiss();
                        EasyLoading.showError(_message);
                      }
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: const Text(
                        'تفضل بالدخول',
                        style: TextStyle(fontSize: 15, color: Colors.green),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                    const Text('لديك حساب؟'),
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
