import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sprint/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sprint/screens/registration_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sprint/screens/form.dart';
import 'package:sprint/screens/home.dart';
import 'package:sprint/screens/login_screen.dart';
import 'package:sprint/screens/forgot_password';
import 'package:sprint/screens/profile_screen.dart';
import 'package:sprint/screens/inviteFriends.dart';
import 'package:sprint/screens/SearchFriends.dart';
import 'package:sprint/screens/ViewAndDeleteFriends.dart';
import 'RequestPageFinal.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cron/cron.dart';

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

//import 'package:sprint/screens/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51LlFPXHZFaMy2scT7EbXYBvQfQUCGj6FvxnI1lrW2xwPhmLowqzkCHeJ8hQ0SzgPn20OdCwGEFkXTP5Y0cM8j3w000NzK0A7VH";
  Stripe.instance.applySettings();

  final cron = Cron();
  // 30 8 27 1,5,9 *         //in mounth 1 5 9 day 27 at 8:30
  //'*/5 * * * 9 *'
  cron.schedule(Schedule.parse('5 * * 9 *'), () async {
    print('notification');

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 2,
            channelKey: 'key1',
            title: 'تفكر تسوي جمعية؟',
            body: 'تطبيقنا يساعدك تنشئ جمعيتك الخاصة بشكل منظم ومرتب'));
  });
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'key1',
        channelName: 'Proto Coders Point',
        channelDescription: "Notification example",
        defaultColor: Colors.green,
        ledColor: Colors.white,
        playSound: true,
        enableLights: true,
        enableVibration: true)
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => const LoginScreen(),
        '/RequestPageFinal': (BuildContext context) => const RequestPageFinal(),
        '/registration': (BuildContext context) => const RegistrationScreen(),
        '/forgotPassword': (BuildContext context) => const ForgotPassword(),
        '/home': (BuildContext context) => const MyHomePage(),
        '/profile': (BuildContext context) => const ProfileScreen(),
        '/inviteFriends': (BuildContext context) => const inviteFriends(),
        '/SearchFriends': (BuildContext context) => const SearchFriends(),
        '/ViewAndDeleteFriends': (BuildContext context) =>
            const ViewAndDeleteFriends(),
      },
      home: //const PaymentDemo(),//const LoginScreen(),
          const LoginScreen(), //const MyHomePage(title: 'Flutter Demo Home Page'),
      //RegistrationScreen()
      builder: EasyLoading.init(),
      /*
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.*/
    );
  }
}
class PaymentDemo extends StatelessWidget {
  const PaymentDemo({Key? key}) : super(key: key);
  Future<void> initPayment(
      {required String email,
      required double amount,
      required BuildContext context}) async {
    try {
      // 1. Create a payment intent on the server
      final response = await http.post(
          Uri.parse(
              'https://us-central1-jamia-2bcc1.cloudfunctions.net/stripePaymentIntentRequest'),
          body: {
            'email': email,
            'amount': amount.toString(),
          });

      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      // 2. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: jsonResponse['paymentIntent'],
        merchantDisplayName: 'Grocery Flutter course',
        customerId: jsonResponse['customer'],
        customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
       // testEnv: true,
        //merchantCountryCode: 'SG',
      ));
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment is successful'),
        ),
      );
    } catch (errorr) {
      if (errorr is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occured ${errorr.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occured $errorr'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        child: const Text('Pay 20\$'),
        onPressed: () async {
          await initPayment(
              amount: 50.0, context: context, email: 'email@test.com');
        },
      )),
    );
  }
}
