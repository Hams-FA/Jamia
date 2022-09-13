// ignore_for_file: prefer_const_constructors
import 'dart:html';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Card(
              color: Colors.white,
          child: Directionality(
              textDirection: ui.TextDirection.rtl,
              child: TextFormField(
                keyboardType: TextInputType.name,
                textAlign: TextAlign.right,

                // The validator receives the text that the user has entered.
                onChanged: (value) {
                  name = value;
                },
                decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'ابحث عن صديق باستخدام الاسم او الايميل',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
              ),),
        )),
        body: StreamBuilder<QuerySnapshot>(
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

                      if (name.isEmpty) {
                        if (data['Email'] != 'fay@howrtmail.com') {
                          //Edit

                          return ListTile(
                            title: Text(
                            data['fname'] +" "+ data['lname'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              data['Email'] +
                                  "                            التقييم:  " +
                                  data['rate'],
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
                                      Icons.add,
                                      size: 30.0,
                                      color: Color.fromARGB(255, 6, 65, 37),
                                    ),
                                    onPressed: () {
                                      var email = data['Email'];
                                      var photo = data['photo'];
                                      var rate = data['rate'];
                                      var fname = data['fname'];
                                      var lname = data['lname'];

                                      /* final User =
                                        FirebaseAuth.instance.currentUser!.uid; */
                                      final docUser = FirebaseFirestore.instance
                                          .collection('users')
                                          .doc('fay@hotmail.com')
                                          .collection('friends')
                                          .doc(email);

                                      docUser.set({
                                        'Email': email,
                                        'rate': rate,
                                        'photo': photo,
                                        'fname': fname,
                                        'lname': lname
                                      });

                                      //_onAddIconPressed(data['userName']);
                                    },
                                  ),
                                ]),
                          );
                        }
                      }
                      if (data['fname']
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        if (data['Email'] != 'fay@hotmail.com') {
                          //Edit

                          return ListTile(
                            title: Text(
                            data['fname'] +" "+ data['lname'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              data['Email'] +
                                  "                            التقييم:  " +
                                  data['rate'],
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
                                      Icons.add,
                                      size: 30.0,
                                      color: Color.fromARGB(255, 6, 65, 37),
                                    ),
                                    onPressed: () {
                                      var email = data['Email'];
                                      var photo = data['photo'];
                                      var rate = data['rate'];
                                      var fname = data['fname'];
                                      var lname = data['lname'];

                                      /* final User =
                                        FirebaseAuth.instance.currentUser!.uid; */
                                      final docUser = FirebaseFirestore.instance
                                          .collection('users')
                                          .doc('fay@hotmail.com')
                                          .collection('friends')
                                          .doc(email);

                                      docUser.set({
                                        'Email': email,
                                        'rate': rate,
                                        'photo': photo,
                                        'fname': fname,
                                        'lname': lname
                                      });
                                      //_onAddIconPressed(data['userName']);
                                    },
                                  ),
                                ]),
                          );
                        }
                      }
                      return Container();
                    });
          },
        ));
  }
}
