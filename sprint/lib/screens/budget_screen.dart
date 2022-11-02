import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _badgetsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          // check if the list is empty
          if (badgets.isEmpty) {
            return const Center(
              child: Text('No data'),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return ListTile(
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
              );
            }).toList(),
          );
        },
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

  factory Badget.fromMap(QueryDocumentSnapshot data) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Badget'),
      ),
      body: const AddBadgetForm(),
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
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Enter name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: 'Enter description',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter description';
              }
              return null;
            },
          ),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              hintText: 'Select category',
            ),
            items: _categories,
            onChanged: (value) {
              setState(() {
                _selectedCategoryI = value;
              });
            },
          ),
          TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            // only allow numbers
            keyboardType: TextInputType.number,
            controller: _percentageController,
            decoration: const InputDecoration(
              hintText: 'Enter percentage',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter percentage';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() &&
                  _selectedCategoryI != null) {
                if (int.parse(_percentageController.text) > 100) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Percentage cannot be greater than 100'),
                    ),
                  );
                } else {
                  // ccheck if category is exist in badgets collection
                  FirebaseFirestore.instance
                      .collection('budgets')
                      .where('category', isEqualTo: _selectedCategoryI)
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    if (querySnapshot.docs.isEmpty) {
                      // check if percentage is not greater than 100 from budgets collection
                      FirebaseFirestore.instance
                          .collection('budgets')
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
                                  'Total percentage cannot be greater than 100'),
                            ),
                          );
                        } else {
                          // add data to firestore
                          FirebaseFirestore.instance.collection('budgets').add({
                            'name': _nameController.text,
                            'description': _descriptionController.text,
                            'category': _selectedCategoryI,
                            'percentage': int.parse(_percentageController.text),
                            'user_id': FirebaseAuth.instance.currentUser!.uid,
                          });
                          //  Navigator.pop(context);
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Category already exist'),
                        ),
                      );
                    }
                  });

                  //   Navigator.pop(context);
                }
              }
            },
            child: const Text('Submit'),
          ),
        ],
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Badget'),
      ),
      body: EditBadgetForm(badget: badget),
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
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Enter name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: 'Enter description',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter description';
              }
              return null;
            },
          ),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              hintText: 'Select category',
            ),
            items: _categories,
            onChanged: (value) {
              setState(() {
                _selectedCategoryI = value;
              });
            },
          ),
          TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            // only allow numbers
            keyboardType: TextInputType.number,
            controller: _percentageController,
            decoration: const InputDecoration(
              hintText: 'Enter percentage',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter percentage';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() &&
                  _selectedCategoryI != null) {
                // check if percentage is not greater than 100 from budgets collection
                FirebaseFirestore.instance
                    .collection('budgets')
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  int totalPercentage = 0;
                  querySnapshot.docs.forEach((doc) {
                    totalPercentage += doc.get('percentage') as int;
                  });
                  if (totalPercentage + int.parse(_percentageController.text) >
                      100) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Total percentage cannot be greater than 100'),
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
                            'percentage': int.parse(_percentageController.text),
                          });
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Category already exist'),
                            ),
                          );
                        }
                      }
                    });
                  }
                });
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
