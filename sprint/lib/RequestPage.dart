import 'package:flutter/material.dart';
import 'package:sprint/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:url_launcher/url_launcher.dart';



import 'firebase_options.dart';

class RequestPage extends StatelessWidget {
  const RequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection : ui.TextDirection.rtl ,
     child :Scaffold(
      
      appBar: AppBar(
      actions:<Widget> [
        IconButton(icon: Icon(Icons.home) , onPressed:() async {
  const url = 'https://github.com/Hams-FA/Jamia/blob/FatimaBranch-Jamia/create_jamia/create_jamia/lib/home.dart';
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
              .collection('Requests')
              .where('status', isEqualTo: 'Pending')
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
              return Text('حدث خطأ ما');
          }),
    ),);
  }
}

// card with title and subtitle and action buttons
Card buildCard(QueryDocumentSnapshot doc) {
  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
          
            backgroundColor: Color(0xFF0F7C0D),
            child: Text(doc.get('jamia_id')),
          ),
          title: Text(doc.get('status')),
          subtitle: Text(doc.get('user_email')),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              child: const Text('قبول',
               
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold , fontFamily: "Montsterrat Classic" , color: Color(0xFF0F7C0D))),
              onPressed: () {
                doc.reference.update({'status': 'Accepted'});
              },
            ),
            const SizedBox(width: 8),
            TextButton(
              child: const Text('رفض' ,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold , fontFamily: "Montsterrat Classic" , color: Color.fromARGB(255, 173, 22, 22))),
              onPressed: () {
                // Rejected
                doc.reference.update({'status': 'Rejected'});
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    ),
  );
}

