import 'package:flutter/services.dart';
import 'package:sprint/screens/user_details.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'dart:ui' as ui;

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int minMembers = 2;
  int maxMembers = 12;
  double amount = 0.0;
  // final moduleList = ['Weekly', 'Monthly'];
  // String dropdownValue = 'Weekly';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 14));

  String name = '';

  @override
  Widget build(BuildContext context) {
    // DateTime? startDate = DateTime.now();
    // DateTime? endDate =
    //     DateTime(startDate.year, startDate.month, startDate.day + 14);
    // DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    //       value: item,
    //       child: Text(item,
    //           style: TextStyle(
    //             color: Colors.black,
    //             fontSize: 12,
    //             fontWeight: FontWeight.w600,
    //           )),
    //     );

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          title: const Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Text(
                'إنـشـاء جـمـعـيـة',
                style: TextStyle(
                    fontSize: 25,
                    color: Color(0xFF393737),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              )),
          backgroundColor: Color.fromARGB(255, 76, 175, 80),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back))),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: formKey,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'إنـشـاء جـمـعـيـة',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF393737),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'اسم الجمعية',
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: TextFormField(
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
                            //labelText: " اسم المجموعة ",

                            hintText: "ادخل اسم الجمعية ",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: Row(
                              children: [
                                Text('اختر الاعضاء'),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
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
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
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
                        SizedBox(
                          height: 20,
                        ),
                        // Container(
                        //   padding: EdgeInsets.symmetric(horizontal: 10),
                        //   width: MediaQuery.of(context).size.width,
                        //   color: Colors.grey.shade300,
                        //   child: DropdownButton<String>(
                        //       isExpanded: true,
                        //       dropdownColor: Colors.grey.shade200,
                        //       iconSize: 30,
                        //       // focusColor: Colors.white,
                        //       icon: Icon(
                        //         Icons.arrow_drop_down,
                        //         color: Colors.grey,
                        //       ),
                        //       underline: SizedBox(),
                        //       items: moduleList.map(buildMenuItem).toList(),
                        //       value: dropdownValue,
                        //       onChanged: (String? newValue) {
                        //         setState(() {
                        //           dropdownValue = newValue!;
                        //         });
                        //       }),
                        // ),
                        //SizedBox(
                        //height: 10,
                        //),
                        Text('الرجاء إدخال المبلغ'),
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
                              onChanged: (val) {
                                setState(() {
                                  amount =
                                      val.length < 1 ? 0 : double.parse(val);
                                });
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade300,
                                filled: true,
                                hintText: "ادخل المبلغ ",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            )),
                        SizedBox(
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
                              style: TextStyle(
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
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 76, 175, 80),
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
                              child: Text('أختر تاريخ البدء')),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text("ارسـال"),
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
                        SizedBox(
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
    ));
  }

  void validation(
    int minMembers,
    int MaxMembers,
    // String week,
    double amount,
    DateTime startDate,
    DateTime endDate,
  ) {
    if (formKey.currentState!.validate()) {
      var startYear = startDate.year;
      var startMonth = startDate.month;
      var startDay = startDate.day;
      String formatedStartDate = '${startDay}-${startMonth}-${startYear}';
      String formatedEndDate = '${startDay}-${startMonth}-${startYear}';

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserDetails(
                    name: name,
                    minMembers: minMembers,
                    maxMembers: maxMembers,
                    // week: week,
                    amount: amount,
                    startDate: formatedStartDate,
                    endDate: formatedEndDate,
                  )));
    }
  }
}
