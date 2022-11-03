import 'dart:ui' as ui;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cron/cron.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sprint/screens/firebase_user_details.dart';
import 'package:sprint/screens/inviteFriends.dart';

import 'package:sprint/screens/form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dart:ui' as ui;

import 'package:flutter_easyloading/flutter_easyloading.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final Firestore = FirebaseFirestore.instance;
  late List<QueryDocumentSnapshot> pastJamiah;
  bool _isLoading = true;
  final _auth = FirebaseAuth.instance;
  bool loggedin = false;
  late User signedInUser;
  final cron1 = Cron();
  final cron27 = Cron();
  ScheduledTask? task1;
  ScheduledTask? task27;

  @override
  void initState() {
    print('home');
    _fcm.getToken().then((token) {
      //print("The token is:" + token!);
      Firestore.collection('tokens').add(
          {'token': token, 'userID': FirebaseAuth.instance.currentUser!.email});
    });
    super.initState();
    fetchUserfromFirebase();
    getCurrentUser();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      paymentReminderFirstOfMounth();
      paymentReminderAt27();
    });
    paymetnNotificationCheck();
    pastJamiah = getPastJamiah();
    //checkUserStatus();
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
                    .isAfter(DateTime.now()) &&
                member.get('status') == 'accepted') {
              print('isCurrentJamia ${element.data()}');
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
    print('CurrentJamiah $pastJamiah');

    return pastJamiah;
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        loggedin = true;
      }
    } catch (e) {
      EasyLoading.showError("حدث خطأ ما ....");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool visibilityController = true;
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        // appBar: AppBar(
        //   actions: <Widget>[],
        //   // title: const Text('                  جمعياتي ',
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
                    child: Text("لا يوجد لديك جمعيات!!"),
                  )
                : ListView(
                    children: pastJamiah.map((reqt) {
                      return Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(reqt.get('name')),
                              leading: CircleAvatar(
                                  backgroundColor: Color(0xFF0F7C0D),
                                  child: Image.asset('images/logo.jpg')),
                              subtitle:
                                  Text(" هل تريد معرفة المزيد من التفاصيل "),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                DateTime.now().isBefore(
                                        reqt.get('startDate').toDate())
                                    ? Column(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            inviteFriends(
                                                                data: reqt)));
                                              },
                                              child: const Icon(
                                                Icons.person_add_alt,
                                                color: Color(0xFF545454),
                                                size: 27,
                                              )),
                                          // const Text('   ادعو اصدقائك    ',
                                          //     style: const TextStyle(
                                          //         fontWeight: FontWeight.bold,
                                          //         fontFamily:
                                          //             "Montsterrat Classic",
                                          //         color: Color(0xFF545454))),
                                        ],
                                      )
                                    : Container(),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FirebaseUserDetails(
                                                      data: reqt,
                                                      jamiaId: '',
                                                    )));
                                      },
                                      child: Icon(
                                        Icons.visibility,
                                        color: Color(0xFF545454),
                                        size: 27,
                                      )),
                                  // Text('   التفاصيل  ',
                                  //     style: const TextStyle(
                                  //         fontWeight: FontWeight.bold,
                                  //         fontFamily: "Montsterrat Classic",
                                  //         color: Color(0xFF545454))),
                                ]),
                                SizedBox(
                                  width: 10,
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
        //               Navigator.pushNamed(context, '/JamiaHistory');
        //             },
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Icon(Icons.people),
        //                 Text("جمعياتي السابقة"),
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

  fetchUserfromFirebase() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  ///30 8 1 * * '
  void paymentReminderFirstOfMounth() async {
    // final querySnapshots = await getJamias();
    // if (querySnapshots.docs.length != 0) {
    //   for (var element in querySnapshots.docs) {
    //     final paymentRecords = await FirebaseFirestore.instance
    //         .collection('JamiaGroup')
    //         .doc(element.data()['id'])
    //         .collection('transaction')
    //         .where('Email', isEqualTo: signedInUser.email)
    //         .get();
    //     var paid = false;
    //     List<dynamic> timelocal = List<dynamic>.empty(growable: true);
    //     paymentRecords.docs.forEach((element) {
    //       var timenow = DateTime.parse(element.get('time'));
    //       timelocal.add(timenow);
    //     });
    //     var max = DateTime.parse('1969-07-20 20:18:04Z');
    //     if (timelocal.isNotEmpty) max = timelocal.first;
    //     for (var i = 1; i < timelocal.length; i++) {
    //       if (timelocal[i].isAfter(max)) max = timelocal[i];
    //     }
    //     if ((max.month).compareTo(DateTime.now().month) == 0) paid = true;
    //     final jamia = await FirebaseFirestore.instance
    //         .collection('JamiaGroup')
    //         .doc(element.data()['id'])
    //         .get();
    //     DateTime start = jamia.data()!['startDate'].toDate();
    //     //DateTime.parse(jamia.data()!['startDate'].toString());
    //     DateTime end = jamia.data()!['endDate'].toDate();
    //     //DateTime.parse(jamia.data()!['endDate']);
    //     if (start.isBefore(DateTime.now()) &&
    //         end.isAfter(DateTime.now()) &&
    //         !paid) {
    //       print('yay');
    //       task1 = cron1.schedule(Schedule.parse('30 8 1 * *'), () async {
    //         print('second notification 1');

    //         await AwesomeNotifications().createNotification(
    //             content: NotificationContent(
    //           id: 2,
    //           channelKey: 'key1',
    //           title: 'حبينا نذكرك',
    //           body: 'لا تنسى تدفع للجمعيات المشارك فيها',
    //         ));
    //       });
    //     } else {
    //       print('nooooooooo');
    //     }
    //   }
    // }
  }

  void paymentReminderAt27() async {
    // final querySnapshots = await getJamias();
    // if (querySnapshots.docs.length != 0) {
    //   for (var element in querySnapshots.docs) {
    //     final paymentRecords = await FirebaseFirestore.instance
    //         .collection('JamiaGroup')
    //         .doc(element.data()['id'])
    //         .collection('transaction')
    //         .where('Email', isEqualTo: signedInUser.email)
    //         .get();
    //     var paid = false;
    //     List<dynamic> timelocal = List<dynamic>.empty(growable: true);
    //     paymentRecords.docs.forEach((element) {
    //       var timenow = DateTime.parse(element.get('time'));
    //       timelocal.add(timenow);
    //     });
    //     var max = DateTime.parse('1969-07-20 20:18:04Z');
    //     if (timelocal.isNotEmpty) max = timelocal.first;
    //     for (var i = 1; i < timelocal.length; i++) {
    //       if (timelocal[i].isAfter(max)) max = timelocal[i];
    //     }
    //     if ((max.month).compareTo(DateTime.now().month) == 0) paid = true;
    //     final jamia = await FirebaseFirestore.instance
    //         .collection('JamiaGroup')
    //         .doc(element.data()['id'])
    //         .get();
    //     DateTime start = jamia.data()!['startDate'].toDate();
    //     //DateTime.parse(jamia.data()!['startDate'].toString());
    //     DateTime end = jamia.data()!['endDate'].toDate();
    //     //DateTime.parse(jamia.data()!['endDate']);
    //     if (start.isBefore(DateTime.now()) &&
    //         end.isAfter(DateTime.now()) &&
    //         !paid) {
    //       print('yay');
    //       task27 = cron27.schedule(Schedule.parse('30 8 27 * *'), () async {
    //         print('second notification 27');

    //         await AwesomeNotifications().createNotification(
    //             content: NotificationContent(
    //           id: 2,
    //           channelKey: 'key1',
    //           title: 'حبينا نذكرك',
    //           body: 'اليوم 27 الشهر قرب ينتهي ! لا تنسى تدفع لجمعياتك',
    //         ));
    //       });
    //     } else {
    //       print('nooooooooo');
    //     }
    //   }
    // }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getJamias() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(signedInUser.email)
        .collection("JamiaGroups")
        .get();
  }

  void paymetnNotificationCheck() {
    final cron = Cron();
    cron.schedule(Schedule.parse('0 0 * * * '), () async {
      //print('notification check');
      final querySnapshots = await getJamias();
      if (querySnapshots.docs.length != 0) {
        for (var element in querySnapshots.docs) {
          final paymentRecords = await FirebaseFirestore.instance
              .collection('JamiaGroup')
              .doc(element.data()['id'])
              .collection('transaction')
              .where('Email', isEqualTo: signedInUser.email)
              .get();
          var paid = false;
          List<dynamic> timelocal = List<dynamic>.empty(growable: true);
          paymentRecords.docs.forEach((element) {
            var timenow = DateTime.parse(element.get('time'));
            timelocal.add(timenow);
          });
          var max = DateTime.parse('1969-07-20 20:18:04Z');
          if (timelocal.isNotEmpty) max = timelocal.first;
          for (var i = 1; i < timelocal.length; i++) {
            if (timelocal[i].isAfter(max)) max = timelocal[i];
          }
          if ((max.month).compareTo(DateTime.now().month) == 0) paid = true;
          final jamia = await FirebaseFirestore.instance
              .collection('JamiaGroup')
              .doc(element.data()['id'])
              .get();
          if (paid) {
            //print('really cancel');
            canedlnot();
          }
        }
      }
    });
  }

  void canedlnot() {
    //print('cancel');
    //print(task1.toString());
    //print(task27.toString());
    task1?.cancel();
    task27?.cancel();
  }

  // void checkUserStatus() {
  //   bool sent = false;
  //   final cron = Cron();
  //   //every day?
  //   cron.schedule(Schedule.parse('*/5 * * * * *'), () async {
  //     print('Check user\'s status');
  //     final stauts = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(signedInUser.email)
  //         .get();
  //     //print(stauts.get('status'));
  //     if (stauts.get('status') == 1 && loggedin) {
  //       loggedin = false;
  //       print('log out');
  //       await _auth.signOut();
  //       if (mounted) {
  //         print('mounted');
  //         Navigator.pushNamed(context, '/login');
  //         print('after');
  //       }
  //       //Navigator.pushNamed(context, '/login');
  //       if (!sent) {
  //         print('sent');
  //         await AwesomeNotifications().createNotification(
  //             content: NotificationContent(
  //           id: 2,
  //           channelKey: 'key1',
  //           title: 'تم إيقاف حسابك',
  //           body: 'بإمكانك التواصل معنا لمعرفة التفاصيل',
  //         ));
  //         sent = true;
  //       }
  //     }
  //   });
  // }
}
