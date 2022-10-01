import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import '../widgets/validations.dart';

class ViewUserProfile extends StatefulWidget {
  const ViewUserProfile({Key? key}) : super(key: key);
  @override
  State<ViewUserProfile> createState() => _ViewUserProfileState();
}

class _ViewUserProfileState extends State<ViewUserProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final _formKey = GlobalKey<FormState>();
  late String nid;
  late String firstName;
  late String lastName;
  late String userName;
  late String bd;
  late String phone;
  late String bankName;
  late String IBAN;
  // late String cvvNumber;
  // late String cardOwnerName;
  late String? imageURL;
  var nidText = TextEditingController();
  var firstNameText = TextEditingController();
  var lastNameText = TextEditingController();
  var userNameText = TextEditingController();
  var bdText = TextEditingController();
  var phoneText = TextEditingController();
  var bankNameText = TextEditingController();
  var IBANText = TextEditingController();
  // var cvvNumberText = TextEditingController();
  // var cardOwnerNameText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Validations validations = Validations();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<String>(
              future: _firebaseStorage
                  .ref()
                  .child('usersProfileImages/${_auth.currentUser?.email}')
                  .getDownloadURL(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done ||
                    snapshot.data == null ||
                    snapshot.hasError) {
                  if (snapshot.data == null || snapshot.hasError) {
                    imageURL = null;
                  } else {
                    imageURL = snapshot.data;
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ProfilePicture(
                              name: '',
                              radius: 30,
                              fontsize: 21,
                              img: imageURL,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                }

                return const Center(
                  child: Text('يتم التحميل'),
                );
              },
            ),
            FutureBuilder<DocumentSnapshot>(
              future: _firestore
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.email)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return const Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  //national id
                  nidText.text = data['NID'];
                  nid = data['NID'];
                  //firstName
                  firstNameText.text = data['fname'];
                  firstName = data['fname'];
                  //lastName
                  lastNameText.text = data['lname'];
                  lastName = data['lname'];
                  //birthdate
                  bdText.text = data['birthDate'];
                  bd = data['birthDate'];
                  //phone number
                  phoneText.text = data['PhoneNO'];
                  phone = data['PhoneNO'];
                  // card number
                  if (data['bankName'] == null) {
                    bankNameText.text = "لم يتم ادخال اسم البنك";
                    bankName = "لم يتم ادخال اسم البنك";
                  } else {
                    bankNameText.text = data['bankName'];
                    bankName = data['bankName'];
                  }
                  //card expiration date
                  if (data['IBAN'] == null) {
                    IBANText.text = "لم يتم ادخال رقم الايبان";
                    IBAN = "لم يتم ادخال رقم الايبان";
                  } else {
                    IBANText.text = data['IBAN'];
                    IBAN = data['IBAN'];
                  }
                  //CVV Number
                  // if (data['expDate'] == null) {
                  //   cvvNumberText.text = "";
                  //   cvvNumber = "";
                  // } else {
                  //   cvvNumberText.text = data['cvv'];
                  //   cvvNumber = data['cvv'];
                  // }
                  //card owner name
                  // if (data['expDate'] == null) {
                  //   cardOwnerNameText.text = "";
                  //   cardOwnerName = "";
                  // } else {
                  //   cardOwnerNameText.text = data['cardOwner'];
                  //   cardOwnerName = data['cardOwner'];
                  // }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            enabled: false,
                            keyboardType: TextInputType.number,
                            // controller: nidText,
                            textAlign: TextAlign.right,

                            // The validator receives the text that the user has entered.
                            validator: (value) =>
                                validations.validate(5, value!),
                            onChanged: (value) {
                              nid = value;
                            },
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.fingerprint),
                              hintText: "${data['NID']}",
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
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
                          const SizedBox(height: 8),
                          TextFormField(
                            enabled: false,
                            keyboardType: TextInputType.name,
                            textAlign: TextAlign.right,
                            // controller: nameText,
                            // The validator receives the text that the user has entered.
                            validator: (value) =>
                                validations.validate(3, value!),
                            onChanged: (value) {
                              firstName = value;
                            },
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.person),
                              hintText: "${data['fname']}",
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
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
                          const SizedBox(height: 8),
                          TextFormField(
                            enabled: false,
                            keyboardType: TextInputType.name,
                            textAlign: TextAlign.right,
                            // controller: nameText,
                            // The validator receives the text that the user has entered.
                            validator: (value) =>
                                validations.validate(3, value!),
                            onChanged: (value) {
                              lastName = value;
                            },
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.person),
                              hintText: "${data['lname']}",
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
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
                          const SizedBox(height: 8),
                          TextFormField(
                            enabled: false,
                            keyboardType: TextInputType.datetime,
                            textAlign: TextAlign.right,
                            // controller: bdText,
                            validator: (value) =>
                                validations.validate(0, value!),
                            onChanged: (value) {
                              bd = value;
                            },
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.calendar_month),
                              hintText: "${data['birthDate']}",
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
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
                          const SizedBox(height: 8),
                          TextFormField(
                            enabled: false,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.right,
                            // controller: phoneText,
                            // The validator receives the text that the user has entered.
                            validator: (value) =>
                                validations.validate(4, value!),
                            onChanged: (value) {
                              phone = value;
                            },
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.phone),
                              hintText: "${data['PhoneNO']}",
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
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
                          const SizedBox(height: 8),
                          TextFormField(
                            enabled: false,
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.email),
                              hintText: "${data['Email']}",
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
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
                          const SizedBox(height: 8),
                          TextFormField(
                            enabled: false,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.right,
                            validator: (value) =>
                                validations.validate(8, value!),
                            onChanged: (value) {
                              bankName = value;
                            },
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.abc),
                              hintText: bankName,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
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
                          const SizedBox(height: 8),
                          TextFormField(
                            enabled: false,
                            keyboardType: TextInputType.datetime,
                            textAlign: TextAlign.right,
                            validator: (value) =>
                                validations.validate(9, value!),
                            onChanged: (value) {
                              IBAN = value;
                            },
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.credit_card),
                              hintText: IBAN,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
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
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Material(
                              elevation: 5,
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                              child: MaterialButton(
                                onPressed: () async {
                                  if (mounted) {
                                    Navigator.pushNamed(
                                        context, '/editUserProfile');
                                  }
                                },
                                height: 42,
                                child: const Text(
                                  "تعديل الملف الشخصي",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Material(
                              elevation: 5,
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                              child: MaterialButton(
                                onPressed: () async {
                                  try {
                                    await _auth.signOut();
                                    if (mounted) {
                                      Navigator.pushNamed(context, '/login');
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    EasyLoading.showError(
                                        'حدث خطأ، الرجاء المحاولة مرة اخرى');
                                  }
                                },
                                height: 42,
                                child: const Text(
                                  "تسجيل الخروج",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return const Center(
                  child: Text('يتم التحميل'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
