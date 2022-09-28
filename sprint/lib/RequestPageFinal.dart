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
                  fontFamily: "Montsterrat Classic", color: Color(0xFF545454))),
          backgroundColor: Color(0xFF0F7C0D),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('requestList')
                .where('email',
                    isEqualTo: FirebaseAuth.instance.currentUser!.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final reqts = snapshot.data!.docs;
                if (reqts.isEmpty) {
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
                return ListView(
                  children: reqts.map((e) => buildCard(e)).toList(),
                );
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
                // get numbers of members in jamia and compare it with the limit
                final jamia = await FirebaseFirestore.instance
                    .collection('JamiaGroup')
                    .doc(doc['jamiaID'])
                    .get();
                final members =
                    await jamia.reference.collection('members').get();
                final limit = jamia['maxMembers'];
                if (members.size < limit) {
                  // add user to jamia members

                  await FirebaseFirestore.instance
                      .collection('JamiaGroup')
                      .doc(doc['jamiaID'])
                      .update({'members': members});
                  // add jamia to user jamia list
                  // final user = await FirebaseFirestore.instance
                  //     .collection('users')
                  //     .doc(doc['email'])
                  //     .get();
                  // final jamiaList = user['jamiaList'];
                  // jamiaList.add(doc['jamiaID']);
                  // await FirebaseFirestore.instance
                  //     .collection('users')
                  //     .doc(doc['email'])
                  //     .update({'jamiaList': jamiaList});
                  // // delete request
                  // await FirebaseFirestore.instance
                  //     .collection('requestList')
                  //     .doc(doc.id)
                  //     .delete();

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
                    'date': DateTime.now(),
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
                } else {
                  // show error message
                  SnackBar(
                    content: Text('تم الوصول للحد الأقصى لعدد الأعضاء',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montsterrat Classic",
                            color: Color(0xFF545454))),
                    backgroundColor: Colors.red,
                  );
                }
                // // add user to jamiahGroup to members collection
                // FirebaseFirestore.instance
                //     .collection('JamiaGroup')
                //     .doc(doc['jamiaID'])
                //     .collection('members')
                //     .doc(doc.id)
                //     .update({
                //   'name': doc.id,
                //   // 'email': doc['email'],
                //   // 'phone': doc['phone'],
                //   // 'amount': doc['amount'],
                //   // 'endDate': doc['endDate'],
                //   'status': 'Active',
                //   'date': DateTime.now(),
                // });
                // FirebaseFirestore.instance
                //     .collection('JamiaGroup')
                //     .doc(doc['jamiaID'])
                //     .get()
                //     .then((value) {
                //   FirebaseFirestore.instance
                //       .collection('users')
                //       .doc(FirebaseAuth.instance.currentUser!.email)
                //       .collection('JamiaGroups')
                //       .doc(doc.id)
                //       .set(value.data()!);
                // });

                // doc.reference.delete();
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
