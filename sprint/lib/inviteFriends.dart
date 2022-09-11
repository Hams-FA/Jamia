import 'package:flutter/material.dart';
import 'package:sprint/data/models/user_model.dart';
import 'package:sprint/data/remote_data_source/firestore_helper.dart';
import 'package:sprint/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class inviteFriends extends StatefulWidget {
  const inviteFriends({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<inviteFriends> createState() => _inviteFriendsState();
}

class _inviteFriendsState extends State<inviteFriends> {
  //int _counter = 0;

/*
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      //_counter++;
    });
  }
*/

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
                      return Center(
                        child: Text("some error occured"),
                      );
                    }
                    if (snapshot.hasData) {
                      final userData = snapshot.data; //
                      return Expanded(
                          child: ListView.builder(
                              itemCount: userData!.length,
                              itemBuilder: (context, index) {
                                final singleUser = userData[index];
                                var list = <String>[]; //
                                list.add(singleUser.userName); //
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    leading: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle),
                                    ),
                                    title: Text("${singleUser.Name}"),
                                    subtitle: Text(
                                        "${singleUser.userName}              التقييم:${singleUser.rate}"),
                                    trailing: Icon(Icons.add),
                                  ),
                                );
                              }));
                    }

                    return Center(
                      child: Text("not yet"), //CircularProgressIndicator()
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

              ElevatedButton(onPressed: () {}, child: Text("دعوة")),

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
        )
        /*     
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Table(
          border: TableBorder.all(),
          columnWidths: const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(64),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                Container(
                    height: 32,
                    child: Text(
                      '@afnanss',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                    //color: Colors.green,
                    ),
                TableCell(
                  //verticalAlignment: TableCellVerticalAlignment.top,
                  child: Container(
                    child: Text(
                      'Afnan Sahem ---',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    height: 32,
                    width: 32,
                    //color: Colors.red,
                  ),
                ),
                Container(
                    height: 64,
                    //color: Colors.blue,
                    child:
                        Checkbox(value: false, onChanged: null) //need changing
                    ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Container(
                    height: 32,
                    child: Text(
                      '@jood',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                    //color: Colors.green,
                    ),
                TableCell(
                  //verticalAlignment: TableCellVerticalAlignment.top,
                  child: Container(
                    child: Text(
                      'Jood Ahmed',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    height: 32,
                    width: 32,
                    //color: Colors.red,
                  ),
                ),
                Container(
                    height: 64,
                    //color: Colors.blue,
                    child:
                        Checkbox(value: false, onChanged: null) //need changing
                    ),
              ],
            ),
          ],
        ),

        /*Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),*/
      ),
      /*
      floatingActionButton: FloatingActionButton(
        //onPressed: _incrementCounter,
        //tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), */// This trailing comma makes auto-formatting nicer for build methods.
    */
        );
  }

  Future<UserModel?> readOneUser(String userName) async {
    final docOneUser =
        FirebaseFirestore.instance.collection('users').doc(userName);
    final snapshot = await docOneUser.get();
    if (snapshot.exists) {
      return UserModel.fromSnapshot(snapshot);
    }
  }

//UserModer
  Widget buildUser(UserModel user) => ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
        ),
        title: Text("${user.Name}"), //
        subtitle: Text("${user.userName}"), //username
      );
}

Widget getFriendsData(List<UserModel> users) {
  return new ListView();
}
