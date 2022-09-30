import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:ui' as ui;

import 'dart:convert';
import 'dart:developer';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

class FirebaseUserDetails extends StatefulWidget {
  FirebaseUserDetails({Key? key, required this.data}) : super(key: key);
  final data;
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
          backgroundColor: Color.fromARGB(255, 76, 175, 80),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back))),
      body: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        color: Colors.grey.shade100,
        child: Column(
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
                          'اسم الجمعية:  ',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          widget.data['name'],
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
                          widget.data['minMembers'].toString(),
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
                        widget.data['maxMembers'].toString(),
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
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                color: Colors.grey.shade200,
                child: Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Row(
                    children: [
                      Text(
                        ' السهم الشهري: ',
                        style: TextStyle(fontSize: 18 ),
                      ),
                      Text(
                        widget.data['amount'].toString() +
                            " ريال " +
                            "(\$ " +
                            (widget.data['amount'] / 3.75).toString() +
                            " )",
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
                        widget.data['startDate'].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                )),
            Column(
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
                            ' تاريخ انتهاء الجمعية:  ',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'لم يحدد حتى الان',
                            //widget.data['endDate'].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    
                    padding: const EdgeInsets.only(left: 130,right: 130),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    
                  ),
                  child: const Text(
                    'ادفع ', style:TextStyle(fontSize: 15)
                  ),
                  onPressed: () async {
                    
                    var today = DateTime.now().day.toString();
                    var yearNow = DateTime.now().year.toString();
                    var yearstart2 =
                        widget.data['startDate'].toString().length - 4;
                    var yearstart = widget.data['startDate']
                        .toString()
                        .substring(yearstart2);
                    //var parsedDate = DateTime.parse('1974-03-20 00:00:00.000');
                    
                    var start =
                        widget.data['startDate'].toString().substring(0, 2);
                    if (start.compareTo(today) == 0 &&
                        yearNow.compareTo(yearstart) == 0) {
                      await initPayment(
                          amount: (widget.data['amount'] / 3.75) * 100,
                          context: context,
                          email: FirebaseAuth.instance.currentUser!.email
                              .toString());
                    } else {
                      null;
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
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
        content: Text('Payment is successful'),
      ),
    );
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
