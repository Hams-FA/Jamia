import 'dart:convert';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final Firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  final cron1 = Cron();
  final cron27 = Cron();
  ScheduledTask? task1;
  ScheduledTask? task27;

  @override
  void initState() {
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
    return Directionality(
        textDirection: ui.TextDirection.rtl,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Text(
                    '                      جـمـعـيـاتـي ',
                    style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 255, 254, 254),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
              backgroundColor: Color.fromARGB(255, 76, 175, 80),
              automaticallyImplyLeading: false,
            ),
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(signedInUser.email)
                              .collection('JamiaGroups')
                              .snapshots(),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    var data = snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>;
                                    return Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          alignment: Alignment.topLeft,
                                          color: Colors.grey.shade300,
                                          child: Directionality(
                                              textDirection:
                                                  ui.TextDirection.rtl,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'الجمعية : ${data['name']}',
                                                        style: TextStyle(
                                                            fontSize: 17),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  ),
                                                  Column(children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          FirebaseUserDetails(
                                                                            data:
                                                                                data,
                                                                            jamiaId:
                                                                                '',
                                                                          )));
                                                        },
                                                        child: Icon(
                                                            Icons.visibility)),
                                                    Text('التفاصيل')
                                                  ]),
                                                  Column(
                                                    children: [
                                                      GestureDetector(
                                                          onTap: () {
                                                            /*
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        inviteFriends()));
                                                        */

                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        inviteFriends(
                                                                            data:
                                                                                data)));
                                                          },
                                                          child: const Icon(Icons
                                                              .person_add_alt)),
                                                      const Text('ادعو اصدقائك')
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    );
                                  });
                            }
                            return Container(
                              child: Text('No data found'),
                            );
                          }))),
                  /*Container(
                  padding: EdgeInsets.only(bottom: 40),
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 76, 175, 80),
                    ),
                    onPressed: () {},
                    child: Text('ادعو اصدقائك'),
                  )),*/
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 76, 175, 80),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FormPage()));
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
                            Text(" اصدقائك"),
                          ],
                        ),
                        minWidth: 40,
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/JamiaHistory');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people),
                            Text("الجمعيات السابقة"),
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
        ));
  }

  fetchUserfromFirebase() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  ///30 8 1 * * '
  void paymentReminderFirstOfMounth() async {
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
        DateTime start = jamia.data()!['startDate'].toDate();
        //DateTime.parse(jamia.data()!['startDate'].toString());
        DateTime end = jamia.data()!['endDate'].toDate();
        //DateTime.parse(jamia.data()!['endDate']);
        if (start.isBefore(DateTime.now()) &&
            end.isAfter(DateTime.now()) &&
            !paid) {
          print('yay');
          task1 = cron1.schedule(Schedule.parse('*/10 * * * * * '), () async {
            print('second notification 1');

            await AwesomeNotifications().createNotification(
                content: NotificationContent(
              id: 2,
              channelKey: 'key1',
              title: 'حبينا نذكرك',
              body: 'لا تنسى تدفع للجمعيات المشارك فيها',
            ));
          });
        } else {
          print('nooooooooo');
        }
      }
    }
  }

  void paymentReminderAt27() async {
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
        DateTime start = jamia.data()!['startDate'].toDate();
        //DateTime.parse(jamia.data()!['startDate'].toString());
        DateTime end = jamia.data()!['endDate'].toDate();
        //DateTime.parse(jamia.data()!['endDate']);
        if (start.isBefore(DateTime.now()) &&
            end.isAfter(DateTime.now()) &&
            !paid) {
          print('yay');
          task27 = cron27.schedule(Schedule.parse('*/15 * * * * * '), () async {
            print('second notification 27');

            await AwesomeNotifications().createNotification(
                content: NotificationContent(
              id: 2,
              channelKey: 'key1',
              title: 'حبينا نذكرك',
              body: 'اليوم 27 الشهر قرب ينتهي ! لا تنسى تدفع لجمعياتك',
            ));
          });
        } else {
          print('nooooooooo');
        }
      }
    }
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
    cron.schedule(Schedule.parse('*/5 * * * * * '), () async {
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
}
