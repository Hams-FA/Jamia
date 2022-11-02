import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:sprint/screens/ViewFriendProfile.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class JamiaMembersDetails extends StatefulWidget {
  JamiaMembersDetails({Key? key, required this.data, required this.jamiaId})
      : super(key: key);
  final Map<String, dynamic> data;
  final String jamiaId;
  @override
  State<JamiaMembersDetails> createState() => _JamiaMembersDetailsState();
}

class _JamiaMembersDetailsState extends State<JamiaMembersDetails> {
  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  late String? imageURL;

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
                    '            تفاصيل الجمعية',
                    style: TextStyle(
                        fontSize: 25,
                        color: ui.Color.fromARGB(255, 255, 255, 255),
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
                        margin: const EdgeInsets.all(10),
                        color: Colors.grey.shade200,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('JamiaGroup')
                              .doc(widget.data['id'])
                              .collection('members')
                              .where('status', isEqualTo: 'accepted')
                              .orderBy('turn')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  // disable scroll
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot data =
                                        snapshot.data!.docs[index];
                                    return Container(
                                      margin: const EdgeInsets.all(10),
                                      color: Colors.grey.shade200,
                                      child: Directionality(
                                        textDirection: ui.TextDirection.rtl,
                                        child: Row(
                                          children: [
                                            FutureBuilder<String>(
                                              future: getProfileImage(data),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                        ConnectionState.done ||
                                                    snapshot.data == null ||
                                                    snapshot.hasError) {
                                                  if (snapshot.data == null ||
                                                      snapshot.hasError) {
                                                    imageURL = null;
                                                  } else {
                                                    imageURL = snapshot.data;
                                                  }
                                                  return Row(
                                                    children: [
                                                      Text('${data?['turn']}-'),
                                                      const SizedBox(width: 16),
                                                      /*ProfilePicture(
                                                        name: '',
                                                        radius: 20,
                                                        fontsize: 20,
                                                        img: imageURL,
                                                      ),*/
                                                      const SizedBox(width: 16),
                                                      RichText(
                                                        text: TextSpan(
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.blue,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: data.id ==
                                                                        signedInUser
                                                                            .email
                                                                    ? 'انت'
                                                                    : '${data['name']}',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                ),
                                                                recognizer:
                                                                    TapGestureRecognizer()
                                                                      ..onTap =
                                                                          () {
                                                                        Navigator.of(context).push(MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                ViewFriendProfile(email: data.id)));
                                                                      }),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 16),
                                                    ],
                                                  );
                                                }

                                                return const Center(
                                                  child: Text('يتم التحميل'),
                                                );
                                              },
                                            ),
                                            ratingWidget(data),
                                          ],
                                        ),
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

  FutureBuilder<QuerySnapshot<Object?>> ratingWidget(
      DocumentSnapshot<Object?> data) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('Ratings').get(),
      // .doc(
      //     '${widget.jamiaId}-${_auth.currentUser?.email}-${data.id}')
      // .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          print("true");
          var rating = 0.0;
          snapshot.data?.docs.forEach((element) {
            if (element.id ==
                '${widget.jamiaId}-${_auth.currentUser?.email}-${data.id}') {
              var data = element.data() as Map<String, dynamic>;
              rating = data['rating'];
            }
          });
          if (data.id != signedInUser.email) {
            return RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 24,
              itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) async {
                // check if user already rated this user
                var isRated = false;
                snapshot.data?.docs.forEach((element) {
                  if (element.id ==
                      '${widget.jamiaId}-${_auth.currentUser?.email}-${data.id}') {
                    isRated = true;
                  }
                });
                if (isRated) {
                  // update rating
                  /* await FirebaseFirestore.instance
                      .collection('Ratings')
                      .doc(
                          '${widget.jamiaId}-${_auth.currentUser?.email}-${data.id}')
                      .update({'rating': rating}); */
                  // show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم التقييم'),
                    ),
                  );
                } else {
                  // add rating
                  // confirm rating dialog
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('تأكيد التقييم'),
                          content: const Text('هل تريد تقييم هذا العضو؟'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('لا')),
                            TextButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('Ratings')
                                      .doc(
                                          '${widget.jamiaId}-${_auth.currentUser?.email}-${data.id}')
                                      .set({
                                    'jamiaId': widget.jamiaId,
                                    'from': signedInUser.email,
                                    'to': data.id,
                                    'rating': rating
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: const Text('نعم')),
                          ],
                        );
                      });
                  /*  await FirebaseFirestore.instance
                      .collection('Ratings')
                      .doc(
                          '${widget.jamiaId}-${_auth.currentUser?.email}-${data.id}')
                      .set({
                    'jamiaId': widget.jamiaId,
                    'from': _auth.currentUser?.email,
                    'to': data.id,
                    'rating': rating
                  }); */
                }
                /* await FirebaseFirestore.instance
                    .collection('Ratings')
                    .doc(
                        '${widget.jamiaId}-${_auth.currentUser?.email}-${data.id}')
                    .set({
                  'jamia_id': widget.jamiaId,
                  'rated_user': data.id,
                  'rating_user': _auth.currentUser?.email,
                  'rating': rating
                });*/
              },
            );
          }
        } else {
          print("false");
        }

        return const Center(
          child: Text(' '),
        );
      },
    );
  }

  Future<String> getProfileImage(DocumentSnapshot<Object?> data) {
    // catch the error if the user has no profile image

    return FirebaseStorage.instance
        .ref()
        .child('usersProfileImages/${data.id}')
        .getDownloadURL()
        .then((value) => value)
        .catchError((error) => null);
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
        print(errorr);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occured ${errorr.error.localizedMessage}'),
          ),
        );
      } else {
        print(errorr);
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

// ListTile(
//   title:
//       Text(data['name']),
//   //subtitle: Text(data['date']),
//   // current in
//   leading: Text(
//     '${data['turn']}',
//   ),
//   onTap: () {
//     print(
//         '${data['name']} is clicked');
//   },
// ),
