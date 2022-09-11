// ignore_for_file: prefer_const_constructors
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

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
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by user name, name Or Phone Number'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        )),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc('BqOzze04XhjjKlgEOc5F').collection('friends').snapshots(),
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
                        return ListTile(
                          title: Text(
                            data['Name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            data['userName']+                                 "                            rate:  " + data['rate'],
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
                                    var uName = data['userName'];
                                   /* final User =
                                        FirebaseAuth.instance.currentUser!.uid; */
                                    final docUser = FirebaseFirestore.
                                    instance.collection('users')
                                    .doc('BqOzze04XhjjKlgEOc5F')
                                    .collection('friends').doc(uName);

                                    docUser.delete();

                                    //_onAddIconPressed(data['userName']);
                                  },
                                ),
                              ]),
                        );
                      }
                      if (data['userName']
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        return ListTile(
                          title: Text(
                            data['Name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            data['userName']+                                 "                            rate:  " + data['rate'],
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
                                    var uName = data['userName'];

                                   /* final User =
                                        FirebaseAuth.instance.currentUser!.uid; */
                                    final docUser = FirebaseFirestore.
                                    instance.collection('users')
                                    .doc('BqOzze04XhjjKlgEOc5F')
                                    .collection('friends').doc(uName);

                                    docUser.delete();

                                    //_onAddIconPressed(data['userName']);
                                  },
                                ),
                              ]),
                        );
                      }
                      return Container();
                    });
          },
        ));
  }
}
