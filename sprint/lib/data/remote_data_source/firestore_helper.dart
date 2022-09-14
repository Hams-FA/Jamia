import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

//change this to id
class FirestoreHelper {
  static Stream<List<UserModel>> readFromUsers() {
    final userFriends = FirebaseFirestore.instance
        .collection("users")
        .doc('wafa@gmail.com/') //change this to id
        .collection('friends'); //.doc("a@gmail.com");
    return userFriends.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }
/*

static Stream<List<UserModel>> readFromFrindsList() {
    final userCollection = FirebaseFirestore.instance.collection("FriendsList");
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }



  static Future create(UserModel user) async {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final uid = userCollection.doc().id;
    final docRef = userCollection.doc(uid);

    final newUser = UserModel(
      id: uid,
        username: user.username,
        age: user.age
    ).toJson();

    try {
      await docRef.set(newUser);
    } catch (e) {
      print("some error occured $e");
    }
  }
*/

  static Future updateJamiaGroup(UserModel user) async {
    /*
    final userCollection = FirebaseFirestore.instance.collection("users");

    final docRef = userCollection.doc(user.id);

    final newUser = UserModel(
        id: user.id,
        username: user.username,
        age: user.age
    ).toJson();

    try {
      await docRef.update(newUser);
    } catch (e) {
      print("some error occured $e");
    }
    */
  }
/*
  static Future delete(UserModel user) async {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final docRef = userCollection.doc(user.id).delete();

  }
*/

}
