import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  // create list to obtain data from firestore collection badgets
  List<Badget> badgets = [];
  // create a variable to obtain data from firestore collection badgets
  // create a variable to obtain data from firestore collection badgets
  final badgetCollection = FirebaseFirestore.instance
      .collection('budgets')
      .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid);
  // create a variable to obtain data from firestore collection badgets
  final Stream<QuerySnapshot> _badgetsStream = FirebaseFirestore.instance
      .collection('budgets')
      .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  double salary = 0.0;
  @override
  void initState() {
    super.initState();
    // create a variable to obtain data from firestore collection badgets
    badgetCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          badgets.add(Badget.fromMap(doc));
        });
      });
    });
    // check if the user is logged in and not have any salary in the database then open dialog to add salary
    // if (FirebaseAuth.instance.currentUser != null) {
    //   FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(FirebaseAuth.instance.currentUser!.email)
    //       .get()
    //       .then((DocumentSnapshot documentSnapshot) {
    //     if (documentSnapshot.exists) {
    //       if (!(documentSnapshot.data() as Map<String, dynamic>)
    //           .containsKey('salary')) {
    //         showDialog(
    //             context: context,
    //             builder: (BuildContext context) {
    //               return AlertDialog(
    //                 title: Text('اضف راتبك'),
    //                 content: TextField(
    //                   keyboardType: TextInputType.number,
    //                   inputFormatters: <TextInputFormatter>[
    //                     FilteringTextInputFormatter.digitsOnly
    //                   ],
    //                   decoration: InputDecoration(hintText: 'راتبك'),
    //                   onChanged: (value) {
    //                     setState(() {
    //                       salary = double.parse(value);
    //                     });
    //                   },
    //                 ),
    //                 actions: [
    //                   TextButton(
    //                       onPressed: () {
    //                         Navigator.of(context).pop();
    //                       },
    //                       child: Text('الغاء')),
    //                   TextButton(
    //                       onPressed: () {
    //                         FirebaseFirestore.instance
    //                             .collection('users')
    //                             .doc(FirebaseAuth.instance.currentUser!.email)
    //                             .update({'salary': salary});
    //                         Navigator.of(context).pop();
    //                       },
    //                       child: Text('حفظ'))
    //                 ],
    //               );
    //             });
    //       }
    //     }
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الميزانية'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // navigate to badget screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddBadget(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            // get the salary from the database and add it to the salary variable inside card widget
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    // check if keys salary exist in the database
                    if ((snapshot.data!.data() as Map<String, dynamic>)
                        .containsKey('salary')) {
                      salary = (snapshot.data!.data()
                          as Map<String, dynamic>)['salary'];
                      // calculate the total of the badgets and subtract it from the salary using percentage
                      double total = 0.0;
                      for (var badget in badgets) {
                        total += badget.percentage;
                      }
                      double percentage = (total / 100) * salary;

                      return Column(children: [
                        Card(
                          child: ListTile(
                            title: Text('المبلغ'),
                            trailing: Text(snapshot.data!['salary'].toString()),
                            subtitle: Text('الكامل'),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            title: Text('المبلغ'),
                            subtitle: Text('المتبقي'),
                            trailing: Text(
                                '${(salary - percentage).toStringAsFixed(2)}'),
                          ),
                        )
                      ]);
                    } else {
                      // add buttom with card widget to add salary
                      return Card(
                        child: ListTile(
                          title: Text('الراتب'),
                          subtitle: Text('لا يوجد راتب'),
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('اضف راتبك'),
                                      content: TextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration:
                                            InputDecoration(hintText: 'راتبك'),
                                        onChanged: (value) {
                                          setState(() {
                                            salary = double.parse(value);
                                          });
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('الغاء')),
                                        TextButton(
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.email)
                                                  .update({'salary': salary});
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('حفظ'))
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ),
                      );
                    }
                  } else {
                    return const Text('loading');
                  }
                }),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _badgetsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('حدث خطأ');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // check if the list is empty
                  if (badgets.isEmpty) {
                    return const Center(
                      child: Text('لا يوجد بيانات'),
                    );
                  }
                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      final category = data['category'] as DocumentReference;
                      // retrun card with circle progress show the percentage of the budget and name with category, with two buttons to edit and delete
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              data['percentage'].toString() + '%',
                              style: const TextStyle(color: Colors.white),
                            ),
                            // color the circle with the percentage of the budget
                            backgroundColor: data['percentage'] < 50
                                ? Colors.green
                                : data['percentage'] < 80
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                          title: Text(data['name']),
                          subtitle: FutureBuilder<DocumentSnapshot<Object?>>(
                              future: category.get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data!['name'] ?? '');
                                }
                                return const Text('Loading');
                              }),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // navigate to badget screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditBadget(
                                        badget: Badget.fromMap(document),
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('budgets')
                                      .doc(document.id)
                                      .delete();
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                      /*   return ListTile(
                        title: Text(data['name']),
                        subtitle: Text(data['description']),
            
                        /// delete data from firestore
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // delete data from firestore
                            FirebaseFirestore.instance
                                .collection('budgets')
                                .doc(document.id)
                                .delete();
                          },
                        ),
                      ); */
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            child: Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/viewUserProfile');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                        ),
                        Text("الملف الشخصي"),
                      ],
                    ),
                    minWidth: 40,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/budget');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.green,
                        ),
                        Text("الميزانية"),
                      ],
                    ),
                    minWidth: 40,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/NewHome');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people),
                        Text("جمعياتي"),
                      ],
                    ),
                    minWidth: 40,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/ViewAndDeleteFriends');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.man,
                        ),
                        Text("اصدقائك"),
                      ],
                    ),
                    minWidth: 40,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/RequestPageFinal');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list_alt,
                        ),
                        Text("الطلبات"),
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

class Badget {
  String name;
  String description;
  DocumentReference category;
  int percentage;
  // id
  String id;
  Badget(
      {required this.name,
      required this.description,
      required this.category,
      required this.percentage,
      required this.id});

  factory Badget.fromMap(DocumentSnapshot data) {
    return Badget(
      name: data.get('name'),
      description: data.get('description'),
      category: data.get('category'),
      percentage: data.get('percentage'),
      id: data.id,
    );
  }
}

//  create form builder to add data to firestore collection badgets,check if precentage is not grater than 100&/ stateless
class AddBadget extends StatelessWidget {
  const AddBadget({super.key});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('اضافة ميزانية'),
        ),
        body: const AddBadgetForm(),
      ),
    );
  }
}

class AddBadgetForm extends StatefulWidget {
  const AddBadgetForm({super.key});
  @override
  _AddBadgetFormState createState() => _AddBadgetFormState();
}

class _AddBadgetFormState extends State<AddBadgetForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController();
  // get categories from firestore
  final Stream<QuerySnapshot> _categoriesStream =
      FirebaseFirestore.instance.collection('categories').snapshots();
  // create list of DropdownMenuItem
  List<DropdownMenuItem> _categories = [];
  DocumentReference? _selectedCategoryI;

  @override
  void initState() {
    _categoriesStream.listen((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _categories.add(DropdownMenuItem(
            child: Text(doc.get('name')),
            value: doc.reference,
          ));
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'اسم الميزانية',
                // rounded with border and filled with color
                border: OutlineInputBorder(),
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء ادخال اسم الميزانية';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'وصف الميزانية',
                // rounded with border and filled with color
                border: OutlineInputBorder(),
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء ادخال وصف الميزانية';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                hintText: 'التصنيف',
                // rounded with border and filled with color
                border: OutlineInputBorder(),
                fillColor: Colors.white,
              ),
              items: _categories,
              onChanged: (value) {
                setState(() {
                  _selectedCategoryI = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              // only allow numbers
              keyboardType: TextInputType.number,
              controller: _percentageController,
              decoration: const InputDecoration(
                hintText: 'النسبة المئوية',
                // rounded with border and filled with color
                border: OutlineInputBorder(),
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء ادخال النسبة المئوية';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    _selectedCategoryI != null) {
                  if (int.parse(_percentageController.text) > 100) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('النسبة المئوية لا يمكن ان تتعدى 100'),
                      ),
                    );
                  } else {
                    // ccheck if category is exist in badgets collection
                    FirebaseFirestore.instance
                        .collection('budgets')
                        .where('user_id',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .where('category', isEqualTo: _selectedCategoryI)
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      if (querySnapshot.docs.isEmpty) {
                        // check if percentage is not greater than 100 from budgets collection
                        FirebaseFirestore.instance
                            .collection('budgets')
                            .where('user_id',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          int totalPercentage = 0;
                          querySnapshot.docs.forEach((doc) {
                            totalPercentage += doc.get('percentage') as int;
                          });
                          if (totalPercentage +
                                  int.parse(_percentageController.text) >
                              100) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('النسبة المئوية لا يمكن ان تتعدى 100'),
                              ),
                            );
                          } else {
                            // add data to firestore
                            FirebaseFirestore.instance
                                .collection('budgets')
                                .add({
                              'name': _nameController.text,
                              'description': _descriptionController.text,
                              'category': _selectedCategoryI,
                              'percentage':
                                  int.parse(_percentageController.text),
                              'user_id': FirebaseAuth.instance.currentUser!.uid,
                            });
                            // show snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تمت الاضافة بنجاح'),
                              ),
                            );
                            //  Navigator.pop(context);
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('هذا التصنيف موجود بالفعل'),
                          ),
                        );
                      }
                    });

                    //   Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// edit form builder to edit data to firestore collection badgets,check if precentage is not grater than 100&/ stateless
class EditBadget extends StatelessWidget {
  const EditBadget({super.key, required this.badget});
  final Badget badget;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تعديل الميزانية'),
        ),
        body: EditBadgetForm(badget: badget),
      ),
    );
  }
}

class EditBadgetForm extends StatefulWidget {
  const EditBadgetForm({super.key, required this.badget});
  final Badget badget;
  @override
  _EditBadgetFormState createState() => _EditBadgetFormState();
}

class _EditBadgetFormState extends State<EditBadgetForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController();
  // get categories from firestore
  final Stream<QuerySnapshot> _categoriesStream =
      FirebaseFirestore.instance.collection('categories').snapshots();
  // create list of DropdownMenuItem
  List<DropdownMenuItem> _categories = [];
  DocumentReference? _selectedCategoryI;

  @override
  void initState() {
    _nameController.text = widget.badget.name;
    _descriptionController.text = widget.badget.description;
    _percentageController.text = widget.badget.percentage.toString();
    _categoriesStream.listen((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _categories.add(DropdownMenuItem(
            child: Text(doc.get('name')),
            value: doc.reference,
          ));
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'الاسم',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء ادخال الاسم';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'الوصف',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء ادخال الوصف';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                hintText: 'التصنيف',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
              ),
              items: _categories,
              onChanged: (value) {
                setState(() {
                  _selectedCategoryI = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              // only allow numbers
              keyboardType: TextInputType.number,
              controller: _percentageController,
              decoration: const InputDecoration(
                hintText: 'النسبة المئوية',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء ادخال النسبة المئوية';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    _selectedCategoryI != null) {
                  // check if percentage is not greater than 100 from budgets collection
                  FirebaseFirestore.instance
                      .collection('budgets')
                      .where('user_id',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    int totalPercentage = 0;
                    querySnapshot.docs.forEach((doc) {
                      totalPercentage += doc.get('percentage') as int;
                    });
                    if (totalPercentage +
                            int.parse(_percentageController.text) >
                        100) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'النسبة المئوية لا يمكن ان تتجاوز 100 بالمئة'),
                        ),
                      );
                    } else {
                      // check if other firestor doc has same category ignore the current doc
                      FirebaseFirestore.instance
                          .collection('budgets')
                          .where('category', isEqualTo: _selectedCategoryI)
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        if (querySnapshot.docs.isEmpty) {
                          // update data to firestore
                          FirebaseFirestore.instance
                              .collection('budgets')
                              .doc(widget.badget.id)
                              .update({
                            'name': _nameController.text,
                            'description': _descriptionController.text,
                            'category': _selectedCategoryI,
                            'percentage': int.parse(_percentageController.text),
                          });
                          Navigator.pop(context);
                        } else {
                          if (querySnapshot.docs.first.id == widget.badget.id) {
                            // update data to firestore
                            FirebaseFirestore.instance
                                .collection('budgets')
                                .doc(widget.badget.id)
                                .update({
                              'name': _nameController.text,
                              'description': _descriptionController.text,
                              'category': _selectedCategoryI,
                              'percentage':
                                  int.parse(_percentageController.text),
                            });
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('هذا التصنيف موجود بالفعل'),
                              ),
                            );
                          }
                        }
                      });
                    }
                  });
                }
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }
}
