import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../widgets/validations.dart';
import 'dart:ui' as ui;

class ViewFriendProfile extends StatefulWidget {
  final String email;
  const ViewFriendProfile({Key? key, required this.email}) : super(key: key);

  @override
  State<ViewFriendProfile> createState() => _ViewFriendProfileState(email);
}

class _ViewFriendProfileState extends State<ViewFriendProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final _formKey = GlobalKey<FormState>();
  final String email;
  late String firstName;
  late String lastName;
  late String bd;
  late String phone;

  late String? imageURL;
  var firstNameText = TextEditingController();
  var lastNameText = TextEditingController();
  var bdText = TextEditingController();
  var phoneText = TextEditingController();
  _ViewFriendProfileState(this.email);
  @override
  Widget build(BuildContext context) {
    Validations validations = Validations();

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الملف الشخصي'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<String>(
                future: Future.value(
                    '') /*_firebaseStorage
                    .ref()
                    .child('usersProfileImages/$email')
                    .getDownloadURL()*/
                ,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
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
                                fontsize: 20,
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
                future: _firestore.collection('users').doc(email).get(),
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
                          ],
                        ),
                      ),
                    );
                  }

                  return const Center(
                    child: Text('يتم التحميل'),
                  );
                },
              ),
              const SizedBox(height: 24),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Ratings')
                      .where('to', isEqualTo: widget.email)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      var count = 0.0;
                      var ratings = 0.0;
                      for (var doc in snapshot.data!.docs) {
                        count++;
                        ratings += doc['rating'];
                      }
                      // count how many ratings

                      return Column(
                        children: [
                          RatingBar.builder(
                            initialRating: ratings != null
                                ? ratings
                                : 0 / count != null
                                    ? count
                                    : 1,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 40,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star_outlined,
                              color: Colors.amber,
                            ),
                            //  ignoreGestures: true,
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          const SizedBox(height: 16),
                          Text('${count}  '),
                        ],
                      );
                    }
                    return const Text('No data found');
                  })),
            ],
          ),
        ),
      ),
    );
  }
}
