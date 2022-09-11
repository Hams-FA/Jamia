import 'package:client_project/form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Jamia Group'),
        ),
        body: Container(
            padding: EdgeInsets.only(bottom: 40),
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Invite Friends'),
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FormPage()));
          },
          tooltip: 'Increment',
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
}
