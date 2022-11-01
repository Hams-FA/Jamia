// ignore_for_file: prefer_const_constructors
//import 'dart:html';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import '../firebase_options.dart';
import 'ViewFriendProfile.dart';

//import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    home: ViewAndDeleteFriends(),
  ));
}

class ViewAndDeleteFriends extends StatefulWidget {
  const ViewAndDeleteFriends({Key? key}) : super(key: key);
  @override
  State<ViewAndDeleteFriends> createState() => _ViewAndDeleteFriendsState();
}

class _ViewAndDeleteFriendsState extends State<ViewAndDeleteFriends> {
  String name = "";
  Widget elevateButton = ElevatedButton(onPressed: null, child: Text('data'));
  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  late String? imageURL;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
      }
    } catch (e) {
      EasyLoading.showError("حدث خطأ ما ....");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('أصدقائي'),
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/SearchFriends');
              },
              icon: Icon(Icons.person_add_alt),
            ),
          ],
        ),
        body: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(signedInUser.email)
                .collection('friends')
                .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshots.hasError) {
                return Center(
                  child: Text("حدث خطأ ما ...."),
                );
              }

              if (snapshots.hasData) {
                final reqts = snapshots.data!.docs;
                if (reqts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.hourglass_empty,
                          size: 100,
                        ),
                        Text(
                          ' لا يوجد لديك اصدقاءابدأ بإضافة الاصدقاء الآن',
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;
                      showAlertDialog(BuildContext context) {
                        // set up the buttons
                        Widget cancelButton = TextButton(
                          child: Text("تراجع"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        );
                        Widget continueButton = TextButton(
                          style:
                              TextButton.styleFrom(foregroundColor: Colors.red),
                          child: Text("حذف"),
                          onPressed: () {
                            Colors.black38;
                            var email = data['Email'];
                            final docUser = FirebaseFirestore.instance
                                .collection('users')
                                .doc(signedInUser.email)
                                .collection('friends')
                                .doc(email);

                            docUser.delete();
                            Navigator.pop(context);
                          },
                        );
                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          title: Text("إزالة صديق"),
                          content: Text(
                              " هل أنت متأكد من رغبتك في إزالة الصديق (" +
                                  data['fname'] +
                                  ")"),
                          actions: [
                            cancelButton,
                            continueButton,
                          ],
                        );
                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      }

                      return FutureBuilder<String>(
                        future: FirebaseStorage.instance
                            .ref()
                            .child('usersProfileImages/${data['Email']}')
                            .getDownloadURL(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done ||
                              snapshot.data == null ||
                              snapshot.hasError) {
                            if (snapshot.data == null || snapshot.hasError) {
                              imageURL = null;
                            } else {
                              imageURL = snapshot.data;
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  ProfilePicture(
                                    name: '',
                                    radius: 20,
                                    fontsize: 20,
                                    img: imageURL,
                                  ),
                                  SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewFriendProfile(
                                                      email: data['Email'])));
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['fname'] + " " + data['lname'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.black54,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          data['Email'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(
                                      Icons.remove_circle_outline,
                                      size: 20.0,
                                      color: Color.fromARGB(255, 169, 37, 4),
                                    ),
                                    onPressed: () {
                                      showAlertDialog(context);

                                      //_onAddIconPressed(data['userName']);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }

                          return const Center(
                            child: Text('يتم التحميل'),
                          );
                        },
                      );
                    });
              }
              return Expanded(
                child: Center(child: Text('عذراً، لا يوجد لديك اصدقاء')),
              );
            },
          ),
        ),
        //added bar here
        bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            child: Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/viewUserProfile');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person),
                        Text("الملف الشخصي"),
                      ],
                    ),
                    minWidth: 40,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/ViewAndDeleteFriends');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.man,
                          color: Colors.green,
                        ),
                        Text("اصدقائك"),
                      ],
                    ),
                    minWidth: 40,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/NewHome');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people),
                        Text("جمعياتي"),
                      ],
                    ),
                    minWidth: 40,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/RequestPageFinal');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list_alt,
                        ),
                        Text("الطلبات"),
                      ],
                    ),
                    minWidth: 40,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
