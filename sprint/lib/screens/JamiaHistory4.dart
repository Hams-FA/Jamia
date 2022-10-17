import 'package:flutter/material.dart';
import 'package:sprint/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sprint/more_details.dart';
import 'dart:ui' as ui;

import 'package:sprint/screens/firebase_user_details.dart';
import 'package:sprint/screens/form.dart';

import '../main.dart';

class JamiaHistory4 extends StatefulWidget {
  const JamiaHistory4({super.key});

  @override
  State<JamiaHistory4> createState() => _JamiaHistory4State();
}

class _JamiaHistory4State extends State<JamiaHistory4> {
  late List<QueryDocumentSnapshot> pastJamiah;
  bool _isLoading = true;
  @override
  void initState() {
    pastJamiah = getPastJamiah();

    super.initState();
  }

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot> getPastJamiah() {
    final User user = auth.currentUser!;
    final uid = user.email;
    List<QueryDocumentSnapshot> pastJamiah = [];

    firestore.collection('JamiaGroup').get().then((value) {
      value.docs.forEach((element) {
        element.reference
            .collection('members')
            .where(FieldPath.documentId, isEqualTo: uid)
            .get()
            .then((value) {
          value.docs.forEach((member) {
            if ((element.data()['endDate'] as Timestamp)
                .toDate()
                .isBefore(DateTime.now())) {
              print('isPastJamia ${element.data()}');
              pastJamiah.add(element);
            }
          });
          setState(() {
            _isLoading = false;
            pastJamiah = pastJamiah;
          });
        });
      });
    });
    print('pastJamiah $pastJamiah');

    return pastJamiah;
  }

  @override
  Widget build(BuildContext context) {
    bool visibilityController = true;
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            actions: <Widget>[
              /*IconButton(
                icon: Icon(Icons.home),
                onPressed: () async {
                  Navigator.pushNamed(context, '/home');
                }),*/
            ],
            title: const Text('جمعياتي السابقة',
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    //fontFamily: "Montsterrat Classic",
                    color: Color.fromARGB(255, 255, 255, 255))),
            backgroundColor: Color.fromARGB(255, 76, 175, 80)),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : pastJamiah.isEmpty
                ? Center(
                    child: Text("لا يوجد لديك جمعيات سابقة!!"),
                  )
                : ListView(
                    children: pastJamiah.map((reqt) {
                      return Card(
                        child: ListTile(
                          title: Text(reqt.get('name')),
                          leading: CircleAvatar(
                              backgroundColor: Color(0xFF0F7C0D),
                              child: Image.asset('images/logo.jpg')),
                          subtitle: Text(
                              " لمعرفة المزيد من التفاصيل وتقييم اعضاء الجمعية "),
                          trailing: TextButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => more_details(
                                          data: reqt.data()
                                              as Map<String, dynamic>,
                                          jamiaId: reqt.id)));
                            },
                            child: const Text('انقر هنا!!',
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montsterrat Classic",
                                    color: Color(0xFF545454))),
                          ),
                        ),
                      );
                    }).toList(),
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
