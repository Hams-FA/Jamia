import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sprint/screens/user_model.dart';
import 'package:sprint/screens/firestore_helper.dart';
import 'package:sprint/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class inviteFriends extends StatefulWidget {
  const inviteFriends({super.key, this.data});

  final data;
  @override
  State<inviteFriends> createState() => _inviteFriendsState();
}

class _inviteFriendsState extends State<inviteFriends> {
  void sendPushMessage(String body, String title, String token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAiGTJayc:APA91bH8EQZpQtqKV_w9cYujZcxgl0HBCnYlN3xrYSfGWO1sOqKM2953gpAixiOBbEEhr4hm3RSZ4a0BXcZjmXMLZYFQazN26vAhiZFE7VL54Hx4fVyB6GGjvafVOLcP3wiG30ccJ4zK',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      print('done');
    } catch (e) {
      print("error push notification");
    }
  }

  Map<String, bool?> checked = new Map();
  List<String> selectedEmails = List<String>.empty(growable: true);
  List<dynamic> invitedAlready = List<dynamic>.empty(growable: true);

  var jamiaId;
  var len; //delete this? no need to check for max here
  bool allinvited = true;

  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  void initState() {
    //print('befor invited');
    //print(invitedAlready);
    super.initState();
    jamiaId = widget.data['id'];

    //print(widget.data['maxMembers']);
    getCurrentUser();
    readInvited211();
    //print('after invited');
    //print(invitedAlready);
    //print('why after');
    //print(widget.data);
    //print(jamiaId);
    //print(signedInUser.email);
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
    return Scaffold(
        appBar: AppBar(
            title: Text("دعوة صديق إلى الجمعية"),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 76, 175, 80)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              /*
              if (allinvited) ...[
                Center(child: Text('! دعيت كل أصحابك')),
              ] else ...[
                */
              StreamBuilder<List<UserModel>>(
                  stream: FirestoreHelper.readFromUsers(signedInUser.email),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("حدث خطأ ما ...."),
                      );
                    }

                    if (snapshot.data!.isEmpty) {
                      return Expanded(
                          child: Center(
                              child: Text('عذراً، لا يوجد لديك اصدقاء')));
                    }

                    if (snapshot.hasData) {
                      final userData = snapshot.data;

                      return Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: userData!.length,
                                  itemBuilder: (context, index) {
                                    final singleUser = userData[index];
                                    if (!invitedAlready
                                        .contains(singleUser.Email)) {
                                      allinvited = false;
                                      checked['${singleUser.Email}'] = false;
                                      return Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: StatefulBuilder(
                                          builder: (context, setState) =>
                                              Directionality(
                                            textDirection: ui.TextDirection.rtl,
                                            child: (CheckboxListTile(
                                              secondary: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    shape: BoxShape.circle),
                                              ),
                                              title: Text(
                                                "${singleUser.fname} ${singleUser.lname}",
                                                style: TextStyle(
                                                  color: Color(0xFF393737),
                                                ),
                                              ),
                                              subtitle:
                                                  Text("${singleUser.Email}"),
                                              activeColor: Color.fromARGB(
                                                  255, 76, 175, 80),
                                              checkColor: Colors.white,
                                              value: checked[
                                                  '${singleUser.Email}'],
                                              onChanged: (val) {
                                                setState(() {
                                                  checked['${singleUser.Email}'] =
                                                      val;
                                                  if (checked[
                                                          '${singleUser.Email}'] ==
                                                      true) {
                                                    selectedEmails.add(
                                                        '${singleUser.Email}');
                                                  } else if (checked[
                                                          '${singleUser.Email}'] ==
                                                      false) {
                                                    selectedEmails.removeWhere(
                                                        (element) =>
                                                            element ==
                                                            '${singleUser.Email}');
                                                  }
                                                });
                                              },
                                            )),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Text('');
                                    }
                                  }),
                            ),
                            SizedBox(
                              height: 42, //height of button
                              width: 200,
                              //height: 42,
                              //                  width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 76, 175, 80),
                                  ),
                                  onPressed: () {
                                    selectedEmails.forEach((element) async {
                                      final docInviteFriends = FirebaseFirestore
                                          .instance
                                          .collection('JamiaGroup')
                                          .doc(jamiaId)
                                          .collection('members');
                                      docInviteFriends
                                          .doc(element)
                                          .set({'status': 'pending'});
                                      FirebaseFirestore.instance
                                          .collection('tokens')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          //.limit(1)
                                          .get()
                                          .then((value) {
                                        final tokens = value;
                                        sendPushMessage(
                                            'انقر لمراجعتها الان',
                                            '!لقد تمت دعوتك لجمعية جديدة',
                                            tokens.get('token'));
                                      });

                                      final docSnapshot =
                                          await FirebaseFirestore.instance
                                              .collection("requestList")
                                              .add({
                                        'email': element,
                                        'jamiaID': jamiaId
                                      });
                                    });
                                    Navigator.pushNamed(context, '/home');
                                    //Navigator.pop(context);
                                    //}

                                    Fluttertoast.showToast(
                                      msg:
                                          "قمت بدعوة  ${selectedEmails.length} من أصدفائك",
                                      toastLength: Toast.LENGTH_SHORT,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  },
                                  child: Text("دعوة")),
                            ),
                          ],
                        ),
                      );
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ],
          ),
        ));
  }

  void readInvited211() async {
    List<dynamic> feature = await readInvited2();
    feature.forEach((element) {
      invitedAlready.add(element);
    });

    ///--------------------- this for max? if so no need
    final docInviteFriends = FirebaseFirestore.instance
        .collection('JamiaGroup')
        .doc(jamiaId)
        .collection('members');
    len = await docInviteFriends.snapshots().length;
  }

  Future<List<dynamic>> readInvited2() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("JamiaGroup")
        .doc(jamiaId)
        .collection('members')
        .get();

    List<dynamic> res = List<dynamic>.empty(growable: true);

    querySnapshot.docs.forEach((element) {
      res.add(element.id);
    });
    return res;
  }
}
