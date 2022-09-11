import 'package:flutter/material.dart';
import 'package:sprint/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


class RequestList extends StatefulWidget {
  const RequestList({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<RequestList> createState() => _requestListState();
}

class _requestListState extends State<RequestList> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
     return  Scaffold (
      appBar : AppBar(title : Text("Request List") ,),
      body : Center(
        child : Table(
          border : TableBorder.all() ,
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
                      'Jamia ID :1234567 , Number of Members : 5 , Start Date : 10/09/2022 , End Date : 10/02/2023 , Period : Monthly , Amount of Money : 1000SR',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                    //color: Colors.green,
                    ),
                TableCell(
                  //verticalAlignment: TableCellVerticalAlignment.top,
                  child: Container(
                    child:  ElevatedButton(   
                
            style: ButtonStyle(backgroundColor:MaterialStatePropertyAll<Color>(Colors.green),),
            onPressed: () {},
            child: const Text('Accept'), ) ,

                    height: 32,
                    width: 32,
                    //color: Colors.red,
                  ),
                ),
                Container(
                    height: 64,
                    child:  ElevatedButton(   
                
            style: ButtonStyle(backgroundColor:MaterialStatePropertyAll<Color>(Colors.red),),
            onPressed: () {},
            child: const Text('Decline'), ) ,
                    ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Container(
                    height: 32,
                    child: Text(
                      '935792',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                    //color: Colors.green,
                    ),
                TableCell(
                  //verticalAlignment: TableCellVerticalAlignment.top,
                  child: Container(
                    child:   ElevatedButton(   
                
            style: ButtonStyle(backgroundColor:MaterialStatePropertyAll<Color>(Colors.green),),
            onPressed: () {},
            child: const Text('Accept'), ) ,
                    height: 32,
                    width: 32,
                    //color: Colors.red,
                  ),
                ),
                Container(
                    height: 64,
                    //color: Colors.blue,
                    child:
                         ElevatedButton(   
                
            style: ButtonStyle(backgroundColor:MaterialStatePropertyAll<Color>(Colors.red),),
            onPressed: () {},
            child: const Text('Decline'), ) ,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



