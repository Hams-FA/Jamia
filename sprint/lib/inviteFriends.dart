import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sprint/data/models/user_model.dart';
import 'package:sprint/data/remote_data_source/firestore_helper.dart';
import 'package:sprint/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class inviteFriends extends StatefulWidget {
  const inviteFriends({super.key, required this.title});

  final String title;
  //static final invitedAlready = [];
  @override
  State<inviteFriends> createState() => _inviteFriendsState();
}

class _inviteFriendsState extends State<inviteFriends> {
  Map<String, bool?> checked = new Map();
  List<String> selectedEmails = List<String>.empty(growable: true); //
  //List list = await readInvited2();
  static var invitedAlready = [];

//here?
  void initState() {
    super.initState();
    readInvited211();
    print('1');
    readInvited211();
    //invitedAlready.add('tyry');
    //invitedAlready = readInvited211() as List; //here
    print(invitedAlready);
    print('hi');
    //print(r
    //veadInvited2());
  }

  CreateStats() {
    print('create');
  }

  @override
  Widget build(BuildContext context) {
    print('22');
    print(invitedAlready.length); //?
    return Scaffold(
        appBar: AppBar(
          title: Text("دعوة صديق إلى الجمعية"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              StreamBuilder<List<UserModel>>(
                  stream: FirestoreHelper.readFromUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Center(
                        child: Text("some error occured"),
                      );
                    }
                    if (snapshot.hasData) {
                      final userData = snapshot.data;
                      //List selectedIndexes = []; //
                      return Expanded(
                          child: ListView.builder(
                              itemCount: userData!.length,
                              itemBuilder: (context, index) {
                                final singleUser = userData[index];
                                //checked.addAll{"'${singleUser.userName}:false};

                                //List list = readInvited21(); //store data here!
                                //change this to contain?
                                //!list.contains()
                                if (true) {
                                  checked['${singleUser.Email}'] = false;
                                  return Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: StatefulBuilder(
                                        builder: (context, setState) =>
                                            (CheckboxListTile(
                                          //ListTile
                                          secondary: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                shape: BoxShape.circle),
                                          ),
                                          title: Text("${singleUser.Name}"),
                                          subtitle: Text(
                                              "${singleUser.Email}              التقييم:${singleUser.rate}"),
                                          activeColor: Colors.green,
                                          checkColor: Colors.white,
                                          value: checked[
                                              '${singleUser.Email}'], //isChecked, //checked['${singleUser.userName}'],
                                          onChanged: (val) {
                                            setState(() {
                                              checked['${singleUser.Email}'] =
                                                  val;
                                              if (checked[
                                                      '${singleUser.Email}'] ==
                                                  true) {
                                                selectedEmails
                                                    .add('${singleUser.Email}');
                                              } else if (checked[
                                                      '${singleUser.Email}'] ==
                                                  false) {
                                                selectedEmails.removeWhere(
                                                    (element) =>
                                                        element ==
                                                        '${singleUser.Email}');
                                              }
                                            });
                                          },
                                        )),
                                      )

                                      /*
                                    trailing: Checkbox(
                                      value: this.value,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          this.value = value;
                                        });
                                      },
                                    ),*/

                                      //1
                                      //Icon(Icons.add),
                                      //),
                                      );
                                }
                              }));
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
//something wrong here
/*
                      final users = snapshot.data;

                      if (users != null) {
                        //return Center(
                        //child: Text("almost"),
                        //);

                        for (var user in users) {
                          //return Center(
                          //child: Text(users.length.toString()),
                          //);

                          child:
                          FutureBuilder<UserModel?>(
                            future: readOneUser(user.userName),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text("something went wrong");
                              } else if (snapshot.hasData) {
                                final user = snapshot.data;
                                if (user == null) {
                                  return Center(
                                    child: Text("No user"),
                                  );
                                } else {
                                  return Center(
                                    child: Text("here?"),
                                  ); //buildUser(user)
                                }
                                /*
                          return user == null
                              ? Center(
                                  child: Text("No user"),
                                )
                              : buildUser(user);*/
                              } else {
                                return Center(
                                  child:
                                      CircularProgressIndicator(), //child: Text("no data"), //CircularProgressIndicator(),
                                );
                              }
                            },
                          );
                          //String username = user.userName;
                          //Future<UserModel?> u = readOneUser(user.userName);
                          //return buildUser(u);//user
                        }
                      } else {
                        return Center(child: Text("some error occured - 2"));
                      }
mine^^*/

              ElevatedButton(
                  onPressed: () {
                    selectedEmails.forEach((element) {
                      var jamiaId =
                          '1'; //change this to id coming from selected jamia
                      final docInviteFriends = FirebaseFirestore.instance
                          .collection('JamiaGroup')
                          .doc(jamiaId)
                          .collection('members')
                          .doc(element);

                      docInviteFriends.set({'status': 'pending'});

                      final updateRequestList = FirebaseFirestore.instance
                          .collection('requestList')
                          .doc(element);
                      updateRequestList.set({'jamiaID': jamiaId});
                    });
                  },
                  child: Text("دعوة")),
              //add if possible ${selectedUsersNames.length} :

              ///////// delete this
              ///
              /*
              FutureBuilder<UserModel?>(
                  future: readOneUser("Saba55"),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("something went wrong");
                    } else if (snapshot.hasData) {
                      final user = snapshot.data;
                      if (user == null) {
                        return Center(
                          child: Text("No user"),
                        );
                      } else {
                        return buildUser(user);
                      }
                      /*
                      return user == null
                          ? Center(
                              child: Text("No user"),
                            )
                          : buildUser(user);*/
                    } else {
                      return Center(
                        child:
                            CircularProgressIndicator(), //child: Text("no data"), //CircularProgressIndicator(),
                      );
                    }
                  })*/
            ],
          ),
        ));
  }
/*
  Future<UserModel?> readOneUser(String Email) async {
    final docOneUser =
        FirebaseFirestore.instance.collection('users').doc(Email);
    final snapshot = await docOneUser.get();
    if (snapshot.exists) {
      return UserModel.fromSnapshot(snapshot);
    }
  }
*/

  Widget buildUser(UserModel user) => ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
        ),
        title: Text("${user.Name}"), //
        subtitle: Text("${user.Email}"), //username
      );

  void readInvited211() async {
    List<dynamic> feature = await readInvited2();
    feature.forEach((element) {
      print(element);
      invitedAlready.add(element);
    });
  }
}

Widget getFriendsData(List<UserModel> users) {
  return new ListView();
}
/*
Future<List<String>> readInvited() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("JamiaGroup")
      .doc('1')
      .collection('members')
      .get(); //
  //return querySnapshot.docs;

  //List<dynamic> menus = querySnapshot.docs
  //  .map((e) => QuerySnapshot.fromJson(e.data() as Map<String, dynamic>))
  //.toList();
  String s = querySnapshot.toString();
  //print(s);
  return null;
}
*/

Future<List<dynamic>> readInvited2() async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection("JamiaGroup")
      .doc('1') //chenge this to jamia id
      .collection('members')
      .get();

  List<dynamic> res = List<dynamic>.empty(growable: true);
  ;

  //res = querySnapshot.keys;
  querySnapshot.docs.forEach((element) {
    //res.add(element.id); //data() - id
    print(element.id);
    //print(element['status']);
  });
  //print(res);
  print('readinvited that return feature');
  return res; //as List?
  //return querySnapshot.snapshots();//().map((event) => event.docs.map((e) => event.data()as Map<String,dynamic>.toList())
}





/*
List<String> readInvited21()  {
  var old = readInvited2();
  old.forEach((element)){

  }

    //List<Future<dynamic>>
    //_selectedItems = List<Future<dynamic>>();
    List<dynamic>
    listofimg = [];
    Future.forEach((element) {   element.then((value) =>
    listofimg.add(value));
    });
}
*/
