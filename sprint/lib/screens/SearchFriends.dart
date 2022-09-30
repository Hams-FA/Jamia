// ignore_for_file: prefer_const_constructors
//import 'dart:html';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../firebase_options.dart';

//import 'package:sprint/screens/firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    home: SearchFriends(),
  ));
}

class SearchFriends extends StatefulWidget {
  const SearchFriends({Key? key}) : super(key: key);

  @override
  State<SearchFriends> createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  List<dynamic> myFriends = List<dynamic>.empty(growable: true);
  late bool toggle;
  String name = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readInvited211();
    print(myFriends);
    getCurrentUser();
  }

  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  @override
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

  void readInvited211() async {
    List<dynamic> feature = await readInvited2();
    feature.forEach((element) {
      myFriends.add(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("أضف صديق"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 76, 175, 80),
        ),
        body: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshots) {
              return (snapshots.connectionState == ConnectionState.waiting)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshots.data!.docs[index].data()
                            as Map<String, dynamic>;

                        if (!myFriends.contains(data['Email'])) {
                          if (name.isEmpty) {
                            if (data['Email'] != signedInUser.email) {
                              toggle = false;

                              //Edit

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
                                        onPressed: () {
                                          setState(() {
                                            // Here we changing the icon.
                                            toggle = true;
                                          });
                                          var email = data['Email'];
                                          var photo = data['photo'];
                                          var rate = data['rate'];
                                          var fname = data['fname'];
                                          var lname = data['lname'];

                                          /* final User =
                                          FirebaseAuth.instance.currentUser!.uid; */
                                          final docUser = FirebaseFirestore
                                              .instance
                                              .collection('users')
                                              .doc(signedInUser.email)
                                              .collection('friends')
                                              .doc(email);

                                          docUser.set({
                                            'Email': email,
                                            'rate': rate,
                                            'photo': photo,
                                            'fname': fname,
                                            'lname': lname
                                          });
                                        },
                                        icon: toggle
                                            ? Icon(Icons.check_box)
                                            : Icon(
                                                Icons.add_box,
                                              ),
                                      ),

                                      //_onAddIconPressed(data['userName']);
                                    ]),
                              );
                            }
                          }
                          if (data['fname']
                              .toString()
                              .toLowerCase()
                              .startsWith(name.toLowerCase())) {
                            if (data['Email'] != signedInUser.email) {
                              toggle = false;

                              //Edit

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
                                        onPressed: () {
                                          setState(() {
                                            // Here we changing the icon.
                                            toggle = true;
                                          });
                                          var email = data['Email'];
                                          var photo = data['photo'];
                                          var rate = data['rate'];
                                          var fname = data['fname'];
                                          var lname = data['lname'];

                                          /* final User =
                                          FirebaseAuth.instance.currentUser!.uid; */
                                          final docUser = FirebaseFirestore
                                              .instance
                                              .collection('users')
                                              .doc(signedInUser.email)
                                              .collection('friends')
                                              .doc(email);

                                          docUser.set({
                                            'Email': email,
                                            'rate': rate,
                                            'photo': photo,
                                            'fname': fname,
                                            'lname': lname
                                          });
                                        },
                                        icon: toggle
                                            ? Icon(Icons.check_box)
                                            : Icon(
                                                Icons.add_box,
                                              ),
                                      ),
                                    ]),
                              );
                            }
                          }
                        }
                        return Container();
                      });
            },
          ),
        ));
  }

  Future<List<dynamic>> readInvited2() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(signedInUser.email) //chenge this to jamia id
        .collection('friends')
        .get();

    List<dynamic> res = List<dynamic>.empty(growable: true);
    //res = querySnapshot.keys;
    //inviteFriends = test;
    querySnapshot.docs.forEach((element) {
      res.add(element.id); //data() - id
      print(element.id);
      //print(element['status']);
    });
    return res;
  }
}

/*
Future<List<dynamic>> readInvited2() async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection("users")
      .doc(signedInUser.email) //chenge this to jamia id
      .collection('friends')
      .get();

  List<dynamic> res = List<dynamic>.empty(growable: true);
  //res = querySnapshot.keys;
  //inviteFriends = test;
  querySnapshot.docs.forEach((element) {
    res.add(element.id); //data() - id
    print(element.id);
    //print(element['status']);
  });
  return res;
}*/
