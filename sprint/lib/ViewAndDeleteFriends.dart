// ignore_for_file: prefer_const_constructors
import 'dart:html';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    home: ViewAndDeleteFriends(),
  ));
}

class ViewAndDeleteFriends extends StatefulWidget {
  const ViewAndDeleteFriends({Key? key}) : super(key: key);

  @override
  State<ViewAndDeleteFriends> createState() => _ViewAndDeleteFriendsState();
}

class _ViewAndDeleteFriendsState extends State<ViewAndDeleteFriends> {

  
/*
    final CollectionReference profileList =
      FirebaseFirestore.instance.collection('FriendsList');

  _onAddIconPressed(String){
  Future<void> createUserData(String userName) async {
    return await profileList.doc(userName)
        .set({'Name': data[Name], 'gender': gender, 'score': score});
  } 
} */
    String name = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: SizedBox(
              
           child: Directionality(
              textDirection: ui.TextDirection.rtl,
              child: TextFormField(
                keyboardType: TextInputType.name,
                textAlign: TextAlign.right,

                // The validator receives the text that the user has entered.
                onChanged: (value) {
                  name = value;
                },
                decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'ابحث عن صديق باستخدام الاسم او الايميل',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
              ),),
        )),
        body:
         StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc('fay@hotmail.com')
              .collection('friends')
              .snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;
                          showAlertDialog(BuildContext context) {
                                      // set up the buttons
                                      Widget cancelButton = TextButton(
                                        child: Text("تراجع"),
                                        onPressed: () {   Navigator.pop(context); },
                                      );
                                      Widget continueButton = TextButton(
                                        child: Text("حذف"),
                                        onPressed: () {
                                           var email = data['Email'];

                                          /* final User =
                                        FirebaseAuth.instance.currentUser!.uid; */
                                          final docUser = FirebaseFirestore
                                              .instance
                                              .collection('users')
                                              .doc('fay@hotmail.com')
                                              .collection('friends')
                                              .doc(email);

                                          docUser.delete();
                                          Navigator.pop(context);
                                        },
                                      );
                                      // set up the AlertDialog
                                      AlertDialog alert = AlertDialog(
                                        title: Text("إزالة صديق"),
                                        content: Text(
                                               data['lname'] +"هل أنت متأكد من رغبتك في إزالة الصديق "  ),
                                        actions: [
                                          cancelButton,
                                          continueButton,
                                        ],
                                      );
                                      // show the dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );
                                    }

                      if (name.isEmpty) {
                        return ListTile(
                          title: Text(
                            data['fname'] + data['lname'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            data['Email'] +
                                "                            rate:  " +
                                data['rate'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                                fontWeight: FontWeight.normal),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(data['photo']),
                          ),
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                 IconButton(
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    size: 20.0,
                                    color: Color.fromARGB(255, 169, 37, 4),
                                  ),
                                  onPressed: () {
                                     showAlertDialog(context);


                                  },
                                ),
                              ]),
                        );
                      }
                      if (data['fname']
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        return ListTile(
                          title: Text(
                            data['fname'] + data['lname'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            data['Email'] +
                                "                            rate:  " +
                                data['rate'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                                fontWeight: FontWeight.normal),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(data['photo']),
                          ),
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    size: 20.0,
                                    color: Color.fromARGB(255, 169, 37, 4),
                                  ),
                                  onPressed: () {
                                     showAlertDialog(context);


                                    //_onAddIconPressed(data['userName']);
                                  },
                                ),
                              ]),
                        );
                      }
                      return Container();
                    });
          },
        ));
  }


}
