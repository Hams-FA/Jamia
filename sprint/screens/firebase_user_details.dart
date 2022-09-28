import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class FirebaseUserDetails extends StatefulWidget {
  FirebaseUserDetails({Key? key, required this.data, required this.jamiaId})
      : super(key: key);
  final Map<String, dynamic> data;
  final String jamiaId;
  @override
  State<FirebaseUserDetails> createState() => _FirebaseUserDetailsState();
}

class _FirebaseUserDetailsState extends State<FirebaseUserDetails> {
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
          backgroundColor: const Color.fromARGB(255, 76, 175, 80),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back))),
      body: Container(
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
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          widget.data['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          widget.data['minMembers'].toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.data['maxMembers'].toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                        ' السهم الشهري  ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.data['amount'].toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.data['startDate'].toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                        ' تاريخ انتهاء الجمعية:  ',
                        style: TextStyle(fontSize: 18),
                      ),
                      const Text(
                        'لم يحدد حتى الان',
                        //widget.data['endDate'].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                )),
            // get members collection from firebase and show it in list view using stream builder and jamia id
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              color: Colors.grey.shade200,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .doc(widget.jamiaId)
                    .collection('members')
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data!.docs[index];
                          return Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            color: Colors.grey.shade200,
                            child: Directionality(
                              textDirection: ui.TextDirection.rtl,
                              child: ListTile(
                                title: Text(data['name']),
                                subtitle: Text(data['date']),
                                // current in
                                leading: Text('${index + 2}'),
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

