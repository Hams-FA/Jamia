import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class FirebaseUserDetails extends StatefulWidget {
  FirebaseUserDetails({Key? key, required this.data}) : super(key: key);
  final data;
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
                        ' السهم الشهري  ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.data['amount'].toString(),
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
          ],
        ),
      ),
    ));
  }
}
