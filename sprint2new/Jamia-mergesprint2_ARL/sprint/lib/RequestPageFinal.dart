import 'package:flutter/material.dart';
import 'package:sprint/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sprint/more_details.dart';
import 'dart:ui' as ui;

import 'package:sprint/screens/firebase_user_details.dart';
import 'package:sprint/screens/form.dart';

class RequestPageFinal extends StatelessWidget {
  const RequestPageFinal({super.key});

  @override
  Widget build(BuildContext context) {
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
            title: const Text('طلبات الإضافة',
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    //fontFamily: "Montsterrat Classic",
                    color: Color.fromARGB(255, 255, 255, 255))),
            backgroundColor: Color.fromARGB(255, 76, 175, 80)),
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
                        /*Icon(
                          Icons.hourglass_empty,
                          size: 100,
                        ),*/
                        Text('لا يوجد طلبات جارية',
                            style: Theme.of(context).textTheme.headline6),
                      ],
                    ),
                  );
                }
                return ListView(
                  children: reqts.map((e) => buildCard(e, context)).toList(),
                );
              } else {
                return Text('حدث خطأ ما',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montsterrat Classic",
                        color: Color(0xFF545454)));
              }
            }),
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
              child: Image.asset('images/logo.jpg')),
          subtitle: Text(" متشوقين لانضمامك معنا!!"),
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
              child: const Text('للمزيد من التفاصيل',
                  style: const TextStyle(
                      decoration: TextDecoration.underline,
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
                final members = await jamia.reference
                    .collection('members')
                    .where('status', isEqualTo: 'accepted')
                    .get();
                final limit = jamia['maxMembers'];
                if (members.size < limit) {
                  // add user to jamia members

                  // await FirebaseFirestore.instance
                  //     .collection('JamiaGroup')
                  //     .doc(doc['jamiaID'])
                  //     .update({'members': members});
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

                  //var date = new DateTime(jamia['endDate'].year, jamia['endDate'].month , jamia['endDate'].day);
                  /*DateTime endDate1 = jamia['endDate'].toDate();
                  DateTime endDate2 = endDate1.add(const Duration(days: 30));
                  FirebaseFirestore.instance
                      .collection('JamiaGroup')
                      .doc(doc['jamiaID'])
                      .get()
                      .then((value) {
                    endDate1 = value.get({'endDate'}).toDate();
                  });
                  DateTime endDate4 = endDate1.add(const Duration(days: 30));
                  */
                  DateTime EndDate(dynamic dateValue) {
                    if (dateValue is DateTime) {
                      return dateValue;
                    } else if (dateValue is String) {
                      return DateTime.parse(dateValue);
                    } else if (dateValue is Timestamp) {
                      return dateValue.toDate();
                    } else {
                      return new DateTime(2001, 11, 28);
                    }
                  }

                  DateTime endDateB = EndDate(jamia['endDate']);
                  DateTime endDateA = endDateB.add(const Duration(days: 30));
                  FirebaseFirestore.instance
                      .collection('JamiaGroup')
                      .doc(doc['jamiaID'])
                      .update({
                    'acceptedCount': FieldValue.increment(1),
                    'endDate': endDateA
                  });
                  FirebaseFirestore.instance
                      .collection('JamiaGroup')
                      .doc(doc['jamiaID'])
                      .collection('members')
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .update({
                    'name': FirebaseAuth.instance.currentUser!.email,
                    // 'email': doc['email'],
                    // 'phone': doc['phone'],
                    // 'amount': doc['amount'],
                    // 'endDate': doc['endDate'],
                    'turn': members.size + 1,
                    'status': 'accepted',
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

                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .collection('JamiaGroups')
                        .doc(doc.id)
                        .update({'endDate': value.get('endDate')});
                  });

                  /*

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
                        .update({'endDate': endDateA});
                  });
*/
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('تمت العملية بنجاح'),
                    duration: Duration(seconds: 2),
                  ));

                  await doc.reference.delete();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('تم الوصول للحد الأقصى لعدد الأعضاء'),
                    duration: Duration(seconds: 2),
                  ));
                  // show error message

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
