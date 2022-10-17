/* No need for this class 
import 'package:flutter/material.dart';
import 'package:sprint/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sprint/more_details.dart';
import 'dart:ui' as ui;

import 'package:sprint/screens/firebase_user_details.dart';
import 'package:sprint/screens/form.dart';

class JamiaHistory2 extends StatelessWidget {
  const JamiaHistory2({super.key});
  late  JHreqts;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            actions: <Widget>[],
            title: const Text('      جـمـعـيـاتـي السابقة',
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    //fontFamily: "Montsterrat Classic",
                    color: Color.fromARGB(255, 255, 255, 255))),
            backgroundColor: Color.fromARGB(255, 76, 175, 80)),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection('JamiaGroups')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                JHreqts = snapshot.data!.docs;
                if (JHreqts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('لا يوجد لديك جمعيات !!',
                            style: Theme.of(context).textTheme.headline6),
                      ],
                    ),
                  );
                }
                return ListView(
                  children: JHreqts.map((e) => buildCard(e, context)).toList(),
                );
              } else {
                return Text('حدث خطأ ما',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montsterrat Classic",
                        color: Color(0xFF545454)));
              }
            }),
        ///////////////////////////////////////////////////////////////////
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
        ///////////////////////////////////////////////////////////////////
      ),
    );
  }
}

// card with title and subtitle and action buttons
Card buildCard(DocumentSnapshot doc, BuildContext context) {
  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('JamiaGroup')
                  .doc(JHreqts)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final jamiah = snapshot.data!;
                  DateTime today = DateTime.now();
                  ///////////////
                  DateTime endDate = jamiah['endDate'];
                  ///////////////
                  if (today.isAfter(endDate)) {
                    return Text(jamiah['name']);
                  }
                } else
                  return Text('جاري التحميل',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montsterrat Classic",
                          color: Color(0xFF545454)));
                return Text('جاري التحميل');
              }),
          leading: CircleAvatar(
              backgroundColor: Color(0xFF0F7C0D),
              child: Image.asset('images/logo.jpg')),
          subtitle: Text("هل تريد الاطلاع على تفاصيلها !! "),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                final jamiah = await FirebaseFirestore.instance
                    .collection('JamiaGroup')
                    .doc(doc['jamiaID'])
                    .get();
                print(jamiah.data());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => more_details(
                            data: jamiah.data() as Map<String, dynamic>,
                            jamiaId: doc.id)));
              },
              child: const Text('تفضل للمزيد من التفاصيل',
                  style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montsterrat Classic",
                      color: Color(0xFF545454))),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    ),
  );
}
*/
