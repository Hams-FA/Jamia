import 'package:client_project/user_details.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int members = 0;
  double amount = 0.0;
  final moduleList = ['Weekly', 'Monthly'];
  String dropdownValue = 'Weekly';
  @override
  Widget build(BuildContext context) {
    String date = DateTime.now().toString();

    DateTime now = new DateTime.now();
    DateTime timeNow = new DateTime(now.year, now.month, now.day);
    List time = [now, timeNow.toString()];

    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
          value: item,
          child: Text(item,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              )),
        );
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          title: Text('User Details'),
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
                      'User Details',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                        TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            setState(() {
                              members = val.length < 1 ? 0 : int.parse(val);
                            });
                          },
                          validator: (value) {
                            if (value == "") {
                              return "Please fill the members field";
                            } else if (members > 8) {
                              return 'Members can not be more than 8';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade300,
                              filled: true,
                              hintText: "Enter total number of members",
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey.shade300,
                          child: DropdownButton<String>(
                              isExpanded: true,
                              dropdownColor: Colors.grey.shade200,
                              iconSize: 30,
                              // focusColor: Colors.white,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                              underline: SizedBox(),
                              items: moduleList.map(buildMenuItem).toList(),
                              value: dropdownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              }),
                        ),
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
                        Container(
                          child: DateTimePicker(
                            type: DateTimePickerType.dateTimeSeparate,
                            dateMask: 'd MMM, yyyy',
                            initialValue: DateTime.now().toString(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            icon: Icon(Icons.event),
                            dateLabelText: 'Date',
                            timeLabelText: "Hour",
                            onChanged: (val) {
                              setState(() {
                                date = val;

                                time = date.split(" ");
                              });
                            },
                            validator: (val) {
                              return null;
                            },
                            onSaved: (val) => print(val),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text("Send"),
                            onPressed: () async {
                              validation(members, dropdownValue, amount, time);
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

  void validation(int members, String week, double amount, List time) {
    if (formKey.currentState!.validate()) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserDetails(
                  members: members,
                  week: week,
                  amount: amount,
                  time: time[0].toString())));
    }
  }
}
