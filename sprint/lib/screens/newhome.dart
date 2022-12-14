import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cron/cron.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'JamiaHistory4.dart';
import 'form.dart';
import 'home.dart';
import 'dart:ui' as ui;

class NewHome extends StatefulWidget {
  const NewHome({Key? key}) : super(key: key);
  @override
  State<NewHome> createState() => _NewHome();
}

class _NewHome extends State<NewHome> {
  late User signedInUser;
  final auth = FirebaseAuth.instance;
  final _auth = FirebaseAuth.instance;
  bool loggedin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    checkUserStatus();
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
    return Directionality(
        textDirection: ui.TextDirection.rtl,
        child: MaterialApp(
          home: DefaultTabController(
            length: 2,
            child: Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                    bottom: TabBar(
                      tabs: [
                        Tab(
                            icon: Icon(Icons.people_alt),
                            text: 'جمعياتي الحالية'),
                        Tab(
                          icon: Icon(Icons.history),
                          text: 'جمعياتي السابقة',
                        ),
                      ],
                    ),
                    title: const Text('',
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            //fontFamily: "Montsterrat Classic",
                            color: Color.fromARGB(255, 255, 255, 255))),
                    backgroundColor: Color.fromARGB(255, 76, 175, 80)),
                body: TabBarView(
                  children: [
                    MyHomePage(),
                    JamiaHistory4(),
                  ],
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
                floatingActionButtonLocation: FloatingActionButtonLocation
                    .miniEndFloat, //miniCenterDocked

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
                              Navigator.pushNamed(context, '/budget');
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.account_balance_wallet,
                                ),
                                Text("الميزانية"),
                              ],
                            ),
                            minWidth: 40,
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/NewHome');
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.people,
                                  color: Colors.green,
                                ),
                                Text("جمعياتي"),
                              ],
                            ),
                            minWidth: 40,
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/ViewAndDeleteFriends');
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.man),
                                Text("اصدقائك"),
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
                                Text("الطلبات"),
                              ],
                            ),
                            minWidth: 40,
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ),
        ));
  }

  void checkUserStatus() {
    bool sent = false;
    final cron = Cron();
    //every day?
    cron.schedule(Schedule.parse('*/5 * * * * *'), () async {
      //print('Check user\'s status');
      final stauts = await FirebaseFirestore.instance
          .collection('users')
          .doc(signedInUser.email)
          .get();
      //print(stauts.get('status'));
      if (stauts.get('status') == 1 && loggedin) {
        loggedin = false;
        print('log out');
        await _auth.signOut();
        if (mounted) {
          print('mounted');
          Navigator.pushNamed(context, '/login');
          print('after');
        }
        //Navigator.pushNamed(context, '/login');
        if (!sent) {
          print('sent');
          await AwesomeNotifications().createNotification(
              content: NotificationContent(
            id: 2,
            channelKey: 'key1',
            title: 'تم إيقاف حسابك',
            body: 'بإمكانك التواصل معنا لمعرفة التفاصيل',
          ));
          sent = true;
        }
      }
    });
  }
}
