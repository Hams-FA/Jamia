import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/validations.dart';

class InquiryPage extends StatefulWidget {
  const InquiryPage({Key? key}) : super(key: key);
  @override
  State<InquiryPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  final _formKey = GlobalKey<FormState>();

  final subjectController = TextEditingController();
  //final emailController = TextEditingController();
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الاستفسارات'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              height: 550,
              width: 400,
              margin: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 20,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 5),
                        blurRadius: 10,
                        spreadRadius: 1,
                        color: Colors.grey[300]!)
                  ]),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('تفضل بطرح استفسارك هنا',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: subjectController,
                      decoration: const InputDecoration(hintText: 'الموضوع'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '*مطلوب تعبيئة خانة الموضوع';
                        }
                        return null;
                      },
                    ),
                    /*
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'Email'),
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Required*';
                    } else if (!EmailValidator.validate(email)) {
                      return 'Please enter a valid Email';
                    }
                    return null;
                  },
                ),*/
                    TextFormField(
                      controller: messageController,
                      decoration: const InputDecoration(hintText: 'الاستفسار'),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '*مطلوب تعبيئة خانة الاستفسار';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                        '*سوف يتم الرد عليك في اقرب وقت ممكن عبر الايميل المسجل به',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montsterrat Classic",
                            color: Color(0xFF545454))),
                    const SizedBox(
                      height: 45,
                      width: 110,
                    ),
                    SizedBox(
                      height: 45,
                      width: 110,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor:
                                ui.Color.fromARGB(255, 61, 139, 63),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40))),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String email = "Admin2022@gmail.com";
                            String subject = subjectController.text;
                            String body = messageController.text;

                            String? encodeQueryParameters(
                                Map<String, String> params) {
                              return params.entries
                                  .map((MapEntry<String, String> e) =>
                                      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                  .join('&');
                            }

                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: email,
                              query: encodeQueryParameters(<String, String>{
                                'subject': subject,
                                'body': body
                              }),
                            );
                            if (await canLaunch(emailLaunchUri.toString())) {
                              launchUrl(emailLaunchUri);
                            } else {
                              print("The action is not support NO Email App!");
                            }
                            //subjectController.clear();
                            //emailController.clear();
                            //messageController.clear();
                          }
                        },
                        child: const Text('ارسـال',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
