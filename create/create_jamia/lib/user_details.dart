import 'package:create_jamia/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget {
  const UserDetails(
      {Key? key,
      required this.name,
      required this.minMembers,
      required this.maxMembers,
      // required this.week,
      required this.amount,
      required this.startDate,
      required this.endDate})
      : super(key: key);
  final String name;
  final int minMembers;
  final int maxMembers;
  // final String week;
  final double amount;
  final String startDate;
  final String endDate;

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          title: Text('User Details'),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios_new))),
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
                child: Row(
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      ' Name',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                )),
            Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                color: Colors.grey.shade200,
                child: Row(
                  children: [
                    Text(
                      widget.minMembers.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      ' Minimum members',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                )),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              color: Colors.grey.shade200,
              child: Row(
                children: [
                  Text(
                    widget.maxMembers.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    ' Maximum members:',
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
            // Container(
            //   padding: EdgeInsets.all(10),
            //   margin: EdgeInsets.all(10),
            //   color: Colors.grey.shade200,
            //   child: Row(
            //     children: [
            //       Text(
            //         widget.week.toString(),
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //       SizedBox(
            //         width: 20,
            //       ),
            //       Text(
            //         ' Days',
            //         style: TextStyle(fontSize: 18),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              color: Colors.grey.shade200,
              child: Row(
                children: [
                  Text(
                    widget.amount.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    ' Total amount',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              color: Colors.grey.shade200,
              child: Row(
                children: [
                  Text(
                    widget.startDate.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    ' Start date',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              color: Colors.grey.shade200,
              child: Row(
                children: [
                  Text(
                    widget.endDate.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    ' End date',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 100,
                    child: ElevatedButton(
                        onPressed: () {
                          saveUserData(
                              name: widget.name,
                              minMembers: widget.minMembers,
                              maxMembers: widget.maxMembers,
                              // week: widget.week,
                              amount: widget.amount,
                              startDate: widget.startDate,
                              endDate: widget.endDate);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Data Saved successfully'),
                            duration: Duration(milliseconds: 3000),
                          ));
                          Future.delayed(
                              const Duration(
                                milliseconds: 3000,
                              ), (() {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()));
                          }));
                        },
                        child: Text('Confirm'))),
                Container(
                    width: 100,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Back'))),
              ],
            )
          ],
        ),
      ),
    ));
  }

  Future saveUserData(
      {required String name,
      required int minMembers,
      required int maxMembers,
      // required String week,
      required double amount,
      required String startDate,
      required String endDate}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();

    final json = {
      'name': name,
      'minMembers': minMembers,
      'maxMembers': maxMembers,
      // 'days': week,
      'amount': amount,
      'startDate': startDate,
      'endDate': endDate
    };

    await docUser.set(json);
  }
}
