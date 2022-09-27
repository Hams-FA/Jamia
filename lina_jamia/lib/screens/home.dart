import 'package:flutter/material.dart';

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
                      widget.data['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      ' Name',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )),
            Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                color: Colors.grey.shade200,
                child: Row(
                  children: [
                    Text(
                      widget.data['minMembers'].toString(),
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
                    widget.data['maxMembers'].toString(),
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
              child: Row(
                children: [
                  Text(
                    widget.data['amount'].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    ' Total amount',
                    style: TextStyle(fontSize: 18),
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
                    widget.data['startDate'].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    ' Start date',
                    style: TextStyle(fontSize: 18),
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
                    widget.data['endDate'].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    ' End Date',
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
