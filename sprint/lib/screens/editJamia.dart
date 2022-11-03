import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditJamia extends StatefulWidget {
  const EditJamia(
      {Key? key,
      required this.jamiaId,
      required this.name,
      required this.minMembers,
      required this.maxMembers,
      required this.amount,
      required this.startDate,
      required this.endDate})
      : super(key: key);
  final String jamiaId;
  final String name;
  final int minMembers;
  final int maxMembers;
  final int amount;
  final DateTime startDate;
  final DateTime endDate;

  @override
  State<EditJamia> createState() => _EditJamiaState();
}

class _EditJamiaState extends State<EditJamia> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String jamiaId = '';
  int minMembers = 2;
  int maxMembers = 12;
  int amount = 0;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 14));
  String name = '';
  var nameText = TextEditingController();
  var minMembersText = TextEditingController();
  var maxMembersText = TextEditingController();
  var amountText = TextEditingController();

  @override
  void initState() {
    super.initState();
    jamiaId = widget.jamiaId;
    name = widget.name;
    nameText.text = widget.name;
    minMembers = widget.minMembers;
    minMembersText.text = widget.minMembers.toString();
    maxMembers = widget.maxMembers;
    maxMembersText.text = widget.maxMembers.toString();
    amount = widget.amount;
    amountText.text = widget.amount.toString();
    print(jamiaId);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
              '           تعديل الجمعية',
              style: TextStyle(
                  fontSize: 25,
                  color: ui.Color.fromARGB(255, 255, 254, 254),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            backgroundColor: const Color.fromARGB(255, 76, 175, 80),
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back))),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'اسم الجمعية',
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: TextFormField(
                          controller: nameText,
                          onChanged: (value) {
                            name = value;
                          },
                          validator: (value) {
                            if (value == '') {
                              return 'الرجاء ادخال اسم الجمعية';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade300,
                            filled: true,
                            hintText: name,
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: Row(
                              children: [
                                const Text('اختر الاعضاء'),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: minMembersText,
                                    onChanged: (val) {
                                      setState(() {
                                        minMembers =
                                            val.length < 1 ? 0 : int.parse(val);
                                      });
                                    },
                                    validator: (value) {
                                      if (value == "") {
                                        return "الرجاء ادخال عدد الاعضاء صحيحا";
                                      } else if (minMembers < 2) {
                                        return 'اقل عدد هو 2 من الاعضاء';
                                      } else if (maxMembers <= minMembers) {
                                        return ' العدد الأقصى للأعضاء أكبر من الحد الأدنى';
                                      } else if (minMembers > 12) {
                                        return 'اكبر عدد هو 12 من الاعضاء';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey.shade300,
                                        filled: true,
                                        hintText: "الادنى",
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey)),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: maxMembersText,
                                    onChanged: (val) {
                                      setState(() {
                                        maxMembers =
                                            val.length < 1 ? 0 : int.parse(val);
                                      });
                                    },
                                    validator: (value) {
                                      if (value == "") {
                                        return "الرجاء ادخال عدد الاعضاء صحيحا";
                                      } else if (maxMembers < 3) {
                                        return 'اقل عدد هو 3 من الاعضاء';
                                      } else if (maxMembers > 12) {
                                        return 'اكبر عدد هو 12 من الاعضاء';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey.shade300,
                                        filled: true,
                                        hintText: "الأقصى",
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey)),
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text('الرجاء إدخال المبلغ'),
                        Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value == "") {
                                  return "الرجاء ادخال المبلغ";
                                } else {
                                  return null;
                                }
                              },
                              controller: amountText,
                              onChanged: (val) {
                                setState(() {
                                  amount = val.length < 1 ? 0 : int.parse(val);
                                });
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade300,
                                filled: true,
                                hintText: "ادخل المبلغ ",
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        // Directionality(
                        //     textDirection: ui.TextDirection.rtl,
                        //     child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Directionality(
                            //     textDirection: ui.TextDirection.rtl,
                            Text(
                              'تاريخ البدء : ${startDate.day}-${startDate.month}-${startDate.year}',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            // const Directionality(
                            //     textDirection: ui.TextDirection.rtl,
                            //     child:
                            /*
                            Text(
                              'تاريخ البدء : ${endDate.day}-${endDate.month}-${endDate.year}',
                              // 'تاريخ الانتهاء : سوف يتم تحديدة لاحقا',
                              //${endDate.day}-${endDate.month}-${endDate.year}',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            */
                          ],
                          // )
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(255, 76, 175, 80),
                              ),
                              onPressed: () async {
                                DateTime? newDate = await showDatePicker(
                                    context: context,
                                    initialDate: startDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100));
                                if (newDate == null) return;

                                setState(() {
                                  startDate = newDate;
                                  endDate = startDate.add(Duration(days: 14));
                                  // endDate = DateTime(startDate.year,
                                  //     startDate.month, startDate.day + 14);
                                });
                              },
                              child: const Text('أختر تاريخ البدء')),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: const Text("تعديل"),
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 76, 175, 80),
                            ),
                            onPressed: () async {
                              validation(
                                  minMembers,
                                  maxMembers,
                                  // dropdownValue,
                                  amount,
                                  startDate,
                                  endDate);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void validation(
    int minMembers,
    int MaxMembers,
    // String week,
    int amount,
    DateTime startDate,
    DateTime endDate,
  ) {
    if (formKey.currentState!.validate()) {
      var startYear = startDate.year;
      var startMonth = startDate.month;
      var startDay = startDate.day;
      String formatedStartDate = '${startDay}-${startMonth}-${startYear}';
      String formatedEndDate = '${startDay}-${startMonth}-${startYear}';
      print('edit it in firebase');
      EasyLoading.show(status: 'تحميل ...');
      print(widget.jamiaId);
      print(widget.name);
      print(jamiaId);
      FirebaseFirestore.instance
          .collection('JamiaGroup')
          .doc(widget.jamiaId)
          .update({
        'name': name,
        'minMembers': minMembers,
        //.toString(),
        'maxMembers': maxMembers,
        //.toString(),
        'amount': amount.round(),
        //.toString(),
        'startDate': startDate,
        //.toString(),
        'endDate': endDate, //.toString(),
      }).onError((error, stackTrace) => () {
                EasyLoading.dismiss();
                EasyLoading.showError('حاول مرة اخرى');
              });
      if (mounted) {
        EasyLoading.showSuccess('تم التعديل بنجاح');
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }
}
