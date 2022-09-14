import 'package:flutter/material.dart';
import 'package:sprint/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:url_launcher/url_launcher.dart';


class RequestPageF extends StatelessWidget {
  const RequestPageF({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection : ui.TextDirection.rtl ,
    child : Scaffold(
      appBar: AppBar(
         actions:<Widget> [
        IconButton(icon: Icon(Icons.home) , onPressed:() async {
  const url = 'home.dart';
  if (await canLaunch(url)) {
   await launch(url);
  } else {
   throw 'Could not launch $url';
  }}),
        ],
        title: const Text('طلبات الإضافة' ,
        textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold , fontFamily: "Montsterrat Classic" , color: Color(0xFF545454))),
        backgroundColor: Color(0xFF0F7C0D),
       
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('requestList')
              // .where('status', isEqualTo: 'Pending')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final reqts = snapshot.data!;
              if (reqts.docs.isEmpty) {
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
                children: reqts.docs
                    .map(
                      (doc) => buildCard(doc),
                    )
                    .toList(),
              );
            } else
              return Text('حدث خطأ ما' ,
              style: const TextStyle(fontWeight: FontWeight.bold , fontFamily: "Montsterrat Classic" , color: Color(0xFF545454)));
          }),
    ),);
  }
}

// card with title and subtitle and action buttons
Card buildCard(QueryDocumentSnapshot doc) {
  return 
   Card(
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
                  style: const TextStyle(fontWeight: FontWeight.bold , fontFamily: "Montsterrat Classic" , color: Color(0xFF545454))
                  );
              }),
          leading: CircleAvatar( backgroundColor: Color(0xFF0F7C0D) , child: Text(doc.get('jamiaID'))),
          subtitle: Text(doc.id),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
          
            
              TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: 
              const Text('للمزيد من التفاصيل', style: const TextStyle(fontWeight: FontWeight.bold , fontFamily: "Montsterrat Classic" , color: Color(0xFF545454) )),
            ),
            TextButton(
              child:
                  const Text('قبول', style: TextStyle(color: Colors.green , fontFamily: "Montsterrat Classic")),
              onPressed: () {
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
                doc.reference.delete();
              },
            ),
            const SizedBox(width: 8),
            TextButton(
              child: const Text('رفض', style: TextStyle(color: Colors.red , fontFamily: "Montsterrat Classic")),
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