// ignore_for_file: prefer_const_constructors
//import 'dart:html';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sprint/screens/form.dart';

import '../firebase_options.dart';

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
/*
    final CollectionReference profileList =
      FirebaseFirestore.instance.collection('FriendsList');

  _onAddIconPressed(String){
  Future<void> createUserData(String userName) async {
    return await profileList.doc(userName)
        .set({'Name': data[Name], 'gender': gender, 'score': score});
  } 
} */
  String name = "";
  Widget elevateButton = ElevatedButton(onPressed: null, child: Text('data'));

  final _auth = FirebaseAuth.instance;
  late User signedInUser;

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
        /*(
          centerTitle: true,
          title: Text('أصدقائي'),
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/SearchFriends');
            },
            icon: Icon(Icons.person_add_alt),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios_new))
          ),
        ),*/
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
                      children: [
                        /*Icon(
                              Icons.hourglass_empty,
                              size: 100,
                            ),*/
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

                            /* final User =
                                          FirebaseAuth.instance.currentUser!.uid; */
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

                      /*if (data['fname']
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) { */
                      return ListTile(
                        title: Text(
                          data['fname'] + " " + data['lname'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          data['Email'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                              fontWeight: FontWeight.normal),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(data['photo']),
                        ),
                        trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
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
                            ]),
                      );
                      /*return Container();
                      } */
                    });
              }
              return Expanded(
                child: Center(child: Text('عذراً، لا يوجد لديك اصدقاء')),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 76, 175, 80),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FormPage()));
          },
          mini: true,
          child: const Icon(
            Icons.add,
            color: Color(0xFF393737),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,

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
                        Icon(Icons.man),
                        Text("قائمة اصدقائك"),
                      ],
                    ),
                    minWidth: 40,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
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
                        Icon(Icons.list_alt),
                        Text("قائمة الطلبات"),
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
