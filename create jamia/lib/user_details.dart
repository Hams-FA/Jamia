import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget {
  const UserDetails(
      {Key? key,
      required this.members,
      required this.week,
      required this.amount,
      required this.time})
      : super(key: key);
  final int members;
  final String week;
  final double amount;
  final String time;

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
                    'Total number of members:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.members.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
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
                    'Days :',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.week.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
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
                    'Total amount :',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.amount.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              color: Colors.grey.shade200,
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Time',
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.time.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
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
                          Navigator.pop(context);
                        },
                        child: Text('Back'))),
                Container(
                    width: 100,
                    child: ElevatedButton(
                        onPressed: () {
                          saveUserData(
                              members: widget.members,
                              week: widget.week,
                              amount: widget.amount,
                              time: widget.time);
                        },
                        child: Text('Confirm')))
              ],
            )
          ],
        ),
      ),
    ));
  }

  Future saveUserData(
      {required int members,
      required String week,
      required double amount,
      required String time}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();

    final json = {
      'members': members,
      'days': week,
      'amount': amount,
      'date': time
    };

    await docUser.set(json);
  }
}
