import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dart:convert';
import 'dart:developer';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

class FirebaseUserDetails extends StatefulWidget {
  FirebaseUserDetails({Key? key, required this.data, required this.jamiaId})
      : super(key: key);
  final Map<String, dynamic> data;
  final String jamiaId;
  @override
  State<FirebaseUserDetails> createState() => _FirebaseUserDetailsState();
}

class _FirebaseUserDetailsState extends State<FirebaseUserDetails> {
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
        child: Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                  title: const Text(
                    'تفاصيل الجمعية',
                    style: TextStyle(
                        fontSize: 25,
                        color: Color(0xFF393737),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                  backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                  leading: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back))),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  color: Colors.grey.shade100,
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          color: Colors.grey.shade200,
                          child: Directionality(
                              textDirection: ui.TextDirection.rtl,
                              child: Row(
                                children: [
                                  const Text(
                                    'اسم الجمعية:  ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montsterrat Classic"),
                                  ),
                                  Text(
                                    widget.data['name'] ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF545454)),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ))),
                      Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          color: Colors.grey.shade200,
                          child: Directionality(
                              textDirection: ui.TextDirection.rtl,
                              child: Row(
                                children: [
                                  const Text(
                                    ' الحد الادنى من الاعضاء:  ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.data['minMembers']!.toString() ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF545454)),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ))),
                      Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          color: Colors.grey.shade200,
                          child: Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: Row(
                              children: [
                                const Text(
                                  ' الحد الاعلى من الاعضاء:  ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  widget.data['maxMembers']!.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF545454)),
                                ),
                                const SizedBox(
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
                      //         widget.data['days'].toString(),
                      //         style: TextStyle(fontWeight: FontWeight.bold),
                      //       ),
                      //       SizedBox(
                      //         width: 20,
                      //       ),
                      //       Text(
                      //         ' Days',
                      //         style: TextStyle(fontSize: 18),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          color: Colors.grey.shade200,
                          child: Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: Row(
                              children: [
                                const Text(
                                  ' السهم الشهري: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.data['amount']!.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF545454)),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          )),
                      Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          color: Colors.grey.shade200,
                          child: Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: Row(
                              children: [
                                const Text(
                                  ' تاريخ بدء الجمعية:  ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.data['startDate'].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF545454)),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          )),
                      Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          color: Colors.grey.shade200,
                          child: Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: Row(
                              children: [
                                const Text(
                                  ' عدد الأعضاء الحالي : ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.data['acceptedCount'].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF545454)),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          )),
                      ////////////afnan
                      FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('JamiaGroup')
                              .doc(widget.data['id'])
                              .collection('transaction')
                              .where('Email', isEqualTo: signedInUser.email)
                              .get(),
                          builder: ((context, snapshot) {
                            // if(!(DateTime.now().isBefore(DateTime.parse(widget.data['startDate'])))){
                            if (snapshot.hasData) {
                              final alltransactions = snapshot.data!.docs;
                              List<dynamic> timelocal =
                                  List<dynamic>.empty(growable: true);
                              alltransactions.forEach(
                                (element) {
                                  var timenow =
                                      DateTime.parse(element.get('time'));
                                  timelocal.add(timenow);
                                },
                              );
                              var max = DateTime.parse('1969-07-20 20:18:04Z');

                              if (timelocal.isNotEmpty) max = timelocal.first;
                              for (var i = 1; i < timelocal.length; i++) {
                                if (timelocal[i].isAfter(max))
                                  max = timelocal[i];
                              }
                              if ((max.month).compareTo(DateTime.now().month) ==
                                  0)
                                return Text(
                                  'لقد قمت بدفع جميعة هذا الشهر',
                                  style: TextStyle(
                                      color: Colors.green[800],
                                      fontWeight: FontWeight.w900,
                                      fontStyle: FontStyle.italic,
                                      fontFamily: 'Open Sans',
                                      fontSize: 24),
                                );
                              else {
                                return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.only(
                                          left: 130, right: 130),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Text('ادفع ',
                                        style: TextStyle(fontSize: 15)),
                                    onPressed: () async {
                                      await initPayment(
                                          amount:
                                              (widget.data['amount'] / 3.75) *
                                                  100,
                                          context: context,
                                          email: FirebaseAuth
                                              .instance.currentUser!.email
                                              .toString());
                                    });
                              }
                            } else {
                              return CircularProgressIndicator();
                            }
                            //   }else {
                            return Text(' لايمكنك الدفع قبل بدء الجمعية');

                            //  }
                          })),

                      ///////////////
                      // get members collection from firebase and show it in list view using stream builder and jamia id
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        //color: Colors.grey.shade200,
                        child: Directionality(
                          textDirection: ui.TextDirection.rtl,
                          child: Row(
                            children: [
                              const Text(
                                ' ترتيب أعضاء الجمعية',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        color: Colors.grey.shade200,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('JamiaGroup')
                              .doc(widget.data['id'])
                              .collection('members')
                              .where('status', isEqualTo: 'accepted')
                              .orderBy('turn')
                              // .orderBy('date')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              print(snapshot.data!.docs.length);
                              return ListView.builder(
                                  // disable scroll
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot data =
                                        snapshot.data!.docs[index];
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.all(10),
                                      color: Colors.grey.shade200,
                                      child: Directionality(
                                        textDirection: ui.TextDirection.rtl,
                                        child: ListTile(
                                            title: Text(data.id),
                                            //subtitle: Text(data['date']),
                                            // current in
                                            leading: Text(
                                              '${data['turn']}',
                                            )),
                                      ),
                                    );
                                  });
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  Future<bool> check() async {
    var max;

    await FirebaseFirestore.instance
        .collection('JamiaGroup')
        .doc(widget.data['id'])
        .collection('transaction')
        .where('Email', isEqualTo: signedInUser.email)
        .get()
        .then((value) {
      final alltransactions = value.docs;
      List<dynamic> timelocal = List<dynamic>.empty(growable: true);

      alltransactions.forEach((e) {
        var timenow = DateTime.parse(e.get('time'));
        timelocal.add(timenow);
      });
      max = timelocal.first;
      for (var i = 1; i < timelocal.length; i++) {
        if (timelocal[i].isAfter(max)) max = timelocal[i];
      }
    });
    if ((max.month).compareTo(DateTime.now().month) == 0)
      return true;
    else {
      return false;
    }
  }

  bool _check() {
    bool checkResult = check() as bool;
    return checkResult;
  }

  Future<void> initPayment(
      {required String email,
      required double amount,
      required BuildContext context}) async {
    try {
      // 1. Create a payment intent on the server
      final response = await http.post(
          Uri.parse(
              'https://us-central1-jamia-2bcc1.cloudfunctions.net/stripePaymentIntentRequest'),
          body: {
            'email': email,
            'amount': amount.toString(),
          });

      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      // 2. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: jsonResponse['paymentIntent'],
        merchantDisplayName: 'Jamias',
        customerId: jsonResponse['customer'],
        customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
        // testEnv: true,
        //merchantCountryCode: 'SG',
      ));
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تمت عملية الدفع بنجاح'),
        ),
      );
      final transDetail = FirebaseFirestore.instance
          .collection('JamiaGroup')
          .doc(widget.data['id'])
          .collection('transaction')
          .doc();

      transDetail.set(
          {'Email': signedInUser.email, 'time': DateTime.now().toString()});
      Navigator.pushNamed(context, '/home');
    } catch (errorr) {
      if (errorr is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occured ${errorr.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occured $errorr'),
          ),
        );
      }
    }
  }

  /////afnan
  Future<QuerySnapshot<Object?>> query() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection('JamiaGroup')
        .doc(widget.data['id'])
        .collection('transaction')
        .where('Email', isEqualTo: signedInUser.email)
        .get();
    return qs;
  }
}
