import 'package:flutter/material.dart';

class LoginScreen extends statefulWidget {

  _LoginScreenState CreateState() => _LoginScreenState();
  
}

class LoginScreenState extends State<LoginScreen> {
  Widget build(BuildContext context) {
    return scaffold(body : Stack(children : <Widget>[
    Container(
    height : double.infinity
    width : double.infinity
    decoration : BoxDecoration(
      gradient : LinearGradient(begin : Alignment.topCenter , end : Alignment.bottomCenter , 
      colors [
        color() , color() , color() , color() 
      ], 
      stops : [0.1 , 0.4 , 0.7 , 0.9] ,

      
      ), //linear
    ), //box
    ), //container
    container(height : double.infinity , child : SingleChildScrollView(
      physics : AlwaysScrollableScrollPhysics() , ))
    ],//widget
    ),//stack
    ); //scff
  }
}