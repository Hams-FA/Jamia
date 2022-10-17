/*import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sprint/more_details.dart';
import 'package:sprint/screens/firebase_user_details.dart';
import 'package:sprint/screens/inviteFriends.dart';

import 'package:sprint/screens/form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dart:ui' as ui;

class JamiaHistory extends StatefulWidget {
  const JamiaHistory({Key? key}) : super(key: key);

  @override
  State<JamiaHistory> createState() => _JamiaHistoryState();
}

class _JamiaHistoryState extends State<JamiaHistory> {
  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  @override
  void initState() {
    super.initState();
    fetchUserfromFirebase();
    getCurrentUser();
    //getMyPastjamiah();
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
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
                title: const Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: Text(
                      '      جـمـعـيـاتـي السابقة',
                      style: TextStyle(
                          fontSize: 25,
                          color: Color.fromARGB(255, 255, 254, 254),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    )),
                backgroundColor: Color.fromARGB(255, 76, 175, 80)),

            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('JamiaGroup')
                  //.where('endDate':isLessThanOrEqualTo:DateTime.now())
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> categorySnapshot) {
                //get data from categories

                if (!categorySnapshot.hasData) {
                  return const Text('Loading...');
                }

                //put all categories in a map
                Map<String, dynamic> categories = Map();
                categorySnapshot.data!.docs.forEach((c) {
                  var Category;
                  categories[c.documentID] =
                      Category.fromJson(c.documentID, c.data);
                });

                //then from objects

                return StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('objectsPath')
                      .where('day', isGreaterThanOrEqualTo: _initialDate)
                      .where('day', isLessThanOrEqualTo: _finalDate)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> objectsSnapshot) {
                    if (!objectsSnapshot.hasData)
                      return const Text('Loading...');

                    final int count =
                        objectsSnapshot.data.documents.length;
                    return Expanded(
                      child: Container(
                        child: Card(
                          elevation: 3,
                          child: ListView.builder(
                              padding: EdgeInsets.only(top: 0),
                              itemCount: count,
                              itemBuilder: (_, int index) {
                                final DocumentSnapshot document =
                                    objectsSnapshot.data.documents[index];
                                Object object = Object.fromJson(
                                    document.documentID, document.data);

                                return Column(
                                  children: <Widget>[
                                    Card(
                                      margin: EdgeInsets.only(
                                          left: 0, right: 0, bottom: 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0)),
                                      ),
                                      elevation: 1,
                                      child: ListTile(
                                        onTap: () {},
                                        title: Text(object.description,
                                            style: TextStyle(fontSize: 20)),
//here is the magic, i get the category name using the map 
of the categories and the category id from the object
                                        subtitle: Text(
                                          categories[object.categoryId] !=
                                                  null
                                              ? categories[
                                                      object.categoryId]
                                                  .name
                                              : 'Uncategorized',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),

                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ),
                    );
                          ),
        
                ],
              ),
            ),

            floatingActionButton: FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 76, 175, 80),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FormPage()));
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
        ));
  }

  fetchUserfromFirebase() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  /*

  fetchJamiafromFirebase(String id) async {
    final jamia =
        await FirebaseFirestore.instance.collection('JamiaGroup').doc(id).get();

    return jamia["endDate"];
  }*/
  /*getMyPastjamiah() async {
    final jamiahs = await FirebaseFirestore.instance
        .collectionGroup('members')
        .where('name', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    jamiahs.docs.forEach((element) {
      print(element.data());
    });
  }*/
}*/
