import 'dart:convert';

import 'package:create_jamia/firebase_user_details.dart';
import 'package:create_jamia/form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    fetchUserfromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Jamia Group'),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: fetchUserfromFirebase(),
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
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      alignment: Alignment.topLeft,
                                      color: Colors.grey.shade300,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Group name : ${data['name']}',
                                                style: TextStyle(fontSize: 17),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'Total group members: ${data['maxMembers'].toString()}',
                                                style: TextStyle(fontSize: 17),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FirebaseUserDetails(
                                                                data: data)));
                                              },
                                              child: Icon(Icons.visibility))
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              });
                        }
                        return Container(
                          child: Text('No data found'),
                        );
                      }))),
              Container(
                  padding: EdgeInsets.only(bottom: 40),
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Invite Friends'),
                  )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FormPage()));
          },
          mini: true,
          child: const Icon(Icons.add),
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
                    onPressed: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person),
                        Text("Profile"),
                      ],
                    ),
                    minWidth: 40,
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.man),
                        Text("Friend list"),
                      ],
                    ),
                    minWidth: 40,
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.price_change),
                        Text("Budget"),
                      ],
                    ),
                    minWidth: 40,
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_month),
                        Text("Calendar"),
                      ],
                    ),
                    minWidth: 40,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  fetchUserfromFirebase() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }
}
