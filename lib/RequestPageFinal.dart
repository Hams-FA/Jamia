import 'package:flutter/material.dart';
import 'package:sprint/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui' as ui;

class RequestPageFinal extends StatelessWidget {
  const RequestPageFinal({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.home),
                onPressed: () async {
                  Navigator.pushNamed(context, '/home');
                }),
          ],
          title: const Text('طلبات الإضافة',
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montsterrat Classic",
                  color: Color(0xFF545454))),
          backgroundColor: Color(0xFF0F7C0D),
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('requestList')
                .doc(FirebaseAuth.instance.currentUser!.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final reqts = snapshot.data!;
                if (!reqts.exists) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          size: 100,
                        ),
                        Text('لا يوجد طلبات جارية',
                            style: Theme.of(context).textTheme.headline6),
                      ],
                    ),
                  );
                }
                return buildCard(reqts);
              } else {
                return Text('حدث خطأ ما',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montsterrat Classic",
                        color: Color(0xFF545454)));
              }
            }),
      ),
    );
  }
}

// card with title and subtitle and action buttons
Card buildCard(DocumentSnapshot doc) {
  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('JamiaGroup')
                  .doc(doc['jamiaID'])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final jamiah = snapshot.data!;
                  return Text(jamiah['name']);
                } else
                  return Text('جاري التحميل',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montsterrat Classic",
                          color: Color(0xFF545454)));
              }),
          leading: CircleAvatar(
              backgroundColor: Color(0xFF0F7C0D),
              child: Text(doc.get('jamiaID'))),
          subtitle: Text(doc.id),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text('للمزيد من التفاصيل',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montsterrat Classic",
                      color: Color(0xFF545454))),
            ),
            TextButton(
              child: const Text('قبول',
                  style: TextStyle(
                      color: Colors.green, fontFamily: "Montsterrat Classic")),
              onPressed: () async {
                // add user to jamiahGroup to members collection
                FirebaseFirestore.instance
                    .collection('JamiaGroup')
                    .doc(doc['jamiaID'])
                    .collection('members')
                    .doc(doc.id)
                    .update({
                  'name': doc.id,
                  // 'email': doc['email'],
                  // 'phone': doc['phone'],
                  // 'amount': doc['amount'],
                  // 'endDate': doc['endDate'],
                  'status': 'Active',
                });
                FirebaseFirestore.instance
                    .collection('JamiaGroup')
                    .doc(doc['jamiaID'])
                    .get()
                    .then((value) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .collection('JamiaGroups')
                      .doc(doc.id)
                      .set(value.data()!);
                });

                doc.reference.delete();
              },
            ),
            const SizedBox(width: 8),
            TextButton(
              child: const Text('رفض',
                  style: TextStyle(
                      color: Colors.red, fontFamily: "Montsterrat Classic")),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('JamiaGroup')
                    .doc(doc['jamiaID'])
                    .collection('members')
                    .doc(doc.id)
                    .delete();
                // Rejected
                doc.reference.delete();
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    ),
  );
}