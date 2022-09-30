import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sprint/screens/user_model.dart';
import 'package:sprint/screens/firestore_helper.dart';
import 'package:sprint/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class inviteFriends extends StatefulWidget {
  const inviteFriends({super.key, this.data});

  final data;
  @override
  State<inviteFriends> createState() => _inviteFriendsState();
}

class _inviteFriendsState extends State<inviteFriends> {
  Map<String, bool?> checked = new Map();
  List<String> selectedEmails = List<String>.empty(growable: true);
  List<dynamic> invitedAlready = List<dynamic>.empty(growable: true);

  var jamiaId; //change this to id coming from selected jamia
  var len; //delete this? no need to check for max here
  bool allinvited = true;

  //need to update this User
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
                                    //print('email friends users');
                                    //print(singleUser.Email);
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
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 76, 175, 80),
                                ),
                                onPressed: () {
                                  //print('on pressed');
                                  //print(selectedEmails.length); //
                                  //if (selectedEmails.length > widget.data['maxMembers']) {
                                  selectedEmails.forEach((element) async {
                                    final docInviteFriends = FirebaseFirestore
                                        .instance
                                        .collection('JamiaGroup')
                                        .doc(jamiaId)
                                        .collection('members');
                                    /*.doc(element);
                      print('number');
                      //int len = await docInviteFriends.snapshots().length;
                      print(len);
                      print(selectedEmails.length);*/
                                    docInviteFriends
                                        .doc(element)
                                        .set({'status': 'pending' });

                                    /*final updateRequestList = FirebaseFirestore.instance
                          .collection('requestList')
                          .doc(element);*/

                                    final docSnapshot = await FirebaseFirestore
                                        .instance
                                        .collection("requestList")
                                        .add({
                                      'email': element,
                                      'jamiaID': jamiaId
                                    });
                                  });

                                  /*if (docSnapshot.exists) {
                        updateRequestList.update({jamiaId: true});
                      } else {
                        updateRequestList.set({jamiaId: true});
                      }
                    });*/
                                  Navigator.pushNamed(context, '/home');
                                  //Navigator.pop(context);
                                  //}
                                  /*
                    else {
                      showAlertDialog(BuildContext context) {
                        // set up the button
                        Widget okButton = TextButton(
                          child: Text("OK"),
                          onPressed: () {},
                        );

                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          title: Text("الدعوة غير ممكنة"),
                          content: Text("أكثر من العدد الأقصى المحدد للجمعية"),
                          actions: [
                            okButton,
                          ],
                        );

                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      }
                      /*
                      AlertDialog alert = AlertDialog(
                        title: Text("My title"),
                        content: Text("This is my message."),
                        actions: <Widget>[
                          TextButton(child: Text("Yes"),
                          onPressed: null,),  
                        ],
                      );

                      // show the dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    */
                    }*/
                                },
                                child: Text("دعوة"))
                          ],
                        ),
                      );
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
              //],
            ],
          ),
        ));
  }

  void readInvited211() async {
    List<dynamic> feature = await readInvited2();
    feature.forEach((element) {
      invitedAlready.add(element);
    });
    //print('readinvited211');
    ///print(invitedAlready);

    ///--------------------- this for max? if so no need
    final docInviteFriends = FirebaseFirestore.instance
        .collection('JamiaGroup')
        .doc(jamiaId)
        .collection('members');
    //.doc(element);
    //print('number');
    len = await docInviteFriends.snapshots().length;
    //print(len);
  }

  Future<List<dynamic>> readInvited2() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("JamiaGroup")
        .doc(jamiaId) //chenge this to jamia id
        .collection('members')
        .get();
    //print('querey snapshot');
    //print(querySnapshot.docs);
    List<dynamic> res = List<dynamic>.empty(growable: true);
    //print('readinvited2');
    querySnapshot.docs.forEach((element) {
      //print(element.id);
      res.add(element.id);
    });
    //print(res);
    return res;
  }
}
