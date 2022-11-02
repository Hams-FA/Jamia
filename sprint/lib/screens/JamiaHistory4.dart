import 'dart:convert';

import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sprint/screens/JamiaMembersDetails.dart';
import 'package:sprint/screens/form.dart';
import 'package:http/http.dart' as http;

class JamiaHistory4 extends StatefulWidget {
  const JamiaHistory4({super.key});

  @override
  State<JamiaHistory4> createState() => _JamiaHistory4State();
}

class _JamiaHistory4State extends State<JamiaHistory4> {
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
    DateTime startDate = DateTime.now();
    //List<String> selectedEmails = List<String>.empty(growable: true);
    late List<QueryDocumentSnapshot> selectedEmails = [];

    bool visibilityController = true;
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        // appBar: AppBar(
        //   actions: <Widget>[
        //     /*IconButton(
        //         icon: Icon(Icons.home),
        //         onPressed: () async {
        //           Navigator.pushNamed(context, '/home');
        //         }),*/
        //   ],
        //   // title: const Text('جمعياتي السابقة',
        //   //     textAlign: TextAlign.right,
        //   //     overflow: TextOverflow.ellipsis,
        //   //     style: const TextStyle(
        //   //         //fontFamily: "Montsterrat Classic",
        //   //         color: Color.fromARGB(255, 255, 255, 255))),
        //   // backgroundColor: Color.fromARGB(255, 76, 175, 80)
        // ),
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
                      showAlertDialog(BuildContext context) {
                        // set up the buttons
                        Widget cancelButton = TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor:
                                  ui.Color.fromARGB(255, 87, 85, 85)),
                          child: Text("تراجع"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        );
                        Widget continueButton = TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.green),
                            child: Text("تأكيد"),
                            onPressed:
                                //Navigator.pop(context);

                                () async {
                              await FirebaseFirestore.instance
                                  .collection('JamiaGroup')
                                  .doc(reqt.id)
                                  .update({
                                'startDate': startDate,
                                'endDate':
                                    startDate.add(const Duration(days: 30)),
                                'acceptedCount': 1,
                                'JamiaTrun': 1
                              });
                              await FirebaseFirestore.instance
                                  .collection('JamiaGroup')
                                  .doc(reqt.id)
                                  .collection('members')
                                  .get()
                                  .then(
                                (value) {
                                  value.docs.forEach((member) {
                                    if (member.id != reqt.get("emailid")) {
                                      selectedEmails.add(member);
                                    }
                                  });
                                  print("selectedEmails: is --->  ");
                                  print(selectedEmails);
                                  selectedEmails.forEach((element) async {
                                    final docInviteFriends = FirebaseFirestore
                                        .instance
                                        .collection('JamiaGroup')
                                        .doc(reqt.id)
                                        .collection('members');
                                    docInviteFriends
                                        .doc(element.id)
                                        .set({'status': 'pending'});
                                    final docSnapshot = await FirebaseFirestore
                                        .instance
                                        .collection("requestList")
                                        .add({
                                      'email': element.id,
                                      'jamiaID': reqt.id
                                    });
                                    FirebaseFirestore.instance
                                        .collection('JamiaGroup')
                                        .doc(reqt.id)
                                        .collection('transaction')
                                        .get()
                                        .then((QuerySnapshot querySnapshot) {
                                      querySnapshot.docs.forEach((doc) {
                                        doc.reference.delete();
                                      });
                                    });
                                    FirebaseFirestore.instance
                                        .collection('JamiaGroup')
                                        .doc(reqt.id)
                                        .collection('members')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.email)
                                        .update({
                                      'name': FirebaseAuth
                                          .instance.currentUser!.email,
                                      'turn': 1,
                                      'status': 'accepted',
                                      'date': DateTime.now(),
                                    });
                                    FirebaseFirestore.instance
                                        .collection('tokens')
                                        .where('userID', isEqualTo: element)
                                        .limit(1)
                                        .get()
                                        .then((value) {
                                      final tokens = value.docs;
                                      tokens.forEach((e) {
                                        sendPushMessage(
                                            'انقر لمراجعتها الان',
                                            '!لقد تمت دعوتك لتجديد جمعية سابقة',
                                            e.get('token'));
                                      });
                                    });
                                  });
                                  if (mounted) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    EasyLoading.dismiss();
                                    EasyLoading.showSuccess(
                                        'تمت اعادة الجمعية والدعوة لها من جديد بنجاح');
                                  } else {
                                    EasyLoading.dismiss();
                                    EasyLoading.showError(
                                        'حدث خطأ الرجاء المحاولة مرة اخرى');
                                  }
                                },

                                //Navigator.pop(context);
                              );
                            });
                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          title: Text("إعادة بدء الجمعية"),
                          content:
                              Text(" هل أنت متأكد من رغبتك في إعادة بدء جمعية"
                                      "       من جديد؟( " +
                                  reqt.get('name') +
                                  " ) "),
                          actions: [
                            cancelButton,
                            continueButton,
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

                      showDataAlert() {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      20.0,
                                    ),
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(
                                  top: 10.0,
                                ),
                                title: Text(
                                  "اختر تاريخ البدء الجديد",
                                  style: TextStyle(fontSize: 24.0),
                                ),
                                content: Container(
                                  height: 400,
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'تاريخ البدء : ${startDate.day}-${startDate.month}-${startDate.year}',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color.fromARGB(
                                                      255, 76, 175, 80),
                                                ),
                                                onPressed: () async {
                                                  DateTime? newDate =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              startDate,
                                                          firstDate:
                                                              DateTime.now(),
                                                          lastDate:
                                                              DateTime(2100));
                                                  if (newDate == null) return;

                                                  setState(() {
                                                    startDate = newDate;
                                                    //.add(Duration(days: 14));

                                                    // endDate = DateTime(startDate.year,
                                                    //     startDate.month, startDate.day + 14);
                                                  });
                                                },
                                                child:
                                                    Text('أختر تاريخ البدء')),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color.fromARGB(
                                                      255, 76, 175, 80),
                                                ),
                                                onPressed: () {
                                                  showAlertDialog(context);
                                                },
                                                child: Text('ارسـال')),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color.fromARGB(
                                                      255, 76, 175, 80),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('تراجـع')),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '                                  ملاحظة',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '                سوف يتم ارسال عوه جديدة لجميع الاعضاء ',
                                            style: TextStyle(fontSize: 12),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }

                      return Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(reqt.get('name')),
                              leading: CircleAvatar(
                                  backgroundColor: Color(0xFF0F7C0D),
                                  child: Image.asset('images/logo.jpg')),
                              subtitle: Text(
                                  " هل تريد معرفة التفاصيل وتقييم اعضاء الجمعية !!"),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                reqt.get('emailid') ==
                                        FirebaseAuth.instance.currentUser!.email
                                    ? IconButton(
                                        icon: const Icon(Icons.restart_alt),
                                        onPressed: () {
                                          showDataAlert();
                                          //showAlertDialog(context);
                                        },
                                      )
                                    : Container(),
                                IconButton(
                                  icon: const Icon(Icons.visibility),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                JamiaMembersDetails(
                                                    data: reqt.data()
                                                        as Map<String, dynamic>,
                                                    jamiaId: reqt.id)));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Color.fromARGB(255, 76, 175, 80),
        //   onPressed: () {
        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (context) => FormPage()));
        //   },
        //   mini: true,
        //   child: const Icon(
        //     Icons.add,
        //     color: Color(0xFF393737),
        //   ),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
        // floatingActionButtonLocation:
        //     FloatingActionButtonLocation.miniCenterDocked,

        // bottomNavigationBar: BottomAppBar(
        //     shape: CircularNotchedRectangle(),
        //     child: Container(
        //       height: 60,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           MaterialButton(
        //             onPressed: () {
        //               Navigator.pushNamed(context, '/viewUserProfile');
        //             },
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Icon(Icons.person),
        //                 Text("الملف الشخصي"),
        //               ],
        //             ),
        //             minWidth: 40,
        //           ),
        //           MaterialButton(
        //             onPressed: () {
        //               Navigator.pushNamed(context, '/ViewAndDeleteFriends');
        //             },
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Icon(Icons.man),
        //                 Text("اصدقائك"),
        //               ],
        //             ),
        //             minWidth: 40,
        //           ),
        //           MaterialButton(
        //             onPressed: () {
        //               Navigator.pushNamed(context, '/home');
        //             },
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Icon(Icons.people),
        //                 Text("جمعياتي"),
        //               ],
        //             ),
        //             minWidth: 40,
        //           ),
        //           MaterialButton(
        //             onPressed: () {
        //               Navigator.pushNamed(context, '/RequestPageFinal');
        //             },
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Icon(Icons.list_alt),
        //                 Text("الطلبات"),
        //               ],
        //             ),
        //             minWidth: 40,
        //           ),
        //         ],
        //       ),
        //     )
        //     ),
      ),
    );
  }
}
