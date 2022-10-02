import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/my_button.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:line_icons/line_icons.dart';
import '../widgets/validations.dart';
import 'package:intl/intl.dart';
import 'package:intl/src/intl/text_direction.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart' as intl;
import 'package:date_time_picker/date_time_picker.dart';

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
  late String f_name;
  late String l_name;
  late String bd;
  late String phone;
  late String email;
  late String password;
  late String conpassword;
  DateTime date = DateTime.now();
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
                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    //textDirection: TextDirection.rtl,
                    // The validator receives the text that the user has entered.
                    validator: (value) => validations.validate(5, value!),
                    onChanged: (value) {
                      nid = value.trim();
                    },
                    maxLength: 10,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.fingerprint),
                      hintText: 'رقم الهوية الوطنية مكون من 10 ارقام',
                      labelText: 'ادخل رقم هويتك الوطنية',
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
                SizedBox(height: 8),
//2-First Name:
                Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.right,

                      // The validator receives the text that the user has entered.
                      validator: (value) =>
                          validations.validate(3, value!.toString()),
                      onChanged: (value) {
                        f_name = value.trim();
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'ادخل اسمك الاول',
                        hintText: 'يجب ان يحتوي اسمك الاول على حرفين على الاقل',
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
                    )),
                SizedBox(height: 8),
//3-user name:
                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: TextFormField(
                    //keyboardType: TextInputType.name,
                    textAlign: TextAlign.right,

                    // The validator receives the text that the user has entered.
                    validator: (value) =>
                        validations.validate(3, value!.toString()),
                    onChanged: (value) {
                      l_name = value.trim();
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.people),
                      labelText: 'ادخل اسم العائلة',
                      hintText: 'يجب ان يحتوي اسم عائلتك على حرفين على الاقل',
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
                ),
                SizedBox(height: 8),
//4-birth date:

                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,

                    // The validator receives the text that the user has entered.
                    validator: (value) => validations.validate(0, value!),
                    onChanged: (value) {
                      bd = value.trim();
                    },
                    maxLength: 3,

                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_month),
                      labelText: 'ادخل عمرك',
                      hintText: 'يجب ان يحتوي  عمرك على ارقام فقط',
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
                ),

                /*DateTimePicker(
                    initialValue: '',
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    //enabled: Border,
                    dateLabelText: 'اختر تاريخ ميلادك ',
                    icon: Icon(Icons.calendar_month),
                    onChanged: (val) => bd = val,
                    validator: (val) {
                      validations.validate(0, val!);
                    },
                    onSaved: (val) => print(val),
                  ),
                ),*/

                /* TextFormField(
                    keyboardType: TextInputType.datetime,
                    textAlign: TextAlign.right,
                    //readOnly: true,
                    // The validator receives the text that the user has entered.
                    /*
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            1900), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2040));
                    final DateFormat formatter = DateFormat("dd/MM/YYYY");
                    bd = formatter.format(pickedDate!).toString();
                    setState(() {
                      date = pickedDate;
                      

                    });
                  },*/
                    onTap: () async {
                      // Below line stops keyboard from appearing
                      FocusScope.of(context).requestFocus(new FocusNode());
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Colors.green,
                              colorScheme: const ColorScheme.light(
                                  primary: Colors.green),
                              buttonTheme: const ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary),
                            ),
                            child: child!,
                          );
                        },
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      //if Cancel
                      if (newDate == null) return;
                      //if OK
                      setState(() => date = newDate);
                      bd = intl.DateFormat.yMMMd().format(newDate);
                    },
                    validator: (value) => validations.validate(0, value!),
                    onChanged: (value) {
                      setState(() => bd = value);
                      print('Selected date: $bd');
                      //bd = value;
                    },
                    onSaved: (val) => print(val),
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
                ),*/

                SizedBox(height: 8),
//5-phone number:
                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    // The validator receives the text that the user has entered.
                    validator: (value) => validations.validate(4, value!),
                    onChanged: (value) {
                      phone = value.trim();
                    },
                    maxLength: 10,
                    decoration: const InputDecoration(

                      prefixIcon: Icon(Icons.phone),
                      labelText: 'ادخل رقم جوالك ',
                      hintText: '05xxxxxxxx : يجب ان يكون كالتالي',
                      //hintText: '05xxxxxxxx :مثال ',
                      //alignLabelWithHint: true,
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
                SizedBox(height: 8),
//6-Email
                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.right,

                    // The validator receives the text that the user has entered.
                    validator: (value) => validations.validate(1, value!),
                    onChanged: (value) {
                      email = value.toLowerCase().trim();
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'ادخل بريدك الالكتروني',
                      hintText: "مثال admin@gmail.com",
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
                SizedBox(height: 8),

//7-password

                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    textAlign: TextAlign.right,
                    // The validator receives the text that the user has entered.
                    validator: (value) => validations.validate(2, value!),
                    onChanged: (value) {
                      password = value.trim();
                    },
                    decoration: const InputDecoration(
                      labelText: 'ادخل كلمة المرور',
                      hintText: 'انتبه للتعليمات في الاسفل...',
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
                SizedBox(height: 8),
                const Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Text('*يجب ان تكون كلمة المرور مكونة من 8 خانات ',
                      textAlign: TextAlign.right, selectionColor: Colors.green),
                ),
                const Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Text(
                      '*يجب ان تحتوي كلمة المرور على حرف واحد كبير على الاقل',
                      textAlign: TextAlign.right,
                      selectionColor: Colors.green),
                ),
                const Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Text(
                      '*يجب ان تحتوي كلمة المرور على حرف واحد صغير على الاقل',
                      textAlign: TextAlign.right,
                      selectionColor: Colors.green),
                ),
                const Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Text('*يجب ان تحتوي كلمة المرور على رقم واحد الاقل',
                      textAlign: TextAlign.right, selectionColor: Colors.green),
                ),
/*7-confirm password
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
                ),*/

                SizedBox(height: 10),

                MyButton(
                  color: Colors.green,
                  title: 'إنــشــاء',
                  onPressed: () async {
                    EasyLoading.show(status: 'تحميل ...');
                    String _message = '';
                    //bool condetionUserName =
                    //isDuplicateUniqueName(userName) as bool;
                    //if (!condetionUserName) {
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
                            await _firestore
                                .collection('users')
                                .doc(email)
                                //.doc(userCred.user!.uid)
                                .set({
                              'NID': nid,
                              'fname': f_name,
                              'lname': l_name,
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
                        //NO
                        //move the auth user to the home page(our App) and we should have import for it.
                        //--Navigator.pushNamed(context, HomeScreen.screenRout);
                        //move the auth user to the home page(our App) and we should have import for it.
                        Navigator.pushNamed(context, '/home');
                      } on FirebaseAuthException catch (e) {
                        switch (e.code) {
                          case "email-already-in-use":
                            _message = 'البريد الإلكتروني مستخدم مسبقًا';
                            //tost is working
                            /*Fluttertoast.showToast(
                                msg: _message,
                                backgroundColor: Colors.green,
                                textColor: Colors.grey,
                                gravity: ToastGravity.TOP,
                                toastLength: Toast.LENGTH_SHORT);*/
                            break;
                          /*case "userName-already-in-use":
                            _message = ' اسم المستخدم مستخدم مسبقًا';
                            Fluttertoast.showToast(
                                msg: _message,
                                backgroundColor: Colors.green,
                                textColor: Colors.grey,
                                gravity: ToastGravity.TOP,
                                toastLength: Toast.LENGTH_SHORT);
                            break;*/
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
                    /*} else {
                      EasyLoading.showError("اسم المستخدم موجود مسبقا");
                    }*/
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
                        //No
                        //Navigator.pushNamed(context, LoginScreen.screenRoute);
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
/*
  Future<bool> isDuplicateUniqueName(String uniqueName) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: uniqueName)
        .get();
    return query.docs.isNotEmpty;
  }
  */
}
