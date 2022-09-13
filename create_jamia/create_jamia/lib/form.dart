import 'package:create_jamia/user_details.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

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

  String name = '';

  @override
  Widget build(BuildContext context) {
    DateTime? startDate = DateTime.now();
    DateTime? endDate =
        DateTime(startDate!.year, startDate!.month, startDate!.day + 14);
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
          title: Text('Create Jamia'),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios_new))),
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
                      'Create Jamia',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      onChanged: (value) {
                        name = value;
                      },
                      validator: (value) {
                        if (value == '') {
                          return 'Please enter your group name';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade300,
                        filled: true,
                        hintText: "Enter your Group Name",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text('Choose Member'),
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
                                    return "Please fill the members field";
                                  } else if (minMembers < 2) {
                                    return 'min 2 members';
                                  } else if (minMembers > 12) {
                                    return 'max 12 members';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade300,
                                    filled: true,
                                    hintText: "Min",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.grey)),
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
                                    return "Please fill the members field";
                                  } else if (maxMembers < 3) {
                                    return 'min 3 members';
                                  } else if (maxMembers > 12) {
                                    return 'max 12 members';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade300,
                                    filled: true,
                                    hintText: "Max",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                          ],
                        ),
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
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == "") {
                              return "Please fill the total amount";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              amount = val.length < 1 ? 0 : double.parse(val);
                            });
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade300,
                            filled: true,
                            hintText: "Enter Amount",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Start Date : ${startDate!.day}-${startDate!.month}-${startDate!.year}',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'End Date : ${endDate!.day}-${endDate!.month}-${endDate!.year}',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              onPressed: () async {
                                startDate = await showDatePicker(
                                    context: context,
                                    initialDate: startDate!,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));

                                setState(() {
                                  DateTime? startDate = DateTime.now();

                                  endDate = DateTime(startDate!.year,
                                      startDate!.month, startDate!.day + 14);
                                });
                              },
                              child: Text('Select Date')),
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text("Send"),
                            onPressed: () async {
                              validation(
                                  minMembers,
                                  maxMembers,
                                  // dropdownValue,
                                  amount,
                                  startDate!,
                                  endDate!);
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
      String formatedEndDate = '${startDay + 14}-${startMonth}-${startYear}';

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
