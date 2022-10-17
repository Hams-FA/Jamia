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
    getMyPastjamiah();
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
                              .collection('users')
                              .doc(signedInUser.email)
                              .collection('JamiaGroups')
                              .snapshots(),
                          builder: ((context, snapshot1) {
                            if (snapshot1.hasData) {
                              return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('JamiaGroup')
                              .snapshots(),
                          builder: ((context, snapshot2) {
                            if (snapshot2.hasData) {


                              return ListView.builder(
                                  itemCount: snapshot1.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    //index what does it means ????????????
                                    var data = snapshot1.data!.docs[index].data()
                                        as Map<String, dynamic>;
                                    


                                    var data2 = snapshot2.data!.docs[index].data()
                                        as Map<String, dynamic>;


                                    //late Map<String, dynamic>? dataj = data;
                                    //data;
                                    /*FirebaseFirestore.instance
                                        .collection('JamiaGroup')
                                        .doc(data['id'])
                                        .get()
                                        .then((value) {
                                      dataj = value.data();
                                    });*/

                                    DateTime today = DateTime.now();

                                    DateTime endDate2 = DateTime.parse(
                                        dataj!['endDate'].toString());
                                    print(dataj);
                                    print(endDate2);

                                    if (today.isAfter(endDate2)) {
                                      return Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            alignment: Alignment.topLeft,
                                            color: Colors.grey.shade300,
                                            child: Directionality(
                                                textDirection:
                                                    ui.TextDirection.rtl,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'الجمعية : ${data['name']}',
                                                          style: TextStyle(
                                                              fontSize: 17),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                    Column(children: [
                                                      GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            more_details(
                                                                              data: data,
                                                                              jamiaId: '',
                                                                            )));
                                                          },
                                                          child: Icon(Icons
                                                              .visibility)),
                                                      Text('التفاصيل')
                                                    ]),
                                                    /*Column(
                                                      children: [
                                                        GestureDetector(
                                                            onTap: () {
                                                              /*
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        inviteFriends()));
                                                        */

                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          inviteFriends(
                                                                              data: data)));
                                                            },
                                                            child: const Icon(Icons
                                                                .person_add_alt)),
                                                        const Text(
                                                            'ادعو اصدقائك')
                                                      ],
                                                    ),*/
                                                  ],
                                                )),
                                          ),
                                        ],
                                      );
                                    }
                                    return Column(children: [
                                      Text("لايوجد لديك جمعيات سابقة !!")
                                    ]);
                                  });
                            }
                            return Container(
                              child: Text('No data found'),
                            );
                          }))),
                  /*Container(
                  padding: EdgeInsets.only(bottom: 40),
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 76, 175, 80),
                    ),
                    onPressed: () {},
                    child: Text('ادعو اصدقائك'),
                  )),*/
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
  getMyPastjamiah() async {
    final jamiahs = await FirebaseFirestore.instance
        .collectionGroup('members')
        .where('name', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    jamiahs.docs.forEach((element) {
      print(element.data());
    });
  }
}*/
