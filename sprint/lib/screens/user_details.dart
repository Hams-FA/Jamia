import 'package:sprint/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UserDetails extends StatefulWidget {
  const UserDetails(
      {Key? key,
      required this.name,
      required this.minMembers,
      required this.maxMembers,
      // required this.week,
      required this.amount,
      required this.startDate,
      required this.endDate})
      : super(key: key);
  final String name;
  final int minMembers;
  final int maxMembers;
  // final String week;
  final double amount;
  final String startDate;
  final String endDate;

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          title: //Text('معلومات الجمعية التي تم إنشائها')
              const Text(
            'معلومات الجمعية التي تم إنشائها',
            style: TextStyle(
                fontSize: 25,
                color: Color(0xFF393737),
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
          backgroundColor: Color.fromARGB(255, 76, 175, 80),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios_new))),
      body: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        color: Colors.grey.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                color: Colors.grey.shade200,
                child: Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: Row(
                      children: [
                        Text(
                          'أسم الجمعية:  ',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          widget.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ))),
            Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                color: Colors.grey.shade200,
                child: Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: Row(
                      children: [
                        Text(
                          ' الحد الادنى من الاعضاء:  ',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          widget.minMembers.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ))),
            Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                color: Colors.grey.shade200,
                child: Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Row(
                    children: [
                      Text(
                        ' الحد الاعلى من الاعضاء:  ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.maxMembers.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                )),
            // Container(
            //   padding: EdgeInsets.all(10),
            //   margin: EdgeInsets.all(10),
            //   color: Colors.grey.shade200,
            //   child: Row(
            //     children: [
            //       Text(
            //         widget.week.toString(),
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //       SizedBox(
            //         width: 20,
            //       ),
            //       Text(
            //         ' Days',
            //         style: TextStyle(fontSize: 18),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                color: Colors.grey.shade200,
                child: Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Row(
                    children: [
                      Text(
                        ' المبلغ الاجمالي:  ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.amount.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                )),
            Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                color: Colors.grey.shade200,
                child: Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Row(
                    children: [
                      Text(
                        ' تاريخ بدء الجمعية:  ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.startDate.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                )),
            Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                color: Colors.grey.shade200,
                child: Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Row(
                    children: [
                      Text(
                        ' تاريخ انتهاء الجمعية:  ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'لم يحدد حتى الان',
                        //widget.endDate.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 100,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 76, 175, 80),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('لـلـخـلـف'))),
                Container(
                    width: 100,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 76, 175, 80),
                        ),
                        onPressed: () {
                          saveUserData(
                              name: widget.name,
                              minMembers: widget.minMembers,
                              maxMembers: widget.maxMembers,
                              // week: widget.week,
                              amount: widget.amount,
                              startDate: widget.startDate,
                              endDate: widget.endDate);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('تم حفظ البيانات بنجاح'),
                            duration: Duration(milliseconds: 3000),
                          ));
                          Future.delayed(
                              const Duration(
                                milliseconds: 3000,
                              ), (() {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()));
                          }));
                        },
                        child: Text('تـأكـيـد'))),
              ],
            )
          ],
        ),
      ),
    ));
  }

  Future saveUserData(
      {required String name,
      required int minMembers,
      required int maxMembers,
      // required String week,
      required double amount,
      required String startDate,
      required String endDate}) async {
    final docUser = FirebaseFirestore.instance.collection('JamiaGroup').doc();

    final docUser1 = docUser.collection('members').doc(signedInUser.email);
    docUser1.set({'status': 'accepted' , 'turn': 1 , 'name': signedInUser.email, 'date': DateTime.now()});

    final docUser2 = FirebaseFirestore.instance
        .collection('users')
        .doc(signedInUser.email)
        .collection('JamiaGroups')
        .doc(docUser.id);
    docUser2.set({
      'name': name,
      'minMembers': minMembers,
      'maxMembers': maxMembers,
      // 'days': week,
      'amount': amount,
      'startDate': startDate,
      'endDate': endDate,
      'id': docUser.id,
    });

    final json = {
      'name': name,
      'minMembers': minMembers,
      'maxMembers': maxMembers,
      // 'days': week,
      'amount': amount,
      'startDate': startDate,
      'endDate': endDate,
      'id': docUser.id,
      'acceptedCount' : 1

    };

    await docUser.set(json);
  }
}
